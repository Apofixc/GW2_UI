local MAJOR, MINOR = "ModelsManagementDB", 0.1
local ModelsManagementLibDB = LibStub:NewLibrary(MAJOR, MINOR)
if not ModelsManagementLibDB then return end

ModelsManagementLibDB.defGetNamePlayer = function()
    return select(1, UnitName("player"))
end

ModelsManagementLibDB.defGetNameNPC = function()
    return select(1, UnitName(UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none"))
end

ModelsManagementLibDB.defGetPlayer = function()
    return {"player"} 
end

ModelsManagementLibDB.defGetNPC = function()
    return {UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none"}
end

ModelsManagementLibDB.defGetTarget = function()
    return {UnitExists("target") and not UnitIsUnit("player", "npc") or "none"}
end

ModelsManagementLibDB.defSetUnit = function(model, unit)
    model:ClearModel()
    model:SetUnit(unit)     
end

ModelsManagementLibDB.defSetCreature = function(model, CreatureId)
    model:ClearModel()
    model:SetCreature(CreatureId)     
end

ModelsManagementLibDB.defSetItem = function(model, itemID, appearanceModID, itemVisualID)
    model:ClearModel()
    model:SetItem(itemID, appearanceModID, itemVisualID)
end

ModelsManagementLibDB.defSetCustomRace = function(model, raceId, sexId)
    model:ClearModel()
    model:SetCustomRace(raceId, sexId)     
end

ModelsManagementLibDB.defSetModel = function(model, file)
    model:ClearModel()
    model:SetModel(file)    
end

ModelsManagementLibDB.defFullModel = {
    SetFacingLeft = { arg1 = "FacingLeft"}, 
    InitializeCamera = {arg1 = "Camera"}, 
    SetTargetDistance = {arg1 = "TargetDistance"}, 
    SetHeightFactor = {arg1 = "HeightFactor"}, 
    SetFacing = {arg1 = "Facing"},
}

ModelsManagementLibDB.defPortrait = {
    SetCamDistanceScale = {arg1 = "DistanceScale"},
    SetPortraitZoom = {arg1 = "PortraitZoom"},
    SetPosition = {arg1 = "PositionX", arg2 = "PositionY", arg3 = "PositionZ"},
    RefreshUnit = {}
}

ModelsManagementLibDB.defFullModelRight = {
    FacingLeft = false,
    Camera = 1.55, 
    Facing = 2.3, 
    TargetDistance = .27, 
    HeightFactor = .4,    
}

ModelsManagementLibDB.defFullModelOffsetRight = {
}

ModelsManagementLibDB.defFullModelLeft = {
    FacingLeft = true,
    Camera = 1.8, 
    Facing = -.92, 
    TargetDistance = .27, 
    HeightFactor = .34,   
}

ModelsManagementLibDB.defFullModelOffsetLeft= {
}

ModelsManagementLibDB.defPortraitRight = {
    DistanceScale = 1.1,
    PortraitZoom = .7,
    PositionX = 0,
    PositionY = 0,
    PositionZ = -.05,
}

ModelsManagementLibDB.defPortraitOffsetRight = {
}

ModelsManagementLibDB.defPortraitLeft = {
    DistanceScale = 1.1,
    PortraitZoom = .7,
    PositionX = 0,
    PositionY = 0,
    PositionZ = -.05,
}

ModelsManagementLibDB.defPortraitOffsetLeft= {
}