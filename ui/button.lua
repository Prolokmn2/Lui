local Button = {}

function Button:Create(text, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.fromOffset(120,30)

    btn.MouseButton1Click:Connect(function()
        callback()
    end)

    return btn
end

return Button
