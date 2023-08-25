-- imports_c.lua: Importing functions from other gate_* resources; client-side

function models_load_autoPlanetModelsLoad(...)
    return (exports.stargate_models:models_load_autoPlanetModelsLoad(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end