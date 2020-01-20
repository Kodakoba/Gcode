BASEWARS_CHOSEN_LANGUAGE = "ENGLISH"

SafezonePoints = {
	["Spawn"] = {Vector(435, 4726.91796875, 59.03125), Vector(-253.96875, 3455.1750488281, 407.849670410156)}
}

BackupWeaponKeys = {
	"Primary", "Secondary", "Recoil_Orig", "FireDelay_Orig", "Damage_Orig"

}

for k,v in pairs(SafezonePoints) do 
	OrderVectors(v[1], v[2])
end

BaseWars.Watery = false 

BaseWars.Config = {
	Forums 		= "https://scriptfodder.com/scripts/view/3309",
	SteamGroup 	= "http://steamcommunity.com/groups/hexahedronic",

	Ents = {
		Electronics = {
			Explode		= true,
			WaterProof	= false,
		},
		SpawnPoint = {
			Offset 		= Vector(0, 0, 16),
		},
	},
		

	Drugs = {
		DoubleJump = {
			JumpHeight 	= Vector(0, 0, 320),
			Duration	= 120,
		},
		Steroid = {
			Walk 		= 330,
			Run 		= 580,
			Duration	= 120,
		},
		Regen = {
			Duration 	= 30,
		},
		Adrenaline = {
			Mult		= 1.5,
			Duration	= 120,
		},
		PainKiller = {
			Mult 		= .75,
			Duration	= 80,
		},
		Rage = {
			Mult 		= 1.5,
			Duration	= 120,
		},
		Shield = {

		},
		Antidote = {

		},
		CookTime	= 30,
	},




	Notifications = {
		LinesAmount = 11,
		Width		= 582,
		BackColor	= Color(30, 30, 30, 140),
		OpenTime	= 10,
	},

	Raid = {
		Time 			= 60 * 5,
		CoolDownTime	= 60 * 15,
		NeededPrinters	= 1,
	},

	AFK  = {
		Time 	= 30,
	},

	SpawnWeps = {
		"weapon_physcannon",
		"hands",
		"dash"
	},

	WeaponDropBlacklist = {
		["hands"] = true,
		["weapon_physcannon"] = true,
		["weapon_physgun"] = true,
		["gmod_tool"] = true,
		["gmod_camera"] = true,
		["dash"] = true,
	},

	PhysgunBlockClasses = {
		["bw_spawnpoint"] = true,
	},

	BlockedTools = {
		["dynamite"] = true,
		["duplicator"] = true,
	},

	ModelBlacklist = {
	},

	PayDayBase 			= 2000,
	PayDayMin			= 150,
	PayDayDivisor		= 1000,
	PayDayRate 			= 60 * 3,
	PayDayRandom		= 50,

	StartMoney 			= 15000,

	ExtraStuff			= true,
	CleanProps			= false, -- Finds all physics props on the map and removes them when all the entities are frist initialized (AKA: When the map first loads).

	AllowFriendlyFire	= false,

	DefaultWalk			= 220,
	DefaultRun			= 300,

	DefaultLimit		= 4,
	SpawnOffset			= Vector(0, 0, 40),

	UniversalPropConstant = 20,
	DestroyReturn 		= 0.6,

	RestrictProps 		= false,

	DispenserTime		= 2,

	LevelSettings = {

		BuyWeapons = 2,

	},

	VIPRanks = {},
}

BaseWars.Config.EXPMult = 1


BaseWars.SpawnList = {}
BaseWars.SpawnList.Models = {}
BaseWars.SpawnList.Models.Entities = {}
BaseWars.SpawnList.Models.Loadout = {}
BaseWars.SpawnList.Models.Printers = {}

local WEAPONS = {}

local t = {}
BaseWars.Dafuq = t
local logmeta = {}

