local MAJOR, MINOR = "ModelsManagement", 0.1
local ModelsManagementLib = LibStub:NewLibrary(MAJOR, MINOR)
if not ModelsManagementLib then return end

ModelsManagementLib.SupportModel            = ModelsManagementLib.SupportModel       or {}
ModelsManagementLib.ModelSetByTypeMode      = ModelsManagementLib.ModelSetByTypeMode or {}
ModelsManagementLib.Animation               = ModelsManagementLib.Animation          or {}

ModelsManagementLib.SupportModel.Model          = true
ModelsManagementLib.SupportModel.PlayerModel    = true
ModelsManagementLib.SupportModel.CinematicModel = true
ModelsManagementLib.SupportModel.DressUpModel   = true
ModelsManagementLib.SupportModel.TabardModel    = true

ModelsManagementLib.ModelSetByTypeMode.ALL          = "ALL"
ModelsManagementLib.ModelSetByTypeMode.SHOW         = "SHOW"
ModelsManagementLib.ModelSetByTypeMode.NOT_SHOW     = "NOT_SHOW"
ModelsManagementLib.ModelSetByTypeMode.VISIBLE      = "VISIBLE"
ModelsManagementLib.ModelSetByTypeMode.NOT_VISIBLE  = "NOT_VISIBLE"

ModelsManagementLib.Animation.Idle = 0 
ModelsManagementLib.Animation.Dead = 6 
ModelsManagementLib.Animation.Talk = 60 
ModelsManagementLib.Animation.TalkExclamation = 64
ModelsManagementLib.Animation.TalkQuestion = 65 
ModelsManagementLib.Animation.Bow = 66 
ModelsManagementLib.Animation.Point = 84
ModelsManagementLib.Animation.Salute = 113
ModelsManagementLib.Animation.Drowned = 132
ModelsManagementLib.Animation.Yes = 185
ModelsManagementLib.Animation.No = 186

-- local CLASS_MODEL = {
--     [ClassName1] = {
--         ["SubClass"] = {
--             SubClassName1 = true, 
--             SubClassName2 = true
--         },
--         ["Limit"] = {
--             "TypeObject1", 
--             "TypeObject2"
--         },
--         ["Models"] = {
--             SubClassName1 = function()
--                 return "npc" or "none"
--             end, 
--             SubClassName2 = function()      
--                 return "player"          
--             end
--         },
--         ["Default"] = {
--              SubClassName1 = {
--                arg1 = "...",
--                arg2 = "...",
--                arg3 = "...",
--               },
--              SubClassName2 = {
--                arg1 = "...",
--                arg2 = "...",
--                arg3 = "...",
--               },
--         },
--         ["Offset"] = {
--              SubClassName1 = {
--                  ModelId1 = {
--                    arg1 = "...",
--                    arg2 = "...",
--                    arg3 = "...",
--                  }
--               },
--              SubClassName2 = {
--                  ModelId1 = {
--                    arg1 = "...",
--                    arg2 = "...",
--                    arg3 = "...",
--                  }
--              },
--         },
--         ["SetModel"] = function (model, unit)
--             model:ClearModel()
--             model:SetUnit(unit) 
--         end,
--         ["SetScaling"] = {
--             NameFunc1 = {arg1 = "..."[, arg2 = "...", arg3 = "...", ....]}, 
--             NameFunc2 = {arg1 = "..."[, arg2 = "...", arg3 = "...", ....]}, 
--             NameFunc3  = {arg1 = "..."[, arg2 = "...", arg3 = "...", ....]}, 
--             NameFunc4  = {arg1 = "..."[, arg2 = "...", arg3 = "...", ....]}, 
--         }
--     }
-- }
------------------------------------------------------------------------------------------------------------------------

local MODEL_LIST = {}
local CLASS_MODEL = {}

