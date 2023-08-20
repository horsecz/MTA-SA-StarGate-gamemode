-- models_c.lua: Model and texture loading module for stargate gamemode; client-side

-- Actions performed on this client resource start
-- > Initialize models_data table
-- > Load all model data into player
-- > Refresh model IDs (change from 1337 to custom)
-- > Load core models
-- > Start timers - VM Protection; VM Memory warning
function models_clientStarted()
	outputDebugString("[MODELS|C] Client started; Loading models ...")
	setElementData(getLocalPlayer(), "models_data", {})


	local loadTime = models_load()	-- only parses, all models have isLoaded == false

	if not loadTime then
		outputChatBox("[STARGATE:MODELS] Fatal error: models cannot be loaded. Reconnect and try again.")
		fadeCamera(false)
		setElementPosition(getLocalPlayer(), 99999, 99999, 9999)
		setElementFrozen(getLocalPlayer(), true)
		setElementAlpha(getLocalPlayer(), 0)
		return false
	end
	setTimer(models_loadObjects, loadTime, 1)
	setTimer(models_loadCore, loadTime+1000, 1)

	local models_timer = setTimer(models_clientTimer, 1000, 0)
	local vm_timer = setTimer(models_vm_protection, 100, 0)
	setElementData(getLocalPlayer(), "timer_stargate_models", models_timer)
	setElementData(getLocalPlayer(), "timer_stargate_models_vm_protection", vm_timer)
end
addEventHandler("onClientResourceStart", resourceRoot, models_clientStarted)

-- Periodical check if client has enough free GPU Virtual Memory
-- > to prevent game crash that may occur when:
--		> this resource will somehow fail and bloats (fills) the entire memory
--		> player has low-spec PC and memory will get full on normal use
-- > also checks on start for VM stats and notifies user if his VM is below recommended or minimum values (once)
-- > notifies user when VM is below specified treshold
function models_clientTimer()
	local VMTotal = dxGetStatus().VideoCardRAM	-- MB
	local VMFree = dxGetStatus().VideoMemoryFreeForMTA	 -- MB
	local VMTotal_warning = getElementData(getLocalPlayer(), "timer_stargate_models:VMTotalWarning")
	local VMFree_warning = getElementData(getLocalPlayer(), "timer_stargate_models:VMFreeWarning")
	if not VMFreeWarning then
		setElementData(getLocalPlayer(), "timer_stargate_models:VMFreeWarning", 1)
	end

	local VMTotal_warn = false
	local VMFree_warn = false

	if VMTotal < VM_RECOMMENDED_MB then
		VMTotal_warn = true
	end
	if VMFree < VM_LOW_WARNING_MB then
		VMFree_warn = true
	end
	
	if VMTotal_warn == true and VMTotal_warning == false then
		if VMTotal < VM_MINIMUM_MB then
			local mq_level_str = "3"
			if VMTotal < VM_MINIMUM_MB and VMTotal > VM_MINIMUM_MB_L3 then
				mq_level_str = "Medium"
				DUPE_TXD_LOAD_MAX = DUPE_TXD_LOAD_MAX_LOWSPEC_1
			elseif VMTotal <= VM_MINIMUM_MB_L3 and VMTotal > VM_MINIMUM_MB_L2 then
				mq_level_str = "Low"
				DUPE_TXD_LOAD_MAX = DUPE_TXD_LOAD_MAX_LOWSPEC_2
			elseif VMTotal <= VM_MINIMUM_MB_L2 and VMTotal > VM_MINIMUM_MB_L1 then
				mq_level_str = "Minimum"
				DUPE_TXD_LOAD_MAX = DUPE_TXD_LOAD_MAX_LOWSPEC_3
			else
				mq_level_str = "Minimum"
				DUPE_TXD_LOAD_MAX = DUPE_TXD_LOAD_MAX_LOWSPEC_3
			end

			if VMTotal < VM_MINIMUM_MB_L1 then
				outputChatBox("[SG:MODELS] WARNING! Your total GPU Video Memory is less than absoulte minimum value for playing this gamemode. Your GPU VM: "..tostring(VMTotal).." MB; Recommended: "..tostring(VM_MINIMUM_MB_L1).." MB") 	
				outputChatBox("[SG:MODELS] Your texture quality setting was lowered to prevent game crash, however you may still experience it due to very low memory.")
			else
				outputChatBox("[SG:MODELS] WARNING! Your total GPU Video Memory is less than minimum recommended value. Your GPU VM: "..tostring(VMTotal).." MB; Recommended: "..tostring(VM_RECOMMENDED_MB).." MB") 
				outputChatBox("[SG:MODELS] Your texture quality setting was lowered to prevent game crash and ensure you can still enjoy this gamemode.")
			end
			outputChatBox("[SG:MODELS] Textures quality level: "..mq_level_str)
		else
			outputChatBox("[SG:MODELS] WARNING! Your total GPU Video Memory is less than recommended value for smooth gameplay. Your GPU VM: "..tostring(VMTotal).." MB; Recommended: "..tostring(VM_RECOMMENDED_MB).." MB")
			outputChatBox("[SG:MODELS] Although you satisfy minimum requirements ("..tostring(VM_MINIMUM_MB).." MB), you may still experience lower FPS or lags when playing.")
		end
		setElementData(getLocalPlayer(), "timer_stargate_models:VMTotalWarning", "happened")
	end
	if VMFree_warn == true then
		if VMFree_warning < VM_LOW_WARNING_REPS then
			setElementData(getLocalPlayer(), "timer_stargate_models:VMFreeWarning", VMFree_warning + 1)
		else
			outputChatBox("[SG:MODELS] WARNING! Your free GPU memory is less than "..tostring(VM_LOW_WARNING_MB).." MB! Try to travel to another planet.")
			setElementData(getLocalPlayer(), "timer_stargate_models:VMFreeWarning", 1)
		end
	end

