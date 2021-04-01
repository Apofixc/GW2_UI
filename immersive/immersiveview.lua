local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local IsIn = GW.IsIn
local AddToAnimation = GW.AddToAnimation
	local FreeAnimation = GW.FreeAnimation
	local FinishedAnimation = GW.FinishedAnimation
	local ImmersiveDinamicArt = GW.ImmersiveDinamicArt
	local GetImmersiveInteractiveText = GW.GetImmersiveInteractiveText
	local LoadImmersiveModelInfo = GW.LoadImmersiveModelInfo
	local SetImmersiveUnitModel = GW.SetImmersiveUnitModel
	local ImmersiveDebugModel = GW.ImmersiveDebugModel

C_GossipInfo.ForceGossip = function() return GetSetting("FORCE_GOSSIP") end

local LastEvent

local TitleButtonPool
local hasActiveQuest = false
local SHOW_TITLE_BUTTON

local AutoNext
local CurrentPartDialogue
local StartAnimationDialog
local SPLIT_DIALOGUE_STRINGS

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------- REWARD/DETAILE -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function QuestInfo_StyleDetail()
	local lastFrame = QuestInfoRewardsFrame.Header
	local totalHeight = lastFrame:GetHeight()

	for _, frame in ipairs({"QuestSessionBonusReward", "ItemReceiveText", "MoneyFrame", "XPFrame", "ArtifactXPFrame", "WarModeBonusFrame", "HonorFrame", "SkillPointFrame", "PlayerTitleText", "TitleFrame", "ItemChooseText"}) do
		if QuestInfoRewardsFrame[frame] and QuestInfoRewardsFrame[frame]:IsShown() then
			QuestInfoRewardsFrame[frame]:ClearAllPoints()
			QuestInfoRewardsFrame[frame]:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -5)
			lastFrame = QuestInfoRewardsFrame[frame]
			totalHeight = totalHeight + lastFrame:GetHeight() + 5
		end
	end

	if QuestInfoRewardsFrame.spellRewardPool:GetNumActive() > 0 then

	end
	
	for i, questItem in ipairs(QuestInfoRewardsFrame.RewardButtons) do
		if questItem:IsShown() then
			questItem:ClearAllPoints()
			questItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", i == 1 and 5 or 0, -5)
			lastFrame = questItem
			totalHeight = totalHeight + lastFrame:GetHeight() + 5
		end
	end

	QuestInfoRewardsFrame:SetHeight(totalHeight)
end

local function QuestInfo_ShowProgressRequiredMoney()
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

		QuestInfoRequiredMoneyFrame:Show()
		return QuestInfoRequiredMoneyFrame
	else
		QuestInfoRequiredMoneyFrame:Hide()
		return nil;
	end
end

