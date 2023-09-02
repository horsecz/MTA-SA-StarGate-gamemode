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
    local currentSymbol = symbol_a
    local symbol = symbol_b

    local currentSymbolNeg = 39 - currentSymbol
    local symbol_neg = 39 - symbol 
    local symbolDistance = math.abs(currentSymbol-symbol)
    local clockWise = nil

    if currentSymbol > symbol then -- 5 (34) -> 2 (37); 3 /// 35 (4) -> 2 (37);  
        if currentSymbolNeg < symbol_neg then -- 5 -> 2
            clockWise = false
        else -- 35 -> 2
            clockWise = true
            symbolDistance = math.abs(currentSymbolNeg + symbol)
        end
    elseif currentSymbol < symbol then -- 2 [37] -> 5 [34] /// 2 [37] -> 35 [4]
        if currentSymbolNeg > symbol_neg then -- 2 -> 5
            clockWise = true
        else -- 2 -> 35
            clockWise = false
            symbolDistance = math.abs(currentSymbol + symbol_neg)
        end
    else -- symbol == currentSymbol
        symbolDistance = 0
    end

    if symbol == 39 and clockWise == true then
        symbolDistance = symbolDistance - 1
    elseif symbol == 39 and clockWise == false then
        symbolDistance = symbolDistance + 2
    end

    if symbolDistance == 0 then
        return -MW_RING_CHEVRON_LOCK_SLOW_DELAY + MW_RING_CHEVRON_LOCK_SLOW_DELAY/10
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
    setElementData(ring, "ring_rotate_symbols_timers", {})
    local sTrs = {}

    for i=1,symbolDistance do
        beginTime = beginTime + MW_RING_SPEED*3
        local oSR = setTimer(stargate_ring_rotateOneSymbol, beginTime, 1, ring, rotateClockwise)
        sTrs = array_push(sTrs, oSR)
    end
    setElementData(ring, "ring_rotate_symbols_timers", sTrs)
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
    local oST = setTimer(function(ring, rotateClockwise)
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
