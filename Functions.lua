local Module = {}
Module.Storadow = {}
Module.FTI = {}
Module.GetService = {}

setmetatable(Module.GetService, {
    __index = function(Self, Index)
        return game:GetService(tostring(Index))
    end
})

local Storadow = Module.Storadow
local Service = Module.GetService
local Client = Service.Players.LocalPlayer

function Module:DisableConnections(connection)
    pcall(function()
        for i, v in pairs(getconnections(connection)) do
            v:Disable()
        end
    end)
end

function Module:GetPlayerFromShortenedName(name)
    for i, v in pairs(Service.Players:GetPlayers()) do
        if v ~= Client then
            if string.sub(string.lower(v.Name), 1, #name) == string.lower(name) then
                return v
            end
        end
    end
end

function Module:Maid()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/a8a2d2c1ffcf6288ec8d66f65cea593061ba2cf0/Modules/Shared/Events/Maid.lua'))();
end

function Module:Fail(reason)
    return Client:Kick(reason)
end

function Module:Check(obj, t)
    if type(obj) == t then
        return true
    else
        return Module:Fail('Error: Failed to find' .. tostring(t) .. ' "' .. tostring(obj) .. '".')
    end
end

-- STORADOW
local OldHash = 'cce55403f8757d8e0e90f3bbcc916b10caf3ea151b0872c2635fc564e89de3cb90fe2791833f88a1bfc66de68fbeb27e'

function Storadow:GetDependencies()
    local RS = Service.ReplicatedStorage
    local GCE = RS:WaitForChild('GCE', 5)
    local GCR = RS:WaitForChild('GCR', 5)
    local Script

    Module:Check(getupvalues, 'function')
    Module:Check(setupvalue, 'function')
    Module:Check(getconstants, 'function')
    Module:Check(getconnections, 'function')
    Module:Check(getgc, 'function')

    if not GCR or not GCE then
        return Module:Fail('Failed to find game dependencies.')
    end

    Module:DisableConnections(Service.ScriptContext.Error)
    Module:DisableConnections(Service.LogService.MessageOut)

    for i, v in pairs(getgc()) do
        if type(v) == 'function' then
            if #getupvalues(v) == 12 and #getconstants(v) == 130 then
                Script = getfenv(v).script
            end
        end
    end

    if not Script then return Module:Fail('Failed to fetch Anti-Cheat script.') end

    return table.unpack({GCE, GCR, Script})
end

function Storadow:InitBypass()
    Module:DisableConnections(Service.ScriptContext.Error)
    Module:DisableConnections(Service.LogService.MessageOut)

    local GCE, GCR, Script = Storadow:GetDependencies()

    for i, v in pairs(getgc()) do
        if type(v) == 'function' then
            if #getupvalues(v) == 12 and #getconstants(v) == 130 then
                for i = 1, #getupvalues(v) do
                    setupvalue(v, i, function() return wait(9e9) end)
                end
            end
        end
    end

    repeat wait() until Script

    GCR.OnClientInvoke = function()
        return table.unpack({ Client, {false, 1 , 1 , 1 , Script} })
    end

    GCE.OnClientEvent:Connect(function(a1, a2)
        if a1 == 1 and type(a2) == "string" then
            GCE:FireServer(a1, a2)
        end
    end)

    Service.StarterGui:SetCore("SendNotification",{
		Title = "rkane";
		Text = "Successfully bypassed.";
    })
end

function Storadow:Execute()
    local GCE, GCR, Script = Storadow:GetDependencies()
    local NewHash = getscripthash(Script)

    if not NewHash == OldHash then
        local Listener = Instance.new('BindableFunction')

        Listener.OnInvoke = function(Selected)
            if Selected == 'Ok' then
                Storadow:InitBypass()
            end
        end

        Service.StarterGui:SetCore("SendNotification",{
            Title = "rkane";
            Text = "Anti-Cheat Script has been updated. This bypass may not work. Are you sure you want to continue?";
            Duration = 10;
            Callback = Listener;
            Button1 = "Ok";
            Button2 = "Cancel"
        })
    else
        Storadow:InitBypass()
    end
end
-- END OF STORADOW

-- FTI FRAME
local FTI = Module.FTI

function FTI:Hit(Handle, Character)
    for i, v in pairs(Character:GetChildren()) do
        if v:IsA('BasePart') then
            firetouchinterest(Handle, v, 0)
            firetouchinterest(Handle, v, 1)
        end
    end
end

function FTI:Frame(VictimName)
    local VictimPlayer = Module:GetPlayerFromShortenedName(VictimName)
    if VictimPlayer then
        local Character = VictimPlayer.Character
        if Character then
            local Tool = Character:FindFirstChildOfClass("Tool")
            if Tool then
                local Handle = Tool.Handle
                if Handle then
                    FTI:Hit(Handle, Client.Character)
                end
            end
        end
    end
end


-- END OF FTI FRAME

return Module