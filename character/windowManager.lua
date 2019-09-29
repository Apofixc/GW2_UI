local windowsList = {}
hasBeenLoaded = false
local _, GW = ...

windowsList[1] = {}
    windowsList[1]['ONLOAD'] = gw_register_character_window
    windowsList[1]['SETTING_NAME'] = 'USE_CHARACTER_WINDOW'
    windowsList[1]['TAB_ICON'] = 'tabicon_character'
    windowsList[1]['TAB_INDEX'] = 1
    windowsList[1]["Bindings"] = {
            ["TOGGLECHARACTER0"] = "PaperDoll",
            ["TOGGLECHARACTER2"] = "Reputation",
            ["TOGGLECHARACTER1"] = "Skills",
            ["TOGGLECHARACTER3"] = "SkiPetPaperDollFramells"
        }
    windowsList[1]["OnClick"] = [=[
            self:GetFrameRef("GwCharacterWindow"):SetAttribute("windowPanelOpen", 1)
        ]=]
    windowsList[1]["gwFrameCombatToggle"] = "gwFrameCombatTogglerCharacter"

    windowsList[2] = {}
    windowsList[2]['ONLOAD'] = gw_register_talent_window
    windowsList[2]['SETTING_NAME'] = 'USE_TALENT_WINDOW'
    windowsList[2]['TAB_ICON'] = 'tabicon-talents'
    windowsList[2]['TAB_INDEX'] = 2
    windowsList[2]["Bindings"] = {
            ["TOGGLETALENTS"] = "Talents"
        }
    windowsList[2]["OnClick"] = [=[
            self:GetFrameRef("GwCharacterWindow"):SetAttribute("windowPanelOpen", 2)
        ]=]
    windowsList[2]["gwFrameCombatToggle"] = "gwFrameCombatTogglerTalent"

    windowsList[3] = {}
    windowsList[3]['ONLOAD'] = gw_register_spellbook_window
    windowsList[3]['SETTING_NAME'] = 'USE_SPELLBOOK_WINDOW'
    windowsList[3]['TAB_ICON'] = 'tabicon_spellbook'
    windowsList[3]['TAB_INDEX'] = 3
    windowsList[3]["Bindings"] = {
            ["TOGGLESPELLBOOK"] = "SpellBook",
            ["TOGGLEPETBOOK"] = "PetBook"
        }
    windowsList[3]["OnClick"] = [=[
            self:GetFrameRef("GwCharacterWindow"):SetAttribute("windowPanelOpen", 3)
        ]=]
    windowsList[3]["gwFrameCombatToggle"] = "gwFrameCombatTogglerSpellbook"

 -- TODO: this doesn't work if bindings are updated in combat, but who does that?!
local function click_OnEvent(self, event)
    if event ~= "UPDATE_BINDINGS" then
        return
    end
    ClearOverrideBindings(self)

    for k, win in pairs(windowsList) do
        if win.TabFrame and win["Bindings"] then
            for key, click in pairs(win["Bindings"]) do
                local keyBind = GetBindingKey(key)
                if keyBind then
                    print(click)
                    SetOverrideBinding(self, false, keyBind, "CLICK ".. win.TabFrame.clicker .. ":" .. click)
                end
            end
        end
    end
end
GW.AddForProfiling("character", "mover_OnEvent", mover_OnEvent)

