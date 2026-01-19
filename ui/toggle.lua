local Toggle = {}

function Toggle:Create(default, callback)
    local state = default

    local btn = Instance.new("TextButton")
    btn.Text = state and "ON" or "OFF"

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return btn
end

return Toggle
