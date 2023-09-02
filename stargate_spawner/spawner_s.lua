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
    newPL = planet_create(enum_planetDimension.Abydos, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.Abydos])
    newPL = planet_create(enum_planetDimension.GreenCave, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.GreenCave])
    newPL = planet_create(enum_planetDimension.Baals, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.Baals])
    newPL = planet_create(enum_planetDimension.MWVillage, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.MWVillage])
    newPL = planet_create(enum_planetDimension.P3R272, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.P3R272])

    newPL = planet_create(enum_planetDimension.Atlantis, enum_galaxy.PEGASUS, enum_planetName[enum_planetDimension.Atlantis])
    newPL = planet_create(enum_planetDimension.GreenWorld, enum_galaxy.PEGASUS, enum_planetName[enum_planetDimension.GreenWorld])
    newPL = planet_create(enum_planetDimension.StorageWorld, enum_galaxy.PEGASUS, enum_planetName[enum_planetDimension.StorageWorld])
    newPL = planet_create(enum_planetDimension.SnowAncientShip, enum_galaxy.PEGASUS, enum_planetName[enum_planetDimension.SnowAncientShip])

    newPL = planet_create(enum_planetDimension.Destiny, enum_galaxy.UNIVERSE, enum_planetName[enum_planetDimension.Destiny])
    newPL = planet_create(enum_planetDimension.UniDesert, enum_galaxy.UNIVERSE, enum_planetName[enum_planetDimension.UniDesert])
    newPL = planet_create(enum_planetDimension.UniCave, enum_galaxy.UNIVERSE, enum_planetName[enum_planetDimension.UniCave])
    newPL = planet_create(enum_planetDimension.UniObelisk, enum_galaxy.UNIVERSE, enum_planetName[enum_planetDimension.UniObelisk])
    newPL = planet_create(enum_planetDimension.UniSnowDesert, enum_galaxy.UNIVERSE, enum_planetName[enum_planetDimension.UniSnowDesert])

    newPL = planet_create(enum_planetDimension.AsgardHomeworld, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.AsgardHomeworld]) -- TODO: Temporary galaxy: MilkyWay
    
    newPL = planet_create(enum_planetDimension.DevelopmentWorld, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.DevelopmentWorld], lifesupport_create(100, 20, 0, 1))
    newPL = planet_create(enum_planetDimension.SandboxWorld, enum_galaxy.MILKYWAY, enum_planetName[enum_planetDimension.SandboxWorld], lifesupport_create(100, 20, 0, 1))
    outputDebugString("[STARGATE:SPAWNER] Created planets.")
end

