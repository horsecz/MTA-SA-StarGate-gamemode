-- handling_c.lua: Working with GUI, handling events; client-side

-- Shows window with some information
--- REQUIRED PARAMETERS:
--> title       string      window title
--> text        string      content
--- OPTIONAL PARAMTERS:
--> duration    int         duration for which will be window displayed [ms]
--- RETURNS:
--> Bool; true if window was displayed or false if not (because other window is being displayed)
function gui_showInfoWindow(title, text, duration)
    if GUI_INFO_WINDOW_DISPLAYED == true then
        return false
    end

    GUI_INFO_WINDOW_TEXT = text
    GUI_INFO_WINDOW_TITLE = title
    GUI_INFO_WINDOW_DURATION = duration
    if not duration then
        GUI_INFO_WINDOW_DURATION = 5000
    end
    
    
    addEventHandler("onClientRender", getRootElement(), gui_infoWindow)
    setTimer(gui_removeInfoWindow, GUI_INFO_WINDOW_DURATION, 1)
    GUI_INFO_WINDOW_DISPLAYED = true
    return true
end
addEvent("gui_showInfoWindow", true)
addEventHandler("gui_showInfoWindow", localPlayer, gui_showInfoWindow)

-- Shows models loading window
function gui_showInfoModelsLoadingWindow()
    addEventHandler("onClientRender", getRootElement(), gui_infoModelsLoadingWindow)
    local rT = setTimer(gui_removeInfoModelsLoadingWindow, 500, 0)
    setElementData(getLocalPlayer(), "gui_info_models_loading", rT)
end
addEvent("gui_showInfoModelsLoadingWindow", true)
addEventHandler("gui_showInfoModelsLoadingWindow", localPlayer, gui_showInfoModelsLoadingWindow)


-- Removes models loading window
function gui_removeInfoModelsLoadingWindow()
    local rT = getElementData(getLocalPlayer(), "gui_info_models_loading")
    local mL = getElementData(getLocalPlayer(), "planet_models_loaded")
    if mL == true then
        if isTimer(rT) then
            killTimer(rT)
            removeEventHandler("onClientRender", getRootElement(), gui_infoModelsLoadingWindow)
        end
    end
end
addEvent("gui_removeInfoModelsLoadingWindow", true)
addEventHandler("gui_removeInfoModelsLoadingWindow", localPlayer, gui_removeInfoModelsLoadingWindow)

-- Removes info window
function gui_removeInfoWindow()
    removeEventHandler("onClientRender", getRootElement(), gui_infoWindow)
    GUI_INFO_WINDOW_DISPLAYED = false
end
addEvent("gui_removeInfoWindow", true)
addEventHandler("gui_removeInfoWindow", localPlayer, gui_removeInfoWindow)