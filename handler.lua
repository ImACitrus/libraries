local lib = {}

--[[
    Modules can only be fetched via user / replicatedStorage;
    -- Any modules outside this area wouldn't be picked up,
    -- however this can easily be changed in code.

    [TUTORIAL]:
    local module_handler = loadstring(game:HttpGet(""))()
    local modules = module_handler:FetchModules()

    local ThrowData = modules:InList("ThrowObjects") and modules:Load("ThrowObjects")
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local PlayerScripts = Player:WaitForChild("PlayerScripts")
local Character = Player.Character

function lib:FetchModules()
    local paths = { ReplicatedStorage, PlayerScripts, Character }
    local self = setmetatable({}, lib)
    self.modules = {}
    for i = 1, #paths do
        for _, v in next, paths[i]:GetDescendants() do
            if v and v:IsA("ModuleScript") then
                self.modules[v.Name] = v
            end
        end
    end
    return self
end

function lib:InList(module_name)
    return table.find(self.modules, module_name) ~= nil
end

function lib:Load(module_name, callback)
    if callback then
        callback(require(self.modules[module_name]))
    else
        return require(self.modules[module_name])
    end
end

return lib
