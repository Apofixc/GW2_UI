local _, GW = ...
local GetSetting = GW.GetSetting

local classID, raceID = select(3, UnitClass("player")), select(3, UnitRace("player"))

local timeLastSummon = 0
local isStealthed = IsStealthed()
local IsSummonPet, IsSummonMount = false, false
local lastSummonedPetGUID, lastSummonedMountID

local RACEMOUNT = {
    [1] = {[6] = true, [18] = true, [11] = true, [9] = true, [93] = true, [91] = true, [92] = true }, --	Human
    [2] = {[310] = true, [20] = true, [19] = true, [14] = true, [104] = true, [106] = true, [105] = true }, --	Ork
    [3] = {[25] = true, [21] = true, [24] = true, [94] = true, [95] = true, [96] = true }, --	Dwarf
    [4] = {[337] = true, [31] = true, [26] = true, [34] = true, [87] = true, [85] = true, [107] = true }, --	Night Elf
    [5] = {[314] = true, [66] = true, [67] = true, [65] = true, [68] = true, [336] = true, [100] = true }, --	Undead
    [6] = {[72] = true, [71] = true, [309] = true, [103] = true, [102] = true, [101] = true }, --	Tauren
    [7] = {[40] = true, [57] = true, [39] = true, [58] = true, [90] = true, [89] = true, [88] = true }, --	Gnome
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

local CLASSMOUNT = {
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

local function PrintInfo(typeSummon, name, sourceText, description)
    ChatFrame1:AddMessage("|c0000FF00"..typeSummon..": |c0000FFFF"..name..".")

    local zoneName = GetZoneText()
    if string.find(sourceText, zoneName) then
        ChatFrame1:AddMessage("|c0000FF00"..ZONE..": |c0000FFFF"..zoneName..".")
    end

    if description and description ~= "" then
        ChatFrame1:AddMessage("|c0000FF00"..DESCRIPTION..": |c0000FFFF"..description..".")
    end  
end

local function IsPlayerFree()
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
        return false
    end

    if InCombatLockdown() or UnitIsDeadOrGhost("player") or UnitIsFeignDeath("player") or isStealthed then
        return false
    end

    if IsFlying() or UnitInVehicle("player") or UnitOnTaxi("player") then
        return false
    end
  
    return true
end

local function SummonMountInfo()
    if lastSummonedMountID then
        local name = C_MountJournal.GetMountInfoByID(lastSummonedMountID)
        local _, description, sourceText = C_MountJournal.GetMountInfoExtraByID(lastSummonedMountID)

        PrintInfo(MOUNTS, name, sourceText, description)
    end

    IsSummonMount = false
end

local function ListMounts()
    local zoneName = GetZoneText()

    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetCollectedFilterSetting(1, true)
    C_MountJournal.SetCollectedFilterSetting(2, false)
    C_MountJournal.SetSearch('')

    local mountZone = {}
    local mountType = {}
    local mountRaceClass = {}

    local numMounts = C_MountJournal.GetNumDisplayedMounts()
    for n = 1, numMounts do
        local _, _, _, _, isUsable, _, _, _, _, _, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(n)
        if isUsable and isCollected then
            mountType[#mountType + 1] = mountID

            local _, _, source, _, _, _, _, _, _  = C_MountJournal.GetMountInfoExtraByID(mountID)
            if string.find(source, zoneName) then
                mountZone[#mountZone + 1] = mountID
            end

            if (CLASSMOUNT[classID][mountID] or RACEMOUNT[raceID][mountID]) then
                mountRaceClass[#mountRaceClass + 1] = mountID
            end
        end
    end

    return #mountZone > 0 and mountZone or #mountRaceClass > 0 and mountRaceClass or mountType
end

local function SummonMount() 
    if IsMounted() then
        C_MountJournal.Dismiss()
    elseif IsPlayerFree() then
        local mounts = ListMounts()
        if (mounts and #mounts > 0) then
            lastSummonedMountID = mounts[math.random(1, #mounts)]
            C_MountJournal.SummonByID(lastSummonedMountID)
            IsSummonMount = true
        end
    end
end

local function SummonPetInfo()
    local newSummonedPetGUID = C_PetJournal.GetSummonedPetGUID()

    if newSummonedPetGUID then
        local _, _, _, _, _, _, isFavorite, name, _, _, _, sourceText, description, _, _, _, _, _ = C_PetJournal.GetPetInfoByPetID(newSummonedPetGUID)

        PrintInfo(PET, name, sourceText, description)

        timeLastSummon = GetTime() - 2
    end

    IsSummonPet = false
end

local function ListPet()    
    local validPets = {} 
    local EXCEPTIONS = { }  

    C_PetJournal.SetAllPetTypesChecked(true)
    C_PetJournal.SetAllPetSourcesChecked(true)
    C_PetJournal.ClearSearchFilter()

    local _, numOwned = C_PetJournal.GetNumPets()
    local summonedPetGUID = C_PetJournal.GetSummonedPetGUID()
    local zoneName = GetZoneText()
    for n = 1, numOwned do
        local petID, _, owned, _, _, _, _, speciesName, _, petType, _, tooltip, description, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(n)
        if (owned and tooltip and string.find(tooltip, zoneName) and EXCEPTIONS[petID] and summonedPetGUID ~= petID) then
            validPets[#validPets + 1] = petID
        end
    end

    return #validPets > 0 and validPets[math.random(#validPets)]
end

local function SummonedPet(summonLastPet)
    if IsPlayerFree() then
        local pet

        if summonLastPet then
            pet = lastSummonedPetGUID
        end

        if not pet then
            pet = ListPet() 
            IsSummonPet = true
        end

        if pet and type(pet) == 'string' then
            C_PetJournal.SummonPetByGUID(pet)
        else
            C_PetJournal.SummonRandomPet(false)
        end
    end
end

local function DismissPet()
    local summonedPetGUID = C_PetJournal.GetSummonedPetGUID()
    if summonedPetGUID then
        lastSummonedPetGUID = summonedPetGUID
        C_PetJournal.SummonPetByGUID(summonedPetGUID)
    end
end

local function LoadSummon()
    if not SummonFrame then
        CreateFrame("Frame", "SummonFrame")
    end
    
    if GetSetting("SUMMON_PET") then
        SummonFrame:RegisterEvent("ZONE_CHANGED")
        SummonFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        SummonFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
        SummonFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
        SummonFrame:RegisterEvent("UPDATE_STEALTH")
        --SummonFrame:RegisterEvent("UNIT_AURA")
        SummonFrame:RegisterEvent("COMPANION_UPDATE")
    end
    
    if GetSetting("SUMMON_MOUNT") then
        -- SummonFrame:RegisterEvent("COMPANION_UPDATE")
        -- MountJournal.SummonRandomFavoriteButton:SetScript("OnClick", SummonMount)

        -- local spellName, _, spellIcon = GetSpellInfo(150544);
        -- if (not GetMacroIndexByName(spellName)) then
        --     CreateMacro(spellName, spellIcon, "/run MountJournal.SummonRandomFavoriteButton:Click()")
        -- end
    end

    SummonFrame:SetScript("OnEvent",
        function(self, event, ...)
            if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
                if GetTime() - timeLastSummon > 120 or not C_PetJournal.GetSummonedPetGUID() then
                    SummonedPet(false)
                end
            elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" then
                if not C_PetJournal.GetSummonedPetGUID() then
                    SummonedPet(false)
                end
            elseif event == "UPDATE_STEALTH" or event == "UNIT_AURA" then
                isStealthed = IsStealthed()
                if isStealthed then
                    DismissPet()
                else
                    SummonedPet(true)
                end
            elseif event == "COMPANION_UPDATE" then
                local companionType = ...
                if companionType == "CRITTER" and IsSummonPet then
                    SummonPetInfo()
                elseif companionType == "MOUNT" and IsSummonMount then
                    SummonMountInfo()
                end
            end  
        end
    )
end

GW.LoadSummon = LoadSummon