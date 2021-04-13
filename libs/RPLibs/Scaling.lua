local MAJOR, MINOR = "ModelScaling", 1 -- 9.2.0 v2 / increase manually on changes
local LibScaling = LibStub:NewLibrary(MAJOR, MINOR)
if not LibScaling then return end

LibScaling.SupportModel            = LibScaling.SupportModel       or {}
LibScaling.ModelSetByTypeMode      = LibScaling.ModelSetByTypeMode or {}

LibScaling.SupportModel.Model          = true
LibScaling.SupportModel.PlayerModel    = true
LibScaling.SupportModel.CinematicModel = true
LibScaling.SupportModel.DressUpModel   = true
LibScaling.SupportModel.TabardModel    = true

LibScaling.ModelSetByTypeMode.ALL          = "ALL"
LibScaling.ModelSetByTypeMode.SHOW         = "SHOW"
LibScaling.ModelSetByTypeMode.NOT_SHOW     = "NOT_SHOW"
LibScaling.ModelSetByTypeMode.VISIBLE      = "VISIBLE"
LibScaling.ModelSetByTypeMode.NOT_VISIBLE  = "NOT_VISIBLE"

local MODEL_LIST = {}

local CONTROL_MODEL_TYPE = {
    ["FULLMODEL"] = {
        ["SubTypes"] = {
            "LEFT", 
            "RIGHT"
        },
        ["Limit"] = {
            ["CinematicModel"] = true
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
            "LEFT", 
            "RIGHT"
        },
        ["Limit"] = {
            ["CinematicModel"] = true, 
            ["PlayerModel"] = true
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

local DEFAULT_PROPERTIES = {
    ["FULLMODEL"] = {
        ["RIGHT"] = {
            FacingLeft = false,
            Camera = 1.55, 
            Facing = 2.3, 
            TargetDistance = .27, 
            HeightFactor = .4, 
        },
        ["LEFT"] = {
            FacingLeft = true,
            Camera = 1.8, 
            Facing = -.92, 
            TargetDistance = .27, 
            HeightFactor = .34, 
        },
    },
    ["PORTRAIT"] = {
        ["RIGHT"] = {
            Camera = 1.8,
            Facing = 1.8, 
            TargetDistance = .22, 
            HeightFactor = .395, 
        },
        ["LEFT"] = {
            Camera = 1.8,
            Facing = -.95,
            TargetDistance = .22, 
            HeightFactor = .325, 
        },
    }
}

local ADJUSTMENT_PROPERTIES = {
    ["FULLMODEL"] = {
        ["RIGHT"] = {
        },
        ["LEFT"] = {

        },
    },
    ["PORTRAIT"] = {
        ["RIGHT"] = {
        },
        ["LEFT"] = {

        },
    },
}

--[----------------------------------------------------------------------------------------------------------------------------------]

local function GetModelProperties(default, adjustment, id)
    local properties = {}

    local defect = adjustment and adjustment[id]
    for key, value in pairs(default) do
        if type(value) == "number" then
            properties[key] = value + (defect and defect[key] or 0)
        else
            properties[key] = defect and defect[key] or value
        end
    end
    
    return properties
end

local function CheckStructureTable(control)
    if type(control["SubTypes"]) ~= "table" or #control["SubTypes"] == 0 or type(control["Limit"]) ~= "table" or type(control["Models"]) ~= "table" or type(control["SetModel"]) ~= "function" or type(control["SetScaling"]) ~= "table" then
        return false
    end

    local num = 0
    for typeObject, value in pairs(control["Limit"]) do
        if not LibScaling.SupportModel[typeObject] or  LibScaling.SupportModel[typeObject] ~= value then
            return false
        end

        num = num + 1
    end
    if num == 0 then return false  end

    num = 0
    for subType, func in ipairs(control["Models"]) do
        if not tContains(control["SubTypes"], subType) or type(func) ~= "function" then
            return false
        end

        num = num + 1
    end
    if num ~= #control["SubTypes"] then return false  end

    num = 0
    for name, args in pairs(control["SetScaling"]) do
        if type(name) ~= "string" or type(args) ~= "table" then
            return false
        end

        num = num + 1
    end
    if num == 0 then return false  end

    return true
end

function LibScaling:RegisterModelType(typeModel, control, default, adjustment)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":RegisterNewModelType(typeModel, control, default, adjustment) - typeModel must be string, got "..type(typeModel)) 
    end
    
    if type(control) ~= "table" then 
        error(MAJOR..":RegisterNewModelType(typeModel, control, default, adjustment) - control must be table, got "..type(control)) 
    end

    if type(default) ~= "table" then 
        error(MAJOR..":RegisterNewModelType(typeModel, control, default, adjustment) - default must be table, got "..type(default)) 
    end

    if type(adjustment) ~= "table" then 
        error(MAJOR..":RegisterNewModelType(typeModel, control, default, adjustment) - adjustment must be table, got "..type(adjustment)) 
    end

    if CONTROL_MODEL_TYPE[typeModel] or DEFAULT_PROPERTIES[typeModel] or ADJUSTMENT_PROPERTIES[typeModel] then 
        return false 
    end

    if not CheckStructureTable(control) then 
        return false 
    end

    for _, SubType in pairs(control["SubTypes"]) do
        if not default[SubType] or adjustment and not adjustment[SubType] then 
            return false 
        end
    end

    for _, args in pairs(control["SetScaling"]) do
        for _, arg in pairs(args) do
            for _, SubType in pairs(control["SubTypes"]) do
                if not default[SubType][arg] then 
                    return false 
                end
            end  
        end
    end

    CONTROL_MODEL_TYPE[typeModel] = control
    DEFAULT_PROPERTIES[typeModel] = default
    ADJUSTMENT_PROPERTIES[typeModel] = adjustment or {}

    return true
end

function LibScaling:AddSybType(typeModel, subTypeModel, unit, default, adjustment)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":AddSybType(typeModel, subTypeModel, unit, default, adjustment) - typeModel must be string, got "..type(typeModel)) 
    end

    if type(subTypeModel) ~= "string" then 
        error(MAJOR..":AddSybType(typeModel, subTypeModel, unit, default, adjustment) - subTypeModel must be string, got "..type(typeModel)) 
    end

    if type(unit) ~= "function" then 
        error(MAJOR..":AddSybType(typeModel, subTypeModel, unit, default, adjustment) - unit must be function, got "..type(unit)) 
    end

    if type(default) ~= "table" then 
        error(MAJOR..":AddSybType(typeModel, subTypeModel, unit, default, adjustment) - default must be table, got "..type(default)) 
    end

    if type(adjustment) ~= "table" then 
        error(MAJOR..":AddSybType(typeModel, subTypeModel, unit, default, adjustment) - adjustment must be table, got "..type(adjustment)) 
    end

    if not CONTROL_MODEL_TYPE[typeModel] or not DEFAULT_PROPERTIES[typeModel] or not ADJUSTMENT_PROPERTIES[typeModel] then 
        return false 
    end

    if CONTROL_MODEL_TYPE[typeModel] and not tContains(CONTROL_MODEL_TYPE[typeModel]["SubTypes"], subTypeModel) or DEFAULT_PROPERTIES[typeModel] and not DEFAULT_PROPERTIES[typeModel][subTypeModel] or ADJUSTMENT_PROPERTIES[typeModel] and not ADJUSTMENT_PROPERTIES[typeModel][subTypeModel] then 
        return false 
    end

    for _, args in pairs(CONTROL_MODEL_TYPE[typeModel]["SetScaling"]) do
        for _, arg in pairs(args) do
            for _, SubType in pairs(CONTROL_MODEL_TYPE[typeModel]["SubTypes"]) do
                if not default[SubType][arg] then 
                    return false 
                end
            end  
        end
    end

    tinsert(CONTROL_MODEL_TYPE[typeModel]["SubTypes"], subTypeModel)
    CONTROL_MODEL_TYPE[typeModel]["SetModel"][subTypeModel] = unit
    DEFAULT_PROPERTIES[typeModel][subTypeModel] = default
    ADJUSTMENT_PROPERTIES[typeModel][subTypeModel] = adjustment

    return true
end

function LibScaling:RemoveModelType(typeModel, subTypeModel)
    if type(typeModel) ~= "string" then 
        error(MAJOR.."RemoveModelType(typeModel, subTypeModel) - typeModel must be string, got "..type(typeModel)) 
    end

    if subTypeModel and type(subTypeModel) ~= "string" then 
        error(MAJOR.."RemoveModelType(typeModel, subTypeModel) - subTypeModel must be string, got "..type(subTypeModel)) 
    end

    if subTypeModel then
        for key, value in pairs(MODEL_LIST) do
            if value.typeModel == typeModel and value.SubTypeModel == subTypeModel then
                key["LibScalingSetModel"] = nil
                MODEL_LIST[key] = nil   
            end
        end

        CONTROL_MODEL_TYPE[typeModel][subTypeModel] = nil
        DEFAULT_PROPERTIES[typeModel][subTypeModel] = nil
        ADJUSTMENT_PROPERTIES[typeModel][subTypeModel] = nil
    else
        for key, value in pairs(MODEL_LIST) do
            if  value.typeModel == typeModel then
                key["LibScalingSetModel"] = nil
                MODEL_LIST[key] = nil   
            end
        end

        CONTROL_MODEL_TYPE[typeModel] = nil
        DEFAULT_PROPERTIES[typeModel] = nil
        ADJUSTMENT_PROPERTIES[typeModel] = nil   
    end

    return true
end

function LibScaling:ClearAll()
    for key, _ in pairs(CONTROL_MODEL_TYPE) do
        self:RemoveModelType(key)
    end
end

--[----------------------------------------------------------------------------------------------------------------------------------]

function LibScaling:RegisterModel(typeModel, subTypeModel, frameModel)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":RegisterModel(typeModel, subTypeModel, frameModel, unit) - typeModel must be string, got "..type(typeModel)) 
    end

    if subTypeModel and type(subTypeModel) ~= "string" then 
        error(MAJOR..":RegisterModel(typeModel, subTypeModel, frameModel, unit) - subTypeModel must be string, got "..type(subTypeModel)) 
    end

    if type(frameModel) ~= "table" then 
        error(MAJOR..":RegisterModel(typeModel, subTypeModel, frameModel, unit) - frameModel must be object, got "..type(frameModel)) 
    end

    typeModel = typeModel:upper() 
    if not CONTROL_MODEL_TYPE[typeModel] or not DEFAULT_PROPERTIES[typeModel] or  not CONTROL_MODEL_TYPE[typeModel][subTypeModel] or not DEFAULT_PROPERTIES[typeModel][subTypeModel] then 
        return false 
    end

    if CONTROL_MODEL_TYPE[typeModel]["SubTypes"] then
        subTypeModel = subTypeModel:upper()
        
        local findSubType = false
        for _, subType in ipairs(CONTROL_MODEL_TYPE[typeModel]["SubTypes"]) do
            if subType == subTypeModel then
                findSubType = true
            end
        end

        if not findSubType then 
            return false 
        end
    end

    local typeObject = frameModel:GetObjectType()
    if CONTROL_MODEL_TYPE[typeModel]["Limit"][typeObject] then
        if not MODEL_LIST[frameModel] then MODEL_LIST[frameModel] = {} end

        MODEL_LIST[frameModel].TypeModel = typeModel
        MODEL_LIST[frameModel].SubTypeModel = subTypeModel
        MODEL_LIST[frameModel].Default = DEFAULT_PROPERTIES[typeModel][subTypeModel] 
        MODEL_LIST[frameModel].Adjustment = ADJUSTMENT_PROPERTIES[typeModel][subTypeModel]
        
        frameModel["LibScalingGetModel"] = CONTROL_MODEL_TYPE[typeModel]["Models"][subTypeModel]
        frameModel["LibScalingSetModel"] = CONTROL_MODEL_TYPE[typeModel]["SetModel"]

        MODEL_LIST[frameModel].ApplyScaling = CONTROL_MODEL_TYPE[typeModel]["SetScaling"]
        return true
    end

    return false
