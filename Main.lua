local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Prismovold/Hub/master/Library.lua'))();
local Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/Prismovold/Hub/master/Functions.lua'))();
local Module = {}

function Module:CreateToggleFlag(Window, Title, FlagName, DefaultValue, Callback)
    Window:Toggle(Title, DefaultValue, function(State)
        Flags[FlagName] = State;
        if Callback then
            Callback()
        end
    end)
end

function Module:CreateTextBoxFlag(Window, Title, FlagName, Callback)
    Window:Textbox(Title, true, function(State)
        Flags[FlagName] = State;
        if Callback then
            Callback()
        end
    end)
end

function Module:SFB()
    Functions.Storadow:Execute()
end

local Flag = {}
Flag.Toggle = Module.CreateToggleFlag
Flag.TextBox = ''

function Module:CustomDuels()
    local Window = Library:Window('rkane - Custom Duels',Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightShift)
    local MiscFrame = Window:Tab('Misc')

    Flag.Toggle(MiscFrame, 'Toggle Framing', 'FrameEnabled', false)
    Flag.TextBox(MiscFrame, 'Frame Victim', 'FrameVictim')

    local Maid = Functions:Maid()
    local MainMaid = Maid.new()

    MainMaid:GiveTask(Functions.GetService.RunService.Stepped:Connect(function()
        if Flags['FrameEnabled'] and Flags['FrameVictim'] then
            Functions.FTI:Frame(Flags['FrameVictim'])
        end
    end))
end

return Module;