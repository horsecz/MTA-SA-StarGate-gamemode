function onPlayerSpawn(x, y, z, r, temp1, temp2, temp3, dimension)
    setElementAlpha(source, 255)
end
addEventHandler ( "onPlayerSpawn", getRootElement(), onPlayerSpawn)

function onPlayerWasted()
    setTimer(spawnPlayer, 5000, 1, source, 0, 10, 4)
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerWasted)

function onPlayerJoin()
    spawnPlayer(source, 0, 10, 4)
    setCameraTarget(source, source)
    fadeCamera(source, true)
end
addEventHandler( "onPlayerJoin", getRootElement(), onPlayerJoin)

function onResourceStart()
    for k, p in ipairs(getElementsByType("player")) do
        spawnPlayer(p, 0, 10, 4, 180)
        setCameraTarget(p, p)
    end
end
addEventHandler( "onResourceStart", resourceRoot, onResourceStart)