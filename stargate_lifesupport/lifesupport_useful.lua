-- useful.lua: Useful functions when working with stargate lifesupport element; shared

--- Lifesupport element attributes
--> oxygen          available oxygen in atmosphere
--> temperature     current temperature
--> toxicity        atmosphere toxicity
--> gravity         planet gravity

---
--- ELEMENT Functions
---

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

---
--- ATTRIBUTE Functions
---

-- Reset lifesupport stats to default values
--- REQUIRED PARAMETERS:
--> lifesupport     reference       lifesupport element
function lifesupport_reset(lifesupport)
    local o, t, tx, g = lifesupport_getPresetValues("DEFAULT")
    lifesupport_set(lifesupport, o, t, tx, g)
end

-- Sets all lifesupport values
--- REQUIRED PARAMETERS:
--> lifesupport     reference       lifesupport element
--> oxygen          int     amount of oxygen available
--> temperature     int     current temperature
--> toxicity        int     atmosphere toxicity level
--> gravity         int     planet gravity
function lifesupport_set(lifesupport, oxygen, gravity, temperature, toxicity)
    setElementData(lifesupport, "oxygen", oxygen)
    setElementData(lifesupport, "gravity", gravity)
    setElementData(lifesupport, "temperature", temperature)
    setElementData(lifesupport, "toxicity", toxicity)
end

-- Gets lifesupport stats from existing preset
--- REQUIRED PARAMETERS:
--> preset      string      present of lifesupport stats (accepts: "SA"; "EARTH", "DEFAULT")
--- RETURNS:
--> Int; oxygen value
--> Int; temperature value
--> Int; toxicity value
--> Int; gravity value
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

-- Gets all values from life support element
--- REQUIRED PARAMETERS:
--> lifesupport     reference       lifesupport element
--- RETURNS:
--> Int; oxygen value
--> Int; temperature value
--> Int; toxicity value
--> Int; gravity value
function lifesupport_getValues(lifesupport)
    local o = lifesupport_getOxygen(lifesupport)
    local t = lifesupport_getTemperature(lifesupport)
    local tx = lifesupport_getToxicity(lifesupport)
    local g = lifesupport_getGravity(lifesupport)
    return o, t, tx, g
end

-- Gets default value of given lifesupport attribute/stat
--- REQUIRED PARAMETERS:
--> ls_stat     string      lifesupport attribute (accepting: "oxygen", "temperature", "toxicity", "gravity")
--- RETURNS:
--> Int; default value of given stat
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