local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local EnableTooltip = GW.EnableTooltip

-------------------------------------------------- Option ----------------------------------------------------------
local FULL_SCREEN = true;
local STYLE_GW2 = true; 
local BORDER_CHAT = true; 
local DINAMIC_BACKGROUND = true; 
local MOUSE_DIALOG = true;
local FORCE_GOSSIP = true;
local AUTO_NEXT = true;
local AUTO_NEXT_TIME = 0.5;
local ANIMATION_TEXT_SPEED = 0.05;
local MOVE_AND_SCALE = true;

local ITEM_BUTTOM_TITLE = {
	buttonPool,
	buttons = {}
}

local ITEM_BUTTOM_REWARD = {
	buttonPool,
	buttons = {}
}

------------------------------------------------ Last Event --------------------------------------------------------

local LAST_ACTIVE_EVENT = "NONE";
local PREV_ACTIVE_EVENT = "NONE";

-------------------------------------------------- Dialog ----------------------------------------------------------

local ANIMATION_TEXT_STOP = false;
local AUTO_NEXT_BLOCK = false;

local GW_INTERACTIVE_TEXT = {
	ACCEPT = {"Принять"},
	DECLINE = {"Отказаться"},
	NEXT = {"Далее", "Продолжить"},
	BACK = {"Назад"},
	RESET = {"Повторить"},
	CANCEL = {"Выход", "Отмена"},
	EXIT = {"Выход"},
	COMPLETE = {"Завершить"},
}

local SEAL_QUESTS = { -- Seal quests
	[40519] = {text = '|cff04aaff'..QUEST_KING_VARIAN_WRYNN..'|r', sealAtlas = 'Quest-Alliance-WaxSeal'},
	[43926] = {text = '|cff480404'..QUEST_WARCHIEF_VOLJIN..'|r', sealAtlas = 'Quest-Horde-WaxSeal'},
	[46730] = {text = '|cff2f0a48'..QUEST_KHADGAR..'|r', sealAtlas = 'Quest-Legionfall-WaxSeal'},
}

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------- OTHER FUNCTION ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GwHideFrame(self)
	self:UnregisterAllEvents()
	self:SetSize(1, 1)
	self:EnableMouse(false)
	self:EnableKeyboard(false)
	self:SetAlpha(0)
	self:ClearAllPoints()
end

local function GwGossipEvent(self)
	self:RegisterEvent("GOSSIP_SHOW");
	self:RegisterEvent("GOSSIP_CLOSED");
	self:RegisterEvent("QUEST_LOG_UPDATE");

	self:RegisterEvent("QUEST_GREETING");
	self:RegisterEvent("QUEST_DETAIL");
	self:RegisterEvent("QUEST_PROGRESS");
	self:RegisterEvent("QUEST_COMPLETE");
	self:RegisterEvent("QUEST_FINISHED");
	self:RegisterEvent("QUEST_ITEM_UPDATE");
	--self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	--self:RegisterEvent("PORTRAITS_UPDATED");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");
end

local function GetItemButton(parent, parentButton)
	local button = parent.buttonPool:Acquire();
	button:SetParent(parentButton);
	table.insert(parent.buttons, button);

	return button;
end

local function Release(parent)
	parent.buttons = {};
	parent.buttonPool:ReleaseAll();
end

local function SetActiveEvent(event)
	PREV_ACTIVE_EVENT = LAST_ACTIVE_EVENT;
	LAST_ACTIVE_EVENT = event;
end

