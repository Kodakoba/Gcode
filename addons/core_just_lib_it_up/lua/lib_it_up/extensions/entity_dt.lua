-- garry suck my dick

--[[
	Emits:
		"DTChanged"
			[1] - Entity (self)
			[2] - String (name of the DTVar changed)
			[3] - Old value
			[4] - New value
			[5] - true/false - true if called from SetDT... ; false if received from a DT update

		"DTVarsChanged"
			[1] - Entity (self)
			[2] - Table of changed vars ({ [key] = {old, new}, ... })
]]

ENTITY.oldInstallDataTable = ENTITY.oldInstallDataTable or ENTITY.InstallDataTable

-- for old notify system use ent:OnDTVarChanged()

-- for new notify system use ent:OnDTChanged() or
-- ent:On("DTChanged", function(self, dt_name, old_val, new_val, predicted, initial) end)

-- if `predicted` is true, that means this was called due to local realm setting the DTVar
-- otherwise, that means it was received via the net notification system

-- predicted updates use `old` as the real, currently-set-by-the-server var
-- so setting a variable clientside multiple times in a row will keep old_val as the real unpredicted var

-- if `initial` is true, that means the entity _just_ came into PVS so we're calling the proxies
-- on the new entity with the dtvars that changed since last time

if SERVER then util.AddNetworkString("DTVarChangeNotify") end

if not table.KeysToValues then include("table.lua") end

_EntityDTQueue = _EntityDTQueue or {}
local queue = _EntityDTQueue

local sz = {
	Int = 32,
}

local typs = {
	String = 0,
	Bool = 1,
	Float = 2,
	Int = 3,
	Vector = 4,
	Angle = 5,
	Entity = 6
}

local backTyps = table.KeysToValues(typs)
local typLen = #backTyps


local lua_typs = {
	String = "",
	Bool = true,
	Float = 1,
	Int = 1,
	Vector = Vector(),
	Angle = Angle(),
	Entity = Entity(0),
}

local aliases = {
	["Player"] = type(Entity(0)),
	["Weapon"] = type(Entity(0)),
	["NPC"] = type(Entity(0)),
	["Vehicle"] = type(Entity(0)),
}

for k,v in pairs(lua_typs) do
	lua_typs[k] = type(v)
end

local OBBs = { -- add ent pos, min, max and center of its' obb to PVS
	function(e, pos)
		return pos
	end,

	function(e, pos)
		local p = e:OBBMins()
		p:Add(pos)
		return p
	end,

	function(e, pos)
		local p = e:OBBMaxs()
		p:Add(pos)
		return p
	end,

	function(e, pos)
		local p = e:OBBCenter()
		p:Add(pos)
		return p
	end
}

function ENTITY:UseNetDTNotify(b)
	self._UsesNetDTNotify = (b == nil and true) or b
end

function ENTITY:NotifyDTVars()
	if not self:IsValid() then queue[self] = nil print("NotifyDTVars: invalid self.") return end
	if not queue[self] or table.Count(queue[self]) == 0 then print("NotifyDTVars: Nothing queued") return end

	local recip = RecipientFilter()
	local pos = self:GetPos()

	for i=1, #OBBs do
		local pvs_point = OBBs[i](self, pos)
		recip:AddPVS(pvs_point)
	end

	if recip:GetCount() == 0 then return end

	net.Start("DTVarChangeNotify")
		net.WriteEntity(self)
		net.WriteBool(false)
		net.WriteUInt(table.Count(queue[self]), 8)

		for k,v in pairs(queue[self]) do
			local ind, typ, val = unpack(v)
			net.WriteUInt(ind, 5)
			net.WriteUInt(typs[typ], bit.GetLen(typLen))

			net["Write" .. typ] (val, sz[typ])
		end

	net.Send(recip)

	table.Empty(queue[self])
end

if SERVER then
	hook.Add("EntityRemoved", "haelp", function(e)
		if e._UsesNetDTNotify then
			net.Start("DTVarChangeNotify")
				net.WriteEntity(e)
				net.WriteBool(true)
			net.Broadcast()
		end
	end)
end

function ENTITY:QueueNotifyChange(ind, typ, name, old, new)
	if CLIENT then return end
	if not self._UsesNetDTNotify then return end
	if old == new then return end --fuck off

	queue[self] = queue[self] or {}
	local me = queue[self]

	local vartyp = type(new)
	vartyp = aliases[vartyp] or vartyp
										-- 'nil' is supported in booleans, wtf
	if lua_typs[typ] ~= vartyp and not (new == nil and typ == "Bool") then
		errorf("EntityDT: mismatched types; expected %q for %q; received %q instead ( '%s' )\n%s", lua_typs[typ], name, vartyp, new, debug.traceback(0, 4))
		return
	end

	me[name] = {ind, typ, new}

	local notify = self.NotifyDTVars

	-- let other DTVars have a chance to be set and network next tick
	timer.Create(("NotifyDTs:%p:%d"):format(self, engine.TickCount()), 0, 1, function() notify(self) end)

end

local notifQueue = {}
ENTITY._DTNotifyQueue = notifQueue

local notifyDT --pre-definition, see client part

