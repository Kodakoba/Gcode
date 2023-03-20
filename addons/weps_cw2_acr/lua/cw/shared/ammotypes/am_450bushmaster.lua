local att = {}
att.name = "am_450bushmaster"
att.displayName = ".450 Bushmaster"
att.displayNameShort = ".450 Bushmaster"

att.statModifiers = {DamageMult = 0.20,
	RecoilMult = 0.30}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/magnumrounds")
	att.description = {}
end

function att:attachFunc()
	self:unloadWeapon()
end

function att:detachFunc()
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)