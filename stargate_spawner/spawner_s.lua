--- spawner_s.lua_ Element spawner for Stargate gamemode

function initServer()
    -- PLANET SPAWNER
    local newPL = nil
    newPL = planet_create(0, enum_galaxy.MILKYWAY, "San Andreas")
    newPL = planet_create(1, enum_galaxy.MILKYWAY, "Earth")
    newPL = planet_create(6969, enum_galaxy.MILKYWAY)   -- Development planet
    newPL = planet_create(4242, enum_galaxy.MILKYWAY)   -- Sandbox planet
        
    -- GATE SPAWNER
    local newSG = nil
    local newDHD = nil
    global_setData("SG_MW", {})
    global_setData("SG_PG", {})
    global_setData("SG_UN", {})

    global_setData("DHD_MW", {})
    global_setData("DHD_PG", {})
    global_setData("DHD_UN", {})

    newSG = stargate_create(enum_galaxy.MILKYWAY, 0, 0, 0, 2.25, {15,11,9,19,25,32,39}, enum_stargateDialType.FAST, 90, 0, 0, false)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 0, -2, 6, 1.7, 0, 0, 180, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, 6969, 20, 0, 4, {1,3,5,7,9,11,39}, enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, 22, 6, 1.7, 0, 0, 210, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, 6969, -20, 0, 3, {1,2,3,4,5,6,39}, enum_stargateDialType.FAST, 45, 20, 45)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, -20, 6, 1.7, 0, 0, 165, getElementID(newSG))

    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, 10, 10, 1.7, 0, 0, 150)
    
    outputDebugString("[GATE_SPAWNER] Initialized.")
    triggerEvent("gateSpawnerActive", root)
end
addEventHandler("onResourceStart", resourceRoot, initServer)

function spawner_gateList_add(gateElement)
    local id = getElementID(gateElement)
    local galaxy = stargate_getGalaxy(id)
    local SG_MW = global_getData("SG_MW")

    if galaxy == "milkyway" then
        SG_MW = array_push(SG_MW, gateElement)
        global_setData("SG_MW", SG_MW)
    end
end
