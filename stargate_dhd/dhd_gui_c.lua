-- gui_c.lua: Module implementing DHD GUI; client-side

-- To be done:
--> Base DHD GUI
--          > merge with classicGUI function
--          > W: gridlist, window size / fast dial checkbox 


DHD_GUI_OPEN = false
DHD_GUI_ELEMENT = nil
DHD_GUI_LOCALONLY = false
DHD_GUI_FASTDIAL = false
DHD_GUI_ADDRESS_EDITBOX = nil
DHD_GUI_ADDRESS = nil
DHD_GUI_GRID_SELECTION = nil
DHD_GUI_GRIDLIST = nil

-- Opens DHD GUI
-- > does not open anything if GUI is already open
function dhd_openGUI()
    if DHD_GUI_OPEN == true then
        return false
    end
    DHD_GUI_OPEN = true
    DHD_GUI_ELEMENT = nil
    DHD_GUI_LOCALONLY = false
    DHD_GUI_FASTDIAL = false
    DHD_GUI_ADDRESS_EDITBOX = nil
    DHD_GUI_ADDRESS = nil
    DHD_GUI_GRID_SELECTION = nil
    DHD_GUI_GRIDLIST = nil

    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local type = dhd_getType(dhdID)
    dhd_classicGUI()
    showCursor(true)
end
addEvent("dhd_openGUI_client", true)
addEventHandler("dhd_openGUI_client", localPlayer, dhd_openGUI)

-- Closes DHD GUI
-- > won't do anything if no GUI is open
function dhd_closeGUI()
    if DHD_GUI_OPEN == false then
        return false
    end

    removeEventHandler("onClientGUIClick", Button_Shutdown, dhd_handleGUIShutdown)
    removeEventHandler("onClientGUIClick", Button_Dial, dhd_handleGUIDial)
    removeEventHandler("onClientGUIAccepted", EditTextBox_Address, dhd_handleGUIDial)
    removeEventHandler("onClientGUIChanged", EditTextBox_Address, dhd_handleGUIAddressChanged)
    removeEventHandler("onClientGUIClick", Checkbox_FastDial, dhd_handleGUIFastDialClicked)
    removeEventHandler("onClientGUIClick", GridList_AddressList, dhd_handleGUIAddressListClicked)
    removeEventHandler("onClientGUIDoubleClick", GridList_AddressList, dhd_handleGUIAddressListDoubleClicked)
    --removeEventHandler("onClientGUIClick", CheckBox_LocalOnly, dhd_handleGUILocalOnlyClicked)
    destroyElement(DHD_GUI_ELEMENT)
    DHD_GUI_ELEMENT = nil
    DHD_GUI_OPEN = false
    showCursor(false)
end
addEvent("dhd_closeGUI_client", true)
addEventHandler("dhd_closeGUI_client", localPlayer, dhd_closeGUI)

-- Refresh GUI Address grid list
function dhd_handleGUIRefreshAddressList()
    gridlist = DHD_GUI_GRIDLIST
    guiGridListClear(gridlist)
    guiGridListSetSelectionMode(gridlist, 0)

    guiGridListAddColumn(gridlist, "#", 0.1)
    guiGridListAddColumn(gridlist, "Planet name", 0.38)
    guiGridListAddColumn(gridlist, "Stargate address", 0.28)
    guiGridListAddColumn(gridlist, "Galaxy", 0.2)

    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAttachedStargate(dhdID)
    local localGalaxy = stargate_getGalaxy(sgID)
    local SG_MW = global_getData("SG_MW") -- "all" stargates list
    if SG_MW == false or SG_MW == nil then
        local rowID = guiGridListAddRow(gridlist)
        guiGridListSetItemText(gridlist, rowID, 1, " ", false, false)
        guiGridListSetItemText(gridlist, rowID, 2, "No stargates found", false, false)
        guiGridListSetItemText(gridlist, rowID, 3, " ", false, false)
        guiGridListSetItemText(gridlist, rowID, 4, " ", false, false)
        return false 
    end

    for i,sg in ipairs(SG_MW) do
        local rowID = guiGridListAddRow(gridlist)
        local sgID = stargate_getID(sg)
        local sg_addressTable = stargate_getAddress(sgID)
        local sg_planet = planet_getDimensionPlanet(getElementDimension(sg))
        local sg_planetID = planet_getPlanetID(sg_planet)

        local sg_address = ""
        for i,symbol in ipairs(sg_addressTable) do
            if i == 1 then
                sg_address = tostring(symbol)
            else
                sg_address = sg_address .. ", " .. tostring(symbol)
            end
        end
        if localGalaxy == stargate_getGalaxy(sgID) then
            sg_address = sg_address .. ", 39"
        else
            sg_address = sg_address .. ", " .. tostring(stargate_convertAddressSymbolToGalaxy(stargate_getGalaxy(sgID))) .. ", 39"
        end
        local planet_name = planet_getPlanetName(sg_planetID)
        local galaxy = planet_getPlanetGalaxyString(sg_planetID)
        if planet_name == nil or planet_name == false then
            planet_name = "?"
        end

        guiGridListSetItemText(gridlist, rowID, 1, tostring(i), false, false)
        guiGridListSetItemText(gridlist, rowID, 2, tostring(planet_name), false, false)
        guiGridListSetItemText(gridlist, rowID, 3, tostring(sg_address), false, false)
        guiGridListSetItemText(gridlist, rowID, 4, tostring(galaxy), false, false)
    end
