-- useful.lua: Useful functions when working with stargate map resource; shared

---
--- DEVELOPMENT Functions
---

--- Generates valid MTA:SA map file and outputs it into this resource root directory at client-side
--- REQUIRED PAREMETERS:
--> objectsArray		reference		array containing tables TN with these values:
--										TN = { objectID, objectModel, x, y, z, dimension, dffFileName, rx, ry, rz, interior, scale, doublesided, collisions }
--> outputFileName		string			name of the output file
--- RETURNS:
--> Bool; true if file generated or false if not
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

-- Generates array that is useful for generating map files (respectively one line for it)

--- REQUIRED PARAMETERS:
--> objectID        string		ID of object
--> objectModel     int			model ID of object
--> x, y, z         int			position of object
--> dimension       int			object dimension 
--> dffFileName     string		name of objects DFF
--> rx, ry, rz      int			object rotation 
--> interior        int			object interior 
--> scale           int			scale of object     
--> doublesided     bool		is object doublesided?
--> collisions      bool		has object collisions enabled? 

--- RETURNS:
--> Reference; table containing elements for generating single line (object) of map file
function map_generateObjectsArrayTable(objectID, objectModel, x, y, z, dimension, rx, ry, rz, interior, scale, doublesided, collisions)
    local TN = { objectID, objectModel, x, y, z, dimension, rx, ry, rz, interior, scale, doublesided, collisions }
    return TN
end

--- Generates one line of MTA SA .map file object as string
--- REQUIRED PARAMETERS:
--> objectID        string		ID of object
--> objectModel     int			model ID of object
--> x, y, z         int			position of object
--> dimension       int			object dimension 
--> dffFileName     string		name of objects DFF

--- OPTIONAL PARAMETERS:
--> rx, ry, rz      int			object rotation 
--- default: 0
--> interior        int			object interior 
--	default: 0
--> scale           int			scale of object     
--	default: 1
--> doublesided     bool		is object doublesided?
--	default: false
--> collisions      bool		has object collisions enabled? 
-- 	default: true

--- RETURNS:
--> String; one line that is compatible with MTA:SA .map file format (generated with newline character)
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

-- Generate beginning of map file
--- RETURNS:
--> String; beginning of map file
function map_generateMapFileBeginning()
    local line = "<map>\n"
    return line
end

-- Generate end of map file
--- RETURNS:
--> String; end of map file
function map_generateMapFileEnd()
    local line = "</map>\n"
    return line
end

-- Command for teleporting player to element by given ID of the element
--- REQUIRED PARAMETERS:
--> Inherited from 'addCommandHandler' function for server-side
--> id		string		argument 1		-		ID of element to teleport to
function map_teleportToElementByID(src, cmd, id)
    local e = getElementByID(id)
    if not e then
        outputChatBox("Wrong element ID!")
        return false
    end
    local x,y,z = getElementPosition(e)
    setElementPosition(src, x,y,z+2)
end
addCommandHandler("poselement", map_teleportToElementByID)

-- Command for generating HOTU objects near player in given range (and the same dimension as players)
--- REQUIRED PARAMETERS:
--> Inherited from 'addCommandHandler' function for server-side
--> s_range			string		argument 1	-	range in which will be objects detected and generated

--- OPTIONAL PARAMETERS:
--> m_dimension		string		argument 2	-	dimension in which these objects will be generated (in map file)
--- default if not specififed:	0
function map_getHOTUObjectsNearPlayer(e, cmd, s_range, m_dimension)
    if not s_range then
        outputChatBox("Where range")
        return false
    end
    local range = tonumber(s_range)
    local x,y,z = getElementPosition(e)
    local cnt = 0
    local ox,oy,oz = nil

    local objectsArray = {}
    local TN = {}
    local dimension = nil
    if not m_dimension then
        dimension = 0
    else
        dimension = tonumber(m_dimension)
    end

    for i,object in ipairs(getElementsByType("object")) do
        if getElementData(object, "hotu_object") == true or getElementData(object, "hotu_object") == "true" then
            ox,oy,oz = getElementPosition(object)
            if math.abs(x - ox) < range and math.abs(y - oy) < range and math.abs(z - oz) < range then
                local hotuID = getElementData(object, "hotu_id")
                local posX, posY, posZ = getElementPosition(object)
                local rotX, rotY, rotZ = getElementRotation(object)
                local interior = getElementInterior(object)
                local dffFileName = getElementData(object, "element_model_data")
                TN = { hotuID, 1337, posX, posY, posZ, m_dimension, dffFileName, rotX, rotY, rotZ, interior }
                objectsArray = array_push(objectsArray, TN)
                cnt = cnt + 1
            end
        end
    end
    map_generateMapFile(objectsArray, "output")
    outputDebugString("[MODELS|C] Found "..tostring(cnt).." objects in "..tostring(range).." range of 'Player ID ("..tostring(getElementID(e))..")'. File generated! (dimension '"..tostring(dimension).."')")
end
addCommandHandler("generate", map_getHOTUObjectsNearPlayer)

---
--- OTHER Functions
---

----- Code from MTA:SA WIKI
----- Source: 
local identityMatrix = {
	[1] = {1, 0, 0},
	[2] = {0, 1, 0},
	[3] = {0, 0, 1}
}
 
----- Code from MTA:SA WIKI
----- Source: 
function QuaternionTo3x3(x,y,z,w)
	local matrix3x3 = {[1] = {}, [2] = {}, [3] = {}}
 
	local symetricalMatrix = {
		[1] = {(-(y*y)-(z*z)), x*y, x*z},
		[2] = {x*y, (-(x*x)-(z*z)), y*z},
		[3] = {x*z, y*z, (-(x*x)-(y*y))} 
	}

	local antiSymetricalMatrix = {
		[1] = {0, -z, y},
		[2] = {z, 0, -x},
		[3] = {-y, x, 0}
	}
 
	for i = 1, 3 do 
		for j = 1, 3 do
			matrix3x3[i][j] = identityMatrix[i][j]+(2*symetricalMatrix[i][j])+(2*w*antiSymetricalMatrix[i][j])
		end
	end
	
	return matrix3x3
end

----- Code from MTA:SA WIKI
----- Source: 
function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return math.deg(math.asin(z2)),-math.deg(math.atan2(vx,vz)),-math.deg(math.atan2(x2,y2))
end

----- Code from MTA:SA WIKI
----- Source: 
function fromQuaternion(x,y,z,w) 
	local matrix = QuaternionTo3x3(x,y,z,w)
	local ox,oy,oz = getEulerAnglesFromMatrix(
		matrix[1][1], matrix[1][2], matrix[1][3], 
		matrix[2][1], matrix[2][2], matrix[2][3],
		matrix[3][1], matrix[3][2], matrix[3][3]
	)

	return ox,oy,oz
end