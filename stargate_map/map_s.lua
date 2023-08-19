-- map_s.lua: Main module for stargate maps; server-side

-- Actions that will be performed on this resource start
function map_onStart()
    r1 = map_createHOTUObjects("files/stargate.IPL")
    if r1 == true then
        r2 = map_createHOTUObjects("files/stargate_2.IPL")
        if r2 == true then
            r3 = map_createHOTUObjects("files/stargate_3.IPL")
            if r3 == true then
                r4 = map_createHOTUObjects("files/stargate_4.IPL")
            end
        end
    end
    if not r1 or not r2 or not r3 or not r4 then
        outputDebugString("Very bad thing happened in MAP_C.lua")
    end
end
addEventHandler("onResourceStart", resourceRoot, map_onStart)

-- Created custom objects from Stargate:Horizon of the universe 
-- > objects are generated from single source IPL file
-- > quaternion to euler rotation conversion is done
-- > all objects are elements of type object with ID: 'HOTU[<HOTU_ID>]<HOTU_MODE_NAME>' and custom attributes:
--      > hotu_object           true (for distinguishing between any other object and HOTU generated object)
--      > hotu_id               object model ID used in HOTU mod (read from IPL file)
--      > element_model_data    model file name (read from IPL file)
--- REQUIRED PARAMETERS:
--> file    string      modified IPL file path, that will be processed
--- RETURNS:
--> Bool; true if objects created, false if not
function map_createHOTUObjects(file)
    local localPlayer = getElementByID("1")
    local stargate_ipl = fileOpen(file)
    if not stargate_ipl then
        outputDebugString("[MAP|C] Unable to open file!", 1)
        return false
    end
    local stargate_ipl_content = fileRead(stargate_ipl, fileGetSize(stargate_ipl))
    if not stargate_ipl_content then
        outputDebugString("[MAP|C] Unable to read from file!", 1)
        return false
    end
    fileClose(stargate_ipl)

    local stargate_ipl_lines = split(stargate_ipl_content, "\r\n")
    local line_split = nil
    local hotuID = ""
    local dffFileName = ""
    local interior = ""
    local posX, posY, posZ = ""
    local qrX, qrY, qrZ, qrW = ""
    local rotX, rotY, rotZ = nil
    local modelID = 0
    local dimension = 0
    local TN = {}
    local objectsArray = {}
    local objectsArrayCust = {}
    local objectsArrayDef = {}
    local customLinesUnloaded = ""
    local customLinesLoaded = ""
    local customLines = ""
    local object = nil
    
    local cnt_def = 0
    local cnt_un = 0
    local cnt_p = 0
    outputDebugString("[MAP|C] Beggining of creating HOTU map from "..tostring(file))
    local maplines = map_generateMapFileBeginning()

    for i,line in ipairs(stargate_ipl_lines) do
        line_split = split(line, ", ")
        hotuID = line_split[1]
        dffFileName = line_split[2]
        interior = line_split[3]
        posX = line_split[4]
        posY = line_split[5]
        posZ = line_split[6]
        qrX = line_split[7]
        qrY = line_split[8]
        qrZ = line_split[9]
        qrW = line_split[10]
        rotX, rotY, rotZ = fromQuaternion(tonumber(qrX), tonumber(qrY), tonumber(qrZ), tonumber(qrW))

        -- generating map file
        --TN = { hotuID, 1337, posX, posY, posZ, 6969, dffFileName, rotX, rotY, rotZ, interior }
        --objectsArray = array_push(objectsArray, TN)

        -- creating objects in world
        outputDebugString("[MAP|C] Created object '"..tostring(dffFileName).."' ("..posX..","..posY..","..posZ..").")
        object = createObject(1337, tonumber(posX), tonumber(posY), tonumber(posZ))
        setElementDimension(object, 6969)
        setElementRotation(object, tonumber(rotX), tonumber(rotY), tonumber(rotZ))
        setElementData(object, "hotu_object", true)
        setElementData(object, "hotu_id", tonumber(hotuID))
        setElementID(object, "HOTU["..tostring(hotuID).."]"..tostring(dffFileName))
        setElementData(object, "element_model_data", dffFileName)
        setElementData(object, "element_model_loaded", false)
        cnt_p = cnt_p + 1
    end
    
    --map_generateMapFile(objectsArray, "stargate_random")  -- generating map file
    outputDebugString("[MAP|C] HOTU map from file "..tostring(file).." created. Created objects: "..tostring(cnt_p)..".")
    return true
end

