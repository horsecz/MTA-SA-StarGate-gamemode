--- gate_c.lua: Core module for stargates and their logic; client-side

-- See stargate_dial in gate_s.lua
function stargate_dial(stargateIDFrom, addressArray, stargateDialType)
	triggerServerEvent("stargate_dial_from_client", resourceRoot, stargateIDFrom, addressArray, stargateDialType)
end

function stargate_abortDial(stargateIDFrom, dialFailed)
	triggerServerEvent("stargate_abort_dial_from_client", resourceRoot, stargateIDFrom, dialFailed)
end

-- Handle newly created projectile element (allow them to pass through event horizon and be transported)
--- REQUIRED PARAMETERS:
--> Inherited from event "onClientProjectileCreation"
function stargate_handleProjectileCreation(creator)
	local t = setTimer(
		function(creator, source, timer)
			if not isElement(source) then
				if isTimer(timer) then
					killTimer(timer)
				end
				return nil
			end
			local SG_MW = global_getData("SG_MW")
			for i, gateElement in pairs(SG_MW) do
				if getElementData(gateElement, "open") == true then
					local horizon = getElementByID(getElementID(gateElement).."TPM")
					if isElement(horizon) then
						if stargate_isProjectileInHorizon(source, horizon) then
							local sx, sy, sz = getElementPosition(getElementByID(getElementData(gateElement, "connectionID")))
							local vx, vy, vz = getElementVelocity(source)
							setElementPosition(source, sx, sy, sz)
							setElementVelocity(source, vx, -vy, vz)
						end
					end
				end
			end
		end
	, 50, 0, creator, source)
end
addEventHandler("onClientProjectileCreation", root, stargate_handleProjectileCreation)

-- Is projectile element inside (very close to) some event horizon?
--- REQUIRED PARAMETERS:
--> projectile		reference	projectile element
--> horizon			reference	event horizon element
--- OPTIONAL PARAMETERS:
--> positionError	int			how much must be projectile close to event horizon
--- RETURNS:
--> Bool; true if projectile is in/near event horizon, false otherwise
function stargate_isProjectileInHorizon(projectile, horizon, positionError)
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