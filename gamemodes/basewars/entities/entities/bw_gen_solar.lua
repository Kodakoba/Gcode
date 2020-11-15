AddCSLuaFile()

ENT.Base 			= "bw_base_generator"
ENT.PrintName 		= "Solar Panel"

ENT.Model 			= "models/props_lab/miniteleport.mdl"


ENT.PowerCapacity 	= 300

ENT.TransmitRadius 	= 200
ENT.TransmitRate 	= 35

local skyPower = 20
local skylessPower = 10

ENT.PowerGenerated 	= skylessPower

local rayPos = Vector(2.4543991088867, -32.136005401611, 3.2566497325897)

local tout = {}
local tdat = {output = tout}

function ENT:DerivedGenDataTables()
	self:NetworkVar("Bool", 3, "SunAccess")
end

function ENT:Think()
	self.BaseClass.Think(self)
	if CLIENT then return end
	if self._LastThink and CurTime() - self._LastThink < 0.3 then return end

	local pos = self:LocalToWorld(rayPos)
	tdat.start = pos
	tdat.endpos = pos + self:GetAngles():Up() * 16384,

	util.TraceLine(tdat)
	local isSky = tout.HitSky

	if isSky then
		local upd = self.PowerGenerated ~= skyPower
		self.PowerGenerated = skyPower

		if upd then
			self:GetGrid():UpdatePowerIn()
		end
	else
		local upd = self.PowerGenerated ~= skylessPower
		self.PowerGenerated = skylessPower

		if upd then
			self:GetGrid():UpdatePowerIn()
		end
	end

	self:SetSunAccess(isSky)
	self._LastThink = CurTime()
end

function ENT:GenerateOptions(qm, pnl)
	local ind = vgui.Create("GradPanel", pnl)
	ind:SetSize(80, 72)
	ind:Center()
	ind.Color = Colors.DarkGray
	ind.Y = ind.Y + pnl.CircleSize + 8

	if qm.SunIndicator and qm.SunIndicator:IsValid() then error("Retard") end
	qm.SunIndicator = ind
	local ent = self
	local sz = 32

	local tx = "%d%%"
	local pwtx = "( %dpw/s )"

	local activeCol = Color(235, 180, 70)
	local inactiveCol = Color(60, 60, 60)
	local txCol = Color(95, 95, 95)

	local sun = ent:GetSunAccess()
	ind.Efficiency = sun and 100 or 50

	ind:On("Paint", "Solar", function(self, w, h)
		local sun = ent:GetSunAccess()

		local eff_perc = skylessPower / skyPower

		self:To("Efficiency", sun and 100 or eff_perc * 100, 0.3, 0, 0.3)

		local eff = math.Round(self.Efficiency)

		local col = sun and activeCol or inactiveCol
		surface.SetDrawColor(col:Unpack())
		surface.DrawMaterial("https://i.imgur.com/QLZ1kck.png", "sun64.png", w/2 - sz/2, 2, sz, sz)
		local tx = tx:format(eff)
		local pwtx = pwtx:format( math.Round( skyPower * (self.Efficiency / 100)) )
		local _, tH = draw.SimpleText(tx, "OS24", w/2, 2 + sz - (24 * 0.125), color_white, 1, 5)
		draw.SimpleText(pwtx, "OS18", w/2, 2 + sz - (24 * 0.3) + tH, txCol, 1, 5)
	end)


	qm:AddPopIn(ind, ind.X, ind.Y, 0, ind:GetTall() / 2)
	return ind
end