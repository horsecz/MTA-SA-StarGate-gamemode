-- marker_s.lua: Module for marker (that are attached to stargate) operations; server-side

-- Create marker that is "attached" to stargate
--- REQUIRED PARAMETERS:
--> x, y, z         int                 marker position
--> markerType      enum_markerType     type of marker
--> markerSize      int                 size of marker
--> r, g, b, a      int                 marker color and alpha
--> markerFunction  function name       name of function, which will be performed when any element hits the marker
--> stargateID      string              ID of stargate
--- RETURNS:
--> Reference; marker element
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

-- Sets attributes and function to marker
-- > element ID
-- > custom attribute
-- > "onMarkerHit" event handler
--- REQUIRED PARAMETERS:
--> marker          reference       marker element
--> ID              string          identificator of marker (partial)
--> attrib_key      string          attribute key
--> attrib_value    variable type   attribute value
--> event_function  function name   name of function, which will be performed when any elements hits the marker
--> stargateID      string          ID of stargate
function stargate_marker_setAttributes(marker, ID, attrib_key, attrib_value, event_function, stargateID)
    setElementID(marker, stargateID..ID)
    setElementData(marker, attrib_key, attrib_value)
    addEventHandler("onMarkerHit", marker, event_function)
end

-- Sets marker's (stargate) source
--- REQUIRED PARAMETERS:
--> marker          reference   marker element
--> stargateID      string      ID of source stargate
function stargate_marker_setSource(marker, stargateID)
    setElementData(marker, "stargateID", stargateID)
end

-- Gets marker element by its stargate source and function
--- REQUIRED PARAMETERS:
--> stargateID      string              ID of source stargate
--> markerFunction  enum_markerType     function that is being performed by this marker
--- RETURNS:
--> Reference; marker element
function stargate_marker_get(stargateID, markerFunction)
    if markerFunction == enum_markerType.EVENTHORIZON then
        return (getElementByID(stargateID.."TPM"))
    elseif markerFunction == enum_markerType.VORTEX then
        return (getElementByID(stargateID.."KZM"))
    end
end

-- Hides marker
--- REQUIRED PARAMETERS:
--> stargateID      string              ID of source stargate
--> markerFunction  enum_markerType     function that is performed by this marker
--> hidden          bool                hiding or showing marker?
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