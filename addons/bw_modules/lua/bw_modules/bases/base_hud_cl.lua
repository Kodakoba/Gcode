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

local bdt = DeltaText():SetFont("MRM" .. baseFontH)
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

local function appear(base)
	if state then return end -- we were appearing already
	state = true

	an:Stop()
	local banim, bnew = an:To("BaseFrac", 1, 0.4, 0, 0.3)

	-- activate base
	local bfragID = baseToID[base:GetID()]

	if not bfragID then
		local piece, key = bdt:AddText(base:GetName())
		--piece.Color = baseCol
		baseToID[base:GetID()] = key
		bfragID = key
	end

	local piece = bdt:ActivateElement(bfragID)
end

local function disappear()
	if not state then return end -- we were disappearing already
	state = false

	an:Stop()

	local anim, new = an:To("BaseFrac", 0, 0.25, 0.15, 2)

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

	local nw = nw.PlayerData

	if not nw:Get("CurrentBase") then
		disappear()
	else
		local base = bw.GetBase(nw:Get("CurrentBase"))
		if not base then print("Didn't find base with ID", nw:Get("CurrentBase")) disappear() return end

		local zone = bw.GetZone( nw:Get("CurrentZone") )

		appear(base, zone)
	end

	bdt:Paint(deadZoneX, deadZoneY)
	zdt:Paint(deadZoneX + 24, deadZoneY + baseFontH)
end)