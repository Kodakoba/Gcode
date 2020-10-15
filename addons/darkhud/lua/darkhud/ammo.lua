
local scale = DarkHUD.Scale
local dh = DarkHUD

local ammoColor = Color(215, 195, 10)
local firedAmmoColor = Color(145, 125, 10, 190)

DarkHUD:On("Rescale", "VitalsResize", function(self, new)
	scale = new

	local f = DarkHUD.Ammo
	if not IsValid(f) then return end

	f:ResizeElements()
end)

function DarkHUD.CreateAmmo()
	if DarkHUD.Ammo then DarkHUD.Ammo:Remove() end

	local me = LocalPlayer()

	DarkHUD.Ammo = vgui.Create("FFrame")
	local f = DarkHUD.Ammo
	f:SetCloseable(false, true)
	f.Shadow = {spread = 0.9, intensity = 2}
	f:SetSize(scale * 500, scale * 120)
	f:SetPos(ScrW() - f:GetWide() - dh.PaddingX, ScrH() - f:GetTall() - dh.PaddingY)

	local rad = f.RBRadius or 8
	local fX, fY = f:GetPos()
	function f:ResizeElements()
		f:SetSize(scale * 500, scale * 200)
		f:SetPos(ScrW() - f:GetWide() - dh.PaddingX, ScrH() - f:GetTall() - dh.PaddingY)

		fX, fY = f:GetPos()
	end

	f.AmmoFrac = 0
	f.AmmoMissingFrac = 0
	f.AmmoGrad = 0

	f.ChamberedFrac = 0
	f.LineGap = 0

	f.Lines = 0

	f.Recoil = 0

	local lastVars = {}

	local lastAmmoFrac

	function f:ShakeLogic()

		if self.Recoil > 0 then
			local shk = self.Recoil
			local shkX, shkY = math.random(-shk, shk), math.random(-shk, shk)
			self:SetPos(fX + shkX, fY + shkY)
		end

	end

	local fired = FrameNumber()

	function f.OnFire(wep, self)
		local recoil = (wep.ArcCW and wep.Recoil * wep.VisualRecoilMult) or 1

		if fired == FrameNumber() then return end -- deal with shotguns 'n shit

		if f.RecoilAnim then f.RecoilAnim:Stop() end
		f.Recoil = f.Recoil + (recoil * 250) ^ 0.4
		f.RecoilAnim = f:To("Recoil", 0, (recoil * 0.3)^0.4, 0, 0.3, true)

		fired = FrameNumber()
	end

	f:On("Think", "Recoil", function(self)
		local wep = me:GetActiveWeapon()
		local valid = wep and wep:IsValid()

		if valid and wep.DrawAmmo and wep:GetMaxClip1() > 0 then

			if not wep:GetListener("FiredBullet", self) then
				wep:On("FiredBullet", self, f.OnFire, f)
			end

			if self.Y ~= fY and self.Recoil == 0 then

				self:To("Y", fY, 0.4, 0, 0.3)
			else
				f:ShakeLogic()
			end
		else
			self:To("Y", ScrH(), 0.15, 0, 4)
		end

	end)

	function f:MaskHeader(w, h)
		--render.SetStencilCompareFunction(STENCIL_ALWAYS)
		draw.RoundedStencilBox(rad, 0, 0, w, self.HeaderSize, color_white, true, true, false, false)
	end

	function f:PostPaint(w, h)
		rad = f.RBRadius or 8

		local wep = me:GetActiveWeapon()
		local valid = wep and wep:IsValid() and wep.DrawAmmo and wep:GetMaxClip1() > 0

		local x, y = self:LocalToScreen(0, 0)

		local clip = valid and wep:Clip1() or lastVars.clip or 0
		lastVars.clip = clip

		local maxclip = (valid and (wep.ArcCW and wep:GetCapacity() or wep:GetMaxClip1())) or lastVars.maxclip or 0
		lastVars.maxclip = maxclip

		local frW = math.min(clip / maxclip, 1)
		local dist = math.abs(self.AmmoFrac - frW)

		local anim, new = self:To("AmmoFrac", frW, (dist ^ 0.1) * 0.3, 0, 0.3)

		if frW ~= lastAmmoFrac and self.LastChangedWeapon ~= wep and new and valid then
			anim:Then(function()
				self.LastChangedWeapon = wep
			end)

			self.AmmoMissingFrac = 0 -- don't add the 'missing' bar when switching between guns (and lerping clips)
		elseif self.LastChangedWeapon == wep and valid then
			self.AmmoMissingFrac = math.max(self.AmmoFrac, self.AmmoMissingFrac)
		end


		local total_lines = math.max(maxclip, 1)

		if total_lines > 10 then

			if total_lines % 10 == 0 then
				if total_lines >= 60 then
					total_lines = total_lines / 20
				elseif total_lines > 30 then
					total_lines = total_lines / 10
				else
					total_lines = total_lines / 5
				end
			elseif total_lines % 5 == 0 then
				total_lines = total_lines / 5
			else
				total_lines = 4
			end

		end


		local line_gap = math.max(w / total_lines, 2)

		f:To("LineGap", line_gap, 0.3, 0, 0.3)

		if frW < self.AmmoFrac and self.LastChangedWeapon == wep and valid then
			self:To("AmmoGrad", 1.5, 0.1, 0, 0.3)
			local anim, new = self:To("AmmoMissingFrac", frW, (dist ^ 0.1) * 0.2, 0.2, 0.2)

			if anim then
				anim:Then(function()
					self:To("AmmoGrad", 0, 0.6, 0.2, 0.3)
				end)
			end
		end

		
		draw.BeginMask(f.MaskHeader, f, w, h)
		draw.DrawOp()

		render.SetScissorRect(x, y, x + w * self.AmmoMissingFrac, y + self.HeaderSize, true)
				DarkHUD.RoundedBoxCorneredSize(8, 0, 0, w, self.HeaderSize, firedAmmoColor, 8, 8, 0, 0)

			render.SetScissorRect(x, y, x + w * self.AmmoFrac, y + self.HeaderSize, true)
				DarkHUD.RoundedBoxCorneredSize(8, 0, 0, w, self.HeaderSize, ammoColor, 8, 8, 0, 0)
				surface.SetDrawColor(color_black)
				surface.DrawLine(-5, self.HeaderSize - 1, w, self.HeaderSize - 1)

				local lines = math.min(math.ceil(w / self.LineGap), w)
				lastLines = lines
				for i=1, lines do
					surface.DrawLine(self.LineGap * i, 0, self.LineGap * i, h)
				end


				-- todo: chambered indicator
				--[[
					local chambered = wep.ArcCW and math.max(clip - maxclip, 0) or 0
					local maxChamber = wep.ArcCW and wep:GetChamberSize() or 0
					local chamberFrac = (chambered ~= 0 and maxChamber ~= 0 and chambered / maxChamber) or 0
					local dist = math.abs(self.ChamberedFrac - chamberFrac)

					f:To("ChamberedFrac", chamberFrac, (dist ^ 0.1) * 0.1, 0, 0.2)
				]]
				if total_lines >= 20 then
					total_lines = math.min(math.floor(total_lines / 6), 10)
				end

				surface.SetDrawColor(color_white)
				surface.SetMaterial(MoarPanelsMats.gr)
				local gW = math.floor(4 * self.AmmoGrad)
				surface.DrawTexturedRect(w * self.AmmoFrac - gW, 0, gW, self.HeaderSize)

			render.SetScissorRect(0, 0, 0, 0, false)

		draw.FinishMask()

		lastWeapon = wep
		lastAmmoFrac = frW

		--[[------------------------------]]
		--	  		Weapon info
		--[[------------------------------]]

		--draw.SimpleText(string text, string font = "DermaDefault", number x = 0, number y = 0, table color = Color( 255, 255, 255, 255 ), number xAlign = TEXT_ALIGN_LEFT, number yAlign = TEXT_ALIGN_TOP)
	end

end


if DarkHUD.Vitals then
	DarkHUD.CreateAmmo()
end


DarkHUD:On("Ready", "CreateAmmo", DarkHUD.CreateAmmo)