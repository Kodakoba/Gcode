MoarPanelsMats = MoarPanelsMats or {

}


MoarPanelsMats.gu = Material("vgui/gradient-u")
MoarPanelsMats.gd = Material("vgui/gradient-d")
MoarPanelsMats.gr = Material("vgui/gradient-r")
MoarPanelsMats.gl = Material("vgui/gradient-l")

local spinner = Material("data/hdl/spinner.png")
local cout = Material("data/hdl/circle_outline256.png") --not c++
local cout128 = Material("data/hdl/circle_outline128.png")
local cout64 = Material("data/hdl/circle_outline64.png")
local bad = Material("materials/icon16/cancel.png")

hook.Add("InitPostEntity", "MoarPanels", function()

	local _ = spinner:IsError() and hdl.DownloadFile("https://i.imgur.com/KHvsQ4u.png", "spinner.png", function(fn) spinner = Material(fn) end)

	_ = cout:IsError() and hdl.DownloadFile("https://i.imgur.com/huBY9vo.png", "circle_outline256.png", function(fn) cout = Material(fn) end)
	_ = cout128:IsError() and hdl.DownloadFile("https://i.imgur.com/mLZEMpW.png", "circle_outline128.png", function(fn) cout128 = Material(fn) end)
	_ = cout64:IsError() and hdl.DownloadFile("https://i.imgur.com/kY0Isiz.png", "circle_outline64.png", function(fn) cout64 = Material(fn) end)

end)

local circles = {rev = {}, reg = {}} --reverse and regular

local function BenchPoly(...)	--shh
	surface.DrawPoly(...)
end

local ipairs = ipairs 

local sin = math.sin 
local cos = math.cos
local mrad = math.rad 


local function FetchUpValuePanel()
	return debug.getlocal(3, 1)
end

function draw.LegacyLoading(x, y, w, h)
	local size = math.min(w, h)
	surface.SetMaterial(spinner)
	surface.DrawTexturedRectRotated(x, y, size, size, -(CurTime() * 360) % 360)
end

function draw.DrawLoading(pnl, x, y, w, h)
	local ct = CurTime()
	local sx, sy

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

	end


	w = math.min(w, h)	--smallest square
	h = math.min(w, h)

	
	

	local amt = 3
	local dur = 2 --seconds
	local vm = Matrix()

	surface.DisableClipping(true)

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	for i=1, amt do 
		local off = dur/amt
		local a = ((ct + off * (i-1))%dur)/dur 

		local r = w*a
		local mat = (r > 160 and cout) or (r > 64 and cout128) or (r < 64 and cout64) or cout64

		surface.SetMaterial(mat)

		local vec = Vector(sx, sy)

		vm:Translate(vec)

		vm:SetScale(Vector(a, a, 0))

		vm:Translate(-vec)

		cam.PushModelMatrix(vm)

		pcall(function()
			surface.SetDrawColor(Color(255, 255, 255, (1 - a)*255))
			surface.DrawTexturedRect(x-w/2, y-h/2, w, h)	--i aint gotta explain shit where the 1.05 came from
		end)

		cam.PopModelMatrix(vm)
	end
	surface.DisableClipping(false)
	render.PopFilterMin()
	render.PopFilterMag()
end

--eclipse gave me this V

function draw.DrawSine(x, y, height, length, speed, frequency)
    local time = CurTime()

    local y1 = y

    frequency = frequency or 20

    for x=x, x+length do
        local y = math.sin((x + time * speed) / frequency or 20) * height / 2 + y
        local lastX = x - 5
        local lastY = math.sin((lastX + time * speed) / frequency) * height / 2 + y1
        
        surface.DrawLine(lastX, lastY, x, y)
        
    end
    
end

--eclipse gave me this ^

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

local rbcache = muldim:new()

local function GenerateRBPoly(rad, x, y, w, h, notr, nobr, nobl, notl)


	local deg = 360
	local segdeg = deg/rad/4

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


