local Save = {}
local JSON = {}

-- tiny JSON encode/decode for universal
function JSON:Encode(t)
    return game and game:GetService("HttpService"):JSONEncode(t) or "[]"
end
function JSON:Decode(str)
    return game and game:GetService("HttpService"):JSONDecode(str) or {}
end

function Save:Load()
    if isfile and isfile("LuiSave.json") then
        return JSON:Decode(readfile("LuiSave.json"))
    end
    return {}
end

function Save:Write(data)
    if writefile then
        writefile("LuiSave.json", JSON:Encode(data))
    end
end

return Save