-- Create and spawn all stargates with their assigned DHDs (if they have one)
function spawner_gateSpawner()
    local newSG = nil
    local newDHD = nil

    -- DEVELOPMENT ONLY
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, 0, 0, 2.25, {15,11,9,19,25,32}, nil, enum_stargateDialType.FAST, 90, 0, 0, false)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -2, 6, 1.7, 0, 0, 180, getElementID(newSG), true)

    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -8, 0, 4, {1,3,5,7,9,11}, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.DevelopmentWorld, -6, 8, 1.7, 0, 0, 210, getElementID(newSG))

    newSG = stargate_create(enum_galaxy.PEGASUS, enum_planetDimension.DevelopmentWorld, -14, 0, 4, {1,5,11,15,19,25}, nil, enum_stargateDialType.SLOW, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.PEGASUS, enum_planetDimension.DevelopmentWorld, -12, 8, 2, 0, 0, 170, getElementID(newSG))
    
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.DevelopmentWorld, -20, 0, 4, {1,5,11,15,19,26}, nil, enum_stargateDialType.SLOW, 0, 0, 0)
    -- DEVELOPMENT ONLY

    -- San Andreas
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.SanAndreas, 254.2, 1855.6, -17.6, enum_stargateAddress.SanAndreas, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.UNKNOWN, enum_planetDimension.SanAndreas, 253.5, 1843.73, -18.7, 0, 0, 180, getElementID(newSG))

    -- Earth
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Earth, -66.228576660156, 1873.39, 2220.52, enum_stargateAddress.Earth, "sgc", enum_stargateDialType.SLOW, 0, 0, 180, false, true)
    newDHD = dhd_create(enum_galaxy.UNKNOWN, enum_planetDimension.Earth, -66.386734008789, 1855.2181396484, 2217.7, 0, 0, 165, getElementID(newSG), true)

    -- Icarus
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Icarus, -137.12, 1930.8, 2186.22, enum_stargateAddress.Icarus, nil, enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.Icarus, -134.35200500488, 1949.1099853516, 2184.1000976562, 0, 0, 241.00012207031, getElementID(newSG), true)
    setElementData(newDHD, "canDialDestiny", true)

    -- Abydos
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Abydos, 87.6, 2453.6, 1203.1, enum_stargateAddress.Abydos, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.Abydos, 85.2, 2465.9, 1201.6, 0, 0, 180, getElementID(newSG))

    -- Milkyway - Random world 1 (greenish; cave neaby)
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.GreenCave, 1832.6, -2459.98, 1988.2, enum_stargateAddress.GreenCave, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.GreenCave, 1837.25, -2442.52, 1987.4, 0, 0, 160, getElementID(newSG))
    
    -- Milkyway - Anubis ship
    --newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Anubis, -1569.1, -1589.22, 1986.45, enum_stargateAddress.Anubis, nil, enum_stargateDialType.FAST, 0, 0, 0)
    --newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.Anubis,  -1569, -1578.8, 1985.3, 0, 0, 180, getElementID(newSG))

    -- Milkyway - Baals time machine
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.Baals, -2347.3, -1638.92, 403.6, enum_stargateAddress.Baals, nil, enum_stargateDialType.SLOW, 0, 0, 270, false, true)
    newDHD = dhd_create(enum_galaxy.UNKNOWN, enum_planetDimension.Baals,  -2330.93, -1652.2, 402.8, 0, 0, 180, getElementID(newSG))
    
    -- Milkyway - Village world
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.MWVillage, -2079.4, -1660.72, 1990.1, enum_stargateAddress.MWVillage, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.MWVillage,  -2082.9, -1644.5, 1989.2, 0, 0, 180, getElementID(newSG))
        
    -- Milkyway - P3R-272 (Ancient knowledge sharing base)
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.P3R272, 312.04, 2489.5, -10.33, enum_stargateAddress.P3R272, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.P3R272, 307.5, 2480.8, -12.4, 0, 0, 180, getElementID(newSG))
            
    
    -- Atlantis
    newSG = stargate_create(enum_galaxy.PEGASUS, enum_planetDimension.Atlantis, 575.6, -2786, 1999.85, enum_stargateAddress.Atlantis, "sgc", enum_stargateDialType.SLOW, 0, 0, 0, false, true)
    setElementData(newSG, "isAtlantis", true)
    newDHD = dhd_create(enum_galaxy.UNKNOWN, enum_planetDimension.Atlantis, 591, -2766, 2003.5, 0, 0, 180, getElementID(newSG), true)
        
    -- Pegasus - Random world 1 (greenish; ZPM hub)
    newSG = stargate_create(enum_galaxy.PEGASUS, enum_planetDimension.GreenWorld, -2377.2, 1564.7, 2003.6, enum_stargateAddress.GreenWorld, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.PEGASUS, enum_planetDimension.GreenWorld, -2377.3, 1554.4, 2002.9, 0, 0, 180, getElementID(newSG))
    
    -- Pegasus - Random world 2 (cellar or some storage room; dart is there)
    newSG = stargate_create(enum_galaxy.PEGASUS, enum_planetDimension.StorageWorld, 0.6, -15, 1895.1, enum_stargateAddress.StorageWorld, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.PEGASUS, enum_planetDimension.StorageWorld, 5, -9.3, 1895.1, 0, 0, 180, getElementID(newSG))

    -- Pegasus - Random world 3 (ancient ship; snow)
    newSG = stargate_create(enum_galaxy.PEGASUS, enum_planetDimension.SnowAncientShip, 2003.1, 101.99, 3016.2, enum_stargateAddress.SnowAncientShip, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.PEGASUS, enum_planetDimension.SnowAncientShip, 2011.66, 91.1, 3017.2, 0, 0, 180, getElementID(newSG))
    
        
    -- Destiny
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.Destiny, 0.45, -11, -21.6, enum_stargateAddress.Destiny, nil, enum_stargateDialType.SLOW, 0, 0, 180, false, true)
    setElementData(newSG, "isDestiny", true)
    newDHD = dhd_create(enum_galaxy.UNKNOWN, enum_planetDimension.Destiny, 2, -28.5, -22, 0, 0, 180, getElementID(newSG), true)
        
    -- Universe - Desert
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.UniDesert, 1389.43, 1000.2, 2001.7, enum_stargateAddress.UniDesert, nil, enum_stargateDialType.FAST, 0, 0, 0)

    -- Universe - Snow desert
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.UniSnowDesert, -2376.9, -77.95, 2002.3, enum_stargateAddress.UniSnowDesert, nil, enum_stargateDialType.FAST, 0, 0, 0)

    -- Universe - Cave world
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.UniCave, -278.4, -1049.8, 1997.5, enum_stargateAddress.UniCave, nil, enum_stargateDialType.FAST, 0, 0, 0)

    -- Universe - Obelisk world
    newSG = stargate_create(enum_galaxy.UNIVERSE, enum_planetDimension.UniObelisk, -976.4, 2328.5, 2484.9, enum_stargateAddress.UniObelisk, nil, enum_stargateDialType.FAST, 0, 0, 0)


    -- Asgard homeworld
    newSG = stargate_create(enum_galaxy.MILKYWAY, enum_planetDimension.AsgardHomeworld, 262.6, 2448.2, -12.61, enum_stargateAddress.AsgardHomeworld, nil, enum_stargateDialType.FAST, 0, 0, 0)
    newDHD = dhd_create(enum_galaxy.MILKYWAY, enum_planetDimension.AsgardHomeworld, 266.2, 2451.9, -13.8, 0, 0, 180, getElementID(newSG), true)
                
    outputDebugString("[STARGATE:SPAWNER] Spawned Stargates and DHDs.")
end

-- Add stargate element to stargate gate element list
-- TODO: is this even used somewhere?
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
