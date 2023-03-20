do
	local pos = Vector(4409.6293945313, -3619.03125, 200.04418945313)
	local ang = Angle(180, -90, 180)
	local scale = 0.5
	local normal = -ang:Forward()
	local col = color_white

	local stage = 0

	local not_looked = false
	local looked = false
	local looking = false

	local url = "http://vaati.net/Gachi/shared/thicc.png"
	local url2 = "https://i.imgur.com/TRh8Lq6.png"

	local snds = {
		{"https://vaati.net/Gachi/shared/snail1.mp3", 1.2, 2},
		{"https://vaati.net/Gachi/shared/sn2.mp3", 1.2, 2},
		{"https://vaati.net/Gachi/shared/sn3.mp3", 1.6, 2.4},
		{"https://vaati.net/Gachi/shared/sn4.mp3", 0, 0.8},
	}

	for k,v in pairs(snds) do
		hdl.DownloadFile(v[1], "mus/snail_" .. k .. ".dat", print, ErrorNoHalt)
	end

	local ratio = 349 / 893
	local thiccratio = 2048 / 1927
	local numPlay = 1

	local playTime = 0
	local startTime = 0
	local stopTime = 0

	local thicc = false

	local d = Memes.AddDecal("thicc", pos, ang, scale, normal, col, nil, nil, nil, 100, 256, 256, 1024, 1024, 4)

	local rt = function(w, h)
		local lookedFor = looked and CurTime() - looked
		thicc = SysTime() > startTime and SysTime() < stopTime

	    surface.SetDrawColor(col)

	    if not thicc then
	    	local sz = h * ratio
	    	local have = surface.DrawMaterial(url2, "omni.png", w / 2 - sz / 2, 20, sz, h)
	    	if not have then return true end
	    else
	    	playTime = 0
	    	local sc = 0.8
	    	local sz = h / thiccratio
	    	local tw, th = w * sc, sz * sc
	    	local have = surface.DrawMaterial(url, "thiccomni.png", w / 2 - tw / 2, h - th, tw, th)
	    	if not have then return true end
	    end
	    --draw.DrawGIF(url, "cerber", 0, 0, w, h, nil, nil, nil, 7)
	end


	d:SetRTPaint(rt)
	d:SetRTUpdate(true)
	d:On("CheckVis", "lmao", function(self, vis)
		if LocalPlayer():GetPos():DistToSqr(self.PixPos or vector_origin) > 262144 then
			looked = false not_looked = CurTime()
			return
		end

		looking = vis > 0

		if not looking then
			looked = false
			not_looked = not_looked or CurTime()
		else
			not_looked = false
			looked = looked or (vis > 0.2 and CurTime())
		end

		if not looking and CurTime() - not_looked > 5 and playTime == 0 and snds[numPlay] then

			playTime = SysTime()

			sound.PlayFile("data/hdl/mus/snail_" .. numPlay .. ".dat", "noplay 3d", function(ch, eid, en)
				playTime = -1
				if not IsValid(ch) then return end
				ch:Play()
				ch:SetVolume(2)
				ch:SetPos(self.PixPos)
				playTime = SysTime()
				print("numPlay", numPlay)
				startTime = snds[numPlay][2] + playTime
				stopTime = playTime + (snds[numPlay][3] or ch:GetLength())
				numPlay = numPlay + 1
			end)


		end

		if not looking and CurTime() - not_looked > 30 then
			numPlay = 1
		end
	end)
end