-- commands_c.lua: Commands for GUI Module; client-side

-- Command for showing info window
--- REQUIRED PARAMETERS:
--> Inherited from addCommandHandler
--> Inherited from showInfoWindow(...)
function showInfoWindowCommand(cmd, title, text, duration)
    if not title or not text then
        outputChatBox("[STARGATE:GUI] Invalid arguments! Syntax: /infowindow title text [duration]")
        return false
    end
    local r = showInfoWindow(title, text, tonumber(duration))
    if r == false then
        outputChatBox("[STARGATE:GUI] Cannot display info window. Another one is already being displayed!")
    end
end
addCommandHandler("infowindow", gui_showInfoWindowCommand)