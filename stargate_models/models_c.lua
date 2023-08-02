-- models_c.lua_ Clientside model and texture load module

function clientStarted()
	outputDebugString("[MODELS] Client started. [Player "..tostring(getElementID(getLocalPlayer())).."]")
	loadModels(getLocalPlayer())
end
addEventHandler("onClientResourceStart", resourceRoot, clientStarted)

function loadModels(player)
	local modelID = nil
	modelID = loadModel("object", "models/mw.txd", "models/mw.dff", "collisions/mw.col")
	setElementData(player, "models_gate_milkyway", modelID)

    modelID = loadModel("object", "models/mw.txd", "models/mw_ring.dff", "collisions/mw_ring.col")
	setElementData(player, "models_gate_milkyway_ring", modelID)

	modelID = loadModel("object", "models/dhd.txd", "models/dhd.dff", "collisions/dhd.col")
	setElementData(player, "models_gate_milkyway_dhd", modelID)

	for i=1,9 do
		modelID = loadModel("object", "models/9chevs.txd", "models/chevs"..tostring(i)..".dff", "collisions/chevs.col")
		setElementData(player, "models_gate_milkyway_chevron_"..tostring(i), modelID)
	end

	for i=1,12 do
		modelID = loadModel("object", "models/Kawoosh.txd", "models/Kawoosh"..tostring(i)..".dff", "collisions/Kawoosh"..tostring(i)..".col")
		setElementData(player, "models_gate_milkyway_kawoosh_"..tostring(i), modelID)
	end

	for i=1,6 do
		modelID = loadModel("object", "models/"..tostring(i)..".txd", "models/"..tostring(i)..".dff", "collisions/"..tostring(i)..".col")
		setElementData(player, "models_gate_milkyway_horizon_"..tostring(i), modelID)

		modelID = loadModel("object", "models/act"..tostring(i)..".txd", "models/act"..tostring(i)..".dff")
		setElementData(player, "models_gate_milkyway_horizon_activation_"..tostring(i), modelID)
	end

	for i=1,10 do
		modelID = loadModel("object", "models/iris.txd", "models/iris"..tostring(i)..".dff", "collisions/iris"..tostring(i)..".col")
		setElementData(player, "models_gate_milkyway_iris_"..tostring(i), modelID)
	end

	initModels(player)
end

function initModels(player)
	local SG_MW = global_getData("SG_MW")
	local DHD_MW = global_getData("DHD_MW")
	
    if SG_MW == nil or SG_MW == false then
        outputDebugString("[GATE_MODELS] Failed to obtain MilkyWay gate list!", 1)
		return nil
    end
	if array_size(SG_MW) < 1 then
		outputDebugString("[GATE_MODELS] MilkyWay gate list contains no gates!", 2)
	end

	if DHD_MW == nil or DHD_MW == false then
        outputDebugString("[GATE_MODELS] Failed to obtain MilkyWay DHD list!", 1)
		return nil
    end
	if array_size(DHD_MW) < 1 then
		outputDebugString("[GATE_MODELS] MilkyWay DHD list contains no DHDs!", 2)
	end	

	outputDebugString("[GATE_MODELS] Begin loading client models.")
    for i,sg in pairs(SG_MW) do
		local x, y, z = getElementPosition(sg)
		local rx, ry, rz = getElementRotation(sg)
        local id = stargate_getID(sg)
		outputDebugString("[GATE_MODELS] Loading model for element '"..id.."'")
        local ring = stargate_getRingElement(id)
        local MWID = getElementData(player, "models_gate_milkyway")
        local MWID_r = getElementData(player, "models_gate_milkyway_ring")
		setElementModel(getElementByID(id), MWID)
		setElementModel(ring, MWID_r)

		for i=1,9 do
			setElementModel(stargate_getChevron(id, i), getElementData(player, "models_gate_milkyway_chevron_"..tostring(i)))
		end
		for i=1,12 do
			setElementModel(stargate_getKawoosh(id, i), getElementData(player, "models_gate_milkyway_kawoosh_"..tostring(i)))
		end
		for i=1,6 do
			setElementModel(stargate_getHorizon(id, i), getElementData(player, "models_gate_milkyway_horizon_"..tostring(i)))
			setElementModel(stargate_getHorizonActivation(id, i), getElementData(player, "models_gate_milkyway_horizon_activation_"..tostring(i)))
		end

		if stargate_hasIris(id) then
			for i=1,10 do
				setElementModel(stargate_getIris(id, i), getElementData(player, "models_gate_milkyway_iris_"..tostring(i)))
			end
		end
    end

	for i,dhd_mw in pairs(DHD_MW) do
		local dhd_model = getElementData(player, "models_gate_milkyway_dhd")
		setElementModel(dhd_mw, dhd_model)
	end
end

function loadModel(modelType, txdPath, dffPath, colPath)
	local modelID = engineRequestModel(modelType)
	if not modelID then
		outputDebugString("Error in loadModel("..tostring(modelType)","..txdPath..","..dffPath..","..colPath..", \""..serverEvent.."\, \""..playerID..")")
		return nil
	end
	local txd = engineLoadTXD(txdPath)
	engineImportTXD(txd, modelID)
	local dff = engineLoadDFF(dffPath)
	engineReplaceModel(dff, modelID)
	if col then
		col = engineLoadCOL(colPath)
		engineReplaceCOL(col, modelID)
	end
	return modelID
end

-- sets elements model from serverside script
function setElementModelClient(element, modelID)
	setElementModel(element, modelID)
end
addEvent("setElementModelClient", true)
addEventHandler("setElementModelClient", resourceRoot, setElementModelClient)
