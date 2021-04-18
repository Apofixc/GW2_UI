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

    if SubClassName and CLASS_MODEL[ClassName] and CLASS_MODEL[ClassName]["SubTypes"][SubClassName] then
        for key, value in pairs(MODEL_LIST) do
            if value.ClassName == ClassName and value.SubClassName == SubClassName then
                self:DeleteModel(key)
            end
        end

        CLASS_MODEL[ClassName]["SubClass"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Models"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Default"][SubClassName] = nil
        CLASS_MODEL[ClassName]["Offset"][SubClassName] = nil

        return true
    elseif CLASS_MODEL[ClassName] then
        for key, value in pairs(MODEL_LIST) do
            if  value.ClassName == ClassName then
                self:DeleteModel(key)
            end
        end

        CLASS_MODEL[ClassName] = nil

        return true
    end

    return false
end

function ModelsManagementLib:ClearAll()
    for key, _ in pairs(CLASS_MODEL) do
        self:RemoveClassOrSubClassModel(key)
    end
end

function ModelsManagementLib:RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName) - ClassName must be string, got "..type(ClassName)) 
    end

    if type(SubClassName) ~= "string" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName) - SubClassName must be string, got "..type(SubClassName)) 
    end

    if type(FrameModel) ~= "table" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName) - FrameModel must be object, got "..type(FrameModel)) 
    end

    if Name and type(Name) ~= "table" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName) - Name must be object, got "..type(Name)) 
    end

    if GetName and type(GetName) ~= "function" then 
        error(MAJOR..":RegisterModel(ClassName, SubClassName, FrameModel, Name, GetName) - Name must be function, got "..type(GetName)) 
    end

    ClassName = ClassName:upper() 
    SubClassName = SubClassName:upper()
    if not CLASS_MODEL[ClassName] or CLASS_MODEL[ClassName] and not CLASS_MODEL[ClassName]["SubClass"][SubClassName] then 
        return false 
    end

    if  not tContains(CLASS_MODEL[ClassName]["Limit"], FrameModel.GetObjectType and FrameModel:GetObjectType() or nil) or Name and Name.GetObjectType and Name:GetObjectType() ~= "FontString" then 
        return false 
    end

    if not MODEL_LIST[FrameModel] then MODEL_LIST[FrameModel] = {} end

    MODEL_LIST[FrameModel]["ClassName"] = ClassName
    MODEL_LIST[FrameModel]["SubClassName"] = SubClassName
    MODEL_LIST[FrameModel]["Default"] = CLASS_MODEL[ClassName]["Default"][SubClassName]
    MODEL_LIST[FrameModel]["Offset"] = CLASS_MODEL[ClassName]["Offset"][SubClassName]
    MODEL_LIST[FrameModel]["Name"] = Name

    FrameModel["LibScalingGetModelInfo"] = CLASS_MODEL[ClassName]["Models"][SubClassName]
    FrameModel["LibScalingSetModel"] = CLASS_MODEL[ClassName]["SetModel"]
    FrameModel["LibScalingGetModelGetName"] = GetName

    MODEL_LIST[FrameModel]["ApplyScaling"]= CLASS_MODEL[ClassName]["SetScaling"]

    return true
end

function ModelsManagementLib:DeleteModel(FrameModel)
    if MODEL_LIST[FrameModel] then 
        MODEL_LIST[FrameModel] = nil
        FrameModel["LibScalingSetModel"] = nil
        FrameModel["LibScalingGetModelInfo"] = nil
        FrameModel["LibScalingGetModelGetName"] = nil

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
        local infoModel = Model:LibScalingGetModelInfo(Model)
        Model:LibScalingSetModel(unpack(infoModel))

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
    if Model.LibScalingGetModelGetName then
        local unit = Model:LibScalingGetModelGetName()
        if type(unit) == "string" then
            return unit
        else
            return UNKNOWN
        end       
    else
        return nil
    end
end

function ModelsManagementLib:SetModelName(Model)
    local info = MODEL_LIST[Model]
    if info and info.Name then
        info.Name:SetText(self:GetModelName(Model))
    end
end

function ModelsManagementLib:SetModelsName(...)
    local models = {...}
    for i, model in ipairs(models) do
        self:SetModelName(model)
    end
end

