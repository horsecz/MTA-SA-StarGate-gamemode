--- gate_s.lua: Core module for stargates and their logic script; server-side

-- Function for creating new stargate
-- REQUIRED PARAMETERS:
--> gateType        enum_stargateGalaxy     model-type of stargate (determined by galaxy)
--> dimension       int                     dimension in which will stargate be created
--> x, y, z         int                     gate position in world
--> address         reference               table; stargate address in format {s1, s2, s3, ... sn};
---                                         s1, ..., sn represents one symbol on SG in number (int) from 0 to 38 (beginning from point of origin)

-- OPTIONAL PARAMETERS:
--> irisType                string                  type of iris on this stargate (accepted values: "sgc", nil)
--- default if not specified: nil
--> defaultDialType         enum_stargateDialType   refers to dial type this gate will use by default
--- default if not specified: enum_stargateDialType.FAST
--> rx, ry, rz              int                     stargate gate object rotation
---     rx  horizontal rotation     [0->normal; 90->lying on ground, pointing up; ...]
---     ry  gate object rotation    [0->symbol 0 at top; 360/38*15-> symbol 15 at top; ...]
---     rz  vertical rotation       [0->facing north; 90->facing west; ...]
--- default if not specified: 0
--> isGrounded              bool                    determines if stargate is facing ground or other object that will prevent it to be used
--- default if not specified: false; true if rx is between 240 and 300
--> forceDefaultDialType    bool                    if this is enabled, defaultDialType will be forced
--- default if not specified: true

--- RETURNS:
--> Reference; stargate element or nil if creating failed (duplicate address)
function stargate_create(gateType, dimension, x, y, z, address, irisType, defaultDialType, rx, ry, rz, isGrounded, forceDefaultDialType)
    if not rx then
        rx = 0
    end
    if not ry then
        ry = 0
    end
    if not rz then
        rz = 0
    end
    if not irisType then
        irisType = nil
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
    local existing = stargate_convertAddressToID(id, address)
    if not existing == false or not exiting == nil then
        outputDebugString("[STARGATE] Attempt to create Stargate (at "..tostring(x)..","..tostring(y)..","..tostring(z)..") with same address as existing stargate ("..existing..")")
        destroyElement(stargate)
        return nil
    end

    stargate_setAddress(id, address)
    stargate_setDefaultDialType(id, dt)
    stargate_setForceDialType(id, forceDefaultDialType)
    energy_device_create(GATE_ENERGY_CAPACITY, 0, GATE_ENERGY_WORMHOLE, stargate, GATE_ENERGY_IDLE, 0, "stargate_energy_device")
    planet_setElementOccupiedPlanet(stargate, "PLANET_"..dimension)
    stargate_addCollisions(id)
    

    if gateType == enum_galaxy.MILKYWAY then
        models_setElementModelAttribute(stargate, "innerring")
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

    setElementData(stargate, "hasIris", false)
    if not irisType == nil or not irisType == false then
        setElementData(stargate, "hasIris", true)
        -- if irisType == "sgc" then
        for i=1,10 do
            stargate_iris_create(id, i)
        end
        -- end
    end

    if not isGrounded then
        isGrounded = false
    end

    if isGrounded == nil then
        isGrounded = false
        if rx > 240 and rx < 300 then
            isGrounded = true
        end
    end

    stargate_setGrounded(id, isGrounded)
    stargate_setAssignedDHD(id, nil)
    local irisText = ""
    if not (irisType == nil or irisType == false) then
        irisText = " iris="..irisType
    end
    outputDebugString("[STARGATE] Created Stargate (ID="..tostring(getElementID(stargate)).." galaxy="..tostring(stargate_galaxy_get(id))..""..irisText..") at "..tostring(x)..","..tostring(y)..","..tostring(z).."")
    return stargate
end

-- Remove stargate  (not implemented yet)
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
function stargate_remove(stargateID)
    outputChatBox("This function (stargate_remove) is not implemented yet!")
