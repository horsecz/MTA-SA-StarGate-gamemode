-- imports_s.lua: Importing functions from other resources; server-side

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

function models_getElementModelAttribute(...)
    return (exports.stargate_exports:models_getElementModelAttribute(...))
end

function models_setElementModelAttribute(...)
    return (exports.stargate_exports:models_setElementModelAttribute(...))
end

function energy_device_create(...)
    return (exports.stargate_energy:energy_device_create(...))
end

function energy_device_attachToElement(...)
    return (exports.stargate_energy:energy_device_attachToElement(...))
end

function energy_device_energyRequirementsMet(...)
    return (exports.stargate_energy:energy_device_energyRequirementsMet(...))
end

function energy_device_setConsumption(...)
    return (exports.stargate_energy:energy_device_setConsumption(...))
end

function energy_device_getConsumption(...)
    return (exports.stargate_energy:energy_device_getConsumption(...))
end

function energy_device_getProduction(...)
    return (exports.stargate_energy:energy_device_getProduction(...))
end

function energy_device_getMaxProduction(...)
    return (exports.stargate_energy:energy_device_getMaxProduction(...))
end

function energy_device_setMaxProduction(...)
    return (exports.stargate_energy:energy_device_setMaxProduction(...))
end

function energy_device_getStorage(...)
    return (exports.stargate_energy:energy_device_getStorage(...))
end

function energy_beginTransfer(...)
    return (exports.stargate_energy:energy_transfer(...))
end


function planet_getElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_getElementOccupiedPlanet(...))
end

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end


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