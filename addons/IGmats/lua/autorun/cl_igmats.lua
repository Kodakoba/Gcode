if SERVER then return end

local mats = {
	["spawn"] = Material(""),
	--["perilous"] = Material("")
}
local vecs = {
	["spawn"] = {pos = Vector(428.8, 4526, 442), ang = Angle(0,0,0), size = {w = 1105, h = 575}}
	--["perilous"] = {pos = Vector(69.378227, -621.031250, 110.143677), ang = Angle(0,90,0), size = {w = 1105, h = 575}}
}
IGMatHTML = IGMatHTML or {}
local frames = IGMatHTML
local mat = Material("decals/unknowninfernosdecal")	--cya!
local mat2 = Material("decals/unknowninfernosdecal1")	--cyyyyyya!
local mat3 = Material("advvert")

local met = Material("vgui/prestige/armor.png")


mat:SetTexture("$basetexture", "env/brush/walls/wall_huron_1st")
mat2:SetTexture("$basetexture", "vgui/black")
mat3:SetTexture("$basetexture", "_rt_fullframefb")

local ricardo
local smug 
local wc


hdl.DownloadFile("http://vaati.net/Gachi/shared/smug.png", "smug.png", function(fn) smug = Material(fn) end)
hdl.DownloadFile("https://i.imgur.com/q59nmL2.png", "ricardoFlick.png", function(fn) ricardo = Material(fn) end)
hdl.DownloadFile("http://vaati.net/Gachi/shared/forsenWC2.png", "forsenWC2.png", function(fn) wc = Material(fn) end)

local rows = 1
local cols = 58--26

local oddframes = 2--2	--missing frames at the end

local giffps = 20

local curframe = 0
local rW, rH, frW, frH

if wc then 
	rW, rH = wc:Width(), wc:Height()
	frW, frH = rW/rows, rH/cols --if they're symmetrical, if not; change it manually
end

local curY, curX = 0, 0	--current frame, they change by 1

local lastframe = CurTime()


surface.CreateFont("A64", {

        font = "Arial",
        size = 64,
        weight = 300,

    })

local lastupd = 0
local fps = 30
local ping = 0

local frpassed = 0

local err = Material("__error")
hook.Add("PostDrawOpaqueRenderables", "InGameMats", function(d, sb)


	if not wc then return end 

	if wc and not rW then 
		rW, rH = wc:Width(), wc:Height()
		frW, frH = rW/rows, rH/cols --if they're symmetrical, if not; change it manually
	end

	local ct = CurTime()

	for k,v in pairs(vecs) do

		if LocalPlayer():GetPos():DistToSqr(v.pos) > 9000000 then continue end

		local mat = mats[k] or err
		local pos, ang, size = v.pos, v.ang, 0.2

		local ang2 = Angle(0,0,0)
		ang2:Set(ang)

		ang2:RotateAroundAxis(ang:Right(), 90)
		ang2:RotateAroundAxis(ang:Forward(), 90)

		if not wc or (wc.IsError and wc:IsError()) then 
			surface.SetDrawColor(255,125,125, 255)
			surface.DrawRect(0, 0, v.size.w, v.size.h)
			draw.SimpleText("downloading RICARDO...", "A128", v.size.w/2, 200, Color(0, 0, 0), 1, 1)
		return end

		cam.Start3D2D(pos, ang2, size)

			surface.SetDrawColor(125,125,125, 255)
			surface.DrawRect(0, 0, v.size.w, v.size.h)

			if curX >= rows then 
				curX = 0
				curY = curY+1
			end
			if curY >= cols then 
				curX = 0
				curY = 0
			end
			if curY*rows+curX >= (rows*cols)-oddframes then 
				curX = 0
				curY = 0
			end

			surface.SetMaterial(wc)
			local u1 = (frW*curX)/rW
			local u2 = (frH*curY)/rH

			local v1 = u1 + (frW-1)/rW
			local v2 = u2 + (frH-1)/rH

			u1 = v1 - (frW-2)/rW
			u2 = v2 - (frH-2)/rH

			surface.DrawTexturedRectUV(0, v.size.h - frH*2, frW*2,frH*2, u1, u2, v1, v2)

			local passed = (ct - lastframe) / (1/giffps)
			local f, frac = math.modf(passed)

			if f>=0 then 

				for i=1, f do
					curX = curX+1
					lastframe = ct - (1 / giffps) * frac
					frpassed = frpassed + 1
				end

			end

			if ct - lastupd > 1 then 
				fps = 1 / FrameTime()
				ping = LocalPlayer():Ping()
				lastupd = ct
				frpassed = 0
			end

		cam.End3D2D()
	end

end)