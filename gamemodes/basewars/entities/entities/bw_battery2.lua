AddCSLuaFile()

ENT.Base 		= "bw_base"
ENT.Type 		= "anim"

ENT.Model 		= "models/props/de_nuke/light_red2.mdl"

	function ENT:SetupDataTables()
		self:NetworkVar("Vector",0 ,"RealPos")
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
	end

	function ENT:Think()

		self:SetRealPos(self:GetPos())

	end

if CLIENT then 
	ENT.deg = 0
	function ENT:Draw()
		self.deg = self.deg + FrameTime() * 2
		self:DrawModel()
		self.RealPos = self:GetRealPos()
		self:SetPos(self.RealPos + self:GetUp()*math.cos(self.deg)*6 )

	end
end