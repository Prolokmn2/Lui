local Key = {}

function Key:Prompt()
    print("Enter key:")
    return io.read() -- works in UNC / console, ignored in Studio
end

return Key
