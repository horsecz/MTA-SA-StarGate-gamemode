-- dhd_s.lua: Module implementing dial home device

function stargate_dhd_create(stargateID, x, y, z, rx, ry, rz, galaxyDial, isBroken)
    local dhd = createObject(1337, x, y, z, rx, ry, rz)
    setElementID(dhd, stargateID.."DHD")
    setElementData(dhd, "attachedStargate", stargateID)

    if not isBroken then
        isBroken = false
    end
    if not galaxyDial then
        galaxyDial = false
    end

    setElementData(dhd, "isBroken", isBroken)
    setElementData(dhd, "canDialGalaxy", galaxyDial)
    -- load dhd model
    -- colshape or marker w/ onhit event activating dhd_activate
    return dhd
end

function stargate_dhd_activate(player)
    -- if source element is dhd colshape/marker
        -- open dhd gui
end

function stargate_dhd_dialStart()
    -- returned values from client-side; dhd gui
    stargate_dial(stargateID, address)
end

function stargate_dhd_dialStop()
    -- returned values from client-side; dhd gui
    stargate_dialFail(stargateID, USER_STOPPED)
end

---
--- GET/SET functions
---

function stargate_dhd_setBroken(dhdID, isBroken)
    setElementData(stargate_dhd_getElement(dhdID), "isBroken", isBroken)
end

function stargate_dhd_setGalaxyDial(dhdID, galaxyDial)
    setElementData(stargate_dhd_getElement(dhdID), "canDialGalaxy", galaxyDial)
end

function stargate_dhd_isBroken(dhdID)
    return (getElementData(stargate_dhd_getElement(dhdID), "isBroken"))
end

function stargate_dhd_canDialGalaxy(dhdID)
    return (getElementData(stargate_dhd_getElement(dhdID), "canDialGalaxy"))
end

function stargate_dhd_getElement(dhdID)
    return (getElementByID(dhdID))
end