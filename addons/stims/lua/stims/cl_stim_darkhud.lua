
local function hookDarkHUD()
	local dh = DarkHUD

	circCol = Colors.DarkGray:Copy()

	local fontName = "Open Sans Bold"
	local scale = math.max(DarkHUD.Scale, 1)

	surface.CreateFont("DarkHUD_Stims", {
		font = fontName,
		size = 18 * scale
	})

	local handle = BSHADOWS.GenerateCache("DarkHUD_Stims", 128, 128)

	local circSize = math.floor(20 * scale)

	local stimX, stimY

	local size = 48 * scale

	handle:SetGenerator(function(self, w, h)
		local ratio = w / size

		surface.SetDrawColor(255, 255, 255)
		surface.DrawMaterial("https://i.imgur.com/1aEZv3d.png", "adrenaline_shot128.png", 0, 0, w, h)

		--local circSize = circSize * 2.8

		local sz = circSize * ratio
		local _, sy = handle:Offset(0, stimY or 0)

		draw.MaterialCircle(sz / 2, h - sz / 2, sz)
	end)

	handle.cached = false

	dh:On("Rescale", "StimRescale", function(_, new)
		scale = math.max(new, 1)
		size = 48 * scale
		circSize = math.floor(20 * scale)
		new = math.max(new, 1) -- 1 is max scale

		handle.cached = false
		--handle:CacheShadow(4, 8, 2)

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

	local cdTextColor = color_white:Copy():HSVMod(0, 0, -0.07)
	local cdBoxColor = Colors.Gray:Copy()

	dh:On("AmmoPainted", "PaintStims", function(_, pnl, w, h)
		local sX, sY = 4, -4 - size

		stimX, stimY = sX, sY

		if not handle.cached then
			handle:CacheShadow(4, 8, 2)
			handle.cached = true
		end

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

		sX = math.floor(sX - pnl.ShakeX / 3) -- counteract the shaking a bit
		sY = math.floor(sY - pnl.ShakeY / 3)

		local gsX, gsY = sX, sY

		draw.EnableFilters(true, false)

			-- Shadowed
			DisableClipping(true)

				White()
				draw.NoTexture()

				handle:Paint(gsX, gsY, size, size)
				surface.SetDrawColor(cdStimCol:Unpack())
				surface.DrawMaterial("https://i.imgur.com/1aEZv3d.png", "adrenaline_shot128.png",
					gsX, gsY, size, size)

				-- trapezoid mask for cooldown
				draw.BeginMask(mask, gsX + size / 2, gsY + size / 2, size, cdFrac)
				draw.DrawOp()
					surface.SetDrawColor(color_white:Unpack())
					surface.DrawMaterial("https://i.imgur.com/1aEZv3d.png", "adrenaline_shot128.png",
						gsX, gsY, size, size)
				draw.FinishMask()

				surface.SetDrawColor(circCol:Unpack())
				draw.MaterialCircle(gsX + circSize / 2, gsY + size - circSize / 2, circSize)

				local tX = math.floor(gsX + circSize / 2)
				local tY = math.floor(gsY + size - circSize / 2 - (18 * scale) * (0.5))

				draw.SimpleText(LocalPlayer():GetStims(), "DarkHUD_Stims", tX, tY, color_white, 1)

				if pnl.StimpakCDFrac > 0 then
					local tx = ("%.1f"):format(math.max(timeLeft, 0))
					surface.SetFont("OSB36")
					local tW = surface.GetTextSize(tx)

					local stimy = sY + 2 - 6 * pnl.StimpakCDFrac

					draw.RoundedBox(4, sX + size / 2 - tW / 2 - 4, stimy - 2 - (36 * 0.875), tW + 8, (36 * 0.75) + 4, cdBoxColor)
					draw.SimpleText2(tx, nil, sX + size / 2, stimy, cdTextColor, 1, 4)
				end
			DisableClipping(false)


		draw.DisableFilters(true, false)
	end)
end

LibItUp.OnLoaded("darkhud.lua", hookDarkHUD)
