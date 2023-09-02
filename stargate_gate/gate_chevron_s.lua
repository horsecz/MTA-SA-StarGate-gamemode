-- chevron_s.lua: Chevron element module; server-side

-- Create chevron object element and attach it to stargate
-- > Milkyway -> creates chevrons 1 - 9
-- > Pegasus  -> creates chevrons 1 - 7;
--             > models for 8 and 9 are nonexistent -> creates chev1 model and rotates the object accordingly
-- > Universe -> creates chevrons with lights on (1)
--- REQUIRED PARAMETERS:
--> stargateID      string      ID of stargate
--> chevron         int         number of chevron (1-9) that is being created
--- RETURNS:
--> Reference; chevron object element
function stargate_chevron_create(stargateID, chevron)
    local x, y, z = stargate_getPosition(stargateID)
    local newChevron = createObject(1337, x, y, z)
    local gateType = stargate_galaxy_get(stargateID)

    if gateType == enum_galaxy.MILKYWAY then
        models_setElementModelAttribute(newChevron, "chevs"..tostring(chevron))
    elseif gateType == enum_galaxy.PEGASUS then
        if chevron < 3 then
            models_setElementModelAttribute(newChevron, "CHpeg"..tostring(chevron))
        elseif chevron < 8 then
            models_setElementModelAttribute(newChevron, "chpeg"..tostring(chevron))
        else
            models_setElementModelAttribute(newChevron, "CHpeg1")
            setElementPosition(newChevron, x, y+0.002, z)
            if chevron == 8 then
                setElementRotation(newChevron, 0, 240, 0)
            else -- chevron == 9
                setElementRotation(newChevron, 0, 199.85, 0)
            end
        end
    elseif gateType == enum_galaxy.UNIVERSE then
        if chevron == 1 then
            models_setElementModelAttribute(newChevron, "SGUCHEV")
        end
    end
    
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