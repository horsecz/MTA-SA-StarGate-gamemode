-- commands.lua: Commands in models script; shared

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