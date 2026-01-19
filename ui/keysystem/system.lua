local Config = require(script.Parent.Parent.config.config)

local KeySystem = {}

function KeySystem:Validate(input)
    if not Config.Keysystem.Enabled then return true end

    local hashed = ""
    for i = 1, #Config.Keysystem.Key do
        hashed ..= string.char(string.byte(Config.Keysystem.Key:sub(i,i)) * Config.Keysystem.Multiplier)
    end

    local attempt = ""
    for i = 1, #input do
        attempt ..= string.char(string.byte(input:sub(i,i)) * Config.Keysystem.Multiplier)
    end

    return attempt == hashed
end

return KeySystem
