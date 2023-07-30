-- vortex_s.lua_ Vortex (Kawoosh) module

function stargate_vortex_create(stargateID, frame)
    local vortex = createObject(1337, x, y, z)
    setElementID(vortex, stargateID.."V"..tostring(frame))
    setElementCollisionsEnabled(vortex, false)
    setElementAlpha(vortex, 0)
    local sg = stargate_getElement(stargateID)
    local planet = planet_getElementOccupiedPlanet(sg)
    planet_setElementOccupiedPlanet(vortex, planet)
    attachElements(vortex, getElementByID(stargateID))
    return vortex
end

function stargate_vortex_getElement(stargateID, frame)
    return (getElementByID(stargateID.."V"..tostring(frame)))
end

function stargate_vortex_remove(stargateID)
    local vortex = nil
    local killZone = stargate_marker_get(stargateID, enum_markerType.VORTEX)
    destroyElement(killZone)
end

function stargate_vortex_setActive(stargateID, frame, active)
    local vortex = nil
    for i=1,12 do
        vortex = stargate_vortex_getElement(stargateID, frame)    
        if active then
            setElementAlpha(vortex, 255)
        else
            setElementAlpha(vortex, 0)
        end
    end
end

-- animate vortex-kawoosh; returns time needed for animation
function stargate_vortex_animate(stargateID)
    local last = 50 + stargate_horizon_activationAnimation(stargateID)

    for i=1,12 do
        setTimer(stargate_vortex_setActive, last, 1, stargateID, i, true)
        last = last + SG_VORTEX_ANIM_SPEED
    end
    last = last + SG_VORTEX_ANIM_TOP_DELAY
    for i=12,1,-1 do
        setTimer(stargate_vortex_setActive, last, 1, stargateID, i, false)
        last = last + SG_VORTEX_ANIM_SPEED
    end

    setTimer(stargate_vortex_remove, last, 1, stargateID)
    setTimer(stargate_horizon_activationSet, last, 1, stargateID, false)
    return last
end

-- killing function for stargate kawoosh-vortex markers
function stargate_vortex_kill(player)
    if stargate_marker_isVortex(source) and getElementDimension(player) == getElementDimension(source) then
        destroyElement(player)
        if isElement(player) and getElementType(player) == "ped" or getElementType(player) == "player" then
            setElementAlpha(player, 0)
            killPed(player)
        end
    end
end
