-- device_s.lua: Energy device element module

--- create energy device element - battery or generator
--- devices can act as generator or battery storage
--> generator:  produces energy, max_production < 0 or > 0
---             produced energy stored into small "buffer" (max_storage)
--> battery:    no energy production (max_production is 0)
---             receiving energy and storing into storage (max_storage)

--- REQUIRED PARAMETERS:
--> element to which element will be this energy element attachedTo
--> max_storage     amount of energy device can store
--          nil, false or 0     no energy can be stored
--          less than  0        infinite amount of energy can be stored  
--          other               energy storage value
--> max_production  amount of energy device can product/create in one second (in best conditions)
--          nil, false or 0     no production
--          less than 0         infinite production in one second
--          other               production/s
--> transfer_rate   amount of energy device can transfer in second
--          same as max_storage or max_production
--          warning: value 0 will make device unusable
--          note: cannot be below zero (infinite) 
--          note: if this value is greater than max_storage, it will be set to max_storage

--- OPTIONAL PARAMETERS:
--> sourceElement       element to be attached with energy device element
--          default: nil
--          warning: energy device element will be unaccessable if not attached to another element 
--> consumption_rate    amount of energy device will consume (from its buffer/storage) per second
--          same as transfer rate
--          default: 0
--          note: cannot be below zero (infinite)
--          note: if this value is greater than max_storage, it will be set to max_storage
--> min_production      minimum amount of energy device can produce in one second
--          default: 0; values same as max_production
--          if min_production > max_production, value is set to match max_production
--> name    name of the device
--          default: nil
--- RETURNS:
--> Energy device element
function energy_device_create(max_storage, max_production, transfer_rate, sourceElement, consumption_rate, min_production, name)
    local energyElement = createElement("energy")
    if not min_production then
        min_production = max_production -- currently all devices produce max_production
    elseif min_production > max_production then -- min_produciton cannot exceed max_production
        min_produciton = max_production
    end
    if not consumption_rate then
        consumption_rate = 0
    end
    if not name then
        name = nil
    end

    if transfer_rate > max_storage then
        transfer_rate = max_storage
    elseif transfer_rate == 0 then
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(element)"') transfers energy at zero speed.", 2)
    elseif transfer_rate < 0 then
        transfer_rate = max_storage
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(element)"') was set to transfer energy at infinite speed (corrected to max_storage).", 2)
    end

    if consumption_rate < 0 then
        consumption_rate = max_storage
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(element)"') was set to consume energy at infinite speed (corrected to max_storage).", 2)
    elseif consumption_rate > max_storage then
        consumption_rate = max_storage
    end

    energy_device_setName(energyElement, name)
    energy_device_setMinProduction(energyElement, min_production)
    energy_device_setMaxProduction(energyElement, max_production)
    energy_device_setMaxStorage(energyElement, max_storage)
    energy_device_setProduction(energyElement, min_produciton)
    energy_device_setStorage(energyElement, 0)
    energy_device_setProductionBuffer(energyElement, 0)
    energy_device_setTransferRate(energyElement, transfer_rate)
    energy_device_setConsumption(energyElement, consumption_rate)
    if not max_production == 0 then
        energy_device_startProductionTimer(energyElement)
    end
    if not consumption_rate == 0 then
        energy_device_startConsumptionTimer(energyElement)
    end
    if not sourceElement == nil then
        energy_device_attachToElement(sourceElement, energyElement)
    end
    return energyElement
end

function energy_device_attachToElement(element, energyElement)
    setElementData(element, "energy", energyElement)
end

---
--- TIMERS
---

-- currently all devices will constantly produce max_production
function energy_device_startProductionTimer(energyDevice)
    local p_timer = setTimer(function(energyDevice)
        local max_production = energy_device_getMaxProduction(energyDevice)
        local r = energy_produce(energyDevice, max_production)
        setElementData(energyDevice, "timer_production_result", r)
    end, 1000, 0, energyDevice)
    setElementData(energyDevice, "timer_production", p_timer)
end

function energy_device_stopProductionTimer(energyDevice)
    killTimer(energy_device_getProductionTimer(energyDevice))