end

-- Begin dialling process of stargate
-- > checks if stargate has enough energy to dial, is not grounded or not active (if these checks fail - dialling will fail without animation)
-- > begins dialling animation and sets stargate energy consumption to GATE_ENERGY_DIAL
-- > checks if there is possibility to create wormhole between stargates (in the moment dialling starts)
--  1. Translation of address to stargate ID failed ->  not possible, dialling fails after completing animation (invalid address)
--  2. Second stargate is disabled, grounded        ->  same as 1. (destination gate is disabled or grounded)
--  3. Stargate is dialling itself                  ->  same as 1. (dialling itself)
--  4. There is incoming wormhole happening         ->  not possible (dialling already failed from other function, animation already interrupted)
--  5. No issues in current moment                  ->  may be possible, prepare connection between stargates (after dialling animation)

--- REQUIRED PARAMETERS:
--> stargateIDFrom      string                  ID of source stargate (outgoing)
--> addressArray        reference               array of address of destination/dialed stargate (incoming)
--> stargateDialType    enum_stargateDialType   used dial type/mode of stargate    
--- RETURNS:
-- Boolean; true if dialling process may continue or false if connection is not possible and dialling will fail
function stargate_dial(stargateIDFrom, addressArray, stargateDialType)
    local stargateIDTo = stargate_convertAddressToID(stargateIDFrom, addressArray)
    local sg_energy = stargate_getEnergyElement(stargateIDFrom)
    if energy_device_energyRequirementsMet(sg_energy) == false then
        stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_NO_ENERGY, false)
        return false
    end

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

    energy_device_setConsumption(stargate_getEnergyElement(stargateIDFrom), GATE_ENERGY_DIAL)
    stargate_setConnectionID(stargateIDFrom, stargateIDTo)
    if stargateIDTo then -- may success
        local result = stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
        if result == enum_stargateStatus.GATE_DISABLED then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        elseif result == enum_stargateStatus.GATE_GROUNDED then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        elseif result == enum_stargateStatus.DIAL_SELF then
            setTimer(stargate_diallingFailed, totalTime+MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo, result)
        elseif result == enum_stargateStatus.DIAL_GATE_INCOMING then
            -- dont do anything
        else -- connection can be secured and at this moment, dialling may not fail
            local anotherTimer = setTimer(stargate_wormhole_secureConnection, totalTime, 1, stargateIDFrom, stargateIDTo)
            setElementData(stargate_getElement(stargateIDFrom), "secureTimer", anotherTimer)
        end
    else -- will surely fail
        setTimer(stargate_diallingFailed, totalTime, 1, stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_UNKNOWN_ADDRESS)
    end

    return true
end
addEvent("stargate_dial_from_client", true)
addEventHandler("stargate_dial_from_client", resourceRoot, stargate_dial)

-- Begin dialling process of stargate but dial by ID instead of address (see stargate_dial(...))
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string                  ID of source stargate (outgoing)
--> stargateIDTo        string                  ID of destination stargate (incoming)
--- RETURNS:
--> Boolean; see stargate_dial(...)
function stargate_dialByID(stargateIDFrom, stargateIDTo, stargateDialType)
    local address = stargate_getAddress(stargateIDTo)
    return (stargate_dial(stargateIDFrom, address, stargateDialType))
end

-- Dialling failed function
-- > plays dial fail sound (depending on dontPlaySound argument)
-- > resets stargate element data
-- > turns off active glyphs, chevrons
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string                  ID of source stargate (outgoing)
--> stargateIDTo        string                  ID of destination stargate (incoming)
--> reason              enum_stargateStatus     status of stargate

