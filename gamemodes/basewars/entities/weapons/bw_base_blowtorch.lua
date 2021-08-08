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

SWEP.Sounds = {
	"ambient/energy/spark1.wav",
	"ambient/energy/spark2.wav",
	"ambient/energy/spark3.wav",
	"ambient/energy/spark4.wav",
	"ambient/energy/spark5.wav",
	"ambient/energy/spark6.wav"
}

SWEP.Range = 80
SWEP.Penetrates = 3
SWEP.TorchDamage = 20
SWEP.IsBlowTorch = true

local function IsProp(ent)
	return (IsValid(ent) and ent.GetClass and ent:GetClass() == "prop_physics") or false
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

local function GetMaxHP(prop)
	return prop:GetMaxHealth()
end

local function SetHP(prop, hp)
	if hp <= 0 then
		prop:Remove()
		return
	end

	prop:SetHealth(hp)
end

function SWEP:Zap()
	self:EmitSound(self.Sounds[math.random(#self.Sounds)],
		90, math.random(90, 110), 1)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

local function isZappable(self, ent)
	if not IsProp(ent) then return false end

	local ow = ent:BW_GetOwner()
	return ow
end

local function canZap(self, ent)
	if not IsProp(ent) then return false end

	local ow = ent:BW_GetOwner()
	return IsPlayerInfo(ow) and ow:IsEnemy(self:GetOwner()) and ow
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if not IsPlayer(ply) then return end

	local tr = ply:GetEyeTrace()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if not IsProp(tr.Entity) or tr.Fraction * 32768 > self.Range then return end

	if CLIENT then return end

	local owner = tr.Entity:BW_GetOwner()

	if not canZap(self, tr.Entity) then print(Realm(), "trace not zappable", tr.Entity) return end

	local trent = tr.Entity
	local trents = {ply, trent}

	self:Zap()

	for i=1, self.Penetrates - 1 do
		local newtr = util.TraceLine({
			start = tr.StartPos,
			endpos = tr.StartPos + tr.Normal * self.Range,
			filter = trents,
		})

		if canZap(self, newtr.Entity) then
			trents[#trents + 1] = newtr.Entity
		end

	end

	table.remove(trents, 1)

	for k,v in ipairs(trents) do
		local hp = GetHP(v)
		hp = hp - self.TorchDamage

		SetHP(v, hp)

		local frac = hp / GetMaxHP(v)

		v:SetColor( Color(255*frac, 255*frac, 255*frac) )
	end
end

function SWEP:SecondaryAttack()
	return false
end




if not CLIENT then return end




local displayDist = 256 / 32768

local lastent 		-- last valid ent we looked at
local x, y = 0, 0 	-- last valid pos of the ent


local strX, strY = 0, 0 --stripes
local hpfrac = 0

local anim

function SWEP:FillData(tr, ent, ow)
	local prev = lastent
	lastent = ent

	local trent = ent
	local trents = {LocalPlayer(), trent}

	for i=1, self.Penetrates - 1 do 	-- -1 because trent is already 1
		local newtr = util.TraceLine({
			start = tr.StartPos,
			endpos = tr.StartPos + tr.Normal * self.Range,
			filter = trents,
		})

		if isZappable(self, newtr.Entity) then
			trents[#trents + 1] = newtr.Entity
		end
	end

	table.remove(trents, 1)

	return prev ~= lastent
end

local CanRaidColor = Color(230, 100, 100)
local CantRaidColor = Color(150, 30, 30)

local header = Colors.Header:Copy()
local body = Colors.FrameBody:Copy()

local hpBarCol = CantRaidColor:Copy()
local emptyBar = Colors.LightGray:Copy()

local infoCol = Color(40, 40, 40)
local txCol = Color(220, 220, 220)

local hdSize = 18
local curBlowtorch
local frW, frH = 180, 55

local function paint(ent, curent, baseAnim, firstFrame)
	local self = curBlowtorch
	if not curBlowtorch then return end

	anim = anim or Animatable("blowtorch")
	local tr = LocalPlayer():GetEyeTrace()
	--stripes = (not MoarPanelsMats["stripes"]:IsError() and MoarPanelsMats["stripes"]) or errmat -- :/

	local ow = isZappable(self, ent)
	local canraid = IsPlayerInfo(ow) and ow:IsEnemy(LocalPlayer())

	if ow then
		self:FillData(tr, ent, ow)
		anim:LerpColor(hpBarCol, CanRaidColor, 0.3, 0, 0.3)
	else
		anim:LerpColor(hpBarCol, CantRaidColor, 0.3, 0, 0.3)
	end

	if a == 0 then return end

	local headerH = 18
	local w, h = frW, baseAnim.Height or frH

	BaseWars.HUD.PaintFrame(w, h, headerH)

	local hp, max = 0, 0

	hpfrac = anim.HPFrac or 0

	if lastent and lastent:IsValid() then
		hp = GetHP(lastent)
		max = GetMaxHP(lastent)
		anim:To("HPFrac", hp / max, 0.2, 0, 0.3)
	end

	surface.SetDrawColor(emptyBar)
	local xpad = 12
	local barW, barH = w - xpad * 2, 16
	local barY = headerH + (h - headerH) / 2 - barH / 2

	surface.DrawRect(x + xpad, barY, barW, barH)

	draw.SimpleText("H E A L T H", "OSB20", x + 20 + 80, barY + barH / 2, infoCol, 1, 1)

	surface.SetDrawColor(hpBarCol)
	surface.DrawRect(x + xpad, barY, hpfrac * barW, barH)

	draw.SimpleText(hp .. "/" .. max, "OS18",
		x + xpad + hpfrac * barW,
		barY + barH,
		txCol, 1, 5)

	if not canraid then
		strX = (strX + FrameTime() / 32) % 0.5
		strY = (strY + FrameTime() / 16) % 0.5

		surface.SetDrawColor( 0, 0, 0 )

		render.SetScissorRect(x + xpad, barY, x + hpfrac * barW + xpad, barY + barH, true)

			surface.DrawUVMaterial("https://i.imgur.com/y9uYf4Y.png", "whitestripes.png",
				x, y, 200, 80, 0.1 - strX, 0.1 - strY, 0.6 - strX, 0.4 - strY)
			draw.SimpleText("H E A L T H", "OSB20", x + 20 + 80, barY + barH / 2, txCol, 1, 1)

		render.SetScissorRect(0, 0, 0, 0, false)
	end

	if canraid then
		local str = ("penetrates %s prop%s"):format(#trents, (#trents ~= 1 and "s") or "")
		draw.SimpleText(str, "OSB18", x + 100, y + 76, Color(200, 200, 200, a), 1, 4)
	end
end


--hook.Add("BW_PaintStructureInfo", "Blowtorch", paint)

hook.Add("BW_ShouldPaintStructureInfo", "Blowtorch", function(ent, dist)
	local class_ok = ent.IsBaseWars or IsProp(ent)
	local wep = LocalPlayer():GetActiveWeapon()
	local wep_ok = wep.IsBlowTorch

	curBlowtorch = wep

	return class_ok and wep_ok and dist < 192, 192, paint
end)