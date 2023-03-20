local mia, mitty

hook.Add("ChatHUDEmotesUpdated", "mittymeme", function(col)
	mia = col.MadeInAbyss
	if not mia then return end

	mitty = mia:GetEmotes().MittyElevator
	if not mitty then return end

	if mitty then
		mitty:Download()

		local where = Vector (-7823.2, -8613.3, -1293.35)
		local viswhere = Vector (-7811, -8618.03125, -1306.9388427734)

		local ang = Angle(-180, -90, 180)
		local scale = Vector(0.3, 0.3, 0.3)

		local dec = Memes.AddDecal("mitty", where, ang, scale, Vector(0, -1, 0))
		dec:SetRTPaint(function(w, h)
			if not mitty:Exists() or (mitty:Exists() and mitty:IsDownloading()) then return true end --need downloading

			surface.SetDrawColor(color_white)
			mitty:Paint(0, 0, 128, 128)
		end)

		dec:SetRTUpdate(false)
		dec:SetPixPos(viswhere)
	end


end)

do
	local stuck_where = Vector (-820.6, 44.415222167969, 485)

	--Vector (-825.44427490234, 46.31368637085, 470.28253173828)
	local stuck_ang = Angle(0, -111.6, 0)
	local scale = Vector(0.2, 0.2, 0.2)

	Memes.AddDecal("stuck", stuck_where, stuck_ang, scale, Vector(0.5, 1, 0), nil,
		function(w, h)
			draw.RoundedBox(16, 0, 0, w, h, ColorAlpha(Colors.DarkGray, 240))
			draw.SimpleText("Getting stuck is PROHIBITED.", "MR72", w/2, 0, Colors.Red, 1, 0)
			draw.SimpleText("If you are stuck, CEASE IMMEDIATELY.", "MR48", w/2, 72, Colors.Red, 1, 0)
		end,
	false, stuck_where + stuck_ang:Right() * 128 * 0.2, 20, 256, 32, 1024, 128)
end

local function addMaN(ffz)
	local man = ffz:GetEmotes().MaN

	if man then
		man:Download()

		local where = Vector (3128.03, 5761.3, 166)
		local ang = Angle (180, 0, 180)
		local scale = Vector(0.05, 0.05, 0.05)

		Memes.AddDecal("pillarMaN", where, ang, scale, Vector(1, 0, 0), nil,
			function(w, h)
				if not man:Exists() or (man:Exists() and man:IsDownloading()) then return true end
				surface.SetDrawColor(color_white)
				man:Paint(0, 0, 128, 128)
			end,
		false, where, 8, nil, nil, nil, nil, 10)
	end
end

hook.Add("ChatHUDFFZUpdated", "manmeme", addMaN)

if Emotes and Emotes.Collections.FFZ then
	addMaN(Emotes.Collections.FFZ)
end


do
	local pos = Vector(11995, 2069, 208.4)
	local ang = Angle(193, -15, 180)
	local scale = 0.2
	local normal = -ang:Forward()
	local col = color_white

	local url = "http://vaati.net/Gachi/shared/cerber_1.png"

	local rt = function(w, h)
	    surface.SetDrawColor(col)
	    draw.DrawGIF(url, "cerber", 0, 0, w, h, nil, nil, nil, 7)
	end

	local dec = Memes.AddDecal("cerberus", pos, ang, scale, normal)

	dec:SetColor(col)
	dec:SetRTPaint(rt)
	dec:SetRTUpdate(true)
	dec:SetPixPos(viswhere)
	dec:SetLight(4)
end

do
	local pos = Vector (-7220.75390625, -4795.423828125, 173.40898132324)
	local ang = Angle(0.54, -180.38, 0)
	local scale = 0.2
	local normal = -ang:Forward()
	local col = color_white


	local url = "https://i.imgur.com/nsUQcic.png"

	local rt = function(w, h)
	    surface.SetDrawColor(col)
	    local ret = surface.DrawMaterial(url, "jermy_clrkson.png", 0, 0, w, h)
	    if not ret then return false end
	end

	local dec = Memes.AddDecal("kfc_man", pos, ang, scale, normal)

	dec:SetColor(col)
	dec:SetRTPaint(rt)
	dec:SetRTUpdate(false)
	dec:SetPixPos(viswhere)
	dec:SetLight(4)
	dec:SetMeshW(128)
	dec:SetMeshH(256)
	dec:SetRtW(128)
	dec:SetRtH(256)
	dec:On("CheckVis", "lmao", function(self, vis)
		render.DrawWireframeSphere(self.PixPos, 16, 16, 16, color_white, false)
	end)
end