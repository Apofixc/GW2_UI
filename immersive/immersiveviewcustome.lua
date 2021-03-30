local _, GW = ...
local L = GW.L
local AddToAnimation = GW.AddToAnimation
local ActiveAnimation = GW.ActiveAnimation
local StopAnimation = GW.StopAnimation
GW.CUSTOME_IMMERSIVE = {}

---------------------------------------------------------------------------------------------------------------------
----------------------------------------------- INTERACTIVE ---------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

do
	local INTERACTIVE_TEXT = {
		ACCEPT = {"Принять"},
		DECLINE = {"Отказаться"},
		NEXT = {"Далее", "Продолжить"},
		BACK = {"Назад"},
		RESET = {"Повторить"},
		CANCEL = {"Выход", "Отмена"},
		EXIT = {"Выход"},
		COMPLETE = {"Завершить"},
		FINISH = {"Завершить"}
	}

	local function GetInteractiveText(buttonType)
		return INTERACTIVE_TEXT[buttonType][math.random(1, #INTERACTIVE_TEXT[buttonType])]
	end

	GW.CUSTOME_IMMERSIVE.GetInteractiveText = GetInteractiveText
end

---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- MODEL ------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

do 
	local EMOTES = {
		["Idle"] = 0,
		["Dead"] = 6,
		["Talk"] = 60,
		["TalkExclamation"] = 64,
		["TalkQuestion"] = 65,
		["Bow"] = 66,
		["Point"] = 84,
		["Salute"] = 113,
		["Drowned"] = 132,
		["Yes"] = 185,
		["No"] = 186
	}

	local function Animation(self)

	end

	local MODEL_INFO = {}

	local function SetDefaultModel(frameModel, idModel, Camera, Facing, TargetDistance, HeightFactor, FacingLeft, Light)
		if not MODEL_INFO[frameModel] then MODEL_INFO[frameModel] = {} end
		if idModel and not MODEL_INFO[frameModel][idModel] then MODEL_INFO[frameModel][idModel] = {} end

		local model = idModel and MODEL_INFO[frameModel][idModel] or MODEL_INFO[frameModel]
		model.Camera = Camera
		model.Facing = Facing
		model.TargetDistance = TargetDistance
		model.HeightFactor = HeightFactor	
		model.FacingLeft = FacingLeft
		model.Light = Light
	end

	local function LoadModelInfo(frameModel, frameModelFullScreen)
		SetDefaultModel(frameModel.Player, nil, .5, .8, 0, 0, false, { true, false, -250, 0, 0, .25, 1, 1, 1, 75, 1, 1,	1})
		SetDefaultModel(frameModel.Giver, nil, .4, .9, .12, 2.2, true, { true, false, -250, 0, 0, .25, 1, 1, 1, 75, 1, 1, 1})
		SetDefaultModel(frameModelFullScreen.Player, nil, 1.8, 1.8, .22, .395, false, { true, false, -250, 0, 0, .25, 1, 1, 1, 75, 1, 1, 1})
		SetDefaultModel(frameModelFullScreen.Giver, nil, 1.8, -.95, .22, .325, true, { true, false, -250, 0, 0, .25, 1, 1, 1, 75, 1, 1,	1})

		SetDefaultModel(frameModelFullScreen.Giver, 1324256, 1.7, -1.2, -.12)
	end

	GW.CUSTOME_IMMERSIVE.LoadModelInfo = LoadModelInfo

	local function DebugModelOn(frameModel, frameModelFullScreen)
		for _, model in pairs({frameModel.Player, frameModel.Giver, frameModelFullScreen.Player, frameModelFullScreen.Giver}) do
			model:SetScript("OnModelLoaded", 
				function(self)
					self.displayedModel = self:GetModelFileID()
					
					local defaults = MODEL_INFO[self]
					local fixModel = defaults[self.displayedModel]

					self.scaleCamera = defaults.Camera  + (fixModel and fixModel.Camera or 0)
					self.oldScaleCamera = defaults.Camera
					self.scaleHeight = defaults.HeightFactor  + (fixModel and fixModel.HeightFactor or 0)
					self.oldScaleHeight = defaults.HeightFactor
					self.scaleTargetDistance = defaults.TargetDistance  + (fixModel and fixModel.TargetDistance or 0)
					self.oldScaleTargetDistance = defaults.TargetDistance
					self.Facing = defaults.Facing  + (fixModel and fixModel.Facing or 0)
					self.oldFacing = defaults.Facing
				end
			)

			model:EnableMouseWheel(true);
			model:SetScript("OnMouseWheel", 
				function(self, delta)
					if IsAltKeyDown() then
						self.Facing = self.Facing - (IsShiftKeyDown() and 0.2 or 0.02) * delta;
						self:SetFacing(self.Facing)
					elseif IsControlKeyDown() then
						self.scaleTargetDistance = self.scaleTargetDistance - (IsShiftKeyDown() and 0.1 or 0.01)* delta
						self:SetTargetDistance(self.scaleTargetDistance)
					elseif IsShiftKeyDown() then
						self.scaleHeight = self.scaleHeight - (IsControlKeyDown() and 0.1 or 0.01)* delta
						self:SetHeightFactor(self.scaleHeight)
					else
						self.scaleCamera = self.scaleCamera - (IsShiftKeyDown() and 0.1 or 0.01) * delta
						self:InitializeCamera(self.scaleCamera)
					end	

					GameTooltip:ClearLines()
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:AddLine("ModelID: "..self.displayedModel)
					GameTooltip:AddLine("Camera -> Old: "..self.oldScaleCamera.." New: "..self.scaleCamera.." Diff: "..(self.scaleCamera - self.oldScaleCamera))
					GameTooltip:AddLine("Scale Height -> Old: "..self.oldScaleHeight.." New: "..self.scaleHeight.." Diff: "..(self.scaleHeight - self.oldScaleHeight))
					GameTooltip:AddLine("Scale Target Distance -> Old: "..self.oldScaleTargetDistance.." New: "..self.scaleTargetDistance.." Diff: "..(self.scaleTargetDistance - self.oldScaleTargetDistance))
					GameTooltip:AddLine("Facing -> Old: "..self.oldFacing.." New: "..self.Facing.." Diff: "..(self.Facing - self.oldFacing))
					GameTooltip:Show()
				end
			)

			model:SetScript("OnLeave",
				function()
					GameTooltip:Hide()
				end
			)
		end

		frameModelFullScreen.Player:SetPoint("TOPRIGHT", -50, 0)
		frameModelFullScreen.Giver:SetPoint("TOPLEFT", 50, 0)
	end

	local function DebugModelOff()
		return
	end

	if (true) then
		GW.CUSTOME_IMMERSIVE.DebugModel = DebugModelOn
	else
		GW.CUSTOME_IMMERSIVE.DebugModel = DebugModelOff
	end

	local function SetUnitModel(self, unit)
		self.defectmodel = false

		self:ClearModel()
		self:SetUnit(unit)
		--self:SetDisplayInfo(4)
		if self.Name then
			self.Name.Text:SetText(unit == "none" and "UNKNOWN" or UnitName(unit))
		end

		local defaults = MODEL_INFO[self]
		local fixModel = defaults[self:GetModelFileID()]
		--QuestFrame_ShowQuestPortrait(GwImmersiveFrame.GossipFrame, 84929, 0, "questPortraitText", "questPortraitName", -3, -42)

		self:InitializeCamera(defaults.Camera + (fixModel and fixModel.Camera or 0))
		self:SetFacingLeft(defaults.FacingLeft)
		self:SetTargetDistance(defaults.TargetDistance + (fixModel and fixModel.TargetDistance or 0))
		self:SetHeightFactor(defaults.HeightFactor + (fixModel and fixModel.HeightFactor or 0))
		self:SetRotation(defaults.Facing + (fixModel and fixModel.Facing or 0))

		self:SetLight(unpack(defaults.Light))
	end

	GW.CUSTOME_IMMERSIVE.SetUnitModel = SetUnitModel
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
	
		--["174"] = "charactercreate-startingzone-goblin", -- The Lost Isles
		--["175"] = "charactercreate-startingzone-goblin", -- Kaja'mite Cavern (Microdungeon)
		--["176"] = "charactercreate-startingzone-goblin", -- Volcanoth's Lair (Microdungeon)
		--["177"] = "charactercreate-startingzone-goblin", -- Gallywix Labor Mine (Microdungeon)
		--["178"] = "charactercreate-startingzone-goblin", -- Gallywix Labor Mine 2 (Microdungeon)
	
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
		--["840"] = "charactercreate-startingzone-gnome", -- Gnomeregan 1 (Dungeon)
		--["841"] = "charactercreate-startingzone-gnome", -- Gnomeregan 2 (Dungeon)
		--["842"] = "charactercreate-startingzone-gnome", -- Gnomeregan 3 (Dungeon)
		--["1371"] = "charactercreate-startingzone-gnome", -- Gnomeregan A
		--["1372"] = "charactercreate-startingzone-gnome", -- Gnomeregan B
		--["1380"] = "charactercreate-startingzone-gnome", -- Gnomeregan C
		--["1374"] = "charactercreate-startingzone-gnome", -- Gnomeregan D
	
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
		--["302"] = "charactercreate-startingzone-undead", -- Scarlet Monastery 1 (Dungeon)
		--["303"] = "charactercreate-startingzone-undead", -- Scarlet Monastery 2 (Dungeon)
		--["304"] = "charactercreate-startingzone-undead", -- Scarlet Monastery 3 (Dungeon)
		--["305"] = "charactercreate-startingzone-undead", -- Scarlet Monastery 4 (Dungeon)
		--["431"] = "charactercreate-startingzone-undead", -- Scarlet Halls 1 (Dungeon)
		--["432"] = "charactercreate-startingzone-undead", -- Scarlet Halls 2 (Dungeon)
		--["435"] = "charactercreate-startingzone-undead", -- Scarlet Monastery New 1 (Dungeon)
		--["436"] = "charactercreate-startingzone-undead", -- Scarlet Monastery New 2 (Dungeon)
		["465"] = "charactercreate-startingzone-undead", -- Deathknell (Tirisfal Glades)
		["466"] = "charactercreate-startingzone-undead", -- Night's Web Hollow (Microdungeon)
		--["804"] = "charactercreate-startingzone-undead", -- SM Newer 1 (Dungeon)
		--["805"] = "charactercreate-startingzone-undead", -- SM Newer 2 (Dungeon)
		["997"] = "charactercreate-startingzone-undead", -- Tirisfal Glades 2
		["1247"] = "charactercreate-startingzone-undead", -- Tirisfal Glades 3
		--["1465"] = "charactercreate-startingzone-undead", -- Scarlet Halls (Dungeon)
	
		--Pandaren
		["378"] = "charactercreate-startingzone-pandaren", -- The Wandering Isle
		["709"] = "charactercreate-startingzone-pandaren", -- The Wandering Isle (Legion)
	
		--region Shadowlands
		["1533"] = "UI-Frame-KyrianChoice-ScrollingBG",
		["1569"] = "UI-Frame-KyrianChoice-ScrollingBG",
		["1813"] = "UI-Frame-KyrianChoice-ScrollingBG",
	
		["1536"] = "UI-Frame-NecrolordsChoice-ScrollingBG",
		["1689"] = "UI-Frame-NecrolordsChoice-ScrollingBG",
		["1741"] = "UI-Frame-NecrolordsChoice-ScrollingBG",
		["1814"] = "UI-Frame-NecrolordsChoice-ScrollingBG",
	
		["1565"] = "UI-Frame-NightFaeChoice-ScrollingBG",
		["1603"] = "UI-Frame-NightFaeChoice-ScrollingBG",
		["1643"] = "UI-Frame-NightFaeChoice-ScrollingBG",
		["1709"] = "UI-Frame-NightFaeChoice-ScrollingBG",
		["1739"] = "UI-Frame-NightFaeChoice-ScrollingBG",
		["1740"] = "UI-Frame-NightFaeChoice-ScrollingBG",
	
		["1525"] = "UI-Frame-VenthyrChoice-ScrollingBG",
		["1688"] = "UI-Frame-VenthyrChoice-ScrollingBG",
		["1734"] = "UI-Frame-VenthyrChoice-ScrollingBG",
		["1738"] = "UI-Frame-VenthyrChoice-ScrollingBG",
		["1742"] = "UI-Frame-VenthyrChoice-ScrollingBG",
	
		--endregion
	
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
						--return info.typeTextureKit, info.uiTextureKit, {0, 1, 0, 1}
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
	
	local function DinamicArt(parent, newStatus)
		if (newStatus) then
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
	end

	GW.CUSTOME_IMMERSIVE.DinamicArt = DinamicArt
end