local Backend = {}

Backend.Elements = {}

function Backend:Register(name, obj)
    self.Elements[name] = obj
end

return Backend
