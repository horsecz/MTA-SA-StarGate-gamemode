-- commands.lua: Commands available to players all time (except exceptions ...)

---
--- DEVELOPMENT COMMANDS
---
--- (won't be available in final release)

-- Set players position
addCommandHandler("pos", function(src, cmd, x, y, z)
    setElementPosition(src, tonumber(x), tonumber(y), tonumber(z))
end)

-- Set players occupied planet/dimension
addCommandHandler("dim", function(src, cmd, d)
    planet_setElementOccupiedPlanet(src, "PLANET_"..tostring(d), true)
end)

-- Gets player current position or if given coordinates, moves player by these given coordinates
addCommandHandler("mypos", function(src, cmd, x, y, z)
    local cx, cy, cz = getElementPosition(src)
    if not x then
        outputChatBox("Your position is "..tostring(cx)..", "..tostring(cy)..", "..tostring(cz))
        return true
    else
        setElementPosition(src, cx+tonumber(x), cy+tonumber(y), cz+tonumber(z))
    end
end)