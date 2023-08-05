-- exports_s.lua_ Functions used across gate_* resources in server-side

function createGlobalElement()
    GLOBAL_ELEMENT = createElement("stargate_root", "stargate_root_element")
end
addEventHandler("onResourceStart", resourceRoot, createGlobalElement)

-- active wait function
function wait(time)
    current = getTickCount()
    final = current + time
    while current < final do current = getTickCount() end
end

function import_variable(import, destination)
    if destination then
        destination = import
    end
    return import
end

---
---
--- stargate_models
---
---

function models_setElementModelAttribute(element, modelDescription)
	setElementData(element, "element_model_data", modelDescription)
end

function models_getElementModelAttribute(element)
	return getElementData(element, "element_model_data")
end

---
---
--- Array functions
--- 
---

function array_equal(array1, array2)
    return (table.concat(array1) == table.concat(array2))
end

function array_get(array, index, resourceStop)
    if resourceStop then
        return nil
    end
    if index >= 1 and index <= array_size(array) then
        return array[index]
    else
        outputDebugString("[ARRAY_GET] Accessing value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array).."."),2)
    end
    return nil
end

function array_set(array, index, value)
    if index >= 1 and index <= array_size(array) then
        array[index] = value
        return true
    else
        outputDebugString("[ARRAY_SET] Modifying value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array).."."), 2)
    return false
    end
end

function array_clear(array)
    array = {}
    return (array)
end

function array_new()
    local newArray = {}
    return newArray
end

function array_size(array)
    if array == nil or array == false then
        return 0
    end
    return (table.getn(array))
end

function array_pop(array)
    table.remove(array)
    return array
end

function array_remove(array, index)
    if array == nil or array == false then
        return nil
    end
    table.remove(array, index)
    return array
end

function array_contains(array, value)
    for i,f_value in pairs(array) do
        if f_value == value then
            return i
        end
    end
    return nil
end

function array_push(array, value)
    if array == nil or array == {} then
        array = {}
        table.insert(array, 1, value)
    else
        table.insert(array, value)
    end
    return array
end

---
---
---  GLOBAL ELEMENT

function global_getElement()
    local e = getElementByID("stargate_root_element")
    if (getElementType(e) == "stargate_root") then
        return e
    end

    outputDebugString("[GATE_EXPORTS] FATAL ERROR: Global element returned NIL VALUE!",1)
    return nil
end

function global_addData(key, value)
    return (setElementData(global_getElement(), key, value))
end

function global_getData(key)
    return (getElementData(global_getElement(), key))
end

function global_setData(key, value)
    return (global_addData(key, value))
end

function global_removeData(key)
    return (global_setData(key, nil))
end