end

function LibScaling:DeleteModel(frameModel)
    if MODEL_LIST[frameModel] then 
        MODEL_LIST[frameModel] = nil
        frameModel["LibScalingSetModel"] = nil

        return true 
    end

    return false
end

function LibScaling:SetModel(model)
    local info = MODEL_LIST[model]
    if info then
        model:LibScalingSetModel(model)

        local id = model:GetModelFileID()
        if id then
            local properties = GetModelProperties(info.Default, info.Adjustment, id)

            for func, info in pairs(info.ApplyScaling) do
                if model[func] then
                    model[func](model, properties[info.arg1], properties[info.arg2], properties[info.arg3], properties[info.arg4])
                end
            end
        end
    end
end

function LibScaling:SetModels(...)
    local models = {...}
    for i, model in ipairs(models) do
        self:SetModel(model)
    end
end

local function CheckStateModel(model, mode)
    if not mode or LibScaling.ModelSetByTypeMode.ALL == mode then return true end

    if LibScaling.ModelSetByTypeMode.SHOW == mode then
        return model:IsShown()
    elseif LibScaling.ModelSetByTypeMode.NOTSHOW == mode then
        return not model:IsShown()
    elseif LibScaling.ModelSetByTypeMode.VISIBLE == mode then
        return model:IsVisible()
    elseif LibScaling.ModelSetByTypeMode.NOTVISIBLE == mode then
        return not model:IsVisible()
    end
end

function LibScaling:SetModelsByType(typeModel, subTypeModel, mode)
    for model, info in pairs(MODEL_LIST) do
        if info.TypeModel == typeModel and (subTypeModel and info.SubTypeModel == subTypeModel or not subTypeModel) then
            if CheckStateModel(model, mode) then
                self:SetModel(model)
            end
        end
    end
end