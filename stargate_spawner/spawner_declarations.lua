-- declarations.lua: Module for global variables script declarations; shared

-- Planet names
enum_planetName = {
    [0] = "San Andreas",
    [1] = "Earth",
    [2] = "Icarus",

    [6969] = "Development world",
    [4242] = "Sandbox world"
}

-- Planet dimensions
enum_planetDimension = {
    SanAndreas = 0,
    Earth = 1,
    Icarus = 2,

    DevelopmentWorld = 6969,
    SandboxWorld = 4242
}

-- Stargate addresses
enum_stargateAddress = {
    SanAndreas = { 10, 19, 24, 5, 32, 13 },
    Earth = { 23, 11, 15, 4, 9, 31 },
    Icarus = { 35, 4, 33, 15, 9, 3 },

    Atlantis = { 19, 3, 35, 15, 10, 24 }
}