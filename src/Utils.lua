-- ============================================================================
-- TinyUI - Utilities
-- ============================================================================

local Utils = {}

function Utils:newInstance(class, props)
	local obj = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			pcall(function() obj[k] = v end)
		end
	end
	return obj
end

function Utils:applyCorner(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = object
	return corner
end

function Utils:applyStroke(object, thickness, color)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1
	stroke.Color = color or Color3.fromRGB(0, 0, 0)
	stroke.Parent = object
	return stroke
end

function Utils:applyGradient(object, color1, color2)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Parent = object
	return gradient
end

function Utils:tween(object, props, duration, style, direction)
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new(
		duration or 0.2,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(object, info, props)
	tween:Play()
	return tween
end

function Utils:debounce(func, delay)
	local last = 0
	return function(...)
		local now = tick()
		if now - last >= delay then
			last = now
			return func(...)
		end
	end
end

function Utils:clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utils:lerp(a, b, t)
	return a + (b - a) * t
end

return Utils
