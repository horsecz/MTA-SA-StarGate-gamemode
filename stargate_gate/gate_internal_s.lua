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
    local all_gates = stargate_getAllStargates()
    if all_gates == nil then
        return false
    end
    local address_withoutPOO = { addressArray[1], addressArray[2], addressArray[3], addressArray[4], addressArray[5], addressArray[6] }
    local address_arraySize = array_size(addressArray)
    local stargate_galaxy = nil
    local address_POO = nil

    if address_arraySize == 7 then -- 7 symbol address -> 7th symbol must be point of origin
        address_POO = addressArray[7]
    elseif address_arraySize == 8 then -- 8 symbol address -> 7th symbol is galaxy; 8th is point of origin
        stargate_galaxy = stargate_convertAddressSymbolToGalaxy(addressArray[7])
        address_POO = addressArray[8]
    elseif address_arraySize == 9 then -- 9 symbol address -> it's not address but a code
        address_withoutPOO = array_push(address_withoutPOO, addressArray[7])
        address_withoutPOO = array_push(address_withoutPOO, addressArray[8])
        address_withoutPOO = array_push(address_withoutPOO, addressArray[9])
    else -- less than 7 or more than 9 symbols -> invalid
        return false
    end

    if address_POO then -- check point of origin 
        if not address_POO == 39 then
            return false
        end
    end

    
    for i, sg in pairs(all_gates) do
        local sg_id = stargate_getID(sg)
        local sg_addr = stargate_getAddress(sg_id)
        if array_equal(address_withoutPOO, sg_addr) then
            if stargate_galaxy then
                local sg_galaxy = stargate_getGalaxy(sg_id)
                if stargate_galaxy == sg_galaxy then
                    return sg_id
                else
                    return false
                end
            else
                return sg_id
            end
        end
    end
    return false
end

-- Assigns new ID to NEW stargate
--- REQUIRED PARAMETERS:
--> stargate    reference       stargate element
--> galaxy      enum_galaxy     galaxy type of stargate
--- RETURNS:
--> String; ID of new stargate element
function stargate_assignID(stargate, galaxy)
    local id = nil
    local galaxy_text = nil
    if LastMWGateID == nil then
        LastMWGateID = 0
    elseif LastPGGateID == nil then
        LastPGGateID = 0
    elseif LastUAGateID == nil then
        LastUAGateID = 0
    end
    
    if galaxy == enum_galaxy.MILKYWAY then
        LastMWGateID = LastMWGateID + 1
        id = LastMWGateID
        galaxy_text = "MW"
    elseif galaxy == enum_galaxy.PEGASUS then
        LastPGGateID = LastPGGateID + 1
        id = LastPGGateID
        galaxy_text = "PG"
    elseif galaxy == enum_galaxy.UNIVERSE then
        LastUAGateID = LastUAGateID + 1
        id = LastUAGateID
        galaxy_text = "UA"
    else 
        return false
    end

    local newID = "SG_" .. galaxy_text .. "_" .. tostring(id)
    setElementID(stargate, newID)
    return newID
end

-- Turn on/off all stargate chevrons
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
--> useDelay        bool        will be all chevrons turned on immediately or with (predefined) delay
--> active          bool        are chevrons being activated or deactivated
-- useDelay = use slow chevron turning on animation
function stargate_setAllChevronsActive(stargateID, useDelay, active, eight, nineth)
    local delay = 50
    local type = stargate_galaxy_get(stargateID)
    if type == enum_galaxy.UNIVERSE then
        setTimer(stargate_chevron_setActive, delay, 1, stargateID, 1, active, true)
        return true
    end

    for i=1,9 do
        if i <= 7 or ( i == 8 and eight ) or ( i == 9 and nineth ) then
            setTimer(stargate_chevron_setActive, delay, 1, stargateID, i, active, true)
            if useDelay then
                delay = delay + MW_INCOMING_CHVRN_DELAY
            end
        end
    end
end