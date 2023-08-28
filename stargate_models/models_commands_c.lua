-- commands_c.lua: Commands in models script; client-side

-- Sets user texture quality level
addCommandHandler("txdquality", function(cmd, level_str)
	if not level_str then
		outputChatBox("[STARGATE:MODELS] You need to specify the level! (value 1-4)")
		return nil
	end
	local level_string = models_setTextureQualitySetting(tonumber(level_str))

	if not level_string then
		outputChatBox("[STARGATE:MODELS] You need to specify correct level! (value 1-4)")
	else
		outputChatBox("[STARGATE:MODELS] Your texture quality level was set to: '"..tostring(level_string).."'.")
	end
end)

-- Loads models near player in given range
addCommandHandler("loadModels", function(cmd, range)
	models_loadModelsNearPlayer(getLocalPlayer(), range)
end)

-- Outputs all loaded HOTU models into .map like file at client-side
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
	outputDebugString("[STARGATE:MODELS] Models descriptions are written in file: output.xml (stargate_models resource root at client-side)")
end)

-- Loads HOTU object and "displays" it in development world (by creating new object with the model)
-- > if not given object element identifier, it will be destroyed shortly (in 10 seconds)
-- > if player is not in development world, teleports him there (near the object)
addCommandHandler("showmodel", function(cmd, dffFileName, objectID)
	local id = models_getObjectID(getLocalPlayer(), dffFileName)
	if not id then
		outputChatBox("Invalid object identifier (dffFileName)")
		return false
	end
	models_loadModelManually(id, false)
	local o = createObject(1337, 0, 0, 5)
	setElementModel(o, id)
	setElementDimension(o, 6969)

	if objectID then
		setElementID(o, objectID)
	else
		setTimer(destroyElement, 10000, 1, o)
	end

	if not getElementDimension(getLocalPlayer()) == 6969 then
		setElementPosition(getLocalPlayer(), 0, 1, 5)
		setElementDimension(getLocalPlayer(), 6969)
	end
end)