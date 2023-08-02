-- marker_s.lua_ Module for marker (that are attached to stargate) operations

function stargate_marker_create(x, y, z, markerType, markerSize, r, g, b, a, markerFunction, stargateID)
    local marker = createMarker(x, y, z, markerType, markerSize, r, g, b, a)
    stargate_marker_setSource(marker, stargateID)
    setElementData(marker, "active", true)
    local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateID))
    planet_setElementOccupiedPlanet(marker, planet)
    if markerFunction == enum_markerType.EVENTHORIZON then
        stargate_marker_setAttributes(marker, "TPM", "isHorizon", true, stargate_wormhole_transport, stargateID)
    elseif markerFunction == enum_markerType.VORTEX then
        stargate_marker_setAttributes(marker, "KZM", "isVortex", true, stargate_vortex_kill, stargateID)
    end
    return marker
end

function stargate_marker_setAttributes(marker, ID, attrib_key, attrib_value, event_function, stargateID)
    setElementID(marker, stargateID..ID)
    setElementData(marker, attrib_key, attrib_value)
    addEventHandler("onMarkerHit", marker, event_function)
end

function stargate_marker_setSource(marker, stargateID)
    setElementData(marker, "stargateID", stargateID)
end

function stargate_marker_getSource(marker)
    return getElementData(marker, "stargateID")
end

function stargate_marker_get(stargateID, markerFunction)
    if markerFunction == enum_markerType.EVENTHORIZON then
        return (getElementByID(stargateID.."TPM"))
    elseif markerFunction == enum_markerType.VORTEX then
        return (getElementByID(stargateID.."KZM"))
    end
end

function stargate_marker_remove(stargateID, markerFunction)
    return destroyElement(stargate_marker_get(stargateID, markerFunction))
end

function stargate_marker_deactivate(stargateID, markerFunction)
    return setElementData(stargate_marker_get(stargateID, markerFunction), "active", false)
end

function stargate_marker_setActive(stargateID, markerFunction, active)
    return setElementData(stargate_marker_get(stargateID, markerFunction), "active", active)
end

function stargate_marker_setHidden(stargateID, markerFunction, hidden)
    local a = 255
    if hidden == false then
        a = 0
    elseif hidden == true then
        a = 255
    end
    setElementAlpha(stargate_marker_get(stargateID, markerFunction), a)
    return 
end

function stargate_marker_isEventHorizon(marker)
    if getElementData(marker, "isHorizon") == nil then
        return false
    else
        return true
    end
end

function stargate_marker_isVortex(marker)
    if getElementData(marker, "isVortex") == nil then
        return false
    else
        return true
    end
end