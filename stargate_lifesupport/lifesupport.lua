-- lifesupport.lua: Main module for lifesupport element of stargate gamemode; shared

-- Create lifesupport element
--- REQUIRED PARAMETERS:
--- OPTIONAL PARAMETERS:
--> oxygen          int     amount of oxygen available
--> temperature     int     current temperature
--> toxicity        int     atmosphere toxicity level
--> gravity         int     planet gravity
--- RETURNS:
--> Reference; life support element
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

-- Starts applying lifesupport stats effects from this resource start
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

-- Applies effects on element depending on lifesupport stats (kill players due to high temperature, low oxygen, etc.)
--- REQUIRED PARAMETERS:
--> element     reference       element which has life support (element) stats
--- RETURNS:
--> Boolean; true if stats were applied, false if life support data are invalid, nil if element has no lifesupport stats, nothing if no stat effects applied
function lifesupport_applyStatsOnElement(element)
    if not lifesupport_hasElementLifesupportStats(element) then
        return nil
    end

    local ls = lifesupport_getElementLifesupport(element)
    if ls == nil or ls == false or not isElement(ls) then
        return false
    end
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

-- Slowly kills/destroys element
--- REQUIRED PARAMETERS:
--> element     reference       element to destroy/kill
--> time        int             time [ms] which will take for element to be destroyed/killed
--> reason      string          reason for killing (accepting: "oxygen", "temperature", "toxicity", "gravity")
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