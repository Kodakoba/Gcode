local bw = BaseWars.Bases
local nw = bw.NW
BaseWars.BaseHUD = hud

bw.HUD = bw.HUD or Emitter()
local hud = bw.HUD

hud.Anims = hud.Anims or Animatable("bases")

include("hud/painter_ext.lua")

hook.Add("HUDPaint", "bas", function()
	local lp = LocalPlayer()
	local base, zone = lp:BW_GetBase(), lp:BW_GetZone()
	hud.DoPainters(base, zone)
end)