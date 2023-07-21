-- imports_s.lua_ Importing functions from other gate_* resources

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

function array_equal(a, b)
    return (exports.stargate_exports:array_equal(a, b))
end

function array_get(a, b)
    return (exports.stargate_exports:array_get(a, b))
end

function array_set(a, b, c)
    return (exports.stargate_exports:array_set(a, b, c))
end

function array_clear(a)
    return (exports.stargate_exports:array_clear(a))
end

function array_new(a)
    return (exports.stargate_exports:array_new(a))
end

function array_size(a)
    return (exports.stargate_exports:array_size(a))
end

function array_pop(a)
    return (exports.stargate_exports:array_pop(a))
end

function array_push(a, b)
    return (exports.stargate_exports:array_push(a, b))
end