if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.ExtraMags = 6
end

if CLIENT then
    SWEP.PrintName = "Remington 870"
    SWEP.Slot = 4
    SWEP.SlotPos = 0
	
	SWEP.AimPos = Vector(-1.856, -4.935, 1.919)
	SWEP.AimAng = Vector(0, 0.15, 0)
	
	SWEP.YawMod = 0.1
	SWEP.ReloadCycleTime = 0.985
	
	SWEP.MuzzleEffect = "muzzleflash_shotgun"
	//SWEP.AttachmentBGs = {["compm4"] = {bg = 2, sbg = 1}}
	
	SWEP.WMAng = Vector(0, 180, 180)
	SWEP.WMPos = Vector(1, -3.2, 0.25)
	SWEP.MagText = "TUBE "
	SWEP.BoltReminderText = "RELOAD KEY - PUMP SHOTGUN"
	
	SWEP.AnimOverride = {["pump02"] = true,
	["pump01_scoped"] = true,
	["pump01_nomen"] = true,
	["pump01_nomen_scoped"] = true}
	
	SWEP.SprintPos = Vector(5, -3, 0.5)
	SWEP.SprintAng = Vector(-12.968, 47.729, 0)
end

//SWEP.Attachments = {[1] = {header = "Sight", sight = true, x = 600, y = -50, atts = {"compm4"}}}

SWEP.BulletLength = 5
SWEP.CaseLength = 5.2
SWEP.EmptySound = Sound("weapons/empty_shotguns.wav")

SWEP.Anims = {}
SWEP.Anims.Draw_First = "deploy_first"
SWEP.Anims.Draw = "draw"
SWEP.Anims.Holster = "holster"
SWEP.Anims.Fire = "fire02"
SWEP.Anims.Fire_Aiming = "fire01_scoped"
SWEP.Anims.Cock = "pump02"
SWEP.Anims.Cock_Aim = "pump01_scoped"
SWEP.Anims.Cock_Nomen = "pump01_nomen"
SWEP.Anims.Cock_Aim_Nomen = "pump01_nomen_scoped"
SWEP.Anims.Idle = "idle"
SWEP.Anims.Idle_Aim = "idle_scoped"
SWEP.Anims.Reload_Start = "reload_start"
SWEP.Anims.Reload_Start_Empty = "reload_start_empty"
SWEP.Anims.Reload_Insert = "reload"
SWEP.Anims.Reload_End = "reload_end"
SWEP.Anims.Reload_Start_Nomen = "reload_start_nomen"
SWEP.Anims.Reload_Start_Empty_Nomen = "reload_start_empty_nomen"
SWEP.Anims.Reload_Insert_Nomen = "reload_nomen"
SWEP.Anims.Reload_End_Nomen = "reload_end_nomen"

SWEP.Sounds = {}
SWEP.Sounds["deploy_first"] = {[1] = {time = 2.2, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 3.2, sound = Sound("FAS2_REM870.PumpForward")},
	[3] = {time = 5.7, sound = Sound("FAS2_REM870.Insert")}}
	
SWEP.Sounds["reload_start"] = {[1] = {time = 0.2, sound = Sound("Generic_Cloth")}}
SWEP.Sounds["reload_start_nomen"] = {[1] = {time = 0.2, sound = Sound("Generic_Cloth")}}

