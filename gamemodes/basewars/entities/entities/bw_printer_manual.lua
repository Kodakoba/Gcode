--easylua.StartEntity("bw_printer_manual")

AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.Capacity        = 0
ENT.PrintName = "Manual Printer"

ENT.FontColor = Color(110, 60, 31)
ENT.BackColor = color_black
ENT.IsValidRaidable = false
ENT.Model = "models/grp/printers/printer.mdl"

ENT.PrintAmount = 0
ENT.PrintAmount2 = 5
ENT.MaxLevel = 5
ENT.BypassMaster = true
ENT.RebootTime = 0

ENT.PowerRequired = 0
ENT.IsManualPrinter = true

function ENT:GetMoneyFraction()
	return 1
end

ENT.JammingSounds = {
	"weapons/arccw_fml/ar_ak47/ak47_cock1.wav",
	"weapons/arccw_fml/ar_ak47/ak47_cock2.wav",
	"weapons/arccw_fml/ar_g36c/g36c_handle.wav",
	"weapons/arccw_fml/ar_g3a3/g3_boltpull.wav",
	"weapons/arccw_fml/sub_mp5/mp5_boltback1.wav",
	"weapons/cw_deagle/slideback.wav",
}

ENT.BreakSounds = {
	"weapons/arccw_fml/mg_vollmer/vollmer_startertab.wav",

}
ENT.RepairingSounds = {
	"weapons/arccw_fml/ar_m4a1/m4_check.wav",
	"weapons/cw_makarov/magin_partial.wav",
	"weapons/cw_mp7_official/boltback.wav",
}

ENT.RepairedSounds = {
	"weapons/cw_mp7_official/boltrelease.wav",
	"weapons/cw_m203/close.wav",
}

for i=1, 5 do
	table.insert(ENT.RepairingSounds, ("weapons/cw_mp7_official/swivel%d.wav"):format(i))
end

function ENT:ExplodeUser()
	local efd = EffectData()
	efd:SetOrigin(self:GetPos())
	util.Effect("Explosion", efd, nil, true)

	local ply = self:BW_GetOwner():GetPlayer()
	if IsPlayer(ply) then
		ply:TakeDamage(
			math.max(0, 100 - ply:GetPos():Distance(self:GetPos()) / 2), self, self)
	end

	self:Remove()
end

function ENT:CrapOut()
	self:EmitSound("arccw_go/taser/taser_shoot.wav")
	self:EmitSound(table.SeqRandom(self.BreakSounds), 100)

	self.Broken = true

	if self:BW_GetOwner():GetMoney() > 500000 and math.random() < 0.05 then
		self:ExplodeUser()
	end
end

function ENT:AttemptRepair()
	if math.random() > 0.1 then
		local snd = table.SeqRandom(self.RepairingSounds)
		self:EmitSound(snd, 60)
		return
	end

	print("Repaired")
	self.NextBreak = math.random(50, 100)
	self.BreaksIn = math.random(5, 15)
	self:EmitSound(table.SeqRandom(self.RepairedSounds), 75)
	self.BreakingDown = 0
	self.Broken = false
end


function ENT:UseFunc(act, call)
	if self:BW_GetOwner() ~= act:GetPInfo() then return end

	if self.Broken then
		self:AttemptRepair()
		return
	end

	local pg = self:GetPowerGrid()
	if not pg or not pg:TakePower(3) then return end

	if self:BW_GetOwner():GetMoney() > 25000 then
		self.BreakingDown = self.BreakingDown + 1

		if self.BreakingDown > self.NextBreak then
			self:EmitSound(table.SeqRandom(self.JammingSounds), 60)
		end

		if self.BreakingDown >= self.BreaksIn + self.NextBreak then
			self:CrapOut()
			return
		end
	end

	local printed = self.PrintAmount2 * self:GetLevel()

	act:GiveMoney(printed)
	hook.Run("BaseWars_PlayerEmptyPrinter", call, self, printed)
end

local misc = {}
local anim = Animatable()
anim.a = 0
local a = 0

local white = Color(255, 255, 255)
local blk = Color(0, 0, 0)

local wrappedtx
local wrappedsrc
local lines

local curTipY = 0

function ENT:SHInit()
	self:SetBoughtPrice(100)
	self.BreakingDown = 0

	self.BreaksIn = math.random(5, 16)
	self.NextBreak = 0
end

function ENT:PaintStructureInfo(w, y)return 0 end

function ENT:DrawTipDisplay(w, h, a)
	local tipW, tipH = w * 0.5, 72
	local tipX, tipY = w/2 - tipW/2, h * 0.05

	--surface.SetDrawColor(0, 0, 0, a * 220)
	--surface.DrawRect(tipX, tipY, tipW, tipH)

	blk.a = a * 220
	white.a = a * 255

	draw.RoundedBoxEx(32, tipX, tipY, tipW, tipH, blk, true, true, false, false)
	draw.SimpleText(Language.Tip, "OSB64", tipX + tipW / 2, tipY + tipH / 2, white, 1, 1)

	local contW, contH = w * 0.8, 0

		-- wrap text
		local contFont, exists = Language("PrinterUpgradeTipFont")
		if not exists then
			contFont = "OS28"
		end
		local hgt = contFont:match("%d+$")
		if not wrappedtx or wrappedsrc ~= Language.PrinterUpgradeTip then
			wrappedsrc = Language("PrinterUpgradeTip")
			wrappedtx = string.WordWrap2(wrappedsrc, contW - 16, contFont)

			local _, lns = wrappedtx:gsub("[\r\n]", "")
			lines = lns + 1
			--lines = select("#", )
		end

		contH = lines * hgt + 16

	local contX, contY = w/2 - contW/2, tipY + tipH

	draw.RoundedBox(16, contX, contY, contW, contH, blk, false, false, true, true)
	draw.DrawText(wrappedtx, contFont, contX + 8, contY + 8, white)

	--curTipY = contY + contH
end

function ENT:Draw()
	self:DrawModel()
	self:GetCachedPos(nil, misc, nil)

	local pos, ang, scale, w, h = misc[1], misc[2], misc[3], misc[4], misc[5]

	local nameW, nameH = w * 0.75, h * 0.2
    local nameX, nameY = (w - nameW) / 2, h * 0.075
    local lp = LocalPlayer()

    if self:ShouldDrawDisplay() and not BaseWars.EverUpgraded() and
    	lp:GetMoney() > self:GetUpgradeCost() and
    	self:BW_GetOwner() == lp:GetPInfo() then

    	anim:To("a", 1, 0.3, 0, 0.2)
    else
    	anim:To("a", 0, 0.3, 0, 0.2)
    end

    local a = anim.a

    
	draw.EnableFilters()
	cam.Start3D2D(pos, ang, scale)
		if a > 0 then
			local ok, err = pcall(self.DrawTipDisplay, self, w, h, a)

			if not ok then
				print("err", err)
			end
		end

		local y =  a * curTipY + 16
		local ok, err = pcall(self.DrawUpgradeCost, self, y, w, h, a)

		if not ok then
			print("err", err)
		end
	cam.End3D2D()
	draw.DisableFilters()



end

function ENT:ThinkFunc()
end

function ENT:UseBypass()
end

--easylua.EndEntity("bw_printer_manual")