--- gate_s.lua_ Core serverside module for stargates and their logic script

---
--- Global variables
---

-- constants
MW_RING_SPEED = 150    -- milkyway gate ring rotation speed [ms per symbol]; default 150
MW_RING_CHEVRON_LOCK = 1500 -- milkyway gate chevron lock time [ms]; default 1500
MW_RING_CHEVRON_LOCK_AE = 500 -- milkyway gate chevron unlock time [ms]; default 1500
MW_RING_CHEVRON_LOCK_FAST_DELAY = 1500 -- milkway gate last chevron lock delay [ms]; default 1500 
MW_RING_CHEVRON_LOCK_SLOW_DELAY = 5000 -- milkway gate chevron lock delay [ms]; 5000
MW_RING_ROTATE_PAUSE = 1250 -- milkyway gate ring rotation pause after chevron lock [ms]; default 1250
MW_INCOMING_CHVRN_DELAY = 1200 -- milkyway gate incoming wormhole chevron activate delay between activation [ms]; default 1200
MW_WORMHOLE_CREATE_DELAY = 500 -- milkyway gate wormhole creation delay (after succesful link) [ms]; default 500
MW_DIAL_FAIL_CHVRN_DELAY = 3000 -- milkyway gate chevrons turn off delay after dial failed [ms]; default 3000
MW_FASTDIAL_START_DELAY = 2500  -- milkyway gate fast dial begin delay [ms]; default 2500
MW_FASTDIAL_CHEVRON_DELAY = 1000 -- milkway gate fast dial chevron encode delay [ms]; default 1000

GATE_OPEN_DELAY = 200

SG_WORMHOLE_OPEN_TIME = 38  -- stargate classic wormhole open time [s]; default 38
SG_VORTEX_ANIM_SPEED = 85 -- stargate vortex opening animation speed [ms]; default 115
SG_VORTEX_ANIM_TOP_DELAY = 300 -- stargate vortex opening animation delay (when vortex is greatest) [ms]; default 200
SG_HORIZON_ANIMATION_SPEED = 100 -- stargate horizon animation change speed [ms]; default 100; recommended 100-200
SG_HORIZON_ACTIVATE_SPEED = 50 -- stargate horizon opening/activation speed [ms]; default 150
SG_HORIZON_OPACITY = 65 -- stargate horizon object transparency [0-100]; default 75

-- variable constants
SG_HORIZON_ANIMATION_BEGIN = SG_HORIZON_ANIMATION_SPEED*3,5
SG_HORIZON_ALPHA = 255 - SG_HORIZON_OPACITY

-- enums
enum_markerType = {
    NONE = -1,
    EVENTHORIZON = 0,
    VORTEX = 1
}

function import_enum_markerType()
    return enum_markerType
end

enum_stargateStatus = {
    DIAL_SELF = -5,
    DIAL_GATE_INCOMING_TOGATE = -4,
    DIAL_GATE_INCOMING = -3,
    DIAL_UNKNOWN_ADDRESS = -2,
    UNKNOWN = -1,

    GATE_IDLE = 0,
    GATE_ACTIVE = 1,
    GATE_OPEN = 2,
    GATE_DISABLED = 3,
    GATE_GROUNDED = 4
}

function import_enum_stargateStatus()
    return enum_stargateStatus
end

function enum_stargateStatus.toString(v)
    if v == enum_stargateStatus.UNKNOWN or v == nil then
        return "Unknown status"
    elseif v == enum_stargateStatus.GATE_IDLE then
        return "Gate idle"
    elseif v == enum_stargateStatus.GATE_ACTIVE then
        return "Gate active"
    elseif v == enum_stargateStatus.GATE_OPEN then
        return "Gate open"
    elseif v == enum_stargateStatus.GATE_DISABLED then
        return "Gate disabled"
    elseif v == enum_stargateStatus.GATE_GROUNDED then
        return "Gate grounded"
    elseif v == enum_stargateStatus.DIAL_UNKNOWN_ADDRESS then
        return "Unknown address"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING then
        return "Incoming wormhole"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING_TOGATE then
        return "Incoming wormhole (fromgate)"
    elseif v == enum_stargateStatus.DIAL_SELF then
        return "Dialed itself"    
    end
end

enum_galaxy = {
    MILKYWAY = 0,
    PEGASUS = 1,
    UNIVERSE = 2
}

function import_enum_galaxy()
    return enum_galaxy
end

-----
----- TEST FUNCTION
-----

