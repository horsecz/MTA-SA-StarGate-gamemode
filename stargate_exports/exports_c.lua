-- exports_s.lua: Functions used across gate_* resources in client-side

---
---
--- Array functions
--- 
---

function array_equal(array1, array2)
    return (table.concat(array1) == table.concat(array2))
end

function array_get(array, index)
    if index >= 1 and index <= array_size(array) then
        return array[index]
    else
        outputDebugString("[ARRAY_GET] Accessing value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array)"."))
    end
    return nil
end

function array_set(array, index, value)
    if index >= 1 and index <= array_size(array) then
        array[index] = value
        return true
    else
        outputDebugString("[ARRAY_SET] Modifying value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array)"."))
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
    if array == nil then
        return 0
    end
    return (table.getn(array))
end

function array_pop(array)
    return (table.remove(array))
end

function array_remove(array, index)
    return (table.remove(array, index))
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

function global_getElement()
    local e = getElementByID("stargate_root_element")
    if (getElementType(e) == "stargate_root") then
        return e
    end
    return nil
end

function global_addData(key, value)
    return (setElementData(global_getElement(), key, value))
end

function global_getData(key)
    return (getElementData(global_getElement(), key))
end

function global_setData(key)
    return (global_addData(key, value))
end

function global_removeData(key)
    return (global_setData(key, nil))
end