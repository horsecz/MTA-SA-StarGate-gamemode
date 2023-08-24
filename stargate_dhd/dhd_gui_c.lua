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

    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local type = dhd_getType(dhdID)
    if type == enum_galaxy.UNKOWN then  -- base DHD
        dhd_baseGUI()
    else -- classic DHD
        dhd_classicGUI()
    end
    DHD_GUI_OPEN = true
end

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
end

-- Refresh GUI Address grid list
function dhd_handleGUIRefreshAddressList()
    gridlist = DHD_GUI_GRIDLIST
    guiGridListClear(gridlist)
    guiGridListSetSelectionMode(gridlist, 0)

    guiGridListAddColumn(gridlist, "#", 0.1)
    guiGridListAddColumn(gridlist, "Planet name", 0.4)
    guiGridListAddColumn(gridlist, "Stargate address", 0.3)
    guiGridListAddColumn(gridlist, "Galaxy", 0.2)

    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAssignedStargate(dhdID)
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
        local sg_planet = planet_getPlanetDimension(getElementDimension(sg))
        local sg_planetID = planet_getPlanetID(sg_planet)

        local sg_address = ""
        for i,symbol in ipairs(sg_addressTable) do
            sg_address = sg_address .. tostring(symbol) .. "," 
        end
        local planet_name = planet_getName(sg_planetID)
        local galaxy = planet_getPlanetGalaxyString(sg_planetID)

        guiGridListSetItemText(gridlist, rowID, 1, tostring(i), false, false)
        guiGridListSetItemText(gridlist, rowID, 2, planet_name, false, false)
        guiGridListSetItemText(gridlist, rowID, 3, sg_address, false, false)
        guiGridListSetItemText(gridlist, rowID, 4, galaxy, false, false)
    end
end

-- Shutdown stargate after clicking Shutdown button
-- > abort dialling process
-- > shutdown stargate
-- > if wormhole is being opened or closed, do nothing
function dhd_handleGUIShutdown()
    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAssignedStargate(dhdID)
    local active = stargate_isActive(sgID)
    local open = stargate_isOpen(sgID)
    local inc = stargate_getIncomingStatus(sgID)
    if active == false and open == false then -- gate idle
        gui_showInfoWindow("DHD", "Stargate is already inactive!", 3000)
        return false
    end

    if active == true and open == false then -- gate dialling
        gui_showInfoWindow("DHD", "Aborted dialling process.", 3000)
        stargate_abortDial(sgID)
        return true
    end

    if active == true and open == true then -- gate is open
        if getElementData(getElementByID(sgID), "vortexIsOpening") == true then -- vortex activation, unable to close
            gui_showInfoWindow("DHD", "Unable to shut down stargate. Wormhole is being estabilished!", 3000)
            return false
        elseif getElementData(getElementByID(sgID), "horizonIsToggling") == true then -- horizon disengaging, gate closing
            gui_showInfoWindow("DHD", "Unable to shut down stargate. Gate is already shutting down!", 3000)
            return false
        else -- gate is normally open
            killTimer(stargate_getCloseTimer(sgID))
            local sgIDTo = stargate_getConnectionID(sgID)
            stargate_wormhole_close(sgID, SGIDTo)
            return true
        end
    end
end

-- Dial stargate after clicking Dial button
-- > only when gate is inactive
function dhd_handleGUIDial()
    local dhdID = dhd_getID(getElementData(getLocalPlayer(), "atDHD"))
    local sgID = dhd_getAssignedStargate(dhdID)
    local active = stargate_isActive(sgID)
    local dialType = enum_stargateDialType.SLOW
    if active == true then
        gui_showInfoWindow("DHD", "Unable to start dialling process. Stargate is already active!", 3000)
        return false
    end
    if DHD_GUI_ADDRESS == nil or DHD_GUI_ADDRESS == false or DHD_GUI_ADDRESS == "" then
        gui_showInfoWindow("DHD", "Missing stargate address to dial!", 3000)
        return false
    end
    if DHD_GUI_FASTDIAL == true then
        dialType = enum_stargateDialType.FAST
    end

    local addressArray = {}
    local addressSeparated = string.split(DHD_GUI_ADDRESS, ",")
    if not addressSeparated then
        gui_showInfoWindow("DHD", "Invalid stargate address format!", 3000)
        return false
    end
    
    for i,sym in addressSeparated do
        addressArray = array_push(addressArray, tonumber(sym))
    end

    stargate_dial(sgID, addressArray, dialType)
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
    local row, column = guiGridListGetSeletedItem(DHD_GUI_GRIDLIST) -- returns index -1 of row
    local address = guiGridListGetItemText(DHD_GUI_GRIDLIST, row+1, 3) -- 3 = sg address column
    guiSetText(DHD_GUI_ADDRESS_EDITBOX)
