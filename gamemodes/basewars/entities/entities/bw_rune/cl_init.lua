
ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

	function ENT:SetupDataTables()
		self:NetworkVar("Int", 1, "RuneType")
		self:NetworkVar("Entity", 0, "Spawner")
	end

	function ENT:Initialize()
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
			self:SetColor(Color(0,0,0,1))
			self:SetModel(self.Model)	
	end

	
	hook.Add("PhysgunPickup", "STOPFUCKINGSTOP", function(ply, ent)
		if ent:GetClass() == "bw_rune" then return false end
	end)


local runetypes = {
	[1] = function(self)

		self:SetMaterial("models/debug/debugwhite")
		self:SetModel("models/maxofs2d/hover_rings.mdl") 

		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(Color(70, 230, 10, 100))

		if math.random() > 0.9 then 
			local ef = EffectData()
			ef:SetOrigin(self:GetPos() + VectorRand()*math.random(1,16))
			util.Effect("inflator_magic",ef)
		end
	end,

	[2] = function(self)

		self:SetMaterial("models/debug/debugwhite")
		self:SetModel("models/maxofs2d/hover_rings.mdl") 

		self:SetColor(Color(230, 50, 50, 100))

		if math.random() > 0.8 then 
			local ef = EffectData()
			ef:SetOrigin(self:GetPos() + VectorRand()*math.random(1,16))

			util.Effect("inflator_magic",ef)
		end

		if math.random() > 0.5 then 
			self.offs = VectorRand()*6
		end

	end,

	[3] = function(self)

		self:SetMaterial("models/debug/debugwhite")
		self:SetModel("models/maxofs2d/hover_rings.mdl") 

		self:SetColor(Color(40, 0, 150, 100 + math.sin(CurTime()*4) * 20))

		if math.random() > 0.98 then 
			local ef = EffectData()
			ef:SetOrigin(self:GetPos() + VectorRand()*math.random(1,16))

			util.Effect("inflator_magic",ef)
		end

	end,

}

local offs = Vector(0,0,0)

	function ENT:Draw()

		self:DrawModel()
		if not self.GetSpawner or not IsValid(self:GetSpawner()) then return end
		local sp = self:GetSpawner()
		runetypes[self:GetRuneType() or 1](self)
		if self:GetRuneType() == 2 then 
			offs = ValGoTo(offs, self.offs or Vector(0,0,0) , 1)
		end
		self:SetPos(sp:GetPos() + sp:GetUp() * math.sin(CurTime()*2) * 4 + sp:GetUp() * 32 + offs)
	end
