-- gui_c.lua: GUI for planets module; client-side

GUI_MAX_PLANET_NAME_CHARS = 20
GUI_MAX_GALAXY_CHARS = 12

GUI_OCCUPIED_PLANET_NAME = nil
GUI_OCCUPIED_GALAXY_NAME = nil

-- Start rendering UI at resource start
function planet_ui_init()
    addEventHandler("onClientRender", getRootElement(), planet_ui_show)
end
addEventHandler("onClientResourceStart", resourceRoot, planet_ui_init)

-- Prepare data - text
-- > planet name
-- > galaxy
-- > string check
function planet_ui_prepare()
    local player_planet = planet_getElementOccupiedPlanet(getLocalPlayer())
    if not player_planet or not planet_isPlanet(player_planet) then
        GUI_OCCUPIED_PLANET_NAME = "?"
        GUI_OCCUPIED_GALAXY_NAME = "?"
        return false
    end

    local planet_name = planet_getPlanetName(player_planet)
    local planet_galaxy = planet_getPlanetGalaxyString(player_planet)

    if not planet_name then
        planet_name = "Unknown planet"
    end
    if not planet_galaxy then
        planet_galaxy = "Unknown"
    end

    if planet_name and string.len(planet_name) > GUI_MAX_PLANET_NAME_CHARS then
        planet_name = string.sub(planet_name, 1, GUI_MAX_PLANET_NAME_CHARS - 2)
        planet_name = planet_name .. ".."
    end
    if planet_galaxy and string.len(planet_galaxy) > GUI_MAX_PLANET_NAME_CHARS then
        planet_galaxy = string.sub(planet_galaxy, 1, GUI_OCCUPIED_GALAXY_NAME - 2)
        planet_galaxy = planet_galaxy .. ".."
    end

    GUI_OCCUPIED_PLANET_NAME = planet_name
    GUI_OCCUPIED_GALAXY_NAME = planet_galaxy
end

-- Show planet UI
function planet_ui_show()
    planet_ui_prepare()
    local screenW, screenH = guiGetScreenSize()
    
    dxDrawLine((screenW * 0.4036) - 1, (screenH * 0.0093) - 1, (screenW * 0.4036) - 1, screenH * 0.0306, tocolor(0, 0, 0, 112), 1, false)
    dxDrawLine(screenW * 0.5984, (screenH * 0.0093) - 1, (screenW * 0.4036) - 1, (screenH * 0.0093) - 1, tocolor(0, 0, 0, 112), 1, false)
    dxDrawLine((screenW * 0.4036) - 1, screenH * 0.0306, screenW * 0.5984, screenH * 0.0306, tocolor(0, 0, 0, 112), 1, false)
    dxDrawLine(screenW * 0.5984, screenH * 0.0306, screenW * 0.5984, (screenH * 0.0093) - 1, tocolor(0, 0, 0, 112), 1, false)
    dxDrawRectangle(screenW * 0.4036, screenH * 0.0093, screenW * 0.1948, screenH * 0.0213, tocolor(0, 0, 0, 112), false)
    dxDrawText(GUI_OCCUPIED_PLANET_NAME, (screenW * 0.4057) + 1, (screenH * 0.0093) + 1, (screenW * 0.5172) + 1, (screenH * 0.0306) + 1, tocolor(0, 0, 0, 62), 0.80, "pricedown", "left", "center", false, false, false, false, false)
    dxDrawText(GUI_OCCUPIED_PLANET_NAME, screenW * 0.4057, screenH * 0.0093, screenW * 0.5172, screenH * 0.0306, tocolor(255, 254, 254, 220), 0.80, "pricedown", "left", "center", false, false, false, false, false)
    dxDrawText(GUI_OCCUPIED_GALAXY_NAME, (screenW * 0.5292) + 1, (screenH * 0.0093) + 1, (screenW * 0.5958) + 1, (screenH * 0.0306) + 1, tocolor(1, 0, 0, 95), 0.80, "pricedown", "right", "center", false, false, false, false, false)
    dxDrawText(GUI_OCCUPIED_GALAXY_NAME, screenW * 0.5292, screenH * 0.0093, screenW * 0.5958, screenH * 0.0306, tocolor(255, 254, 254, 231), 0.80, "pricedown", "right", "center", false, false, false, false, false)
end