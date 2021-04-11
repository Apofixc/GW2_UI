local MAJOR, MINOR = "ModelScaling", 1 -- 9.2.0 v2 / increase manually on changes
local LibScaling = LibStub:NewLibrary(MAJOR, MINOR)
if not LibScaling then return end

local MODEL_LIST = {}
local SupportModel = {["Model"] = true, ["PlayerModel"] = true, ["CinematicModel"] = true, ["DressUpModel"] = true, ["TabardModel"] = true,}

LibScaling.TypeDataBase            = LibScaling.TypeDataBase       or {}
LibScaling.ModelSetByTypeMode      = LibScaling.ModelSetByTypeMode or {}

LibScaling.TypeDataBase.DEFAULT_PROPERTIES    = "DEFAULT_PROPERTIES" 
LibScaling.TypeDataBase.ADJUSTMENT_PROPERTIES = "ADJUSTMENTN_PROPERTIES" 

LibScaling.ModelSetByTypeMode.ALL = "ALL"
LibScaling.ModelSetByTypeMode.SHOW = "SHOW"
LibScaling.ModelSetByTypeMode.NOTSHOW = "NOTSHOW"
LibScaling.ModelSetByTypeMode.VISIBLE = "VISIBLE"
LibScaling.ModelSetByTypeMode.NOTVISIBLE  = "NOTVISIBLE"

