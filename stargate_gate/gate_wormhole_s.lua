-- wormhole_s.lua_ Wormhole operations module

-- create wormhole between stargates
function stargate_wormhole_create(stargateIDFrom, stargateIDTo)
    stargate_setOpen(stargateIDFrom, true)
    if stargate_isOpen(stargateIDTo) then
        outputDebugString("[STARGATE] HANDLED RARE CASE: Both stargates (F:"..stargateIDFrom..", T:"..stargateIDTo..") dialed themselves at the same time. Stargate T did not create wormhole.")
        return false
    else
        stargate_setOpen(stargateIDTo, true)
    end
    energy_device_setConsumption(stargate_getEnergyElement(stargateIDFrom), GATE_ENERGY_WORMHOLE)
    energy_device_setConsumption(stargate_getEnergyElement(stargateIDTo), GATE_ENERGY_WORMHOLE)
    -- opening, vortex
    stargate_sound_play(stargateIDFrom, enum_soundDescription.GATE_VORTEX_OPEN)
    stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_VORTEX_OPEN)
    stargate_vortex_animate(stargateIDFrom)
    local vortexTime = stargate_vortex_animate(stargateIDTo)
    local killZoneF = nil
    local killZoneT = nil

    if stargate_iris_isActive(stargateIDFrom) == false or stargate_iris_isActive(stargateIDTo) == nil then
        local killZoneF = stargate_marker_create(0, 0, -1000, "corona", 3.4, 20, 90 , 250, 10, enum_markerType.VORTEX, stargateIDFrom)
        attachElements(killZoneF, getElementByID(stargateIDFrom))
        setElementAttachedOffsets(killZoneF, 0, 2.3, 0)
    end
    if stargate_iris_isActive(stargateIDTo) == false or stargate_iris_isActive(stargateIDTo) == nil then
        local killZoneT = stargate_marker_create(0, 0, -1000, "corona", 3.4, 20, 90 , 250, 10, enum_markerType.VORTEX, stargateIDTo)
        attachElements(killZoneT, getElementByID(stargateIDTo))
        setElementAttachedOffsets(killZoneT, 0, 2.3, 0)
    end

    -- horizon
    setTimer(stargate_horizon_setActive, vortexTime, 1, stargateIDFrom, 0, false)
    setTimer(stargate_horizon_setActive, vortexTime, 1, stargateIDTo, 0, false)
    local hFt = setTimer(stargate_horizon_animateFrames, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDFrom)
    local hTt = setTimer(stargate_horizon_animateFrames, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 0, stargateIDTo)
    setElementData(stargate_getElement(stargateIDFrom), "horizonMainArray", hFt)
    setElementData(stargate_getElement(stargateIDTo), "horizonMainArray", hTt)

    -- teleport ability
    local x, y, z = stargate_getPosition(stargateIDFrom)
    local tpm = stargate_marker_create(x, y, z, "corona", 2, 25, 90, 200, 190, enum_markerType.EVENTHORIZON, stargateIDFrom)
    
    local x, y, z = stargate_getPosition(stargateIDTo)
    local rpm = stargate_marker_create(x, y, z, "corona", 2, 25, 90, 200, 190, enum_markerType.EVENTHORIZON, stargateIDTo)
    setElementData(rpm, "incoming", true)

    if stargate_iris_isActive(stargateIDFrom) then
        setElementAlpha(tpm, 0)
    end
    if stargate_iris_isActive(stargateIDTo) then
        setElementAlpha(rpm, 0)
    end

    -- autoclose in 38/given seconds
    local closeTimer = setTimer(stargate_wormhole_close, vortexTime + SG_WORMHOLE_OPEN_TIME*1000, 1, stargateIDFrom, stargateIDTo)
    stargate_setCloseTimer(stargateIDFrom, closeTimer)
    stargate_setCloseTimer(stargateIDTo, closeTimer)

    -- energy check
    setTimer(function(stargateIDFrom, stargateIDTo)
        local energyTimer = setTimer(stargate_wormhole_energyCheck, 1000, 0, stargateIDFrom, stargateIDTo)
        stargate_setEnergyTimer(stargateIDFrom, energyTimer)
    end, vortexTime+100, 1, stargateIDFrom, stargateIDTo)
end

