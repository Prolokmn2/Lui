local Hide = {}

function Hide:Obfuscate(str)
    local new = ""
    for _,c in ipairs(str:split("")) do
        new ..= string.char(string.byte(c) + math.random(3,12))
    end
    return new
end

return Hide
