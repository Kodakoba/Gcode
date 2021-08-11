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


local k = 1000
local m = k * 1000
local b = m * 1000

local function CreateCategory(cat)
	local t = {
		Name = cat,
		Items = {},
		Subcategories = {},
		Priority = 0,

		Icon = nil
	}

	BaseWars.SpawnList[cat] = t
	return t
end

local function CreateSubcategory(cat, subcat)
	local t = {
		Name = subcat,
		Items = {},

		Priority = 0,
		Icon = nil
	}
				-- tier detection
	if subcat:match("[%p%s]T(%d+)[%p%s]") then
		t.Priority = -tonumber(subcat:match("[%p%s]T(%d+)[%p%s]"))
	end

	BaseWars.SpawnList[cat].Subcategories[subcat] = t
	return t
end

if CLIENT then
	if not Icon then
		include("lib_it_up/classes/icon.lua")
	end
end

local Icon = Icon or function() end

local cEnts = CreateCategory("Entities")
local cLoadout = CreateCategory("Loadout")

	if CLIENT then
		--local scMelee = CreateSubcategory("Loadout", "Melee")
		--scMelee.Priority = 10

		local scPistols = CreateSubcategory("Loadout", "Pistols")
		scPistols.Priority = 9
		scPistols.Icon = Icon("https://i.imgur.com/VkH8Yvy.png", "gun.png"):SetSize(24, 24)

		local scShotguns = CreateSubcategory("Loadout", "Shotguns")
		scShotguns.Priority = 8

		local scSMGs = CreateSubcategory("Loadout", "SMGs")
		scSMGs.Priority = 7

		local scRifles = CreateSubcategory("Loadout", "Assault Rifles")
		scRifles.Priority = 6
	end

local cPrinters = CreateCategory("Printers")
local cRecreational = CreateCategory("Recreational")


if CLIENT then
	cEnts.Icon = Icon("https://i.imgur.com/1a5sZQc.png", "entities56.png"):SetSize(28, 28)
	--cLoadout.Icon = Icon("https://i.imgur.com/1a5sZQc.png", "entities56.png"):SetSize(28, 28)
	cPrinters.Icon = Icon("https://i.imgur.com/vzrqPxk.png", "coins_pound64.png"):SetSize(28, 28)
	cRecreational.Icon = Icon("https://i.imgur.com/tKMbV5S.png", "gamepad56.png"):SetSize(28, 28)
end

local Icon = Icon or BlankFunc

local add = BaseWars.AddToSpawn

local sl = BaseWars.SpawnList

local curTier

local function SetTier(t)
	curTier = t
end

