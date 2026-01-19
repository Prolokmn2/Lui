local Players = game:GetService("Players")

local PlayerInfo = {}

function PlayerInfo:Get()
    local plr = Players.LocalPlayer
    return {
        name = plr.Name,
        display = plr.DisplayName
    }
end

return PlayerInfo
