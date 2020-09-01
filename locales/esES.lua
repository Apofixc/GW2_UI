-- esES localization
local _, GW = ...

local function GWUseThisLocalization()
    -- Create a global variable for the language strings
    local L = GW.L
    
    --Fonts
    L["FONT_NORMAL"] = "Interface/AddOns/GW2_UI/fonts/menomonia.ttf"
    L["FONT_BOLD"] = "Interface/AddOns/GW2_UI/fonts/headlines.ttf"
    L["FONT_NARROW"] = "Interface/AddOns/GW2_UI/fonts/menomonia.ttf"
    L["FONT_NARROW_BOLD"] = "Interface/AddOns/GW2_UI/fonts/menomonia.ttf"
    L["FONT_LIGHT"] = "Interface/AddOns/GW2_UI/fonts/menomonia-italic.ttf"
    L["FONT_DAMAGE"] = "Interface/AddOns/GW2_UI/fonts/headlines.ttf"

    --classic ones
    L["FPS_TOOLTIP_1"] = "FPS "
    L["FPS_TOOLTIP_2"] = "Latencia (Hogar) "
    L["FPS_TOOLTIP_3"] = "Latencia (Mundo) "
    L["FPS_TOOLTIP_4"] = "Ancho de banda (Descargar): "
    L["FPS_TOOLTIP_5"] = "Ancho de banda (Cargar): "
    L["FPS_TOOLTIP_6"] = "Memoria para Addons: "
    L["FUTURE_SPELLS"] = "Future Spells"
    L["INVTYPE_RANGED"] = "A distancia"
    
    --Strings
    L["ACTION_BAR_FADE"] = "Ocultar las barras de acción"
    L["ACTION_BAR_FADE_DESC"] = "Ocultar las barras de acción adicionales cuando estés fuera de combate."
    L["ACTION_BARS_DESC"] = "Utilizar las barras de acción mejoradas de GW2 UI."
    L["ADV_CAST_BAR"] = "Barra de casteo avanzado"
    L["ADV_CAST_BAR_DESC"] = "Activar o desactivar la barra de casteo avanzado."
    L["ALL_BINDINGS_DISCARD"] = "Todas las asignaciones nuevas de teclas se han borrado."
    L["ALL_BINDINGS_SAVE"] = "Todas las asignaciones de teclas se han guardado."
    L["AMOUNT_LOAD_ERROR"] = "La cantidad no se pudo cargar"
    L["RAID_AURAS"] = "Raid Auras"
    L["RAID_AURAS_DESC"] = "Edit which buffs and debuffs are shown."
    L["RAID_AURAS_IGNORED"] = "Auras to ignore"
    L["RAID_AURAS_IGNORED_DESC"] = "A comma-separated list of aura names that should never be shown."
    L["RAID_AURAS_MISSING"] = "Missing auras"
    L["RAID_AURAS_MISSING_DESC"] = "A comma-separated list of aura names that should only be shown when they are missing."
    L["RAID_AURAS_TOOLTIP"] = "Show or hide auras and edit raid buff/debuff indicators."
    L["BAG_NEW_ORDER_FIRST"] = "Poner artículos nuevos en la primera bolsa"
    L["BAG_NEW_ORDER_LAST"] = "Poner artículos nuevos en la última bolsa"
    L["BAG_ORDER_NORMAL"] = "Orden de bolsa normal"
    L["BAG_ORDER_REVERSE"] = "Orden de bolsa inversa"
    L["BAG_SORT_ORDER_FIRST"] = "Ordenar a la primera bolsa"
    L["BAG_SORT_ORDER_LAST"] = "Ordenar a la última bolsa"
    L["BANK_COMPACT_ICONS"] = "Iconos compactos"
    L["BANK_EXPAND_ICONS"] = "Iconos grandes"
    L["BINDINGS_DESC"] = "Mueva el cursor sobre cualquier botón de acción para asignarlo. Presione la tecla de escape o  clic derecho para eliminar las asignaciones del botón de acción actual."
    L["BINDINGS_TRIGGER"] = "Activa"
    L["BINGSINGS_BIND"] = "asignado a"
    L["BINGSINGS_CLEAR"] = "Todas las asignaciones de teclas son borrado para"
    L["BINGSINGS_KEY"] = "Tecla"
    L["BUTTON_ASSIGNMENTS"] = "Asignar huecos de barra de acción"
    L["BUTTON_ASSIGNMENTS_DESC"] = "Activar o desactivar las asignaciones de huecos de barra de acción"
    L["CASTING_BAR_DESC"] = "Activar la barra de casteo de GW2 UI"
    L["CHARACTER_NEXT_RANK"] = "SIGUIENTE"
    L["CHARACTER_PARAGON"] = "Paragón"
    L["CHAT_BUBBLES_DESC"] = "Reemplazar los bocadillos de chat de IU predeterminados. (Only in not protected areas)"
    L["CHAT_FADE"] = "Ocultar el chat"
    L["CHAT_FADE_DESC"] = "Permitir al chat ocultarse cuando no esté en uso."
    L["CHAT_FRAME_DESC"] = "Activar la ventana de chat mejorada."
    L["CHRACTER_WINDOW_DESC"] = "Reemplazar la ventana de personaje predeterminada."
    L["CLASS_COLOR_DESC"] = "Mostrar el color de clase como la barra de salud."
    L["CLASS_COLOR_RAID_DESC"] = "Utilizar el color de clase en vez de iconos de clase."
    L["CLASS_POWER"] = "Poder de clase"
    L["CLASS_POWER_DESC"] = "Activar los poderes de clase alternos."
    L["COMPACT_ICONS"] = "Iconos compactos"
    L["COMPASS_TOGGLE"] = "Mostrar/Ocultar brújula"
    L["COMPASS_TOGGLE_DESC"] = "Activar o desactivar la brújula de rastreador de misiones."
    L["DEBUFF_DISPELL_DESC"] = "Sólo muestra los debuffs que puedes disipar. "
    L["DISABLED_MA_BAGS"] = "Desactivar el manejo de MoveAnything para la bolsa."
    L["DYNAMIC_HUD"] = "HUD dinámico"
    L["DYNAMIC_HUD_DESC"] = "Activar o desactivar el fondo HUD dinámico."
    L["EXP_BAR_TOOLTIP_EXP_RESTED"] = "Descansado "
    L["EXP_BAR_TOOLTIP_EXP_RESTING"] = " (En reposo)"
    L["EXPAND_ICONS"] = "Iconos grandes"
    L["FADE_MICROMENU"] = "Ocultar la barra de menú"
    L["FADE_MICROMENU_DESC"] = "Ocultar el micromenú principal cuando el cursor no está cerca."
    L["FOCUS_DESC"] = "Modificar los ajustes de marco de foco."
    L["FOCUS_FRAME_DESC"] = "Activar el reemplazo del marco de objetivo de foco."
    L["FOCUS_TARGET_DESC"] = "Mostrar el marco de objetivo de foco."
    L["FOCUS_TOOLTIP"] = "Editar los ajustes de marco de foco."
    L["FONTS"] = "Fuentes"
    L["FONTS_DESC"] = "Reemplazar las fuentes predeterminadas con las fuentes de GW2 UI."
    L["GROUND_MARKER"] = "WM"
    L["GROUP_DESC"] = "Editar los ajustes de grupos y bandas para satisfacer tus necesidades."
    L["GROUP_FRAMES"] = "Marcos de grupo"
    L["GROUP_FRAMES_DESC"] = "Reemplazar los marcos de grupo IU predeterminados."
    L["GROUP_TOOLTIP"] = "Editar los ajustes de grupo."
    L["HEALTH_GLOBE"] = "Globo de Salud"
    L["HEALTH_GLOBE_DESC"] = "Activar el reemplazo de barra de salud."
    L["HEALTH_PERCENTAGE_DESC"] = "Mostrar salud como un porcentaje. Puede usarse, o así mismo el valor de salud."
    L["HEALTH_VALUE_DESC"] = "Mostrar salud como un valor numérico."
    L["HIDE_EMPTY_SLOTS"] = "Esconder huecos vacíos"
    L["HIDE_EMPTY_SLOTS_DESC"] = "Esconder los huecos de barra de acción vacíos."
    L["HUD_DESC"] = "Editar los módulos en el HUD para más personalización."
    L["HUD_MOVE_ERR"] = "¡No puedes mover los elementos durante el combate!"
    L["HUD_SCALE"] = "Escala de HUD"
    L["HUD_SCALE_DESC"] = "Cambiar el tamaño de HUD."
    L["HUD_SCALE_TINY"] = "Minúsculo"
    L["HUD_TOOLTIP"] = "Editar los módulos de HUD."
    L["INDICATORS"] = "Raid indicators"
    L["INDICATORS_DESC"] = "Edit raid buff/debuff indicators."
    L["INDICATORS_ICON"] = "Show spell icons"
    L["INDICATORS_ICON_DESC"] = "Show spell icons instead of monochrome squares."
    L["INDICATORS_TIME"] = "Show remaining time"
    L["INDICATORS_TIME_DESC"] = "Show the remaining aura time as animated overlay."
    L["INDICATOR_TITLE"] = "%s indicator"
    L["INDICATOR_DESC"] = "Edit %s raid aura indicator."
    L["INDICATOR_BAR"] = "progress bar"
    L["INVENTORY_FRAME_DESC"] = "Activar el interfaz de inventario unificado."
    L["LEVEL_REWARDS"] = "Próximas recompensas de nivel"
    L["MAP_CLOCK_LOCAL_REALM"] = "Clic izquierda para cambiar entre tiempo de local o reino."
    L["MAP_CLOCK_MILITARY"] = "Mayús-Clic para pasar el formato de tiempo militar"
    L["MAP_CLOCK_STOPWATCH"] = "Clic derecho para abrir el cronómetro"
    L["MAP_CLOCK_TIMEMANAGER"] = "Shift-Right Click to open the Time Manager"
    L["MAP_COORDINATES_TITLE"] = "Coordenadas del mapa"
    L["MAP_COORDINATES_TOGGLE_TEXT"] = "Clic izquierdo para alternar coordenadas de mayor precisión."
    L["MINIMAP_DESC"] = "Utilizar el marco de minimapa de GW2 UI."
    L["MINIMAP_HOVER"] = "Detalles de minimapa"
    L["MINIMAP_HOVER_TOOLTIP"] = "Mostrar permanentemente los detalles de minimapa."
    L["MINIMAP_POS"] = "Posición de minimapa"
    L["MINIMAP_SCALE"] = "Escala de minimapa"
    L["MINIMAP_SCALE_DESC"] = "Cambiar el tamaño de minimapa."
    L["MODULES_CAT"] = "MÓDULOS"
    L["MODULES_CAT_1"] = "Módulos"
    L["MODULES_CAT_TOOLTIP"] = "Activar o desactivar los componentes"
    L["MODULES_DESC"] = "Activar o desactivar los módulos que tú necesitas o no."
    L["MODULES_TOOLTIP"] = "Activar o desactivar los módulos de IU"
    L["MOUSE_TOOLTIP"] = "Sugerencias de cursor"
    L["MOUSE_TOOLTIP_DESC"] = "Adjunta las sugerencias al cursor."
    L["MOVE_HUD_BUTTON"] = "Mover HUD"
    L["NAME_LOAD_ERROR"] = "No se puede cargar el nombre"
    L["NOT_A_LEGENDARY"] = "No puedes mejorar este objeto."
    L["PET_BAR_DESC"] = "Utilizar la barra de mascota mejorada de GW2 UI."
    L["PLAYER_AURAS_DESC"] = "Mover y cambiar el tamaño de las auras de jugadores/as."
    L["POWER_BARS_RAID_DESC"] = "Mostrar los barras de poder en las unidades de banda."
    L["PROFILES_CAT"] = "PERFILES"
    L["PROFILES_CAT_1"] = "Perfiles"
    L["PROFILES_CREATED"] = "Creando: "
    L["PROFILES_CREATED_BY"] = "\nCreado por: "
    L["PROFILES_DEFAULT_SETTINGS"] = "Ajustes predeterminados"
    L["PROFILES_DEFAULT_SETTINGS_DESC"] = "Cargar los ajustes de addon predeterminados en la perfil actual."
    L["PROFILES_DEFAULT_SETTINGS_PROMPT"] = "¿Estás seguro que quieres cargar los ajustes predeterminados?\n\nTodos los ajustes previos serán borrados."
    L["PROFILES_DELETE"] = "¿Estás seguro que quieres eliminar este perfil?"
    L["PROFILES_DESC"] = "Los perfiles son una manera fácil de compartir tus ajustes entre los personajes y reinos."
    L["PROFILES_LAST_UPDATE"] = "\nÚltima actualización: "
    L["PROFILES_LOAD_BUTTON"] = "Cargar"
    L["PROFILES_MISSING_LOAD"] = "El texto no puede cargarse."
    L["PROFILES_TOOLTIP"] = "Crear o eliminar perfiles."
    L["QUEST_REQUIRED_ITEMS"] = "Objetos requeridos:"
    L["QUEST_TRACKER_DESC"] = "Activar el rastreador mejorado de misiones."
    L["QUEST_VIEW_SKIP"] = "Omitir"
    L["QUESTING_FRAME"] = "Misiones inmersivos"
    L["QUESTING_FRAME_DESC"] = "Activar el ventana de misiones inmersivos."
    L["RAID_ANCHOR"] = "Set Raid anchor"
    L["RAID_ANCHOR_DESC"] = "Set where the raid frame container should be anchored.\n\nBy position: Always the same as the container's position on screen.\nBy growth: Always opposite to the growth direction."
    L["RAID_ANCHOR_BY_POSITION"] = "By position on screen"
    L["RAID_ANCHOR_BY_GROWTH"] = "By growth direction"
    L["RAID_BAR_HEIGHT"] = "Establecer la altura de unidad de banda"
    L["RAID_BAR_HEIGHT_DESC"] = "Establecer la altura de unidades de banda"
    L["RAID_BAR_WIDTH"] = "Establecer el ancho de unidad de banda"
    L["RAID_BAR_WIDTH_DESC"] = "Establecer el ancho de unidades de banda"
    L["RAID_CONT_HEIGHT"] = "Establecer la altura de envase de marco de banda"
    L["RAID_CONT_HEIGHT_DESC"] = "Establecer la altura máxima en la que los marcos de banda pueden ser mostrado.\n\nThis will cause unit frames to shrink or move to the next column."
    L["RAID_CONT_WIDTH"] = "Set Raid Frame Container Width"
    L["RAID_CONT_WIDTH_DESC"] = "Set the maximum width that the raid frames can be displayed.\n\nThis will cause unit frames to shrink or move to the next row."
    L["RAID_GROW"] = "Set Raid grow directions"
    L["RAID_GROW_DESC"] = "Set the grow directions for raid frames."
    L["RAID_GROW_DIR"] = "%s and then %s"
    L["RAID_MARKER_DESC"] = "Muestra los marcadores de objetivo en los marcos de unidades de banda"
    L["RAID_PARTY_STYLE_DESC"] = "Mostrar los marcos de grupo como los marcos de banda."
    L["RAID_PREVIEW"] = "Preview raid frames"
    L["RAID_PREVIEW_DESC"] = "Click to toggle raid frame preview and cycle through different group sizes."
    L["RAID_SORT_BY_ROLE"] = "Sort raidframes by role"
    L["RAID_SORT_BY_ROLE_DESC"] = "Sort raid unit frames by role (tank, heal, damage) instead of group."
    L["RAID_AURA_TOOLTIP_IN_COMBAT"] = "Show aura tooltips in combat"
    L["RAID_AURA_TOOLTIP_IN_COMBAT_DESC"] = "Show tooltips of buffs and debuffs even when you are in combat."
    L["RAID_UNIT_FLAGS"] = "Mostrar la bandera del país"
    L["RAID_UNIT_FLAGS_2"] = "Diferente de la mía"
    L["RAID_UNIT_FLAGS_TOOLTIP"] = "Mostrar la bandera del país basado en el idioma de la unidad."
    L["RAID_UNITS_PER_COLUMN"] = "Set Raid units per column"
    L["RAID_UNITS_PER_COLUMN_DESC"] = "Set the number of raid unit frames per column or row, depending on grow directions."
    L["RESOURCE_DESC"] = "Reemplazar la barra de maná/poder predeterminada."
    L["SETTING_LOCK_HUD"] = "Bloquear HUD"
    L["SETTINGS_BUTTON"] = "Ajustes de GW2 UI"
    L["SETTINGS_NO_LOAD_ERROR"] = "Parte del texto no puede cargarse, por favor intenta actualiza la interfaz."
    L["SETTINGS_RESET_TO_DEFAULT"] = "Restablecer a los predeterminados."
    L["SETTINGS_SAVE_RELOAD"] = "Guardar y recargar"
    L["SHOW_ALL_DEBUFFS_DESC"] = "Mostrar todos los perjuicios del objetivo."
    L["SHOW_BUFFS_DESC"] = "Mostrar los beneficios del objetivo."
    L["SHOW_DEBUFFS_DESC"] = "Mostrar los perjuicios del objetivo que has infligido."
    L["SHOW_ILVL"] = "Display average item level"
    L["SHOW_ILVL_DESC"] = "Display the average item level instead of prestige level for friendly units."
    L["STG_RIGHT_BAR_COLS"] = "Ancho de la barra derecha"
    L["STG_RIGHT_BAR_COLS_DESC"] = "Número de columnas en las dos barras de acción adicionales de la derecha."
    L["TALENTS_BUTTON_DESC"] = "Activar el reemplazo de talentos, especializaciones, y libro de hechizos."
    L["TARGET_DESC"] = "Modificar los ajustes de marco de objetivo."
    L["TARGET_FRAME_DESC"] = "Activar el reemplazo de marco de objetivo."
    L["TARGET_OF_TARGET_DESC"] = "Activar el marco de objetivo de objetivo."
    L["TARGET_TOOLTIP"] = "Editar los ajustes de marco de objetivo."
    L["TOOLTIPS"] = "Sugerencias"
    L["TOOLTIPS_DESC"] = "Reemplazar las sugerencias de UI predeterminados."
    L["TRACKER_RETRIVE_CORPSE"] = "Recuperar tu cadáver"
    L["UNEQUIP_LEGENDARY"] = "Debes quitarte este objeto para mejorarlo."
    L["UPDATE_STRING_1"] = "Nueva actualización es disponible para descargar."
    L["UPDATE_STRING_2"] = "Nueva actualización disponible que contiene nuevas características."
    L["UPDATE_STRING_3"] = "Una actualización |cFFFF0000importante| está disponible.\n\nEs muy recomendable que actualice."
    L["MINIMAP_COORDS"] = "Coordenadas"
    L["WORLD_MARKER_DESC"] = "Show menu for placing world markers when in raids."
    L["UP"] = "up"
    L["DOWN"] = "down"
    L["LEFT"] = "left"
    L["RIGHT"] = "right"
    L["TOP"] = "top"
    L["BOTTOM"] = "bottom"
    L["CENTER"] = "center"
    L["TOPLEFT"] = ("%s %s"):format(L["TOP"], L["LEFT"])
    L["TOPRIGHT"] = ("%s %s"):format(L["TOP"], L["RIGHT"])
    L["BOTTOMLEFT"] = ("%s %s"):format(L["BOTTOM"], L["LEFT"])
    L["BOTTOMRIGHT"] = ("%s %s"):format(L["BOTTOM"], L["RIGHT"])
    L["RAID_UNIT_LOST_HEALTH_PREC"] = "Health Remaining in percent"
    L["SHOW_THREAT_VALUE"] = "Show threat"
    L["MINIMAP_FPS"] = "Show FPS on minimap"
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
    L["NO_GUILD"] = "Sin gremio"
    L["AFK_MODE"] = "Modo AFK"
    L["AFK_MODE_DESC"] = "Cuando vaya a AFK, visualice la pantalla AFK."
    L["REPAIRD_FOR"] = "Sus artículos han sido reparados para: %s"
    L["AUTO_REPAIR"] = "Reparación de automóviles"
    L["AUTO_REPAIR_DESC"] = "Repare automáticamente utilizando el siguiente método cuando visite a un comerciante."
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
    L["DISPLAY_PORTRAIT_DAMAGED"] = "Mostrar Daño en el Retrato"
    L["DISPLAY_PORTRAIT_DAMAGED_DESC"] = "Mostrar Daño en el Retrato en este Marco"
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

if GetLocale() == "esES" then
    GWUseThisLocalization()
end

-- After using this localization or deciding that we don"t need it, remove it from memory.
GWUseThisLocalization = nil
    