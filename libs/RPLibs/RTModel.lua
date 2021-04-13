local MAJOR, MINOR = "ModelScaling", 1 -- 9.2.0 v2 / increase manually on changes
local ModelsManagementLib = LibStub:NewLibrary(MAJOR, MINOR)
if not ModelsManagementLib then return end

ModelsManagementLib.SupportModel            = ModelsManagementLib.SupportModel       or {}
ModelsManagementLib.ModelSetByTypeMode      = ModelsManagementLib.ModelSetByTypeMode or {}

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

local MODEL_LIST = {}

local CONTROL_MODEL_TYPE = {
    ["FULLMODEL"] = {
        ["SubTypes"] = {
            ["LEFT"] = true, 
            ["RIGHT"] = true
        },
        ["Limit"] = {
            ["CinematicModel"] = true
        },
        ["Default"] = {
            ["LEFT"] = {
                FacingLeft = true,
                Camera = 1.8, 
                Facing = -.92, 
                TargetDistance = .27, 
                HeightFactor = .34, 
            }, 
            ["RIGHT"] = {
                FacingLeft = false,
                Camera = 1.55, 
                Facing = 2.3, 
                TargetDistance = .27, 
                HeightFactor = .4, 
            }
        },
        ["Offset"] = {
            ["LEFT"] = {

            }, 
            ["RIGHT"] = {
                
            }
        },
        ["Models"] = {
            ["LEFT"] = function()
                return UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none"
            end, 
            ["RIGHT"] = function()      
                return "player"          
            end
        },
        ["SetModel"] = function (model, unit)
            model:ClearModel()
            model:SetUnit(unit) 
        end,
        ["SetScaling"] = {
            ["SetFacingLeft"] = {arg1 = "FacingLeft"}, 
            ["InitializeCamera"] = {arg1 = "Camera"}, 
            ["SetTargetDistance"] = {arg1 = "TargetDistance"}, 
            ["SetHeightFactor"] = {arg1 = "HeightFactor"}, 
            ["SetFacing"] = {arg1 = "Facing"}
        }
    },
    ["PORTRAIT"] = {
        ["SubTypes"] = {
            ["LEFT"] = true, 
            ["RIGHT"] = true
        },
        ["Limit"] = {
            ["CinematicModel"] = true, 
            ["PlayerModel"] = true
        },
        ["Default"] = {
            ["LEFT"] = {
                Camera = 1.8,
                Facing = -.95,
                TargetDistance = .22, 
                HeightFactor = .325, 
            }, 
            ["RIGHT"] = {
                Camera = 1.8,
                Facing = 1.8, 
                TargetDistance = .22, 
                HeightFactor = .395, 
            }
        },
        ["Offset"] = {
            ["LEFT"] = {

            }, 
            ["RIGHT"] = {
                
            }
        },
        ["Model"] = {
            ["LEFT"] = function()
                return UnitExists("questnpc") and "questnpc" or UnitExists("npc") and "npc" or "none"
            end, 
            ["RIGHT"] = function()      
                return "player"          
            end
        },
        ["SetModel"] = function (model, unit)
            model:ClearModel()
            model:SetUnit(unit) 
        end,
        ["SetScaling"] = {

        }
    }
}

function ModelsManagementLib:CreateClassModel(ClassName, Limit, SetModel, SetScaling)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - ClassName must be string, got "..type(ClassName)) 
    end
    
    if type(Limit) ~= "table" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - Limit must be table, got "..type(Limit)) 
    end

    if type(SetModel) ~= "function" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - default must be table, got "..type(SetModel)) 
    end    

    if type(SetScaling) ~= "table" then 
        error(MAJOR..":CreateNewClassModel(ClassName, Limit, SetModel, SetScaling) - SetScaling must be table, got "..type(SetScaling)) 
    end    

    ClassName = ClassName:upper() 
    if CONTROL_MODEL_TYPE[ClassName] then
        return false
    end

    if not next(Limit) or not next(SetScaling)  then
        return false     
    end

    for typeObject, value in pairs(Limit) do
        if not ModelsManagementLib.SupportModel[typeObject] or ModelsManagementLib.SupportModel[typeObject] ~= value then
            return false
        end
    end

    for name, args in pairs(SetScaling) do
        if type(name) ~= "string" or type(args) ~= "table" then
            return false
        end
    end

    CONTROL_MODEL_TYPE[ClassName] = {}
    CONTROL_MODEL_TYPE[ClassName]["SubClass"] = {}
    CONTROL_MODEL_TYPE[ClassName]["Limit"] = Limit
    CONTROL_MODEL_TYPE[ClassName]["Models"] = {}
    CONTROL_MODEL_TYPE[ClassName]["SetModel"] = SetModel
    CONTROL_MODEL_TYPE[ClassName]["SetScaling"] = SetScaling
    CONTROL_MODEL_TYPE[ClassName]["Default"] = {}
    CONTROL_MODEL_TYPE[ClassName]["Offset"] = {}
