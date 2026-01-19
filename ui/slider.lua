local Slider = {}

function Slider:Create(min, max, callback)
    local value = min

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(120,20)

    local bar = Instance.new("TextButton", frame)
    bar.Size = UDim2.fromScale(1,1)

    bar.MouseButton1Down:Connect(function()
        value = math.random(min, max)
        callback(value)
    end)

    return frame
end

return Slider