local CONTROL_MODEL_TYPE = {
    ["FULLMODEL"] = {
        ["SubTypes"] = {"LEFT", "RIGHT"},
        ["Limit"] = {["CinematicModel"] = true},
        ["SetScaling"] = {
            ["SetFacingLeft"] = {arg1 = "FacingLeft"}, 
            ["InitializeCamera"] = {arg1 = "Camera"}, 
            ["SetTargetDistance"] = {arg1 = "TargetDistance"}, 
            ["SetHeightFactor"] = {arg1 = "HeightFactor"}, 
            ["SetFacing"] = {arg1 = "Facing"}
        }
    },
    ["PORTRAIT"] = {
        ["SubTypes"] = {["LEFT"] = true, ["RIGHT"] = true },
        ["Limit"] = {["CinematicModel"] = true, ["PlayerModel"] = true},
        ["SetScaling"] = {
            ["SetFacingLeft"] = {arg1 = "FacingLeft"}, 
            ["InitializeCamera"] = {arg1 = "Camera"}, 
            ["SetTargetDistance"] = {arg1 = "TargetDistance"}, 
            ["SetHeightFactor"] = {arg1 = "HeightFactor"}, 
            ["SetFacing"] = {arg1 = "Facing"}
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
            Camera = 1.55, 
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

local function MergeTable(t1, t2)
    for key1, value1 in pairs(t2) do
        for key2, value2 in pairs(value1) do
            t1[key1][key2] = value2
        end
    end

	return t1
end

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

function LibScaling:UpdateControl(typeModel, control)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":UpdateControl(typeModel, control) - typeModel must be string, got "..type(typeModel)) 
    end

    if type(control) ~= "table" then 
        error(MAJOR..":UpdateControl(typeModel, control) - control must be table, got "..type(control)) 
    end

    if not CONTROL_MODEL_TYPE[typeModel] then return false end

    MergeTable(CONTROL_MODEL_TYPE[typeModel], control)

    return true
end

function LibScaling:UpdateDefault(typeModel, default)
    if type(typeModel) ~= "string" then 
        error(MAJOR.."UpdateDefault(typeModel, default) - typeModel must be string, got "..type(typeModel)) 
    end

    if type(default) ~= "table" then 
        error(MAJOR..":UpdateDefault(typeModel, default) - control must be table, got "..type(default)) 
    end

    if not DEFAULT_PROPERTIES[typeModel] then return false end

    MergeTable(DEFAULT_PROPERTIES[typeModel], default)

    return true
end

function LibScaling:UpdateAdjusment(typeModel, adjustment)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":UpdateAdjusment(typeModel, adjustment) - typeModel must be string, got "..type(typeModel)) 
    end

    if type(adjustment) ~= "table" then 
        error(MAJOR..":UpdateAdjusment(typeModel, adjustment) - control must be table, got "..type(adjustment)) 
    end

    if not DEFAULT_PROPERTIES[typeModel] then return false end
    if not ADJUSTMENT_PROPERTIES[typeModel] then ADJUSTMENT_PROPERTIES[typeModel] = {} end

    MergeTable(ADJUSTMENT_PROPERTIES[typeModel], adjustment)

    return true
end

function LibScaling:RegisterNewModelType(typeModel, control, default, adjustment)
    if type(typeModel) ~= "string" then 
        error(MAJOR..":RegisterControl(typeModel, control, update) - typeModel must be string, got "..type(typeModel)) 
    end

    if type(control) ~= "table" then 
        error(MAJOR..":RegisterControl(typeModel, control, update) - control must be table, got "..type(control)) 
    end

    if type(default) ~= "table" then 
        error(MAJOR..":RegisterDefault(typeModel, default, update) - control must be table, got "..type(default)) 
    end

    if type(adjustment) ~= "table" then 
        error(MAJOR..":RegisterAdjusment(typeModel, adjustment, update) - control must be table, got "..type(adjustment)) 
    end

    if CONTROL_MODEL_TYPE[typeModel] and DEFAULT_PROPERTIES[typeModel] then return false end
    if adjustment and ADJUSTMENT_PROPERTIES[typeModel] then return false end

    if control["SubTypes"] and type(control["SubTypes"]) ~= "table" then return false end
    if not control["Limit"] or control["Limit"] and type(control["Limit"]) ~= "table" then return false end
    if not control["SetScaling"] or control["SetScaling"] and type(control["SetScaling"]) ~= "table" then return false end

    for _, SubType in pairs(control["SubTypes"]) do
        if not default[SubType] or adjustment and not adjustment[SubType] then return false end
    end

    for _, args in pairs(control["SetScaling"]) do
        for _, arg in pairs(args) do
            if control["SubTypes"] and #control["SubTypes"] > 0 then
                for _, SubType in pairs(control["SubTypes"]) do
                    if not default[SubType][arg] then return false end
                end      
            else
                if default[arg] then return false end
            end
        end
    end

    CONTROL_MODEL_TYPE[typeModel] = control
    DEFAULT_PROPERTIES[typeModel] = default
    ADJUSTMENT_PROPERTIES[typeModel] = adjustment

    return true
end

function LibScaling:RemoveModelType(typeModel)
    if type(typeModel) ~= "string" then 
        error(MAJOR.."RemoveModelType(typeModel) - typeModel must be string, got "..type(typeModel)) 
    end

    for key, value in pairs(MODEL_LIST) do
        if  value.typeModel == typeModel then
            MODEL_LIST[key] = nil
        end
    end

    CONTROL_MODEL_TYPE[typeModel] = nil
    DEFAULT_PROPERTIES[typeModel] = nil
    ADJUSTMENT_PROPERTIES[typeModel] = nil

    return true
end

function LibScaling:ClealAll()
    MODEL_LIST = {}
    CONTROL_MODEL_TYPE = {}
    DEFAULT_PROPERTIES = {}
    ADJUSTMENT_PROPERTIES = {}
end

LibScaling.SetPlayer = function(model)
    model:ClearModel()
    model:SetUnit("player") 
    
    return model:GetModelFileID()
end

LibScaling.SetTarget = function(model)
    model:ClearModel()

    if UnitExists("target") and not UnitIsUnit("player", "npc") then
        model:SetUnit("target") 
    else
        model:SetUnit("none") 
    end

    return model:GetModelFileID()
end

LibScaling.SetNPC = function(model)
    model:ClearModel()

    if UnitExists("questnpc") then
        model:SetUnit("questnpc") 
    elseif UnitExists("npc") then 
        model:SetUnit("npc") 
    else
        model:SetUnit("none") 
    end

    return model:GetModelFileID() 
end

function LibScaling:RegisterModel(frameModel, typeModel, subTypeModel, unit)
    if type(frameModel) ~= "table" then 
        error(MAJOR..":RegisterModel(frameModel, typeModel, subTypeModel, unit) - frameModel must be object, got "..type(frameModel)) 
    end

    if type(typeModel) ~= "string" then 
        error(MAJOR..":RegisterModel(frameModel, typeModel, subTypeModel, unit) - typeModel must be string, got "..type(typeModel)) 
    end
   
    if subTypeModel and type(subTypeModel) ~= "string" then 
        error(MAJOR..":RegisterModel(frameModel, typeModel, subTypeModel, unit) - subTypeModel must be string, got "..type(subTypeModel)) 
    end

    if type(unit) ~= "function" and type(unit) ~= "number" then 
        error(MAJOR..":RegisterModel(frameModel, typeModel, subTypeModel, unit) - unit must be function/ number, got "..type(unit)) 
    end

    typeModel = typeModel:upper() 
    if not CONTROL_MODEL_TYPE[typeModel] and not DEFAULT_PROPERTIES[typeModel] then return false end
    if not CONTROL_MODEL_TYPE[typeModel]["SubTypes"] and not subTypeModel then return false end

    local findSubType = false
    subTypeModel = subTypeModel:upper()
    for _, subType in ipairs(CONTROL_MODEL_TYPE[typeModel]["SubTypes"]) do
        if subType == subTypeModel then
            findSubType = true
        end
    end
    if not findSubType then return false end

    if not MODEL_LIST[frameModel] then MODEL_LIST[frameModel] = {} end
    MODEL_LIST[frameModel].TypeModel = typeModel
    MODEL_LIST[frameModel].SubTypeModel = subTypeModel
    MODEL_LIST[frameModel].SetUnit = unit
    MODEL_LIST[frameModel].Default = DEFAULT_PROPERTIES[typeModel][subTypeModel] or DEFAULT_PROPERTIES[typeModel]
    MODEL_LIST[frameModel].Adjustment = ADJUSTMENT_PROPERTIES[typeModel] and ADJUSTMENT_PROPERTIES[typeModel][subTypeModel] or ADJUSTMENT_PROPERTIES[typeModel]
    MODEL_LIST[frameModel].ApplyScaling = CONTROL_MODEL_TYPE[typeModel]["SetScaling"]

    return true
end

function LibScaling:DeleteModel(frameModel)
    if MODEL_LIST[frameModel] then 
        MODEL_LIST[frameModel] = nil

        return true 
    end

    return false
end

function LibScaling:SetModel(model)
    local info = MODEL_LIST[model]
    if info then
        local id = info.SetUnit(model)
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

function LibScaling:SetModelsByType(typeModel, mode)
    for model, info in pairs(MODEL_LIST) do
        if info.TypeModel == typeModel and CheckStateModel(model, mode) then
            self:SetModel(model)
        end
    end
end