end

-- device will consume energy from its storage
function energy_device_startConsumptionTimer(energyDevice)
    local c_timer = setTimer(function(energyDevice)
        local consumption = energy_device_getConsumption(energyDevice)
        local r = energy_consume(energyDevice)
        setElementData(energyDevice, "timer_consumption_result", r)

        local er_test = consumption - r
        if r < 0 then
            er_test = 0
        end
        setElementData(energyDevice, "timer_consumption_er_test", er_test)
    end, 1000, 0, energyDevice)
    setElementData(energyDevice, "timer_consumption", c_timer)
end

function energy_device_stopConsumptionTimer(energyDevice)
    killTimer(energy_device_getConsumptionTimer(energyDevice))
end

function energy_device_addTransferTimer(energyDevice, timer)
    local timers = energy_device_getTransferTimers(energyDevice)
    timer = array_push(timers, timer)
    setElementData(energyDevice, "array_timers", timers)
end

function energy_device_removeTransferTimer(energyDevice, timer)
    local timers = energy_device_getTransferTimers(energyDevice)
    timer = array_remove(timers, timer)
    setElementData(energyDevice, "array_timers", timers)
end


---
--- GETTERS/SETTERS
---

function energy_device_getTransferTimers(energyDevice)
    return getElementData(energyDevice, "array_timers")
end

function energy_device_isTransferringEnergy(energyDevice)
    local t = energy_device_getTransferTimers(energyDevice)
    if t [1] == nil then
        return false
    else
        return true
    end
end


function energy_device_getProductionTimer(energyDevice)
    return getElementData(energyDevice, "timer_production")
end

-- energy produced in last second
function energy_device_getProductionResult(energyDevice)
    return getElementData(energyDevice, "timer_production_result")
end

function energy_device_getConsumptionTimer(energyDevice)
    return getElementData(energyDevice, "timer_consumption")
end

-- energy consumed last second
function energy_device_getConsumptionResult(energyDevice)
    return getElementData(energyDevice, "timer_consumption_result")
end

-- checks last second energy balance
function energy_device_getEnergyRequirementsTestResult(energyDevice)
    return getElementData(energyDevice, "timer_consumption_er_test")
end

-- checks if energy requirements for device were met
function energy_device_energyRequirementsMet(energyDevice)
    if energy_device_getEnergyRequirementsTestResult(energyDevice) >= 0 then
        return true
    else
        return false
    end
end


function energy_device_getMaxStorage(energyDevice)
    return getElementData(energyDevice, "max_storage")
end

function energy_device_getMaxProduction(energyDevice)
    return getElementData(energyDevice, "max_production")
end

function energy_device_getMinProduction(energyDevice)
    return getElementData(energyDevice, "min_production")
end

function energy_device_getName(energyDevice)
    return getElementData(energyDevice, "name")
end


function energy_device_setMaxStorage(energyDevice, v)
    return setElementData(energyDevice, "max_storage", v)
end

function energy_device_setMaxProduction(energyDevice, v)
    return setElementData(energyDevice, "max_production", v)
end

function energy_device_setMinProduction(energyDevice, v)
    return setElementData(energyDevice, "min_production", v)
end

function energy_device_setName(energyDevice, v)
    return setElementData(energyDevice, "name", v)
end

function energy_device_setStorage(energyDevice, v)
    return setElementData(energyDevice, "storage", v)
end

function energy_device_setProduction(energyDevice, v)
    return setElementData(energyDevice, "production", v)
end

function energy_device_getStorage(energyDevice)
    return getElementData(energyDevice, "storage")
end

function energy_device_getProduction(energyDevice)
    return getElementData(energyDevice, "production")
end

function energy_device_getTransferRate(energyDevice)
    return getElementData(energyDevice, "transfer_rate")
end

function energy_device_setTransferRate(energyDevice, v)
    return setElementData(energyDevice, "transfer_rate", v)
end

function energy_device_getConsumption(energyDevice)
    return getElementData(energyDevice, "consumption")
end

function energy_device_setConsumption(energyDevice, v)
    return setElementData(energyDevice, "consumption", v)
end