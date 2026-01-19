local Hide = {}

function Hide:Obfuscate(str)
    local new = ""
    for i = 1,#str do
        new ..= string.char(string.byte(str:sub(i,i)) + math.random(3,12))
    end
    return new
end

return Hide
