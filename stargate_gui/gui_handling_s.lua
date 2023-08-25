-- handling_s.lua: Handling events and working with GUI - triggering client events; server-side
-- See handling_c.lua for description

function gui_showInfoWindow(player, title, text, duration)
    triggerClientEvent(player, "gui_showInfoWindow", player, title, text, duration)
end

function gui_showInfoModelsLoadingWindow(player)
    triggerClientEvent(player, "gui_showInfoModelsLoadingWindow", player)
end

function gui_removeInfoWindow(player)
    triggerClientEvent(player, "gui_removeInfoWindow", player)
end

function gui_removeInfoModelsLoadingWindow(player)
    triggerClientEvent(player, "gui_removeInfoModelsLoadingWindow", player)
end