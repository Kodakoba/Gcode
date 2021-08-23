MoarPanelsMats = MoarPanelsMats or {}
MatsBack = MatsBack or {}

setfenv(0, _G) --never speak to me or my son

local math_Round = math.Round
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_DrawText = surface.DrawText
local surface_GetTextSize = surface.GetTextSize
local surface_SetFont = surface.SetFont
local surface_DisableClipping = DisableClipping
local surface_DrawPoly = surface.DrawPoly

MoarPanelsMats.gu = Material("vgui/gradient-u")
MoarPanelsMats.gd = Material("vgui/gradient-d")
MoarPanelsMats.gr = Material("vgui/gradient-r")
MoarPanelsMats.gl = Material("vgui/gradient-l")
MoarPanelsMats.g = Material("gui/gradient", "noclamp smooth")


local spinner = Material("data/hdl/spinner.png")
local spinner32 = Material("data/hdl/spinner32.png")

local cout = Material("data/hdl/circle_outline256.png")
local cout128 = Material("data/hdl/circle_outline128.png")
local cout64 = Material("data/hdl/circle_outline64.png")
local bad = Material("materials/icon16/cancel.png")

local blur = CreateMaterial("lbu_Blur", "GMODScreenspace", {
	["$basetexture"] = "_rt_FullFrameFB",
	["$texturealpha"] = "0",
	["$vertexalpha"] = "0",
	["$blur"] = 1.6,
})

blur:Recompute()

local _ = spinner:IsError() and hdl.DownloadFile("https://i.imgur.com/KHvsQ4u.png", "spinner.png", function(fn) spinner = Material(fn, "mips") end)
_ = spinner32:IsError() and hdl.DownloadFile("https://i.imgur.com/YMMrRhh.png", "spinner32.png", function(fn) spinner32 = Material(fn, "mips") end)
_ = cout:IsError() and hdl.DownloadFile("https://i.imgur.com/huBY9vo.png", "circle_outline256.png", function(fn) cout = Material(fn, "mips") end)
_ = cout128:IsError() and hdl.DownloadFile("https://i.imgur.com/mLZEMpW.png", "circle_outline128.png", function(fn) cout128 = Material(fn, "mips") end)
_ = cout64:IsError() and hdl.DownloadFile("https://i.imgur.com/kY0Isiz.png", "circle_outline64.png", function(fn) cout64 = Material(fn, "mips") end)

local circles = {rev = {}, reg = {}} --reverse and regular

local function LerpColor(frac, col, dest, src)

	col.r = Lerp(frac, src.r, dest.r)
	col.g = Lerp(frac, src.g, dest.g)
	col.b = Lerp(frac, src.b, dest.b)

	local sA, c1A, c2A = src.a, col.a, dest.a

	if sA ~= c2A or c1A ~= c2A then
		col.a = Lerp(frac, sA, c2A)
	end

end

draw.LerpColor = LerpColor

local function BenchPoly(...)	--shh
	surface_DrawPoly(...)
end

local ipairs = ipairs

local sin = math.sin
local cos = math.cos
local mrad = math.rad

local sizes = {}

function surface.GetTextSizeQuick(tx, font)
	surface_SetFont(font)
	return surface_GetTextSize(tx)
end