BaseWars.SpawnList = {}
BaseWars.SpawnList.Models = {}
BaseWars.SpawnList.Models.Entities = setmetatable({}, logmeta)
BaseWars.SpawnList.Models.Loadout = setmetatable({}, logmeta)
BaseWars.SpawnList.Models.Printers = setmetatable({}, logmeta)
BaseWars.SpawnList.Models.Recreational = setmetatable({}, logmeta)


local k = 1000
local m = k * 1000
local b = m * 1000

local add = BaseWars.AddToSpawn

local sl = BaseWars.SpawnList.Models 

local function AddCat(cat, typ, class, name, price, lv, mdl)
	local t = {}

	t.ClassName = class 
	t.Price = price 
	t.Model = mdl 
	t.Level = lv 

	t.Name = name

	t = add(t)

	local t2 = sl[cat][typ] or setmetatable({}, logmeta)

	sl[cat][typ] = t2

	t2[#t2 + 1] = t

	return t
end

local function AddLoadout(typ, class, name, price, lv, mdl)

	local wep = weapons.Get(class)

	mdl = (mdl ~= "" and mdl) or wep.WorldModel
	if not mdl then error("Failed getting model for weapon " .. class) return end 

	name = name or wep.PrintName
	if not name then error("wtf is the name " .. class) return end 

	local t = AddCat("Loadout", typ, class, name, price, lv, mdl)

	t.Gun = true 
end


local function AddPrinters(typ, class, name, price, lv, mdl, lim)

	local t = AddCat("Printers", typ, class, name, price, lv, mdl, lim)

	t.Limit = 1

end


local function AddRecreational(typ, class, name, price, lv, mdl, lim)

	local t = AddCat("Recreational", typ, class, name, price, lv, mdl, lim)

end

local function AddEntities(typ, class, name, price, lv, mdl, lim)
	local t = AddCat("Entities", typ, class, name, price, lv, mdl, lim)
end

local function GSL(t)
	return add(t)
end

-- Weapons - T3--

AddLoadout("Weapons - T3", "cw_blackops3_dlc1_locus", "Locus", m * 5, 0, "models/loyalists/blackops3/locus/w_sr_locus.mdl")
AddLoadout("Weapons - T3", "cw_blackops3_dlc2_arak", "KN-44", m * 3.5, 0, "models/loyalists/blackops3/arak/w_ar_arak.mdl")
AddLoadout("Weapons - T3", "cw_blackops3_xr2", "XR-2", m * 5, 0, "models/loyalists/blackops3/xr2/w_ar_xr2.mdl")


-- Weapons - T2--

AddLoadout("Weapons - T2", "cw_vss", "VSS/AS VAL", k * 200, 0, "models/cw2/rifles/w_vss.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_dlc3_mp400", "HG 40", k * 1000, 0, "models/loyalists/blackops3/dlc_mp400/w_smg_mp400.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_dlc2_shva", "Sheiva", k * 500, 0, "models/loyalists/blackops3/shva/w_ar_shva.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_dlc2_isr27", "ICR-1", m * 1.5, 0, "models/loyalists/blackops3/isr27/w_ar_isr27.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_dlc3_peacekeeper", "PeaceKeeper", k * 1000, 0, "models/loyalists/blackops3/dlc_peacekeeper/w_ar_peacekeeper.mdl")
AddLoadout("Weapons - T2", "cw_m3super90", "M3", k * 200, 0, "models/weapons/w_shot_m3super90.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_spartan", "Spartan", k * 300, 0, "models/loyalists/blackops3/spartan/w_shot_spartan.mdl")
AddLoadout("Weapons - T2", "cw_g4p_m4a1", "M4A1", k * 300, 0, "models/weapons/w_rif_m4a1.mdl")
AddLoadout("Weapons - T2", "cw_g4p_awm", "AWM", k * 500, 0, "models/weapons/w_snip_awp.mdl")
AddLoadout("Weapons - T2", "cw_blackops3_dlc4_mnwr", "Man o' War", k * 200, 0, "models/loyalists/blackops3/mnwr/w_ar_mnwr.mdl")
AddLoadout("Weapons - T2", "cw_g4p_xm8", "XM8", k * 400, 0, "models/weapons/w_rif_m4a1.mdl")

-- Weapons - Misc--

AddLoadout("Weapons - Misc", "weapon_health", "Heal Gun", k * 500, 20, "models/weapons/w_physics.mdl")
AddLoadout("Weapons - Misc", "epicpickax", "Pickaxe", k * 200, 50, "models/weapons/w_irifle.mdl")
AddLoadout("Weapons - Misc", "bw_blowtorch_t3", "Blowtorch T3", m * 5, 250, "models/weapons/w_irifle.mdl")
AddLoadout("Weapons - Misc", "bw_blowtorch_t5", "Blowtorch T5", b * 5, 2500, "models/weapons/w_irifle.mdl")
AddLoadout("Weapons - Misc", "bw_blowtorch_t4", "Blowtorch T4", m * 250, 1000, "models/weapons/w_irifle.mdl")
AddLoadout("Weapons - Misc", "bw_blowtorch_t2", "Blowtorch T2", m * 2.5, 75, "models/weapons/w_irifle.mdl")
AddLoadout("Weapons - Misc", "bw_blowtorch_t1", "Blowtorch T1", k * 1000, 20, "models/weapons/w_irifle.mdl")


-- Printers - Misc.--

AddPrinters("Printers - Misc.", "bw_printercap", "Capacity Kit", k * 1000, 0, "models/props_junk/cardboard_box004a.mdl")
AddPrinters("Printers - Misc.", "bw_printerrack", "Printer Rack", k * 25, 5, "models/grp/rack/rack.mdl")
AddPrinters("Printers - Misc.", "bw_printercap2", "Heavy Capacity Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")
AddPrinters("Printers - Misc.", "bw_printerpaper", "Printer Paper", 300, 0, "models/props_junk/garbage_newspaper001a.mdl")


-- Printers (T1)--

AddPrinters("Printers (T1)", "bw_printer_nuclear", "Nuclear Printer", k * 500, 40, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_platinum", "Platinum Printer", k * 100, 15, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_manual", "Manual Printer", 100, 0, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_diamond", "Diamond Printer", k * 200, 25, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_base_moneyprinter", "Basic Printer", k * 5, 0, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_copper", "Copper Printer", k * 12.5, 3, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_silver", "Silver Printer", k * 20, 5, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T1)", "bw_printer_gold", "Gold Printer", k * 50, 10, "models/props_lab/reciever01a.mdl")


-- Printers (T2)--

AddPrinters("Printers (T2)", "bw_printer_mobius", "Mobius Printer", m * 6, 75, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T2)", "bw_printer_molecular", "Molecular Printer", m * 85, 200, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T2)", "bw_printer_monolith", "Monolith Printer", m * 35, 120, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T2)", "bw_printer_quantum", "Quantum Printer", m * 55, 150, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T2)", "bw_printer_darkmatter", "Dark Matter Printer", m * 15, 85, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T2)", "bw_printer_redmatter", "Red Matter Printer", m * 25, 100, "models/props_lab/reciever01a.mdl")


