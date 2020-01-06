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

	HUD = {
		EntFont = "TargetID",
		EntFont2 = "BudgetLabel",
		EntW	= 175,
		EntH	= 25,
	},

	Rules = {
		IsHTML 	= false,
		HTML	= "http://hexahedron.pw/free_rules.html",
	},

	Adverts = {
		Time = 240,
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

	NPC = {
		FadeOut = 400,
	},

	AntiRDM = {
		HurtTime 		= 80,
		RDMSecondsAdd 	= 3,
		KarmaSecondPer 	= 4,
		KarmaLoss 		= -2,
		KarmaGlowLevel 	= -120,
	},

	PayDayBase 			= 2000,
	PayDayMin			= 150,
	PayDayDivisor		= 1000,
	PayDayRate 			= 60 * 3,
	PayDayRandom		= 50,

	StartMoney 			= 15000,

	CustomChat			= false,
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

BaseWars.Config.LogShit=false

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

if CustomizableWeaponry then
	BaseWars.SpawnList.Models.Loadout["Weapons - T1"] = {

			["Crowbar"] 				= BaseWars.GSL{Gun = true, Model = "models/weapons/w_crowbar.mdl", Price = 5*k, ClassName = "weapon_crowbar"},
			["Knife"]					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_csgo_default.mdl", Price = 15*k, ClassName = "csgo_default_knife"},
			["USP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_usp.mdl", Price = 15*k, ClassName = "cw_g4p_usp40"},
			["M1911"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/cw_pist_m1911.mdl", Price = 15*k, ClassName = "cw_m1911"},
			["FiveSeven"] 			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_fiveseven.mdl", Price = 35*k, ClassName = "cw_g4p_fiveseven"},

			["Deagle"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 50*k, ClassName = "cw_deagle"},
			["MR96"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 50*k, ClassName = "cw_mr96"},
			["MP412"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_pist_deagle.mdl", Price = 50*k, ClassName = "cw_g4p_mp412_rex"},

			["MAC11"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_cst_mac11.mdl", Price = 60*k, ClassName = "cw_mac11"},
			["UMP"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_ump45.mdl", Price = 100*k, ClassName = "cw_g4p_ump45"},
			["MP5"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_mp5.mdl", Price = 100*k, ClassName = "cw_mp5"},
			["BloodHound"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/38/w_pistol_38.mdl", Price = 100*k, ClassName = "cw_blackops3_38"},

			["Magpul"] 					= BaseWars.GSL{Gun = true, Model = "models/weapons/w_smg_p90.mdl", Price = 125*k, ClassName = "cw_g4p_magpul_masada"},
			["MR6"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/mr6/w_pistol_mr6.mdl", Price = 150*k, ClassName = "cw_blackops3_mr6"},



	}


	BaseWars.SpawnList.Models.Loadout["Weapons - T2"] = {

		["Man o' War"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/mnwr/w_ar_mnwr.mdl", Price = 200000, ClassName = "cw_blackops3_dlc4_mnwr"},
		["VSS/AS VAL"] 					= BaseWars.GSL{Gun = true, Model = "models/cw2/rifles/w_vss.mdl", Price = 200000, ClassName = "cw_vss"},
		["M3"] 							= BaseWars.GSL{Gun = true, Model = "models/weapons/w_shot_m3super90.mdl", Price = 200000, ClassName = "cw_m3super90"},
		["Spartan"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/spartan/w_shot_spartan.mdl", Price = 300000, ClassName = "cw_blackops3_spartan"},
		["M4A1"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 300000, ClassName = "cw_g4p_m4a1"},
		["XM8"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_rif_m4a1.mdl", Price = 400000, ClassName = "cw_g4p_xm8"},
		["AWM"] 						= BaseWars.GSL{Gun = true, Model = "models/weapons/w_snip_awp.mdl", Price = 500000, ClassName = "cw_g4p_awm"},
		["Sheiva"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/shva/w_ar_shva.mdl", Price = 500000, ClassName = "cw_blackops3_dlc2_shva"},
		["PeaceKeeper"] 				= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/dlc_peacekeeper/w_ar_peacekeeper.mdl", Price = 1000000, ClassName = "cw_blackops3_dlc3_peacekeeper"},
		["HG 40"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/dlc_mp400/w_smg_mp400.mdl", Price = 1000000, ClassName = "cw_blackops3_dlc3_mp400"},
		["ICR-1"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/isr27/w_ar_isr27.mdl", Price = 1500000, ClassName = "cw_blackops3_dlc2_isr27"},
	


	}

	BaseWars.SpawnList.Models.Loadout["Weapons - T3"] = {
		["KN-44"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/arak/w_ar_arak.mdl", Price = 3500000, ClassName = "cw_blackops3_dlc2_arak"},
		["XR-2"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/xr2/w_ar_xr2.mdl", Price = 5000000, ClassName = "cw_blackops3_xr2"},
		["Locus"] 					= BaseWars.GSL{Gun = true, Model = "models/loyalists/blackops3/locus/w_sr_locus.mdl", Price = 5000000, ClassName = "cw_blackops3_dlc1_locus"},
	}

	
	BaseWars.SpawnList.Models.Loadout["Ammo Kits"] = {

		["Kit"]		= BaseWars.GSL{Raid=true, Model = "models/items/boxsrounds.mdl", Price = 5000, ClassName = "cw_ammo_kit_small", Limit=15},
		["Crate"]	= BaseWars.GSL{Raid=true,Model = "models/items/boxsrounds.mdl", Price = 35000, ClassName = "cw_ammo_crate_small", Limit=15},

	}

	--[[BaseWars.SpawnList.Models.Loadout["Attachments"] = {
		["General - Suppresors"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_suppressors"},
		["General - Attachments"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_various"},
		["General - Rails"]				= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_railpack"},
		["General - UECW"]				= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "x_cw_extra_g4p_attpack"},
		["Sights - Long"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_longrange"},
		["Sights - Mid"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_midrange"},
		["Sights - Sniper"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_sniper"},
		["Sights - CQC"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_sights_cqb"},
		["Ammo - Shotgun"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_shotguns"},
		["Ammo - General"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ammotypes_rifles"},
		["Barrels - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_barrels"},
		["Barrels - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels"},
		["Barrels - AR15 (Long)"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_barrels_large"},
		["Barrels - Deagle"]	= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_deagle_barrels"},
		["Barrels - MP5"]			= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_barrels"},
		["Barrels - MR96"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mr96_barrels"},
		["Stocks - MP5"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_stocks"},
		["Stocks - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_stocks"},
		["Stocks - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_stocks"},
		["Misc - MP5"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_mp5_misc"},
		["Misc - AK74"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ak74_misc"},
		["Misc - AR15"]		= BaseWars.GSL{Model = "models/items/boxsrounds.mdl", Price = 65000, ClassName = "cw_attpack_ar15_misc"},
	}]]
else

end

BaseWars.SpawnList.Models.Entities["Generators (T1)"] = {
	["Manual Generator"]			= BaseWars.GSL{Raid=true, Model = "models/props_c17/TrapPropeller_Engine.mdl", Price = 250, ClassName = "bw_gen_manual", Limit = 1, Tooltip="I guess we all start out somewhere...\nCan be purchased in a raid."},
	["Gas Generator"]				= BaseWars.GSL{Model = "models/xqm/hydcontrolbox.mdl", Price = 1500, ClassName = "bw_gen_gas", Level = 5},
	["Solar Panel"]					= BaseWars.GSL{Model = "models/props_lab/miniteleport.mdl", Price = 5000, ClassName = "bw_gen_solar", Level = 15},
	["Coal Fired Generator"]		= BaseWars.GSL{Model = "models/props_wasteland/laundry_washer003.mdl", Price = 20000, ClassName = "bw_gen_coalfired", Level = 50},
	["Fission Reactor"]				= BaseWars.GSL{Model = "models/props/de_nuke/equipment1.mdl", Price = 75000, ClassName = "bw_gen_fission", Level = 100},
	["Fusion Reactor"]				= BaseWars.GSL{Model = "models/maxofs2d/thruster_propeller.mdl", Price = 300000, ClassName = "bw_gen_fusion", Level = 500},
	["Hydroelectric Reactor"]		= BaseWars.GSL{Model = "models/props_wasteland/laundry_washer001a.mdl", Price = 5000000, ClassName = "bw_gen_hydroelectric", Level = 1250, Limit = 1},
	["Numismatic Reactor"]			= BaseWars.GSL{Model = "models/props_c17/cashregister01a.mdl", Price = 150000000, ClassName = "bw_gen_joke", Level = 3000, Limit = 1,Tooltip='"EA Recommends!" ...huh.\n Uses money to create power very efficiently.\n One of those should be enough to power an entire base!'},
    ["Combustion Reactor"]          = BaseWars.GSL{Model = "models/props_c17/substation_transformer01a.mdl", Price = 500000000, ClassName = "bw_gen_combustion", Level = 3000, Limit = 1,Tooltip="Don't ever have power-related problems with this bad boy!"},
     
    ["Power Pole"] 					= BaseWars.GSL{
    	Model = "models/grp/powerpole/powerpole.mdl", 
    	Price = 10*k, 
    	ClassName = "bw_electric_pole", 
    	Level = 5, 
    	Limit = 2,
    	Tooltip="Simplify your power grid with this."
    },

}

BaseWars.SpawnList.Models.Entities["Dispensers (T1)"] = {

	["Vending Machine"]				= BaseWars.GSL{Model = "models/props_interiors/VendingMachineSoda01a.mdl", Price = 20000, ClassName = "bw_vendingmachine", Level = 10, ShortName = "VendMach."},
	["Weapons Crafter"]	= BaseWars.GSL{Model = "models/props_combine/combine_mortar01b.mdl", Price = 500000, ClassName = "bw_weaponcrafter", Limit=4, Level = 10, ShortName = "WepCrafter."},
	["Ammo Dispenser"]				= BaseWars.GSL{Raid=true, Model = "models/props_lab/reciever_cart.mdl", Price = 55000, ClassName = "bw_dispenser_ammo", Tooltip="Can be purchased in a raid.", Level = 30, ShortName = "AmmoDisp."},
    ["Ammo Dispenser T2"]              = BaseWars.GSL{Raid=true, Model = "models/props_lab/reciever_cart.mdl", Price = 10000000, ClassName = "bw_dispenser_ammo2", Tooltip="Can be purchased in a raid.", Level = 750, ShortName = "AmmoDispT2"},

	["Armor Dispenser"]			= BaseWars.GSL{Model = "models/props_combine/suit_charger001.mdl", Price = 50000, ClassName = "bw_dispenser_armor", Level = 50, ShortName = "ArmorDisp."},
    ["Armor Dispenser T2"]         = BaseWars.GSL{Model = "models/props_combine/suit_charger001.mdl", Price = 15000000, ClassName = "bw_dispenser_armor2", Level = 1000, ShortName = "ArmorDispT2"},

    ["Armor Dispenser"]			= BaseWars.GSL{Model = "models/props_combine/health_charger001.mdl", Price = 25000, ClassName = "bw_dispenser_health", Level = 50, ShortName = "HealthDisp."},

	["Health Pad"]					= BaseWars.GSL{Model = "models/props_lab/teleplatform.mdl", Price = 10000000, ClassName = "bw_healthpad", UseSpawnFunc = true, Level = 150},
    ["Health Pad T2"]                   = BaseWars.GSL{Model = "models/props_lab/teleplatform.mdl", Price = 150000000, ClassName = "bw_healthpad2", UseSpawnFunc = true, Level = 1500},

}

BaseWars.SpawnList.Models.Entities["Structures (T1)"] = {

	
	["Spawnpoint"]					= BaseWars.GSL{Raid=true,Model = "models/props_trainstation/trainstation_clock001.mdl", Price = 25000, Limit = 2, ClassName = "bw_spawnpoint", UseSpawnFunc = true},
 	["Vault"]					= BaseWars.GSL{Model = "models/props/de_nuke/NuclearContainerBoxClosed.mdl", Price = 50*k, ClassName = "bw_printerstorage", Limit=1, Level = 10},
 	["Weapon Box"]					= BaseWars.GSL{Model = "models/lt_c/sci_fi/box_crate.mdl", Price = 150*k, ClassName = "bw_weaponbox", Limit=3, Level = 25},
 	--["Perk Machine[unfinished]"]	= BaseWars.GSL{Model = "models/props_combine/combine_mortar01b.mdl", Price = 10000000, ClassName = "bw_upgrader", Limit=1, Level = 1500},
}

BaseWars.SpawnList.Models.Entities["Structures (T2)"] = {

	-- T2
	["Radar"]						= BaseWars.GSL{Model = "models/props_rooftop/roof_dish001.mdl", Price = 250000000, ClassName = "bw_radar",  Limit = 1, Level = 250},

}

BaseWars.SpawnList.Models.Entities["Defense"] = {

	["Ballistic Turret"] 			= BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 80000, ClassName = "bw_turret_ballistic", Limit = 3, Level = 75, ShortName = "BallTurr."},
	["Laser Turret"] 				= BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 120000, ClassName = "bw_turret_laser", Limit = 2, Level = 100, ShortName = "BallTurr."},

    ["Rapid Ballistic Turret"]                = BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 2500000, ClassName = "bw_turret_ballistic_rapid", Limit = 1, Level = 750, ShortName = "FastBallTurr."},
    ["Rapid Laser Turret"]                = BaseWars.GSL{Model = "models/Combine_turrets/Floor_turret.mdl", Price = 7500000, ClassName = "bw_turret_laser_rapid", Limit = 1, Level = 1250, ShortName = "FastLaserTurr."},
}

BaseWars.SpawnList.Models.Entities["Consumables (T1)"] = {

	["Repair Kit"]					= BaseWars.GSL{Model = "models/Items/car_battery01.mdl", Price = 2500, ClassName = "bw_repairkit", UseSpawnFunc = true},
	["Armor Kit"]					= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 2500000, ClassName = "bw_entityarmor", UseSpawnFunc = true},
    ["Heavy Armor Kit"]                  = BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_entityarmor2", UseSpawnFunc = true},
	["Battery Kit"]					= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 2500000, ClassName = "bw_battery", UseSpawnFunc = true},
    ["Heavy Battery Kit"]                 = BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_battery", UseSpawnFunc = true},

}
BaseWars.SpawnList.Models.Printers["Printers - Misc."] = {

	["Printer Paper"]				= BaseWars.GSL{Model = "models/props_junk/garbage_newspaper001a.mdl", Price = 300, ClassName = "bw_printerpaper", UseSpawnFunc = true},
	["Printer Rack"] 				= BaseWars.GSL{Model = "models/grp/rack/rack.mdl", Price = 25000, ClassName = "bw_printerrack", Level = 5, Limit = 3},
	["Capacity Kit"]				= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 1000000, ClassName = "bw_printercap", UseSpawnFunc = true},
	["Heavy Capacity Kit"]			= BaseWars.GSL{Model = "models/props_junk/cardboard_box004a.mdl", Price = 125000000, ClassName = "bw_printercap2", UseSpawnFunc = true},

}

BaseWars.SpawnList.Models.Printers["Printers (T1)"] = {

	-- T1
	["Manual Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100, ClassName = "bw_printer_manual", Limit = 1, Tooltip="..what is this?..."},
	["Basic Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 5000, ClassName = "bw_base_moneyprinter", Limit = 1, Tooltip="Well, this looks more like a printer! Unraidable.\nPrints £10/s\nMax. £10k."},
	["Copper Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 12500, ClassName = "bw_printer_copper", Level = 3, Limit = 1, Tooltip="Prints £15/s\nMax. £15k."},
	["Silver Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 20000, ClassName = "bw_printer_silver", Level = 5, Limit = 1, Tooltip="Prints £20/s\nMax. £35k."},
	["Gold Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50000, ClassName = "bw_printer_gold", Level = 10, Limit = 1, Tooltip="Prints £50/s\nMax. £90k."},
	["Platinum Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100000, ClassName = "bw_printer_platinum", Level = 15, Limit = 1, Tooltip="Prints £100/s\nMax. £180k."},
	["Diamond Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 200000, ClassName = "bw_printer_diamond", Level = 25, Limit = 1, Tooltip="Prints £150/s\nMax. £250k."},
	["Nuclear Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 500000, ClassName = "bw_printer_nuclear", Level = 40, Limit = 1, Tooltip="Prints £250/s\nMax. £500k."},
	--research
	--["Research Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 1000000, ClassName = "bw_printer_research", Level = 50, Limit = 1, Tooltip="Prints EXP150/s\nMax. EXP50k.\nPrints EXP instead of money."},
}

BaseWars.SpawnList.Models.Printers["Printers (T2)"] = {

	-- T2
	["Mobius Printer"]				= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 6000000, ClassName = "bw_printer_mobius", Level = 75, Limit = 1, Tooltip="Prints £1300/s\nMax. £6m."},
	["Dark Matter Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 15000000, ClassName = "bw_printer_darkmatter", Level = 85, Limit = 1, Tooltip="Prints £2200/s\nMax. £12m."},
	["Red Matter Printer"]    		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 25000000, ClassName = "bw_printer_redmatter", Level = 100, Limit = 1, Tooltip="Prints £3500/s\nMax. £20m."},
	["Monolith Printer"]      		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 35000000, ClassName = "bw_printer_monolith", Level = 120, Limit = 1, Tooltip="Prints £6000/s\nMax. £30m."},
	["Quantum Printer"]       		= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 55000000, ClassName = "bw_printer_quantum", Level = 150, Limit = 1, Tooltip="Prints £10000/s\nMax. £45m."},
	["Molecular Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 85000000, ClassName = "bw_printer_molecular", Level = 200, Limit = 1, Tooltip="Prints £15000/s\nMax. £60m."},
	--science
	--["Science Printer"]			= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 100000000, ClassName = "bw_printer_science", Level = 150, Limit = 1, Tooltip="Prints EXP1500/s\nMax. EXP750k.\nPrints EXP instead of money."},
}

BaseWars.SpawnList.Models.Printers["Printers (T3)"] = {

	-- T3
	["Atomic Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 10*10000000, ClassName = "bw_printer_atomic", Level = 250, Limit = 1, Tooltip="Prints £25000/s\nMax. £15m."},
	["Proton Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 15*10000000, ClassName = "bw_printer_proton", Level = 400, Limit = 1, Tooltip="Prints £45000/s\nMax. £25m."},
	["Neutron Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 25*10000000, ClassName = "bw_printer_neutron", Level = 550, Limit = 1, Tooltip="Prints £60000/s\nMax. £40m."},
	["Electron Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 40*10000000, ClassName = "bw_printer_electron", Level = 700, Limit = 1, Tooltip="Prints £90000/s\nMax. £50m."},
	["Photon Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50*10000000, ClassName = "bw_printer_photon", Level = 900, Limit = 1, Tooltip="Prints £150000/s\nMax. £75m."},
	--["Cosmic Printer"]       	= BaseWars.GSL{Model = "models/props_lab/reciever01a.mdl", Price = 50*10000001, ClassName = "bw_printer_cosmic", Level = 1000, Limit = 1, Tooltip="Your finish line.\nPrints 1LV/15s..\n Max. LV10.\nUpgrades INFINITELY, Upgrades increase maximum capacity and decrease print interval."},
}



BaseWars.SpawnList.Models.Loadout["Weapons - Misc"] = {

	["Heal Gun"]				= BaseWars.GSL{Gun = true, Model = "models/weapons/w_physics.mdl", Price = 500000, ClassName = "weapon_health", Level = 20},

	["Blowtorch T1"]			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 1000000, ClassName = "bw_blowtorch_t1", Level = 20},
	["Blowtorch T2"]			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 2500000, ClassName = "bw_blowtorch_t2", Level = 75},
	["Blowtorch T3"]			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000, ClassName = "bw_blowtorch_t3", Level = 250},
	["Blowtorch T4"]			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 250000000, ClassName = "bw_blowtorch_t4", Level = 1000},
	["Blowtorch T5"]			= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 5000000000, ClassName = "bw_blowtorch_t5", Level = 2500},

	["Pickaxe"] 				= BaseWars.GSL{Gun = true, Model = "models/weapons/w_irifle.mdl", Price = 200000, ClassName = "epicpickax", Level = 50}, 
}


BaseWars.SpawnList.Models.Recreational["Misc."] = {

	["Synthesizer - Piano"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_piano", Level = 2},
	["Synthesizer - Accordion"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_accordion", Level = 2},
	["Synthesizer - Electric Guitar"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_electric_guitar", Level = 2},
	["Synthesizer - Guitar"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_guitar", Level = 2},
	["Synthesizer - Harp"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_harp", Level = 2},
	["Synthesizer - Organ"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_organ", Level = 2},
	["Synthesizer - Saxophone"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_sax", Level = 2, trust = true},
	["Synthesizer - Violin"]					= BaseWars.GSL{Model = "models/tnf/synth.mdl", Price = 350000, ClassName = "synthesizer_violin", Level = 2, vip = true},
}