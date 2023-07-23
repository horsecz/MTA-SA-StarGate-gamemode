--- gate_c.lua: Core clientside module

---
--- GLOBALS (CLIENT)
---

---
--- INIT
---

function initClient()
	triggerServerEvent("clientStartedEvent", source)
end
addEventHandler("onClientResourceStart", resourceRoot, initClient)

-- at the end of resource, free models
function endClient()
	engineFreeModel(getElementData(source, "models_gate_milkyway"))
	engineFreeModel(getElementData(source, "models_gate_milkyway_ring"))
	for i=1,9 do
		engineFreeModel(getElementData(source, "models_gate_milkyway_chevron_"..tostring(i)))
	end
	for i=1,12 do
		engineFreeModel(getElementData(source, "models_gate_milkyway_kawoosh_"..tostring(i)))
	end
	for i=1,6 do
		engineFreeModel(getElementData(source, "models_gate_milkyway_horizon_"..tostring(i)))
	end
end
addEventHandler("onClientResourceStop", resourceRoot, endClient)

function handleProjectileCreation(creator)
	local t = setTimer(
		function(creator, SG_MW, source, timer)
			if not isElement(source) then
				if isTimer(timer) then
					killTimer(timer)
				end
				return nil
			end
			for i, gateElement in pairs(SG_MW) do
				if getElementData(gateElement, "open") == true then
					local horizon = getElementByID(getElementID(gateElement).."TPM")
					if isElement(horizon) then
						if isProjectileInHorizon(source, horizon) then
							local sx, sy, sz = getElementPosition(getElementByID(getElementData(gateElement, "connectionID")))
							local vx, vy, vz = getElementVelocity(source)
							setElementPosition(source, sx, sy, sz)
							setElementVelocity(source, vx, -vy, vz)
						end
					end
				end
			end
		end
	, 50, 0, creator, SG_MW, source)
end
addEventHandler("onClientProjectileCreation", root, handleProjectileCreation)

function isProjectileInHorizon(projectile, horizon, positionError)
	local x, y, z = getElementPosition(horizon)
	local px, py, pz = getElementPosition(projectile)
	local EPS = positionError
	if not positionError then
		EPS = 1.33
	end
	if math.abs(math.abs(x) - math.abs(px)) < EPS then
		if math.abs(math.abs(y) - math.abs(py)) < EPS then
			if math.abs(math.abs(z) - math.abs(pz)) < EPS then
				return true
			end
		end
	end
	return false
end


--- GETTERS/SETTERS

function stargate_getID(stargate)
    return (getElementID(stargate))
end

function stargate_getRingElement(id)
    return (stargate_ring_getElement(id.."R"))
end

function stargate_getChevron(id, chevronNumber)
    return getElementByID(id.."C"..tostring(chevronNumber))
end

function stargate_getKawoosh(id, kawooshNumber)
    return getElementByID(id.."V"..tostring(kawooshNumber))
end

function stargate_getHorizon(id, horizonNumber)
    return getElementByID(id.."H"..tostring(horizonNumber))
end