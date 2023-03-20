if SERVER then return end

audio = audio or {}
audio.EntBound = audio.EntBound or muldim:new()

local stream = audio.Stream or Emitter:callable()
audio.Stream = stream

ChainAccessor(stream, "Handle", "Handle")

local meta = FindMetaTable("IGModAudioChannel")

local function StreamAccessor(name, onStream, fl)
	if meta["Get" .. name] then
		stream["Get" .. name] = function(self)
			if onStream and self:GetHandle() then
				return meta["Get" .. name] (self:GetHandle())
			end

			return self[name]
		end
	end

	if meta["Set" .. name] then
		stream["Set" .. name] = function(self, v)
			if fl then self:_AddFlag(fl) end
			self[name] = v
			if self:GetHandle() then
				self:GetHandle()["Set" .. name] (self:GetHandle(), v)
			end
		end
	end
end

local function StreamAccessorMulti(name, fl)
	if meta["Get" .. name] then
		stream["Get" .. name] = function(self)
			return unpack(self[name])
		end
	end

	if meta["Set" .. name] then
		stream["Set" .. name] = function(self, ...)
			if fl then self:_AddFlag(fl) end
			self[name] = {...}
			if self:GetHandle() then
				self:GetHandle()["Set" .. name] (self:GetHandle(), ...)
			end
		end
	end
end

StreamAccessor("Volume")
StreamAccessor("Pan")
StreamAccessor("PlaybackRate")
StreamAccessor("Length", true)
StreamAccessor("Time", "noblock")

StreamAccessorMulti("3DFadeDistance")

function stream:RandomizeTime()
	if self:GetHandle() and not self:_HasFlag("noblock") then
		errorf("Can't randomize time of a started stream without noblock flag.")
		return
	end

	if not self:GetHandle() then
		self.RandomTime = true
		return
	end

	local l = self:GetLength()
	local rand = math.random()

	self:SetTime(l * rand)
end

function stream:Initialize(url, path, flags)
	assert(isstring(url))

	if not url:match("^https?") then
		self.Path = url
	else
		self.URL = url
		self.Path = path
	end

	self.Flags = flags or ""
	self.WantState = nil
	self.Pos = Vector()

	self:SetPlaybackRate(1)
	self:SetVolume(1)
	self:SetPan(0)
	self:Set3DFadeDistance(500, 100000)

	self:SetHandle(nil)

	self.LoadPromises = {}
end


function stream:_AddFlag(fl)
	self.Flags = (self:_HasFlag(fl) and self.Flags) or (self.Flags .. " " .. fl)
end

function stream:_HasFlag(fl)
	return self.Flags:find(fl)
end

function stream:Preload()
	local pr = Promise()

	if not self:GetHandle() then
		self:_AddFlag("noplay")
		self:_LoadAudio(pr)
	else
		pr:Resolve(self:GetHandle())
	end

	return pr
end

function stream:_LoadAudio(pr)
	table.insert(self.LoadPromises, pr)

	if self.Loading then
		return
	end

	self.Loading = true

	local cb = function(chan, errID, errName)
		self.Loading = nil

		if errID then
			for k, pr in pairs(self.LoadPromises) do
				pr:Reject(errID, errName)
			end

		else
			self:SetHandle(chan)

			if chan:Is3D() then
				chan:SetPos(self.Pos)
			end

			if self.Loop then
				chan:EnableLooping(true)
			end

			chan:SetVolume(self:GetVolume())
			chan:SetPlaybackRate(self:GetPlaybackRate())
			chan:SetPan(self:GetPan())
			chan:Set3DFadeDistance(self:Get3DFadeDistance())

			if self.Time then
				chan:SetTime(self.Time)
			elseif self.RandomTime then
				local l = chan:GetLength()
				local rand = math.random()
				self:SetTime(l * rand)
			end

			if self.WantState then
				chan[self.WantState] (chan)
				self.WantState = nil
			end

			for k, pr in pairs(self.LoadPromises) do
				pr:Resolve(chan)
			end

			self.LoadPromises = {}
		end
	end

	if not self.URL then
		-- no url defined; load from disk
		sound.PlayFile(self.Path, self.Flags, cb)
	else
		if self.Path then
			-- url & path defined; load onto disk then play
			hdl.DownloadFile(self.URL, self.Path):Then(function(_, fn)
				sound.PlayFile(fn, self.Flags, cb)
			end)
		else
			-- url but no path; load from web
			sound.PlayURL(self.URL, self.Flags, cb)
		end
	end

	return pr
