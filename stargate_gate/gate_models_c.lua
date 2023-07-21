-- models_c.lua_ Clientside model and texture load module

function loadModel(modelType, txdPath, dffPath, colPath, serverEvent)
	local modelID = engineRequestModel(modelType)
	if not modelID then
		outputDebugString("Error in loadModel("..tostring(modelType)","..txdPath..","..dffPath..","..colPath..", \""..serverEvent.."\"). [no model-id]")
		return nil
	end
	local txd = engineLoadTXD(txdPath)
	engineImportTXD(txd, modelID)
	local dff = engineLoadDFF(dffPath)
	engineReplaceModel(dff, modelID)
	col = engineLoadCOL(colPath)
	engineReplaceCOL(col, modelID)
	triggerServerEvent(serverEvent, resourceRoot, modelID)
end

-- sets elements model from serverside script
function setElementModelClient(element, modelID)
	setElementModel(element, modelID)
end
addEvent("setElementModelClient", true)
addEventHandler("setElementModelClient", resourceRoot, setElementModelClient)
