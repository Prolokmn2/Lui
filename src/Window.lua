-- ============================================================================
-- TinyUI - Window Module
-- ============================================================================

local UIS = game:GetService("UserInputService")
local Utils = require(script.Parent:WaitForChild("Utils"))
local Signal = require(script.Parent:WaitForChild("Signal"))

local Window = {}
Window.__index = Window

function Window.new(opts, theme, rootGui)
	opts = opts or {}
	
	local self = setmetatable({
		Title = opts.Title or "Window",
		Size = opts.Size or UDim2.fromOffset(700, 500),
		Position = opts.Position or UDim2.new(0.5, -350, 0.5, -250),
		Theme = theme,
		RootGui = rootGui,
		
		_tabs = {},
		_frame = nil,
		_destroyed = false,
		_autosizeScheduled = false,
		
		Closed = Signal.new(),
		Resized = Signal.new(),
	}, Window)
	
	self:_create()
	return self
end

function Window:_create()
	-- Main window frame
	self._frame = Utils:newInstance("Frame", {
		Size = self.Size,
		Position = self.Position,
		BackgroundColor3 = self.Theme.Background,
		BackgroundTransparency = 0,
		Parent = self.RootGui,
	})
	self._frame.Name = "TinyUIWindow_" .. tostring(math.random(100000, 999999))
	Utils:applyCorner(self._frame, 16)
	Utils:applyStroke(self._frame, 2, self.Theme.Border)
	
	-- Create drop shadow effect
	self:_createShadow()
	
	-- Titlebar with dragging
	self:_createTitlebar()
	
	-- Tab bar
	self:_createTabBar()
	
	-- Content area
	self:_createContentArea()
end

function Window:_createShadow()
	local shadow = Utils:newInstance("Frame", {
		Size = self._frame.Size + UDim2.new(0, 20, 0, 20),
		Position = self._frame.Position + UDim2.new(0, -10, 0, -10),
		BackgroundColor3 = self.Theme.Shadow,
		BackgroundTransparency = 0.8,
		Parent = self.RootGui,
		ZIndex = 0,
	})
	shadow.LayoutOrder = -1
	Utils:applyCorner(shadow, 16)
end

function Window:_createTitlebar()
	local titleBar = Utils:newInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = self.Theme.Surface,
		BackgroundTransparency = 0,
		Parent = self._frame,
	})
	Utils:applyCorner(titleBar, 14)
	Utils:applyStroke(titleBar, 1, self.Theme.Border)
	
	-- Title text
	local title = Utils:newInstance("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 16, 0, 0),
		BackgroundTransparency = 1,
		Text = self.Title,
		TextColor3 = self.Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = titleBar,
	})
	
	-- Close button
	local closeBtn = Utils:newInstance("ImageButton", {
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(1, -44, 0.5, -18),
		BackgroundColor3 = self.Theme.Danger,
		BackgroundTransparency = 0.1,
		Image = "",
		Parent = titleBar,
	})
	Utils:applyCorner(closeBtn, 8)
	
	local closeLabel = Utils:newInstance("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "✕",
		TextColor3 = self.Theme.Danger,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		Parent = closeBtn,
	})
	
	closeBtn.MouseEnter:Connect(function()
		Utils:tween(closeBtn, {BackgroundTransparency = 0}, 0.2)
	end)
	closeBtn.MouseLeave:Connect(function()
		Utils:tween(closeBtn, {BackgroundTransparency = 0.1}, 0.2)
	end)
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy()
	end)
	
	-- DRAGGING - ONLY ON TITLEBAR
	self:_setupDragging(titleBar)
	
	self._titleBar = titleBar
end

