local HttpService = game:GetService("HttpService")
local Config = require(game.ReplicatedStorage.Lui.config.config)

local Save = {}

function Save:Load()
    if not isfile(Config.Save.File) then
        return {}
    end
    return HttpService:JSONDecode(readfile(Config.Save.File))
end

function Save:Write(data)
    writefile(Config.Save.File, HttpService:JSONEncode(data))
end

return Save
