local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local SetSetting = GW.SetSetting
local RegisterMovableFrame = GW.RegisterMovableFrame
local AddToAnimation = GW.AddToAnimation
local ActiveAnimation = GW.ActiveAnimation
local StopAnimation = GW.StopAnimation
local SetFontColor = GW.CUSTOME_IMMERSIVE.SetFontColor
local FullScreenBorderStyle = GW.CUSTOME_IMMERSIVE.FullScreenBorderStyle
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

local function GetItemButton(pool, buttons, parentButton, width)
	local button = pool:Acquire();
	button:SetParent(parentButton);
	button:SetWidth(width or button:GetWidth());
	table.insert(buttons, button);

	return button, pool:GetNumActive();
end

local function ReleaseAll(pool)
	pool:ReleaseAll();
	return {}
end

local function TitleButtonUpdate(buttonTitleInfo, info, buttonType, func, arg, playSound)
	local titleInfo = buttonTitleInfo[buttonType];
	if (not titleInfo) then
		buttonTitleInfo[buttonType] = {}
		titleInfo = buttonTitleInfo[buttonType];
	end

	info.buttonType = buttonType;
	info.func = func;
	info.arg = arg;
	info.playSound = playSound;

	table.insert(titleInfo, info);
end

local function TitleButtonShow(self, event, start, finish, current)
	local multiElement = start ~= finish;
	local firstElement = current == start;
	local lastElement = current == finish;
	local moveElement = current > start and current < finish;
	local width = self.Scroll.ScrollChildFrame:GetWidth()
	local totalHeight = 0;

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
		{ name = "EXIT", show = event == 'GOSSIP_SHOW' },
	}
	
	GwImmersiveFrame.titleButtons = ReleaseAll(GwImmersiveFrame.titlePool);
	
	for id, value in ipairs(ShowElement) do
		if (value.show) then
			for _, info in ipairs(GwImmersiveFrame.buttonTitleInfo[value.name]) do
				local button, key = GetItemButton(GwImmersiveFrame.titlePool, GwImmersiveFrame.titleButtons, self.Scroll.ScrollChildFrame, width);	
				local keyTitle = key < 11 and key..". " or "";

				if (info.buttonType == "AVAILABLE") then
					button:SetQuest(keyTitle..info.title, info.questLevel, info.isTrivial, info.frequency, info.repeatable, info.isLegendary, info.isIgnored, info.questID);
				elseif (info.buttonType == "ACTIVE") then
					button:SetActiveQuest(keyTitle..info.title, info.questLevel, info.isTrivial, info.isComplete, info.isLegendary, info.isIgnored, info.questID);
				elseif (info.buttonType == "GOSSIP") then
					button:SetOption(keyTitle..info.name, info.type, info.spellID);
				else
					button:SetAction(keyTitle..GetInteractiveText(info.buttonType), id - 4);
				end

				button:SetFunction(key, info.func, info.arg, info.playSound);
				button:SetHighlight(GwImmersiveFrame.GossipFrame.TitleHighlightTexture)

				if (key > 1) then
					button:SetPoint('TOPLEFT', GwImmersiveFrame.titleButtons[key - 1], 'BOTTOMLEFT', width, -5);
				else
					button:SetPoint('TOPLEFT', self.Scroll.ScrollChildFrame, 'TOPLEFT', width, 0);
				end

				button:Show();
				totalHeight = totalHeight + button:GetHeight() + 5;
			end
		end
	end

	self.Scroll.ScrollChildFrame:SetHeight(totalHeight);

	if ((event == "QUEST_PROGRESS" or event == "QUEST_DETAIL" or event == "QUEST_COMPLETE") and lastElement) then
		if (not self.Detail:IsShown()) then
			self.Detail.Scroll.ScrollBar:SetValue(0);
			self.Detail:Show();
			if (self.Detail.Scroll.ScrollChildFrame:GetHeight() == 0) then
				self.Detail:Hide();
			end
		end
	else
		if (self.Detail:IsShown()) then
			self.Detail:Hide();
		end
	end
end

local function StopAnimationDialog(self)
	self.nextFunc = nil;
	
	self.GossipFrame.Dialog.Text:SetAlphaGradient(self.GossipFrame.maxSizeText, 1);
	self.GossipFrame.Scroll.ScrollChildFrame:Show();	
	self.GossipFrame.Scroll.ScrollBar:SetAlpha(1);	
end

