local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local AddToAnimation = GW.AddToAnimation
local StopAnimation = GW.StopAnimation
local CheckStateAnimation =  GW.CheckStateAnimation
local IsIn = GW.IsIn
local ModelScaling = GW.Libs.Model

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
				pool:OnLoad("BUTTON", parent, frameTemplate)
			elseif typePool == "FontString" then
				local parent, layer, subLayer, fontStringTemplate = ...
	
				pool = CreateFromMixins(FontStringPoolMixin, CollectionMixin)
				pool:OnLoad(parent, layer, subLayer, fontStringTemplate)
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
	GW.LoadDetalies = LoadDetalies
end

do
	local ACTIVE_TEMPLATE
	local SHOW_TITLE_BUTTON

	local function ShownDetail(parentFrame, formatShow)
		for _, frame in ipairs({QuestInfoObjectivesText, QuestInfoSpecialObjectivesFrame, QuestInfoGroupSize, QuestInfoSpecialObjectivesFrame, QuestInfoRewardsFrame, GwQuestInfoProgress}) do
			frame:ClearAllPoints()
			frame:Hide()
		end
	
		ACTIVE_TEMPLATE.contentWidth = parentFrame:GetWidth()
		QuestInfo_Display(ACTIVE_TEMPLATE, parentFrame)
	
		return formatShow(ACTIVE_TEMPLATE)
	end

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
			if not gwImmersiveFrame.ActiveFrame.Detail:IsVisible() then
				ACTIVE_TEMPLATE = _G["GW2_"..gwImmersiveFrame.LastEvent.."_TEMPLATE"]
				gwImmersiveFrame.ActiveFrame.Detail.Scroll.ScrollBar:SetValue(0)
				gwImmersiveFrame.ActiveFrame.Detail.Title:SetText(ACTIVE_TEMPLATE.title)
				local height = ShownDetail(gwImmersiveFrame.ActiveFrame.Detail.Scroll.ScrollChildFrame, gwImmersiveFrame.ActiveFrame.StyleReward)
				gwImmersiveFrame.ActiveFrame.Detail.Scroll.ScrollChildFrame:SetHeight(height)
				gwImmersiveFrame.ActiveFrame.Detail:SetShown(height > 0)
			end
		else
			if gwImmersiveFrame.ActiveFrame.Detail:IsVisible() then
				gwImmersiveFrame.ActiveFrame.Detail:Hide()
			end
		end
	
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetValue(0)
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollBar:SetAlpha(0)
		gwImmersiveFrame.ActiveFrame.Scroll.ScrollChildFrame:SetHeight(totalHeight)
	end

	local function Split(gwImmersiveFrame, text, maxSizeText, mode)
		gwImmersiveFrame.Dialog = {}
		gwImmersiveFrame.DialogCurrent = 0
		gwImmersiveFrame.AutoNext = GetSetting("AUTO_NEXT")

		local unitName = format("|cFFFF5A00%s|r ", (mode == "FULL_SCREEN") and UnitName("npc")..": " or "")

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
		gwImmersiveFrame.ActiveFrame:Show()
		AddToAnimation(
			gwImmersiveFrame.ActiveFrame:GetName(),
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
		ModelScaling:SetModels(gwImmersiveFrame.ActiveFrame.Models.Player, gwImmersiveFrame.ActiveFrame.Models.Giver)
		ModelScaling:SetModelName(gwImmersiveFrame.ActiveFrame.Models.Player)
		ModelScaling:SetModelName(gwImmersiveFrame.ActiveFrame.Models.Giver)

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
			if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION") then StopAnimation("IMMERSIVE_DIALOG_ANIMATION") end
			if CheckStateAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") then StopAnimation("IMMERSIVE_DIALOG_ANIMATION_TITLE_BUTTON") end
			if CheckStateAnimation("IMMERSIVE_TITLE_ANIMATION") then StopAnimation("IMMERSIVE_TITLE_ANIMATION") end

			AddToAnimation(
				gwImmersiveFrame.ActiveFrame:GetName(),
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

					if reframe then
						gwImmersiveFrame.ActiveFrame = gwImmersiveFrame.ActiveFrame.mode == "NORMAL" and GwFullScreenGossipViewFrame or GwNormalScreenGossipViewFrame
						gwImmersiveFrame.ActiveFrame.FontColor()
						
						pcall(gwImmersiveFrame:GetScript("OnEvent"), gwImmersiveFrame, gwImmersiveFrame.LastEvent)
					end
				end,
				true
			)
		end
	end
	GW.ImmersiveFrameHandleHide = ImmersiveFrameHandleHide

	local function LoadTitleButtons()
		GwImmersiveFrame.TitleButtonPool = CreateFramePool("BUTTON", nil, "GwTitleButtonTemplate")
		
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
				if numQuestChoices == 1 then QuestInfoFrame.itemChoice = 1 end
	
				GetQuestReward(QuestInfoFrame.itemChoice)
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
	GW.LoadTitleButtons = LoadTitleButtons
end