function Window:_setupDragging(titleBar)
	local dragging = false
	local dragStart = nil
	local frameStart = nil
	
	titleBar.InputBegan:Connect(function(input, gpe)
		if gpe or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		dragging = true
		dragStart = input.Position
		frameStart = self._frame.Position
	end)
	
	titleBar.InputEnded:Connect(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UIS.InputChanged:Connect(function(input, gpe)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self._frame.Position = UDim2.new(
				frameStart.X.Scale, frameStart.X.Offset + delta.X,
				frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
			)
		end
	end)
end

function Window:_createTabBar()
	self._tabBar = Utils:newInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 48),
		Position = UDim2.new(0, 0, 0, 50),
		BackgroundColor3 = self.Theme.SurfaceLight,
		BackgroundTransparency = 0,
		Parent = self._frame,
	})
	Utils:applyCorner(self._tabBar, 14)
	Utils:applyStroke(self._tabBar, 1, self.Theme.Border)
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = self._tabBar
	
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 8)
	layout.Parent = self._tabBar
end

function Window:_createContentArea()
	self._contentArea = Utils:newInstance("Frame", {
		Size = UDim2.new(1, -24, 1, -108),
		Position = UDim2.new(0, 12, 0, 62),
		BackgroundTransparency = 1,
		Parent = self._frame,
	})
end

function Window:AddTab(name)
	if self._destroyed then return nil end
	
	name = tostring(name or "Tab")
	
	local tab = {
		Name = name,
		_window = self,
		_frame = nil,
		_button = nil,
		_active = false,
	}
	
	-- Tab content frame
	tab._frame = Utils:newInstance("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = self._contentArea,
	})
	tab._frame.Visible = false
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.PaddingTop = UDim.new(0, 8)
	padding.Parent = tab._frame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 12)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = tab._frame
	
	-- Tab button
	tab._button = Utils:newInstance("TextButton", {
		Text = name,
		Size = UDim2.new(0, 100, 0, 32),
		BackgroundColor3 = self.Theme.SurfaceLight,
		BackgroundTransparency = 0.5,
		TextColor3 = self.Theme.TextSecondary,
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		Parent = self._tabBar,
	})
	Utils:applyCorner(tab._button, 8)
	
	tab._button.MouseEnter:Connect(function()
		if not tab._active then
			Utils:tween(tab._button, {
				BackgroundColor3 = self.Theme.SurfaceLight,
				BackgroundTransparency = 0,
				TextColor3 = self.Theme.Text
			}, 0.2)
		end
	end)
	
	tab._button.MouseLeave:Connect(function()
		if not tab._active then
			Utils:tween(tab._button, {
				BackgroundColor3 = self.Theme.SurfaceLight,
				BackgroundTransparency = 0.5,
				TextColor3 = self.Theme.TextSecondary
			}, 0.2)
		end
	end)
	
	tab._button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	
	table.insert(self._tabs, tab)
	
	-- Auto-select first tab
	if #self._tabs == 1 then
		self:SelectTab(tab)
	end
	
	return tab
end

function Window:SelectTab(tab)
	for _, t in ipairs(self._tabs) do
		t._frame.Visible = false
		t._active = false
		Utils:tween(t._button, {
			BackgroundColor3 = self.Theme.SurfaceLight,
			BackgroundTransparency = 0.5,
			TextColor3 = self.Theme.TextSecondary
		}, 0.2)
	end
	
	tab._frame.Visible = true
	tab._active = true
	Utils:tween(tab._button, {
		BackgroundColor3 = self.Theme.Accent,
		BackgroundTransparency = 0,
		TextColor3 = self.Theme.Text
	}, 0.2)
end

