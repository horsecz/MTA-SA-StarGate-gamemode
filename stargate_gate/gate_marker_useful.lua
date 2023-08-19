-- marker_useful.lua: Useful functions when working with stargate markers; shared

-- Marker element attributes
--> stargateID      marker's stargate source (attached stargate)
--> active          will marker peform its function or not? (if false, "onMarkerHit" event function won't be performed)
--> variable key attribute(s):
----> isHorizon     marker is event horizon marker
----> isVortex      marker is vortex horizon marker


function stargate_marker_getSource(marker)
    return getElementData(marker, "stargateID")
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