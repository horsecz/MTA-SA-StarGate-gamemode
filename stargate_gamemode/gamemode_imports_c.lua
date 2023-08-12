-- imports_s.lua: Importing functions from other gate_* resources

function planet_setElementOccupiedPlanet(...)
    return (exports.stargate_planets:planet_setElementOccupiedPlanet(...))
end