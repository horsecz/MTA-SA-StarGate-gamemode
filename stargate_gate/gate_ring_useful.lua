-- ring_useful.lua: Useful functions with stargate ring element; shared

--- Stargate ring element attributes
--> isRotating      is ring currently being rotated
--> rotationTime    time for ring that will take to rotate to correct symbol


function stargate_ring_setID(id, newID)
    setElementID(stargate_ring_getElement(id), newID)
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
    return (math.floor(ringRotation/oneSymbolAngle))
end