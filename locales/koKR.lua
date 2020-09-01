-- koKR localization
local _, GW = ...

local function GWUseThisLocalization()
    -- Create a global variable for the language strings
    local L = GW.L
    
    --Fonts
    L["FONT_NORMAL"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"
    L["FONT_BOLD"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"
    L["FONT_NARROW"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"
    L["FONT_NARROW_BOLD"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"
    L["FONT_LIGHT"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"
    L["FONT_DAMAGE"] = "Interface/AddOns/GW2_UI/fonts/korean.ttf"

    --classic ones
    L["FPS_TOOLTIP_1"] = "FPS"
    L["FPS_TOOLTIP_2"] = "대기시간 (서버): "
    L["FPS_TOOLTIP_3"] = "대기시간 (세계): "
    L["FPS_TOOLTIP_4"] = "대역폭 (다운로드): "
    L["FPS_TOOLTIP_5"] = "대역폭 (업로드): "
    L["FPS_TOOLTIP_6"] = "애드온 메모리: "
    L["FUTURE_SPELLS"] = "Future Spells"
    L["INVTYPE_RANGED"] = "원거리 장비"
    
    --Strings
    L["ACTION_BAR_FADE"] = "액션바 숨기기"
    L["ACTION_BAR_FADE_DESC"] = "전투 중 액션바 숨김"
    L["ACTION_BARS_DESC"] = "개선된 GW2 UI 액션바 사용"
    L["ADV_CAST_BAR"] = "고급 시전바"
    L["ADV_CAST_BAR_DESC"] = "고급 시전바 활성 또는 비활성."
    L["AMOUNT_LOAD_ERROR"] = "금액을 불러올 수 없습니다."
    L["RAID_AURAS"] = "Raid Auras"
    L["RAID_AURAS_DESC"] = "Edit which buffs and debuffs are shown."
    L["RAID_AURAS_IGNORED"] = "Auras to ignore"
    L["RAID_AURAS_IGNORED_DESC"] = "A comma-separated list of aura names that should never be shown."
    L["RAID_AURAS_MISSING"] = "Missing auras"
    L["RAID_AURAS_MISSING_DESC"] = "A comma-separated list of aura names that should only be shown when they are missing."
    L["RAID_AURAS_TOOLTIP"] = "Show or hide auras and edit raid buff/debuff indicators."
    L["BANK_COMPACT_ICONS"] = "소형 아이콘"
    L["BANK_EXPAND_ICONS"] = "큰 아이콘"
    L["BUTTON_ASSIGNMENTS"] = "액션바 버튼 추가"
    L["BUTTON_ASSIGNMENTS_DESC"] = "액션바 슬롯 할당 활성화 또는 비활성화"
    L["CASTING_BAR_DESC"] = "GW2 시전바 활성화"
    L["CHARACTER_NEXT_RANK"] = "다음"
    L["CHARACTER_PARAGON"] = "불멸의 동맹"
    L["CHAT_BUBBLES_DESC"] = "기본 말풍선 교체 (Only in not protected areas)"
    L["CHAT_FADE"] = "채팅 숨기기"
    L["CHAT_FADE_DESC"] = "채팅을 사용하지 않을 시 자동 숨김. "
    L["CHAT_FRAME_DESC"] = "향상된 채팅 창 사용"
    L["CHRACTER_WINDOW_DESC"] = "기본 캐릭터 창을 바꿈."
    L["CLASS_COLOR_DESC"] = "체력바를 직업 색상으로 표시."
    L["CLASS_COLOR_RAID_DESC"] = "직업 아이콘 대신 직업 색상 사용."
    L["CLASS_POWER"] = "직업 파워"
    L["CLASS_POWER_DESC"] = "직업파워를 바꿈"
    L["COMPACT_ICONS"] = "소형 아이콘"
    L["COMPASS_TOGGLE"] = "토글 나침반"
    L["COMPASS_TOGGLE_DESC"] = "퀘스트 추적기의 나침반을 활성화 또는 비활성화"
    L["DEBUFF_DISPELL_DESC"] = "자신의 디버프와 해제가능한 주문만 보여줌니다."
    L["DYNAMIC_HUD"] = "동적 HUD"
    L["DYNAMIC_HUD_DESC"] = "동적으로 변하는 HUD 배경을 활성화 또는 비활성화합니다."
    L["EXP_BAR_TOOLTIP_EXP_RESTED"] = "휴식 "
    L["EXP_BAR_TOOLTIP_EXP_RESTING"] = " (휴식)"
    L["EXPAND_ICONS"] = "큰 아이콘"
    L["FOCUS_DESC"] = "주시 프레임 설정을 수정."
    L["FOCUS_FRAME_DESC"] = "주시대상 프레임을 교체합니다."
    L["FOCUS_TARGET_DESC"] = "주시 대상 프레임을 표시함."
    L["FOCUS_TOOLTIP"] = "주시 프레임 설정을 편집합니다."
    L["FONTS"] = "글꼴"
    L["FONTS_DESC"] = "기본 글꼴을 GW2 UI 글꼴로 변경합니다."
    L["GROUND_MARKER"] = "WM"
    L["GROUP_DESC"] = "파티 및 공격대 옵션을 필요 따라 알맞게 편집하십시오."
    L["GROUP_FRAMES"] = "그룹 프레임"
    L["GROUP_FRAMES_DESC"] = "그룹 프레임"
    L["GROUP_TOOLTIP"] = "그룹 설정 편집."
    L["HEALTH_GLOBE"] = "구모양의 체력바"
    L["HEALTH_GLOBE_DESC"] = "체력바 설정을 변경합니다."
    L["HEALTH_PERCENTAGE_DESC"] = "체력을 백분율로 표시합니다. 체력값 대신 사용할수 있습니다."
    L["HEALTH_VALUE_DESC"] = "체력을 수치로 보여줌니다."
    L["HIDE_EMPTY_SLOTS"] = "빈 슬롯 숨기기"
    L["HIDE_EMPTY_SLOTS_DESC"] = "액션바의 빈 슬롯을 숨깁니다."
    L["HUD_DESC"] = "Heads-Up Display 모듈을 사용자 정의에 맛게 편집하십시오."
    L["HUD_MOVE_ERR"] = "전투 중에는 이동할 수 없습니다!"
    L["HUD_SCALE"] = "HUD 규모"
    L["HUD_SCALE_DESC"] = "HUD 크기를 변경."
    L["HUD_SCALE_TINY"] = "매우 작음"
    L["HUD_TOOLTIP"] = "HUD 모듈을 편집."
    L["INDICATORS"] = "Raid indicators"
    L["INDICATORS_DESC"] = "Edit raid buff/debuff indicators."
    L["INDICATORS_ICON"] = "Show spell icons"
    L["INDICATORS_ICON_DESC"] = "Show spell icons instead of monochrome squares."
    L["INDICATORS_TIME"] = "Show remaining time"
    L["INDICATORS_TIME_DESC"] = "Show the remaining aura time as animated overlay."
    L["INDICATOR_TITLE"] = "%s indicator"
    L["INDICATOR_DESC"] = "Edit %s raid aura indicator."
    L["INDICATOR_BAR"] = "progress bar"
    L["INVENTORY_FRAME_DESC"] = "가방 인터페이스을 하나로 활성화."
    L["LEVEL_REWARDS"] = "다가오는 레벨 보상"
    L["MAP_CLOCK_LOCAL_REALM"] = "왼쪽 클릭으로 로컬과 렐름 시간을 전환"
    L["MAP_CLOCK_MILITARY"] = "쉬프트 클릭으로 군사 시간 형식 전환"
    L["MAP_CLOCK_STOPWATCH"] = "오른쪽 클릭으로 스톱 워치 열기"
    L["MAP_CLOCK_TIMEMANAGER"] = "Shift-Right Click to open the Time Manager"
    L["MAP_COORDINATES_TITLE"] = "지도 좌표"
    L["MAP_COORDINATES_TOGGLE_TEXT"] = "높은 정밀도 좌표를 전환하려면 왼쪽을 클릭하십시오."
    L["MINIMAP_DESC"] = "GW2 UI 스타일의 미니맵 사용."
    L["MINIMAP_HOVER"] = "미니맵 세부"
    L["MINIMAP_HOVER_TOOLTIP"] = "미니 맵 세부 정보를 영구히 표시하십시오,"
    L["MINIMAP_SCALE"] = "미니맵 규모"
    L["MINIMAP_SCALE_DESC"] = "미니앱 크기을 변경."
    L["MODULES_CAT"] = "모듈"
    L["MODULES_CAT_1"] = "모듈"
    L["MODULES_CAT_TOOLTIP"] = "구성 요소 활성화 및 비활성화"
    L["MODULES_DESC"] = "필요에 따라 필요하지 않은 모듈을 생성하거나 해제 할 수 있습니다."
    L["MODULES_TOOLTIP"] = "UI 모듈을 활성화 또는 비활성화합니다."
    L["MOUSE_TOOLTIP"] = "Tooltip mouse anchor"
    L["MOUSE_TOOLTIP_DESC"] = "Show Tooltips at cursor"
    L["MOVE_HUD_BUTTON"] = "HUD 이동"
    L["NAME_LOAD_ERROR"] = "이름을 로드 할 수 없습니다."
    L["NOT_A_LEGENDARY"] = "해당 아이템을 업그레이드 할 수 없습니다."
    L["PET_BAR_DESC"] = "GW2 UI 스타일의 펫바를 사용합니다."
    L["PLAYER_AURAS_DESC"] = "프레이어 오라를 이동과 크기조정을 합니다."
    L["POWER_BARS_RAID_DESC"] = "공격대에 파워 바를 표시하십시오."
    L["PROFILES_CAT"] = "프로파일"
    L["PROFILES_CAT_1"] = "프로파일"
    L["PROFILES_CREATED"] = "제작: "
    L["PROFILES_CREATED_BY"] = "\n제작자: "
    L["PROFILES_DEFAULT_SETTINGS"] = "기본 설정"
    L["PROFILES_DEFAULT_SETTINGS_DESC"] = "현재 애드온 설정을 현재 프로파일로 불러옴니다."
    L["PROFILES_DEFAULT_SETTINGS_PROMPT"] = "기본 설정을로드 하시겠습니까?\n\n이전 설정이 모두 제거됨니다."
    L["PROFILES_DELETE"] = "이 프로필을 삭제 하시겠습니까?"
    L["PROFILES_DESC"] = "프로필은 캐릭터와 영역에서 설정을 공유하는 쉬운 방법입니다."
    L["PROFILES_LAST_UPDATE"] = "\n마지막 업데이트:"
    L["PROFILES_LOAD_BUTTON"] = "불러오기"
    L["PROFILES_MISSING_LOAD"] = "만약 당신이 이 메세지를 본다면 우리는 몇개의 텍스트를 불러오는것을 잃어버렸습니다.메우 유능할 샘플 텍스트를 가지고 있으니 걱정 안하셔도 됨니다."
    L["PROFILES_TOOLTIP"] = "프로파일을 추가 또는 삭제"
    L["QUEST_REQUIRED_ITEMS"] = "필요한 아이템:"
    L["QUEST_TRACKER_DESC"] = "개편된 퀘스트 추적기 활성화."
    L["QUEST_VIEW_SKIP"] = "넘김"
    L["QUESTING_FRAME"] = "몰입형 퀘스트"
    L["QUESTING_FRAME_DESC"] = "몰입형 퀘스트 활성화."
    L["RAID_ANCHOR"] = "Set Raid anchor"
    L["RAID_ANCHOR_DESC"] = "Set where the raid frame container should be anchored.\n\nBy position: Always the same as the container's position on screen.\nBy growth: Always opposite to the growth direction."
    L["RAID_ANCHOR_BY_POSITION"] = "By position on screen"
    L["RAID_ANCHOR_BY_GROWTH"] = "By growth direction"
    L["RAID_BAR_HEIGHT"] = "공격대 단위 높이 설정"
    L["RAID_BAR_HEIGHT_DESC"] = "공격대 단위의 높이를 설정하십시오."
    L["RAID_BAR_WIDTH"] = "공격대 단위 폭 설정"
    L["RAID_BAR_WIDTH_DESC"] = "공격대 단위의 폭을 설정하십시오."
    L["RAID_CONT_HEIGHT"] = "공격대 프레임 컨테이너 높이 설정"
    L["RAID_CONT_HEIGHT_DESC"] = "공격대 프레임을 표시 할 수있는 최대 높이를 설정하십시오.\n\nThis will cause unit frames to shrink or move to the next column."
    L["RAID_CONT_WIDTH"] = "Set Raid Frame Container Width"
    L["RAID_CONT_WIDTH_DESC"] = "Set the maximum width that the raid frames can be displayed.\n\nThis will cause unit frames to shrink or move to the next row."
    L["RAID_GROW"] = "Set Raid grow directions"
    L["RAID_GROW_DESC"] = "Set the grow directions for raid frames."
    L["RAID_GROW_DIR"] = "%s and then %s"
    L["RAID_MARKER_DESC"] = "공격대 단위 프레임에 대상 징표를 표시합니다."
    L["RAID_PARTY_STYLE_DESC"] = "파티 프레임을 공격대 프레임과 같은 스타일로 정할 수 있습니다."
    L["RAID_PREVIEW"] = "Preview raid frames"
    L["RAID_PREVIEW_DESC"] = "Click to toggle raid frame preview and cycle through different group sizes."
    L["RAID_SORT_BY_ROLE"] = "Sort raidframes by role"
    L["RAID_SORT_BY_ROLE_DESC"] = "Sort raid unit frames by role (tank, heal, damage) instead of group."
    L["RAID_AURA_TOOLTIP_IN_COMBAT"] = "Show aura tooltips in combat"
    L["RAID_AURA_TOOLTIP_IN_COMBAT_DESC"] = "Show tooltips of buffs and debuffs even when you are in combat."
    L["RAID_UNIT_FLAGS"] = "국기를 표시"
    L["RAID_UNIT_FLAGS_2"] = "자신과 다른"
    L["RAID_UNIT_FLAGS_TOOLTIP"] = "각 언어에 따라 국가 국기 표시"
    L["RAID_UNITS_PER_COLUMN"] = "Set Raid units per column"
    L["RAID_UNITS_PER_COLUMN_DESC"] = "Set the number of raid unit frames per column or row, depending on grow directions."
    L["RESOURCE_DESC"] = "기본 마나 / 파워 바를 교체하십시오."
    L["SETTING_LOCK_HUD"] = "HUD 잠금"
    L["SETTINGS_BUTTON"] = "GW2 UI 설정"
    L["SETTINGS_NO_LOAD_ERROR"] = "일부 텍스트가 불러올 수 없습니다. 인터페이스 새로 고침을 시도하십시오."
    L["SETTINGS_RESET_TO_DEFAULT"] = "기본값으로 재설정."
    L["SETTINGS_SAVE_RELOAD"] = "저장후 재시작"
    L["SHOW_ALL_DEBUFFS_DESC"] = "모든 대상의 디버프를 표시합니다."
    L["SHOW_BUFFS_DESC"] = "대상의 버프를 표시합니다."
    L["SHOW_DEBUFFS_DESC"] = "대상의 디버프를 표시합니다."
    L["SHOW_ILVL"] = "Display average item level"
    L["SHOW_ILVL_DESC"] = "Display the average item level instead of prestige level for friendly units."
    L["TARGET_DESC"] = "대상 프레임 설정 수정."
    L["TARGET_FRAME_DESC"] = "새로운 대상 프레임 활성화합니다."
    L["TARGET_OF_TARGET_DESC"] = "대상의 대상 프레임을 활성화합니다."
    L["TARGET_TOOLTIP"] = "대상 프레임 설정을 편집하십시오."
    L["TOOLTIPS"] = "툴팁"
    L["TOOLTIPS_DESC"] = "기본 UI 툴팁을 바꿉니다."
    L["TRACKER_RETRIVE_CORPSE"] = "당신의 시체를 찾으십시오"
    L["UNEQUIP_LEGENDARY"] = "해당 아이템을 업그레이드하려면 먼저 해제해야합니다."
    L["UPDATE_STRING_1"] = "새로운 업데이트가 있습니다. 다운로드 해주세요."
    L["UPDATE_STRING_2"] = "새로운 기능이 포함 된 새로운 업데이트입니다."
    L["UPDATE_STRING_3"] = "|cFFFF0000 중요한 |r 업데이트를 사용할 수 있습니다.\n\n업데이트하는 것이 좋습니다."
    L["BAG_SORT_ORDER_FIRST"] = "Sort to First Bag"
    L["BAG_SORT_ORDER_LAST"] = "Sort to Last Bag"
    L["BAG_NEW_ORDER_FIRST"] = "New Items to First Bag"
    L["BAG_NEW_ORDER_LAST"] = "New Items to Last Bag"
    L["BAG_ORDER_NORMAL"] = "Normal Bag Order"
    L["BAG_ORDER_REVERSE"] = "Reverse Bag Order"
    L["STG_RIGHT_BAR_COLS"] = "Right Bar Width"
    L["STG_RIGHT_BAR_COLS_DESC"] = "Number of columns in the two extra right-hand action bars."
    L["DISABLED_MA_BAGS"] = "Disabled MoveAnything's bag handling."
    L["FADE_MICROMENU"] = "Fade Menu Bar"
    L["FADE_MICROMENU_DESC"] = "Fade the main micromenu when the mouse is not near."
    L["TALENTS_BUTTON_DESC"] = "Enable the talents, specialization, and spellbook replacement."
    L["ALL_BINDINGS_SAVE"] = "All key bindings have been saved."
    L["ALL_BINDINGS_DISCARD"] = "All newly set key bindings have been discarded."
    L["BINDINGS_DESC"] = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbutton's keybinding."
    L["BINDINGS_TRIGGER"] = "Trigger"
    L["BINGSINGS_KEY"] = "Key"
    L["BINGSINGS_CLEAR"] = "All key bindings cleared for"
    L["BINGSINGS_BIND"] = "bound to"
    L["MINIMAP_POS"] = "Minimap position"
    L["MINIMAP_COORDS"] = "좌표"
    L["WORLD_MARKER_DESC"] = "Show menu for placing world markers when in raids."
    L["UP"] = "위"
    L["DOWN"] = "아래"
    L["LEFT"] = "왼쪽"
    L["RIGHT"] = "오른쪽"
    L["TOP"] = "상단"
    L["BOTTOM"] = "하단"
    L["CENTER"] = "중앙"
    L["TOPLEFT"] = ("%s %s"):format(L["TOP"], L["LEFT"])
    L["TOPRIGHT"] = ("%s %s"):format(L["TOP"], L["RIGHT"])
    L["BOTTOMLEFT"] = ("%s %s"):format(L["BOTTOM"], L["LEFT"])
    L["BOTTOMRIGHT"] = ("%s %s"):format(L["BOTTOM"], L["RIGHT"])
    L["RAID_UNIT_LOST_HEALTH_PREC"] = "Health Remaining in percent"
    L["SHOW_THREAT_VALUE"] = "위협 표시"
    L["MINIMAP_FPS"] = "미니맵에 FPS 표시"
    L["TARGET_COMBOPOINTS"] = "Show Combopunkt on target"
    L["TARGET_COMBOPOINTS_DEC"] = "SHow Combopunkt on target, below the healthbar"
    L["PIXEL_PERFECTION"] = "Pixel Perfection-Mode"
    L["PIXEL_PERFECTION_DESC"] = "Scales the UI into a Pixel Perfection mode. This depends on the screen resolution."
    L["WELCOME_SPLASH_HEADER"] = "Welcome to GW2 UI"
    L["CHANGELOG"] = "Changelog"
    L["WELCOME"] = "Welcome"
    L["PIXEL_PERFECTION_ON"] = "Turn Pixel Perfection-Modus on"
    L["PIXEL_PERFECTION_OFF"] = "Turn Pixel Perfection-Modus off"
    L["WELCOME_SPLASH_WELCOME_TEXT"] = "GW2 UI is a full user interface replacement. We have built the user interface with a modular approach, this means that if you dislike a certain part of the addon - or have another you prefer for that function - you can just disable that part, whilst keeping the rest of the interface intact.\nSome of the modules available to you are an immersive questing window, a full inventory replacement, as well as a full character window replacement. There are many more that you can enjoy, just take a look in the settings menu to see what's available to you!"
    L["WELCOME_SPLASH_WELCOME_TEXT_PP"] = "What is 'Pixel Perfection'?\n\nGW2 UI has a built-in setting called 'Pixel Perfection Mode'. What this means for you is that your user interface will look as was intended, with crisper textures and better scaling. Of course, you can toggle this off in the settings menu should you prefer."
    L["DISCORD"] = "Join Discord"
    L["STANCEBAR_POSITION"] = "Position of the Stancebar"
    L["STANCEBAR_POSITION_DESC"] = "Set the position of the Stancebar (Left or Right from the main Actionbar)"
    L["CURSOR_ANCHOR_TYPE"] = "Cursor Anchor Type"
    L["CURSOR_ANCHOR_TYPE_DESC"] = "Take only effect if the option 'Cursor Tooltips' is activated"
    L["CURSOR_ANCHOR"] = "Cursor Anchor"
    L["ANCHOR_CURSOR_LEFT"] = "Cursor Anchor left"
    L["ANCHOR_CURSOR_RIGHT"] = "Cursor Anchor right"
    L["ANCHOR_CURSOR_OFFSET_X"] = "Cursor Anchor Offset X"
    L["ANCHOR_CURSOR_OFFSET_Y"] = "Cursor Anchor Offset Y"
    L["ANCHOR_CURSOR_OFFSET_DESC"] = "Take only effect if the option 'Cursor Tooltips' is activated and the Cursoer Anchor is NOT 'Cursor Anchor'"
    L["MOUSE_OVER"] = "Only Mouse over"
    L["PLAYER_BUFFS_GROW"] = "Player Buff Growth Direction"
    L["PLAYER_DEBUFFS_GROW"] = "Player Debuffs Growth Direction"
    L["RED_OVERLAY"] = "Red overlay"
    L["MAINBAR_RANGE_INDICATOR"] = "Mainbar range indicator"
    L["PLAYER_ABSORB_VALUE_TEXT"] = "Show Shield value"
    L["PLAYER_DESC"] = "Modify the player frame settings."
    L["GRID_BUTTON_SHOW"] = "Show grid"
    L["GRID_BUTTON_HIDE"] = "Hide grid"
    L["GRID_SIZE_LABLE"] = "Grid Size:"
    L["HIDE_SETTING_IN_COMBAT"] = "Settings are not available in combat!"
    L["TARGETED_BY"] = "Targeted by:"
    L["ADVANCED_TOOLTIP"] = "Advanced Tooltips"
    L["ADVANCED_TOOLTIP_DESC"] = "Displays additional information in the tooltip (further information is displayed when the SHIFT key is pressed)"
    L["ADVANCED_TOOLTIP_OPTION_ITEMCOUNT"] = "Item Count"
    L["ADVANCED_TOOLTIP_OPTION_ITEMCOUNT_DESC"] = "Display how many of a certain item you have in your possession."
    L["ADVANCED_TOOLTIP_SPELL_ITEM_ID"] = "Spell/Item IDs"
    L["ADVANCED_TOOLTIP_SPELL_ITEM_ID_DESC"] = "Display the spell or item ID when mousing over a spell or item tooltip."
    L["ADVANCED_TOOLTIP_NPC_ID"] = "NPC IDs"
    L["ADVANCED_TOOLTIP_NPC_ID_DESC"] = "Display the npc ID when mousing over a npc tooltip."
    L["ADVANCED_TOOLTIP_SHOW_MOUNT"] = "Current Mount"
    L["ADVANCED_TOOLTIP_SHOW_MOUNT_DESC"] = "Display current mount the unit is riding."
    L["ADVANCED_TOOLTIP_SHOW_TARGET_INFO"] = "Target Info"
    L["ADVANCED_TOOLTIP_SHOW_TARGET_INFO_DESC"] = "When in a raid group display if anyone in your raid is targeting the current tooltip unit."
    L["ADVANCED_TOOLTIP_SHOW_REALM_ALWAYS"] = "Always Show Realm"
    L["ADVANCED_TOOLTIP_SHOW_PLAYER_TITLES_DESC"] ="Display player titles."
    L["ADVANCED_TOOLTIP_SHOW_GUILD_RANKS"] = "Guild Ranks"
    L["ADVANCED_TOOLTIP_SHOW_GUILD_RANKS_DESC"] = "Display guild ranks if a unit is guilded."
    L["ADVANCED_TOOLTIP_SHOW_ROLE_DESC"] = "Display the unit role in the tooltip."
    L["SHOW_JUNK_ICON"] = "Show Junk Icon"
    L["SHOW_QUALITY_COLOR"] = "Show Quality Color"
    L["SHOW_SCRAP_ICON"] = "Show Scrap Icon"
    L["PROFESSION_BAG_COLOR"] = "Colouring professional bags"
    L["SHOW_UPGRADE_ICON"] = "Show Upgrade Icon"
    L["AURAS_PER_ROW"] = "Auras per Row"
    L["AURA_STYLE"] = "Aura Style"
    L["UP_AND_RIGHT"] = "Up and Right"
    L["DOWN_AND_RIGHT"] = "Down and Right"
    L["SECURE"] = "Secure"
    L["VENDOR_GRAYS"] = "Sell Junk automatically"
    L["SELLING_JUNK"] = "Selling Junk"
    L["SELLING_JUNK_FOR"] = "Sold Junk for: %s"
    L["NO_GUILD"] = "길드 없음"
    L["AFK_MODE"] = "자리비움 모드"
    L["AFK_MODE_DESC"] = "자리비움 시 UI가 자리비움모드로 전환됩니다."
    L["REPAIRD_FOR"] = "자동으로 수리하고 비용을 지불했습니다: %s"
    L["AUTO_REPAIR"] = "자동 수리"
    L["AUTO_REPAIR_DESC"] = "수리가 가능한 상점을 열면 이 옵션에서 선택한 자금으로 장비를 자동 수리합니다."
    L["FADE_GROUP_MANAGE_FRAME"] = "Fade Group Manage Button"
    L["FADE_GROUP_MANAGE_FRAME_DESC"] = "Fade the Group Manage Button when the mouse is not near."
    L["HUD_BACKGROUND"] = "Show HUD background"
    L["HUD_BACKGROUND_DESC"] = "The HUD background changes color in the following situations: In Combat, Not In Combat, In Water, Low HP, Ghost"
    L["RAID_SHOW_IMPORTEND_RAID_DEBUFFS"] = "Dungeon & Raid Debuffs"
    L["RAID_SHOW_IMPORTEND_RAID_DEBUFFS_DESC"] = "Show importend Dungeon & Raid debuffs"
    L["PLAYER_GROUP_FRAME"] = "Playerframe in group"
    L["PLAYER_GROUP_FRAME_DESC"] = "Show Player as Groupframe"
    L["5SR_TIMER"] = "5 secound rule: display remaning time"
    L["ENERGY_MANA_TICK"] = "Energy/Mana Ticker"
    L["ENERGY_MANA_TICK_HIDE_OFC"] = "Show Energy/Mana Ticker only in combat"
    L["PLAYER_BUFF_SIZE"] = "Buff size"
    L["PLAYER_DEBUFF_SIZE"] = "Debuff size"
    L["DISPLAY_PORTRAIT_DAMAGED"] = "초상화 피해 표시"
    L["DISPLAY_PORTRAIT_DAMAGED_DESC"] = "이 창의 초상화에 피해를 표시합니다."
    L["IMPORT"] = "Import"
    L["DECODE"] = "Decode"
    L["IMPORT_SUCCESSFUL"] = "Import string succsessfully imported!"
    L["IMPORT_FAILED"] = "Error importing profile: Invalid or corrupted string!"
    L["IMPORT_DECODE_FALIED"] = "Error decoding profile: Invalid or corrupted string!"
    L["IMPORT_DECODE:SUCCESSFUL"] = "Import string succsessfully decoded!"
    L["EXPORT_PROFILE"] = "Export Profile"
    L["EXPORT_PROFILE_DESC"] = "Profile string to share your settings:"
    L["IMPORT_PROFILE"] = "Import Profile"
    L["IMPORT_PROFILE_DESC"] = "Past your profile string here, to import the profile."
end

if GetLocale() == "koKR" then
    GWUseThisLocalization()
end

-- After using this localization or deciding that we don"t need it, remove it from memory.
GWUseThisLocalization = nil
