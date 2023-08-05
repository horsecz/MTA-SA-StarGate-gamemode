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

function models_getElementModelAttribute(...)
    return (exports.stargate_exports:models_getElementModelAttribute(...))
end

function models_setElementModelAttribute(...)
    return (exports.stargate_exports:models_setElementModelAttribute(...))
end

function energy_device_create(...)
    return (exports.stargate_energy:energy_device_create(...))
end

function energy_device_attachToElement(...)
    return (exports.stargate_energy:energy_device_attachToElement(...))
end

function energy_device_energyRequirementsMet(...)
    return (exports.stargate_energy:energy_device_energyRequirementsMet(...))
end

function energy_device_setConsumption(...)
    return (exports.stargate_energy:energy_device_setConsumption(...))
end

function energy_device_setStorage(...)
    return (exports.stargate_energy:energy_device_setStorage(...))
end

function energy_device_setProduction(...)
    return (exports.stargate_energy:energy_device_setProduction(...))
end

function energy_device_getMaxProduction(...)
    return (exports.stargate_energy:energy_device_getMaxProduction(...))
end

function energy_beginTransfer(...)
    return (exports.stargate_energy:energy_beginTransfer(...))
end




function planet_getElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_getElementOccupiedPlanet(...))
end

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end




function spawner_gateList_add(...)
    return (exports.stargate_spawner:spawner_gateList_add(...))
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

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end