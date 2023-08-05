-- models_c.lua_ Clientside model and texture load module
LAST_RESERVED_OBJECT_MODEL = 0
PATH_TXD = "textures/"
PATH_DFF = "models/"
PATH_COL = "collisions/"
BIG_FILE = 1000000*15	-- in bytes what is considered as big (texture) files
MODEL_LOAD_TIME = 5		-- delay between loading one object model [ms]
						-- note: preventing game crash at client side


function clientStarted()
	outputDebugString("[MODELS|C] Client started; Loading models ...")
	setElementData(getLocalPlayer(), "models_data", {})
	-- Table for saving data about object IDs and their names
	-- MODELS table			= 	{ T1, T2, T3, ..., TN }
		-- TN				=	{ objectID, objectName, hotuID }
			-- objectID		=	model ID of object (int)
			-- objectName	=	description name of object; dff file name (string)
			-- hotuID		=	model ID of object in Horizon of the Universe v2.0 mod


	local loadTime = models_load()
	setTimer(models_loadObjects, loadTime, 1)
end
addEventHandler("onClientResourceStart", resourceRoot, clientStarted)

function clientStopped()
	local MODELS = getElementData(getLocalPlayer(), "models_data")
	for i,tn in ipairs(MODELS) do
		for i,tn_element in ipairs(tn) do
			engineFreeModel(tn[1])
		end
	end
end
addEventHandler("onClientResourceStop", resourceRoot, clientStopped)

function models_loadObjects()
	local model_data = nil
	local id = nil
	for i,object in ipairs(getElementsByType("object")) do
		model_data = models_getElementModelAttribute(object)
		if model_data then
			id = models_getObjectID(getLocalPlayer(), model_data)
			if id then
				setElementModel(object, id)
			else
				outputDebugString("[MODELS|C] Object element '"..tostring(getElementID(object))"' has unknown objectName '"..tostring(model_data)"' and was not set new model ID.")
			end
		end
	end
end

addCommandHandler("work", function(cmd, i)
	setElementAlpha(getElementByID("SG_MW_3"..i), 255)
	outputDebugString(tostring(getElementModel(getElementByID("SG_MW_3"..i))))
end)

