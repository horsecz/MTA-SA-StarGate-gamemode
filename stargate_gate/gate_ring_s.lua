-- ring_s.lua_ Gate ring module

function stargate_ring_create(gateID, x, y, z, rx, ry, rz)
    local ring = createObject(1377, x, y, z, rx, ry, rz)
    local id = stargate_ring_assignID(ring, gateID)
    setElementCollisionsEnabled(ring, true)
    setElementData(ring, "rotationTime", 0)
end

-- precalculate ring rotation time on MWSG
function stargate_ring_getSymbolRotationTime(symbol_a, symbol_b)
    local oneSymbolAngle = 360/39
    local currentSymbol = symbol_a
    local symbolDistance = 0
    local np = 1
    if currentSymbol < symbol_b then
        symbolDistance = symbol_b-currentSymbol
    else
        symbolDistance = currentSymbol-symbol_b
        np = -1
    end
    return MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE
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

function stargate_ring_setModel(id, modelID)
    triggerClientEvent("setElementModelClient", resourceRoot, stargate_ring_getElement(id), modelID)
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
    local tmp, ringRotation, tmp2 = getElementRotation(ring)
    return (ringRotation/oneSymbolAngle)
end