AddCSLuaFile("cl_init.lua")
ENT.Base 		= "base_gmodentity"
ENT.Type 		= "anim"

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 1, "RuneType")
		self:NetworkVar("Entity", 0, "Spawner")
	end

	function ENT:Initialize()
			self:SetColor(Color(0,0,0,1))
			self:SetModel(self.Model)
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS) --freeze this is the police
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetUseType(SIMPLE_USE)
			self:SetSpawner(self.Creator)
			self:SetRuneType(self.RuneType or 1)
	end

local UseFuncs = {

[1] = function(ply) 
ply.MegaRegen = CurTime()
ply:SetHealth(math.min(ply:Health() + 25, 200))
ply:EmitSound("snds/runes/regen.ogg",60, 100, 0.75, CHAN_AUTO)
ply:SetNWFloat("regen", CurTime())
end,

[2] = function(ply) 

	if ply.OnHasteRune then 
		ply.HasteStart = CurTime()
		ply:EmitSound("snds/runes/haste.ogg",60, 100, 0.5, CHAN_AUTO)
		ply:SetNWFloat("haste", CurTime())
		return
	end 

	ply:SetRunSpeed(ply:GetRunSpeed()+120) 
	ply.OnHasteRune = true 
	ply.HasteStart = CurTime()
	ply:EmitSound("snds/runes/haste.ogg",60, 100, 0.75, CHAN_AUTO)
	ply:SetNWFloat("haste", CurTime())
end,

[3] = function(ply)
if ply.InvisRune then 
	ply.InvisRune = CurTime()
	ply:EmitSound("snds/runes/invis.ogg", 60, 100, 0.5, CHAN_AUTO)
	ply:SetNWFloat("invis", CurTime())
return end
	ply.InvisRune = CurTime()
	local c = ply:GetColor()

	ply:AddEffects(EF_NODRAW)
	ply:AddEffects(EF_NOSHADOW)
	local wep = ply:GetActiveWeapon()
	ply.InvisWeps = {}
	wep:AddEffects(EF_NODRAW)
	wep:AddEffects(EF_NOSHADOW)
	ply:EmitSound("snds/runes/invis.ogg", 60, 100, 0.75, CHAN_AUTO)
	ply:SetNWFloat("invis", CurTime())
end,

}

local oddtick = false

	hook.Add("EntityTakeDamage", "WearOffRune", function(ply, dmg)

		if not IsValid(ply) or not ply:IsPlayer() then return end

			local ply2 = dmg:GetAttacker()

			if not IsValid(ply) or not ply:IsPlayer() then return end
			if not IsValid(ply2) or not ply2:IsPlayer() then return end

		if ply2.InvisRune then ply2.InvisRune = CurTime() - 45 end --let the think hook do the actual cancelling
		if ply.MegaRegen then ply.MegaRegen = 0 end
	end)
	hook.Add("PlayerDeath", "WearOffRune", function(ply)
		ply.HasteStart = nil 
		ply.MegaRegen = nil
		ply.InvisRune = nil

		ply:SetNWFloat("haste", 0)
		ply:SetNWFloat("regem", 0)
		ply:SetNWFloat("invis", 0)
		end)
	hook.Add("Think", "RuneThink", function()

		oddtick = not oddtick

		for k, ply in pairs(player.GetAll()) do
			if not IsValid(ply) or not ply:Alive() then continue end 

				if ply.HasteStart and CurTime() - ply.HasteStart > 20 then 
					ply:SetRunSpeed(ply:GetRunSpeed() - 120)
					ply.HasteStart = nil
					ply.OnHasteRune = nil
					ply:SetNWFloat("haste", 0)
				end

				if ply.MegaRegen and CurTime() - ply.MegaRegen < 15 and not oddtick then 

					ply:SetHealth( math.min(ply:Health() + 1, 200) )
					ply:SetArmor( math.min(ply:Armor() + 1, 200) )

					elseif ply.MegaRegen and CurTime() - ply.MegaRegen > 15 then 
						ply.MegaRegen = nil 
						ply:SetNWFloat("regen", 0)
				end

				if ply.InvisRune then 

					if ply.InvisWeps and not table.HasValue(ply.InvisWeps, ply:GetActiveWeapon()) then
						local wep = ply:GetActiveWeapon()
						wep:AddEffects(EF_NODRAW)
						wep:AddEffects(EF_NOSHADOW)
						ply.InvisWeps[#ply.InvisWeps + 1] = wep
					end

				end

				if ply.InvisRune and CurTime() - ply.InvisRune > 30 then 

					ply.InvisRune = nil 
					local c = ply:GetColor()
					ply:RemoveEffects(EF_NODRAW)
					ply:RemoveEffects(EF_NOSHADOW)

					if istable(ply.InvisWeps) then 
						for k, wep in pairs(ply.InvisWeps) do
							if not IsValid(wep) then continue end
							wep:RemoveEffects(EF_NODRAW)
							wep:RemoveEffects(EF_NOSHADOW)
						end
					end

					local wep = ply:GetActiveWeapon()
					wep:RemoveEffects(EF_NODRAW)
					wep:RemoveEffects(EF_NOSHADOW)
					ply.InvisWeps = {}
					ply:SetNWFloat("invis", 0)
				end


		end
	end)


	function ENT:OnUse(ply)
		UseFuncs[self:GetRuneType() or 1](ply)

		self:Remove()

	end
	function ENT:Think()
		if not self.Creator or not self.SetSpawner then return end
		
		if not IsValid(self:GetSpawner()) then self:Remove() return end

	end
	function ENT:Use(call, ply)

		if not call==ply or not IsValid(call) or not call:IsPlayer() then return end

		self:OnUse(ply)
	end
	 
	 hook.Add("PhysgunPickup", "STOPFUCKINGSTOP", function(ply, ent)
		if ent:GetClass() == "bw_rune" then return false end
	end)