function setAllStargatesIntoDevMode()
    MW_RING_SPEED = 0    -- milkyway gate ring rotation speed [ms per symbol]; default 600
    MW_RING_CHEVRON_LOCK = 50 -- milkyway gate chevron lock time [ms]; default 750
    MW_RING_CHEVRON_LOCK_AE = 50 -- milkyway gate chevron unlock time [ms]; default 550
    MW_RING_ROTATE_PAUSE = 250 -- milkyway gate ring rotation pause after chevron lock [ms]; default 1250
    MW_INCOMING_CHVRN_DELAY = 1200 -- milkyway gate incoming wormhole chevron activate delay between activation [ms]; default 1200
    MW_WORMHOLE_CREATE_DELAY = 500 -- milkyway gate wormhole creation delay (after succesful link) [ms]; default 500
    GATE_OPEN_DELAY = 200
    
    SG_WORMHOLE_OPEN_TIME = 5  -- stargate classic wormhole open time [s]; default 38
end

-----
----- INIT
-----

-- script begin/init
function initServer(startedResource)
end
addEvent("clientStartedEvent", true)
addEventHandler("clientStartedEvent", resourceRoot, initServer)

-----
----- GENERAL
-----

-- function for creating stargate

-- REQUIRED PARAMETERS:
--> gateType
--- model of stargate (determined by galaxy; see enum_stargateGalaxy)
--> x, y, z gate position
--> address
--- stargate address in format of array/table {s1, s2, s3, ... sn};
--- sn represents one symbol on SG in number from 0 to 38 (beginning from point of origin)

-- OPTIONAL PARAMETERS:
--> defaultDialType refers to dial type this gate will use by default
--- default if not specified: enum_stargateDialType.FAST
--> rx, ry, rz gate rotation
--- rx  horizontal rotation     [0->normal; 90->lying on ground, pointing up; ...]
--- ry  gate object rotation    [0->symbol 0 at top; 360/38*15-> symbol 15 at top; ...]
--- rz  vertical rotation       [0->facing north; 90->facing west; ...]
--- default if not specified: 0
--> isGrounded determines if stargate is facing ground or other object that will prevent it to be used
--- default if not specified: false or true if rx is between 240 and 300
--> forceDefaultDialType - if this is enabled, defaultDialType will be forced
--- default if not specified: true
function stargate_create(gateType, dimension, x, y, z, address, defaultDialType, rx, ry, rz, isGrounded, forceDefaultDialType)
    if not rx then
        rx = 0
    end
    if not ry then
        ry = 0
    end
    if not rz then
        rz = 0
    end
    
    local dt = defaultDialType
    if not defaultDialType then
        dt = enum_stargateDialType.FAST
    end
    if not forceDefaultDialType then
        forceDefaultDialType = true
    end

    local stargate = createObject(1337, x, y, z, rx, ry, rz)
    local id = stargate_assignID(stargate)
    stargate_setAddress(id, address)
    stargate_setDefaultDialType(id, dt)
    stargate_setForceDialType(id, forceDefaultDialType)
    planet_setElementOccupiedPlanet(stargate, "PLANET_"..dimension)
    stargate_addCollisions(id)
    

    if gateType == enum_galaxy.MILKYWAY then
        stargate_ring_create(id, x, y, z, rx, ry, rz)
        stargate_galaxy_set(id, "milkyway")
    end
    
    for i=1,9 do
        stargate_chevron_create(id, i)
    end
    for i=1,12 do
        stargate_vortex_create(id, i)
    end
    for i=1,6 do
        stargate_horizon_create(id, i)
    end

    if not isGrounded then
        isGrounded = false
    end

    if not isGrounded then
        isGrounded = false
        if rx > 240 and rx < 300 then
            isGrounded = true
        end
    end
    stargate_setGrounded(id, isGrounded)
    stargate_setAssignedDHD(id, nil)
    outputDebugString("Created Stargate (ID="..tostring(getElementID(stargate)).." galaxy="..tostring(stargate_galaxy_get(id))..") at "..tostring(x)..","..tostring(y)..","..tostring(z).."")
    return stargate
end

-- remove stargate
function stargate_remove(stargateID)
    outputChatBox("This function (stargate_remove) is not implemented yet!")
end

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

-- translation of SG address to SG ID
-- expecting index of some stargate, which will "do" the conversion
-- expecting addressArray {} index represents numerical value of one symbol; indexing from 1
-- returning ID of StarGate or false if invalid
function stargate_convertAddressToID(id, addressArray)
    for i, sg in pairs(stargate_galaxy_getAllElements(id)) do
        local sg_id = stargate_getID(sg)
        local sg_addr = stargate_getAddress(sg_id)
        if array_equal(addressArray, sg_addr) then
            return sg_id
        end
    end
    return false
