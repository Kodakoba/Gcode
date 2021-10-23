AddCSLuaFile()

ENT.Base = "bw_base_dispenser"
ENT.Type = "anim"

ENT.PrintName = "Armor Dispenser"

ENT.Model = "models/props_combine/suit_charger001.mdl"

ENT.Levels = {
	{
		Cost = 0,
		DispenseAmt = 5,
		MaxArmor = 50,
	}, {
		Cost = 500e3,
		DispenseAmt = 10,
		MaxArmor = 75,
	}, {
		Cost = 10e6,
		DispenseAmt = 15,
		MaxArmor = 100,
	}, {
		Cost = 150e6,
		DispenseAmt = 20,
		MaxArmor = 150,
	},
}


function ENT:Dispense(ply, dat)
	if not IsPlayer(ply) then return false end

	local ar = ply:Armor()
	if ar >= dat.MaxArmor then return false end

	ply:SetArmor(math.min(ar + dat.DispenseAmt, dat.MaxArmor))
end
