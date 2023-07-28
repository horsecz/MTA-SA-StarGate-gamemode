-- imports_s.lua_ Importing functions from other gate_* resources

SG_MW = nil

function import_gate_variables()
    SG_MW = (exports.stargate_gate:import_sg_mw())
end

function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    -- If the clientside event handler is not in the same resource, replace 'resourceRoot' with the appropriate element
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end

function stargate_setModel(...)
    return (exports.stargate_gate:stargate_setModel(...))
end

function stargate_ring_setModel(...)
    return (exports.stargate_gate:stargate_ring_setModel(...))
end