function draw.RoundedPolyBox(rad, x, y, w, h, col)
	
	--[[
		coords for post-rounded corners
	]]

	surface.SetDrawColor(col)
	draw.NoTexture()

	local cache = rbcache:Get(rad, x, y, w, h)

	if not cache then

		local p = GenerateRBPoly(rad, x, y, w, h)

		rbcache:Set(p, rad, x, y, w, h)
		cache = p
	end

	if not cache then return end 
	BenchPoly(cache)
end

local rbexcache = muldim:new()

function draw.RoundedPolyBoxEx(rad, x, y, w, h, col, notr, nobr, nobl, notl)

	surface.SetDrawColor(col)
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

function draw.RotatedBox(x, y, x2, y2, w)
	local dx, dy = x2 - x, y2 - y

	draw.NoTexture()
	
	local rad = -math.atan2(dy, dx)

	local sin = math.sin(rad)
	local cos = math.cos(rad)

	local poly = {}

		poly[1] = {
			x = x - sin*w,
			y = y - cos*w
		}

		poly[2] = {
			x = x2 - sin*w,
			y = y2 - cos*4,
		}

		poly[3] = {
			x = x2 + sin*w,
			y = y2 + cos*w,
		}

		poly[4] = {
			x = x + sin*w,
			y = y + cos*w,
		}

	surface.DrawPoly(poly)
end

local function GetOrDownload(url, name, flags, cb)	--callback: 1st arg is material, 2nd arg is boolean: was the material loaded from cache?
	if url == "-" or name == "-" then return false end 

	local mat = MoarPanelsMats[name]
	if not name then error("no name! disaster averting") return end

	if not mat or (mat.failed and mat.failed ~= url) then 
		MoarPanelsMats[name] = {}
		local cmat = Material(name, flags or "smooth")
		MoarPanelsMats[name].mat = cmat

		MoarPanelsMats[name].w = cmat:Width()
		MoarPanelsMats[name].h = cmat:Height()

		MoarPanelsMats[name].fromurl = url

		if MoarPanelsMats[name].mat:IsError() or (MoarPanelsMats[name].failed and (MoarPanelsMats[name].failed~=url)) then 
			MoarPanelsMats[name].downloading = true

			hdl.DownloadFile(url, name or "unnamed.dat", function(fn)
				MoarPanelsMats[name].downloading = false 
				local cmat = Material(fn, flags or "smooth")
				MoarPanelsMats[name].mat = cmat

				MoarPanelsMats[name].w = cmat:Width()
				MoarPanelsMats[name].h = cmat:Height()
				if cb then cb(MoarPanelsMats[name].mat, false) end

			end, function(...)
				print("Failed to download! URL:", url, "\nError:", ...)
				MoarPanelsMats[name].mat = Material("materials/icon16/cancel.png")
				MoarPanelsMats[name].failed = url
				MoarPanelsMats[name].downloading = false
			end)

		end
		mat = MoarPanelsMats[name]
	else 
		if cb then cb(MoarPanelsMats[name].mat, true) end
	end

	return mat
end

draw.GetMaterial = GetOrDownload 

draw.Rect = surface.DrawRect
draw.DrawRect = surface.DrawRect 

draw.Color = surface.SetDrawColor 

function surface.DrawMaterial(url, name, x, y, w, h, rot)
	local mat = GetOrDownload(url, name)
	if not mat then return end 

	if mat and (mat.downloading or mat.mat:IsError()) then
		draw.DrawLoading(x + w/2, y + h/2, w, h)
		return
	end

	surface.SetMaterial(mat.mat)
	if rot then 
		surface.DrawTexturedRectRotated(x, y, w, h, rot)
	else 
		surface.DrawTexturedRect(x, y, w, h)
	end

end

function surface.DrawUVMaterial(url, name, x, y, w, h, u1, v1, u2, v2)
	local mat = GetOrDownload(url, name, "noclamp mips smooth")
	if not mat then return end 
	
	if mat and mat.downloading or mat.mat:IsError() then 
		draw.DrawLoading(x + w/2, y + h/2, w, h)
		return
	end

	surface.SetMaterial(mat.mat)
	
	surface.DrawTexturedRectUV(x, y, w, h, u1, v1, u2, v2)

end

surface.PaintMaterial = Deprecated or function() print("surface.PaintMaterial is deprecated", debug.traceback()) end

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

