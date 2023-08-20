-- planets_s.lua: Main script for planets used in stargate gamemode; server-side

PLANET_LIST = {}

-- Initialize planet list on this resource start
function planet_initServer()
    PLANET_LIST = global_getData("PLANET_LIST")
end
addEventHandler("onResourceStart", resourceRoot, planet_initServer)

--- Create new planet element

--- REQUIRED PARAMETERS:
--> dimension   int                     world dimension in which will planet take place
--> galaxy      enum_galaxy     galaxy in which is planet located

--- OPTIONAL PARAMETERS:
--> name            string      name of the planet
--- default: random name depending on galaxy (Milkyway: PXX-XXX; Pegasus: MXX-XXX; Universe: U-XXXXX; Other: nil)
--> ls_stats        reference   lifesupport element - atmosphere stats for planet
--- default: default lifesupport values (San Andreas/Earth defaults)
--> cx, cy, cz      int         planet center coordinates
--- default: 0, 0, 0

--- RETURNS:
--> Reference; planet element or nil if creation failed (created planet is using same dimension as another planet)
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

-- Creates random name for new planet
-- > as it would name it Stargate computer in SGC (PXX-XXX or MXX-XXX or U-XXXXX format; X = random number)
-- > for other galaxies PXXXXX format is used (X = random number)
--- REQUIRED PARAMETERS:
--> galaxy      enum_galaxy      galaxy in which is planet located in
--- RETURNS:
--> String; name of the planet
function planet_createRandomName(galaxy)
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

    if fmt == 0 then    -- MW and PG; [P/M]XX-XXX format
        local NUM1 = tostring(math.random(10,99))
        local NUM2 = tostring(math.random(100,999))
        name = GX..NUM1.."-"..NUM2
    elseif fmt == 1 then    -- UN; [U]-XXXXX format
        local NUM = tostring(math.random(10000,99999))
        name = GX.."-"..NUM
    else -- other; [P]XXXXX format
        local NUM = tostring(math.random(10000,99999))
        name = GX..NUM
    end
    return name
end

-- Check if planet element can be created
--- REQUIRED PARAMETERS:
--> planet      reference       new planet element
--- RETURNS:
--> Bool; true if planet can be created or false if not (new planet will occupy dimension of existing planet) 
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