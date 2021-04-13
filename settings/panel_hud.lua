local _, GW = ...
local L = GW.L
local addOption = GW.AddOption
local addOptionButton = GW.AddOptionButton
local addOptionSlider = GW.AddOptionSlider
local addOptionDropdown = GW.AddOptionDropdown
local createCat = GW.CreateCat
local GetSetting = GW.GetSetting
local InitPanel = GW.InitPanel

local function LoadHudPanel(sWindow)
    local p = CreateFrame("Frame", nil, sWindow.panels, "GwSettingsPanelTmpl")
    p.header:Hide()
    p.sub:Hide()

    local p_hub = CreateFrame("Frame", nil, p, "GwSettingsPanelScrollTmpl")
    p_hub:SetHeight(370)
    p_hub:SetWidth(512)
    p_hub:ClearAllPoints()
    p_hub:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
    p_hub.scroll.scrollchild.header:SetFont(DAMAGE_TEXT_FONT, 20)
    p_hub.scroll.scrollchild.header:SetTextColor(255 / 255, 241 / 255, 209 / 255)
    p_hub.scroll.scrollchild.header:SetText(UIOPTIONS_MENU)
    p_hub.scroll.scrollchild.sub:SetFont(UNIT_NAME_FONT, 12)
    p_hub.scroll.scrollchild.sub:SetTextColor(181 / 255, 160 / 255, 128 / 255)
    p_hub.scroll.scrollchild.sub:SetText(L["Edit the modules in the Heads-Up Display for more customization."])

    local p_immersive = CreateFrame("Frame", nil, p, "GwSettingsPanelScrollTmpl")
    p_immersive:SetHeight(250)
    p_immersive:SetWidth(512)
    p_immersive:ClearAllPoints()
    p_immersive:SetPoint("TOPLEFT", p_hub, "BOTTOMLEFT", 0, 0)
    p_immersive.scroll.scrollchild.header:SetFont(DAMAGE_TEXT_FONT, 20)
    p_immersive.scroll.scrollchild.header:SetTextColor(255 / 255, 241 / 255, 209 / 255)
    p_immersive.scroll.scrollchild.header:SetText(L["Immersion"])
    p_immersive.scroll.scrollchild.sub:SetFont(UNIT_NAME_FONT, 12)
    p_immersive.scroll.scrollchild.sub:SetTextColor(181 / 255, 160 / 255, 128 / 255)
    p_immersive.scroll.scrollchild.sub:SetText(L["Setting Immersion elements."])

    createCat(UIOPTIONS_MENU, L["Edit the HUD modules."], p, 3, nil, {p_hub, p_immersive})

    addOption(p_hub.scroll.scrollchild, L["Show HUD background"], L["The HUD background changes color in the following situations: In Combat, Not In Combat, In Water, Low HP, Ghost"], "HUD_BACKGROUND")
    addOption(p_hub.scroll.scrollchild, L["Dynamic HUD"], L["Enable or disable the dynamically changing HUD background."], "HUD_SPELL_SWAP", nil, nil, {["HUD_BACKGROUND"] = true})
    addOption(p_hub.scroll.scrollchild, L["AFK Mode"], L["When you go AFK, display the AFK screen."], "AFK_MODE")
    addOption(p_hub.scroll.scrollchild, L["Fade Chat"], L["Allow the chat to fade when not in use."], "CHATFRAME_FADE", nil, nil, {["CHATFRAME_ENABLED"] = true})
    addOptionSlider(
        p_hub.scroll.scrollchild,
        L["Maximum lines of 'Copy Chat Frame'"],
        L["Set the maximum number of lines displayed in the Copy Chat Frame"],
        "CHAT_MAX_COPY_CHAT_LINES",
        nil,
        50,
        500,
        nil,
        0,
        {["CHATFRAME_ENABLED"] = true},
        1
    )
    addOption(p_hub.scroll.scrollchild, L["Toggle Compass"], L["Enable or disable the quest tracker compass."], "SHOW_QUESTTRACKER_COMPASS", nil, nil, {["QUESTTRACKER_ENABLED"] = true})
    addOption(p_hub.scroll.scrollchild, L["Advanced Casting Bar"], L["Enable or disable the advanced casting bar."], "CASTINGBAR_DATA", nil, nil, {["CASTINGBAR_ENABLED"] = true})
    addOption(p_hub.scroll.scrollchild, L["Fade Menu Bar"], L["The main menu icons will fade when you move your cursor away."], "FADE_MICROMENU")
    addOption(p_hub.scroll.scrollchild, DISPLAY_BORDERS, nil, "BORDER_ENABLED")
    addOption(p_hub.scroll.scrollchild, L["Show Coordinates on World Map"], L["Show Coordinates on World Map"], "WORLDMAP_COORDS_TOGGLE", nil, nil)
    addOption(p_hub.scroll.scrollchild, L["Show FPS on minimap"], L["Show FPS on minimap"], "MINIMAP_FPS", nil, nil, {["MINIMAP_ENABLED"] = true}, "Minimap")
    addOption(p_hub.scroll.scrollchild, L["Show Coordinates on Minimap"], L["Show Coordinates on Minimap"], "MINIMAP_COORDS_TOGGLE", nil, nil, {["MINIMAP_ENABLED"] = true}, "Minimap")
    addOption(p_hub.scroll.scrollchild, L["Fade Group Manage Button"], L["The Group Manage Button will fade when you move the cursor away."], "FADE_GROUP_MANAGE_FRAME", nil, nil, {["PARTY_FRAMES"] = true}, "Groupframes")
    addOption(
        p_hub.scroll.scrollchild,
        L["Pixel Perfect Mode"],
        L["Scales the UI into a Pixel Perfect Mode. This is dependent on screen resolution."],
        "PIXEL_PERFECTION",
        function()
            SetCVar("useUiScale", 0)
            GW.PixelPerfection()
        end
    )
    addOptionDropdown(
        p_hub.scroll.scrollchild,
        COMBAT_TEXT_LABEL,
        COMBAT_SUBTEXT,
        "GW_COMBAT_TEXT_MODE",
        nil,
        {"GW2", "BLIZZARD", "OFF"},
        {GW.addonName, "Blizzard", OFF .. " / " .. OTHER .. " " .. ADDONS},
        nil,
        nil,
        nil,
        "FloatingCombatText"
    )
    addOption(p_hub.scroll.scrollchild, COMBAT_TEXT_LABEL .. L[": Use Blizzard colors"], nil, "GW_COMBAT_TEXT_BLIZZARD_COLOR", nil, nil, {["GW_COMBAT_TEXT_MODE"] = "GW2"}, "FloatingCombatText")
    addOption(p_hub.scroll.scrollchild, COMBAT_TEXT_LABEL .. L[": Show numbers with commas"], nil, "GW_COMBAT_TEXT_COMMA_FORMAT", nil, nil, {["GW_COMBAT_TEXT_MODE"] = "GW2"}, "FloatingCombatText")
    addOptionSlider(
        p_hub.scroll.scrollchild,
        L["HUD Scale"],
        L["Change the HUD size."],
        "HUD_SCALE",
        GW.UpdateHudScale,
        0.5,
        1.5,
        nil,
        2
    )
    addOptionButton(p_hub.scroll.scrollchild, L["Apply UI scale to all scaleable frames"], L["Applies the UI scale to all frames, which can be scaled in 'Move HUD' mode."], nil, function()
        local scale = GetSetting("HUD_SCALE")
        for _, mf in pairs(GW.scaleableFrames) do
            mf.gw_frame:SetScale(scale)
            mf:SetScale(scale)
            GW.SetSetting(mf.gw_Settings .."_scale", scale)
        end
    end)
    addOptionDropdown(
        p_hub.scroll.scrollchild,
        L["Minimap details"],
        L["Always show Minimap details."],
        "MINIMAP_HOVER",
        GW.SetMinimapHover,
        {"NONE", "ALL", "CLOCK", "ZONE", "COORDS", "CLOCKZONE", "CLOCKCOORDS", "ZONECOORDS"},
        {
            NONE_KEY,
            ALL,
            TIMEMANAGER_TITLE,
            ZONE,
            L["Coordinates"],
            TIMEMANAGER_TITLE .. " + " .. ZONE,
            TIMEMANAGER_TITLE .. " + " .. L["Coordinates"],
            ZONE .. " + " .. L["Coordinates"]
        },
        nil,
        {["MINIMAP_ENABLED"] = true},
        nil,
        "Minimap"
    )
    addOptionDropdown(
        p_hub.scroll.scrollchild,
        L["Minimap Scale"],
        L["Change the Minimap size."],
        "MINIMAP_SCALE",
        function()
            local size = GetSetting("MINIMAP_SCALE")
            Minimap:SetSize(size, size)
            Minimap.gwMover:SetSize(size, size)
        end,
        {250, 200, 170},
        {
            LARGE,
            TIME_LEFT_MEDIUM,
            DEFAULT
        },
        nil,
        {["MINIMAP_ENABLED"] = true},
        nil,
        "Minimap"
    )
    addOptionDropdown(
        p_hub.scroll.scrollchild,
        L["Auto Repair"],
        L["Automatically repair using the following method when visiting a merchant."],
        "AUTO_REPAIR",
        nil,
        {"NONE", "PLAYER", "GUILD"},
        {
            NONE_KEY,
            PLAYER,
            GUILD,
        }
    )

    addOption(p_immersive.scroll.scrollchild, VIDEO_OPTIONS_FULLSCREEN, L["Set FullScreen mode as default mode."], "FULL_SCREEN", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOption(p_immersive.scroll.scrollchild, DYNAMIC.." "..strlower(BACKGROUND), L["Use backgrounds based on the current zone when possible."], "DYNAMIC_BACKGROUND", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOption(p_immersive.scroll.scrollchild, L["Use mouse"], L["Controlling dialog text using the mouse."], "MOUSE_DIALOG", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOption(p_immersive.scroll.scrollchild, L["Extended dialog with NPC"], L["Open additional dialog options when communicating with NPC."], "FORCE_GOSSIP", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOption(p_immersive.scroll.scrollchild, L["Scrolling text"], L["Automatic scrolling of dialog text."], "AUTO_NEXT", nil, nil, {["QUESTVIEW_ENABLED"] = true})
    addOptionSlider(
        p_immersive.scroll.scrollchild,
        L["Scrolling delay"],
        L["Set the time after which the automatic scrolling of the dialog will work."],
        "AUTO_NEXT_TIME",
        nil,
        0.25,
        5,
        nil,
        2, 
        {["QUESTVIEW_ENABLED"] = true, ["AUTO_NEXT"] = true}
    )
    addOptionSlider(
        p_immersive.scroll.scrollchild,
        L["Text animation speed (Player)"],
        L["Controls the speed of text animations. When value are equal to 0, animation is disabled."],
        "ANIMATION_TEXT_SPEED_P",
        nil,
        0,
        2,
        nil,
        2, 
        {["QUESTVIEW_ENABLED"] = true}
    )
    addOptionSlider(
        p_immersive.scroll.scrollchild,
        L["Text animation speed (NPC)"],
        L["Controls the speed of text animations. When value are equal to 0, animation is disabled."],
        "ANIMATION_TEXT_SPEED_N",
        nil,
        0,
        2,
        nil,
        2, 
        {["QUESTVIEW_ENABLED"] = true}
    )
    addOption(p_immersive.scroll.scrollchild, L["'Smart' summon mount"], L["Summons a mount based on location/ class/ race player"], "SUMMON_MOUNT")
    addOption(p_immersive.scroll.scrollchild, L["Summon pets"], L["Summon Pets depending on the location of the player."], "SUMMON_PET")

    InitPanel(p_hub, true)
    InitPanel(p_immersive, true)
end
GW.LoadHudPanel = LoadHudPanel
