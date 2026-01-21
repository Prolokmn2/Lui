-- ============================================================================
-- TinyUI - Main Module
-- ============================================================================

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Utils = require(script:WaitForChild("Utils"))
local Signal = require(script:WaitForChild("Signal"))
local Window = require(script:WaitForChild("Window"))
local THEMES = require(script:WaitForChild("Theme"))

local TinyUI = {
	_windows = {},
	_theme = "ModernDark",
	_rootGui = nil,
	Version = "3.0.0",
}

-- Initialize root GUI
function TinyUI:_init()
	local existing = CoreGui:FindFirstChild("TinyUI_Root")
	if existing then existing:Destroy() end
	
	self._rootGui = Utils:newInstance("ScreenGui", {
		Name = "TinyUI_Root",
		ResetOnSpawn = false,
		Parent = CoreGui,
	})
	
	self._rootGui.ZIndex = 1000
end

-- Create window
function TinyUI:CreateWindow(opts)
	if not self._rootGui then self:_init() end
	
	opts = opts or {}
	opts.Theme = opts.Theme or self._theme
	
	local theme = THEMES[opts.Theme] or THEMES.ModernDark
	local window = Window.new(opts, theme, self._rootGui)
	
	table.insert(self._windows, window)
	window.Closed:Connect(function()
		for i, w in ipairs(self._windows) do
			if w == window then
				table.remove(self._windows, i)
				break
			end
		end
	end)
	
	return window
end

-- Set theme
function TinyUI:SetTheme(themeName)
	if not THEMES[themeName] then return false end
	self._theme = themeName
	return true
end

-- Get all windows
function TinyUI:GetWindows()
	return self._windows
end

-- Close all windows
function TinyUI:CloseAll()
	local windows = {unpack(self._windows)}
	for _, window in ipairs(windows) do
		window:Destroy()
	end
end

-- Get window count
function TinyUI:GetWindowCount()
	return #self._windows
end

-- Export for module usage
return TinyUI
