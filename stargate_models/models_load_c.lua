--- load.c: Loading given models; client-side 

-- Load models in occupied planet
-- > core models (Stargate Model, Stargate Core, DHD Model)
-- > models in given range of player
function models_load_autoPlanetModelsLoad()
    local galaxy = planet_getElementOccupiedGalaxy(getLocalPlayer())
    local planet = planet_getElementOccupiedPlanet(getLocalPlayer())
    models_load_autoPlanetModelsUnload()
	
	-- load stargate models in specified galaxy
	-- > exceptions: development world -> load all SG models
    if galaxy == enum_galaxy.MILKYWAY or planet == "PLANET_6969"  then
        models_load_stargateMW()
        models_load_dhdMW()
	end
	if galaxy == enum_galaxy.PEGASUS or planet == "PLANET_6969"  then
		models_load_stargatePG()
        models_load_dhdPG()
	end
	if galaxy == enum_galaxy.UNIVERSE or planet == "PLANET_6969"  then
		models_load_stargateUA()
	end
	models_load_stargateCore()

	if planet == "PLANET_6969" then
		models_loadModelsNearPlayer(getLocalPlayer(), 1)
	else
		models_loadModelsNearPlayer(getLocalPlayer(), 9999)
	end
end
addEvent("models_load_autoPlanetModelsLoad_event", true)
addEventHandler("models_load_autoPlanetModelsLoad_event", root, models_load_autoPlanetModelsLoad)
global_setData("models_load_autoPlanetModelsLoad_event:added", true)

-- Unload core planet models (stargate models, dhd models)
function models_load_autoPlanetModelsUnload()
	local galaxy = planet_getElementOccupiedGalaxy(getLocalPlayer())
    local planet = planet_getElementOccupiedPlanet(getLocalPlayer())

	if galaxy == enum_galaxy.MILKYWAY or planet == "PLANET_6969" then
        models_load_stargateMW(true)
        models_load_dhdMW(true)
	end
	if galaxy == enum_galaxy.PEGASUS or planet == "PLANET_6969" then
		models_load_stargatePG(true)
        models_load_dhdPG(true)
	end
	if galaxy == enum_galaxy.UNIVERSE or planet == "PLANET_6969" then
		models_load_stargateUA(true)
	end
	models_load_stargateCore(true)
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

-- Loads pegasus stargate model
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_stargatePG(unload)
	local sg = models_getObjectID(getLocalPlayer(), "pegaze")

	models_loadModelManually(sg, unload)
	for i=1,2 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "CHpeg"..tostring(i)), unload)
	end
	for i=3,7 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "chpeg"..tostring(i)), unload)
	end
end

-- Loads universe stargate model
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_stargateUA(unload)
	local sg = models_getObjectID(getLocalPlayer(), "SGUGATE")
	local sg_chevs_active = models_getObjectID(getLocalPlayer(), "SGUCHEV")

	models_loadModelManually(sg, unload)
	models_loadModelManually(sg_chevs_active, unload)
end

-- Loads horizon, activation and kawoosh-vortex for MW and PG stargates
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_stargateCore(unload)
	for i=1,6 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "act"..tostring(i)), unload)
		models_loadModelManually(models_getObjectID(getLocalPlayer(), tostring(i)), unload) -- mw horizon
		models_loadModelManually(models_getObjectID(getLocalPlayer(), tostring(i).."peg"), unload) -- pg horizon
		models_loadModelManually(models_getObjectID(getLocalPlayer(), tostring(i).."SGU"), unload) -- ua horizon
	end
	for i=1,12 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "Kawoosh"..tostring(i)), unload) -- mw/pg kawoosh
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "SGUkaw"..tostring(i)), unload) -- ua kawoosh
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

-- Loads pegasus DHD model
--- OPTIONAL PARAMETERS:
--> unload		bool		will be model(s) unloaded?
function models_load_dhdPG(unload)
	local dhd = models_getObjectID(getLocalPlayer(), "pegdhd")
	models_loadModelManually(dhd, unload)
end