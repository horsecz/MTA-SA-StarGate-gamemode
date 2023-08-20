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

function global_addData(...)
    return (exports.stargate_exports:global_addData(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end

function global_removeData(...)
    return (exports.stargate_exports:global_removeData(...))
end