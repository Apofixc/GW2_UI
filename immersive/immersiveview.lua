local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local SetSetting = GW.SetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local AddToAnimation = GW.AddToAnimation
local ActiveAnimation = GW.ActiveAnimation
local StopAnimation = GW.StopAnimation
local DinamicArt = GW.CUSTOME_IMMERSIVE.DinamicArt
local GetInteractiveText = GW.CUSTOME_IMMERSIVE.GetInteractiveText
local LoadModelInfo = GW.CUSTOME_IMMERSIVE.LoadModelInfo
local SetUnitModel = GW.CUSTOME_IMMERSIVE.SetUnitModel
local DebugModel = GW.CUSTOME_IMMERSIVE.DebugModel

if GetSetting("FORCE_GOSSIP") then
	C_GossipInfo.ForceGossip = function() return true end
else
	C_GossipInfo.ForceGossip = function() return false end
end


---------------------------------------------------------------------------------------------------------------------
----------------------------------------- API / OTHER FUNCTION ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function SetFontColor(color)
	IGNORED_QUEST_DISPLAY = color.Ignored
	TRIVIAL_QUEST_DISPLAY = color.Trivial
	NORMAL_QUEST_DISPLAY = color.Normal
	ACTION_DISPLAY = color.Action
end

local function AcquireObjectFromPool(pool, parentButton)
	local obj = pool:Acquire()
	obj:SetParent(parentButton or obj:GetParent())

	return obj, pool:GetNumActive()
end

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

	print(QuestInfoRewardsFrame.spellRewardPool:GetNumActive())
	print(QuestInfoRewardsFrame.followerRewardPool:GetNumActive())
	print(QuestInfoRewardsFrame.spellHeaderPool:GetNumActive())
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

local function QuestInfo_ReleaseProgressButtons()
	GwImmersiveFrame.progressButtonPool:ReleaseAll()
end

local function QuestInfo_ShowProgressRequiredMoney()
	local requiredMoney = GetQuestMoneyToGet()
	if requiredMoney > 0 then
		MoneyFrame_Update("QuestInfoRequiredMoneyDisplay", requiredMoney);
		if requiredMoney > GetMoney() then
			QuestInfoRequiredMoneyText:SetTextColor(0, 0, 0);
			SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "red");
		else
			QuestInfoRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor("QuestInfoRequiredMoneyDisplay", "white");
		end

		QuestInfoRequiredMoneyFrame:Show();
		return QuestInfoRequiredMoneyFrame;
	else
		QuestInfoRequiredMoneyFrame:Hide();
		return nil;
	end
end

local function QuestInfo_ShowProgressRequiredItems()
	local numRequiredItems = GetNumQuestItems()
	local numHiddenItem = 0
	local lastAnchorElement = GwQuestInfoRequiredItemFrame.RequiredText
	local totalHeight = lastAnchorElement:GetHeight()

	if numRequiredItems > 0 then
		for i = 1, numRequiredItems do
			local hidden = IsQuestItemHidden(i);
			if hidden == 0 then
				local requiredItem = AcquireObjectFromPool(GwImmersiveFrame.progressButtonPool, GwQuestInfoRequiredItemFrame)
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

		if numHiddenItem ~= numRequiredItems then
			GwQuestInfoRequiredItemFrame:SetHeight(totalHeight)
			GwQuestInfoRequiredItemFrame:Show()
			return GwQuestInfoRequiredItemFrame
		end
	end

	GwQuestInfoRequiredItemFrame:Hide()
	return nil
end

local function QuestInfo_ShowProgressRequiredCurrencies()
	local numRequiredCurrencies = GetNumQuestCurrencies()
	local lastAnchorElement = GwQuestInfoRequiredCurrenciesFrame.RequiredText
	local totalHeight = lastAnchorElement:GetHeight()

	if numRequiredCurrencies > 0 then
		for i=1, numRequiredCurrencies do
			local requiredItem = AcquireObjectFromPool(GwImmersiveFrame.progressButtonPool, GwQuestInfoRequiredCurrenciesFrame)
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

		GwQuestInfoRequiredCurrenciesFrame:SetHeight(totalHeight)
		GwQuestInfoRequiredCurrenciesFrame:Show()

		return GwQuestInfoRequiredCurrenciesFrame
	end

	GwQuestInfoRequiredCurrenciesFrame:Hide()
	return nil
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

			totalHeight = totalHeight + _G[elementsTable[i]]:GetHeight() + elementsTable[i + 1]
		end
	end
	parentFrame:SetHeight(totalHeight)
	return totalHeight > 0
