-- declarations.lua: Module for global variables script declarations; shared

-- Planet names
enum_planetName = {
    [0] = "San Andreas",
    [1] = "Earth",
    [2] = "Icarus base",
    [4] = "Abydos",
    [14] = "Random 1 (Green cave)",
    [16] = "Baals time machine",
    [17] = "Village",
    [20] = "P3R-272",
    
    [10] = "Atlantis",
    [8] = "Random 1 (Grass world)",
    [11] = "Random 2 (Storage)",
    [18] = "Random 3 (Snow ancient world)",

    [6] = "Destiny",
    [7] = "Desert",
    [9] = "Snow desert",
    [12] = "Cave hills",
    [13] = "Obelisk",

    [19] = "Asgard homeworld",

    [6969] = "Development world",
    [4242] = "Sandbox world"
}

-- Planet dimensions
enum_planetDimension = {
    SanAndreas = 0,
    Earth = 1,
    Icarus = 2,
    Abydos = 4,
    GreenCave = 14,
    Baals = 16,
    MWVillage = 17,
    P3R272 = 20,

    Atlantis = 10,
    GreenWorld = 8,
    StorageWorld = 11,
    SnowAncientShip = 18,
    
    Destiny = 6,
    UniDesert = 7,
    UniSnowDesert = 9,
    UniCave = 12,
    UniObelisk = 13,

    AsgardHomeworld = 19,

    DevelopmentWorld = 6969,
    SandboxWorld = 4242
}

-- Stargate addresses
enum_stargateAddress = {
    SanAndreas = { 10, 19, 24, 5, 32, 13 },
    Earth = { 23, 11, 15, 4, 9, 31 },
    Icarus = { 35, 4, 33, 15, 9, 3 },
    Abydos = { 9, 13, 19, 28, 32, 11 },
    GreenCave = { 1, 5, 9, 32, 15, 4 },
    Baals = { 31, 5, 25, 8, 16, 11 },
    MWVillage = { 24, 15, 11, 27, 34, 8 },
    P3R272 = { 6, 4, 2, 31, 15, 26 },

    Atlantis = { 19, 3, 35, 15, 10, 24 },
    GreenWorld = { 8, 31, 7, 30, 6, 29 },
    StorageWorld = { 4, 2, 6, 9, 15, 30 },
    SnowAncientShip = { 15, 14, 10, 21, 25, 9 },

    Destiny = { 9, 25, 2, 18, 32, 5, 38, 25, 11 },
    UniDesert = { 11, 15, 2, 22, 29, 35 },
    UniSnowDesert = { 11, 20, 3, 2, 1, 22 },
    UniCave = { 34, 31, 24, 21, 14, 11 },
    UniObelisk = { 5, 15, 25, 3, 13, 23 },

    AsgardHomeworld = { 22, 19, 11, 31, 5, 9 }
}