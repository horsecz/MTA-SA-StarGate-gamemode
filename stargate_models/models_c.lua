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
		-- TN				=	{ objectID, dffFileName, txdFileName, colFileName, hotuID }
			-- objectID		=	model ID of object (int)
			-- dffFileName	=	description name of object; dff file name (string)
			-- txdFileName	= 	name of txd
			-- colFileName	=	name of collision file
			-- hotuID		=	model ID of object in Horizon of the Universe v2.0 mod


	local loadTime = models_load()	-- only parses, all models have isLoaded == false
	setTimer(models_loadObjects, loadTime, 1)
	setTimer(models_loadCore, loadTime+1000, 1)
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

function models_loadCore()
	models_load_autoPlanetModelsLoad()
end

function models_loadObjects(reload)
	local modelsLoaded = global_getData("MODELS_LOADED")
	if modelsLoaded == true then
		if not reload then
			return true
		else
			outputDebugString("[MODELS|C] Reloading object models.")
		end
	end

	local model_data = nil
	local id = nil
	for i,object in ipairs(getElementsByType("object")) do
		model_data = models_getElementModelAttribute(object)
		if model_data then
			if getElementData(object, "element_model_modelSet") == true then
				-- model already set
			else
				id = models_getObjectID(getLocalPlayer(), model_data)
				if id then
					setElementModel(object, id)
					local x,y,z = getElementPosition(object)
					outputDebugString("[MODELS|C] Object element '"..tostring(getElementID(object)).." was assigned model '"..tostring(id).."'")
					setElementData(object, "element_model_modelSet", true)
				else
					id = models_getUnloadedObjectID(getLocalPlayer(), model_data)
					if id then
						if getElementData(object, "hotu_object") == true then -- not loaded model
							--outputDebugString("[MODELS|C] Object element '"..tostring(getElementID(object)).."' is HOTU object, but its model is not loaded.")
						end
					else -- not HOTU object
						outputDebugString("[MODELS|C] Object element '"..tostring(getElementID(object)).."' has unknown objectName '"..tostring(model_data).."' and was not set new model ID.")
					end
				end
			end
		end
	end
	global_setData("MODELS_LOADED", true)
end

