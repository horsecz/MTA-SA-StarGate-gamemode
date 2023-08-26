-- wormhole_s.lua: Module for wormhole operations and functions; server-side

-- Create wormhole between two stargates
-- > Set all stargates open status (to true) and their energy consumption to GATE_ENERGY_WORMHOLE
-- > Perform kawoosh/vortex opening animation (and create kill zone marker so any element is destroyed if touching vortex)
-- > Show and animate event horizon with enabling transport from source stargate to destination stargate
-- > Create timer for stargate autoclose after given time; timer is only one, however reference is stored on both gates
-- > Create timer for automatic stargate close, when stargates energy requirements won't be met (one timer, references on both gates)
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string      ID of stargate
--> stargateIdTO        int         kawoosh frame number
--- RETURNS:
--> Bool; false if very rare case happens (both stargates dial themselves at the same time), otherwise no return value
function stargate_wormhole_create(stargateIDFrom, stargateIDTo)
    stargate_setOpen(stargateIDFrom, true)
    if stargate_isOpen(stargateIDTo) then
        outputDebugString("[STARGATE] HANDLED RARE CASE: Both stargates (F:"..stargateIDFrom..", T:"..stargateIDTo..") dialed themselves at the same time. Stargates won't create wormhole.")
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
    attachElements(tpm, getElementByID(stargateIDFrom))

    local x, y, z = stargate_getPosition(stargateIDTo)
    local rpm = stargate_marker_create(x, y, z, "corona", 2, 25, 90, 200, 190, enum_markerType.EVENTHORIZON, stargateIDTo)
    setElementData(rpm, "incoming", true)
    attachElements(rpm, getElementByID(stargateIDTo))

    if stargate_iris_isActive(stargateIDFrom) then
        setElementAlpha(tpm, 0)
    end
    if stargate_iris_isActive(stargateIDTo) then
        setElementAlpha(rpm, 0)
    end

    -- autoclose in 38/given seconds
    local closeTimer = setTimer(stargate_wormhole_close, vortexTime + SG_WORMHOLE_OPEN_TIME*1000, 1, stargateIDFrom, stargateIDTo)
    setElementData(stargate_getElement(stargateIDFrom), "stargateCloseTimer", closeTimer)
    setElementData(stargate_getElement(stargateIDTo), "stargateCloseTimer", closeTimer)

    -- energy check
    setTimer(function(stargateIDFrom, stargateIDTo)
        local energyTimer = setTimer(stargate_wormhole_energyCheck, 1000, 0, stargateIDFrom, stargateIDTo)
        setElementData(stargate_getElement(stargateIDFrom), "stargateEnergyTimer", energyTimer)
        setElementData(stargate_getElement(stargateIDTo), "stargateEnergyTimer", energyTimer)
    end, vortexTime+100, 1, stargateIDFrom, stargateIDTo)
end

-- Perform check whether stargate energy status is OK; if not, close the connection (wormhole) and notify player
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string      ID of source stargate
--> stargateIDTo        string      ID of destination stargate
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

-- Prepare for creation of wormhole between stargates; check if it is possible to connect both gates and create wormhole
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string      ID of source stargate
--> stargateIDTo        string      ID of destination stargate
--- RETURNS:
-- enum_stargateStatus; enumeration value (int) - if connection is possible returns GATE_IDLE value, otherwise returns proper value from enum
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

