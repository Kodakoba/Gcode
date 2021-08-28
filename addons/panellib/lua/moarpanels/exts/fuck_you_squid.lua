local function BenchPoly(...)	--shh
	return surface_DrawPoly(...)
end

local sin = math.sin
local cos = math.cos
local mrad = math.rad

function draw.DrawCircle(x, y, rad, seg, perc, reverse, matsize)
	local circ = {}

	local uvdiv = (matsize and 2*matsize) or 2
	perc = perc or 100

	if reverse == nil then
		reverse = false
	end

	local segs = math.min(seg * (perc/100), seg)

	local degoff = -360
	local key = "reg"

	if circles[key][seg] then

		local st = circles[key][seg]	--st = pre-generated cached circle

		local segfull, segdec = math.modf(segs)
		segfull = segfull + 2
		segdec = (segdec~=0 and segdec) or nil

		for k,w in ipairs(st) do 	--CURSED VAR NAME

			--[[
				Generate sub-segment (for percentage)
			]]

			if not reverse and (k > segfull) then --the current segment will be the sub-segment
				if segdec then

					local a = mrad( ( (segs) / seg ) * degoff)

					local s = sin(a)
					local c = cos(a)

					circ[#circ+1] = {
						x = s*rad + x,
						y = c*rad + y,
						u = s/uvdiv + 0.5,
						v = c/uvdiv + 0.5
					}

				end
			break end 	--+1 due to poly #1 being a [0,0]

			if reverse and (k-3 < seg-segfull) and k ~= 1 then

				if segdec and k-2 >= seg-segfull then

					local a = mrad( ( (k-2-segdec) / seg ) * degoff)
					local s = sin(a)
					local c = cos(a)
					circ[#circ+1] = {
						x = s*rad + x,
						y = c*rad + y,
						u = s/uvdiv + 0.5,
						v = c/uvdiv + 0.5
					}
				end

			continue end

			circ[#circ+1] = {
				x=w.x*rad + x, 			--XwX
				y=w.y*rad + y, 			--YwY
				u=w.u/uvdiv + 0.5,		--UwU
				v=w.v/uvdiv + 0.5 	 	--VwV
			}

			if k==1 then circ[#circ].u = 0.5 circ[#circ].v = 0.5 end
		end

		BenchPoly(circ)
	else

		local segfull, segdec = math.modf(segs)
		segdec = (segdec~=0 and segdec) or nil

		for i=0, seg do --generate full circle...

			local a = mrad( ( i / seg ) * degoff)

			local s = sin(a)
			local c = cos(a)

			circ[i+1] = {
				x = s,
				y = c,
				u = s,
				v = c
			}
		end

		local a = mrad(0)

		local s = sin(a)
		local c = cos(a)

		circ[#circ+1] = {
			x = s,
			y = c,
			u = s,
			v = c
		}

		circles[key][seg] = circ

		local origin = {
			x = 0,
			y = 0,
			u = 0.5,
			v = 0.5,
		}

		table.insert(circ, 1, origin)

		local c2 = {}

		for k,w in pairs(circ) do 	--CURSED VAR NAME
			if not reverse and (k > segs+1) then
				if segdec then

					local a = mrad( ( (k-3+segdec) / seg ) * degoff)

					local s = sin(a)
					local c = cos(a)

					c2[#c2+1] = {
						x = s*rad + x,
						y = c*rad + y,
						u = s/2 + 0.5,
						v = c/2 + 0.5
					}

				end
			break end 	--+1 due to poly #1 being a [0,0]

			if reverse and (k < seg-segfull) and k ~= 1 then continue end

			c2[#c2+1] = {
				x = w.x*rad + x, --XwX
				y = w.y*rad + y, --YwY
				u = w.u,		 --UwU
				v = w.v 	 --VwV
			}
		end
		BenchPoly(c2)
	end
end

draw.Circle = draw.DrawCircle --noob mistakes