-- loads model of one object
function models_loadObjectModel(txdPath, dffPath, colPath, requestIDOnly, doNotRequestID, id, unload)
	local rres = nil
	if doNotRequestID == false or doNotRequestID == nil then
		rres = engineRequestModel("object")
	else
		rres = id
	end
	if rres == false or rres == nil then
		if not doNotRequestID then
			outputDebugString("[MODELS|C] Error in loadModel("..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [ENGINE]")
			return false
		end
	end
	if requestIDOnly == true then
		return true, rres
	end

	if unload == true then
		engineRestoreModel(id)
		engineRestoreCOL(id)
		return true
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

		--if txdFileSize > BIG_FILE then
		if 1 == 2 then
			counter_delayed = counter_delayed + 1
			setElementData(getLocalPlayer(), "models_load_for_counter_delayed", counter_delayed)
			bigFile = true

			MODELS_DELAYED_LOAD = getElementData(getLocalPlayer(), "models_delayed_load")
			DELAYED_TN = { dffPath, txdPath, colPath, dffFileName, hotuID, txdFileSize }
			MODELS_DELAYED_LOAD = array_push(MODELS_DELAYED_LOAD, DELAYED_TN)
			setElementData(getLocalPlayer(), "models_delayed_load", MODELS_DELAYED_LOAD)
			outputDebugString("[MODELS|C] Skipping dff:'"..tostring(dffPath).."' txd: '"..tostring(txdPath).."' col:'"..tostring(colPath).."' HotuID "..tostring(hotuID).." (file too big)", 2)
		end

		if bigFile == false then
			setTimer(function(i, line, stargate_ide_lines, missingFile, dffFileName, hotuID, txdPath, dffPath, colPath, txdFileName)
				local MODELS = getElementData(getLocalPlayer(), "models_data")
				if missingFile == false then					
					result, objectID = models_loadObjectModel(txdPath, dffPath, colPath, true) -- request model ID only

					if result == true then
						counter_loaded = counter_loaded + 1
						setElementData(getLocalPlayer(), "models_load_for_counter_loaded", counter_loaded)
						TN = { tonumber(objectID), dffFileName, txdFileName, colPath, tonumber(hotuID) }
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
			end, t, 1, i, line, stargate_ide_lines, missingFile, dffFileName, hotuID, txdPath, dffPath, colPath, txdFileName)
			t = t + MODEL_LOAD_TIME
		end
	end

	fileClose(stargate_ide)
	--setTimer(function()
		--local counter_failed = getElementData(getLocalPlayer(), "models_load_for_counter_failed")
		--local counter_loaded = getElementData(getLocalPlayer(), "models_load_for_counter_loaded")
		--local counter_delayed = getElementData(getLocalPlayer(), "models_load_for_counter_delayed")
		--local result = true
		--if counter_failed > 0 then
		--	result = false
		--end

		--setElementData(getLocalPlayer(), "models_data_load_result", result)
		--engineRestreamWorld(true)
		--outputDebugString("[MODELS|C] Loading models completed. ("..tostring(counter_loaded).." OK; "..tostring(counter_failed).." FAILED; "..tostring(counter_delayed).." DELAYED)")
		--setTimer(models_loadBigFiles, 1000, 1)
	--end, t+MODEL_LOAD_TIME*10, 1)

	return t+MODEL_LOAD_TIME*10
end

function models_loadModelManually(objectID, unload, reload)
	local MODELS_DATA = getElementData(getLocalPlayer(), "models_data")
	local file = nil
	for i,tn in ipairs(MODELS_DATA) do -- TN = { objectID, dffFileName, txdFileName, colPath, hotuID }
		if tn[1] == tonumber(objectID) then
			file = tn
			break
		end
	end

	if file == false or file == nil then
		outputDebugString("[MODELS|C] Unable to manually load '"..tostring(objectID).."' (objectID invalid)")
		return false
	end
	local dffFileName = file[2]
	local txdFileName = file[3]
	engineStreamingFreeUpMemory(100000000) -- try to free some memory

	local dffPath = PATH_DFF..dffFileName..".dff"
	local txdPath = PATH_TXD..txdFileName..".txd"
	local colPath = file[4]
	result = models_loadObjectModel(txdPath, dffPath, colPath, false, true, file[1], unload)

	if result == true then
		if unload == true then
			--outputDebugString("[MODELS|C] Unload model '"..tostring(dffFileName).."' SUCCESS")
		else
			--outputDebugString("[MODELS|C] Load model '"..tostring(dffFileName).."' SUCCESS")
		end
		if getElementData(getLocalPlayer(), "manual_load_result") then
			setElementData(getLocalPlayer(), "manual_load_result", getElementData(getLocalPlayer(), "manual_load_result") + 1 )
		end
	else
		if unload == true then
			outputDebugString("[MODELS|C] Unload model '"..tostring(dffFileName).."' FAIL")
		else
			outputDebugString("[MODELS|C] Load model '"..tostring(dffFileName).."' FAIL")
		end
	end
	if reload == true then
		models_loadObjects(true)
	end
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
		--for i, tn in ipairs(MODELS_DELAYED_LOAD) do
			--outputDebugString("[MODELS|C] Model '"..tostring(tn[4]).."' was skipped from loading process. (TXD too big)")
		--end
		--outputDebugString("[MODELS|C] Big texture files and models were not loaded. [Work in progress]")
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

function models_getUnloadedObjectID(playerElement, objectName)
	local model_delayed = getElementData(playerElement, "models_delayed_load")
	for i,tn in ipairs(model_delayed) do
		if tn[4] == objectName then
			return tn[5]
		end
	end	-- Table structure: { dffPath, txdPath, colPath, dffFileName, hotuID, size }
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

function models_loadHOTUModelsInRangeOfElement(e, range)
    local x,y,z = getElementPosition(e)
    local id = 0
    local cnt = 0
    local ox,oy,oz = nil
    local t = 50
	local loadedModelsList = getElementData(getLocalPlayer(), "loaded_models_list")

    for i,object in ipairs(getElementsByType("object")) do
        if getElementData(object, "hotu_object") == true or getElementData(object, "hotu_object") == "true" then
            ox,oy,oz = getElementPosition(object)
            if math.abs(x - ox) < range and math.abs(y - oy) < range and math.abs(z - oz) < range then
                id = models_getObjectID(getLocalPlayer(), getElementData(object, "element_model_data"))
                setTimer(models_loadModelManually, t, 1, id, false)
				loadedModelsList = array_push(loadedModelsList, object)
                cnt = cnt + 1
                t = t + 10
            end
        end
    end

	models_loadObjects(true)
	setElementData(getLocalPlayer(), "loaded_models_list", loadedModelsList)
    outputDebugString("[MODELS|C] Loaded "..tostring(cnt).." objects in "..tostring(range).." range of '"..tostring(getElementID(e)).."' ")
end

function models_loadModelsNearPlayer(playerElement, s_range)
	local range = tonumber(s_range)
	if range > 250 then
		range = 250
		outputDebugString("models_loadModelsNearPlayer(...) range capped to "..tostring(range), 2)
	end
	if not playerElement then
		outputDebugString("models_loadModelsNearPlayer(...) missing playerElement ("..tostring(playerElement)..")", 1)
		return false
	end

	local cnt = 0
	local id = nil
	loadedModelsList = getElementData(getLocalPlayer(), "loaded_models_list")
	if not loadedModelsList == false then  
		for i,object in ipairs(loadedModelsList) do
			id = models_getObjectID(getLocalPlayer(), getElementData(object, "element_model_data"))
			models_loadModelManually(id, true)
			cnt = cnt + 1
		end
		outputDebugString("[MODELS|C] Unloaded "..tostring(cnt).." objects from memory.")
	end

	setTimer(setElementData, 100, 1, getLocalPlayer(), "loaded_models_list", {})
	setTimer(models_loadHOTUModelsInRangeOfElement, 200, 1, playerElement, range)
end
addCommandHandler("loadModels", function(cmd, range)
	models_loadModelsNearPlayer(getLocalPlayer(), range)
end)

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