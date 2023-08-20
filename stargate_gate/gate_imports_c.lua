-- imports_c.lua: Importing functions from other gate_* resources; client-side

function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)

function models_getElementModelAttribute(...)
    return (exports.stargate_exports:models_getElementModelAttribute(...))
end

function models_setElementModelAttribute(...)
    return (exports.stargate_exports:models_setElementModelAttribute(...))
end

function setElementModelClient(...)
    return (exports.stargate_models:setElementModelClient(...))
end

function planet_getElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_getElementOccupiedPlanet(...))
end

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end

function planet_getPlanetDimension(...)
    return (exports.stargate_planets:planet_getPlanetDimension(...))
end

function energy_beginTransfer(...)
    return (exports.stargate_energy:energy_transfer(...))
end