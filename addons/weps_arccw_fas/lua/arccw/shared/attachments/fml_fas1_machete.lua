att.PrintName = "Machete"
att.Icon = Material("entities/arccw_fml_fas1_machete.png")

att.Description = "A Machete for all your slashing need. For pistols and SMGs"

att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.Slot = {"foregrip_pistol","style_pistol", "fas1_machete"}

att.LHIK = true

att.Mult_MoveDispersion = 1.4
att.AutoStats = true
att.Mult_Recoil = 1.3
att.Mult_RecoilSide = 1.3

att.Model = "models/weapons/arccw/fml_atts/fas1_machete.mdl"
att.ModelOffset = Vector(0,0,-4)

att.DrawFunc = function(wep, element, wm)

if wep.InProcBash and CLIENT then --Hook_Think machine broke so I'm doing this here
wep:DoLHIKAnimation("stab") wep.InProcBash=false
end

if wm then element.NoDraw=true end
end

att.Mult_MeleeTime = 1.35
att.Mult_MeleeDamage = 4.1
att.Add_MeleeRange = 34
att.Mult_MeleeAttackTime = 0.25
att.Mult_ReloadTime = 1.15

att.CQC_KnifeLastReload=0

local reloads={"reload","sgreload_start","sgreload_insert","sgreload_finish","reload_empty","cycle", "sgreload_start_empty", "sgreload_finish_empty"}
att.Hook_TranslateAnimation = function(wep,anim)

if !att.CQC_KnifeLastReload then att.CQC_KnifeLastReload=0 end
if table.HasValue(reloads,anim) and CLIENT and wep.LHIKAnimation!=3 then
	att.CQC_KnifeLastReload=CurTime()+0.25
	wep:DoLHIKAnimation("holster")
elseif anim=="bash" then
	wep:DoLHIKAnimation("stab",0.509) --NEEDS the float serverside for some reason
	return false
end

end

att.Hook_LHIK_TranslateAnimation  = function(wep,anim)

if !att.CQC_KnifeLastReload then att.CQC_KnifeLastReload=0 end
if anim=="idle" and (wep:GetNWBool("reloading") or wep:GetNWBool("cycle") or CurTime()<att.CQC_KnifeLastReload) and CLIENT then
	return "holsteridle"
elseif anim=="idle" then timer.Simple(0,function() wep.LHIKAnimationTime=7.2727270126343 end) return "idlelong" --im sorry for that float
end

end
