-- gui_s.lua: Module implementing DHD GUI; server-side

-- See: dhd_openGUI in gui_c.lua
function dhd_openGUI(player)
    triggerClientEvent(player, "dhd_openGUI_client", player)
end

-- See: dhd_closeGUI in gui_c.lua
function dhd_closeGUI(player)
    triggerClientEvent(player, "dhd_closeGUI_client", player)
end