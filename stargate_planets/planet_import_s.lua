-- import_s.lua: importing functions from other resources (server-sided)

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end


function lifesupport_create(...)
    return (exports.stargate_lifesupport:lifesupport_create(...))
end
