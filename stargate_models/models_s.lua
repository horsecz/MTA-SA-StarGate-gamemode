--- models_s.lua: Model and texture loading module

function models_getObjectID(playerElement, objectName)
	local model_data = getElementData(playerElement, "models_data")
	local tn_objectID = nil
	local tn_objectName = nil
	for i,tn in ipairs(model_data) do
		tn_objectID = tn[1]
		tn_objectName = tn[2]
		if tn_objectName == objectName then
			return tn_objectID
		end
	end
	return nil
end

function models_setElementModelAttribute(element, modelDescription)
	setElementData(element, "element_model_data", modelDescription)
end

function models_getElementModelAttribute(element)
	return getElementData(element, "element_model_data")
end