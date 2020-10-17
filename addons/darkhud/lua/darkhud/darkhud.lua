setfenv(1, _G)

DarkHUD = DarkHUD or Emitter:callable()

local dh = DarkHUD

--[[------------------------------]]
--	  		Fonts setup
--[[------------------------------]]

DarkHUD.Fonts = DarkHUD.Fonts or {}

local fonts = DarkHUD.Fonts


--[[------------------------------]]
--	  	Used/not used setup
--[[------------------------------]]

DarkHUD.EverUsed = false

sql.Query("CREATE TABLE IF NOT EXISTS DarkHUD(used TEXT, settings TEXT)")
DarkHUD.Used = DarkHUD.Used or sql.Query("SELECT used FROM DarkHUD")
local used = DarkHUD.Used

if not used then
	used = {}
	sql.Query("INSERT INTO DarkHUD(used, settings) VALUES('[]', '[]')")
end

if used and used[1] and used[1].used then used = util.JSONToTable(used[1].used) end

function DarkHUD.SetUsed(key, val)
	used[key] = val

	local str = SQLStr(util.TableToJSON(used))
	local q = ("UPDATE DarkHUD SET used = %s"):format(str)
	sql.Query(q)
end




--[[------------------------------]]
--	  Scaling & Rescaling setup
--[[------------------------------]]

local scale = 0
DarkHUD.Scale = 0

function DarkHUD.ReScale()
	scale = ScrH() / 1080 * 0.9
	DarkHUD.Scale = scale

	dh.PaddingX = 16 + scale * 36
	dh.PaddingY = 16 + scale * 24

	DarkHUD:Emit("Rescale", scale)

end

DarkHUD.ReScale()

local tex_corner8	= surface.GetTextureID( "gui/corner8" )
local tex_corner16	= surface.GetTextureID( "gui/corner16" )
local tex_corner32	= surface.GetTextureID( "gui/corner32" )

local surface = surface

local function RoundedBoxCorneredSize(bordersize, x, y, w, h, color, btl, btr, bbl, bbr)
	-- the difference is that this has configurable radiuses per-corner

	surface.SetDrawColor( color.r, color.g, color.b, color.a )

	if ( bordersize <= 0 ) then
		surface.DrawRect( x, y, w, h )
		return
	end

	x = math.floor( x )
	y = math.floor( y )
	w = math.floor( w )
	h = math.floor( h )
	bordersize = math.min( math.floor( bordersize ), math.floor( w / 2 ) )

	-- Draw as much of the rect as we can without textures
	surface.DrawRect( x + bordersize, y, w - bordersize * 2, h )
	surface.DrawRect( x, y + bordersize, bordersize, h - bordersize * 2 )
	surface.DrawRect( x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2 )

	local tex = tex_corner8
	if ( bordersize > 8 ) then tex = tex_corner16 end
	if ( bordersize > 16 ) then tex = tex_corner32 end

	surface.SetTexture( tex )

	if btl and btl > 0 then
		surface.DrawTexturedRectUV( x, y, btl, btl, 0, 0, 1, 1 )
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end

	if btr and btr > 0 then
		surface.DrawTexturedRectUV( x + w - bordersize, y, btr, btr, 1, 0, 0, 1 )
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end

	if bbl and bbl > 0 then
		surface.DrawTexturedRectUV( x, y + h - bbl, bbl, bbl, 0, 1, 1, 0 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end

	if bbr and bbr > 0 then
		surface.DrawTexturedRectUV( x + w - bordersize, y + h - bbr, bbr, bbr, 1, 1, 0, 0 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end
end

DarkHUD.RoundedBoxCorneredSize = RoundedBoxCorneredSize

hook.Add("OnScreenSizeChanged", "DarkHUD_Scale", DarkHUD.ReScale)


--[[------------------------------]]
--	    Setup: include files
--[[------------------------------]]

hook.Add("InitPostEntity", "HUDCreate", function()
	DarkHUD:Emit("Ready")
end)
