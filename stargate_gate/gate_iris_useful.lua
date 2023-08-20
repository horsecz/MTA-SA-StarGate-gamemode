-- iris_useful.lua: Useful functions when working with stargate iris module; shared

--- Iris element attributes
--> irisActive      is iris currently active (open) or inactive (closed)


function stargate_iris_isActive(stargateID)
    return (getElementData(stargate_getElement(stargateID), "irisActive"))
end
