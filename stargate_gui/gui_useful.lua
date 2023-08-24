-- useful.lua: Useful functions when working with Stargate GUI; shared

-- PLAYER Element
--> gui_key_open        string; key for opening any GUI window (action-key)
--> gui_key_close       string; key for closing any GUI window
--> gui_key_openclose   string; key for both opening and closing GUI window


function gui_getKeyOpen(player)
    return (getElementData(player, "gui_key_open"))
end

function gui_getKeyClose(player)
    return (getElementData(player, "gui_key_close"))
end

function gui_getKeyOpenClose(player)
    return (getElementData(player, "gui_key_openclose"))
end


function gui_setKeyOpen(player, key)
    return (getElementData(player, "gui_key_open", key))
end

function gui_setKeyClose(player, key)
    return (getElementData(player, "gui_key_close", key))
end

function gui_setKeyOpenClose(player, key)
    return (getElementData(player, "gui_key_openclose", key))
end