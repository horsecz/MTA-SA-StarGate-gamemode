-- internal_s.lua: Internal functions used for working with stargate element; server-side

-- Adds collision objects to stargate
--- REQUIRED PARAMETERS:
--> id      string      ID of stargate
function stargate_addCollisions(id)
    setElementCollisionsEnabled(stargate_getElement(id), false)
    x, y, z = stargate_getPosition(id)
    local srx, sry, srz = stargate_getRotation(id)
    local col_w stargate_addCollisionObject(id, 2.1, 0, 0, 0, 0, 0, "W")
    local col_e = stargate_addCollisionObject(id, -2.1, 0, 0, 0, 0, 0, "E")
    local col_n = stargate_addCollisionObject(id, 0, 0, 2.1, 0, 90, 0, "N")
    local col_s = stargate_addCollisionObject(id, 0, 0, -2.1, 0, 90, 0, "S")
    local col_ne = stargate_addCollisionObject(id, -1.5, 0, 1.5, 0, 45, 0, "NE")
    local col_nw = stargate_addCollisionObject(id, 1.5, 0, 1.5, 0, -45, 0, "NW")
    local col_se = stargate_addCollisionObject(id, 1.5, 0, -1.5, 0, 45, 0, "SW")
    local col_sw = stargate_addCollisionObject(id, -1.5, 0, -1.5, 0, -45, 0, "SE")
end

-- Adds single collision object to stargate
--- REQUIRED PARAMETERS:
--> id          string      ID of stargate
--> x,y,z       int         collision object position (relative to stargate)
--> rx,ry,rz    int         rotation of collision object (relative to stargate)
--> desc        string      description of collision object (used in ID)
--- RETURNS:
--> Reference; collision object
function stargate_addCollisionObject(id, x, y, z, rx, ry, rz, desc)
    local collisionObject = createObject(9131, 0, 0, -1000, rx, ry, rz)
    local stargate = stargate_getElement(id)
    setElementID(collisionObject, id.."COLOBJ."..desc)
    setElementAlpha(collisionObject, 0)
    local dimension = getElementDimension(stargate)
    planet_setElementOccupiedPlanet(collisionObject, "PLANET_"..dimension)
    attachElements(collisionObject, getElementByID(id), x, y, z, rx, ry, rz)
    return collisionObject
end

-- Translation of stargate address to stargate element ID
--- REQUIRED PARAMETERS:
--> id              string      ID of stargate
--> addressArray    reference   array containing 7 - 9 elements type int; numbers in range from 0 to 38
--- RETURNS:
--> String; Stargate ID or false if address is invalid
function stargate_convertAddressToID(id, addressArray)
    local all_gates = stargate_galaxy_getAllElements(id)
    if all_gates == nil then
        return false
    end
    for i, sg in pairs(all_gates) do
        local sg_id = stargate_getID(sg)
        local sg_addr = stargate_getAddress(sg_id)
        if array_equal(addressArray, sg_addr) then
            return sg_id
        end
    end
    return false
end

-- Assigns new ID to NEW stargate
--- REQUIRED PARAMETERS:
--> stargate    reference   stargate element
--- RETURNS:
--> String; ID of new stargate element
function stargate_assignID(stargate)
    if LastMWGateID == nil then
        LastMWGateID = 0
    end
    LastMWGateID = LastMWGateID + 1
    local newID = "SG_MW_"..tostring(LastMWGateID)
    setElementID(stargate, newID)
    return newID
end

-- Turn on all stargate chevrons
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
--> useDelay        bool        will be all chevrons turned on immediately or with (predefined) delay
--> active          bool        are chevrons being activated or deactivated
-- useDelay = use slow chevron turning on animation
function stargate_setAllChevronsActive(stargateID, useDelay, active)
    local delay = 50
    for i=1,7 do
        setTimer(stargate_chevron_setActive, delay, 1, stargateID, i, active, true)
        if useDelay then
            delay = delay + MW_INCOMING_CHVRN_DELAY
        end
    end
end