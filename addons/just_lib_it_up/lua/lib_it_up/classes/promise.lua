LibItUp.SetIncluded()
if not Emitter then include('emitter.lua') end

--[[
	Promise:
		Allows you to stick one async (or sync, see if i care) function in the initializer or first :Then() call
]]
Promise = Promise or Emitter:Callable()

function Promise:Initialize(f, err)

	self.__CoroFunction = function(resolve, err, ...)

		local step = self.__CurrentStep

		if self.__Success[step] then
			local ok, res = coroutine.resume(self.__Success[step], resolve, err, ...)

			if not ok then
				error("Promise error: " .. res)
			end

			if step == self.__CurrentStep then -- we haven't resolved immediately; halt this coroutine
				if coroutine.running() == self.Coroutine then coroutine.yield() end
			end
		end

	end

	self.Coroutine = coroutine.create(self.__CoroFunction)

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
		self.__CurrentStep = self.__CurrentStep + 1 --next then's error
		if self.__Errors[self.__CurrentStep] then self.__Errors[self.__CurrentStep] (...) end

		
		if coroutine.running() == self.Coroutine then coroutine.yield() end
	end

	self.CatchFunc = nil

	if isfunction(f) or isfunction(err) then
		self:Then(isfunction(f) and f, isfunction(err) and err)
	end
end

function Promise:Rewind()
	self.__CurrentStep = 1

	self.Coroutine = coroutine.create(self.__CoroFunction)
end

function Promise:Reset()
	self.__CurrentArgs = {}
	self.__Success = {}
	self.__Errors = {}

	self:Rewind()
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
	local stat = coroutine.status(self.Coroutine)
	if stat == "dead" then print("coroutine is dead") return self end --/shrug

	local ok, err = coroutine.resume(self.Coroutine, self.__Resolve, self.__Error, ...)

	if not ok then
		error(err)
	end

	return self
end

Promise.Do = Promise.Exec
Promise.Run = Promise.Exec

local CurUniqueID = 0
local uidLen = 16
local NetPromises = {}

local function uid()
	CurUniqueID = CurUniqueID + 1
	return CurUniqueID % bit.lshift(1, uidLen)
end

function net.StartPromise(name, ns)
	local prom = Promise():Then(function(good, bad, ok)
		if not ok then
			bad()
		else
			good()
		end
	end)

	local uid = uid()
	NetPromises[uid] = prom

	if name then net.Start(name) end
		net.WriteUInt(uid, uidLen)

	return prom, uid
end

local PromReply = Object:extend()

function PromReply:ReplySend(name, ok, ns)
	if self.Deactivated then error("Can't reply twice!") return end

	if IsNetstack(ns) then
		ns:SetMode("append")
		ns:SetCursor(1)

		self:Reply(ok, ns)

		net.Start(name)
			net.WriteNetStack(ns)
		net.Send(self.Owner)
	else
		net.Start(name)
			self:Reply(ok)
		net.Send(self.Owner)
	end
	
end

function PromReply:Reply(ok, ns)
	if self.Deactivated then error("Can't reply twice!") return end
	ns = IsNetstack(ns) and ns or nil

	if ns then
		ns:WriteUInt(self.ID, uidLen)
		ns:WriteBool(ok == nil and true or ok)
	else
		net.WriteUInt(self.ID, uidLen)
		net.WriteBool(ok == nil and true or ok)
	end

	self.Deactivated = true
end

function PromReply:Deny()
	self:Reply(false)
end
PromReply.Error = PromReply.Deny

function PromReply:Accept()
	self:Reply(true)
end
PromReply.Success = PromReply.Accept

function net.ReadPromise()
	local id = net.ReadUInt(uidLen)
	local ok = net.ReadBool()
	return NetPromises[id]:Exec(ok), ok
end

function net.ReplyPromise(who)
	local rep = PromReply:new()
	rep.ID = net.ReadUInt(uidLen)
	rep.Owner = who

	return rep
end

