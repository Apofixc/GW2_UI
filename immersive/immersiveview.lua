local _, GW = ...
local L = GW.L
local ModelScaling = GW.Libs.Model
local GetSetting = GW.GetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local IsIn = GW.IsIn

local ImmersiveFrameHandleShow = GW.ImmersiveFrameHandleShow
local ImmersiveFrameHandleHide = GW.ImmersiveFrameHandleHide
local GetTitleButtonPoolEnumerateActive = GW.GetTitleButtonPoolEnumerateActive
local StopAnimationDialog = GW.StopAnimationDialog
local LoadTitleButtons = GW.LoadTitleButtons
local LoadDetalies = GW.LoadDetalies
local LoadModel = GW.LoadModel
local StopAnimation = GW.StopAnimation
local FinishedAnimation = GW.FinishedAnimation
local GetCustomZoneBackground = GW.GetCustomZoneBackground

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
			if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then
				StopAnimation("IMMERSIVE_DIALOG_ANIMATION")	
				StopAnimationDialog(self)
			end
		elseif button == "F1" then
			ImmersiveFrameHandleHide(GwImmersiveFrame)			
			
			C_Timer.After(1,
				function()
					GwImmersiveFrame.ActiveFrame = self.mode == "NORMAL" and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
					GwImmersiveFrame.ActiveFrame.FontColor()
					GwImmersiveFrame_OnEvent(GwImmersiveFrame, GwImmersiveFrame.LastEvent)
				end
			)
		elseif button == "F2" then
			if self.Dialog:GetScript("OnClick") then self.Dialog:SetMouseClickEnabled(not self.Dialog:IsMouseEnabled()) end
		else 
			if self.Scroll.ScrollChildFrame:IsVisible() then
				local num = tonumber(button) 
				for obj in GetTitleButtonPoolEnumerateActive() do
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
	if FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then
		Dialog(GwImmersiveFrame.ActiveFrame, button == "LeftButton" and 1 or -1)
	else
		StopAnimation("IMMERSIVE_DIALOG_ANIMATION")		
		StopAnimationDialog(GwImmersiveFrame.ActiveFrame)
	end
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
	LoadModel()
end

GW.LoadImmersiveView = LoadImmersiveView