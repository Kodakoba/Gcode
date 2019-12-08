ENT.Exception=ENT.Exception or false

if !ENT.Exception then
AddCSLuaFile()
end

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"

ENT.Model = "models/props_interiors/pot02a.mdl"
ENT.Skin = 0
ENT.PowerCapacity = 1000
ENT.PresetMaxHealth = 100
ENT.Power = 0
ENT.IsBaseWars = true 

local pow = ENT.Power

BWEnts = BWEnts or {}

BWOwners = BWOwners or {}

hook.Add("PlayerInitialSpawn", "RefreshOwner", function(ply)
	
	local sid64 = ply:SteamID64()

	print("PLAYER SPAWNED", ply, sid64)

	for k,v in pairs(BWOwners) do 
		if sid64==k then 
			BWOwners[ply] = v 
			for k,v in v:pairs() do 
				v.BWOwner = ply
			end
			BWOwners[k] = nil 
		end
	end

end)

hook.Add("PlayerDisconnected", "SaveOwners", function(ply)
	
	local sid64 = ply:SteamID64()

	print("PLAYER LEFT", ply, sid64)

	for k,v in pairs(BWOwners) do 
		if k==ply then 
			BWOwners[sid64] = v 
			for k,v in v:pairs() do 
				v.BWOwner = sid64
			end
			BWOwners[k] = nil 
		end 
	end

end)

hook.Add("CPPIAssignOwnership", "BWRecalculateOwner", function(ply, ent)
	if not IsValid(ply) then print("Attempted to re-assign ownership to invalid player from", ply, "for", ent) return end 
	if not BWEnts[ent] or not ent.CPPIOwner then return end 	--not a bw ent or owner not assigned yet

	BWOwners[ent.CPPIOwner][ent] = nil 
	ent.CPPIOwner = ply
end)

function ENT:Init()

end

function ENT:ThinkFunc()

end

function ENT:UseFunc()

end

function ENT:DerivedDataTables()

end

function ENT:BadlyDamaged()

	return self:Health() <= (self:GetMaxHealth() / 5)

end

function ENT:SetupDataTables()
	
	self:NetworkVar("Int", 0, "Power")
	self:NetworkVar("Int", 1, "MaxPower")
	
	self:DerivedDataTables()
	
end

function ENT:DrainPower(val)

	local me = BWEnts[self]

	--BWEnts[self].Power = 0
	me.Power = math.max(me.Power-val, 0)
	self:SetPower(me.Power)
	
	me.LastDrain = CurTime()
end

function ENT:ReceivePower(val)
	local me = BWEnts[self]
	me.Power = math.min(me.Power+val, me.MaxPower)
	self:SetPower(me.Power)
	return 

end


if SERVER then

	function ENT:Initialize()
		BWEnts[self] = {}
		local me = BWEnts[self]

		me.Power = 0
		me.MaxPower = self.PowerCapacity
		me.LastDrain = 0 

		self:SetModel(self.Model)
		self:SetSkin(self.Skin)

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:SetUseType(SIMPLE_USE)
		self:AddEffects(EF_ITEM_BLINK)
		
		self:PhysWake()
		self:Activate()
		
		self:SetHealth(self.PresetMaxHealth)
		self:SetMaxPower(self.PowerCapacity)
		self.rtb = 0
		
		self:Init(me)
		
		self:SetMaxHealth(self:Health())

		timer.Simple(0, function() 
			if IsValid(self) then 
				self.CPPIOwner = self:CPPIGetOwner() 
				self.BWOwner = self.CPPIOwner
				if not self.CPPIOwner then return end 
				
				BWOwners[self.CPPIOwner] = BWOwners[self.CPPIOwner] or ValidSeqIterable()
				local t = BWOwners[self.CPPIOwner]
				t[#t+1] = self
			end 
		end)

	end
	
	function ENT:Repair()
	
		self:SetHealth(self:GetMaxHealth())
		
	end

	function ENT:Spark(a, ply)

		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin(vPoint)
		util.Effect(a or "ManhackSparks", effectdata)
		self:EmitSound("DoSpark")

		if ply and ply:GetPos():Distance(self:GetPos()) < 80 and math.random(0, 10) == 0 then

			local d = DamageInfo()

			d:SetAttacker(ply)
			d:SetInflictor(ply)
			d:SetDamage(ply:Health() / 2)
			d:SetDamageType(DMG_SHOCK)

			local vPoint = ply:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin(vPoint)
			util.Effect(a or "ManhackSparks", effectdata)

			ply:TakeDamageInfo(d)

		end

	end

	function ENT:OnTakeDamage(dmginfo)

		local dmg = dmginfo:GetDamage()
		local Attacker = dmginfo:GetAttacker()

		self:SetHealth(self:Health() - dmg)

		if self:Health() <= 0 and not self.BlownUp then
			
			self.BlownUp = true
		
			BaseWars.UTIL.PayOut(self, Attacker)
		
			if dmginfo:IsExplosionDamage() then
			
				self:Explode(false)

			return end

			self:Explode()

		return end

		if dmginfo:GetDamage() < 1 then return end

		self:Spark(nil, Attacker)

	end

	function ENT:Explode(e)

		if e == false then

			local vPoint = self:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin(vPoint)
			util.Effect("Explosion", effectdata)

			self:Remove()
			
		return end

		local ex = ents.Create("env_explosion")
			ex:SetPos(self:GetPos())
		ex:Spawn()
		ex:Activate()
		
		ex:SetKeyValue("iMagnitude", 100)
		
		ex:Fire("explode")

		self:Spark("cball_bounce")
		self:Remove()

		SafeRemoveEntityDelayed(ex, 0.1)

	end
	
else 

	function ENT:CLInit()

	end

	function ENT:Initialize()
		BWEnts[self] = {}
		self:CLInit()
	end

end
