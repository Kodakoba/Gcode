if not Emitter then include('emitter.lua') end

--[[
	Promise:
		Allows you to stick one async (or sync, see if i care) function in the initializer or first :Then() call
]]
Promise = Promise or Emitter:Callable()

function Promise:Initialize(f, err)

	local st = SysTime()

	self.Coroutine = coroutine.create(function(resolve, err, ...)

		local step = self.__CurrentStep

		local ok, res = coroutine.resume(self.__Success[step], resolve, err, ...)

		if not ok then
			if self.__Errors[step] then
				self.__Errors[step](self, res)
			else
				error("Promise error: " .. res)
			end
		end

		if step == self.__CurrentStep then -- we haven't resolved immediately; halt this coroutine
			if coroutine.running() == self.Coroutine then coroutine.yield() end
		end

	end)

	self.__CurrentArgs = {}
	self.__Success = {}
	self.__Errors = {}

	self.__CurrentStep = 1

	self.__Resolve = function(...)
		local args = {...}
		self.__CurrentStep = self.__CurrentStep + 1

		while self.__Success[self.__CurrentStep] do
			local f = self.__Success[self.__CurrentStep]
			self.__CurrentStep = self.__CurrentStep + 1

			local new_args = { f( unpack(args) ) }

			for i=1, table.maxn(new_args) do
				if new_args[i] ~= nil then
					args[i] = new_args[i]
				end
			end
		end

		if coroutine.running() == self.Coroutine then coroutine.yield() end
	end
	
	self.__Error = function(...)
		self.__Errors[self.__CurrentStep] (...)

		self.__CurrentStep = self.__CurrentStep + 1
		if coroutine.running() == self.Coroutine then coroutine.yield() end
	end

	self.CatchFunc = nil

	if f or err then
		self:Then(f, err)
	end
end

function Promise:Then(f, err)
	local key = #self.__Success + 1
	self.__Success[key] = (key == 1 and f and coroutine.create(f)) or f
	if err then self.__Errors[key] = err end

	return self
end

function Promise:Catch(err)
	self.CatchFunc = (isfunction(err) and err) or defaultCatch
	return self
end

function Promise:Exec(...)

	local ok, err = coroutine.resume(self.Coroutine, self.__Resolve, self.__Error, ...)

	if not ok then
		error(err)
	end

	return self
end

Promise.Do = Promise.Exec
Promise.Run = Promise.Exec