end

-- Event after double-clicking row in address list -> dial the gate
function dhd_handleGUIAddressListDoubleClicked()
    dhd_handleGUIAddressListClicked()
    dhd_handleGUIDial()
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
        local sgID = dhd_getAssignedStargate(dhdID)

        local FastDialCheckbox_enabled = true
        local LocalCheckbox_enabled = true
        local isLocalOnly = false

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

        if stargate_getForceDialType(sgID) == true then
            FastDialCheckbox_enabled = false
        end
        if dhd_canDialGalaxy(dhdID) == false then
            isLocalOnly = true
            LocalCheckbox_enabled = false
        end

        Checkbox_FastDial = guiCreateCheckBox(0.42, 0.14, 0.09, 0.12, "Fast dial", false, FastDialCheckbox_enabled, GUI_Window)
        CheckBox_LocalOnly = guiCreateCheckBox(0.54, 0.14, 0.11, 0.12, "Local only", isLocalOnly, LocalCheckbox_enabled, GUI_Window)    

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

-- Base DHD GUI
function dhd_baseGUI()
    -- special DHD GUI for SGC (ATL; etc) with stats
    -- dial mode always slow
    -- otherwise same as classic gui
    -- maybe: maybe much better: just include it into dhd_openGUI and if dhdType is BASE then add stats and force slow dial?
        -- warning: dont forget on fast dial checkbox and bigger gridlist 

    GUI_Window = guiCreateWindow(0.32, 0.23, 0.37, 0.36, "DHD User Interface", true)
    guiWindowSetSizable(GUI_Window, false)
    guiSetAlpha(GUI_Window, 0.90)
    guiSetProperty(GUI_Window, "CaptionColour", "FEFEFEFE")
    DHD_GUI_ELEMENT = GUI_Window

    Button_Close = guiCreateButton(0.84, 0.07, 0.14, 0.09, "Shutdown", true, GUI_Window)
    guiSetAlpha(Button_Close, 0.90)
    guiSetProperty(Button_Close, "NormalTextColour", "E4FEFEFE")
    Button_Dial = guiCreateButton(0.68, 0.07, 0.14, 0.09, "Dial", true, GUI_Window)
    guiSetAlpha(Button_Dial, 0.90)
    guiSetFont(Button_Dial, "default-bold-small")
    guiSetProperty(Button_Dial, "NormalTextColour", "E4FEFEFE")
    GridList_AddressList = guiCreateGridList(0.01, 0.18, 0.97, 0.44, true, GUI_Window)
    guiGridListAddColumn(GridList_AddressList, "#", 0.2)
    guiGridListAddColumn(GridList_AddressList, "Planet name", 0.2)
    guiGridListAddColumn(GridList_AddressList, "Stargate address", 0.2)
    guiGridListAddColumn(GridList_AddressList, "Galaxy", 0.2)
    for i = 1, 2 do
        guiGridListAddRow(GridList_AddressList)
    end
    guiGridListSetItemText(GridList_AddressList, 0, 1, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 0, 2, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 0, 3, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 0, 4, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 1, 1, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 1, 2, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 1, 3, "-", false, false)
    guiGridListSetItemText(GridList_AddressList, 1, 4, "-", false, false)
    guiSetAlpha(GridList_AddressList, 0.96)

    -----------------------
    ------------------------ ADDITIONAL FOR BASE DHD -----------------------------------
    -----------------------
    Label_Address = guiCreateLabel(0.03, 0.08, 0.09, 0.07, "Address:", true, GUI_Window)
    guiSetAlpha(Label_Address, 0.92)
    guiSetFont(Label_Address, "default-bold-small")
    guiLabelSetHorizontalAlign(Label_Address, "center", false)
    guiLabelSetVerticalAlign(Label_Address, "center")
    EditTextBox_Address = guiCreateEdit(0.13, 0.08, 0.27, 0.07, "", true, GUI_Window)
    guiSetAlpha(EditTextBox_Address, 0.93)
    CheckBox_LocalOnly = guiCreateCheckBox(0.42, 0.08, 0.11, 0.07, "Local only", false, true, GUI_Window)
    Label_Energy = guiCreateLabel(0.03, 0.67, 0.09, 0.07, "Energy:", true, GUI_Window)
    guiSetAlpha(Label_Energy, 0.92)
    guiSetFont(Label_Energy, "default-bold-small")
    guiLabelSetVerticalAlign(Label_Energy, "center")
    Label_DialLocal = guiCreateLabel(0.03, 0.77, 0.17, 0.07, "Can dial local:", true, GUI_Window)
    guiSetAlpha(Label_DialLocal, 0.92)
    guiSetFont(Label_DialLocal, "default-bold-small")
    guiLabelSetVerticalAlign(Label_DialLocal, "center")
    Label_DialGalaxy = guiCreateLabel(0.03, 0.86, 0.17, 0.07, "Can dial galaxy:", true, GUI_Window)
    guiSetAlpha(Label_DialGalaxy, 0.92)
    guiSetFont(Label_DialGalaxy, "default-bold-small")
    guiLabelSetVerticalAlign(Label_DialGalaxy, "center")
    LabelValue_DialLocal = guiCreateLabel(0.21, 0.77, 0.09, 0.07, "YES", true, GUI_Window)
    guiSetAlpha(LabelValue_DialLocal, 0.92)
    guiSetFont(LabelValue_DialLocal, "default-bold-small")
    guiLabelSetColor(LabelValue_DialLocal, 11, 210, 6)
    guiLabelSetVerticalAlign(LabelValue_DialLocal, "center")
    LabelValue_DialGalaxy = guiCreateLabel(0.21, 0.86, 0.09, 0.07, "NO", true, GUI_Window)
    guiSetAlpha(LabelValue_DialGalaxy, 0.92)
    guiLabelSetColor(LabelValue_DialGalaxy, 254, 27, 27)
    guiLabelSetVerticalAlign(LabelValue_DialGalaxy, "center")
    LabelValue_Energy = guiCreateLabel(0.21, 0.67, 0.12, 0.07, "1 000 000", true, GUI_Window)
    guiSetAlpha(LabelValue_Energy, 0.92)
    guiLabelSetColor(LabelValue_Energy, 254, 254, 254)
    guiLabelSetVerticalAlign(LabelValue_Energy, "center")
    Label_WormholeStatus = guiCreateLabel(0.49, 0.67, 0.17, 0.07, "Wormhole status:", true, GUI_Window)
    guiSetAlpha(Label_WormholeStatus, 0.92)
    guiSetFont(Label_WormholeStatus, "default-bold-small")
    guiLabelSetVerticalAlign(Label_WormholeStatus, "center")
    Label_StargateStatus = guiCreateLabel(0.49, 0.77, 0.17, 0.07, "Stargate status:", true, GUI_Window)
    guiSetAlpha(Label_StargateStatus, 0.92)
    guiSetFont(Label_StargateStatus, "default-bold-small")
    guiLabelSetVerticalAlign(Label_StargateStatus, "center")
    LabelValue_WormholeStatus = guiCreateLabel(0.71, 0.67, 0.14, 0.07, "Stable", true, GUI_Window)
    guiSetAlpha(LabelValue_WormholeStatus, 0.92)
    guiLabelSetColor(LabelValue_WormholeStatus, 11, 210, 6)
    guiLabelSetVerticalAlign(LabelValue_WormholeStatus, "center")
    LabelValue_StargateStatus = guiCreateLabel(0.71, 0.77, 0.14, 0.07, "Open", true, GUI_Window)
    guiSetAlpha(LabelValue_StargateStatus, 0.92)
    guiLabelSetVerticalAlign(LabelValue_StargateStatus, "center")
    Label_Connection = guiCreateLabel(0.49, 0.86, 0.17, 0.07, "Connected To:", true, GUI_Window)
    guiSetAlpha(Label_Connection, 0.92)
    guiSetFont(Label_Connection, "default-bold-small")
    guiLabelSetVerticalAlign(Label_Connection, "center")
    LabelValue_Connection = guiCreateLabel(0.71, 0.86, 0.26, 0.07, "Development World", true, GUI_Window)
    guiSetAlpha(LabelValue_Connection, 0.92)
    guiLabelSetVerticalAlign(LabelValue_Connection, "center") 

end