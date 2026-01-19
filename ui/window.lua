local Window = {}

function Window:Create(title)
    local gui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromOffset(300,200)

    local label = Instance.new("TextLabel", frame)
    label.Text = title

    return gui, frame
end

return Window
