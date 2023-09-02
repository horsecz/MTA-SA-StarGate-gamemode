-- imports_s.lua: Importing functions from other resources; server-side

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function array_size(...)
    return (exports.stargate_exports:array_size(...))
end

function models_getUnloadedObjectID(...)
    return (exports.stargate_models:models_getUnloadedObjectID(...))
end

function models_getObjectID(...)
    return (exports.stargate_models:models_getObjectID(...))
end

function energy_device_create(...)
    return (exports.stargate_energy:energy_device_create(...))
end

function energy_transfer(...)
    return (exports.stargate_energy:energy_transfer(...))
end

function stargate_getPlanetStargates(...)
    return (exports.stargate_gate:stargate_getPlanetStargates(...))
end