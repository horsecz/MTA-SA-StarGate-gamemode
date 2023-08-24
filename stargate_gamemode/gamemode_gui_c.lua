-- gui_c.lua: Gamemode GUI module; client-side

-- Show models loading notification at start
function onClientResourceStart()
    gui_showInfoModelsLoadingWindow()
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)
