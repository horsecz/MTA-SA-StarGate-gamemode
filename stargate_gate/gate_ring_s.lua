-- ring_s.lua_ Gate ring module

function stargate_ring_create(gateID, x, y, z, rx, ry, rz)
    local ring = createObject(1337, x, y, z, rx, ry, rz)
    local sg = stargate_getElement(gateID)
    local id = stargate_ring_assignID(ring, gateID)
    setElementCollisionsEnabled(ring, false)
    local planet = planet_getElementOccupiedPlanet(sg)
    planet_setElementOccupiedPlanet(ring, planet)
    setElementData(ring, "rotationTime", 0)
    setElementAlpha(ring, 254)
    attachElements(ring, sg)
end

-- precalculate ring rotation time on MWSG
function stargate_ring_getSymbolRotationTime(symbol_a, symbol_b)
    if symbol_a < symbol_b then
        symbolDistance = symbol_b-symbol_a
    else
        symbolDistance = symbol_a-symbol_b
    end

    local beginTime = 0
    for i=1,symbolDistance do
        beginTime = beginTime + MW_RING_SPEED*3
    end
    return beginTime
end

function stargate_ring_rotateSymbols(ring, rotateClockwise, symbolDistance)
    local beginTime = 0
    for i=1,symbolDistance do
        beginTime = beginTime + MW_RING_SPEED*3
        setTimer(stargate_ring_rotateOneSymbol, beginTime, 1, ring, rotateClockwise)
    end
    return beginTime
end

function stargate_ring_rotateOneSymbol(ring, rotateClockwise)
    setTimer(function(ring, rotateClockwise)
        local x,y,z,rx,ry,rz = getElementAttachedOffsets(ring)
        local oneSymbolAngle = 360/39
        if rotateClockwise == true then
            ry = ry + (oneSymbolAngle/MW_RING_SPEED)
        else
            ry = ry - (oneSymbolAngle/MW_RING_SPEED)
        end
        setElementAttachedOffsets(ring, 0, 0, 0, 0, ry, 0)
    end, 1, MW_RING_SPEED, ring, rotateClockwise)
    return MW_RING_SPEED
end

function stargate_ring_setID(id, newID)
    setElementID(stargate_ring_getElement(id), newID)
end

function stargate_ring_assignID(ring, gateID)
    local id = gateID.."R"
    setElementID(ring, id)
    return id
end

function stargate_ring_getID(ring)
    return (getElementID(ring))
end

function stargate_ring_getElement(id)
    return (getElementByID(id))
end

function stargate_ring_isRotating(stargateID)
    return (getElementData(getElementByID(stargateID), "isRotating"))
end

function stargate_ring_setRotating(stargateID, rotating)
    return (setElementData(getElementByID(stargateID), "isRotating", rotating))
end

function stargate_ring_getRotationTime(stargateID)
    return (getElementData(getElementByID(stargateID.."R"), "rotationTime"))
end

function stargate_ring_getCurrentSymbol(stargateID)
    local ring = stargate_ring_getElement(stargateID.."R")
    local oneSymbolAngle = 360/39
    local tmpx, tmpy, tmpz, tmprx, ringRotation, tmprz = getElementAttachedOffsets(ring)
    return (ringRotation/oneSymbolAngle)
end