-- loads model of one object
function models_loadObjectModel(txdPath, dffPath, colPath)
	local rres = engineRequestModel("object")
	if rres == false or rres == nil then
		outputDebugString("[MODELS|C] Error in loadModel("..tostring(modelType)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [ENGINE]")
		return false
	end
	local objectID = rres
	local col = nil
	local rcol = nil
	local txd = engineLoadTXD(txdPath)
	if txd == nil or txd == false then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [TXD LOAD]", 2)
		return false
	end
	local rtxd = engineImportTXD(txd, objectID)
	if rtxd == nil or rtxd == false then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [TXD CORRUPT]", 1)
		return false
	end

	local dff = engineLoadDFF(dffPath)
	if dff == nil or dff == false then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [DFF LOAD]", 2)
		return false
	end

	local rdff = engineReplaceModel(dff, objectID)
	if rdff == false or rdff == nil then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [DFF CORRUPT]", 1)
		return false
	end

	if colPath then
		col = engineLoadCOL(colPath)
		if col == false then
			outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [COL LOAD]", 2)
			return false
		end
		rcol = engineReplaceCOL(col, objectID)
	end


	if rcol == false then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [COL CORRUPT]", 2)
		return false
	end
	return true, objectID
end

-- loads all models from dff/txd/col folders
function models_load()
	local MODELS = {}
	local TN = {}

	local stargate_ide = fileOpen("files/stargate.ide", true)
	local result = true
	local counter_loaded = 0
	setElementData(getLocalPlayer(), "models_load_for_counter_failed", counter_loaded)
	local counter_failed = 0
	setElementData(getLocalPlayer(), "models_load_for_counter_failed", counter_failed)
	local txdPath = nil
	local dffPath = nil
	local colPath = nil

	if not stargate_ide then
		outputDebugString("[MODELS|C] No models loaded! Unable to open 'files/stargate.ide' file.", 1)
		return false
	end
	local stargate_ide_content = fileRead(stargate_ide, fileGetSize(stargate_ide))
	local stargate_ide_lines = split(stargate_ide_content, "\n")
	local line = nil

	local hotuID = nil
	local txdFileName = nil
	local dffFileName = nil
	local line_split = nil
	local missingFiles = 0
	local missingFile = false
	local objectID = nil

	setElementData(getLocalPlayer(), "models_load_for_return", nil)
	setElementData(getLocalPlayer(), "models_load_for_break", false)
	local t = MODEL_LOAD_TIME
	local counter_delayed = 0

	local MODELS_DELAYED_LOAD = {} -- table for models which will be loaded slowly over time
	local DELAYED_TN = {}
	local bigFile = false
	-- { dffPath, txdPath, colPath, dffFileName, hotuID, size }

	for i,line in ipairs(stargate_ide_lines) do
		line_split = split(line, ", ")
		hotuID = line_split[1]
		dffFileName = line_split[2]
		txdFileName = line_split[3]
		dffPath = PATH_DFF..dffFileName..".dff"
		txdPath = PATH_TXD..txdFileName..".txd"
		txdPath = PATH_TXD..txdFileName..".txd"
		local txdFileDesc = fileOpen(txdPath)
		if txdFileDesc == false then
			outputDebugString("[MODELS|C] Unable to open file '"..txdPath.."'. Aborting loading models.")
			return false
		end
		local txdFileSize = fileGetSize(txdFileDesc)
		local MB = 0
		bigFile = false
		fileClose(txdFileDesc)

		missingFile = false
		if not fileExists(dffPath) then
			outputDebugString("[MODELS|C] Missing DFF File '"..tostring(dffPath).."' for HotuID "..tostring(hotuID), 1)
			missingFiles = missingFiles + 1
			missingFile = true
		end
		if not fileExists(txdPath) then
			outputDebugString("[MODELS|C] Missing TXD File '"..tostring(txdPath).."' for HotuID "..tostring(hotuID), 1)
			missingFiles = missingFiles + 1
			missingFile = true
		end
		if missingFiles > 5000 then
			outputDebugString("[MODELS|C] Too many files missing! Aborting model load.", 1)
			setElementData(getLocalPlayer(), "models_load_for_return", "false")
			return false
		end
		if fileExists(PATH_COL..dffFileName..".col") then
			colPath = PATH_COL..dffFileName..".col"	-- collision file has same name as model (dff) name
		else
			colPath = nil
		end

		if txdFileSize > BIG_FILE then
			counter_delayed = counter_delayed + 1
			setElementData(getLocalPlayer(), "models_load_for_counter_delayed", counter_delayed)
			bigFile = true

			DELAYED_TN = { dffPath, txdPath, colPath, dffFileName, hotuID, txdFileSize }
			MODELS_DELAYED_LOAD = array_push(MODELS_DELAYED_LOAD, DELAYED_TN)
			--outputDebugString("[MODELS|C] Skipping dff:'"..tostring(dffPath).."' txd: '"..tostring(txdPath).."' col:'"..tostring(colPath).."' HotuID "..tostring(hotuID).." (file too big)", 2)
		end

		if bigFile == false then
			setTimer(function(i, line, stargate_ide_lines, missingFile, dffFileName, hotuID, txdPath, dffPath, colPath)
				local MODELS = getElementData(getLocalPlayer(), "models_data")
				if missingFile == false then					
					result, objectID = models_loadObjectModel(txdPath, dffPath, colPath)

					if result == true then
						counter_loaded = counter_loaded + 1
						setElementData(getLocalPlayer(), "models_load_for_counter_loaded", counter_loaded)
						TN = { tonumber(objectID), dffFileName, tonumber(hotuID) }
						MODELS = array_push(MODELS, TN)
						setElementData(getLocalPlayer(), "models_data", MODELS)
					else
						counter_failed = counter_failed + 1
						setElementData(getLocalPlayer(), "models_load_for_counter_failed", counter_failed)
						if objectID then
							outputDebugString("Freeing model "..tostring(objectID))
							engineFreeModel(objectID)
						end
					end
				else
					counter_failed = counter_failed + 1
					setElementData(getLocalPlayer(), "models_load_for_counter_failed", counter_failed)
				end
			end, t, 1, i, line, stargate_ide_lines, missingFile, dffFileName, hotuID, txdPath, dffPath, colPath)
			t = t + MODEL_LOAD_TIME
		end
	end

	fileClose(stargate_ide)
	setTimer(function()
		engineRestreamWorld(true)
		local counter_failed = getElementData(getLocalPlayer(), "models_load_for_counter_failed")
		local counter_loaded = getElementData(getLocalPlayer(), "models_load_for_counter_loaded")
		local counter_delayed = getElementData(getLocalPlayer(), "models_load_for_counter_delayed")
		local result = true
		if counter_failed > 0 then
			result = false
		end

		setElementData(getLocalPlayer(), "models_data_load_result", result)
		setElementData(getLocalPlayer(), "models_delayed_load", MODELS_DELAYED_LOAD)
		engineRestreamWorld(true)
		outputDebugString("[MODELS|C] Loading models completed. ("..tostring(counter_loaded).." OK; "..tostring(counter_failed).." FAILED; "..tostring(counter_delayed).." DELAYED)")
		setTimer(models_loadBigFiles, 1000, 1)
	end, t+MODEL_LOAD_TIME*10, 1)

	return t+MODEL_LOAD_TIME*10
end

function models_loadBigFiles()
	local MODELS_DELAYED_LOAD = getElementData(getLocalPlayer(), "models_delayed_load")
	local DELAYED_TN = {}
	local t = 500
	local mb = 0
	local increase = 0
	setElementData(getLocalPlayer(), "models_load_for_counter_loaded", 0)
	setElementData(getLocalPlayer(), "models_load_for_counter_failed", 0)

	---- 
	---- TO BE DONE
	if 1 == 1 then
		for i, tn in ipairs(MODELS_DELAYED_LOAD) do
			outputDebugString("[MODELS|C] Model '"..tostring(tn[4]).."' was skipped from loading process. (TXD too big)")
		end
		outputDebugString("[MODELS|C] Big texture files and models were not loaded. [Work in progress]")
		return false
	end
	---- TO BE DONE
	----

	for i,tn in ipairs(MODELS_DELAYED_LOAD) do
		setTimer(function(dffPath, txdPath, colPath, dffFileName, hotuID, size)
			local MODELS = getElementData(getLocalPlayer(), "models_data")
			local counter_loaded = getElementData(getLocalPlayer(), "models_load_for_counter_loaded")
			local counter_failed = getElementData(getLocalPlayer(), "models_load_for_counter_failed")
			engineStreamingFreeUpMemory(size)
			result, objectID = models_loadObjectModel(txdPath, dffPath, colPath)

			if result == true then
				counter_loaded = counter_loaded + 1
				setElementData(getLocalPlayer(), "models_load_fuor_counter_loaded", counter_loaded)
				TN = { tonumber(objectID), dffFileName, tonumber(hotuID) }
				MODELS = array_push(MODELS, TN)
				setElementData(getLocalPlayer(), "models_data", MODELS)
			else
				counter_failed = counter_failed + 1
				setElementData(getLocalPlayer(), "models_load_for_counter_failed", counter_failed)
				if objectID then
					engineFreeModel(objectID)
				end
			end
		end, t, 1, tn[1], tn[2], tn[3], tn[4], tn[5], tn[6])
		mb = math.floor(tn[6]/1000000)
		if mb < 20 then
			increase = 5
		else
			increase = 10
		end
		t = t + mb*increase
	end

	setTimer(function()
		local counter_loaded = getElementData(getLocalPlayer(), "models_load_for_counter_loaded")
		local counter_failed = getElementData(getLocalPlayer(), "models_load_for_counter_failed")
		engineRestreamWorld(true)
		outputDebugString("[MODELS|C] Loading delayed completed. ("..tostring(counter_loaded).." OK; "..tostring(counter_failed).." FAILED)")
	end, t, 1)
	outputDebugString("[MODELS|C] Delayed loading models begin. Expected total time: "..tostring(t/1000).." seconds.")
end


function models_engineReserveObjectModelID(id, first)
	if LAST_RESERVED_OBJECT_MODEL >= id then
		return true
	end

	local modelID = nil
	while true do
		modelID = engineRequestModel("object")
		if modelID == nil or modelID == false then
			outputDebugString("models_engineReserveObjectModelID(...) did not found requested ID "..tostring(id), 2)
			return false
		end
		if first == true then
			LAST_RESERVED_OBJECT_MODEL = modelID
			return modelID
		end
		if tonumber(id) == tonumber(modelID) then
			return true
		end
		LAST_RESERVED_OBJECT_MODEL = modelID
	end
	return nil
end

function models_getObjectID(playerElement, objectName)
	local model_data = getElementData(playerElement, "models_data")
	local tn_objectID = nil
	local tn_objectName = nil
	local tn_hotuID = nil
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		tn_hotuID = tn[3]
		if tn_objectName == objectName then
			return tn_objectID
		end
	end
	return nil
end

function models_getObjectHOTUID(playerElement, objectName)
	local model_data = getElementData(playerElement, "models_data")
	local tn_objectID = nil
	local tn_objectName = nil
	local tn_hotuID = nil
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		tn_hotuID = tn[3]
		if tn_objectName == objectName then
			return tn_hotuID
		end
	end
	return nil
end

function models_setElementModelAttribute(element, modelDescription)
	setElementData(element, "element_model_data", modelDescription)
end

function models_getElementModelAttribute(element)
	return getElementData(element, "element_model_data")
end

-- sets elements model from serverside script
function setElementModelClient(element, modelID)
	setElementModel(element, modelID)
end
addEvent("setElementModelClient", true)
addEventHandler("setElementModelClient", resourceRoot, setElementModelClient)


addCommandHandler("outputmodels", function(cmd)
	local line = ""
	local model_data = getElementData(getLocalPlayer(), "models_data")
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		tn_hotuID = tn[3]
		line = line .. "<object model="..tostring(tn[1]).." name=\""..tn[2].."\" hotuID="..tostring(tn[3]).." />\n"
	end
	local f = fileCreate("output.xml")
	fileWrite(f, line)
	fileClose(f)
	outputDebugString("[MODELS|C] Models descriptions are written in file: output.xml (stargate_models resource root at client-side)")
end)