local function GwButtonUpdate(self, start, finish, currete)
	local Scroll = self.Scroll;
	local lastElement = start == finish or currete == finish;
	local firstElement = start == finish or currete == start;
	local moveElement = start ~= finish and currete > start and currete < finish;

	local move = {
		["GOSSIP"] = lastElement,
		["GREETING"] = lastElement,
		["NEXT"] = firstElement or moveElement,
		["ACCEPT"] = lastElement,
		["DECLINE"] = lastElement,
		["COMPLETE"] = lastElement,
		["BACK"] = lastElement or moveElement,
		["CANCEL"] = true,
		["EXIT"] = true
	}

	Release(ITEM_BUTTOM_TITLE);
	local totalHeight = 0;

	for _, item in ipairs(Scroll.scrollButtonTitleInfo) do
		if (item.action) then
			item.show = move[item.action];
		end

		if (item.show) then
			local button = GetItemButton(ITEM_BUTTOM_TITLE, Scroll.ScrollChildFrame);
			local key = #ITEM_BUTTOM_TITLE.buttons;

			titleText = item.titleText or GW_INTERACTIVE_TEXT[item.action][math.random(1, #GW_INTERACTIVE_TEXT[item.action])];
			button:SetInfo(item.buttonID, item.type, (key < 11 and key..". "..titleText) or titleText, item.isIgnored, item.isTrivial, item.icon, item.action, item.specID);

			if (key > 1) then
				button:SetPoint('TOPLEFT', ITEM_BUTTOM_TITLE.buttons[key - 1], 'BOTTOMLEFT', 0, -5);
			else
				
				button:SetPoint('TOPLEFT', Scroll.ScrollChildFrame, 'TOPLEFT', 5, -5);
			end
			
			button:Resize(Scroll.ScrollChildFrame:GetWidth());
			button:Show();

			totalHeight = totalHeight + button:GetHeight() + 5;
		end
	end

	if (LAST_ACTIVE_EVENT == "QUEST_PROGRESS" and lastElement) then
		if (self.Detail.numRequiredMoney > 0 or self.Detail.numRequiredItems > 0 or self.Detail.numRequiredCurrencies > 0) then
			self.DetailButton:Show();
		end
	end

	Scroll.ScrollChildFrame:SetHeight(totalHeight);
	Scroll.ScrollChildFrame:Show();
	Scroll.ScrollBar:SetAlpha(0);
end

local function GwForceClose()
	C_GossipInfo.CloseGossip();
	CloseQuest();
	CloseItemText();
end

local function GwAcceptQuest()
	if (QuestFlagsPVP()) then
		StaticPopup_Show('CONFIRM_ACCEPT_PVP_QUEST');
	else
		if (QuestGetAutoAccept()) then
			AcknowledgeAutoAcceptQuest();
		else
			AcceptQuest();
		end
	end
	PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN);
end

local function GwAutoQuest(questStartItemID)
	if (QuestIsFromAdventureMap()) then
		PlayAutoAcceptQuestSound();

		return true;
	end

	if((questStartItemID ~= nil and questStartItemID ~= 0) or (QuestGetAutoAccept() and QuestIsFromAreaTrigger())) then
		if (AutoQuestPopupTracker_AddPopUp(GetQuestID(), 'OFFER', questStartItemID)) then
			PlayAutoAcceptQuestSound();
		end

		return true;
	end

	return false;
end

local function GwCompleteQuest(self)
	local numQuestChoices = GetNumQuestChoices();
	self.itemChoice = (numQuestChoices == 1 and 1) or self.itemChoice;

	if ( self.itemChoice == 0 and numQuestChoices > 0 ) then
		QuestChooseRewardError();
	else
		GetQuestReward(self.itemChoice);
	end
end

---------------------------------------------------------------------------------------------------------------------
------------------------------------------- ANIMATION ELEMENT -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function AnimationTextDialog(self, elapsed)
	if (self.timeElapsed and self.char) then
		self.timeElapsed  = self.timeElapsed  + elapsed;

		if (self.timeElapsed  >= ANIMATION_TEXT_SPEED) then
			self.timeElapsed  = 0;

			self.char = self.char + 1;
			if (self.char >= strlenutf8(self.Text:GetText()) or ANIMATION_TEXT_STOP) then
				self.char = nil;
				self.timeElapsed = nil;
				self.Text:SetAlphaGradient(strlenutf8(self.Text:GetText()), 1);
				ANIMATION_TEXT_STOP = false;

				if (AUTO_NEXT and not AUTO_NEXT_BLOCK) then
					self.dialogActive = true;
					C_Timer.After(AUTO_NEXT_TIME, function() 
						self:NextDialog();
						if (AUTO_NEXT_BLOCK) then
							self:GetParent().Scroll.ScrollChildFrame:Show();	
							self:GetParent().Scroll.ScrollBar:SetAlpha(1);	
						end
						self.dialogActive = false;
					end);
				else
					self:GetParent().Scroll.ScrollChildFrame:Show();	
					self:GetParent().Scroll.ScrollBar:SetAlpha(1);	
				end	

				self:SetScript("OnUpdate", nil);
			else
				self.Text:SetAlphaGradient(self.char, 1);
			end
		end
	end
end

local function AnimationPlayerText(self, elapsed)
	if (self.timeElapsed and self.char) then
		self.timeElapsed  = self.timeElapsed  + elapsed;

		if (self.timeElapsed  >= ANIMATION_TEXT_SPEED) then
			self.timeElapsed  = 0;

			self.char = self.char + 1;
			if (self.char >= strlenutf8(self.Text:GetText()) or ANIMATION_TEXT_STOP) then
				self.char = nil;
				self.timeElapsed = nil;
				self.Text:SetAlphaGradient(strlenutf8(self.Text:GetText()), 1);
				ANIMATION_TEXT_STOP = false;

				self:SetScript("OnUpdate", nil);

				return true;
			else
				self.Text:SetAlphaGradient(self.char, 1);

				return false;
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- MODEL ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

GwGossipModelMixin = {}


---------------------------------------------------------------------------------------------------------------------
----------------------------------------- FULL SCREEN STYLE MIXIN ---------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

GwGossipFullScreenStyle = {}

local DYNAMIC_BACKGROUNDS = {

	--region Battle for Azeroth

	["1161"] = "TiragardeSound", -- Boralus
	["895"] = "TiragardeSound",
	["1196"] = "TiragardeSound",
	["876"] = "TiragardeSound", -- Kul Tiras, fallback for all Alliance zones
	["942"] = "Stormsong",
	["1198"] = "Stormsong",
	["896"] = "Drustvar",
	["1197"] = "Drustvar",
	["862"] = "Zuldazar",
	["1181"] = "Zuldazar",
	["1193"] = "Zuldazar",
	["1163"] = "Zuldazar", -- Dazar'alor
	["1164"] = "Zuldazar", -- Dazar'alor
	["1165"] = "Zuldazar", -- Dazar'alor
	["1352"] = "Zuldazar", -- Battle for Dazar'alor
	["1353"] = "Zuldazar", -- Battle for Dazar'alor
	["1354"] = "Zuldazar", -- Battle for Dazar'alor
	["1356"] = "Zuldazar", -- Battle for Dazar'alor
	["1357"] = "Zuldazar", -- Battle for Dazar'alor
	["1358"] = "Zuldazar", -- Battle for Dazar'alor
	["1364"] = "Zuldazar", -- Battle for Dazar'alor
	["1367"] = "Zuldazar", -- Battle for Dazar'alor
	["875"] = "Zuldazar", -- Zandalar, fallback for all Horde zones
	["864"] = "Voldun",
	["1195"] = "Voldun",
	["863"] = "Nazmir",
	["1194"] = "Nazmir",
	["1355"] = "Nazjatar",
	["1504"] = "Nazjatar",
	["1528"] = "Nazjatar",
	["1462"] = "Mechagon",
	["1490"] = "Mechagon",
	["1491"] = "Mechagon",
	["1493"] = "Mechagon",
	["1494"] = "Mechagon",
	["1497"] = "Mechagon",

	--endregion

	--region Legion

	["630"] = "Azsuna",
	["867"] = "Azsuna",
	["1187"] = "Azsuna",
	["41"] = "Dalaran",
	["125"] = "Dalaran",
	["126"] = "Dalaran",
	["501"] = "Dalaran",
	["502"] = "Dalaran",
	["625"] = "Dalaran",
	["626"] = "Dalaran",
	["627"] = "Dalaran",
	["628"] = "Dalaran",
	["629"] = "Dalaran",
	["650"] = "Highmountain",
	["869"] = "Highmountain",
	["870"] = "Highmountain",
	["1189"] = "Highmountain",
	["634"] = "Stormheim",
	["696"] = "Stormheim",
	["865"] = "Stormheim",
	["866"] = "Stormheim",
	["1190"] = "Stormheim",
	["680"] = "Suramar",
	["1191"] = "Suramar",
	["641"] = "Valsharah",
	["868"] = "Valsharah",
	["1188"] = "Valsharah",
	["905"] = "Argus",
	["994"] = "Argus",
	["885"] = "Argus", -- Antoran Wastes
	["882"] = "Argus", -- Mac'Aree
	["830"] = "Argus", -- Krokuun
	["831"] = "Argus", -- Vindicaar
	["887"] = "Argus", -- Vindicaar
	["883"] = "Argus", -- Vindicaar
	["619"] = "Legion", -- Fallback for all legion zones

	--endregion

	--region Old world

	["14"] = "ArathiHighlands", -- Arathi Highlands
	["93"] = "ArathiHighlands", -- Arathi Basin
	["837"] = "ArathiHighlands", -- Arathi Basin
	["844"] = "ArathiHighlands", -- Arathi Basin
	["906"] = "ArathiHighlands", -- Arathi Highlands
	["943"] = "ArathiHighlands", -- Arathi Highlands
	["1044"] = "ArathiHighlands", -- Arathi Highlands
	["1158"] = "ArathiHighlands", -- Arathi Highlands
	["1244"] = "ArathiHighlands", -- Arathi Highlands
	["1366"] = "ArathiHighlands", -- Arathi Basin
	["1383"] = "ArathiHighlands", -- Arathi Basin
	["63"] = "Ashenvale",
	["1310"] = "Ashenvale",
	["76"] = "Azshara",
	["697"] = "Azshara",
	["1209"] = "Azshara",
	["62"] = "Darkshore",
	["1203"] = "Darkshore",
	["1309"] = "Darkshore",
	["1332"] = "Darkshore",
	["1333"] = "Darkshore",
	["1338"] = "Darkshore",
	["1343"] = "Darkshore",
	["1"] = "Durotar",
	["1305"] = "Durotar",
	["25"] = "HillsbradFoothills", -- Hillsbrad Foothills
	["274"] = "HillsbradFoothills", -- Old Hillsbrad Foothills
	["623"] = "HillsbradFoothills", -- Hillsbrad Foothills (Southshore vs. Tarren Mill)
	["10"] = "NorthernBarrens", -- Northern Barrens
	["1307"] = "NorthernBarrens", -- Northern Barrens
	["21"] = "SilverpineForest",
	["1248"] = "SilverpineForest",
	["199"] = "SouthernBarrens",
	["1329"] = "SouthernBarrens",

	--endregion

	--region Warlords of Draenor

	["525"] = "FrostfireRidge",
	["543"] = "Gorgrond",
	["1170"] = "Gorgrond", -- Mag'har Scenario
	["107"] = "Nagrand",
	["550"] = "Nagrand",
	["104"] = "ShadowmoonValley",
	["539"] = "ShadowmoonValley",
	["542"] = "SpiresofArak",
	["535"] = "Talador",
	["534"] = "TannanJungle",
	["577"] = "TannanJungle",
	["572"] = "Talador", -- Draenor, fallback for all Warlords of Draenor content


	--endregion
}

local STATIC_BACKGROUNDS = {
	["1409"] = "charactercreate-startingzone-exilesreach",

	--Blood Elf

	["467"] = "charactercreate-startingzone-bloodelf", -- Sunstrider Isle (Eversong)
	["94"] = "charactercreate-startingzone-bloodelf", -- Eversong
	["1267"] = "charactercreate-startingzone-bloodelf", -- Eversong 2

	--Draenei

	["1325"] = "charactercreate-startingzone-draenei", -- Azuremyst
	["97"] = "charactercreate-startingzone-draenei", -- Azuremyst 2
	["98"] = "charactercreate-startingzone-draenei", -- Tides' Hollow (Microdungeon)
	["99"] = "charactercreate-startingzone-draenei", -- Stillpine Hold (Microdungeon)
	["468"] = "charactercreate-startingzone-draenei", -- Ammen Vale (Azuremyst)
	["776"] = "charactercreate-startingzone-draenei", -- Azuremyst (Orphan)
	["891"] = "charactercreate-startingzone-draenei", -- Azuremyst (Legion Scenario)
	["892"] = "charactercreate-startingzone-draenei", -- Azuremyst (Legion Scenario 2)
	["893"] = "charactercreate-startingzone-draenei", -- Azuremyst (Legion Scenario 3)
	["894"] = "charactercreate-startingzone-draenei", -- Azuremyst (Legion Scenario 4)

	--Worgen

	["179"] = "charactercreate-startingzone-worgen", -- Gilneas (Orphan)
	["180"] = "charactercreate-startingzone-worgen", -- Emberstone Mine (Microdungeon)
	["181"] = "charactercreate-startingzone-worgen", -- Greymane Manor (Microdungeon)
	["182"] = "charactercreate-startingzone-worgen", -- Greymane Manor 2 (Microdungeon)
	["202"] = "charactercreate-startingzone-worgen", -- Gilneas City (Gilneas)
	["217"] = "charactercreate-startingzone-worgen", -- Ruins of Gilneas
	["218"] = "charactercreate-startingzone-worgen", -- Ruins of Gilneas City (Orphan)
	["1030"] = "charactercreate-startingzone-worgen", -- Greymane Manor 3 (Microdungeon)
	["1031"] = "charactercreate-startingzone-worgen", -- Greymane Manor 4 (Microdungeon)
	["1271"] = "charactercreate-startingzone-worgen", -- Gilneas
	["1273"] = "charactercreate-startingzone-worgen", -- Ruins of Gilneas 2
	["1577"] = "charactercreate-startingzone-worgen", -- Gilneas City 2 (Gilneas)

	--Goblin

	["194"] = "charactercreate-startingzone-goblin", -- Kezan
	["195"] = "charactercreate-startingzone-goblin", -- Kaja'mine (Microdungeon)
	["196"] = "charactercreate-startingzone-goblin", -- Kaja'mine 2 (Microdungeon)
	["197"] = "charactercreate-startingzone-goblin", -- Kaja'mine 3 (Microdungeon)

	--Human

	["37"] = "charactercreate-startingzone-human", -- Elwynn Forest
	["38"] = "charactercreate-startingzone-human", -- Fargodeep Mine (Microdungeon)
	["39"] = "charactercreate-startingzone-human", -- Fargodeep Mine (Microdungeon)
	["40"] = "charactercreate-startingzone-human", -- Jasperlode Mine (Microdungeon)
	["425"] = "charactercreate-startingzone-human", -- Northshire (Elwynn Forest)
	["426"] = "charactercreate-startingzone-human", -- Echo Ridge Mine (Microdungeon)
	["1256"] = "charactercreate-startingzone-human", -- Elwynn Forest 2

	--Dwarf

	["27"] = "charactercreate-startingzone-dwarf", -- Dun Morogh
	["28"] = "charactercreate-startingzone-dwarf", -- Colridge Pass (Microdungeon)
	["29"] = "charactercreate-startingzone-dwarf", -- The Grizzled Den (Microdungeon)
	["31"] = "charactercreate-startingzone-dwarf", -- Gol'Bolar Quarry (Microdungeon)
	["427"] = "charactercreate-startingzone-dwarf", -- Coldridge Valley (Orphan)
	["428"] = "charactercreate-startingzone-dwarf", -- Frostmane Hovel (Microdungeon)
	["470"] = "charactercreate-startingzone-dwarf", -- Frostmane Hold (Microdungeon)
	["523"] = "charactercreate-startingzone-dwarf", -- Dun Morogh (Orphan)
	["843"] = "charactercreate-startingzone-dwarf", -- Coldridge Valley (Orphan)
	["1253"] = "charactercreate-startingzone-dwarf", -- Dun Morogh 2

	--Gnome

	["30"] = "charactercreate-startingzone-gnome", -- New Tinkertown (The Gnomeregan Starting Zone)
	["469"] = "charactercreate-startingzone-gnome", -- New Tinkertown 2 (The Outdoor Gnome Zone)

	--Night Elf

	["57"] = "charactercreate-startingzone-nightelf", -- Teldrassil
	["58"] = "charactercreate-startingzone-nightelf", -- Shadowthread Cave (Microdungeon)
	["59"] = "charactercreate-startingzone-nightelf", -- Fel Rock (Microdungeon)
	["60"] = "charactercreate-startingzone-nightelf", -- Ban'ethil Barrow Den (Microdungeon)
	["61"] = "charactercreate-startingzone-nightelf", -- Ban'ethil Barrow Den 2 (Microdungeon)
	["460"] = "charactercreate-startingzone-nightelf", -- Shadowglen (Teldrassil)
	["1308"] = "charactercreate-startingzone-nightelf", -- Teldrassil 2

	--Orc

	["1"] = "charactercreate-startingzone-orc", -- Durotar
	["2"] = "charactercreate-startingzone-orc", -- Burning Blade Coven (Microdungeon)
	["3"] = "charactercreate-startingzone-orc", -- Tiragarde Keep (Microdungeon)
	["4"] = "charactercreate-startingzone-orc", -- Tiragarde Keep 2 (Microdungeon)
	["5"] = "charactercreate-startingzone-orc", -- Skull Rock (Microdungeon)
	["6"] = "charactercreate-startingzone-orc", -- Dustwind Cave (Microdungeon)
	["461"] = "charactercreate-startingzone-orc", -- Valley of Trials (Durotar)
	["1305"] = "charactercreate-startingzone-orc", -- Durotar 2

	--Troll

	["463"] = "charactercreate-startingzone-troll", -- Echo Isles (Durotar)
	["464"] = "charactercreate-startingzone-troll", -- Spitescale Cavern (Microdungeon)

	--Tauren

	["7"] = "charactercreate-startingzone-tauren", -- Mulgore
	["8"] = "charactercreate-startingzone-tauren", -- Palemane Rock (Microdungeon)
	["9"] = "charactercreate-startingzone-tauren", -- The Venture Co. Mine (Microdungeon)
	["462"] = "charactercreate-startingzone-tauren", -- Camp Narache (Mulgore)
	["1306"] = "charactercreate-startingzone-tauren", -- Mulgore 2

	--Undead (or Forsaken if you're feeling politically correct)

	["18"] = "charactercreate-startingzone-undead", -- Tirisfal Glades
	["19"] = "charactercreate-startingzone-undead", -- Scarlet Monastery Entrance (Microdungeon)
	["20"] = "charactercreate-startingzone-undead", -- Keeper's Rest (Microdungeon)
	["465"] = "charactercreate-startingzone-undead", -- Deathknell (Tirisfal Glades)
	["466"] = "charactercreate-startingzone-undead", -- Night's Web Hollow (Microdungeon)
	["997"] = "charactercreate-startingzone-undead", -- Tirisfal Glades 2
	["1247"] = "charactercreate-startingzone-undead", -- Tirisfal Glades 3

	--Pandaren
	["378"] = "charactercreate-startingzone-pandaren", -- The Wandering Isle
	["709"] = "charactercreate-startingzone-pandaren", -- The Wandering Isle (Legion)
}

function GwGossipFullScreenStyle:getCustomZoneBackground(zone)
	local mapID = C_Map.GetBestMapForUnit("player");
		if mapID then
			repeat
				if zone[tostring(mapID)] then
					return zone[tostring(mapID)];
				end
				local mapInfo = C_Map.GetMapInfo(mapID);
				mapID = mapInfo and mapInfo.parentMapID or 0;
			until mapID == 0
		end			

	return false;
end

function GwGossipFullScreenStyle:OnShow()	
	if (STYLE_GW2) then
		local num = math.random(1, 1);

		self.Border:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_border_"..num);
		self.Bottom:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_gw2_bottom_"..num);
		self.Top:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_gw2_top_"..num);

		self:GetParent().Detail.background:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_gw2_reward");
	else
		self.Border:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_border_1");
		self.Bottom:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_classic_bottom");
		self.Top:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_classic_top");

		self:GetParent().Detail.background:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_classic_reward");
	end

	if (DINAMIC_BACKGROUND) then
		if (C_CampaignInfo.IsCampaignQuest(GetQuestID())) then
			self.backgroundLayer:SetAtlas( "QuestBG-"..UnitFactionGroup("player"));
			self.backgroundLayer:SetTexCoord(0.2, 0.99, 0.5, 0.95);
			self.backgroundLayer:Show();
			self.middlegroundLayer:Hide();
			self.foregroundLayer:Hide();
		elseif (self:getCustomZoneBackground(STATIC_BACKGROUNDS)) then
			local zoneBackground = self:getCustomZoneBackground(STATIC_BACKGROUNDS);
			self.backgroundLayer:SetAtlas(zoneBackground);
			self.backgroundLayer:Show();
			self.middlegroundLayer:Hide();
			self.foregroundLayer:Hide();
		elseif (self:getCustomZoneBackground(DYNAMIC_BACKGROUNDS)) then
			local dynamicBackground = self:getCustomZoneBackground(DYNAMIC_BACKGROUNDS);
			self.backgroundLayer:SetAtlas("_GarrMissionLocation-"..dynamicBackground.."-Back");
			self.backgroundLayer:SetTexCoord(0.25, 0.75, 0, 1);
			self.backgroundLayer:Show();
			self.middlegroundLayer:SetAtlas("_GarrMissionLocation-"..dynamicBackground.."-Mid");
			self.middlegroundLayer:SetTexCoord(0.25, 0.75, 0, 1);
			self.middlegroundLayer:Show();
			self.foregroundLayer:SetAtlas("_GarrMissionLocation-"..dynamicBackground.."-Fore");
			self.foregroundLayer:SetTexCoord(0.25, 0.75, 0, 1);
			self.foregroundLayer:Show();
		else
			local classFilename = select(2, UnitClass("player"));
			if (classFilename) then
				self.backgroundLayer:SetAtlas("dressingroom-background-"..classFilename);
				self.backgroundLayer:SetTexCoord(0, 1, 0.25, 0.75)
			else
				self.backgroundLayer:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\questview\\fsgvf_bg_default");
			end
			self.backgroundLayer:Show();
			self.middlegroundLayer:Hide();
			self.foregroundLayer:Hide();
		end
	else
		self.backgroundLayer:Hide();
		self.middlegroundLayer:Hide();
		self.foregroundLayer:Hide();
	end
end

---------------------------------------------------------------------------------------------------------------------
------------------------------------------- GOSSIP BUTTON MIXIN -----------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

GwGossipTitleButtonMixin = {}

function GwGossipTitleButtonMixin:SetInfo(buttonID, type, titleText, isIgnored, isTrivial, icon, actionType, specID)
	self:SetID(buttonID);
	self.type = type;
	self.actionType = actionType;
	self.specID = specID;

	if (icon.atlas) then
		self.Icon:SetAtlas(icon.texture, true);
	else
		self.Icon:SetTexture(icon.texture);
	end

	self:UpdateTitle(titleText, isIgnored, isTrivial);
end

function GwGossipTitleButtonMixin:UpdateTitle(titleText, isIgnored, isTrivial)
	if (isIgnored) then
		self.Label:SetFormattedText("|cFF8C8C8C%s|r", titleText);
		self.Icon:SetVertexColor(0.5,0.5,0.5);
	elseif (isTrivial) then
		self.Label:SetFormattedText("|cffffffff%s|r", titleText);
		self.Icon:SetVertexColor(0.5,0.5,0.5);
	elseif (self.type == "Gossip") then
		self.Label:SetFormattedText("|cffffffff%s|r", titleText);
		self.Icon:SetVertexColor(1,1,1);
	elseif  (self.type == "Action") then
		self.Label:SetFormattedText("|cFF8C00FF%s|r", titleText);
		self.Icon:SetVertexColor(1,1,1);
	else
		self.Label:SetFormattedText("|cFFFF5A00%s|r", titleText);
		self.Icon:SetVertexColor(1,1,1);
	end
end

function GwGossipTitleButtonMixin:OnClick()
	local parent = self:GetParent():GetParent():GetParent();

	if (not AUTO_NEXT_BLOCK) then
		parent.Scroll.ScrollChildFrame:Hide();
	end

	local unitName = "";
	if (FULL_SCREEN) then
		unitName = "|cFFFF5A00"..UnitName("player")..":|r";
	else
		parent.Scroll.Icon:Show();
	end

	parent.Scroll.Text:SetText(unitName..self.Label:GetText():gsub("^.+%d.", ""));

	if (self.type == "Action") then
		if (self.actionType == "ACCEPT") then
			GwAcceptQuest();
		elseif (self.actionType == "DECLINE") then
			DeclineQuest();
		elseif (self.actionType == "NEXT") then 
			parent.Dialog:NextDialog();
		elseif (self.actionType == "BACK") then
			parent.Dialog:BackDialog();
		elseif (self.actionType == "CANCEL") then 
			CloseQuest();
		elseif (self.actionType == "EXIT") then 
			C_GossipInfo.CloseGossip();
		elseif (self.actionType == "COMPLETE") then 
			CompleteQuest();
		end
	elseif (LAST_ACTIVE_EVENT == "GOSSIP_SHOW") then
		if (self.type == "Available") then
			C_GossipInfo.SelectAvailableQuest(self:GetID());
		elseif (self.type == "Active") then
			C_GossipInfo.SelectActiveQuest(self:GetID());
		elseif (self.type == "Gossip") then 
			C_GossipInfo.SelectOption(self:GetID());
		end
	elseif (LAST_ACTIVE_EVENT == "QUEST_GREETING") then
		if (self.type == "Available" ) then
			C_GossipInfo.SelectAvailableQuest(self:GetID());
		elseif (self.type == "Active") then
			C_GossipInfo.SelectActiveQuest(self:GetID());
		end
	end
end 

function GwGossipTitleButtonMixin:OnEnter()
	if (self.specID) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
		if (self.type == "Gossip") then 
			GameTooltip:SetSpellByID(self.specID);
		elseif (self.type == "Active") then
			local level = C_QuestLog.GetQuestDifficultyLevel(self.specID) ;
			GameTooltip:SetText(string.format("Рекомендуемый уровень: %d", level));
		elseif (self.type == "Available") then
			local level =  C_QuestLog.GetQuestDifficultyLevel(self.specID) ;
			local num = C_QuestLog.GetSuggestedGroupSize(self.specID);
			num = num == 0 and 1;
			GameTooltip:SetText(string.format("Рекомендуемый уровень: %d", level));
			GameTooltip:AddLine(QUEST_SUGGESTED_GROUP_NUM:format(num));
		end
		GameTooltip:Show(); 
		GameTooltip:SetIgnoreParentAlpha(true);
	end
end 

function GwGossipTitleButtonMixin:OnLeave()
	GameTooltip:SetIgnoreParentAlpha(false);
	GameTooltip:Hide(); 
end 

function GwGossipTitleButtonMixin:Resize(width)
	self:SetWidth(width);
	self:SetHeight(math.max(self:GetTextHeight() + 2, self.Icon:GetHeight()));
	
	if (FULL_SCREEN) then
		self:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	else
		self:SetHighlightTexture("Interface/AddOns/GW2_UI/textures/questview/gvf_scroll_buttom")
	end 
end

function GwGossipTitleButtonMixin:Release()
	self:SetID(-1);
	self.type = nil;
	self.func = nil;
	self.specID = nil;
	self.Label:SetText("");
	self.Icon:SetTexture("");
end

---------------------------------------------------------------------------------------------------------------------
------------------------------------------------ DIALOG MIXIN -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

GwGossipDialogMixin = {}

function GwGossipDialogMixin:Split(text)
	self.numPartDialog = 0;
	self.splitDialog = {}
	
	local unitName ="";
	if (FULL_SCREEN) then
		unitName = UnitName("npc");
		if (unitName) then
			self.startAnimation = strlenutf8(unitName);
			unitName = "|cFFFF5A00"..unitName..":|r ";
		end 
	else
		self.startAnimation = 0;
	end

	for _, value in ipairs({ strsplit('\n', text)}) do
		if (strtrim(value) ~= "") then
			local strLen = strlenutf8(value);

			if (strLen < self.maxSizeText) then
				table.insert(self.splitDialog, unitName..value);
			else
				local SizePart = math.ceil(strLen/math.ceil(strLen/self.maxSizeText));
				local forceInsert = false;
				local new = "";

				for key, newValue in ipairs({ strsplit('\n', value:gsub('%.%s%.%s%.', '...'):gsub('%.%s+', '.\n'):gsub('%.%.%.\n', '...\n...'):gsub('%!%s+', '!\n'):gsub('%?%s+', '?\n')) }) do
					if (strtrim(newValue) ~= "") then
						local size = strlenutf8(new) + strlenutf8(newValue) + 1;

						if (size < self.maxSizeText and not forceInsert) then
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

function GwGossipDialogMixin:OnLoad()
	self.dialogActive = false;
end

function GwGossipDialogMixin:OnHide()
	self.splitDialog = nil;
	self.numPartDialog = nil;
	self.startAnimation = nil;
	self.Text:SetText("");
	self.dialogActive = false;
	self.char = nil;
	self.timeElapsed = nil;
end

function GwGossipDialogMixin:OnClick()
	if (ANIMATION_TEXT_STOP) then
		if (not self.dialogActive) then
			ANIMATION_TEXT_STOP = false;
			if(button == "LeftButton") then
				self:NextDialog();
			elseif (button == "RightButton") then
				self:BackDialog();
			end
		end
	else
		ANIMATION_TEXT_STOP = true;
	end
end

function GwGossipDialogMixin:NextDialog()
	local num = self.numPartDialog + 1;

	if (self.splitDialog[num]) then
		self.timeElapsed = 0;
		self.char = self.startAnimation;
		self.Text:SetText(self.splitDialog[num]);
		self.Text:SetAlphaGradient(self.char, 1);
		self.numPartDialog = num;
		self:SetScript("OnUpdate", AnimationTextDialog);
		
		GwButtonUpdate(self:GetParent(), 1, #self.splitDialog, self.numPartDialog);
		return;
	end

	AUTO_NEXT_BLOCK = true;
end

function GwGossipDialogMixin:BackDialog()
	local num = self.numPartDialog - 1;
	AUTO_NEXT_BLOCK = true;

	if (self.splitDialog[num]) then
		self.timeElapsed = 0;
		self.char = self.startAnimation;
		self.Text:SetText(self.splitDialog[num]);
		self.Text:SetAlphaGradient(self.char, 1);
		self.numPartDialog = num;
		self:SetScript("OnUpdate", AnimationTextDialog);
		
		GwButtonUpdate(self:GetParent(), 1, #self.splitDialog, self.numPartDialog);
		return;
	end
end

function GwGossipDialogMixin:GwControlDialogWithMouse()
	if (MOUSE_DIALOG) then
		GwFullScreenGossipViewFrame.Dialog:SetScript("OnClick", GwGossipViewFrameDialog_OnClick);
	else
		GwFullScreenGossipViewFrame.Dialog:SetScript("OnClick", nil);
	end
end

function GwGossipDialogMixin:GwBorderDialogFullScreen()
	if (BORDER_CHAT) then

	else

	end
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------- REWARD/DETALIE -------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GwHiddenButton(parent, index)
	for i=index, #parent do
		parent[i]:Hide()
	end
end

local function GwQuestDetaliesSpecialObjectives()
	-- Show objective spell
	local spellID, spellName, spellTexture = GetCriteriaSpell()
	local specialFrame = self.Content.SpecialObjectivesFrame
	local spellObjectiveLabel = specialFrame.SpellObjectiveLearnLabel
	local spellObjective = specialFrame.SpellObjectiveFrame


	local lastFrame = nil
	local totalHeight = 0

	if (spellID) then
		spellObjective.Icon:SetTexture(spellTexture)
		spellObjective.Name:SetText(spellName)
		spellObjective.spellID = spellID

		spellObjective:ClearAllPoints()
		if (lastFrame) then
			spellObjectiveLabel:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -4)
			totalHeight = totalHeight + 4
		else
			spellObjectiveLabel:SetPoint('TOPLEFT', 0, 0)
		end

		spellObjective:SetPoint('TOPLEFT', spellObjectiveLabel, 'BOTTOMLEFT', 0, -4)

		spellObjectiveLabel:SetText(LEARN_SPELL_OBJECTIVE)
		spellObjectiveLabel:SetTextColor(0, 0, 0)

		spellObjectiveLabel:Show()
		spellObjective:Show()
		totalHeight = totalHeight + spellObjective:GetHeight() + spellObjectiveLabel:GetHeight()
		lastFrame = spellObjective
	else
		spellObjective:Hide()
		spellObjectiveLabel:Hide()
	end

	if (lastFrame) then
		specialFrame:SetHeight(totalHeight)
		specialFrame:Show()
		return specialFrame
	else
		return specialFrame:Hide()
	end
end

local function IsValidSpellReward(texture, knownSpell, isBoostSpell, garrFollowerID)
	-- check if already known, check if is boost spell, check if follower is collected
	return  texture and not knownSpell and
			(not isBoostSpell or API:IsCharacterNewlyBoosted()) and
			(not garrFollowerID or not API:IsFollowerCollected(garrFollowerID))
end

local function AddSpellToBucket(spellBuckets, type, rewardSpellIndex)
	if not spellBuckets[type] then
		spellBuckets[type] = {}
	end
	local spellBucket = spellBuckets[type]
	spellBucket[#spellBucket + 1] = rewardSpellIndex
end

local function ToggleRewardElement(frame, value, anchor)
	if ( value and tonumber(value) ~= 0 ) then
		frame:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
		frame.ValueText:SetText(value)
		frame:Show()
		return true
	else
		frame:Hide()
	end
end

local function UpdateItemInfo(self)
	if self.objectType == 'item' then
		local name, texture, numItems, quality, isUsable = GetQuestItemInfo(self.type, self:GetID());
		-- For the tooltip
		self.Name:SetText(name);
		self.itemTexture = texture;
		SetItemButtonCount(self, numItems);
		SetItemButtonTexture(self, texture);
		if ( isUsable ) then
			SetItemButtonTextureVertexColor(self, 1.0, 1.0, 1.0);
			SetItemButtonNameFrameVertexColor(self, 1.0, 1.0, 1.0);
		else
			SetItemButtonTextureVertexColor(self, 0.9, 0, 0);
			SetItemButtonNameFrameVertexColor(self, 0.9, 0, 0);
		end

		return self:Show();
	elseif self.objectType == 'currency' then
		local name, texture, numItems = GetQuestCurrencyInfo(self.type, self:GetID());
		if (name and texture and numItems) then
			-- For the tooltip
			self.Name:SetText(name);
			self.itemTexture = texture;
			SetItemButtonCount(self, numItems, true);
			SetItemButtonTexture(self, texture);
			SetItemButtonTextureVertexColor(self, 1.0, 1.0, 1.0);
			SetItemButtonNameFrameVertexColor(self, 1.0, 1.0, 1.0);

			return self:Show();
		else
			return self:Hide();
		end
	end
end

local function GwQuestRewards_Update()
	local elements = self
	local self = self.Content.RewardsFrame -- more convenient this way
	local rewardButtons = self.Buttons
	local 	numQuestRewards, numQuestChoices, numQuestCurrencies,
			money,
			skillName, skillPoints, skillIcon,
			xp, artifactXP, artifactCategory, honor,
			playerTitle,
			numSpellRewards
			
	local numQuestSpellRewards = 0
	local totalHeight = 0
	local GetSpell = GetRewardSpell

	do  -- Get data
		numQuestRewards = API:GetNumQuestRewards()
		numQuestChoices = API:GetNumQuestChoices()
		numQuestCurrencies = API:GetNumRewardCurrencies()
		money = API:GetRewardMoney()
		skillName, skillIcon, skillPoints = API:GetRewardSkillPoints()
		xp = API:GetRewardXP()
		artifactXP, artifactCategory = API:GetRewardArtifactXP()
		honor = API:GetRewardHonor()
		playerTitle = API:GetRewardTitle()
		numSpellRewards = API:GetNumRewardSpells()
	end

	do -- Spell rewards
		for rewardSpellIndex = 1, numSpellRewards do
			local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetSpell(rewardSpellIndex)
			local knownSpell = tonumber(spellID) and IsSpellKnownOrOverridesKnown(spellID)

			-- only allow the spell reward if user can learn it
			if IsValidSpellReward(texture, knownSpell, isBoostSpell, garrFollowerID) then
				numQuestSpellRewards = numQuestSpellRewards + 1
			end
		end
	end

	local totalRewards = numQuestRewards + numQuestChoices + numQuestCurrencies

	do -- Check if any rewards are present, break out if none
		if ( totalRewards == 0 and 
			money == 0 and 
			xp == 0 and 
			not playerTitle and 
			numQuestSpellRewards == 0 and 
			artifactXP == 0 ) then

			return self:Hide()
		end
	end

	do -- Hide unused rewards
		for i = totalRewards + 1, #rewardButtons do
			local rewardButton = rewardButtons[i]
			rewardButton:ClearAllPoints()
			rewardButton:Hide()
		end
	end

	-- Setup locals 
	local questItem, name, texture, quality, isUsable, numItems
	local rewardsCount = 0
	local lastFrame = self.Header

	local totalHeight = self.Header:GetHeight()
	local buttonHeight = self.Buttons[1]:GetHeight()

	do -- Artifact experience
		self.ArtifactXPFrame:ClearAllPoints()
		if ( artifactXP > 0 ) then
			local name, icon = C_ArtifactUI.GetArtifactXPRewardTargetInfo(artifactCategory)
			self.ArtifactXPFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			self.ArtifactXPFrame.Name:SetText(BreakUpLargeNumbers(artifactXP))
			self.ArtifactXPFrame.Icon:SetTexture(icon or 'Interface\\Icons\\INV_Misc_QuestionMark')
			self.ArtifactXPFrame:Show()

			lastFrame = self.ArtifactXPFrame
			totalHeight = totalHeight + self.ArtifactXPFrame:GetHeight() + REWARDS_OFFSET
		else
			self.ArtifactXPFrame:Hide()
		end
	end

	do -- Setup choosable rewards
		self.ItemChooseText:ClearAllPoints()
		self.MoneyIcon:Hide()
		if ( numQuestChoices > 0 ) then
			self.ItemChooseText:Show()
			self.ItemChooseText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -5)

			local highestValue, moneyItem
			local index
			local baseIndex = rewardsCount
			for i = 1, numQuestChoices do
				index = i + baseIndex
				questItem = GetItemButton(self, index)
				questItem.type = 'choice'
				questItem.objectType = 'item'
				numItems = 1
				questItem:SetID(i)
				questItem:Show()

				UpdateItemInfo(questItem)

				local link = GetQuestItemLink(questItem.type, i)
				local vendorValue = link and select(11, GetItemInfo(link))
				
				if vendorValue and ( not highestValue or vendorValue > highestValue ) then
					highestValue = vendorValue
					if vendorValue > 0 and numQuestChoices > 1 then
						moneyItem = questItem
					end
				end

				if ( i > 1 ) then
					if ( mod(i, ITEMS_PER_ROW) == 1 ) then
						questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
						lastFrame = questItem
						totalHeight = totalHeight + buttonHeight + 2
					else
						questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
					end
				else
					questItem:SetPoint('TOPLEFT', self.ItemChooseText, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
					lastFrame = questItem
					totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
				end
				rewardsCount = rewardsCount + 1
			end

			if moneyItem then
				self.MoneyIcon:SetPoint('BOTTOMRIGHT', moneyItem, -13, 6)
				self.MoneyIcon:Show()
			end

			if ( numQuestChoices == 1 ) then
				elements.chooseItems = nil
				self.ItemChooseText:SetText(REWARD_ITEMS_ONLY)
			elseif ( elements.chooseItems ) then
				self.ItemChooseText:SetText(REWARD_CHOOSE)
			else
				self.ItemChooseText:SetText(REWARD_CHOICES)
			end
			totalHeight = totalHeight + self.ItemChooseText:GetHeight() + REWARDS_OFFSET
		else
			elements.chooseItems = nil
			self.ItemChooseText:Hide()
		end
	end

	do -- Wipe reward pools
		self.spellRewardPool:ReleaseAll()
		self.followerRewardPool:ReleaseAll()
		self.spellHeaderPool:ReleaseAll()
	end

	do -- Setup spell rewards
		if ( numQuestSpellRewards > 0 ) then
			local spellBuckets = {}

			-- Generate spell buckets
			for rewardSpellIndex = 1, numSpellRewards do
				local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetSpell(rewardSpellIndex)
				local knownSpell = IsSpellKnownOrOverridesKnown(spellID)
				if IsValidSpellReward(texture, knownSpell, isBoostSpell, garrFollowerID) then
					local bucket = 	isTradeskillSpell 	and QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL or
									isBoostSpell 		and QUEST_SPELL_REWARD_TYPE_ABILITY or
									garrFollowerID 		and QUEST_SPELL_REWARD_TYPE_FOLLOWER or
									isSpellLearned 		and QUEST_SPELL_REWARD_TYPE_SPELL or
									genericUnlock 		and QUEST_SPELL_REWARD_TYPE_UNLOCK or QUEST_SPELL_REWARD_TYPE_AURA
					
					AddSpellToBucket(spellBuckets, bucket, rewardSpellIndex)
				end
			end

			-- Sort buckets in the correct order
			for orderIndex, spellBucketType in ipairs(QUEST_INFO_SPELL_REWARD_ORDERING) do
				local spellBucket = spellBuckets[spellBucketType]
				if spellBucket then
					for i, rewardSpellIndex in ipairs(spellBucket) do
						local texture, name, isTradeskillSpell, isSpellLearned, _, isBoostSpell, garrFollowerID = GetSpell(rewardSpellIndex)
						if i == 1 then
							local header = self.spellHeaderPool:Acquire()
							header:SetText(QUEST_INFO_SPELL_REWARD_TO_HEADER[spellBucketType])
							header:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
							if self.spellHeaderPool.textR and self.spellHeaderPool.textG and self.spellHeaderPool.textB then
								header:SetVertexColor(self.spellHeaderPool.textR, self.spellHeaderPool.textG, self.spellHeaderPool.textB)
							end
							header:Show()

							totalHeight = totalHeight + header:GetHeight() + REWARDS_OFFSET
							lastFrame = header
						end

						local anchorFrame
						if garrFollowerID then
							local followerFrame = self.followerRewardPool:Acquire()
							local followerInfo = C_Garrison.GetFollowerInfo(garrFollowerID)
							followerFrame.Name:SetText(followerInfo.name)
							followerFrame.Class:SetAtlas(followerInfo.classAtlas)
							followerFrame.PortraitFrame:SetupPortrait(followerInfo)
							followerFrame.ID = garrFollowerID
							followerFrame:Show()

							anchorFrame = followerFrame
						else
							local spellRewardFrame = self.spellRewardPool:Acquire()
							spellRewardFrame.Icon:SetTexture(texture)
							spellRewardFrame.Name:SetText(name)
							spellRewardFrame.rewardSpellIndex = rewardSpellIndex
							spellRewardFrame:Show()

							anchorFrame = spellRewardFrame
						end
						if i % 2 ==  1 then
							anchorFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
							totalHeight = totalHeight + anchorFrame:GetHeight() + REWARDS_OFFSET

							lastFrame = anchorFrame
						else
							anchorFrame:SetPoint('LEFT', lastFrame, 'RIGHT', 1, 0)
						end
					end
				end
			end
		end
	end

	do -- Title reward
		if ( playerTitle ) then
			self.PlayerTitleText:Show()
			self.PlayerTitleText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			totalHeight = totalHeight +  self.PlayerTitleText:GetHeight() + REWARDS_OFFSET
			self.TitleFrame:SetPoint('TOPLEFT', self.PlayerTitleText, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			self.TitleFrame.Name:SetText(playerTitle)
			self.TitleFrame:Show()
			lastFrame = self.TitleFrame
			totalHeight = totalHeight +  self.TitleFrame:GetHeight() + REWARDS_OFFSET
		else
			self.PlayerTitleText:Hide()
			self.TitleFrame:Hide()
		end
	end

	do -- Setup mandatory rewards
		if ( numQuestRewards > 0 or numQuestCurrencies > 0 or money > 0 or xp > 0 ) then
			-- receive text, will either say 'You will receive' or 'You will also receive'
			local questItemReceiveText = self.ItemReceiveText
			if ( numQuestChoices > 0 or numQuestSpellRewards > 0 or playerTitle ) then
				questItemReceiveText:SetText(REWARD_ITEMS)
			else
				questItemReceiveText:SetText(REWARD_ITEMS_ONLY)
			end
			questItemReceiveText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			questItemReceiveText:Show()
			totalHeight = totalHeight + questItemReceiveText:GetHeight() + REWARDS_OFFSET
			lastFrame = questItemReceiveText

			do -- Money rewards
				if ( money > 0 ) then
					MoneyFrame_Update(self.MoneyFrame, money)
					self.MoneyFrame:Show()
				else
					self.MoneyFrame:Hide()
				end
			end

			do -- XP rewards
				if ( ToggleRewardElement(self.XPFrame, BreakUpLargeNumbers(xp), lastFrame) ) then
					lastFrame = self.XPFrame
					totalHeight = totalHeight + self.XPFrame:GetHeight() + REWARDS_OFFSET
				end
			end

			do -- Skill Point rewards
				if ( ToggleRewardElement(self.SkillPointFrame, skillPoints, lastFrame) ) then
					lastFrame = self.SkillPointFrame
					self.SkillPointFrame.Icon:SetTexture(skillIcon)
					if (skillName) then
						self.SkillPointFrame.Name:SetFormattedText(BONUS_SKILLPOINTS, skillName)
						self.SkillPointFrame.tooltip = format(BONUS_SKILLPOINTS_TOOLTIP, skillPoints, skillName)
					else
						self.SkillPointFrame.tooltip = nil
						self.SkillPointFrame.Name:SetText('')
					end
					totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
				end
			end

			local index
			local baseIndex = rewardsCount
			local buttonIndex = 0

			do -- Item rewards
				for i = 1, numQuestRewards, 1 do
					buttonIndex = buttonIndex + 1
					index = i + baseIndex
					questItem = GetItemButton(self, index)
					questItem.type = 'reward'
					questItem.objectType = 'item'
					questItem:SetID(i)
					questItem:Show()

					UpdateItemInfo(questItem)

					if ( buttonIndex > 1 ) then
						if ( mod(buttonIndex, ITEMS_PER_ROW) == 1 ) then
							questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
							lastFrame = questItem
							totalHeight = totalHeight + buttonHeight + 2
						else
							questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
						end
					else
						questItem:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
						lastFrame = questItem
						totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
					end
					rewardsCount = rewardsCount + 1
				end
			end
			
			do -- Currency
				baseIndex = rewardsCount
				local foundCurrencies = 0
				buttonIndex = buttonIndex + 1
				for i = 1, API:GetMaxRewardCurrencies(), 1 do
					index = i + baseIndex
					questItem = GetItemButton(self, index)
					questItem.type = 'reward'
					questItem.objectType = 'currency'
					questItem:SetID(i)
					questItem:Show()

					if (UpdateItemInfo(questItem)) then

						if ( buttonIndex > 1 ) then
							if ( mod(buttonIndex, ITEMS_PER_ROW) == 1 ) then
								questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
								lastFrame = questItem
								totalHeight = totalHeight + buttonHeight + 2
							else
								questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
							end
						else
							questItem:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
							lastFrame = questItem
							totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
						end
						rewardsCount = rewardsCount + 1
						foundCurrencies = foundCurrencies + 1
						buttonIndex = buttonIndex + 1
						if (foundCurrencies == numQuestCurrencies) then
							break
						end
					end
				end
			end

			do -- Honor reward 
				self.HonorFrame:ClearAllPoints()
				if ( honor > 0 ) then
					local faction = UnitFactionGroup('player')
					local icon = faction and ('Interface\\Icons\\PVPCurrency-Honor-%s'):format(faction)

					self.HonorFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
					self.HonorFrame.Count:SetText(BreakUpLargeNumbers(honor))
					self.HonorFrame.Name:SetText(HONOR)
					self.HonorFrame.Icon:SetTexture(icon)
					self.HonorFrame:Show()

					lastFrame = self.HonorFrame
					totalHeight = totalHeight + self.HonorFrame:GetHeight() + REWARDS_OFFSET
				else
					self.HonorFrame:Hide()
				end
			end

		else -- Hide all sub-frames
			self.ItemReceiveText:Hide()
			self.MoneyFrame:Hide()
			self.XPFrame:Hide()
			self.SkillPointFrame:Hide()
			self.HonorFrame:Hide()
		end
	end

	-- deselect item
	elements.itemChoice = 0
	if ( self.ItemHighlight ) then
		self.ItemHighlight:Hide()
	end

	self:Show()
	self:SetHeight(totalHeight)
	return self, lastFrame
end

local function GwQuestDetail_Update(self)
	local progress = self.Scroll.ScrollChildFrame.Progress;
	local Offset = 5;
	Release(ITEM_BUTTOM_REWARD);

	local buttonIndex = 1;
	local totalHeight = 0;
	local lastElement;

	--self.numRequiredMoney = math.random(0, 1000);
	--self.numRequiredItems = math.random(10, 20);
	--self.numRequiredCurrencies = math.random(5, 10);

	if (self.numRequiredMoney > 0) then
		MoneyFrame_Update(progress.MoneyFrame, self.numRequiredMoney);
		
		local moneyColor, moneyVertex;
		
		if (self.numRequiredMoney < GetMoney()) then
			moneyColor, moneyVertex = 'red', 0.2;
		end

		progress.MoneyText:SetTextColor(moneyVertex, moneyVertex, moneyVertex);
		SetMoneyFrameColor(progress.MoneyFrame, moneyColor);
		progress.MoneyText:SetPoint('TOPLEFT', progress, 'TOPLEFT', Offset, -Offset);
		progress.MoneyText:Show();
		progress.MoneyFrame:Show();

		totalHeight = totalHeight + progress.MoneyFrame:GetHeight() + Offset;
		lastElement = progress.MoneyText;
	else
		progress.MoneyText:Hide();
		progress.MoneyFrame:Hide();
	end

	if (self.numRequiredItems > 0) then
		if (lastElement) then
			progress.ReqItemText:SetPoint('TOPLEFT', lastElement, 'BOTTOMLEFT', 0, -Offset);
		else
			progress.ReqItemText:SetPoint('TOPLEFT', progress, 'TOPLEFT', Offset, -Offset);
		end
		totalHeight = totalHeight + progress.ReqItemText:GetHeight() + Offset;

		for RequiredItems = 1, self.numRequiredItems do	
			local hidden = IsQuestItemHidden(RequiredItems);
			if (hidden == 0) then
				local requiredItem = GetItemButton(ITEM_BUTTOM_REWARD, progress);
				requiredItem.type = 'required';
				requiredItem.objectType = 'item';
				requiredItem:SetID(1);
				
				UpdateItemInfo(requiredItem);

				if (FULL_SCREEN) then
					if (RequiredItems > 1) then
						requiredItem:SetPoint('TOPLEFT', ITEM_BUTTOM_REWARD.buttons[buttonIndex - 1], 'BOTTOMLEFT', 0, -Offset);
					else
						requiredItem:SetPoint('TOPLEFT', progress.ReqItemText, 'BOTTOMLEFT', Offset, -Offset);
					end
					
					totalHeight = totalHeight + requiredItem:GetHeight() + Offset;
				else

				end

				buttonIndex = buttonIndex + 1;
			end
		end

		if (buttonIndex ~= 1) then
			progress.ReqItemText:Show();
			lastElement = ITEM_BUTTOM_REWARD.buttons[buttonIndex - 1];
		else
			totalHeight = totalHeight - progress.ReqItemText:GetHeight() - Offset;
			progress.ReqItemText:Hide();
		end
	else
		progress.ReqItemText:Hide();
	end

	if (self.numRequiredCurrencies > 0) then
		if (lastElement) then
			progress.ReqCurrencyText:SetPoint('TOPLEFT', lastElement, 'BOTTOMLEFT', 0, -Offset);
		else
			progress.ReqCurrencyText:SetPoint('TOPLEFT', progress, 'TOPLEFT', Offset, -Offset);
		end

		totalHeight = totalHeight + progress.ReqCurrencyText:GetHeight() + Offset;
		progress.ReqCurrencyText:Show();

		for RequiredCurrencies = 1, self.numRequiredCurrencies do	
			local requiredItem = GetItemButton(ITEM_BUTTOM_REWARD, progress);
			requiredItem.type = 'required'
			requiredItem.objectType = 'currency'
			requiredItem:SetID(RequiredCurrencies);

			UpdateItemInfo(requiredItem)

			if (FULL_SCREEN) then
				if (RequiredCurrencies > 1) then
					requiredItem:SetPoint('TOPLEFT', ITEM_BUTTOM_REWARD.buttons[buttonIndex - 1], 'BOTTOMLEFT', 0, -Offset);
				else
					requiredItem:SetPoint('TOPLEFT', progress.ReqCurrencyText, 'BOTTOMLEFT', Offset, -Offset);
				end
				
				totalHeight = totalHeight + requiredItem:GetHeight() + Offset;
			else

			end
	
			buttonIndex = buttonIndex + 1;
		end

	else
		progress.ReqCurrencyText:Hide();
	end
	
	progress:SetHeight(totalHeight);
	self.Scroll.ScrollChildFrame:SetHeight(totalHeight);
	self.Scroll.ScrollBar:SetValue(0);

	self:Show();
	progress:Show();

	GwHiddenButton(ITEM_BUTTOM_REWARD.buttons, buttonIndex);
end

local function GwGossipViewFrameDetailButton_OnClick(self, button, down)
	local Parent = self:GetParent();
	self:ClearAllPoints();

	if (Parent.Detail:IsShown()) then
		if (FULL_SCREEN) then
			self:SetPoint("TOPLEFT", Parent, "CENTER", -50, 50);		
			self:SetPoint("BOTTOMRIGHT", Parent, "CENTER", 50, -50);	
		end

		Parent.Detail:Hide();
	else	
		if (FULL_SCREEN) then
			self:SetPoint("TOPLEFT", Parent.Dialog, "BOTTOM", -50, 0);		
			self:SetPoint("TOPRIGHT", Parent.Dialog, "BOTTOM", 50, 0);
			self:SetPoint("BOTTOM", Parent.Dialog, "BOTTOM", 0, -100);
		end

		self.func(Parent.Detail);
	end
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------- Set Gossip/Greeting/ Quest Info ----------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GwGetGossipIcon(type, isComplete, isLegendary, frequency, isRepeatable, isCampaign, isCovenantCalling)
	local icon = {}

	if (type == "Active") then
		icon.texture , icon.atlas = QuestUtil.GetQuestIconActive(isComplete, isLegendary, frequency, isRepeatable, isCampaign, isCovenantCalling)
	elseif (type == "Available") then
		icon.texture , icon.atlas = QuestUtil.GetQuestIconOffer(isLegendary, frequency, isRepeatable, isCampaign, isCovenantCalling)
	else
		icon.texture , icon.atlas = "Interface/GossipFrame/" .. type .. "GossipIcon", false
	end

	return icon
end

local function GwAddTitleButtonInfo(self, Info, actionType, buttonType, titleIndex, show)
	local item = {}

	item.type = buttonType;
	item.show = show;
	item.action = actionType;
	item.buttonID = titleIndex or -1;

	if (buttonType == "Gossip") then
		item.titleText = Info.name;
		item.icon = GwGetGossipIcon(Info.type);
		item.specID = Info.spellID;
	elseif (buttonType == "Action") then
		item.icon = {texture = "Interface/AddOns/GW2_UI/textures/questview/icon_"..actionType, atlas = false};
	else
		item.titleText = Info.title;
		item.isTrivial = Info.isTrivial;
		item.isIgnored = Info.isIgnored;
		item.specID = Info.questID;
		item.icon = GwGetGossipIcon(buttonType, Info.isComplete, Info.isLegendary, Info.frequency, Info.isRepeatable, QuestUtil.ShouldQuestIconsUseCampaignAppearance(Info.questID), C_QuestLog.IsQuestCalling(Info.questID));
	end

	table.insert(self.scrollButtonTitleInfo, item);
end

local UPDATE = {
	GOSSIP_SHOW = function(self)
		self.Dialog:Split(C_GossipInfo.GetText());
	
		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "NEXT", "Action", nil, true);
		end
	
		local GossipQuests = C_GossipInfo.GetAvailableQuests();
		for titleIndex, questInfo in ipairs(GossipQuests) do
			GwAddTitleButtonInfo(self.Scroll, questInfo, "GOSSIP", "Available", titleIndex, true);
		end
	
		local GossipQuests = C_GossipInfo.GetActiveQuests();
		self.hasActiveQuest = (#GossipQuests > 0);
		for titleIndex, questInfo in ipairs(GossipQuests) do
			GwAddTitleButtonInfo(self.Scroll, questInfo, "GOSSIP", "Active", titleIndex, true);
		end
	
		local gossipOptions = C_GossipInfo.GetOptions();
		for titleIndex, optionInfo in ipairs(gossipOptions) do
			GwAddTitleButtonInfo(self.Scroll, optionInfo, "GOSSIP", "Gossip", titleIndex, true);
		end
	
		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "BACK", "Action", nil, true);
		end
	
		GwAddTitleButtonInfo(self.Scroll, nil, "EXIT", "Action", nil, true);
	end,
	QUEST_GREETING = function (self)
		self.Dialog:Split(GetGreetingText());

		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "NEXT", "Action", nil, true);
		end

		local GreetingAvailableQuests = GetNumAvailableQuests();
		for ID = 1, GreetingAvailableQuests do
			local Info = {}

			Info.isTrivial, Info.frequency, Info.isRepeatable, Info.isLegendary, Info.questID = GetAvailableQuestInfo(ID);
			item.titleText = GetAvailableTitle(ID);

			GwAddTitleButtonInfo(self.Scroll, Info, "GREETING", "Available", ID, true);
		end

		local GreetingActiveQuests = GetNumActiveQuests();
		for ID = 1, GreetingActiveQuests do
			local Info = {}

			Info.title, Info.isComplete = GetActiveTitle(ID);
			Info.isTrivial = IsActiveQuestTrivial(ID);
			Info.isLegendary = IsActiveQuestLegendary(ID);
			Info.questID = GetActiveQuestID(ID);

			GwAddTitleButtonInfo(self.Scroll, Info, "GREETING", "Active", ID, true);
		end

		if (#self.Dialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "BACK", "Action", nil, true);
		end

		GwAddTitleButtonInfo(self.Scroll, nil, "EXIT", "Action", nil, true);
	end,
	QUEST_DETAIL = function (self)
		self.Title.Text:SetText(GetTitleText());

		self.Dialog:Split(GetQuestText());

		self.Dialog.splitDialog[#self.Dialog.splitDialog + 1] = QUEST_OBJECTIVES..": "..GetObjectiveText();
		--QuestInfo_Display(QUEST_TEMPLATE_DETAIL, QuestDetailScrollChildFrame, QuestFrameAcceptButton, material);

		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "NEXT", "Action", nil, true);
		end

		GwAddTitleButtonInfo(self.Scroll, nil, "ACCEPT", "Action", nil, true);

		if (not QuestGetAutoAccept()) then 
			GwAddTitleButtonInfo(self.Scroll, nil, "DECLINE", "Action", nil, true);
		end

		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "BACK", "Action", nil, true);
		end
	end,
	QUEST_PROGRESS = function(self)
		self.Title.Text:SetText(GetTitleText());
		self.Dialog:Split(GetProgressText());

		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "NEXT", "Action", nil, true);
		end

		if IsQuestCompletable() then 
			GwAddTitleButtonInfo(self.Scroll, nil, "COMPLETE", "Action", nil, true);
		end

		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "BACK", "Action", nil, true);
		end

		GwAddTitleButtonInfo(self.Scroll, nil, "CANCEL", "Action", nil, true);

		self.Detail.numRequiredMoney = GetQuestMoneyToGet();
		self.Detail.numRequiredItems = GetNumQuestItems();
		self.Detail.numRequiredCurrencies = GetNumQuestCurrencies();

		self.DetailButton.func = GwQuestDetail_Update;
	end,
	QUEST_COMPLETE = function (self)
		self.Title.Text:SetText(GetTitleText());
		self.Dialog:Split(GetRewardText());
	
		--QuestInfo_Display(QUEST_TEMPLATE_REWARD, QuestRewardScrollChildFrame, QuestFrameCompleteQuestButton, material);
	
		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "NEXT", "Action", nil, true);
		end
	
		GwAddTitleButtonInfo(self.Scroll, nil, "CANCEL", "Action", nil, true);
	
		if (#self.Dialog.splitDialog > 1) then
			GwAddTitleButtonInfo(self.Scroll, nil, "BACK", "Action", nil, true);
		end
	end
}

---------------------------------------------------------------------------------------------------------------------
--------------------------------------------- REPUTATION BAR --------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function NPCFriendshipStatusBar_Update(frame, factionID --[[ = nil ]])
	local statusBar = frame.ReputationBar;
	local id, rep, maxRep, name, text, texture, reaction, threshold, nextThreshold = GetFriendshipReputation(factionID);
	statusBar.friendshipFactionID = id;
	if ( id and id > 0 ) then
		-- if max rank, make it look like a full bar
		if ( not nextThreshold ) then
			threshold, nextThreshold, rep = 0, 1, 1;
		end
		if ( texture ) then
			statusBar.icon:SetTexture(texture);
		else
			statusBar.icon:SetTexture("Interface\\Common\\friendship-heart");
		end
		statusBar:SetMinMaxValues(threshold, nextThreshold);
		statusBar:SetValue(rep);
		statusBar:Show();
	else
		statusBar:Hide();
	end
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------- Show/ Hide/ Update GossipFrame ---------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GwImmersiveFrameHandleShow(self)
	if (not self:IsShown()) then
		self:Show();
		if (not self:IsShown()) then
			C_GossipInfo.CloseGossip();
			return;
		end
		NPCFriendshipStatusBar_Update(self);
	end

	AUTO_NEXT_BLOCK = false;
	self.Scroll.ScrollChildFrame:Hide();
	self.Scroll.scrollButtonTitleInfo = {}

	local GwUpdate = UPDATE[LAST_ACTIVE_EVENT];	

	GwUpdate(self);

	if (self.Title.Text:GetText() ~= nil) then
		self.Title:Show();
	end

	self.Dialog:NextDialog();
end

local function GwImmersiveFrameHandleHide(self)
	GwForceClose();
	ANIMATION_TEXT_STOP = false;
	if (self:IsShown()) then
		self.Scroll.scrollButtonTitleInfo = nil;
		self.Title:Hide();
		self.DetailButton:Hide();
		self.Detail:Hide();
		self.buttonSettings.dropdown:Hide();
		self:Hide();
	end
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- EVENT ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local function GwGossipViewFrame_OnEvent(self, event, ...)
	print(event)
	if (event == "GOSSIP_SHOW") then
		local customGossipHandler = ...
		if (customGossipHandler) then
			return;
		end

		if not C_GossipInfo.ForceGossip() then
			C_Timer.After(0.5, function()
				if LAST_ACTIVE_EVENT ~= "GOSSIP_CLOSED" then
					SetActiveEvent(event);
					GwImmersiveFrameHandleShow(self);
				end
			end)
		else
			SetActiveEvent(event);
			GwImmersiveFrameHandleShow(self);
		end

		return;
	elseif (event == "GOSSIP_CLOSED") then
		SetActiveEvent(event);
		GwImmersiveFrameHandleHide(self)
		
		return;
	elseif (event == "QUEST_GREETING") then
		SetActiveEvent(event);
		GwImmersiveFrameHandleShow(self);
		
		return;
	elseif (event == "QUEST_LOG_UPDATE") then
		if ((LAST_ACTIVE_EVENT == "GOSSIP_SHOW") and self.hasActiveQuest or LAST_ACTIVE_EVENT == "QUEST_GREETING") then
			GwImmersiveFrameHandleShow(self);
		end
		
		return;
	elseif (event == "QUEST_DETAIL") then
		local questStartItemID = ...;

		if (GwAutoQuest(questStartItemID)) then
			GwForceClose();
			return;
		end

		SetActiveEvent(event);
		GwImmersiveFrameHandleShow(self);
		
		return;
	elseif (event == "QUEST_PROGRESS") then
			SetActiveEvent(event);
			GwImmersiveFrameHandleShow(self);
		return;
	elseif (event == "QUEST_COMPLETE") then
			SetActiveEvent(event);
			GwImmersiveFrameHandleShow(self);
		return;
	elseif (event == "QUEST_FINISHED") then
		if (self:IsShown()) then
			if (self.PrevActive == "GOSSIP_SHOW" or self.PrevActive == "QUEST_GREETING") then
				SetActiveEvent(PREV_ACTIVE_EVENT);
				GwImmersiveFrameHandleShow(self);
			else
				SetActiveEvent("GOSSIP_CLOSED");
				GwImmersiveFrameHandleHide(self);
			end
		end
		
		return;
	elseif (event == "QUEST_ITEM_UPDATE") then
		if (self:IsShown()) then
			if (LAST_ACTIVE_EVENT == "QUEST_DETAIL") then
				GwImmersiveFrameHandleShow(self);
			elseif (LAST_ACTIVE_EVENT == "QUEST_PROGRESS") then
				if (self.Detail:IsShown()) then
					GwQuestDetail_Update(self.Detail);
				end
			elseif (LAST_ACTIVE_EVENT =="QUEST_COMPLETE") then
			end
		end

		return;
	elseif (event == "LEARNED_SPELL_IN_TAB") then
		if (not self:IsShown()) then
			return;
		end
	end
end

local function GwGossipViewFrame_OnKeyDown(self, button)
	if (button == 'ESCAPE') then
		if (not QuestGetAutoAccept()) then
			GwForceClose();
		end
		self:SetPropagateKeyboardInput(false);
		return;
	elseif (button == "SPACE") then
		ANIMATION_TEXT_STOP = true;
		self:SetPropagateKeyboardInput(false);
		return;
	end

	local num = tonumber(button);
	if (num and self.Scroll.ScrollChildFrame:IsShown()) then
		local titlebutton = ITEM_BUTTOM_TITLE.buttons;
		titlebutton[num]:Click();

		self:SetPropagateKeyboardInput(false);
		return;
	else
		self:SetPropagateKeyboardInput(true);
	end
end

local function GwMoveAndScaleGossipViewFrame()
	if (MOVE_AND_SCALE) then
		GwGossipViewFrame.mover:RegisterForDrag("LeftButton")
		GwGossipViewFrame.mover:SetScript("OnDragStart", function (self)
			self:GetParent():StartMoving();
		end);
		GwGossipViewFrame.mover:SetScript("OnDragStop", function (self)
			self:GetParent():StopMovingOrSizing();
		end);

		GwGossipViewFrame.sizer.texture:SetDesaturated(true);
		GwGossipViewFrame.sizer:SetScript("OnEnter", function(self)
			GwGossipViewFrame.sizer.texture:SetDesaturated(false);
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 10, 30);
			GameTooltip:ClearLines();
			GameTooltip_SetTitle(GameTooltip, L["SIZER_HERO_PANEL"]);
			GameTooltip:Show();
		end)
		GwGossipViewFrame.sizer:SetScript("OnLeave", function(self)
			GwGossipViewFrame.sizer.texture:SetDesaturated(true);
			GameTooltip_Hide();
		end)
		GwGossipViewFrame.sizer:SetFrameStrata(GwGossipViewFrame:GetFrameStrata());
		GwGossipViewFrame.sizer:SetFrameLevel(GwGossipViewFrame:GetFrameLevel() + 15);
		GwGossipViewFrame.sizer:SetScript("OnMouseDown", function(self, btn)			
			if btn ~= "RightButton" then
				return;
			end

			self.GetScaleDistance = function ()
				local left, top = GossipViewFrameLeft, GossipViewFrameTop
				local scale = GossipViewFrameEffectiveScale
				local x, y = GetCursorPosition()
				x = x / scale - left
				y = top - y / scale
				return sqrt(x * x + y * y)
			end

			GossipViewFrameLeft, GossipViewFrameTop = self:GetParent():GetLeft(), self:GetParent():GetTop();

			GossipViewFrameNormalScale = self:GetParent():GetScale()
			GossipViewFrameX, GossipViewFrameY = GossipViewFrameLeft, GossipViewFrameTop - (UIParent:GetHeight() / GossipViewFrameNormalScale)
			GossipViewFrameEffectiveScale = self:GetParent():GetEffectiveScale()
			moveDistance = self.GetScaleDistance()

			self:SetScript("OnUpdate", function()
				local scale = self.GetScaleDistance() / moveDistance * GossipViewFrameNormalScale
				if scale < 0.2 then	scale = 0.2	elseif scale > 3.0 then	scale = 3.0	end
				self:GetParent():SetScale(scale)
				local s = GossipViewFrameNormalScale / self:GetParent():GetScale()
				local x = GossipViewFrameX * s
				local y = GossipViewFrameY * s
				self:GetParent():ClearAllPoints()
				self:GetParent():SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)

				print(self:GetParent():GetSize())
				print(self:GetParent():GetScale())
			end)
		end)
		GwGossipViewFrame.sizer:SetScript("OnMouseUp", function(self, btn)
			self:SetScript("OnUpdate", nil);
			self.GetScaleDistance = nil;
			--SetSetting("HERO_POSITION_SCALE", self:GetParent():GetScale())
			-- Save hero frame position
			-- local pos = GetSetting("HERO_POSITION")
			-- if pos then
			-- 	wipe(pos)
			-- else
			-- 	pos = {}
			-- end
			-- pos.point, _, pos.relativePoint, pos.xOfs, pos.yOfs = self:GetParent():GetPoint()
			--SetSetting("HERO_POSITION", pos)
			GwGossipViewFrame.Models.Player:RefreshCamera();
			GwGossipViewFrame.Models.Giver:RefreshCamera();
		end)
		GwGossipViewFrame.sizer:Show();
	else
		GwGossipViewFrame.mover:RegisterForDrag(nil);
		GwGossipViewFrame.mover:SetScript("OnDragStart", nil);
		GwGossipViewFrame.mover:SetScript("OnDragStop", nil);

		GwGossipViewFrame.sizer:SetScript("OnMouseDown", nil);
		GwGossipViewFrame.sizer:SetScript("OnMouseUp", nil);
		GwGossipViewFrame.sizer:Hide();
	end
