HDN = HDN or {}
HDN.Instances = HDN.Instances or muldim:new()
HDN.Anim = Animatable("HDN")

HDN.Colors = {
	Damage = Color(230, 230, 230, 210),
	Crit = Color(0, 0, 0, 255),
}

HDN.ShakeLength = 0.4
HDN.MoveLength = 0.2
HDN.DisappearTime = 2
HDN.DisappearLen = 0.2

HDN.FontMain = "BSB64"

function HDN.AddIndicator(victim, dmg, crit, pos)
	local val, cur = HDN.Instances:Insert({
		damage = dmg,
		crit = crit,
		pos = pos,
	}, victim)

	local dat = HDN.Instances[victim]
	dat.total = (dat.total or 0) + dmg
	dat.totalAnim = dat.totalAnim or 0
	dat.lastDmg = CurTime()
	dat.firstDeal = dat.firstDeal or CurTime()
	dat.pixvis = dat.pixvis or util.GetPixelVisibleHandle()

	HDN.Anim:MemberLerp(dat, "totalAnim", dat.total, HDN.ShakeLength, 0, 0.25)
end

net.Receive("bhdn_spawn", function()
	local victim = net.ReadEntity()
	local dmg = net.ReadUInt(16)
	local crit = net.ReadBool()
	local pos = net.ReadVector()

	HDN.AddIndicator(victim, dmg, crit, pos)
end)

local tVecs = {Vector(), Vector(), Vector()}
local tCols = {Color(0, 0, 0), Color(0, 0, 0)}

local ep, ev = EyePos(), EyeVector()

function HDN.DrawEntity(ent, dat)
	

	return true
end

local mx = Matrix()

function HDN.DrawEntityNumber(ent, dat, state)
	if not IsValid(ent) then return true end

	local total = dat.total

	local hnPos
	--[[local attIdx = ent:LookupAttachment("eyes")

	if attIdx then
		local att = ent:GetAttachment(attIdx)
		hnPos = att and att.Pos

		if hnPos then
			hnPos[3] = hnPos[3] + 10
		end
	end]]

	if not hnPos then
		local bone = ent:BoneToIndex("ValveBiped.Bip01_Head1")

		if not bone then
			hnPos = dat[1] and dat[1].pos
				or ent:OBBCenter()
		else
			hnPos = ent:GetBonePosition(bone)
			hnPos[3] = hnPos[3] + 8
		end
	end

	local pixvis = util.PixelVisible(hnPos, 8, dat.pixvis)

	local x, y
	local do2d = false

	local tx = ("-%d"):format(dat.totalAnim)
	local txW, txH = surface.GetTextSizeQuick(tx, HDN.FontMain)
	local scale = 0.5

	if pixvis > 0.5 then
		local sdat = hnPos:ToScreen()
		local vis = sdat.visible

		if vis and (sdat.x < -120 or sdat.x > ScrW() + 120) then -- Y axis is for losers
			vis = false
		end

		if not vis then return end
		dat.lx, dat.ly = sdat.x, sdat.y

		dat.moveIn = dat.moveIn or (dat.moveOut and CurTime())
		dat.moveOut = nil

		local mpass = dat.moveIn and CurTime() - dat.moveIn or math.huge
		local fr = math.min(1, math.TimeFraction( 0, HDN.MoveLength, mpass ))
		fr = Ease(fr, 0.25)

		x = Lerp(fr, dat.sx, sdat.x)
		y = Lerp(fr, dat.sy, sdat.y)
	else
		local amt = state.amt or 0
		state.amt = amt + 1

		dat.moveIn = nil
		dat.moved = true

		dat.sx = ScrW() / 2 + txW / 2 + 16
		dat.sy = ScrH() / 2 + txH / 2 * scale

		if dat.lx then
			-- lerp from the last visible position
			dat.moveOut = dat.moveOut or CurTime()
			local mpass = CurTime() - dat.moveOut
			local fr = math.min(1, math.TimeFraction( 0, HDN.MoveLength, mpass ))
			fr = Ease(fr, 0.25)

			x = Lerp(fr, dat.lx, dat.sx)
			y = Lerp(fr, dat.ly, dat.sy)
		else
			x, y = 0, 0
		end

		do2d = true
	end

	dat.firstpixvis = false

	local diffVec = tVecs[1]
	diffVec:Set(hnPos)
	diffVec:Sub(ep)
	diffVec:Normalize()

	if not do2d then
		local dot = ev:Dot(diffVec)
		local ang = math.deg(math.acos(dot))

		scale = Lerp(1 - (ang / 45) ^ 0.6, 0.75, 1)
		local distScale = 1 - (math.max(0, ep:Distance(hnPos) - 192) / 768)
		distScale = Lerp(distScale, 0.5, 1)

		scale = Lerp(1 - (ep:Distance(hnPos) / 768), 0.3, 1) * scale

		scale = scale * 0.6
	end

	local passedFirst = CurTime() - dat.firstDeal
	local passed = CurTime() - dat.lastDmg

	local shake = math.max(0, math.Remap(passed, 0, HDN.ShakeLength, 1, 0)) * 4

	local shkX = math.cos(SysTime() * 150) * shake / 2
	local shkY = math.sin(SysTime() * 100) * shake

	local rotFr = math.max(0, math.Remap(passedFirst, 0, 0.4, 0, 1))
	rotFr = Ease(rotFr, 0.3)
	local rotAng = -Lerp(rotFr, 90, 0)

	if passed > HDN.DisappearTime - HDN.DisappearLen then
		rotFr = math.Remap(passed, HDN.DisappearTime - HDN.DisappearLen, HDN.DisappearTime, 1, 0)
		rotFr = Ease(rotFr, 0.3)
		rotAng = -Lerp(rotFr, 60, 0)
	end

	

	mx:Reset()

	mx:TranslateNumber(x + shkX, y + shkY)
	mx:SetScaleNumber(scale, scale)

	-- text is bottom-aligned so we add height
	mx:TranslateNumber(txW * (1 - rotFr) / 2, txH * (1 - rotFr))
	mx:SetAnglesNumber(0, rotAng)
	mx:TranslateNumber(0, 0)

	tCols[1]:Set(HDN.Colors.Damage)
	tCols[1].a = Lerp(rotFr, tCols[1].a * 0.33, tCols[1].a)

	tCols[2]:Set(HDN.Colors.Crit)
	tCols[2].a = Lerp(rotFr, tCols[2].a * 0.1, tCols[2].a)

	DisableClipping(true)
	cam.PushModelMatrix(mx)
		draw.SimpleTextOutlined(tx, HDN.FontMain, 0, 0, tCols[1], 1, 4, 2, tCols[2])
		White()
		--surface.DrawOutlinedRect(-txW / 2, -txH, txW, txH, 2)
	cam.PopModelMatrix()
	DisableClipping(false)

	if passed > 2 then
		return true
	end
end

hook.Add("HUDPaint", "HDN", function()
	local state = {}

	draw.EnableFilters()
	for ent, dat in pairs(HDN.Instances) do
		local rem = HDN.DrawEntityNumber(ent, dat, state)
		if rem then HDN.Instances[ent] = nil end
	end
	draw.DisableFilters()
end)

hook.Add("PostDrawTranslucentRenderables", "HDN", function()
	ep, ev = EyePos(), EyeVector()

	for ent, dat in pairs(HDN.Instances) do
		local ok = HDN.DrawEntity(ent, dat)
		--if not ok then HDN.Instances[ent] = nil end
	end
end)