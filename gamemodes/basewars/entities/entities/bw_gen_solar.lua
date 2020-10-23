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

	self._LastThink = CurTime()
end