-- Widget helper
function Window:_addToTab(tab, widget)
	widget.LayoutOrder = (#tab._frame:GetChildren() or 0) + 1
	widget.Parent = tab._frame
	self:_scheduleAutosize()
	return widget
end

function Window:_scheduleAutosize()
	if self._autosizeScheduled then return end
	self._autosizeScheduled = true
	task.defer(function()
		self:_autosize()
		self._autosizeScheduled = false
	end)
end

function Window:_autosize()
	if self._destroyed then return end
	
	local maxHeight = 20
	for _, tab in ipairs(self._tabs) do
		if tab._frame and tab._frame.Visible then
			local layoutSize = tab._frame:FindFirstChild("UIListLayout")
			if layoutSize then
				-- Get content height from layout
				local totalHeight = 0
				for _, child in ipairs(tab._frame:GetChildren()) do
					if child:IsA("GuiObject") and child ~= layoutSize then
						totalHeight = totalHeight + (child.Size.Y.Offset or 0) + 12
					end
				end
				if totalHeight > maxHeight then
					maxHeight = totalHeight
				end
			end
		end
	end
	
	local newHeight = math.max(350, maxHeight + 130)
	newHeight = math.min(newHeight, 900)
	
	Utils:tween(self._frame, {Size = UDim2.fromOffset(self._frame.Size.X.Offset, newHeight)}, 0.2)
end

-- Widget creators
function Window:AddLabel(tab, text, opts)
	opts = opts or {}
	local label = Utils:newInstance("TextLabel", {
		Size = UDim2.new(1, 0, 0, opts.TextSize and math.ceil(opts.TextSize * 1.3) or 24),
		BackgroundTransparency = 1,
		Text = text or "Label",
		TextColor3 = opts.TextColor or self.Theme.Text,
		Font = Enum.Font.Gotham,
		TextSize = opts.TextSize or 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	return self:_addToTab(tab, label)
end

function Window:AddButton(tab, opts)
	opts = opts or {}
	local btn = Utils:newInstance("TextButton", {
		Size = UDim2.new(0, opts.width or 140, 0, 40),
		BackgroundColor3 = opts.color or self.Theme.Accent,
		BackgroundTransparency = 0,
		Text = opts.text or "Button",
		TextColor3 = self.Theme.Text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
	})
	Utils:applyCorner(btn, 10)
	
	local callback = opts.callback or opts["function"]
	if type(callback) == "function" then
		btn.MouseButton1Click:Connect(callback)
	end
	
	btn.MouseEnter:Connect(function()
		Utils:tween(btn, {
			BackgroundColor3 = opts.color and opts.color:Lerp(Color3.fromRGB(255, 255, 255), 0.15) or self.Theme.AccentHover,
		}, 0.2)
	end)
	
	btn.MouseLeave:Connect(function()
		Utils:tween(btn, {
			BackgroundColor3 = opts.color or self.Theme.Accent,
		}, 0.2)
	end)
	
	return self:_addToTab(tab, btn)
end

function Window:AddToggle(tab, opts)
	opts = opts or {}
	local state = opts.default and true or false
	
	local container = Utils:newInstance("Frame", {
		Size = UDim2.new(0, 100, 0, 40),
		BackgroundTransparency = 1,
	})
	
	local btn = Utils:newInstance("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = state and self.Theme.Success or self.Theme.Danger,
		BackgroundTransparency = 0,
		Text = state and "ON" or "OFF",
		TextColor3 = self.Theme.Text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Parent = container,
	})
	Utils:applyCorner(btn, 10)
	
	local callback = opts.callback or opts["function"]
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		Utils:tween(btn, {
			BackgroundColor3 = state and self.Theme.Success or self.Theme.Danger
		}, 0.2)
		if type(callback) == "function" then pcall(callback, state) end
	end)
	
	btn.MouseEnter:Connect(function()
		Utils:tween(btn, {BackgroundTransparency = -0.1}, 0.2)
	end)
	
	btn.MouseLeave:Connect(function()
		Utils:tween(btn, {BackgroundTransparency = 0}, 0.2)
	end)
	
	return self:_addToTab(tab, container)
end

function Window:AddSlider(tab, opts)
	opts = opts or {}
	local min, max = opts.min or 0, opts.max or 100
	
	local container = Utils:newInstance("Frame", {
		Size = UDim2.new(1, 0, 0, opts.label and 50 or 30),
		BackgroundTransparency = 1,
	})
	
	if opts.label then
		local lbl = Utils:newInstance("TextLabel", {
			Size = UDim2.new(1, 0, 0, 18),
			BackgroundTransparency = 1,
			Text = opts.label,
			TextColor3 = self.Theme.TextSecondary,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = container,
		})
	end
	
	local track = Utils:newInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 0, opts.label and 22 or 0),
		BackgroundColor3 = self.Theme.SurfaceLight,
		Parent = container,
	})
	Utils:applyCorner(track, 3)
	
	local fill = Utils:newInstance("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = self.Theme.Accent,
		Parent = track,
	})
	Utils:applyCorner(fill, 3)
	
	local dragging = false
	local function updateValue(x)
		local rel = Utils:clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		local value = min + rel * (max - min)
		if type(opts.callback) == "function" then pcall(opts.callback, value) end
	end
	
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateValue(input.Position.X)
		end
	end)
	
	track.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateValue(input.Position.X)
		end
	end)
	
	return self:_addToTab(tab, container)
