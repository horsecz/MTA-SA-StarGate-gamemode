-- handling_s.lua: Handling events and working with GUI - triggering client events; server-side
-- See handling_c.lua for description

function gui_showInfoWindow(title, text, duration)
    triggerClientEvent(resourceRoot, "gui_showInfoWindow", resourceRoot, title, text, duration)
end

function gui_showInfoModelsLoadingWindow()
    triggerClientEvent(resourceRoot, "gui_showInfoModelsLoadingWindow", resourceRoot)
end

function gui_removeInfoWindow()
    triggerClientEvent(resourceRoot, "gui_removeInfoWindow", resourceRoot)
end

function gui_removeInfoModelsLoadingWindow()
    triggerClientEvent(resourceRoot, "gui_removeInfoModelsLoadingWindow", resourceRoot)
end