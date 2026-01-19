local Config = require(game.ReplicatedStorage.Lui.config.config)

local KeySystem = {}

function KeySystem:Validate(input)
    if not Config.Keysystem.Enabled then
        return true
    end

    local hashed = ""
    for i,v in ipairs(Config.Keysystem.Key:split("")) do
        hashed ..= string.char(string.byte(v) * Config.Keysystem.Multiplier)
    end

    local attempt = ""
    for i,v in ipairs(input:split("")) do
        attempt ..= string.char(string.byte(v) * Config.Keysystem.Multiplier)
    end

    return attempt == hashed
end

return KeySystem
