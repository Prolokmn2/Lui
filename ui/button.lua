local Button = {}

function Button:Create(text, callback, parent)
    if game then
        local btn = Instance.new("TextButton")
        btn.Text = text
        btn.Size = UDim2.fromOffset(120,30)
        btn.Parent = parent
        btn.MouseButton1Click:Connect(callback)
        return btn
    else
        print("[UI BUTTON]", text, "(click triggers callback in console)")
        return {Click=function() callback() end}
    end
end

return Button
