AddCSLuaFile()

ENT.Base = "bw_base_dispenser"
ENT.Type = "anim"

ENT.PrintName = "Ammo Dispenser"
ENT.Model = "models/props_lab/reciever_cart.mdl"

ENT.Levels = {
	{
		Cost = 0,
		DispenseMult = 1,
		CapacityMult = 2, -- mags in reserve
	}, {
		Cost = 125e3,
		DispenseMult = 2,
		CapacityMult = 3,
	}, {
		Cost = 2.5e6,
		DispenseMult = 3,
		CapacityMult = 4,
	}, {
		Cost = 15e6,
		DispenseMult = 5,
		CapacityMult = 5,
	}, {
		Cost = 50e6,
		DispenseMult = 8,
		CapacityMult = 6,
	}, {
		Cost = 200e6,
		DispenseMult = 15,
		CapacityMult = 8,
	}
}


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
	if not IsValid(gun) then return end

	local ammo = gun:GetPrimaryAmmoType()
	if not ammo then return end

	local ammoName = game.GetAmmoName(ammo)
	local capMult = capMults[ammoName] or 1

	local clip = gun:GetMaxClip1()
	local toGive = math.min(10, math.ceil(clip / 3)) * dat.DispenseMult

	local max = clip * dat.CapacityMult * capMult
	local has = ply:GetAmmoCount(ammo)
	toGive = math.min(max - has, toGive)

	ply:GiveAmmo(toGive, ammo)
end
