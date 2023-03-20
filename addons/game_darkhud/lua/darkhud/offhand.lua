
local dh = DarkHUD
local col = Colors.LighterGray

local icon = {"https://i.imgur.com/6se0gFC.png", "none64_gray.png"}

local handle = BSHADOWS.GenerateCache("DarkHUD_OffhandNothing", 128, 128)
handle.rendered = false
handle:SetGenerator(function(self, w, h)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawMaterial(icon[1], icon[2],
		0, 0, w, h)
end)


local function paintNothing(pnl, x, y, w)
	local sz = w * 0.65
	local diff = w - sz

	local x, y = math.floor(x + diff / 2),
		math.floor(y + diff / 2)

	surface.SetDrawColor(255, 255, 255)
	handle:Paint(x, y, sz, sz)

	surface.SetDrawColor(col:Unpack())
	surface.DrawMaterial(icon[1], icon[2],
		x, y, sz, sz)
end

local fmt = "[%s]"

local rectCol = Color(0, 0, 0, 240)
local gradCol = Color(180, 180, 180, 250)
local outlineCol = Color(120, 120, 120)

local pad = 16
local rectSz = 4
local gradH = 0.95
local gradStart = 0.2

DarkHUD.OffhandYPad = 8

surface.CreateFont("Darkhud_OffhandTip", {
	font = "BreezeSans",
	size = DarkHUD.Scale * 28,
	weight = 600,
})

surface.CreateFont("Darkhud_OffhandTipSmall", {
	font = "BreezeSans",
	size = DarkHUD.Scale * 24,
	weight = 600,
})

surface.CreateFont("Darkhud_OffhandTipSmallShadow", {
	font = "BreezeSans",
	size = DarkHUD.Scale * 24,
	weight = 600,
	blursize = 3,
})

surface.CreateFont("Darkhud_OffhandTipShadow", {
	font = "BreezeSans",
	size = DarkHUD.Scale * 28,
	weight = 600,
	blursize = 3,
})

DarkHUD.OffhandKeyFontSize = math.ceil(DarkHUD.Scale * 28)

dh:On("Rescale", "OffhandFonts", function(_, sc)
	surface.CreateFont("Darkhud_OffhandTip", {
		font = "BreezeSans",
		size = sc * 28,
		weight = 600,
	})

	surface.CreateFont("Darkhud_OffhandTipShadow", {
		font = "BreezeSans",
		size = sc * 28,
		weight = 600,
		blursize = 3,
	})

	surface.CreateFont("Darkhud_OffhandTipSmall", {
		font = "BreezeSans",
		size = DarkHUD.Scale * 24,
		weight = 600,
	})

	DarkHUD.OffhandKeyFontSize = math.ceil(sc * 28)
end)

local holdTip = "(hold)"

dh:On("AmmoThink", "ThinkOffhand", function(_, pnl)
	local w = math.max(48, 48 * DarkHUD.Scale)
	local fw = pnl:GetWide()

	pnl:To("OffhandX", pnl.Gone and fw - #Offhand.Binds * w or 8, 0.3, 0, 0.3)
	pnl:To("OffhandFr", (pnl.Gone or pnl.GoingAway) and 0 or 1, 0.3, 0, 0.3)
end)

dh.OffhandY = 0

dh:On("AmmoPainted", "PaintOffhand", function(_, pnl, fw, h)

	local minW = math.max(48, 48 * DarkHUD.Scale)
	local maxW = math.max(64, 64 * DarkHUD.Scale)

	local x = Lerp(1 - pnl.OffhandFr, pnl.OffhandX or 8, fw - maxW * 3 - pad * 2)
	local w = Lerp(1 - pnl.OffhandFr, minW, maxW)

	pnl.OffhandFr = pnl.OffhandFr or 0
	local y = -w - DarkHUD.OffhandYPad -- - (1 - pnl.OffhandFr) * h
	dh.OffhandY = y - 8

	local mat, has = draw.GetMaterial(icon[1], icon[2])

	if has then
		handle:CacheRet(3, 8, 6)
	end

	local clip = DisableClipping(true)

	-- counteract the shaking a bit
	-- unshaken is used in painting icons and keys, not rects

	local minY = dh.OffhandY

	for i, bind in ipairs(Offhand.Binds) do
		local ux = math.floor(x - pnl.ShakeX * 0.6)
		local uy = math.floor(y - pnl.ShakeY * 0.6)

		local act = Offhand.GetBindAction(bind)
		local tbl = Offhand.GetAction(act)

		local left = x - rectSz
		local uleft = ux - rectSz

		local top = y - rectSz
		local utop = uy - rectSz

		local rsz = w + rectSz * 2

		--[[surface.SetDrawColor(rectCol:Unpack())
		surface.DrawRect(left, top, rsz, rsz)

		surface.SetDrawColor(gradCol:Unpack())
		surface.SetMaterial(MoarPanelsMats.gd)
		surface.DrawTexturedRectUV(left,
			-w * gradH - DarkHUD.OffhandYPad + rectSz - (1 - pnl.OffhandFr) * h,
			rsz, w * gradH,
			0, 0, 1, gradStart)]]

		local ok, add

		if not tbl or not tbl.Paint or
			(tbl.ShouldPaint and tbl:ShouldPaint() == false) then
			add = w

			if tbl and tbl.PaintNothing then
				xpcall(tbl.PaintNothing, GenerateErrorer("PaintAction_Nothing_" .. act), pnl, ux, uy, w)
			else
				paintNothing(pnl, ux, uy, w)
			end

		else
			ok, add = xpcall(tbl.Paint, GenerateErrorer("PaintAction_" .. act),
				pnl, ux, uy, w)
		end

		if not act or act:match("nothing") then act = nil end

		if pnl.OffhandFr > 0 or not act then
			local aFr = Lerp(pnl.OffhandFr or 0, act and 0 or 0.5, 1)

			local txt = fmt:format(input.GetKeyName(bind.Key)):upper()

			surface.SetFont("Darkhud_OffhandTipShadow")

			local txW, txH = surface.GetTextSize(txt)
			local txX, txY = math.floor(uleft + rsz / 2 - txW / 2),
				math.floor(utop - 4 - txH)

			local tipW, tipH = 0, 0

			if not act then
				local font = "Darkhud_OffhandTipSmall"
				surface.SetFont(font .. "Shadow")
				surface.SetTextColor(0, 0, 0, aFr * 200)
				tipW, tipH = surface.GetTextSize(holdTip)
				local tipX = uleft + rsz / 2 - tipW / 2

				for i=1, 3 do
					surface.SetTextPos(tipX, txY - tipH)
					surface.DrawText(holdTip)
				end

				surface.SetFont(font)
				surface.SetTextColor(160, 160, 160, aFr * 200)
				surface.SetTextPos(tipX, txY - tipH)

				surface.DrawText(holdTip)
			end

			surface.SetFont("Darkhud_OffhandTipShadow")
			surface.SetTextColor(0, 0, 0, aFr * 255)

			for i=1, 5 do
				surface.SetTextPos(txX, txY)
				surface.DrawText(txt)
			end

			surface.SetFont("Darkhud_OffhandTip")
			surface.SetTextPos(txX, txY)
			surface.SetTextColor(255, 255, 255, aFr * 255)
			surface.DrawText(txt)

			minY = math.min(minY, Lerp(not act and 1 or aFr, uy, txY - tipH))
		end

		x = x + (add or w) + pad
	end

	dh.OffhandY = minY
	DisableClipping(clip)
end)