end

-----
----- DIAL PROCESS
-----

enum_stargateDialType = {
    SLOW = 0,
    FAST = 1,
    INSTANT = 2
}

function import_enum_stargateDialType()
    return (enum_stargateDialType)
end

-- dialling process of stargate
-- returns true if ok; false if stargate is already active (and wont dial)
function stargate_dial(stargateIDFrom, addressArray, stargateDialType)
    local stargateIDTo = stargate_convertAddressToID(stargateIDFrom, addressArray)

    if stargate_isActive(stargateIDFrom) then
        outputChatBox("[STARGATE ("..stargateIDFrom..")]: WHOA! I wont dial, im doing something rn!")
        return false
    end
    if stargate_getGrounded(stargateIDFrom) then
        stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.GATE_GROUNDED, false)
        return false
    end

    stargate_setDialAddress(stargateIDFrom, addressArray)
    stargate_setActive(stargateIDFrom, true)
    local dt = stargateDialType
    if not stargateDialType or stargate_getForceDialType(stargateIDFrom) == true then
        dt = stargate_getDefaultDialType(stargateIDFrom)
    end
    local totalTime = stargate_diallingAnimation(stargateIDFrom, dt)
    if not totalTime then
        stargate_setDialAddress(stargateIDFrom, nil)
        stargate_setActive(stargateIDFrom, false)
        return false
    end

    stargate_setConnectionID(stargateIDFrom, stargateIDTo)
    if stargateIDTo then -- may success
        local result = stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
        if result == enum_stargateStatus.GATE_DISABLED then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        elseif result == enum_stargateStatus.GATE_GROUNDED then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        elseif result == enum_stargateStatus.DIAL_SELF then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        else
            setTimer(stargate_wormhole_secureConnection, totalTime, 1, stargateIDFrom, stargateIDTo)
        end
    else -- will surely fail
        setTimer(stargate_diallingFailed, totalTime, 1, stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_UNKNOWN_ADDRESS)
    end

    return true
end

-- dial stargate by ID
function stargate_dialByID(stargateIDFrom, stargateIDTo, stargateDialType)
    local address = stargate_getAddress(stargateIDTo)
    return (stargate_dial(stargateIDFrom, address, stargateDialType))
end

-- dial failed
function stargate_diallingFailed(stargateIDFrom, stargateIDTo, reason, dontPlaySound)
    local id = stargateIDFrom
    local arrow = "to"
    if reason == enum_stargateStatus.DIAL_GATE_INCOMING then
        id = stargateIDTo
        arrow = "from"
    end

    if not dontPlaySound then
        stargate_sound_play(id, enum_soundDescription.GATE_DIAL_FAIL)
    end
    
    setTimer(stargate_setAllChevronsActive, MW_DIAL_FAIL_CHVRN_DELAY, 1, id, false, false)
    stargate_setDialAddress(id, nil)
    stargate_setActive(id, false)
    outputChatBox("[STARGATE ("..tostring(stargateIDFrom)..")] Dialling "..arrow.." "..tostring(stargateIDTo).." failed. ("..enum_stargateStatus.toString(reason)..")")
end


-----
----- ANIMATION
-----