function draw.Masked(mask, op, demask, deop)

	render.SetStencilPassOperation( STENCIL_KEEP )

	render.SetStencilEnable(true)

		render.ClearStencil()
		
		render.SetStencilTestMask(0xFF)
		render.SetStencilWriteMask(0xFF)

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )

		render.SetStencilReferenceValue( 1 ) --include

		mask()

		render.SetStencilReferenceValue( 0 ) --exclude

		if demask then

			demask()

		end

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )

		op()	--actual draw op

		if deop then
			render.SetStencilCompareFunction( STENCIL_EQUAL )

			deop()
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
		RT_SIZE_LITERAL,			--the wiki claims rendertargets change sizes to powers of 2 and clamp it to screen size; lets prevent that
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

function draw.RenderOntoMaterial(name, w, h, func, rtfunc, matfunc, pre_rt, pre_mat)

	local rt
	local mat

	if not RTs[name] then	
		print("new rt!")

		rt = CreateRT(name, w, h)

		mat = CreateMaterial(name, "UnlitGeneric", {
		    ["$translucent"] = 1,
		    ["$vertexalpha"] = 1,

		    ["$alpha"] = 1,
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
			print("new W,H arent equal to old, recreating")
			local id = rtm:Get("Number")
			rtm:Set(id + 1, "Number")

			rt = CreateRT(name .. id, w, h)
			rtm:Set(rt, w, h)
		end

		mats[name] = mats[name] or CreateMaterial(name, "UnlitGeneric", {
		    ["$translucent"] = 1,
		    ["$vertexalpha"] = 1,

		    ["$alpha"] = 1,
		})
		
		mat = mats[name]
	end

	rt = pre_rt or rt 
	mat = pre_mat or mat

	render.PushRenderTarget(rt)

	render.OverrideAlphaWriteEnable(true, true)
		render.Clear(0, 0, 0, 0, true, true)
	render.OverrideAlphaWriteEnable(false, false)

	local sw, sh = ScrW(), ScrH()

	render.SetViewPort(0, 0, w, h)

	surface.DisableClipping(true)

	cam.Start2D()
		local ok, err = pcall(func, w, h)
	cam.End2D()

	surface.DisableClipping(false)

	render.SetViewPort(0, 0, sw, sh)

	if rtfunc and ok then 
		local keep = rtfunc(rt)
		if keep == false then render.PopRenderTarget() return end
	end

	render.PopRenderTarget()

	mat:SetTexture("$basetexture", rt)

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

			spic:SetModel(mdl)
			spic:RebuildSpawnIcon()
			mdls[mdl] = true

			hook.Add("SpawniconGenerated", mdl, function(mdl2, ic, amt)
				if mdl == mdl2 then hook.Remove("SpawniconGenerated", mdl2) end
				--mdls[mdl] = Material(ic)
				if amt == 1 then spic:Remove() end
			end)

		end 

		draw.DrawLoading(pnl, x+w/2, y+h/2, w, h)

		return
	elseif isbool(mdls[mdl]) then 
		draw.DrawLoading(pnl, x+w/2, y+h/2, w, h)
		return
	end

	surface.SetMaterial(mdls[mdl])
	surface.DrawTexturedRect(x, y, w, h)

end

local function ParseGIF(fn)
	local path = "hdl/%s"

	local f = file.Open(fn, "rb", "GAME")

	local info = {}

	local fs = f:Size()
	f:Seek(fs - 2)

	local hdsize = f:ReadUShort()

	print("read hdsize:", hdsize)
	hdsize = bit.ror(hdsize, 16 / 2)
	print("new hdsize:", hdsize)

	f:Skip(-hdsize - 2)

	local where = f:Tell()

	f:Seek(0)

	local gifdata = f:Read(where)

	local left = hdsize - 4

	local time = f:ReadUShort()
	info[1] = bit.ror(time, 16 / 2)

	print('current time:', info[1], time)

	local fr_amt = f:ReadUShort()

	fr_amt = bit.ror(fr_amt, 8)

	info.amt = fr_amt

	print("left is", left)

	while left > 0 do 

		local frame = f:ReadUShort()
		local time = f:ReadUShort()
		
		frame, time = bit.ror(frame, 16 / 2), bit.ror(time, 16 / 2)

		--print("Frame, time:", frame, time)
		info[frame] = time

		left = left - 4
	end

	if left ~= 0 then 
		ErrorNoHalt("GIFS header parsed incorrectly! Name: " .. name .. ", left bytes: " .. left .. "\n")
	end 

	f:Close()

	return info, gifdata
end

local function ParseGIFInfo(path, name, info)

	local path = "hdl/%s"

	local tbl = {}

	local cmat = Material("data/" .. path:format(name):lower()  .. ".png", "smooth")

	tbl.mat = cmat

	tbl.w = cmat:Width()
	tbl.h = cmat:Height()
	tbl.i = info


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
	if not name then error("no name! disaster averting") return end

	if not mat or (mat.failed and mat.failed ~= url) then 
		MoarPanelsMats[name] = {}

		local cmat = Material("data/hdl/" .. name, "smooth")
		MoarPanelsMats[name].mat = cmat

		MoarPanelsMats[name].w = cmat:Width()
		MoarPanelsMats[name].h = cmat:Height()

		MoarPanelsMats[name].fromurl = url

		if not file.Exists(path:format(name) .. ".png", "DATA") then--MoarPanelsMats[name].mat:IsError() or (MoarPanelsMats[name].failed and (MoarPanelsMats[name].failed~=url)) then 
			MoarPanelsMats[name].downloading = true

			hdl.DownloadFile(url, "temp.dat", function(fn, body)
				if body:find("404 Not Found") then return end

				local info, gifdata = ParseGIF(fn)

				local gif_file = file.Open(path:format(name) .. ".png", "wb", "DATA")

				gif_file:Write(gifdata)
				gif_file:Close()

				file.Write(path:format(name .. "_info")  .. ".dat", util.TableToJSON(info))

				file.Delete("hdl/temp.dat")
				
				MoarPanelsMats[name].downloading = false 

				local tbl = ParseGIFInfo(path, name, info)
				MoarPanelsMats[name] = tbl

			end, function(...)
				print("Failed to download! URL:", url, "\nError:", ...)
				MoarPanelsMats[name] = false
			end, true)

		else 
			local info = file.Read(path:format(name .. "_info.dat"), "DATA")
			info = util.JSONToTable(info)

			local tbl = ParseGIFInfo(path, name, info)
			table.Merge(MoarPanelsMats[name], tbl)
		end

		mat = MoarPanelsMats[name]

	elseif mat and mat.failed then 
		print(mat.failed, url)
	end

	return MoarPanelsMats[name]
end

function draw.DrawGIF(url, name, x, y, dw, dh, frw, frh, start)
	local mat = DownloadGIF(url, name)--GetOrDownload(url, name)
	if not mat then return end 
	
	if mat and mat.downloading or mat.mat:IsError() then 
		if mat.mat:IsError() and not mat.downloading then 
			surface.SetMaterial(bad)
			surface.DrawTexturedRect(x, y, dw, dh)
		else
			draw.DrawLoading(nil, x + dw/2, y + dh/2, dw, dh)
		end
		return
	end

	surface.SetMaterial(mat.mat)
	local w, h, i = mat.w, mat.h, mat.i 

	if not start then start = 0 end 
	local ct = CurTime()

	local t = ((ct - start) % mat.dur) * 100

	local frame = 0

	for i=1, #mat.timings do 

		if t < mat.timings[i] then 
			frame = i - 1
			break 
		end 
	end

	local frames = math.min(mat.i.amt, 5)	--frames on a row
	local totalframes = mat.i.amt 

	local row, col = (frame % 5), math.floor(frame / 5)
	--print("cur frame", row, col)
	local xpad, ypad = 4, 4

	local cols = h/116

	local xo, yo = xpad, ypad


	local u1, v1 = row / frames , col / cols
	local u2, v2 = u1 + 112/w, v1 + (112)/h
	
	surface.DrawTexturedRectUV(x, y, dw, dh, u1, v1, u2, v2)
end