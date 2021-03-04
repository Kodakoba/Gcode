--
local bw = BaseWars.Bases
bw.BaseView = bw.BaseView or {}

bw.BaseView.Actions = {
	Claim = 0,

}

FInc.FromHere("baseview/bview_*.lua", _SH, true, FInc.RealmResolver():SetDefault(true))
