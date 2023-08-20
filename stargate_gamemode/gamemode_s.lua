-- gamemode_s.lua:  Main gamemode script for Stargate for MTA:SA Gamemode; server-side
RESOURCE_STOP = false       -- is resource being stopped?

-- Actions performed on player spawning
-- Reset his alpha, camera, lifesupport and occupied planet
-- PARAMETERS:
--> inherited from "onPlayerSpawn" event
function onPlayerSpawn(x, y, z, r, temp1, temp2, temp3, dimension)
    setElementAlpha(source, 255)
    fadeCamera(source, true, 1)
    local ls = lifesupport_create()
    lifesupport_setElementLifesupport(source, ls)
    planet_setElementOccupiedPlanet(source, "PLANET_6969", true)
end
addEventHandler ( "onPlayerSpawn", getRootElement(), onPlayerSpawn)

-- Actions performed on player dying
-- Respawn player
function onPlayerWasted()
    setTimer(spawnPlayer, 5000, 1, source, 0, 10, 4)
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerWasted)

-- Actions performed on player joining the server
-- Spawn player, add him to joined players array, set player ID
-- PARAMETERS:
--> inherited from "onPlayerJoin" event
function onPlayerJoin(player)
    spawnPlayer(source, 0, 10, 4, 180)
    setCameraTarget(source, source)
    fadeCamera(source, true)
    local PLAYERS_JOINED = global_getData("var_players_joined")

    if not PLAYERS_JOINED then
        PLAYERS_JOINED = array_new()
    end
    PLAYERS_JOINED = array_push(PLAYERS_JOINED, source)
    setElementID(source, array_size(PLAYERS_JOINED))
    global_setData("var_players_joined", PLAYERS_JOINED)
end
addEventHandler( "onPlayerJoin", getRootElement(), onPlayerJoin)

-- Actions performed on player leaving the server
-- Remove player from joined players array
function onPlayerLeave()
    if not RESOURCE_STOP then
        local PLAYERS_JOINED = global_getData("var_players_joined")
        local id = tonumber(getElementID(source))
        PLAYERS_JOINED = array_remove(PLAYERS_JOINED, array_get(PLAYERS_JOINED, id, true))
        global_setData("var_players_joined", PLAYERS_JOINED)
    end
end
addEventHandler( "onPlayerQuit", getRootElement(), onPlayerLeave)

-- Actions performed on gamemode resource start
function onResourceStart()
end
addEventHandler( "onResourceStart", resourceRoot, onResourceStart)

-- Actions performed on gamemode resource stop
-- Reconnecting all players
function onResourceStop()
    RESOURCE_STOP = true
    for k, p in ipairs(getElementsByType("player")) do
        redirectPlayer(p, "", 0)
    end
end
addEventHandler( "onResourceStop", resourceRoot, onResourceStop)