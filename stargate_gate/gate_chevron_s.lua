-- chevron_s.lua_ Chevron element module

-- set chevron active on SG
function stargate_chevron_create(stargateID, chevron)
    local x, y, z = stargate_getPosition(stargateID)
    local newChevron = createObject(1337, x, y, z)
    local chevronID = stargate_chevron_assignID(newChevron, stargateID, chevron)
    setElementData(newChevron, "number", chevron)
    setElementData(newChevron, "active", false)
    setElementCollisionsEnabled(newChevron, false)
    setElementAlpha(newChevron, 0)
    local sg = stargate_getElement(stargateID)
    local planet = planet_getElementOccupiedPlanet(sg)
    planet_setElementOccupiedPlanet(newChevron, planet)
    attachElements(newChevron, getElementByID(stargateID))
    return newChevron
end

function stargate_chevron_setActive(stargateID, chevron, active, playSound)
    local chevronElement = stargate_chevron_getElement(stargateID.."C"..tostring(chevron))
    if active == true then
        if playSound == true then
            x, y, z = stargate_getPosition(stargateID)
            stargate_sound_play(stargateID, enum_soundDescription.GATE_CHEVRON_INCOMING)
        end
        setElementAlpha(chevronElement, 255)
    else
        setElementAlpha(chevronElement, 0)
    end
    setElementData(chevronElement, "active", active)
end

function stargate_chevron_assignID(chevron, gateID, chevronNumber)
    local id = gateID.."C"..tostring(chevronNumber)
    setElementID(chevron, id)
    return id
end

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