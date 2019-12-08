easylua.StartEntity("bw_printer_uno")
AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.Capacity 		= 15000000000
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 0

ENT.PrintName = "UniPrinter"

ENT.FontColor = Color(51, 102, 255)
ENT.BackColor = color_black

ENT.IsValidRaidable = true
ENT.PresetMaxHealth = 6000
ENT.CurrentValue = ENT.CurrentValue or 0

if SERVER then

	function ENT:Init()

		self.time = CurTime()
		self.time_p = CurTime()

		self:SetCapacity(self.Capacity)
		self:SetPaper(self.MaxPaper)
		self.Money = 0
		self:SetHealth(self.PresetMaxHealth or 100)

		self.rtb = 0

		self.FontColor = color_white
		self.BackColor = color_black

		self:SetNWInt("UpgradeCost", self.UpgradeCost)

		self:SetLevel(1)
		timer.Simple(1,function()
		for k,v in pairs(ents.GetAll()) do
			if v.IsPrinter then
				if v:CPPIGetOwner() == self:CPPIGetOwner() and v:GetClass()~="bw_printer_uno" then
					print('Found printer', v)
					self.Capacity=self.Capacity+v.Capacity
					self.PrintAmount=self.PrintAmount+v.PrintAmount
					self.CurrentValue = self.CurrentValue + v.CurrentValue or 0
					self.UpgradeCost = (self.UpgradeCost or 0) + v.UpgradeCost
					SafeRemoveEntity(v)
				end
			end
		end

		self:SetCapacity(self.Capacity)
		self:SetUpgradeCost(self.UpgradeCost)
		end)
	end

end

	if CLIENT then
        function ENT:DrawDisplay(pos, ang, scale)
        	if( LocalPlayer():GetPos():Distance( self:GetPos() ) >= 350 ) then return end
	
			local w, h = 216 * 2, 136 * 2
			local disabled = self:GetNWBool("printer_disabled")
			local Pw = self:IsPowered()
			local Lv = self:GetLevel()
			local Cp = self:GetCapacity()

			draw.RoundedBox(4, 0, 0, w, h, Pw and self.BackColor or color_black)

			if not Pw then return end

			if disabled then
				draw.DrawText(BaseWars.LANG.PrinterBeen, fontName, w / 2, h / 2 - 48, self.FontColor, TEXT_ALIGN_CENTER)
				draw.DrawText(BaseWars.LANG.Disabled, fontName .. ".Huge", w / 2, h / 2 - 32, Color(255,0,0), TEXT_ALIGN_CENTER)
			return end
			draw.DrawText(self.PrintName, fontName, w / 2, 4, self.FontColor, TEXT_ALIGN_CENTER)

			if disabled then return end

			--Level
			surface.SetDrawColor(self.FontColor)
			surface.DrawLine(0, 30, w, 30)--draw.RoundedBox(0, 0, 30, w, 1, self.FontColor)
			draw.DrawText(string.format(BaseWars.LANG.LevelText, Lv):upper(), fontName .. ".Big", 4, 32, self.FontColor, TEXT_ALIGN_LEFT)
			surface.DrawLine(0, 68, w, 68)--draw.RoundedBox(0, 0, 68, w, 1, self.FontColor)

			draw.DrawText(BaseWars.LANG.Cash, fontName .. ".Big", 4, 72, self.FontColor, TEXT_ALIGN_LEFT)
