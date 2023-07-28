-- sound_s.lua_ Sound module

enum_soundDescription = {
    GATE_DIAL_FAIL = 0,
    GATE_RING_ROTATE = 1,

    GATE_CHEVRON_LOCK = 2,
    GATE_CHEVRON_INCOMING = 3,

    GATE_VORTEX_OPEN = 4,
    GATE_HORIZON_TOUCH = 5,
    GATE_HORIZON = 6,

    GATE_CLOSE = 7
}

-- play sound at stargate; default distance 150
function stargate_sound_play(stargateID, soundDescription, soundDistance)
    local x, y, z = stargate_getPosition(stargateID)
    local soundPath, soundAttrib = stargate_sound_convertDescription(soundDescription)
    local distance = soundDistance
    if not soundDistance then
        distance = 100
    end

    triggerClientEvent("clientPlaySound3D", root, stargateID, soundPath, x, y, z, distance, soundAttrib)
end

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

function stargate_sound_stop(stargateID, soundDescription)
    local soundPath, soundAttrib = stargate_sound_convertDescription(soundDescription)
    triggerClientEvent("clientStopSound", root, stargateID, soundAttrib)
end