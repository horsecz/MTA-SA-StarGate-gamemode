--- load.c: manual loading of models

function models_load_autoPlanetModelsLoad()
    local galaxy = planet_getElementOccupiedGalaxy(getLocalPlayer())
    local planet = planet_getElementOccupiedPlanet(getLocalPlayer())
    models_load_autoPlanetModelsUnload()
    
    if galaxy == enum_galaxy.MILKYWAY then
        models_load_stargateMW()
        models_load_stargateCore()
        models_load_dhdMW()
    end
	models_loadModelsNearPlayer(getLocalPlayer(), 150)
end
addEvent("models_load_autoPlanetModelsLoad_event", true)
addEventHandler("models_load_autoPlanetModelsLoad_event", root, models_load_autoPlanetModelsLoad)

function models_load_autoPlanetModelsUnload()
    models_load_stargateMW(true)
    models_load_stargateCore(true)
    models_load_dhdMW(true) 
end

-- loads milkyway stargate
function models_load_stargateMW(unload)
	local sg_mw = models_getObjectID(getLocalPlayer(), "innerring")
	local sg_mw_ring = models_getObjectID(getLocalPlayer(), "outerring")

	models_loadModelManually(sg_mw, unload)
	models_loadModelManually(sg_mw_ring, unload)
	for i=1,9 do
		models_loadModelManually(models_getObjectID(getLocalPlayer(), "chevs"..tostring(i)), unload)
	end
end

-- loads horizon, activation and kawoosh for MW and PG stargates
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

-- loads milkyway DHD
function models_load_dhdMW(unload)
    local dhd = models_getObjectID(getLocalPlayer(), "dhd")
	models_loadModelManually(dhd, unload)
end