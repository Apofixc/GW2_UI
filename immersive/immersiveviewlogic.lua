local _, GW = ...
local L = GW.L
local Model = GW.Libs.Model
local GetSetting = GW.GetSetting
local AddToAnimation = GW.AddToAnimation
local StopAnimation = GW.StopAnimation
local CheckStateAnimation =  GW.CheckStateAnimation
local IsIn = GW.IsIn

local INTERACTIVE_TEXT = {
	ACCEPT = {ACCEPT},
	DECLINE = {DECLINE},
	NEXT = {NEXT, CONTINUE},
	BACK = {BACK},
	CANCEL = {EXIT, CANCEL},
	EXIT = {EXIT, GOODBYE},
	COMPLETE = {COMPLETE, COMPLETE_QUEST},
	FINISH = {L["Finish"]},
	RESET = {RESET}
}

local function GetImmersiveInteractiveText(buttonType)
	return INTERACTIVE_TEXT[buttonType][math.random(1, #INTERACTIVE_TEXT[buttonType])]
end

do
	local BACKGROUNDS = {
		[{[1161] = true, [895] = true, [1196] = true, [876] = true}] = {["uiTextureKit"] = "TiragardeSound", ["typeTextureKit"] = "Dinamic"},
		[{[942] = true, [1198] = true}] = {["uiTextureKit"] = "Stormsong", ["typeTextureKit"] = "Dinamic"},
		[{[896] = true, [1197] = true}] = {["uiTextureKit"] = "Drustvar", ["typeTextureKit"] = "Dinamic"},
		[{[862] = true, [1181] = true, [1193] = true, [1163] = true, [1164] = true, [1165] = true, [1352] = true, [1353] = true, [1354] = true, [1356] = true, [1357] = true, [1358] = true, [1364] = true, [1367] = true, [875] = true}] = {["uiTextureKit"] = "Zuldazar", ["typeTextureKit"] = "Dinamic" },
		[{[864] = true, [1195] = true}] = {["uiTextureKit"] = "Voldun", ["typeTextureKit"] = "Dinamic"},
		[{[863] = true, [1194] = true}] = {["uiTextureKit"] = "Nazmir", ["typeTextureKit"] = "Dinamic"},
		[{[1355] = true, [1504] = true, [1528] = true}] = {["uiTextureKit"] = "Nazjatar", ["typeTextureKit"] = "Dinamic"},
		[{[1462] = true, [1490] = true, [1491] = true, [1493] = true, [1494] = true, [1497] = true}] = {["uiTextureKit"] = "Mechagon", ["typeTextureKit"] = "Dinamic"},
		[{[630] = true, [895] = true, [867] = true, [1187] = true}] = {["uiTextureKit"] = "Azsuna", ["typeTextureKit"] = "Dinamic"},
		[{[41] = true, [125] = true, [126] = true, [501] = true, [502] = true, [625] = true, [626] = true, [627] = true, [628] = true, [629] = true}] = {["uiTextureKit"] = "Dalaran", ["typeTextureKit"] = "Dinamic"},
		[{[650] = true, [869] = true, [870] = true, [1189] = true}] = {["uiTextureKit"] = "Highmountain", ["typeTextureKit"] = "Dinamic"},
		[{[634] = true, [696] = true, [865] = true, [866] = true, [1190] = true}] = {["uiTextureKit"] = "Stormheim", ["typeTextureKit"] = "Dinamic"},
		[{[680] = true, [1191] = true}] = {["uiTextureKit"] = "Suramar", ["typeTextureKit"] = "Dinamic"},
		[{[641] = true, [868] = true, [1188] = true}] = {["uiTextureKit"] = "Valsharah", ["typeTextureKit"] = "Dinamic"},
		[{[905] = true, [994] = true, [885] = true, [882] = true, [830] = true, [831] = true, [887] = true, [883] = true}] = {["uiTextureKit"] = "Argus", ["typeTextureKit"] = "Dinamic"},
		[{[619] = true}] = {["uiTextureKit"] = "Legion", ["typeTextureKit"] = "Dinamic" },
		[{[14] = true, [93] = true, [837] = true, [844] = true, [906] = true, [943] = true, [1044] = true, [1158] = true, [1244] = true, [1366] = true, [1383] = true}] = {["uiTextureKit"] = "ArathiHighlands", ["typeTextureKit"] = "Dinamic"},
		[{[63] = true, [1310] = true}] = {["uiTextureKit"] = "Ashenvale", ["typeTextureKit"] = "Dinamic" },
		[{[76] = true, [697] = true, [1209] = true}] = {["uiTextureKit"] = "Azshara", ["typeTextureKit"] = "Dinamic"},
		[{[62] = true, [1203] = true, [1309] = true, [1332] = true, [1333] = true, [1338] = true, [1343] = true}] = {["uiTextureKit"] = "Darkshore", ["typeTextureKit"] = "Dinamic"},
		[{[1] = true, [1305] = true}] = {["uiTextureKit"] = "Durotar", ["typeTextureKit"] = "Dinamic"},
		[{[25] = true, [274] = true, [623] = true}] = {["uiTextureKit"] = "HillsbradFoothills", ["typeTextureKit"] = "Dinamic"},
		[{[10] = true, [1307] = true}] = {["uiTextureKit"] = "NorthernBarrens", ["typeTextureKit"] = "Dinamic"},
		[{[21] = true, [1248] = true}] = {["uiTextureKit"] = "SilverpineForest", ["typeTextureKit"] = "Dinamic"},
		[{[199] = true, [1329] = true}] = {["uiTextureKit"] = "SouthernBarrens", ["typeTextureKit"] = "Dinamic"},
		[{[525] = true}] = {["uiTextureKit"] = "FrostfireRidge", ["typeTextureKit"] = "Dinamic"},
		[{[543] = true, [1170] = true}] = {["uiTextureKit"] = "Gorgrond", ["typeTextureKit"] = "Dinamic"},
		[{[107] = true, [550] = true}] = {["uiTextureKit"] = "Nagrand", ["typeTextureKit"] = "Dinamic"},
		[{[104] = true, [539] = true}] = {["uiTextureKit"] = "ShadowmoonValley", ["typeTextureKit"] = "Dinamic"},
		[{[542] = true}] = {["uiTextureKit"] = "SpiresofArak", ["typeTextureKit"] = "Dinamic"},
		[{[535] = true, [572] = true}] = {["uiTextureKit"] = "Talador", ["typeTextureKit"] = "Dinamic" },
		[{[534] = true, [577] = true}] = {["uiTextureKit"] = "TannanJungle", ["typeTextureKit"] = "Dinamic"},
	}
	
	local function GetCustomZoneBackground()
		local questID = GetQuestID()		
		if C_CampaignInfo.IsCampaignQuest(questID) then
			local campaignInfo = C_CampaignInfo.GetCampaignInfo(questID)
			if campaignInfo.uiTextureKit then
				return "Campaign", "QuestBG-"..campaignInfo.uiTextureKit, {0.2, 0.99, 0.5, 0.95}
			end
		end
		
		local mapID = C_Map.GetBestMapForUnit("player");
		if mapID then
			repeat
				for map, info in pairs(BACKGROUNDS) do
					if map[mapID] then
						return info.typeTextureKit, info.uiTextureKit, {0, 1, 0, 1}
					end					
				end
				
				local mapInfo = C_Map.GetMapInfo(mapID);
				mapID = mapInfo and mapInfo.parentMapID or 0;
			until mapID == 0
		end			
	
		local classFilename = select(2, UnitClass("player"));
		if classFilename then
			return "Class", "dressingroom-background-"..classFilename, {0, 1, 0.25, 0.75}
		else
			return "Default", "Interface/AddOns/GW2_UI/textures/questview/bg_default", {0, 1, 0, 1}
		end
	end
	GW.GetCustomZoneBackground = GetCustomZoneBackground
end

do
	GWAdvanceGossipTitleButtonMixin = {}
	
	function GWAdvanceGossipTitleButtonMixin:SetAction(titleText, icon)
		self.type = "Action"

		self:SetFormattedText(ACTION_DISPLAY, titleText)
		self.Icon:SetTexture("Interface/AddOns/GW2_UI/textures/gossipview/icon-gossip")
		self.Icon:SetTexCoord(0.25 * floor(icon / 4), 0.25 * (floor(icon / 4) + 1), 0.25 * (icon % 4), 0.25 * ((icon % 4) + 1))
		self.Icon:SetVertexColor(1, 1, 1, 1)
	
		self:Resize()
	end
	
	function GWAdvanceGossipTitleButtonMixin:AddCallbackForClick(id, func, arg, playSound)
		self:SetID(id)

		self.func = func
		self.arg = arg
		self.playSound = playSound
	end

	function GWAdvanceGossipTitleButtonMixin:Resize()
		self:SetHeight(math.max(self:GetTextHeight() + 2, self.Icon:GetHeight()))
		self:SetWidth(self:GetParent():GetWidth())
	end

	function GWAdvanceGossipTitleButtonMixin:OnClick()
		if not CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") and self.func and not self.ShowIn:IsPlaying() then
			local scroll = self:GetParent():GetParent()
			scroll.ScrollBar:SetAlpha(0)
			scroll.ScrollChildFrame:Hide()
			
			if scroll.Icon.SetText then scroll.Icon:SetText("|cFFFF5A00"..UnitName("player")..": ") end			
			scroll.Icon:Show()

			scroll.Text:SetText(self:GetText():gsub("^.*%d+%p%s", ""))
			scroll.Text:Show()

			local lenghtText = strlenutf8(scroll.Text:GetText())
			AddToAnimation(
				"IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON",
				0,
				lenghtText,
				GetTime(),
				GetSetting("ANIMATION_TEXT_SPEED_P") * lenghtText,
				function(step)
					scroll.Text:SetAlphaGradient(step, 1)
				end,
				nil,
				function()
					self.func(self.arg)
					PlaySound(self.playSound)
				end
			)
		end
	end 
end

do 	
	local function AcquireFontString(pool, name)
		local fontString = pool:Acquire()

		if name then
			fontString:SetText(name)		
		end

		if pool.textR and pool.textR and pool.textR then
			fontString:SetTextColor(pool.textR, pool.textG, pool.textB)
		end

		return fontString
	end

	local function AcquireButton(pool, name)
		local button = pool:Acquire()

		if pool.style ~= button.style then
			button.style = pool.style
			--fontString:SetText(name)		

			if not button.onclick then
				button.onclick = true

				button:SetScript("OnClick",
					function (self)
						if IsModifiedClick() and self.objectType == "item" then
							HandleModifiedItemClick(GetQuestItemLink(self.type, self:GetID()))
						elseif GwImmersiveFrame.chooseItems then
							if self.type == "choice" then
								if GwImmersiveFrame.itemChoice == self:GetID() then
									GetQuestReward(GwImmersiveFrame.itemChoice)
								else
									GwQuestInfoRewardsFrame.ItemHighlight:SetPoint("TOPLEFT", self, "TOPLEFT", -8, 7)
									GwQuestInfoRewardsFrame.ItemHighlight:Show()
									GwImmersiveFrame.itemChoice = self:GetID()
								end
							end
						end
					end
				)
			end
		end

		return button
	end

	local function UpdateItemInfo(questItem, objectType, index)
		questItem.objectType = objectType
		print(index)
		questItem:SetID(index)

		if questItem.objectType == "item" then
			local name, texture, numItems, quality, isUsable, itemID = GetQuestItemInfo(questItem.type, index)
			SetItemButtonQuality(questItem, quality, GetQuestItemLink(questItem.type, index))

			questItem.Name:SetText(name)
			questItem.itemTexture = texture
			local item = Item:CreateFromItemID(itemID)
			if item then
				item:ContinueOnItemLoad(function()
					name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, index)
					SetItemButtonQuality(questItem, quality, GetQuestItemLink(questItem.type, index))
			
					questItem.Name:SetText(name)
					SetItemButtonCount(questItem, numItems)
					SetItemButtonTexture(questItem, texture)
					if isUsable then
						SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0)
						SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0)
					else
						SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0)
						SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0)
					end
				end)
			end
		elseif questItem.objectType == "currency" then
			local name, texture, amount, quality = GetQuestCurrencyInfo(questItem.type, index)
			local currencyID = GetQuestCurrencyID(questItem.type, index)
			name, texture, amount, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, amount, name, texture, quality)

			questItem.Name:SetText(name)
			SetItemButtonCount(questItem, amount, true)
			local currencyColor = GetColorForCurrencyReward(currencyID, amount)
			questItem.Count:SetTextColor(currencyColor:GetRGB())
			SetItemButtonTexture(questItem, texture)
			SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0)
			SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0)
			SetItemButtonQuality(questItem, quality, currencyID)
		elseif questItem.objectType == "questSessionBonusReward" then
			local item = Item:CreateFromItemID(index);
			if item then
				item:ContinueOnItemLoad(function()
						questItem.Name:SetText(item:GetItemName())
						SetItemButtonCount(questItem, 1)
						SetItemButtonTexture(questItem, item:GetItemIcon())
						SetItemButtonQuality(questItem, item:GetItemQuality(), index)
						SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0)
						SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0)
					end
				)
			end
		end
	end

	local function ShowObjectivesText()
		local questObjectives = GetObjectiveText()

		if questObjectives then
			GwQuestInfoObjectivesText:SetText(questObjectives)
			return GwQuestInfoObjectivesText
		else
			return nil
		end
	end

	local function ShowSpecialObjectives()
		return QuestInfo_ShowSpecialObjectives()
	end

	local function ShowGroupSize()
		return QuestInfo_ShowGroupSize()
	end

	local function ShowSeal() 
		local theme = QuestInfoSealFrame.theme
		if  theme and (theme.signature ~= "" or theme.seal) then
			QuestInfoSealFrame.Text:SetText(theme.signature)
			QuestInfoSealFrame.Texture:SetAtlas(theme.seal)

			return QuestInfoSealFrame
		else
			return nil
		end
	end

	local function ShowProgress(format) 
		GwQuestInfoProgress.headerProgressPool:ReleaseAll()
		GwQuestInfoProgress.buttonProgressPool:ReleaseAll()
		GwQuestInfoProgress.MoneyFrame:Hide()

		local numRequiredMoney = GetQuestMoneyToGet()
		local numRequiredItems = GetNumQuestItems()
		local numRequiredCurrencies = GetNumQuestCurrencies()

		if numRequiredMoney == 0 and numRequiredItems == 0 and numRequiredCurrencies == 0 or not format then
			GwQuestInfoProgress:Hide()

			return nil
		end

		local lastElement, height, totalHeight = nil, 0, 0
		local function AddElement(name, element, num)
			lastElement, height = format(lastElement, num, name, element)
			totalHeight = totalHeight + height
		end
		
		if numRequiredMoney > 0 then
			AddElement("MoneyFrame", AcquireFontString(GwQuestInfoProgress.headerProgressPool, REQUIRED_MONEY), 1)

			GwQuestInfoProgress.MoneyFrame:SetAmount(numRequiredMoney)
			GwQuestInfoProgress.MoneyFrame:SetPoint("LEFT", lastElement, "RIGHT", 5, 0)
			GwQuestInfoProgress.MoneyFrame:Show()	
		end

		local addFontString = true
		for id = 1, numRequiredItems do
			local hidden = IsQuestItemHidden(id)
			if hidden == 0 then
				if addFontString then
					addFontString = false

					AddElement("RequiredItemText",  AcquireFontString(GwQuestInfoProgress.headerProgressPool, ITEMS), 1)
				end

				local requiredItem = AcquireButton(GwQuestInfoProgress.buttonProgressPool)
				requiredItem.type = "required"
				requiredItem.objectType = "item"
				requiredItem:SetID(id)
				local name, texture, numItems = GetQuestItemInfo(requiredItem.type, id)
				SetItemButtonCount(requiredItem, numItems)
				SetItemButtonTexture(requiredItem, texture)
				requiredItem.Name:SetText(name)
					
				AddElement("RequiredItem", requiredItem, GwQuestInfoProgress.buttonProgressPool:GetNumActive())
			end
		end

		addFontString = true
		for id = 1, numRequiredCurrencies do
			if addFontString then
				addFontString = false

				AddElement("RequiredCurrenciesText", AddElement("RequiredItemText",  AcquireFontString(GwQuestInfoProgress.headerProgressPool, CURRENCY), 1), 1)
			end

			local requiredCurrencie = AcquireButton(GwQuestInfoProgress.buttonProgressPool)
			requiredCurrencie.type = "required"
			requiredCurrencie.objectType = "currency"
			requiredCurrencie:SetID(id)
			local name, texture, numItems = GetQuestCurrencyInfo(requiredCurrencie.type, id)
			SetItemButtonCount(requiredCurrencie, numItems)
			SetItemButtonTexture(requiredCurrencie, texture)
			requiredCurrencie.Name:SetText(name)

			AddElement("RequiredCurrencies", requiredCurrencie, id)
		end

		GwQuestInfoProgress:SetHeight(totalHeight)

		return GwQuestInfoProgress
	end

	local function ShowRewards(format)
		GwQuestInfoRewardsFrame.Header:Hide()
		GwQuestInfoRewardsFrame.HonorFrame:Hide()
		GwQuestInfoRewardsFrame.WarModeBonusFrame:Hide()
		GwQuestInfoRewardsFrame.MoneyFrame:Hide()
		GwQuestInfoRewardsFrame.SkillPointFrame:Hide()
		GwQuestInfoRewardsFrame.XPFrame:Hide()
		GwQuestInfoRewardsFrame.ArtifactXPFrame:Hide()
		GwQuestInfoRewardsFrame.TitleFrame:Hide()
		GwQuestInfoRewardsFrame.headerRewardsPool:ReleaseAll()
		GwQuestInfoRewardsFrame.buttonRewardPool:ReleaseAll()
		GwQuestInfoRewardsFrame.spellButtonRewardsPool:ReleaseAll()
		GwQuestInfoRewardsFrame.followerButtonRewardsPool:ReleaseAll()
		GwQuestInfoRewardsFrame.spellHeaderRewardsPool:ReleaseAll()

		local numQuestRewards = GetNumQuestRewards()
		local numQuestChoices = GetNumQuestChoices()
		local numQuestCurrencies = GetNumRewardCurrencies()
		local money = GetRewardMoney()
		local skillName, skillIcon, skillPoints = GetRewardSkillPoints()
		local xp = GetRewardXP()
		local artifactXP, artifactCategory = GetRewardArtifactXP()
		local honor = GetRewardHonor()
		local playerTitle = GetRewardTitle()
		local numSpellRewards = GetNumRewardSpells()
		local questID = GetQuestID()
		local hasChanceForQuestSessionBonusReward = C_QuestLog.QuestHasQuestSessionBonus(questID)
		local hasWarModeBonus = C_QuestLog.QuestCanHaveWarModeBonus(questID)

		local numQuestSpellRewards = 0
		for rewardSpellIndex = 1, numSpellRewards do
			local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetRewardSpell(rewardSpellIndex)
			local knownSpell = tonumber(spellID) and IsSpellKnownOrOverridesKnown(spellID)

			if texture and not knownSpell and (not isBoostSpell or IsCharacterNewlyBoosted()) and (not garrFollowerID or not C_Garrison.IsFollowerCollected(garrFollowerID)) then
				numQuestSpellRewards = numQuestSpellRewards + 1
			end
		end

		local totalRewards = numQuestRewards + numQuestChoices + numQuestCurrencies
		if totalRewards == 0 and money == 0 and xp == 0 and not playerTitle and numQuestSpellRewards == 0 and artifactXP == 0 or not format then
			GwQuestInfoRewardsFrame:Hide()
			return nil
		end

		local lastElement, height, totalHeight = nil, 0, 0
		local function AddElement(name, element, num)
			lastElement, height = format(lastElement, num, name, element)
			totalHeight = totalHeight + height
		end

		if GwQuestInfoRewardsFrame.rewardsHeader then
			AddElement("Header", GwQuestInfoRewardsFrame.Header, 1)
		end

		if hasWarModeBonus and C_PvP.IsWarModeDesired() then
			GwQuestInfoRewardsFrame.WarModeBonusFrame.Count:SetFormattedText(PLUS_PERCENT_FORMAT, C_PvP.GetWarModeRewardBonus())
			AddElement("WarModeBonusFrame", GwQuestInfoRewardsFrame.WarModeBonusFrame, 1)
		end

		if totalRewards > 0 or money > 0 or xp > 0 or honor > 0 or artifactXP > 0 then
			AddElement("ItemReceiveText", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, REWARD_ITEMS_ONLY), 1)
		end

		if money > 0 then
			AddElement("MoneyFrame", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, MONEY..":"), 1)

			GwQuestInfoRewardsFrame.MoneyFrame:SetAmount(money)	
			GwQuestInfoRewardsFrame.MoneyFrame:SetPoint("LEFT", lastElement, "RIGHT", 5, 0)
			GwQuestInfoRewardsFrame.MoneyFrame:Show()
		end

		if xp > 0 then
			GwQuestInfoRewardsFrame.XPFrame.ValueText:SetText(BreakUpLargeNumbers(xp))
			AddElement("XPFrame", GwQuestInfoRewardsFrame.XPFrame, 1)	
		end
		
		if honor > 0 then
			local faction = UnitFactionGroup('player')
			local icon = faction and ('Interface/Icons/PVPCurrency-Honor-%s'):format(faction)

			GwQuestInfoRewardsFrame.HonorFrame.Count:SetText(BreakUpLargeNumbers(honor))
			GwQuestInfoRewardsFrame.HonorFrame.Name:SetText(HONOR)
			GwQuestInfoRewardsFrame.HonorFrame.Icon:SetTexture(icon)

			AddElement("HonorFrame", GwQuestInfoRewardsFrame.HonorFrame, 1)
		end		

		if artifactXP > 0 then
			local name, icon = C_ArtifactUI.GetArtifactXPRewardTargetInfo(artifactCategory)
			
			GwQuestInfoRewardsFrame.ArtifactXPFrame.Name:SetText(BreakUpLargeNumbers(artifactXP))
			GwQuestInfoRewardsFrame.ArtifactXPFrame.Icon:SetTexture(icon or "Interface/Icons/INV_Misc_QuestionMark")
			
			AddElement("ArtifactXPFrame", GwQuestInfoRewardsFrame.ArtifactXPFrame, 1)
		end

		if numQuestSpellRewards > 0 then
			local spellBuckets = {}

			for rewardSpellIndex = 1, numSpellRewards do
				local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetRewardSpell(rewardSpellIndex);
				local knownSpell = IsSpellKnownOrOverridesKnown(spellID);
				if texture and not knownSpell and (not isBoostSpell or IsCharacterNewlyBoosted()) and (not garrFollowerID or not C_Garrison.IsFollowerCollected(garrFollowerID)) then
					local bucketType = 	isTradeskillSpell 	and QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL or
								isBoostSpell 		and QUEST_SPELL_REWARD_TYPE_ABILITY or
								garrFollowerID 		and (C_Garrison.GetFollowerInfo(garrFollowerID).followerTypeID == Enum.GarrisonFollowerType.FollowerType_9_0 and QUEST_SPELL_REWARD_TYPE_COMPANION or  QUEST_SPELL_REWARD_TYPE_FOLLOWER) or
								isSpellLearned 		and QUEST_SPELL_REWARD_TYPE_SPELL or
								genericUnlock 		and QUEST_SPELL_REWARD_TYPE_UNLOCK or QUEST_SPELL_REWARD_TYPE_AURA;

					if not spellBuckets[bucketType] then
						spellBuckets[bucketType] = {}
					end

					spellBuckets[bucketType][#spellBuckets[bucketType] + 1] = rewardSpellIndex
				end
			end

			for orderIndex, spellBucketType in ipairs(QUEST_INFO_SPELL_REWARD_ORDERING) do
					local spellBucket = spellBuckets[spellBucketType]
					if spellBucket then
						for i, rewardSpellIndex in ipairs(spellBucket) do
							local texture, name, isTradeskillSpell, isSpellLearned, _, isBoostSpell, garrFollowerID = GetRewardSpell(rewardSpellIndex);
							if i == 1 then
								AddElement("QuestSpellHeader", AcquireFontString(GwQuestInfoRewardsFrame.spellHeaderRewardsPool, QUEST_INFO_SPELL_REWARD_TO_HEADER[spellBucketType]), 1)
							end

							if garrFollowerID then
								local followerFrame = GwQuestInfoRewardsFrame.followerButtonRewardsPool:Acquire()
								local followerInfo = C_Garrison.GetFollowerInfo(garrFollowerID)
								followerFrame.Name:SetText(followerInfo.name)

								local adventureCompanion = followerInfo.followerTypeID == Enum.GarrisonFollowerType.FollowerType_9_0
								followerFrame.AdventuresFollowerPortraitFrame:SetShown(adventureCompanion)
								followerFrame.PortraitFrame:SetShown(not adventureCompanion)

								if adventureCompanion then
									followerFrame.AdventuresFollowerPortraitFrame:SetupPortrait(followerInfo)
								else
									followerFrame.PortraitFrame:SetupPortrait(followerInfo);
									followerFrame.Class:SetAtlas(followerInfo.classAtlas);
								end
								followerFrame.ID = garrFollowerID

								AddElement("QuestFollowerRewards", followerFrame, 1)
							else
								local spellRewardFrame = GwQuestInfoRewardsFrame.spellButtonRewardsPool:Acquire()
								spellRewardFrame.Icon:SetTexture(texture)
								spellRewardFrame.Name:SetText(name)
								spellRewardFrame.rewardSpellIndex = rewardSpellIndex

								AddElement("QuestSpellRewards", spellRewardFrame, 1)
							end
						end
					end		
			end
		end

		if numQuestRewards > 0 then
			AddElement("RewardItemsHeader", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, ITEMS), 1)

			for i = 1, numQuestRewards do
				local questItem = AcquireButton(GwQuestInfoRewardsFrame.buttonRewardPool)
				questItem.type = "reward"
				UpdateItemInfo(questItem, "item", i)

				AddElement("RewardItems", questItem, i)
			end
		end

		if numQuestCurrencies > 0 then
			AddElement("RewardCurrenciesHeader", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, CURRENCY), 1)

			for i = 1, numQuestCurrencies do
				local questItem = AcquireButton(GwQuestInfoRewardsFrame.buttonRewardPool)
				questItem.type = "reward"
				UpdateItemInfo(questItem, "currency", i)

				AddElement("RewardCurrencies", questItem, i)
			end
		end

		if numQuestChoices > 0 then
			if numQuestChoices > 1 then
				AddElement("ItemChooseText", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, GwImmersiveFrame.chooseItems and REWARD_CHOOSE or REWARD_CHOICES), 1)
			else
				GwImmersiveFrame.chooseItems = nil
			end
			
			for i = 1, numQuestChoices do
				local questItem = AcquireButton(GwQuestInfoRewardsFrame.buttonRewardPool)
				questItem.questID = questID
				questItem.type = "choice"

				local lootType = GetQuestItemInfoLootType(questItem.type, i)
				UpdateItemInfo(questItem, lootType == 0 and "item" or lootType == 1 and "currency", i)

				AddElement("ItemChoose", questItem, i)
			end	
		end

		if skillPoints then
			GwQuestInfoRewardsFrame.SkillPointFrame.ValueText:SetText(skillPoints)
			GwQuestInfoRewardsFrame.SkillPointFrame.Icon:SetTexture(skillIcon)

			if skillName then
				GwQuestInfoRewardsFrame.SkillPointFrame.Name:SetFormattedText(BONUS_SKILLPOINTS, skillName)
				GwQuestInfoRewardsFrame.SkillPointFrame.tooltip = format(BONUS_SKILLPOINTS_TOOLTIP, skillPoints, skillName)
			else
				GwQuestInfoRewardsFrame.SkillPointFrame.tooltip = nil
				GwQuestInfoRewardsFrame.SkillPointFrame.Name:SetText("")
			end
			
			AddElement("SkillPointFrame", GwQuestInfoRewardsFrame.SkillPointFrame, 1)
		end

		if playerTitle then
			AddElement("PlayerTitleText", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, REWARD_TITLE), 1)

			GwQuestInfoRewardsFrame.TitleFrame.Name:SetText(playerTitle)		
			AddElement("TitleFrame", GwQuestInfoRewardsFrame.TitleFrame, 1)	
		end

		if hasChanceForQuestSessionBonusReward then
			AddElement("QuestSessionBonusRewardHeader", AcquireFontString(GwQuestInfoRewardsFrame.headerRewardsPool, QUEST_SESSION_BONUS_LOOT_REWARD_FRAME_TITLE), 1)	

			local questItem = AcquireButton(GwQuestInfoRewardsFrame.buttonRewardPool)
			questItem.type = "reward"
			UpdateItemInfo(questItem, "questSessionBonusReward", 171305)

			AddElement("QuestSessionBonusReward", questItem, 1)	
		end		

		GwImmersiveFrame.itemChoice = 0
		if GwQuestInfoRewardsFrame.ItemHighlight then
			GwQuestInfoRewardsFrame.ItemHighlight:Hide()
		end

		GwQuestInfoRewardsFrame:SetHeight(totalHeight)

		return GwQuestInfoRewardsFrame
	end

	GW2_QUEST_DETAIL_TEMPLATE = {
		questLog = nil, chooseItems = nil, canHaveSealMaterial = false, rewardsHeader = true, title = QUEST_DETAILS,
		elements = {	
			ShowObjectivesText,
			ShowSeal, 
			ShowSpecialObjectives, 
			ShowGroupSize, 
			ShowRewards
		},
	}

	GW2_QUEST_PROGRESS_TEMPLATE = {
		questLog = nil, chooseItems = nil, canHaveSealMaterial = false, title = QUEST_OBJECTIVES,
		elements = {			
			ShowProgress
		},
	}

	GW2_QUEST_COMPLETE_TEMPLATE = {
		questLog = nil, chooseItems = true, canHaveSealMaterial = false, rewardsHeader = false, title = QUEST_REWARDS,
		elements = {
			ShowRewards
		},
	}
