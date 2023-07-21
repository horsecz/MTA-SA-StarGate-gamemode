-- exports_s.lua_ Functions used across gate_* resources in server-side

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
    return (table.getn(array))
end

function array_pop(array)
    return (table.remove(array))
end

function array_push(array, value)
    local sOld = array_size(array)
    table.insert(array, value)
    return array
end