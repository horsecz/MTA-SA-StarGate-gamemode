-- wormhole_s.lua_ Wormhole operations module

-- create wormhole between stargates
function stargate_wormhole_create(stargateIDFrom, stargateIDTo)
    stargate_setOpen(stargateIDFrom, true)
    stargate_setOpen(stargateIDTo, true)
    -- opening, vortex
    stargate_sound_play(stargateIDFrom, enum_soundDescription.GATE_VORTEX_OPEN)
    stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_VORTEX_OPEN)
    stargate_animateOpening(stargateIDFrom)

    -- horizon
    local hFt = setTimer(stargate_horizon_animateFrames, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDFrom)
    local hTt = setTimer(stargate_horizon_animateFrames, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDTo)
    setElementData(stargate_getElement(stargateIDFrom), "horizonMainArray", hFt)
    setElementData(stargate_getElement(stargateIDTo), "horizonMainArray", hTt)
    local vortexTime = stargate_animateOpening(stargateIDTo)

    -- teleport ability
    local x, y, z = stargate_getPosition(stargateIDFrom)
    local tpm = stargate_marker_create(x, y, z, "corona", 2, 25, 90, 200, 190, enum_markerType.EVENTHORIZON, stargateIDFrom)

    -- autoclose in 38/given seconds
    local closeTimer = setTimer(stargate_wormhole_close, vortexTime + SG_WORMHOLE_OPEN_TIME*1000, 1, stargateIDFrom, stargateIDTo)
    stargate_setCloseTimer(stargateIDFrom, closeTimer)
    stargate_setCloseTimer(stargateIDTo, closeTimer)
end

-- prepare for creation of wormhole between stargates; check if it is possible to connect both gates,
-- returns enumeration value of enum stargateStatus; if connection possible, returns GATE_IDLE value
function stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
    if stargate_isDisabled(stargateIDTo) then 
        return enum_stargateStatus.GATE_DISABLED
    end
    if stargate_isActive(stargateIDTo) or stargate_isOpen(stargateIDTo) then -- second sg dialling or open
        return enum_stargateStatus.GATE_ACTIVE
    end
    return enum_stargateStatus.GATE_IDLE
end

-- In case that other-dialed SG is dialling (active) but not connected yet, we must check for its status again
-- before completely failing dialling process;
-- if dialed SG is still not yet open and we can estabilish connection, we get priority and interrupt its dialling;
-- 
-- connected SG == all chevrons on outgoing SG locked/encoded & any chevron on incoming SG is locked/encoded
function stargate_wormhole_secureConnection(stargateIDFrom, stargateIDTo)
    if stargate_isOpen(stargateIDTo) then -- second stargate dialed out faster
        stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.GATE_OPEN)
        return nil
    elseif stargate_isOpen(stargateIDFrom)then
        stargate_diallingFailed(stargateIDTo, stargateIDFrom, enum_stargateStatus.GATE_OPEN)
        return nil
    elseif getElementData(stargate_getElement(stargateIDFrom), "dial_failed") then
        --stargate_diallingFailed(stargateIDFrom, stargate_getConnectionID(stargateIDFrom), enum_stargateStatus.DIAL_GATE_INCOMING_TOGATE, true)
        return nil
    elseif stargate_isActive(stargateIDTo) and not stargate_isOpen(stargateIDTo) then -- second stargate not open but dialling (slower)
        if stargate_getConnectionID(stargateIDTo) then
            stargate_setDialAddress(stargateIDTo, nil)
            stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_GATE_INCOMING, true)
            setElementData(stargate_getElement(stargateIDTo), "dial_failed", true)
            for i=1,7 do
                local t = getElementData(stargate_getElement(stargateIDTo), "rot_anim_timer_"..tostring(i))
                if isTimer(t) then
                    killTimer(t)
                end
            end
            GATE_OPEN_DELAY = GATE_OPEN_DELAY + 1000
        end
    end
    setTimer(stargate_setAllChevronsActive, GATE_OPEN_DELAY, 1, stargateIDTo, false, true)
    setTimer(stargate_setConnectionID, GATE_OPEN_DELAY, 1, stargateIDTo, stargateIDFrom)
    setTimer(stargate_setActive, GATE_OPEN_DELAY, 1, stargateIDTo, true)
    setTimer(stargate_wormhole_create, GATE_OPEN_DELAY + MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo)
end

-- teleport function for stargate horizon markers; source = marker
function stargate_wormhole_transport(hitElement)
    if stargate_marker_isEventHorizon(source) then
        local stargateIDFrom = stargate_marker_getSource(source)
        if stargate_isOpen(stargateIDFrom) then
            local stargateIDTo = stargate_getConnectionID(stargateIDFrom)
            local x2, y2, z2 = stargate_getPosition(stargateIDTo)
            setElementPosition(hitElement, x2, y2, z2)
            stargate_sound_play(stargateIDFrom, enum_soundDescription.GATE_HORIZON_TOUCH, 75)
            stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_HORIZON_TOUCH, 75)
        else
            if getElementType(hitElement) == "ped" or getElementType(hitElement) == "player" then
                killPed(hitElement) -- stargate open but (active and) horizon marker is present = unstable vortex still present
            else
                destroyElement(hitElement)
            end
        end
    end
end

-- close active wormhole between two SGs
function stargate_wormhole_close(stargateIDFrom, stargateIDTo)
    -- prepare, disable teleportation
    stargate_marker_remove(stargateIDFrom, enum_markerType.EVENTHORIZON)
    local x, y, z = stargate_getPosition(stargateIDFrom)
    local x2, y2, z2 = stargate_getPosition(stargateIDTo)
    stargate_sound_play(stargateIDFrom, enum_soundDescription.GATE_CLOSE)
    stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_CLOSE)
    -- disengage horizon
    stargate_horizon_animateRemove(stargateIDFrom)
    stargate_horizon_animateRemove(stargateIDTo)

    -- turn off chevrons, remove event horizon and reset attributes
    setTimer(function(stargateIDFrom, stargateIDTo)
        stargate_setAllChevronsActive(stargateIDFrom, false, false)
        stargate_setAllChevronsActive(stargateIDTo, false, false)
        stargate_horizon_remove(stargateIDFrom)
        stargate_horizon_remove(stargateIDTo)

        stargate_setActive(stargateIDFrom, false)
        stargate_setActive(stargateIDTo, false)
        stargate_setOpen(stargateIDFrom, false)
        stargate_setOpen(stargateIDTo, false)
        setElementData(stargate_getElement(stargateIDFrom), "dial_failed", false)
        setElementData(stargate_getElement(stargateIDTo), "dial_failed", false)
    end, 3000, 1, stargateIDFrom, stargateIDTo)
end