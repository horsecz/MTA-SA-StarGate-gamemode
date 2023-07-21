-- vortex_s.lua_ Vortex (Kawoosh) module

-- warning_ does not set element model (model is set in 'animate()' function instead)
function stargate_vortex_create(stargateID, x, y, z)
    local vortex = createObject(1337, x, y, z)
    setElementID(vortex, stargateID.."V")
    setElementCollisionsEnabled(vortex, false)
    return vortex
end

function stargate_vortex_getElement(stargateID)
    return getElementByID(stargateID.."V")
end

function stargate_vortex_remove(stargateID)
    local vortex = stargate_vortex_getElement(stargateID)
    local killZone = stargate_marker_get(stargateID, enum_markerType.VORTEX)
    destroyElement(vortex)
    destroyElement(killZone)
end

-- animate vortex-kawoosh; returns time needed for animation
function stargate_vortex_animate(stargateID)
    local vortex = stargate_vortex_getElement(stargateID)
    local last = 50
    for i=1,12 do
        setTimer(triggerClientEvent, last, 1, "setElementModelClient", resourceRoot, vortex, SG_Kawoosh[i])
        last = last + SG_VORTEX_ANIM_SPEED
    end
    for i=12,1,-1 do
        setTimer(triggerClientEvent, last, 1, "setElementModelClient", resourceRoot, vortex, SG_Kawoosh[i])
        last = last + SG_VORTEX_ANIM_SPEED
    end

    setTimer(stargate_vortex_remove, last, 1, stargateID)
    return last
end

-- killing function for stargate kawoosh-vortex markers
function stargate_vortex_kill(player)
    if stargate_marker_isVortex(source) then
        destroyElement(player)
        if isElement(player) and getElementType(player) == "ped" or getElementType(player) == "player" then
            setElementAlpha(player, 0)
            killPed(player)
        end
    end
end
