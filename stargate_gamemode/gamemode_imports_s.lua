-- imports_s.lua: Importing functions from other gate_* resources; server-side

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end

function lifesupport_create(...)
    return (exports.stargate_lifesupport:lifesupport_create(...))
end

function lifesupport_setElementLifesupport(...)
    return (exports.stargate_lifesupport:lifesupport_setElementLifesupport(...))
end

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function array_new(...)
    return (exports.stargate_exports:array_new(...))
end

function array_remove(...)
    return (exports.stargate_exports:array_remove(...))
end

function array_contains(...)
    return (exports.stargate_exports:array_contains(...))
end

function array_size(...)
    return (exports.stargate_exports:array_size(...))
end

function array_clear(...)
    return (exports.stargate_exports:array_clear(...))
end

function array_get(...)
    return (exports.stargate_exports:array_get(...))
end

function global_addData(key, value)
    return (setElementData(global_getElement(), key, value))
end

function global_getData(key)
    return (getElementData(global_getElement(), key))
end

function global_setData(key)
    return (global_addData(key, value))
end

function global_removeData(key)
    return (global_setData(key, nil))
end