--- OPTIONAL PARAMETERS:
--> dontPlaySound       bool                    will be dial fail sound played or not?
--- default if not specified: nil
--- RETURNS:
--> Null; nil if source stargate is open, otherwise nothing is returned
function stargate_diallingFailed(stargateIDFrom, stargateIDTo, reason, dontPlaySound)
    if stargate_isOpen(stargateIDFrom) then
        return nil
    end
    local id = stargateIDFrom
    local arrow = "to"
    if reason == enum_stargateStatus.DIAL_GATE_INCOMING then
        id = stargateIDTo
        arrow = "from"
    end

    if not dontPlaySound then
        stargate_sound_play(id, enum_soundDescription.GATE_DIAL_FAIL)
    end
    
    local t = setTimer(stargate_setAllChevronsActive, MW_DIAL_FAIL_CHVRN_DELAY, 1, id, false, false)
    setElementData(stargate_getElement(id), "timer_shutdownChevrons", t)
    stargate_setDialAddress(id, nil)
    stargate_setActive(id, false)
    energy_device_setConsumption(stargate_getEnergyElement(id), GATE_ENERGY_IDLE)
    if not reason == enum_stargateStatus.DIAL_ABORTED then
        outputChatBox("[STARGATE ("..tostring(stargateIDFrom)..")] Dialling "..arrow.." "..tostring(stargateIDTo).." failed. ("..enum_stargateStatus.toString(reason)..")")
    end
end

