-- dhd_s.lua: Module implementing dial home device

-- create dhd

-- REQUIRED PARAMETERS:
--> type    dhd model; type
--> x, y, z dhd position

-- OPTIONAL PARAMETERS:
--> rx, ry, rz  dhd rotation
--> stargateID  ID of stargate that is this DHD attached&connected to
--- default if not specified: nil   (not attached to any gate)
--> galaxyDial  can this DHD dial outside its gate's galaxy?
--- default if not specified: false
--> isBroken    is this DHD broken and not working?
--- default if not specified: false
--> isDamaged   is DHD damaged? (able to dial, receive, but wormhole is unstable)
--- default if not specified: false
function dhd_create(type, dimension, x, y, z, rx, ry, rz, stargateID, galaxyDial, isBroken, isDamaged)
    local dhd = createObject(1337, x, y, z, rx, ry, rz)
    local id = dhd_assignID(dhd, type)
    local dhd_marker = createMarker(x, y, z+1, "corona", 1.7, 0, 0, 0, 0)
    setElementID(dhd_marker, id.."_EM")
    setElementData(dhd_marker, "isDHDMarker", true)
    setElementData(dhd_marker, "DHD", dhd)
    planet_setElementOccupiedPlanet(dhd, "PLANET_"..dimension)
    planet_setElementOccupiedPlanet(dhd_marker, "PLANET_"..dimension)
    addEventHandler("onMarkerHit", dhd_marker, dhd_activate)
    addEventHandler("onMarkerLeave", dhd_marker, dhd_leave)

    if not isBroken then
        isBroken = false
    end
    if not isDamaged then
        isDamaged = false
    end
    if not galaxyDial then
        galaxyDial = false
    end
    if not stargateID then
        stargateID = nil
    end

    if not stargateID == nil or not stargateID == false then
        dhd_attachToStargate(id, stargateID)
    end
    setElementData(dhd, "isBroken", isBroken)
    setElementData(dhd, "isDamaged", isDamaged)
    setElementData(dhd, "canDialGalaxy", galaxyDial)
    outputDebugString("Created DHD (ID="..tostring(getElementID(dhd)).." galaxy="..tostring(type)..") at "..tostring(x)..","..tostring(y)..","..tostring(z).."")
    return dhd
end

-- removes dhd
function dhd_remove(dhdID)
    local dhd = dhd_getElement(dhdID)
    local dhd_marker = getElementByID(dhdID.."_EM")
    removeEventHandler("onMarkerHit", dhd_marker, dhd_activate)
    destroyElement(dhd)
    destroyElement(dhd_marker)
end

function dhd_attachToStargate(dhdID, stargateID)
    local dhd = dhd_getElement(dhdID)
    local sg_dhd = stargate_getAssignedDHD(stargateID)
    if sg_dhd == nil then
        setElementData(dhd, "attachedStargate", stargateID)
        stargate_setAssignedDHD(stargateID, dhdID)
    else
        outputDebugString("[DHD] Attaching DHD '"..dhdID.."' to Stargate '"..stargateID.."' which already has some attached DHD! (Attached DHD: '"..sg_dhd.."')", 2)
    end
end

function dhd_detachFromStargate(dhdID)
    local dhd = dhd_getElement(dhdID)
    local sg_id = getElementData(dhd, "attachedStargate")
    local sg_dhd = stargate_getAssignedDHD(stargateID)
    stargate_setAssignedDHD(sg_id, nil)
    setElementData(dhd, "attachedStargate", nil)
end

-- assigns new ID to NEW stargate
function dhd_assignID(dhd, type)
    local galaxy = "MW"
    if LastDHDID == nil then
        LastDHDID = 0
    end
    LastDHDID = LastDHDID + 1
    if type == enum_galaxy.MILKYWAY then
        galaxy = "MW"
        local DHD_MW = global_getData("DHD_MW")
        DHD_MW = array_push(DHD_MW, dhd)
        global_setData("DHD_MW", DHD_MW)
    end

    local newID = "DHD_"..galaxy.."_"..tostring(LastDHDID)
    setElementID(dhd, newID)
    return newID
end

function dhd_activate(player)
    -- if source element is dhd colshape/marker
        -- open dhd gui
    local marker = getElementByID(getElementID(source))
    if getElementData(marker, "isDHDMarker") == true and getElementDimension(marker) == getElementDimension(player) then
        local dhd = getElementData(marker, "DHD")
        if getElementData(dhd, "attachedStargate") == false or getElementData(dhd, "attachedStargate") == nil then
            outputChatBox("[DHD] Not attached to any stargate yet.")
            return nil
        else
            --
            -- TEMPORARY :::
            outputChatBox("[DHD] You can now dial with command: /dial [Stargate ID number]")
            setElementData(player, "atDHD", dhd)
            addCommandHandler("dial", dhd_dialStart)
            -- TEMPORARY ^^^
            --
        end
    end
end

function dhd_leave(player)
    local marker = getElementByID(getElementID(source))
    if getElementData(marker, "isDHDMarker") == true then
        --
        -- TEMPORARY :::
        setElementData(player, "atDHD", nil)
        removeCommandHandler("dial", dhd_dialStart)
        -- TEMPORARY ^^^
        --
    end
end

function dhd_dialStart(playerSource, commandName, stargateIDTo)
    -- returned values from client-side; dhd gui
    local DHD = getElementData(playerSource, "atDHD")
    local SGFrom_ID = getElementData(DHD, "attachedStargate")

    stargate_dialByID(SGFrom_ID, "SG_MW_"..stargateIDTo) -- ::: TEMPORARY :::
end

function dhd_dialStop()
    -- returned values from client-side; dhd gui
    stargate_dialFail(stargateID, USER_STOPPED)
end

---
--- GET/SET functions
---

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