end

function Window:AddTextBox(tab, opts)
	opts = opts or {}
	local textbox = Utils:newInstance("TextBox", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = self.Theme.SurfaceLight,
		BackgroundTransparency = 0,
		TextColor3 = self.Theme.Text,
		PlaceholderText = opts.placeholder or "Enter text...",
		PlaceholderColor3 = self.Theme.TextMuted,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		ClearTextOnFocus = false,
	})
	Utils:applyCorner(textbox, 10)
	Utils:applyStroke(textbox, 1, self.Theme.Border)
	
	if opts.callback then
		textbox.FocusLost:Connect(function()
			if opts.callback then pcall(opts.callback, textbox.Text) end
		end)
	end
	
	return self:_addToTab(tab, textbox)
end

function Window:AddDropdown(tab, opts)
	opts = opts or {}
	local values = opts.values or {}
	local current = values[1] or "N/A"
	
	local btn = Utils:newInstance("TextButton", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = self.Theme.SurfaceLight,
		BackgroundTransparency = 0,
		Text = (opts.label or "Select") .. ": " .. tostring(current),
		TextColor3 = self.Theme.Text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
	})
	Utils:applyCorner(btn, 10)
	Utils:applyStroke(btn, 1, self.Theme.Border)
	
	btn.MouseButton1Click:Connect(function()
		local idx = table.find(values, current) or 1
		idx = (idx % #values) + 1
		current = values[idx]
		btn.Text = (opts.label or "Select") .. ": " .. tostring(current)
		if type(opts.callback) == "function" then pcall(opts.callback, current) end
	end)
	
	btn.MouseEnter:Connect(function()
		Utils:tween(btn, {BackgroundColor3 = self.Theme.Surface}, 0.2)
	end)
	
	btn.MouseLeave:Connect(function()
		Utils:tween(btn, {BackgroundColor3 = self.Theme.SurfaceLight}, 0.2)
	end)
	
	return self:_addToTab(tab, btn)
end

function Window:AddColorPicker(tab, opts)
	opts = opts or {}
	local color = opts.default or Color3.fromRGB(255, 255, 255)
	
	local btn = Utils:newInstance("TextButton", {
		Size = UDim2.new(0, 140, 0, 40),
		BackgroundColor3 = color,
		BackgroundTransparency = 0,
		Text = opts.text or "Pick Color",
		TextColor3 = self.Theme.Text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
	})
	Utils:applyCorner(btn, 10)
	
	btn.MouseButton1Click:Connect(function()
		local newColor = Color3.fromHSV(math.random() / 1, 0.6, 0.9)
		color = newColor
		Utils:tween(btn, {BackgroundColor3 = color}, 0.2)
		if type(opts.callback) == "function" then pcall(opts.callback, color) end
	end)
	
	return self:_addToTab(tab, btn)
end

function Window:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	
	if self._frame then self._frame:Destroy() end
	self.Closed:Fire()
end

return Window
