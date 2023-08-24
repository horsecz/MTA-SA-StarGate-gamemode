-- imports_c.lua: Importing functions from other gate_* resources; client-side

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function global_setData(...)
    return (exports.stargate_exports:global_setData(...))
end

function showInfoModelsLoadingWindow(...)
    return (exports.stargate_gui:gui_showInfoModelsLoadingWindow(...))
end