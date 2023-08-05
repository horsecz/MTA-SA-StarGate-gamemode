
function map_createHOTUObjects()
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

function map_placeHOTUObjects()
    -- loop at all object elements
    -- if element is hotu_object and has ipl data
    -- setElementPosition
    -- [!] models are set in models_c
end