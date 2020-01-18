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

BaseWars.SpawnList = {}
BaseWars.SpawnList.Models = {}
BaseWars.SpawnList.Models.Entities = {}
BaseWars.SpawnList.Models.Loadout = {}
BaseWars.SpawnList.Models.Printers = {}
BaseWars.SpawnList.Models.Recreational = {}

local k = 1000
local m = k * 1000
local b = m * 1000

local add = BaseWars.AddToSpawn

local sl = BaseWars.SpawnList.Models 

local function AddLoadout(typ, class, name, price, lv, mdl)
	local t = {}

	local wep = weapons.Get(class)

	mdl = (mdl ~= "" and mdl) or wep.WorldModel
	if not mdl then error("Failed getting model for weapon " .. class) return end 

	name = name or wep.PrintName
	if not name then error("wtf is the name " .. class) return end 

	t.ClassName = class 
	t.Price = price 
	t.Model = mdl 
	t.Level = lv 

	t.Gun = true 

	t = add(t)
	print(typ, name)
	sl.Loadout[typ] = sl.Loadout[typ] or {} 
	sl.Loadout[typ][name] = t
end

local function GSL(t)
	return t
end

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

AddLoadout("SMGs", "cw_mac11", "MAC-11", 50*k, 30, "")
AddLoadout("SMGs", "cw_mp5", "HK MP5", 75*k, 35, "")

----

AddLoadout("Pistols", "cw_blackops3_38", "BloodHound", 65*k, 40, "models/loyalists/blackops3/38/w_pistol_38.mdl")
AddLoadout("Pistols", "cw_blackops3_mr6", "MR6", 100*k, 50, "models/loyalists/blackops3/mr6/w_pistol_mr6.mdl")

----

AddLoadout("SMGs", "cw_g4p_magpul_masada", "Magpul Masada", 200*k, 40, "models/weapons/w_smg_p90.mdl")

AddLoadout("SMGs", "cw_killdrix_acre", "ACR-E", 250*k, 50, "models/weapons/killdrix/w_acre.mdl")

AddLoadout("Assault Rifles", "cw_sg55x", "SG552", 350*k, 50, "")




--AddLoadout("SMGs", "", "", 100*k, 30, "")


