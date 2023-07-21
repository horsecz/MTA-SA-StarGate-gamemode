--- models_s.lua: Model and texture loading module

-- load custom models
function loadModels()
    outputDebugString("Loading models: SGMW")
    callClientFunction(root, "loadModel", "object", "models/mw.txd", "models/mw.dff", "collisions/mw.col", "MWModelLoaded")
end

-- load gate model
function setMWModelID(id)
    outputDebugString("Loading models: SGMW-Ring")
    MWID = id
    callClientFunction(root, "loadModel", "object", "models/mw.txd", "models/mw_ring.dff", "collisions/mw_ring.col", "MWModelRingLoaded")
end
addEvent("MWModelLoaded", true)
addEventHandler("MWModelLoaded", resourceRoot, setMWModelID)

-- load ring model
function setMWModelRingID(id)
    MWID_r = id
    callClientFunction(root, "loadModel", "object", "models/9chevs.txd", "models/chevs1.dff", "collisions/chevs.col", "MWModelChevronLoaded")
    outputDebugString("Loading models: SGMW-Chevrons")
end
addEvent("MWModelRingLoaded", true)
addEventHandler("MWModelRingLoaded", resourceRoot, setMWModelRingID)

-- load chevron models
function setMWModelChevronID(id)
    MWID_c = array_push(MWID_c, id)
    chevrons_loaded = array_size(MWID_c)
    if chevrons_loaded < 9 then
        callClientFunction(root, "loadModel", "object", "models/9chevs.txd", "models/chevs"..tostring(chevrons_loaded+1)..".dff", "collisions/chevs.col", "MWModelChevronLoaded")
    else
        outputDebugString("Loading models: SGMW-Horizon")
        callClientFunction(root, "loadModel", "object", "models/1.txd", "models/1.dff", "collisions/first.col", "MWModelHorizonLoaded")
    end
end
addEvent("MWModelChevronLoaded", true)
addEventHandler("MWModelChevronLoaded", resourceRoot, setMWModelChevronID)

-- load event horizon models
function setMWModelHorizonID(id)
    local newArrayElementI = MW_Horizon_last + 1
    MW_Horizon_last = MW_Horizon_last + 1
    MW_Horizon[newArrayElementI] = id
    if newArrayElementI < 6 then
        callClientFunction(root, "loadModel", "object", "models/"..tostring(newArrayElementI)..".txd", "models/"..tostring(newArrayElementI)..".dff", "collisions/"..tostring(newArrayElementI)..".col", "MWModelHorizonLoaded")
    else
        outputDebugString("Loading models: SG-Kawoosh")
        callClientFunction(root, "loadModel", "object", "models/Kawoosh.txd", "models/Kawoosh1.dff", "collisions/Kawoosh1.col", "ModelKawooshLoaded")
    end
end
addEvent("MWModelHorizonLoaded", true)
addEventHandler("MWModelHorizonLoaded", resourceRoot, setMWModelHorizonID)

-- load vortex modelf
function setKawooshModelID(id)
    local newArrayElementI = SG_Kawoosh_last + 1
    SG_Kawoosh_last = SG_Kawoosh_last + 1
    SG_Kawoosh[newArrayElementI] = id
    if newArrayElementI < 12 then
        callClientFunction(root, "loadModel", "object", "models/Kawoosh.txd", "models/Kawoosh"..tostring(newArrayElementI)..".dff", "collisions/Kawoosh"..tostring(newArrayElementI)..".col", "ModelKawooshLoaded")
    else
        initModels()   
    end
end
addEvent("ModelKawooshLoaded", true)
addEventHandler("ModelKawooshLoaded", resourceRoot, setKawooshModelID)