
--- generates one line of MTA SA .map file object as string
--- REQUIRED PARAMETERS:
--> objectID        ID of object (string)
--> objectModel     model ID of object (int/string)
--> x, y, z         position of object (int/string)
--> dimension       object dimension   (int/string)
--> dffFileName     name of objects DFF (string)

--- OPTIONAL PARAMETERS:
--> rx, ry, rz      object rotation     (int/string); default 0
--> interior        object interior     (int/string); default 0
--> scale           scale of object     (int/string); default 1
--> doublesided     is object doublesided? (boolean/string); default false
--> collisions      has object collisions enabled?  (boolean/string);   default true

--- RETURNS:
--> one line (as a string value) that is compatible with MTA:SA .map file format 
--- Note: line is generated with newline character
function map_generateMapFileLine(objectID, objectModel, x, y, z, dimension, dffFileName, rx, ry, rz, interior, scale, doublesided, collisions)
    local line_begin = "\t<object "
    local line_propEnd = "\" "
    local line_hotuobject= "hotu_object=\"true\" "
    local line_hotuid = "hotu_id=\""..tostring(objectID).."\" "
    local line_id = "id=\""
    local line_idValue = ""
    local line_interior = "interior=\""
    local line_interiorValue = ""
    local line_alpha = "alpha=\""
    local line_alphaValue = ""
    local line_dimension = "dimension=\""
    local line_dimensionValue = ""
    local line_model = "model=\""
    local line_modelValue = ""
    local line_scale = "scale=\""
    local line_scaleValue = ""
    local line_doublesided = "doublesided=\""
    local line_doublesidedValue = ""
    local line_collisions = "collisions=\""
    local line_collisionsValue = ""
    local line_posX = "posX=\""
    local line_posXValue = ""
    local line_posY = "posY=\""
    local line_posYValue = ""
    local line_posZ = "posZ=\""
    local line_posZValue = ""
    local line_rotX = "rotX=\""
    local line_rotXValue = ""
    local line_rotY = "rotY=\""
    local line_rotYValue = ""
    local line_rotZ = "rotZ=\""
    local line_rotZValue = ""
    local line_dffFileName = "element_model_data=\""
    local line_dffFileNameValue = ""
    local line_end = "></object>\n"
    local line = ""
    if not rx then
        rx = 0
    end
    if not ry then
        ry = 0
    end
    if not rz then
        rz = 0
    end
    if not interior then
        interior = 0
    end
    if not scale then
        scale = 1
    end
    if not doublesided then
        doublesided = false
    end
    if not collisions then
        collisions = true
    end
    line_idValue = "HOTU["..tostring(objectID).."]"..dffFileName
    line_modelValue = tostring(objectModel)
    line_posXValue = tostring(x)
    line_posYValue = tostring(y)
    line_posZValue = tostring(z)
    line_dimensionValue = tostring(dimension)
    line_rotXValue = tostring(rx)
    line_rotYValue = tostring(ry)
    line_rotZValue = tostring(rz)
    line_interiorValue = tostring(interior)
    line_scaleValue = tostring(scale)
    line_doublesidedValue = tostring(doublesided)
    line_collisionsValue = tostring(collisions)
    line_dffFileNameValue = tostring(dffFileName)

    line = line .. line_begin .. line_id .. line_idValue .. line_propEnd .. line_model .. line_modelValue .. line_propEnd 
    line = line .. line_posX .. line_posXValue .. line_propEnd .. line_posY .. line_posYValue .. line_propEnd .. line_posZ .. line_posZValue .. line_propEnd
    line = line .. line_dimension .. line_dimensionValue .. line_propEnd
    line = line .. line_rotX .. line_rotXValue .. line_propEnd .. line_rotY .. line_rotYValue .. line_propEnd .. line_rotZ .. line_rotZValue .. line_propEnd
    line = line .. line_interior .. line_interiorValue .. line_propEnd .. line_scale .. line_scaleValue .. line_propEnd
    line = line .. line_doublesided .. line_doublesidedValue .. line_propEnd .. line_collisions .. line_collisionsValue .. line_propEnd
    line = line .. line_dffFileName ..line_dffFileNameValue .. line_propEnd .. line_hotuid .. line_hotuobject .. line_end

    return line
end

function map_generateMapFileBeginning()
    local line = "<map>\n"
    return line
end

function map_generateMapFileEnd()
    local line = "</map>\n"
    return line
end

--- generates map file and outputs into this resource root directory at client-sde

--- REQUIRED PAREMETERS:
--> objectsArray
--- array/table containing tables TN with these values:
----> TN = { objectID, objectModel, x, y, z, dimension, dffFileName, rx, ry, rz, interior, scale, doublesided, collisions }
---- Note: see map_generateMapFileLine(...)
---- Note: parameters after dimension are optional

--- RETURNS:
--> true if file generated or false (with debugString text) if not
function map_generateMapFile(objectsArray, outputFileName)
    local content = map_generateMapFileBeginning()
    local line = ""
    for i,object in ipairs(objectsArray) do
        line = map_generateMapFileLine(object[1], object[2], object[3], object[4], object[5], object[6], object[7], object[8], object[9], object[10], object[11], object[12], object[13], object[14])
        content = content .. line
    end
    content = content .. map_generateMapFileEnd()
    local file = fileCreate("files/"..outputFileName..".map")
    if not file then
        outputDebugString("[MAP|C] Unable to create output file.", 1)
        return false
    end

    local r = fileWrite(file, content)
    if not r then
        outputDebugString("[MAP|C] Unable to write into output file.", 1)
        return false
    end

    fileClose(file)
    outputDebugString("[MAP|C] Generated map file! Output is on server-side 'stargate_map/files/"..tostring(outputFileName)..".map'")
    return true
