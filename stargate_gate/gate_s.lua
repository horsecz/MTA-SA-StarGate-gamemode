--- gate_s.lua: StarGate gamemode part script - server-side operations and stargate logic
---
--- Global variables
---

-- constants
MW_RING_SPEED = 50     -- milkyway gate ring rotation speed [ms per symbol]; default 600
MW_RING_CHEVRON_LOCK = 750 -- milkyway gate chevron lock time [ms]; default 750
MW_RING_CHEVRON_LOCK_AE = 550 -- milkyway gate chevron unlock time [ms]; default 550
MW_RING_ROTATE_PAUSE = 1250 -- milkyway gate ring rotation pause after chevron lock [ms]; default 1250
MW_INCOMING_CHVRN_DELAY = 1200 -- milkyway gate incoming wormhole chevron activate delay between activation [ms]; default 1200
MW_WORMHOLE_CREATE_DELAY = 700 -- milkyway gate wormhole creation delay (after succesful link) [ms]; default 700

SG_WORMHOLE_OPEN_TIME = 20  -- stargate classic wormhole open time [s]; default 38
SG_VORTEX_ANIM_SPEED = 115 -- stargate vortex opening animation speed [ms]; default 115
SG_HORIZON_ANIMATION_SPEED = 100 -- stargate horizon animation change speed [ms]; default 100; recommended 100-200

-- variable constants
SG_HORIZON_ANIMATION_BEGIN = SG_HORIZON_ANIMATION_SPEED*3,5

-- global vars
MWID = nil
MWID_r = nil
MWID_c = {}
MWID_c_last = 0
LastMWGateID = nil
MW_Horizon = {}
MW_Horizon_last = 0

SG_Kawoosh = {}
SG_Kawoosh_last = 0

SG_MW_CNT = 0

SG_WM_OPEN_LIST = {}
SG_WM_OPEN_LIST_Last = 0

----
---- TODO; Insert into global script/gamemode or other scripts
----
-- init/spawn all gates on map at the beginning
function spawnAllStargates()
    createStargate(MWID, 0, 0, 4, {15,11,9,19,25,32,0})
    createStargate(MWID, 20, 0, 4, {1,3,5,7,9,11,0})
    createStargate(MWID, -20, 0, 4, {1,2,3,4,5,6,0})
end

-- test function
function testFunc(playerSource, commandName)
    outputChatBox("Dialling random address")
    stargateDialID("SG_MW_1", "SG_MW_2")
    stargateDialID("SG_MW_3", "SG_MW_1")
end
addCommandHandler("work", testFunc)

