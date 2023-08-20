-- galaxy_s.lua: Module for working with stargate galaxy attribute; shared

--- Galaxy attributes
--> galaxy          stargate galaxy; see enum_stargateGalaxy
--> gateCount       count of stargates in stargate's galaxy
--> allElements     returns all existing stargates in stargate's galaxy (in form of array or nil if none)


function stargate_galaxy_getGateCount(id)
    if stargate_galaxy_get(id) == "milkyway"then
        return (array_size(SG_MW))
    end
end

function stargate_galaxy_set(id, galaxy)
    setElementData(stargate_getElement(id), "galaxy", galaxy)
    spawner_gateList_add(stargate_getElement(id))
end

function stargate_galaxy_get(id)
    return (getElementData(stargate_getElement(id), "galaxy"))
end

function stargate_galaxy_getAllElements(id)
    if stargate_galaxy_get(id) == "milkyway" then
        return (global_getData("SG_MW"))
    end
    return nil
end