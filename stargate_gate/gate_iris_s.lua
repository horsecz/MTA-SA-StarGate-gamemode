-- iris_s.lua_ Iris module

function stargate_iris_create(stargateID, frame)
    local x, y, z = stargate_getPosition(stargateID)
    local iris = createObject(1337, x, y, z)
    models_setElementModelAttribute(iris, "iris"..tostring(frame))
    setElementCollisionsEnabled(iris, false)
    setElementID(iris, stargateID.."I"..tostring(frame))
    setElementAlpha(iris, 0)
    setElementData(stargate_getElement(stargateID), "irisActive", false)
    local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateID))
    planet_setElementOccupiedPlanet(iris, planet)
    attachElements(iris, getElementByID(stargateID))
    setElementAttachedOffsets(iris, 0, 0.025, 0)
    return iris
end

function stargate_iris_setAutoClose(stargateID, autoclose)
    if autoclose == true then
        local t = setTimer(stargate_iris_autoclose, 50, 0, stargateID)
        if isTimer(getElementData(stargate_getElement(stargateID), "timer_irisAutoclose")) then
            killTimer(getElementData(stargate_getElement(stargateID), "timer_irisAutoclose"))
        end
        setElementData(stargate_getElement(stargateID), "timer_irisAutoclose", t)
    else
        killTimer(getElementData(stargate_getElement(stargateID), "timer_irisAutoclose"))
        setElementData(stargate_getElement(stargateID), "timer_irisAutoclose", nil)
    end
end

function stargate_iris_autoclose(stargateID)
    local incoming = stargate_getIncomingStatus(stargateID)
    local iris = stargate_iris_isActive(stargateID)
    local irisWorking = getElementData(stargate_getElement(stargateID), "irisIsToggling")

    if incoming == true then
        if iris == false and ( irisWorking == false or irisWorking == nil ) then
            stargate_iris_toggle(stargateID)
        end
    else
        if iris == true and ( irisWorking == false or irisWorking == nil ) then
            stargate_iris_toggle(stargateID)
        end
    end
end

function stargate_iris_toggle(stargateID)
    local irisStatus = stargate_iris_isActive(stargateID)
    if irisStatus == true then
        stargate_iris_setActive(stargateID, false)
    else
        stargate_iris_setActive(stargateID, true)
    end
end

function stargate_iris_setActive(stargateID, active)
    local iris = nil
    local t = GATE_IRIS_ACTIVATION_SPEED
    local v_status = getElementData(stargate_getElement(stargateID), "vortexIsOpening")
    local i_status = getElementData(stargate_getElement(stargateID), "irisIsToggling")
    if v_status == true then
        return false
    end
    if i_status == true then
        return false
    end
    setElementData(stargate_getElement(stargateID), "irisIsToggling", true)
    setElementData(getElementByID(stargateID), "irisActive", active)

    if active == true then
        stargate_sound_play(stargateID, enum_soundDescription.GATE_MW_IRIS_CLOSE)
        for i=1,10 do
            setTimer(function(stargateID, i) 
                local iris = getElementByID(stargateID.."I"..tostring(i))
                local iris2 = getElementByID(stargateID.."I"..tostring(i-1))
                setElementAlpha(iris, 255)
                if i > 1 then
                    setTimer(setElementAlpha, GATE_IRIS_ACTIVATION_SPEED, 1, iris2, 0)
                end
            end, t, 1, stargateID, i)

            t = t + GATE_IRIS_ACTIVATION_SPEED
            if i > 1 and i < 4 then
                t = t + GATE_IRIS_ACTIVATION_SPEED*4
            end
            if i > 8 then
                t = t + GATE_IRIS_ACTIVATION_SPEED*4
            end
        end
    else
        stargate_sound_play(stargateID, enum_soundDescription.GATE_MW_IRIS_OPEN)
        for i=10,0,-1 do
            setTimer(function(stargateID, i) 
                local iris = getElementByID(stargateID.."I"..tostring(i))
                local iris2 = getElementByID(stargateID.."I"..tostring(i+1))
                if i > 1 then
                    setElementAlpha(iris, 255)
                end
                if i < 10 then
                    setTimer(setElementAlpha, GATE_IRIS_ACTIVATION_SPEED, 1, iris2, 0)
                end
            end, t, 1, stargateID, i)

            t = t + GATE_IRIS_ACTIVATION_SPEED
            if i < 3 then
                t = t + GATE_IRIS_ACTIVATION_SPEED*4
            end
            if i > 7 and i < 10 then
                t = t + GATE_IRIS_ACTIVATION_SPEED*4
            end
        end
    end
    iris = getElementByID(stargateID.."I"..tostring(10))
    if stargate_isOpen(stargateID) then
        local marker = nil
        if active == true then
            marker = false
        else
            marker = true
        end
        setTimer(stargate_marker_setHidden, t/2, 1, stargateID, enum_markerType.EVENTHORIZON, marker)
    end
    setTimer(setElementData, t, 1, stargate_getElement(stargateID), "irisIsToggling", false)
    setTimer(setElementCollisionsEnabled, t/2, 1, iris, active)
    return t
end

function stargate_iris_isActive(stargateID)
    return (getElementData(stargate_getElement(stargateID), "irisActive"))
end
