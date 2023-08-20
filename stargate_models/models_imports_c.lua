-- imports_c.lua: Importing functions from other gate_* resources; client-side

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)

function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    -- If the serverside event handler is not in the same resource, replace 'resourceRoot' with the appropriate element
    triggerServerEvent("onClientCallsServerFunction", resourceRoot , funcname, unpack(arg))
end

function array_size(...)
    return (exports.stargate_exports:array_size(...))
end

function array_push(array, value)
    if array == nil or array == {} or array == false then
        array = {}
        table.insert(array, 1, value)
    else
        table.insert(array, value)
    end
    return array
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function planet_getElementOccupiedGalaxy(...)
    return (exports.stargate_planets:planet_getElementOccupiedGalaxy(...))
end

function planet_getElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_getElementOccupiedPlanet(...))
end

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end

function stargate_getID(...)
    return (exports.stargate_gate:stargate_getID(...))
end

function stargate_ring_getID(...)
    return (exports.stargate_gate:stargate_ring_getID(...))
end

function stargate_getRingElement(...)
    return (exports.stargate_gate:stargate_getRingElement(...))
end

function stargate_getChevron(...)
    return (exports.stargate_gate:stargate_getChevron(...))
end

function stargate_getKawoosh(...)
    return (exports.stargate_gate:stargate_getKawoosh(...))
end

function stargate_getHorizon(...)
    return (exports.stargate_gate:stargate_getHorizon(...))
end

function stargate_getHorizonActivation(...)
    return (exports.stargate_gate:stargate_getHorizonActivation(...))
end

function stargate_getIris(...)
    return (exports.stargate_gate:stargate_getIris(...))
end

function stargate_hasIris(...)
    return (exports.stargate_gate:stargate_hasIris(...))
end