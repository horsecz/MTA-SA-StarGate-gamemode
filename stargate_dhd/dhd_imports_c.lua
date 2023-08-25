-- imports_c.lua: Importing functions from other resources; client-side

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

enum_stargateDialType = (exports.stargate_gate:import_enum_stargateDialType())

function gui_getKeyOpen(...)
    return (exports.stargate_gui:gui_getKeyOpen(...))
end

function gui_getKeyClose(...)
    return (exports.stargate_gui:gui_getKeyClose(...))
end

function gui_showInfoWindow(...)
    return (exports.stargate_gui:gui_showInfoWindow(...))
end

function stargate_getForceDialType(...)
    return (exports.stargate_gate:stargate_getForceDialType(...))
end

function stargate_getID(...)
    return (exports.stargate_gate:stargate_getID(...))
end

function stargate_getAddress(...)
    return (exports.stargate_gate:stargate_getAddress(...))
end

function stargate_getCloseTimer(...)
    return (exports.stargate_gate:stargate_getCloseTimer(...))
end

function stargate_getConnectionID(...)
    return (exports.stargate_gate:stargate_getConnectionID(...))
end

function stargate_abortDial(...)
    return (exports.stargate_gate:stargate_abortDial(...))
end

function stargate_isActive(...)
    return (exports.stargate_gate:stargate_isActive(...))
end

function stargate_isOpen(...)
    return (exports.stargate_gate:stargate_isOpen(...))
end

function stargate_getIncomingStatus(...)
    return (exports.stargate_gate:stargate_getIncomingStatus(...))
end

function stargate_wormhole_close(...)
    return (exports.stargate_gate:stargate_wormhole_close(...))
end

function stargate_dial(...)
    return (exports.stargate_gate:stargate_dial(...))
end

function planet_getPlanetName(...)
    return (exports.stargate_planets:planet_getPlanetName(...))
end

function planet_getPlanetGalaxyString(...)
    return (exports.stargate_planets:planet_getPlanetGalaxyString(...))
end

function planet_getDimensionPlanet(...)
    return (exports.stargate_planets:planet_getDimensionPlanet(...))
end

function planet_getPlanetID(...)
    return (exports.stargate_planets:planet_getPlanetID(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end