function stargate_wormhole_energyCheck(stargateIDFrom, stargateIDTo)
    local fE = stargate_getEnergyElement(stargateIDFrom)
    local tE = stargate_getEnergyElement(stargateIDTo)
    local fE_status = energy_device_energyRequirementsMet(fE)
    local tE_status = energy_device_energyRequirementsMet(tE)
    if fE_status == true or tE_status == true then
        -- energy OK so is wormhole
    else
        killTimer(stargate_getCloseTimer(stargateIDFrom))
        stargate_wormhole_close(stargateIDFrom, stargateIDTo)
        outputChatBox("["..stargateIDFrom.."] Wormhole unstable due to insufficent energy! Stargate's disconnected.")
    end
end

-- prepare for creation of wormhole between stargates; check if it is possible to connect both gates,
-- returns enumeration value of enum stargateStatus; if connection possible, returns GATE_IDLE value
function stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
    if stargateIDFrom == stargateIDTo then
        return enum_stargateStatus.DIAL_SELF
    end
    if stargate_isDisabled(stargateIDTo) then 
        return enum_stargateStatus.GATE_DISABLED
    end
    if stargate_isActive(stargateIDTo) or stargate_isOpen(stargateIDTo) then -- second sg dialling or open
        return enum_stargateStatus.GATE_ACTIVE
    end
    if stargate_isOpen(stargateIDFrom) then
        return enum_stargateStatus.DIAL_GATE_INCOMING
    end
    if stargate_getGrounded(stargateIDTo) then
        return enum_stargateStatus.GATE_GROUNDED
    end
    return enum_stargateStatus.GATE_IDLE
end

-- In case that other-dialed SG is dialling (active) but not connected yet, we must check for its status again
-- before completely failing dialling process;
-- if dialed SG is still not yet open and we can estabilish connection, we get priority and interrupt its dialling;
-- 
-- connected SG == all chevrons on outgoing SG locked/encoded & any chevron on incoming SG is locked/encoded
function stargate_wormhole_secureConnection(stargateIDFrom, stargateIDTo)
    local sg_en = stargate_getEnergyElement(stargateIDFrom)
    if stargate_isOpen(stargateIDTo) then -- second stargate dialed out faster
        stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.GATE_OPEN)
        return nil
    elseif stargate_isOpen(stargateIDFrom) then
        stargate_diallingFailed(stargateIDTo, stargateIDFrom, enum_stargateStatus.GATE_OPEN)
        return nil
    elseif getElementData(stargate_getElement(stargateIDFrom), "dial_failed") then
        --stargate_diallingFailed(stargateIDFrom, stargate_getConnectionID(stargateIDFrom), enum_stargateStatus.DIAL_GATE_INCOMING_TOGATE, true)
        return nil
    elseif energy_device_energyRequirementsMet(sg_en) == false then
        stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.WORMHOLE_CREATE_NO_ENERGY)
        return nil
    elseif stargate_isActive(stargateIDTo) and not stargate_isOpen(stargateIDTo) then -- second stargate not open but dialling (slower)
        if stargate_getConnectionID(stargateIDTo) then
            stargate_setDialAddress(stargateIDTo, nil)
            stargate_diallingFailed(stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_GATE_INCOMING, true)
            setElementData(stargate_getElement(stargateIDTo), "dial_failed", true)
            if isTimer(getElementData(stargate_getElement(stargateIDTo), "timer_shutdownChevrons")) then
                killTimer(getElementData(stargate_getElement(stargateIDTo), "timer_shutdownChevrons"))
            end
            for i=1,7 do
                local t = getElementData(stargate_getElement(stargateIDTo), "rot_anim_timer_"..tostring(i))
                local ts = getElementData(stargate_getElement(stargateIDTo), "rot_anim_timer_"..tostring(i).."_semitimers")
                
                if not ts == nil or not ts == false then
                    for i,v in ipairs(ts) do
                        if isTimer(v) then
                            killTimer(v)
                        end
                    end
                end

                local ts2 = getElementData(stargate_getElement(stargateIDTo), "rot_anim_timer_semitimers")
                if isTimer(ts2) then
                    killTimer(ts2)
                end
                if isTimer(t) then
                    killTimer(t)
                end
                local st = getElementData(stargate_getElement(stargateIDTo), "secureTimer")
                if isTimer(st) then
                    killTimer(st)
                end

                stargate_sound_stop(stargateIDTo, enum_soundDescription.GATE_RING_ROTATE)

            end
            GATE_OPEN_DELAY = GATE_OPEN_DELAY + GATE_ACTIVE_INCOMING_OPEN_DELAY
            stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_DIAL_FAIL)
        end
    end
    setTimer(stargate_setAllChevronsActive, GATE_OPEN_DELAY, 1, stargateIDTo, false, true)
    setTimer(stargate_setConnectionID, GATE_OPEN_DELAY, 1, stargateIDTo, stargateIDFrom)
    setTimer(stargate_setActive, GATE_OPEN_DELAY, 1, stargateIDTo, true)
    setTimer(stargate_setIncomingStatus, GATE_OPEN_DELAY, 1, stargateIDTo, true)
    setTimer(stargate_wormhole_create, GATE_OPEN_DELAY + MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo)
