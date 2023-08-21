-- gui_c.lua: Module implementing DHD GUI; client-side

function dhd_openClassicGUI(stargateStatus)
        -- inspired by garrys mod gui
        -- changes depending on stargate status(es)
            -- GATE_STATE 1 - inactive
            -- dial btn         enabled
            -- shutdown btn     disabled
            -- GATE_STATE 2 - dialling OR GATE_STATE 3 - open
            -- dial btn         disabled
            -- shutdown btn     enabled
                -- STATE 2 -> interrupts dial
                -- STATE 3 -> shutdowns gate
            -- GATE_STATE 4 - incoming
            -- shutdown btn disabled
            -- dial btn disabled
        -- all states: gui looks the same only buttons are being disabled/enabled
        --             forceDialType true -> fast dial checkbox disabled
        --             dial mode -> depends on fast dial checkbox (and forceDialType)
        --             address textbox -> input for stargate_dial
        --                             -> s1,s2,s3,s4,s5,s6,s7 OR s1 s2 s3 s4 s5 s6 s7
        --                             -> autofill when user selects gate from gridlist
        -- GUI OPEN -> command /dial OR predefined button (E?)
        -- GUI CLOSE -> predefined button (same as open +/or ESC?)

        GUI_Window = guiCreateWindow(0.32, 0.23, 0.37, 0.21, "DHD User Interface", true)
        guiWindowSetSizable(GUI_Window, false)
        guiSetAlpha(GUI_Window, 0.90)
        guiSetProperty(GUI_Window, "CaptionColour", "FEFEFEFE")

        Button_Close = guiCreateButton(0.84, 0.12, 0.14, 0.16, "Shutdown", true, GUI_Window)
        guiSetAlpha(Button_Close, 0.90)
        guiSetProperty(Button_Close, "NormalTextColour", "E4FEFEFE")
        Button_Dial = guiCreateButton(0.68, 0.12, 0.14, 0.16, "Dial", true, GUI_Window)
        guiSetAlpha(Button_Dial, 0.90)
        guiSetFont(Button_Dial, "default-bold-small")
        guiSetProperty(Button_Dial, "NormalTextColour", "E4FEFEFE")
        GridList_AddressList = guiCreateGridList(0.02, 0.30, 0.97, 0.63, true, GUI_Window)
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
        Label_Address = guiCreateLabel(18, 32, 66, 27, "Address:", false, GUI_Window)
        guiSetAlpha(Label_Address, 0.92)
        guiSetFont(Label_Address, "default-bold-small")
        guiLabelSetHorizontalAlign(Label_Address, "center", false)
        guiLabelSetVerticalAlign(Label_Address, "center")
        EditTextBox_Address = guiCreateEdit(0.13, 0.14, 0.27, 0.12, "", true, GUI_Window)
        guiSetAlpha(EditTextBox_Address, 0.93)
        Checkbox_FastDial = guiCreateCheckBox(0.42, 0.14, 0.09, 0.12, "Fast dial", false, true, GUI_Window)
        CheckBox_LocalOnly = guiCreateCheckBox(0.54, 0.14, 0.11, 0.12, "Local only", true, true, GUI_Window)    
   
end

function dhd_openBaseGUI(stargateStatus)
    -- special DHD GUI for SGC (ATL; etc) with stats
    -- dial mode always slow
    -- otherwise same as classic gui
    -- maybe: maybe much better: just include it into dhd_openGUI and if dhdType is BASE then add stats and force slow dial?
        -- warning: dont forget on fast dial checkbox and bigger gridlist 

    GUI_Window = guiCreateWindow(0.32, 0.23, 0.37, 0.36, "DHD User Interface", true)
    guiWindowSetSizable(GUI_Window, false)
    guiSetAlpha(GUI_Window, 0.90)
    guiSetProperty(GUI_Window, "CaptionColour", "FEFEFEFE")

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