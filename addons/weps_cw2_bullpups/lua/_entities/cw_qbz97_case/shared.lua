if CustomizableWeaponry_WS_CASES then

ENT.Type = "anim"
ENT.Base = "cw_ws_case_base"
ENT.Category = "TheRambotnic09's Cases"
 
ENT.PrintName = "QBZ-97 Rifle Case"
ENT.Author = "TheRambotnic09"
ENT.Contact	= "Via Steam: http://steamcommunity.com/id/therambotniczeronove/"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.HealthAmount = 500 
ENT.Model = "models/cw2/cases/qbz97_case.mdl"
ENT.WepWorldModel = "models/weapons/therambotnic09/w_cw2_qbz97.mdl"

ENT.BodyGroupCoverMain = 1
ENT.BodyGroupOpenSet = 1
ENT.BodyGroupCloseSet = 0

ENT.WeaponUsed = "cw_tr09_qbz97"

ENT.GunsNum = 2
ENT.upOffset = Vector(0, 0, 50)

ENT.wepBGGunsTableMain = {2,3}
ENT.wepBGAmmoTableMain = {4,5}

ENT.wepBGGunsTableStored = {0,0}
ENT.wepBGAmmoTableStored = {0,0}

ENT.wepBGGunsTableGone = {1,1}
ENT.wepBGAmmoTableGone = {1,1}

end