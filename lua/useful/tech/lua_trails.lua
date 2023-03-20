local trail = Material("trails/laser")

--[==================================[
 			modify these:
 --]==================================]
local updatePeriod = 1 / 66 -- update x times a second (or less if FPS is bad, lole)
							-- increasing this will also increase the quality of the trail (=> render time)

local an = Animatable("treil")

local function ubLerp(fr, from, to)
	return from + (to - from) * fr
end

local function getWidth(timePassed, dat)
	local maxWidth = 16
	local minWidth = 0
	local fadeStart = 0 -- default trail behavior: start shrinking immediately
	local fadeLength = 2

	local fr = math.max(0, timePassed - fadeStart) / fadeLength -- you can add easing here if you want
	local lfr = math.ease.InOutCirc(fr) -- also try math.ease.InBounce, looks pretty funny
	local width = ubLerp( lfr, maxWidth, minWidth )

	local wave = 1--math.min(1, math.sin(dat.time * math.pi * 4) * 0.25 + 0.75)
	return width * wave, fr >= 1 -- second return is a bool: if true, the trail point should be removed
end

local function shouldShowTrail(ply)
	-- do a check whether `ply` needs a trail -- an NWBool maybe?
	return true
end



--[==================================[
 			internals below
 --]==================================]

local players = player.GetAll()
local trails = {}

hook.Add("NotifyShouldTransmit", "tryiel", function(e, enter)
	if not enter then table.RemoveByValue(players, e) return end
	if e:IsPlayer() then
		table.insert(players, e)
	end
end)


local function getTexEnd(cur, lastPt)
	if lastPt then
		return lastPt.txend + lastPt.pos:Distance(cur.pos) / 16
	else
		return 0
	end
end

local col = Color(0, 0, 0)

local function getColor(dat)
	col:SetHSV(dat.time * 180 % 360, 0.7, 1)
	return col
end

local function getPos(ply, t)
	local pos = ply:GetPos()
	pos:Add(ply:OBBCenter())

	an:To(ply, ply:GetVelocity():IsEqualTol(vector_origin, 16) and 1 or 0, 0.8, 0, 0.2)

	local fr = an[ply] or 0

	pos.x = pos.x + math.cos(t * math.pi * 3) * 36 * fr
	pos.y = pos.y + math.sin(t * math.pi * 3) * 36 * fr
	pos.z = pos.z + math.sin(t * math.pi / 1.5) * 8 * fr

	pos.z = pos.z + (8 + math.sin(t * math.pi * 2) * 8) * (1 - fr)

	return pos
end

local b = bench("trailgen")
local b2 = bench("trailrender")

hook.Add("PostDrawTranslucentRenderables", "tryiel", function()
	if not players[1] and table.IsEmpty(trails) then return end -- noone to care about, i sleep

	local time = SysTime()

	b:Open()

	for _, ply in ipairs(players) do
		if not shouldShowTrail(ply) then continue end

		local t = trails[ply] or {}
		trails[ply] = t

		-- offset if needed
		local pos = getPos(ply, time)

		local passed = time - (ply._lastTrailUpdate or 0)

		if passed > updatePeriod then
			local prev = t[#t]

			ply._lastTrailUpdate = time
			local new = {
				pos = pos,
				time = time, -- retains precision, though you have bigger issues if this is one lol
			}

			new.txend = getTexEnd(new, prev)
			table.insert(t, new)
		else
			local prev = t[#t - 1]
			local last = t[#t]
			if not last then continue end

			last.pos:Set(pos)
			last.time = time
			last.txend = getTexEnd(last, prev)
		end
	end

	b:Close():print()

	if table.IsEmpty(trails) then return end -- no trails, i sleep

	b2:Open()
	for ply, dat in pairs(trails) do

		render.StartBeam(#dat)

		for i=#dat, 1, -1 do -- reverse iteration: from newest to oldest
			local v = dat[i]
			local pos, start = v.pos, v.time
			local width, remove = getWidth(time - start, v)

			if remove then
				table.remove(dat, i)
				continue
			end

			render.AddBeam(pos, width, v.txend, getColor(v))
		end

		render.SetMaterial(trail)
		render.EndBeam()
	end
	b2:Close():print()
end)