local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local IsIn = GW.IsIn
local FadeAnimation = GW.FadeAnimation
local DialogAnimation =  GW.DialogAnimation
local FreeAnimation = GW.FreeAnimation
local FinishedAnimation = GW.FinishedAnimation
local ImmersiveDinamicArt = GW.ImmersiveDinamicArt
local LoadImmersiveModelInfo = GW.LoadImmersiveModelInfo
local SetImmersiveUnitModel = GW.SetImmersiveUnitModel
local ImmersiveDebugModel = GW.ImmersiveDebugModel

C_GossipInfo.ForceGossip = function() return GetSetting("FORCE_GOSSIP") end

---------------------------------------------------------------------------------------------------------------------
----------------------------------------------- INTERACTIVE ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local INTERACTIVE_TEXT = {
	ACCEPT = {ACCEPT},
	DECLINE = {DECLINE},
	NEXT = {NEXT, CONTINUE},
	BACK = {BACK},
	CANCEL = {EXIT, CANCEL},
	EXIT = {EXIT, GOODBYE},
	COMPLETE = {COMPLETE, COMPLETE_QUEST},
	FINISH = {FINISH},
	RESET = {RESET}
}

local function GetImmersiveInteractiveText(buttonType)
	return INTERACTIVE_TEXT[buttonType][math.random(1, #INTERACTIVE_TEXT[buttonType])]
end

local LastEvent
local ACTIVE_TEMPLATE

local TitleButtonPool
local hasActiveQuest = false
local SHOW_TITLE_BUTTON

local AutoNext
local DIALOG_STRINGS_CURRENT
local DIALOG_STRINGS

local function QuestInfo_StyleDetail(template)
	local totalHeight = 0
	local elementsTable = template.frames

	for i = 1, #elementsTable, 2 do
		if _G[elementsTable[i]]:IsShown() then
			if elementsTable[i] == "QuestInfoRewardsFrame" then
				local lastFrame = QuestInfoRewardsFrame.Header
				local height = lastFrame:GetHeight()
			
				for _, frame in ipairs({"QuestSessionBonusReward", "ItemReceiveText", "MoneyFrame", "XPFrame", "ArtifactXPFrame", "WarModeBonusFrame", "HonorFrame", "SkillPointFrame", "PlayerTitleText", "TitleFrame", "ItemChooseText"}) do
					if QuestInfoRewardsFrame[frame] and QuestInfoRewardsFrame[frame]:IsShown() then
						QuestInfoRewardsFrame[frame]:ClearAllPoints()
						QuestInfoRewardsFrame[frame]:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
						lastFrame = QuestInfoRewardsFrame[frame]
						height = height + lastFrame:GetHeight() + 5
					end
				end
				
				for _, obj in ipairs(QuestInfoRewardsFrame.collectionObjectFromPolls) do
					obj:ClearAllPoints()
					obj:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)	
					lastFrame = obj
					height = height + lastFrame:GetHeight() + 5
				end
				
				for i, questItem in ipairs(QuestInfoRewardsFrame.RewardButtons) do
					if questItem:IsShown() then
						questItem:ClearAllPoints()
						questItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", i == 1 and 5 or 0, -5)
						lastFrame = questItem
						height = height + lastFrame:GetHeight() + 5
					end
				end
			
				QuestInfoRewardsFrame:SetHeight(height)
			end

			if elementsTable[i] == "GwQuestInfoProgress" then
				local height = 0
				local lastFrame 
				if QuestInfoRequiredMoneyFrame:IsShown() then
					height = height + QuestInfoRequiredMoneyFrame:GetHeight()
					lastFrame = QuestInfoRequiredMoneyFrame
				end

				for _, obj in ipairs(GwQuestInfoProgress.collectionObjectFromPolls) do
					obj:ClearAllPoints()
					obj:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)	
					lastFrame = obj
					height = height + lastFrame:GetHeight() + 5
				end
			end

			totalHeight = totalHeight + _G[elementsTable[i]]:GetHeight() + elementsTable[i + 1]
		end
	end

	return totalHeight
end

