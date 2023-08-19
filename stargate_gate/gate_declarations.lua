-- declarations.lua: module for declaring global variables, constats, enumerations and more; shared

-- milkyway stargate
MW_RING_SPEED = 150    -- milkyway gate ring rotation speed [ms per symbol]; default 150
MW_RING_CHEVRON_LOCK = 1500 -- milkyway gate chevron lock time [ms]; default 1500
MW_RING_CHEVRON_LOCK_AE = 500 -- milkyway gate chevron unlock time [ms]; default 1500
MW_RING_CHEVRON_LOCK_FAST_DELAY = 1500 -- milkway gate last chevron lock delay [ms]; default 1500 
MW_RING_CHEVRON_LOCK_SLOW_DELAY = 5000 -- milkway gate chevron lock delay [ms]; 5000
MW_RING_ROTATE_PAUSE = 1250 -- milkyway gate ring rotation pause after chevron lock [ms]; default 1250
MW_INCOMING_CHVRN_DELAY = 1200 -- milkyway gate incoming wormhole chevron activate delay between activation [ms]; default 1200
MW_WORMHOLE_CREATE_DELAY = 500 -- milkyway gate wormhole creation delay (after succesful link) [ms]; default 500
MW_DIAL_FAIL_CHVRN_DELAY = 3000 -- milkyway gate chevrons turn off delay after dial failed [ms]; default 3000
MW_FASTDIAL_START_DELAY = 2500  -- milkyway gate fast dial begin delay [ms]; default 2500
MW_FASTDIAL_CHEVRON_DELAY = 1000 -- milkway gate fast dial chevron encode delay [ms]; default 1000

-- all stargates
GATE_OPEN_DELAY = 200   -- delay when stargate completed dialling and is about to open wormhole [ms]; default 200
GATE_ACTIVE_INCOMING_OPEN_DELAY = 3000 -- stargate open delay when dialling out and incoming wormhole happens [ms]; default 3000
GATE_IRIS_ACTIVATION_SPEED = 120 -- stargate milkyway iris de/activation (frame) speed [ms]; default 120

-- stargate wormhole
SG_WORMHOLE_OPEN_TIME = 38  -- stargate classic wormhole open time [s]; default 38
SG_VORTEX_ANIM_SPEED = 85 -- stargate vortex opening animation speed [ms]; default 115
SG_VORTEX_ANIM_TOP_DELAY = 300 -- stargate vortex opening animation delay (when vortex is greatest) [ms]; default 200
SG_HORIZON_ANIMATION_SPEED = 100 -- stargate horizon animation change speed [ms]; default 100; recommended 100-200
SG_HORIZON_ACTIVATE_SPEED = 50 -- stargate horizon opening/activation speed [ms]; default 150
SG_HORIZON_OPACITY = 65 -- stargate horizon object transparency [0-100]; default 75
SG_HORIZON_ANIMATION_BEGIN = SG_HORIZON_ANIMATION_SPEED*3,5 -- beginning of event horizon animation [ms]; depends on SG_HORIZON_ANIMATION_SPEED
SG_HORIZON_ALPHA = 255 - SG_HORIZON_OPACITY -- event horizon object element alpha; depends on SG_HORIZON_OPACITY

-- stargate energy values
GATE_ENERGY_IDLE = 1
GATE_ENERGY_DIAL = 1000
GATE_ENERGY_WORMHOLE = 100000

-- enums
enum_markerType = {
    NONE = -1,
    EVENTHORIZON = 0,
    VORTEX = 1
}

enum_stargateStatus = {
    DIAL_NO_ENERGY = -6,
    DIAL_SELF = -5,
    DIAL_GATE_INCOMING_TOGATE = -4,
    DIAL_GATE_INCOMING = -3,
    DIAL_UNKNOWN_ADDRESS = -2,
    UNKNOWN = -1,

    GATE_IDLE = 0,
    GATE_ACTIVE = 1,
    GATE_OPEN = 2,
    GATE_DISABLED = 3,
    GATE_GROUNDED = 4,

    WORMHOLE_NO_ENERGY = 5,
    WORMHOLE_CREATE_NO_ENERGY = 6
}

enum_galaxy = {
    UNKNOWN = -2,
    INVALID = -1,

    MILKYWAY = 0,
    PEGASUS = 1,
    UNIVERSE = 2,

    IDA = 3,
    ORI = 4
}

enum_stargateDialType = {
    SLOW = 0,
    FAST = 1,
    INSTANT = 2
}

enum_soundDescription = {
    GATE_DIAL_FAIL = 0,
    GATE_RING_ROTATE = 1,

    GATE_CHEVRON_LOCK = 2,
    GATE_CHEVRON_INCOMING = 3,

    GATE_VORTEX_OPEN = 4,
    GATE_HORIZON_TOUCH = 5,
    GATE_HORIZON = 6,

    GATE_CLOSE = 7,

    GATE_MW_IRIS_CLOSE = 8,
    GATE_MW_IRIS_OPEN = 9
}

---
--- EXPORT Functions
---

function import_enum_galaxy()
    return enum_galaxy
end

function import_enum_markerType()
    return enum_markerType
end

function import_enum_stargateStatus()
    return enum_stargateStatus
end

function import_enum_stargateDialType()
    return (enum_stargateDialType)
end

---
--- OTHER
---

function enum_stargateStatus.toString(v)
    if v == enum_stargateStatus.UNKNOWN or v == nil then
        return "Unknown status"
    elseif v == enum_stargateStatus.GATE_IDLE then
        return "Gate idle"
    elseif v == enum_stargateStatus.GATE_ACTIVE then
        return "Gate active"
    elseif v == enum_stargateStatus.GATE_OPEN then
        return "Gate open"
    elseif v == enum_stargateStatus.GATE_DISABLED then
        return "Gate disabled"
    elseif v == enum_stargateStatus.GATE_GROUNDED then
        return "Gate grounded"
    elseif v == enum_stargateStatus.DIAL_UNKNOWN_ADDRESS then
        return "Unknown address"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING then
        return "Incoming wormhole"
    elseif v == enum_stargateStatus.DIAL_GATE_INCOMING_TOGATE then
        return "Incoming wormhole (fromgate)"
    elseif v == enum_stargateStatus.DIAL_NO_ENERGY then
        return "Not enough energy to dial"
    elseif v == enum_stargateStatus.WORMHOLE_NO_ENERGY then
        return "Not enough energy to maintain wormhole"
    elseif v == enum_stargateStatus.WORMHOLE_CREATE_NO_ENERGY then
        return "Not enough energy to estabilish wormhole"
    elseif v == enum_stargateStatus.DIAL_SELF then
        return "Dialed itself"    
    end
end