if not Emitter then include('emitter.lua') end

Binds = Binds or {}

Binds.Data = Binds.Data or {}
Binds.Keys = Binds.Keys or muldim:new()

local fileName = __LibName .. "_binds.txt"

local comment = [[
Don't touch this unless you're confident you won't mess it up,
since if you did, the error won't really tell you where or why.

You may want to use this page: https://wiki.facepunch.com/gmod/Enums/KEY
]]

local function writeData()
	local t = {}

	for line, num in eachNewline(comment) do
		if select(2, line:gsub("%w", "")) > 0 then
			line = "## " .. line
		end

		t[num] = line
	end

	t[#t + 1] = "\n\n"

	local dat = util.TableToJSON(Binds.Data, true)
	t[#t + 1] = dat

	file.Write(fileName, table.concat(t, "\n"))
end

local function readData()
	local dat = file.Read(fileName, "DATA")

	if not dat then
		writeData()
		return
	end

	local json = {}

	for line, num in eachNewline(dat) do
		if line:match("^##") then continue end
		json[#json + 1] = line
	end

	local bindData = util.JSONToTable(table.concat(json))
	PrintTable(bindData)
end

Binds.WriteData = writeData
Binds.ReadData = readData

BINDS_TOGGLE = "TOGGLE"
BINDS_HOLD = "HOLD"

Binds.BindData = Binds.BindData or Object:callable()
local bindData = Binds.BindData

bindData[1] = KEY_NONE
bindData[2] = BINDS_TOGGLE

local key_whitelist = {
	Key = 1,
	Method = 2
}

bindData.__index = function(self, k)
	if isnumber(k) then return bindData[k] end

	k = key_whitelist[k] or -1
	return self[k] or bindData[k]
end

bindData.__newindex = function(self, k, v)
	if not isnumber(k) then
		if not key_whitelist[k] then errorf("%s is not a whitelisted non-number index.", k) return end
		rawset(self, key_whitelist[k], v)
		return
	end

	rawset(self, k, v)
end

function bindData:Initialize(k, m)
	self[1] = k
	self[2] = m
end

local function cleanID(t, id)
	for i=#t, 1, -1 do
		if t[i].ID == id then
			table.remove(t, i)
		end
	end
end

Bind = Bind or Emitter:callable()

function Bind:Initialize(id)

	self.ID = id

	if Binds.Data[id] then
		local dat = Binds.Data[id]
		self :SetKey(dat.Key) :SetMethod(dat.Method)
		return
	end

	Binds.Data[id] = bindData:new()
end

function Bind:GetData()
	return Binds.Data[self.ID]
end

-- exclusive means that bind and ONLY that bind will proc for this key
-- there can't be multiple exclusive binds on a key

-- there theoretically can be multiple binds and an exclusive bind,
-- but they just won't run

function Bind:GetExclusive()
	return self.Exclusive
end

function Bind:SetExclusive(b) --, prevent_default)	-- gmod sucks, cant prevent default lol
	if b == nil then b = true end

	if b and self.Key then
		for k,v in ipairs(Binds.Keys[self.Key]) do
			if v.Exclusive then
				return false, "There can't be multiple exclusive keys! (The other is " .. v.ID .. ")"
			end
		end
	end

	self.Exclusive = b
	--self.ExclusivePreventDefault = prevent_default
end


ChainAccessor(Bind, "Exclusive", "Exclusive")

function Bind:SetKey(k)
	local prev = self.Key
	if prev == k then return end --bruh

	self.Key = k

	if Binds.Keys[prev] then
		cleanID(Binds.Keys[prev], self.ID)
	end

	if Binds.Keys[k] then
		cleanID(Binds.Keys[k], self.ID)

		if self.Exclusive then
			for k,v in ipairs(Binds.Keys[self.Key]) do
				if v.Exclusive then
					return false, "There can't be multiple exclusive keys! (The other is " .. v.ID .. ")"
				end
			end
		end

	end

	Binds.Keys:Insert(self, k)

	self:GetData().Key = k

	self:Emit("KeyChanged", prev, k)
	return self
end

function Bind:SetMethod(m)
	local prev = self.Method
	self.Method = m

	self:GetData().Method = m

	self:Emit("MethodChanged", prev, m)
	return self
end

function Bind:SetDefaultMethod(m)
	if not self.Method then
		self:SetMethod(m)
	end

	return self
end

function Bind:SetDefaultKey(k)
	if not self.Key then
		return self:SetKey(k)
	end

	return self
end

hook.Add("PlayerButtonDown", __LibName .. "_BindsDown", function(ply, btn)
	if not Binds.Keys[btn] then return end
	if not IsFirstTimePredicted() then return end

	local binds = Binds.Keys[btn]

	for _, bind in ipairs(binds) do
		if not bind.Exclusive then continue end

		if bind.Method == BINDS_HOLD then
			bind:Emit("Deactivate", ply)
		elseif bind.Method == BINDS_TOGGLE then
			local newState = not bind.__State
			bind:Emit(newState and "Activate" or "Deactivate", ply)
		end

		return -- exclusive bind
	end


	for _, bind in ipairs(binds) do
		if bind.Method == BINDS_HOLD then
			bind:Emit("Activate", ply)
		elseif bind.Method == BINDS_TOGGLE then
			local newState = not bind.__State
			bind:Emit(newState and "Activate" or "Deactivate", ply)
		end
	end

end)

hook.Add("PlayerButtonUp", __LibName .. "_BindsUp", function(ply, btn)
	if not Binds.Keys[btn] then return end
	if not IsFirstTimePredicted() then return end

	local binds = Binds.Keys[btn]

	for _, bind in ipairs(binds) do
		if not bind.Exclusive then continue end

		if bind.Method == BINDS_HOLD then
			bind:Emit("Deactivate", ply)
		end

		return -- exclusive bind
	end


	for _, bind in ipairs(binds) do
		if bind.Method == BINDS_HOLD then
			bind:Emit("Deactivate", ply)
		end
	end
end)