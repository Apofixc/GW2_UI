local _, GW = ...
local L = GW.L
local animations = GW.animations
local AddToAnimation = GW.AddToAnimation

local function FinishedAnimation(name)
	return animations[name] == nil or animations[name]["completed"] == true
end
GW.FinishedAnimation = FinishedAnimation

local function FadeAnimation(frame, name, fadeStart, fadeFinish, duration, funcFinish)
	AddToAnimation(
		name,
		fadeStart,
		fadeFinish,
		GetTime(),
		duration,
		function(step)
			frame:SetAlpha(step)	
		end,
		nil,
		funcFinish,
		true
	)
end
GW.FadeAnimation = FadeAnimation

local function DialogAnimation(frame, name, start, finish, duration, funcFinish)
	AddToAnimation(
		name,
		start,
		finish,
		GetTime(),
		duration,
		function(step)
			frame:SetAlphaGradient(step, 1)
		end,
		nil,
		funcFinish
	)
end
GW.DialogAnimation = DialogAnimation


do

end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- CUSTOME ----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
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
	
	local function getCustomZoneBackground()
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
	
	local function ImmersiveDinamicArt(parent)
		parent:HookScript("OnShow", 
			function (self)
				local typeBackGrounds, texture, texCoord = getCustomZoneBackground()
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
		)
	end

	GW.ImmersiveDinamicArt = ImmersiveDinamicArt
end