end

local function GwChangeGossipFrame()
	if (FULL_SCREEN) then
		GwGossipViewFrame:UnregisterAllEvents();

		GwGossipEvent(GwFullScreenGossipViewFrame);
		GwFullScreenGossipViewFrame.buttonSettings:SetParent(GwFullScreenGossipViewFrame);
		GwFullScreenGossipViewFrame.buttonSettings:ClearAllPoints();
		GwFullScreenGossipViewFrame.buttonSettings:SetPoint("TOPRIGHT", GwFullScreenGossipViewFrame, "TOPRIGHT", -8, -8);
		GwFullScreenGossipViewFrame.buttonSettings:SetAlpha(0);

		GwFullScreenGossipViewFrame.buttonSettings.dropdown:Hide();
		GwFullScreenGossipViewFrame.buttonSettings.dropdown:SetSize(200, 285);
		GwFullScreenGossipViewFrame.buttonSettings.dropdown.moveAndScale:Hide();
		GwFullScreenGossipViewFrame.buttonSettings.dropdown.styleGW2:Show();
		GwFullScreenGossipViewFrame.buttonSettings.dropdown.borderChat:Show();
		GwFullScreenGossipViewFrame.buttonSettings.dropdown.dinamicBackground:Show();
		GwFullScreenGossipViewFrame.buttonSettings.dropdown.mouseDialog:Show();

		GwFullScreenGossipViewFrame.Dialog:GwBorderDialogFullScreen();
		GwFullScreenGossipViewFrame.Dialog:GwControlDialogWithMouse();
		
		if (GwGossipViewFrame:IsShown()) then
			GwGossipViewFrame:Hide();
			
			GwGossipViewFrame_OnEvent(GwFullScreenGossipViewFrame, LAST_ACTIVE_EVENT);
		end
	else
		GwFullScreenGossipViewFrame:UnregisterAllEvents();

		GwGossipEvent(GwGossipViewFrame);
		GwGossipViewFrame.buttonSettings:SetParent(GwGossipViewFrame);
		GwGossipViewFrame.buttonSettings:ClearAllPoints();
		GwGossipViewFrame.buttonSettings:SetPoint("TOPRIGHT", GwGossipViewFrame.mover, "TOPLEFT", -15, 0);
		GwGossipViewFrame.buttonSettings:SetAlpha(0);

		GwGossipViewFrame.buttonSettings.dropdown:Hide();
		GwGossipViewFrame.buttonSettings.dropdown:SetSize(200, 240);
		GwGossipViewFrame.buttonSettings.dropdown.styleGW2:Hide();
		GwGossipViewFrame.buttonSettings.dropdown.borderChat:Hide();
		GwGossipViewFrame.buttonSettings.dropdown.dinamicBackground:Hide();
		GwGossipViewFrame.buttonSettings.dropdown.mouseDialog:Hide();
		GwGossipViewFrame.buttonSettings.dropdown.moveAndScale:Show();
		
		GwMoveAndScaleGossipViewFrame();

		if (GwFullScreenGossipViewFrame:IsShown()) then
			GwFullScreenGossipViewFrame:Hide();

			GwGossipViewFrame_OnEvent(GwGossipViewFrame, LAST_ACTIVE_EVENT);
		end
	end
