--- gate_s.lua_ Core serverside module for stargates and their logic script

---
--- Global variables
---

-- constants
MW_RING_SPEED = 600    -- milkyway gate ring rotation speed [ms per symbol]; default 600
MW_RING_CHEVRON_LOCK = 750 -- milkyway gate chevron lock time [ms]; default 750
MW_RING_CHEVRON_LOCK_AE = 550 -- milkyway gate chevron unlock time [ms]; default 550
MW_RING_ROTATE_PAUSE = 1250 -- milkyway gate ring rotation pause after chevron lock [ms]; default 1250
MW_INCOMING_CHVRN_DELAY = 1200 -- milkyway gate incoming wormhole chevron activate delay between activation [ms]; default 1200
MW_WORMHOLE_CREATE_DELAY = 500 -- milkyway gate wormhole creation delay (after succesful link) [ms]; default 500
MW_DIAL_FAIL_CHVRN_DELAY = 3000 -- milkyway gate chevrons turn off delay after dial failed [ms]; default 3000
MW_FASTDIAL_START_DELAY = 2500  -- milkyway gate fast dial begin delay [ms]; default 2500
MW_FASTDIAL_CHEVRON_DELAY = 1000 -- milkway gate fast dial chevron encode delay [ms]; default 1000

GATE_OPEN_DELAY = 200

SG_WORMHOLE_OPEN_TIME = 38  -- stargate classic wormhole open time [s]; default 38
SG_VORTEX_ANIM_SPEED = 115 -- stargate vortex opening animation speed [ms]; default 115
SG_HORIZON_ANIMATION_SPEED = 100 -- stargate horizon animation change speed [ms]; default 100; recommended 100-200

-- variable constants
SG_HORIZON_ANIMATION_BEGIN = SG_HORIZON_ANIMATION_SPEED*3,5

-- global variables
MWID = nil
MWID_r = nil
MWID_c = {}
MWID_c_last = 0
LastMWGateID = nil
MW_Horizon = {}
MW_Horizon_last = 0

SG_Kawoosh = {}
SG_Kawoosh_last = 0

SG_MW = nil

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
    DIAL_GATE_INCOMING_TOGATE = -4,
    DIAL_GATE_INCOMING = -3,
    DIAL_UNKNOWN_ADDRESS = -2,
    UNKNOWN = -1,

    GATE_IDLE = 0,
    GATE_ACTIVE = 1,
    GATE_OPEN = 2,
    GATE_DISABLED = 3
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
    elseif v == enum_stargateStatus.DIAL_UNKNOWN_ADDRESS then
        return "Unknown address"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING then
        return "Incoming wormhole"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING_TOGATE then
        return "Incoming wormhole (fromgate)"
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


function testFunc(playerSource, commandName, arg1, arg2, arg3)
    --setAllStargatesIntoDevMode()
    if arg3 == "slow" then
        arg3 = enum_stargateDialType.SLOW
    elseif arg3 == "fast" then 
        arg3 = enum_stargateDialType.FAST
    else
        arg3 = enum_stargateDialType.INSTANT
    end

    outputChatBox("Dialling "..arg1.."->"..arg2.." ["..arg3.." mode]")
    stargate_dialByID("SG_MW_"..arg1, "SG_MW_"..arg2, arg3)
end
addCommandHandler("work", testFunc)
    

-----
----- INIT
-----

-- script begin/init
function initServer(startedResource)
	outputChatBox("GATE: Resource gate started - test functions started.")
    loadModels()
end
addEvent("clientStartedEvent", true)
addEventHandler("clientStartedEvent", resourceRoot, initServer)

-- initialize models
function initModels()
    if array_size(SG_MW) < 1 then
        outputDebugString("GATE: No stargates detected", 2)
    end
    triggerClientEvent("onServerGateLoaded", root, SG_MW)

    for i,sg in pairs(SG_MW) do
        local id = stargate_getID(sg)
        local ringID = stargate_ring_getID(stargate_getRingElement(id))
        stargate_setModel(id, MWID)
        stargate_ring_setModel(ringID, MWID_r)
    end
end
addEvent("gateSpawnerActive", true)
addEventHandler("gateSpawnerActive", resourceRoot, initModels)

-----
----- GENERAL
-----