local function loadBaseFrame()
    if hasBeenLoaded then return end
    hasBeenLoaded = true

    CreateFrame('Frame', 'GwCharacterWindowMoverFrame', UIParent,' GwCharacterWindowMoverFrame')
    CreateFrame('Button', 'GwCharacterWindow', UIParent, 'GwCharacterWindow')
    GwCharacterWindow:SetFrameLevel(5)
    GwCharacterWindowMoverFrame:Hide()

    GwCharacterWindow:SetAttribute('windowPanelOpen', 0)

    -- set binding change handlers
    GwCharacterWindow.secure:HookScript("OnEvent", click_OnEvent)
    GwCharacterWindow.secure:RegisterEvent("UPDATE_BINDINGS")

    GwCharacterWindow.secure:SetFrameRef("GwCharacterWindow", GwCharacterWindow)

    GwCharacterWindow.WindowHeader:SetFont(DAMAGE_TEXT_FONT, 20)
    GwCharacterWindow.WindowHeader:SetTextColor(255/255, 241/255, 209/255)

    GwCharacterWindow.SoundOpen = function(self)
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
    end
    GwCharacterWindow.SoundSwap = function(self)
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
    end
    GwCharacterWindow.SoundExit = function(self)
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
    end

    GwCharacterWindow.close:SetFrameRef('GwCharacterWindow', GwCharacterWindow)
    GwCharacterWindow.close:SetFrameRef('GwCharacterWindowMoverFrame', GwCharacterWindowMoverFrame)

    GwCharacterWindow.close:SetAttribute("_onclick", [=[
        self:GetFrameRef('GwCharacterWindow'):Hide()
        self:GetFrameRef('GwCharacterWindowMoverFrame'):Hide()
        if self:GetFrameRef('GwCharacterWindow'):IsVisible() then
            self:GetFrameRef('GwCharacterWindow'):Hide()
        end
    ]=])

    GwCharacterWindow:SetAttribute('windowPanelOpen', 0)
    GwCharacterWindow:SetAttribute('_onshow', [=[
        self:SetBindingClick(false, 'ESCAPE', self:GetName(), 'Escape')
        ]=])
    GwCharacterWindow:SetAttribute('_onhide', [=[
        self:ClearBindings()
    ]=])
    GwCharacterWindow:SetAttribute('_onclick', [=[
        if button == 'Escape' then
            self:Hide()
            self:GetFrameRef('GwCharacterWindowMoverFrame'):Hide()
        end
    ]=])

    GwCharacterWindow:Hide()
    GwCharacterWindow:SetFrameRef('GwCharacterWindowMoverFrame', GwCharacterWindowMoverFrame)
    GwCharacterWindow:SetAttribute('_onattributechanged', [=[
        if value == nil or value == true then return end

        if value == 1 and self:GetFrameRef('GwCharacterWindowContainer') ~= nil and self:GetFrameRef('GwCharacterWindowContainer'):IsVisible() then
            self:SetAttribute('windowPanelOpen', 0)
            return
        end
        if value == 2 and self:GetFrameRef('GwTalentFrame') ~= nil and self:GetFrameRef('GwTalentFrame'):IsVisible() then
            self:SetAttribute('windowPanelOpen', 0)
            return
        end
        if value == 3 and self:GetFrameRef('GwSpellbook') ~= nil and self:GetFrameRef('GwSpellbook'):IsVisible() then
            self:SetAttribute('windowPanelOpen', 0)
            return
        end

        if self:GetFrameRef('GwTalentFrame') ~= nil then
            self:GetFrameRef('GwTalentFrame'):Hide()
        end
        if self:GetFrameRef('GwCharacterWindowContainer') ~= nil then
            self:GetFrameRef('GwCharacterWindowContainer'):Hide()
        end
        if self:GetFrameRef('GwSpellbook') ~= nil then
            self:GetFrameRef('GwSpellbook'):Hide()
        end

        if not self:IsVisible() and value ~= 0 then
            self:Show()
            self:GetFrameRef('GwCharacterWindowMoverFrame'):Show()
        end

        if value == 1 and self:GetFrameRef('GwCharacterWindowContainer') ~= nil then
            self:GetFrameRef('GwCharacterWindowContainer'):Show()
        end
        if value == 2 and self:GetFrameRef('GwTalentFrame') ~= nil then
            self:GetFrameRef('GwTalentFrame'):Show()
        end
        if value == 3 and self:GetFrameRef('GwSpellbook') ~= nil then
            self:GetFrameRef('GwSpellbook'):Show()
        end

        if value == 0 then
            self:Hide()
            self:GetFrameRef('GwCharacterWindowMoverFrame'):Hide()
        end
    ]=])
end

local function setTabIconState(self, b)
    if b then
        self.icon:SetTexCoord(0, 0.5, 0, 0.625)
    else
        self.icon:SetTexCoord(0.5, 1, 0, 0.625)
    end
end

local usedTabs = 1
local function createTabIcon(iconName, tabIndex)
    local f = CreateFrame('Button', 'CharacterWindowTab' .. tabIndex, GwCharacterWindow, 'SecureHandlerClickTemplate,SecureHandlerStateTemplate,CharacterWindowTabSelect')

    f.icon:SetTexture('Interface\\AddOns\\GW2_UI\\textures\\character\\' .. iconName)
    f:SetPoint('TOP', GwCharacterWindow, 'TOPLEFT', -32, -25 + -((usedTabs - 1) * 45))
    usedTabs = usedTabs + 1
    setTabIconState(f, false)

    return f
end

function Gw_LoadWindows()
    local anyThingToLoad = false
    for k, v in pairs(windowsList) do
        if GW.GetSetting(v['SETTING_NAME']) then
            anyThingToLoad = true
        end
    end
    if not anyThingToLoad then
        return
    end

    loadBaseFrame()

    for k, v in pairs(windowsList) do
        if GW.GetSetting(v['SETTING_NAME']) then
            local ref = v['ONLOAD']()
            local f = createTabIcon(v['TAB_ICON'], v['TAB_INDEX'])

            f.clicker = v["gwFrameCombatToggle"]
            GwCharacterWindow:SetFrameRef(ref:GetName(), ref)
            ref:HookScript('OnShow', function()
                setTabIconState(f, true)
            end)
            ref:HookScript('OnHide', function()
                setTabIconState(f, false)
            end)
            f:SetFrameRef('GwCharacterWindow', GwCharacterWindow)
            f:SetAttribute('_OnClick', v["OnClick"])
            
            local gwFrameCombatToggle = CreateFrame('Button', v["gwFrameCombatToggle"], UIParent, 'SecureActionButtonTemplate,gwFrameCombatTogglerSpellbook')
            gwFrameCombatToggle:SetAttribute('type', 'attribute')
            gwFrameCombatToggle:SetAttribute('type2', 'attribute')
            gwFrameCombatToggle:SetAttribute('attribute-frame', GwCharacterWindow)
            gwFrameCombatToggle:SetAttribute('attribute-name', 'windowPanelOpen')
            gwFrameCombatToggle:SetAttribute('attribute-value', v['TAB_INDEX'])
            
            v.TabFrame = f
        end
    end

    -- set bindings on secure instead of char win to not interfere with secure ESC binding on char win
    click_OnEvent(GwCharacterWindow.secure, "UPDATE_BINDINGS")
end
