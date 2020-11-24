setfenv(0, _G)

if not Networkable then include("networkable.lua") end -- end me

--[[
	terms:
		Prediction Run - completely new runs of predicted hooks containing prediction frames (eg shooting with a weapon starts a Prediction Run)
		Prediction Frame - runs of multiple predicted actions for the same CurTime (eg PrimaryAttack getting called multiple times; each call is a Prediction Frame)

		Stream - kv's which are used in prediction frames; each prediction frame will modify vars into streams instead of baseline
		BaseLine - basically main stream, what we'll use outside of prediction (server also updates its' vars into baseline)
]]

local Stream = Object:callable()
function Stream:Initialize()
	self.Data = {}
	self.BaseLine = {}
end

function Stream:Set(k, v, futureBaseline)
	self.Data[k] = v
	if futureBaseline then
		self.BaseLine[k] = v
	end
end

PredNetworkable = PredNetworkable or Networkable:callable()
local nw = PredNetworkable

local allNWs = _AllPredNWs or WeakTable("v")
_AllPredNWs = allNWs


timer.Create("PredNW_GC", 3, 0, function()
	local rCT = CurTime()

	for k,v in pairs(allNWs) do
		for ct, _ in pairs(v.Streams) do
			if rCT > ct + 3 then
				v.Streams[ct] = nil -- you won't be missed
			end
		end
	end
end)

nw:On("Invalidate", "CleanPredNW", function(self)
	for k,v in ipairs(_AllPredNWs) do
		if v == self then
			table.remove(_AllPredNWs, k)
			break
		end
	end
end)

function nw:Initialize(id)

	--[[
		[unpred_ctime] = {
			Key = Val, ...
		},
	]]

	self.ActiveRuns = {} -- [curtime] = unpredCT (when the first predicted frame happened)
	self.BaseLine = {}

	self.Streams = muldim:new()

	if id then self:SetNetworkableID(id, true) end
	self.LastPredFrame = 0 --UnPredictedCurTime
	self.BaseLineWhen = 0

	self:Alias("__ct", 255)
	allNWs[#allNWs + 1] = self
end

function nw:CreateStream(time)
	local st = Stream()
	self.Streams[time] = st

	local str = self:GetClosestPredRun(time)
	for k,v in pairs(str and str.BaseLine or self.BaseLine) do
		st:Set(k, v)
	end

	return st
end

function nw:GetStream(time)
	return self.Streams[time] or self:CreateStream(time)
end

function nw:GetClosestPredRun(ct) -- behind `ct`
	local mx = 0

	for k,v in pairs(self.ActiveRuns) do
		if k < ct then
			mx = math.max(v, mx)
			mxKey = k
		end
	end

	for k,v in pairs(self.ActiveRuns) do
		if mx ~= 0 and mx - v > 3 then
			self.ActiveRuns[k] = nil
		end
	end

	return self.Streams[mx], mx
end

function nw:GetClosestPredRunUnpred(uct)
	local mx = 0

	for k,v in pairs(self.ActiveRuns) do
		if v < uct then
			mx = math.max(v, mx)
		end
	end

	return self.Streams[mx], mx
end

function nw:Set(k, v, force_pred)
	if self.Aliases[k] ~= nil then k = self.Aliases[k] end

	if SERVER then
		if self.Networked[k] == v then return self end

		local a = self.__parent.Set(self, k, v)
		self.__parent.Set(self, "__ct", CurTime())

		timer.Create("NWNetwork" .. tostring(self.NetworkableID), 0, 1, function()
			if self:IsValid() then
				self.__parent.Network(self, true)
			end
		end)

		return a
	end

	local when = CurTime()					-- shared between multiple pred frames of a single run
	local streamWhen = UnPredictedCurTime() -- shared between multiple runs in a single pred frame

	local pred = force_pred or streamWhen ~= when or not IsFirstTimePredicted()
	local first_pred = pred and IsFirstTimePredicted()

	if not pred then
		--print("!!set baseline from unpred", CurTime(), k, v)
		self.BaseLine[k] = v
		self.BaseLineWhen = when
	else
		--print("!!set stream from pred", CurTime(), streamWhen)
		local stream = self:GetStream(streamWhen)
		stream.LastPredRun = when
		stream:Set(k, v, first_pred)

		if first_pred then
			--print("!!!!!!!first pred", when, streamWhen)
			self.ActiveRuns[when] = streamWhen
		end
	end

end

local print = print
local acPrint = print

function nw:Get(k, p, no_pred)
	if self.Aliases[k] ~= nil then k = self.Aliases[k] end
	if p then print = acPrint else print = BlankFunc end

	local when = CurTime()
	local streamWhen = UnPredictedCurTime()

	local pred = not no_pred and (UnPredictedCurTime() ~= when or not IsFirstTimePredicted())
	if no_pred == false then pred = true end

	if pred then -- we're in prediction; either grab current prediction frame's var, first prediction frame's var in a pred run before this one or baseline
		print("pred")
		local stream = self.Streams[streamWhen]
		local streamFrom
		if not stream then stream, streamFrom = self:GetClosestPredRun(when) end

		if streamFrom and self.ActiveRuns[self.BaseLineWhen] and streamFrom < self.ActiveRuns[self.BaseLineWhen] then
			print("using baseline since its more recent", self.BaseLineWhen, streamWhen, streamFrom, when)
			return self.BaseLine[k], self.BaseLineWhen
		end

		local var = stream and stream.Data[k]
		print("using stream", var, streamFrom, streamWhen, self.BaseLineWhen, when)

		if stream and var == nil then
			print("using stream baseline..?", stream.BaseLine[k])
			var = stream.BaseLine[k]
		end

		if var ~= nil then
			return var, streamFrom or streamWhen
		end -- if the current prediction frame has that var set, return it

		print('returned to baseline')
		return self.BaseLine[k], self.BaseLineWhen -- otherwise, return to baseline
	else

		local stream = self.Streams[streamWhen]
		local closestTime
		if not stream then stream, closestTime = self:GetClosestPredRunUnpred(streamWhen) end

		local blVar = self.BaseLine[k]

		if closestTime and self.ActiveRuns[self.BaseLineWhen] and closestTime < self.ActiveRuns[self.BaseLineWhen] and blVar then -- use baseline if it's more recent than whatever stream we have
			return blVar, self.BaseLineWhen
		end

		local ret
		if stream then
			ret = stream.Data[k]
			if ret == nil then ret = stream.BaseLine[k] end
		end
		if ret == nil then ret = blVar end

		return ret, closestTime or streamWhen

	end
end



function nw:GetPredicted(k)
	return self:Get(k, nil, false)
end

function nw:GetUnpredicted(k)
	return self:Get(k, nil, true)
end

if CLIENT then
	local print = acPrint

	nw:On("NetworkedChanged", "MergeIntoBaseline", function(self, changes)

		if self.BaseLineServer and (not self.BaseLineWhen or self.BaseLineServer >= self.BaseLineWhen) then

			for k,v in pairs(changes) do
				self.BaseLine[k] = v[2]
				self:Emit("PredNetworkedVarChanged", k, v[1], v[2])
			end

			self.BaseLineWhen = self.BaseLineServer
			self.BaseLine.__ct = nil
			self.BaseLineServer = nil
		end

	end)

	nw:On("NetworkedVarChanged", "MergeIntoBaseline", function(self, key, old, new)
		if key == self.Aliases["__ct"] then
			if self.BaseLineWhen < new then
				--self.BaseLineWhen = new
				self.BaseLineServer = new
			end
			self.Networked.__ct = nil
		end
	end)
end