-- Printers (T3)--

AddPrinters("Printers (T3)", "bw_printer_neutron", "Neutron Printer", m * 250, 550, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T3)", "bw_printer_photon", "Photon Printer", m * 500, 900, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T3)", "bw_printer_proton", "Proton Printer", m * 150, 400, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T3)", "bw_printer_atomic", "Atomic Printer", m * 100, 250, "models/props_lab/reciever01a.mdl")
AddPrinters("Printers (T3)", "bw_printer_electron", "Electron Printer", m * 400, 700, "models/props_lab/reciever01a.mdl")


-- Misc.--

AddRecreational("Misc.", "synthesizer_accordion", "Synthesizer - Accordion", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_organ", "Synthesizer - Organ", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_violin", "Synthesizer - Violin", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_electric_guitar", "Synthesizer - Electric Guitar", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_piano", "Synthesizer - Piano", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_sax", "Synthesizer - Saxophone", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_harp", "Synthesizer - Harp", k * 350, 2, "models/tnf/synth.mdl")
AddRecreational("Misc.", "synthesizer_guitar", "Synthesizer - Guitar", k * 350, 2, "models/tnf/synth.mdl")


-- Defense--

AddEntities("Defense", "bw_turret_laser_rapid", "Rapid Laser Turret", m * 7.5, 1250, "models/Combine_turrets/Floor_turret.mdl")
AddEntities("Defense", "bw_turret_ballistic", "Ballistic Turret", k * 80, 75, "models/Combine_turrets/Floor_turret.mdl")
AddEntities("Defense", "bw_turret_laser", "Laser Turret", k * 120, 100, "models/Combine_turrets/Floor_turret.mdl")
AddEntities("Defense", "bw_turret_ballistic_rapid", "Rapid Ballistic Turret", m * 2.5, 750, "models/Combine_turrets/Floor_turret.mdl")


