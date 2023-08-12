--- spawner_s.lua_ Element spawner for Stargate gamemode

function initServer()
    -- PLANET SPAWNER
    global_setData("PLANET_LIST", {})
    local newPL = nil
    local ls_stats = lifesupport_create(100, 20, 0, 1)
    newPL = planet_create(0, enum_galaxy.MILKYWAY, "San Andreas")
    newPL = planet_create(1, enum_galaxy.MILKYWAY, "Earth")
    newPL = planet_create(2, enum_galaxy.MILKYWAY, "Icarus")
    newPL = planet_create(6969, enum_galaxy.MILKYWAY, nil, ls_stats)   -- Development planet
    newPL = planet_create(4242, enum_galaxy.MILKYWAY, nil, ls_stats)   -- Sandbox planet
        
    -- GATE SPAWNER
    local newSG = nil
    local newDHD = nil
    global_setData("SG_MW", {})
    global_setData("SG_PG", {})
    global_setData("SG_UN", {})

    global_setData("DHD_MW", {})
    global_setData("DHD_PG", {})
    global_setData("DHD_UN", {})

    -- TEST
    newSG = stargate_create(enum_galaxy.MILKYWAY, 0, 0, 0, 2.25, {15,11,9,19,25,32,39}, nil, enum_stargateDialType.FAST, 90, 0, 0, false)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 0, -2, 6, 1.7, 0, 0, 180, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, 0, 0, 0, 22, {14,11,9,19,25,32,39}, nil, enum_stargateDialType.FAST, 270, 0, 0, false)

    newSG = stargate_create(enum_galaxy.MILKYWAY, 6969, 20, 0, 4, {1,3,5,7,9,11,39}, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, 22, 6, 1.7, 0, 0, 210, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, 6969, -20, 0, 3, {1,2,3,4,5,6,39}, "sgc", enum_stargateDialType.INSTANT, 45, 20, 45)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, -20, 6, 1.7, 0, 0, 165, getElementID(newSG))
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, 10, 10, 1.7, 0, 0, 150)
    -- TEST

    -- Earth
    newSG = stargate_create(enum_galaxy.MILKYWAY, 1, -66.228576660156, 1873.39, 2220.52, {5, 15, 9, 14, 8, 31, 39}, "sgc", enum_stargateDialType.SLOW, 0, 0, 180, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 1, -66.386734008789, 1855.2181396484, 2217.7, 0, 0, 165, getElementID(newSG))

    -- Icarus
    newSG = stargate_create(enum_galaxy.MILKYWAY, 2, -137, 1930, 2187, {4, 8, 12, 16, 22, 24, 1}, nil, enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 2, -134.35200500488, 1949.1099853516, 2184.1000976562, 0, 0, 241.00012207031, getElementID(newSG))

    -- Atlantis
    newSG = stargate_create(enum_galaxy.MILKYWAY, 6969, 575.6, -2786, 1999.85, {9, 15, 25, 11, 8, 32, 39}, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, 6969, 591, -2766, 2004, 0, 0, 180, getElementID(newSG))

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