end

-- teleport function for stargate horizon markers; source = marker
function stargate_wormhole_transport(hitElement)
    if stargate_marker_isEventHorizon(source) and getElementDimension(hitElement) == getElementDimension(source) then
        local stargateIDFrom = stargate_marker_getSource(source)
        if getElementData(source, "active") == false then -- closing gate
            setElementAlpha(hitElement, 0)
            outputChatBox("["..stargateIDFrom.."] Unstable event horizon killed you!")
            if getElementType(hitElement) == "ped" or getElementType(hitElement) == "player" then
                killPed(hitElement) -- stargate open but (active and) horizon marker is present = unstable vortex still present
            else
                destroyElement(hitElement)
            end
            return true
        end

        if getElementData(source, "incoming") == true then -- incoming gate wont teleport 
            return true
        end
        if stargate_isOpen(stargateIDFrom) then
            if stargate_iris_isActive(stargateIDFrom) then
                return true
            end
            local stargateIDTo = stargate_getConnectionID(stargateIDFrom)
            if stargate_iris_isActive(stargateIDTo) then
                setElementAlpha(hitElement, 0)
                if getElementType(hitElement) == "ped" or getElementType(hitElement) == "player" then
                    killPed(hitElement) -- stargate open but (active and) horizon marker is present = unstable vortex still present
                else
                    destroyElement(hitElement)
                end
                outputChatBox("["..stargateIDFrom.."] Destination stargate has active Iris! You have died in wormhole.")
                return true
            end

            local x2, y2, z2 = stargate_getPosition(stargateIDTo)
            local rx, ry, rz = stargate_getRotation(stargateIDTo)
            local erx, ery, erz = getElementRotation(hitElement)

            if (rx > 60 and rx < 115) then -- if lying on the ground, teleport element higher
                z2 = z2 + 1
            end
            setElementData(hitElement, "planet_models_loaded", false)
            setCameraMatrix(hitElement, -10000,-10000,-1000)
            local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateIDTo))
            planet_setElementOccupiedPlanet(hitElement, planet, true)
            stargate_sound_play(stargateIDFrom, enum_soundDescription.GATE_HORIZON_TOUCH, 75)
            stargate_sound_play(stargateIDTo, enum_soundDescription.GATE_HORIZON_TOUCH, 75)
            setElementPosition(hitElement, x2, y2, z2)
            setElementRotation(hitElement, erx, ery, rz)
            setElementCollisionsEnabled(hitElement, false)
            setElementFrozen(hitElement, true)
        else
            setElementAlpha(hitElement, 0)
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
    killTimer(stargate_getEnergyTimer(stargateIDFrom))
    -- prepare, disable teleportation
    stargate_marker_deactivate(stargateIDFrom, enum_markerType.EVENTHORIZON)
    stargate_marker_deactivate(stargateIDTo, enum_markerType.EVENTHORIZON)
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

        stargate_setActive(stargateIDFrom, false)
        stargate_setActive(stargateIDTo, false)
        stargate_setOpen(stargateIDFrom, false)
        stargate_setOpen(stargateIDTo, false)
        stargate_setIncomingStatus(stargateIDTo, false)
        setElementData(stargate_getElement(stargateIDFrom), "dial_failed", false)
        setElementData(stargate_getElement(stargateIDTo), "dial_failed", false)
    end, 3000, 1, stargateIDFrom, stargateIDTo)
end