local function Dialog(self, numPart)
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
							self.nextFunc(self);
						end	
					end);
				else
					StopAnimationDialog(GwImmersiveFrame)
				end
			end
		)	

		TitleButtonShow(self.GossipFrame, self.lastEvent, 1, #self.splitDialog, self.numPartDialog);
	end
end

local function NextDialog(self)
	if (self.numPartDialog and not ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
		local num = self.numPartDialog + 1;

		Dialog(self, num);
	end
end

local function BackDialog(self)
	if (self.numPartDialog and not ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
		local num = self.numPartDialog - 1;
		
		Dialog(self, num);
	end
end

local function ResetDialog(self)
	self.nextFunc = NextDialog;
	self.numPartDialog = 0;

	NextDialog(self)
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------- REWARD/DETALIE -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
do 
	local TEMPLETE = {
		events = {
			QUEST_DETAIL = {
				canHaveSealMaterial = true,
				detail = {
					function (self) return self:ShowObjectivesText(); end,
					function (self) return self:ShowSpecialObjectives(); end,
					function (self) return self:ShowRewards(); end,
					function (self) return self:ShowSeal(); end
				}
			},
			QUEST_PROGRESS = {
				detail = {
					function (self) return self:ShowProgress(); end
				}
			},
			QUEST_COMPLETE = {
				canHaveSealMaterial = true,
				chooseItems = true,
				detail = {
					function (self) return self:ShowRewards(); end
				}
			}
		}
	}

	local REWARDS_OFFSET = 5;

	GwGossipDetailMixin = {}

	function GwGossipDetailMixin:AddElement(element, special, index)
		--element:ClearAllPoints();
		if (special) then
			if (GetSetting("FULL_SCREEN")) then 
				element:SetPoint('TOPLEFT', self.lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET);

				self.rewardsCount = self.rewardsCount + 1;
			else
				-- if ( buttonIndex > 1 ) then
				-- 	if ( mod(buttonIndex, ITEMS_PER_ROW) == 1 ) then
				-- 		questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
				-- 		lastFrame = questItem
				-- 		totalHeight = totalHeight + buttonHeight + 2
				-- 	else
				-- 		questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
				-- 	end
				-- else
				-- 	questItem:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
				-- 	lastFrame = questItem
				-- 	totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
				-- end
			end
		else
			if (self.lastFrame) then
				element:SetPoint('TOPLEFT', self.lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET);
			else
				element:SetPoint('TOPLEFT', 0, -REWARDS_OFFSET);
			end
		end

		element:Show();

		self.lastFrame = element;
		self.totalHeight = self.totalHeight + element:GetHeight() + REWARDS_OFFSET;
	end

	function GwGossipDetailMixin:UpdateItemInfo(button)
		if button.objectType == 'item' then
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo(button.type, button:GetID());
			-- For the tooltip
			button.Name:SetText(name);
			button.itemTexture = texture;
			SetItemButtonCount(button, numItems);
			SetItemButtonTexture(button, texture);
			if (isUsable) then
				SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(button, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(button, 0.9, 0, 0);
				SetItemButtonNameFrameVertexColor(button, 0.9, 0, 0);
			end
		elseif button.objectType == 'currency' then
			local name, texture, numItems, quality = GetQuestCurrencyInfo(button.type, button:GetID())
			local currencyID = GetQuestCurrencyID(button.type, button:GetID());
			name, texture, numItems, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numItems, name, texture, quality);
			-- For the tooltip
			button.Name:SetText(name)
			button.itemTexture = texture
			SetItemButtonCount(button, numItems, true)
			SetItemButtonTexture(button, texture)
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0)
			SetItemButtonNameFrameVertexColor(button, 1.0, 1.0, 1.0)
		elseif button.objectType == 'questSessionBonusReward' then
			local QUEST_SESSION_BONUS_REWARD_ITEM_COUNT = 1;
			local QUEST_SESSION_BONUS_REWARD_ITEM_ID = 171305;

			button.Name:SetText(C_Item.GetItemNameByID(QUEST_SESSION_BONUS_REWARD_ITEM_ID));
			SetItemButtonCount(button, QUEST_SESSION_BONUS_REWARD_ITEM_COUNT);
			SetItemButtonTexture(button, C_Item.GetItemIconByID(QUEST_SESSION_BONUS_REWARD_ITEM_ID));
			SetItemButtonQuality(button, C_Item.GetItemQualityByID(QUEST_SESSION_BONUS_REWARD_ITEM_ID), QUEST_SESSION_BONUS_REWARD_ITEM_ID);
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0);
			SetItemButtonNameFrameVertexColor(button, 1.0, 1.0, 1.0);
		

			button:SetID(QUEST_SESSION_BONUS_REWARD_ITEM_ID);
		end
	end

	function GwGossipDetailMixin:ShowObjectivesText()
		local questObjectives = GetObjectiveText();

		if (questObjectives ~= nil) then
			self.objectiveText:SetText(questObjectives);
			self:AddElement(self.objectiveText);
		end
	end

	function GwGossipDetailMixin:ShowSpecialObjectives()
		local spellID, spellName, spellTexture, finished = GetCriteriaSpell();

		if (spellID) then
			if (finished) then
				self.SpecialObjectivesFrame.SpellObjectiveLearnLabel:SetText(LEARN_SPELL_OBJECTIVE.." ("..COMPLETE..")");
				self.SpecialObjectivesFrame.SpellObjectiveLearnLabel:SetTextColor(0.2, 0.2, 0.2);
			else
				self.SpecialObjectivesFrame.SpellObjectiveLearnLabel:SetText(LEARN_SPELL_OBJECTIVE);
				self.SpecialObjectivesFrame.SpellObjectiveLearnLabel:SetTextColor(0, 0, 0);
			end

			self.SpecialObjectivesFrame.SpellObjectiveFrame.Icon:SetTexture(spellTexture);
			self.SpecialObjectivesFrame.SpellObjectiveFrame.Name:SetText(spellName);
			self.SpecialObjectivesFrame.SpellObjectiveFrame.spellID = spellID;

			self:AddElement(self.SpecialObjectivesFrame);
		end
	end

	function GwGossipDetailMixin:ShowSeal()
		if (self.canHaveSealMaterial) then
			local sealInfo = C_QuestLog.GetQuestDetailsTheme(self.questID);
			if (sealInfo) then
				self.SealFrame.Text:SetText(sealInfo.signature);
				self.SealFrame.Texture:SetAtlas(sealInfo.seal);

				self:AddElement(self.SealFrame);
			end
		end
	end

	function GwGossipDetailMixin:ShowRewards()
		local numQuestRewards = GetNumQuestRewards();
		local numQuestChoices = GetNumQuestChoices();
		local numQuestCurrencies = GetNumRewardCurrencies();
		local money = GetRewardMoney();
		local skillName, skillIcon, skillPoints = GetRewardSkillPoints();
		local xp = GetRewardXP();
		local artifactXP, artifactCategory = GetRewardArtifactXP();
		local honor = GetRewardHonor();
		local playerTitle = GetRewardTitle();
		local numSpellRewards = GetNumRewardSpells();
		local hasWarModeBonus = C_QuestLog.QuestCanHaveWarModeBonus(self.questID);

		GwImmersiveFrame.rewardButtons = ReleaseAll(GwImmersiveFrame.rewardPool);
		GwImmersiveFrame.rewardSpellButtons = ReleaseAll(GwImmersiveFrame.rewardSpellPool);
		GwImmersiveFrame.rewardFollowerButtons = ReleaseAll(GwImmersiveFrame.rewardFollowerPool);
		GwImmersiveFrame.headerSpellButtons = ReleaseAll(GwImmersiveFrame.headerSpellPool);

		local numQuestSpellRewards = 0;
		for rewardSpellIndex = 1, numSpellRewards do
			local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetRewardSpell(rewardSpellIndex);
			local knownSpell = tonumber(spellID) and IsSpellKnownOrOverridesKnown(spellID);

			if (texture and not knownSpell and (not isBoostSpell or IsCharacterNewlyBoosted()) and (not garrFollowerID or not C_Garrison.IsFollowerCollected(garrFollowerID))) then
				numQuestSpellRewards = numQuestSpellRewards + 1;
			end
		end

		local totalRewards = numQuestRewards + numQuestChoices + numQuestCurrencies;
		if (totalRewards == 0 and money == 0 and xp == 0 and not playerTitle and numQuestSpellRewards == 0 and artifactXP == 0) then
			return 0;
		end

		self:AddElement(self.Header);

		local hasChanceForQuestSessionBonusReward = C_QuestLog.QuestHasQuestSessionBonus(self.questID);
		if (numQuestRewards > 0 or numQuestCurrencies > 0 or money > 0 or xp > 0 or honor > 0 or hasChanceForQuestSessionBonusReward) then
			if hasWarModeBonus and C_PvP.IsWarModeDesired() then
				self.WarModeBonusFrame.Count:SetFormattedText(PLUS_PERCENT_FORMAT, C_PvP.GetWarModeRewardBonus());

				self:AddElement(self.WarModeBonusFrame);
			end

			if (money > 0) then
				MoneyFrame_Update(self.MoneyFrame.Money, money);

				self:AddElement(self.MoneyFrame);
			end

			if (xp > 0) then
				self.XPFrame.ValueText:SetText(BreakUpLargeNumbers(xp));

				self:AddElement(self.XPFrame);		
			end
			
			if (honor > 0) then
				local faction = UnitFactionGroup('player');
				local icon = faction and ('Interface/Icons/PVPCurrency-Honor-%s'):format(faction);

				self.HonorFrame.Count:SetText(BreakUpLargeNumbers(honor));
				self.HonorFrame.Name:SetText(HONOR);
				self.HonorFrame.Icon:SetTexture(icon);

				self:AddElement(self.HonorFrame);	
			end

			if (artifactXP > 0) then
				local name, icon = C_ArtifactUI.GetArtifactXPRewardTargetInfo(artifactCategory);
				
				self.ArtifactXPFrame.Name:SetText(BreakUpLargeNumbers(artifactXP));
				self.ArtifactXPFrame.Icon:SetTexture(icon or 'Interface/Icons/INV_Misc_QuestionMark');
				
				self:AddElement(self.ArtifactXPFrame);
			end

			if (skillPoints) then
				self.SkillPointFrame.ValueText:SetText(skillPoints);
				self.SkillPointFrame.Icon:SetTexture(skillIcon);
				if (skillName) then
					self.SkillPointFrame.Name:SetFormattedText(BONUS_SKILLPOINTS, skillName);
					self.SkillPointFrame.tooltip = format(BONUS_SKILLPOINTS_TOOLTIP, skillPoints, skillName);
				else
					self.SkillPointFrame.tooltip = nil;
					self.SkillPointFrame.Name:SetText('');
				end
				
				self:AddElement(self.SkillPointFrame);
			end
			
			if (playerTitle) then
				self.TitleFrame.Name:SetText(playerTitle);

				self:AddElement(self.PlayerTitleText);
				self:AddElement(self.TitleFrame);
			end

			if (numQuestRewards > 0) then
				self:AddElement(self.ItemText);
				for index = 1, numQuestRewards, 1 do
					local questItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
					questItem.type = 'reward';
					questItem.objectType = 'item';
					questItem:SetID(index);		

					self:UpdateItemInfo(questItem);		
					self:AddElement(questItem, true, index);
				end
			end

			if (numQuestCurrencies > 0) then
				self:AddElement(self.CurrencyText);
				for index = 1, numQuestCurrencies, 1 do
					local questItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
					questItem.type = 'reward';
					questItem.objectType = 'currency';
					questItem:SetID(index);

					self:UpdateItemInfo(questItem);
					self:AddElement(questItem, true, index);
				end
			end

			if hasChanceForQuestSessionBonusReward then
				self:AddElement(self.QuestSessionBonusReward);

				local questItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
				questItem.type = "reward";
				questItem.objectType = "questSessionBonusReward";

				self:UpdateItemInfo(questItem);
				self:AddElement(questItem, true, 1);
			end
		end
		
		if (numQuestChoices > 0) then
			self.ItemChooseText:SetText((numQuestChoices == 1 and REWARD_ITEMS_ONLY) or (self.chooseItems and REWARD_CHOOSE) or REWARD_CHOICES);

			self:AddElement(self.ItemChooseText);

			local highestValue, moneyItem
			for index = 1, numQuestChoices do
				local questItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
				questItem.type = 'choice';
				questItem.objectType = 'item';
				numItems = 1;
				questItem:SetID(index);	

				self:UpdateItemInfo(questItem);	
				self:AddElement(questItem, true, index);

				local link = GetQuestItemLink(questItem.type, index);
				local vendorValue = link and select(11, GetItemInfo(link));

				if vendorValue and ( not highestValue or vendorValue > highestValue ) then
					highestValue = vendorValue;
					if vendorValue > 0 and numQuestChoices > 1 then
						moneyItem = questItem;
					end
				end	
			end	

			if (moneyItem) then
				self.MoneyIcon:SetPoint('BOTTOMRIGHT', moneyItem, -13, 6);
				self.MoneyIcon:Show();
			end	
		end

		if (numQuestSpellRewards > 0) then
			local spellBuckets = {}

			-- Generate spell buckets
			for rewardSpellIndex = 1, numSpellRewards do
				local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetRewardSpell(rewardSpellIndex);
				local knownSpell = IsSpellKnownOrOverridesKnown(spellID);
				if (texture and not knownSpell and (not isBoostSpell or IsCharacterNewlyBoosted()) and (not garrFollowerID or not C_Garrison.IsFollowerCollected(garrFollowerID))) then
					local bucket = 	isTradeskillSpell 	and QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL or
									isBoostSpell 		and QUEST_SPELL_REWARD_TYPE_ABILITY or
									garrFollowerID 		and QUEST_SPELL_REWARD_TYPE_FOLLOWER or
									isSpellLearned 		and QUEST_SPELL_REWARD_TYPE_SPELL or
									genericUnlock 		and QUEST_SPELL_REWARD_TYPE_UNLOCK or QUEST_SPELL_REWARD_TYPE_AURA;
					
									-- local followerInfo = C_Garrison.GetFollowerInfo(garrFollowerID);
									-- if followerInfo.followerTypeID == Enum.GarrisonFollowerType.FollowerType_9_0 then
									-- 	AddSpellToBucket(spellBuckets, QUEST_SPELL_REWARD_TYPE_COMPANION, rewardSpellIndex);
									-- else
									-- 	AddSpellToBucket(spellBuckets, QUEST_SPELL_REWARD_TYPE_FOLLOWER, rewardSpellIndex);
									-- end

					if (not spellBuckets[type]) then
						spellBuckets[type] = {}
					end

					local spellBucket = spellBuckets[type];
					spellBucket[#spellBucket + 1] = rewardSpellIndex;
				end
			end

			-- Sort buckets in the correct order
			for orderIndex, spellBucketType in ipairs(QUEST_INFO_SPELL_REWARD_ORDERING) do
				local spellBucket = spellBuckets[spellBucketType];
				if (spellBucket) then
					for i, rewardSpellIndex in ipairs(spellBucket) do
						local texture, name, isTradeskillSpell, isSpellLearned, _, isBoostSpell, garrFollowerID = GetRewardSpell(rewardSpellIndex);
						if i == 1 then
							local header = GetItemButton(GwImmersiveFrame.headerSpellPool, GwImmersiveFrame.headerSpellButtons, self);
							header:SetText(QUEST_INFO_SPELL_REWARD_TO_HEADER[spellBucketType]);
							-- if self.spellHeaderPool.textR and self.spellHeaderPool.textG and self.spellHeaderPool.textB then
							-- 	header:SetVertexColor(self.spellHeaderPool.textR, self.spellHeaderPool.textG, self.spellHeaderPool.textB)
							-- end

							self:AddElement(header);
						end

						if (garrFollowerID) then
							local followerFrame = GetItemButton(GwImmersiveFrame.rewardFollowerPool, GwImmersiveFrame.rewardFollowerButtons, self);
							local followerInfo = C_Garrison.GetFollowerInfo(garrFollowerID);
							followerFrame.Name:SetText(followerInfo.name);
							followerFrame.Class:SetAtlas(followerInfo.classAtlas);
							followerFrame.PortraitFrame:SetupPortrait(followerInfo);
							followerFrame.ID = garrFollowerID;
							
							self:AddElement(followerFrame);
						else
							local spellRewardFrame = GetItemButton(GwImmersiveFrame.rewardSpellPool, GwImmersiveFrame.rewardSpellButtons, self);
							spellRewardFrame.Icon:SetTexture(texture);
							spellRewardFrame.Name:SetText(name);
							spellRewardFrame.rewardSpellIndex = rewardSpellIndex;

							self:AddElement(spellRewardFrame);
						end
					end
				end
			end
		end
	end

	function GwGossipDetailMixin:ShowProgress()
		local numRequiredMoney = GetQuestMoneyToGet();
		local numRequiredItems = GetNumQuestItems();
		local numRequiredCurrencies = GetNumQuestCurrencies();

		GwImmersiveFrame.rewardButtons = ReleaseAll(GwImmersiveFrame.rewardPool);

		-- numRequiredMoney = math.random(100, 1000);
		-- numRequiredItems = math.random(10, 20);
		-- numRequiredCurrencies = math.random(5, 10);

		if (numRequiredMoney > 0) then
			MoneyFrame_Update(self.MoneyFrame.Money, numRequiredMoney);
			
			local moneyColor, moneyVertex;
			
			if (numRequiredMoney < GetMoney()) then
				moneyColor, moneyVertex = 'red', 0.2;
			end

			self.MoneyFrame.Title:SetTextColor(moneyVertex, moneyVertex, moneyVertex);
			SetMoneyFrameColor(self.MoneyFrame.Money, moneyColor);

			self:AddElement(self.MoneyFrame);
		end

		if (numRequiredItems > 0) then
			for RequiredItems = 1, numRequiredItems do	
				local hidden = IsQuestItemHidden(RequiredItems);
				if (hidden == 0) then
					if (RequiredItems == 1) then
						self:AddElement(self.ItemText);
					end

					local requiredItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
					requiredItem.type = 'required';
					requiredItem.objectType = 'item';
					requiredItem:SetID(RequiredItems);
						
					self:UpdateItemInfo(requiredItem);
					self:AddElement(requiredItem, true, RequiredItems);
				end
			end
		end

		if (numRequiredCurrencies > 0) then
			self:AddElement(self.CurrencyText);
			for RequiredCurrencies = 1, numRequiredCurrencies do	
				local requiredItem = GetItemButton(GwImmersiveFrame.rewardPool, GwImmersiveFrame.rewardButtons, self);
				requiredItem.type = 'required';
				requiredItem.objectType = 'currency';
				requiredItem:SetID(RequiredCurrencies);

				self:UpdateItemInfo(requiredItem);
				self:AddElement(requiredItem, true, RequiredCurrencies);
			end
		end
	end

	function GwGossipDetailMixin:Update()
		if (self:IsShown()) then
			self:Hide();
			self:Show();
		end
	end

	function GwGossipDetailMixin:OnLoad()
		self.ItemText:SetText(ITEMS..":");
		self.CurrencyText:SetText(CURRENCY..":");
		self.MoneyFrame.MoneyText:SetText(MONEY..":");
	end

	function GwGossipDetailMixin:OnShow()
		self.totalHeight = 0;
		self.rewardsCount = 0;

		local activeTemplete = TEMPLETE.events[GwImmersiveFrame.lastEvent];
		self.canHaveSealMaterial  = activeTemplete.canHaveSealMaterial;
		self.chooseItems = activeTemplete.chooseItems;
		self.questID = GetQuestID();

		for _, element in pairs(activeTemplete.detail) do
			element(self);
		end

		if (self.totalHeight > 0) then
			self:SetHeight(self.totalHeight);
			self:Show();
		end
	end

	function GwGossipDetailMixin:OnHide()
		self.totalHeight = nil;
		self.rewardsCount = nil;
		self.lastFrame = nil;

		for _, getChild in pairs({function (self) return self:GetChildren(); end, function (self) return self:GetRegions(); end}) do
			local childrenFrames = {getChild(self)};
			
			for _, child in pairs(childrenFrames) do
				child:Hide();
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- EVENT ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

do
	local function NPCFriendshipStatusBar_Update(gossipFrame, factionID --[[ = nil ]])
		local statusBar = gossipFrame.ReputationBar;
		local id, rep, maxRep, name, text, texture, reaction, threshold, nextThreshold = GetFriendshipReputation(factionID);
		statusBar.friendshipFactionID = id;
		if (id and id > 0) then
			if (not nextThreshold) then
				threshold, nextThreshold, rep = 0, 1, 1;
			end
			if (texture) then
				statusBar.icon:SetTexture(texture);
			else
				statusBar.icon:SetTexture("Interface/Common/friendship-heart");
			end
			statusBar:SetMinMaxValues(threshold, nextThreshold);
			statusBar:SetValue(rep);
			statusBar:Show();
		else
			statusBar:Hide();
		end
	end

	local function Split(self, text, maxSizeText)
		self.splitDialog = {}
		
		local unitName ="";
		if (self.FullScreen) then
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

	local function Overlap(self, currentEvent)
		if (type(currentEvent) == 'string') then
			if (currentEvent == 'QUEST_ITEM_UPDATE' or  currentEvent == 'QUEST_LOG_UPDATE' or currentEvent == 'LEARNED_SPELL_IN_TAB') then
				return;
			elseif (self.lastEvent == "GOSSIP_SHOW" and currentEvent:match('^QUEST')) then
				C_GossipInfo.CloseGossip();
			end

			self.lastEvent = currentEvent;
		end
	end

	local function CustomeGossip(self, textureKit)
		if (textureKit) then
			local handler = textureKit and self:GetGossipHandler(textureKit)
			if handler then
				self.customFrame = handler(textureKit)
				return true;
			else
				--self.GossipFrame.Dialog:SetAtlas(GossipFrame_GetBackgroundTexture(self.GossipFrame, textureKit), TextureKitConstants.UseAtlasSize);
			end
		end

		return false;
	end

	local function IsGossipAvailable()
		if (C_GossipInfo.GetNumAvailableQuests() == 0 and C_GossipInfo.GetNumActiveQuests()  == 0 and C_GossipInfo.GetNumOptions() == 1 and not C_GossipInfo.ForceGossip()) then
			local gossipInfoTable = C_GossipInfo.GetOptions();
			if (gossipInfoTable[1].type ~= "gossip") then
				C_GossipInfo.SelectOption(1);
				return false;
			end
		end

		return true;
	end

	local function IsQuestAutoAccepted(questStartItemID)
		if (QuestIsFromAdventureMap()) then
			return true;
		end

		if ((questStartItemID ~= nil and questStartItemID ~= 0) or (QuestGetAutoAccept() and QuestIsFromAreaTrigger())) then
			if (AutoQuestPopupTracker_AddPopUp(GetQuestID(), "OFFER", questStartItemID)) then
				PlayAutoAcceptQuestSound();
			end
			CloseQuest();
			return true;
		end

		return false;
	end

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
		local GreetingAvailableQuests = GetNumAvailableQuests();
		for ID = 1, GreetingAvailableQuests do
			local Info = {}

			Info.isTrivial, Info.frequency, Info.isRepeatable, Info.isLegendary, Info.questID = GetAvailableQuestInfo(ID);
			Info.titleText = GetAvailableTitle(ID);

			TitleButtonUpdate(self.buttonTitleInfo, Info, "AVAILABLE", SelectAvailableQuest, ID, SOUNDKIT.IG_QUEST_LIST_SELECT);
		end
	end

	local function GetActiveQuestsGreeting(self)
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

		SetUnitModel(self.GossipFrame.Models.Player, "player", false)
		SetUnitModel(self.GossipFrame.Models.Giver, UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none", false)

		if (title) then
			self.GossipFrame.Title.Text:SetText(title);
			self.GossipFrame.Title:Show();
		else
			self.GossipFrame.Title:Hide();
		end

		Split(self, dialog, self.GossipFrame.maxSizeText);

		ResetDialog(self);
	end

	local function ImmersiveFrameHandleHide(self)
		if (self.customFrame) then
			self.customFrame:Hide()
			self.customFrame = nil;		
		else
			StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
			StopAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLEBUTTON");
			self.splitDialog = nil;
			self.numPartDialog = nil;
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
		Overlap(self, event);
		if (event == 'GOSSIP_SHOW') then
			if (not CustomeGossip(...) and IsGossipAvailable()) then
				GetAvailableQuestsGossip(self);
				GetActiveQuestsGossip(self);
				GetOptionsGossip(self);

				ImmersiveFrameHandleShow(self, nil, C_GossipInfo.GetText());
			end
		elseif (event == 'GOSSIP_CLOSED') then
			ImmersiveFrameHandleHide(self)
		elseif (event == 'QUEST_GREETING') then
			GetAvailableQuestsGreeting(self);
			GetActiveQuestsGreeting(self);

			ImmersiveFrameHandleShow(self, nil, GetGreetingText());
		elseif (event == 'QUEST_DETAIL') then
			if (not IsQuestAutoAccepted(...)) then
				ImmersiveFrameHandleShow(self, GetTitleText(), GetQuestText());
			end
		elseif (event == 'QUEST_PROGRESS') then
			ImmersiveFrameHandleShow(self, GetTitleText(), GetProgressText());
		elseif (event == 'QUEST_COMPLETE') then
			ImmersiveFrameHandleShow(self, GetTitleText(), GetRewardText());
		elseif (event == 'QUEST_FINISHED') then
			ImmersiveFrameHandleHide(self);
		elseif (event == 'QUEST_ITEM_UPDATE') then
			if (self.GossipFrame.Detail:IsShown()) then
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
				self.GossipFrame.Detail.Scroll.ScrollChildFrame:Update();
			end
		elseif (event == 'UNIT_MODEL_CHANGED') then
			if (self.GossipFrame:IsShown()) then
				local unit = ...
				local frame = (unit == "player") and self.GossipFrame.Models.Player or self.GossipFrame.Models.Giver

				SetUnitModel(frame, unit, true)
			end
		end
	end 

	local function ImmersiveViewOnKeyDown(self, button)
		if (button == 'ESCAPE') then
			if (not QuestGetAutoAccept()) then
				CloseItemText();
				CloseQuest();
				C_GossipInfo.CloseGossip();
				PlaySound(SOUNDKIT.IG_QUEST_LIST_CLOSE);
			end
			return;
		elseif (button == "SPACE") then
			if (ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
				StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
				StopAnimationDialog(GwImmersiveFrame);
			end

			self:SetPropagateKeyboardInput(false);
			return;
		elseif (button == "R") then
			ResetDialog(GwImmersiveFrame);

			self:SetPropagateKeyboardInput(false);
			return;
		elseif (button == "F1") then
			ImmersiveFrameHandleHide(GwImmersiveFrame)
			GwImmersiveFrame.FullScreen = not GwImmersiveFrame.FullScreen
			SetFontColor(GwImmersiveFrame.FullScreen and GetSetting("STYLE") or "NORMAL")
			GwImmersiveFrame.GossipFrame = GwImmersiveFrame.FullScreen and GwFullScreenGossipViewFrame or GwGossipViewFrame
			GwImmersiveFrameOnEvent(GwImmersiveFrame, GwImmersiveFrame.lastEvent);

			self:SetPropagateKeyboardInput(false);
			return;
		elseif (button == "F2") then


			self:SetPropagateKeyboardInput(false);
			return;
		elseif (button == "F3") then
			GwImmersiveFrame.enableClick = not GwImmersiveFrame.enableClick

			self:SetPropagateKeyboardInput(false);
			return;
		end

		local num = tonumber(button);
		if (num and self.Scroll.ScrollChildFrame:IsShown() and GwImmersiveFrame.titleButtons[num]) then
			GwImmersiveFrame.titleButtons[num]:Click();

			self:SetPropagateKeyboardInput(false);
			return;
		else
			self:SetPropagateKeyboardInput(true);
		end
	end

	local function DialogOnClick(self, button)
		if (not GwImmersiveFrame.enableClick) then
			return;
		end

		if (ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION")) then
			StopAnimation("IMMERSIVE_DIALOG_ANIMATION");
			StopAnimationDialog(GwImmersiveFrame);
		else
			if(button == "LeftButton") then
				NextDialog(GwImmersiveFrame);
			elseif (button == "RightButton") then
				BackDialog(GwImmersiveFrame);
			end
		end
	end

	local function LoadImmersiveView()
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

		function GossipTitleButtonMixin:SetHighlight(texture)
			self:SetHighlightTexture(texture);
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

			return self.startAnimationText and self.lenghtAnimationText and self.frameAnimationText;
		end
		
		function GossipTitleButtonMixin:OnClick()
			if (not ActiveAnimation("IMMERSIVE_DIALOG_ANIMATION") and self.func) then
				local finishFunc = function()
					self.func(self.arg);

					if (self.playSound) then
						PlaySound(self.playSound);	
					end
				end	
				
				if (self:SetAnimationText()) then
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
						finishFunc
					)	
				else
					finishFunc();	
				end
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

		for _, frame in ipairs({GossipFrame, QuestFrame}) do
			frame:UnregisterAllEvents()
			frame:EnableMouse(false)
			frame:EnableKeyboard(false)
			frame:ClearAllPoints()
		end

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
			gF.Scroll.ScrollChildFrame:SetWidth(gF.Scroll:GetWidth())
			gF:SetScript("OnKeyDown", ImmersiveViewOnKeyDown)
			gF.Dialog:SetScript("OnClick", DialogOnClick)
		end
		RegisterMovableFrame(GwGossipViewFrame, L["Gossip View Frame"], "GwGossipViewFramePos", "VerticalActionBarDummy", nil, nil, {"scaleable"} )
		GwGossipViewFrame:ClearAllPoints()
		GwGossipViewFrame:SetAllPoints(GwGossipViewFrame.gwMover)
		
		GwImmersiveFrame.titlePool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate")
		GwImmersiveFrame.rewardPool = CreateFramePool("BUTTON", nil, "GwGossipItemButtonTemplate, GwGossipRewardItemCodeTemplate")
		GwImmersiveFrame.rewardSpellPool = CreateFramePool("BUTTON", nil, "GwQuestSpellTemplate, GwRewardSpellCodeTemplate")
		GwImmersiveFrame.rewardFollowerPool = CreateFramePool("BUTTON", nil, "LargeQuestInfoRewardFollowerTemplate")
		GwImmersiveFrame.headerSpellPool = CreateFontStringPool(nil, "BACKGROUND", 0, "QuestInfoSpellHeaderTemplate")
		
		GwImmersiveFrame.buttonTitleInfo = {}
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "NEXT", NextDialog, GwImmersiveFrame, SOUNDKIT.IG_QUEST_LIST_OPEN)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "BACK", BackDialog, GwImmersiveFrame, SOUNDKIT.IG_QUEST_LIST_OPEN)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "ACCEPT", 	
			function ()
				if (QuestFlagsPVP()) then
					StaticPopup_Show('CONFIRM_ACCEPT_PVP_QUEST');
				else
					if (QuestGetAutoAccept()) then
						AcknowledgeAutoAcceptQuest();
					else
						AcceptQuest();
					end
				end
			end, 
			nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "DECLINE", DeclineQuest, nil, SOUNDKIT.IG_QUEST_CANCEL)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "COMPLETE", CompleteQuest, nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "FINISH", 		
			function ()
				local numQuestChoices = GetNumQuestChoices();	
				if (numQuestChoices ~= 0) then
					QuestChooseRewardError();
				else
					GetQuestReward();
				end
			end, 
			nil, SOUNDKIT.IG_QUEST_LIST_OPEN)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "CANCEL", CloseQuest, nil, SOUNDKIT.IG_QUEST_LIST_CLOSE)
		TitleButtonUpdate(GwImmersiveFrame.buttonTitleInfo, {}, "EXIT", C_GossipInfo.CloseGossip, nil, SOUNDKIT.IG_QUEST_LIST_CLOSE)

		GwImmersiveFrame.FullScreen = GetSetting("FULL_SCREEN")
		GwImmersiveFrame.GossipFrame = GwImmersiveFrame.FullScreen and GwFullScreenGossipViewFrame or GwGossipViewFrame
		GwImmersiveFrame.enableClick = GetSetting("MOUSE_DIALOG") 

		FullScreenBorderStyle(GwFullScreenGossipViewFrame, GetSetting("STYLE"))
		SetFontColor(GwImmersiveFrame.FullScreen and GetSetting("STYLE") or "NORMAL")
		DinamicArt(GetSetting("DINAMIC_ART"))
		LoadModelInfo(GwGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
		DebugModel(GwGossipViewFrame.Models, GwFullScreenGossipViewFrame.Models)
	end

	GW.LoadImmersiveView = LoadImmersiveView
end