function ENTITY:InstallDataTable()
	self:oldInstallDataTable()
	local name, datatable = debug.getupvalue(self.CallDTVarProxies, 1)

	if name ~= "datatable" then
		errorf("I think we got the wrong table chief %s", datatable)
		return
	end

	self._dt_data = datatable

	local dt_rev = {}
	self._dt_reverse = dt_rev

	--self.CallDTVarProxies = BlankFunc

	local changedDTs = false
	local all_data = {}

	-- DTVar registers a DTVar onto the entity
	-- We can abuse that
	self.DTVar = function( ent, typename, index, name )

		local GetFunc = ent[ "GetDT" .. typename ]

		local SetFunc = function(ent, slot, val)
			local old = GetFunc(ent, slot)
			if old == val then return end --fuck off

			ent:Emit("DTChanged", name, old, val, true)
			if ent.OnDTChanged then
				ent:OnDTChanged(name, old, val, true)
			end
			return ent[ "SetDT" .. typename ] (ent, slot, val)
		end

		if not SetFunc or not GetFunc then
			MsgN( "Couldn't addvar " , name, " - type ", typename," is invalid!" )
			return
		end

		local type_curry = function(func)
			return function(ent, name, old, new)
				func(ent, index, typename, name, old, new)
			end
		end

		local prevDatatable = datatable[name]

		datatable[name] = {
			index = index,
			SetFunc = SetFunc,
			GetFunc = GetFunc,
			typename = typename,
			Notify = {
				type_curry(self.QueueNotifyChange)
			},
			lastKnownValue = prevDatatable and prevDatatable.lastKnownValue or nil -- value which was used in the last notification
		}

		if isfunction(self.OnDTVarChanged) then
			table.insert(datatable[name].Notify, 1, type_curry(self.OnDTVarChanged))
		end

		dt_rev[typename .. index] = datatable[name]
		datatable[name].name = name


		if CLIENT then
			local curVal = GetFunc(self, index)
		
			if datatable.lastKnownValue ~= curVal then
				all_data[typename] = all_data[typename] or {}
				all_data[typename][index] = curVal

				changedDTs = true
			end
		end

		return datatable[name]
	end

	local ind = self:EntIndex()

	timer.Simple(0, function()
		if not CLIENT or not changedDTs or not self:IsValid() then return end
		notifyDT(self, all_data)
	end)

	if notifQueue[ind] and CLIENT then
		timer.Simple(0, function()
			if not IsValid(self) then return end --??? THANK U BASED FULLUPDATES
			notifyDT(self, notifQueue[ind])
			notifQueue[ind] = nil
		end)
	end

end


if CLIENT then

	-- this handles calling proxies for entities re-entering PVS
	hook.Add("NotifyShouldTransmit", "UpdateDTProxies", function(ent, tr)
		if not tr then return end
		local dt = ent._dt_data
		--[[
		print(dt)
		if not dt then

		end
		]]
	end)

	local function callCallbacks(ent, dt, val, init)
		local name = dt.name
		local old = dt.lastKnownValue --dt.GetFunc(ent, dt.index)
		if old == val then old = nil end -- :)
		init = init or false
		dt.lastKnownValue = val

		ent:Emit("DTChanged", name, old, val, init)
		if ent.OnDTChanged then
			ent:OnDTChanged(name, old, val, init)
		end

		return name, old, val
	end


	--[[

		all_data = { ["String"] = {
						[0] = "aaa",
						[1] = "Value",
						[2] = "Value",
						...
					},
					
					["Float"] = {
						[1] = 69.69,
						...
					} }
		]]

	function notifyDT(ent, all_data, init)
		-- rev = { ["String0"] = datatable, ... }
		--  (datatable is the same as in InstallDataTable)
		local rev = ent._dt_reverse


		local cbVars = {}

		for typ, indvals in pairs(all_data) do

			for ind, val in pairs(indvals) do
				if not rev[typ .. ind] then
					printf("NotifyDT: didnt find datatable of type %s index %d.", typ, ind)
					printf("Ent: %s", ent)
					continue
				end

				local dtname, old, new = callCallbacks(ent, rev[typ .. ind], val, init)
				cbVars[dtname] = {old, new}
			end
		end

		ent:Emit("DTVarsChanged", cbVars)
	end

	net.Receive("DTVarChangeNotify", function(len)
		local entID = net.ReadUInt(16)
		local death = net.ReadBool()
		if death then
			notifQueue[entID] = nil
			return
		end

		local valid = true

		if not Entity(entID):IsValid() then
			notifQueue[entID] = {}
			valid = false
		end

		local amt = net.ReadUInt(8)

		local dat = {}

		for i=1, amt do
			local ind = net.ReadUInt(5)
			local id = net.ReadUInt(bit.GetLen(typLen))
			local typ = backTyps[id]
			if not typ then error("corrupted dtnotify...?", id) return end

			local val = net["Read" .. typ] (sz[typ])

			dat[typ] = dat[typ] or {}
			dat[typ][ind] = val
		end

		local ent = Entity(entID)

		if valid and ent._dt_reverse then
			notifyDT(ent, dat)
		else

			if notifQueue[entID] then
				for k,v in pairs(dat) do
					notifQueue[entID][k] = v
				end
			else
				notifQueue[entID] = dat
			end

		end

	end)
end
