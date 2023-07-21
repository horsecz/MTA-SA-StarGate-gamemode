-- galaxy_s.lua_ Galaxy module

-- gets count of all stargates in gate's galaxy
function stargate_galaxy_getGateCount(id)
    if stargate_galaxy_get(id) == "milkyway"then
        return (array_size(SG_MW))
    end
end

function stargate_galaxy_set(id, galaxy)
    setElementData(stargate_getElement(id), "galaxy", galaxy)
    if galaxy == "milkyway" then
        if SG_MW == nil then
            SG_MW = array_new()
        end
        SG_MW = array_push(SG_MW, stargate_getElement(id))
    end
end

function stargate_galaxy_get(id)
    return (getElementData(stargate_getElement(id), "galaxy"))
end

-- returns all existing gates in current gate's galaxy in form of array-list of IDs
function stargate_galaxy_getAllElements(id)
    if stargate_galaxy_get(id) == "milkyway" then
        return SG_MW
    end
    return nil
end