-- milkyway gate ring rotation
function stargate_animateOutgoingDial(stargateID, symbol, chevron, lastChevron)
    local ring = stargate_getRingElement(stargateID)
    local stargate = stargate_getElement(stargateID)
    local x, y, z, rx, ry, rz = getElementAttachedOffsets(ring)
    local oneSymbolAngle = 360/39
    local currentSymbol = ry/oneSymbolAngle
    local symbolDistance = 0
    local clockWise = true
    if currentSymbol < symbol then
        symbolDistance = symbol-currentSymbol
    else
        symbolDistance = currentSymbol-symbol
        clockWise = false
    end
    -- start rotating
    stargate_ring_setRotating(stargateID, true)
    local timeTook = stargate_ring_rotateSymbols(ring, clockWise, symbolDistance)
    setTimer(stargate_sound_play, MW_RING_SPEED, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
    setElementData(ring, "rotationTime", MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)

    -- top chevron after symbol reached
    setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, 7, true)
    if not lastChevron then
        setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE, 1, stargateID, 7, false)
        setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK, 1, stargateID, chevron, true)
    end
    -- engaged chevron after symbol reached
    setTimer(stargate_ring_setRotating, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, false)
    setTimer(stargate_sound_stop, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
    setTimer(stargate_sound_play, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
end

-- stargate address dialling animation
function stargate_diallingAnimation(stargateID, stargateDialType)
    local t = 50
    local symbol_target = nil
    local symbol_f_current = nil
    local timer = nil
    if stargateDialType == enum_stargateDialType.SLOW then
        for i=1,7 do
            if i == 1 then
                symbol_f_current = stargate_ring_getCurrentSymbol(stargateID)
            else
                symbol_f_current = stargate_getAddressSymbol(stargate_getDialAddress(stargateID), i-1)
            end

            symbol_target = stargate_getAddressSymbol(stargate_getDialAddress(stargateID), i)
            if i == 7 then
                timer = setTimer(stargate_animateOutgoingDial, t, 1, stargateID, symbol_target, i, true)
            else
                timer = setTimer(stargate_animateOutgoingDial, t, 1, stargateID, symbol_target, i)
            end
            setElementData(stargate_getElement(stargateID), "rot_anim_timer_"..tostring(i), timer)
            t = t + stargate_ring_getSymbolRotationTime(symbol_f_current, symbol_target) + MW_RING_CHEVRON_LOCK_SLOW_DELAY*1.5
            if i == 7 then
                t = t - MW_RING_CHEVRON_LOCK_SLOW_DELAY/7
            end

            if getElementData(stargate_getElement(stargateID), "dial_failed") == true then
                return false
            end
        end
    elseif stargateDialType == enum_stargateDialType.INSTANT then
        t = 500
        stargate_sound_play(stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
        setTimer(stargate_setAllChevronsActive, t, 1, stargateID, false, true)
    elseif stargateDialType == enum_stargateDialType.FAST then
        local ring = stargate_getRingElement(stargateID)
        local stargate = stargate_getElement(stargateID)
        local x, y, z, rx, ry, rz = getElementAttachedOffsets(ring)
        local oneSymbolAngle = 360/39
        local currentSymbol = ry/oneSymbolAngle
        local symbolDistance = 0
        local clockWise = true
        local symbol = currentSymbol + 16
        if symbol > 39 then
            symbol = symbol - 39
        end
        if currentSymbol < symbol then
            symbolDistance = symbol-currentSymbol
        else
            symbolDistance = currentSymbol-symbol
            clockWise = false
        end
        -- start rotating
        setTimer(stargate_sound_play, MW_RING_SPEED*2, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
        stargate_ring_setRotating(stargateID, true)
        local timeTook = stargate_ring_rotateSymbols(ring, clockWise, symbolDistance)
        setElementData(ring, "rotationTime", timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)
    
        local delay = MW_FASTDIAL_START_DELAY
        for i=1,7 do
            setTimer(stargate_chevron_setActive, delay, 1, stargateID, i, true, true)
            delay = delay + MW_FASTDIAL_CHEVRON_DELAY
        end
        setTimer(stargate_ring_setRotating, timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, false)
        setTimer(stargate_sound_stop, MW_RING_CHEVRON_LOCK_FAST_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
        setTimer(stargate_sound_play, timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE+MW_RING_CHEVRON_LOCK_FAST_DELAY, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
        t = timeTook + MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE+ MW_WORMHOLE_CREATE_DELAY*6
    else
        outputDebugString("Stargate "..stargateID.." tried to dial in unsupported dial mode "..tostring(stargate_dialType))
        return false
    end
    return t
end
-----
----- GETTERS/SETTERS
-----

-- returns gate ring element 
function stargate_getRingElement(id)
    return (stargate_ring_getElement(id.."R"))
end

-- assigns new ID to NEW stargate
function stargate_assignID(stargate)
    if LastMWGateID == nil then
        LastMWGateID = 0
    end
    LastMWGateID = LastMWGateID + 1
    local newID = "SG_MW_"..tostring(LastMWGateID)
    setElementID(stargate, newID)
    return newID
end

function stargate_getID(stargate)
    return (getElementID(stargate))
end

function stargate_setID(id, newID)
    setElementID(stargate_getElement(id), newID)
end

-- returns stargate element
function stargate_getElement(id)
    return (getElementByID(id))
end

function stargate_setAddress(id, address)
    setElementData(stargate_getElement(id), "address", address)
end

-- turn on all chevrons
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

function stargate_getChevron(id, chevronNumber)
    return getElementByID(id.."C"..tostring(chevronNumber))
end

function stargate_getKawoosh(id, kawooshNumber)
    return getElementByID(id.."V"..tostring(kawooshNumber))
end

function stargate_getHorizon(id, horizonNumber)
    return getElementByID(id.."H"..tostring(horizonNumber))
end

function stargate_getHorizonActivation(id, horizonNumber)
    return getElementByID(id.."HA"..tostring(horizonNumber))
end

function stargate_isActive(stargateID)
    return getElementData(getElementByID(stargateID), "active")
end

function stargate_isDisabled(stargateID)
    return getElementData(getElementByID(stargateID), "disabled")
end

function stargate_isOpen(stargateID)
    return getElementData(getElementByID(stargateID), "open")
end

function stargate_setDisabled(stargateID, disabled)
    return setElementData(getElementByID(stargateID), "disabled", disabled)
end

function stargate_setOpen(stargateID, open)
    return setElementData(getElementByID(stargateID), "open", open)
end

function stargate_setActive(stargateID, active)
    return setElementData(getElementByID(stargateID), "active", active)
end

function stargate_getDialAddress(stargateID)
    return getElementData(getElementByID(stargateID), "diallingAddress")
end

function stargate_getAddressSymbol(address, symbol)
    return address[symbol]
end

function stargate_setDialAddress(stargateID, address)
    return setElementData(getElementByID(stargateID), "diallingAddress", address)
end

function stargate_getConnectionID(stargateID)
    return (getElementData(getElementByID(stargateID), "connectionID"))
end

function stargate_setConnectionID(stargateID, id)
    return setElementData(getElementByID(stargateID), "connectionID", id)
end

function stargate_getAddress(stargateID)
    return getElementData(getElementByID(stargateID), "address")
end

function stargate_getPosition(stargateID)
    local x, y, z = getElementPosition(stargate_getElement(stargateID))
    return x, y, z
end

function stargate_getRotation(stargateID)
    local x, y, z = getElementRotation(stargate_getElement(stargateID))
    return x, y, z
end

function stargate_getIncomingStatus(stargateID) 
    return getElementData(getElementByID(stargateID), "incomingStatus")
end

function stargate_setIncomingStatus(stargateID, status) 
    return setElementData(getElementByID(stargateID), "incomingStatus", status)
end

function stargate_setPosition(stargateID, nx, ny, nz)
    setElementPosition(stargate_getElement(stargateID), nx, ny, nz)
    if stargate_galaxy_get(stargateID) == "milkyway" then
        setElementPosition(stargate_getRingElement(stargateID), nx, ny, nz)
    end 
end

function stargate_setCloseTimer(stargateID, timer)
    setElementData(getElementByID(stargateID), "closeTimer", timer)
end

function stargate_getCloseTimer(stargateID)
    getElementData(getElementByID(stargateID), "closeTimer")
end

function stargate_setDefaultDialType(id, defaultDialType)
    setElementData(stargate_getElement(id), "defaultDialType", defaultDialType)
end

function stargate_getDefaultDialType(id)
    return (getElementData(stargate_getElement(id), "defaultDialType"))
end

function stargate_setGrounded(id, v)
    return (setElementData(stargate_getElement(id), "isGrounded", v))
end

function stargate_getGrounded(id)
    return (getElementData(stargate_getElement(id), "isGrounded"))
end

function stargate_setForceDialType(id, v)
    return (setElementData(stargate_getElement(id), "forceDialType", v))
end

function stargate_getForceDialType(id)
    return (getElementData(stargate_getElement(id), "forceDialType"))
end

function stargate_setAssignedDHD(id, v)
    return (setElementData(stargate_getElement(id), "assignedDHD", v))
end

function stargate_getAssignedDHD(id)
    return (getElementData(stargate_getElement(id), "assignedDHD"))
end

-- returns remaining time wormhole will be open in miliseconds or nil
function stargate_getWormholeTimeRemaining(stargateID)
    local timer = stargate_getCloseTimer(stargateID)
    if isTimer(timer) then
        local r = getTimerDetails(timer)
        return r
    else
        return nil
    end
end

function stargate_isValidAttribute(stargateID, attribute)
    if getElementData(getElementByID(stargateID), attribute) == nil then
        outputChatBox("no! "..stargateID.." hasnt "..attribute)
        return false
    else
        outputChatBox("yes")
        return true
    end
end

function stargate_getGateModel(type)
    if type == "MW" then
        return MWID
    end
end

function stargate_getGalaxy(id)
    return (getElementData(stargate_getElement(id), "galaxy"))
end