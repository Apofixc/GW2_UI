local _, GW = ...
local L = GW.L
local GetSetting = GW.GetSetting
local SetSetting = GW.SetSetting

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- MODEL ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- CUSTOME ----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

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

local function getCustomZoneBackground(zone)
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

local function FullScreenFrameStyleOnShow(self)	
	if (GetSetting("STYLE_GW2")) then
		local num = math.random(1, 1);

		self.Border:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_border_"..num);
		self.Bottom:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_gw2_bottom_"..num);
		self.Top:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_gw2_top_"..num);

		self:GetParent().Detail.background:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_gw2_reward");
	else
		self.Border:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_border_1");
		self.Bottom:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_classic_bottom");
		self.Top:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_classic_top");

		self:GetParent().Detail.background:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_classic_reward");
	end

	if (GetSetting("DINAMIC_BACKGROUND")) then
		if (C_CampaignInfo.IsCampaignQuest(GetQuestID())) then
			self.backgroundLayer:SetAtlas( "QuestBG-"..UnitFactionGroup("player"));
			self.backgroundLayer:SetTexCoord(0.2, 0.99, 0.5, 0.95);
			self.backgroundLayer:Show();
			self.middlegroundLayer:Hide();
			self.foregroundLayer:Hide();
		elseif (getCustomZoneBackground(STATIC_BACKGROUNDS)) then
			local zoneBackground = getCustomZoneBackground(STATIC_BACKGROUNDS);
			self.backgroundLayer:SetAtlas(zoneBackground);
			self.backgroundLayer:Show();
			self.middlegroundLayer:Hide();
			self.foregroundLayer:Hide();
		elseif (getCustomZoneBackground(DYNAMIC_BACKGROUNDS)) then
			local dynamicBackground = getCustomZoneBackground(DYNAMIC_BACKGROUNDS);
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
				self.backgroundLayer:SetTexture("Interface/AddOns/GW2_UI/textures/questview/fsgvf_bg_default");
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

local function LoadImmersiveCustome()
	do
		GwImmersiveFrame.NormalFrame.mover:HookScript("OnDragStop", function(self)

		end)

		GwImmersiveFrame.NormalFrame.sizer:HookScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 10, 30);
			GameTooltip:ClearLines();
			GameTooltip_SetTitle(GameTooltip, L["SIZER_HERO_PANEL"]);
			GameTooltip:Show();
		end)

		GwImmersiveFrame.NormalFrame.sizer:HookScript("OnLeave", function(self)
			GameTooltip_Hide();
		end)

		GwImmersiveFrame.NormalFrame.sizer:HookScript("OnMouseUp", function(self, btn)
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
			GwImmersiveFrame.NormalFrame.Models.Player:RefreshCamera();
			GwImmersiveFrame.NormalFrame.Models.Giver:RefreshCamera();
		end)
	end

	GwImmersiveFrame.FullScreenFrame.Background:SetScript("OnShow", FullScreenFrameStyleOnShow);
	GW.ImmersiveFrameChange(GetSetting("FULL_SCREEN"));
	GwImmersiveFrame.enableClick = GetSetting("MOUSE_DIALOG");
	
	local moveAndScale = GetSetting("MOVE_AND_SCALE");
	GwImmersiveFrame.NormalFrame.mover.isMoving = moveAndScale;
	GwImmersiveFrame.NormalFrame.sizer.isSizing = moveAndScale;

	if (moveAndScale) then
		GwImmersiveFrame.NormalFrame.sizer:Show();
	else
		GwImmersiveFrame.NormalFrame.sizer:Hide();
	end
end

GW.LoadImmersiveCustome = LoadImmersiveCustome

