--- models_s.lua: Model and texture loading module for stargate gamemode; server-side

function models_load_autoPlanetModelsLoad()
	if global_getData("models_load_autoPlanetModelsLoad_event:added") == true then
		triggerClientEvent("models_load_autoPlanetModelsLoad_event", resourceRoot)
	end
end