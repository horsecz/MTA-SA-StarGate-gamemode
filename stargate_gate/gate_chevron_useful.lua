-- chevron_useful.lua: Useful functions when working with stargate chevron element; shared

--- Chevron element attributes
--> active      is chevron currently active (shown)?

function stargate_chevron_getID(chevron)
    return (getElementID(chevron))
end

function stargate_chevron_getElement(id)
    return (getElementByID(id))
end

function stargate_chevron_getPosition(id)
    return (getElementData(stargate_chevron_getElement(id), "number"))
end

function stargate_chevron_isActive(stargateID, chevron)
    chevron = stargate_chevron_getElement(stargateID.."C"..tostring(chevron))
    return (getElementData(chevron, "active"))
end