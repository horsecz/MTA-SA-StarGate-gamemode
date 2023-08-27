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
    local SGC_Stargate = getElementByID("SG_MW_5") -- not good to harcode it (this way)...
    local sgc_gate_energy = getElementData(SGC_Stargate, "energy")
    local eTT = setTimer(energy_transfer, 1000, 0, energy_device, sgc_gate_energy, 290000)
    setElementData(energy_device_object, "energy_transfer_timer", eTT)
end