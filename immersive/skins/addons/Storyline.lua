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


        Storyline_NPCFrame.Background.border = Storyline_NPCFrame.Background:CreateTexture(nil, "BACKGROUND", nil, -1)
        Storyline_NPCFrame.Background.border:SetPoint("TOPLEFT", -60, 40)
        Storyline_NPCFrame.Background.border:SetPoint("BOTTOMRIGHT", 60, -40)
        Storyline_NPCFrame.Background.border:SetTexture("Interface/AddOns/GW2_UI/textures/questview/border")
        
        Storyline_NPCFrame.Background.top = Storyline_NPCFrame.Background:CreateTexture(nil, "BACKGROUND", nil, 6)
        Storyline_NPCFrame.Background.top:SetPoint("TOP", Storyline_NPCFrame.Background, "TOP", 0, 0)
        Storyline_NPCFrame.Background.top:SetPoint("LEFT", Storyline_NPCFrame.Background, "LEFT", 0, 0)
        Storyline_NPCFrame.Background.top:SetPoint("RIGHT", Storyline_NPCFrame.Background, "RIGHT", 0, 0)
        Storyline_NPCFrame.Background.top:SetPoint("BOTTOM", Storyline_NPCFrame.Background, "CENTER", 0, 20)
        Storyline_NPCFrame.Background.top:SetTexture("Interface/AddOns/GW2_UI/textures/questview/overlay_top")

        Storyline_NPCFrame.Background.bottom = Storyline_NPCFrame.Background:CreateTexture(nil, "BORDER", nil, 2)
        Storyline_NPCFrame.Background.bottom:SetPoint("TOPLEFT", Storyline_NPCFrame.Background, "TOPLEFT", 0, 0)
        Storyline_NPCFrame.Background.bottom:SetPoint("BOTTOMRIGHT", Storyline_NPCFrame.Background, "BOTTOMRIGHT", 0, 0)
        Storyline_NPCFrame.Background.bottom:SetTexture("Interface/AddOns/GW2_UI/textures/questview/overlay_bottom")

        Storyline_NPCFrameClose:StripTextures()
        Storyline_NPCFrameClose:ClearAllPoints()
        Storyline_NPCFrameClose:SetPoint("TOPRIGHT", -20, -20)
        Storyline_NPCFrameClose:SetNormalTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameClose:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        Storyline_NPCFrameClose:SetPushedTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        Storyline_NPCFrameClose:SetDisabledTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameClose:SetSize(25, 25)

        Storyline_NPCFrameLock:StripTextures()
        Storyline_NPCFrameLock:ClearAllPoints()
        Storyline_NPCFrameLock:SetPoint("TOPRIGHT", Storyline_NPCFrameClose, "TOPLEFT", -5, 0)
        --Storyline_NPCFrameLock:SetNormalTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        --Storyline_NPCFrameLock:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        --Storyline_NPCFrameLock:SetPushedTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        --Storyline_NPCFrameLock:SetDisabledTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameLock:SetSize(25, 25)

        Storyline_NPCFrameResizeButton:StripTextures()
        --Storyline_NPCFrameResizeButton:SetNormalTexture("Interface/AddOns/GW2_UI/textures/uistuff/resize")
        --Storyline_NPCFrameResizeButton:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/uistuff/resize")
        --Storyline_NPCFrameResizeButton:SetPushedTexture("Interface/AddOns/GW2_UI/textures/uistuff/resize")
        --Storyline_NPCFrameResizeButton:SetCheckedTexture("Interface/AddOns/GW2_UI/textures/uistuff/resize")
        Storyline_NPCFrameResizeButton:SetSize(25, 25)

        Storyline_NPCFrameConfigButton:StripTextures()
       -- Storyline_NPCFrameConfigButton:SetNormalTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
       --- Storyline_NPCFrameConfigButton:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
        ---Storyline_NPCFrameConfigButton:SetPushedTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-hover")
       -- Storyline_NPCFrameConfigButton:SetDisabledTexture("Interface/AddOns/GW2_UI/textures/uistuff/window-close-button-normal")
        Storyline_NPCFrameConfigButton:SetSize(25, 25)

       -- Storyline_NPCFrameClose:ClearAllPoints()
        -- ImmersionFrame.TalkBox.MainFrame.CloseButton:SetPoint("TOPRIGHT", -30, -8)

        -- ImmersionFrame.TalkBox.BackgroundFrame.TextBackground:SetTexture("Interface/AddOns/GW2_UI/textures/party/manage-group-bg")

        -- ImmersionFrame.TalkBox.Hilite:Hide()

        -- ImmersionFrame.TalkBox.MainFrame.Indicator:SetPoint("TOPRIGHT", -56, -13)
    end
end
GW.LoadStorylineAddonSkin = LoadStorylineAddonSkin