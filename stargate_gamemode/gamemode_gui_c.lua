-- gui_c.lua: Gamemode GUI module; client-side

GUI_INFO_WINDOW_TEXT = nil
GUI_INFO_WINDOW_TITLE = nil
GUI_INFO_WINDOW_DURATION = 5000
GUI_INFO_WINDOW_DISPLAYED = false

-- Start rendering UI at resource start; show models loading notification
function onClientResourceStart()
    showInfoModelsLoadingWindow()
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

---
--- RENDERING AND PROCESSING
---

-- Shows window with some information
--- REQUIRED PARAMETERS:
--> title       string      window title
--> text        string      content
--- OPTIONAL PARAMTERS:
--> duration    int         duration for which will be window displayed [ms]
--- RETURNS:
--> Bool; true if window was displayed or false if not (because other window is being displayed)
function showInfoWindow(title, text, duration)
    if GUI_INFO_WINDOW_DISPLAYED == true then
        return false
    end

    GUI_INFO_WINDOW_TEXT = text
    GUI_INFO_WINDOW_TITLE = title
    GUI_INFO_WINDOW_DURATION = duration
    if not duration then
        GUI_INFO_WINDOW_DURATION = 5000
    end
    
    
    addEventHandler("onClientRender", getRootElement(), infoWindow)
    setTimer(removeInfoWindow, GUI_INFO_WINDOW_DURATION, 1)
    GUI_INFO_WINDOW_DISPLAYED = true
    return true
end

-- Shows models loading window
--- REQUIRED PARAMETERS:
--> title       string      window title
--> text        string      content
function showInfoModelsLoadingWindow(title, text)
    addEventHandler("onClientRender", getRootElement(), infoModelsLoadingWindow)
    local rT = setTimer(removeInfoModelsLoadingWindow, 500, 0)
    setElementData(getLocalPlayer(), "gui_info_models_loading", rT)
end

-- Removes models loading window
function removeInfoModelsLoadingWindow()
    local rT = getElementData(getLocalPlayer(), "gui_info_models_loading")
    local mL = getElementData(getLocalPlayer(), "planet_models_loaded")
    if mL == true then
        if isTimer(rT) then
            killTimer(rT)
            removeEventHandler("onClientRender", getRootElement(), infoModelsLoadingWindow)
        end
    end
end

-- Removes info window
function removeInfoWindow()
    removeEventHandler("onClientRender", getRootElement(), infoWindow)
    GUI_INFO_WINDOW_DISPLAYED = false
end

---
--- COMMANDS
---

-- Command for showing info window
--- REQUIRED PARAMETERS:
--> Inherited from addCommandHandler
--> Inherited from showInfoWindow(...)
function showInfoWindowCommand(cmd, title, text, duration)
    if not title or not text then
        outputChatBox("[STARGATE:GAMEMODE] Invalid arguments! Syntax: /infowindow title text [duration]")
        return false
    end
    local r = showInfoWindow(title, text, tonumber(duration))
    if r == false then
        outputChatBox("[STARGATE:GAMEMODE] Cannot display info window. Another one is already being displayed!")
    end
end
addCommandHandler("infowindow", showInfoWindowCommand)

---
--- GUI
---

-- Info window UI 
function infoWindow(title, text)
    local screenW, screenH = guiGetScreenSize()

    dxDrawRectangle(screenW * 0.3448, screenH * 0.0398, screenW * 0.3047, screenH * 0.1148, tocolor(0, 0, 0, 121), false)
    dxDrawText(GUI_INFO_WINDOW_TITLE, screenW * 0.3542, screenH * 0.0398, screenW * 0.6401, screenH * 0.0704, tocolor(255, 255, 255, 215), 1.00, "bankgothic", "center", "bottom", false, false, false, false, false)
    dxDrawText(GUI_INFO_WINDOW_TEXT, screenW * 0.3542, screenH * 0.0796, screenW * 0.6401, screenH * 0.1417, tocolor(255, 255, 255, 184), 1.20, "sans", "center", "center", false, true, false, false, false)
    dxDrawLine(screenW * 0.3458, screenH * 0.0741, screenW * 0.6495, screenH * 0.0704, tocolor(0, 0, 0, 120), 1, false)
end

-- Info window when models are being loaded
function infoModelsLoadingWindow()
    local screenW, screenH = guiGetScreenSize()

    dxDrawRectangle(screenW * 0.3552, screenH * 0.3639, screenW * 0.3068, screenH * 0.1398, tocolor(0, 0, 0, 121), false)
    dxDrawText("Loading models ...", 728, 416, 1230, 512, tocolor(255, 255, 255, 215), 2.50, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText("This may take just few seconds.", 861, 517, 1099, 539, tocolor(255, 255, 255, 184), 1.00, "default", "center", "center", false, false, false, false, false)
end