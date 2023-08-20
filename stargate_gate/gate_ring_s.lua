-- ring_s.lua: Module for stargate ring; server-side

-- Create ring object element and attach it to stargate
--- REQUIRED PARAMETERS:
--> gateID      string      stargate ID
--> x, y, z     int         ring object position
--> rx, ry, rz  int         ring object rotation
function stargate_ring_create(gateID, x, y, z, rx, ry, rz)
    local ring = createObject(1337, x, y, z, rx, ry, rz)
    models_setElementModelAttribute(ring, "outerring")
    local sg = stargate_getElement(gateID)
    local id = stargate_ring_assignID(ring, gateID)
    setElementCollisionsEnabled(ring, false)
    local planet = planet_getElementOccupiedPlanet(sg)
    planet_setElementOccupiedPlanet(ring, planet)
    setElementData(ring, "rotationTime", 0)
    setElementAlpha(ring, 254)
    attachElements(ring, sg)
end

-- Calculates ring rotation time for given symbols (for MilkyWay type stargate)
--- REQUIRED PARAMETERS:
--> symbol_a    int     first symbol
--> symbol_b    int     second symbol
--- RETURNS:
--> Int; time [ms] that will take for ring to rotate from symbol A to symbol B
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

-- Perform ring rotation by given number of symbols (distance)
--- REQUIRED PARAMETERS:
--> ring                reference   ring element
--> rotateClockWise     bool        will be ring rotated clockwise or not
--> symbolDistance      int         the distance (number of symbols) ring will rotate
--- RETURNS:
--> Int; time [ms] that will take for ring to be rotated 
function stargate_ring_rotateSymbols(ring, rotateClockwise, symbolDistance)
    local beginTime = 0
    for i=1,symbolDistance do
        beginTime = beginTime + MW_RING_SPEED*3
        setTimer(stargate_ring_rotateOneSymbol, beginTime, 1, ring, rotateClockwise)
    end
    return beginTime
end

-- Performs ring rotation (by one symbol)
-- > Ring object is attached object (to stargate), therefore moveObject does not work and custom function for rotating had to be implemented
--- REQUIRED PARAMETERS:
--> ring                reference       ring element
--> rotateClockwise     bool            will be ring rotated clockwise or the other direction?
--- RETURNS:
--> Int; time it will take for ring to be rotated
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

---
--- INTERNAL Functions
---

-- Assigns ID to new ring element
--- REQUIRED PARAMETERS:
--> ring        reference   ring element
--> gateID      string      stargate ID
--- RETURNS:
--> String; ring element ID
function stargate_ring_assignID(ring, gateID)
    local id = gateID.."R"
    setElementID(ring, id)
    return id
end
