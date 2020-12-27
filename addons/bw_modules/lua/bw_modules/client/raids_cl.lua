local PLAYER = debug.getregistry().Player

Raids = Raids or {}

local raid = Raids

raid.Cooldowns = raid.Cooldowns or {}
raid.OngoingRaids = raid.OngoingRaids or {}

RaidCoolDown = 900 --15 min
RaidDuration = 360 --6 min



local function Valid()
	return Raids.Frame and IsValid(Raids.Frame)
end

function Raids.CallRaid(what, fac)
	local pr

	if fac then
		pr = net.StartPromise("Raid")
			net.WriteUInt(2, 4) --fac vs fac
			net.WriteUInt(IsFaction(what) and what:GetID() or what, 24)
		net.SendToServer()
	else
		if not IsPlayer(what) then return end
		pr = net.StartPromise("Raid")
			net.WriteUInt(1, 4) --ply vs ply
			net.WriteEntity(what)
		net.SendToServer()
	end

	return pr
end

function PLAYER:RaidedCooldown()
	local left = self:GetNWFloat("RaidCD", 0) - CurTime()
	return left > 0, left
end

function PLAYER:IsRaider() --localplayer's raid only

	if not raid.MyRaid then return false end

	if raid.MyRaid then
		if raid.MyRaid.Raided and (raid.MyRaid.Raided.id == self:Team() or raid.MyRaid.Raided == self) then return false end
		if raid.MyRaid.Raiders and (raid.MyRaid.Raiders.id == self:Team() or raid.MyRaid.Raiders == self) then return true end
		return false --?
	else
		return false
	end
end

function PLAYER:IsEnemy()

	if not raid.MyRaid then return false end
	--1 = raider
	--2 = raided
	local am = 0
	local is = 0
	local my = raid.MyRaid
	if my.VSFac then
		if my.Raided and my.Raided.id == self:Team() then is = 2 am = 1 end
		if my.Raiders and my.Raiders.id == self:Team() then is = 1 am = 2 end
	else
		if my.Raided and my.Raided == LocalPlayer() then am = 2 is = 1 end
		if my.Raiders and my.Raiders == LocalPlayer() then am = 1 is = 2 end
	end

	local err = (am==0 or is==0) --not even a part of the raid

	if err then return false end


	return am ~= is

end

function PLAYER:IsRaidable()
	local can, err = raid.CanGenerallyRaid(self, true)
	if can == false then
		return can, err
	end

	can, err = raid.CanRaidPlayer(LocalPlayer(), self)
	if can == false then
		return can, err
	end

	return true
end

net.Receive("Raid", function()
	local rep, ok = net.ReadPromise()
	if ok == false then return end

	local mode = net.ReadUInt(4)
	--1 = start ply vs ply
	--2 = start fac vs fac
	--3 = end
	--4 = err
	print("received raid cl,", mode)
	if mode == 1 then
		local rder = net.ReadUInt(24)
		local rded = net.ReadUInt(24)

		local start = net.ReadFloat()
		local id = net.ReadUInt(16)

		local r = {}

		r.VSFac = false

		if IsPlayer(Player(rder)) then rder = Player(rder) end
		if IsPlayer(Player(rded)) then rded = Player(rded) end --see factions_cl for why

		r.Raiders = rder
		r.Raided = rded

		r.Start = start
		print('received ply vs ply', rder, rded)
		r.PartOf = (rder == LocalPlayer()) or (rded == LocalPlayer())
		print(rder, rded, r.PartOf)
		if r.PartOf then raid.MyRaid = r end

		raid.OngoingRaids[id] = r

		CreateRaidButton(id, r)

		hook.Run("OnRaid", true, false, rder, rded)

		return
	elseif mode == 2 then
		local rder = net.ReadUInt(24)
		local rded = net.ReadUInt(24)

		local start = net.ReadFloat()
		local id = net.ReadUInt(16)

		local r = {}

		r.VSFac = true

		local rderfac = Factions.FactionIDs[rder]
		local rdedfac = Factions.FactionIDs[rded]

		r.Raiders = rderfac
		r.Raided =  rdedfac

		r.Start = start

		local partof = LocalPlayer():InFaction(rderfac.id) or LocalPlayer():InFaction(rdedfac.id)
		print('received fac vs fac', rder, rded)
		r.PartOf = partof

		if r.PartOf then raid.MyRaid = r end

		raid.OngoingRaids[id] = r

		CreateRaidButton(id, r)

		hook.Run("OnRaid", true, true, rder, rded)

		return
	elseif mode==3 then

		local id = net.ReadUInt(16)
		print("Sweet louiseana", id)

		if raid.MyRaid == raid.OngoingRaids[id] then raid.MyRaid = nil end
		raid.OngoingRaids[id] = nil

		if Valid() and Raids.Frame.Raids[id] and IsValid(Raids.Frame.Raids[id]) then
			Raids.Frame.Raids[id]:PopOut()
			Raids.Frame.Raids[id] = nil
		end

		hook.Run("OnRaidStop", id)

		return
	elseif mode==4 then
		print("running onRaid")
		hook.Run("OnRaid", false, net.ReadString())
	end


end)

