-- useful.lua: Useful functions when working with stargate models; shared

--- Object model attributes (HOTU object)
--> element_model_data      	filename of DFF used in HOTU mod

--- Player model attributes (local player)
--> models_data             	table for saving data about object IDs and their names
---                         	contains: { T1, T2, T3, ..., TN }
---                         	where TN is table containing: { objectID, dffFileName, txdFileName, colFileName, hotuID }
---                             	where   objectID    =   int; model ID of object
---                                     	dffFileName	=	string; description name of object; dff file name
---                                     	txdFileName	= 	string; name of txd
---                                 	    colFileName	=	string; name of collision file
---                             	        hotuID		=	int; model ID of object in Horizon of the Universe v2.0 mod
--> txd_loaded_list         	table containing list of currently active/loaded texture files
---                         	contains: { T1, T2, T3, ..., TN }
---                         	where TN is table containing: { TXDElement, TXDName }
---                             	where   TXDElement  =   reference; loaded TXD
---                             	        TXDName     =   string, name of txd file
--> loaded_models_list      	table containing list of currently loaded model files
---                         	contains: { object1, object2, ..., objectN }
---                         	where objectN is reference; object element that has loaded custom model
--> planet_models_loaded    	are all models for current occupied planet loaded?
--> timer_stargate_models		timer; checking periodically for low GPU virtual memory
--> timer_stargate_models:VMTotalWarning	boolean value - has been user notified at start, that he has potato pc?
--> timer_stargate_models:VMFreeWarning		int; has been user notified of low VM memory? 0 - 9 -> no; 10 -> yes 
--> timer_stargate_models_vm_protection		timer; periodical check for very low (or dangerously filled; 99.9% full) GPU memory and frees textures/models from VM when client crash may happen 

---
--- PLAYER ATTRIBUTE Functions
---

function models_setElementModelAttribute(element, modelDescription)
	setElementData(element, "element_model_data", modelDescription)
end

function models_getElementModelAttribute(element)
	return getElementData(element, "element_model_data")
end


-- Retreives object model ID by given object (model) name
--- REQUIRED PARAMETERS:
--> playerElement		reference		player element; local player where models_data table is saved
--> objectName			string			DFF file name of the object
--- RETURNS:
--> Int; object model ID or nil if object name not found in table
function models_getObjectID(playerElement, objectName)
	local model_data = getElementData(playerElement, "models_data")
	local tn_objectID = nil
	local tn_objectName = nil
	local tn_hotuID = nil
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		tn_hotuID = tn[3]
		if tn_objectName == objectName then
			return tn_objectID
		end
	end
	return nil
end

-- Gets unloaded object ID
-- Note: may not be needed here?
--- REQUIRED PARAMETERS:
--> playerElement		reference	player
--> objectName			string		DFF file name of object model
--- RETURNS:
--> Int; Model ID of object or nil if not found
function models_getUnloadedObjectID(playerElement, objectName)
	local model_delayed = getElementData(playerElement, "models_delayed_load")
	for i,tn in ipairs(model_delayed) do
		if tn[4] == objectName then
			return tn[5]
		end
	end	-- Table structure: { dffPath, txdPath, colPath, dffFileName, hotuID, size }
	return nil
end

-- Gets objects HOTU ID
--- REQUIRED PARAMETERS:
--> playerElement		reference		player element; local player where models_data table is saved
--> objectName			string			DFF file name of the object
--- RETURNS:
--> Int; object model ID that was used in HOTU mod; or nil if object name not found in table
function models_getObjectHOTUID(playerElement, objectName)
	local model_data = getElementData(playerElement, "models_data")
	local tn_objectID = nil
	local tn_objectName = nil
	local tn_hotuID = nil
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		tn_hotuID = tn[3]
		if tn_objectName == objectName then
			return tn_hotuID
		end
	end
	return nil
end

-- 
-- TO BE REMOVED
function setElementModelClient(element, modelID)
	setElementModel(element, modelID)
end
addEvent("setElementModelClient", true)
addEventHandler("setElementModelClient", resourceRoot, setElementModelClient)