SWEP.Sounds["reload"] = {[1] = {time = 0.25, sound = Sound("FAS2_REM870.Insert")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")}}
	
SWEP.Sounds["reload_nomen"] = {[1] = {time = 0.15, sound = Sound("FAS2_REM870.Insert")}}
SWEP.Sounds["reload_start_empty"] = {[1] = {time = 0.2, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")},
	[3] = {time = 1, sound = Sound("FAS2_REM870.Insert")},
	[4] = {time = 1.8, sound = Sound("FAS2_REM870.PumpForward")},
	[5] = {time = 1.9, sound = Sound("Generic_Cloth")}}
	
SWEP.Sounds["reload_start_empty_nomen"] = {[1] = {time = 0.2, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")},
	[3] = {time = 1.05, sound = Sound("FAS2_REM870.Insert")},
	[4] = {time = 1.8, sound = Sound("FAS2_REM870.PumpForward")}}
	
SWEP.Sounds["pump02"] = {[1] = {time = 0.1, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.35, sound = Sound("FAS2_REM870.PumpForward")}}
	
SWEP.Sounds["pump01_nomen"] = {[1] = {time = 0.1, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.25, sound = Sound("FAS2_REM870.PumpForward")}}

SWEP.Sounds["pump01_scoped"] = {[1] = {time = 0.1, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.35, sound = Sound("FAS2_REM870.PumpForward")}}
	
SWEP.Sounds["pump01_nomen_scoped"] = {[1] = {time = 0.1, sound = Sound("FAS2_REM870.PumpBack")},
	[2] = {time = 0.25, sound = Sound("FAS2_REM870.PumpForward")}}
	
SWEP.FireModes = {"pump"}

SWEP.Category = "FA:S 2 Weapons"
SWEP.Base = "fas2_base_shotgun"
SWEP.Author            = "Spy"
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.HoldType = "shotgun"

SWEP.ViewModelFOV    = 60
SWEP.ViewModelFlip    = false

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true

SWEP.VM = "models/weapons/view/shotguns/870.mdl"
SWEP.WM = "models/weapons/w_m3.mdl"
SWEP.WorldModel   = "models/weapons/w_shot_m3super90.mdl"

-- Primary Fire Attributes --
SWEP.Primary.ClipSize        = 8
SWEP.Primary.DefaultClip    = 16
SWEP.Primary.Automatic       = false    
SWEP.Primary.Ammo             = "12 Gauge"
 
-- Secondary Fire Attributes --
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic       = false
SWEP.Secondary.Ammo         = "none"

-- Deploy related
SWEP.FirstDeployTime = 6.5
SWEP.DeployTime = 0.45
SWEP.HolsterTime = 0.3

-- Firing related
SWEP.Shots = 12
SWEP.FireDelay = 0.2
SWEP.Damage = 10
SWEP.FireSound = Sound("FAS2_REM870")
SWEP.CockAfterShot = true
SWEP.Cocked = true

-- Accuracy related
SWEP.HipCone = 0.035
SWEP.AimCone = 0.005
SWEP.ClumpSpread = 0.015
SWEP.SpreadPerShot = 0.02
SWEP.MaxSpreadInc = 0.055
SWEP.SpreadCooldown = 0.4
SWEP.VelocitySensitivity = 1.5
SWEP.AimFOV = 5

-- Recoil related
SWEP.ViewKick = 3.7
SWEP.Recoil = 3

-- Reload related
SWEP.InsertEmpty = 3
SWEP.InsertTime = 0.8
SWEP.ReloadStartTime = 0.5
SWEP.ReloadAdvanceTimeEmpty = 1.4
SWEP.ReloadAdvanceTimeLast = 1.1
SWEP.ReloadEndTime = 0.5
SWEP.ReloadAbortTime = 0.7
SWEP.CockTime = 0.5

SWEP.InsertEmpty_Nomen = 2.7
SWEP.InsertTime_Nomen = 0.6
SWEP.ReloadStartTime_Nomen = 0.5
SWEP.ReloadAdvanceTimeEmpty_Nomen = 1.4
SWEP.ReloadAdvanceTimeLast_Nomen = 1.1
SWEP.ReloadEndTime_Nomen = 0.5
SWEP.CockTime_Nomen = 0.35

local mag, ammo, CT

function SWEP:ReloadStartLogic()
	mag = self:Clip1()
	ammo = self.Owner:GetAmmoCount(self.Primary.Ammo)
	
	if mag < self.Primary.ClipSize and ammo > 0 then
		CT = CurTime()
		self.dt.Status = FAS_STAT_IDLE
		
		if mag == 0 then
			if self.Owner.FAS_FamiliarWeapons[self.Class] then
				FAS2_PlayAnim(self, self.Anims.Reload_Start_Empty_Nomen, 1, 0)
				self:DelayMe(CT + self.InsertEmpty_Nomen)
				self.ReloadStateWait = CT + self.InsertEmpty_Nomen
			else
				FAS2_PlayAnim(self, self.Anims.Reload_Start_Empty, 1, 0)
				self:DelayMe(CT + self.InsertEmpty)
				self.ReloadStateWait = CT + self.InsertEmpty
			end
			
			self:InsertAmmo()
			self.Owner:SetAnimation(PLAYER_RELOAD)
			
			if ammo > 1 then
				self.ReloadState = 2
			else
				self.ReloadState = 3 -- damn you lack of anims!
			end
		else
			if self.Owner.FAS_FamiliarWeapons[self.Class] then
				FAS2_PlayAnim(self, self.Anims.Reload_Start_Nomen, 1, 0)
				self:DelayMe(CT + self.ReloadStartTime_Nomen)
				self.ReloadStateWait = CT + self.ReloadStartTime_Nomen
				self.ReloadState = 2
			else
				FAS2_PlayAnim(self, self.Anims.Reload_Start, 1, 0)
				self:DelayMe(CT + self.ReloadStartTime)
				self.ReloadStateWait = CT + self.ReloadStartTime
				self.ReloadState = 2
			end
		end
	end
end

if CLIENT then
	function SWEP:MakePumpShell()
		self:AddEvent(0.15, function()
			self:CreateShell("12g_buck")
		end)
	end
end