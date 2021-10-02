local Module = {}
Module.Storadow = {}
Module.GetService = {}

setmetatable(Module.GetService, {
    __index = function(Self, Index)
        return game:GetService(tostring(Index))
    end
})

local Storadow = Module.Storadow
local Service = Module.GetService
local Client = Service.Players.LocalPlayer

function Module:DisableConnection(connection)
    pcall(function()
        for i, v in pairs(getconnections(connection)) do
            v:Disable()
        end
    end)
end

function Module:Fail(reason)
    Client:Kick(reason)
end

function Module:Check(obj, t)
    if type(obj) == t then
        return true
    else
        Module:Fail('Error: Couldn\'t find function "' .. tostring(obj) .. '".')
    end
end

-- STORADOW
function Storadow:GetDependencies()
    local RS = Service.ReplicatedStorage
    local GCE = RS:WaitForChild('GCE', 5)
    local GCR = RS:WaitForChild('GCR', 5)
    
    Module:Check(getconnections)
end

function Storadow:InitBypass()

end
-- END OF STORADOW

return Module