local bw = BaseWars.Bases
local nw = bw.NW

local baseCol = color_white:Copy()
local zoneCol = Color(160, 160, 160)

local baseFontH = 48
local zoneFontH = 28

-- because i don't auto-create italic versions of fonts i might as well make one
surface.CreateFont("BW_ZoneItalic", {
	font = "BreezeSans Light",
	size = zoneFontH,
	weight = 400,
	italic = true,
})

local bdt = DeltaText():SetFont("MR" .. baseFontH)
local zdt = DeltaText():SetFont("BW_ZoneItalic")

local deadZoneX, deadZoneY = 8, 16

local baseToID = {
	-- [id] = elem_num
}

local zToID = {
	-- [id] = elem_num
}

local an = Animatable("bases")
an.BaseFrac = 0
an.ZoneFrac = 0

local state = false

local function displayZone(zone)
	local zfragID = zToID[zone:GetID()]

	if not zfragID then
		local piece, key = zdt:AddText(zone:GetName())
		piece.Color = zoneCol
		piece.BWZone = zone:GetID()



		zToID[zone:GetID()] = key
		zfragID = key
	end

	local piece = zdt:ActivateElement(zfragID)

	if not bdt:GetCurrentElement() then
		piece:SetLiftStrength(-18)
	else
		piece:SetLiftStrength(18)
	end
end


local function updateOwner(base, initial)
	local fac, owners = base:GetOwner()

	local piece = bdt:GetElements()[ baseToID[base:GetID()] ]

	local is_owned = fac or owners

	local animTable = {Delay = initial and 0.6 or 0}

	if is_owned then
		if not piece.OwnedByOpenerFragment or not piece.OwnerFragment then
			return
		end

		piece:ReplaceText(piece.OwnedByOpenerFragment, "  (owned by ", nil, nil, animTable)

		if not fac and owners then -- player-owned
			local ply = owners:GetPlayer()
			local name = ply:IsValid() and ply:Nick() or owners:SteamID64()
			local _, new = piece:ReplaceText(piece.OwnerFragment, name, nil, nil, animTable)
			if new then
				new.Font = "MR18"
				new.Color = color_white:Copy()
			end
		else
			local _, new = piece:ReplaceText(piece.OwnerFragment, fac:GetName(), nil, nil, animTable)
			if new then
				new.Color = fac:GetColor():Copy()
			end
		end
	else -- not owned
		piece:ReplaceText(piece.OwnedByOpenerFragment, "  (not owned", nil, nil, animTable)
		piece:ReplaceText(piece.OwnerFragment, "", nil, nil, animTable)
	end

	piece:ReplaceText(piece.OwnedByCloserFragment, ")", nil, nil, animTable)
end

local function appear(base)
	if state then -- we were appearing(-ed) already
		updateOwner(base)
		return
	end

	state = true

	an:Stop()
	local banim, bnew = an:To("BaseFrac", 1, 0.4, 0, 0.3)

	-- activate base
	local bfragID = baseToID[base:GetID()]

	if not bfragID then
		local piece, key = bdt:AddText("")

		local _, frag = piece:AddFragment(base:GetName(), 1, false)

		piece.FragmentTemplate = {
			Font = "OS18",
			AlignY = (0.75 * 2),	-- eek.
			Color = Color(150, 150, 150)
		}

		local owKey, frag = piece:AddFragment("", 2)
			piece.OwnedByOpenerFragment = owKey

		local owKey, frag = piece:AddFragment("", 3)
			piece.OwnerFragment = owKey

		local owKey, frag = piece:AddFragment("", 4)
			piece.OwnedByCloserFragment = owKey
		--piece.Color = baseCol
		baseToID[base:GetID()] = key
		bfragID = key

		updateOwner(base, true)
	end

	local piece = bdt:ActivateElement(bfragID)
end

local function disappear()
	if not state then return end -- we were disappearing already
	state = false

	an:Stop()

	local anim, new = an:To("BaseFrac", 0, 0.25, 0.15, 2)

	local cur = bdt:GetCurrentElement()
	cur:ReplaceText(cur.OwnedByOpenerFragment, "")
	cur:ReplaceText(cur.OwnerFragment, "")
	cur:ReplaceText(cur.OwnedByCloserFragment, "")

	if new then
		anim:Once("Start", "dis", function()
			bdt:DisappearCurrentElement()
		end)
	end


end


local function think()

	local zone = bw.GetZone( nw.PlayerData:Get("CurrentZone") )
	local curElem = zdt:GetCurrentElement()

	if not zone or zone:GetName() == "" then
		zdt:DisappearCurrentElement()
		local zanim, new = an:To("ZoneFrac", 0, 0.3, 0, 0.3)
	else
		local zanim, new = an:To("ZoneFrac", 1, 0.3, 0.2, 0.3)

		if curElem then
			-- zones switched or we reentered a disappearing zone
			displayZone(zone)
		elseif new then
			-- new zone appeared; put us on a delay
			zanim:Once("Start", "a", function()
				if bw.GetZone( nw.PlayerData:Get("CurrentZone") ) then
					displayZone(zone)
				end
			end)
		end
	end
end

local lastBaseName = ""



hook.Add("HUDPaint", "bas", function()
	think()
	local lp = LocalPlayer()
	local base, zone = lp:BW_GetBase(), lp:BW_GetZone()

	if not base then
		disappear()
	else
		appear(base, zone)
	end

	bdt:Paint(deadZoneX, deadZoneY)
	zdt:Paint(deadZoneX + 24, deadZoneY + baseFontH)
end)