end

function ModelsManagementLib:CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - ClassName must be string, got "..type(ClassName)) 
    end
    
    if type(SubClassName) ~= "string" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - Limit must be table, got "..type(SubClassName)) 
    end

    if type(Model) ~= "function" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - default must be table, got "..type(Model)) 
    end    

    if type(Default) ~= "table" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - SetScaling must be table, got "..type(Default)) 
    end

    if Offset and type(Offset) ~= "table" then 
        error(MAJOR..":CreateSubClassModel(ClassName, SubClassName, Model, Default, Offset) - SetScaling must be table, got "..type(Offset)) 
    end 

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CONTROL_MODEL_TYPE[ClassName] or CONTROL_MODEL_TYPE[ClassName]["SubClass"][SubClassName] then
        return false
    end

    for _, args in pairs(CONTROL_MODEL_TYPE[ClassName]["SetScaling"]) do
        for _, arg in pairs(args) do
            if not Default[arg] then 
                return false 
            end 
        end
    end

    CONTROL_MODEL_TYPE[ClassName]["SubClass"][SubClassName] = true
    CONTROL_MODEL_TYPE[ClassName]["Models"][SubClassName] = Model
    CONTROL_MODEL_TYPE[ClassName]["Default"][SubClassName] = Default
    CONTROL_MODEL_TYPE[ClassName]["Offset"][SubClassName] = Offset
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
    if not CONTROL_MODEL_TYPE[ClassName] or CONTROL_MODEL_TYPE[ClassName] and not CONTROL_MODEL_TYPE[ClassName]["SubTypes"][SubClassName] then 
        return false 
    end

    if SubClassName then
        for key, value in pairs(MODEL_LIST) do
            if value.ClassName == ClassName and value.SubClassName == SubClassName then
                self:DeleteModel(key)
            end
        end

        CONTROL_MODEL_TYPE[ClassName]["SubClass"][SubClassName] = nil
        CONTROL_MODEL_TYPE[ClassName]["Models"][SubClassName] = nil
        CONTROL_MODEL_TYPE[ClassName]["Default"][SubClassName] = nil
        CONTROL_MODEL_TYPE[ClassName]["Offset"][SubClassName] = nil
    else
        for key, value in pairs(MODEL_LIST) do
            if  value.ClassName == ClassName then
                self:DeleteModel(key)
            end
        end

        CONTROL_MODEL_TYPE[ClassName] = nil
    end

end

function ModelsManagementLib:ClearAll()
    for key, _ in pairs(CONTROL_MODEL_TYPE) do
        self:RemoveClassOrSubClassModel(key)
    end
end

function ModelsManagementLib:RegisterModel(ClassName, SubClassName, FrameModel)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel) - ClassName must be string, got "..type(ClassName)) 
    end

    if type(SubClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel) - SubClassName must be string, got "..type(SubClassName)) 
    end

    if type(FrameModel) ~= "table" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel) - FrameModel must be object, got "..type(FrameModel)) 
    end

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CONTROL_MODEL_TYPE[ClassName] or CONTROL_MODEL_TYPE[ClassName] and not CONTROL_MODEL_TYPE[ClassName]["SubTypes"][SubClassName] then 
        return false 
    end

    local typeObject = FrameModel:GetObjectType()
    if CONTROL_MODEL_TYPE[ClassName]["Limit"][typeObject] then
        if not MODEL_LIST[FrameModel] then MODEL_LIST[FrameModel] = {} end

        MODEL_LIST[FrameModel].ClassName = ClassName
        MODEL_LIST[FrameModel].SubClassName = SubClassName
        MODEL_LIST[FrameModel].Default = CONTROL_MODEL_TYPE[ClassName]["Default"][SubClassName]
        MODEL_LIST[FrameModel].Offset = CONTROL_MODEL_TYPE[ClassName]["Offset"][SubClassName]
        
        FrameModel["LibScalingGetModel"] = CONTROL_MODEL_TYPE[ClassName]["Models"][SubClassName]
        FrameModel["LibScalingSetModel"] = CONTROL_MODEL_TYPE[ClassName]["SetModel"]

        MODEL_LIST[FrameModel].ApplyScaling = CONTROL_MODEL_TYPE[ClassName]["SetScaling"]
        return true

    end

    return false
end

function ModelsManagementLib:DeleteModel(FrameModel)
    if MODEL_LIST[FrameModel] then 
        MODEL_LIST[FrameModel] = nil
        FrameModel["LibScalingSetModel"] = nil
        FrameModel["LibScalingGetModel"] = nil

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
        Model:LibScalingSetModel(Model)

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