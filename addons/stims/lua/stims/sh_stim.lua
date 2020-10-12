--wah

Stims = Stims or {}
Stims.Bind = Stims.Bind or Bind("stim")
	:SetDefaultKey(KEY_G)
	:SetDefaultMethod(BINDS_HOLD)

Stims.Active = {}	   						-- stores [ply] = { activeStimStats }
Stims.PlayerStims = Stims.PlayerStims or {} -- stores [ply] = { stimStats }

local blank_tbl = {}

function Stims.AddStim(ply, dat)
	dat = dat or Stims.PlayerStims[ply] or blank_tbl

	Stims.Active[ply] = {
		Working = false,		-- is the stimpak healing currently?
		Started = CurTime(),	-- when was the stimpak procced?

		-- delay before the stim actually starts healing
		WorkTime = dat.WorkTime or STIMPAK_WORK_TIME,

		-- delay between the stim stopping to heal and the stim being outta your hand
		DeinjectTime = dat.RemoveTime or STIMPAK_REMOVE_TIME,

		Heal = dat.HealAmount or 50,	-- how much HP the stim will heal
		HealTime = dat.HealTime or 1,	-- how much time will it take to heal

		LastHeal = 0, -- internal
	}

	hook.Run("PlayerUsedStimpak", ply, Stims.Active[ply])
end

function Stims.RemoveStim(ply)
	Stims.Active[ply] = nil
end


function Stims.SetStim(ply, dat)
	Stims.PlayerStims[ply] = dat
end