end

do
	local SHOW_TITLE_BUTTON

	local function TitleButtonShow(gwImmersiveFrame, start, finish, current)
		local firstElement = current == start
		local lastElement = current == finish
		local totalHeight = 0
	
		gwImmersiveFrame.TitleButtonPool:ReleaseAll()
	
		for id, value in ipairs(SHOW_TITLE_BUTTON) do
			if value.show(gwImmersiveFrame.LastEvent, firstElement, lastElement) then
				for titleIndex, info in pairs(value.getInfo()) do
					local button = gwImmersiveFrame.TitleButtonPool:Acquire() 
					local numActiveButton = gwImmersiveFrame.TitleButtonPool:GetNumActive()
					button:SetParent(gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame)
					button:SetHighlightTexture(gwImmersiveFrame.ActiveFrame.titleHighlightTexture)
					button:SetPoint('TOPLEFT', gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame, 'TOPLEFT', 0, -totalHeight)
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
	
		if IsIn(gwImmersiveFrame.LastEvent, "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE") and lastElement then
			if gwImmersiveFrame.ActiveFrame.Detail:IsShown() then
				gwImmersiveFrame.ActiveFrame.Detail:Hide()
			end

			gwImmersiveFrame.ActiveFrame.Detail:Show()
		else
			gwImmersiveFrame.ActiveFrame.Detail:Hide()
		end
	
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetValue(0)
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetAlpha(0)
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame:SetHeight(totalHeight)
	end

	local function Split(gwImmersiveFrame, text, maxSizeText, mode)
		gwImmersiveFrame.Dialog = {}
		gwImmersiveFrame.DialogCurrent = 0
		gwImmersiveFrame.AutoNext = GetSetting("AUTO_NEXT")

		local unit = (mode == "FULL_SCREEN") and UnitName(UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none") or nil
		local unitName = format("|cFFFF5A00%s|r ", unit and unit..": " or "")

		for _, value in ipairs({ strsplit('\n', text)}) do
			if strtrim(value) ~= "" then
				local strLen = strlenutf8(value)

				if strLen < maxSizeText then
					table.insert(gwImmersiveFrame.Dialog, unitName..value)
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
								table.insert(gwImmersiveFrame.Dialog, unitName..new)
								forceInsert = false
								new = newValue
							end
						end
					end

					if new ~= "" then table.insert(gwImmersiveFrame.Dialog, unitName..new) end
				end
			end
		end
	end

	local function Dialog(gwImmersiveFrame, operation)
		if gwImmersiveFrame.DialogCurrent and not CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") and tonumber(operation) then
			gwImmersiveFrame.DialogCurrent = gwImmersiveFrame.DialogCurrent + operation

			if not gwImmersiveFrame.Dialog[gwImmersiveFrame.DialogCurrent] then 
				gwImmersiveFrame.DialogCurrent = gwImmersiveFrame.DialogCurrent - operation
				return 
			end

			gwImmersiveFrame.ActiveFrame.Dialog.Text:SetText(gwImmersiveFrame.Dialog[gwImmersiveFrame.DialogCurrent])

			local sColor, name, fColor = string.match(gwImmersiveFrame.Dialog[gwImmersiveFrame.DialogCurrent], "^(%p%x+)(.*)(%p%a)")
			local StartAnimation = strlenutf8(name)
			local lenghtAnimation = strlenutf8(gwImmersiveFrame.Dialog[gwImmersiveFrame.DialogCurrent]) - strlenutf8(sColor) - strlenutf8(fColor)
			AddToAnimation(
				"IMMERSIVE_DIALOG_ANIMATION",
				StartAnimation,
				lenghtAnimation,
				GetTime(),
				GetSetting("ANIMATION_TEXT_SPEED_N") * lenghtAnimation,
				function(step)
					gwImmersiveFrame.ActiveFrame.Dialog.Text:SetAlphaGradient(step, 1)
				end,
				nil,
				function()
					if gwImmersiveFrame.AutoNext and gwImmersiveFrame.DialogCurrent < #gwImmersiveFrame.Dialog then
						C_Timer.After(GetSetting("AUTO_NEXT_TIME"), 
							function() 
								if gwImmersiveFrame.AutoNext and gwImmersiveFrame.ActiveFrame:IsVisible() then Dialog(gwImmersiveFrame, 1) end	
							end
						)
					else
						gwImmersiveFrame.AutoNext = false

						gwImmersiveFrame.ActiveFrame.Dialog.Text:SetAlphaGradient(gwImmersiveFrame.ActiveFrame.maxSizeText, 1)
						gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame:Show()
						gwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetAlpha(1)
					end
				end
			)

			TitleButtonShow(gwImmersiveFrame, 1, #gwImmersiveFrame.Dialog, gwImmersiveFrame.DialogCurrent);
		end
	end
	GW.Dialog = Dialog

	local function ImmersiveFrameHandleShow(gwImmersiveFrame, title, dialog)	
		if not gwImmersiveFrame.LoadFrame then
			gwImmersiveFrame.LoadFrame = true

			if gwImmersiveFrame.ForceFrame and (InCombatLockdown() or true) then
				gwImmersiveFrame.ActiveFrame, gwImmersiveFrame.ForceFrameTemp = gwImmersiveFrame.ForceFrame, gwImmersiveFrame.ActiveFrame
				gwImmersiveFrame.ActiveFrame.FontColor()
			end
		end

		gwImmersiveFrame.ActiveFrame:Show()
		AddToAnimation(
			"IMMERSIVE_ALPHA",
			gwImmersiveFrame.ActiveFrame:GetAlpha(),
			1,
			GetTime(),
			0.2,
			function(step)
				gwImmersiveFrame.ActiveFrame:SetAlpha(step)	
			end,
			nil,
			nil,
			true
		)
			
		gwImmersiveFrame.ActiveFrame.ReputationBar:Show()
		Model:SetModels(gwImmersiveFrame.ActiveFrame.Models.Player, gwImmersiveFrame.ActiveFrame.Models.Giver)
		Model:SetModelName(gwImmersiveFrame.ActiveFrame.Models.Player)
		Model:SetModelName(gwImmersiveFrame.ActiveFrame.Models.Giver)
		Model:SetAnimation(gwImmersiveFrame.ActiveFrame.Models.Giver, 60)

		if title then
			gwImmersiveFrame.ActiveFrame.Title.Text:SetText(title)
			AddToAnimation(
				"IMMERSIVE_TITLE_ANIMATION",
				gwImmersiveFrame.ActiveFrame.Title:GetAlpha(),
				1,
				GetTime(),
				0.3,
				function(step)
					gwImmersiveFrame.ActiveFrame.Title:SetAlpha(step)	
				end
			)
		else
			if CheckStateAnimation("IMMERSIVE_TITLE_ANIMATION") then StopAnimation("IMMERSIVE_TITLE_ANIMATION") end
			gwImmersiveFrame.ActiveFrame.Title:SetAlpha(0)
		end

		Split(gwImmersiveFrame, dialog, gwImmersiveFrame.ActiveFrame.maxSizeText, gwImmersiveFrame.ActiveFrame.mode);
		Dialog(gwImmersiveFrame, 1)
	end
	GW.ImmersiveFrameHandleShow = ImmersiveFrameHandleShow

	local function ImmersiveFrameHandleHide(gwImmersiveFrame, reframe)
		if (gwImmersiveFrame.customFrame) then
			gwImmersiveFrame.customFrame:Hide()
			gwImmersiveFrame.customFrame = nil	
		elseif gwImmersiveFrame.ActiveFrame:IsShown() then
			gwImmersiveFrame.LoadDetail = true
			if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") then StopAnimation("IMMERSIVE_DIALOG_ANIMATION") end
			if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") then StopAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") end
			if CheckStateAnimation("IMMERSIVE_TITLE_ANIMATION") then StopAnimation("IMMERSIVE_TITLE_ANIMATION") end
			

			AddToAnimation(
				"IMMERSIVE_ALPHA",
				gwImmersiveFrame.ActiveFrame:GetAlpha(),
				0,
				GetTime(),
				0.5,
				function(step)
					gwImmersiveFrame.ActiveFrame:SetAlpha(step)	
				end,
				nil,
				function()
					gwImmersiveFrame.ActiveFrame:Hide()
					gwImmersiveFrame.ActiveFrame.Scroll.Icon:Hide()
					gwImmersiveFrame.ActiveFrame.Scroll.Text:Hide()
					gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame:Hide()
					gwImmersiveFrame.ActiveFrame.Detail:Hide()

					if gwImmersiveFrame.LoadFrame then
						gwImmersiveFrame.LoadFrame = false

						if gwImmersiveFrame.ForceFrameTemp then
							gwImmersiveFrame.ActiveFrame, gwImmersiveFrame.ForceFrameTemp = gwImmersiveFrame.ForceFrameTemp, nil
							gwImmersiveFrame.ActiveFrame.FontColor()							
						end
					end

					if reframe then
						gwImmersiveFrame.ActiveFrame, gwImmersiveFrame.UnActiveFrame = gwImmersiveFrame.UnActiveFrame, gwImmersiveFrame.ActiveFrame
						gwImmersiveFrame.ActiveFrame.FontColor()
						
						pcall(gwImmersiveFrame:GetScript("OnEvent"), gwImmersiveFrame, gwImmersiveFrame.LastEvent)
					end
				end,
				true
			)
		end
	end
	GW.ImmersiveFrameHandleHide = ImmersiveFrameHandleHide

	do
		local function GetAvailableQuests() return C_GossipInfo.GetAvailableQuests() end
		local function GetOptions() return C_GossipInfo.GetOptions() end		
	
		local function GetActiveQuests()
			local GossipQuests = C_GossipInfo.GetActiveQuests()  
			GwImmersiveFrame.hasActiveQuest = #GossipQuests > 0
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
				if numQuestChoices == 1 then GwImmersiveFrame.itemChoice = 1 end
	
				GetQuestReward(GwImmersiveFrame.itemChoice)
			end
		end
	
		local function Next() Dialog(GwImmersiveFrame, 1) end
		local function Back() Dialog(GwImmersiveFrame, -1) end
		local function Repeat() 
			GwImmersiveFrame.DialogCurrent = 0
			GwImmersiveFrame.AutoNext = GetSetting("AUTO_NEXT")
			Dialog(GwImmersiveFrame, 1) 
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
end