end

-- Frees all models and memory on this resource stop
function models_clientStopped()
	local MODELS = getElementData(getLocalPlayer(), "models_data")
	models_freeObjectTextures()
	for i,tn in ipairs(MODELS) do
		for i,tn_element in ipairs(tn) do
			engineFreeModel(tn[1])
		end
	end
end
addEventHandler("onClientResourceStop", resourceRoot, models_clientStopped)

-- Anti-crash system - protects client from crashing by filling the entire GPU Video Memory (and overflowing it)
-- 	> Unloads all textures when VM is below specified treshold
--  > If player is not in San Andreas, teleports him there
--- OPTIONAL PARAMETERS:
--> dontAsk		bool		dont wait for if condition and destroy the models now
function models_vm_protection(dontAsk)
	local VMFree = dxGetStatus().VideoMemoryFreeForMTA -- MB
	if VMFree < VM_DESTROY_THRESHOLD or dontAsk == true then
		models_unloadModels()
		local str_addition = "."
		if not planet_getElementOccupiedPlanet(getLocalPlayer()) == "PLANET_0" then
			setElementPosition(getLocalPlayer(), 0, 0, 5)
			planet_setElementOccupiedPlanet(getLocalPlayer(), "PLANET_0", true)
			str_addition = " and teleported you to San Andreas."
		end
		outputChatBox("[SG:MODELS] ATTENTION! Gamemode has detected, that your remaining GPU Video Memory was extremely low (free memory: "..tostring(VMFree).." MB; treshold: "..tostring(VM_DESTROY_THRESHOLD).." MB)")
		outputChatBox("[SG:MODELS] To prevent game crash, gamemode automatically unloaded all custom models"..tostring(str_addition))
	end
end

-- Loads all core models needed for gamemode to work
-- > planet models (models used on current planet) 
function models_loadCore()
	models_load_autoPlanetModelsLoad()
end

-- Change all object model IDs (load their models) from 1337 (default) to custom model IDs
--- OPTINAL PARAMETERS:
--> reload		bool		will be model IDs reloaded?
--- RETURNS:
--> Bool; true if model ids are already loaded (and reload is not active), otherwise no return value
function models_loadObjects(reload)
	local modelsLoaded = getElementData(getLocalPlayer(), "player_object_models_loaded")
	if modelsLoaded == true then
		outputDebugString("[MODELS|C] Reloading object models.")
	end

	local model_data = nil
	local id = nil
	for i,object in ipairs(getElementsByType("object")) do
		model_data = models_getElementModelAttribute(object)
		if model_data then
			id = models_getObjectID(getLocalPlayer(), model_data)
			if id then
				setElementModel(object, id)
				local x,y,z = getElementPosition(object)
				--outputDebugString("[MODELS|C] Object element '"..tostring(getElementID(object)).." was assigned model '"..tostring(id).."'")
			end
		end
	end
	setElementData(getLocalPlayer(), "player_object_models_loaded", true)
