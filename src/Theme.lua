-- ============================================================================
-- TinyUI - Theme System
-- ============================================================================

local THEMES = {}

-- Modern Dark Theme (Sleek & Professional)
THEMES.ModernDark = {
	Name = "ModernDark",
	Background = Color3.fromRGB(14, 17, 23),
	Surface = Color3.fromRGB(23, 28, 37),
	SurfaceLight = Color3.fromRGB(32, 38, 50),
	Accent = Color3.fromRGB(66, 135, 245),
	AccentHover = Color3.fromRGB(100, 160, 255),
	AccentActive = Color3.fromRGB(50, 110, 220),
	Text = Color3.fromRGB(240, 240, 245),
	TextSecondary = Color3.fromRGB(160, 170, 185),
	TextMuted = Color3.fromRGB(110, 120, 135),
	Success = Color3.fromRGB(52, 211, 153),
	Warning = Color3.fromRGB(251, 146, 60),
	Danger = Color3.fromRGB(239, 68, 68),
	Border = Color3.fromRGB(50, 60, 75),
	Shadow = Color3.fromRGB(0, 0, 0),
}

-- Glassmorphism Theme (Modern Blur Effect)
THEMES.Glass = {
	Name = "Glass",
	Background = Color3.fromRGB(20, 24, 32),
	Surface = Color3.fromRGB(30, 35, 48),
	SurfaceLight = Color3.fromRGB(45, 52, 68),
	Accent = Color3.fromRGB(99, 102, 241),
	AccentHover = Color3.fromRGB(129, 140, 248),
	AccentActive = Color3.fromRGB(79, 70, 229),
	Text = Color3.fromRGB(248, 250, 252),
	TextSecondary = Color3.fromRGB(148, 163, 184),
	TextMuted = Color3.fromRGB(100, 116, 139),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(249, 115, 22),
	Danger = Color3.fromRGB(220, 38, 38),
	Border = Color3.fromRGB(71, 85, 105),
	Shadow = Color3.fromRGB(0, 0, 0),
}

-- Neon Cyberpunk Theme
THEMES.Neon = {
	Name = "Neon",
	Background = Color3.fromRGB(13, 13, 30),
	Surface = Color3.fromRGB(25, 25, 50),
	SurfaceLight = Color3.fromRGB(35, 35, 70),
	Accent = Color3.fromRGB(0, 255, 150),
	AccentHover = Color3.fromRGB(50, 255, 180),
	AccentActive = Color3.fromRGB(0, 200, 120),
	Text = Color3.fromRGB(0, 255, 200),
	TextSecondary = Color3.fromRGB(0, 200, 150),
	TextMuted = Color3.fromRGB(0, 100, 100),
	Success = Color3.fromRGB(0, 255, 100),
	Warning = Color3.fromRGB(255, 200, 0),
	Danger = Color3.fromRGB(255, 0, 100),
	Border = Color3.fromRGB(0, 255, 200),
	Shadow = Color3.fromRGB(0, 0, 0),
}

-- Light Clean Theme
THEMES.Light = {
	Name = "Light",
	Background = Color3.fromRGB(248, 250, 252),
	Surface = Color3.fromRGB(241, 245, 249),
	SurfaceLight = Color3.fromRGB(226, 232, 240),
	Accent = Color3.fromRGB(59, 130, 246),
	AccentHover = Color3.fromRGB(96, 165, 250),
	AccentActive = Color3.fromRGB(37, 99, 235),
	Text = Color3.fromRGB(15, 23, 42),
	TextSecondary = Color3.fromRGB(51, 65, 85),
	TextMuted = Color3.fromRGB(100, 116, 139),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(249, 115, 22),
	Danger = Color3.fromRGB(220, 38, 38),
	Border = Color3.fromRGB(203, 213, 225),
	Shadow = Color3.fromRGB(0, 0, 0),
}

return THEMES
