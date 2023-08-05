    -- planets_s.lua: Main script for server-side stargate_planets

PLANET_LIST = {}

function initServer()
    PLANET_LIST = global_getData("PLANET_LIST")
end
addEventHandler("onResourceStart", resourceRoot, initServer)

--- create new planet
---

--- REQUIRED PARAMETERS:
--> dimension   world dimension in which will planet take place
--> galaxy      galaxy in which is planet located (enum_galaxy)

--- OPTIONAL PARAMETERS:
--> name        name of the planet
--- default:    random name depending on galaxy (MW: PXX-XXX; PG: MXX-XXX; UN: U-XXXXX)
--> ls_stats    lifesupport stats for planet (see stargate_lifesupport script&element)
--- default:    default lifesupport values (San Andreas/Earth defaults)
--> cx, cy, cz  planet center coordinates
--- default:    0,0,0

--- OUTPUT:
--> planet element
function planet_create(dimension, galaxy, name, ls_stats, cx, cy, cz)
    if not name then
        name = planet_createRandomName(dimension, galaxy)
    end
    if not cx then
        cx = 0
    end
    if not cy then
        cy = 0
    end
    if not cz then
        cz = 0
    end
    
    local id = "PLANET_"..dimension
    local planet = createElement("planet", id)
    
    setElementData(planet, "galaxy", galaxy)
    setElementData(planet, "name", name)
    setElementData(planet, "dimension", dimension)
    setElementData(planet, "cx", cx)
    setElementData(planet, "cy", cy)
    setElementData(planet, "cz", cz)    

    local checkResult = planet_createCheck(planet)
    if checkResult == true then
        if not ls_stats then
            ls_stats = lifesupport_create()
        end
        setElementData(planet, "lifesupport", ls_stats)
        local o = getElementData(ls_stats, "oxygen")
        local t = getElementData(ls_stats, "temperature")
        local tx = getElementData(ls_stats, "toxicity")
        local g = getElementData(ls_stats, "gravity")

        PLANET_LIST = array_push(PLANET_LIST, planet)
        global_setData("PLANET_LIST", PLANET_LIST)
        outputDebugString("[PLANETS] Created planet ('"..name.."'; dimension "..tostring(dimension).."; galaxy "..tostring(galaxy)..", center ["..tostring(cx)..","..tostring(cy)..","..tostring(cz).."], atmosphere {O:"..tostring(o).."%,T:"..tostring(t).."C,TX:"..tostring(tx).."T,G:"..tostring(g).."G})")
        return planet
    else
        destroyElement(planet)
        return nil
    end
end

function planet_createRandomName(dimension, galaxy)
    local GX = nil
    local name = "Unknown name"
    local fmt = 0

    if galaxy == enum_galaxy.MILKYWAY then
        GX = "P"
    elseif galaxy == enum_galaxy.PEGASUS then
        GX = "M"
    elseif galaxy == enum_galaxy.UNIVERSE then
        GX = "U"
        fmt = 1
    else
        GX = "P"
        fmt = 2
    end

    if fmt == 0 then
        local NUM1 = tostring(math.random(10,99))
        local NUM2 = tostring(math.random(100,999))
        name = GX..NUM1.."-"..NUM2
    elseif fmt == 1 then
        local NUM = tostring(math.random(10000,99999))
        name = GX.."-"..NUM
    else
        local NUM = tostring(math.random(10000,99999))
        name = GX..NUM
    end
    return name
end

function planet_createCheck(planet)
    local planetID = planet_getPlanetID(planet)
    local name = planet_getPlanetName(planetID)
    local dimension = planet_getPlanetDimension(planetID)
    local galaxy = planet_getPlanetGalaxy(planetID)
    PLANET_LIST = global_getData("PLANET_LIST")

    for i,p in pairs(PLANET_LIST) do
        local c_id = planet_getPlanetID(p)
        local c_name = planet_getPlanetName(c_id)
        local c_dimension = planet_getPlanetDimension(c_id)
        local c_galaxy = planet_getPlanetGalaxy(c_id)
        if dimension == c_dimension then
            outputDebugString("[PLANETS] Planet "..name.." for dimension "..tostring(dimension).." was not created. (has same dimension as "..c_name..")", 2)
            return false
        elseif name == c_name then
            if galaxy == c_galaxy then
                outputDebugString("[PLANETS] Planet "..name.." for dimension "..tostring(dimension).." has same name as another planet in same galaxy.", 2)
            end
        end
    end
    return true
end


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
    return (tonumber(getElementData(planet_getPlanetElement(planetID), "dimension")))
end

function planet_getPlanetGalaxy(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "galaxy"))
end

function planet_getPlanetName(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "name"))
end

function planet_getPlanetAtmosphere(planetID)
    return (getElementData(planet_getPlanetElement(planetID), "lifesupport"))
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

function planet_isElementOnPlanet(planetID, element)
    return (planet_getElementOccupiedPlanet(element) == planetID)
end

function planet_setElementOccupiedPlanet(element, planetID, needsLs)
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
    return true
end