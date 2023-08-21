-- gui_c.lua: GUI for planets module; client-side

GUI_MAX_PLANET_NAME_CHARS = 20
GUI_MAX_GALAXY_CHARS = 12

function planet_showUI()
    local screenW, screenH = guiGetScreenSize()
    
    dxDrawLine((screenW * 0.4036) - 1, (screenH * 0.0093) - 1, (screenW * 0.4036) - 1, screenH * 0.0306, tocolor(255, 254, 254, 65), 1, false)
    dxDrawLine(screenW * 0.5984, (screenH * 0.0093) - 1, (screenW * 0.4036) - 1, (screenH * 0.0093) - 1, tocolor(255, 254, 254, 65), 1, false)
    dxDrawLine((screenW * 0.4036) - 1, screenH * 0.0306, screenW * 0.5984, screenH * 0.0306, tocolor(255, 254, 254, 65), 1, false)
    dxDrawLine(screenW * 0.5984, screenH * 0.0306, screenW * 0.5984, (screenH * 0.0093) - 1, tocolor(255, 254, 254, 65), 1, false)
    dxDrawRectangle(screenW * 0.4036, screenH * 0.0093, screenW * 0.1948, screenH * 0.0213, tocolor(255, 254, 254, 50), false)
    dxDrawText("Planet name", (screenW * 0.4057) + 1, (screenH * 0.0093) + 1, (screenW * 0.5172) + 1, (screenH * 0.0306) + 1, tocolor(0, 0, 0, 62), 0.80, "pricedown", "left", "center", false, false, false, false, false)
    dxDrawText("Planet name", screenW * 0.4057, screenH * 0.0093, screenW * 0.5172, screenH * 0.0306, tocolor(255, 254, 254, 220), 0.80, "pricedown", "left", "center", false, false, false, false, false)
    dxDrawText("Galaxy name", (screenW * 0.5292) + 1, (screenH * 0.0093) + 1, (screenW * 0.5958) + 1, (screenH * 0.0306) + 1, tocolor(1, 0, 0, 95), 0.80, "pricedown", "right", "center", false, false, false, false, false)
    dxDrawText("Galaxy name", screenW * 0.5292, screenH * 0.0093, screenW * 0.5958, screenH * 0.0306, tocolor(255, 254, 254, 231), 0.80, "pricedown", "right", "center", false, false, false, false, false)
end