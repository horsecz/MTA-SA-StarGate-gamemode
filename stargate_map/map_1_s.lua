-- 1_s.lua: Script for planet 1 map (Earth); server-side

function onMapStart()
    initSGC()
end
addEventHandler("onResourceStart", resourceRoot, onMapStart)

function initSGC()
    -- create external energy device as DHD in SGC is base type and generates 0 energy
    local energy_device_object = createObject(1337, -44.8, 1908.5, 2218.3)
    setElementAlpha(energy_device_object, 0)
    setElementCollisionsEnabled(energy_device_object, false)
    local energy_device = energy_device_create(1000000, 300000, 1000000, energy_device_object, 0, 300000, "sgc_energy_generator")
    local Earth_SGs = stargate_getPlanetStargates("PLANET_1") -- Earth planet
    if Earth_SGs == false or Earth_SGs == nil or array_size(Earth_SGs) < 1 then
        outputDebugString("[MAP_1] Error setting energy device for SGC Stargate. No stargates found!", 1)
        return false
    end
    local SGC_Stargate = Earth_SGs[1]
    local sgc_gate_energy = getElementData(SGC_Stargate, "energy")
    local eTT = setTimer(energy_transfer, 1000, 0, energy_device, sgc_gate_energy, 290000)
    setElementData(energy_device_object, "energy_transfer_timer", eTT)
end