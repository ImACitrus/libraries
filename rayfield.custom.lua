local lib = {}
lib.__index = lib

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local window_data = {
    Name = "Sample",
    LoadingTitle = "",
    LoadingSubtitle = "",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil,
       FileName = ""
    },
    Discord = {
       Enabled = false,
       Invite = "",
       RememberJoins = false
    },
    KeySystem = false,
    KeySettings = {
       Title = "",
       Subtitle = "",
       Note = "",
       FileName = "",
       SaveKey = false,
       GrabKeyFromSite = false,
       Key = ""
    }
}

function lib.window(v)
    local self = setmetatable({}, lib)

    for i, v in next, window_data do
        pcall(function()
            if v[i] then
                window_data[i] = t[i]
            end
        end)
    end
    
    self.window = library:CreateWindow(window_data)
    function self:DeleteUi()
        library:Destroy()
    end

    return self
end

function lib:Tab(Name)
    self.tab = self.window:CreateTab(Name)
    return self
end

function lib:Section(Name, content)
    self.section = self.tab:CreateSection(Name)
    local sections = {}
    local Types = {
        button = function(v)
            if v.Type then v.Type = nil end
            table.insert(self.section:CreateButton(v))
        end,
        toggle = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateToggle(v))
        end,
        colorpicker = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateColorPicker(v))
        end,
        slider = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateSlider(v))
        end,
        input = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateInput(v))
        end,
        dropdown = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateDropdown(v))
        end,
        keybind = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateKeybind(v))
        end,
        label = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateLabel(v))
        end,
        paragraph = function(v)
            if v.Type then v.Type = nil end
            table.insert(sections, self.tab:CreateParagraph(v))
        end
    }
    for _, v in next, content do
        pcall(function()
            Types[string.lower(v.Type)](v)
        end)
    end
    return sections
end

return lib
