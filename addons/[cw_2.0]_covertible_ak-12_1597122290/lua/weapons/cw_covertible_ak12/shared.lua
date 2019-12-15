AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

CustomizableWeaponry:registerAmmo("5.45x39MM", "5.45x39MM Rounds", 5.45, 39)

SWEP.EffectiveRange_Orig = 100 * 180
SWEP.DamageFallOff_Orig = .25

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "AK-12"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/weapons/w_rif_covertible_ak12.mdl"
	SWEP.WMPos = Vector(-1, 2.5, 0.5)
	SWEP.WMAng = Vector(0, 0, 180)
	
	SWEP.IronsightPos = Vector(-1.936, 0, 0.439)
	SWEP.IronsightAng = Vector(0.546, 0.009, 0)
	
	SWEP.MicroT1Pos = Vector(-1.95, -1.005, 0)
	SWEP.MicroT1Ang = Vector(0.2, -0.026, 0)

	SWEP.AimpointPos = Vector(-1.958, 0, -0.2)
	SWEP.AimpointAng = Vector(0.45, -0.03, 0)
	
	SWEP.EoTechPos = Vector(-1.9485, 0, -0.607)
	SWEP.EoTechAng = Vector(0.4, -0.01, 0)

    SWEP.ACOGPos = Vector(-1.92, 0, -0.616)
	SWEP.ACOGAng = Vector(1.45, 0.319, 0)
	
	SWEP.RMRPos = Vector(-1.933, 0, 0)
	SWEP.RMRAng = Vector(0.949, -0, 0)
	
	SWEP.ShortDotPos = Vector(-1.936, 0, -0.04)
	SWEP.ShortDotAng = Vector(-0.854, -0.101, 0)
	
	SWEP.ShortenedPos = Vector(-1.936, 0, 0.439)
	SWEP.ShortenedAng = Vector(0.546, 0.009, 0)
	
	SWEP.NXSPos = Vector(-1.926, 0.4, -0.28)
	SWEP.NXSAng = Vector(0.217, -0, 0)

	SWEP.AlternativePos = Vector(-0.24, 0, -0.48)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(7.829, -1.22, -0.5)
    SWEP.SprintAng = Vector(-10.75, 46.066, 0)
	
--	SWEP.SprintPos = Vector(2.578, -0.84, -0.06)
--	SWEP.SprintAng = Vector(-5.915, 25.457, 0)
	
	SWEP.CustomizePos = Vector(4.647, 0, -0.547)
	SWEP.CustomizeAng = Vector(6.801, 29.028, 0)
	
--[[--------------------Unofficial ATTACHMENTS-------------------------]]--

	SWEP.CmorePos = Vector(-1.917, 0, 0.158)
	SWEP.CmoreAng = Vector(-1.3, 0.055, 0)
	
	SWEP.ReflexPos = Vector(-1.943, 0, 0)
	SWEP.ReflexAng = Vector(.212, 0.009, 0)
	
	SWEP.ELCANPos = Vector(-1.943, 0, 0)
	SWEP.ELCANAng = Vector(-1.285, -0.101, 0)
	
	SWEP.CSGOACOGPos = Vector(-1.92, 0, -0.4)
	SWEP.CSGOACOGAng = Vector(1.45, 0.319, 0)
	
	SWEP.CSGO556Pos = Vector(-1.92, 0, 0)
	SWEP.CSGO556Ang = Vector(0.279, 0.25, 0)
	
	SWEP.CSGOSSGPos = Vector(-2.76, -2.8, 0.4)
	SWEP.CSGOSSGAng = Vector(0, 0, 0)
	
--	SWEP.LeupoldPos = Vector(-1.945, 0.437, -0.179)
--	SWEP.LeupoldAng = Vector(0, 0.1, 0)
	
--	SWEP.BallisticPos = Vector(-2.76, -4.6, 0.36)
--	SWEP.BallisticAng = Vector(0, 0, 0)

