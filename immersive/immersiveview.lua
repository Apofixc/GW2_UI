local _, GW = ...
local L = GW.L
local ModelScaling = GW.Libs.Model
local GetSetting = GW.GetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local IsIn = GW.IsIn
local CheckStateAnimation =  GW.CheckStateAnimation
local StopAnimation = GW.StopAnimation
local ImmersiveFrameHandleShow = GW.ImmersiveFrameHandleShow
local ImmersiveFrameHandleHide = GW.ImmersiveFrameHandleHide
local GetCustomZoneBackground = GW.GetCustomZoneBackground

local Dialog = GW.Dialog
local LoadTitleButtons = GW.LoadTitleButtons
local LoadDetalies = GW.LoadDetalies

C_GossipInfo.ForceGossip = function() return GetSetting("FORCE_GOSSIP") end

local function GwImmersiveFrame_OnEvent(self, event, ...)
	if IsIn(event, "QUEST_ITEM_UPDATE", "QUEST_LOG_UPDATE", "LEARNED_SPELL_IN_TAB", "UNIT_MODEL_CHANGED") and not self.ActiveFrame:IsShown() then return end

	if not IsIn(event, "QUEST_ITEM_UPDATE", "QUEST_LOG_UPDATE", "LEARNED_SPELL_IN_TAB", "UNIT_MODEL_CHANGED") then
		if self.LastEvent == "GOSSIP_SHOW" and event:match('^QUEST') then C_GossipInfo.CloseGossip() end

		self.LastEvent = event
	end
	
	if IsIn(event, "GOSSIP_SHOW", "QUEST_GREETING") then
		local dialog 

		if event == "GOSSIP_SHOW" then
			local textureKit = ...
			if textureKit then
				local handler = self:GetHandler(textureKit)
				if handler then
					self.customFrame = handler(textureKit)
					return
				end
			end

			if C_GossipInfo.GetNumAvailableQuests() == 0 and C_GossipInfo.GetNumActiveQuests() == 0 and C_GossipInfo.GetNumOptions() == 1 and not C_GossipInfo.ForceGossip() then
				local gossipInfoTable = C_GossipInfo.GetOptions()
				if gossipInfoTable[1].type ~= "gossip" then
					C_GossipInfo.SelectOption(1)
					return
				end
			end

			dialog = C_GossipInfo.GetText()
		else
			dialog = GetGreetingText()
		end

		ImmersiveFrameHandleShow(self.ActiveFrame, nil, dialog)
	elseif IsIn(event, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") then
		local dialog

		if IsIn(event, "QUEST_DETAIL", "QUEST_COMPLETE") then
			local questPortrait, questPortraitText, questPortraitName, questPortraitMount

			if event == "QUEST_DETAIL" then
				local questStartItemID = ...

				if QuestIsFromAdventureMap() then return end

				if questStartItemID and questStartItemID ~= 0 or QuestGetAutoAccept() and QuestIsFromAreaTrigger() then
					if AutoQuestPopupTracker_AddPopUp(GetQuestID(), "OFFER", questStartItemID) then PlayAutoAcceptQuestSound() end

					CloseQuest()
					return
				end

				dialog = GetQuestText()
				questPortrait, questPortraitText, questPortraitName, questPortraitMount = GetQuestPortraitGiver()
			else
				questPortrait, questPortraitText, questPortraitName = GetQuestPortraitTurnIn()
				dialog = GetRewardText()
			end

			if questPortrait == 0 then
				--QuestFrame_ShowQuestPortrait(self.ActiveFrame, -1, -1, "Test", "Test")
				-- QuestFrame_ShowQuestPortrait(self.ActiveFrame, questPortrait, questPortraitMount or 0, questPortraitText, questPortraitName, -3, -42)
				--QuestFrame_UpdatePortraitText( "Test")
				--QuestModelScene:SetParent(self.ActiveFrame)
				--QuestModelScene:ClearAllPoints()
				--QuestModelScene:SetPoint("CENTER", self.ActiveFrame, "CENTER", 0, 0)
				-- QuestNPCModelTextFrameBg:Show()
				--QuestModelScene:Show()
			end
		else
			dialog = GetProgressText()
		end

		ImmersiveFrameHandleShow(self.ActiveFrame, GetTitleText(), dialog)
	elseif IsIn(event, "GOSSIP_CLOSED", "QUEST_FINISHED") then
		ImmersiveFrameHandleHide(self)
	elseif IsIn(event, "QUEST_ITEM_UPDATE", "LEARNED_SPELL_IN_TAB") then
		if IsIn(self.LastEvent, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and self.ActiveFrame.Detail:IsVisible() then
			self.ActiveFrame.Detail:Hide()
			self.ActiveFrame.Detail.Scroll.ScrollBar:SetValue(0)
			self.ActiveFrame.Detail:SetShown(ShownDetail(LastEvent, self.ActiveFrame.Detail.Scroll.ScrollChildFrame))
		end
	elseif event == "QUEST_LOG_UPDATE" then
		if (self.LastEvent == "GOSSIP_SHOW" and self.hasActiveQuest) or self.LastEvent == "QUEST_GREETING" then
			GwImmersiveFrame_OnEvent(GwImmersiveFrame, self.LastEvent)
		end
	elseif event == "UNIT_MODEL_CHANGED" then
		local unit = ...
		if unit == "player" then
			ModelScaling:SetModel(self.ActiveFrame.Models.Player)
		else
			ModelScaling:SetModel(self.ActiveFrame.Models.Giver)
		end
	end
end 

local function GwFullScreenGossipViewFrame_OnShow(self)
	local typeBackGrounds, texture, texCoord = GetCustomZoneBackground()
	if typeBackGrounds == "Default" then
		self.Background:SetTexture(texture);
	else
		if typeBackGrounds == "Dinamic" then
			self.Middleground:SetAtlas("_GarrMissionLocation-"..texture.."-Mid")
			self.Background:SetAtlas("_GarrMissionLocation-"..texture.."-Back")
			self.Foreground:SetAtlas("_GarrMissionLocation-"..texture.."-Fore")		
		else
			self.Background:SetAtlas(texture)
		end	
	end

	self.Background:SetTexCoord(unpack(texCoord))	
	if typeBackGrounds == "Dinamic" then
		self.Middleground:SetTexCoord(unpack(texCoord))	
		self.Foreground:SetTexCoord(unpack(texCoord))	
	end

	self.Background:SetShown(true)
	self.Middleground:SetShown(typeBackGrounds == "Dinamic")
	self.Foreground:SetShown(typeBackGrounds == "Dinamic")
end

local function GwImmersiveFrames_OnKeyDown(self, button)
	if IsIn(button, "ESCAPE", "SPACE", "F1", "F2") or tonumber(button) then
		if button == "ESCAPE" then
			if not QuestGetAutoAccept() then
				CloseQuest()
				C_GossipInfo.CloseGossip()
				PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
			end
		elseif button == "SPACE" then
			if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") then
				StopAnimation("IMMERSIVE_DIALOG_ANIMATION")

				self.AutoNext = false
				self.Dialog.Text:SetAlphaGradient(self.maxSizeText, 1)
				self.Scroll.ScrollChildFrame:Show()
				self.Scroll.ScrollBar:SetAlpha(1)
			end
		elseif button == "F1" then
			ImmersiveFrameHandleHide(GwImmersiveFrame, true)			
		elseif button == "F2" then
			if self.Dialog:GetScript("OnClick") then self.Dialog:SetMouseClickEnabled(not self.Dialog:IsMouseEnabled()) end
		else 
			if self.Scroll.ScrollChildFrame:IsVisible() then
				local num = tonumber(button) 
				for obj in GwImmersiveFrame.TitleButtonPool:EnumerateActive() do
					if obj:GetID() == num then 
						obj:Click() 
						break
					end			
				end							
			end
		end

		self:SetPropagateKeyboardInput(false)	
	else
		self:SetPropagateKeyboardInput(true);
	end
end

local function GwNormalScreenGossipViewFrame_OnClick(self, button)
	if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") then
		StopAnimation("IMMERSIVE_DIALOG_ANIMATION")
	
		GwImmersiveFrame.AutoNext = false
		GwImmersiveFrame.ActiveFrame.Dialog.Text:SetAlphaGradient(GwImmersiveFrame.ActiveFrame.maxSizeText, 1)
		GwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame:Show()
		GwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetAlpha(1)		
	else
		Dialog(GwImmersiveFrame.ActiveFrame, button == "LeftButton" and 1 or -1)
	end
end

local function SetStyleFullScreen()
	-- <Layer level="ARTWORK">	
	-- 			<Texture parentKey="BottomLeft" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="BOTTOMLEFT" relativeKey="$parent" relativePoint="BOTTOMLEFT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="BottomRight" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="BOTTOMRIGHT" relativeKey="$parent" relativePoint="BOTTOMRIGHT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="TopRight" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="TOPRIGHT" relativeKey="$parent" relativePoint="TOPRIGHT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="TopLeft" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="TOPLEFT" relativeKey="$parent" relativePoint="TOPLEFT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>		
	-- 			<Texture parentKey="Left" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="LEFT" relativeKey="$parent" relativePoint="LEFT" x="0" y="0"/>
	-- 					<Anchor point="BOTTOM" relativeKey="$parent.BottomLeft" relativePoint="TOP" x="0" y="0"/>
	-- 					<Anchor point="TOP" relativeKey="$parent.TopLeft" relativePoint="BOTTOM" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="Right" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="RIGHT" relativeKey="$parent" relativePoint="RIGHT" x="0" y="0"/>
	-- 					<Anchor point="BOTTOM" relativeKey="$parent.BottomRight" relativePoint="TOP" x="0" y="0"/>
	-- 					<Anchor point="TOP" relativeKey="$parent.TopRight" relativePoint="BOTTOM" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="Bottom" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="BOTTOM" relativeKey="$parent" relativePoint="BOTTOM" x="0" y="0"/>
	-- 					<Anchor point="LEFT" relativeKey="$parent.BottomLeft" relativePoint="RIGHT" x="0" y="0"/>
	-- 					<Anchor point="RIGHT" relativeKey="$parent.BottomRight" relativePoint="LEFT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 			<Texture parentKey="Top" hidden="true">
	-- 				<Anchors>
	-- 					<Anchor point="TOP" relativeKey="$parent" relativePoint="TOP" x="0" y="0"/>
	-- 					<Anchor point="LEFT" relativeKey="$parent.TopLeft" relativePoint="RIGHT" x="0" y="0"/>
	-- 					<Anchor point="RIGHT" relativeKey="$parent.TopRight" relativePoint="LEFT" x="0" y="0"/>
	-- 				</Anchors>
	-- 			</Texture>
	-- 		</Layer>  
	-- t = {
	-- 	SHADOWLANDS = {	
	-- 		maxSizeText = 400,
	-- 		TitleHighlightTexture = "Interface/QuestFrame/UI-QuestTitleHighlight",
	-- 		Parent = {
	-- 			Border = {format = true, atlas = "UI-Frame-%s-CardParchmentWider", useAtlasSize = true},
	-- 			--MaskBorder = {atlas = "covenantchoice-celebration-background", useAtlasSize = true},
	-- 			Middleground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
	-- 			Background = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
	-- 			Foreground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
	-- 			BottomLeft = {format = true, atlas = "%s-NineSlice-CornerBottomLeft", useAtlasSize = true},	
	-- 			BottomRight = {format = true, atlas = "%s-NineSlice-CornerBottomRight", useAtlasSize = true},	
	-- 			TopRight = {format = true, atlas = "%s-NineSlice-CornerTopRight", useAtlasSize = true},
	-- 			TopLeft = {format = true, atlas = "%s-NineSlice-CornerTopLeft", useAtlasSize = true},
	-- 			Bottom = {format = true, atlas = "_%s-NineSlice-EdgeBottom", useAtlasSize = true},
	-- 			Right = {format = true, atlas = "!%s-NineSlice-EdgeRight", useAtlasSize = true},
	-- 			Left = {format = true, atlas = "!%s-NineSlice-EdgeLeft", useAtlasSize = true},
	-- 			Top = {format = true, atlas = "_%s-NineSlice-EdgeTop", useAtlasSize = true},
	-- 		},
	-- 		Title = {
	-- 			TitleLeft = {format = true, atlas = "UI-Frame-%s-TitleLeft", useAtlasSize = true},
	-- 			TitleRight = {format = true, atlas = "UI-Frame-%s-TitleRight", useAtlasSize = true},
	-- 			TitleMiddle = {format = true, atlas = "_UI-Frame-%s-TitleMiddle", useAtlasSize = true}
	-- 		},
	-- 		Dialog = {
	-- 			Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
	-- 		},
	-- 		Scroll = {
	-- 			Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
	-- 		},
	-- 		ReputationBar = {
	-- 			Background = {format = true, atlas = "covenantsanctum-level-border-%s", useAtlasSize = false, texCoord = {1, 0, 0, 0, 1, 1, 0, 1}, points = {{"TOPLEFT", -42, 59}, {"BOTTOMRIGHT", 42, -57}}},
	-- 			--Background = {atlas = "Garr_Mission_MaterialFrame", useAtlasSize = false, points = {{"TOPLEFT", -33, 15}, {"BOTTOMRIGHT", 33, -15}}},
	-- 		},
	-- 		Detail = {
	-- 			Background = {format = true, atlas = "covenantchoice-offering-parchment-%s", useAtlasSize = true},
	-- 			Title1 = {format = true, atlas = "UI-Frame-%s-Ribbon", useAtlasSize = true},
	-- 		},
	-- 	},
	-- 	CLASSIC = {
	-- 		maxSizeText = 400,
	-- 		TitleHighlightTexture = "Interface/QuestFrame/UI-QuestTitleHighlight",
	-- 		Parent = {
	-- 			Border = {format = true, atlas = "UI-Frame-%s-CardParchmentWider", useAtlasSize = true},
	-- 			MaskBorder = {atlas = "covenantchoice-celebration-background", useAtlasSize = true},
	-- 			BottomLeft = {format = true, atlas = "%s-NineSlice-CornerBottomLeft", useAtlasSize = true},	
	-- 			BottomRight = {format = true, atlas = "%s-NineSlice-CornerBottomRight", useAtlasSize = true},	
	-- 			TopRight = {format = true, atlas = "%s-NineSlice-CornerTopRight", useAtlasSize = true},
	-- 			TopLeft = {format = true, atlas = "%s-NineSlice-CornerTopLeft", useAtlasSize = true},
	-- 			Bottom = {format = true, atlas = "_%s-NineSlice-EdgeBottom", useAtlasSize = true},
	-- 			Right = {format = true, atlas = "!%s-NineSlice-EdgeRight", useAtlasSize = true},
	-- 			Left = {format = true, atlas = "!%s-NineSlice-EdgeLeft", useAtlasSize = true},
	-- 			Top = {format = true, atlas = "_%s-NineSlice-EdgeTop", useAtlasSize = true},
	-- 		},
	-- 		Title = {
	-- 			TitleLeft = {format = true, atlas = "UI-Frame-%s-TitleLeft", useAtlasSize = true},
	-- 			TitleRight = {format = true, atlas = "UI-Frame-%s-TitleRight", useAtlasSize = true},
	-- 			TitleMiddle = {format = true, atlas = "_UI-Frame-%s-TitleMiddle", useAtlasSize = true}
	-- 		},
	-- 		Dialog = {
	-- 			Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
	-- 		},
	-- 		Scroll = {
	-- 			Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
	-- 		},
	-- 		ReputationBar = {
	-- 			Border = {format = true, atlas = "Garr_Mission_MaterialFrame", useAtlasSize = true--[[ , points = {{"TOPLEFT", -35, 30}, {"BOTTOMRIGHT", 7, -10}} ]]},
	-- 			--MaskBorder = {path = "Interface/ChatFrame/UI-ChatIcon-HotS"},
	-- 		},
	-- 		Detail = {
	-- 			Background = {format = true, atlas = "covenantchoice-offering-parchment-%s", useAtlasSize = true},
	-- 			Title1 = {format = true, atlas = "UI-Frame-%s-Ribbon", useAtlasSize = true},
	-- 		},			
	-- 	}
	-- }
end

local function LoadImmersiveView()
	for _, frame in ipairs({GossipFrame, QuestFrame}) do
		frame:UnregisterAllEvents()
		frame:EnableMouse(false)
		frame:EnableKeyboard(false)
		frame:ClearAllPoints()
	end

	CreateFrame("Frame", "GwImmersiveFrame")
	GwImmersiveFrame:RegisterEvent("QUEST_GREETING")
	GwImmersiveFrame:RegisterEvent("QUEST_DETAIL")
	GwImmersiveFrame:RegisterEvent("QUEST_PROGRESS")
	GwImmersiveFrame:RegisterEvent("QUEST_COMPLETE")
	GwImmersiveFrame:RegisterEvent("QUEST_FINISHED")
	GwImmersiveFrame:RegisterEvent("QUEST_ITEM_UPDATE")
	GwImmersiveFrame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	GwImmersiveFrame:RegisterEvent("UNIT_MODEL_CHANGED")
	GwImmersiveFrame.RegisterHandler = CustomGossipManagerMixin.RegisterHandler
	GwImmersiveFrame.GetGossipHandler = CustomGossipManagerMixin.GetHandler
	CustomGossipManagerMixin.OnLoad(GwImmersiveFrame)
	CustomGossipFrameManager:UnregisterAllEvents()	

	GwImmersiveFrame:SetScript("OnEvent", GwImmersiveFrame_OnEvent)
	GwImmersiveFrame.hasActiveQuest = false
	CreateFrame("Frame", "GwFullScreenGossipViewFrame", UIParent, "GwFullScreenGossipViewFrameTemplate")
	GwFullScreenGossipViewFrame:SetScript("OnKeyDown", GwImmersiveFrames_OnKeyDown)
	if GetSetting("DYNAMIC_BACKGROUND") then 
		GwFullScreenGossipViewFrame:HookScript("OnShow", GwFullScreenGossipViewFrame_OnShow)
	end

	CreateFrame("Frame", "GwNormalScreenGossipViewFrame", UIParent, "GwNormalScreenGossipViewFrameTemplate")
	GwNormalScreenGossipViewFrame:SetScript("OnKeyDown", GwImmersiveFrames_OnKeyDown)

	if GetSetting("MOUSE_DIALOG") then
		GwNormalScreenGossipViewFrame.Dialog:SetScript("OnClick", GwNormalScreenGossipViewFrame_OnClick)
	end
	RegisterMovableFrame(GwNormalScreenGossipViewFrame, L["Immersive Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
	GwNormalScreenGossipViewFrame:ClearAllPoints()
	GwNormalScreenGossipViewFrame:SetPoint("TOPLEFT", GwNormalScreenGossipViewFrame.gwMover)
	
	GwImmersiveFrame.ActiveFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
	GwImmersiveFrame.ActiveFrame.FontColor()

	LoadTitleButtons()
	LoadDetalies()

	ModelScaling:CreateClassModel("FULLMODEL", {"CinematicModel"}, ModelScaling.defSetUnit, ModelScaling.defFullModel)
    ModelScaling:CreateSubClassModel("FULLMODEL", "RIGHT", ModelScaling.defGetPlayer, ModelScaling.defFullModelRight, ModelScaling.defFullModelOffsetRight)
    ModelScaling:CreateSubClassModel("FULLMODEL", "LEFT", ModelScaling.defGetNPC, ModelScaling.defFullModelLeft, ModelScaling.defFullModelOffsetLeft)
	ModelScaling:RegisterModel("FULLMODEL", "RIGHT", GwFullScreenGossipViewFrame.Models.Player)
	ModelScaling:RegisterModel("FULLMODEL", "LEFT", GwFullScreenGossipViewFrame.Models.Giver)

    ModelScaling:CreateClassModel("PORTRAIT", {"CinematicModel", "PlayerModel"}, ModelScaling.defSetUnit, ModelScaling.defPortrait)
    ModelScaling:CreateSubClassModel("PORTRAIT", "RIGHT", ModelScaling.defGetPlayer, ModelScaling.defPortraitRight, ModelScaling.defPortraitOffsetRight)
    ModelScaling:CreateSubClassModel("PORTRAIT", "LEFT", ModelScaling.defGetNPC, ModelScaling.defPortraitLeft, ModelScaling.defPortraitOffsetLeft)
	ModelScaling:RegisterModel("PORTRAIT", "RIGHT", GwNormalScreenGossipViewFrame.Models.Player, GwNormalScreenGossipViewFrame.Models.Player.Name.Text)
	ModelScaling:RegisterModel("PORTRAIT", "LEFT", GwNormalScreenGossipViewFrame.Models.Giver, GwNormalScreenGossipViewFrame.Models.Giver.Name.Text)
end

GW.LoadImmersiveView = LoadImmersiveView