--			draw.RoundedBox(0, 0, 72 + 32, w, 1, self.FontColor)

			local money = self:GetMoney() or 0
			local cap = tonumber(Cp) or 0

			local moneyPercentage = math.Round( money / cap * 100 ,1)
			--Percentage done
			draw.DrawText( moneyPercentage .."%" , fontName .. ".Big",	w - 4, 71, self.FontColor, TEXT_ALIGN_RIGHT)

			--Money/Maxmoney
			local currentMoney = string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(money))
			local maxMoney = string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(cap))
			local font = fontName .. ".Big"

			if #currentMoney > 16 then
				font = fontName .. ".MedBig"
			end

			if #currentMoney > 20 then
				font = fontName .. ".Med"
			end

			local fh = draw.GetFontHeight(font)

			local StrW,StrH = surface.GetTextSize(" / ")
			draw.DrawText(" / " , font,
				w/2 - StrW/2 , (font == fontName .. ".Big" and 106 or 105 + fh / 4), self.FontColor, TEXT_ALIGN_LEFT)

			local moneyW,moneyH = surface.GetTextSize(currentMoney)
			draw.DrawText(currentMoney , font,
				w/2 - StrW/2 - moneyW , (font == fontName .. ".Big" and 106 or 105 + fh / 4), self.FontColor, TEXT_ALIGN_LEFT)

			draw.DrawText( maxMoney, font,
				w/2 + StrW/2 , (font == fontName .. ".Big" and 106 or 105 + fh / 4), self.FontColor, TEXT_ALIGN_Right)

			--Paper
			local paper = math.floor(self:GetPaper())
			draw.DrawText(string.format(BaseWars.LANG.Paper, paper), fontName .. ".MedBig", 4, 94 + 49, self.FontColor, TEXT_ALIGN_LEFT)
			--draw.RoundedBox(0, 0, 102 + 37, w, 1, self.FontColor)
			surface.DrawLine(0, 102 + 37, w, 102 + 37)

			local NextCost = string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(self:GetLevel() * self:GetNWInt("UpgradeCost")))

			if self:GetLevel() >= self.MaxLevel then
				NextCost = BaseWars.LANG.MaxLevel
			end

			surface.DrawLine(0, 142 + 25, w, 142 + 25)--draw.RoundedBox(0, 0, 142 + 25, w, 1, self.FontColor)
			draw.DrawText(string.format(BaseWars.LANG.NextUpgrade, NextCost), fontName .. ".MedBig", 4, 84 + 78 + 10, self.FontColor, TEXT_ALIGN_LEFT)
			surface.DrawLine(0, 142 + 25, w, 142 + 25)--draw.RoundedBox(0, 0, 142 + 55, w, 1, self.FontColor)

			--Time remaining counter
			local timeRemaining = 0
			timeRemaining = math.Round( (cap - money) / (self.PrintAmount * Lv / self.PrintInterval) )

			--if timeRemaining > 0 then
			--	local PrettyHours = math.floor(timeRemaining/3600)
			--	local PrettyMinutes = math.floor(timeRemaining/60) - PrettyHours*60
			--	local PrettySeconds = timeRemaining - PrettyMinutes*60 - PrettyHours*3600
			--	local PrettyTime = (PrettyHours > 0 and PrettyHours..BaseWars.LANG.HoursShort or "") ..
			--	(PrettyMinutes > 0 and PrettyMinutes..BaseWars.LANG.MinutesShort or "") ..
			--	PrettySeconds..BaseWars.LANG.SecondsShort
--
			--	draw.DrawText(string.format(BaseWars.LANG.UntilFull, PrettyTime), fontName .. ".Big", w-4 , 32, self.FontColor, TEXT_ALIGN_RIGHT)
			--else
			--	draw.DrawText(BaseWars.LANG.Full, fontName .. ".Big", w-4 , 32, self.FontColor, TEXT_ALIGN_RIGHT)
			--end

			--Money bar BG
			local BoxX = 88
			local BoxW = 265
			draw.RoundedBox(0, BoxX, 74, BoxW , 24, self.FontColor)

			--Money bar gap
			if cap > 0 and cap ~= math.huge then
				local moneyRatio = money / cap
				local maxWidth = math.floor(BoxW - 6)
				local curWidth = maxWidth * (1-moneyRatio)

				draw.RoundedBox(0, w - BoxX - curWidth + 6 , 76, curWidth , 24 - 4, self.BackColor)
			end
		end

		function ENT:Calc3D2DParams()
			local pos = self:GetPos()
			local ang = self:GetAngles()

			pos = pos + ang:Up() * 48
			pos = pos + ang:Forward() * 22
			pos = pos + ang:Right() * 7.15

                        ang:RotateAroundAxis(ang:Forward(), 90)
                        ang:RotateAroundAxis(ang:Right(), -90)
                        ang:RotateAroundAxis(ang:Forward(), -30)

			return pos, ang, 0.1 / 2
		end

	function ENT:Draw()
		self:DrawModel()

			local pos, ang, scale = self:Calc3D2DParams()

			cam.Start3D2D(pos, ang, scale)
				pcall(self.DrawDisplay, self, pos, ang, scale)
			cam.End3D2D()
	end
end


easylua.EndEntity()