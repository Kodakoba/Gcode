easylua.StartEntity("empnade_ent")

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "emp nade"

ENT.Range = 450
ENT.Duration = 3

TotalEMPs = TotalEMPs or 0

local EMPFX = {}	--table containing positions and values (0-1 fractions)

function ENT:Initialize()
	self:SetModel("models/Items/combine_rifle_ammo01.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()
	self:Activate()

	self:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector() * 700 + Vector(0, 0, math.random(30, 70)))

	if CLIENT then 
		self:CallOnRemove("EMPFX", function()
			local pos = self:GetPos()
			EmitSound("weapons/sapper_removed.wav", pos, self:EntIndex(), CHAN_AUTO)
			EMPFX[#EMPFX + 1] = {pos = pos, frac = 0}
		end)

		return
	end 

	timer.Simple(3, function()
		if IsValid(self) then 
			self:Asplode()
		end
	end)
	

	TotalEMPs = TotalEMPs + 1
	self.EMPNumber = TotalEMPs
end

local function findents(t, range, from, func)
	for k, ent in ipairs(t) do 
		if not IsValid(ent) then continue end 

		local class = ent:GetClass()
		if not class:find(".?prop.?") and not class:find("bw_.?") then continue end 
		
		if from:DistToSqr(ent:LocalToWorld(ent:OBBCenter())) > range then print("2much range", range, from:DistToSqr(ent:LocalToWorld(ent:OBBCenter()))) continue end 
		print("executing func with", ent)
		func(ent)
	end
end

function ENT:Asplode()
	local affected = {}

	local i = 0
	local ind = self.EMPNumber

	findents(ents.GetAll(), self.Range ^ 2, self:GetPos(), function(ent)
		ent.PreEMPMat = ent.PreEMPMat or ent:GetMaterial()
		ent.PreEMPCol = ent.PreEMPCol or ent:GetColor()

		ent.PreEMPFX = ent.PreEMPFX or ent:GetRenderFX()
		ent.PreEMPRMode = ent.PreEMPRMode or ent:GetRenderMode()

		ent.EMPdBy = ind

		ent:SetMaterial("")
		ent:SetColor(Color(255, 255, 255))

		ent:SetRenderFX(kRenderFxNone)
		ent:SetRenderMode(RENDERMODE_TRANSCOLOR)

		i = i + 1 

		affected[i] = ent
	end)

	timer.Simple(self.Duration, function()
		for k,v in ipairs(affected) do 
			if not IsValid(v) then continue end 
			if v.EMPdBy ~= ind then continue end 

			v:SetMaterial(v.PreEMPMat)
			v:SetColor(v.PreEMPCol)

			v:SetRenderFX(v.PreEMPFX)
			v:SetRenderMode(v.PreEMPRMode)

			ent.PreEMPMat = nil
			ent.PreEMPCol = nil
			ent.PreEMPFX = nil
			ent.PreEMPRMode = nil

		end
	end)

	SafeRemoveEntity(self)
end

hook.Add("PostDrawTranslucentRenderables", "EMPFX", function(depth, sky)
	if depth or sky then return end 

	local rems = {}

	for k,v in pairs(EMPFX) do
		local pos = v.pos 
		local frac = 1 - ((1 - v.frac) ^ 3) --easing
		local col = v.col or Color(120, 120, 200)

		v.frac = v.frac + FrameTime() * 2 --0.5 s effect delay 

		if v.frac > 1 then 
			EMPFX[k] = nil --no convenience funcs off my server >:( 
		end

		col.a = 255 - 255*frac

		render.SetColorMaterial()
		render.DrawSphere(pos, 450 * frac, 32, 32, col)
	end

end)
easylua.EndEntity()