-- imports_s.lua

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

function stargate_dial(...)
    return (exports.stargate_gate:stargate_dial(...))
end

function stargate_dialByID(...)
    return (exports.stargate_gate:stargate_dialByID(...))
end

function stargate_dialFail(...)
    return (exports.stargate_gate:stargate_dialFail(...))
end

function stargate_getAssignedDHD(...)
    return (exports.stargate_gate:stargate_getAssignedDHD(...))
end

function stargate_setAssignedDHD(...)
    return (exports.stargate_gate:stargate_setAssignedDHD(...))
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