-------------------------------------------------------------Animation--------------------------------------------------------------------------

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

function ModelsManagementLib:CreateClassAnimation(ClassName, ...)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":CreateClassAnimation(ClassName, ...) - ClassName must be string, got "..type(ClassName)) 
    end

    if not CLASS_MODEL[ClassName] or CLASS_MODEL[ClassName] and tContains(CLASS_MODEL[ClassName]["Limit"], "Model") then
        return false
    end

    local count = select("#", ...)
    if count%2 == 1 then
        return false
    end

    for i = 1, count, 2 do
        local SubClassName = select(i, ...)
        if type(SubClassName) ~= "string" then 
            error(MAJOR..":CreateClassAnimation(ClassName, ...) - SubClass must be string, got "..type(SubClassName)) 
        end

        local Reaction = select(i + 1, ...)
        if type(Reaction) ~= "table" then 
            error(MAJOR..":CreateClassAnimation(ClassName, ...) - Reaction must be table, got "..type(Reaction)) 
        end

        if CLASS_MODEL[ClassName]["SubClass"][SubClassName] then
            if not CLASS_MODEL[ClassName]["Animation"] then 
                CLASS_MODEL[ClassName]["Animation"] = {} 
            end

            CLASS_MODEL[ClassName]["Animation"][SubClassName] = Reaction
        end
    end

    CLASS_MODEL[ClassName]["Sync"] = count > 2

    return true
end

function ModelsManagementLib:RegisterAnimation(FrameModel)
    if  MODEL_LIST[FrameModel] and tContains(CLASS_MODEL[MODEL_LIST[FrameModel]["ClassName"]]["Limit"], "Model") or MODEL_LIST[FrameModel]["Animation"] then
        return false
    end

    MODEL_LIST[FrameModel]["Animation"] = true
    MODEL_LIST[FrameModel]["Sync"] = false

    return true
end

local function clone(T, except)
    local u = { }
    for k, v in pairs(T) do 
        if k ~= except then
           u[k] = v          
        end
    end

    return u
end

local function OnAnimFinished(self)
    if self.SyncAnimActive then
        self.SyncAnimActive = nil
    end
    
end

function ModelsManagementLib:RegisterSyncAnimation(ClassName, ...)
    if type(ClassName) ~= "string" then 
        error(MAJOR..":RegisterAnimation(ClassName, ...) - ClassName must be string, got "..type(ClassName)) 
    end

    if not CLASS_MODEL[ClassName]["Animation"] or not CLASS_MODEL[ClassName]["Sync"] then
        return false
    end

    local sync = {}
    local count = select("#", ...)
    for i = 1, count do
        local FrameModel = select(i, ...)

        if MODEL_LIST[FrameModel]["ClassName"] == ClassName and CLASS_MODEL[ClassName]["Animation"][MODEL_LIST[FrameModel]["SubClassName"]] and not MODEL_LIST[FrameModel]["Animation"] then
            sync[FrameModel] = true 
        end
    end

    if not next(sync) then
        return false     
    end

    for FrameModel, _ in pairs(sync) do
        MODEL_LIST[FrameModel]["Animation"] = true
        MODEL_LIST[FrameModel]["Sync"] = true
        MODEL_LIST[FrameModel]["Reaction"] = CLASS_MODEL[ClassName]["Animation"][MODEL_LIST[FrameModel]["SubClassName"]] 
        MODEL_LIST[FrameModel]["SyncFrame"] = clone(sync, FrameModel)
       
        FrameModel:SetScript("OnAnimFinished", OnAnimFinished)
    end

    return true
end

function ModelsManagementLib:SetAnimation(FrameModel, AnimationID)
    if not MODEL_LIST[FrameModel] or not MODEL_LIST[FrameModel]["Animation"] or not FrameModel:HasAnimation(AnimationID) then
        return false
    end

    FrameModel:SetAnimation(AnimationID)

    if MODEL_LIST[FrameModel]["Sync"] then
        for syncFrameModel, _ in pairs(MODEL_LIST[FrameModel]["SyncFrame"]) do
            syncFrameModel.SyncAnimActive = true
            syncFrameModel:SetAnimation(MODEL_LIST[syncFrameModel]["Reaction"][AnimationID])
        end
    end

    return true
end

