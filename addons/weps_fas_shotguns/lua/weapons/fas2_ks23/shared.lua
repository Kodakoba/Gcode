if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.ExtraMags = 6
end

if CLIENT then
    SWEP.PrintName = "KS-23"
    SWEP.Slot = 4
    SWEP.SlotPos = 0
	
	SWEP.AimPos = Vector(-1.902, -4.151, 1.235)
	SWEP.AimAng = Vector(0.685, 0, 0)
	
	SWEP.YawMod = 0.1
	SWEP.ReloadCycleTime = 0.985
	
	SWEP.MuzzleEffect = "muzzleflash_shotgun"
	SWEP.AttachmentBGs = {["tritiumsights"] = {bg = 2, sbg = 1}}
	
	SWEP.WMAng = Vector(0, 0, 180)
	SWEP.WMPos = Vector(-1, 6, 3.75)
	SWEP.MagText = "TUBE "
	SWEP.BoltReminderText = "RELOAD KEY - PUMP SHOTGUN"
	
	SWEP.AnimOverride = {["insert"] = true,
	["start"] = true,
	["start_empty"] = true,
	["insert_nomen"] = true,
	["start_nomen"] = true,
	["start_empty_nomen"] = true,
	["pump"] = true,
	["pump_iron"] = true,
	["pump_nomen"] = true,
	["pump_nomen_iron"] = true}
	
	SWEP.SprintPos = Vector(4, -2.09, 0.5)
	SWEP.SprintAng = Vector(-12.968, 47.729, 0)
end

SWEP.Attachments = {[1] = {header = "Sight", sight = true, x = 600, y = -50, atts = {"tritiumsights"}}}

SWEP.BulletLength = 23
SWEP.CaseLength = 75
SWEP.EmptySound = Sound("weapons/empty_shotguns.wav")

SWEP.Anims = {}
SWEP.Anims.Draw_First = "draw"
SWEP.Anims.Draw = "draw"
SWEP.Anims.Holster = "holster"
SWEP.Anims.Fire = "fire02"
SWEP.Anims.Fire_Aiming = "fire_iron"
SWEP.Anims.Cock = "pump"
SWEP.Anims.Cock_Aim = "pump_iron"
SWEP.Anims.Cock_Nomen = "pump_nomen"
SWEP.Anims.Cock_Aim_Nomen = "pump_nomen_iron"
SWEP.Anims.Idle = "idle"
SWEP.Anims.Idle_Aim = "idle_scoped"
SWEP.Anims.Reload_Start = "start"
SWEP.Anims.Reload_Start_Empty = "start_empty"
SWEP.Anims.Reload_Insert = "insert"
SWEP.Anims.Reload_End = "end_nopump"
SWEP.Anims.Reload_Start_Nomen = "start_nomen"
SWEP.Anims.Reload_Start_Empty_Nomen = "start_empty_nomen"
SWEP.Anims.Reload_Insert_Nomen = "insert_nomen"
SWEP.Anims.Reload_End_Nomen = "end_nopump_nomen"

SWEP.Sounds = {}
	
SWEP.Sounds["start"] = {[1] = {time = 0.2, sound = Sound("Generic_Cloth")}}
SWEP.Sounds["start_nomen"] = {[1] = {time = 0.2, sound = Sound("Generic_Cloth")}}

SWEP.Sounds["insert"] = {[1] = {time = 0.25, sound = Sound("FAS2_KS23.Insert")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")}}
	
SWEP.Sounds["insert_nomen"] = {[1] = {time = 0.15, sound = Sound("FAS2_KS23.Insert")}}
SWEP.Sounds["start_empty"] = {[1] = {time = 0.1, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")},
	[3] = {time = 0.7, sound = Sound("FAS2_KS23.InsertPort")},
	[4] = {time = 1.4, sound = Sound("FAS2_KS23.PumpForward")},
	[5] = {time = 1.9, sound = Sound("Generic_Cloth")}}
	
SWEP.Sounds["start_empty_nomen"] = {[1] = {time = 0.1, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.5, sound = Sound("Generic_Cloth")},
	[3] = {time = 0.65, sound = Sound("FAS2_KS23.InsertPort")},
	[4] = {time = 1.4, sound = Sound("FAS2_KS23.PumpForward")}}
	
SWEP.Sounds["pump"] = {[1] = {time = 0.15, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.35, sound = Sound("FAS2_KS23.PumpForward")}}
	
SWEP.Sounds["pump_nomen"] = {[1] = {time = 0.1, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.25, sound = Sound("FAS2_KS23.PumpForward")}}

SWEP.Sounds["pump_iron"] = {[1] = {time = 0.1, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.5, sound = Sound("FAS2_KS23.PumpForward")}}
	
SWEP.Sounds["pump_nomen_iron"] = {[1] = {time = 0.1, sound = Sound("FAS2_KS23.PumpBack")},
	[2] = {time = 0.35, sound = Sound("FAS2_KS23.PumpForward")}}
	
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

SWEP.VM = "models/weapons/view/shotguns/ks23.mdl"
SWEP.WM = "models/weapons/world/shotguns/ks23.mdl"
SWEP.WorldModel   = "models/weapons/w_shot_m3super90.mdl"

-- Primary Fire Attributes --
SWEP.Primary.ClipSize        = 4
SWEP.Primary.DefaultClip    = 8
SWEP.Primary.Automatic       = false    
SWEP.Primary.Ammo             = "23x75MMR"
 
-- Secondary Fire Attributes --
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic       = false
SWEP.Secondary.Ammo         = "none"

-- Deploy related
SWEP.FirstDeployTime = 0.55
SWEP.DeployTime = 0.55
SWEP.HolsterTime = 0.3
SWEP.DeployAnimSpeed = 0.5

-- Firing related
SWEP.Shots = 1
SWEP.FireDelay = 0.2
SWEP.Damage = 120
SWEP.FireSound = Sound("FAS2_KS23")
SWEP.CockAfterShot = true
SWEP.Cocked = true

-- Accuracy related
SWEP.HipCone = 0.05
SWEP.AimCone = 0.002
SWEP.SpreadPerShot = 0.3
SWEP.MaxSpreadInc = 0.055
SWEP.SpreadCooldown = 0.4
SWEP.VelocitySensitivity = 1.5
SWEP.AimFOV = 5

-- Recoil related
SWEP.ViewKick = 7.5
SWEP.Recoil = 5

-- Reload related
SWEP.InsertEmpty = 2.1
SWEP.InsertTime = 1
SWEP.ReloadStartTime = 0.5
SWEP.ReloadAdvanceTimeEmpty = 1.4
SWEP.ReloadAdvanceTimeLast = 1.1
SWEP.ReloadEndTime = 0.5
SWEP.ReloadAbortTime = 0.7
SWEP.CockTime = 0.75

SWEP.InsertEmpty_Nomen = 2.1
SWEP.InsertTime_Nomen = 0.75
SWEP.ReloadStartTime_Nomen = 0.3
SWEP.ReloadAdvanceTimeEmpty_Nomen = 1.4
SWEP.ReloadAdvanceTimeLast_Nomen = 1.1
SWEP.ReloadEndTime_Nomen = 0.25
SWEP.CockTime_Nomen = 0.55

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
		self:AddEvent(0.2, function()
			self:CreateShell("23x75")
		end)
	end
end