-- create stargate element
-- required_ gateType; position [x,y,z], address
-- address in format {s1, s2, s3, ... sn};
-- rx, ry, rz not supported yet
-- sn represents one symbol on SG in number from 0 to 38 (beginning from point of origin; ring rotation=0)
function stargate_create(gateType, x, y, z, address, defaultDialType, rx, ry, rz)
    if not rx then
        rx = 0
    end
    if not ry then
        ry = 0
    end
    if not rz then
        rz = 0
    end

    -- force 0 
    rx = 0
    ry = 0
    rz = 0
    local stargate = createObject(1337, x, y, z, rx, ry, rz)
    local id = stargate_assignID(stargate)
    stargate_setAddress(id, address)
    stargate_addCollisions(id)

    if gateType == enum_galaxy.MILKYWAY then
        stargate_ring_create(id, x, y, z, rx, ry, rz)
        stargate_galaxy_set(id, "milkyway")
        local dt = defaultDialType
        if not defaultDialType then
            dt = enum_stargateDialType.FAST
        end
        stargate_setDefaultDialType(id, dt)
    end
    outputDebugString("Created Stargate (ID="..tostring(getElementID(stargate)).." galaxy="..tostring(stargate_galaxy_get(id))..") at "..tostring(x)..","..tostring(y)..","..tostring(z).."")
end

-- remove stargate
function stargate_remove(stargateID)
    outputChatBox("This function (stargate_remove) is not implemented yet!")
end

function stargate_addCollisions(id)
    setElementCollisionsEnabled(stargate_getElement(id), false)
    x, y, z = stargate_getPosition(id)
    local col_w stargate_addCollisionObject(id, x+2.1, y, z, 0, "W")
    local col_e = stargate_addCollisionObject(id, x-2.1, y, z, 0, "E")
    local col_n = stargate_addCollisionObject(id, x, y, z+2.1, 90, "N")
    local col_s = stargate_addCollisionObject(id, x, y, z-2.1, 90, "S")
    local col_ne = stargate_addCollisionObject(id, x-1.5, y, z+1.5, 45, "NE")
    local col_nw = stargate_addCollisionObject(id, x+1.5, y, z+1.5, -45, "NW")
    local col_se = stargate_addCollisionObject(id, x+1.5, y, z-1.5, 45, "SW")
    local col_sw = stargate_addCollisionObject(id, x-1.5, y, z-1.5, -45, "SE")
end

function stargate_addCollisionObject(id, x, y, z, ry, desc)
    local srx, sry, srz = getElementRotation(stargate_getElement(id))
    local collisionObject = createObject(9131, x, y, z, srx+0, sry+ry, srz+0)
    setElementID(collisionObject, id.."COLOBJ."..desc)
    setElementAlpha(collisionObject, 0)
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
    if stargate_isActive(stargateIDFrom) then
        outputChatBox("Wont dial, im active!")
        return false
    end

    stargate_setDialAddress(stargateIDFrom, addressArray)
    stargate_setActive(stargateIDFrom, true)
    local dt = stargateDialType
    if not stargateDialType then
        dt = stargate_getDefaultDialType(stargateIDFrom)
    end
    local totalTime = stargate_diallingAnimation(stargateIDFrom, dt)
    if not totalTime then
        stargate_setDialAddress(stargateIDFrom, nil)
        stargate_setActive(stargateIDFrom, false)
        return false
    end

    local stargateIDTo = stargate_convertAddressToID(stargateIDFrom, addressArray)
    stargate_setConnectionID(stargateIDFrom, stargateIDTo)
    if stargateIDTo then -- may success
        local result = stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
        if result == enum_stargateStatus.GATE_DISABLED then
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
    local arrow = "->"
    if reason == enum_stargateStatus.DIAL_GATE_INCOMING then
        id = stargateIDTo
        arrow = "<-"
    end

    if not dontPlaySound then
        stargate_sound_play(id, enum_soundDescription.GATE_DIAL_FAIL)
    end
    
    setTimer(stargate_setAllChevronsActive, MW_DIAL_FAIL_CHVRN_DELAY, 1, id, false, false)
    stargate_setDialAddress(id, nil)
    stargate_setActive(id, false)
    outputChatBox("Dialing "..tostring(stargateIDFrom)..arrow..tostring(stargateIDTo).." failed. ("..enum_stargateStatus.toString(reason)..")")
end


-----
----- ANIMATION
-----

