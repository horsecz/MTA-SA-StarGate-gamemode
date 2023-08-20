-- exports.lua: Functions used across gate_* resources; shared

-- Active wait function
--> time    int     time in ms which script will actively wait
-- Note: MTA:SA currently does not like long active waiting and considers them as infinite loops (not recommended to use at all)
function wait(time)
    current = getTickCount()
    final = current + time
    while current < final do current = getTickCount() end
end

-- Import exported variable
-- REQUIRED PARAMETERS:
--> import          variable type   variable to be imported
--> destination     variable type   source destination

-- RETURNS:
--> Variable type; exported variable
function import_variable(import, destination)
    if destination then
        destination = import
    end
    return import
end

---
--- STARGATE Models
---

-- TODO; dont be here pls
function models_setElementModelAttribute(element, modelDescription)
	setElementData(element, "element_model_data", modelDescription)
end

-- TODO; dont be here pls
function models_getElementModelAttribute(element)
	return getElementData(element, "element_model_data")
end

---
--- ARRAY/TABLE Functions
--- 

-- Compares two arrays if they are equal
--- REQUIRED PARAMETERS:
--> array1     reference    first array
--> array2     reference    second array

--- RETURNS:
--> Boolean; true if arrays are equal, false if not
function array_equal(array1, array2)
    return (table.concat(array1) == table.concat(array2))
end

-- Gets value from array at specified index
--- REQUIRED PARAMETERS:
--> array   reference   source array
--> index   int         index in array

--- OPTIONAL PARAMETERS:
--> resourceStop    bool    is resource being stopped? (internal use only); default: nil

--- RETURNS:
--> Variable type; value of array at given index or nil if index is out of range of array (or nil if resource is being stopped)
function array_get(array, index, resourceStop)
    if resourceStop then
        return nil
    end
    if index >= 1 and index <= array_size(array) then
        return array[index]
    else
        outputDebugString("[STARGATE:EXPORTS] array_get: Accessing value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array).."."),2)
    end
    return nil
end

-- Set value at specified index in array
--- REQUIRED PARAMETERS:
--> array   reference       source array
--> index   int             index in array
--> value   variable type   value to be set

--- RETURNS:
--> Boolean; true if success, false if index out of range
function array_set(array, index, value)
    if index >= 1 and index <= array_size(array) then
        array[index] = value
        return true
    else
        outputDebugString("[STARGATE:EXPORTS] array_set: Modifying value at index "..tostring(index).." in array "..tostring(array).." of size "..tostring(array_size(array).."."), 2)
    return false
    end
end

-- Removes all content of array
--- REQUIRED PARAMETERS:
--> array   reference   source array

--- RETURNS:
--> Reference; empty array
function array_clear(array)
    array = {}
    return (array)
end

-- Initializes new empty array
--- RETURNS:
--> Reference; new empty array
function array_new()
    local newArray = {}
    return (newArray)
end

-- Gets size of array
--- REQUIRED PARAMETERS:
--> array   reference   source array
--- RETURNS:
--> Int; size of array (number of elements)
function array_size(array)
    if array == nil or array == false then
        return 0
    end
    return (table.getn(array))
end

-- Removes last element from array
--- REQUIRED PARAMETERS:
--> array   reference   source array
--- RETURNS:
--> Reference; modified array without last element
function array_pop(array)
    table.remove(array)
    return (array)
end

-- Removes element from array at given index
--- REQUIRED PARAMETERS:
--> array   reference source array
--> index   int     index of element to be removed
--- RETURNS:
--> Reference; modified array or nil if source array is invalid
function array_remove(array, index)
    if array == nil or array == false then
        return nil
    end
    table.remove(array, index)
    return (array)
end

-- Checks if array contains given value
--- REQUIRED PARAMETERS:
--> array   reference       source array
--> value   variable type   value
--- RETURNS:
--> Int; index of element in array (if value exists in array) or nil if does not 
function array_contains(array, value)
    for i,f_value in pairs(array) do
        if f_value == value then
            return i
        end
    end
    return nil
end

-- Inserts value at the end of the array
--- REQUIRED PARAMETERS:
--> array   reference       source array
--> value   variable type   value
--- RETURNS:
--> Reference; modified array
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
--- GLOBAL ELEMENT Functions
---  

-- Creates global element
function createGlobalElement()
    GLOBAL_ELEMENT = createElement("stargate_root", "stargate_root_element")
end
addEventHandler("onResourceStart", resourceRoot, createGlobalElement)

-- Gets global element
--- RETURNS:
--> Reference;  global element or nil if not found
function global_getElement()
    local e = getElementByID("stargate_root_element")
    if (getElementType(e) == "stargate_root") then
        return e
    end

    outputDebugString("[STARGATE:EXPORTS] global_getElement: Global element returned NIL VALUE!", 3)
    return nil
end

-- Adds data to global element
--- REQUIRED PARAMETERS:
--> key     string          key identifier of added data
--> value   variable type   data value to be added
--- RETURNS:
--> Boolean; true if data added successfully, false otherwise
function global_addData(key, value)
    return (setElementData(global_getElement(), key, value))
end

-- See global_addData(...)
function global_setData(key, value)
    return (global_addData(key, value))
end


-- Gets data from global element
--- REQUIRED PARAMETERS:
--> key     string          key identifier of data
--- RETURNS:
--> Variable type; data value from global element or false if data does not exist
function global_getData(key)
    return (getElementData(global_getElement(), key))
end

-- Removes data from global element (sets key value to nil)
--- REQUIRED PARAMETERS:
--> key     string          key identifier of data
--- RETURNS:
--> Boolean; true if data removed or false
function global_removeData(key)
    return (global_setData(key, nil))
end