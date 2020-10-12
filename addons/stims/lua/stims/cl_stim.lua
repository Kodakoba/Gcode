local function stim(ply)
	return Stims.Active[ply]
end

Stims.Bind:On("Activate", "BeginStim", function(self, ply)
	if not ply:Alive() then return end


	local dat = stim(ply)

	if dat then

		if not dat.Deinjecting then
			-- forcefully end stimpack
			dat.Working = false
			dat.Deinjecting = CurTime()

			VManip.SegmentFinished = true --fuck you
			VManip:PlaySegment("stim_inject_end", true)

			net.Start("ProcStim")
			net.SendToServer()
		end

		return
	end

	local can = VManip:PlayAnim("stim_inject_start")
	if not can then print("can't") return end -- trust the client, YEET

	net.Start("ProcStim")
	net.SendToServer()

	Stims.Active[ply] = {
		Active = true,
		Working = false,
		Started = CurTime(),

		WorkTime = STIMPAK_WORK_TIME,
		DeinjectTime = STIMPAK_REMOVE_TIME,

		Heal = 50,
		HealTime = 1,
		LastHeal = 0,
	}


end)



local function stimDeinject()
	if not CLIENT then return end

	local dat = stim(LocalPlayer())
	VManip.SegmentFinished = true --fuck you
	VManip:PlaySegment("stim_inject_end", true)

	dat.Working = false
	dat.Deinjecting = CurTime()

end

gameevent.Listen("entity_killed")

hook.Add("entity_killed", "StimpakTrack", function(t)
	local victim = Entity(t.entindex_killed)
	if victim ~= LocalPlayer() then return end

	Stims.RemoveStim( victim )
end)

hook.Add("Think", "Stimpak", function()
	local lp = LocalPlayer()
	local t = stim(lp)

	if not t then return end

	if not t.Working then

		if not t.Deinjecting and CurTime() - t.Started > t.WorkTime then
			-- not deinjecting and it's time to start working
			t.Working = true
			t.WorkingTime = CurTime()
		elseif t.Deinjecting and CurTime() - t.Deinjecting > t.DeinjectTime then
			-- deinjecting and it's time to stop completely
			Stims.RemoveStim( lp )
			return
		end

	elseif CurTime() - t.WorkingTime > t.HealTime or lp:Health() >= lp:GetMaxHealth() then
		-- was working and it's time to stop (max hp reached or all heals spent)
		stimDeinject()
	end

end)