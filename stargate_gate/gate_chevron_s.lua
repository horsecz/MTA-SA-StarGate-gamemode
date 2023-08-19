-- chevron_s.lua: Chevron element module; server-side

-- Create chevron object element and attach it to stargate
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
--> chevron         int         number of chevron (1-9) that is being created
--- RETURNS:
--> Reference; chevron object element
function stargate_chevron_create(stargateID, chevron)
    local x, y, z = stargate_getPosition(stargateID)
    local newChevron = createObject(1337, x, y, z)
    models_setElementModelAttribute(newChevron, "chevs"..tostring(chevron))
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

-- Shows or hides active chevron object element on stargate
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
--> chevron         int         number of chevron that is being activated (1-9)
--> active          bool        showing or hiding chevron?
--> playSound       bool        will be chevron activation sound played?
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

---
--- INTERNAL Functions
---

-- Assigns ID to new chevron object element
--- REQUIRED PARAMETERS:
--> chevron         reference       chevron object element
--> gateID          string          stargate ID, to which this chevron will be attached to
--> chevronNumber   int             number of chevron (1-9)
--- RETURNS:
--> String; new ID for chevron element
function stargate_chevron_assignID(chevron, gateID, chevronNumber)
    local id = gateID.."C"..tostring(chevronNumber)
    setElementID(chevron, id)
    return id
end