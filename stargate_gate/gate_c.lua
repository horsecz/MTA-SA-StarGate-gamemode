--- gate_c.lua: StarGate gamemode part script - client-side stargate operations, models and logic
---
--- Global variables
---

MWID = nil
MWID_r = nil
MWID_c = {}
MWID_c_last = 0
MW_Horizon = {}
MW_Horizon_last = 0

SG_Kawoosh = {}
SG_Kawoosh_last = 0

---
--- Initializing functions
---

function begin()
	triggerServerEvent("clientStartedEvent", source)
end
addEventHandler("onClientResourceStart", resourceRoot, begin)

-- at the end of resource, free models
function stop()
	engineFreeModel(MWID)
	engineFreeModel(MWID_r)
	for i=1,9 do
		engineFreeModel(MWID_c[i])
	end
	-- TODO; free the rest
end
addEventHandler("onClientResourceStop", resourceRoot, stop)

---
--- Model and textures functions
---

function loadMWModel()
	modelID = engineRequestModel("object")
	if not modelID then
		outputDebugString("Very bad error in loadMWModel() gate_c.lua")
	end

	txd = engineLoadTXD("models/mw.txd")
	engineImportTXD(txd, modelID)
	dff = engineLoadDFF("models/mw.dff")
	engineReplaceModel(dff, modelID)
	MWID = modelID
	triggerServerEvent("MWModelLoaded", resourceRoot, modelID)
end

function loadMWModelRing()
	modelID = engineRequestModel("object")
	if not modelID then
		outputDebugString("Very bad error in loadMWModelRing() gate_c.lua")
	end

	txd = engineLoadTXD("models/mw.txd")
	engineImportTXD(txd, modelID)
	dff = engineLoadDFF("models/mw_ring.dff")
	engineReplaceModel(dff, modelID)
	MWID_r = modelID
	triggerServerEvent("MWModelRingLoaded", resourceRoot, modelID)
end

function loadMWModelChevrons()
	number = MWID_c_last + 1
	MWID_c_last = MWID_c_last + 1
	modelID = engineRequestModel("object")
	if not modelID then
		outputDebugString("Very bad error in loadMWModelChevrons() gate_c.lua")
	end

	txd = engineLoadTXD("models/9chevs.txd")
	engineImportTXD(txd, modelID)
	dff = engineLoadDFF("models/chevs"..(number)..".dff")
	engineReplaceModel(dff, modelID)
	MWID_c[number] = modelID
	triggerServerEvent("MWModelChevronLoaded", resourceRoot, modelID)
end

function loadMWModelHorizon()
	number = MW_Horizon_last + 1
	MW_Horizon_last = MW_Horizon_last + 1
	modelID = engineRequestModel("object")
	if not modelID then
		outputDebugString("Very bad error in loadMWModelHorizon() gate_c.lua")
	end

	txd = engineLoadTXD("models/"..tostring(number)..".txd")
	engineImportTXD(txd, modelID)
	dff = engineLoadDFF("models/"..(number)..".dff")
	engineReplaceModel(dff, modelID)
	MW_Horizon[number] = modelID
	triggerServerEvent("MWModelHorizonLoaded", resourceRoot, modelID)
end

function loadModelKawoosh()
	number = SG_Kawoosh_last + 1
	SG_Kawoosh_last = SG_Kawoosh_last + 1
	modelID = engineRequestModel("object")
	if not modelID then
		outputDebugString("Very bad error in loadModelKawoosh() gate_c.lua")
	end

	txd = engineLoadTXD("models/Kawoosh.txd")
	engineImportTXD(txd, modelID)
	dff = engineLoadDFF("models/Kawoosh"..(number)..".dff")
	engineReplaceModel(dff, modelID)
	SG_Kawoosh[number] = modelID
	triggerServerEvent("ModelKawooshLoaded", resourceRoot, modelID)
end

---
--- "Shared" functions with server-side
---

-- sets elements model from serverside script
function setElementModelClient(element, modelID)
	setElementModel(element, modelID)
end
addEvent("setElementModelClient", true)
addEventHandler("setElementModelClient", resourceRoot, setElementModelClient)

-- plays3d sound from server
function playSound3DFromServerSG(stargateID, soundpath, x, y, z, distance, soundAttrib)
	s = playSound3D(soundpath, x, y, z)
	if distance then
		setSoundMaxDistance(s, distance)
	else
		distance = 150
	end
	setElementData(getElementByID(stargateID), soundAttrib, s)

	if soundAttrib == "ringRotate" then
		beginSoundLength = getSoundLength(s)*1000
		continueRotationSound = setTimer(function(stargateID, distance)
			ls = playSound3D("sounds/mw_ring_rotate.mp3", x, y, z)
			setSoundMaxDistance(ls, distance)
			setElementData(getElementByID(stargateID), "ringRotateLongSound", ls)
		end
		, beginSoundLength-100, 1, stargateID, distance)
		setElementData(getElementByID(stargateID), "ringRotateLongTimer", continueRotationSound)
	end
end
addEvent("clientPlaySound3D", true)
addEventHandler("clientPlaySound3D", root, playSound3DFromServerSG)

-- stops sound from server
function stopSoundFromServerSG(stargateID, soundAttribute)
	sound = getElementData(getElementByID(stargateID), soundAttribute)
	if sound then
		stopSound(sound)
	end
	if soundAttribute == "ringRotate" then
		timer = getElementData(getElementByID(stargateID), "ringRotateLongTimer")
		if isTimer(timer) then
			killTimer(timer)
		else
			stopSound(getElementData(getElementByID(stargateID), "ringRotateLongSound"))
		end
	end
end
addEvent("clientStopSound", true)
addEventHandler("clientStopSound", root, stopSoundFromServerSG)

-- server-side only -- calls function from client
function callClientFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("onServerCallsClientFunction", true)
addEventHandler("onServerCallsClientFunction", resourceRoot, callClientFunction)