-- Structures (T2)--

AddEntities("Structures (T2)", "bw_radar", "Radar", m * 250, 250, "models/props_rooftop/roof_dish001.mdl")


-- Consumables (T1)--

AddEntities("Consumables (T1)", "bw_battery", "Battery Kit", m * 2.5, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables (T1)", "bw_repairkit", "Repair Kit", k * 2.5, 0, "models/Items/car_battery01.mdl")
AddEntities("Consumables (T1)", "bw_battery", "Heavy Battery Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables (T1)", "bw_entityarmor", "Armor Kit", m * 2.5, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables (T1)", "bw_entityarmor2", "Heavy Armor Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")


-- Generators (T1)--

AddEntities("Generators (T1)", "bw_gen_joke", "Numismatic Reactor", m * 150, 3000, "models/props_c17/cashregister01a.mdl")
AddEntities("Generators (T1)", "bw_gen_coalfired", "Coal Fired Generator", k * 20, 50, "models/props_wasteland/laundry_washer003.mdl")
AddEntities("Generators (T1)", "bw_gen_hydroelectric", "Hydroelectric Reactor", m * 5, 1250, "models/props_wasteland/laundry_washer001a.mdl")
AddEntities("Generators (T1)", "bw_gen_solar", "Solar Panel", k * 5, 15, "models/props_lab/miniteleport.mdl")
AddEntities("Generators (T1)", "bw_gen_combustion", "Combustion Reactor", m * 500, 3000, "models/props_c17/substation_transformer01a.mdl")
AddEntities("Generators (T1)", "bw_gen_fission", "Fission Reactor", k * 75, 100, "models/props/de_nuke/equipment1.mdl")
AddEntities("Generators (T1)", "bw_gen_fusion", "Fusion Reactor", k * 300, 500, "models/maxofs2d/thruster_propeller.mdl")
AddEntities("Generators (T1)", "bw_gen_manual", "Manual Generator", 250, 0, "models/props_c17/TrapPropeller_Engine.mdl")
AddEntities("Generators (T1)", "bw_electric_pole", "Power Pole", k * 10, 5, "models/grp/powerpole/powerpole.mdl")
AddEntities("Generators (T1)", "bw_gen_gas", "Gas Generator", k * 1.5, 5, "models/xqm/hydcontrolbox.mdl")


-- Structures (T1)--

AddEntities("Structures (T1)", "bw_weaponbox", "Weapon Box", k * 150, 25, "models/lt_c/sci_fi/box_crate.mdl")
AddEntities("Structures (T1)", "bw_printerstorage", "Vault", k * 50, 10, "models/props/de_nuke/NuclearContainerBoxClosed.mdl")
AddEntities("Structures (T1)", "bw_spawnpoint", "Spawnpoint", k * 25, 0, "models/props_trainstation/trainstation_clock001.mdl")


-- Dispensers (T1)--

AddEntities("Dispensers (T1)", "bw_vendingmachine", "Vending Machine", k * 20, 10, "models/props_interiors/VendingMachineSoda01a.mdl")
AddEntities("Dispensers (T1)", "bw_weaponcrafter", "Weapons Crafter", k * 500, 10, "models/props_combine/combine_mortar01b.mdl")
AddEntities("Dispensers (T1)", "bw_healthpad2", "Health Pad T2", m * 150, 1500, "models/props_lab/teleplatform.mdl")
AddEntities("Dispensers (T1)", "bw_healthpad", "Health Pad", m * 10, 150, "models/props_lab/teleplatform.mdl")
AddEntities("Dispensers (T1)", "bw_dispenser_health", "Armor Dispenser", k * 25, 50, "models/props_combine/health_charger001.mdl")
AddEntities("Dispensers (T1)", "bw_dispenser_ammo", "Ammo Dispenser", k * 55, 30, "models/props_lab/reciever_cart.mdl")
AddEntities("Dispensers (T1)", "bw_dispenser_armor2", "Armor Dispenser T2", m * 15, 1000, "models/props_combine/suit_charger001.mdl")
AddEntities("Dispensers (T1)", "bw_dispenser_ammo2", "Ammo Dispenser T2", m * 10, 750, "models/props_lab/reciever_cart.mdl")


AddLoadout("Ammo Kits", "cw_ammo_kit_small", "Box", 5*k, 30, "models/items/boxsrounds.mdl")
AddLoadout("Ammo Kits", "cw_ammo_crate_small", "Crate", 35*k, 25, "models/Items/item_item_crate.mdl")

----

AddLoadout("Melee", "weapon_crowbar", "Crowbar", 2.5*k, 3, "models/weapons/w_crowbar.mdl")
AddLoadout("Melee", "csgo_default_knife", "Knife", 10*k, 5, "models/weapons/w_csgo_default.mdl")

----

AddLoadout("Pistols", "cw_g4p_usp40", "USP", 12.5*k, 5, "models/weapons/w_pist_usp.mdl")
AddLoadout("Pistols", "cw_m1911", "M1911", 15*k, 7, "models/weapons/cw_pist_m1911.mdl")

AddLoadout("Pistols", "cw_g4p_fiveseven", "FiveSeven", 25*k, 10, "models/weapons/w_pist_fiveseven.mdl")

AddLoadout("Pistols", "cw_deagle", "Deagle", 25*k, 15, "models/weapons/w_pist_deagle.mdl")
AddLoadout("Pistols", "cw_mr96", "MR96", 35*k, 20, "models/weapons/w_pist_deagle.mdl")
AddLoadout("Pistols", "cw_g4p_mp412_rex", "MP412", 50*k, 25, "models/weapons/w_pist_deagle.mdl")

----

AddLoadout("SMGs", "cw_mac11", "MAC-11", 50*k, 30, "models/weapons/w_smg_p90.mdl")
AddLoadout("SMGs", "cw_mp5", "HK MP5", 75*k, 35, "models/weapons/w_smg_p90.mdl")

----

AddLoadout("Pistols", "cw_blackops3_38", "BloodHound", 65*k, 40, "models/loyalists/blackops3/38/w_pistol_38.mdl")
AddLoadout("Pistols", "cw_blackops3_mr6", "MR6", 100*k, 50, "models/loyalists/blackops3/mr6/w_pistol_mr6.mdl")

----

AddLoadout("SMGs", "cw_g4p_magpul_masada", "Magpul Masada", 150*k, 40, "models/weapons/w_smg_p90.mdl")

AddLoadout("SMGs", "cw_killdrix_acre", "ACR-E", 200*k, 50, "models/weapons/killdrix/w_acre.mdl")

----

AddLoadout("Assault Rifles", "cw_sg55x", "SG552", 225*k, 50, "")
AddLoadout("Assault Rifles", "cw_blackops3_dlc4_mnwr", "Man o' War", 500*k, 50, "")

----


--AddLoadout("SMGs", "", "", 100*k, 30, "")
--[[

BaseWars.SpawnList.Models.Loadout["Weapons - T2"] = {

	["Man o' War"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/mnwr/w_ar_mnwr.mdl", Price = 200000, ClassName = "cw_blackops3_dlc4_mnwr"},
	["VSS/AS VAL"] 					= GSL{Gun = true, Model = "models/cw2/rifles/w_vss.mdl", Price = 200000, ClassName = "cw_vss"},
	["M3"] 							= GSL{Gun = true, Model = "models/weapons/w_shot_m3super90.mdl", Price = 200000, ClassName = "cw_m3super90"},
	["Spartan"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/spartan/w_shot_spartan.mdl", Price = 300000, ClassName = "cw_blackops3_spartan"},
	["M4A1"] 						= GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 300000, ClassName = "cw_g4p_m4a1"},
	["XM8"] 						= GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 400000, ClassName = "cw_g4p_xm8"},
	["AWM"] 						= GSL{Gun = true, Model = "models/weapons/w_snip_awp.mdl", Price = 500000, ClassName = "cw_g4p_awm"},
	["Sheiva"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/shva/w_ar_shva.mdl", Price = 500000, ClassName = "cw_blackops3_dlc2_shva"},
	["PeaceKeeper"] 				= GSL{Gun = true, Model = "models/loyalists/blackops3/dlc_peacekeeper/w_ar_peacekeeper.mdl", Price = 1000000, ClassName = "cw_blackops3_dlc3_peacekeeper"},
	["HG 40"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/dlc_mp400/w_smg_mp400.mdl", Price = 1000000, ClassName = "cw_blackops3_dlc3_mp400"},
	["ICR-1"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/isr27/w_ar_isr27.mdl", Price = 1500000, ClassName = "cw_blackops3_dlc2_isr27"},



}

BaseWars.SpawnList.Models.Loadout["Weapons - T3"] = {
	["KN-44"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/arak/w_ar_arak.mdl", Price = 3500000, ClassName = "cw_blackops3_dlc2_arak"},
	["XR-2"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/xr2/w_ar_xr2.mdl", Price = 5000000, ClassName = "cw_blackops3_xr2"},
	["Locus"] 					= GSL{Gun = true, Model = "models/loyalists/blackops3/locus/w_sr_locus.mdl", Price = 5000000, ClassName = "cw_blackops3_dlc1_locus"},
}


BaseWars.SpawnList.Models.Loadout["Weapons - Misc"] = {

	["Heal Gun"]				= GSL{Gun = true, Model = "models/weapons/w_physics.mdl", Price = 500000, ClassName = "weapon_health", Level = 20},

	["Blowtorch T1"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 1000000, ClassName = "bw_blowtorch_t1", Level = 20},
	["Blowtorch T2"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 2500000, ClassName = "bw_blowtorch_t2", Level = 75},
	["Blowtorch T3"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000, ClassName = "bw_blowtorch_t3", Level = 250},
	["Blowtorch T4"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 250000000, ClassName = "bw_blowtorch_t4", Level = 1000},
	["Blowtorch T5"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000000, ClassName = "bw_blowtorch_t5", Level = 2500},

	["Pickaxe"] 				= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 200000, ClassName = "epicpickax", Level = 50}, 
}--e


BaseWars.SpawnList.Models.Recreational["Misc."] = {

	["Synthesizer - Piano"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_piano", Level = 2},
	["Synthesizer - Accordion"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_accordion", Level = 2},
	["Synthesizer - Electric Guitar"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_electric_guitar", Level = 2},
	["Synthesizer - Guitar"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_guitar", Level = 2},
	["Synthesizer - Harp"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_harp", Level = 2},
	["Synthesizer - Organ"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_organ", Level = 2},
	["Synthesizer - Saxophone"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_sax", Level = 2, trust = true},
	["Synthesizer - Violin"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_violin", Level = 2, vip = true},
}--e
]]