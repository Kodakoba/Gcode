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

local bad = Material("materials/icon16/cancel.png")

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