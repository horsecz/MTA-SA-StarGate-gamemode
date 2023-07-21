--- spawner_s.lua_ Element spawner for Stargate gamemode
function initServer()
    stargate_create(enum_galaxy.MILKYWAY, 0, 0, 4, {15,11,9,19,25,32,0}, enum_stargateDialType.SLOW)
    stargate_create(enum_galaxy.MILKYWAY, 20, 0, 4, {1,3,5,7,9,11,0}, enum_stargateDialType.FAST, 0, 0, 0)
    stargate_create(enum_galaxy.MILKYWAY, -20, 0, 4, {1,2,3,4,5,6,0}, enum_stargateDialType.INSTANT, 0, 0, 90)
    outputDebugString("[GATE_SPAWNER] Initialized.")
    triggerEvent("gateSpawnerActive", resourceRoot)
end
addEventHandler("onResourceStart", resourceRoot, initServer)