function surface.CharSizes(tx, font, unicode)
	local szs = {}
	surface_SetFont(font)
	local cache = sizes[font] or {}
	sizes[font] = cache

	if unicode then
		local codes = {utf8.codepoint(tx, 1, #tx)}
		for i=1, #codes do
			local char = utf8.char(codes[i])
			local sz = cache[char]

			if not sz then
				sz = (surface_GetTextSize(char))
				cache[char] = sz
			end

			szs[i] = sz
		end

	else
		for i=1, #tx do
			local char = tx[i]
			local sz = cache[char]

			if not sz then
				sz = (surface_GetTextSize(char))
				cache[char] = sz
			end

			szs[i] = sz
		end
	end

	return szs
end

local function FetchUpValuePanel()
	return debug.getlocal(3, 1)
end

function draw.LegacyLoading(x, y, w, h)
	local size = math.min(w, h)
	surface_SetMaterial(size < 32 and spinner32 or spinner)
	surface.DrawTexturedRectRotated(x, y, size, size, -(CurTime() * 360) % 360)
end

local tr_vec = Vector()
local sc_vec = Vector()
local vm = Matrix()

function draw.DrawLoading(pnl, x, y, w, h, col)
	local ct = CurTime()
	local sx, sy

	local clipping = true

	if not ispanel(pnl) and pnl ~= nil then 	--backwards compat


		local _, panl = FetchUpValuePanel()

		--shift all vars by 1
		h = w
		w = y
		y = x
		x = pnl

		pnl = panl

		if not ispanel(pnl) then
			draw.LegacyLoading(x, y, w, h)
		return end

		sx, sy = pnl:LocalToScreen(x, y)

	elseif pnl == nil then
		sx, sy = x, y
		x, y = x, y

	elseif ispanel(pnl) then
		sx, sy = pnl:LocalToScreen(x or w/2, y or h/2)
		clipping = false
	end


	w = math.min(w, h)	--smallest square
	h = math.min(w, h)


	local amt = 3
	local dur = 2 --seconds

	if clipping then surface_DisableClipping(true) end

	col = IsColor(col) and col or false
	local r, g, b, mul_a = col and col.r or 255, col and col.g or 255, col and col.b or 255, col and col.a / 255 or 1

	--render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	for i=1, amt do
		local off = dur/amt
		local a = ((ct + off * (i-1)) % dur) / dur

		local rad = w * a
		local mat = (rad > 160 and cout) or (rad > 64 and cout128) or (rad < 64 and cout64) or cout64

		surface_SetMaterial(mat)

		tr_vec[1], tr_vec[2] = sx, sy
		sc_vec[1], sc_vec[2] = a, a

		vm:Reset()
		vm:Translate(tr_vec)
			vm:SetScale(sc_vec)
			tr_vec:Mul(-1)
		vm:Translate(tr_vec)

		cam.PushModelMatrix(vm)
			surface_SetDrawColor(r, g, b, (1 - a) * 255 * mul_a)
			surface_DrawTexturedRect(x - w/2, y - h/2, w, h)
		cam.PopModelMatrix(vm)
	end

	if clipping then surface_DisableClipping(false) end
	render.PopFilterMin()
	--render.PopFilterMag()
end

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

local rbcache = muldim:new(true)

local function GenerateRBPoly(rad, x, y, w, h, notr, nobr, nobl, notl)


	local deg = 360
	local segdeg = deg / rad / 4

	local lx = x + rad
	local rx = x + w - rad

	local ty = y + rad
	local by = y + h - rad

	local p = {}

	p[1] = {x = x + w/2, y = y + h/2}
	p[2] = {x = lx, y = y}
	p[3] = {x = rx, y = y}

	if not notr then
		for i=1, rad - 1 do
			local a = mrad(segdeg * i)

			local s = sin(a) * rad
			local c = cos(a) * rad

			p[#p + 1] = {
				x = rx + s,
				y = ty - c,
			}
		end
	else
		p[#p+1] = {x = x+w, y = y}
	end

	p[#p + 1] = {x = x+w, y = ty}
	p[#p + 1] = {x = x+w, y = by}

	if not nobr then
		for i=rad, rad*2 - 1 do
			local a = mrad(segdeg * i)
			local s = sin(a) * rad
			local c = cos(a) * rad

			p[#p + 1] = {
				x = rx + s,
				y = by - c,
			}
		end
	else
		p[#p+1] = {x = x+w, y = y+h}
	end

	p[#p + 1] = {x = rx, y = y + h}
	p[#p + 1] = {x = lx, y = y + h}

	if not nobl then
		for i=rad*2, rad*3 - 1 do
			local a = mrad(segdeg * i)
			local s = sin(a) * rad
			local c = cos(a) * rad

			p[#p + 1] = {
				x = lx + s,
				y = by - c,
			}
		end
	else
		p[#p+1] = {x = x, y = y+h}
	end

	p[#p + 1] = {x = x, y = by}
	p[#p + 1] = {x = x, y = ty}

	if not notl then
		for i=rad*3, rad*4 - 1 do
			local a = mrad(segdeg * -i)

			local s = sin(a) * rad
			local c = cos(a) * rad

			p[#p + 1] = {
				x = lx - s,
				y = ty - c,
			}
		end
	else
		p[#p+1] = {x = x, y = y}
	end

	p[#p+1] = {x = lx, y = y}

	return p
end
												--   clockwise order:
												-- V no topright, no bottomright, no bottomleft, no topleft
function draw.RoundedPolyBox(rad, x, y, w, h, col, notr, nobr, nobl, notl)

	--[[
		coords for post-rounded corners
	]]

	surface_SetDrawColor(col:Unpack())
	draw.NoTexture()

	local cache = rbcache:Get(rad, x, y, w, h, notr, nobr, nobl, notl)

	if not cache then

		local p = GenerateRBPoly(rad, x, y, w, h, notr, nobr, nobl, notl)

		rbcache:Set(p, rad, x, y, w, h, notr, nobr, nobl, notl)
		cache = p
	end

	if not cache then return end
	BenchPoly(cache)
end

local rbexcache = muldim:new(true)

local corners = {
	tex_corner8		= "gui/corner8",
	tex_corner16	= "gui/corner16",
	tex_corner32	= "gui/corner32",
	tex_corner64	= "gui/corner64",
	tex_corner512	= "gui/corner512"
}

for name, mat in pairs(corners) do
	corners[name] = CreateMaterial("alphatest_" .. mat:gsub("gui/", ""), "UnlitGeneric", {
	    ["$basetexture"] = mat,
	    ["$alphatest"] = 1,
	    ["$alphatestreference"] = 0.5,
	})
end

function draw.RoundedStencilBox(bordersize, x, y, w, h, col, tl, tr, bl, br)
	if tl == nil then tl = true end
	if tr == nil then tr = true end
	if bl == nil then bl = true end
	if br == nil then br = true end

	if col then surface_SetDrawColor(col:Unpack()) end

	-- Do not waste performance if they don't want rounded corners
	if ( bordersize <= 0 ) then
		surface_DrawRect( x, y, w, h )
		return
	end

	x = math_Round( x )
	y = math_Round( y )
	w = math_Round( w )
	h = math_Round( h )
	bordersize = math.min( math_Round( bordersize ), math.floor( w / 2 ) )

	-- Draw as much of the rect as we can without textures
	surface_DrawRect( x + bordersize, y, w - bordersize * 2, h )
	surface_DrawRect( x, y + bordersize, bordersize, h - bordersize * 2 )
	surface_DrawRect( x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2 )

	local tex = corners.tex_corner8
	if ( bordersize > 8 ) then tex = corners.tex_corner16 end
	if ( bordersize > 16 ) then tex = corners.tex_corner32 end
	if ( bordersize > 32 ) then tex = corners.tex_corner64 end
	if ( bordersize > 64 ) then tex = corners.tex_corner512 end

	surface_SetMaterial( tex )

	if ( tl ) then
		surface_DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 )
	else
		surface_DrawRect( x, y, bordersize, bordersize )
	end

	if ( tr ) then
		surface_DrawTexturedRectUV( x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1 )
	else
		surface_DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end

	if ( bl ) then
		surface_DrawTexturedRectUV( x, y + h -bordersize, bordersize, bordersize, 0, 1, 1, 0 )
	else
		surface_DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end

	if ( br ) then
		surface_DrawTexturedRectUV( x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0 )
	else
		surface_DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end

end

--mostly useful for stencils

--if bottom is true, it'll make the bottom shorter
--otherwise the top is shorter

function draw.RightTrapezoid(x, y, w, h, leg, bottom)


	local poly = {

		{ --top left
			x = x,
			y = y,
		},

		{ --top right
			x = x + w - (bottom and 0 or leg),
			y = y,
		},

		{ --bottom right
			x = x + w - (bottom and leg or 0),
			y = y + h,
		},

		{ --bottom left
			x = x,
			y = y + h,
		}
	}

	surface.DrawPoly(poly)
end

function draw.RoundedPolyBoxEx(rad, x, y, w, h, col, notr, nobr, nobl, notl)

	surface_SetDrawColor(col)
	draw.NoTexture()

	local cache = rbexcache:Get(rad, x, y, w, h, notr, nobr, nobl, notl)

	if not cache then

		local p = GenerateRBPoly(rad, x, y, w, h, notr, nobr, nobl, notl)

		rbexcache:Set(p, rad, x, y, w, h, notr, nobr, nobl, notl)
		cache = p
	end

	if not cache then return end
	BenchPoly(cache)

end

function draw.ScuffedBlur(pnl, int, x, y, w, h)
	local sx, sy = 0, 0
	if pnl then
		sx, sy = pnl:LocalToScreen(0, 0)
	end
	local sw, sh = ScrW(), ScrH()

	blur:SetFloat("$alpha", int)	-- 0-1 int

	-- SetScissorRect doesn't work with this??
	-- Even if it did, see: https://github.com/Facepunch/garrysmod-issues/issues/4635

	draw.BeginMask()
	render.SetMaterial(blur)
	render.DrawScreenQuadEx(sx, sy, sx + x + w, sy + y + h)

	
	int = math.max(int, 1)
	
	draw.DrawOp()

	for i=0, int do
		render.SetMaterial(blur)
		render.UpdateScreenEffectTexture()
		render.DrawScreenQuad()
	end

	draw.FinishMask()

end

function draw.RotatedBox(x, y, x2, y2, w)
	local dx, dy = x2 - x, y2 - y

	draw.NoTexture()

	local rad = -math.atan2(dy, dx)

	local psin = sin(rad) * w
	local pcos = cos(rad) * w

	local poly = {}

		poly[1] = {
			x = x - psin,
			y = y - pcos
		}

		poly[2] = {
			x = x2 - psin,
			y = y2 - pcos,
		}

		poly[3] = {
			x = x2 + psin,
			y = y2 + pcos,
		}

		poly[4] = {
			x = x + psin,
			y = y + pcos,
		}

	surface_DrawPoly(poly)
end

draw.Line = draw.RotatedBox

local customMats = {}

MoarPanelsMats._ReloadAll = function()
	for k,v in pairs(customMats) do
		MoarPanelsMats[k] = nil
		draw.GetMaterial(v[1], v[2], v[3])
	end
end

MoarPanelsMats._YeetAll = function()
	for k,v in pairs(customMats) do
		MoarPanelsMats[k] = nil
	end
end

-- callback: 1st arg is material, 2nd arg is boolean: was the material loaded from cache?
								-- (aka it was already loaded; if its a first load it's false)
local function GetOrDownload(url, name, flags, cb)
	if url == "-" or name == "-" then return false end
	if not name then ErrorNoHalt("GetOrDownload: No name!\n") return end

	local key = name:gsub("%.%w+$", "") .. (flags or "")
	if key == "_YeetAll" or key == "_ReloadAll" then
		ErrorNoHalt("GetOrDownload: Attempt to download a material with a reserved name!\n")
	end

	local mat = MoarPanelsMats[key]

	name = name:gsub("%(.+%)", "")

	if not mat or (mat.failed and mat.failed ~= url) then 	--mat was not loaded

		mat = {}
		MoarPanelsMats[key] = mat

		if file.Exists("hdl/" .. name, "DATA") then 		--mat existed on disk: load it in

			local cmat = Material("data/hdl/" .. name, flags or "smooth ignorez")

			mat.mat = cmat

			MatsBack[cmat] = mat

			mat.w = cmat:Width()
			mat.h = cmat:Height()

			mat.flags = flags or ""
			mat.path = "data/hdl/" .. name

			mat.fromurl = url
			customMats[key] = {url, name, flags}
			if cb then cb(mat.mat, false) end
		else 												--mat did not exist on disk: download it then load it in

			mat.downloading = true
			customMats[key] = {url, name, flags}

			hdl.DownloadFile(url, name or "unnamed.dat", function(fn)
				mat.downloading = false
				local cmat = Material(fn, flags or "smooth ignorez")
				mat.mat = cmat
				MatsBack[cmat] = mat

				mat.w = cmat:Width()
				mat.h = cmat:Height()
				mat.flags = flags or ""
				mat.path = fn

				if cb then cb(mat.mat, false) end

			end, function(err)

				mat.mat = Material("materials/icon16/cancel.png")
				mat.failed = url
				mat.downloading = false
				errorf("Failed to download! URL: %s\n Error: %s", url, err)
			end)

		end

	else --mat was already preloaded
		if mat.mat then MatsBack[mat.mat] = mat end

		if cb then cb(mat.mat, true) end
	end

	return mat
end

draw.GetMaterial = GetOrDownload

function draw.GetMaterialInfo(mat)
	return MatsBack[mat] or MoarPanelsMats[mat]
end

draw.Rect = surface.DrawRect
draw.DrawRect = surface.DrawRect

draw.Color = surface.SetDrawColor

function White()
	surface.SetDrawColor(255, 255, 255)
end

function surface.DrawMaterial(url, name, x, y, w, h, rot)
	local mat = GetOrDownload(url, name)
	if not mat then return false end

	if mat and (mat.downloading or mat.mat:IsError()) then
		draw.DrawLoading(x + w/2, y + h/2, w, h)
		return false
	end

	surface_SetMaterial(mat.mat)

	if rot then
		surface_DrawTexturedRectRotated(x, y, w, h, rot)
	else
		surface_DrawTexturedRect(x, y, w, h)
	end

	return mat
end

function surface.DrawUVMaterial(url, name, x, y, w, h, u1, v1, u2, v2)
	local mat = GetOrDownload(url, name .. "(noclamp)", "smooth noclamp ignorez")
	if not mat then return end

	if mat and mat.downloading or not mat.mat or mat.mat:IsError() then
		draw.DrawLoading(x + w/2, y + h/2, w, h)
		return
	end

	surface_SetMaterial(mat.mat)

	surface_DrawTexturedRectUV(x, y, w, h, u1, v1, u2, v2)

end

local shitCircle = CreateMaterial("_crapcircle", "UnlitGeneric", {
	["$basetexture"] = "vgui/circle",
	["$ignorez"] = 1,
	["$translucent"] = 1,

	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1, -- what in the goddamn
})

--Material("vgui/circle", "smooth ignorez")
--shitCircle:SetInt("$translucent", 1)

function draw.SetMaterialCircle(rad)
	local mat

	if rad < 64 then
		mat = GetOrDownload("https://i.imgur.com/MMHZw92.png", "small-circle.png", "smooth ignorez")
	elseif rad < 256 then
		mat = GetOrDownload("https://i.imgur.com/XAWPA15.png", "medium-circle.png", "smooth ignorez")
	else
		mat = GetOrDownload("https://i.imgur.com/6SdL8ff.png", "big-circle.png", "smooth ignorez")
	end

	if mat.mat and not mat.mat:IsError() then
		surface.SetMaterial(mat.mat)
	else
		surface.SetMaterial(shitCircle)
	end
end

function draw.DrawMaterialCircle(x, y, rad)	--i hate it but its the only way to make an antialiased circle on clients with no antialiasing set
	if rad < 64 then
		surface.DrawMaterial("https://i.imgur.com/MMHZw92.png", "small-circle.png", x - rad/2, y - rad/2, rad, rad)
	elseif rad < 256 then
		surface.DrawMaterial("https://i.imgur.com/XAWPA15.png", "medium-circle.png", x - rad/2, y - rad/2, rad, rad)
	else
		surface.DrawMaterial("https://i.imgur.com/6SdL8ff.png", "big-circle.png", x - rad/2, y - rad/2, rad, rad)
	end
end

draw.MaterialCircle = draw.DrawMaterialCircle

local sz = 512

local circMaskRT = GetRenderTargetEx("__CircleMaskRT", sz, sz, RT_SIZE_OFFSCREEN,
									MATERIAL_RT_DEPTH_SHARED, 0, 0, -1)

local circMaskRTMat = CreateMaterial("__CircleMaskRTMat", "UnlitGeneric", {
	["$basetexture"] = circMaskRT:GetName(),
	["$translucent"] = 1,
})

--[[
	Generate Circle mask
]]
local circURL, circName = "https://i.imgur.com/XAWPA15.png", "medium-circle.png"




local circMaskMatRT = GetRenderTargetEx("__CircleMaskMatRT", sz, sz, RT_SIZE_OFFSCREEN,
									MATERIAL_RT_DEPTH_SHARED, 0, 0, -1)

local circMaskMat = CreateMaterial("__CircleMaskMat", "UnlitGeneric", {
	['$basetexture'] = circMaskMatRT:GetName(),
	["$translucent"] = 1,
})

Promise(function(res)
	draw.GetMaterial(circURL, circName, nil, res)
end):Then(function(mat)

	render.PushRenderTarget(circMaskMatRT)
		cam.Start2D()
			render.Clear(0, 0, 0, 0)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	render.PopRenderTarget()

	--circMaskMat:SetTexture("$basetexture", mat:GetTexture("$basetexture"))
	--circMaskMat:SetTexture("$basetexture", mat:GetTexture("$basetexture"))
end):Exec()

function draw.MaskCircle(x, y, rad, func, ...)
	rad = rad * 2
	render.PushRenderTarget(circMaskRT)
		cam.Start2D()
			render.Clear(0, 0, 0, 0, true)
			local ok, err = pcall(func, ...)

			render.SetWriteDepthToDestAlpha(false)
				render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, 3 )
					surface.SetMaterial(circMaskMat)
					surface.DrawTexturedRect(0, 0, sz, sz)
				render.OverrideBlend(false)
			render.SetWriteDepthToDestAlpha(true)

		cam.End2D()
	render.PopRenderTarget()

	if ok == false then
		error(err)
		return
	end

	--draw.EnableFilters(true, false)

	--draw.DisableFilters(true, false)


	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(circMaskRTMat)
	surface.DrawTexturedRect(x, y, rad, rad)
end

function draw.EnableMaskCircle(x, y, w, h)

	render.PushRenderTarget(circMaskRT, x, y, w, h)
		cam.Start2D()
			render.OverrideDepthEnable(true, true)
			render.Clear( 0, 0, 0, 0, true )

end
			-- draw op

function draw.DisableMaskCircle(x, y, rad)
			render.SetWriteDepthToDestAlpha(false)
				render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, 3 )
					surface.SetMaterial(circMaskMat)
					surface.DrawTexturedRect(0, 0, rad, rad)
				render.OverrideBlend(false)
			render.SetWriteDepthToDestAlpha(true)

		cam.End2D()
	render.PopRenderTarget()
	render.OverrideDepthEnable(false, true)

	render.OverrideColorWriteEnable(true, true)
	render.OverrideAlphaWriteEnable(true, true)
	surface.SetDrawColor(0, 0, 0, 120)
	surface.SetMaterial(circMaskRTMat)
	surface.DrawTexturedRect(x or 0, y or 0, rad, rad)
end
--[[

-- Draw the actual mask


function draw.MaskCircle(x, y, w, h, func, ...)



-- Create a translucent render-able material for our render target


local txBackground = Material( "models/weapons/v_toolgun/screen_bg" )
local mask = Material( "gui/gradient_down" )



end]]


function draw.BeginMask(mask, ...)
	render.SetStencilPassOperation( STENCIL_KEEP )

	render.SetStencilEnable(true)

		render.ClearStencil()

		render.SetStencilTestMask(0xFF)
		render.SetStencilWriteMask(0xFF)

		draw.SetMaskDraw(false)

		render.SetStencilReferenceValue( 1 ) --include

		if mask then mask(...) end

end

function draw.SetMaskDraw(should)
	if should then
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_REPLACE )
	else
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )
	end
end

function draw.DisableMask()
	render.SetStencilEnable(false)
end

function draw.ReenableMask()
	render.SetStencilEnable(true)
end

function draw.DeMask(demask, ...) --requires mask to be started
	render.SetStencilReferenceValue( 0 ) --exclude
	if demask then demask(...) end
end

function draw.DrawOp()
	render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilReferenceValue( 0 )
end

function draw.FinishMask()
	render.SetStencilEnable(false)
end


function draw.Masked(mask, op, demask, deop, ...)

	render.SetStencilPassOperation( STENCIL_KEEP )

	render.SetStencilEnable(true)

		render.ClearStencil()

		render.SetStencilTestMask(0xFF)
		render.SetStencilWriteMask(0xFF)

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )

		render.SetStencilReferenceValue( 1 ) --include

		mask(...)

		render.SetStencilReferenceValue( 0 ) --exclude

		if demask then

			demask(...)

		end

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )

		op(...)	--actual draw op

		if deop then
			render.SetStencilCompareFunction( STENCIL_EQUAL )

			deop(...)
		end

	render.SetStencilEnable(false)

end


local RTs = MoarPanelsRTs or {}
MoarPanelsRTs = RTs

local mats = MoarPanelsRTMats or {}
MoarPanelsRTMats = mats

local function CreateRT(name, w, h)

	return GetRenderTargetEx(
		name,
		w,
		h,
		RT_SIZE_OFFSCREEN,			--the wiki claims rendertargets change sizes to powers of 2 and clamp it to screen size; lets prevent that
		MATERIAL_RT_DEPTH_SHARED, 	--idfk?
		2, 	--texture filtering, the enum doesn't work..?
		CREATERENDERTARGETFLAGS_HDR,--wtf
		IMAGE_FORMAT_RGBA8888		--huh
	)

end

function draw.GetRT(name, w, h)
	local rt
	if not w or not h then error("error #2 or #3: expected width and height, received nothin'") return end

	if not RTs[name] then

		rt = CreateRT(name .. w .. h, w, h)

		local m = muldim()
		RTs[name] = m

		m:Set(rt, w, h)
		m:Set(1, "Number")

	else
		local rtm = RTs[name]
		local cached = rtm:Get(w, h)

		if cached then
			rt = cached
		else --new W and H aren't equal, so recreate the RT

			local id = rtm:Get("Number")
			rtm:Set(id + 1, "Number")

			rt = CreateRT(name .. w .. h .. id, w, h)
			rtm:Set(rt, w, h)
		end

	end

	return rt
end

function draw.GetRTMat(name, w, h, shader)
	local rt = draw.GetRT(name, w, h)
	name = name .. ("%dx%d"):format(w, h)
	local mat = mats[name]
	if not mat then

		mat = CreateMaterial(name, shader or "UnlitGeneric", {
			["$basetexture"] = rt:GetName(),
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1,
		})

		mats[name] = mat
	end

	return rt, mat
end

local minstate = 0
local magstate = 0

local anis = TEXFILTER.ANISOTROPIC

function draw.EnableFilters(min, mag)
	local gm, gmg = min, mag
	if min == nil then
		min = true
	end

	if mag == nil then
		mag = true
	end

	local omin, omag = min, mag

	min = minstate == 0 and min -- if min/mag already enabled, set to false
	mag = magstate == 0 and mag -- otherwise, use original

	minstate = minstate + (omin and 1 or 0)
	magstate = magstate + (omag and 1 or 0)

	if not min and not mag then return end

	if min then render.PushFilterMin(anis) end
	if mag then render.PushFilterMag(anis) end
end

function draw.DisableFilters(min, mag)
	if min == nil then
		min = true
	end

	if mag == nil then
		mag = true
	end

	local omin, omag = min, mag

	min = minstate == 1 and min -- if min/mag already disabled, set to false (dont need to disable whats disabled)
	mag = magstate == 1 and mag -- otherwise, use original

	minstate = minstate - (omin and 1 or 0)
	magstate = magstate - (omag and 1 or 0)

	if not min and not mag then return end

	if mag then render.PopFilterMag() end
	if min then render.PopFilterMin() end
end

function draw.RenderOntoMaterial(name, w, h, func, rtfunc, matfunc, pre_rt, pre_mat, has2d, x, y)

	local rt
	local mat

	if not RTs[name] then

		rt = CreateRT(name, w, h)

		mat = CreateMaterial(name, "UnlitGeneric", {
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1,
		})

		local m = muldim()
		RTs[name] = m
		m:Set(rt, w, h)
		m:Set(1, "Number")

		mats[name] = mat

	else
		local rtm = RTs[name]
		local cached = rtm:Get(w, h)

		if cached then
			rt = cached
		else --new W and H aren't equal, so recreate the RT

			local id = rtm:Get("Number")
			rtm:Set(id + 1, "Number")
			rt = CreateRT(name .. id, w, h)
			rtm:Set(rt, w, h)
		end

		mats[name] = mats[name] or CreateMaterial(name, "UnlitGeneric", {
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1,
		})

		mat = mats[name]
	end

	rt = pre_rt or rt
	mat = pre_mat or mat

	mat:SetTexture("$basetexture", rt:GetName())

	render.PushRenderTarget(rt)

		render.OverrideAlphaWriteEnable(true, true)

			render.ClearDepth()
			render.Clear(0, 0, 0, 0)

			if not has2d then cam.Start2D() end
				local ok, err = pcall(func, w, h, rt)


			if rtfunc and ok then
				local ok, keep = pcall(rtfunc, rt)
				if ok and keep == false then

					render.PopRenderTarget()
					render.OverrideAlphaWriteEnable(false)
					if not has2d then cam.End2D() end

					return
				end
			end

			if not has2d then cam.End2D() end

		render.OverrideAlphaWriteEnable(false)

	render.PopRenderTarget()



	if matfunc and ok then
		matfunc(mat)
	end

	if not ok then
		error("RenderOntoMaterial got an error while drawing!\n" .. err)
		return
	end

	return mat

end

local mdls = {}

if IsValid(MoarPanelsSpawnIcon) then MoarPanelsSpawnIcon:Remove() end

local function GetSpawnIcon()

	if not IsValid(MoarPanelsSpawnIcon) then
		MoarPanelsSpawnIcon = vgui.Create("SpawnIcon")
		local spic = MoarPanelsSpawnIcon
		spic:SetSize(64, 64)
		spic:SetAlpha(1)
	end

	return MoarPanelsSpawnIcon
end

local szs = {64, 128, 256, 512}

local upscale = function(w, h)
	for i=1, #szs do
		if w < szs[i] then
			w = szs[i]
		end

		if h < szs[i] then
			h = szs[i]
		end
	end

	w, h = math.min(w, 512), math.min(h, 512)

	return w, h
end

function draw.DrawOrRender(pnl, mdl, x, y, w, h)

	local icname = mdl

	icname = icname:gsub("%.mdl", "")

	if not icname:find("%.png") then
		icname = icname .. ".png"
	end

	if not mdls[mdl] then

		mdls[mdl] = Material("spawnicons/" .. icname)

		if mdls[mdl]:IsError() then
			local spic = GetSpawnIcon()

			spic:SetSize(upscale(w, h))
			spic:SetModel(mdl)
			spic:RebuildSpawnIcon()
			mdls[mdl] = true

			hook.Add("SpawniconGenerated", mdl, function(mdl2, ic, amt)
				if mdl == mdl2 then hook.Remove("SpawniconGenerated", mdl2) end
				--mdls[mdl] = Material(ic)
				if amt == 1 then spic:Remove() end
			end)
			return
		end

		draw.DrawLoading(pnl, x + w/2, y + h/2, w, h)
	elseif isbool(mdls[mdl]) then
		draw.DrawLoading(pnl, x + w/2, y + h/2, w, h)
		return
	end

	surface_SetMaterial(mdls[mdl])
	surface_DrawTexturedRect(x, y, w, h)

end

--[[
	GIF header (tailer? it's last):
		2 bytes: first frame delay time (in centiseconds)
		2 bytes: amt of frames

		2 bytes: max width in the gif
		2 bytes: max height in the gif

	i swapped them to little byte order so i don't think i need to rotate anymore
]]
local function ParseGIF(fn, realname)

	local f = file.Open(fn, "rb", "GAME")

	local info = {}

	local fs = f:Size()
	f:Seek(fs - 2)

	local hdsize = f:ReadUShort()
	--hdsize = bit.ror(hdsize, 8)

	if hdsize > 512 then --ridiculous header size = gg
		errorf("GIF %s broke as hell; header size is apparently '%d'", realname, hdsize)
		return
	end

	f:Skip(-hdsize - 2)

	local where = f:Tell()

	f:Seek(0)

	local gifdata = f:Read(where)


	local time = f:ReadUShort()
	info[1] = time

	local fr_amt = f:ReadUShort()

	local fr_wid, fr_hgt = f:ReadUShort(), f:ReadUShort()


	info.wid, info.hgt = fr_wid, fr_hgt

	info.amt = fr_amt


	local left = hdsize - 8	--8 bytes were already read

	while left > 0 do

		local frame = f:ReadUShort()
		local time = f:ReadUShort()

		info[frame] = time

		left = left - 4
	end

	if left ~= 0 then
		ErrorNoHalt("GIF's header parsed incorrectly! Name: " .. name .. ", left bytes: " .. left .. "\n")
	end

	f:Close()

	return info, gifdata
end

draw.ParseGIF = ParseGIF

local function ParseGIFInfo(_, name, info)

	local path = "hdl/%s"

	local tbl = {}

	local cmat = Material("data/" .. path:format(name):lower()  .. ".png", "smooth ignorez")

	tbl.mat = cmat

	tbl.w = cmat:Width()
	tbl.h = cmat:Height()
	tbl.i = info

	tbl.frw = info.wid
	tbl.frh = info.hgt

	local dur = 0
	local time = 0

	local fulltimes = {}
	local timings = {}

	for i=1, info.amt do

		if info[i] then time = info[i] end

		dur = dur + time

		fulltimes[i] = time
		timings[i] = dur

	end

	tbl.dur = dur / 100 --centiseconds
	tbl.times = fulltimes
	tbl.timings = timings

	return tbl
end

function DownloadGIF(url, name)
	if url == "-" or name == "-" then return false end

	local path = "hdl/%s"

	local mat = MoarPanelsMats[name]
	if not name then ErrorNoHalt("DownloadGIF: No name!\n") return end

	if not mat or (mat.failed and mat.failed ~= url) then
		MoarPanelsMats[name] = {}

		local gifpath = path:format(name)

		if file.Exists(gifpath .. ".png", "DATA") then

			local info = file.Read(gifpath .. "_info.dat", "DATA")
			info = util.JSONToTable(info)

			local tbl = ParseGIFInfo(path, name, info)	--ParseGIFInfo creates a table with this structure:
														--[[
															mat = IMaterial

															w = mat:Width()
															h = mat:Height()
															i = info

															frw = info.wid
															frh = info.hgt

															dur = full duration in centiseconds
															times = {}   - times since beginning for each frame
															timings = {} - duration of each frame

															---

															we'll just merge it into MoarPanelsMats
														]]
			table.Merge(MoarPanelsMats[name], tbl)


			mat = MoarPanelsMats[name]

		else

			MoarPanelsMats[name].downloading = true

			hdl.DownloadFile(url, ("temp_gif%s.dat"):format(name), function(fn, body)
				if body:find("404 %-") then errorf("404'd while attempting to download %q", name) return end
				local bytes = {}

				local chunk = body:sub(#body - 20, #body)

				for s in chunk:gmatch(".") do
					bytes[#bytes + 1] = bit.tohex(string.byte(s)):sub(7)
				end

				local info, gifdata = draw.ParseGIF(fn, name)

				local gif_file = file.Open(path:format(name) .. ".png", "wb", "DATA")

				gif_file:Write(gifdata)
				gif_file:Close()

				file.Write(path:format(name .. "_info")  .. ".dat", util.TableToJSON(info))

				file.Delete(("hdl/temp_gif%s.dat"):format(name))

				MoarPanelsMats[name].downloading = false

				local tbl = ParseGIFInfo(path, name, info)

				tbl.fromurl = url
				MoarPanelsMats[name] = tbl

			end, function(...)
				errorf("Failed to download! URL: %s\n Error: %s", url, err)
				MoarPanelsMats[name] = false
			end, true)

		end


	elseif mat and mat.failed then
		return false
	end

	return MoarPanelsMats[name]
end

function surface.DrawNewlined(tx, x, y, first_x, first_y)
	local i = 0
	local _, th = surface_GetTextSize(tx:gsub("\n", ""))

	for s in tx:gmatch("[^\n]+") do
		surface_SetTextPos(first_x or x, (first_y or y) + i*th)
		surface_DrawText(s)
		i = i + 1

		first_x, first_y = nil, nil
	end

end

function draw.DrawGIF(url, name, x, y, dw, dh, frw, frh, start, frametime, pnl)
	local mat = DownloadGIF(url, name)
	if not mat then return end

	if mat and (not mat.mat or mat.downloading or mat.mat:IsError()) then
		if mat.mat and mat.mat:IsError() and not mat.downloading then
			surface_SetMaterial(bad)
			surface_DrawTexturedRect(x, y, dw, dh)
		else
			draw.DrawLoading(pnl, x + dw/2, y + dh/2, dw, dh)
		end
		return
	end

	surface_SetMaterial(mat.mat)
	local w, h = mat.w, mat.h

	frw = frw or mat.frw
	frh = frh or mat.frh

	if not start then start = 0 end
	local ct = CurTime()

	local dur = (frametime and frametime * mat.i.amt / 100) or mat.dur
	local t = ((ct - start) % dur) * 100

	local frame = 0

	if frametime then --we were given frame time to use
		frame = math.floor(t / frametime)
	else
		for i=1, #mat.timings do

			if t < mat.timings[i] then
				frame = i - 1
				break
			end
		end
	end

	local row, col = (frame % 5), math.floor(frame / 5)

	local xpad, ypad = 4, 4

	local xo, yo = xpad, ypad

	local startX = row * frw + row * xo
	local endX = startX + frw

	local startY = col * frh + col * yo
	local endY = startY + frh

	local u1, v1 = startX / (w - 1) , startY / (h - 1)		--before you ask where -1 came from, I DONT KNOW
	local u2, v2 = endX / (w - 1), endY / (h - 1)			--ALL OF THIS JUST WORKS

															--i spent 4 days fixing this and turns out i just needed to sub 1 PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands PepeHands
	surface_DrawTexturedRectUV(x, y, dw, dh, u1, v1, u2, v2)
end

function draw.SimpleText2( text, font, x, y, colour, xalign, yalign )

	text	= tostring( text )
	x		= x			or 0
	y		= y			or 0
	xalign	= xalign	or TEXT_ALIGN_LEFT
	yalign	= yalign	or TEXT_ALIGN_TOP

	if font then surface_SetFont( font ) end

	local w, h

	if xalign ~= TEXT_ALIGN_LEFT or yalign ~= TEXT_ALIGN_TOP then
		w, h = surface_GetTextSize( text )

		if ( xalign == TEXT_ALIGN_CENTER ) then
			x = x - w / 2
		elseif ( xalign == TEXT_ALIGN_RIGHT ) then
			x = x - w
		end

		if ( yalign == TEXT_ALIGN_CENTER ) then
			y = y - h / 2
		elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
			y = y - h
		end
	end

	surface_SetTextPos(x, y)

	if colour then
		surface_SetTextColor(colour.r, colour.g, colour.b, colour.a)
	--else
		--surface_SetTextColor( 255, 255, 255, 255 )
	end

	surface_DrawText(text)

	return w, h

end