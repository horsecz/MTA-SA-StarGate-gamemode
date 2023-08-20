-- dhd_useful.lua:  useful functions when working with DHD element; shared

-- DHD element attributes:
--> isBroken        bool    is DHD broken or not
--> canDialGalaxy   bool    can be stargate from another galaxy dialed via this DHD

function dhd_setBroken(dhdID, isBroken)
    setElementData(stargate_dhd_getElement(dhdID), "isBroken", isBroken)
end

function dhd_setGalaxyDial(dhdID, galaxyDial)
    setElementData(stargate_dhd_getElement(dhdID), "canDialGalaxy", galaxyDial)
end

function dhd_isBroken(dhdID)
    return (getElementData(stargate_dhd_getElement(dhdID), "isBroken"))
end

function dhd_canDialGalaxy(dhdID)
    return (getElementData(stargate_dhd_getElement(dhdID), "canDialGalaxy"))
end

function dhd_getElement(dhdID)
    return (getElementByID(dhdID))
end

function dhd_getID(dhd)
    return (getElementID(dhd))
end