-- global function for calling function from client-side
function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    -- If the clientside event handler is not in the same resource, replace 'resourceRoot' with the appropriate element
    triggerClientEvent("onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end

-- active wait function
function wait(time)
    current = getTickCount()
    final = current + time
    while current < final do current = getTickCount() end
end

-- tests equality of two "arrays"
function arraysEqual(array1, array2)
    return table.concat(array1) == table.concat(array2)
end
----
----
----

---
--- Initializing functions
---


-- script begin/init
function onResourceStart(startedResource)
	outputChatBox("[SG] Resource gate started - test functions started.")
    loadModels()
end
addEvent("clientStartedEvent", true)
addEventHandler("clientStartedEvent", resourceRoot, onResourceStart)

-- load custom models
function loadModels()
    callClientFunction(source, "loadMWModel")
    outputDebugString("INIT: Loading models: SGMW")
end

---
--- Model and textures functions
---

function setMWModelID(id)
    MWID = id
    callClientFunction(source, "loadMWModelRing")
    outputDebugString("INIT: Loading models: SGMW-Ring")
end
addEvent("MWModelLoaded", true)
addEventHandler("MWModelLoaded", resourceRoot, setMWModelID)

function setMWModelRingID(id)
    MWID_r = id
    callClientFunction(source, "loadMWModelChevrons")
    outputDebugString("INIT: Loading models: SGMW-Chevrons")
end
addEvent("MWModelRingLoaded", true)
addEventHandler("MWModelRingLoaded", resourceRoot, setMWModelRingID)

function setMWModelChevronID(id)
    newArrayElementI = MWID_c_last + 1
    MWID_c_last = MWID_c_last + 1
    MWID_c[newArrayElementI] = id
    if newArrayElementI < 9 then
        callClientFunction(source, "loadMWModelChevrons")
    else
        outputDebugString("INIT: Loading models: SGMW-Horizon")
        callClientFunction(source, "loadMWModelHorizon")
    end
end
addEvent("MWModelChevronLoaded", true)
addEventHandler("MWModelChevronLoaded", resourceRoot, setMWModelChevronID)

function setMWModelHorizonID(id)
    newArrayElementI = MW_Horizon_last + 1
    MW_Horizon_last = MW_Horizon_last + 1
    MW_Horizon[newArrayElementI] = id
    if newArrayElementI < 6 then
        callClientFunction(source, "loadMWModelHorizon")
    else
        outputDebugString("INIT: Loading models: SG-Kawoosh")
        callClientFunction(source, "loadModelKawoosh")
    end
end
addEvent("MWModelHorizonLoaded", true)
addEventHandler("MWModelHorizonLoaded", resourceRoot, setMWModelHorizonID)

function setKawooshModelID(id)
    newArrayElementI = SG_Kawoosh_last + 1
    SG_Kawoosh_last = SG_Kawoosh_last + 1
    SG_Kawoosh[newArrayElementI] = id
    if newArrayElementI < 12 then
        callClientFunction(source, "loadModelKawoosh")
    else
        spawnAllStargates()
    end
end
addEvent("ModelKawooshLoaded", true)
addEventHandler("ModelKawooshLoaded", resourceRoot, setKawooshModelID)

---
--- StarGate functions and operations
---

-- create stargate element
-- required: modelID; position [x,y,z], address
-- address in format {s1, s2, s3, ... sn};
-- sn represents one symbol on SG in number from 0 to 38 (beginning from point of origin; ring rotation=0)
function createStargate(modelID, x, y, z, address)
    stargate = createObject(1337, x, y, z)
    if LastMWGateID == nil then
        LastMWGateID = 0
    end
    LastMWGateID = LastMWGateID + 1
    setElementID(stargate, "SG_MW_"..tostring(LastMWGateID))
    setElementData(stargate, "address", address)
    setElementCollisionsEnabled(stargate, false)
    triggerClientEvent("setElementModelClient", resourceRoot, stargate, modelID)
    if modelID == MWID then
        ring = createObject(1377, x, y, z)
        setElementID(ring, "SG_MW_"..tostring(LastMWGateID).."R")
        setElementCollisionsEnabled(ring, false)
        setElementData(ring, "rotationTime", 0)
        triggerClientEvent("setElementModelClient", resourceRoot, ring, MWID_r)
    end
    
    SG_MW_CNT = SG_MW_CNT + 1
    outputDebugString("Created Stargate (ID="..tostring(getElementID(stargate)).." model="..tostring(modelID)..") at "..tostring(x)..","..tostring(y)..","..tostring(z).."")
end

-- precalculate ring rotation time on MWSG
function stargateCalculateRingRotationTime(symbol_a, symbol_b)
    oneSymbolAngle = 360/39
    currentSymbol = symbol_a
    if currentSymbol < symbol_b then
        symbolDistance = symbol_b-currentSymbol
        np = 1
    else
        symbolDistance = currentSymbol-symbol_b
        np = -1
    end
    return MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE
end

-- milkyway gate ring rotation
function stargateRotate(stargateID, symbol, chevron)
    ring = getElementByID(stargateID.."R")
    x, y, z = getElementPosition(ring)
    rx, ry, rz = getElementRotation(ring)
    oneSymbolAngle = 360/39
    currentSymbol = ry/oneSymbolAngle
    if currentSymbol < symbol then
        symbolDistance = symbol-currentSymbol
        np = 1
    else
        symbolDistance = currentSymbol-symbol
        np = -1
    end
    triggerClientEvent("clientPlaySound3D", root, stargateID, "sounds/mw_ring_rotate_begin.mp3", x, y, z, 150, "ringRotate")
    setElementData(getElementByID(stargateID), "isRotating", true)
    setElementData(ring, "rotationTime", MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)
    moveObject(ring, MW_RING_SPEED*symbolDistance, x, y, z, rx, np*oneSymbolAngle*symbolDistance, rz)

    -- top chevron
    setTimer(stargateChevronActive, MW_RING_SPEED*symbolDistance, 1, stargateID, 7)
    setTimer(stargateChevronInactive, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE, 1, stargateID, 7)
    -- engaged chevron
    setTimer(stargateChevronActive, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK, 1, stargateID, chevron)
    setTimer(setElementData, MW_RING_SPEED*symbolDistance+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, getElementByID(stargateID), "isRotating", false)
    setTimer(triggerClientEvent, MW_RING_SPEED*symbolDistance, 1, "clientStopSound", root, stargateID, "ringRotate")
    setTimer(triggerClientEvent, MW_RING_SPEED*symbolDistance, 1, "clientPlaySound3D", root, stargateID, "sounds/mw_chevron_lock.mp3", x, y, z, 100, "chevronEncoded")
end

-- set chevron active on SG
function stargateChevronActive(stargateID, chevron)
    stargate = getElementByID(stargateID)
    x, y, z = getElementPosition(stargate)
    newChevron = createObject(1337, x, y, z)
    setElementID(newChevron, stargateID.."C"..tostring(chevron))
    setElementCollisionsEnabled(newChevron, false)
    triggerClientEvent("setElementModelClient", resourceRoot, newChevron, MWID_c[chevron])
end

-- set chevron inactive on SG
function stargateChevronInactive(stargateID, chevron)
    destroyElement(getElementByID(stargateID.."C"..tostring(chevron)))
end

-- stargate address dialling animation
function stargateDialRotate(stargateID)
    t = 0
    stargateRotate(stargateID, stargateGetDiallingAddress(stargateID)[1], 1)
    t = t + stargateCalculateRingRotationTime(0, stargateGetDiallingAddress(stargateID)[1])

    for i=2,7 do
        setTimer(stargateRotate, t, 1, stargateID, stargateGetDiallingAddress(stargateID)[i], i)
        t = t + stargateCalculateRingRotationTime(stargateGetDiallingAddress(stargateID)[i-1], stargateGetDiallingAddress(stargateID)[i])
    end
    return t
end

-- turn on chevrons on incoming wormwhole
function stargateDialIncomingChevrons(stargateID, useDelay)
    delay = 0
    for i=1,7 do
        setTimer(stargateChevronActiveIncoming, delay, 1, stargateID, i)
        if useDelay then
            delay = delay + MW_INCOMING_CHVRN_DELAY
        else
            delay = 0
        end
    end
end

-- activate chevrons on stargate (incoming wormhole)
function stargateChevronActiveIncoming(stargateID, chevron)
    x, y, z = getElementPosition(getElementByID(stargateID))
    triggerClientEvent("clientPlaySound3D", root, stargateID, "sounds/mw_chevron_incoming.mp3", x, y, z, 150, "chevronEncoded")
    stargateChevronActive(stargateID, chevron)
end

-- dialling process of stargate
function stargateDial(stargateIDFrom, addressArray)
    setElementData(getElementByID(stargateIDFrom), "diallingAddress", addressArray)
    setElementData(getElementByID(stargateIDFrom), "active", true)
    local totalTime = stargateDialRotate(stargateIDFrom)
    local stargateIDTo = stargateAddressToID(addressArray)
    
    if stargateIDTo then -- may success
        if totalTime - MW_INCOMING_CHVRN_DELAY*7 > 50 then -- can turn on incoming chevrons slowly
            setTimer(stargateWormholePreCreate, totalTime - MW_INCOMING_CHVRN_DELAY*7, 1, stargateIDFrom, stargateIDTo, totalTime, true)
        else -- no time, turn them on all at once
            setTimer(stargateWormholePreCreate, totalTime, 1, stargateIDFrom, stargateIDTo, totalTime, false)
        end
    else -- will surely fail
        setTimer(stargateDialFail, totalTime, 1, stargateIDFrom)
    end
end

-- dial stargate by ID
function stargateDialID(stargateIDFrom, stargateIDTo)
    address = stargateIDToAddress(stargateIDTo)
    stargateDial(stargateIDFrom, address)
end

-- turn off chevrons
function stargateDialFail(stargateID)
    triggerClientEvent("clientPlaySound3D", root, stargateID, "sounds/mw_dial_fail.mp3", x, y, z, 150, "dialFail")
    for i=1,7 do
        destroyElement(getElementByID(stargateID.."C"..tostring(i)))
    end
    setElementData(getElementByID(stargateID), "diallingAddress", nil)
    setElementData(getElementByID(stargateID), "active", false)
end

-- prepare for creation of wormhole between stargates; check if it is possible to connect both gates, if yes, do connect
-- returns true if can create, otherwise false
function stargateWormholePreCreate(stargateIDFrom, stargateIDTo, totalTime, slowChevrons)
    if isStargateDisabled(stargateIDTo) then -- stargate is disabled
        if slowChevrons then
            setTimer(stargateDialFail, 1000+MW_INCOMING_CHVRN_DELAY*7 + MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, "disabled")
        else
            setTimer(stargateDialFail, 1000+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, "disabled")
        end
        return false
    end
    if isStargateActive(stargateIDTo) or isStargateOpen(stargateIDTo) then -- second sg dialling or open
        if slowChevrons then
            setTimer(stargateWormholePreCreateRepecheck, MW_INCOMING_CHVRN_DELAY*7 + MW_WORMHOLE_CREATE_DELAY - 500, 1, stargateIDFrom, stargateIDTo, totalTime, slowChevrons)
        else
            setTimer(stargateWormholePreCreateRepecheck, MW_WORMHOLE_CREATE_DELAY - 500, 1, stargateIDFrom, stargateIDTo, totalTime, slowChevrons)
        end
        return false
    end

    -- connection can be estabilished
    setElementData(getElementByID(stargateIDTo), "active", true)
    setElementData(getElementByID(stargateIDFrom), "connectedTo", stargateIDTo)
    setElementData(getElementByID(stargateIDTo), "connectedFrom", stargateIDFrom)
    setElementData(getElementByID(stargateIDTo), "diallingAddress", nil)
    if slowChevrons then -- chevrons on incoming SG will be turned on one by one
        stargateDialIncomingChevrons(stargateIDTo, slowChevrons)
        setTimer(stargateWormholeCreate, MW_INCOMING_CHVRN_DELAY*7 + MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo)
    else -- chevrons will be turned on all at once
        stargateDialIncomingChevrons(stargateIDTo, slowChevrons)
        setTimer(stargateWormholeCreate, MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo)
    end
end

-- In case that other-dialed SG is dialling (active) but not connected yet, we must check for its status again
-- before completely failing dialling process;
-- if dialed SG is still not yet open and we can estabilish connection, we get priority and interrupt its dialling;
-- 
-- connected SG == all chevrons on outgoing SG locked/encoded & any chevron on incoming SG is locked/encoded
function stargateWormholePreCreateRepecheck(stargateIDFrom, stargateIDTo, totalTime, slowChevrons)
    if isStargateOpen(stargateIDTo) then -- second stargate dialed out faster
        setTimer(stargateDialFail, 1000, 1, stargateIDFrom, "open")
        return false
    end
    if isStargateActive(stargateIDTo) and not isStargateActive(getElementData(getElementByID(stargateIDTo), "connectedTo")) then -- second stargate not open but dialling (slower)
        stargateDialFail(stargateIDTo, "incoming")
        setElementData(getElementByID(stargateIDTo), "active", true)
        setElementData(getElementByID(stargateIDFrom), "connectedTo", stargateIDTo)
        setElementData(getElementByID(stargateIDTo), "connectedFrom", stargateIDFrom)
        setElementData(getElementByID(stargateIDTo), "diallingAddress", nil)
        stargateDialIncomingChevrons(stargateIDTo, false)
        setTimer(stargateWormholeCreate, 1000, 1, stargateIDFrom, stargateIDTo)
    else -- second stargate open, dialed out faster
        setTimer(stargateDialFail, 1000, 1, stargateIDFrom, "open")
        return false
    end
end

-- create wormhole between stargates
function stargateWormholeCreate(stargateIDFrom, stargateIDTo)
    setElementData(getElementByID(stargateIDFrom), "connectedTo", stargateIDTo)
    -- opening, vortex
    x, y, z = getElementPosition(getElementByID(stargateIDFrom))
    x2, y2, z2 = getElementPosition(getElementByID(stargateIDTo))
    triggerClientEvent("clientPlaySound3D", root, stargateIDFrom, "sounds/vortex.mp3", x, y, z, 150, "vortex")
    triggerClientEvent("clientPlaySound3D", root, stargateIDFrom, "sounds/vortex.mp3", x2, y2, z2, 150, "vortex")
    stargateCreateVortexOpening(stargateIDFrom)
    vortexTime = stargateCreateVortexOpening(stargateIDTo)

    -- horizon
    hFt = setTimer(stargateHorizonAnimation, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDFrom)
    hTt = setTimer(stargateHorizonAnimation, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDTo)
    setElementData(getElementByID(stargateIDFrom), "horizonMainArray", hFt)
    setElementData(getElementByID(stargateIDTo), "horizonMainArray", hTt)

    -- teleport ability
    x, y, z = getElementPosition(getElementByID(stargateIDFrom))
    teleportFrom = createMarker(x, y, z, "corona", 1, 25, 90, 200, 190)
    setElementID(teleportFrom, stargateIDFrom.."TPM")
    setElementData(teleportFrom, "isHorizon", true)
    addEventHandler("onMarkerHit", teleportFrom, stargateTeleport)
    setTimer(setElementData, vortexTime, 1, getElementByID(stargateIDFrom), "open", true)
    setTimer(setElementData, vortexTime, 1, getElementByID(stargateIDTo), "open", true)

    -- autoclose in 38/given seconds
    closeTimer = setTimer(stargateWormholeClose, vortexTime + SG_WORMHOLE_OPEN_TIME*1000, 1, stargateIDFrom, stargateIDTo)
    setElementData(getElementByID(stargateIDFrom), "closeTimer", closeTimer)
end

-- teleport function for stargate horizon markers
function stargateTeleport(player)
    if isMarkerEventHorizon(source) then
        markerID = getElementID(source)
        stargateIDFrom = string.gsub(markerID, "(TPM)", "")
        if isStargateOpen(stargateIDFrom) then
            stargateIDTo = getElementData(getElementByID(stargateIDFrom), "connectedTo")
            x, y, z = getElementPosition(getElementByID(stargateIDFrom))
            x2, y2, z2 = getElementPosition(getElementByID(stargateIDTo))
            setElementPosition(player, x2, y2, z2)
            triggerClientEvent("clientPlaySound3D", source, stargateIDFrom, "sounds/horizon_touch.mp3", x, y, z, 75, "horizonTouch")
            triggerClientEvent("clientPlaySound3D", source, stargateIDTo, "sounds/horizon_touch.mp3", x2, y2, z2, 75, "horizonTouch")
        else
            killPlayer(player) -- stargate open but (active and) horizon marker is present = unstable vortex still present
        end
    end
end

-- killing function for stargate kawoosh-vortex markers
function stargateVortexKill(player)
    if isMarkerVortex(source) then
        killPlayer(player)
    end
end

-- close active wormhole between two SGs
function stargateWormholeClose(stargateIDFrom, stargateIDTo)
    destroyElement(getElementByID(stargateIDFrom.."TPM"))
    x, y, z = getElementPosition(getElementByID(stargateIDFrom))
    x2, y2, z2 = getElementPosition(getElementByID(stargateIDTo))
    triggerClientEvent("clientPlaySound3D", root, stargateIDFrom, "sounds/gate_close.mp3", x, y, z, 150, "gateClose")
    triggerClientEvent("clientPlaySound3D", root, stargateIDTo, "sounds/gate_close.mp3", x2, y2, z2, 150, "gateClose")

    -- disengage horizon
    setTimer(setElementAlpha, 100, 1, getElementByID(stargateIDFrom.."H"), getElementAlpha(getElementByID(stargateIDFrom.."H"))-80)
    setTimer(setElementAlpha, 100, 1, getElementByID(stargateIDTo.."H"), getElementAlpha(getElementByID(stargateIDTo.."H"))-80)
    -- turn off chevrons, horizon timers
    setTimer(function(stargateIDFrom, stargateIDTo)
        for i=1,7 do
            destroyElement(getElementByID(stargateIDFrom.."C"..tostring(i)))
            destroyElement(getElementByID(stargateIDTo.."C"..tostring(i)))
        end
        destroyElement(getElementByID(stargateIDFrom.."H"))
        destroyElement(getElementByID(stargateIDTo.."H"))
        killTimer(getElementData(getElementByID(stargateIDFrom), "horizonMainArray"))
        killTimer(getElementData(getElementByID(stargateIDTo), "horizonMainArray"))
        for i=1,6 do
            tF = getElementData(getElementByID(stargateIDFrom), "horizonArray")[i]
            if isTimer(tF) then
                killTimer(tF)
            end
            tT = getElementData(getElementByID(stargateIDTo), "horizonArray")[i]
            if isTimer(tT) then
                killTimer(tT)
            end
        end
        -- reset stargate attributes
        setElementData(getElementByID(stargateIDFrom), "active", false)
        setElementData(getElementByID(stargateIDTo), "active", false)
        setElementData(getElementByID(stargateIDFrom), "open", false)
        setElementData(getElementByID(stargateIDTo), "open", false)
    end, 3000, 1, stargateIDFrom, stargateIDTo)
end

-- create unstable vortex and horizon at stargate
function stargateCreateVortexOpening(stargateID)
    stargate = getElementByID(stargateID)
    x, y, z = getElementPosition(stargate)

    vortex = createObject(1337, x, y, z)
    horizon = createObject(1337, x, y, z)
    killZone = createMarker(x, y+2.6, z, "corona", 3, 25, 90, 200, 25)
    setElementID(killZone, stargateID.."KZM")
    addEventHandler("onMarkerHit", killZone, stargateVortexKill)

    setElementID(vortex, stargateID.."V")
    setElementID(horizon, stargateID.."H")
    setElementCollisionsEnabled(vortex, false)
    setElementCollisionsEnabled(horizon, false)
    triggerClientEvent("setElementModelClient", resourceRoot, horizon, MW_Horizon[1])

    last = 50
    for i=1,12 do
        setTimer(triggerClientEvent, last, 1, "setElementModelClient", resourceRoot, vortex, SG_Kawoosh[i])
        last = last + SG_VORTEX_ANIM_SPEED
    end
    for i=12,1,-1 do
        setTimer(triggerClientEvent, last, 1, "setElementModelClient", resourceRoot, vortex, SG_Kawoosh[i])
        last = last + SG_VORTEX_ANIM_SPEED
    end

    setTimer(destroyElement, last, 1, vortex)
    setTimer(destroyElement, last, 1, killZone)
    return last
end

-- begin animation of stargate's event horizon
function stargateHorizonAnimation(stargateID)
    horizon = getElementByID(stargateID.."H")
    h1 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*0, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[1])
    h2 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*1, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[2])
    h3 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*2, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[3])
    h4 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*3, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[4])
    h5 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*4, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[5])
    h6 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*5, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[6])
    h7 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[5])
    h8 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*7, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[4])
    h9 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*8, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[3])
    h10 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*9, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[2])
    horizonArray = {h1, h2, h3, h4, h5, h6, h7, h8, h9, h10}
    setElementData(getElementByID(stargateID), "horizonArray", horizonArray)
