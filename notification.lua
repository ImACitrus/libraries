-- Services
local ReplicatedStorage = game.ReplicatedStorage
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Functions
local function LoadSlot(id)
	ReplicatedStorage ["LoadSaveRequests"] ["RequestLoad"]:InvokeServer(id, game.Players.LocalPlayer)
end
local sleep = task.wait

-- Instance related
new = function(Class, Parent)
	return Instance.new(Class, Parent)
end
stats = function(Object, Properties)
	if not Properties then return end
	for i, v in next, Properties do
		Object[i] = v
	end
end

-- Notification
function Notify(text, formatTxt)

	-- Variables
	local isAdded = CoreGui:FindFirstChild("timeLeft") ~= nil

	-- Ui
	local Gui = CoreGui:FindFirstChild("timeLeft") or new("ScreenGui", CoreGui)
	stats(Gui, {Name = "timeLeft"})

	-- Textlabel
	local Label = Gui:FindFirstChild("cooldown") or new("TextLabel", Gui)
	stats(Label, {
		Name = "cooldown",
		AnchorPoint = Vector2.new(0.5, 0.5),
    	Position = UDim2.fromScale(0.9, 1.2),
    	Size = UDim2.fromScale(0.13, 0.05),
		TextColor3 = Color3.fromRGB(255, 255, 255),
   		BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	})

	-- Additionals
	local Note = new("StringValue", Gui)
	stats(Note, {
		Name = "Note",
		Value = "Displays base-load request cooldown"
	})

	local UICorner = new("UICorner", Label)
	stats(UICorner, {
		Name = "UICorner",
		CornerRadius = UDim.new(0, 6)
	})

	local Textconstraint = new("UITextSizeConstraint", Label)
	stats(Textconstraint, {
		Name = "Textconstraint",
		MaxTextSize = 14,
    	MinTextSize = 8
	})

	-- Response
	return {
	    getSelf = function()
	    	return Label;
	    end,
	    prevadd = function()
	    	return isAdded
	    end,
	    setTextFromSelf = function(text, ...)
	    	if not text then return end;
	    	if not ... then
	    		Label.Text = text
	    	else
	    		Label.Text = (text):format(...)
	    	end
	    end,
	    open = function()
		    TweenService:Create(Label, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		        Position = UDim2.fromScale(0.9, 0.95)
		    }):Play()
	    end,
	    close = function()
	    	TweenService:Create(Label, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
	        	Position = UDim2.fromScale(0.9, 1.2)
	    	}):Play()
	    end,
	    remove = function(on_remove)
	    	on_remove()
	   		Label.Parent:Remove()
	   	end
   }

end

return { send = function(message, format) Notify(message, format) end, }
