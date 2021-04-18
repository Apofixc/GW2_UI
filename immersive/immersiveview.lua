local _, GW = ...
local L = GW.L
local Model = GW.Libs.Model
local ModelDB = GW.Libs.ModelDB
local GetSetting = GW.GetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local IsIn = GW.IsIn
local CheckStateAnimation =  GW.CheckStateAnimation
local StopAnimation = GW.StopAnimation
local ImmersiveFrameHandleShow = GW.ImmersiveFrameHandleShow
local ImmersiveFrameHandleHide = GW.ImmersiveFrameHandleHide
local GetCustomZoneBackground = GW.GetCustomZoneBackground

local Dialog = GW.Dialog

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

		ImmersiveFrameHandleShow(self, nil, dialog)
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

		ImmersiveFrameHandleShow(self, GetTitleText(), dialog)
	elseif IsIn(event, "GOSSIP_CLOSED", "QUEST_FINISHED") then
		ImmersiveFrameHandleHide(self)
	elseif IsIn(event, "QUEST_ITEM_UPDATE", "LEARNED_SPELL_IN_TAB") then
		print("yes1")
		if IsIn(self.LastEvent, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and self.ActiveFrame.Detail:IsVisible() then
			self.ActiveFrame.Detail:Hide()
			self.ActiveFrame.Detail:Show()
		end
	elseif event == "QUEST_LOG_UPDATE" then
		if (self.LastEvent == "GOSSIP_SHOW" and self.hasActiveQuest) or self.LastEvent == "QUEST_GREETING" then
			GwImmersiveFrame_OnEvent(GwImmersiveFrame, self.LastEvent)
		end
	elseif event == "UNIT_MODEL_CHANGED" then
		local unit = ...
		if unit == "player" then
			Model:SetModel(self.ActiveFrame.Models.Player)
		else
			Model:SetModel(self.ActiveFrame.Models.Giver)
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

				GwImmersiveFrame.AutoNext = false
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

local function GwImmersiveDetail_OnShow(self)
		local template = _G["GW2_"..GwImmersiveFrame.LastEvent.."_TEMPLATE"]
		local parentFrame = self:GetParent()
		local format, mode, color = parentFrame.Format, parentFrame.mode, parentFrame.Color

		local detail = self.Scroll.ScrollChildFrame
		local detailWidth = detail:GetWidth()

		if template.canHaveSealMaterial then
			local questID = GetQuestID()
			local theme = C_QuestLog.GetQuestDetailsTheme(questID)

			QuestInfoSealFrame.theme = theme
		end

		GwImmersiveFrame.chooseItems = template.chooseItems
		GwQuestInfoRewardsFrame.rewardsHeader = true

		if GwImmersiveFrame.material ~= mode  then
			GwImmersiveFrame.material = mode
			self.Title:SetTextColor(color.r, color.g, color.b)
			GwQuestInfoObjectivesText:SetTextColor(color.r, color.g, color.b)
			QuestInfoGroupSize:SetTextColor(color.r, color.g, color.b)
			QuestInfoSealFrame.Text:SetTextColor(color.r, color.g, color.b)
			GwQuestInfoRewardsFrame.Header:SetTextColor(color.r, color.g, color.b)
			GwQuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(color.r, color.g, color.b)

			GwQuestInfoProgress.headerProgressPool.textR, GwQuestInfoProgress.headerProgressPool.textG, GwQuestInfoProgress.headerProgressPool.textB = color.r, color.g, color.b
			GwQuestInfoRewardsFrame.headerRewardsPool.textR, GwQuestInfoRewardsFrame.headerRewardsPool.textG, GwQuestInfoRewardsFrame.headerRewardsPool.textB = color.r, color.g, color.b
			GwQuestInfoRewardsFrame.spellHeaderRewardsPool.textR, GwQuestInfoRewardsFrame.spellHeaderRewardsPool.textG, GwQuestInfoRewardsFrame.spellHeaderRewardsPool.textB = color.r, color.g, color.b
			
			GwQuestInfoProgress.buttonProgressPool.style = mode
			GwQuestInfoRewardsFrame.buttonRewardPool.style = mode
		end

		if not detail.questInfoHyperlinksInstalled then
			detail.questInfoHyperlinksInstalled = true
			detail:SetHyperlinksEnabled(true)
			detail:SetScript("OnHyperlinkEnter", QuestInfo_OnHyperlinkEnter)
			detail:SetScript("OnHyperlinkLeave", QuestInfo_OnHyperlinkLeave)
		end

		QuestInfoSealFrame:Hide()
		QuestInfoSpecialObjectivesFrame:Hide()
		QuestInfoGroupSize:Hide()
		GwQuestInfoRewardsFrame:Hide()
		GwQuestInfoProgress:Hide()
		GwQuestInfoObjectivesText:Hide()

		local lastFrame = nil
		local totalHeight = 0
		local element = template.elements
		for i = 1, #element do
			local shownFrame = element[i](format, template.rewardsHeader)
			if shownFrame then
				shownFrame:ClearAllPoints()
				shownFrame:SetParent(detail)
				shownFrame:SetWidth(detailWidth)
				if lastFrame then
					shownFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
				else
					shownFrame:SetPoint("TOPLEFT", detail, "TOPLEFT", 0, 0)
				end

				shownFrame:Show()
				lastFrame = shownFrame
				totalHeight = totalHeight + shownFrame:GetHeight() + 5
			end
		end
		
		if totalHeight > 0 then
			self.Title:SetText(template.title)
			self.Scroll.ScrollBar:SetValue(0)
			self.Scroll.ScrollChildFrame:SetHeight(totalHeight)	
		else
			self:Hide()
		end
end

local function GwImmersiveDetail_OnHide(self)

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
	GwImmersiveFrame.LoadDetail = true
	local GwFullScreenGossipViewFrame = CreateFrame("Frame", nil, UIParent, "GwFullScreenGossipViewFrameTemplate")
	GwFullScreenGossipViewFrame:SetScript("OnKeyDown", GwImmersiveFrames_OnKeyDown)
	GwFullScreenGossipViewFrame.Detail:SetScript("OnShow", GwImmersiveDetail_OnShow)
	GwFullScreenGossipViewFrame.Detail:SetScript("OnHide", GwImmersiveDetail_OnHide)
	if GetSetting("DYNAMIC_BACKGROUND") then 
		GwFullScreenGossipViewFrame:HookScript("OnShow", GwFullScreenGossipViewFrame_OnShow)
	end

	local GwNormalScreenGossipViewFrame = CreateFrame("Frame", nil, UIParent, "GwNormalScreenGossipViewFrameTemplate")
	GwNormalScreenGossipViewFrame:SetScript("OnKeyDown", GwImmersiveFrames_OnKeyDown)
	GwNormalScreenGossipViewFrame.Detail:SetScript("OnShow", GwImmersiveDetail_OnShow)
	GwNormalScreenGossipViewFrame.Detail:SetScript("OnHide", GwImmersiveDetail_OnHide)
	if GetSetting("MOUSE_DIALOG") then
		GwNormalScreenGossipViewFrame.Dialog:SetScript("OnClick", GwNormalScreenGossipViewFrame_OnClick)
	end
	RegisterMovableFrame(GwNormalScreenGossipViewFrame, L["Dialog Immersive Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
	GwNormalScreenGossipViewFrame:ClearAllPoints()
	GwNormalScreenGossipViewFrame:SetPoint("TOPLEFT", GwNormalScreenGossipViewFrame.gwMover)

	local FramePool_HideAndClearAnchors = function(framePool, frame)
		frame:Hide()
		frame:ClearAllPoints()
		frame.Icon:SetTexCoord(0, 1, 0, 1)
	end

	GwImmersiveFrame.TitleButtonPool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate", FramePool_HideAndClearAnchors)
	QuestInfoFrame:CreateFontString("GwQuestInfoObjectivesText", "BACKGROUND", "QuestFontLeft")
	CreateFrame("Frame", "GwQuestInfoProgress",nil, "GwQuestInfoProgress")
	CreateFrame("Frame", "GwQuestInfoRewardsFrame",nil, "GwQuestInfoRewardsFrame")

	Model:CreateClassModel("FULLMODEL", {"CinematicModel"}, ModelDB.defSetUnit, ModelDB.defFullModel)
    Model:CreateSubClassModel("FULLMODEL", "RIGHT", ModelDB.defGetPlayer, ModelDB.defFullModelRight, ModelDB.defFullModelOffsetRight)
    Model:CreateSubClassModel("FULLMODEL", "LEFT", ModelDB.defGetNPC, ModelDB.defFullModelLeft, ModelDB.defFullModelOffsetLeft)
	Model:RegisterModel("FULLMODEL", "RIGHT", GwFullScreenGossipViewFrame.Models.Player)
	Model:RegisterModel("FULLMODEL", "LEFT", GwFullScreenGossipViewFrame.Models.Giver)
	Model:CreateClassAnimation("FULLMODEL", "RIGHT", {[60] = 60}, "LEFT", {[60] = 60} )
	Model:RegisterSyncAnimation("FULLMODEL", GwFullScreenGossipViewFrame.Models.Player, GwFullScreenGossipViewFrame.Models.Giver)

    Model:CreateClassModel("PORTRAIT", {"CinematicModel", "PlayerModel"}, ModelDB.defSetUnit, ModelDB.defPortrait)
    Model:CreateSubClassModel("PORTRAIT", "RIGHT", ModelDB.defGetPlayer, ModelDB.defPortraitRight, ModelDB.defPortraitOffsetRight)
    Model:CreateSubClassModel("PORTRAIT", "LEFT", ModelDB.defGetNPC, ModelDB.defPortraitLeft, ModelDB.defPortraitOffsetLeft)
	Model:RegisterModel("PORTRAIT", "RIGHT", GwNormalScreenGossipViewFrame.Models.Player, GwNormalScreenGossipViewFrame.Models.Player.Name.Text, ModelDB.defGetNamePlayer)
	Model:RegisterModel("PORTRAIT", "LEFT", GwNormalScreenGossipViewFrame.Models.Giver, GwNormalScreenGossipViewFrame.Models.Giver.Name.Text, ModelDB.defGetNameNPC)
	Model:CreateClassAnimation("PORTRAIT", "RIGHT", {[60] = 60}, "LEFT", {[60] = 60} )
	Model:RegisterSyncAnimation("PORTRAIT", GwNormalScreenGossipViewFrame.Models.Player, GwNormalScreenGossipViewFrame.Models.Giver)

	GwImmersiveFrame.ActiveFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
	GwImmersiveFrame.UnActiveFrame = GetSetting("FULL_SCREEN") and GwNormalScreenGossipViewFrame or GwFullScreenGossipViewFrame
	GwImmersiveFrame.ActiveFrame.FontColor()

	GwImmersiveFrame.ForceFrame = GwNormalScreenGossipViewFrame
end

GW.LoadImmersiveView = LoadImmersiveView
