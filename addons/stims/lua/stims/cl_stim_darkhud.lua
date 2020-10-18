
local function hookDarkHUD()
	local dh = DarkHUD

	circCol = Colors.DarkGray:Copy()

	local fontName = "Open Sans Bold"

	surface.CreateFont("DarkHUD_Stims", {
		font = fontName,
		size = 18 * DarkHUD.Scale
	})

	dh:On("Rescale", "StimRescale", function(_, new)
		surface.CreateFont("DarkHUD_Stims", {
			font = fontName,
			size = 18 * new
		})
	end)

	local mask = function(x, y, sz, frac)
		-- galaxy brain mask
		draw.RightTrapezoid(x - sz, y - sz,
			sz + sz * frac * 2,
			sz + sz * frac * 2,
			sz + sz * frac * 2,
		true)
	end

	local cdStimCol = Colors.Gray:Copy()
	cdStimCol.a = 100

	local onCD = false

	local cdTextColor = color_white:Copy():HSVMod(0, 0, -0.07)
	local cdBoxColor = Colors.Gray:Copy()

	dh:On("AmmoPainted", "PaintStims", function(_, pnl, w, h)
		local scale = dh.Scale
		local size = (h - pnl.HeaderSize) / 3 * 2

		local me = LocalPlayer()

		pnl.StimpakCDFrac = pnl.StimpakCDFrac or 0

		local isOnCD, timeLeft, cdFrac = me:IsOnStimCooldown()
		cdTextColor.a = pnl.StimpakCDFrac * 210
		cdBoxColor.a = pnl.StimpakCDFrac * 160

		if isOnCD then
			onCD = true
		end

		pnl:To("StimpakCDFrac", isOnCD and 1 or 0, 0.3, 0, 0.3)

		local x, y = pnl:LocalToScreen(0, 0)

		local sW = math.floor(scale * size)
		local sH = sW

		local sX, sY = 4, -4 - size

		sX = math.floor(sX - pnl.ShakeX / 3) -- counteract the shaking a bit
		sY = math.floor(sY - pnl.ShakeY / 3)

		local gsX, gsY = sX + x, sY + y -- global/toscreen'd stimX, stimY

		local circSize = math.floor(24 * scale)

		draw.EnableFilters(true, false)

			-- Shadowed
			BSHADOWS.BeginShadow()
				White()
				draw.NoTexture()
				--mask(gsX + sW / 2, gsY + sH / 2, sW, math.abs(math.sin(CurTime() * 2)))
				surface.SetDrawColor(cdStimCol:Unpack())
				surface.DrawMaterial("https://i.imgur.com/1aEZv3d.png", "adrenaline_shot128.png", gsX, gsY, sW, sH)

				draw.BeginMask(mask, gsX + sW / 2, gsY + sH / 2, sW, cdFrac)
				draw.DrawOp()
					surface.SetDrawColor(color_white:Unpack())
					surface.DrawMaterial("https://i.imgur.com/1aEZv3d.png", "adrenaline_shot128.png", gsX, gsY, sW, sH)
				draw.FinishMask()
			BSHADOWS.EndShadow(4, 0.6, 1)

			BSHADOWS.BeginShadow()
				surface.SetDrawColor(circCol:Unpack())
				draw.MaterialCircle(gsX + circSize / 2, gsY + sH - circSize / 2, circSize)

				local tX = math.floor(gsX + circSize / 2)
				local tY = math.floor(gsY + sH - circSize / 2 - (18 * scale) * (0.5))

				draw.SimpleText(LocalPlayer():GetStims(), "DarkHUD_Stims", tX, tY, color_white, 1)
			BSHADOWS.EndShadow(2, 0.3, 1)

			-- Unshadowed
			DisableClipping(true)
				if pnl.StimpakCDFrac > 0 then
					local tx = ("%.1f"):format(math.max(timeLeft, 0))
					surface.SetFont("OSB36")
					local tW = surface.GetTextSize(tx)

					local stimy = sY + 2 - 6 * pnl.StimpakCDFrac

					draw.RoundedBox(4, sX + sW / 2 - tW / 2 - 4, stimy - 2 - (36 * 0.875), tW + 8, (36 * 0.75) + 4, cdBoxColor)
					draw.SimpleText2(tx, nil, sX + sW / 2, stimy, cdTextColor, 1, 4)
				end
			DisableClipping(false)


		draw.DisableFilters(true, false)
	end)
end

LibItUp.OnLoaded("darkhud.lua", hookDarkHUD)