local function QuestInfo_ShowProgressRequiredItems()
	GwQuestInfoProgress.progressButtonPool:ReleaseAll()

	local lastAnchorElement
	local totalHeight = 0	

	local numRequiredItems = GetNumQuestItems()
	if numRequiredItems > 0 then
		local numHiddenItem = 0

		GwQuestInfoProgress.RequiredTextItem:SetPoint("TOPLEFT", 0, -5)
		GwQuestInfoProgress.RequiredTextItem:Show()
		totalHeight = totalHeight + GwQuestInfoProgress.RequiredTextItem:GetHeight() + 5
		lastAnchorElement = GwQuestInfoProgress.RequiredTextItem 

		for i = 1, numRequiredItems do
			local hidden = IsQuestItemHidden(i);
			if hidden == 0 then
				local requiredItem = GwQuestInfoProgress.progressButtonPool:Acquire()
				requiredItem.type = "required";
				requiredItem.objectType = "item";
				requiredItem:SetID(i)
				local name, texture, numItems = GetQuestItemInfo(requiredItem.type, 1)
				SetItemButtonCount(requiredItem, numItems)
				SetItemButtonTexture(requiredItem, texture)
				requiredItem:Show()
				requiredItem.Name:SetText(name)

				if (i - numHiddenItem) % 2 == 1 then
					requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "BOTTOMLEFT", 0, -5)
					lastAnchorElement = requiredItem
					totalHeight = totalHeight + requiredItem:GetHeight() + 5
				else
					requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "TOPRIGHT", 1, 0)
				end
			else
				numHiddenItem = numHiddenItem + 1
			end
		end

		if numHiddenItem == numRequiredItems then
			GwQuestInfoProgress.RequiredTextItem:Hide()
			totalHeight = totalHeight - GwQuestInfoProgress.RequiredTextItem:GetHeight() - 5
			lastAnchorElement = nil
		end
	else
		GwQuestInfoProgress.RequiredTextItem:Hide()
	end

	local numRequiredCurrencies = GetNumQuestCurrencies()
	if numRequiredCurrencies > 0 then
		if lastAnchorElement then
			GwQuestInfoProgress.RequiredTextCurrencies:SetPoint("TOPLEFT", lastAnchorElement, "BOTTOMLEFT", 0, -5)
		else
			GwQuestInfoProgress.RequiredTextCurrencies:SetPoint("TOPLEFT", 0, -5)
		end

		GwQuestInfoProgress.RequiredTextCurrencies:Show()
		totalHeight = totalHeight + GwQuestInfoProgress.RequiredTextCurrencies:GetHeight() + 5
		lastAnchorElement = GwQuestInfoProgress.RequiredTextCurrencies 

		for i=1, numRequiredCurrencies do
			local requiredItem = GwQuestInfoProgress.progressButtonPool:Acquire()
			requiredItem.type = "required";
			requiredItem.objectType = "currency";
			requiredItem:SetID(i);
			local name, texture, numItems = GetQuestCurrencyInfo(requiredItem.type, 1);
			SetItemButtonCount(requiredItem, numItems);
			SetItemButtonTexture(requiredItem, texture);
			requiredItem:Show();
			requiredItem.Name:SetText(name)

			if i % 2 == 1 then
				requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "BOTTOMLEFT", 0, -5)
				lastAnchorElement = requiredItem
				totalHeight = totalHeight + requiredItem:GetHeight() + 5
			else
				requiredItem:SetPoint("TOPLEFT", lastAnchorElement, "TOPRIGHT", 1, 0)
			end
		end
	else
		GwQuestInfoProgress.RequiredTextCurrencies:Hide()
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

local function ShownDetail(event, parentFrame)
	local template = _G["GW2_"..event.."_TEMPLATE"]
	local totalHeight = 0

	--for i,children in ipairs{parentFrame:GetFrameChildren()}
	template.contentWidth = parentFrame:GetWidth()
	QuestInfo_Display(template, parentFrame)
	
	local elementsTable = template.frames
	for i = 1, #elementsTable, 2 do
		if _G[elementsTable[i]]:IsShown() then
			if elementsTable[i] == "QuestInfoRewardsFrame" then
				QuestInfo_StyleDetail()
			end

			if elementsTable[i] == "GwQuestInfoProgress" then
				QuestInfo_StyleDetail()
			end

			totalHeight = totalHeight + _G[elementsTable[i]]:GetHeight() + elementsTable[i + 1]
		end
	end

	parentFrame:SetHeight(totalHeight)
	return totalHeight > 0
end

