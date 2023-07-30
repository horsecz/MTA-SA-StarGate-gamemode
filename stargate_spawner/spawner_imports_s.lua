-- imports_s.lua_ Importing functions from other gate_* resources

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())
enum_stargateDialType = (exports.stargate_gate:import_enum_stargateDialType())

function planet_create(...)
    return (exports.stargate_planets:planet_create(...))
end

function lifesupport_create(...)
    return (exports.stargate_lifesupport:lifesupport_create(...))
end

function stargate_create(...)
    return (exports.stargate_gate:stargate_create(...))
end

function stargate_getGalaxy(...)
    return (exports.stargate_gate:stargate_getGalaxy(...))
end

function dhd_create(...)
    return (exports.stargate_dhd:dhd_create(...))
end

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end