end

---------------------------------------------------------------------------------------------------------------------
----------------------------------------------- TITLE BUTTON --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function TitleButtonUpdate(buttonTitleInfo, info, buttonType, func, arg, playSound)
	local titleInfo = buttonTitleInfo[buttonType]
	if (not titleInfo) then
		buttonTitleInfo[buttonType] = {}
		titleInfo = buttonTitleInfo[buttonType]
	end

	info.buttonType = buttonType
	info.func = func
	info.arg = arg
	info.playSound = playSound

	table.insert(titleInfo, info)
end

local function TitleButtonShow(self, event, start, finish, current)
	local multiElement = start ~= finish
	local firstElement = current == start
	local lastElement = current == finish
	local moveElement = current > start and current < finish
	local width = self.Scroll.ScrollChildFrame:GetWidth()
	local totalHeight = 0

	local ShowElement = {
		{ name = "AVAILABLE", show = lastElement and (event == 'GOSSIP_SHOW' or event == 'QUEST_GREETING') },
		{ name = "ACTIVE", show = lastElement and (event == 'GOSSIP_SHOW' or event == 'QUEST_GREETING') },
		{ name = "GOSSIP", show = lastElement and event == 'GOSSIP_SHOW' },
		{ name = "ACCEPT", show = lastElement and event == 'QUEST_DETAIL' },
		{ name = "DECLINE", show = lastElement and event == 'QUEST_DETAIL' and not QuestGetAutoAccept() },
		{ name = "COMPLETE", show = lastElement and event == 'QUEST_PROGRESS' and IsQuestCompletable() },
		{ name = "FINISH", show = lastElement and event == 'QUEST_COMPLETE' and GetNumQuestChoices() == 0 },
		{ name = "NEXT", show = multiElement and (firstElement or moveElement) },
		{ name = "BACK", show = multiElement and (lastElement or moveElement) },
		{ name = "CANCEL", show = event == 'QUEST_GREETING' or event == 'QUEST_PROGRESS' or event == 'QUEST_COMPLETE' },
		{ name = "EXIT", show = event == 'GOSSIP_SHOW' }
	}
	
	GwImmersiveFrame.titlePool:ReleaseAll()
	
	for id, value in ipairs(ShowElement) do
		if value.show then
			for _, info in ipairs(GwImmersiveFrame.buttonTitleInfo[value.name]) do
				local button, key = AcquireObjectFromPool(GwImmersiveFrame.titlePool, self.Scroll.ScrollChildFrame, GwImmersiveFrame.GossipFrame.titleHighlightTexture)	
				local keyTitle = key < 11 and key..". " or ""

				if info.buttonType == "AVAILABLE" then
					button:SetQuest(keyTitle..info.title, info.questLevel, info.isTrivial, info.frequency, info.repeatable, info.isLegendary, info.isIgnored, info.questID)
				elseif info.buttonType == "ACTIVE" then
					button:SetActiveQuest(keyTitle..info.title, info.questLevel, info.isTrivial, info.isComplete, info.isLegendary, info.isIgnored, info.questID)
				elseif info.buttonType == "GOSSIP" then
					button:SetOption(keyTitle..info.name, info.type, info.spellID)
				else
					button:SetAction(keyTitle..GetInteractiveText(info.buttonType), id - 4)
				end
				button:SetFunction(key, info.func, info.arg, info.playSound)
				button:SetHighlightTexture(GwImmersiveFrame.GossipFrame.titleHighlightTexture)

				button:SetPoint('TOPLEFT', self.Scroll.ScrollChildFrame, 'TOPLEFT', width, -totalHeight)
				button:Show()

				totalHeight = totalHeight + button:GetHeight() + 5
			end
		end
	end

	self.Scroll.ScrollChildFrame:SetHeight(totalHeight)

	if (event == "QUEST_PROGRESS" or event == "QUEST_DETAIL" or event == "QUEST_COMPLETE") and lastElement then
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
---------------------------------------- GOSSIP/ GREETING INFO ------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GetAvailableQuestsGossip(self)
	self.buttonTitleInfo["AVAILABLE"] = {}
	local GossipQuests = C_GossipInfo.GetAvailableQuests();
	for titleIndex, questInfo in ipairs(GossipQuests) do
		TitleButtonUpdate(self.buttonTitleInfo, questInfo, "AVAILABLE", C_GossipInfo.SelectAvailableQuest, titleIndex, SOUNDKIT.IG_QUEST_LIST_SELECT);
	end	
