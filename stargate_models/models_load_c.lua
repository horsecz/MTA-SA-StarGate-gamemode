--- load.c: Loading given models; client-side 

-- Load models in occupied planet
-- > core models (Stargate Model, Stargate Core, DHD Model)
-- > models in given range of player
function models_load_autoPlanetModelsLoad()
    local galaxy = planet_getElementOccupiedGalaxy(getLocalPlayer())
    local planet = planet_getElementOccupiedPlanet(getLocalPlayer())
    models_load_autoPlanetModelsUnload()
    
    if galaxy == enum_galaxy.MILKYWAY then
        models_load_stargateMW()
        models_load_stargateCore()
        models_load_dhdMW()
    end
	if planet == 6969 or planet == "PLANET_6969" then
		models_loadModelsNearPlayer(getLocalPlayer(), 1)
	else
		models_loadModelsNearPlayer(getLocalPlayer(), 9999)
	end
end
addEvent("models_load_autoPlanetModelsLoad_event", true)
addEventHandler("models_load_autoPlanetModelsLoad_event", root, models_load_autoPlanetModelsLoad)
global_setData("models_load_autoPlanetModelsLoad_event:added", true)

-- Unload core planet models (stargate milkyway, core stargate, dhd milkyway)
function models_load_autoPlanetModelsUnload()
    models_load_stargateMW(true)
    models_load_stargateCore(true)
    models_load_dhdMW(true) 
end

-- Loads milkyway stargate model
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_stargateMW(unload)
	local sg_mw = models_getObjectID(getLocalPlayer(), "innerring")
	local sg_mw_ring = models_getObjectID(getLocalPlayer(), "outerring")

	models_loadModelManually(sg_mw, unload)
	models_loadModelManually(sg_mw_ring, unload)
	for i=1,9 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "chevs"..tostring(i)), unload)
	end
end

-- Loads horizon, activation and kawoosh-vortex for MW and PG stargates
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_stargateCore(unload)
	for i=1,6 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "act"..tostring(i)), unload)
		models_loadModelManually(models_getObjectID(getLocalPlayer(), tostring(i)), unload)
	end
	for i=1,12 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "Kawoosh"..tostring(i)), unload)
	end
	for i=1,10 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "iris"..tostring(i)), unload)
	end
end

-- Loads milkyway DHD model
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_dhdMW(unload)
    local dhd = models_getObjectID(getLocalPlayer(), "dhd")
	models_loadModelManually(dhd, unload)
end