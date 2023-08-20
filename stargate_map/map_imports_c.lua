-- imports_c.lua: Importing functions from other resources; client-side

function models_loadModelManually(...)
    return (exports.stargate_models:models_loadModelManually(...))
end

function models_getObjectID(...)
    return (exports.stargate_models:models_getObjectID(...))
end