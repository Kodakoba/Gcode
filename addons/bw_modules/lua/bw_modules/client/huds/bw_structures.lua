

local EntHP = 0
local EntMaxHP = 0

local lastEnt

local optimal_w, optimal_h = 180, 55

local HPBG = Color(75, 75, 75)
local HPFG = Color(200, 75, 75)

local white = Color(255, 255, 255)
local gray = Color(40, 40, 40)

local anims

local paintEntityLevel

local function paint(ent, curent, baseAnim, firstFrame)
	anims = anims or Animatable("HUD_Structures")

	anims.EntHPs = anims.EntHPs or {}

	if ent and ent.IsBaseWars then
		lastEnt = ent
		EntHP = ent:Health()
		EntMaxHP = math.max(ent:GetMaxHealth(), 1)

		local hpfrac = (EntHP / EntMaxHP)
	end

	if not lastEnt or not lastEnt:IsValid() then return end

	--[==================================[
				Size calculation
	--]==================================]

	local toH = optimal_h

	local rebooting = false
	local dead = not lastEnt:GetPower() and not lastEnt.Powerless

	if dead or rebooting then
		toH = toH + 18
	end

	local w = baseAnim.Width or optimal_w
	local h = baseAnim.Height or toH

	--[==================================[
			HP Bar Size calculation
	--]==================================]

	local hpfrac = (EntHP / EntMaxHP)

	if not anims.EntHPs[lastEnt:EntIndex()] then
		anims.EntHPs[lastEnt:EntIndex()] = hpfrac
	end

	anims:MemberLerp(anims.EntHPs, lastEnt:EntIndex(), hpfrac, 0.3, 0, 0.3)

	hpfrac = anims.EntHPs[lastEnt:EntIndex()]

	local hpW = hpfrac * (w - 12)
	hpW = math.floor(math.max(hpW, 8))			--for nice rounding


	--[==================================[
			  Actual paint process
	--]==================================]

	local headerH = 24

	BaseWars.HUD.PaintFrame(w, h, headerH)

	local name = lastEnt.PrintName
	draw.SimpleText(name, "OSB24", w/2, math.floor(headerH / 2), white, 1, 1)

	draw.RoundedBox(6, 6, headerH + 8, w - 13, 14, HPBG)
	draw.RoundedBox(6, 6, headerH + 8, hpW, 14, HPFG)

	local tx = Language("Health", EntHP, EntMaxHP)

	draw.Masked(function()
		draw.RoundedPolyBox(6, 4, headerH + 3, hpW + 1, 24, HPFG)
	end, function()
		draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 14, white, 1, 1)
	end, nil, function()
		draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 14, gray, 1, 1)
	end)

	local tY = headerH + 26

	if rebooting then
		local _, tH = draw.SimpleText("Rebooting" .. ("."):rep((CurTime() * 3) % 3 + 1), "OS18", w/2, tY, white, 1, 5)
		White()
		draw.LegacyLoading(w / 2 + rebootingMaxWidth / 2 + 6 + 8, tY + tH / 2, 16, 16)
		tY = tY + 18
	elseif dead then
		anims.NoPowerCol = anims.NoPowerCol or Color(200, 60, 60)
		local colh, cols, colv = 0, 0.7, 0.78 --values for Color(200, 60, 60)
		draw.ColorModHSV(anims.NoPowerCol, colh, cols, colv + math.sin(CurTime() * 8) * 0.08)
		--anims.NoPowerCol.a = alpha

		draw.SimpleText("Insufficient power!", "OSB18", w/2, tY, anims.NoPowerCol, 1, 5)

		tY = tY + 18
	end


	local uY, uH = paintEntityLevel(lastEnt, w, tY)
	tY = tY + uY
	toH = toH + uH

	local toW = optimal_w

	if lastEnt.PaintStructureInfo then
		local needHeight, needWidth = lastEnt:PaintStructureInfo(w, tY)

		if not needHeight then
			print("reminder: ENT:PaintStructureInfo needs to return additional height. return 0 if unnecessary.")
			needHeight = 0
		end

		if curent then
			-- only add the info height if we're actually looking at the ent rn
			toH = toH + needHeight
			if needWidth then
				toW = math.max(optimal_w, needWidth)
			end
		end
	end

	if firstFrame then
		baseAnim:RemoveLerp("Height")
		baseAnim.Height = toH

		baseAnim:RemoveLerp("Width")
		baseAnim.Width = toW
	elseif curent then
		baseAnim:To("Height", toH, 0.3, 0, 0.3)
		baseAnim:To("Width", toW, 0.3, 0, 0.3)
	end
end

local lvFont = "OSB24"
local fh = draw.GetFontHeight(lvFont)

function paintEntityLevel(ent, w, y)
	if not ent.GetLevel or not chat.IsOpen() then
		anims:To("LevelFrac", 0, 0.3, 0, 0.3)
		return (anims.LevelFrac or 0) * fh, 0
	end

	anims:To("LevelFrac", 1, 0.3, 0, 0.3)

	local fr = anims.LevelFrac or 0
	draw.SimpleText(Language("Level", ent:GetLevel()),
		lvFont, w / 2, y, color_white, 1)

	--[[draw.SimpleText(Language("Level", ent:GetLevel()),
		lvFont, w / 2, y, color_white, 1)]]

	return fh * fr, fh
end

hook.Add("BW_ShouldPaintStructureInfo", "BWStructure", function(ent, dist)
	return ent.IsBaseWars and dist < 192, 192, paint
end)