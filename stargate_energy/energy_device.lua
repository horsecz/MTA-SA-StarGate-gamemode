-- device.lua: Energy device element module; shared

------------ ENERGY DEVICE NOTES
--------
--- Devices can act as generator, battery, transformator or any combination of these (depends on produced, consumed or generated neergy) 
--> generator:  produces energy, max_production < 0 or > 0
---             produced energy stored into "buffer" (max_storage)
--> battery:    no energy production (max_production is 0)
---             receiving energy and storing into storage (max_storage)

-- stats:
--> production      current device production (also exists: min/max)
--> storage         current device storage status (also exists: max)
--> transfer_rate   how much energy can device transfer (store/send) in 1 second
--> consumption     device consumption
--> test_result     were energy requirements (consumption) for this device met last second? 
---                 aka: storage > consumption last second
---                 also: energy_device_getEnergyRequirementsTestResult(...)
--------
------------

--- Create energy device element
--- REQUIRED PARAMETERS:
--> element to which element will be this energy element attachedTo
--> max_storage     int     amount of energy device can store
--          0                   no energy can be stored
--          less than  0        infinite amount of energy can be stored  
--          other               energy storage value
--> max_production  int     amount of energy device can product/create in one second (in best conditions)
--          0                   no production
--          less than 0         infinite production in one second
--          other               production/s
--> transfer_rate   int     amount of energy device can transfer in second
--          note: same as max_storage or max_production
--          warning: value 0 will make device unusable (for transfers)
--          note: cannot be below zero (infinite) 
--          note: if this value is greater than max_storage, it will be set (capped) to max_storage

--- OPTIONAL PARAMETERS:
--> sourceElement       reference     element to be attached with energy device element
--          default: nil
--          warning: energy device element will be unaccessable if not attached to another element 
--> consumption_rate    int           amount of energy device will consume (from its buffer/storage) per second
--          same as transfer rate
--          default: 0
--          note: cannot be below zero (infinite)
--          note: if this value is greater than max_storage, it will be set to max_storage
--> min_production      int            minimum amount of energy device can produce in one second
--          default: 0; values same as max_production
--          if min_production > max_production, value is set to match max_production
--> name                string          name of the device
--          default: nil

--- RETURNS:
--> Reference; Energy device element
function energy_device_create(max_storage, max_production, transfer_rate, sourceElement, consumption_rate, min_production, name)
    local energyElement = createElement("energy", 0)
    local min_prod = min_produciton
    local cons_rate = consumption_rate
    local nam = name
    if not min_production or min_produciton == nil or min_produciton == false then
        min_prod = max_production -- currently all devices produce max_production
    elseif min_production > max_production then -- min_produciton cannot exceed max_production
        min_prod = max_production
    end
    if not consumption_rate or consumption_rate == nil or consumption_rate == false then
        cons_rate = 0
    end
    if not name or name == nil or name == false then
        nam = nil
    end

    if transfer_rate > max_storage then
        transfer_rate = max_storage
    elseif transfer_rate == 0 then
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(sourceElement).."') transfers energy at zero speed.", 2)
    elseif transfer_rate < 0 then
        transfer_rate = max_storage
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(sourceElement).."') was set to transfer energy at infinite speed (corrected to max_storage).", 2)
    end

    if cons_rate < 0 then
        cons_rate = max_storage
        outputDebugString("[ENERGY] New energy device (for element '"..getElementID(sourceElement).."') was set to consume energy at infinite speed (corrected to max_storage).", 2)
    elseif cons_rate > max_storage then
        cons_rate = max_storage
    end

    energy_device_setName(energyElement, nam)
    energy_device_setMinProduction(energyElement, min_prod)
    energy_device_setMaxProduction(energyElement, max_production)
    energy_device_setMaxStorage(energyElement, max_storage)
    energy_device_setProduction(energyElement, min_prod)
    energy_device_setStorage(energyElement, 0)
    energy_device_setTransferRate(energyElement, transfer_rate)
    energy_device_setConsumption(energyElement, cons_rate)
    if max_production > 0 then
        energy_device_startProductionTimer(energyElement)
    end
    if cons_rate > 0 then
        energy_device_startConsumptionTimer(energyElement)
    end
    if sourceElement then
        energy_device_attachToElement(sourceElement, energyElement)
    end
    return energyElement
end

-- Attaches energy device element to another element
-- REQUIRED PARAMETERS:
--> element         reference       element attach to
--> energyElement   reference       energy device element
function energy_device_attachToElement(element, energyElement)
    setElementData(element, "energy", energyElement)
end

-- Starts producing energy every second in energy device
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element
-- Note: currently all devices will constantly produce max_production
function energy_device_startProductionTimer(energyDevice)
    local p_timer = setTimer(function(energyDevice)
        local max_production = energy_device_getMaxProduction(energyDevice)
        local r = energy_produce(energyDevice, max_production)
        setElementData(energyDevice, "timer_production_result", r)
    end, 1000, 0, energyDevice)
    setElementData(energyDevice, "timer_production", p_timer)
end

-- Energy device will stop producing energy every second
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element
function energy_device_stopProductionTimer(energyDevice)
    killTimer(energy_device_getProductionTimer(energyDevice))
end

-- Energy device will start to consume energy from its storage
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element 
function energy_device_startConsumptionTimer(energyDevice)
    local c_timer = setTimer(function(energyDevice)
        local consumption = energy_device_getConsumption(energyDevice)
        local r = energy_consume(energyDevice, consumption)
        setElementData(energyDevice, "timer_consumption_result", r)

        local er_test = r - consumption
        if r < 0 then
            er_test = 0
        end
        setElementData(energyDevice, "timer_consumption_er_test", er_test)
    end, 1000, 0, energyDevice)
    setElementData(energyDevice, "timer_consumption", c_timer)
end

-- Stop consuming energy from energy device's own storage
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element 
function energy_device_stopConsumptionTimer(energyDevice)
    killTimer(energy_device_getConsumptionTimer(energyDevice))
end

---
--- INTERNAL
---

-- Adds energy transfer timer element to array of transfer timers in energy device 
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element 
--> timer           reference       timer element
function energy_device_addTransferTimer(energyDevice, timer)
    local timers = energy_device_getTransferTimers(energyDevice)
    if timers == nil or timers == false then
        timers = {}
    end
    timers = array_push(timers, timer)
    setElementData(energyDevice, "array_timers", timers)
end

-- Remove energy transfer timer from timers array in energy device
-- REQUIRED PARAMETERS:
--> energyDevice    reference       energy device element 
--> timer           reference       timer element
function energy_device_removeTransferTimer(energyDevice, timer)
    local timers = energy_device_getTransferTimers(energyDevice)
    if timers == nil or timers == false then
        timers = {}
    end
    timers = array_remove(timers, timer)
    setElementData(energyDevice, "array_timers", timers)
end