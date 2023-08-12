-- planet_c.lua: Main script for client-side stargate_planets

---
--- GETTERS

function planet_getPlanetElement(planetID)
    local planet = getElementByID(planetID)
    if getElementType(planet) == "planet" then
        return planet
    else
        return nil
    end
end

function planet_getPlanetID(planet)
    return (getElementID(planet))
end

-- returns planet assigned to given dimension (nil if none)
function planet_getDimensionPlanet(dimension)
    local pl = global_getData("PLANET_LIST")
    for i,p in pairs(pl) do
        if planet_getPlanetDimension(dimension) == dimension then
            return p
        end
    end
    return nil
end

-- returns dimension in which is this planet located
function planet_getPlanetDimension(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "dimension"))
end

function planet_getPlanetGalaxy(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "galaxy"))
end

function planet_getPlanetName(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "name"))
end

function planet_getPlanetAtmosphere(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "atmosphere"))
end

function planet_getPlanetCenterPosition(planetID)
    local cx = getElementData(planet_getPlanetElement(planetID), "cx")
    local cy = getElementData(planet_getPlanetElement(planetID), "cy")
    local cz = getElementData(planet_getPlanetElement(planetID), "cz")
    return cx, cy, cz
end

function planet_isPlanet(planetID)
    if (planet_getPlanetElement(planetID)) == false or (planet_getPlanetElement(planetID)) == nil then
        return false
    else
        return true
    end
end


---
--- ELEMENT FUNCTIONS

function planet_getElementOccupiedPlanet(element)
    return (getElementData(element, "planet_occupied"))
end

function planet_getElementOccupiedGalaxy(element)
    local planet = planet_getElementOccupiedPlanet(element)
    return (planet_getPlanetGalaxy(planet))
end

function planet_isElementOnPlanet(planetID, element)
    return (planet_getElementOccupiedPlanet(element) == planetID)
end

function planet_setElementOccupiedPlanet(element, planetID, needsLs, resourceStart)
    if not planet_isPlanet(planetID) then
        outputDebugString("[PLANETS] Element "..getElementID(element).." was not set to nonexisting planet dimension "..planetID, 2)
        return false
    end    
    local ls_stats = planet_getPlanetAtmosphere(planetID)
    local dimension = planet_getPlanetDimension(planetID)
    
    if not needsLs then
        needsLs = false
    end
    if needsLs == true then
        setElementData(element, "lifesupport", ls_stats)
    end
    setElementData(element, "planet_occupied", planetID)
    setElementDimension(element, dimension)

    if getElementType(element) == "player" then
        if not resourceStart then
            models_load_autoPlanetModelsLoad()
        end
    end
    return true
end