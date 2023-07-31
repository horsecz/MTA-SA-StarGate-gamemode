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
    -- no energy consumption/requirements => automatically true
    if energy_device_getEnergyRequirementsTestResult(energyDevice) == false or energy_device_getEnergyRequirementsTestResult(energyDevice) == nil then
        return true
    end

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