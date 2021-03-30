<!-- 			<Layer level="ARTWORK">	
				<Texture parentKey="BottomLeft" hidden="true">
					<Anchors>
						<Anchor point="BOTTOMLEFT" relativeKey="$parent" relativePoint="BOTTOMLEFT" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="BottomRight" hidden="true">
					<Anchors>
						<Anchor point="BOTTOMRIGHT" relativeKey="$parent" relativePoint="BOTTOMRIGHT" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="TopRight" hidden="true">
					<Anchors>
						<Anchor point="TOPRIGHT" relativeKey="$parent" relativePoint="TOPRIGHT" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="TopLeft" hidden="true">
					<Anchors>
						<Anchor point="TOPLEFT" relativeKey="$parent" relativePoint="TOPLEFT" x="0" y="0"/>
					</Anchors>
				</Texture>		
				<Texture parentKey="Left" hidden="true">
					<Anchors>
						<Anchor point="LEFT" relativeKey="$parent" relativePoint="LEFT" x="0" y="0"/>
						<Anchor point="BOTTOM" relativeKey="$parent.BottomLeft" relativePoint="TOP" x="0" y="0"/>
						<Anchor point="TOP" relativeKey="$parent.TopLeft" relativePoint="BOTTOM" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="Right" hidden="true">
					<Anchors>
						<Anchor point="RIGHT" relativeKey="$parent" relativePoint="RIGHT" x="0" y="0"/>
						<Anchor point="BOTTOM" relativeKey="$parent.BottomRight" relativePoint="TOP" x="0" y="0"/>
						<Anchor point="TOP" relativeKey="$parent.TopRight" relativePoint="BOTTOM" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="Bottom" hidden="true">
					<Anchors>
						<Anchor point="BOTTOM" relativeKey="$parent" relativePoint="BOTTOM" x="0" y="0"/>
						<Anchor point="LEFT" relativeKey="$parent.BottomLeft" relativePoint="RIGHT" x="0" y="0"/>
						<Anchor point="RIGHT" relativeKey="$parent.BottomRight" relativePoint="LEFT" x="0" y="0"/>
					</Anchors>
				</Texture>
				<Texture parentKey="Top" hidden="true">
					<Anchors>
						<Anchor point="TOP" relativeKey="$parent" relativePoint="TOP" x="0" y="0"/>
						<Anchor point="LEFT" relativeKey="$parent.TopLeft" relativePoint="RIGHT" x="0" y="0"/>
						<Anchor point="RIGHT" relativeKey="$parent.TopRight" relativePoint="LEFT" x="0" y="0"/>
					</Anchors>
				</Texture>
			</Layer>  