-- Perform animation of rotating ring (MilkyWay stargate) - single rotation of ring to specified symbol
--- REQUIRED PARAMETERS:
--> stargateID      string          ID of stargate
--> symbol          int             numerical symbol representation (0-38) which ring will rotate to
--> chevron         int             number of chevron that is being activated (locked)
--> lastChevron     bool            is this chevron the last activated chevron?
function stargate_animateOutgoingDial(stargateID, symbol, chevron, lastChevron)
    local t = {}
    local tm = nil
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
    tm = setTimer(stargate_sound_play, MW_RING_SPEED, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
    setElementData(ring, "rotationTime", MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)
    t = array_push(t, tm)
    -- top chevron after symbol reached
    tm = setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, 7, true)
    t = array_push(t, tm)
    if not lastChevron then
        tm = setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE, 1, stargateID, 7, false)
        t = array_push(t, tm)
        tm = setTimer(stargate_chevron_setActive, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK, 1, stargateID, chevron, true)
        t = array_push(t, tm)
    end
    -- engaged chevron after symbol reached
    tm = setTimer(stargate_ring_setRotating, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, false)
    t = array_push(t, tm)
    setTimer(stargate_sound_stop, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
    tm = setTimer(stargate_sound_play, MW_RING_CHEVRON_LOCK_SLOW_DELAY+timeTook, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
    t = array_push(t, tm)
    setElementData(stargate, "rot_anim_timer_"..tostring(chevron).."_semitimers", t)
end

-- Perform dialling animation of Stargate; MilkyWay stargate type
--- REQUIRED PARAMETERS:
--> stargateID          string                  ID of stargate
--> stargateDialType    enum_stargateDialType   dialling mode/type
--- RETURNS:
--> Int; time [ms] it will take to perform dialling animation; false if dialling failed (or dial mode is invalid)
function stargate_diallingAnimation(stargateID, stargateDialType)
    local t = 50
    local symbol_target = nil
    local symbol_f_current = nil
    local timer = nil
    if stargateDialType == enum_stargateDialType.SLOW then  --> Slow => ring will rotate to required symbol in addres, lock it; repeat until all symbols from address are locked
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
    elseif stargateDialType == enum_stargateDialType.INSTANT then   --> Instant => no animation, just turn on all required chevrons
        t = 500
        stargate_sound_play(stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
        setTimer(stargate_setAllChevronsActive, t, 1, stargateID, false, true)
    elseif stargateDialType == enum_stargateDialType.FAST then      --> Fast => ring will rotate and chevrons will turn be turned on with some delay
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
        local t_arr = {}
        local tm = nil
        -- start rotating
        tm = setTimer(stargate_sound_play, MW_RING_SPEED*2, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
        t_arr = array_push(t_arr, tm)
        stargate_ring_setRotating(stargateID, true)
        local timeTook = stargate_ring_rotateSymbols(ring, clockWise, symbolDistance)
        setElementData(ring, "rotationTime", timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE)
    
        local delay = MW_FASTDIAL_START_DELAY
        for i=1,7 do
            tm = setTimer(stargate_chevron_setActive, delay, 1, stargateID, i, true, true)
            t_arr = array_push(t_arr, tm)
            delay = delay + MW_FASTDIAL_CHEVRON_DELAY
        end
        tm = setTimer(stargate_ring_setRotating, timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, false)
        t_arr = array_push(t_arr, tm)
        tm = setTimer(stargate_sound_stop, MW_RING_CHEVRON_LOCK_FAST_DELAY+timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE, 1, stargateID, enum_soundDescription.GATE_RING_ROTATE)
        t_arr = array_push(t_arr, tm)
        tm = setTimer(stargate_sound_play, timeTook+MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE+MW_RING_CHEVRON_LOCK_FAST_DELAY, 1, stargateID, enum_soundDescription.GATE_CHEVRON_LOCK)
        t_arr = array_push(t_arr, tm)
        setElementData(stargate_getElement(stargateID), "rot_anim_timer_semitimers", t_arr)
        t = timeTook + MW_RING_CHEVRON_LOCK+MW_RING_CHEVRON_LOCK_AE+MW_RING_ROTATE_PAUSE+ MW_WORMHOLE_CREATE_DELAY*6
    else --> Unknown dial type
        outputDebugString("Stargate "..stargateID.." tried to dial in unsupported dial mode "..tostring(stargate_dialType))
        return false
    end
    return t
end

-- Abort dialling process
-- > when stargate is dialling
-- > when stargate is dialling but incoming wormhole is being created
--- REQUIRED PARAMETERS:
--> stargateID  string          ID of Stargate that is dialling
--- OPTIONAL PARAMETERS:
--> dialFailed      bool        was it aborted because dialling process failed?
function stargate_abortDial(stargateID, dialFailed)
    local stargateIDFrom = stargate_getConnectionID(stargateIDFrom)
    stargate_setDialAddress(stargateID, nil)
    if dialFailed then
        stargate_diallingFailed(stargateIDFrom, stargateID, enum_stargateStatus.DIAL_GATE_INCOMING, true)
        setElementData(stargate_getElement(stargateID), "dial_failed", true)
    else
        stargate_diallingFailed(stargateID, stargateIDFrom, enum_stargateStatus.DIAL_ABORTED, true)
    end

    if isTimer(getElementData(stargate_getElement(stargateID), "timer_shutdownChevrons")) then
        killTimer(getElementData(stargate_getElement(stargateID), "timer_shutdownChevrons"))
    end
    for i=1,7 do
        local t = getElementData(stargate_getElement(stargateID), "rot_anim_timer_"..tostring(i))
        local ts = getElementData(stargate_getElement(stargateID), "rot_anim_timer_"..tostring(i).."_semitimers")
                
        if not ts == nil or not ts == false then
            for i,v in ipairs(ts) do
                if isTimer(v) then
                    killTimer(v)
                end
            end
        end

    local ts2 = getElementData(stargate_getElement(stargateID), "rot_anim_timer_semitimers")
    if isTimer(ts2) then
        killTimer(ts2)
    end
    if isTimer(t) then
        killTimer(t)
    end
    local st = getElementData(stargate_getElement(stargateID), "secureTimer")
    if isTimer(st) then
        killTimer(st)
    end
    stargate_sound_stop(stargateID, enum_soundDescription.GATE_RING_ROTATE)
    
    if dialFailed then
        stargate_sound_play(stargateID, enum_soundDescription.GATE_DIAL_FAIL)
    end
end
addEvent("stargate_abort_dial_from_client", true)
addEventHandler("stargate_abort_dial_from_client", resourceRoot, stargate_abortDial)