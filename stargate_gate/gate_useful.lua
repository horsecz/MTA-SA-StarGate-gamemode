-- useful.lua: Useful functions for working with stargate element; shared

--- Stargate element attributes
--> address             stargate address
--> active              is stargate active (dialling or open)
--> disabled            is stargate disabled (unable to be dialed and dial out)
--> open                is stargate open (wormhole estabilished)
--> diallingAddress     address of stargate that is current stargate dialling
--> connectionID        ID of stargate that is this stargate connected to (when open; can be source or destination stargate)
--> incomingStatus      is stargate being dialed to? (status switched on when gate is activated due to incoming wormhole)
--> closeTimer          timer element which performs wormhole close after predefined time passes
--> energyTimer         timer element which performs checks whether stargate's energy status is OK or not
--> defaultDialType     standard dial type for this stargate (see enum_stargateDialType)
--> isGrounded          is stargate grounded, buried, ... (unable to dial in or out)
--> forceDialType       is defaultDialType forced when dialling? (if not, dial mode can be changed)
--> hasIris             has this stargate attached iris?
--> energy              current amount of energy that stargate has in its storage; in EU
--> assignedDHD         DHD element (reference) that is assigned to this stargate

--- Attached elements to stargate element
--> ring                stargate ring (MilkyWay type only)
--> horizon             event horizon
--> horizonActivation   event horizon activation (animation)
--> iris                stargate iris or shield
--> marker              special marker that is "attached" to stargate
--> sound               sound that is performed "by" stargate
--> vortex              kawoosh/vortex opening animation object/s

---
--- ELEMENT Functions
---

function stargate_getRingElement(id)
    return (stargate_ring_getElement(id.."R"))
end

function stargate_getChevron(id, chevronNumber)
    return getElementByID(id.."C"..tostring(chevronNumber))
end

function stargate_getKawoosh(id, kawooshNumber)
    return getElementByID(id.."V"..tostring(kawooshNumber))
end

function stargate_getIris(id, irisNumber)
    return getElementByID(id.."I"..tostring(irisNumber))
end

function stargate_getHorizon(id, horizonNumber)
    return getElementByID(id.."H"..tostring(horizonNumber))
end

function stargate_getHorizonActivation(id, horizonNumber)
    return getElementByID(id.."HA"..tostring(horizonNumber))
end

function stargate_getElement(id)
    return (getElementByID(id))
end

---
--- ATTRIBUTE Functions
---

function stargate_getID(stargate)
    return (getElementID(stargate))
end

function stargate_setID(id, newID)
    setElementID(stargate_getElement(id), newID)
end

function stargate_setAddress(id, address)
    setElementData(stargate_getElement(id), "address", address)
end

function stargate_isActive(stargateID)
    return getElementData(getElementByID(stargateID), "active")
end

function stargate_isDisabled(stargateID)
    return getElementData(getElementByID(stargateID), "disabled")
end

function stargate_isOpen(stargateID)
    return getElementData(getElementByID(stargateID), "open")
end

function stargate_setDisabled(stargateID, disabled)
    return setElementData(getElementByID(stargateID), "disabled", disabled)
end

function stargate_setOpen(stargateID, open)
    return setElementData(getElementByID(stargateID), "open", open)
end

function stargate_setActive(stargateID, active)
    return setElementData(getElementByID(stargateID), "active", active)
end

function stargate_getDialAddress(stargateID)
    return (getElementData(getElementByID(stargateID), "diallingAddress"))
end

function stargate_setDialAddress(stargateID, address)
    return (setElementData(getElementByID(stargateID), "diallingAddress", address))
end

function stargate_getConnectionID(stargateID)
    return (getElementData(getElementByID(stargateID), "connectionID"))
end

function stargate_setConnectionID(stargateID, id)
    return (setElementData(getElementByID(stargateID), "connectionID", id))
end

function stargate_getAddress(stargateID)
    return (getElementData(getElementByID(stargateID), "address"))
end

function stargate_getIncomingStatus(stargateID) 
    return (getElementData(getElementByID(stargateID), "incomingStatus"))
end

function stargate_setIncomingStatus(stargateID, status) 
    return (setElementData(getElementByID(stargateID), "incomingStatus", status))
end

function stargate_setCloseTimer(stargateID, timer)
    setElementData(getElementByID(stargateID), "stargateCloseTimer", timer)
end

function stargate_getCloseTimer(stargateID)
    return (getElementData(getElementByID(stargateID), "stargateCloseTimer"))
end

function stargate_setEnergyTimer(stargateID, timer)
    setElementData(getElementByID(stargateID), "stargateEnergyTimer", timer)
end

function stargate_getEnergyTimer(stargateID)
    return (getElementData(getElementByID(stargateID), "stargateEnergyTimer"))
end

function stargate_setDefaultDialType(id, defaultDialType)
    setElementData(stargate_getElement(id), "defaultDialType", defaultDialType)
end

