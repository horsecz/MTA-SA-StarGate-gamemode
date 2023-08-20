-- sound_s.lua: Stargate sounds module; server-side

-- Play sound at stargate position
--- REQUIRED PARAMETERS:
--> stargateID          string                  ID of stargate
--> soundDescription    enum_soundDescription   (type of) sound that will be played
--- OPTIONAL PARAMETERS:
--> soundDistance       int                     range in which will be sound heard
--- default if not specified:   125
function stargate_sound_play(stargateID, soundDescription, soundDistance)
    local x, y, z = stargate_getPosition(stargateID)
    local soundPath, soundAttrib = stargate_sound_convertDescription(soundDescription)
    local distance = soundDistance
    if not soundDistance then
        distance = 125
    end

    triggerClientEvent("clientPlaySound3D", root, stargateID, soundPath, x, y, z, distance, soundAttrib)
end

-- Convert sound description (from enum) to sound file path and attribute
--- REQUIRED PARAMETERS:
--> soundDescription        enum_soundDescription       (type of) sound
--- RETURNS:
--> String; file path of sound
--> String; sound attribute key name
function stargate_sound_convertDescription(soundDescription)
    local soundPath = nil
    local soundAttrib = nil
    if soundDescription == enum_soundDescription.GATE_DIAL_FAIL then
        soundPath = "sounds/mw_dial_fail.mp3"
        soundAttrib = "sound_dial_fail"
    elseif soundDescription == enum_soundDescription.GATE_RING_ROTATE then
        soundPath = "sounds/mw_ring_rotate_begin.mp3"
        soundAttrib = "sound_ring_rotate"
    elseif soundDescription == enum_soundDescription.GATE_CHEVRON_LOCK then
        soundPath = "sounds/mw_chevron_lock.mp3"
        soundAttrib = "sound_chevron_lock"
    elseif soundDescription == enum_soundDescription.GATE_CHEVRON_INCOMING then
        soundPath = "sounds/mw_chevron_incoming.mp3"
        soundAttrib = "sound_chevron_lock_incoming"
    elseif soundDescription == enum_soundDescription.GATE_MW_IRIS_CLOSE then
        soundPath = "sounds/mw_iris_close.mp3"
        soundAttrib = "sound_mw_iris_close"
    elseif soundDescription == enum_soundDescription.GATE_MW_IRIS_OPEN then
        soundPath = "sounds/mw_iris_open.mp3"
        soundAttrib = "sound_mw_iris_open"
    elseif soundDescription == enum_soundDescription.GATE_VORTEX_OPEN then
        soundPath = "sounds/vortex.mp3"
        soundAttrib = "sound_vortex"
    elseif soundDescription == enum_soundDescription.GATE_HORIZON_TOUCH then
        soundPath = "sounds/horizon_touch.mp3"
        soundAttrib = "sound_horizon_touch"
    elseif soundDescription == enum_soundDescription.GATE_CLOSE then
        soundPath = "sounds/gate_close.mp3"
        soundAttrib = "sound_gate_close"
    elseif soundDescription == enum_soundDescription.GATE_HORIZON then
        soundPath = "sounds/horizon.mp3"
        soundAttrib = "sound_horizon"
    end
    return soundPath, soundAttrib
end

-- Stop played sound
--- REQUIRED PARAMETERS:
--> stargateID          string                  ID of stargate
--> soundDescription    enum_soundDescription   (type of) sound
function stargate_sound_stop(stargateID, soundDescription)
    local soundPath, soundAttrib = stargate_sound_convertDescription(soundDescription)
    triggerClientEvent("clientStopSound", root, stargateID, soundAttrib)
end