local function ShownDetail(parentFrame, formatShow)
	for _, frame in ipairs({QuestInfoObjectivesText, QuestInfoSpecialObjectivesFrame, QuestInfoGroupSize, QuestInfoSpecialObjectivesFrame, QuestInfoRewardsFrame, GwQuestInfoProgress}) do
		frame:ClearAllPoints()
		frame:Hide()
	end

	ACTIVE_TEMPLATE.contentWidth = parentFrame:GetWidth()
	QuestInfo_Display(ACTIVE_TEMPLATE, parentFrame)

	return formatShow(template)
end

local function TitleButtonShow(self, event, start, finish, current)
	local firstElement = current == start
	local lastElement = current == finish
	local totalHeight = 0

	TitleButtonPool:ReleaseAll()

	for id, value in ipairs(SHOW_TITLE_BUTTON) do
		if value.show(event, firstElement, lastElement) then
			for titleIndex, info in pairs(value.getInfo()) do
				local button = TitleButtonPool:Acquire() 
				local numActiveButton = TitleButtonPool:GetNumActive()
				button:SetParent(self.Scroll.ScrollChildFrame)
				button:SetHighlightTexture(self.titleHighlightTexture)
				button:SetPoint('TOPLEFT', self.Scroll.ScrollChildFrame, 'TOPLEFT', 0, -totalHeight)
				button:Show()		
				
				if value.type == "AVAILABLE" then
					button:SetQuest(numActiveButton..". "..info.title, info.questLevel, info.isTrivial, info.frequency, info.repeatable, info.isLegendary, info.isIgnored, info.questID)
				elseif value.type == "ACTIVE" then
					button:SetActiveQuest(numActiveButton..". "..info.title, info.questLevel, info.isTrivial, info.isComplete, info.isLegendary, info.isIgnored, info.questID)
				elseif value.type == "GOSSIP" then
					button:SetOption(numActiveButton..". "..info.name, info.type, info.spellID)
				else
					button:SetAction(numActiveButton..". "..info.name, info.icon)
				end

				button:AddCallbackForClick(numActiveButton, value.callBack, id < 6 and titleIndex or value.arg, value.playSound)
				totalHeight = totalHeight + button:GetHeight() + 5						
			end
		end
	end

	if IsIn(event, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and lastElement then
		if not self.Detail:IsVisible() then
			ACTIVE_TEMPLATE = _G["GW2_"..event.."_TEMPLATE"]
			self.Detail.Scroll.ScrollBar:SetValue(0)
			self.Detail.Title:SetText(ACTIVE_TEMPLATE.title)
			local height = ShownDetail(self.Detail.Scroll.ScrollChildFrame, QuestInfo_StyleDetail)
			self.Detail.Scroll.ScrollChildFrame:SetHeight(height)
			self.Detail:SetShown(height > 0)
		end
	else
		if self.Detail:IsVisible() then
			self.Detail:Hide()
		end
	end

	self.Scroll.ScrollBar:SetValue(0)
	self.Scroll.ScrollBar:SetAlpha(0)
	self.Scroll.ScrollChildFrame:SetHeight(totalHeight)
end

---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DIALOG ----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function StopAnimationDialog(immersiveFrame)
	AutoNext = false;

	immersiveFrame.Dialog.Text:SetAlphaGradient(immersiveFrame.maxSizeText, 1);
	immersiveFrame.Scroll.ScrollChildFrame:Show();	
	immersiveFrame.Scroll.ScrollBar:SetAlpha(1);	
end

local function Split(text, maxSizeText, mode)
	DIALOG_STRINGS = {}
	DIALOG_STRINGS_CURRENT = 0
	AutoNext = GetSetting("AUTO_NEXT")

	local unitName = format("|cFFFF5A00%s|r ", (mode == "FULL_SCREEN") and UnitName("npc")..": " or "")

	for _, value in ipairs({ strsplit('\n', text)}) do
		if strtrim(value) ~= "" then
			local strLen = strlenutf8(value)

			if strLen < maxSizeText then
				table.insert(DIALOG_STRINGS, unitName..value)
			else
				local sizePart = math.ceil(strLen/math.ceil(strLen/maxSizeText))
				local forceInsert = false
				local new = ""

				for key, newValue in ipairs({ strsplit('\n', value:gsub('%.%s%.%s%.', '...'):gsub('%.%s+', '.\n'):gsub('%.%.%.\n', '...\n...'):gsub('%!%s+', '!\n'):gsub('%?%s+', '?\n')) }) do
					if strtrim(newValue) ~= "" then
						local size = strlenutf8(new) + strlenutf8(newValue) + 1

						if size < maxSizeText and not forceInsert then
							new = new.." "..newValue
							if size >= sizePart then forceInsert = true	end
						else
							table.insert(DIALOG_STRINGS, unitName..new)
							forceInsert = false
							new = newValue
						end
					end
				end

				if new ~= "" then table.insert(DIALOG_STRINGS, unitName..new) end
			end
		end
	end
end

local function Dialog(immersiveFrame, operation)
	if DIALOG_STRINGS_CURRENT and FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") and tonumber(operation) then
		DIALOG_STRINGS_CURRENT = DIALOG_STRINGS_CURRENT + operation

		if not DIALOG_STRINGS[DIALOG_STRINGS_CURRENT] then 
			DIALOG_STRINGS_CURRENT = DIALOG_STRINGS_CURRENT - operation
			return 
		end

		immersiveFrame.Dialog.Text:SetText(DIALOG_STRINGS[DIALOG_STRINGS_CURRENT])

		local sColor, name, fColor = string.match(DIALOG_STRINGS[DIALOG_STRINGS_CURRENT], "^(%p%x+)(.*)(%p%a)")
		local StartAnimation = strlenutf8(name)
		local lenghtAnimation = strlenutf8(DIALOG_STRINGS[DIALOG_STRINGS_CURRENT]) - strlenutf8(sColor) - strlenutf8(fColor)
		local funcFinish = function()
			if AutoNext and DIALOG_STRINGS_CURRENT < #DIALOG_STRINGS then
				C_Timer.After(GetSetting("AUTO_NEXT_TIME"), 
					function() 
						if AutoNext and immersiveFrame:IsVisible() then Dialog(immersiveFrame, 1) end	
					end
				)
			else
				StopAnimationDialog(immersiveFrame)
			end
		end
		DialogAnimation(immersiveFrame.Dialog.Text, "IMMERSIVE_DIALOG_ANIMATION", StartAnimation, lenghtAnimation, GetSetting("ANIMATION_TEXT_SPEED_N") * lenghtAnimation, funcFinish)

		TitleButtonShow(immersiveFrame, LastEvent, 1, #DIALOG_STRINGS, DIALOG_STRINGS_CURRENT);
	end
end

---------------------------------------------------------------------------------------------------------------------
----------------------------------------------- SHOW / HIDE ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function ImmersiveFrameHandleShow(immersiveFrame, title, dialog)	
	immersiveFrame:Show()
	FadeAnimation(immersiveFrame, immersiveFrame:GetName(), immersiveFrame:GetAlpha(), 1, 0.2)
		
	immersiveFrame.ReputationBar:Show()
	SetImmersiveUnitModel(immersiveFrame.Models.Player, "player")
	SetImmersiveUnitModel(immersiveFrame.Models.Giver, UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none")

	if title then
		immersiveFrame.Title.Text:SetText(title)
		FadeAnimation(immersiveFrame.Title, "IMMERSIVE_TITLE_ANIMATION", immersiveFrame.Title:GetAlpha(), 1, 0.3)
	else
		if not FinishedAnimation("IMMERSIVE_TITLE_ANIMATION") then FreeAnimation("IMMERSIVE_TITLE_ANIMATION") end
		immersiveFrame.Title:SetAlpha(0)
	end

	Split(dialog, immersiveFrame.maxSizeText, immersiveFrame.mode);
	Dialog(immersiveFrame, 1)
end

local function ImmersiveFrameHandleHide(self)
	if (self.customFrame) then
		self.customFrame:Hide()
		self.customFrame = nil	
	elseif self.ActiveFrame:IsShown() then
		if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then FreeAnimation("IMMERSIVE_DIALOG_ANIMATION") end
		if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") then FreeAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") end
		if not FinishedAnimation("IMMERSIVE_TITLE_ANIMATION") then FreeAnimation("IMMERSIVE_TITLE_ANIMATION") end

		local funcFinish = function()
			self.ActiveFrame:Hide()
			self.ActiveFrame.Scroll.Icon:Hide()
			self.ActiveFrame.Scroll.Text:Hide()
			self.ActiveFrame.Scroll.ScrollChildFrame:Hide()
			self.ActiveFrame.Detail:Hide()
		end

		FadeAnimation(self.ActiveFrame, self.ActiveFrame:GetName(), self.ActiveFrame:GetAlpha(), 0, 0.5, funcFinish)
	end
end

---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- LOAD ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function LoadTitleButtons()
	AdvanceGossipTitleButtonMixin = {}

	function AdvanceGossipTitleButtonMixin:SetAction(titleText, icon)
		self.type = "Action"

		self:SetFormattedText(ACTION_DISPLAY, titleText)
		self.Icon:SetTexture("Interface/AddOns/GW2_UI/textures/gossipview/icon-gossip")
		self.Icon:SetTexCoord(0.25 * floor(icon / 4), 0.25 * (floor(icon / 4) + 1), 0.25 * (icon % 4), 0.25 * ((icon % 4) + 1))
		self.Icon:SetVertexColor(1, 1, 1, 1)
	
		self:Resize()
	end
	
	function AdvanceGossipTitleButtonMixin:AddCallbackForClick(id, func, arg, playSound)
		self:SetID(id)

		self.func = func
		self.arg = arg
		self.playSound = playSound
	end

	function AdvanceGossipTitleButtonMixin:Resize()
		self:SetHeight(math.max(self:GetTextHeight() + 2, self.Icon:GetHeight()))
		self:SetWidth(self:GetParent():GetWidth())
	end

	function AdvanceGossipTitleButtonMixin:OnClick()
		if FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") and self.func and not self.ShowIn:IsPlaying() then
			local scroll = self:GetParent():GetParent()
			scroll.ScrollBar:SetAlpha(0)
			scroll.ScrollChildFrame:Hide()
			
			if scroll.Icon.SetText then scroll.Icon:SetText("|cFFFF5A00"..UnitName("player")..": ") end			
			scroll.Icon:Show()

			scroll.Text:SetText(self:GetText():gsub("^.*%d+%p%s", ""))
			scroll.Text:Show()

			local lenghtText = strlenutf8(scroll.Text:GetText())
			local funcFinish = function()
				self.func(self.arg)
				PlaySound(self.playSound)
			end

			DialogAnimation(scroll.Text, "IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON", 0, lenghtText, GetSetting("ANIMATION_TEXT_SPEED_P") * lenghtText, funcFinish)
		end
	end 

	local function FramePool_HideAndClear(framePool, frame)
		frame:Hide()
		frame:ClearAllPoints()
		frame.Icon:SetTexCoord(0, 1, 0, 1)
	end

	TitleButtonPool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate", FramePool_HideAndClear)

	local function GetAvailableQuests() return C_GossipInfo.GetAvailableQuests() end
	local function GetOptions() return C_GossipInfo.GetOptions() end		

	local function GetActiveQuests()
		local GossipQuests = C_GossipInfo.GetActiveQuests()  
		hasActiveQuest = #GossipQuests > 0
		return GossipQuests
	end

	local function GetGreetingAvailableQuests()
		local info ={}
		local GreetingAvailableQuests = GetNumAvailableQuests();
		for ID = 1, GreetingAvailableQuests do
			local title, isTrivial, frequency, isRepeatable, isLegendary, questID, questLevel = GetAvailableTitle(ID), GetAvailableQuestInfo(ID), GetActiveLevel(ID)
			tinsert(info, {title = title, questLevel = questLevel, isTrivial = isTrivial, frequency = frequency, isRepeatable = isRepeatable, isLegendary = isLegendary, questID = questID})
		end

		return info
	end

	local function GetGreetingActiveQuests()
		local info ={}
		local GreetingActiveQuests = GetNumActiveQuests();
		for ID = 1, GreetingActiveQuests do
			local title, isComplete, questID, isTrivial, isLegendary, questLevel = GetActiveTitle(ID), GetActiveQuestID(ID), IsActiveQuestTrivial(ID), IsActiveQuestLegendary(ID), GetAvailableLevel(ID)
			tinsert(info, {title = title, questLevel = questLevel, isComplete = isComplete, isTrivial = isTrivial, isLegendary = isLegendary, questID = questID})
		end

		return info
	end	

	local function GetAction(typeAction, icon)
		local info = {}
		tinsert(info, {name = GetImmersiveInteractiveText(typeAction), icon = icon})

		return info
	end

	local function Accept()
		if QuestFlagsPVP() then
			StaticPopup_Show('CONFIRM_ACCEPT_PVP_QUEST')
		else
			if QuestGetAutoAccept() then
				AcknowledgeAutoAcceptQuest()
			else
				AcceptQuest()
			end
		end
	end

	local function Finish()
		local numQuestChoices = GetNumQuestChoices()
		if numQuestChoices > 1 then
			QuestChooseRewardError()
		else
			if numQuestChoices == 1 then QuestInfoFrame.itemChoice = 1 end

			GetQuestReward(QuestInfoFrame.itemChoice)
		end
	end

	local function Next() Dialog(GwImmersiveFrame.ActiveFrame, 1) end
	local function Back() Dialog(GwImmersiveFrame.ActiveFrame, -1) end
	local function Repeat() 
		DIALOG_STRINGS_CURRENT = 0
		AutoNext = GetSetting("AUTO_NEXT")
		Dialog(GwImmersiveFrame.ActiveFrame, 1) 
	end

	local function ShowAvailable(event, firstElement, lastElement) return lastElement and event == "GOSSIP_SHOW" end
	local function ShowGreetingAvailable(event, firstElement, lastElement) return lastElement and event == "QUEST_GREETING" end
	local function ShowActive(event, firstElement, lastElement) return lastElement and event == "GOSSIP_SHOW" end
	local function ShowGreetingActive(event, firstElement, lastElement) return lastElement and event == "QUEST_GREETING" end
	local function ShowGossip(event, firstElement, lastElement) return lastElement and event == "GOSSIP_SHOW" end
	local function ShowAccept(event, firstElement, lastElement) return lastElement and event == "QUEST_DETAIL" end
	local function ShowDecline(event, firstElement, lastElement) return lastElement and event == "QUEST_DETAIL" and not QuestGetAutoAccept() end
	local function ShowComplete(event, firstElement, lastElement) return lastElement and event == "QUEST_PROGRESS" and IsQuestCompletable() end
	local function ShowFinish(event, firstElement, lastElement) return lastElement and event == "QUEST_COMPLETE" and GetNumQuestChoices() <= 1 end
	local function ShowNext(event, firstElement, lastElement) return not lastElement end 
	local function ShowBack(event, firstElement, lastElement) return not firstElement end
	local function ShowCancel(event, firstElement, lastElement) return IsIn(event, "QUEST_GREETING", "QUEST_PROGRESS", "QUEST_COMPLETE") end
	local function ShowExit(event, firstElement, lastElement) return event == "GOSSIP_SHOW" end
	local function ShowRepeat(event, firstElement, lastElement) return lastElement and false end

	SHOW_TITLE_BUTTON = {
		{ type = "AVAILABLE", show = ShowAvailable, callBack = C_GossipInfo.SelectAvailableQuest, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT, getInfo = GetAvailableQuests },
		{ type = "AVAILABLE", show = ShowGreetingAvailable, callBack = SelectAvailableQuest, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT, getInfo = GetGreetingAvailableQuests },
		{ type = "ACTIVE", show = ShowActive, callBack = C_GossipInfo.SelectActiveQuest, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT, getInfo = GetActiveQuests },
		{ type = "ACTIVE", show = ShowGreetingActive, callBack = SelectActiveQuest, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT, getInfo = GetGreetingActiveQuests },
		{ type = "GOSSIP", show = ShowGossip, callBack = C_GossipInfo.SelectOption, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT, getInfo = GetOptions },
		{ type = "ACCEPT", show = ShowAccept, callBack = Accept, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("ACCEPT", 0) end },
		{ type = "DECLINE", show = ShowDecline, callBack = DeclineQuest, playSound = SOUNDKIT.IG_QUEST_CANCEL, getInfo = function() return GetAction("DECLINE", 1) end },
		{ type = "COMPLETE", show = ShowComplete, callBack = CompleteQuest, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("COMPLETE", 2) end },
		{ type = "FINISH", show = ShowFinish, callBack = Finish, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("FINISH", 3) end },
		{ type = "NEXT", show = ShowNext, callBack = Next, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("NEXT", 4) end },
		{ type = "BACK", show = ShowBack, callBack = Back, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("BACK", 5) end },
		{ type = "CANCEL", show = ShowCancel, callBack = CloseQuest, playSound = SOUNDKIT.IG_QUEST_LIST_CLOSE, getInfo = function() return GetAction("CANCEL", 6) end},
		{ type = "EXIT", show = ShowExit, callBack = C_GossipInfo.CloseGossip, playSound = SOUNDKIT.IG_QUEST_LIST_CLOSE, getInfo = function() return GetAction("EXIT", 7) end},
		{ type = "RESET", show = ShowRepeat, callBack = Repeat, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN, getInfo = function() return GetAction("REPEAT", 8) end}
	}
end

local function LoadDetalies()
	local CollectionMixin = {}

	function CollectionMixin:Acquire()
		local obj = ObjectPoolMixin.Acquire(self)
		tinsert(self.collection, obj)
		
		return obj
	end

	function CollectionMixin:Release(obj)
		for index, objCollection in ipairs(self.collection) do
			if objCollection == obj then 
				tremove(self.collection, index) 
				break
			end
		end

		ObjectPoolMixin.Release(self, obj)
	end

	local function CreatePool(typePool, ...)
		local pool

		if typePool == "Button" then
			local parent, frameTemplate = ...

			pool = CreateFromMixins(FramePoolMixin, CollectionMixin)
			pool:OnLoad("BUTTON", parent, frameTemplate, FramePool_HideAndClearAnchors)
		elseif typePool == "FontString" then
			local parent, layer, subLayer, fontStringTemplate = ...

			pool = CreateFromMixins(FontStringPoolMixin, CollectionMixin)
			pool:OnLoad(parent, layer, subLayer, fontStringTemplate, FontStringPool_HideAndClearAnchors)
		end
		pool.collection = QuestInfoRewardsFrame.collectionObjectFromPolls

		return pool
	end

	QuestInfoRewardsFrame.collectionObjectFromPolls = {}
	QuestInfoRewardsFrame.spellRewardPool = CreatePool("Button", QuestInfoRewardsFrame, "QuestSpellTemplate, QuestInfoRewardSpellCodeTemplate")
	QuestInfoRewardsFrame.followerRewardPool = CreatePool("Button", QuestInfoRewardsFrame, "LargeQuestInfoRewardFollowerTemplate")
	QuestInfoRewardsFrame.spellHeaderPool = CreatePool("FontString", QuestInfoRewardsFrame, "BACKGROUND", 0, "QuestInfoSpellHeaderTemplate")

	CreateFrame("Frame", "GwQuestInfoProgress", QuestInfoFrame)
	GwQuestInfoProgress.collectionObjectFromPolls = {}
	GwQuestInfoProgress.progressHeaderPool = CreatePool("FontString", GwQuestInfoProgress, "BACKGROUND", 0, "QuestInfoSpellHeaderTemplate")
	GwQuestInfoProgress.progressButtonPool = CreatePool("Button", GwQuestInfoProgress, "QuestItemTemplate")

	local function QuestInfo_ShowHookObjectivesText()
		local objectivesText = QuestInfo_ShowObjectivesText()
		objectivesText:Show()

		return objectivesText
	end
	
	local function QuestInfo_ShowProgressRequired()
		GwQuestInfoProgress:SetWidth(ACTIVE_TEMPLATE.contentWidth)
		GwQuestInfoProgress.progressButtonPool:ReleaseAll()
		GwQuestInfoProgress.progressHeaderPool:ReleaseAll()

		local lastAnchorElement
		local totalHeight = 0	

		local requiredMoney = GetQuestMoneyToGet()
		if requiredMoney > 0 then
			MoneyFrame_Update("QuestInfoRequiredMoneyDisplay", requiredMoney)
			if requiredMoney > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0, 0, 0)
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "red")
			else
				QuestInfoRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
				SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "white")
			end

			QuestInfoRequiredMoneyFrame:SetPoint("TOPLEFT", 0, -5)
			QuestInfoRequiredMoneyFrame:SetParent(GwQuestInfoProgress)
			QuestInfoRequiredMoneyFrame:Show()

			lastAnchorElement = QuestInfoRequiredMoneyFrame
			totalHeight = totalHeight + QuestInfoRequiredMoneyFrame:GetHeight() + 5
		else
			QuestInfoRequiredMoneyFrame:Hide()
		end

		local progress = {
			{GetNumQuestRequired = GetNumQuestItems, Name = ITEMS, IsHidden = IsQuestItemHidden, objectType = "item", GetQuestInfo = GetQuestItemInfo}, 
			{GetNumQuestRequired = GetNumQuestCurrencies, Name = CURRENCY, IsHidden = function() return 0 end, objectType = "currency", GetQuestInfo = GetQuestCurrencyInfo }
		}

		for _, required  in ipairs(progress) do
			local numRequired = required.GetNumQuestRequired()
			if numRequired > 0 then
				local numButton = 0
				local header = GwQuestInfoProgress.progressHeaderPool:Acquire()
				header:SetText(required.Name)

				if lastAnchorElement then
					header:SetPoint("TOPLEFT", lastAnchorElement, "BOTTOMLEFT", 0, -5)
				else
					header:SetPoint("TOPLEFT", 0, -5)
				end

				header:Show()
				totalHeight = totalHeight + header:GetHeight() + 5
				lastAnchorElement = header

				for i = 1, numRequired do
					local hidden = required.IsHidden(i)
					if hidden == 0 then
						local requiredItem = GwQuestInfoProgress.progressButtonPool:Acquire()
						numButton = numButton + 1
						requiredItem.type = "required"
						requiredItem.objectType = required.objectType
						requiredItem:SetID(i)
						local name, texture, numItems = required.GetQuestInfo(requiredItem.type, 1)
						SetItemButtonCount(requiredItem, numItems)
						SetItemButtonTexture(requiredItem, texture)
						requiredItem:Show()
						requiredItem.Name:SetText(name)
		
						if numButton % 2 == 1 then
							requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "BOTTOMLEFT", 0, -5)
							lastAnchorElement = requiredItem
							totalHeight = totalHeight + requiredItem:GetHeight() + 5
						else
							requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "TOPRIGHT", 1, 0)
						end
					end
				end

				if numButton == 0 then
					totalHeight = totalHeight - header:GetHeight() - 5
					GwQuestInfoProgress.progressHeaderPool:Release(header)
					lastAnchorElement = QuestInfoRequiredMoneyFrame:IsShown() and QuestInfoRequiredMoneyFrame or nil 
				end
			end
		end
	
		if totalHeight > 0 then
			GwQuestInfoProgress:SetHeight(totalHeight)
			GwQuestInfoProgress:Show()

			return GwQuestInfoProgress
		else
			GwQuestInfoProgress:Hide()

			return nil	
		end
	end
	
	GW2_QUEST_DETAIL_TEMPLATE = {
		chooseItems = nil, canHaveSealMaterial = false, title = QUEST_DETAILS,
		elements = {		
			QuestInfo_ShowHookObjectivesText, 0, 0,
			QuestInfo_ShowSpecialObjectives, 0, -10,
			QuestInfo_ShowGroupSize, 0, -10,
			QuestInfo_ShowRewards, 0, -15,
		},
		frames = {
			"QuestInfoObjectivesText", 0,
			"QuestInfoSpecialObjectivesFrame", 10,
			"QuestInfoGroupSize", 10,
			"QuestInfoRewardsFrame", 15
		}
	}

	GW2_QUEST_PROGRESS_TEMPLATE = {
		chooseItems = nil, canHaveSealMaterial = false, title = QUEST_OBJECTIVES,
		elements = {
			QuestInfo_ShowProgressRequired, 0, 0
		},
		frames = {
			"GwQuestInfoProgress", 0
		}	
	}

	GW2_QUEST_COMPLETE_TEMPLATE = {
		chooseItems = true, canHaveSealMaterial = false, title = QUEST_REWARDS,
		elements = {
			QuestInfo_ShowRewards, 0, 0,
		},
		frames = {
			"QuestInfoRewardsFrame", 0
		}
	}

	function QuestInfoItem_OnClick(self)
		if self.type == "choice" then
			if QuestInfoFrame.itemChoice == self:GetID() then
				GetQuestReward(QuestInfoFrame.itemChoice)
			else
				QuestInfoItemHighlight:SetPoint("TOPLEFT", self, "TOPLEFT", -8, 7)
				QuestInfoItemHighlight:Show()
				QuestInfoFrame.itemChoice = self:GetID()
			end
		end
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
	GwImmersiveFrame:SetScript("OnEvent", 
		function (self, event, ...)
			if IsIn(event, "QUEST_ITEM_UPDATE", "QUEST_LOG_UPDATE", "LEARNED_SPELL_IN_TAB", "UNIT_MODEL_CHANGED") and not self.ActiveFrame:IsShown() then return end

			if not IsIn(event, "QUEST_ITEM_UPDATE", "QUEST_LOG_UPDATE", "LEARNED_SPELL_IN_TAB", "UNIT_MODEL_CHANGED") then
				if LastEvent == "GOSSIP_SHOW" and event:match('^QUEST') then C_GossipInfo.CloseGossip() end

				LastEvent = event
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
				if IsIn(LastEvent, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and self.ActiveFrame.Detail:IsVisible() then
					self.ActiveFrame.Detail:Hide()
					self.ActiveFrame.Detail.Scroll.ScrollBar:SetValue(0)
					self.ActiveFrame.Detail:SetShown(ShownDetail(LastEvent, self.ActiveFrame.Detail.Scroll.ScrollChildFrame))
				end
			elseif event == "QUEST_LOG_UPDATE" then
				if (LastEvent == "GOSSIP_SHOW" and hasActiveQuest) or LastEvent == "QUEST_GREETING" then
					pcall(self:GetScript("OnEvent"), self, LastEvent)
				end
			elseif event == "UNIT_MODEL_CHANGED" then
				local unit = ...
				if unit == "player" then
					SetUnitModel(self.ActiveFrame.Models.Player, unit)
				else
					SetUnitModel(self.ActiveFrame.Models.Giver, unit)
				end
			end
		end 
	)

	for _, name in ipairs({"GwFullScreen", "GwNormalScreen"}) do
		local gF = CreateFrame("Frame", name.."GossipViewFrame", UIParent, name.."GossipViewFrameTemplate")
		gF:SetScript("OnKeyDown", 
			function (self, button)
				if IsIn(button, "ESCAPE", "SPACE", "F1", "F2") or tonumber(button) then
					if button == "ESCAPE" then
						if not QuestGetAutoAccept() then
							CloseQuest()
							C_GossipInfo.CloseGossip()
							PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE)
						end
					elseif button == "SPACE" then
						if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then
							FreeAnimation("IMMERSIVE_DIALOG_ANIMATION")	
							StopAnimationDialog(self)
						end
					elseif button == "F1" then
						ImmersiveFrameHandleHide(GwImmersiveFrame)			
						
						C_Timer.After(1,
							function()
								GwImmersiveFrame.ActiveFrame = self.mode == "NORMAL" and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
								GwImmersiveFrame.ActiveFrame.FontColor()
								pcall(GwImmersiveFrame:GetScript("OnEvent"), GwImmersiveFrame, LastEvent)
							end
						)
					elseif button == "F2" then
						if self.Dialog:GetScript("OnClick") then self.Dialog:SetMouseClickEnabled(not self.Dialog:IsMouseEnabled()) end
					else 
						if self.Scroll.ScrollChildFrame:IsVisible() then
							local num = tonumber(button) 
							for obj in TitleButtonPool:EnumerateActive() do
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
		)

		if GetSetting("MOUSE_DIALOG") then
			gF.Dialog:SetScript("OnClick", 
				function (self, button)
					if FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then
						Dialog(GwImmersiveFrame.ActiveFrame, button == "LeftButton" and 1 or -1)
					else
						FreeAnimation("IMMERSIVE_DIALOG_ANIMATION")		
						StopAnimationDialog(GwImmersiveFrame.ActiveFrame)
					end
				end
			)
		end
	end

	if GetSetting("DYNAMIC_BACKGROUND") then ImmersiveDinamicArt(GwFullScreenGossipViewFrame) end
	RegisterMovableFrame(GwNormalScreenGossipViewFrame, L["Gossip View Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
	GwNormalScreenGossipViewFrame:ClearAllPoints()
	GwNormalScreenGossipViewFrame:SetPoint("TOPLEFT", GwNormalScreenGossipViewFrame.gwMover)
	
	GwImmersiveFrame.ActiveFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
	GwImmersiveFrame.ActiveFrame.FontColor()
	
	GwImmersiveFrame.UseFrame, GwImmersiveFrame.NoUseFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame, GwNormalScreenGossipViewFrame or GwNormalScreenGossipViewFrame, GwFullScreenGossipViewFrame
	GwImmersiveFrame.ForceFrame = GwNormalScreenGossipViewFrame

	LoadTitleButtons()
	LoadDetalies()
	LoadImmersiveModelInfo(GwNormalScreenGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)

	ImmersiveDebugModel(GwNormalScreenGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
end

GW.LoadImmersiveView = LoadImmersiveView