local wasopen = false

function CreateRaidFrame(noanim)

	local f
	if IsValid(Raids.Frame) then return end

	if IsValid(g_ContextMenu) then
		f = vgui.Create("FFrame", g_ContextMenu)
	else
		return
	end

	if not f then return false end --?


	local sw = ScrW()
	local sh = ScrH()

	local scale = sw / 1920

	f:SetSize(scale*600, 192)

	f:SetPos(ScrW()/2 - scale*300, 36)

	f.Label = "Raids"
	if not noanim then
		f:PopIn(0.1, 1, function(_,s)
			s:PopOut(nil, 2, function() end)
		end)
	end

	f.scr = vgui.Create("FScrollPanel", f)
	f.scr:Dock(FILL)

	f.Raids = {}

	if noanim then
		f:SetAlpha(0)
	else
		timer.Simple(1.5, function()
			if IsValid(f) and not wasopen then
				f:PopOut(nil, nil, function() end) --dont remove
			end
		end)
	end

	Raids.Frame = f
	function Raids.Frame:PostPaint(w,h)

	end

	return f
end
function CreateRaidButton(id, v)
	local scale = ScrW()/1920
	if not Valid() then CreateRaidFrame(true):SetAlpha(0) end

	if Valid() and not Raids.Frame.Raids[id] and Raids.Frame.scr then
		print('created button')
		local f = vgui.Create("FButton", Raids.Frame.scr )
		f:Dock(TOP)
		f:DockMargin(16, 8, 16, 8)



		f.DrawShadow = false

		f.VSFac = v.VSFac
		f:SetTall((v.VSFac and 48) or 32)
		f.Raiders = v.Raiders
		f.Raided = v.Raided

		f.Start = v.Start
		f.PartOf = v.PartOf

		f.Font = "TW18"
		if raid.MyRaid and raid.MyRaid.Panel and IsValid(raid.MyRaid.Panel) then raid.MyRaid.Panel:Remove() raid.MyRaid.Panel = nil end
		if f.PartOf then
			f:Dock(NODOCK)
			f:SetParent(vgui.GetWorldPanel())

			f:SetPos(2, 24)
			f:SetSize(scale * 800, 50)
			f:CenterHorizontal()
			f.Font = "OSB32"
			raid.MyRaid.Panel = f
		end
		local lkname1 = ""
		local lkname2 = ""

		function f:PostPaint(w, h)
			local frac = (RaidDuration - (CurTime() - f.Start))/RaidDuration

			if frac <= 0.01 or not raid.MyRaid then
				self:PopOut()
				if Valid() then Raids.Frame.Raids[id] = nil end
				if f.PartOf and raid.MyRaid and raid.MyRaid.Panel == self then raid.MyRaid.Panel = nil end
			end

			local col = (self.PartOf and Color(50, 150, 250)) or Color(40, 90, 120)

			local t = math.max(math.Round(RaidDuration - (CurTime() - f.Start), 1), 0)

			if (v.VSFac and v.Raiders.name) or IsPlayer(v.Raiders) then
				lkname1 = (v.VSFac and v.Raiders.name) or (v.Raiders.Nick and v.Raiders:Nick()) or "???"
			end

			if (v.VSFac and v.Raided.name) or IsPlayer(v.Raided) then
				lkname2 = (v.VSFac and v.Raided.name) or (v.Raided.Nick and v.Raided:Nick()) or "???"
			end

			local name1, name2 = lkname1, lkname2

			if utf8.len(name1) > 16 then
				name1 = name1:sub(1, 14) .. ".."
			end

			if utf8.len(name2) > 16 then
				name2 = name2:sub(1, 14) .. ".."
			end

			draw.RoundedBox(8, 0, 0, w*frac, h, col)
			draw.SimpleText(name1, "OS24", 8, h/2, color_white, 0, 1)
			draw.SimpleText(name2, "OS24", w - 8, h/2, color_white, 2, 1)

			draw.SimpleText(t .. "s. remaining", self.Font, w/2, h/2, color_white, 1, 1)

		end

		Raids.Frame.Raids[id] = f
	end

end


hook.Add("CalcView", "RaidOnLoad", function()
	CreateRaidFrame()

	for id,v in pairs(raid.OngoingRaids) do
		CreateRaidButton(id, v)
	end

	hook.Remove("CalcView", "RaidOnLoad")
end)


hook.Add("OnContextMenuOpen", "RaidOpen", function()
	if not IsValid(Raids.Frame) then CreateRaidFrame(true) end

	wasopen = true

	Raids.Frame:PopIn(nil, nil, function(_,s) if not Raids.Frame.PoppingOut and IsValid(s) then s:MakePopup() s:SetKeyBoardInputEnabled(false) else print('no') end end)
	Raids.Frame.PoppingOut = false
end)

hook.Add("OnContextMenuClose", "RaidClose", function()
	if not IsValid(Raids.Frame) then return end

	Raids.Frame.PoppingOut = true

	Raids.Frame:SetKeyBoardInputEnabled(false)
	Raids.Frame:SetMouseInputEnabled(false)

	Raids.Frame:PopOut(nil, nil, function() end)

end)