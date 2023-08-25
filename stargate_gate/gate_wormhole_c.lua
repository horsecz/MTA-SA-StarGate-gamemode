-- wormhole_c.lua: Module for wormhole operations and functions; client-side

-- See stargate_wormhole_close in wormhole_s.lua
function stargate_wormhole_close(stargateIDFrom, stargateIDTo)
    triggerServerEvent("stargate_wormhole_close_client", resourceRoot, stargateIDFrom, stargateIDTo)
end