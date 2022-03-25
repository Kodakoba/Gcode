local bw = BaseWars.Bases
bw.HUD = bw.HUD or Emitter()
local hud = bw.HUD

include("hud/base_painter_ext.lua")

hook.Add("HUDPaint", "basePainter", function()
	if not hud.DoPainters then return end

	local lp = LocalPlayer()
	local base, zone = lp:BW_GetBase(), lp:BW_GetZone()
	hud.DoPainters(base, zone)

	local x = math.ceil(ScrW() * 0.03)
	hud:Emit("Paint", x)
end)


local txT = {

}

local anim = Animatable("propcounter")

local text = "Props: %s/%s"

local textData = {
	Filled = color_white,
	Unfilled = color_black,
	Text = text,
	Font = "EXM20",
	FixUp = 0.125 / 4
}

local scale, scaleW = Scaler(1600, 900)

local minSize = surface.GetTextSizeQuick("Props: 999/999", textData.Font) + scaleW(8)
local border = Colors.Sky:Copy():MulHSV(1, 1.2, 0.9)

bw.HUD:On("Paint", 1, function(_, x)
	local y = hud.MaxY or 0
	y = y + 8
	y = math.floor(y)

	local w = minSize
	local h = math.floor(scale(20))
	local wfr = 0.75

	local fullW = math.max(w, hud.CurW)
	local cw = fullW * wfr

	anim:To("X", x + fullW / 2 - cw / 2, 0.3, 0, 0.3)
	anim:To("Width", math.max(cw, w), 0.3, 0, 0.3)

	w = math.floor(anim.Width or w)

	local ax = math.floor(anim.X or x)

	local cnt = CachedLocalPlayer():GetCount("props")

	local cvar = GetConVar("sbox_maxprops")
		cvar = cvar and cvar:GetInt()

	textData.Text = text:format(cnt, cvar or "?WTF?")

	anim:To("FillFr", cnt / (cvar or 1), 0.3, 0, 0.3)

	draw.RoundedBox(4, ax - 1, y - 1, w + 2, h + 2, color_black)
	DarkHUD.PaintBar(4, ax, y, w, h, anim.FillFr or 0,
		Colors.Gray, border, Colors.Sky, textData)

end)