function stargate_getDefaultDialType(id)
    return (getElementData(stargate_getElement(id), "defaultDialType"))
end

function stargate_setGrounded(id, v)
    return (setElementData(stargate_getElement(id), "isGrounded", v))
end

function stargate_getGrounded(id)
    return (getElementData(stargate_getElement(id), "isGrounded"))
end

function stargate_setForceDialType(id, v)
    return (setElementData(stargate_getElement(id), "forceDialType", v))
end

function stargate_getForceDialType(id)
    return (getElementData(stargate_getElement(id), "forceDialType"))
end

function stargate_hasIris(id)
    return (getElementData(stargate_getElement(id), "hasIris"))
end

function stargate_getEnergyElement(id)
    return (getElementData(stargate_getElement(id), "energy"))
end

function stargate_getAssignedDHD(id)
    return (getElementData(stargate_getElement(id), "assignedDHD"))
end

function stargate_setAssignedDHD(id, v)
    if not v == nil or not v == false then
        local stargate = stargate_getElement(id)
        local dhd = getElementByID(v)
        local dhdType = getElementData(dhd, "type")
        if dhdType == enum_galaxy.UNKNOWN then   -- dont generate energy when DHD is Base type
        else
            local sg_energy = getElementData(stargate, "energy")
            local dhd_energy = getElementData(dhd, "energy")
            local eTT = setTimer(energy_beginTransfer, 1000, 0, dhd_energy, sg_energy, GATE_ENERGY_WORMHOLE)
            setElementData(dhd, "energy_transfer_timer", eTT)
        end        
    end
    return (setElementData(stargate_getElement(id), "assignedDHD", v))
end

---
--- OTHER USEFUL Functions
---

-- returns remaining time wormhole will be open in miliseconds or nil
function stargate_getWormholeTimeRemaining(stargateID)
    local timer = stargate_getCloseTimer(stargateID)
    if isTimer(timer) then
        local r = getTimerDetails(timer)
        return r
    else
        return nil
    end
end

function stargate_getGateModel(type)
    if type == "MW" then
        return MWID
    end
end

function stargate_getGalaxy(id)
    return (getElementData(stargate_getElement(id), "galaxy"))
end

function stargate_getAddressSymbol(address, symbol)
    return address[symbol]
end

function stargate_convertAddressSymbolToGalaxy(symbol)
    if symbol == 10 then
        return enum_galaxy.MILKYWAY
    elseif symbol == 20 then
        return enum_galaxy.PEGASUS
    else
        return nil
    end
end

function stargate_convertGalaxyToAddressSymbol(galaxy)
    if galaxy == enum_galaxy.MILKYWAY then
        return 10
    elseif galaxy == enum_galaxy.PEGASUS then
        return 20
    else
        return nil
    end
end

function stargate_isDestinyGate(stargateID)
    return (getElementData(stargate_getElement(stargateID), "isDestiny"))
end


function stargate_getPosition(stargateID)
    local x, y, z = getElementPosition(stargate_getElement(stargateID))
    return x, y, z
end

function stargate_getRotation(stargateID)
    local x, y, z = getElementRotation(stargate_getElement(stargateID))
    return x, y, z
end

function stargate_setPosition(stargateID, nx, ny, nz)
    setElementPosition(stargate_getElement(stargateID), nx, ny, nz)
    if stargate_galaxy_get(stargateID) == "milkyway" then
        setElementPosition(stargate_getRingElement(stargateID), nx, ny, nz)
    end 
end

function stargate_attachToElement(stargateID, elementAttachTo, x,y,z, rx,ry,rz)
    if not x then
        x = 0
    end 
    if not y then
        y = 0
    end
    if not z then
        z = 0
    end
    if not rx then
        rx = 0
    end
    if not ry then
        ry = 0
    end
    if not rz then
        rz = 0
    end
    
    attachElements(stargate_getElement(stargateID), elementAttachTo, x,y,z, rx,ry,rz)
end

function stargate_detachFromElement(stargateID, elementDetachFrom)
    if not elementDetachFrom then
        elementDetachFrom = nil
    end
    detachElements(stargate_getElement(stargateID), elementDetachFrom)
end

function stargate_getPlanetStargates(planetID)
    if not planet_isPlanet(planetID) then
        return nil
    end
    local dimension = planet_getPlanetDimension(planetID)
    local SG_LIST = global_getData("SG_LIST")
    local planet_sgs = { }
    for i,sg in ipairs(SG_LIST) do
        local sg_dimension = getElementDimension(sg)
        if sg_dimension == dimension then
            planet_sgs = array_push(planet_sgs, sg)
        end
    end

    return planet_sgs
end

function stargate_getAllStargates()
    return (global_getData("SG_LIST"))
end

---
--- OBSOLETE Functions
---

function stargate_isValidAttribute(stargateID, attribute)
    if getElementData(getElementByID(stargateID), attribute) == nil then
        return false
    else
        return true
    end
end