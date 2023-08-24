-- imports_c.lua: Importing functions from other resources; client-side

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())

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

function stargate_abortDial(...)
    return (exports.stargate_gate:stargate_abortDial(...))
end

function stargate_wormhole_close(...)
    return (exports.stargate_gate:stargate_wormhole_close(...))
end

function planet_getName(...)
    return (exports.stargate_planets:planet_getName(...))
end

function planet_getPlanetGalaxyString(...)
    return (exports.stargate_planets:planet_getPlanetGalaxyString(...))
end

function planet_getPlanetDimension(...)
    return (exports.stargate_planets:planet_getPlanetDimension(...))
end

function planet_getPlanetID(...)
    return (exports.stargate_planets:planet_getPlanetID(...))
end

function global_getData(...)
    return (exports.stargate_exports:global_getData(...))
end