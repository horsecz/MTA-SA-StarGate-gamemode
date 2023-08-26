-- commands_s.lua: Commands for stargate; server-side

-- Attach stargate to players vehicle
addCommandHandler("sgattach", function(src, cmd, sgid)
    if not sgid then
        outputChatBox("Wrong sgid!")
        return false
    end
    if not getPedOccupiedVehicle(src) then
        outputChatBox("You are not in vehicle!")
        return false
    end
    stargate_attachToElement(sgid, getPedOccupiedVehicle(src), 0,0,2, 90)
end)