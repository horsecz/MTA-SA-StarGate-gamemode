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


---
--- ELEMENT FUNCTIONS

function planet_getElementOccupiedPlanet(element)
    return (getElementData(element, "planet_occupied"))
end

function planet_isElementOnPlanet(planetID, element)
    return (planet_getElementOccupiedPlanet(element) == planetID)
end

function planet_setElementOccupiedPlanet(element, planetID)
    local ls_stats = planet_getPlanetAtmosphere(planetID)
    setElementData(element, "lifesupport", ls_stats)
    setElementData(element, "planet_occupied", planetID)
end 
