-- imports_s.lua_ Importing functions from other gate_* resources

enum_galaxy = (exports.stargate_gate:import_enum_galaxy())
enum_stargateDialType = (exports.stargate_gate:import_enum_stargateDialType())

function stargate_create(...)
    return (exports.stargate_gate:stargate_create(...))
end
