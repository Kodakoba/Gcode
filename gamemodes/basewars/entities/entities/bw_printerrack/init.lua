AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local max = 8 --max printers

function ENT:Init()
	self.Money = 0

	self:SetHealth(self.PresetMaxHealth or 100)

	self.rtb = 0
	self:SetTrigger(true)
	self.Printers = {}
	self.PowerRequired = 5

	self:On("ConsumePower", self.ConsumePower)
end

--[[local pos = {
	Vector (0.912353515625, -0.44677734375, 13.148170471191),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*2),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*3 - 0.2),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*4 - 0.4),

	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*6 - 0.9),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*7 - 1),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*8 - 1.1),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*9 - 1.1),
	Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*10 - 1.1),
}]]

local pos = {}


for i=1, 8 do
	local off = (i>=5 and i*5.9 + 13) or i*5.9

	pos[#pos + 1] = Vector(3, -0.5, 8 + off)
end

local function ParsePrintersOut(str)
	local t = string.Explode(" ", str)
	return t
end

local function ParsePrintersIn(tbl)
	local t = {}

	for i=1, max do

		local ent = tbl[i]
		local id = (IsValid(ent) and ent:EntIndex()) or "0"
		t[#t+1] = id

	end

	local str = table.concat(t, " ")
	return str
end

function ENT:NetworkPrinters()
	local str = ParsePrintersIn(self.Printers)
	self:SetPrinters(str)

end

function ENT:ConsumePower(req, total, enough)

	local me = self:GetTable()

	if self:IsRebooting() or not self:IsPowered() then
		for k,ent in pairs(me.Printers) do
			ent:SetPowered(false)
		end
		return
	end

	if not enough then
		local pw = self:GetGrid().PowerStored

		for k,ent in pairs(me.Printers) do
			if not IsValid(ent) then me.Printers[k] = nil continue end

			local req = ent.PowerRequired
			if not req or pw <= req then ent:SetPowered(false) print("not nnuff", ent, pw, self.PowerRequired) continue end
			ent:SetPowered(true)
			pw = pw - req
		end
	else
		for k,ent in pairs(me.Printers) do
			if ent:IsRebooting() then continue end
			ent:SetPowered(true)
		end
	end

end

function ENT:AddPrinter(slot, ent)

	if not pos[slot] then error('attempted adding a printer to a slot which doesnt have a pos (' .. slot .. ")") return end

	print("adding printer @", slot, ent)
	self.Printers[slot] = ent


	local off = pos[slot]

	local pos = self:GetPos()
	local ang = self:GetAngles()

	pos = pos + ang:Up() * off.z
	pos = pos + ang:Right() * off.y
	pos = pos + ang:Forward() * off.x

	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:SetMoveType(MOVETYPE_NONE)
	ent:SetParent(self)
	ent.IsInRack = true

	print("added", ent, pos, ent:GetPos(), slot)

	self:NetworkPrinters()
	self.CurrentValue = 15000
	self.PowerRequired = 5

	for k,v in pairs(self.Printers) do
		if v.CurrentValue then self.CurrentValue = self.CurrentValue + v.CurrentValue end
		self.PowerRequired = self.PowerRequired + v.PowerRequired
	end

	ent:On("ShouldConsumePower", "RackConsume", function()
		return false
	end)
end

function ENT:Touch(ent)

	if not ent.IsPrinter or ent.IsInRack or self.Printers[ent] or ent:CPPIGetOwner() ~= self:CPPIGetOwner() then return end
	if table.Count(self.Printers) >= max then return end

	local fr = 0

	for i=1, max do
		if not self.Printers[i] then fr = i break end
	end
	if fr==0 then error('no free key for printer!') end

	self:AddPrinter(fr, ent)
end

function ENT:ThinkFunc()
	self:NetworkPrinters()
end

function ENT:Eject(num)
	local me = self:GetTable()

	if not me.Printers[num] then print("no printer!", num) return end

	local ent = me.Printers[num]
	if not ent or not IsValid(ent) then print('not valid') return end

	local mins = ent:OBBMins()
	local maxs = ent:OBBMaxs()

	mins, maxs = ent:GetRotatedAABB(mins, maxs)

	OrderVectors(mins, maxs)

	local ang = self:GetAngles()

	local startpos = ent:GetPos()
	local dir = ang:Forward()
	local len = 64

	local ignore = {self, ent}

	table.Add(ignore, me.Printers)

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = ignore
	} )

	if not tr.Hit then
		me.Printers[num] = nil
		ent.IsInRack = false

		ent:SetParent(nil)
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		ent:SetPos(ent:GetPos() + ang:Forward() * 56)
		ent:SetGravity(1)

		ent:GetPhysicsObject():EnableGravity(true) --???
		ent:SetAbsVelocity(Vector(0, 0, 0))

		ent:RemoveListener("ShouldConsumePower", "RackConsume")
		self.CurrentValue = 15000
		for k,v in pairs(self.Printers) do
			if v.CurrentValue then self.CurrentValue = self.CurrentValue + v.CurrentValue end
		end
	else
		self:EmitSound("buttons/button10.wav", 65, 100, 1)
	end

end

util.AddNetworkString("PrinterRack")

net.Receive("PrinterRack", function(_, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) or ent:GetClass() ~= "bw_printerrack" or ply:GetPos():Distance(ent:GetPos()) > 192 or ent:CPPIGetOwner() ~= ply then return end

	local typ = net.ReadUInt(2)

	if typ == 0 then
		local pr = net.ReadUInt(8)
		ent:Eject(pr)
	elseif typ == 1 then
		ent:Collect(ply)
	end

end)

function ENT:Use()
end

function ENT:Collect(ply)

	local moneys = 0

	for k,v in pairs(self.Printers) do
		if not IsValid(v) then continue end

		local mon = v.UseFunc and v:UseFunc(ply, ply, _, _, true)

		if mon then moneys = moneys + mon end
	end

	if moneys > 0 then ply:EmitSound("mvm/mvm_money_pickup.wav") end
end