end

ChainAccessor(stream, "InstantFade", "InstantFade")

function stream:Play()
	local pr = Promise()

	if not self:GetHandle() then
		self.WantState = "Play"
		self:_LoadAudio(pr)
	else
		self:GetHandle():Play()
		pr:Resolve(self:GetHandle())
		self.WantState = nil
	end

	return pr
end

function stream:Stop()
	if self:GetHandle() then
		self:GetHandle():Stop()
	else
		self.WantState = "Stop"
	end
end

function stream:Pause()
	if self:GetHandle() then
		self:GetHandle():Pause()
	else
		self.WantState = "Pause"
	end
end

function stream:EnableLooping()
	if self:GetHandle() or self.Loading then
		errorf("Stream:EnableLooping() [%s] must be called before load (to set noblock).",
			self.Path or self.URL)
		return
	end

	self:_AddFlag("noblock")
	self.Loop = true
end

function stream:IsValid()
	return not self:GetHandle() or self:GetHandle():IsValid()
end

function stream:_BindEntity(what, do3d)
	do3d = do3d == nil or do3d

	if do3d and (self:GetHandle() and not self:GetHandle():Is3D() or self.Loading) then
		errorf("Stream:Bind(Entity) [%s] must be called before load (to set 3D).",
			self.Path or self.URL)
		return
	end

	if do3d then
		self:SetPos(what:GetPos() + what:OBBCenter())
		self:_AddFlag("3d")
	end

	audio.EntBound:Insert(self, what)
end

function stream:Bind(what)
	if IsEntity(what) then
		return self:_BindEntity(what)
	end

	errorf("unhandled Stream:Bind argument: %s (%s)", what, type(what))
end

function stream:IsPlaying()
	return self:GetHandle() and self:GetHandle():GetState() == 1
end

function stream:SetPos(p)
	self.Pos:Set(p)

	if self:GetHandle() then
		self:GetHandle():SetPos(p)
	end
end

Timerify(stream)


hook.Add("Think", "AudioStream", function()
	if table.IsEmpty(audio.EntBound) then return end

	local mypos = CachedLocalPlayer():GetPos()

	for ent, sts in pairs(audio.EntBound) do
		if #sts == 0 then
			audio.EntBound[ent] = nil
		end

		if not ent:IsValid() then
			local has_valid = false
			for i=#sts, 1, -1 do
				local v = sts[i]
				if v:GetInstantFade() then
					v:Stop()
					table.remove(sts, i)
				else
					v._deathTime = v._deathTime or SysTime()
					v._vol = v._vol or v:GetVolume()
					local mul = math.min(1, math.Remap(SysTime() - v._deathTime, 0, 1.4, 1, 0))
					mul = Ease(mul, 0.4)
					v:SetVolume(v._vol * mul)

					if v:GetVolume() <= 0 then
						v:Stop()
						table.remove(sts, i)
					else
						has_valid = true
					end
				end
			end

			if not has_valid then audio.EntBound[ent] = nil end
			continue
		end

		local pos = ent:GetPos()
		pos:Add(ent:OBBCenter())

		local distSqr = mypos:DistToSqr(pos)

		for i=#sts, 1, -1 do
			local v = sts[i]
			if not v:IsValid() then
				table.remove(sts, i)
				continue
			end

			v:SetPos(pos)

			if v:GetHandle() then
				local min, max = v:GetHandle():Get3DFadeDistance()
		
				if max ^ 2 < distSqr then
					v:GetHandle():SetVolume(0)
				else
					v:GetHandle():SetVolume(v:GetVolume())
				end
			end
		end
	end
end)