local function AddItem(cat, typ, class, name, price, lv, mdl)
	local t = {}

	t.ClassName = class
	t.Price = price
	t.Model = mdl
	t.Level = lv
	t.Tier = curTier

	t.Name = name

	t = add(t)

	local cat_t = sl[cat] or CreateCategory(cat)
	local subcat_t = cat_t.Subcategories[typ] or CreateSubcategory(cat, typ)

	cat_t.Items[#cat_t.Items + 1] = t
	subcat_t.Items[#subcat_t.Items + 1] = t

	t.CatID = #cat_t.Items
	t.SubcatID = #subcat_t.Items

	return t
end

local function AddLoadout(typ, class, name, price, lv, mdl, nongun)

	local wep = weapons.GetStored(class)

	mdl = (mdl ~= "" and mdl) or wep.WorldModel
	if not mdl then error("Failed getting model for weapon " .. class) return end 

	name = name or wep.PrintName
	if not name then error("wtf is the name " .. class) return end 

	local t = AddItem("Loadout", typ, class, name, price, lv, mdl)

	if not nongun then t.Gun = true end
end


local function AddPrinters(typ, class, name, price, lv, mdl, lim)

	local t = AddItem("Printers", typ, class, name, price, lv, mdl, lim)

	t.Limit = 1

end


local function AddRecreational(typ, class, name, price, lv, mdl, lim)

	local t = AddItem("Recreational", typ, class, name, price, lv, mdl, lim)

end

local function AddEntities(typ, class, name, price, lv, mdl, lim)
	local t = AddItem("Entities", typ, class, name, price, lv, mdl, lim)
end

local function GSL(t)
	return add(t)
end

--[[
	models/weapons/killdrix/w_acre.mdl
	models/weapons/scorpion/w_ev03.mdl
	models/weapons/w_rif_m4a1.mdl



]]



-- Weapons - Misc--

SetTier(1)
	AddLoadout("Weapons - Misc", "weapon_health", "Heal Gun", k * 500, 20, "models/weapons/w_physics.mdl")
	AddLoadout("Weapons - Misc", "epicpickax", "Pickaxe", k * 200, 50, "models/weapons/w_irifle.mdl")
	AddLoadout("Weapons - Misc", "bw_blowtorch_t1", "Blowtorch T1", k * 1000, 20, "models/weapons/w_irifle.mdl")

SetTier(2)
	AddLoadout("Weapons - Misc", "bw_blowtorch_t2", "Blowtorch T2", m * 2.5, 75, "models/weapons/w_irifle.mdl")

SetTier(3)
	AddLoadout("Weapons - Misc", "bw_blowtorch_t3", "Blowtorch T3", m * 5, 250, "models/weapons/w_irifle.mdl")

SetTier(4)
	AddLoadout("Weapons - Misc", "bw_blowtorch_t4", "Blowtorch T4", m * 250, 1000, "models/weapons/w_irifle.mdl")

SetTier(5)
	AddLoadout("Weapons - Misc", "bw_blowtorch_t5", "Blowtorch T5", b * 5, 2500, "models/weapons/w_irifle.mdl")


SetTier(nil)

-- Printers - Misc.--

	AddPrinters("Printers - Misc.", "bw_printercap", "Capacity Kit", k * 1000, 0, "models/props_junk/cardboard_box004a.mdl")
	AddPrinters("Printers - Misc.", "bw_printerrack", "Printer Rack", k * 25, 5, "models/grp/rack/rack.mdl")
	AddPrinters("Printers - Misc.", "bw_printercap2", "Heavy Capacity Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")
	AddPrinters("Printers - Misc.", "bw_printerpaper", "Printer Paper", 300, 0, "models/props_junk/garbage_newspaper001a.mdl")


-- Printers (T1)--

SetTier(1)

	AddPrinters("Printers", "bw_printer_nuclear", "Nuclear Printer", k * 500, 40, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_platinum", "Platinum Printer", k * 100, 15, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_manual", "Manual Printer", 100, 0, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_diamond", "Diamond Printer", k * 200, 25, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_base_moneyprinter", "Basic Printer", k * 5, 0, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_copper", "Copper Printer", k * 12.5, 3, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_silver", "Silver Printer", k * 20, 5, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_gold", "Gold Printer", k * 50, 10, "models/props_lab/reciever01a.mdl")


-- Printers (T2)--

SetTier(2)

	AddPrinters("Printers", "bw_printer_mobius", "Mobius Printer", m * 6, 75, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_molecular", "Molecular Printer", m * 85, 200, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_monolith", "Monolith Printer", m * 35, 120, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_quantum", "Quantum Printer", m * 55, 150, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_darkmatter", "Dark Matter Printer", m * 15, 85, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_redmatter", "Red Matter Printer", m * 25, 100, "models/props_lab/reciever01a.mdl")


-- Printers (T3)--

SetTier(3)

	AddPrinters("Printers", "bw_printer_neutron", "Neutron Printer", m * 250, 550, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_photon", "Photon Printer", m * 500, 900, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_proton", "Proton Printer", m * 150, 400, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_atomic", "Atomic Printer", m * 100, 250, "models/props_lab/reciever01a.mdl")
	AddPrinters("Printers", "bw_printer_electron", "Electron Printer", m * 400, 700, "models/props_lab/reciever01a.mdl")


SetTier(nil)

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

-- AddEntities("Defense", "bw_turret_laser_rapid", "Rapid Laser Turret", m * 7.5, 1250, "models/Combine_turrets/Floor_turret.mdl")
-- AddEntities("Defense", "bw_turret_ballistic", "Ballistic Turret", k * 80, 75, "models/Combine_turrets/Floor_turret.mdl")
-- AddEntities("Defense", "bw_turret_laser", "Laser Turret", k * 120, 100, "models/Combine_turrets/Floor_turret.mdl")
-- AddEntities("Defense", "bw_turret_ballistic_rapid", "Rapid Ballistic Turret", m * 2.5, 750, "models/Combine_turrets/Floor_turret.mdl")


-- Structures (T2)--

-- AddEntities("Structures", "bw_radar", "Radar", m * 250, 250, "models/props_rooftop/roof_dish001.mdl")


-- Consumables (T1)--

AddEntities("Consumables", "bw_battery", "Battery Kit", m * 2.5, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables", "bw_repairkit", "Repair Kit", k * 2.5, 0, "models/Items/car_battery01.mdl")
AddEntities("Consumables", "bw_battery", "Heavy Battery Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables", "bw_entityarmor", "Armor Kit", m * 2.5, 0, "models/props_junk/cardboard_box004a.mdl")
AddEntities("Consumables", "bw_entityarmor2", "Heavy Armor Kit", m * 125, 0, "models/props_junk/cardboard_box004a.mdl")


-- Generators (T1)--

SetTier(1)
	AddEntities("Generators", "bw_gen_manual", "Manual Generator", 250, 0, "models/props_c17/TrapPropeller_Engine.mdl")
	AddEntities("Generators", "bw_gen_solar", "Solar Panel", k * 1.5, 1, "models/props_lab/miniteleport.mdl")
	AddEntities("Generators", "bw_gen_gas", "Gas Generator", k * 5, 5, "models/xqm/hydcontrolbox.mdl")

SetTier(2)
	AddEntities("Generators", "bw_gen_coalfired", "Coal Fired Generator", k * 20, 50, "models/props_wasteland/laundry_washer003.mdl")
	AddEntities("Generators", "bw_gen_fission", "Fission Reactor", k * 75, 100, "models/props/de_nuke/equipment1.mdl")
	AddEntities("Generators", "bw_gen_fusion", "Fusion Reactor", k * 300, 500, "models/maxofs2d/thruster_propeller.mdl")

SetTier(3)
	AddEntities("Generators", "bw_gen_joke", "Numismatic Reactor", m * 150, 3000, "models/props_c17/cashregister01a.mdl")
	AddEntities("Generators", "bw_gen_hydroelectric", "Hydroelectric Reactor", m * 5, 1250, "models/props_wasteland/laundry_washer001a.mdl")
	AddEntities("Generators", "bw_gen_combustion", "Combustion Reactor", m * 500, 3000, "models/props_c17/substation_transformer01a.mdl")



-- Structures (T1)--

SetTier(1)
	AddEntities("Structures", "bw_spawnpoint", "Spawnpoint", k * 25, 0, "models/props_trainstation/trainstation_clock001.mdl")


-- Dispensers (T1)--

SetTier(1)
	AddEntities("Dispensers", "bw_vendingmachine", "Vending Machine", k * 20, 10, "models/props_interiors/VendingMachineSoda01a.mdl")
	AddEntities("Dispensers", "bw_dispenser_health", "Health Dispenser", k * 25, 50, "models/props_combine/health_charger001.mdl")
	AddEntities("Dispensers", "bw_dispenser_ammo", "Ammo Dispenser", k * 55, 30, "models/props_lab/reciever_cart.mdl")

SetTier(2)
	AddEntities("Dispensers", "bw_dispenser_armor2", "Armor Dispenser T2", m * 15, 1000, "models/props_combine/suit_charger001.mdl")
	AddEntities("Dispensers", "bw_dispenser_ammo2", "Ammo Dispenser T2", m * 10, 750, "models/props_lab/reciever_cart.mdl")

----

--AddLoadout("Melee", "weapon_crowbar", "Crowbar", 2.5*k, 3, "models/weapons/w_crowbar.mdl")
--AddLoadout("Melee", "csgo_default_knife", "Knife", 10*k, 5, "models/weapons/w_csgo_default.mdl")

-- Shit-tier --

SetTier(1)
	AddLoadout("Pistols", "arccw_makarov", "PM", 				15*k, 3)
	AddLoadout("Pistols", "arccw_fml_fas_ots33", "OTS 33", 		10*k, 5)
	AddLoadout("Pistols", "arccw_go_p2000", "P2000", 			12.5*k, 5)
	AddLoadout("Pistols", "arccw_go_usp", "USP", 				15*k, 7)
	AddLoadout("Pistols", "arccw_go_m9", "M9 Beretta", 			15*k, 7)
	AddLoadout("Pistols", "arccw_go_p250", "P250", 				20*k, 7)


	AddLoadout("Shotguns", "arccw_db", "Sawn-off", 25 * k, 10, "models/weapons/arccw/w_sawnoff.mdl")
	AddLoadout("Shotguns", "arccw_go_nova", "Nova", 50 * k, 15, nil)
	AddLoadout("Shotguns", "arccw_dmi_r870_sg_elite", "Remington M870", 60 * k, 20, nil)

	AddLoadout("SMGs", "arccw_dmi_hk94a2_export", "HK94", 		15*k, 15, nil)
	AddLoadout("SMGs", "arccw_dmi_mkgs_banshee", "Banshee", 	20*k, 15, nil) -- slightly better than hk94, still semi
	AddLoadout("SMGs", "arccw_mw2_tmp", "TMP", 					30*k, 15)
	AddLoadout("SMGs", "arccw_mw2_miniuzi", "Mini Uzi", 		50*k, 20)
	AddLoadout("SMGs", "arccw_go_mp9", "MP9", 					50*k, 20)

	AddLoadout("Sniper Rifles", "arccw_contender", "G2 Contender", k * 50, 25, "models/weapons/arccw/w_contender.mdl")

	AddLoadout("Assault Rifles", "arccw_go_ar15", "AR15", 35*k, 20)



-- Low-Mid tier --

SetTier(2)
	AddLoadout("Pistols", "arccw_go_fiveseven", "Five-seven", 	25*k, 7)
	AddLoadout("Pistols", "arccw_go_cz75", "CZ-75", 			25*k, 7)
	AddLoadout("Pistols", "arccw_go_tec9", "Tec-9", 			25*k, 7)
	AddLoadout("Pistols", "arccw_go_deagle", "Deagle", 			40*k, 15)
	AddLoadout("Pistols", "arccw_go_r8", "R8 Revolver", 		50*k, 20)

	AddLoadout("SMGs", "arccw_fml_fas_mp5", "HK MP5K", 					75*k, 30, "models/weapons/w_smg_mp5.mdl")
	AddLoadout("SMGs", "arccw_go_mp5", "MP5A3", 						75*k, 30, nil)
	AddLoadout("SMGs", "arccw_fml_fas_extra_comando9", "Commando 9", 	90*k, 30)
	AddLoadout("SMGs", "arccw_go_ump", "UMP45 (v1)", 					100*k, 30, nil)
	AddLoadout("SMGs", "arccw_mw2_ump45", "UMP45 (v2)", 				100*k, 40)

	AddLoadout("Assault Rifles", "arccw_fml_fas_g36c", "G36", 		75*k, 30, nil)
	AddLoadout("Assault Rifles", "arccw_fml_fas_ak47", "AK-47", 	75*k, 35, "models/weapons/arccw/fml/fas1/w_ak47.mdl")
	AddLoadout("Assault Rifles", "arccw_fml_fas_famas", "FAMAS", 	125*k, 40, "models/weapons/arccw/fml/fas1/w_famas.mdl")
	AddLoadout("Assault Rifles", "arccw_go_ace", "Galil", 			125*k, 40)
	AddLoadout("Assault Rifles", "arccw_fml_fas_g3a3", "G3A3", 		150*k, 40, "models/weapons/arccw/fml/fas1/w_g3a3.mdl")

	AddLoadout("Sniper Rifles", "arccw_go_ssg08", "Scout", 120 * k, 50)

-- Mid tier --

AddLoadout("Sniper Rifles", "arccw_fml_fas_m24", "M24", 200 * k, 50,"models/weapons/arccw/fml/fas1/w_m24.mdl")
AddLoadout("Sniper Rifles", "arccw_fml_fas_m82", "Barett M82", 350 * k, 60, "models/weapons/arccw/fml/fas1/w_m82.mdl")

--AddLoadout("Assault Rifles", "cw_g4p_an94", "G36", 200*k, 65, "models/weapons/w_rif_ak47.mdl")
--AddLoadout("Assault Rifles", "cw_tr09_tar21", "TAR-21", 300*k, 65, "models/weapons/therambotnic09/w_cw2_tar21.mdl")

--AddLoadout("Assault Rifles", "cw_g4p_m16a2", "M16A2", 350*k, 80, "models/weapons/w_rif_m4a1.mdl")
--AddLoadout("Assault Rifles", "cw_tr09_qbz97", "QBZ-97", 350*k, 80, "models/weapons/therambotnic09/w_cw2_qbz97.mdl")

--AddLoadout("Assault Rifles", "cw_g4p_masada_acr", "ACR", 350*k, 100, "models/weapons/therambotnic09/w_cw2_qbz97.mdl")

-- Mid-Top tier --

AddLoadout("Assault Rifles", "arccw_fml_fas_m14", "M14", 350*k, 125, "models/weapons/arccw/fml/fas1/w_m14.mdl")
AddLoadout("Assault Rifles", "arccw_mw2_f2000", "F2000", 150*k, 125)
--AddLoadout("Assault Rifles", "cw_g4p_xm8", "XM8", 500*k, 150, "models/weapons/w_rif_m4a1.mdl")
--AddLoadout("Assault Rifles", "cw_g4p_m4a1", "M4A1", 750*k, 175, "models/weapons/w_rif_m4a1.mdl")
AddLoadout("Assault Rifles", "arccw_fml_fas_sg550", "SG550", 250*k, 50, "models/weapons/arccw/fml/fas1/w_sg550.mdl")

-- Top-tier --

--AddLoadout("SMGs", "cw_scorpin_evo3", "Scorpion Evo", 750*k, 200, "models/weapons/scorpion/w_ev03.mdl")

--AddLoadout("Assault Rifles", "cw_ar15", "AR15", 1250*k, 220, "models/weapons/w_rif_m4a1.mdl") --the AR15 is somehow better than M4A1
--AddLoadout("Assault Rifles", "cw_tr09_mk18", "MK18", 1.5*m, 220, "models/weapons/therambotnic09/w_cw2_mk18.mdl") 
--AddLoadout("Assault Rifles", "cw_kk_hk416", "HK416", 1.5*m, 260, "models/weapons/w_cwkk_hk416.mdl") 
--AddLoadout("Assault Rifles", "cw_covertible_ak12", "AK-12", 2.5*m, 300, "models/weapons/w_rif_covertible_ak12.mdl") 


----