function ModelsManagementLib:CreateClassModel(ClassName, Limit, SetModel, SetScaling)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - ClassName must be string, got "..type(ClassName)) 
    end
    
    if type(Limit) ~= "table" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - Limit must be table, got "..type(Limit)) 
    end

    if type(SetModel) ~= "function" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - SetModel must be function, got "..type(SetModel)) 
    end    

    if type(SetScaling) ~= "table" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - SetScaling must be table, got "..type(SetScaling)) 
    end    

    ClassName = ClassName:upper() 
    if CLASS_MODEL[ClassName] then
        return false
    end

    if not next(Limit) or not next(SetScaling)  then
        return false     
    end

    for _, typeObject in ipairs(Limit) do
        if not ModelsManagementLib.SupportModel[typeObject] then
            return false
        end
    end

    for name, args in pairs(SetScaling) do
        if type(name) ~= "string" or type(args) ~= "table" then
            return false
        end
    end

    CLASS_MODEL[ClassName] = {}
    CLASS_MODEL[ClassName]["SubClass"] = {}
    CLASS_MODEL[ClassName]["Limit"] = Limit
    CLASS_MODEL[ClassName]["Models"] = {}
    CLASS_MODEL[ClassName]["SetModel"] = SetModel
    CLASS_MODEL[ClassName]["SetScaling"] = SetScaling
    CLASS_MODEL[ClassName]["Default"] = {}
    CLASS_MODEL[ClassName]["Offset"] = {}

    return true
end

function ModelsManagementLib:CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - ClassName must be string, got "..type(ClassName)) 
    end
    
    if type(SubClassName) ~= "string" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - SubClassName must be string, got "..type(SubClassName)) 
    end

    if type(Model) ~= "function" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - Model must be function, got "..type(Model)) 
    end    

    if type(Default) ~= "table" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - Default must be table, got "..type(Default)) 
    end

    if Offset and type(Offset) ~= "table" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - Offset must be table, got "..type(Offset)) 
    end 

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CLASS_MODEL[ClassName] or CLASS_MODEL[ClassName]["SubClass"][SubClassName] then
        return false
    end

    for _, args in pairs(CLASS_MODEL[ClassName]["SetScaling"]) do
        for _, arg in pairs(args) do
            if Default[arg] == nil then 
                return false 
            end 
        end
    end

    CLASS_MODEL[ClassName]["SubClass"][SubClassName] = true
    CLASS_MODEL[ClassName]["Models"][SubClassName] = Model
    CLASS_MODEL[ClassName]["Default"][SubClassName] = Default
    CLASS_MODEL[ClassName]["Offset"][SubClassName] = Offset

    return true
end

function ModelsManagementLib:RemoveClassOrSubClassModel(ClassName, SubClassName)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":RemoveClassOrSubClassModel(ClassName, SubClassName) - ClassName must be string, got "..type(ClassName)) 
    end
    
    if SubClassName and type(SubClassName) ~= "string" then 
        error(MAJOR..":RemoveClassOrSubClassModel(ClassName, SubClassName) - SubClassName must be string, got "..type(SubClassName)) 
    end

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CLASS_MODEL[ClassName] or CLASS_MODEL[ClassName] and not CLASS_MODEL[ClassName]["SubTypes"][SubClassName] then 
        return false 
    end

    if SubClassName then
        for key, value in pairs(MODEL_LIST) do
            if value.ClassName == ClassName and value.SubClassName == SubClassName then
                self:DeleteModel(key)
            end
        end

        CLASS_MODEL[ClassName]["SubClass"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Models"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Default"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Offset"][SubClassName] = nil
    else
        for key, value in pairs(MODEL_LIST) do
            if  value.ClassName == ClassName then
                self:DeleteModel(key)
            end
        end

        CLASS_MODEL[ClassName] = nil
    end

end

function ModelsManagementLib:ClearAll()
    for key, _ in pairs(CLASS_MODEL) do
        self:RemoveClassOrSubClassModel(key)
    end
end

function ModelsManagementLib:RegisterModel(ClassName, SubClassName, FrameModel, Name)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name) - ClassName must be string, got "..type(ClassName)) 
    end

    if type(SubClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name) - SubClassName must be string, got "..type(SubClassName)) 
    end

    if type(FrameModel) ~= "table" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name) - FrameModel must be object, got "..type(FrameModel)) 
    end

    if Name and type(Name) ~= "table" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name) - Name must be object, got "..type(Name)) 
    end

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CLASS_MODEL[ClassName] or CLASS_MODEL[ClassName] and not CLASS_MODEL[ClassName]["SubClass"][SubClassName] then 
        return false 
    end

    if not tContains(CLASS_MODEL[ClassName]["Limit"], FrameModel:GetObjectType()) or Name and Name:GetObjectType() ~= "FontString" then 
        return false 
    end

    if not MODEL_LIST[FrameModel] then MODEL_LIST[FrameModel] = {} end

    MODEL_LIST[FrameModel].ClassName = ClassName
    MODEL_LIST[FrameModel].SubClassName = SubClassName
    MODEL_LIST[FrameModel].Default = CLASS_MODEL[ClassName]["Default"][SubClassName]
    MODEL_LIST[FrameModel].Offset = CLASS_MODEL[ClassName]["Offset"][SubClassName]
    MODEL_LIST[FrameModel].Name = Name

    FrameModel["LibScalingGetModelInfo"] = CLASS_MODEL[ClassName]["Models"][SubClassName]
    FrameModel["LibScalingSetModel"] = CLASS_MODEL[ClassName]["SetModel"]

    MODEL_LIST[FrameModel].ApplyScaling = CLASS_MODEL[ClassName]["SetScaling"]

    return true
