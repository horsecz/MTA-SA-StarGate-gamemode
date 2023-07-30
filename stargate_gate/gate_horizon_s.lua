-- horizon_s.lua_ Event horizon module

function stargate_horizon_create(stargateID, frame)
    local x, y, z = stargate_getPosition(stargateID)
    local horizon = createObject(1337, x, y, z)
    setElementCollisionsEnabled(horizon, false)
    setElementID(horizon, stargateID.."H"..tostring(frame))
    setElementAlpha(horizon, 0)
    local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateID))
    planet_setElementOccupiedPlanet(horizon, planet)
    attachElements(horizon, getElementByID(stargateID))

    local horizonActivation = createObject(1337, x, y, z)
    setElementCollisionsEnabled(horizonActivation, false)
    setElementID(horizonActivation, stargateID.."HA"..tostring(frame))
    setElementAlpha(horizonActivation, 0)
    local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateID))
    planet_setElementOccupiedPlanet(horizonActivation, planet)
    attachElements(horizonActivation, getElementByID(stargateID))
    return horizon
end

function stargate_horizon_setActive(stargateID, frame, active)
    local horizon = nil
    if tonumber(frame) == 0 then
        if active then
            setElementAlpha(getElementByID(stargateID.."H"..tostring(1)), 255)
        else
            setElementAlpha(getElementByID(stargateID.."H"..tostring(1)), 0)
        end
        return true
    end

    for i=1,6 do
        horizon = getElementByID(stargateID.."H"..tostring(i))
        setElementAlpha(horizon, 0)
        if i == tonumber(frame) and active == true then
            setElementAlpha(horizon, SG_HORIZON_ALPHA)
        end
    end
end

function stargate_horizon_activationAnimation(stargateID)
    local ha = nil
    local t = SG_HORIZON_ACTIVATE_SPEED

    for i=6,1,-1 do
        local ha = stargate_getHorizonActivation(stargateID, i)
        setTimer(setElementAlpha, t, 1, ha, 255)
        t = t + SG_HORIZON_ACTIVATE_SPEED
    end
    return t
end

function stargate_horizon_activationSet(stargateID, active)
    if active then 
        for i=1,6 do
            local ha = stargate_getHorizonActivation(stargateID, i)
            setElementAlpha(ha, 255)
        end
    else
        for i=1,6 do
            local ha = stargate_getHorizonActivation(stargateID, i)
            setElementAlpha(ha, 0)
        end
    end
end

function stargate_horizon_deactivationAnimation(stargateID)
    local ha = nil
    local t = SG_HORIZON_ACTIVATE_SPEED
    stargate_horizon_activationSet(stargateID, true)
    
    for i=1,6 do
        local ha = stargate_getHorizonActivation(stargateID, i)
        setTimer(setElementAlpha, t, 1, ha, 0)
        t = t + SG_HORIZON_ACTIVATE_SPEED
    end
    return t
end

-- animate disengaging event horizon when shutting down gate
function stargate_horizon_animateRemove(stargateID)
    local sg = stargate_getElement(stargateID)
    killTimer(getElementData(sg, "horizonMainArray"))
    for i=1,6 do
        local tF = getElementData(sg, "horizonArray")[i]
        if isTimer(tF) then
            killTimer(tF)
        end
    end
    stargate_horizon_activationSet(stargateID, true)
    setTimer(stargate_horizon_remove, 1000, 1, stargateID)
    setTimer(stargate_horizon_deactivationAnimation, 1750, 1, stargateID)
    setTimer(stargate_marker_remove, 1750, 1, stargateID, enum_markerType.EVENTHORIZON)
end

function stargate_horizon_remove(stargateID)
    for i=1,6 do
        stargate_horizon_setActive(stargateID, i, false)
    end
end

function stargate_horizon_get(stargateID, frame)
    return (getElementByID(stargateID.."H"..tostring(frame)))
end

-- begin animation of stargate's event horizon
function stargate_horizon_animateFrames(stargateID)
    local h1 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*0, 1, stargateID, 1, true)
    local h2 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*1, 1, stargateID, 2, true)
    local h3 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*2, 1, stargateID, 3, true)
    local h4 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*3, 1, stargateID, 4, true)
    local h5 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*4, 1, stargateID, 5, true)
    local h6 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*5, 1, stargateID, 6, true)
    local h7 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 1, stargateID, 5, true)
    local h8 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*7, 1, stargateID, 4, true)
    local h9 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*8, 1, stargateID, 3, true)
    local h10 = setTimer(stargate_horizon_setActive, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*9, 1, stargateID, 2, true)
    local horizonArray = {h1, h2, h3, h4, h5, h6, h7, h8, h9, h10}
    setElementData(getElementByID(stargateID), "horizonArray", horizonArray)
end