if CustomizableWeaponry then


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

	
	BaseWars.SpawnList.Models.Loadout["Ammo Kits"] = {

		["Kit"]		= GSL{Raid=true, Model = "models/items/boxsrounds.mdl", Price = 5000, ClassName = "cw_ammo_kit_small", Limit=15},
		["Crate"]	= GSL{Raid=true,Model = "models/items/boxsrounds.mdl", Price = 35000, ClassName = "cw_ammo_crate_small", Limit=15},

	}

	--[[BaseWars.SpawnList.Models.Loadout["Attachments"] = {
		["General - Suppresors"]	= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_suppressors"},
		["General - Attachments"]	= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_various"},
		["General - Rails"]				= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_railpack"},
		["General - UECW"]				= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_attpack"},
		["Sights - Long"]			= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_longrange"},
		["Sights - Mid"]			= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_midrange"},
		["Sights - Sniper"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_sniper"},
		["Sights - CQC"]			= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_cqb"},
		["Ammo - Shotgun"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_shotguns"},
		["Ammo - General"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_rifles"},
		["Barrels - AK74"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_barrels"},
		["Barrels - AR15"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels"},
		["Barrels - AR15 (Long)"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels_large"},
		["Barrels - Deagle"]	= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_deagle_barrels"},
		["Barrels - MP5"]			= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_barrels"},
		["Barrels - MR96"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mr96_barrels"},
		["Stocks - MP5"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_stocks"},
		["Stocks - AR15"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_stocks"},
		["Stocks - AK74"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_stocks"},
		["Misc - MP5"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_misc"},
		["Misc - AK74"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_misc"},
		["Misc - AR15"]		= GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_misc"},
	}]]
else

end

BaseWars.SpawnList.Models.Entities["Generators (T1)"] = {
	["Manual Generator"]			= GSL{Raid=true, Model = "models/props_c17/TrapPropeller_Engine.mdl", Price = 250, ClassName = "bw_gen_manual", Limit = 1, Tooltip="I guess we all start out somewhere...\nCan be purchased in a raid."},
	["Gas Generator"]				= GSL{Model = "models/xqm/hydcontrolbox.mdl", Price = 1500, ClassName = "bw_gen_gas", Level = 5},
	["Solar Panel"]					= GSL{Model = "models/props_lab/miniteleport.mdl", Price = 5000, ClassName = "bw_gen_solar", Level = 15},
	["Coal Fired Generator"]		= GSL{Model = "models/props_wasteland/laundry_washer003.mdl", Price = 20000, ClassName = "bw_gen_coalfired", Level = 50},
	["Fission Reactor"]				= GSL{Model = "models/props/de_nuke/equipment1.mdl", Price = 75000, ClassName = "bw_gen_fission", Level = 100},
	["Fusion Reactor"]				= GSL{Model = "models/maxofs2d/thruster_propeller.mdl", Price = 300000, ClassName = "bw_gen_fusion", Level = 500},
	["Hydroelectric Reactor"]		= GSL{Model = "models/props_wasteland/laundry_washer001a.mdl", Price = 5000000, ClassName = "bw_gen_hydroelectric", Level = 1250, Limit = 1},
	["Numismatic Reactor"]			= GSL{Model = "models/props_c17/cashregister01a.mdl", Price = 150000000, ClassName = "bw_gen_joke", Level = 3000, Limit = 1,Tooltip='"EA Recommends!" ...huh.\n Uses money to create power very efficiently.\n One of those should be enough to power an entire base!'},
    ["Combustion Reactor"]          = GSL{Model = "models/props_c17/substation_transformer01a.mdl", Price = 500000000, ClassName = "bw_gen_combustion", Level = 3000, Limit = 1,Tooltip="Don't ever have power-related problems with this bad boy!"},
     
    ["Power Pole"] 					= GSL{
    	Model = "models/grp/powerpole/powerpole.mdl", 
    	Price = 10*k, 
    	ClassName = "bw_electric_pole", 
    	Level = 5, 
    	Limit = 2,
    	Tooltip="Simplify your power grid with this."
    },

}

BaseWars.SpawnList.Models.Entities["Dispensers (T1)"] = {

	["Vending Machine"]				= GSL{Model = "models/props_interiors/VendingMachineSoda01a.mdl", Price = 20000, ClassName = "bw_vendingmachine", Level = 10, ShortName = "VendMach."},
	["Weapons Crafter"]	= GSL{Model = "models/props_combine/combine_mortar01b.mdl", Price = 500000, ClassName = "bw_weaponcrafter", Limit=4, Level = 10, ShortName = "WepCrafter."},
	["Ammo Dispenser"]				= GSL{Raid=true, Model = "models/props_lab/reciever_cart.mdl", Price = 55000, ClassName = "bw_dispenser_ammo", Tooltip="Can be purchased in a raid.", Level = 30, ShortName = "AmmoDisp."},
    ["Ammo Dispenser T2"]              = GSL{Raid=true, Model = "models/props_lab/reciever_cart.mdl", Price = 10000000, ClassName = "bw_dispenser_ammo2", Tooltip="Can be purchased in a raid.", Level = 750, ShortName = "AmmoDispT2"},

	["Armor Dispenser"]			= GSL{Model = "models/props_combine/suit_charger001.mdl", Price = 50000, ClassName = "bw_dispenser_armor", Level = 50, ShortName = "ArmorDisp."},
    ["Armor Dispenser T2"]         = GSL{Model = "models/props_combine/suit_charger001.mdl", Price = 15000000, ClassName = "bw_dispenser_armor2", Level = 1000, ShortName = "ArmorDispT2"},

    ["Armor Dispenser"]			= GSL{Model = "models/props_combine/health_charger001.mdl", Price = 25000, ClassName = "bw_dispenser_health", Level = 50, ShortName = "HealthDisp."},

	["Health Pad"]					= GSL{Model = "models/props_lab/teleplatform.mdl", Price = 10000000, ClassName = "bw_healthpad", UseSpawnFunc = true, Level = 150},
    ["Health Pad T2"]                   = GSL{Model = "models/props_lab/teleplatform.mdl", Price = 150000000, ClassName = "bw_healthpad2", UseSpawnFunc = true, Level = 1500},

}

BaseWars.SpawnList.Models.Entities["Structures (T1)"] = {

	
	["Spawnpoint"]					= GSL{Raid=true,Model = "models/props_trainstation/trainstation_clock001.mdl", Price = 25000, Limit = 2, ClassName = "bw_spawnpoint", UseSpawnFunc = true},
 	["Vault"]					= GSL{Model = "models/props/de_nuke/NuclearContainerBoxClosed.mdl", Price = 50*k, ClassName = "bw_printerstorage", Limit=1, Level = 10},
 	["Weapon Box"]					= GSL{Model = "models/lt_c/sci_fi/box_crate.mdl", Price = 150*k, ClassName = "bw_weaponbox", Limit=3, Level = 25},
 	--["Perk Machine[unfinished]"]	= GSL{Model = "models/props_combine/combine_mortar01b.mdl", Price = 10000000, ClassName = "bw_upgrader", Limit=1, Level = 1500},
}

BaseWars.SpawnList.Models.Entities["Structures (T2)"] = {

	-- T2
	["Radar"]						= GSL{Model = "models/props_rooftop/roof_dish001.mdl", Price = 250000000, ClassName = "bw_radar",  Limit = 1, Level = 250},

}

BaseWars.SpawnList.Models.Entities["Defense"] = {

	["Ballistic Turret"] 			= GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 80000, ClassName = "bw_turret_ballistic", Limit = 3, Level = 75, ShortName = "BallTurr."},
	["Laser Turret"] 				= GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 120000, ClassName = "bw_turret_laser", Limit = 2, Level = 100, ShortName = "BallTurr."},

    ["Rapid Ballistic Turret"]                = GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 2500000, ClassName = "bw_turret_ballistic_rapid", Limit = 1, Level = 750, ShortName = "FastBallTurr."},
    ["Rapid Laser Turret"]                = GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 7500000, ClassName = "bw_turret_laser_rapid", Limit = 1, Level = 1250, ShortName = "FastLaserTurr."},
}

BaseWars.SpawnList.Models.Entities["Consumables (T1)"] = {

	["Repair Kit"]					= GSL{Model = "models/Items/car_battery01.mdl", Price = 2500, ClassName = "bw_repairkit", UseSpawnFunc = true},
	["Armor Kit"]					= GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 2500000, ClassName = "bw_entityarmor", UseSpawnFunc = true},
    ["Heavy Armor Kit"]                  = GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_entityarmor2", UseSpawnFunc = true},
	["Battery Kit"]					= GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 2500000, ClassName = "bw_battery", UseSpawnFunc = true},
    ["Heavy Battery Kit"]                 = GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_battery", UseSpawnFunc = true},

}
BaseWars.SpawnList.Models.Printers["Printers - Misc."] = {

	["Printer Paper"]				= GSL{Model = "models/props_junk/garbage_newspaper001a.mdl", Price = 300, ClassName = "bw_printerpaper", UseSpawnFunc = true},
	["Printer Rack"] 				= GSL{Model = "models/grp/rack/rack.mdl", Price = 25000, ClassName = "bw_printerrack", Level = 5, Limit = 3},
	["Capacity Kit"]				= GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 1000000, ClassName = "bw_printercap", UseSpawnFunc = true},
	["Heavy Capacity Kit"]			= GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_printercap2", UseSpawnFunc = true},

}

BaseWars.SpawnList.Models.Printers["Printers (T1)"] = {

	-- T1
	["Manual Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100, ClassName = "bw_printer_manual", Limit = 1, Tooltip="..what is this?..."},
	["Basic Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 5000, ClassName = "bw_base_moneyprinter", Limit = 1, Tooltip="Well, this looks more like a printer! Unraidable.\nPrints £10/s\nMax. £10k."},
	["Copper Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 12500, ClassName = "bw_printer_copper", Level = 3, Limit = 1, Tooltip="Prints £15/s\nMax. £15k."},
	["Silver Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 20000, ClassName = "bw_printer_silver", Level = 5, Limit = 1, Tooltip="Prints £20/s\nMax. £35k."},
	["Gold Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50000, ClassName = "bw_printer_gold", Level = 10, Limit = 1, Tooltip="Prints £50/s\nMax. £90k."},
	["Platinum Printer"]			= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100000, ClassName = "bw_printer_platinum", Level = 15, Limit = 1, Tooltip="Prints £100/s\nMax. £180k."},
	["Diamond Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 200000, ClassName = "bw_printer_diamond", Level = 25, Limit = 1, Tooltip="Prints £150/s\nMax. £250k."},
	["Nuclear Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 500000, ClassName = "bw_printer_nuclear", Level = 40, Limit = 1, Tooltip="Prints £250/s\nMax. £500k."},
	--research
	--["Research Printer"]			= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 1000000, ClassName = "bw_printer_research", Level = 50, Limit = 1, Tooltip="Prints EXP150/s\nMax. EXP50k.\nPrints EXP instead of money."},
}

BaseWars.SpawnList.Models.Printers["Printers (T2)"] = {

	-- T2
	["Mobius Printer"]				= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 6000000, ClassName = "bw_printer_mobius", Level = 75, Limit = 1, Tooltip="Prints £1300/s\nMax. £6m."},
	["Dark Matter Printer"]			= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 15000000, ClassName = "bw_printer_darkmatter", Level = 85, Limit = 1, Tooltip="Prints £2200/s\nMax. £12m."},
	["Red Matter Printer"]    		= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 25000000, ClassName = "bw_printer_redmatter", Level = 100, Limit = 1, Tooltip="Prints £3500/s\nMax. £20m."},
	["Monolith Printer"]      		= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 35000000, ClassName = "bw_printer_monolith", Level = 120, Limit = 1, Tooltip="Prints £6000/s\nMax. £30m."},
	["Quantum Printer"]       		= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 55000000, ClassName = "bw_printer_quantum", Level = 150, Limit = 1, Tooltip="Prints £10000/s\nMax. £45m."},
	["Molecular Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 85000000, ClassName = "bw_printer_molecular", Level = 200, Limit = 1, Tooltip="Prints £15000/s\nMax. £60m."},
	--science
	--["Science Printer"]			= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100000000, ClassName = "bw_printer_science", Level = 150, Limit = 1, Tooltip="Prints EXP1500/s\nMax. EXP750k.\nPrints EXP instead of money."},
}

BaseWars.SpawnList.Models.Printers["Printers (T3)"] = {

	-- T3
	["Atomic Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 10*10000000, ClassName = "bw_printer_atomic", Level = 250, Limit = 1, Tooltip="Prints £25000/s\nMax. £15m."},
	["Proton Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 15*10000000, ClassName = "bw_printer_proton", Level = 400, Limit = 1, Tooltip="Prints £45000/s\nMax. £25m."},
	["Neutron Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 25*10000000, ClassName = "bw_printer_neutron", Level = 550, Limit = 1, Tooltip="Prints £60000/s\nMax. £40m."},
	["Electron Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 40*10000000, ClassName = "bw_printer_electron", Level = 700, Limit = 1, Tooltip="Prints £90000/s\nMax. £50m."},
	["Photon Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50*10000000, ClassName = "bw_printer_photon", Level = 900, Limit = 1, Tooltip="Prints £150000/s\nMax. £75m."},
	--["Cosmic Printer"]       	= GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50*10000001, ClassName = "bw_printer_cosmic", Level = 1000, Limit = 1, Tooltip="Your finish line.\nPrints 1LV/15s..\n Max. LV10.\nUpgrades INFINITELY, Upgrades increase maximum capacity and decrease print interval."},
}



BaseWars.SpawnList.Models.Loadout["Weapons - Misc"] = {

	["Heal Gun"]				= GSL{Gun = true, Model = "models/weapons/w_physics.mdl", Price = 500000, ClassName = "weapon_health", Level = 20},

	["Blowtorch T1"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 1000000, ClassName = "bw_blowtorch_t1", Level = 20},
	["Blowtorch T2"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 2500000, ClassName = "bw_blowtorch_t2", Level = 75},
	["Blowtorch T3"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000, ClassName = "bw_blowtorch_t3", Level = 250},
	["Blowtorch T4"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 250000000, ClassName = "bw_blowtorch_t4", Level = 1000},
	["Blowtorch T5"]			= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000000, ClassName = "bw_blowtorch_t5", Level = 2500},

	["Pickaxe"] 				= GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 200000, ClassName = "epicpickax", Level = 50}, 
}


BaseWars.SpawnList.Models.Recreational["Misc."] = {

	["Synthesizer - Piano"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_piano", Level = 2},
	["Synthesizer - Accordion"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_accordion", Level = 2},
	["Synthesizer - Electric Guitar"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_electric_guitar", Level = 2},
	["Synthesizer - Guitar"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_guitar", Level = 2},
	["Synthesizer - Harp"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_harp", Level = 2},
	["Synthesizer - Organ"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_organ", Level = 2},
	["Synthesizer - Saxophone"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_sax", Level = 2, trust = true},
	["Synthesizer - Violin"]					= GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_violin", Level = 2, vip = true},
}