---------------------------------------------------------------------------------------------------------------------
----------------------------------------------- TITLE BUTTON --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function TitleButtonShow(self, event, start, finish, current)
	local multiElement = start ~= finish
	local firstElement = current == start
	local lastElement = current == finish
	local moveElement = current > start and current < finish
	local width = self.Scroll.ScrollChildFrame:GetWidth()
	local totalHeight = 0

	SHOW_TITLE_BUTTON[1].show = lastElement and (event == 'GOSSIP_SHOW' or event == 'QUEST_GREETING')
	SHOW_TITLE_BUTTON[2].show = lastElement and (event == 'GOSSIP_SHOW' or event == 'QUEST_GREETING')
	SHOW_TITLE_BUTTON[3].show = lastElement and event == 'GOSSIP_SHOW'
	SHOW_TITLE_BUTTON[4].show = lastElement and event == 'QUEST_DETAIL'
	SHOW_TITLE_BUTTON[5].show = lastElement and event == 'QUEST_DETAIL' and not QuestGetAutoAccept()
	SHOW_TITLE_BUTTON[6].show = lastElement and event == 'QUEST_PROGRESS' and IsQuestCompletable()
	SHOW_TITLE_BUTTON[7].show = lastElement and event == 'QUEST_COMPLETE' and GetNumQuestChoices() == 0
	SHOW_TITLE_BUTTON[8].show = multiElement and (firstElement or moveElement)
	SHOW_TITLE_BUTTON[9].show = multiElement and (lastElement or moveElement)
	SHOW_TITLE_BUTTON[10].show = event == 'QUEST_GREETING' or event == 'QUEST_PROGRESS' or event == 'QUEST_COMPLETE'
	SHOW_TITLE_BUTTON[11].show = event == 'GOSSIP_SHOW'
	
	local function AcquireButton()
		local button = TitleButtonPool:Acquire() 
		button:SetParent(self.Scroll.ScrollChildFrame)
		button:SetHighlightTexture(GwImmersiveFrame.GossipFrame.titleHighlightTexture)
		button:SetPoint('TOPLEFT', self.Scroll.ScrollChildFrame, 'TOPLEFT', width, -totalHeight)
		button:Show()		

		return button
	end

	TitleButtonPool:ReleaseAll()

	for id, value in ipairs(SHOW_TITLE_BUTTON) do
		if value.show then
			if value.type == "AVAILABLE" and event == 'GOSSIP_SHOW' then
				local GossipQuests = C_GossipInfo.GetAvailableQuests();
				for titleIndex, questInfo in ipairs(GossipQuests) do
					local button = AcquireButton()
					button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, questInfo, C_GossipInfo.SelectAvailableQuest, titleIndex, value.playSound)
					totalHeight = totalHeight + button:GetHeight() + 5
				end	
			elseif value.type == "AVAILABLE" and event == 'QUEST_GREETING' then
				local GreetingAvailableQuests = GetNumAvailableQuests();
				for ID = 1, GreetingAvailableQuests do
					local button = AcquireButton()
					local titleText, isTrivial, frequency, isRepeatable, isLegendary, questID = GetAvailableTitle(ID), GetAvailableQuestInfo(ID)

					button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, {}, SelectAvailableQuest, ID, value.playSound)
					totalHeight = totalHeight + button:GetHeight() + 5
				end
			elseif value.type == "ACTIVE" and event == 'GOSSIP_SHOW' then
				local GossipQuests = C_GossipInfo.GetActiveQuests()
				hasActiveQuest = #GossipQuests > 0
				for titleIndex, questInfo in ipairs(GossipQuests) do
					local button = AcquireButton()
					button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, questInfo, C_GossipInfo.SelectActiveQuest, titleIndex, value.playSound)
					totalHeight = totalHeight + button:GetHeight() + 5
				end
			elseif value.type == "ACTIVE" and event == 'QUEST_GREETING' then
				local GreetingActiveQuests = GetNumActiveQuests();
				for ID = 1, GreetingActiveQuests do
					local button = AcquireButton()
					local title, isComplete, questID, isTrivial, isTrivial = GetActiveTitle(ID), GetActiveQuestID(ID), IsActiveQuestTrivial(ID), IsActiveQuestLegendary(ID)

					button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, {}, SelectActiveQuest, ID, value.playSound)
					totalHeight = totalHeight + button:GetHeight() + 5
				end
			elseif value.type == "GOSSIP" then
				local gossipOptions = C_GossipInfo.GetOptions()
				for titleIndex, optionInfo in ipairs(gossipOptions) do
					local button = AcquireButton()
					button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, optionInfo, value.callBack, titleIndex, value.playSound)
					totalHeight = totalHeight + button:GetHeight() + 5
				end
			else
				local button = AcquireButton()
				button:AddCallbackForTitleButton(TitleButtonPool:GetNumActive(), value.type, {name = GetImmersiveInteractiveText(value.type), icon = id - 4}, value.callBack, value.arg, value.playSound)
				totalHeight = totalHeight + button:GetHeight() + 5
			end
		end
	end

	self.Scroll.ScrollChildFrame:SetHeight(totalHeight)

	if IsIn(event, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and lastElement then
		if not self.Detail:IsVisible() then
			self.Detail.Scroll.ScrollBar:SetValue(0)
			self.Detail:SetShown(ShownDetail(event, self.Detail.Scroll.ScrollChildFrame))
		end
	else
		if self.Detail:IsVisible() then
			self.Detail:Hide()
		end
	end
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
	SPLIT_DIALOGUE_STRINGS = {}
	CurrentPartDialogue = 0
	AutoNext = GetSetting("AUTO_NEXT")

	local unitName = mode == "FULL_SCREEN" and UnitName("npc") or ""
	StartAnimationDialog = strlenutf8(unitName)
	if StartAnimationDialog > 0 then unitName = "|cFFFF5A00"..unitName..":|r " end

	for _, value in ipairs({ strsplit('\n', text)}) do
		if strtrim(value) ~= "" then
			local strLen = strlenutf8(value)

			if strLen < maxSizeText then
				table.insert(SPLIT_DIALOGUE_STRINGS, unitName..value)
			else
				local SizePart = math.ceil(strLen/math.ceil(strLen/maxSizeText))
				local forceInsert = false
				local new = ""

				for key, newValue in ipairs({ strsplit('\n', value:gsub('%.%s%.%s%.', '...'):gsub('%.%s+', '.\n'):gsub('%.%.%.\n', '...\n...'):gsub('%!%s+', '!\n'):gsub('%?%s+', '?\n')) }) do
					if strtrim(newValue) ~= "" then
						local size = strlenutf8(new) + strlenutf8(newValue) + 1

						if size < maxSizeText and not forceInsert then
							new = new.." "..newValue
							if size >= SizePart then forceInsert = true	end
						else
							table.insert(SPLIT_DIALOGUE_STRINGS, unitName..new)
							forceInsert = false
							new = newValue
						end
					end
				end

				if new ~= "" then table.insert(SPLIT_DIALOGUE_STRINGS, unitName..new) end
			end
		end
	end
end

local function Dialog(immersiveFrame, operation)
	if CurrentPartDialogue and FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") and tonumber(operation) then
		CurrentPartDialogue = CurrentPartDialogue + operation

		if not SPLIT_DIALOGUE_STRINGS[CurrentPartDialogue] then 
			CurrentPartDialogue = CurrentPartDialogue - operation
			return 
		end

		immersiveFrame.Dialog.Text:SetText(SPLIT_DIALOGUE_STRINGS[CurrentPartDialogue])
			
		local lenghtAnimationDialog = strlenutf8(immersiveFrame.Dialog.Text:GetText()) - StartAnimationDialog;
		AddToAnimation(
			"IMMERSIVE_DIALOG_ANIMATION",
			StartAnimationDialog,
			lenghtAnimationDialog,
			GetTime(),
			GetSetting("ANIMATION_TEXT_SPEED") * lenghtAnimationDialog,
			function(step)
				immersiveFrame.Dialog.Text:SetAlphaGradient(step, 1);
			end,
			true,
			function()
				if AutoNext and CurrentPartDialogue < #SPLIT_DIALOGUE_STRINGS then
					C_Timer.After(GetSetting("AUTO_NEXT_TIME"), 
						function() 
							if AutoNext then Dialog(immersiveFrame, 1) end	
						end
					)
				else
					StopAnimationDialog(immersiveFrame)
				end
			end
		)	

		TitleButtonShow(immersiveFrame, LastEvent, 1, #SPLIT_DIALOGUE_STRINGS, CurrentPartDialogue);
	end
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- EVENT ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function ImmersiveFrameHandleShow(immersiveFrame, title, dialog)	
	immersiveFrame:Show();
	AddToAnimation(
		immersiveFrame:GetName(),
		immersiveFrame:GetAlpha(),
		1,
		GetTime(),
		0.2,
		function(step)
			immersiveFrame:SetAlpha(step)
		end,
		nil, nil, true
	)
		
	immersiveFrame.ReputationBar:Show()
	SetImmersiveUnitModel(immersiveFrame.Models.Player, "player")
	SetImmersiveUnitModel(immersiveFrame.Models.Giver, UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none")

	if title then
		immersiveFrame.Title.Text:SetText(title)
		AddToAnimation(
			"IMMERSIVE_TITLE_ANIMATION",
			immersiveFrame.Title:GetAlpha(),
			1,
			GetTime(),
			0.2,
			function(step)
				immersiveFrame.Title:SetAlpha(step)
			end
		)
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
		else
			if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") then FreeAnimation("IMMERSIVE_DIALOG_ANIMATION") end
			if not FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") then FreeAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") end
			if not FinishedAnimation("IMMERSIVE_TITLE_ANIMATION") then FreeAnimation("IMMERSIVE_TITLE_ANIMATION") end

			local frame = self.GossipFrame
			AddToAnimation(
				frame:GetName(),
				frame:GetAlpha(),
				0,
				GetTime(),
				0.5,
				function(step)
					frame:SetAlpha(step)	
				end,
				nil,
				function()
					frame:Hide()
					frame.Detail:Hide()
					frame.Scroll.Icon:Hide()
					frame.Scroll.Text:Hide()
					frame.Scroll.ScrollBar:SetValue(0)
					frame.Scroll.ScrollBar:SetAlpha(0)
					frame.Scroll.ScrollChildFrame:Hide()
					frame.Models.Player.unitDirty = nil
					frame.Models.Giver.unitDirty = nil	
					
					frame.Title:SetAlpha(0)
				end,
				true
			)
		end
end

local function LoadTitleButtonsMixin()
	function GossipTitleButtonMixin:SetAction(titleText, icon)
		self.type = "Action";

		self:SetFormattedText(ACTION_DISPLAY, titleText);
		self.Icon:SetTexture("Interface/AddOns/GW2_UI/textures/icons/icon-gossip");
		self.Icon:SetTexCoord(0.25 * floor(icon / 4), 0.25 * (floor(icon / 4) + 1), 0.25 * (icon % 4), 0.25 * ((icon % 4) + 1))
		self.Icon:SetVertexColor(1, 1, 1, 1);
	
		self:Resize();
	end
	
	function GossipTitleButtonMixin:AddCallbackForTitleButton(id, typeButton, info, func, arg, playSound)
		self:SetID(id);

		self.func = func;
		self.arg = arg;
		self.playSound = playSound;

		if typeButton == "AVAILABLE" then
			self:SetQuest(id..". "..info.title, info.questLevel, info.isTrivial, info.frequency, info.repeatable, info.isLegendary, info.isIgnored, info.questID)
		elseif typeButton == "ACTIVE" then
			self:SetActiveQuest(id.titlePool:GetNumActive()..". "..info.title, info.questLevel, info.isTrivial, info.isComplete, info.isLegendary, info.isIgnored, info.questID)
		elseif typeButton == "GOSSIP" then
			self:SetOption(id..". "..info.name, info.type, info.spellID)
		else
			self:SetAction(id..". "..info.name, info.icon)
		end
	end

	function GossipTitleButtonMixin:Resize()
		self:SetHeight(math.max(self:GetTextHeight() + 2, self.Icon:GetHeight()));
		self:SetWidth(self:GetParent():GetWidth());
	end

	function GossipTitleButtonMixin:SetAnimationText()
		self.frameAnimationText = self:GetParent():GetParent():GetParent().Scroll;
		self.frameAnimationText.ScrollBar:SetValue(0);
		self.frameAnimationText.ScrollBar:SetAlpha(0);
		self.frameAnimationText.ScrollChildFrame:Hide();
		self.frameAnimationText.Icon:Show();
		if self.frameAnimationText.Icon.SetText then
			self.frameAnimationText.Icon:SetText("|cFFFF5A00"..UnitName("player")..": ");
		end
		self.frameAnimationText.Text:Show();
		self.frameAnimationText.Text:SetText(self:GetText():gsub("^.*%d+%p%s", ""));

		self.startAnimationText = 0;
		self.lenghtAnimationText = strlenutf8(self.frameAnimationText.Text:GetText()) - self.startAnimationText;
	end
	
	function GossipTitleButtonMixin:OnClick()
		if FinishedAnimation("IMMERSIVE_DIALOG_ANIMATION") and self.func then
			self:SetAnimationText()
			AddToAnimation(
				"IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON",
				self.startAnimationText,
				self.lenghtAnimationText,
				GetTime(),
				GetSetting("ANIMATION_TEXT_SPEED") * self.lenghtAnimationText,
				function(step)
					self.frameAnimationText.Text:SetAlphaGradient(step, 1);
				end,
				true,
				function()
					self.func(self.arg)
					PlaySound(self.playSound)
				end
			)	
		end
	end 

	function GossipTitleButtonMixin:OnShowAnimation()
		local id = self:GetID();

		local ag = self:CreateAnimationGroup()    

		local a1 = ag:CreateAnimation("Translation")
		a1:SetOffset(-self:GetWidth(), 0)   
		a1:SetStartDelay(0.4 * id) 
		a1:SetDuration(6)
		a1:SetSmoothing("OUT")
		a1:Play()
		
		--local point, relativeTo, relativePoint, _, yOfs = self:GetPoint()

		-- if (id and id > 0) then
		-- 	AddToAnimation(
		-- 		"IMMERSIVE_TITLE_BUTTON_ANIMATION_"..id,
		-- 		self:GetWidth(),
		-- 		0,
		-- 		GetTime(),
		-- 		0.4 * id,
		-- 		function(step)
		-- 			self:SetPoint(point, relativeTo, relativePoint, step, yOfs)
		-- 		end
		-- 	)	
		-- else
		-- 	self:SetPoint(point, relativeTo, relativePoint, 0, yOfs)
		-- end
	end
	
	function GossipTitleButtonMixin:OnHideAnimation()
		local id = self:GetID()
		--if not FinishedAnimation("IMMERSIVE_TITLE_BUTTON_ANIMATION_"..id) then FreeAnimation("IMMERSIVE_TITLE_BUTTON_ANIMATION_"..id) end

		self.Icon:SetTexCoord(0, 1, 0, 1)
	end

	TitleButtonPool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate")
end

local function LoadTitleButtonsInfo()
	SHOW_TITLE_BUTTON = {
		{ type = "AVAILABLE", playSound = SOUNDKIT.IG_QUEST_LIST_SELECT },
		{ type = "ACTIVE", playSound = SOUNDKIT.IG_QUEST_LIST_SELECT},
		{ type = "GOSSIP", callBack = C_GossipInfo.SelectOption, playSound = SOUNDKIT.IG_QUEST_LIST_SELECT },
		{ type = "ACCEPT", 
			callBack = function ()
				if QuestFlagsPVP() then
					StaticPopup_Show('CONFIRM_ACCEPT_PVP_QUEST')
				else
					if QuestGetAutoAccept() then
						AcknowledgeAutoAcceptQuest()
					else
						AcceptQuest()
					end
				end
			end, 
			playSound = SOUNDKIT.IG_QUEST_LIST_OPEN },
		{ type = "DECLINE", callBack = DeclineQuest, playSound = SOUNDKIT.IG_QUEST_CANCEL },
		{ type = "COMPLETE", callBack = CompleteQuest, playSound = SOUNDKIT.IG_QUEST_LIST_OPEN },
		{ type = "FINISH", 
			callBack = function ()
				local numQuestChoices = GetNumQuestChoices()
				if (numQuestChoices ~= 0) then
					QuestChooseRewardError()
				else
					GetQuestReward(QuestInfoFrame.itemChoice)
				end
			end, 
			playSound = SOUNDKIT.IG_QUEST_LIST_OPEN },
		{ type = "NEXT", 
			callBack = function ()
				Dialog(GwImmersiveFrame.GossipFrame, 1)
			end, 
			playSound = SOUNDKIT.IG_QUEST_LIST_OPEN },
		{ type = "BACK", 			
			callBack = function ()
				Dialog(GwImmersiveFrame.GossipFrame, -1)
			end, 
			playSound = SOUNDKIT.IG_QUEST_LIST_OPEN },
		{ type = "CANCEL", callBack = CloseQuest, playSound = SOUNDKIT.IG_QUEST_LIST_CLOSE },
		{ type = "EXIT", callBack = C_GossipInfo.CloseGossip, playSound = SOUNDKIT.IG_QUEST_LIST_CLOSE }
	}
end

local function LoadDetalies()
	local CollectionPollMixin = {}

	function CollectionPollMixin:CreatePool(typePool, template, ...)
		local pool

		if typePool == "Frame" then
			local frameType, parent, frameTemplate, resetterFunc, forbidden = ...
			pool = CreateFramePool(frameType, parent, frameTemplate, resetterFunc, forbidden)
		elseif typePool == "FontString" then
			local parent, layer, subLayer, fontStringTemplate, resetterFunc = ...
			pool = CreateFontStringPool(parent, layer, subLayer, fontStringTemplate, resetterFunc)
		end

		self.pools[template] = pool

		return pool
	end

	local function CreateCollectionPool()
		local poolCollection = CreateFromMixins(CollectionPollMixin)
		FramePoolCollectionMixin.OnLoad(poolCollection)
		return poolCollection;
	end

	GW2_QUEST_DETAIL_TEMPLATE = {
		chooseItems = nil, canHaveSealMaterial = false, 
		elements = {		
			QuestInfo_ShowObjectivesText, 0, 0,
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
		chooseItems = nil, canHaveSealMaterial = false,
		elements = {
			QuestInfo_ShowProgressRequiredMoney, 0, 0,
			QuestInfo_ShowProgressRequiredItems, 0, -5
		},
		frames = {
			"QuestInfoRequiredMoneyFrame", 0,
			"GwQuestInfoProgress", 5
		}	
	}

	GW2_QUEST_COMPLETE_TEMPLATE = {
		chooseItems = true, canHaveSealMaterial = false,
		elements = {
			QuestInfo_ShowRewardText, 0, 0,
			QuestInfo_ShowRewards, 0, -10,
		},
		frames = {
			"QuestInfoRewardText", 0,
			"QuestInfoRewardsFrame", 10
		}
	}

	QuestInfoRewardsFrame.spellRewardPool = CreateFramePool("BUTTON", QuestInfoRewardsFrame, "QuestSpellTemplate, QuestInfoRewardSpellCodeTemplate");
	QuestInfoRewardsFrame.followerRewardPool = CreateFramePool("BUTTON", QuestInfoRewardsFrame, "LargeQuestInfoRewardFollowerTemplate");
	QuestInfoRewardsFrame.spellHeaderPool = CreateFontStringPool(QuestInfoRewardsFrame, "BACKGROUND", 0, "QuestInfoSpellHeaderTemplate");

	CreateFrame("Frame", "GwQuestInfoProgress", QuestInfoFrame, "GwQuestInfoProgressTemplate")

	function QuestInfoItem_OnClick(self)
		if ( self.type == "choice" ) then
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
			if IsIn(event, "QUEST_ITEM_UPDATE", "QUEST_LOG_UPDATE", "LEARNED_SPELL_IN_TAB", "UNIT_MODEL_CHANGED") and not self.GossipFrame:IsShown() then return end

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

				ImmersiveFrameHandleShow(self.GossipFrame, nil, dialog)
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

					if questPortrait ~= 0 then
						-- QuestFrame_ShowQuestPortrait(QuestFrame, questPortrait, questPortraitMount or 0, questPortraitText, questPortraitName, -3, -42)
						-- QuestFrame_UpdatePortraitText("Пример")
						-- QuestModelScene:SetParent(self.GossipFrame.Models)
						-- QuestModelScene:ClearAllPoints()
						-- QuestModelScene:SetPoint("CENTER", self.GossipFrame.Models, "CENTER", 0, 0)
						-- QuestNPCModelTextFrameBg:Show()
						-- QuestModelScene:Show()
					end
				else
					dialog = GetProgressText()
				end

				ImmersiveFrameHandleShow(self.GossipFrame, GetTitleText(), dialog)
			elseif IsIn(event, "GOSSIP_CLOSED", "QUEST_FINISHED") then
				ImmersiveFrameHandleHide(self)
			elseif IsIn(event, "QUEST_ITEM_UPDATE", "LEARNED_SPELL_IN_TAB") then
				if IsIn(LastEvent, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and self.GossipFrame.Detail:IsVisible() then
					self.GossipFrame.Detail:Hide()
					self.GossipFrame.Detail.Scroll.ScrollBar:SetValue(0)
					self.GossipFrame.Detail:SetShown(ShownDetail(LastEvent, self.GossipFrame.Detail.Scroll.ScrollChildFrame))
				end
			elseif event == "QUEST_LOG_UPDATE" then
				if (LastEvent == "GOSSIP_SHOW" and hasActiveQuest) or LastEvent == "QUEST_GREETING" then
					pcall(self:GetScript("OnEvent"), self, LastEvent)
				end
			elseif event == "UNIT_MODEL_CHANGED" then
				local unit = ...
				if unit == "player" then
					SetUnitModel(self.GossipFrame.Models.Player, unit)
				else
					SetUnitModel(self.GossipFrame.Models.Giver, unit)
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
						GwImmersiveFrame.GossipFrame = self.mode == "NORMAL" and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
						GwImmersiveFrame.GossipFrame.FontColor()

						pcall(GwImmersiveFrame:GetScript("OnEvent"), GwImmersiveFrame, LastEvent)
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
						Dialog(GwImmersiveFrame.GossipFrame, button == "LeftButton" and 1 or -1)
					else
						FreeAnimation("IMMERSIVE_DIALOG_ANIMATION")		
						StopAnimationDialog(GwImmersiveFrame.GossipFrame)
					end
				end
			)
		end
	end

	if GetSetting("DINAMIC_ART") then ImmersiveDinamicArt(GwFullScreenGossipViewFrame) end
	RegisterMovableFrame(GwNormalScreenGossipViewFrame, L["Gossip View Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
	GwNormalScreenGossipViewFrame:ClearAllPoints()
	GwNormalScreenGossipViewFrame:SetPoint("TOPLEFT", GwNormalScreenGossipViewFrame.gwMover)
	
	GwImmersiveFrame.GossipFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
	GwImmersiveFrame.GossipFrame.FontColor()

	LoadTitleButtonsMixin()
	LoadTitleButtonsInfo()
	LoadDetalies()
	LoadImmersiveModelInfo(GwNormalScreenGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)

	ImmersiveDebugModel(GwNormalScreenGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
end

GW.LoadImmersiveView = LoadImmersiveView