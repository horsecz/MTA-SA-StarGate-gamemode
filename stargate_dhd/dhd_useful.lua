-- dhd_useful.lua:  useful functions when working with DHD element; shared

-- DHD element attributes:
--> isBroken            bool                    is DHD broken or not (working or not working at all)
--> isDamaged           bool                    is DHD damaged (working but with issues)
--> canDialGalaxy       bool                    can be stargate from another galaxy dialed via this DHD
--> type                enum_galaxy             DHD type     
--> attachedStargate    string                  attached stargate (ID)


function dhd_setBroken(dhdID, isBroken)
    setElementData(dhd_getElement(dhdID), "isBroken", isBroken)
end

function dhd_setDamaged(dhdID, v)
    setElementData(dhd_getElement(dhdID), "isDamaged", v)
end

function dhd_setGalaxyDial(dhdID, galaxyDial)
    setElementData(dhd_getElement(dhdID), "canDialGalaxy", galaxyDial)
end

function dhd_setType(dhdID, v)
    setElementData(dhd_getElement(dhdID), "type", v)
end

function dhd_setAttachedStargate(dhdID, v)
    setElementData(dhd_getElement(dhdID), "attachedstargate", v)
end


function dhd_isBroken(dhdID)
    return (getElementData(dhd_getElement(dhdID), "isBroken"))
end

function dhd_isDamaged(dhdID)
    return (getElementData(dhd_getElement(dhdID), "isDamaged"))
end

function dhd_canDialGalaxy(dhdID)
    return (getElementData(dhd_getElement(dhdID), "canDialGalaxy"))
end

function dhd_getType(dhdID)
    return (getElementData(dhd_getElement(dhdID), "type"))
end

function dhd_getAttachedStargate(dhdID)
    setElementData(dhd_getElement(dhdID), "attachedstargate")
end


function dhd_getElement(dhdID)
    return (getElementByID(dhdID))
end

function dhd_getID(dhd)
    return (getElementID(dhd))
end