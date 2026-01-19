local Players = game:GetService("Players")

local Info = {}

function Info:Get()
    local plr = Players.LocalPlayer
    return {
        name = plr.Name,
        userid = plr.UserId
    }
end

return Info
