--- gate_c.lua: Core clientside module

---
--- GLOBALS (CLIENT)
---

--- are they any use?
MWID = nil
MWID_r = nil
MWID_c = {}
MWID_c_last = 0
MW_Horizon = {}
MW_Horizon_last = 0

SG_Kawoosh = {}
SG_Kawoosh_last = 0

SG_MW = nil

---
--- INIT
---

function initClient()
	triggerServerEvent("clientStartedEvent", source)
end
addEventHandler("onClientResourceStart", resourceRoot, initClient)

function serverLoaded(gate_list)
	SG_MW = gate_list
end
addEvent("onServerGateLoaded", true)
addEventHandler("onServerGateLoaded", resourceRoot, serverLoaded)

-- at the end of resource, free models
function endClient()
	engineFreeModel(MWID)
	engineFreeModel(MWID_r)
	for i=1,9 do
		engineFreeModel(MWID_c[i])
	end
	-- TODO; free the rest
end
--addEventHandler("onClientResourceStop", resourceRoot, endClient)

function testCall(text)
	outputChatBox(text)
end

---
---
---

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
