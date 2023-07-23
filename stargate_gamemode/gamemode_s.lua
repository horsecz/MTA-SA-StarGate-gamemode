RESOURCE_STOP = false

function onPlayerSpawn(x, y, z, r, temp1, temp2, temp3, dimension)
    setElementAlpha(source, 255)
end
addEventHandler ( "onPlayerSpawn", getRootElement(), onPlayerSpawn)

function onPlayerWasted()
    setTimer(spawnPlayer, 5000, 1, source, 0, 10, 4)
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerWasted)

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

function onPlayerLeave()
    local PLAYERS_JOINED = global_getData("var_players_joined")
    if not RESOURCE_STOP then
        local id = tonumber(getElementID(source))
        PLAYERS_JOINED = array_remove(PLAYERS_JOINED, array_get(PLAYERS_JOINED, id))
    end
    global_setData("var_players_joined", PLAYERS_JOINED)
end
addEventHandler( "onPlayerQuit", getRootElement(), onPlayerLeave)

function onResourceStart()
end
addEventHandler( "onResourceStart", resourceRoot, onResourceStart)

function onResourceStop()
    RESOURCE_STOP = true
    for k, p in ipairs(getElementsByType("player")) do
        redirectPlayer(p, "", 0)
    end
end
addEventHandler( "onResourceStop", resourceRoot, onResourceStop)