end

-- Shutdown stargate after clicking Shutdown button
-- > abort dialling process
-- > shutdown stargate
-- > if wormhole is being opened or closed, do nothing
function dhd_handleGUIShutdown()
    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAttachedStargate(dhdID)
    local active = stargate_isActive(sgID)
    local open = stargate_isOpen(sgID)
    local inc = stargate_getIncomingStatus(sgID)
    if active == false and open == false then -- gate idle
        gui_showInfoWindow("DHD", "Stargate is already inactive!", 3000)
        dhd_closeGUI()
        return false
    end

    if active == true and open == false then -- gate dialling
        dhd_closeGUI()
        stargate_abortDial(sgID)
        return true
    end

    if active == true and open == true then -- gate is open
        if getElementData(getElementByID(sgID), "vortexIsOpening") == true then -- vortex activation, unable to close
            gui_showInfoWindow("DHD", "Unable to shut down stargate. Wormhole is being estabilished!", 3000)
            dhd_closeGUI()
            return false
        elseif getElementData(getElementByID(sgID), "horizonIsToggling") == true then -- horizon disengaging, gate closing
            gui_showInfoWindow("DHD", "Unable to shut down stargate. Gate is already shutting down!", 3000)
            dhd_closeGUI()
            return false
        else -- gate is normally open
            local sgIDTo = stargate_getConnectionID(sgID)
            stargate_wormhole_close(sgID, sgIDTo)
            dhd_closeGUI()
            return true
        end
    end
end

-- Dial stargate after clicking Dial button
-- > only when gate is inactive
function dhd_handleGUIDial()
    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAttachedStargate(dhdID)
    local active = stargate_isActive(sgID)
    local dialType = enum_stargateDialType.SLOW
    if active == true then
        gui_showInfoWindow("DHD", "Unable to start dialling process. Stargate is already active!", 3000)
        dhd_closeGUI()
        return false
    end
    if getElementData(getElementByID(sgID), "dial_failed") == true then
        gui_showInfoWindow("DHD", "Wait before proceeding with another action!", 3000)
        dhd_closeGUI()
        return false
    end
    if DHD_GUI_ADDRESS == nil or DHD_GUI_ADDRESS == false or DHD_GUI_ADDRESS == "" then
        gui_showInfoWindow("DHD", "Missing stargate address to dial!", 3000)
        dhd_closeGUI()
        return false
    end
    if DHD_GUI_FASTDIAL == true then
        dialType = enum_stargateDialType.FAST
    end

    local addressArray = {}
    local addressSeparated = split(DHD_GUI_ADDRESS, ",")
    if not addressSeparated then
        gui_showInfoWindow("DHD", "Invalid stargate address format!", 3000)
        dhd_closeGUI()
        return false
    end
    
    for i,sym in ipairs(addressSeparated) do
        addressArray = array_push(addressArray, tonumber(sym))
    end

    stargate_dial(sgID, addressArray, dialType, getLocalPlayer())
    dhd_closeGUI()
end

-- Change edited address
function dhd_handleGUIAddressChanged()
    DHD_GUI_ADDRESS = guiGetText(source)
end

-- Change fast dial mode
function dhd_handleGUIFastDialClicked()
    DHD_GUI_FASTDIAL = guiCheckBoxGetSelected(source)
end

-- Event after clicking row in address list -> set address
function dhd_handleGUIAddressListClicked()
    local row, column = guiGridListGetSelectedItem(DHD_GUI_GRIDLIST)
    local address = guiGridListGetItemText(DHD_GUI_GRIDLIST, row, 3)
    guiSetText(DHD_GUI_ADDRESS_EDITBOX, address)
end

-- Event after double-clicking row in address list -> dial the gate
function dhd_handleGUIAddressListDoubleClicked()
    dhd_handleGUIAddressListClicked()
    dhd_handleGUIDial()
    dhd_closeGUI()