end

function map_generateObjectsArrayTable(objectID, objectModel, x, y, z, dimension, rx, ry, rz, interior, scale, doublesided, collisions)
    local TN = { objectID, objectModel, x, y, z, dimension, rx, ry, rz, interior, scale, doublesided, collisions }
    return TN
end

function map_createHOTUObjects()
    local localPlayer = getElementByID("1")
    local stargate_ipl = fileOpen("files/stargate.IPL")
    if not stargate_ipl then
        outputDebugString("[MAP|C] Unable to open stargate.IPL file!", 1)
        return false
    end
    local stargate_ipl_content = fileRead(stargate_ipl, fileGetSize(stargate_ipl))
    if not stargate_ipl_content then
        outputDebugString("[MAP|C] Unable to read from stargate.IPL file!", 1)
        return false
    end
    fileClose(stargate_ipl)

    local stargate_ipl_lines = split(stargate_ipl_content, "\r\n")
    local line_split = nil
    local hotuID = ""
    local dffFileName = ""
    local interior = ""
    local posX, posY, posZ = ""
    local rotX, rotY, rotZ = ""
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
    outputDebugString("[MAP|C] Beggining of creating HOTU map.")
    local maplines = map_generateMapFileBeginning()

    for i,line in ipairs(stargate_ipl_lines) do
        line_split = split(line, ", ")
        hotuID = line_split[1]
        dffFileName = line_split[2]
        interior = line_split[3]
        posX = line_split[4]
        posY = line_split[5]
        posZ = line_split[6]
        rotX = line_split[7]
        rotY = line_split[8]
        rotZ = line_split[9]

        -- generating map
        --TN = { hotuID, 1337, posX, posY, posZ, 6969, dffFileName, rotX, rotY, rotZ, interior }
        --objectsArray = array_push(objectsArray, TN)

        -- creating objects
        --outputDebugString("[MAP|C] Created object '"..tostring(dffFileName).."' ("..posX..","..posY..","..posZ..").")
        --object = createObject(1337, tonumber(posX), tonumber(posY), tonumber(posZ))
        --setElementRotation(object, tonumber(rotX), tonumber(rotY), tonumber(rotZ))
        --setElementData(object, "hotu_object", true)
        --setElementData(object, "hotu_id", tonumber(hotuID))
        --setElementID(object, "HOTU["..tostring(hotuID).."]"..tostring(dffFileName))
        --setElementData(object, "element_model_data", dffFileName)
        cnt_p = cnt_p + 1
    end
    
    --map_generateMapFile(objectsArray, "stargate_random")
    --outputDebugString("[MAP|C] HOTU map created. Created objects: "..tostring(cnt_p)..".")
    return true
    -- load stargate.IPL file 
    -- IPL file line === HOTUID, dffName, ?, x, y, z, rx, ry, rz, ?, ?
    -- loop per line
    -- createObject
    -- elementData: element_object_type     =   "hotu_object"
    -- elementData: element_model_data      =   dffName (IPL/second thing; MUST BE same as stargate.IDE dffName in models script)
    -- elementData: element_hotuid          =   HOTUID  (IPL/first thing)
    -- elementData: element_ipl_data        =   table {x,y,z,rx,ry,rz}  (IPL)
    -- maybe: setElementPlanet?
end
addEventHandler("onResourceStart", resourceRoot, map_createHOTUObjects)

function map_placeHOTUObjects()
    -- loop at all object elements
    -- if element is hotu_object and has ipl data
    -- setElementPosition
    -- [!] models are set in models_c
end

function map_teleportToElementByID(src, cmd, id, range)
    local e = getElementByID(id)
    if not e then
        outputChatBox("Wrong element ID!")
        return false
    end
    local x,y,z = getElementPosition(e)
    setElementPosition(src, x,y,z+2)
end
addCommandHandler("poselement", map_teleportToElementByID)

function map_getHOTUObjectsNearPlayer(e, cmd, s_range)
    local range = tonumber(s_range)
    local x,y,z = getElementPosition(e)
    local cnt = 0
    local ox,oy,oz = nil

    local objectsArray = {}
    local TN = {}
    for i,object in ipairs(getElementsByType("object")) do
        if getElementData(object, "hotu_object") == true or getElementData(object, "hotu_object") == "true" then
            ox,oy,oz = getElementPosition(object)
            if math.abs(x - ox) < range and math.abs(y - oy) < range and math.abs(z - oz) < range then
                local hotuID = getElementData(object, "hotu_id")
                local posX, posY, posZ = getElementPosition(object)
                local rotX, rotY, rotZ = getElementRotation(object)
                local interior = getElementInterior(object)
                local dffFileName = getElementData(object, "element_model_data")
                TN = { hotuID, 1337, posX, posY, posZ, 1, dffFileName, rotX, rotY, rotZ, interior }
                objectsArray = array_push(objectsArray, TN)
                cnt = cnt + 1
            end
        end
    end
    map_generateMapFile(objectsArray, "output")
    outputDebugString("[MODELS|C] Found "..tostring(cnt).." objects in "..tostring(range).." range of 'Player ID ("..tostring(getElementID(e))..")'. File generated!")
end
addCommandHandler("generate", map_getHOTUObjectsNearPlayer)