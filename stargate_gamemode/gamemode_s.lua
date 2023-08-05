RESOURCE_STOP = false

function onPlayerSpawn(x, y, z, r, temp1, temp2, temp3, dimension)
    setElementAlpha(source, 255)
    fadeCamera(source, true, 1)
    local ls = lifesupport_create()
    lifesupport_setElementLifesupport(source, ls)
    
    if not RESOURCE_STOP then
        planet_setElementOccupiedPlanet(source, "PLANET_6969", true)
    end
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
    if not RESOURCE_STOP then
        local PLAYERS_JOINED = global_getData("var_players_joined")
        local id = tonumber(getElementID(source))
        PLAYERS_JOINED = array_remove(PLAYERS_JOINED, array_get(PLAYERS_JOINED, id, true))
        global_setData("var_players_joined", PLAYERS_JOINED)
    end
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

-- returns true/false
-- if given element1 is in range of element2 (within specifieed radius)
function isElementInRange(element1, element2, radius)
    local x, y, z = getElementPosition(element1)
    local x2, y2, z2 = getElementPosition(element2)
    local d1 = getElementDimension(element1)
    local d2 = getElementDimension(element2)
    if d1 == d2 then
        if x < x2+radius and x > x2-radius then
            if y < y2+radius and y > y2-radius then
                if z < z2+radius and z > z2-radius then
                    return true
                end
            end
        end
    end
    return false
end

-- if given element1 is in range of coordinates x2,y2,z2 within specified radius
function isElementInCoordinatesRange(element1, x2, y2, z2, radius)
    local x, y, z = getElementPosition(element1)
    if x < x2+radius and x > x2-radius then
        if y < y2+radius and y > y2-radius then
            if z < z2+radius and z > z2-radius then
            return true
            end
        end
    end
    return false
end

addCommandHandler("pos", function(src, cmd, x, y, z)
    setElementPosition(src, tonumber(x), tonumber(y), tonumber(z))
end)

---
--- DOES NOT BELONG HERE
---

-- fake explosion
function explosion_create(src, cmdName, type)
    local bombTime = 5000
    local bombDelay = 2000
    local bombRange = 1000

    local dimension = 6969
    local x, y, z = 0, 0, 4

    if type == "nuclear" or type == "stargate" then
        setTimer(function(x, y, z, d, r)
            for i,p in ipairs(getElementsByType("player")) do
                if isElementInCoordinatesRange(p, x, y, z, r) and getElementDimension(p) == d then
                    local px, py, pz = getElementPosition(p)
                    fadeCamera(p, false, 0.3, 255, 255, 255)
                    setElementAlpha(p, 0)
                    setElementHealth(p, 0)
                    createExplosion(px, py, pz, 7, p)
                    createExplosion(px, py, pz+1, 7, p)
                    createExplosion(px, py, pz-1, 7, p)
                end
            end
        end, 100, (bombTime+bombDelay+255*10)/100, x, y, z, dimension, bombRange)
    end
end