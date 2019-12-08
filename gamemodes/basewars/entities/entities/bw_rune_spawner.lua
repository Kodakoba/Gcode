AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"
ENT.LastSpawn = 0
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

	function ENT:SetupDataTables()
		self:NetworkVar("Entity", 1, "Rune")
	end
if SERVER then 

	function ENT:Initialize()

			self:SetModel(self.Model)
			self:SetColor(0,0,0,1)
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
			self:AddEffects(EF_NODRAW)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS) --freeze this is the police
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetUseType(SIMPLE_USE)

	end


end

	hook.Add("PhysgunPickup", "STOPFUCKINGSTOP", function(ply, ent)
		if ent:GetClass() == "bw_rune_spawner" and not ply:IsSuperAdmin() then return false end
	end)
if SERVER then 
	function ENT:Think()
		if not IsValid(self.Rune) then self.LastSpawn = self.LastSpawn or CurTime() else self.LastSpawn = nil return end
		if CurTime() - self.LastSpawn < 30 then return end

		local rune = ents.Create("bw_rune")
		rune.Creator = self 
		rune.RuneType = math.random(1, 3)
		rune:SetPos(self:GetPos() + self:GetUp() * 32)
		--rune:SetModel(rune.Model)
		rune:Spawn()
		self.Rune = rune
		self.LastSpawn = CurTime()


	end
end



if CLIENT then 
		function ENT:Draw()
			if LocalPlayer():IsSuperAdmin() then self:DrawModel() self:SetColor(0,0,0,255) end

		end
end