end

local function GetActiveQuestsGossip(self)
	self.buttonTitleInfo["ACTIVE"] = {}
	local GossipQuests = C_GossipInfo.GetActiveQuests();
	self.hasActiveQuest = (#GossipQuests > 0);
	for titleIndex, questInfo in ipairs(GossipQuests) do
		TitleButtonUpdate(self.buttonTitleInfo, questInfo, "ACTIVE", C_GossipInfo.SelectActiveQuest, titleIndex, SOUNDKIT.IG_QUEST_LIST_SELECT);
	end
end

local function GetOptionsGossip(self)
	self.buttonTitleInfo["GOSSIP"] = {}
	local gossipOptions = C_GossipInfo.GetOptions();
	for titleIndex, optionInfo in ipairs(gossipOptions) do
		TitleButtonUpdate(self.buttonTitleInfo, optionInfo, "GOSSIP", C_GossipInfo.SelectOption, titleIndex, SOUNDKIT.IG_QUEST_LIST_SELECT);
	end
end

local function GetAvailableQuestsGreeting(self)
	self.buttonTitleInfo["AVAILABLE"] = {}
	local GreetingAvailableQuests = GetNumAvailableQuests();
	for ID = 1, GreetingAvailableQuests do
		local Info = {}

		Info.isTrivial, Info.frequency, Info.isRepeatable, Info.isLegendary, Info.questID = GetAvailableQuestInfo(ID);
		Info.titleText = GetAvailableTitle(ID);

		TitleButtonUpdate(self.buttonTitleInfo, Info, "AVAILABLE", SelectAvailableQuest, ID, SOUNDKIT.IG_QUEST_LIST_SELECT);
	end
end

local function GetActiveQuestsGreeting(self)	
	self.buttonTitleInfo["ACTIVE"] = {}
	local GreetingActiveQuests = GetNumActiveQuests();
	for ID = 1, GreetingActiveQuests do
		local Info = {}

		Info.title, Info.isComplete = GetActiveTitle(ID);
		Info.isTrivial = IsActiveQuestTrivial(ID);
		Info.isLegendary = IsActiveQuestLegendary(ID);
		Info.questID = GetActiveQuestID(ID);

		TitleButtonUpdate(self.buttonTitleInfo, Info, "ACTIVE", SelectActiveQuest, ID, SOUNDKIT.IG_QUEST_LIST_SELECT);
	end
end

---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DIALOG ----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function StopAnimationDialog(self)
	self.nextFunc = false;
	
	self.GossipFrame.Dialog.Text:SetAlphaGradient(self.GossipFrame.maxSizeText, 1);
	self.GossipFrame.Scroll.ScrollChildFrame:Show();	
	self.GossipFrame.Scroll.ScrollBar:SetAlpha(1);	
end

local function Split(self, text, maxSizeText, mode)
	self.splitDialog = {}
	self.numPartDialog = 0
	self.nextFunc = GetSetting("AUTO_NEXT")

	local unitName ="";
	if (mode == "FULL_SCREEN") then
		unitName = UnitName("npc");
		if (unitName) then
			self.startAnimationDialog = strlenutf8(unitName);
			unitName = "|cFFFF5A00"..unitName..":|r ";
		end 
	else
		self.startAnimationDialog = 0;
	end

	for _, value in ipairs({ strsplit('\n', text)}) do
		if (strtrim(value) ~= "") then
			local strLen = strlenutf8(value);

			if (strLen < maxSizeText) then
				table.insert(self.splitDialog, unitName..value);
			else
				local SizePart = math.ceil(strLen/math.ceil(strLen/maxSizeText));
				local forceInsert = false;
				local new = "";

				for key, newValue in ipairs({ strsplit('\n', value:gsub('%.%s%.%s%.', '...'):gsub('%.%s+', '.\n'):gsub('%.%.%.\n', '...\n...'):gsub('%!%s+', '!\n'):gsub('%?%s+', '?\n')) }) do
					if (strtrim(newValue) ~= "") then
						local size = strlenutf8(new) + strlenutf8(newValue) + 1;

						if (size < maxSizeText and not forceInsert) then
							new = new.." "..newValue;

							if (size >= SizePart) then
								forceInsert = true;
							end
						else
							table.insert(self.splitDialog, unitName..new);
							forceInsert = false;
							new = newValue;
						end
					end
				end

				if (new ~= "") then
					table.insert(self.splitDialog, unitName..new);					
				end
			end
		end
	end
end

local function Dialog(self, back)
	if (self.numPartDialog and not ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
		local numPart = self.numPartDialog + (back and -1 or 1)

		if (self.splitDialog[numPart]) then
			self.numPartDialog = numPart;
			self.GossipFrame.Dialog.Text:SetText(self.splitDialog[numPart]);
			
			local lenghtAnimationDialog = strlenutf8(self.GossipFrame.Dialog.Text:GetText()) - self.startAnimationDialog;
			AddToAnimation(
				"IMMERSIVE_DIALOG_ANIMATION",
				self.startAnimationDialog,
				lenghtAnimationDialog,
				GetTime(),
				GetSetting("ANIMATION_TEXT_SPEED") * lenghtAnimationDialog,
				function(step)
					self.GossipFrame.Dialog.Text:SetAlphaGradient(step, 1);
				end,
				true,
				function()
					if (self.nextFunc and numPart < #self.splitDialog) then
						C_Timer.After(GetSetting("AUTO_NEXT_TIME"), function() 
							if (self.nextFunc) then
								Dialog(self, false);
							end	
						end);
					else
						StopAnimationDialog(self)
					end
				end
			)	

			TitleButtonShow(self.GossipFrame, self.lastEvent, 1, #self.splitDialog, self.numPartDialog);
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- EVENT ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function ImmersiveFrameHandleShow(self, title, dialog)	
	self.GossipFrame:Show();
	AddToAnimation(
		self.GossipFrame:GetName(),
		self.GossipFrame:GetAlpha(),
		1,
		GetTime(),
		0.2,
		function(step)
			self.GossipFrame:SetAlpha(step)
		end
	)
		
	self.GossipFrame.ReputationBar:Show()
	SetUnitModel(self.GossipFrame.Models.Player, "player")
	SetUnitModel(self.GossipFrame.Models.Giver, UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none")

	if title then
		self.GossipFrame.Title.Text:SetText(title);
		self.GossipFrame.Title:Show();
	else
		self.GossipFrame.Title:Hide();
	end

	Split(self, dialog, self.GossipFrame.maxSizeText, self.GossipFrame.mode);
	Dialog(self, false)
end

local function ImmersiveFrameHandleHide(self)
		if (self.customFrame) then
			self.customFrame:Hide()
			self.customFrame = nil;		
		else
			StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
			StopAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLEBUTTON");
			self.splitDialog = nil;
			self.numPartDialog = nil
			self.startAnimationDialog = nil;
			
			local frame = self.GossipFrame;
			
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
					frame:Hide();
					frame.Detail:Hide();
					frame.Scroll.Icon:Hide();
					frame.Scroll.Text:Hide();
					frame.Scroll.ScrollBar:SetValue(0);
					frame.Scroll.ScrollBar:SetAlpha(0);
					frame.Scroll.ScrollChildFrame:Hide();	
					frame.Models.Player.unitDirty = nil;	
					frame.Models.Giver.unitDirty = nil;			
				end
			)
		end
end

local function GwImmersiveFrameOnEvent(self, event, ...)
		if (event ~= 'QUEST_ITEM_UPDATE' or  event ~= 'QUEST_LOG_UPDATE' or event ~= 'LEARNED_SPELL_IN_TAB') then
			if (self.lastEvent == "GOSSIP_SHOW" and event:match('^QUEST')) then
				C_GossipInfo.CloseGossip();
			end

			self.lastEvent = event;
		end
		
		if (event == 'GOSSIP_SHOW') then
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
				if (gossipInfoTable[1].type ~= "gossip") then
					C_GossipInfo.SelectOption(1)
					return
				end
			end

			GetAvailableQuestsGossip(self);
			GetActiveQuestsGossip(self);
			GetOptionsGossip(self);

			ImmersiveFrameHandleShow(self, nil, C_GossipInfo.GetText());
		elseif (event == 'GOSSIP_CLOSED') then
			ImmersiveFrameHandleHide(self)
		elseif (event == 'QUEST_GREETING') then
			GetAvailableQuestsGreeting(self);
			GetActiveQuestsGreeting(self);

			ImmersiveFrameHandleShow(self, nil, GetGreetingText());
		elseif (event == 'QUEST_DETAIL') then
			local questStartItemID = ...

			if QuestIsFromAdventureMap() then
				HideUIPanel(QuestLogPopupDetailFrame)
				return
			end

			if questStartItemID ~= nil and questStartItemID ~= 0 or QuestGetAutoAccept() and QuestIsFromAreaTrigger() then
				if (AutoQuestPopupTracker_AddPopUp(GetQuestID(), "OFFER", questStartItemID)) then
					PlayAutoAcceptQuestSound()
				end

				CloseQuest()
				return
			end

			HideUIPanel(QuestLogPopupDetailFrame)
			ImmersiveFrameHandleShow(self, GetTitleText(), GetQuestText())
			--local questPortrait, questPortraitText, questPortraitName, questPortraitMount = GetQuestPortraitGiver()
			-- QuestFrame_UpdatePortraitText("Пример")
			-- QuestModelScene:SetParent(self.GossipFrame.Models)
			-- QuestModelScene:ClearAllPoints()
			-- QuestModelScene:SetPoint("CENTER", self.GossipFrame.Models, "CENTER", 0, 0)
			-- QuestNPCModelTextFrameBg:Show()
			-- QuestModelScene:Show()
		elseif (event == 'QUEST_PROGRESS') then
			HideUIPanel(QuestLogPopupDetailFrame)
			ImmersiveFrameHandleShow(self, GetTitleText(), GetProgressText());
		elseif (event == 'QUEST_COMPLETE') then
			HideUIPanel(QuestLogPopupDetailFrame)
			ImmersiveFrameHandleShow(self, GetTitleText(), GetRewardText())
			local questPortrait, questPortraitText, questPortraitName = GetQuestPortraitTurnIn()
		elseif (event == 'QUEST_FINISHED') then
			ImmersiveFrameHandleHide(self);
		elseif (event == 'QUEST_ITEM_UPDATE') then
			if (self.GossipFrame.Detail:IsVisible()) then
				if (self.lastEvent == 'QUEST_DETAIL' or self.lastEvent == 'QUEST_PROGRESS' or self.lastEvent == 'QUEST_COMPLETE') then
					self.GossipFrame.Detail.Scroll.ScrollChildFrame:Update();
				end
			end
		elseif (event == 'QUEST_LOG_UPDATE') then
			if ((self.lastEvent == 'GOSSIP_SHOW' and self.hasActiveQuest) or self.lastEvent == 'QUEST_GREETING') then
				GwImmersiveFrameOnEvent(self, self.lastEvent)
			end
		elseif (event == 'LEARNED_SPELL_IN_TAB') then
			if (self.GossipFrame.Detail:IsVisible()) then
				QuestInfo_Display(_G["GW2_"..event.."_TEMPLATE"], self.Detail.Scroll.ScrollChildFrame)
			end
		elseif (event == 'UNIT_MODEL_CHANGED') then
			if (self.GossipFrame:IsVisible()) then
				local unit = ...
				local frame = (unit == "player") and self.GossipFrame.Models.Player or self.GossipFrame.Models.Giver

				SetUnitModel(frame, unit)
			end
		end
end 

local function ModificationStandardElements()
	function GossipTitleButtonMixin:SetAction(titleText, icon)
		self.type = "Action";

		self:SetFormattedText(ACTION_DISPLAY, titleText);
		self.Icon:SetTexture("Interface/AddOns/GW2_UI/textures/icons/icon-gossip");
		self.Icon:SetTexCoord(0.25 * floor(icon / 4), 0.25 * (floor(icon / 4) + 1), 0.25 * (icon % 4), 0.25 * ((icon % 4) + 1))
		self.Icon:SetVertexColor(1, 1, 1, 1);
	
		self:Resize();
	end
	
	function GossipTitleButtonMixin:SetFunction(id, func, arg, playSound)
		self:SetID(id);

		self.func = func;
		self.arg = arg;
		self.playSound = playSound;
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
		if (not ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION") and self.func) then
			self:SetAnimationText()
			AddToAnimation(
				"IMMERSIVE_DIALOG_ANIMATION_TITLEBUTTON",
				self.startAnimationText,
				self.lenghtAnimationText,
				GetTime(),
				GetSetting("ANIMATION_TEXT_SPEED") * self.lenghtAnimationText,
				function(step)
					self.frameAnimationText.Text:SetAlphaGradient(step, 1);
				end,
				true,
				function()
					if type(self.arg) == "table" then					
						self.func(unpack(self.arg))
					else
						self.func(self.arg)
					end
	
					if (self.playSound) then
						PlaySound(self.playSound);	
					end
				end
			)	
		end
	end 

	function GossipTitleButtonMixin:OnShowAnimation()
		local id = self:GetID();
		local point, relativeTo, relativePoint, _, yOfs = self:GetPoint()

		if (id and id > 0) then
			AddToAnimation(
				"IMMERSIVE_TITLE_ANIMATION_"..id,
				self:GetWidth(),
				0,
				GetTime(),
				0.4 * id,
				function(step)
					self:SetPoint(point, relativeTo, relativePoint, step, yOfs)
				end
			)	
		else
			self:SetPoint(point, relativeTo, relativePoint, 0, yOfs)
		end
	end
	
	function GossipTitleButtonMixin:OnHideAnimation()
		local id = self:GetID();

		if (id and id > 0) then
			StopAnimation("IMMERSIVE_TITLE_ANIMATION_"..id)
		end
		self.Icon:SetTexCoord(0, 1, 0, 1)
	end

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

	for _, frame in ipairs({GossipFrame, QuestFrame}) do
			frame:UnregisterAllEvents()
			frame:EnableMouse(false)
			frame:EnableKeyboard(false)
			frame:ClearAllPoints()
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
			QuestInfo_ReleaseProgressButtons, 0, 0,
			QuestInfo_ShowProgressRequiredMoney, 0, 0,
			QuestInfo_ShowProgressRequiredItems, 0, -5,
			QuestInfo_ShowProgressRequiredCurrencies, 0, -5
		},
		frames = {
			"QuestInfoObjectivesFrame", 0,
			"QuestInfoRequiredMoneyFrame", 0,
			"GwQuestInfoRequiredItemFrame", 5,
			"QuestInfoRequiredMoneyFrame", 5
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

	CreateFrame("Frame", "GwQuestInfoRequiredItemFrame", QuestInfoFrame, "GwQuestInfoProgressTemplate")
	GwQuestInfoRequiredItemFrame.RequiredText:SetText(ITEMS)
	CreateFrame("Frame", "GwQuestInfoRequiredCurrenciesFrame", QuestInfoFrame, "GwQuestInfoProgressTemplate")
	GwQuestInfoRequiredCurrenciesFrame.RequiredText:SetText(CURRENCY)
end

local function LoadImmersiveView()
	ModificationStandardElements()

	CreateFrame("Frame", "GwImmersiveFrame")
	GwImmersiveFrame:RegisterEvent("QUEST_LOG_UPDATE")
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
	GwImmersiveFrame:SetScript("OnEvent", GwImmersiveFrameOnEvent)

	for _, frame in ipairs({{name = "GwFullScreenGossipViewFrame", template = "GwFullScreenGossipViewFrameTemplate"}, {name = "GwGossipViewFrame", template = "GwGossipViewFrameTemplate"}}) do
		local gF = CreateFrame("Frame", frame.name, UIParent, frame.template)
		gF:SetScript("OnKeyDown", 
				function (self, button)
					self:SetPropagateKeyboardInput(false)

					if (button == 'ESCAPE') then
						if (not QuestGetAutoAccept()) then
							CloseItemText();
							CloseQuest();
							C_GossipInfo.CloseGossip();
							PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE);
						end
					elseif (button == "SPACE") then
						if (ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
							StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
							StopAnimationDialog(GwImmersiveFrame);
						end
					elseif (button == "F1") then
						ImmersiveFrameHandleHide(GwImmersiveFrame)				
						GwImmersiveFrame.GossipFrame = GwImmersiveFrame.GossipFrame.mode == "NORMAL" and GwFullScreenGossipViewFrame or GwGossipViewFrame
						SetFontColor(GwImmersiveFrame.GossipFrame.fontColor)
						GwImmersiveFrameOnEvent(GwImmersiveFrame, GwImmersiveFrame.lastEvent);
					elseif (button == "F2") then

					elseif (button == "F3") then
						GwImmersiveFrame.enableClick = not GwImmersiveFrame.enableClick
					elseif tonumber(button) then
						local num = tonumber(button) 

						if self.Scroll.ScrollChildFrame:IsVisible() then
							for obj in GwImmersiveFrame.titlePool:EnumerateActive() do
								if obj:GetID() == num then
									obj:Click()
								end
							end										
						end
					else
						self:SetPropagateKeyboardInput(true);
					end
				end
		)
		gF.Dialog:SetScript("OnClick", 
				function (self, button)
					if (not GwImmersiveFrame.enableClick) then
						return;
					end
			
					if (ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
						StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
						StopAnimationDialog(GwImmersiveFrame);
					else
						if(button == "LeftButton") then
							Dialog(GwImmersiveFrame, false);
						elseif (button == "RightButton") then
							Dialog(GwImmersiveFrame, true);
						end
					end
				end
		)
	end

	RegisterMovableFrame(GwGossipViewFrame, L["Gossip View Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
	GwGossipViewFrame:ClearAllPoints()
	GwGossipViewFrame:SetAllPoints(GwGossipViewFrame.gwMover)
	
	GwImmersiveFrame.titlePool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate")
	GwImmersiveFrame.progressButtonPool = CreateFramePool("BUTTON", nil, "QuestItemTemplate")

	GwImmersiveFrame.buttonTitleInfo = {}
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "NEXT", Dialog, {GwImmersiveFrame, false}, SOUNDKIT.IG_QUEST_LIST_OPEN)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "BACK", Dialog, {GwImmersiveFrame, true}, SOUNDKIT.IG_QUEST_LIST_OPEN)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "ACCEPT", 	
			function ()
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
			nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "DECLINE", DeclineQuest, nil, SOUNDKIT.IG_QUEST_CANCEL)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "COMPLETE", CompleteQuest, nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "FINISH", 		
			function ()
				local numQuestChoices = GetNumQuestChoices()
				if (numQuestChoices ~= 0) then
					QuestChooseRewardError()
				else
					GetQuestReward(QuestInfoFrame.itemChoice)
				end
			end, 
			nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "CANCEL", CloseQuest, nil, SOUNDKIT.IG_QUEST_LIST_CLOSE)
	TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "EXIT", C_GossipInfo.CloseGossip, nil, SOUNDKIT.IG_QUEST_LIST_CLOSE)

	GwImmersiveFrame.GossipFrame = GetSetting("FULL_SCREEN") and GwFullScreenGossipViewFrame or GwGossipViewFrame
	GwImmersiveFrame.enableClick = GetSetting("MOUSE_DIALOG") 
	SetFontColor(GwImmersiveFrame.GossipFrame.fontColor)
	DinamicArt(GwFullScreenGossipViewFrame, GetSetting("DINAMIC_ART"))
	LoadModelInfo(GwGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
	DebugModel(GwGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
end

GW.LoadImmersiveView = LoadImmersiveView