local _, GW = ...
local L = GW.L
local addOption = GW.AddOption
local addOptionDropdown = GW.AddOptionDropdown
local addOptionSlider = GW.AddOptionSlider
local createCat = GW.CreateCat
local InitPanel = GW.InitPanel
local SetSetting = GW.SetSetting
local AddForProfiling = GW.AddForProfiling

local function LoadImmersivePanel(sWindow)
    local p = CreateFrame("Frame", nil, sWindow.panels, "GwSettingsPanelTmpl")
    p.header:SetFont(DAMAGE_TEXT_FONT, 20)
    p.header:SetTextColor(255 / 255, 241 / 255, 209 / 255)
    p.header:SetText(L["Immersive"])
    p.sub:SetFont(UNIT_NAME_FONT, 12)
    p.sub:SetTextColor(181 / 255, 160 / 255, 128 / 255)
    p.sub:SetText(L["Enable or disable the modules you need and don't need."])


    createCat(L["MODULES"], L["Enable and disable components"], p, 9)

    addOption(p, L["Advanced Mode"], L["Enable the health bar replacement."], "ADVANCED_MODE", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOption(p, L["Full Screen"], L["Enable the health bar replacement."], "FULL_SCREEN", nil, nil, {["ADVANCED_MODE"] = true})
    addOptionDropdown(
        p,
        L["Full Screen Style"],
        nil,
        "STYLE",
        nil,
        {"CLASSIC", "GW2"},
        {L["CLASSIC"], L["GW2 UI"]},
        nil,
        {["ADVANCED_MODE"] = true}
    )
    addOption(p, L["Dinamic Background"], L["Enable the health bar replacement."], "DINAMIC_ART", nil, nil, {["ADVANCED_MODE"] = true})
    addOption(p, L["Force Gossip"], L["Enable the health bar replacement."], "FORCE_GOSSIP")
    addOption(p, L["Auto Next"], L["Enable the health bar replacement."], "AUTO_NEXT", nil, nil, {["ADVANCED_MODE"] = true})
    addOption(p, L["Control Dialog with Mouse"], L["Enable the health bar replacement."], "MOUSE_DIALOG", nil, nil, {["ADVANCED_MODE"] = true})

    addOptionSlider(
        p,
        L["Speed Auto Next"],
        L["Change the HUD size."],
        "AUTO_NEXT_TIME",
        nil,
        0,
        5,
        nil,
        2,
        {["ADVANCED_MODE"] = true, ["AUTO_NEXT"] = true},
        0.01
    )

    addOptionSlider(
        p,
        L["Speed Text Animation"],
        L["Change the HUD size."],
        "ANIMATION_TEXT_SPEED",
        nil,
        0,
        5,
        nil,
        2,
        {["ADVANCED_MODE"] = true},
        0.05
    )

    addOption(p, L["Auto summon Pet"], L["Enable the health bar replacement."], "SUMMON_PET")
    addOption(p, L["Mount"], L["Enable the health bar replacement."], "SUMMON_MOUNT")   

    InitPanel(p)
end
GW.LoadImmersivePanel = LoadImmersivePanel