end

local function LoadQuestview()
	GwHideFrame(GossipFrame);
	GwHideFrame(QuestFrame);

	local buttonSettings = CreateFrame("Button", nil, nil, "buttonSettingsTemplate");

	CreateFrame("Frame", "GwFullScreenGossipViewFrame", UIParent, "GwFullScreenGossipViewFrameTemplate");
	GwFullScreenGossipViewFrame.Scroll.ScrollChildFrame:SetWidth(GwFullScreenGossipViewFrame.Scroll:GetWidth());
	GwFullScreenGossipViewFrame.Scroll.ScrollChildFrame:Hide();

	GwFullScreenGossipViewFrame:SetScript("OnEvent", GwGossipViewFrame_OnEvent);
	GwFullScreenGossipViewFrame:SetScript("OnKeyDown", GwGossipViewFrame_OnKeyDown);
	GwFullScreenGossipViewFrame.DetailButton:SetScript("OnClick", GwGossipViewFrameDetailButton_OnClick);
	GwFullScreenGossipViewFrame.buttonSettings = buttonSettings;
	GwFullScreenGossipViewFrame.Dialog.maxSizeText = 600;

	CreateFrame("Frame", "GwGossipViewFrame", UIParent, "GwGossipViewFrameTemplate");
	GwGossipViewFrame.Scroll.ScrollChildFrame:SetWidth(GwGossipViewFrame.Scroll:GetWidth());
	GwGossipViewFrame.Scroll.ScrollChildFrame:Hide();
	GwGossipViewFrame:SetScript("OnEvent", GwGossipViewFrame_OnEvent);
	GwGossipViewFrame:SetScript("OnKeyDown", GwGossipViewFrame_OnKeyDown);
	GwGossipViewFrame.DetailButton:SetScript("OnClick", GwGossipViewFrameDetailButton_OnClick);
	GwGossipViewFrame.buttonSettings = buttonSettings;
	GwGossipViewFrame.Dialog:SetScript("OnClick", GwGossipViewFrameDialog_OnClick);
	GwGossipViewFrame.Dialog.maxSizeText = 300;

	GwChangeGossipFrame();

	ITEM_BUTTOM_TITLE.buttonPool = CreateFramePool("BUTTON", nil, "GwChoiceTitleButtonTemplate");
	ITEM_BUTTOM_REWARD.buttonPool = CreateFramePool("BUTTON", nil, "GwGossipQuestItemTemplate, GwGossipRewardItemCodeTemplate");
	
	do
        --EnableTooltip(buttonSettings, "Gossip Option")
        local dd = buttonSettings.dropdown
        dd:CreateBackdrop(GW.skins.constBackdropFrame)
        buttonSettings:HookScript(
            "OnClick",
            function(self)
                if dd:IsShown() then
                    dd:Hide()
                else
                    -- check if the dropdown need to grow up or down
                    local _, y = self:GetCenter()
                    local screenHeight = UIParent:GetTop()
                    local position
                    if y > (screenHeight / 2) then
                        position = "TOPRIGHT"
                    else
                        position = "BOTTOMRIGHT"
                    end
                    dd:ClearAllPoints()
                    dd:SetPoint(position, dd:GetParent(), "LEFT", 0, -5)
                    dd:Show()
                end
            end
        )
        dd.fullScreen.checkbutton:SetScript(
            "OnClick",
			function(self)
				if (QuestGetAutoAccept()) then
					return;
				end

				FULL_SCREEN = not FULL_SCREEN;
				self:SetChecked(FULL_SCREEN);

				GwChangeGossipFrame();
            end
        )
		dd.forceGossip.checkbutton:HookScript(
            "OnClick",
			function(self)
				FORCE_GOSSIP = not FORCE_GOSSIP;
				self:SetChecked(FORCE_GOSSIP);
            end
		)
		dd.autoNext.checkbutton:HookScript(
            "OnClick",
			function(self)
				AUTO_NEXT = not AUTO_NEXT;
				self:SetChecked(AUTO_NEXT);
            end
		)
		dd.autoNextTime.slider:HookScript(
            "OnValueChanged",
			function(self)
				local newValue = GW.RoundDec(self:GetValue(), 1);
				self:GetParent().input:SetText(newValue);
				AUTO_NEXT_TIME = tonumber(newValue);
            end
		)
		dd.autoNextTime.input:HookScript(
            "OnEnterPressed",
			function(self)
				local roundValue = GW.RoundDec(self:GetNumber(), 1) or 0.5;
			
				self:ClearFocus();

				if tonumber(roundValue) > 60 then 
					self:SetText(60); 
				end

				if tonumber(roundValue) < 0 then 
					self:SetText(0);
				end

				roundValue = GW.RoundDec(self:GetNumber(), 1) or 0.5;
			
				self:GetParent().slider:SetValue(roundValue);
            end
		)
		dd.animationTextSpeed.slider:HookScript(
            "OnValueChanged",
			function(self)
				local newValue = GW.RoundDec(self:GetValue(), 2)
				self:GetParent().input:SetText(newValue);
				ANIMATION_TEXT_SPEED = tonumber(newValue);
            end
		)
		dd.animationTextSpeed.input:HookScript(
            "OnEnterPressed",
			function(self)
				local roundValue = GW.RoundDec(self:GetNumber(), 2) or 0.05;
			
				self:ClearFocus();
				
				if tonumber(roundValue) > 60 then 
					self:SetText(60); 
				end

				if tonumber(roundValue) < 0 then 
					self:SetText(0);
				end

				roundValue = GW.RoundDec(self:GetNumber(), 2) or 0.05;
			
				self:GetParent().slider:SetValue(roundValue);
            end
		)
		dd.moveAndScale.checkbutton:HookScript(
			"OnClick",
			function(self)
				MOVE_AND_SCALE = not MOVE_AND_SCALE;
				self:SetChecked(MOVE_AND_SCALE);

				GwMoveAndScaleGossipViewFrame();
			end
		)
		dd.styleGW2.checkbutton:HookScript(
			"OnClick",
			function(self)
				STYLE_GW2 = not STYLE_GW2;
				self:SetChecked(STYLE_GW2);

				GwFullScreenGossipViewFrame.Background:OnShow();
			end
		)
		dd.borderChat.checkbutton:HookScript(
			"OnClick",
			function(self)
				BORDER_CHAT = not BORDER_CHAT;
				self:SetChecked(BORDER_CHAT);

				GwFullScreenGossipViewFrame.Dialog:GwBorderDialogFullScreen();
			end
		)
		dd.dinamicBackground.checkbutton:HookScript(
			"OnClick",
			function(self)
				DINAMIC_BACKGROUND = not DINAMIC_BACKGROUND;
				self:SetChecked(DINAMIC_BACKGROUND);

				GwFullScreenGossipViewFrame.Background:OnShow();
			end
		)
		dd.mouseDialog.checkbutton:HookScript(
            "OnClick",
			function(self)
				MOUSE_DIALOG = not MOUSE_DIALOG;
				self:SetChecked(MOUSE_DIALOG);
				
				GwFullScreenGossipViewFrame.Dialog:GwControlDialogWithMouse();
            end
		)
		
		dd.fullScreen.checkbutton:SetChecked(FULL_SCREEN);
		dd.forceGossip.checkbutton:SetChecked(FORCE_GOSSIP);
		dd.autoNext.checkbutton:SetChecked(FORCE_GOSSIP);
		dd.autoNextTime.slider:SetMinMaxValues(0, 60);
		dd.autoNextTime.slider:SetValueStep(0.05);
		dd.autoNextTime.slider:SetValue(AUTO_NEXT_TIME);
		dd.autoNextTime.input:SetText(AUTO_NEXT_TIME);
		dd.animationTextSpeed.slider:SetMinMaxValues(0, 5);
		dd.animationTextSpeed.slider:SetValueStep(0.005);
		dd.animationTextSpeed.slider:SetValue(ANIMATION_TEXT_SPEED);
		dd.animationTextSpeed.input:SetText(ANIMATION_TEXT_SPEED);
		dd.moveAndScale.checkbutton:SetChecked(MOVE_AND_SCALE);
		dd.styleGW2.checkbutton:SetChecked(STYLE_GW2);
		dd.borderChat.checkbutton:SetChecked(BORDER_CHAT);
		dd.dinamicBackground.checkbutton:SetChecked(FORCE_GOSSIP);
		dd.mouseDialog.checkbutton:SetChecked(MOUSE_DIALOG);

        -- setup bag setting title locals
		dd.fullScreen.title:SetText("Full Screen");
		dd.forceGossip.title:SetText("Force Gossip");
		dd.autoNext.title:SetText("Auto Next");
		dd.autoNextTime.title:SetText("Speed Auto Next");
		dd.animationTextSpeed.title:SetText("Speed Text Animation");
		dd.moveAndScale.title:SetText("Move And Scale");
		dd.styleGW2.title:SetText("Style GW2");
		dd.borderChat.title:SetText("Border Chat");
		dd.dinamicBackground.title:SetText("Dinamic Background");
		dd.mouseDialog.title:SetText("Control Dialog with Mouse");
	end
	
	C_GossipInfo.ForceGossip = function() return FORCE_GOSSIP end;
end

GW.LoadQuestview = LoadQuestview
