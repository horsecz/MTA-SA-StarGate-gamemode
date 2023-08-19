--- spawner_s.lua: Element spawner for Stargate gamemode; server-side

-- Start spawner resource -> initialize and spawn all elements:
-- > initialize global array lists
-- > create planets
-- > spawn stargates and their dhds
-- > spawn dhds (unassigned)
function spawner_serverStart()
    spawner_initGlobals()
    spawner_planetSpawner()
    spawner_gateSpawner()
    triggerEvent("gateSpawnerActive", root)
end
addEventHandler("onResourceStart", resourceRoot, spawner_serverStart)

-- Initialize global lists
function spawner_initGlobals()
    global_setData("PLANET_LIST", {})

    global_setData("SG_MW", {})
    global_setData("SG_PG", {})
    global_setData("SG_UN", {})

    global_setData("DHD_MW", {})
    global_setData("DHD_PG", {})
    global_setData("DHD_UN", {})
end

-- Create (and "spawn") all planets
function spawner_planetSpawner()
    local newPL = nil
    newPL = planet_create(enum_planetDimension.SanAndreas, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.SanAndreas])
    newPL = planet_create(enum_planetDimension.Earth, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.Earth])
    newPL = planet_create(enum_planetDimension.Icarus, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.Icarus])
    newPL = planet_create(enum_planetDimension.DevelopmentWorld, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.DevelopmentWorld], lifesupport_create(100, 20, 0, 1))
    newPL = planet_create(enum_planetDimension.SandboxWorld, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.SandboxWorld], lifesupport_create(100, 20, 0, 1))
    outputDebugString("[STARGATE:SPAWNER] Created planets.")
end

-- Create and spawn all stargates with their assigned DHDs (if they have one)
function spawner_gateSpawner()
    local newSG = nil
    local newDHD = nil

    -- DEVELOPMENT ONLY
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 0, 0, 2.25, {15,11,9,19,25,32,39}, nil, enum_stargateDialType.FAST, 90, 0, 0, false)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -2, 6, 1.7, 0, 0, 180, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 0, 0, 22, {14,11,9,19,25,32,39}, nil, enum_stargateDialType.FAST, 270, 0, 0, false)

    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 20, 0, 4, {1,3,5,7,9,11,39}, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 22, 6, 1.7, 0, 0, 210, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -20, 0, 3, {1,2,3,4,5,6,39}, "sgc", enum_stargateDialType.INSTANT, 45, 20, 45)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -20, 6, 1.7, 0, 0, 165, getElementID(newSG))
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 10, 10, 1.7, 0, 0, 150)
    -- DEVELOPMENT ONLY

    -- Earth
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Earth, -66.228576660156, 1873.39, 2220.52, enum_stargateAddress.Earth, "sgc", enum_stargateDialType.SLOW, 0, 0, 180, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.Earth, -66.386734008789, 1855.2181396484, 2217.7, 0, 0, 165, getElementID(newSG))

    -- Icarus
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Icarus, -137.12, 1930.8, 2186.22, enum_stargateAddress.Icarus, nil, enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.Icarus, -134.35200500488, 1949.1099853516, 2184.1000976562, 0, 0, 241.00012207031, getElementID(newSG))

    -- Atlantis     >>> TODO: Development world dimension <<<
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 575.6, -2786, 1999.85, enum_stargateAddress.Atlantis, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 591, -2766, 2004, 0, 0, 180, getElementID(newSG))

    outputDebugString("[STARGATE:SPAWNER] Spawned Stargates and DHDs.")
end

-- Add stargate element to stargate gate element list
--- REQUIRED PARAMETERS:
--> gateElement     reference       stargate element
function spawner_gateList_add(gateElement)
    local id = getElementID(gateElement)
    local galaxy = stargate_getGalaxy(id)
    local SG_MW = global_getData("SG_MW")

    if galaxy == "milkyway" then
        SG_MW = array_push(SG_MW, gateElement)
        global_setData("SG_MW", SG_MW)
    end
end