local function LoadImmersiveOption()
	CreateFrame("Frame", "GwImmersiveSettings", nil, "ImmersiveSettingsTemplate");

	GwImmersiveSettings.advacedMode.checkbutton:HookScript(
		"OnClick",
	   function(self)
		   local newStatus = not GetSetting("ADVANCED_MODE");
		   self:SetChecked(newStatus);
		   SetSetting("ADVANCED_MODE", newStatus)
		   
		   C_UI.Reload();
		end
	)

    GwImmersiveSettings.fullScreen.checkbutton:HookScript(
         "OnClick",
		function(self)
			if (QuestGetAutoAccept()) then
				return;
			end

			local newStatus = not GetSetting("FULL_SCREEN");
            self:SetChecked(newStatus);
			SetSetting("FULL_SCREEN", newStatus)
			
			if (GwImmersiveFrame) then
				GW.ImmersiveFrameChange(newStatus)
			end
         end
    )
	GwImmersiveSettings.forceGossip.checkbutton:HookScript(
         "OnClick",
		function(self)
            local newStatus = not GetSetting("FORCE_GOSSIP");
            self:SetChecked(newStatus);
            SetSetting("FORCE_GOSSIP", newStatus)
         end
	)
	GwImmersiveSettings.autoNext.checkbutton:HookScript(
         "OnClick",
		function(self)
            local newStatus = not GetSetting("AUTO_NEXT");
            self:SetChecked(newStatus);
            SetSetting("AUTO_NEXT", newStatus)
         end
	)
	GwImmersiveSettings.autoNextTime.slider:HookScript(
         "OnValueChanged",
		function(self)
			local newValue = GW.RoundDec(self:GetValue(), 1);
            self:GetParent().input:SetText(newValue);
            SetSetting("AUTO_NEXT_TIME", tonumber(newValue))
         end
	)
	GwImmersiveSettings.autoNextTime.input:HookScript(
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
	GwImmersiveSettings.animationTextSpeed.slider:HookScript(
         "OnValueChanged",
		function(self)
			local newValue = GW.RoundDec(self:GetValue(), 2)
            self:GetParent().input:SetText(newValue);
            SetSetting("ANIMATION_TEXT_SPEED", tonumber(newValue))
         end
	)
	GwImmersiveSettings.animationTextSpeed.input:HookScript(
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
	GwImmersiveSettings.moveAndScale.checkbutton:HookScript(
		"OnClick",
		function(self)
			local newStatus = not GetSetting("MOVE_AND_SCALE");
            self:SetChecked(newStatus);
            SetSetting("MOVE_AND_SCALE", newStatus)

			if (GwImmersiveFrame and GwImmersiveFrame.NormalFrame) then
				GwImmersiveFrame.NormalFrame.mover.isMoving = newStatus;
				GwImmersiveFrame.NormalFrame.sizer.isSizing = newStatus;
				
				if (newStatus) then
					GwImmersiveFrame.NormalFrame.sizer:Show();
				else
					GwImmersiveFrame.NormalFrame.sizer:Hide();
				end
			end
		end
	)
	GwImmersiveSettings.styleGW2.checkbutton:HookScript(
		"OnClick",
		function(self)
			local newStatus = not GetSetting("STYLE_GW2");
            self:SetChecked(newStatus);
            SetSetting("STYLE_GW2", newStatus)
             
			if (GwImmersiveFrame and GwImmersiveFrame.FullScreenFrame and GwImmersiveFrame.FullScreenFrame:IsShown()) then
				FullScreenFrameStyleOnShow(GwImmersiveFrame.FullScreenFrame.Background);
			end
		end
	)
	GwImmersiveSettings.dinamicBackground.checkbutton:HookScript(
		"OnClick",
		function(self)
			local newStatus = not GetSetting("DINAMIC_BACKGROUND");
            self:SetChecked(newStatus);
			SetSetting("DINAMIC_BACKGROUND", newStatus)
			
			if (GwImmersiveFrame and GwImmersiveFrame.FullScreenFrame and GwImmersiveFrame.FullScreenFrame:IsShown()) then
				FullScreenFrameStyleOnShow(GwImmersiveFrame.FullScreenFrame.Background);
			end
		end
	)
	GwImmersiveSettings.mouseDialog.checkbutton:HookScript(
         "OnClick",
		function(self)              
            local newStatus = not GetSetting("MOUSE_DIALOG");
            self:SetChecked(newStatus);
            SetSetting("MOUSE_DIALOG", newStatus)

			if (GwImmersiveFrame) then
				GwImmersiveFrame.enableClick = newStatus;
			end
         end
	)
	
	GwImmersiveSettings.advacedMode.checkbutton:SetChecked(GetSetting("ADVANCED_MODE"));
	GwImmersiveSettings.fullScreen.checkbutton:SetChecked(GetSetting("FULL_SCREEN"));
	GwImmersiveSettings.forceGossip.checkbutton:SetChecked(GetSetting("FORCE_GOSSIP"));
	GwImmersiveSettings.autoNext.checkbutton:SetChecked(GetSetting("AUTO_NEXT"));
	GwImmersiveSettings.autoNextTime.slider:SetMinMaxValues(0, 60);
	GwImmersiveSettings.autoNextTime.slider:SetValueStep(0.05);
	GwImmersiveSettings.autoNextTime.slider:SetValue(GetSetting("AUTO_NEXT_TIME"));
	GwImmersiveSettings.autoNextTime.input:SetText(GetSetting("AUTO_NEXT_TIME"));
	GwImmersiveSettings.animationTextSpeed.slider:SetMinMaxValues(0, 5);
	GwImmersiveSettings.animationTextSpeed.slider:SetValueStep(0.005);
	GwImmersiveSettings.animationTextSpeed.slider:SetValue(GetSetting("ANIMATION_TEXT_SPEED"));
	GwImmersiveSettings.animationTextSpeed.input:SetText(GetSetting("ANIMATION_TEXT_SPEED"));
	GwImmersiveSettings.moveAndScale.checkbutton:SetChecked(MOVE_AND_SCALE);
	GwImmersiveSettings.styleGW2.checkbutton:SetChecked(GetSetting("STYLE_GW2"));
	GwImmersiveSettings.dinamicBackground.checkbutton:SetChecked(GetSetting("DINAMIC_BACKGROUND"));
	GwImmersiveSettings.mouseDialog.checkbutton:SetChecked(GetSetting("MOUSE_DIALOG"));

	GwImmersiveSettings.advacedMode.title:SetText("Advanced Mode");
	GwImmersiveSettings.fullScreen.title:SetText("Full Screen");
	GwImmersiveSettings.forceGossip.title:SetText("Force Gossip");
	GwImmersiveSettings.autoNext.title:SetText("Auto Next");
	GwImmersiveSettings.autoNextTime.title:SetText("Speed Auto Next");
	GwImmersiveSettings.animationTextSpeed.title:SetText("Speed Text Animation");
	GwImmersiveSettings.moveAndScale.title:SetText("Move And Scale");
	GwImmersiveSettings.styleGW2.title:SetText("Style GW2");
	GwImmersiveSettings.dinamicBackground.title:SetText("Dinamic Background");
	GwImmersiveSettings.mouseDialog.title:SetText("Control Dialog with Mouse");

	tinsert(UISpecialFrames, GwImmersiveSettings:GetName())
end

GW.LoadImmersiveOption = LoadImmersiveOption