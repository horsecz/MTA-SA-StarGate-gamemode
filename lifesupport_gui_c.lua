-- gui_c.lua: GUI for lifesupport module; client-side

GUI_MAX_LS_PROPERTY_CHARS = 6

GUI_LS_OXYGEN = nil
GUI_LS_GRAV = nil
GUI_LS_TOX = nil
GUI_LS_TEMP = nil

GUI_LS_NOLS = "-"
GUI_LS_NOPROP = "?"

-- Initializes GUI; starts render
function lifesupport_gui_init()
    addEventHandler("onClientRender", resourceRoot, lifesupport_gui_show)
end
addEventHandler("onClientResourceStart", resourceRoot, lifesupport_gui_init)

-- Prepares GUI data; string parse and check
function lifesupport_gui_prepare()
    local player_ls = lifesupport_getElementLifesupportStats(getLocalPlayer()) -- ???
    if not player_ls then
        return (lifesupport_gui_setDefaults())    
    end
    local oxygen = lifesupport_getOxygen(player_ls)
    local gravity = lifesupport_getGravity(player_ls)
    local toxicity = lifesupport_getToxicity(player_ls)
    local temp = lifesupport_getTemperature(player_ls)
    
    if not oxygen then
        GUI_LS_OXYGEN = GUI_LS_NOPROP  
    else
        GUI_LS_OXYGEN = tostring(oxygen) .. "%"
    end

    if not gravity then
        GUI_LS_GRAV = GUI_LS_NOPROP
    else
        if gravity > 999 then
            gravity = "999+"
        end
        GUI_LS_GRAV = tostring(gravity) .. " EA"
    end
    
    if not toxicity then
        GUI_LS_TOX = GUI_LS_NOPROP
    else
        GUI_LS_TOX = tostring(toxicity) .. "%"
    end

    if not temp then
        GUI_LS_TEMP = GUI_LS_NOPROP
    else
        if temp > 999 then
            temp = "999+"
        end
        GUI_LS_TEMP = tostring(temp) .. " °C"
    end
end

function lifesupport_gui_setDefaults()
    GUI_LS_OXYGEN = GUI_LS_NOLS
    GUI_LS_GRAV = GUI_LS_NOLS
    GUI_LS_TOX = GUI_LS_NOLS
    GUI_LS_TEMP = GUI_LS_NOLS
end

-- Shows GUI
function lifesupport_gui_show()
    lifesupport_gui_prepare()
    local screenW, screenH = guiGetScreenSize()
    
    dxDrawRectangle(screenW * 0.7818, screenH * 0.3454, screenW * 0.1703, screenH * 0.1556, tocolor(0, 0, 0, 112), false)
    dxDrawLine(screenW * 0.7839, screenH * 0.3750, screenW * 0.9521, screenH * 0.3769, tocolor(0, 0, 0, 134), 1, false)
    dxDrawText("Atmosphere", (screenW * 0.7839) + 1, (screenH * 0.3454) + 1, (screenW * 0.9521) + 1, (screenH * 0.3713) + 1, tocolor(0, 0, 0, 193), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
    dxDrawText("Atmosphere", screenW * 0.7839, screenH * 0.3454, screenW * 0.9521, screenH * 0.3713, tocolor(232, 232, 232, 230), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
    dxDrawText("Oxygen", screenW * 0.7870, screenH * 0.3861, screenW * 0.8630, screenH * 0.4065, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Gravity", screenW * 0.7870, screenH * 0.4713, screenW * 0.8630, screenH * 0.4917, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Toxicity", screenW * 0.7870, screenH * 0.4454, screenW * 0.8630, screenH * 0.4657, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText("Temperature", screenW * 0.7870, screenH * 0.4157, screenW * 0.8630, screenH * 0.4361, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "left", "center", false, false, false, false, false)
    dxDrawText(GUI_LS_OXYGEN, screenW * 0.8870, screenH * 0.4157, screenW * 0.9469, screenH * 0.4398, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText(GUI_LS_GRAV, screenW * 0.8870, screenH * 0.4454, screenW * 0.9469, screenH * 0.4657, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText(GUI_LS_TOX, screenW * 0.8870, screenH * 0.4713, screenW * 0.9469, screenH * 0.4917, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
    dxDrawText(GUI_LS_TEMP, screenW * 0.8870, screenH * 0.3843, screenW * 0.9469, screenH * 0.4083, tocolor(232, 232, 232, 224), 0.80, "bankgothic", "right", "center", false, false, false, false, false)
end