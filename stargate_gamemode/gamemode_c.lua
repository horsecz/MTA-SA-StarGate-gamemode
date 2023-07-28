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