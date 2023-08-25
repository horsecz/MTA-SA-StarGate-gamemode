-- gui_c.lua: Main module for Stargate GUI; client-side

-- Initialize Stargate GUI Module; set global gui keys
function gui_init()
    gui_setKeyOpen(getLocalPlayer(), GUI_KEY_OPEN)
    gui_setKeyClose(getLocalPlayer(), GUI_KEY_CLOSE)
    gui_setKeyOpenClose(getLocalPlayer(), GUI_KEY_OPENCLOSE)
end
addEventHandler("onClientResourceStart", resourceRoot, gui_init)


-- Generic info window
function gui_infoWindow()
    local screenW, screenH = guiGetScreenSize()

    dxDrawRectangle(screenW * 0.3448, screenH * 0.0398, screenW * 0.3047, screenH * 0.1148, tocolor(0, 0, 0, 121), false)
    dxDrawText(GUI_INFO_WINDOW_TITLE, screenW * 0.3542, screenH * 0.0398, screenW * 0.6401, screenH * 0.0704, tocolor(255, 255, 255, 215), 1.00, "bankgothic", "center", "bottom", false, false, false, false, false)
    dxDrawText(GUI_INFO_WINDOW_TEXT, screenW * 0.3542, screenH * 0.0796, screenW * 0.6401, screenH * 0.1417, tocolor(255, 255, 255, 184), 1.20, "sans", "center", "center", false, true, false, false, false)
    dxDrawLine(screenW * 0.3458, screenH * 0.0741, screenW * 0.6495, screenH * 0.0704, tocolor(0, 0, 0, 120), 1, false)
end

-- Info window when models are being loaded
function gui_infoModelsLoadingWindow()
    local screenW, screenH = guiGetScreenSize()

    dxDrawRectangle(screenW * 0.3552, screenH * 0.3639, screenW * 0.3068, screenH * 0.1398, tocolor(0, 0, 0, 121), false)
    dxDrawText(GUI_INFO_MODELS_LOADING_TEXT, 728, 416, 1230, 512, tocolor(255, 255, 255, 215), 2.50, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText(GUI_INFO_MODELS_LOADING_SUBTEXT, 861, 517, 1099, 539, tocolor(255, 255, 255, 184), 1.00, "default", "center", "center", false, false, false, false, false)
end