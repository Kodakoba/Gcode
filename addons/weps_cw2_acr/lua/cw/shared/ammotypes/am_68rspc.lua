local att = {}
att.name = "am_68rspc"
att.displayName = "6.8 Remington SPC"
att.displayNameShort = "6.8 SPC"

att.statModifiers = {DamageMult = 0.125,
	RecoilMult = 0.225}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")
	att.description = {}
end

function att:attachFunc()
	self:unloadWeapon()
end

function att:detachFunc()
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)