end

-- Frees GPU VM by destroying all used/loaded texture elements
function models_freeObjectTextures()
	local txds = getElementData(getLocalPlayer(), "txd_loaded_list")
	local cnt = 0
	if txds then
		for i,txd_table in ipairs(txds) do
			destroyElement(txd_table[1])
			cnt = i
		end
	end
	setElementData(getLocalPlayer(), "txd_loaded_list", {})
	outputDebugString("[MODELS|C] Destroyed "..tostring(cnt).." texture elements.")
end

-- Unloads all loaded models from memory 
function models_unloadModels()
	models_freeObjectTextures()
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
end

-- Loads texture, model and collisions for one object
--- REQUIRED PARAMETERS:
--> txdPath			string		filepath to .txd file
--> dffPath			string		filepath to .dff file
--> colPath			string		filepath to .col file
--- OPTIONAL PARAMETERS:
--> requestIDOnly	bool		will be just requested model ID from engineRequestModel?
--> doNotRequestID	bool		don't request new model ID
--> id				int			ID of model (used for unloading)
--> unload			bool		will be model unloading performed instead loading?
--- RETURNS:
--> Bool; true if success, false if failure
--> Int; new model ID (may and may not be returned)
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
	local txd_list = getElementData(getLocalPlayer(), "txd_loaded_list")
	local txd_isNew = true
	local txd = nil
	local txd_num = 1
	local rtxd_loaded = false
	local rtxd = nil

	-- doesnt work on AMD GPU ...
	if dxGetStatus().VideoMemoryFreeForMTA < VM_DESTROY_THRESHOLD then
		models_vm_protection(true)
		return false
	end

	-- reuse loaded txd if loaded too often
	if txd_list then
		for i,t_table in ipairs(txd_list) do
			if t_table[2] == txdPath then
				txd_num = t_table[3]
				if t_table[3] >= DUPE_TXD_LOAD_MAX then
					txd_isNew = false
					txd = t_table[1]
					rtxd = engineImportTXD(txd, objectID)
					if rtxd then
						rtxd_loaded = true
						break
					end
				end
			end
		end
	end

	if txd_isNew == true then
		txd = engineLoadTXD(txdPath)
		txd_num = txd_num + 1
	end

	if not txd then 
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [TXD LOAD] (Free VM: "..tostring(dxGetStatus().VideoMemoryFreeForMTA)..")", 2)
		return false
	end

	if rtxd_loaded == false then
		rtxd = engineImportTXD(txd, objectID)
	end
	if not rtxd then
		if txd_isNew == true then -- we care only if its newly loaded TXD
			outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [TXD IMPORT "..tostring(rtxd).."]", 1)
			return false
		end
	end

	-- REUSING TEXTURES
	--if not rtxd then -- cannot reuse TXD -> need load it again
	--	outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") Failed -> trying another", 2)
	--	
	--	local txd_num = 1
	--	local txd_loaded = false
	--	if txd_list then -- use already loaded txd but different (try all of them)
	--		for i,t_table in ipairs(txd_list) do
	--			if t_table[2] == txdPath and t_table[3] > 1 then -- dont try the first one again
	--				txd_isNew = false
	--				txd = t_table[1]
	--				txd_num = t_table[3]
--
--					rtxd = engineImportTXD(txd, objectID)
--					if rtxd then
--						txd_loaded = true
--						outputDebugString("Another found! Number: "..tostring(txd_num))
--						break
--					end
--				end
--			end
--		end
--
--		if txd_loaded == false then -- none of them worked properly
--			txd_num = txd_num + 1
--			txd = engineLoadTXD(txdPath)
--			rtxd = engineImportTXD(txd, objectID)
--			outputDebugString("Another not found. Loading TXD again ("..tostring(txd_num).."th time).")
--			if not rtxd then
--				outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [TXD IMPORT "..tostring(rtxd).."]", 1)
--				return false
--			end
--			txd_list = array_push(txd_list, { txd, txdPath, txd_num })
--		end
--	end

	dff = engineLoadDFF(dffPath, objectID)
	if dff == nil or dff == false then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [DFF LOAD]", 2)
		return false
	end

	local rdff = engineReplaceModel(dff, objectID)
	if rdff == false or rdff == nil then
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [DFF REPLACE]", 1)
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
		outputDebugString("loadObjectModel("..tostring(objectID)..","..tostring(txdPath)..","..tostring(dffPath)..","..tostring(colPath)..") [COL REPLACE]", 2)
		return false
	end

	if txd_list and txd_isNew == true then
		txd_list = array_push(txd_list, { txd, txdPath, txd_num })
	end
	--txd_list = array_push(txd_list, { txd, txdPath, array_size(txd_list) })
	setElementData(getLocalPlayer(), "txd_loaded_list", txd_list)
	return true, objectID
