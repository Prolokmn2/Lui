local Window = require(script.Parent.window)

local Init = {}

function Init:Start()
    local gui, frame = Window:Create("Lui Window")
    gui.Parent = game.CoreGui
    return frame
end

return Init