end

-- translation of SG address to SG ID
-- expecting addressArray {} index represents numerical value of one symbol; indexing from 1
-- returning ID of StarGate or false if invalid
function stargateAddressToID(addressArray)
    for i=1,SG_MW_CNT do
        sg_id = "SG_MW_"..tostring(i)
        sg_addr = stargateGetAddress(sg_id)
        if arraysEqual(addressArray, sg_addr) then
            return sg_id
        end
    end
    return false
end

-- vice versa as stargateAddressToID, just reversed
function stargateIDToAddress(stargateID)
    sg = getElementByID(stargateID)
    if sg == nil then
        return false
    end
    return getElementData(sg, "address")
end

---
--- Check/Get Functions
---

function isStargateRingRotating(stargateID)
    return getElementData(getElementByID(stargateID), "isRotating")
end

function isStargateActive(stargateID)
    return getElementData(getElementByID(stargateID), "active")
end

function isStargateDisabled(stargateID)
    return getElementData(getElementByID(stargateID), "disabled")
end

function isStargateOpen(stargateID)
    return getElementData(getElementByID(stargateID), "open")
end

function stargateGetRingRotationTime(stargateID)
    return getElementData(getElementByID(stargateID.."R"), "rotationTime")
end

function stargateGetDiallingAddress(stargateID)
    return getElementData(getElementByID(stargateID), "diallingAddress")
end

function stargateGetAddress(stargateID)
    return getElementData(getElementByID(stargateID), "address")
end

function isStargateAttribute(stargateID, attribute)
    if getElementData(getElementByID(stargateID), attribute) == nil then
        outputChatBox("no! "..stargateID.." hasnt "..attribute)
        return false
    else
        outputChatBox("yes")
        return true
    end
end

function isMarkerEventHorizon(marker)
    if getElementData(marker, "isHorizon") == nil then
        return false
    else
        return true
    end
end

function isMarkerVortex(marker)
    if getElementData(marker, "isVortex") == nil then
        return false
    else
        return true
    end
end