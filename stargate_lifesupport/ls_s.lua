-- ls_s.lua: Main script for server-side stargate_lifesupport

-- apply lifesupport effects from resource start
function lifesupport_start()
    setTimer(function()
        for i,p in ipairs(getElementsByType("player")) do
            lifesupport_applyStatsOnElement(p)
        end
        for i,p in ipairs(getElementsByType("ped")) do
            lifesupport_applyStatsOnElement(p)
        end
    end, 1000, 0)
end
addEventHandler("onResourceStart", resourceRoot, lifesupport_start)

-- applies effects on element depending on ls stats
function lifesupport_applyStatsOnElement(element)
    if not lifesupport_hasElementLifesupportStats(element) then
        return nil
    end

    local ls = lifesupport_getElementLifesupport(element)
    local o, t, tx, g = lifesupport_getValues(ls)
    local ct = getElementData(ls, "ls_slowkill_timer")

    if o <= 1 then
        lifesupport_elementSlowKill(element, 1000*30, "oxygen")
        return true
    end
    if tx >= 5 then
        lifesupport_elementSlowKill(element, 1000*300, "toxicity")
        return true
    end
    if t > 60 then
        if t > 250 then
            if getElementType(element) == "ped" or getElementType(element) == "player" then
                killPed(element)
            else
                destroyElement(element)
            end
            outputChatBox("Extreme temperature! Death is immitent.", element)
        else
            lifesupport_elementSlowKill(element, 1000*120, "temperature")
        end
        return true
    end
    if g > 3 then
        lifesupport_elementSlowKill(element, 1000*10, "gravity")
        return true
    end

    if isTimer(ct) then -- all ok, stop killing
        killTimer(ct)
    end
end

-- slowly kills/destroys element
function lifesupport_elementSlowKill(element, time, reason)
    local ls = lifesupport_getElementLifesupport(element)
    local ct = getElementData(ls, "ls_slowkill_timer")
    if isTimer(ct) then
        return true
    end

    if reason == "oxygen" then
        outputChatBox("Dangerous levels of oxygen! You will die in 30 seconds", element)
    elseif reason == "temperature" then
        outputChatBox("Dangerous temperature levels! You will burn to death in 2 minutes", element)
    elseif reason == "toxicity" then
        outputChatBox("Toxic atmoshpere! Death in 5 minutes", element)
    elseif reason == "gravity" then
        outputChatBox("Extremely strong planet gravity! You die in 10 seconds", element)
    end
    local hmodif = math.floor(getElementHealth(element) / (time/1000))
    local t = setTimer(function(element, hmodif)
                            local h = getElementHealth(element) - hmodif
                            setElementHealth(element, h)
                            if h <= 0 then
                                if not getElementType(element) == "ped" and not getElementType(element) == "player" then
                                    destroyElement(element)
                                end
                            end
                        end, 1000, time/1000, element, hmodif)
    setElementData(ls, "ls_slowkill_timer", t)    
end

-- create lifesupport element

--- REQUIRED PARAMETERS:
--- none

--- OPTIONAL PARAMETERS:
--> oxygen
--> temperature
--> toxicity
--> gravity
function lifesupport_create(oxygen, temperature, toxicity, gravity)
    local ls = createElement("lifesupport")
    if oxygen == nil then
        oxygen = lifesupport_getDefaultValue("oxygen")
    end
    if temperature == nil then
        temperature = lifesupport_getDefaultValue("temperature")
    end
    if toxicity == nil then
        toxicity = lifesupport_getDefaultValue("toxicity")
    end
    if gravity == nil then
        gravity = lifesupport_getDefaultValue("gravity")
    end

    setElementData(ls, "oxygen", oxygen)
    setElementData(ls, "gravity", gravity)
    setElementData(ls, "temperature", temperature)
    setElementData(ls, "toxicity", toxicity)
    --outputDebugString("[LS] Created lifesupport element with values ("..tostring(oxygen)..","..tostring(temperature)..","..tostring(toxicity)..","..tostring(gravity)..")")
    return ls
end

-- reset lifesupport stats to default values
function lifesupport_reset(lifesupport)
    local o, t, tx, g = lifesupport_getPresetValues("DEFAULT")
    lifesupport_set(lifesupport, o, t, tx, g)
end

function lifesupport_set(lifesupport, oxygen, gravity, temperature, toxicity)
    setElementData(lifesupport, "oxygen", oxygen)
    setElementData(lifesupport, "gravity", gravity)
    setElementData(lifesupport, "temperature", temperature)
    setElementData(lifesupport, "toxicity", toxicity)
end

-- returns lifesupport stats from existing preset
function lifesupport_getPresetValues(preset)
    local o = nil
    local t = nil
    local tx = nil
    local g = nil
    if preset == "SA" or preset == "EARTH" or preset == "DEFAULT" then
        o = lifesupport_getDefaultValue("oxygen")
        t = lifesupport_getDefaultValue("temperature")
        tx = lifesupport_getDefaultValue("toxicity")
        g = lifesupport_getDefaultValue("gravity")
    end
    return o, t, tx, g
end

function lifesupport_getValues(lifesupport)
    local o = lifesupport_getOxygen(lifesupport)
    local t = lifesupport_getTemperature(lifesupport)
    local tx = lifesupport_getToxicity(lifesupport)
    local g = lifesupport_getGravity(lifesupport)
    return o, t, tx, g
end

---
--- GETTERS

function lifesupport_getDefaultValue(ls_stat)
    if ls_stat == "oxygen" then
        return 21
    elseif ls_stat == "temperature" then
        return 20
    elseif ls_stat == "toxicity" then
        return 0
    elseif ls_stat == "gravity" then
        return 1
    end
end

function lifesupport_getOxygen(lifesupport)
    return (getElementData(lifesupport, "oxygen"))
end

function lifesupport_getTemperature(lifesupport)
    return (getElementData(lifesupport, "temperature"))
end

function lifesupport_getToxicity(lifesupport)
    return (getElementData(lifesupport, "toxicity"))
end

function lifesupport_getGravity(lifesupport)
    return (getElementData(lifesupport, "gravity"))
end


function lifesupport_setOxygen(lifesupport, value)
    return (setElementData(lifesupport, "oxygen", value))
end

function lifesupport_setTemperature(lifesupport, value)
    return (setElementData(lifesupport, "temperature", value))
end

function lifesupport_setToxicity(lifesupport, value)
    return (setElementData(lifesupport, "toxicity", value))
end

function lifesupport_setGravity(lifesupport, value)
    return (setElementData(lifesupport, "gravity", value))
end

---
--- ELEMENT FUNCTIONS

function lifesupport_setElementLifesupport(element, lifesupport)
    return (setElementData(element, "lifesupport", lifesupport))
end

function lifesupport_getElementLifesupport(element)
    return (getElementData(element, "lifesupport"))
end

function lifesupport_hasElementLifesupportStats(element)
    local ls = getElementData(element, "lifesupport")
    if ls == nil or ls == false then
        return false
    else
        return true
    end
end