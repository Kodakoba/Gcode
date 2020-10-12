--wah

Stims = Stims or {}
Stims.Bind = Stims.Bind or Bind("stim")
	:SetDefaultKey(KEY_G)
	:SetDefaultMethod(BINDS_HOLD)

Stims.Active = {}

local blank_tbl = {}

function Stims.AddStim(ply, dat)
	dat = dat or blank_tbl

	Stims.Active[ply] = {
		Active = true,
		Working = false,
		Started = CurTime(),

		WorkTime = dat.WorkTime or STIMPAK_WORK_TIME,
		DeinjectTime = dat.RemoveTime or STIMPAK_REMOVE_TIME,

		Heal = dat.HealAmount or 50,
		HealTime = dat.HealTime or 1,

		LastHeal = 0,
	}

end

function Stims.RemoveStim(ply)
	Stims.Active[ply] = nil
end