HDN = HDN or {}

FInc.Recursive("hitnums/*.lua", _SH, FInc.RealmResolver())

local 	st = Settings.Create("hdn_enable", "bool")
			:SetDefaultValue(false)
			:SetCategory("HUD")
			:SetName("Enable experimental new damage indicators")

HDN.EnableSetting = st