--- models_s.lua: Model and texture loading module for stargate gamemode; server-side

function models_load_autoPlanetModelsLoad()
	triggerClientEvent("models_load_autoPlanetModelsLoad_event", resourceRoot)
end