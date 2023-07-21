-- chevron_s.lua_ Chevron element module

-- set chevron active on SG
function stargate_chevron_setActive(stargateID, chevron, active, playSound)
    local x, y, z = 0, 0, 0
    if active == true then
        futureID = stargateID.."C"..tostring(chevron)
        if stargate_chevron_getElement(futureID) then
            --outputDebugString("Activating already active chevron! GateID: "..stargateID.."; Chevron: "..tostring(chevron), 1)
            return nil
        end

        if playSound == true then
            x, y, z = stargate_getPosition(stargateID)
            stargate_sound_play(stargateID, enum_soundDescription.GATE_CHEVRON_INCOMING)
        end
        local stargate = stargate_getElement(stargateID)
        x, y, z = stargate_getPosition(stargateID)
        local newChevron = createObject(1337, x, y, z)
        local chevronID = stargate_chevron_assignID(newChevron, stargateID, chevron)
        setElementData(newChevron, "number", chevron)
        setElementCollisionsEnabled(newChevron, true)
        stargate_chevron_setModel(chevronID, chevron)
    else
        chevronElement = stargate_getChevron(stargateID, chevron)
        if chevronElement then
            destroyElement(chevronElement)
        end
    end
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

function stargate_chevron_setModel(id, chevronNumber)
    triggerClientEvent("setElementModelClient", resourceRoot, stargate_chevron_getElement(id), MWID_c[chevronNumber])
end

function stargate_chevron_isActive(stargateID, chevron)
    chevron = stargate_chevron_getElement(stargateID.."C"..tostring(chevron))
    if chevron == nil then
        return false
    else
        return true
    end
end