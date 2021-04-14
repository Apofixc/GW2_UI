local MAJOR, MINOR = "MountManagement", 0.1
local MountManagementLib = LibStub:NewLibrary(MAJOR, MINOR)
if not MountManagementLib then return end

local RACE = {
    [1] = {--	Human
        [6] = true, 
        [18] = true, 
        [11] = true, 
        [9] = true, 
        [93] = true, 
        [91] = true, 
        [92] = true 
    }, 
    [2] = {--	Orc
        [310] = true, 
        [20] = true, 
        [19] = true, 
        [14] = true, 
        [104] = true, 
        [106] = true, 
        [105] = true 
    }, 
    [3] = {--	Dwarf
        [25] = true, 
        [21] = true, 
        [24] = true, 
        [94] = true, 
        [95] = true, 
        [96] = true 
    }, 
    [4] = { --	Night Elf
        [337] = true, 
        [31] = true, 
        [26] = true, 
        [34] = true, 
        [87] = true, 
        [85] = true, 
        [107] = true 
    },
    [5] = {--	Undead
        [314] = true, 
        [66] = true, 
        [67] = true, 
        [65] = true, 
        [68] = true, 
        [336] = true, 
        [100] = true 
    }, 
    [6] = { --	Tauren
        [72] = true, 
        [71] = true, 
        [309] = true, 
        [103] = true, 
        [102] = true, 
        [101] = true 
    },
    [7] = { --	Gnome
        [40] = true, 
        [57] = true, 
        [39] = true, 
        [58] = true, 
        [90] = true, 
        [89] = true, 
        [88] = true 
    },
    [8] = {[27] = true, [36] = true, [38] = true, [97] = true, [98] = true, [99] = true }, --	Troll
    [9] = {[388] = true, [389] = true }, --	Goblin
    [10] = {[159] = true, [158] = true, [157] = true, [152] = true, [160] = true, [146] = true, [161] = true }, --	Blood Elf
    [11] = {[147] = true, [163] = true, [164] = true, [166] = true, [165] = true, [167] = true }, --	Draenei
    [22] = {[435] = true, [436] = true }, --	Worgen
    [23] = { }, --	Gilnean
    [24] = { }, --	Pandaren
    [25] = {[492] = true, [493] = true, [494] = true, [452] = true, [495] = true, [496] = true, [497] = true, [498] = true, [499] = true, [500] = true, [501] = true, [453] = true }, --	Pandaren Alliance
    [26] = {[492] = true, [493] = true, [494] = true, [452] = true, [495] = true, [496] = true, [497] = true, [498] = true, [499] = true, [500] = true, [501] = true, [453] = true }, --	Pandaren Horde
    [27] = {[904] = true }, --	Nightborne 
    [28] = {[903] = true }, --	Highmountain Tauren 
    [29] = {[902] = true }, --	Void Elf 
    [30] = {[901] = true }, --	Lightforged Draenei 
    [31] = {[912] = true }, --	Zandalari Troll 
    [32] = {[1098] = true }, --	Kul Tiran 
    [34] = {[918] = true }, --	Dark Iron Dwarf
    [35] = {[1184] = true }, --	Vulpera
    [36] = {[913] = true }, --	Mag'har Orc
    [37] = {[1189] = true }, --	Mechagnome
}

local CLASS = {
    [1] = {[867] = true }, --	Warrior
    [2] = {[41] = true, [150] = true, [367] = true, [350] = true, [84] = true, [149] = true, [368] = true, [351] = true, [338] = true, [1047] = true, [1046] = true, [1225] = true, [885] = true, [892] = true, [894] = true, [893] = true}, --	Paladin
    [3] = {[870] = true, [865] = true, [872] = true }, --	Hunter
    [4] = {[884] = true, [891] = true, [890] = true, [889] = true }, --	Rogue
    [5] = {[861] = true }, --	Priest
    [6] = {[221] = true, [236] = true, [866] = true }, --	Death Knight
    [7] = {[888] = true }, --	Shaman
    [8] = {[860] = true }, --	Mage
    [9] = {[17] = true, [83] = true, [930] = true, [931] = true, [898] = true }, --	Warlock
    [10] = {[864] = true }, --	Monk
    [11] = { }, --	Druid
    [12] = {[780] = true, [868] = true, }, --	Demon Hunter
}

local FRACTION = {
    
}

local COVENANT = {

}

local QUEST = {

}

local PROFESSION = {

}

local ACHIEVEMENTS = {

}

function MountManagementLib:GetRaceMounts()
end

function MountManagementLib:GetClassMounts()
end

function MountManagementLib:GetFractionMounts()
end

function MountManagementLib:GetCovenantMounts()
end

function MountManagementLib:GetQuestMounts()
end

function MountManagementLib:GetProfessionMounts()
    local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
end

function MountManagementLib:GetAchievementsMounts()
end