end

function ModelsManagementLib:DeleteModel(FrameModel)
    if MODEL_LIST[FrameModel] then 
        MODEL_LIST[FrameModel] = nil
        FrameModel["LibScalingSetModel"] = nil
        FrameModel["LibScalingGetModelInfo"] = nil

        return true 
    end

    return false
end

local function GetModelProperties(Default, Offset, Id)
    local properties = {}

    local defect = Offset and Offset[Id]
    for key, value in pairs(Default) do
        if type(value) == "number" then
            properties[key] = value + (defect and defect[key] or 0)
        else
            properties[key] = defect and defect[key] or value
        end
    end
    
    return properties
end

function ModelsManagementLib:SetModel(Model)
    local info = MODEL_LIST[Model]
    if info then
        local unit = Model:LibScalingGetModelInfo(Model)
        Model:LibScalingSetModel(unit)

        local id = Model:GetModelFileID()
        if id then
            local properties = GetModelProperties(info.Default, info.Offset, id)
            
            for func, info in pairs(info.ApplyScaling) do
                if Model[func] then
                    Model[func](Model, properties[info.arg1], properties[info.arg2], properties[info.arg3], properties[info.arg4])
                end
            end
        end
    end
end

function ModelsManagementLib:SetModels(...)
    local models = {...}
    for i, model in ipairs(models) do
        self:SetModel(model)
    end
end

local function CheckStateModel(Model, Mode)
    if not Mode or ModelsManagementLib.ModelSetByTypeMode.ALL == Mode then return true end

    if ModelsManagementLib.ModelSetByTypeMode.SHOW == Mode then
        return Model:IsShown()
    elseif ModelsManagementLib.ModelSetByTypeMode.NOTSHOW == Mode then
        return not Model:IsShown()
    elseif ModelsManagementLib.ModelSetByTypeMode.VISIBLE == Mode then
        return Model:IsVisible()
    elseif ModelsManagementLib.ModelSetByTypeMode.NOTVISIBLE == Mode then
        return not Model:IsVisible()
    end
end

function ModelsManagementLib:SetModelsByType(ClassName, SubClassName, Mode)
    for model, info in pairs(MODEL_LIST) do
        if info.ClassName == ClassName and (SubClassName and info.SubClassName == SubClassName or not SubClassName) then
            if CheckStateModel(model, Mode) then
                self:SetModel(model)
            end
        end
    end
end

function ModelsManagementLib:GetModelName(Model)
    local unit = Model:LibScalingGetModelInfo(Model)
    if type(unit) == "string" and unit ~= "none" then
        return select(1, UnitName(unit))
    else
        return UNKNOWN
    end
end

function ModelsManagementLib:SetModelName(Model)
    local info = MODEL_LIST[Model]
    if info and info.Name then
        local id = Model:GetModelFileID()
        if id then
            info.Name:SetText(self:GetModelName(Model))
            info.Name:Show()
        else
            info.Name:Hide()
        end
    end
end

function ModelsManagementLib:SetModelsName(...)
    local models = {...}
    for i, model in ipairs(models) do
        self:SetModelName(model)
    end
end