--[[----------------------------------------------]]--
	
	SWEP.ViewModelMovementScale = 1.45
	SWEP.MoveType = 1
	
	SWEP.LaserPosAdjust = Vector(-0.6, 0, 0.2)
	SWEP.LaserAngAdjust = Angle(0, 179.095, 0) 
	
	SWEP.LaserAngAdjustAim = Angle(0, 180.6, 0)
	
    SWEP.BackupSights = {
	["md_acog"] = {[1] = Vector(-1.945, 0, -1.6), [2] = Vector(0.7, 0.004, 0)},
	["md_12_elcan"] = {[1] = Vector(-1.945, 0, -0.88), [2] = Vector(0.55, -0.11, 0)},
    ["md_uecw_csgo_556"] = {[1] = Vector(-1.945, 0, -1.0), [2] = Vector(1.5, -0.03, 0)}}
	
	SWEP.IconLetter = "b"
	killicon.AddFont("cw_ak74", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_OTS"
	SWEP.PosBasedMuz = false
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 1.5, y = -0.5, z = 1.5}
	SWEP.SightWithRail = false
		
	SWEP.AttachmentModelsVM = {
		["md_nightforce_nxs"] = {model = "models/cw2/attachments/l96_scope.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.01, -4.569, 5.077), angle = Angle(0, -90, 0), size = Vector(1.116, 1.116, 1.116)},
		["md_bipod"] = {model = "models/wystan/attachments/bipod.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.1, 6.8, 0.834), angle = Angle(0, 0, 0), size = Vector(0.87, 0.87, 0.87)},
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.25, -8.709, -1.456), angle = Angle(0, -90, 0), size = Vector(0.933, 0.933, 0.933)},
		["md_rmr"] = {model = "models/cw2/attachments/pistolholo.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.267, -4.861, -1.53), angle = Angle(0, -90, 0), size = Vector(0.949, 0.949, 0.949)},
	    ["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.054, -2.774, 4.03), angle = Angle(0, 0, 0), size = Vector(0.379, 0.379, 0.379)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.276, -9.162, -1.52), angle = Angle(0, 0, 0), size = Vector(0.948, 0.948, 0.948)},
	    ["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.03, 4.046, 3.786), angle = Angle(0, 90, 0), size = Vector(0.509, 0.509, 0.509)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.419, -17.743, -9.931), angle = Angle(0, -90, 0), size = Vector(1.286, 1.286, 1.286)},
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.176, -8.773, -1.568), angle = Angle(0, 0, 0), size = Vector(0.959, 0.959, 0.959)},
		["md_pbs1"] = {model = "models/cw2/attachments/pbs1.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.07, 17.275, 1.429), angle = Angle(0, 180, 0), size = Vector(0.746, 1.195, 0.746)},

		["md_cmore"] = { type = "Model", model = "models/attachments/cmore.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.09, -2.75, 3.839), angle = Angle(0, 0, 0), size = Vector(0.718, 0.718, 0.718)},
		["md_reflex"] = { type = "Model", model = "models/attachments/kascope.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.065, -0.101, 4.087), angle = Angle(0, 0, 0), size = Vector(0.718, 0.718, 0.718)},

	    ["md_12_elcan"] = { type = "Model", model = "models/bunneh/elcan.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.171, -8.207, -0.26), angle = Angle(0, 0, 0), size = Vector(0.718, 0.718, 0.718)},
		["md_uecw_csgo_acog"] = { type = "Model", model = "models/gmod4phun/csgo/eq_optic_acog.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.125, -9.664, 0.057), angle = Angle(0, -90, 0), size = Vector(0.855, 0.855, 0.855)},
		["md_uecw_csgo_556"] = { type = "Model", model = "models/gmod4phun/csgo/eq_optic_sig.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.125, -2.757, 3.65), angle = Angle(0, -90, 0), size = Vector(0.773, 0.773, 0.773)}
		
--	    ["md_uecw_csgo_scope_ssg"] = { type = "Model", model = "models/gmod4phun/csgo/eq_optic_scope_bender.mdl", bone = "AK12_Body", rel = "", pos = Vector(0.119, -4.255, 3.65), angle = Angle(0, -90, 0), size = Vector(0.773, 0.773, 0.773)}

--      ["md_ballistic"] = { type = "Model", model = "models/bunneh/scope01.mdl", bone = "AK12_Body", rel = "", pos = Vector(-0.171, -8.207, -0.26), angle = Angle(0, 0, 0), size = Vector(0.718, 0.718, 0.718)}
	}
--[[	
	SWEP.ForegripOverridePos = {
	["bipod"] = {
	[""] = { scale = Vector(1, 1, 1), pos = Vector(-11, 0, -11), angle = Angle(0, 0, 0) }},
	
	["null"] = {
	[""] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }}}
--]]
	SWEP.ACOGAxisAlign = {right = -2.4, up = -0.6, forward = 0}
	SWEP.ElcanAxisAlign = {right = 0, up = 0.01, forward = 0}

	SWEP.NXSAlign = {right = -1.19, up = -0.27, forward = 0}
	SWEP.PSO1AxisAlign = {right = 0, up = 0.4, forward = -90}
	SWEP.SchmidtShortDotAxisAlign = {right = -0.1, up = -0.2, forward = 0}
	
	SWEP.AttachmentPosDependency = {["md_pbs1"] = {["bg_ak12_longbarrel"] = Vector(0.07, 22, 1.429), ["bg_ak12_ubarrel"] = Vector(0.07, 15.275, 1.429)}}
	
    SWEP.CustomizationMenuScale = 0.0135
end
	
SWEP.BoltBone = "AK12_bolt"
SWEP.BoltShootOffset = Vector(-2.2, 0, 0)

SWEP.MuzzleVelocity = 900-- in meter/s

SWEP.SightBGs = {main = 2, none = 1} -- 2, 1 sight bg / 3, 1 Short barrel -- 3, 2 Long barrel / 4, 1 Big mag / 5, 1 no stock 
SWEP.BarrelBGs = {main = 3, longris = 0, long = 2, short = 1, magpul = 0, ris = 0, regular = 0}
SWEP.StockBGs = {main = 5, regular = 0, retractable = 2, none = 1}
SWEP.MagBGs = {main = 4, regular = 0, round60 = 1, round20 = 3, round7_62x39 = 2, round7_62x51 = 4, round7_rpk12 = 5}

SWEP.LuaViewmodelRecoil = true
SWEP.LuaVMRecoilAxisMod = {vert = 0.55, hor = 1.1, roll = 1.05, forward = 0.8, pitch = 0.5}



local exs = {}

local deps = {
	["bg_rpk_12_mag"] = {"bg_ak762x39rndammo"},
	["bg_svd12rndmag"] = {"bg_ak762x51rndammo"},
}

local ammo762 = {	--subammunition
	"bg_ak762x39hp",
	"bg_ak762x39bp",
	"bg_ak762x39us",
}

local ammo545 = {}
local ammo76251 = {"bg_ak762x51"}

local mags = {
	["bg_ak12_20rndmag"] = "",
	["bg_ak12_50rndmag"] = "",
	["bg_rpk_12_mag"] = "bg_ak762x39rndammo",
	["bg_svd12rndmag"] = "bg_ak762x51rndammo",
}

local ammos = {
	"bg_ak762x39rndammo", "bg_ak762x51rndammo", ""
}

--[[

	Add subammunition to their calibers (7.62x39 US to 7.62x39 caliber)

]]


for k,v in pairs(ammo762) do 
	deps[v] = {"bg_ak762x39rndammo"}
end

for k,v in pairs(ammo545) do 
	deps[v] = {"bg_ak545x39rndammo"}
end

for k,v in pairs(ammo762) do 
	deps[v] = {"bg_ak762x39rndammo"}
end

SWEP.Attachments = {
    [1] = {header = "Sight", offset = {260, -650}, atts = {"md_rmr", "md_microt1", "md_aimpoint", "md_eotech", "md_schmidt_shortdot", "md_acog", "md_nightforce_nxs"}},
    [2] = {header = "Receiver", offset = {-400, -680}, atts = {"bg_ak12_longbarrel", "bg_ak12_ubarrel"}},
    [3] = {header = "Rail", offset = {280, -80}, atts = {"md_anpeq15"}},
    [4] = {header = "Barrel", offset = {-350, -100}, atts = {"md_pbs1"}},
    [5] = {header = "Magazine", offset = {-200, 400}, atts = {"bg_ak12_20rndmag", "bg_ak12_50rndmag", "bg_svd12rndmag", "bg_rpk_12_mag"}},
    ["+reload"] = {header = "Caliber", offset = {580, 550}, atts = {"bg_ak762x39us", "bg_ak762x39hp", "bg_ak762x39bp"}},
    ["+use"] = {header = "Ammunition", offset = {580, 50}, atts = {"bg_ak762x39rndammo", "bg_ak762x51rndammo"}},
    [8] = {header = "Stock", offset = {1500, 600}, atts = {"bg_retracted_stock", "bg_ak12_nostock"}},
    [9] = {header = "Handguard", offset = {-800, 200}, atts = {"md_bipod"}, dependencies = {bg_ak12_longbarrel = true}},
    --["+reload"] = {header = "Ammo", offset = {580, 500}, atts = {"am_magnum", "am_matchgrade"}}
}


for k,v in pairs(mags) do 

	local exclus = {}

	for k, str in pairs(ammos) do 
		if v==str and str ~= "" then continue end
		exclus[#exclus + 1] = str
	end


	exs[k] = exclus 
end


SWEP.AttachmentDependencies = deps 
SWEP.AttachmentExclusions = exs



if CustomizableWeaponry_OP_Perks then 
	 SWEP.Attachments[7] = {header = "Perks", offset = {1300, 170}, atts = {"Cod_Extreme_Conditioning", "Cod_Fast_Hands", "Cod_Steady_Aim", "Perk_Force", "Cod_Double_Tap", "Perk_Stopping_Power"}}
end

if CustomizableWeaponry_G4P_UECW then 
	SWEP.Attachments[1].atts = {"md_rmr", "md_microt1", "md_cmore", "md_reflex", "md_aimpoint", "md_eotech", "md_schmidt_shortdot", "md_12_elcan", "md_uecw_csgo_acog", "md_uecw_csgo_556", "md_acog", "md_nightforce_nxs"}
end




SWEP.Animations = {fire = {"shoot3"},
	reload = "reload",
	reload_empty = "reload_unsil",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {

    draw = {[1] ={time = 0.05, sound = "CW_FOLEY_MEDIUM"},
	[2] ={time = 0.05, sound = "CW_AK12_SAFE"}, 
	[3] = {time = 0.45, sound = "CW_CLOTH2"},
    [4] = {time = 0.55, sound = "CW_AK12_GRIP"},
    [5] = {time = 0.75, sound = "CW_AK12_CLOTH"},
	[6] = {time = 0.8, sound = "CW_CLOTH3"}},
	
	draw_unsil = {[1] ={time = 0, sound = "CW_FOLEY_MEDIUM"}},

	reload = {[1] = {time = 0.15, sound = "CW_CLOTH4"},
	[2] = {time = 0.35, sound = "CW_BF4_AK12_MAGOUT"},
	[3] = {time = 0.8, sound = "CW_CLOTH1"},
	[4] = {time = 1.16, sound = "CW_BF4_AK12_MAGIN"},
	[5] = {time = 1.2, sound = "CW_BF4_AK12_MAGIN2"},
	[6] = {time = 1.7, sound = "CW_CLOTH2"},
	[7] = {time = 1.8, sound = "CW_AK12_BOLT"},
	[8] = {time = 1.85, sound = "CW_CLOTH3"}},
	
	reload_unsil = {[1] = {time = 0.15, sound = "CW_CLOTH4"},
	[2] = {time = 0.48, sound = "CW_BF4_AK12_MAGOUT"},
	[3] = {time = 0.8, sound = "CW_CLOTH1"},
	[4] = {time = 1.32, sound = "CW_BF4_AK12_MAGIN"},
	[5] = {time = 1.46, sound = "CW_BF4_AK12_MAGIN2"},
	[6] = {time = 1.7, sound = "CW_CLOTH2"},
	[7] = {time = 2.18, sound = "CW_AK12_BOLT"},
	[8] = {time = 2.2, sound = "CW_CLOTH3"}}}
	
SWEP.SpeedDec = 20

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "[CW2.0] Yan's Guns"

SWEP.Author			= "Xxyan700xX"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_rif_covertible_ak12.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_covertible_ak12.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 360
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.45x39MM"

SWEP.FireDelay = 0.09
SWEP.FireSound = "CW_BF4_AK12_FIRE"
SWEP.FireSoundSuppressed = "CW_AK12_FIRE_SUPPRESSED"
SWEP.Recoil = 0.92

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.013
SWEP.VelocitySensitivity = 1.55
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.16
SWEP.Shots = 1
SWEP.Damage = 32
SWEP.DeployTime = 1.15

SWEP.ReloadSpeed = 0.9
SWEP.ReloadTime = 2.6
SWEP.ReloadTime_Empty = 2.9
SWEP.ReloadHalt = 2.6
SWEP.ReloadHalt_Empty = 2.9
SWEP.SnapToIdlePostReload = true

function SWEP:IndividualThink()

	self.EffectiveRange = 100 * 180
	self.DamageFallOff = .25
	
	if self.ActiveAttachments.bg_ak762x39rndammo or self.ActiveAttachments.bg_rpk_12_mag then
	
	    self.EffectiveRange = 100 * 200
	    self.DamageFallOff = .22
		
	elseif self.ActiveAttachments.bg_svd12rndmag then
	
	    self.EffectiveRange = 100 * 235
	    self.DamageFallOff = .20
		
	elseif not self.ActiveAttachments.bg_ak762x39rndammo or self.ActiveAttachments.bg_rpk_12_mag or self.ActiveAttachments.bg_svd12rndmag then
	
	    self.EffectiveRange = 100 * 180
	    self.DamageFallOff = .25
	end
	
	if self.dt.BipodDeployed or self.ActiveAttachments.md_nightforce_nxs then 
	    self.AimBreathingEnabled = true
		
	elseif not self.dt.BipodDeployed or self.ActiveAttachments.md_nightforce_nxs then
	    self.AimBreathingEnabled = false
	end
	
    self.Animations.draw = "draw_unsil"
	if self.Animations.draw == "draw_unsil" then
	    self.DeployTime = 0.6
	end
end