-->

	local function SetFontColor(color)
		IGNORED_QUEST_DISPLAY = color.Ignored
		TRIVIAL_QUEST_DISPLAY = color.Trivial
		NORMAL_QUEST_DISPLAY = color.Normal
		ACTION_DISPLAY = color.Action
	end

	GW.CUSTOME_IMMERSIVE.SetFontColor = SetFontColor

	local FULL_SCREEN_THEME = {
		GW2 = {
			maxSizeText = 400,
			TitleHighlightTexture = "Interface/QuestFrame/UI-QuestTitleHighlight",
			Parent = {
				Border = {path = "Interface/AddOns/GW2_UI/textures/questview/advanced/fs_gw2", texCoord = {0, 1, 0, 0.499}},
				Middleground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
				Background = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
				Foreground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}}
			},
			ReputationBar = {
				Background = {format = true, atlas = "Garr_Mission_MaterialFrame", useAtlasSize = false, texCoord = {1, 0, 0, 0, 1, 1, 0, 1}, points = {{"TOPLEFT", -20, 15}, {"BOTTOMRIGHT", 20, -15}}},
			},
			Detail = {
				Background = {path = "Interface/AddOns/GW2_UI/textures/questview/advanced/fs_gw2", texCoord = {0, 0.5, 0.5, 1}}
			},
		},
		SHADOWLANDS = {	
			maxSizeText = 400,
			TitleHighlightTexture = "Interface/QuestFrame/UI-QuestTitleHighlight",
			Parent = {
				Border = {format = true, atlas = "UI-Frame-%s-CardParchmentWider", useAtlasSize = true},
				--MaskBorder = {atlas = "covenantchoice-celebration-background", useAtlasSize = true},
				Middleground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
				Background = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
				Foreground = {points = {{"TOPLEFT", 0, -205}, {"BOTTOMRIGHT", 0, 170}}},
				BottomLeft = {format = true, atlas = "%s-NineSlice-CornerBottomLeft", useAtlasSize = true},	
				BottomRight = {format = true, atlas = "%s-NineSlice-CornerBottomRight", useAtlasSize = true},	
				TopRight = {format = true, atlas = "%s-NineSlice-CornerTopRight", useAtlasSize = true},
				TopLeft = {format = true, atlas = "%s-NineSlice-CornerTopLeft", useAtlasSize = true},
				Bottom = {format = true, atlas = "_%s-NineSlice-EdgeBottom", useAtlasSize = true},
				Right = {format = true, atlas = "!%s-NineSlice-EdgeRight", useAtlasSize = true},
				Left = {format = true, atlas = "!%s-NineSlice-EdgeLeft", useAtlasSize = true},
				Top = {format = true, atlas = "_%s-NineSlice-EdgeTop", useAtlasSize = true},
			},
			Title = {
				TitleLeft = {format = true, atlas = "UI-Frame-%s-TitleLeft", useAtlasSize = true},
				TitleRight = {format = true, atlas = "UI-Frame-%s-TitleRight", useAtlasSize = true},
				TitleMiddle = {format = true, atlas = "_UI-Frame-%s-TitleMiddle", useAtlasSize = true}
			},
			Dialog = {
				Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
			},
			Scroll = {
				Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
			},
			ReputationBar = {
				Background = {format = true, atlas = "covenantsanctum-level-border-%s", useAtlasSize = false, texCoord = {1, 0, 0, 0, 1, 1, 0, 1}, points = {{"TOPLEFT", -42, 59}, {"BOTTOMRIGHT", 42, -57}}},
				--Background = {atlas = "Garr_Mission_MaterialFrame", useAtlasSize = false, points = {{"TOPLEFT", -33, 15}, {"BOTTOMRIGHT", 33, -15}}},
			},
			Detail = {
				Background = {format = true, atlas = "covenantchoice-offering-parchment-%s", useAtlasSize = true},
				Title1 = {format = true, atlas = "UI-Frame-%s-Ribbon", useAtlasSize = true},
			},
		},
		CLASSIC = {
			maxSizeText = 400,
			TitleHighlightTexture = "Interface/QuestFrame/UI-QuestTitleHighlight",
			Parent = {
				Border = {format = true, atlas = "UI-Frame-%s-CardParchmentWider", useAtlasSize = true},
				MaskBorder = {atlas = "covenantchoice-celebration-background", useAtlasSize = true},
				BottomLeft = {format = true, atlas = "%s-NineSlice-CornerBottomLeft", useAtlasSize = true},	
				BottomRight = {format = true, atlas = "%s-NineSlice-CornerBottomRight", useAtlasSize = true},	
				TopRight = {format = true, atlas = "%s-NineSlice-CornerTopRight", useAtlasSize = true},
				TopLeft = {format = true, atlas = "%s-NineSlice-CornerTopLeft", useAtlasSize = true},
				Bottom = {format = true, atlas = "_%s-NineSlice-EdgeBottom", useAtlasSize = true},
				Right = {format = true, atlas = "!%s-NineSlice-EdgeRight", useAtlasSize = true},
				Left = {format = true, atlas = "!%s-NineSlice-EdgeLeft", useAtlasSize = true},
				Top = {format = true, atlas = "_%s-NineSlice-EdgeTop", useAtlasSize = true},
			},
			Title = {
				TitleLeft = {format = true, atlas = "UI-Frame-%s-TitleLeft", useAtlasSize = true},
				TitleRight = {format = true, atlas = "UI-Frame-%s-TitleRight", useAtlasSize = true},
				TitleMiddle = {format = true, atlas = "_UI-Frame-%s-TitleMiddle", useAtlasSize = true}
			},
			Dialog = {
				Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
			},
			Scroll = {
				Background = {format = true, atlas = "UI-Frame-%s-PortraitWiderDisable", useAtlasSize = false}
			},
			ReputationBar = {
				Border = {format = true, atlas = "Garr_Mission_MaterialFrame", useAtlasSize = true--[[ , points = {{"TOPLEFT", -35, 30}, {"BOTTOMRIGHT", 7, -10}} ]]},
				--MaskBorder = {path = "Interface/ChatFrame/UI-ChatIcon-HotS"},
			},
			Detail = {
				Background = {format = true, atlas = "covenantchoice-offering-parchment-%s", useAtlasSize = true},
				Title1 = {format = true, atlas = "UI-Frame-%s-Ribbon", useAtlasSize = true},
			},			
		}
	}

	local function AcceptFullScreenTheme(parent, acceptTheme, width, height)
		local substyle
		if acceptTheme == "SHADOWLANDS" then
			--{"NightFae", "Venthyr", "Necrolord", "Kyrian"}
			substyle = "NightFae"
		end

		local theme = FULL_SCREEN_THEME[acceptTheme]
		for name, settings in pairs(theme) do
			if type(settings) == "table" then
				local frame = parent[name] and parent[name] or parent

				for key, setting in pairs(settings) do
					if setting.height then
						frame[key]:SetHeight(setting.height)
					end
					
					if setting.width then
						frame[key]:SetWidth(setting.width)
					end

					if setting.atlas then
						frame[key]:SetAtlas(setting.format and string.format(setting.atlas, substyle) or setting.atlas, setting.useAtlasSize)
					end

					if setting.path then
						frame[key]:SetTexture(setting.format and string.format(setting.path, substyle) or setting.path)
					end

					if setting.texCoord then
						frame[key]:SetTexCoord(unpack(setting.texCoord))	
					end

					if setting.points then
						for _, point in ipairs(setting.points) do
							frame[key]:SetPoint(unpack(point))	
						end
					end

					frame[key]:Show()
				end
			else
				parent[name] = settings
			end
		end
	end

	GW.CUSTOME_IMMERSIVE.AcceptFullScreenTheme = AcceptFullScreenTheme