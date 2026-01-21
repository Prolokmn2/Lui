-- ============================================================================
-- TinyUI - Beautiful Demo
-- ============================================================================

local TinyUI = require(script.Parent:WaitForChild("TinyUI"))

-- Create main window
local window = TinyUI:CreateWindow({
	Title = "✨ TinyUI v3.0 Demo",
	Size = UDim2.fromOffset(750, 600),
	Theme = "ModernDark",
})

-- Tabs
local homeTab = window:AddTab("🏠 Home")
local demoTab = window:AddTab("🎨 Demo")
local themesTab = window:AddTab("🎭 Themes")
local aboutTab = window:AddTab("ℹ️ About")

-- ============================================================================
-- HOME TAB
-- ============================================================================

window:AddLabel(homeTab, "Welcome to TinyUI v3.0", {TextSize = 18})
window:AddLabel(homeTab, "A beautiful, modular UI library for Roblox", {TextSize = 12})

window:AddButton(homeTab, {
	text = "📚 View Docs",
	width = 200,
	callback = function()
		print("Check out the GitHub for documentation!")
	end
})

window:AddButton(homeTab, {
	text = "⭐ Star on GitHub",
	width = 200,
	callback = function()
		print("Thanks for the star!")
	end
})

-- ============================================================================
-- DEMO TAB - Show all widgets
-- ============================================================================

window:AddLabel(demoTab, "All Available Widgets", {TextSize = 16})

-- Buttons
window:AddButton(demoTab, {
	text = "🔵 Primary Button",
	width = 200,
})

window:AddButton(demoTab, {
	text = "🟢 Success Button",
	width = 200,
	color = Color3.fromRGB(52, 211, 153),
})

window:AddButton(demoTab, {
	text = "🔴 Danger Button",
	width = 200,
	color = Color3.fromRGB(239, 68, 68),
})

-- Toggles
window:AddLabel(demoTab, "Toggles", {TextSize = 14})

window:AddToggle(demoTab, {
	default = true,
	callback = function(state)
		print("Toggle 1:", state)
	end
})

window:AddToggle(demoTab, {
	default = false,
	callback = function(state)
		print("Toggle 2:", state)
	end
})

-- Slider
window:AddLabel(demoTab, "Sliders", {TextSize = 14})

window:AddSlider(demoTab, {
	label = "🔊 Volume",
	min = 0,
	max = 100,
	callback = function(value)
		print("Volume:", math.floor(value))
	end
})

window:AddSlider(demoTab, {
	label = "☀️ Brightness",
	min = 0,
	max = 2,
	callback = function(value)
		print("Brightness:", value)
	end
})

-- TextBox
window:AddLabel(demoTab, "Text Input", {TextSize = 14})

window:AddTextBox(demoTab, {
	placeholder = "Enter your username...",
	callback = function(text)
		print("Username:", text)
	end
})

-- Dropdown
window:AddLabel(demoTab, "Dropdown Menu", {TextSize = 14})

window:AddDropdown(demoTab, {
	label = "🎮 Game Mode",
	values = {"Creative", "Survival", "Adventure", "Hardcore"},
	callback = function(selected)
		print("Game Mode:", selected)
	end
})

-- Color Picker
window:AddLabel(demoTab, "Color Picker", {TextSize = 14})

window:AddColorPicker(demoTab, {
	text = "🎨 Pick Your Color",
	callback = function(color)
		print("Color picked!")
	end
})

-- ============================================================================
-- THEMES TAB
-- ============================================================================

window:AddLabel(themesTab, "Choose Your Theme", {TextSize = 16})
window:AddLabel(themesTab, "Click to apply", {TextSize = 12})

window:AddButton(themesTab, {
	text = "🌙 Modern Dark",
	width = 200,
	callback = function()
		TinyUI:SetTheme("ModernDark")
	end
})

window:AddButton(themesTab, {
	text = "✨ Glass Morphism",
	width = 200,
	color = Color3.fromRGB(99, 102, 241),
	callback = function()
		TinyUI:SetTheme("Glass")
	end
})

window:AddButton(themesTab, {
	text = "⚡ Neon Cyberpunk",
	width = 200,
	color = Color3.fromRGB(0, 255, 150),
	callback = function()
		TinyUI:SetTheme("Neon")
	end
})

window:AddButton(themesTab, {
	text = "☀️ Light Mode",
	width = 200,
	color = Color3.fromRGB(241, 245, 249),
	callback = function()
		TinyUI:SetTheme("Light")
	end
})

-- ============================================================================
-- ABOUT TAB
-- ============================================================================

window:AddLabel(aboutTab, "TinyUI v3.0", {TextSize = 18})
window:AddLabel(aboutTab, "Version 3.0.0", {TextSize = 12})
window:AddLabel(aboutTab, "", {TextSize = 8})

window:AddLabel(aboutTab, "Features:", {TextSize = 14})
window:AddLabel(aboutTab, "✅ Modular Architecture", {TextSize = 11})
window:AddLabel(aboutTab, "✅ Beautiful Modern UI", {TextSize = 11})
window:AddLabel(aboutTab, "✅ 4 Built-in Themes", {TextSize = 11})
window:AddLabel(aboutTab, "✅ Drag on Titlebar Only", {TextSize = 11})
window:AddLabel(aboutTab, "✅ Responsive Design", {TextSize = 11})
window:AddLabel(aboutTab, "✅ GitHub Ready", {TextSize = 11})

window:AddButton(aboutTab, {
	text = "📖 Read Docs",
	width = 150,
	callback = function()
		print("Docs: Check README.md")
	end
})

print("TinyUI Demo loaded! Check out the beautiful new UI!")
