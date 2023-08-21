-- gui_c.lua: GUI for lifesupport module; client-side

GUI_MAX_LS_PROPERTY_CHARS = 6

function lifesupport_showUI()
    local screenW, screenH = guiGetScreenSize()
    
    dxDrawRectangle(screenW * 0.7818, screenH * 0.3454, screenW * 0.1703, screenH * 0.1556, tocolor(0, 0, 0, 112), false)
    dxDrawLine(screenW * 0.7839, screenH * 0.3750, screenW * 0.9521, screenH * 0.3769, tocolor(0, 0, 0, 134), 1, false)
    dxDrawText("Atmosphere", (screenW * 0.7839) + 1, (screenH * 0.3454) + 1, (screenW * 0.9521) + 1, (screenH * 0.3713) + 1, tocolor(0, 0, 0, 193), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
    dxDrawText("Atmosphere", screenW * 0.7839, screenH * 0.3454, screenW * 0.9521, screenH * 0.3713, tocolor(232, 232, 232, 230), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
    dxDrawText("Oxygen", screenW * 0.7870, screenH * 0.3861, screenW * 0.8630, screenH * 0.4065, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Gravity", screenW * 0.7870, screenH * 0.4713, screenW * 0.8630, screenH * 0.4917, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Toxicity", screenW * 0.7870, screenH * 0.4454, screenW * 0.8630, screenH * 0.4657, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Temperature", screenW * 0.7870, screenH * 0.4157, screenW * 0.8630, screenH * 0.4361, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("999+ ~C", screenW * 0.8870, screenH * 0.4157, screenW * 0.9469, screenH * 0.4398, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText("999+ ~C", screenW * 0.8870, screenH * 0.4454, screenW * 0.9469, screenH * 0.4657, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText("999+ ~C", screenW * 0.8870, screenH * 0.4713, screenW * 0.9469, screenH * 0.4917, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText("BBBBBB", screenW * 0.8870, screenH * 0.3843, screenW * 0.9469, screenH * 0.4083, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)

end