-- energy_s.lua: Main module for energy script

---
--- ENERGY
---


--- "use" stored energy from buffer in one second
--- REQUIRED PARAMETERS:
--> energyDeviceElement     element of energy device
--> energy                  energy to be consumed
--                          note: cannot be infinite (value < 0)
--- RETURNS:
--> total consumed energy
function energy_consume(energyDeviceElement, energy)
    local storage = energy_device_getStorage(energyDeviceElement)
    local energy_consumed = energy
    if storage < 0 then
        return energy_consumed
    elseif energy < 0 then
        return 0    -- no infinite energy consumption
    elseif storage >= energy then
        energy_device_setStorage(energyDeviceElement, storage - energy)
    else
        energy_device_setStorage(energyDeviceElement, 0)
        energy_consumed = storage
    end

    return energy_consumed
end

--- produce some energy in one second
--- REQUIRED PARAMETERS:
--> energyDeviceElement     element of energy device
--> energy                  amount of energy for this device to produce

--- RETURNS:
--> produced energy in total
--          >0  some energy was produced
--          0   no energy produced
--          <0  infinite energy produced
function energy_produce(energyDeviceElement, energy)
    local min_production = energy_device_getMinProduction(energyDeviceElement)
    local max_production = energy_device_getMaxProduction(energyDeviceElement)
    local result_energy = energy

    if min_production < 0 or max_production < 0 then -- produce infinite
        result_energy = -1
    elseif energy < min_production then -- produce none
        result_energy = 0
    elseif energy > max_production then -- produce maximum
        result_energy = max_production
    end

    energy_device_setProduction(energyDeviceElement, result_energy)
    energy_store(energyDeviceElement, result_energy) -- stores produced energy into buffer (if any)
    return result_energy
end

--- store energy into device in one second
--- REQUIRED PARAMETERS:
--> energyDeviceElement     element of energy device
--> energy                  amount of energy to store

--- RETURNS:
--> amount of energy stored into device
function energy_store(energyDeviceElement, energy)
    local result_energy = energy
    local storage = energy_device_getStorage(energyDeviceElement)
    local max_storage = energy_device_getMaxStorage(energyDeviceElement)

    if max_storage == 0 then
        result_energy = 0
    elseif max_storage < 0 then
        result_energy = -1
    elseif storage + energy <= max_storage then
        energy_device_transferToStorage(energyDeviceElement, result_energy)
    else
        result_energy = max_storage - storage
        energy_device_setStorage(energyDeviceElement, max_storage)
    end

    return result_energy
end

--- transfers energy between two devices in one second
--- RETURNS:
--> amount of energy sent by sender device
--> amount of energy that receiver device received (stored into its buffer/storage)
function energy_transfer(deviceSender, deviceReceiver, energy)
    local result_energy = energy
    local stored_energy = energy
    local storage = energy_device_getStorage(deviceSender)

    if energy < 0 then
        result_energy = -1
        stored_energy = energy_store(deviceReceiver, result_energy)
    elseif storage >= energy then
        energy_device_setStorage(deviceSender, storage - energy)
        stored_energy = energy_store(deviceReceiver, energy)
    else
        energy_device_setStorage(deviceSender, 0)
        stored_energy = energy_store(deviceReceiver, storage)
        result_energy = storage
    end

    return result_energy, stored_energy
end

--- initiate and process energy transfer between two devices
--- note: used will be the slower rate  
function energy_beginTransfer(deviceSender, deviceReceiver, totalEnergy)
    local transfer_s = energy_device_getTransferRate(deviceSender)
    local transfer_r = energy_device_getTransferRate(deviceReceiver)
    local transfer_max = transfer_s
    if transfer_s > transfer_r then
        transfer_max = transfer_r
    end
    local totalReps = math.ceil(totalEnergy / transfer_max)

    local tT = setTimer(function(deviceSender, deviceReceiver, transfer_max)
        local r = energy_transfer(deviceSender, deviceReceiver, transfer_max)
        setElementData(deviceSender, "timer_transfer_result", r)
    end, 1000, totalReps, deviceSender, deviceReceiver, transfer_max)

    energy_device_addTransferTimer(deviceSender, tT)
    energy_device_addTransferTimer(deviceReceiver, tT)
end