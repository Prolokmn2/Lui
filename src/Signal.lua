-- ============================================================================
-- TinyUI - Signal System
-- ============================================================================

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {},
		_fired = false,
		_args = nil,
	}, Signal)
end

function Signal:Connect(callback)
	if not callback then return end
	
	local connection = {
		_callback = callback,
		_signal = self,
		_connected = true,
	}
	
	function connection:Disconnect()
		self._connected = false
		for i, conn in ipairs(self._signal._connections) do
			if conn == self then
				table.remove(self._signal._connections, i)
				break
			end
		end
	end
	
	if self._fired then
		task.defer(callback, unpack(self._args or {}))
	else
		table.insert(self._connections, connection)
	end
	
	return connection
end

function Signal:Fire(...)
	self._args = {...}
	self._fired = true
	for _, conn in ipairs(self._connections) do
		if conn._connected then
			task.defer(conn._callback, ...)
		end
	end
end

function Signal:Wait()
	local thread = coroutine.running()
	local conn
	conn = self:Connect(function(...)
		conn:Disconnect()
		task.resume(thread, ...)
	end)
	return coroutine.yield()
end

function Signal:Destroy()
	for _, conn in ipairs(self._connections) do
		conn:Disconnect()
	end
	self._connections = {}
end

return Signal
