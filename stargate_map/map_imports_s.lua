-- imports_s.lua: Importing functions from other resources; server-side

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function models_getUnloadedObjectID(...)
    return (exports.stargate_models:models_getUnloadedObjectID(...))
end

function models_getObjectID(...)
    return (exports.stargate_models:models_getObjectID(...))
end