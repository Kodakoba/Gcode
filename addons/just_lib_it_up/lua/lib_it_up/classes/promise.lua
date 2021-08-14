LibItUp.SetIncluded()
if not Emitter then include('emitter.lua') end

--[[
	Promise:
		i dont fucking remember
]]
Promise = Promise or Emitter:Callable()
Promise.IsPromise = true

local errer = GenerateErrorer("Promise")
function IsPromise(what)
	return istable(what) and what.IsPromise
end

function Promise:Initialize(fn, err)
	self._success = {}
	self._branches = {}
	self._fail = {}

	self._curFillStep = 0
	self._curRunStep = 0
end

function Promise:Rewind()
	self._curRunStep = 0
end

function Promise:Reset()
	self._success = {}
	self._fail = {}
	self._branches = {}
	self._curFillStep = 0

	self:Rewind()
end

function Promise:Then(full, rej)
	self._curFillStep = self._curFillStep + 1
	local key = self._curFillStep

	local nextPr = Promise()

	if isfunction(full) then
		nextPr = Promise()
		self._success[key] = coroutine.create(full)
		self._branches[key] = nextPr
	end

	if isfunction(rej) then
		self._branches[key] = nextPr
		self._fail[key] = coroutine.create(rej)
	end

	return nextPr
end

function Promise:_run(...)
	local s, f = self._success, self._fail

	self._curRunStep = self._curRunStep + 1

	while s[self._curRunStep] or f[self._curRunStep] do
		local key = self._curRunStep

		if not self._errored then
			if self._success[key] then
				local rets = { coroutine.resume(self._success[key], self, ...) }
				if self._branches[key] and table.maxn(rets) > 0 then
					self._branches[key]:Resolve(unpack(rets))
				end
			end
		else
			if self._fail[key] then
				local rets = { coroutine.resume(self._fail[key], self, ...) }
				if self._branches[key] and table.maxn(rets) > 0 then
					self._branches[key]:Reject(unpack(rets))
				end
			end
		end

		self._curRunStep = self._curRunStep + 1
	end
end

-- passed into the callbacks, intended to be ran for async
function Promise:Resolve(x, ...)
	if x == self then error("fuck you a+ [you passed self into resolve]") return end
	if IsPromise(x) then
		x:Then(function(...)
			self:Resolve(...)
		end, function(...)
			self:Reject(...)
		end)
	else
		return self:_run(x, ...)
	end
end

function Promise:Reject(err)
	self._errored = true
	return self:_run(err)
end

-- async functions suck and dont let you pass args in? got you covered fam
function Promise:Resolver()
	self._resolver = self._resolver or function(...)
		return self:Resolve(...)
	end

	return self._resolver
end

function Promise:Rejector()
	self._rejector = self._rejector or function(...)
		return self:Reject(...)
	end

	return self._rejector
end

-- backwards compat with my old code :)
Promise.Exec = Promise.Resolve
Promise.Do = Promise.Resolve
Promise.Run = Promise.Resolve

local CurUniqueID = 0
local uidLen = 16
local NetPromises = {}

local function uid()
	CurUniqueID = CurUniqueID + 1
	return CurUniqueID % bit.lshift(1, uidLen)
end

function net.StartPromise(name, ns)
	local prom = Promise()

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
		ns:WriteUInt(self.ID, uidLen).Description = "Promise ID"
		ns:WriteBool(ok == nil and true or ok).Description = "Promise success"
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

	local prom = NetPromises[id]

	if ok then
		prom:Resolve()
	else
		prom:Reject()
	end

	return prom, ok
end

function net.ReplyPromise(who)
	local rep = PromReply:new()
	rep.ID = net.ReadUInt(uidLen)
	rep.Owner = who

	return rep
end

