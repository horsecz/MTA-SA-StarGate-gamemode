-- functions.lua: Useful functions for gamemode; shared

-- returns true/false
-- Checks if given element1 is in range of element2 (within specified radius)
--- REQUIRED PARAMETERS:
--> element1    reference   first element
--> element2    reference   second element
--> radius      int         radius range

--- RETURNS:
--> Bool; true if they are in range, false if not
function isElementInRange(element1, element2, radius)
    local x, y, z = getElementPosition(element1)
    local x2, y2, z2 = getElementPosition(element2)
    local d1 = getElementDimension(element1)
    local d2 = getElementDimension(element2)
    if d1 == d2 then
        if x < x2+radius and x > x2-radius then
            if y < y2+radius and y > y2-radius then
                if z < z2+radius and z > z2-radius then
                    return true
                end
            end
        end
    end
    return false
end

-- Checks if given element1 is in range of coordinates x2,y2,z2 within specified radius
--- REQUIRED PARAMETERS:
--> element1    reference   first element
--> x2, y2, z2  int         world coordinates
--> radius      int         radius range

--- RETURNS:
--> Bool; true if element is in range of these coordinates, false if not
function isElementInCoordinatesRange(element1, x2, y2, z2, radius)
    local x, y, z = getElementPosition(element1)
    if x < x2+radius and x > x2-radius then
        if y < y2+radius and y > y2-radius then
            if z < z2+radius and z > z2-radius then
            return true
            end
        end
    end
    return false
end