-- milkyway gate ring rotation
function stargate_animateOutgoingDial(stargateID, symbol, chevron, lastChevron)
    local ring = stargate_getRingElement(stargateID)
    local stargate = stargate_getElement(stargateID)
    local x, y, z = getElementPosition(ring)
    local rx, ry, rz = getElementRotation(ring)
    local oneSymbolAngle = 360/39
    local currentSymbol = ry/oneSymbolAngle
    local symbolDistance = 0
    local np = 1
    if currentSymbol < symbol then
        symbolDistance = symbol-currentSymbol
    else
        symbolDistance = currentSymbol-symbol
        np = -1
    end
    -- start rotating
    stargate_sound_play(stargateID, enum_soundDescription.GATE_RING_ROTATE)
    stargate_ring_setRotating(stargateID, true)
    setElementData(ring, "rotationTime", MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)
    moveObject(ring, MW_RING_SPEED*symbolDistance, x, y, z, rx, np*oneSymbolAngle*symbolDistance, rz)

    -- top chevron after symbol reached
    setTimer(stargate_chevron_setActive, MW_RING_SPEED*symbolDistance, 1, stargateID, 7, true)
    if not lastChevron then
        setTimer(stargate_chevron_setActive, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE, 1, stargateID, 7, false)
        setTimer(stargate_chevron_setActive, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK, 1, stargateID, chevron, true)
    end
    -- engaged chevron after symbol reached
    setTimer(stargate_ring_setRotating, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, false)
    setTimer(stargate_sound_stop, MW_RING_SPEED*symbolDistance, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
    setTimer(stargate_sound_play, MW_RING_SPEED*symbolDistance, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
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
                timer =setTimer(stargate_animateOutgoingDial, t, 1, stargateID, symbol_target, i, true)
            else
                timer = setTimer(stargate_animateOutgoingDial, t, 1, stargateID, symbol_target, i)
            end
            setElementData(stargate_getElement(stargateID), "rot_anim_timer_"..tostring(i), timer)
            t = t + stargate_ring_getSymbolRotationTime(symbol_f_current, symbol_target)
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
        local x, y, z = getElementPosition(ring)
        local rx, ry, rz = getElementRotation(ring)
        local oneSymbolAngle = 360/39
        local currentSymbol = ry/oneSymbolAngle
        local symbolDistance = 16
        -- start rotating
        stargate_sound_play(stargateID, enum_soundDescription.GATE_RING_ROTATE)
        stargate_ring_setRotating(stargateID, true)
        setElementData(ring, "rotationTime", MW_RING_SPEED*600*7)
        moveObject(ring, MW_RING_SPEED*symbolDistance, x, y, z, rx, oneSymbolAngle*symbolDistance, rz)

        local delay = MW_FASTDIAL_START_DELAY
        for i=1,7 do
            setTimer(stargate_chevron_setActive, delay, 1, stargateID, i, true, true)
            delay = delay + MW_FASTDIAL_CHEVRON_DELAY
        end
        setTimer(stargate_ring_setRotating, MW_RING_SPEED*symbolDistance, 1, stargateID, false)
        setTimer(stargate_sound_stop, MW_RING_SPEED*symbolDistance, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
        setTimer(stargate_sound_play, MW_RING_SPEED*symbolDistance, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
        t = MW_RING_SPEED*symbolDistance + MW_WORMHOLE_CREATE_DELAY*2
    else
        outputDebugString("Stargate "..stargateID.." tried to dial in unsupported dial mode "..tostring(stargate_dialType))
        return false
    end
    return t
end

-- create unstable vortex and horizon at stargate
-- returns time needed for animation
function stargate_animateOpening(stargateID)
    local x, y, z = stargate_getPosition(stargateID)
    local vortex = stargate_vortex_create(stargateID, x, y, z)
    local horizon = stargate_horizon_create(stargateID, x, y, z)
    local killZone = stargate_marker_create(x, y+2.6, z, "corona", 3, 25, 90 ,200, 25, enum_markerType.VORTEX, stargateID)
    return (stargate_vortex_animate(stargateID))
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

function stargate_setModel(id, modelID, colPath)
    triggerClientEvent("setElementModelClient", resourceRoot, stargate_getElement(id), modelID, colPath)
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

-- returns chevron if chevron is active or nil
function stargate_getChevron(id, chevronNumber)
    return getElementByID(id.."C"..tostring(chevronNumber))
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