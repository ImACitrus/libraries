local module = {}
module.__index = module

--[[
    attempts: adds 1 for each attempt (FAIL)
    closeAfterX: closes UI after X amount of attempts, put 0 if you dont want it. (FAILS)
]]

module.SETTINGS = {
    attempts = 0,
    closeAfterX = 0 
}

ignoreClose = module.SETTINGS.closeAfterX == 0

function module:Window(config)

    local Players = game:GetService("Players")

    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local Gui = PlayerGui:FindFirstChild("wl") or Instance.new("ScreenGui", PlayerGui)
    local body = Instance.new("Frame", Gui)

    local key = Instance.new("TextBox", body)
    local trigger = Instance.new("TextButton", body)

    Gui.Name = "wl"

    body.Name = "body"
    key.Name = "key"
    trigger.Name = "callback"
        
    body.Active = true
    body.Draggable = true
    body.AnchorPoint = Vector2.new(0.5, 0.5)
    body.Position = UDim2.fromScale(0.5, 0.5)
    body.Size = UDim2.fromOffset(400, 105)

    body.BorderSizePixel = 0

    key.Size = UDim2.fromOffset(378, 35)
    key.Position = UDim2.fromScale(0.027, 0.146)
        
    key.Text = ""
    key.PlaceholderText = _G.key or "Enter key"
    key.BorderSizePixel = 1
        
    trigger.Text = "Submit"
    trigger.Size = UDim2.fromOffset(378, 41)
    trigger.Position = UDim2.fromScale(0.027, 0.539)

    trigger.BorderSizePixel = 0
    trigger.FontSize = Enum.FontSize.Size18

    body.BackgroundColor3 = config and config.Properties and config.Properties.body or Color3.fromRGB(25, 25, 25)

    key.TextColor3 = config and config.Properties and config.Properties.key.textcolor or Color3.fromRGB(178, 178, 178)
    key.BackgroundColor3 = config and config.Properties and config.Properties.key.backgroundcolor or Color3.fromRGB(20, 20, 20)
    key.BorderColor3 = config and config.Properties and config.Properties.key.outlinecolor or Color3.fromRGB(15, 15, 15)

    trigger.TextColor3 = config and config.Properties and config.Properties.button.textcolor or Color3.fromRGB(229, 229, 229)
    trigger.BackgroundColor3 = config and config.Properties and config.Properties.button.backgroundcolor or Color3.fromRGB(35, 35, 35)

    local TweenService = game:GetService("TweenService")
    local self = setmetatable({}, module)
    
    function self:TweenState(obj, state)
        if string.lower(state) == "pressed" then
            local tween = TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0), {
                BackgroundColor3 = Color3.fromRGB(82, 134, 255)
            })
            tween:Play()
        elseif string.lower(state) == "successfull" then
            local tween = TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0), {
                BorderColor3 = Color3.fromRGB(33, 255, 40)
            })
            tween:Play()
        elseif string.lower(state) == "unsuccessfull" then
            local tween = TweenService:Create(obj, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true, 0), {
                BorderColor3 = Color3.fromRGB(250, 40, 100)
            })
            tween:Play()
        end
    end
    
    function self:LoadUlr(url)
        if not url or type(url) ~= "string" then return end;
        loadstring(game:HttpGet(url))()
    end

    return self

end

function module:onConnect(keys, callback)
    
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("wl")
    local body = gui:WaitForChild("body")
    local textbox = body:WaitForChild("key")
    local trigger = body:WaitForChild("callback")

    local user = game:GetService("Players").LocalPlayer
    trigger.MouseButton1Click:Connect(function()
        self:TweenState(trigger, "pressed")
        local Sub, Key = false, ""
        if not ignoreClose then module.SETTINGS.attempts = module.SETTINGS.attempts + 1 if module.SETTINGS.attempts >= module.SETTINGS.closeAfterX then return gui:Destroy(); end  end
        for _, v in next, keys do
            self.current = {
                Id = v.Id,
                Key = v.Key,
                Subscription = v.Subscription
            }
            if self.current.Id == user.UserId then
                if string.lower(self.current.Key) == string.lower(textbox.Text) then
                    if self.current.Subscription then
                        self:TweenState(textbox, "successfull");
                        task.wait(0.55)
                        gui:Destroy()
                        return callback(user, self.Subscription)
                    end
                else
                    self:TweenState(textbox, "unsuccessfull")
                    callback(user, self.Subscription)
                    continue
                end
            else
                self:TweenState(textbox, "unsuccessfull")
                callback(user, self.Subscription)
                continue
            end
        end
    end)
    self.logged = {
        user = user,
        keys = keys
    }

end

local win = module:Window()
local SETTINGS = module.SETTINGS

SETTINGS.closeAfterX = 0
keys = {
    {
        Id = 4112844200,
        Key = "0DAA43C3-F1FC-4D36-B415-0C43E3C1EF06",
        Subscription = true
    },
    {
        Id = 1361218435,
        Key = "46808E6C-E19A-4C58-933E-521E30945FE7",
        Subscription = true
    },
    {
        Id = 4215487093,
        Key = "0DAA43C3-F1FC-4D36-B415-0C43E3C1EF06",
        Subscription = true
    },
}

games = {
    [7708751418] = "https://raw.githubusercontent.com/ImACitrus/Smashing-Simulator-X/main/.lua"
}

win:onConnect(keys, function(user, hasSubscription)
    win:LoadUrl( games[game.PlaceId] )
end)
