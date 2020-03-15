AddCSLuaFile()

SWEP.PrintName 	= "Blowtorch T???"
SWEP.Author = "1488khz gachi remix"
SWEP.Instructions = "Destroy others' props in a raid."

SWEP.Spawnable = true
SWEP.AdminSpawnable = false

SWEP.ViewModelFOV = 65
SWEP.ViewModel 	= "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.UseHands = true

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.HoldType = "ar2"
SWEP.FiresUnderwater = true
SWEP.Weight = 20
SWEP.DrawCrosshair = true

SWEP.Category = "BaseWars"
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 0.25
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay 	= 0.25
SWEP.Primary.Force 	= 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.Sounds = {"ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav", "ambient/energy/spark5.wav", "ambient/energy/spark6.wav"}
SWEP.Range = 80
SWEP.Penetrates = 3
SWEP.TorchDamage = 20

local function IsProp(ent)
	return (IsValid(ent) and ent.GetClass and ent:GetClass()=="prop_physics") or false
end
function SWEP:Deploy()

	self:SendWeaponAnim(ACT_VM_IDLE)

end
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

local function GetHP(prop)
	return prop:Health()
end 

local function SetHP(prop, hp)
	if hp <= 0 then 
		prop:Remove()
		return
	end 

	prop:SetHealth(hp)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if not IsPlayer(ply) then return end 

	local tr = ply:GetEyeTrace()

	if not IsFirstTimePredicted() then self:SetNextPrimaryFire(CurTime() + self.Primary.Delay) return end --wtf?
	--[[
		if not ply:InRaid() then return end 
		if not IsProp(tr.Entity) then return end 

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 
		ply:SetAnimation(PLAYER_ATTACK1)
	return end 
	]]
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	

	if not ply:InRaid() then return end 

	if not IsProp(tr.Entity) or tr.Fraction * 32768 > self.Range then return end 

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 
	ply:SetAnimation(PLAYER_ATTACK1)

	timer.Simple(self:SequenceDuration() - 0.05, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
	if CLIENT then return end
	
	self.Sounds.BaseClass = nil 
	
	self.Owner:EmitSound(table.Random(self.Sounds), 90, math.random(90, 110), 1, CHAN_WEAPON)
	
	

	local trent = (IsProp(tr.Entity) and tr.Entity:CPPIGetOwner():IsEnemy(ply) and tr.Entity) or nil
	local trents = {ply, trent}

	if trent then

		for i=1, self.Penetrates - 1 do
			local newtr = util.TraceLine({
				start = tr.StartPos,
				endpos = tr.StartPos + tr.Normal * self.Range,
				filter = trents,
			})
			if IsProp(newtr.Entity) and newtr.Entity:CPPIGetOwner():IsEnemy(ply) then 
				trents[#trents + 1] = newtr.Entity
			end
		end

	else 
		if IsValid(trent) and trent.CPPIGetOwner and trent:CPPIGetOwner():IsEnemy(ply) and not trent.IsBaseWars then 
			trent:Remove()
		end
		return 
	end
	table.remove(trents, 1)

	for k,v in pairs(trents) do 
		local hp = GetHP(v)
		hp = hp - self.TorchDamage

		SetHP(v, hp)

		local frac = hp / v:GetMaxHealth()

		v:SetColor(Color(255*frac, 255*frac, 255*frac))

	end



end

function SWEP:SecondaryAttack()
	return false
end

local shade = Color(0, 0, 0, 140)
local trans = Color(255, 255, 255, 150)
local textc = Color(100, 150, 200, 255)
local hpbck = Color(255, 0  , 0  , 100)
local red	= Color(255, 0  , 0	 , 245)

local dist = 256/32768

local a = 0 

local x, y = 0, 0
local lastent
local stripes

local errmat = Material("__error")

local strX, strY = 0, 0 --stripes
local hpfrac = 0

function SWEP:DrawHUD()
	local tr = LocalPlayer():GetEyeTrace()
	--stripes = (not MoarPanelsMats["stripes"]:IsError() and MoarPanelsMats["stripes"]) or errmat -- :/

	local ent = tr.Entity
	local okent = true 

	if not IsValid(ent) or ent:GetClass() ~= "prop_physics" or tr.Fraction > dist then 
		a = L(a, 0, 20, true) 
		okent = false
	else
		a = L(a, 255, 20, true)
	end

	local ow = okent and ent.CPPIGetOwner and ent:CPPIGetOwner() 

	local canraid = okent and (IsPlayer(ow) and ow:IsEnemy(LocalPlayer()))

	if okent then
		lastent = ent
	end
	local trent = (IsValid(tr.Entity) and tr.Entity) or nil
	local trents = {LocalPlayer(), trent}

	if canraid then 
		

		for i=1, self.Penetrates - 1 do 	-- -1 because trent is already 1
			local newtr = util.TraceLine({
				start = tr.StartPos,
				endpos = tr.StartPos + tr.Normal * self.Range,
				filter = trents,
			})
			if IsValid(newtr.Entity) and newtr.Entity:GetClass() == "prop_physics" then 
				trents[#trents + 1] = newtr.Entity
			end
		end

	end

	if lastent and IsValid(lastent) then
		local pos = (lastent:GetPos() + Vector(0, 0, 16)):ToScreen()
		x = pos.x - 100 
		y = pos.y - 40
	end

	table.remove(trents, 1)

	local col = (canraid and Color(230, 100, 100, a)) or Color(150, 30, 30, a)

	draw.RoundedBox(6, x, y, 200, 50, Color(50, 50, 50, a - 15))

	local hp, max = 0, 0

	if lastent and IsValid(lastent) then 
		hp = GetHP(lastent)
		max = lastent:GetMaxHealth()
		hpfrac = L(hpfrac, hp/max, 15)
	end

	surface.SetDrawColor(Color(80, 80, 80, a))
	surface.DrawRect(x + 20, y + 12, 160, 16)

	draw.SimpleText("H E A L T H", "OSB18", x + 20 + 80, y + 12 + 8, Color(40, 40, 40, a), 1, 1)

	surface.SetDrawColor(col)
	surface.DrawRect(x + 20, y + 12, hpfrac*160, 16)

	draw.SimpleText(hp .. "/" .. max, "OS18", x + 20 + hpfrac*160, y + 12 + 16, Color(220, 220, 220, a), 1, 5)
	if not canraid then 
		strX = (strX + FrameTime()/32)%0.5
		strY = (strY + FrameTime()/16)%0.5

		surface.SetDrawColor(Color(0, 0, 0, math.min(a, 100)))

		render.SetScissorRect(x + 20, y + 12, x + hpfrac*160 + 20, y + 12 + 16, true)

			surface.DrawUVMaterial("https://www.sccpre.cat/mypng/full/11-113784_transparent-stripes-tumblr-huge-freebie-download-for-transparent.png", "stripes.png", x, y, 200, 80, 0.1 - strX, 0.1 - strY, 0.6 - strX, 0.4 - strY)

		render.SetScissorRect(0,0,0,0, false)
	end

	if canraid then
		local str = ("penetrates %s prop%s"):format(#trents, ((#trents ~= 1 and "s") or ""))
		draw.SimpleText(str, "OSB18", x + 100, y + 76, Color(200, 200, 200, a), 1, 4)
	end
end
