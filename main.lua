-- TinyUI v1.0.2a Ultimate Revamped (loadstring-ready)
-- ~420 lines, single-file UI lib: Key system, Dev Mode, Tabs, Widgets, Backend API, visuals, autosize, tweening
-- Paste into Roblox Studio or run via loadstring(game:HttpGet(URL))()

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- safety: ensure this runs in Studio/Client only
if game:GetService("RunService"):IsServer() then
    warn("TinyUI: should be run on client (LocalScript/loadstring). Aborting.")
    return
end

local TinyUI = {}
TinyUI._windows = {}       -- internal windows list
TinyUI.DevMode = false
TinyUI._rootGuiName = "TinyUI_v1_0_2a_Revamped"

-- helper utilities
local Utils = {}

function Utils:newInstance(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

function Utils:applyUICorner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = object
    return c
end

function Utils:applyStroke(object, thickness, color)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = color or Color3.fromRGB(0,0,0)
    s.Parent = object
    return s
end

function Utils:tween(object, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local ok, t = pcall(function() return TweenService:Create(object, info, props) end)
    if ok and t then
        t:Play()
        return t
    end
    return nil
end

function Utils:isDescendantOfUI(obj)
    while obj and typeof(obj) == "Instance" do
        if obj.Name == TinyUI._rootGuiName then return true end
        obj = obj.Parent
    end
    return false
end

-- clear any existing root gui to avoid dupes
pcall(function()
    local existing = CoreGui:FindFirstChild(TinyUI._rootGuiName)
    if existing then existing:Destroy() end
end)

-- Root ScreenGui
local rootGui = Instance.new("ScreenGui")
rootGui.Name = TinyUI._rootGuiName
rootGui.ResetOnSpawn = false
rootGui.Parent = CoreGui

-- Key system GUI (modal) - returns chosen mode via closure
local function showKeyPrompt(callback)
    local gui = Utils:newInstance("ScreenGui", { Name = "__TinyUI_KeyPrompt", Parent = rootGui })
    local overlay = Utils:newInstance("Frame", {
        Size = UDim2.fromScale(1,1),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        Parent = gui
    })
    overlay.ZIndex = 0

    local frame = Utils:newInstance("Frame", {
        Size = UDim2.fromOffset(420,180),
        Position = UDim2.new(0.5, -210, 0.5, -90),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Parent = gui
    })
    frame.ZIndex = 2
    Utils:applyUICorner(frame, 12)
    Utils:applyStroke(frame, 1, Color3.fromRGB(10,10,10))

    local title = Utils:newInstance("TextLabel", {
        Size = UDim2.new(1,0,0,42),
        Position = UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        Text = "Enter Access Key",
        TextColor3 = Color3.fromRGB(245,245,245),
        Font = Enum.Font.GothamSemibold,
        TextSize = 20,
        Parent = frame
    })

    local subtitle = Utils:newInstance("TextLabel", {
        Size = UDim2.new(1,-24,0,20),
        Position = UDim2.new(0,12,0,44),
        BackgroundTransparency = 1,
        Text = "Use 'TESTER' for normal, 'DEV' for developer mode.",
        TextColor3 = Color3.fromRGB(170,170,170),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local input = Utils:newInstance("TextBox", {
        Size = UDim2.new(1,-40,0,40),
        Position = UDim2.new(0,20,0,70),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        TextColor3 = Color3.fromRGB(230,230,230),
        PlaceholderText = "Enter key here",
        Text = "",
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        TextSize = 18,
        Parent = frame
    })
    Utils:applyUICorner(input,8)

    local submit = Utils:newInstance("TextButton", {
        Size = UDim2.new(0,110,0,36),
        Position = UDim2.new(1,-130,1,-46),
        BackgroundColor3 = Color3.fromRGB(85,160,255),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = "Submit",
        Font = Enum.Font.GothamSemibold,
        TextSize = 18,
        Parent = frame
    })
    Utils:applyUICorner(submit,8)
    submit.AutoButtonColor = false

    local cancel = Utils:newInstance("TextButton", {
        Size = UDim2.new(0,80,0,36),
        Position = UDim2.new(1,-210,1,-46),
        BackgroundColor3 = Color3.fromRGB(70,70,70),
        TextColor3 = Color3.fromRGB(230,230,230),
        Text = "Cancel",
        Font = Enum.Font.Gotham,
        TextSize = 16,
        Parent = frame
    })
    Utils:applyUICorner(cancel,8)
    cancel.AutoButtonColor = false

    local function clean()
        pcall(function() gui:Destroy() end)
    end

    submit.MouseEnter:Connect(function() Utils:tween(submit, {BackgroundColor3 = Color3.fromRGB(110,190,255)}, 0.12) end)
    submit.MouseLeave:Connect(function() Utils:tween(submit, {BackgroundColor3 = Color3.fromRGB(85,160,255)}, 0.12) end)
    cancel.MouseEnter:Connect(function() Utils:tween(cancel, {BackgroundColor3 = Color3.fromRGB(90,90,90)}, 0.12) end)
    cancel.MouseLeave:Connect(function() Utils:tween(cancel, {BackgroundColor3 = Color3.fromRGB(70,70,70)}, 0.12) end)

    local function acceptKey()
        local key = tostring(input.Text or "")
        if key:upper() == "TESTER" then
            clean()
            callback("TESTER")
        elseif key:upper() == "DEV" then
            clean()
            callback("DEV")
        else
            input.Text = ""
            input.PlaceholderText = "Invalid key — try TESTER or DEV"
            Utils:tween(input, {BackgroundColor3 = Color3.fromRGB(120,40,40)}, 0.12)
            delay(0.25, function() Utils:tween(input, {BackgroundColor3 = Color3.fromRGB(40,40,40)}, 0.12) end)
        end
    end

    submit.MouseButton1Click:Connect(acceptKey)
    input.FocusLost:Connect(function(enter)
        if enter then acceptKey() end
    end)
    cancel.MouseButton1Click:Connect(function() clean(); callback(nil) end)
end

-- Core Window factory: returns Window object with API
function TinyUI:CreateWindow(opts)
    opts = opts or {}
    local Window = {}
    Window.Tabs = {}
    Window.widgets = {} -- list of widgets for metadata
    Window.Title = opts.Title or "TinyUI v1.0.2a"
    Window.Size = opts.Size or UDim2.fromOffset(520,420)
    Window.Position = opts.Position or UDim2.new(0.5,-260,0.5,-210)
    Window.Color = opts.Color or Color3.fromRGB(30,30,34)
    Window.BackgroundTransparency = opts.Transparency or 0
    Window.Draggable = opts.Draggable ~= false
    Window.CloseButton = opts.CloseButton ~= false

    -- create GUI
    local gui = Utils:newInstance("Frame", {
        Size = Window.Size,
        Position = Window.Position,
        BackgroundColor3 = Window.Color,
        BackgroundTransparency = Window.BackgroundTransparency,
        Parent = rootGui
    })
    gui.Name = ("Window_%s"):format(tostring(math.random(100000,999999)))
    Utils:applyUICorner(gui, 12)
    Utils:applyStroke(gui, 1, Color3.fromRGB(0,0,0))

    -- root container (frame)
    local frame = gui

    -- Titlebar
    local titleBar = Utils:newInstance("Frame", {
        Size = UDim2.new(1,0,0,36),
        Position = UDim2.new(0,0,0,0),
        BackgroundColor3 = Color3.fromRGB(44,44,48),
        Parent = frame
    })
    Utils:applyUICorner(titleBar, 10)

    local titleLabel = Utils:newInstance("TextLabel", {
        Size = UDim2.new(1,-60,1,0),
        Position = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1,
        Text = Window.Title,
        TextColor3 = Color3.fromRGB(245,245,245),
        Font = Enum.Font.GothamSemibold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    local closeBtn
    if Window.CloseButton then
        closeBtn = Utils:newInstance("ImageButton", {
            Size = UDim2.new(0,36,0,36),
            Position = UDim2.new(1,-44,0,0),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(170,60,60),
            Image = "",
            Parent = titleBar
        })
        local xlabel = Utils:newInstance("TextLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Text = "✕",
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            Parent = closeBtn
        })
        Utils:applyUICorner(closeBtn, 8)
        closeBtn.MouseEnter:Connect(function() Utils:tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(210,80,80)}, 0.14) end)
        closeBtn.MouseLeave:Connect(function() Utils:tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(170,60,60)}, 0.14) end)
        closeBtn.MouseButton1Click:Connect(function()
            pcall(function() frame:Destroy() end)
        end)
    end

    -- Tab bar
    local tabBar = Utils:newInstance("Frame", {
        Size = UDim2.new(1,0,0,36),
        Position = UDim2.new(0,0,0,36),
        BackgroundColor3 = Color3.fromRGB(38,38,42),
        Parent = frame
    })
    Utils:applyUICorner(tabBar, 10)

    -- tab content area
    local contentArea = Utils:newInstance("Frame", {
        Size = UDim2.new(1,0,1,-108),
        Position = UDim2.new(0,0,0,108),
        BackgroundTransparency = 1,
        Parent = frame
    })

    -- helper: recalc autosize height based on content of current tab
    local function autosizeWindow()
        -- compute max required height from visible tab children
        local maxY = 120
        for _, tab in ipairs(Window.Tabs) do
            if tab.Frame and tab.Frame.Visible then
                for _, child in ipairs(tab.Frame:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("Frame") or child:IsA("ImageLabel") then
                        local bottom = child.Position.Y.Offset + (child.Size.Y.Offset or 0)
                        if bottom > maxY then maxY = bottom end
                    end
                end
            end
        end
        local newHeight = math.max(220, maxY + 60)
        local target = UDim2.fromOffset(Window.Size.X.Offset, newHeight)
        Utils:tween(frame, {Size = target}, 0.18)
    end

    -- dragging via title bar only
    if Window.Draggable then
        local dragging, dragInput, startPos, startFramePos
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startPos = input.Position
                startFramePos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging=false end
                end)
            end
        end)
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - startPos
                frame.Position = UDim2.new(
                    startFramePos.X.Scale,
                    startFramePos.X.Offset + delta.X,
                    startFramePos.Y.Scale,
                    startFramePos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Tab creation function (fixed indexing + robust)
    function Window:AddTab(name)
        name = tostring(name or "Tab")
        local tab = {}
        tab.Name = name
        tab.Frame = Utils:newInstance("Frame", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Parent = contentArea
        })
        tab.Frame.Visible = false
        tab.Button = Utils:newInstance("TextButton", {
            Text = name,
            Size = UDim2.new(0, 110, 1, 0),
            Parent = tabBar,
            BackgroundColor3 = Color3.fromRGB(58,58,62),
            TextColor3 = Color3.fromRGB(230,230,230),
            Font = Enum.Font.Gotham,
            TextSize = 15
        })
        Utils:applyUICorner(tab.Button, 8)
        tab.Button.LayoutOrder = #Window.Tabs + 1

        -- position based on order
        local orderIndex = #Window.Tabs
        tab.Button.Position = UDim2.new(0, (orderIndex) * 112 + 8, 0, 4)

        -- hover/polish
        tab.Button.MouseEnter:Connect(function()
            Utils:tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(85,85,92)}, 0.12)
        end)
        tab.Button.MouseLeave:Connect(function()
            Utils:tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(58,58,62)}, 0.12)
        end)

        tab.Button.MouseButton1Click:Connect(function()
            -- hide all tabs
            for _, t in ipairs(Window.Tabs) do
                t.Frame.Visible = false
                if t.Button then Utils:tween(t.Button, {BackgroundTransparency = 0}, 0.12) end
            end
            tab.Frame.Visible = true
            autosizeWindow()
        end)

        table.insert(Window.Tabs, tab)

        -- if first tab, show it
        if #Window.Tabs == 1 then
            tab.Frame.Visible = true
        end

        return tab
    end

    -- widget helpers (button, toggle, slider) - configurable via options table
    local function nextY(tab)
        local maxY = 8
        for _, c in ipairs(tab.Frame:GetChildren()) do
            if c:IsA("GuiObject") and c ~= tab.Button then
                local bottom = c.Position.Y.Offset + (c.Size and c.Size.Y.Offset or 0)
                if bottom > maxY then maxY = bottom end
            end
        end
        return maxY + 12
    end

    function Window:AddButton(tab, options)
        options = options or {}
        local btnText = options.text or options.label or "Button"
        local btn = Utils:newInstance("TextButton", {
            Text = btnText,
            Size = UDim2.new(0, options.width or 180, 0, options.height or 44),
            Position = options.Position or UDim2.new(0, 12, 0, nextY(tab)),
            BackgroundColor3 = options.color or Color3.fromRGB(70,130,180),
            BackgroundTransparency = options.transparency or 0,
            TextColor3 = options.TextColor or Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamSemibold,
            TextSize = options.textSize or 16,
            Parent = tab.Frame
        })
        Utils:applyUICorner(btn, 8)
        Utils:applyStroke(btn, 1, Color3.fromRGB(0,0,0))
        btn.AutoButtonColor = false

        -- support both options.function and options.callback
        local cb = options["function"] or options.callback
        if type(cb) == "function" then
            btn.MouseButton1Click:Connect(cb)
        end

        btn.MouseEnter:Connect(function()
            local target = (options.hoverColor or btn.BackgroundColor3:Lerp(Color3.fromRGB(140,180,255), 0.2))
            Utils:tween(btn, {BackgroundColor3 = target, Size = btn.Size + UDim2.new(0,6,0,4)}, 0.12)
        end)
        btn.MouseLeave:Connect(function()
            Utils:tween(btn, {BackgroundColor3 = options.color or Color3.fromRGB(70,130,180), Size = UDim2.new(0, options.width or 180, 0, options.height or 44)}, 0.12)
        end)

        table.insert(Window.widgets, {type="button", obj=btn, options=options})
        autosizeWindow()
        return btn
    end

    function Window:AddToggle(tab, options)
        options = options or {}
        local start = options.default and true or false
        local btn = Utils:newInstance("TextButton", {
            Text = start and "ON" or "OFF",
            Size = UDim2.new(0, options.width or 140, 0, options.height or 38),
            Position = options.Position or UDim2.new(0, 12, 0, nextY(tab)),
            BackgroundColor3 = start and (options.onColor or Color3.fromRGB(70,200,120)) or (options.offColor or Color3.fromRGB(200,70,70)),
            TextColor3 = options.TextColor or Color3.fromRGB(245,245,245),
            Font = Enum.Font.GothamSemibold,
            TextSize = 15,
            Parent = tab.Frame
        })
        Utils:applyUICorner(btn, 8)
        btn.AutoButtonColor = false

        local state = start
        local cb = options["function"] or options.callback
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and (options.onColor or Color3.fromRGB(70,200,120)) or (options.offColor or Color3.fromRGB(200,70,70))
            if type(cb) == "function" then pcall(cb, state) end
        end)

        table.insert(Window.widgets, {type="toggle", obj=btn, get=function() return state end, options=options})
        autosizeWindow()
        return btn
    end

    function Window:AddSlider(tab, options)
        options = options or {}
        local min = options.min or 0
        local max = options.max or 100
        local width = options.width or 260
        local height = options.height or 18

        local container = Utils:newInstance("Frame", {
            Size = UDim2.new(0, width, 0, height + 8),
            Position = options.Position or UDim2.new(0, 12, 0, nextY(tab)),
            BackgroundTransparency = 1,
            Parent = tab.Frame
        })
        local track = Utils:newInstance("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            Position = UDim2.new(0, 0, 0, 8),
            BackgroundColor3 = options.trackColor or Color3.fromRGB(60,60,60),
            Parent = container
        })
        Utils:applyUICorner(track, 6)
        local fill = Utils:newInstance("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = options.fillColor or Color3.fromRGB(80,170,100),
            Parent = track
        })
        Utils:applyUICorner(fill, 6)

        local dragging = false
        local function updateValueFromX(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local value = min + rel * (max - min)
            if type(options.callback) == "function" then
                pcall(options.callback, value)
            elseif type(options["function"]) == "function" then
                pcall(options["function"], value)
            end
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateValueFromX(input.Position.X)
            end
        end)
        track.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValueFromX(input.Position.X)
            end
        end)

        table.insert(Window.widgets, {type="slider", obj=container, get=function()
            local rel = fill.Size.X.Scale + (fill.Size.X.Offset / track.AbsoluteSize.X)
            return min + rel * (max - min)
        end, options=options})
        autosizeWindow()
        return container
    end

    -- convenience global API bound to this window, using explicit tab object or default first tab
    function Window:AddButtonConfig(tabOrOptions, maybeOptions)
        -- allows both Window:AddButtonConfig(tab, options) and Window:AddButtonConfig(options) where default tab used
        local tab, options = nil, nil
        if typeof(tabOrOptions) == "table" and tabOrOptions.Frame and tabOrOptions.Button then
            tab = tabOrOptions
            options = maybeOptions
        else
            tab = Window.Tabs[1]
            options = tabOrOptions
        end
        return Window:AddButton(tab, options)
    end

    function Window:AddToggleConfig(tabOrOptions, maybeOptions)
        local tab, options = nil, nil
        if typeof(tabOrOptions) == "table" and tabOrOptions.Frame and tabOrOptions.Button then
            tab = tabOrOptions
            options = maybeOptions
        else
            tab = Window.Tabs[1]
            options = tabOrOptions
        end
        return Window:AddToggle(tab, options)
    end

    function Window:AddSliderConfig(tabOrOptions, maybeOptions)
        local tab, options = nil, nil
        if typeof(tabOrOptions) == "table" and tabOrOptions.Frame and tabOrOptions.Button then
            tab = tabOrOptions
            options = maybeOptions
        else
            tab = Window.Tabs[1]
            options = tabOrOptions
        end
        return Window:AddSlider(tab, options)
    end

    -- high-level API on TinyUI object for convenience across windows
    table.insert(TinyUI._windows, Window)
    return Window
