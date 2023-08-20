-- dhd_c.lua: Module implementing dial home device (on client-side)

function dhd_openClassicGUI(stargateStatus)
    -- dhd gui
    -- different stargate status => different gui look & behavior
    -- inspired by garrys mod gui
        -- STATE 1 - inactive
        -- => sg address list; default list only local, canDialGalaxy=can see other "galaxy gates" or local
        -- => text input for manual address
        -- => select dial mode (if not forced => stargate->forceDialMode);
        -- => dial
        -- => help; instructions
        -- STATE 2 - dialling
        -- => stop
        -- => status
        -- STATE 3 - open
        -- => close
        -- => status
        -- STATE 4 - incoming
        -- => status
end

function dhd_openBaseGUI(stargateStatus)
    -- special DHD GUI for SGC (ATL; etc)
    -- all states together
    -- more control; more info
    -- iris control
    -- only slow dial
end