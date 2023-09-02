-- gui_s.lua: Module implementing DHD GUI; server-side

-- See: dhd_openGUI in gui_c.lua
function dhd_openGUI(player)
    if getElementData(player, "dhd_gui_isOpen") == false then
        triggerClientEvent(player, "dhd_openGUI_client", player)
    end
end

-- See: dhd_closeGUI in gui_c.lua
function dhd_closeGUI(player)
    if getElementData(player, "dhd_gui_isOpen") == true then
        triggerClientEvent(player, "dhd_closeGUI_client", player)
    end
end