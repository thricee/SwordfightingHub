local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Prismovold/Hub/master/Library.lua'))();
local Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/Prismovold/Hub/master/Functions.lua'))();
local Module = {}

function Module:SFB()
    Functions.Storadow:Execute()
end

function Module:CustomDuels()
    local Window = Library:Window('rkane - Custom Duels',Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightShift)
    local MiscFrame = Window:Tab('Misc')

    MiscFrame:Toggle('Enable Framing', false, function(State)
        Flags['FramingEnabled'] = State;
    end)
    MiscFrame:Textbox('Frame Victim', true, function(State)
        Flags['FrameVictim'] = State;
    end)

    game:GetService('RunService').Stepped:Connect(function()
        if Flags['FrameEnabled'] and Flags['FrameVictim'] then
            Functions.FTI:Frame(Flags['FrameVictim'])
        end
    end)
end

return Module;