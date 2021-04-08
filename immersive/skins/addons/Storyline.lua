local _, GW = ...

local function LoadStorylineAddonSkin()
    if not GW.GetSetting("IMMERSIONADDON_SKIN_ENABLED") then return end

    local Storyline_NPCFrame = _G.Storyline_NPCFrame

    if Storyline_NPCFrame then
        for i,v in pairs({Storyline_NPCFrame:GetChildren()}) do
            if v.BorderTopLeft and v.BorderTopRight and v.BorderBottomLeft and v.BorderBottomRight then
                v:StripTextures()
                break
            end
        end


        Storyline_NPCFrame.Background.tex1 = Storyline_NPCFrame.Background:CreateTexture("bg1", "BACKGROUND", nil, -1)
        Storyline_NPCFrame.Background.tex1:SetPoint("CENTER", 0, 0)
        Storyline_NPCFrame.Background.tex1:SetSize(760, 500)
        Storyline_NPCFrame.Background.tex1:SetTexture("Interface/AddOns/GW2_UI/textures/questview/border")
        
        Storyline_NPCFrame.Background.tex2 = Storyline_NPCFrame.Background:CreateTexture("bg2", "BACKGROUND", nil, 6)
        Storyline_NPCFrame.Background.tex2:SetPoint("TOP", 0, 25)
        Storyline_NPCFrame.Background.tex2:SetSize(700, 250)
        Storyline_NPCFrame.Background.tex2:SetTexture("Interface/AddOns/GW2_UI/textures/questview/overlay_top")

        Storyline_NPCFrame.models.tex1 = Storyline_NPCFrame.models:CreateTexture("bg3", "BORDER", nil, 2)
        Storyline_NPCFrame.models.tex1:SetPoint("BOTTOM", 0, -20)
        Storyline_NPCFrame.models.tex1:SetSize(670, 450)
        Storyline_NPCFrame.models.tex1:SetTexture("Interface/AddOns/GW2_UI/textures/questview/overlay_bottom")

        Storyline_NPCFrameClose:SetNormalTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameClose:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        Storyline_NPCFrameClose:SetPushedTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        Storyline_NPCFrameClose:SetDisabledTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameClose:SetSize(25, 25)
       -- Storyline_NPCFrameClose:ClearAllPoints()
        -- ImmersionFrame.TalkBox.MainFrame.CloseButton:SetPoint("TOPRIGHT", -30, -8)

        -- ImmersionFrame.TalkBox.BackgroundFrame.TextBackground:SetTexture("Interface/AddOns/GW2_UI/textures/party/manage-group-bg")

        -- ImmersionFrame.TalkBox.Hilite:Hide()

        -- ImmersionFrame.TalkBox.MainFrame.Indicator:SetPoint("TOPRIGHT", -56, -13)
    end
end
GW.LoadStorylineAddonSkin = LoadStorylineAddonSkin