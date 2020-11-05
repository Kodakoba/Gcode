if not Emitter then include('emitter.lua') end


MultiPromise = MultiPromise or Emitter:Callable()

function MultiPromise:Initialize(f)
	self.CurrentCoroutine = nil

	self.Coroutine = coroutine.create(function(resolve, err)

		while true do
			local step = self.__CurrentStep
			self.CurrentCoroutine = self.__Success[step]
			local ok, res = coroutine.resume(self.__Success[step], resolve, err, unpack(self.__CurrentArgs))

			if not ok and self.__Errors[step] then
				self.__Errors[step](self, res)
			end

			if step == self.__CurrentStep then -- we haven't resolved immediately; halt this coroutine
				coroutine.yield()
			end
		end
	end)

	self.__CurrentArgs = {}
	self.__Success = {f and coroutine.create(f) or nil}
	self.__Errors = {}

	self.__CurrentStep = 1

	self.__Resolve = function(...)
		local cur_cor = coroutine.running()
		self.__CurrentStep = self.__CurrentStep + 1
		self.__CurrentArgs = {...}
		local status = coroutine.status(self.Coroutine)

		if --[[cor == cur_cor]] status == "running" and cur_cor ~= self.Coroutine then
			coroutine.yield(...)
		elseif status == "suspended" then
			coroutine.resume(self.Coroutine, self.Resolve, self.Error, ...)
		end
		--coroutine.resume(self.Coroutine, self.Resolve, self.Error, ...)

	end

	self.__Error = function(...)
		self.__Errors[self.__CurrentStep] (...)
	end

	self.CatchFunc = nil
end

function MultiPromise:Then(f, err)
	local key = #self.__Success + 1
	self.__Success[key] = coroutine.create(f)
	if err then self.__Errors[key] = err end

	return self
end

function MultiPromise:Catch(err)
	self.CatchFunc = (isfunction(err) and err) or defaultCatch
	return self
end

function MultiPromise:Exec(...)
	self.__CurrentArgs = {...}
	local ok, err = coroutine.resume(self.Coroutine, self.__Resolve, self.__Error)

	if not ok then
		error(err)
	end

	return self
end