end

-- Dev: create debug panel when in DevMode
local function createDevPanel()
    local devFrame = Utils:newInstance("Frame", {
        Size = UDim2.fromOffset(420, 260),
        Position = UDim2.new(0.02, 0, 0.02, 0),
        BackgroundColor3 = Color3.fromRGB(22,22,26),
        Parent = rootGui
    })
    Utils:applyUICorner(devFrame, 10)
    Utils:applyStroke(devFrame, 1, Color3.fromRGB(0,0,0))

    local title = Utils:newInstance("TextLabel", {
        Size = UDim2.new(1,0,0,34),
        BackgroundTransparency = 1,
        Text = "DEV PANEL",
        TextColor3 = Color3.fromRGB(220,220,220),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = devFrame
    })

    local inspector = Utils:newInstance("TextBox", {
        Size = UDim2.new(1,-20,1,-54),
        Position = UDim2.new(0,10,0,44),
        BackgroundColor3 = Color3.fromRGB(18,18,20),
        TextColor3 = Color3.fromRGB(200,200,200),
        Text = "vars: {}",
        MultiLine = true,
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        TextSize = 14,
        Parent = devFrame
    })

    local refreshBtn = Utils:newInstance("TextButton", {
        Size = UDim2.new(0,90,0,30),
        Position = UDim2.new(1,-100,1,-40),
        BackgroundColor3 = Color3.fromRGB(80,160,240),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = "REFRESH",
        Parent = devFrame
    })
    Utils:applyUICorner(refreshBtn, 8)
    refreshBtn.MouseButton1Click:Connect(function()
        local text = {}
        text[#text+1] = ("windows: %d"):format(#TinyUI._windows)
        for i, w in ipairs(TinyUI._windows) do
            text[#text+1] = ("Window %d: title=%s tabs=%d widgets=%d"):format(i, tostring(w.Title), #w.Tabs, #w.widgets)
        end
        inspector.Text = table.concat(text, "\n")
    end)

    return devFrame
end

-- show key prompt first, then build default demo window
showKeyPrompt(function(mode)
    if not mode then
        -- user cancelled key prompt, do nothing
        return
    end
    TinyUI.DevMode = (mode == "DEV")

    -- create main window
    local win = TinyUI:CreateWindow({Title = "TinyUI Demo", Size = UDim2.fromOffset(640,420)})

    -- create tabs
    local mainTab = win:AddTab("Main")
    local setTab = win:AddTab("Settings")
    local devTab = win:AddTab("Dev")

    -- populate main
    win:AddButton(mainTab, { text = "Press Me", color = Color3.fromRGB(90,200,120), ["function"] = function() print("Main Pressed") end })
    win:AddButton(mainTab, { text = "Another", color = Color3.fromRGB(200,100,120), callback = function() print("Another pressed") end })
    win:AddToggle(mainTab, { default = false, onColor = Color3.fromRGB(70,200,120), offColor = Color3.fromRGB(200,70,70), function = function(s) print("Toggle main:", s) end })
    win:AddSlider(mainTab, { min = 0, max = 100, callback = function(v) print("Slider main:", math.floor(v)) end })

    -- settings
    win:AddButton(setTab, { text = "Close All Windows", color = Color3.fromRGB(220,90,90), function = function()
        for _, w in ipairs(TinyUI._windows) do
            pcall(function() if w and w.Frame then w.Frame:Destroy() end end)
        end
        TinyUI._windows = {}
    end })

    win:AddButton(setTab, { text = "Spawn Another Demo", color = Color3.fromRGB(90,140,240), function = function()
        local w2 = TinyUI:CreateWindow({Title = "Extra Window", Size = UDim2.fromOffset(420,320)})
        local t1 = w2:AddTab("Home")
        w2:AddButton(t1, { text = "Hi from extra", function = function() print("extra: hi") end })
    end })

    -- dev tab only visible if dev mode
    if TinyUI.DevMode then
        win:AddButton(devTab, { text = "Open Debug Panel", color = Color3.fromRGB(240,200,80), function = function()
            local dp = createDevPanel()
            -- refresh once
        end })
        win:AddButton(devTab, { text = "Print UI State", color = Color3.fromRGB(200,255,120), function = function()
            print("DEV: dump")
            for i,w in ipairs(TinyUI._windows) do
                print("Window", i, "Title:", w.Title)
                print("Tabs:", #w.Tabs, "Widgets:", #w.widgets)
            end
        end })
    else
        -- hide dev tab button if not dev
        for _, t in ipairs(win.Tabs) do
            if t.Name == "Dev" then
                t.Button.Visible = false
                t.Frame.Visible = false
            end
        end
    end

    -- autosize first time
    delay(0.05, function()
        -- try to autosize based on content
        pcall(function()
            for _, w in ipairs(TinyUI._windows) do
                -- call internal autosize if present by firing an InputChanged hack: we rely on created function being closure
                -- since autosizeWindow is closure inside CreateWindow, call resize by toggling tabs
                if w and w.Tabs and #w.Tabs > 0 then
                    for _, t in ipairs(w.Tabs) do
                        t.Button:CaptureFocus() -- noop but safe
                    end
                end
            end
        end)
    end)

end)

-- Return API for external use if required
return TinyUI
