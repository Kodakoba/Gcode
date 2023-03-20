AddCSLuaFile()

------------------ UNSUPPRESSED

local att = {}
att.name = "bg_mp7_unsuppressed"
att.displayName = "Unsuppressed"
att.displayNameShort = "Unsup"
att.isBG = true

att.statModifiers = {
	DamageMult = 0.1,
	RecoilMult = 0.15
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/saker")
end

function att:attachFunc()
	self.dt.Suppressed = false
	self:setBodygroup(self.SuppressorBGs.main, self.SuppressorBGs.unsuppressed)	
end

function att:detachFunc()
	self:setBodygroup(self.SuppressorBGs.main, self.SuppressorBGs.suppressed)
	self:resetSuppressorStatus()
end

CustomizableWeaponry:registerAttachment(att)