end

-- Change local only value
function dhd_handleGUILocalOnlyClicked()
    DHD_GUI_LOCALONLY = guiCheckBoxGetSelected(source)
end

---
--- GUI
---

-- Classic DHD GUI
-- > Shutdown button        -   shut downs stargate (aborts diallling or closes wormhole)
-- > Dial button            -   dials stargate from given address in address text box
-- > Fast dial checkbox     -   use faster dialling mode?
--      > can be changed only when stargate's forceDialType is disabled
-- > Local only checkbox    -   show only local stargates (in same galaxy)
--      > can be changed only when dhd's canDialGalaxy is enabled
--      > Note: currently unavailable and does nothing (1 galaxy implemented only)
-- > Address textbox        -   input stargate address to be dialed
--      > automatically filled based on grid-list selection
--      > accepts format s1,s2,s3,s4,s5,s6,s7
-- > Address grid-list      -   list of available stargates
--      > clicking on row fills address textbox
--      > doublelick dials selected stargate
-- > Action (shutdown or dial)  -   auto-closes GUI
function dhd_classicGUI()
        local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
        local sgID = dhd_getAttachedStargate(dhdID)

        GUI_Window = guiCreateWindow(0.32, 0.23, 0.37, 0.21, "DHD User Interface", true)
        guiWindowSetSizable(GUI_Window, false)
        guiSetAlpha(GUI_Window, 0.90)
        guiSetProperty(GUI_Window, "CaptionColour", "FEFEFEFE")
        DHD_GUI_ELEMENT = GUI_Window

        Button_Shutdown = guiCreateButton(0.84, 0.12, 0.14, 0.16, "Shutdown", true, GUI_Window)
        guiSetAlpha(Button_Shutdown, 0.90)
        guiSetProperty(Button_Shutdown, "NormalTextColour", "E4FEFEFE")

        Button_Dial = guiCreateButton(0.68, 0.12, 0.14, 0.16, "Dial", true, GUI_Window)
        guiSetAlpha(Button_Dial, 0.90)
        guiSetFont(Button_Dial, "default-bold-small")
        guiSetProperty(Button_Dial, "NormalTextColour", "E4FEFEFE")

        GridList_AddressList = guiCreateGridList(0.02, 0.30, 0.97, 0.63, true, GUI_Window)
        guiSetAlpha(GridList_AddressList, 0.96)
        DHD_GUI_GRIDLIST = GridList_AddressList

        Label_Address = guiCreateLabel(18, 32, 66, 27, "Address:", false, GUI_Window)
        guiSetAlpha(Label_Address, 0.92)
        guiSetFont(Label_Address, "default-bold-small")
        guiLabelSetHorizontalAlign(Label_Address, "center", false)
        guiLabelSetVerticalAlign(Label_Address, "center")
        EditTextBox_Address = guiCreateEdit(0.13, 0.14, 0.27, 0.12, "", true, GUI_Window)
        guiSetAlpha(EditTextBox_Address, 0.93)
        DHD_GUI_ADDRESS_EDITBOX = EditTextBox_Address

        Checkbox_FastDial = guiCreateCheckBox(0.42, 0.14, 0.09, 0.12, "Fast dial", false, true, GUI_Window)
        CheckBox_LocalOnly = guiCreateCheckBox(0.54, 0.14, 0.11, 0.12, "Local only", true, true, GUI_Window)    

        if stargate_getForceDialType(sgID) == true then
            guiSetEnabled(Checkbox_FastDial, false)
        end
        if dhd_canDialGalaxy(dhdID) == false then
            guiSetEnabled(CheckBox_LocalOnly, false)
        end

        dhd_handleGUIRefreshAddressList(GridList_AddressList)
        addEventHandler("onClientGUIClick", Button_Shutdown, dhd_handleGUIShutdown, false)
        addEventHandler("onClientGUIClick", Button_Dial, dhd_handleGUIDial, false)
        addEventHandler("onClientGUIAccepted", EditTextBox_Address, dhd_handleGUIDial)
        addEventHandler("onClientGUIChanged", EditTextBox_Address, dhd_handleGUIAddressChanged)
        addEventHandler("onClientGUIClick", Checkbox_FastDial, dhd_handleGUIFastDialClicked, false)
        addEventHandler("onClientGUIClick", GridList_AddressList, dhd_handleGUIAddressListClicked, false)
        addEventHandler("onClientGUIDoubleClick", GridList_AddressList, dhd_handleGUIAddressListDoubleClicked, false)
        --addEventHandler("onClientGUIClick", CheckBox_LocalOnly, dhd_handleGUILocalOnlyClicked, false)
end