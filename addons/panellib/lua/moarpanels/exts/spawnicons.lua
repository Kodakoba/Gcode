--

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