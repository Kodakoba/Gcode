
AddCSLuaFile()

ENT.Base            = "bw_base_electronics"
ENT.PrintName       = "Cash Cab"

ENT.Model           = "models/props/de_nuke/nuclearcontainerboxclosed.mdl"
ENT.Color           = Color(0,0,0,255)
ENT.PowerCapacity   = 100000
ENT.Material        = "models/props/cs_assault/metal_stairs1"
ENT.MaxStorage      = 1500000
ENT.IsVault         = true
ENT.IsPrinter       = false

ENT.Sound =  "mvm/mvm_money_pickup.wav"
local UpgradeCost = {500000, 2500000, 12500000, 500000000, 0}

function ENT:DerivedDataTables()
	self:NetworkVar("Float", 2, "Money")
	self:NetworkVar("Int", 3, "Upgrades")
	self:NetworkVar("Int", 4, "UpgradeCost")
end

function ENT:GetUsable()
	return true
end

function ENT:Init()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)	
	self:SetMaterial(self.Material)
	self.Time=CurTime()
	self.Delay=5
	self.Radius=250
	self.MoneyStored=0
	self.CurrentValue=1
	self:SetUpgradeCost(UpgradeCost[1])
	self.UpgradeValue = 0
end

	local fontName = "VaultFont"
	surface.CreateFont(fontName..".Title", {
		font = "Roboto",
		size = 96,
		weight = 800,
	})

	surface.CreateFont(fontName, {
		font = "Roboto",
		size = 64,
		weight = 800,
	})

	surface.CreateFont(fontName..".Small", {
		font = "Roboto Light",
		size = 48,
		weight = 600,
	})

	local SlotColor, UpgDesc = {}, {}


	UpgDesc[1]="Increases pickup range."
	UpgDesc[2]="When destroyed, returns it's contents\nto you."
	UpgDesc[3]="Automatically refills your printers'\npaper supply."
	UpgDesc[4]="During a raid, your printers become\ninvincible as long as the bank is alive."
	UpgDesc[5]="Max upgrades reached!"

	function ENT:DrawDisplay(pos, ang, scale, alpha)
			
		local alpha = self.alpha or 255
		local anim = self.anim
			
		if alpha < 1 then return end

		local font=fontName
		draw.RoundedBox(0,0,-80,800,1125,Color(0,0,0,alpha))
		if self:GetPower() < 10 then return end

		draw.DrawText("Bank", font..".Title", 400, -50+anim, Color(255,0,0, alpha-20), TEXT_ALIGN_CENTER)

		draw.DrawText("Money: ", font, 50+anim*2, 100, Color(255,255,255, alpha-50), TEXT_ALIGN_LEFT)
		local money = tonumber(self:GetMoney()) or 0
		local money = BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(money)
		draw.DrawText(money, font, 250+anim*2, 100, Color(255,255,255, alpha-50), TEXT_ALIGN_LEFT)


		for i=1,4 do
			local sizeOuter=60+anim
			draw.RoundedBox(8,200+(i*100) + sizeOuter/2,300 + sizeOuter/2,sizeOuter, sizeOuter,Color(255,255,255,alpha)) --upgrade outer

			if self:GetUpgrades()>=i then 
				SlotColor[i] = Color(0,225,0, alpha-20)
			else
				SlotColor[i]=Color(225,0,0, alpha-20)
			end
				
			local sizeInner=50+anim
			draw.RoundedBox(8,210+(i*100) + sizeInner/2,310 + sizeInner/2,sizeInner, sizeInner,SlotColor[i]) --upgrade inner
		end


		draw.DrawText("Upgrades:", font, 50+anim*2, 325, Color(255,255,255, alpha-50), TEXT_ALIGN_LEFT)
		draw.DrawText("Next upgrade: " .. BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(self:GetUpgradeCost()), font, 400, 500+anim*2, Color(255,255,255, alpha-50), TEXT_ALIGN_CENTER)
		draw.DrawText(UpgDesc[self:GetUpgrades()+1], "VaultFont.Small", 36, 600+anim*2, Color(230,230,230, alpha-50), TEXT_ALIGN_LEFT)
	end

	function ENT:Draw()

		self:DrawModel()

		if not self.alpha then self.alpha=50 end 
		if not self.anim then self.anim=-50 end

		self.dist = LocalPlayer():GetPos():Distance(self:GetPos())

		if self.dist > 256 then
			self.alpha = L(self.alpha, -100)
			self.anim = L(self.anim, -50, 8)
		end
			
		if self.dist < 256 then self.alpha = L(self.alpha, 350) self.anim = L(self.anim, 0) end

		local ang = self:GetAngles()
		local pos = self:GetPos()+ang:Forward()*14.75+ang:Right()*(14)+ang:Up()*17
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 270)
		local scale = 0.035

		cam.Start3D2D(pos, ang, scale)
			self:DrawDisplay(pos, ang, scale)
		cam.End3D2D()

	end
