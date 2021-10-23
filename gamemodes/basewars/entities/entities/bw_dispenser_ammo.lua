AddCSLuaFile()

ENT.Base = "bw_base_dispenser"
ENT.Type = "anim"

ENT.PrintName = "Ammo Dispenser"
ENT.Model = "models/props_lab/reciever_cart.mdl"

ENT.Levels = {
	{
		Cost = 0,
		ChargeRate = 0.5 / 30,
		MaxCharge = 3,

		--DispenseMult = 1,
		CapacityMult = 2, -- mags in reserve
	}, {
		Cost = 125e3,
		ChargeRate = 0.5 / 20,
		MaxCharge = 5,

		--DispenseMult = 2,
		CapacityMult = 3,
	}, {
		Cost = 2.5e6,
		ChargeRate = 0.5 / 15,
		MaxCharge = 8,

		--DispenseMult = 3,
		CapacityMult = 4,
	}, {
		Cost = 15e6,
		ChargeRate = 0.5 / 10,
		MaxCharge = 12,

		--DispenseMult = 5,
		CapacityMult = 5,
	}, {
		Cost = 50e6,
		ChargeRate = 0.5 / 5,
		MaxCharge = 16,

		--DispenseMult = 8,
		CapacityMult = 6,
	}, {
		Cost = 200e6,
		ChargeRate = 0.5 / 5,
		MaxCharge = 20,

		--DispenseMult = 15,
		CapacityMult = 8,
	}
}

ENT.UseFractionCharge = true

function ENT:CheckUsable()
	if self.Time and self.Time + 0.5 > CurTime() then return false end
end

local capMults = {
	["12 Gauge"] = 2,
	["Buckshot"] = 2,
	["BuckshotHL1"] = 2, -- ???
	[".338 Lapua"] = 0.75
}

function ENT:Dispense(ply, dat)
	local gun = ply:GetActiveWeapon()
	if not IsValid(gun) then return true end

	local ammo = gun:GetPrimaryAmmoType()
	if not ammo then return true end

	local ammoName = game.GetAmmoName(ammo)
	local capMult = capMults[ammoName] or 1

	local clip = gun:GetMaxClip1()
	local toGive = math.max(6, clip) -- * dat.DispenseMult

	local max = clip * dat.CapacityMult * capMult
	local has = ply:GetAmmoCount(ammo)
	local newGive = math.max(0, math.min(max - has, toGive))
	local fracUsed = newGive / toGive

	if newGive == 0 then return true end
	if not self:HaveCharge(fracUsed) then return false end

	self:TakeCharge(fracUsed)
	ply:GiveAmmo(newGive, ammo)
end