end

-- Prepares all models for loading
-- > Reads stargate.ide file
-- > Extracts useful information from it (such as txd file name, model file name, ID, etc.)
-- > Requests new model ID for given model
-- > Saves data into local player (models_data) 
--- RETURNS:
--> Int; Time that will take for models data to be loaded into player or false if data cannot be loaded
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
		outputChatBox("[STARGATE:MODELS] Unable to open file 'files/stargate.ide' in 'stargate_models' resource.")
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
			outputDebugString("[MODELS|C] Unable to open file '"..tostring(txdPath).."'. Aborting loading models.")
			outputChatBox("[STARGATE:MODELS] Unable to open file '"..tostring(txdPath).."' in 'stargate_models' resource.")
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

-- Manual load of one object model
--- REQUIRED PARAMATERS:
--> objectID	int		ID of object whose model will be loaded
--- OPTIONAL PARAMETERS:
--> unload		bool	will be model loaded or unloaded?
--> reload		bool	refresh/reload all object model IDs after model is loaded?
--- RETURNS:
--> Bool; false if object ID is invalid and load failed, otherwise no return value
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

-- Reserve object model ID
-- Note: may not be needeed?
--- REQUIRED PARAMETERS:
--> id		int		model ID to be reserved
--> first	bool	is this the first reserved model ID?
--- RETURNS:
--> Bool; true if model ID was reserved (or already is), false if engineRequestModel function failed, nil otherwise
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


-- Loads HOTU custom models (of objects) in given range of given element
-- > objects and element must be in same dimension
-- > camera will be moved away when loading the models and moved back after its done
--- REQUIRED PARAMETERS:
--> e		reference		element
--> range	int				range in which will be models loaded 
function models_loadHOTUModelsInRangeOfElement(e, range)
	setCameraMatrix(-10000,-10000,-1000)
	setElementFrozen(getLocalPlayer(), true)
    local x,y,z = getElementPosition(e)
	local d = getElementDimension(e)
    local id = 0
    local cnt = 0
    local ox,oy,oz,od = nil
    local t = 50
	local loadedModelsList = getElementData(getLocalPlayer(), "loaded_models_list")

    for i,object in ipairs(getElementsByType("object")) do
        if getElementData(object, "hotu_object") == true or getElementData(object, "hotu_object") == "true" then
            ox,oy,oz = getElementPosition(object)
			od = getElementDimension(object)
            if math.abs(x - ox) < range and math.abs(y - oy) < range and math.abs(z - oz) < range and od == d then
                id = models_getObjectID(getLocalPlayer(), getElementData(object, "element_model_data"))
                setTimer(models_loadModelManually, t, 1, id, false)
				loadedModelsList = array_push(loadedModelsList, object)
                cnt = cnt + 1
                t = t + 10
            end
        end
    end

	models_loadObjects(true)
	setTimer(setElementFrozen, t+100, 1, getLocalPlayer(), false)
	setTimer(setElementCollisionsEnabled, t+100, 1, getLocalPlayer(), true)
	setTimer(setCameraTarget, t+150, 1, getLocalPlayer())
	setTimer(setElementData, t+100, 1, e, "planet_models_loaded", true)
	setElementData(getLocalPlayer(), "loaded_models_list", loadedModelsList)
    outputDebugString("[MODELS|C] Loaded "..tostring(cnt).." objects in "..tostring(range).." range of '"..tostring(getElementID(e)).."' ")
end

-- Loads object models near player in given range
-- > player and objects must be in same dimension (as in loadHOTUModelsInRangeOfElement)
-- > if s_range is greater than maximum value, it will be capped to that value
--- REQUIRED PARAMETERS:
--> playerElement	reference	player
--> s_range			int			range in which models will be loaded
--- RETURNS:
--> Bool; false if player element is invalid, otherwise no return value
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
	models_unloadModels()

	setTimer(setElementData, 100, 1, getLocalPlayer(), "loaded_models_list", {})
	setTimer(models_loadHOTUModelsInRangeOfElement, 200, 1, playerElement, range)
end