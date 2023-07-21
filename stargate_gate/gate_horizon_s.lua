-- horizon_s.lua_ Event horizon module

function stargate_horizon_create(stargateID, x, y, z)
    local horizon = createObject(1337, x, y, z)
    setElementCollisionsEnabled(horizon, false)
    setElementID(horizon, stargateID.."H")
    triggerClientEvent("setElementModelClient", resourceRoot, horizon, MW_Horizon[1])
    return horizon
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
end

function stargate_horizon_remove(stargateID)
    return (destroyElement(getElementByID(stargateID.."H")))
end

function stargate_horizon_get(stargateID)
    return (getElementByID(stargateID.."H"))
end

-- begin animation of stargate's event horizon
function stargate_horizon_animateFrames(stargateID)
    local horizon = stargate_horizon_get(stargateID)
    local h1 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*0, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[1])
    local h2 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*1, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[2])
    local h3 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*2, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[3])
    local h4 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*3, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[4])
    local h5 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*4, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[5])
    local h6 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*5, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[6])
    local h7 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*6, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[5])
    local h8 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*7, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[4])
    local h9 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*8, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[3])
    local h10 = setTimer(triggerClientEvent, SG_HORIZON_ANIMATION_BEGIN+SG_HORIZON_ANIMATION_SPEED*9, 1, "setElementModelClient", resourceRoot, horizon, MW_Horizon[2])
    local horizonArray = {h1, h2, h3, h4, h5, h6, h7, h8, h9, h10}
    setElementData(getElementByID(stargateID), "horizonArray", horizonArray)
end