-- Secures connection between two stargates
-- > Performs neccessary checks like:
--      > destination gate open (someone dialed it faster)      -> dial failed
--      > source gate open (incoming wormhole on source gate)   -> dial failed
--      > source gate has attribute dial_failed set true (incoming wormhole on source gate)             -> nothing happens
--      > energy requirements for source stargate weren't met (not enough energy to create wormhole)    -> dial failed
-- > If all checks are fine, activates destination stargate and creates wormhole
-- > If checks are OK but destination stargate is active (not open, dialling out - animation not finished yet), destination gate will be interrupted (dial for it will fail) and wormhole will be created
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string      ID of source stargate
--> stargateIDTo        string      ID of destination stargate
--- RETURNS:
--> Null; if connection cannot be secured, otherwise no return value
function stargate_wormhole_secureConnection(stargateIDFrom, stargateIDTo)
    local sg_en = stargate_getEnergyElement(stargateIDFrom)
    local activate_delay = GATE_OPEN_DELAY
    local result = stargate_wormhole_checkAvailability(stargateIDFrom, stargateIDTo)
    if result == enum_stargateStatus.GATE_DISABLED then
        setTimer(stargate_diallingFailed, 10, 1, stargateIDFrom, stargateIDTo, result)
        return nil
    elseif result == enum_stargateStatus.GATE_GROUNDED then
        setTimer(stargate_diallingFailed, 10, 1, stargateIDFrom, stargateIDTo, result)
        return nil
    elseif result == enum_stargateStatus.DIAL_SELF then
        setTimer(stargate_diallingFailed, 10, 1, stargateIDFrom, stargateIDTo, result)
        return nil
    elseif stargateIDTo == nil or stargateIDTo == false then
        setTimer(stargate_diallingFailed, 10, 1, stargateIDFrom, stargateIDTo, enum_stargateStatus.DIAL_UNKNOWN_ADDRESS)
        return nil
    end

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
            stargate_abortDial(stargateIDTo, true)
            activate_delay = GATE_OPEN_DELAY + GATE_ACTIVE_INCOMING_OPEN_DELAY
        end
    end
    setTimer(stargate_setAllChevronsActive, activate_delay, 1, stargateIDTo, false, true)
    setTimer(stargate_setConnectionID, activate_delay, 1, stargateIDTo, stargateIDFrom)
    setTimer(stargate_setActive, activate_delay, 1, stargateIDTo, true)
    setTimer(stargate_setIncomingStatus, activate_delay, 1, stargateIDTo, true)
    setTimer(stargate_wormhole_create, activate_delay + MW_WORMHOLE_CREATE_DELAY, 1, stargateIDFrom, stargateIDTo)
end

-- Teleport function for stargate horizon markers
-- > Teleports element that hits event horizon marker to destination stargate
-- > When teleporting, plays horizon touch sound
-- > Element won't be teleported if:
--      > stargate is being closed (horizon is deactivating)    -> element will be destroyed
--      > marker is on destination stargate         -> nothing happens
--      > iris is active on source stargate         -> nothing happens
--      > iris is active on destination stargate    -> element will be destroyed
--- REQUIRED PARAMETERS:
--> Inherited from "onMarkerHit" server event
--- RETURNS:
--> Bool; true if element hit the marker but teleport won't be performed
function stargate_wormhole_transport(hitElement)
    if stargate_marker_isEventHorizon(source) and getElementDimension(hitElement) == getElementDimension(source) then
        local stargateIDFrom = stargate_marker_getSource(source)
        if getElementData(source, "active") == false then -- closing gate
            if getElementData(source, "isStargateElement") == true then -- dont destroy itself, other stargate
                return false 
            end
            if getElementAttachedTo(stargate_getElement(stargateIDFrom)) then -- no destroying when stargate is attached to something
                return false
            end

            setElementAlpha(hitElement, 0)
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
            setElementRotation(hitElement, rx, ry, rz)
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

-- Close active wormhole between two stargates; shut down both gates
-- > 1. Deactivate horizon markers (but don't destroy yet)
-- > 2. Play gate close sound
-- > 3. Animate event horizon closing, remove horizon marker
-- > 4. Reset stargate attributes and turn off chevrons
--- REQUIRED PARAMETERS:
--> stargateIDFrom      string      ID of source stargate
--> stargateIDTo        string      ID of destination stargate
function stargate_wormhole_close(stargateIDFrom, stargateIDTo)
    if isTimer(stargate_getEnergyTimer(stargateIDFrom)) then
        killTimer(stargate_getEnergyTimer(stargateIDFrom))
        stargate_setEnergyTimer(stargateIDFrom, nil)
        stargate_setEnergyTimer(stargateIDTo, nil)
    end
    if isTimer(stargate_getCloseTimer(stargateIDFrom)) then
        killTimer(stargate_getCloseTimer(stargateIDFrom))
    end
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

        stargate_horizon_remove(stargateIDFrom)
        stargate_horizon_remove(stargateIDTo)
        
        setElementData(stargate_getElement(stargateIDFrom), "dial_failed", false)
        setElementData(stargate_getElement(stargateIDTo), "dial_failed", false)

        stargate_setCloseTimer(stargateIDFrom, nil)
        stargate_setCloseTimer(stargateIDTo, nil)
    end, 3000, 1, stargateIDFrom, stargateIDTo)
end
addEvent("stargate_wormhole_close_client", true)
addEventHandler("stargate_wormhole_close_client", resourceRoot, stargate_wormhole_close)