local scale = 0.85
local hsc = 0.85

DarkHUD = DarkHUD or {}
local wasvalid = false

local render = render
local surface = surface

if DarkHUD.Essentials then DarkHUD.Essentials:Remove() DarkHUD.Essentials = nil wasvalid = true end

DarkHUD.EverUsed = false

sql.Query("CREATE TABLE IF NOT EXISTS DarkHUD(used TEXT, settings TEXT)")
DarkHUD.Used = DarkHUD.Used or sql.Query("SELECT used FROM DarkHUD")
local used = DarkHUD.Used

if not used then used = {} sql.Query("INSERT INTO DarkHUD(used, settings) VALUES('[]', '[]')") end
if used and used[1] and used[1].used then used = util.JSONToTable(used[1].used) end

function DarkHUD.SetUsed(key, val)
	used[key] = val

	local str = SQLStr(util.TableToJSON(used))
	local q = ("UPDATE DarkHUD SET used = %s"):format(str)
	sql.Query(q)
end


local dh = DarkHUD

dh.PaddingX = scale * 64
dh.PaddingY = hsc * 48

local tex_corner8	= surface.GetTextureID( "gui/corner8" )
local tex_corner16	= surface.GetTextureID( "gui/corner16" )
local tex_corner32	= surface.GetTextureID( "gui/corner32" )
local tex_corner64	= surface.GetTextureID( "gui/corner64" )
local tex_corner512	= surface.GetTextureID( "gui/corner512" )

function draw.RoundedBoxExEx( bordersize, x, y, w, h, color, btl, btr, bbl, bbr )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )

	-- Do not waste performance if they don't want rounded corners
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
	if ( bordersize > 32 ) then tex = tex_corner64 end
	if ( bordersize > 64 ) then tex = tex_corner512 end

	surface.SetTexture( tex )

	if ( btl ) then
		surface.DrawTexturedRectUV( x, y, btl, btl, 0, 0, 1, 1 )
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end

	if ( btr ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y, btr, btr, 1, 0, 0, 1 )
		surface.DrawRect(x + w - bordersize, y + btr, btr, h-btr*2)
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end

	if ( bbl ) then
		surface.DrawTexturedRectUV( x, y + h - bbl, bbl, bbl, 0, 1, 1, 0 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end

	if ( bbr ) then
		surface.DrawTexturedRectUV( x + w - bordersize, y + h - bbr, bbr, bbr, 1, 1, 0, 0 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end


end

surface.CreateFont("FactionFont", {
    font = "Open Sans",
    size = 24,
    weight = 200
})

local padx, pady = dh.PaddingX, dh.PaddingY

function DarkHUD.Create()
	if DarkHUD.Essentials then DarkHUD.Essentials:Remove() DarkHUD.Essentials = nil end
	DarkHUD.Essentials = vgui.Create("FFrame")

	local f = DarkHUD.Essentials
	if not IsValid(f) then return false end --?
	f:SetPaintedManually(true)
	f.HeaderSize = 24

	local hs = f.HeaderSize


	f:SetSize(scale*500, hsc*200)
	local fw, fh = f:GetSize()

	f:SetPos(padx, ScrH() - fh - pady)
	f:SetCloseable(false, true)

	f.BackgroundColor.a = 255
	f.HeaderColor.a = 255

	f.Vitals = vgui.Create("InvisFrame", f)

	local vls = f.Vitals

	vls:SetSize(f:GetWide(), f:GetTall() - hs)
	vls:SetPos(0, hs)


	f.Economy = vgui.Create("InvisFrame", f)
	local ecn = f.Economy

	ecn:SetSize(f:GetWide(), f:GetTall() - hs)
	ecn:SetPos(0, hs)

	ecn:SetAlpha(0)


	local av = vgui.Create("AvatarImage", f)
	f.Avatar = av

	av:SetSize(64, 64)
	av:SetPos(16, hs + 8)
	av:SetPlayer(LocalPlayer(), 128)

	av:SetPaintedManually(true)

	local tcol = Color(100, 100, 100)

	f.Shadow = {spread = 0.8, intensity = 4}

	local hpfr = 0
	local arfr = 0

	local contextopen = false

	local pl, pm, pe = LocalPlayer():GetLevel(), LocalPlayer():GetMoney()

	local PopupLevel = 0
	local PopupMoney = 0

	local pld, pmd, ped = {}, {}, {} --differences

	local mCol = Color(250, 250, 250)
	local lvCol = Color(250, 250, 250)

	local boxcol = Color(50, 50, 50, 253)

	function f:Think()
		local lvl = LocalPlayer():GetLevel()
		local mon = LocalPlayer():GetMoney()

		if pl ~= lvl then
			PopupLevel = CurTime()
			lvCol:Set(Colors.Green)
			pld = {amt = lvl - pl, y = 0, ct = CurTime(), boxcol = boxcol:Copy()}
		end

		if pm ~= mon then
			PopupMoney = CurTime()

			if pm < mon then -- + money
				mCol:Set(Colors.Green)
			else
				mCol:Set(Colors.Red)
			end

			if #pmd < 7 then
				pmd[#pmd+1] = {amt = mon - pm, y = 0, ct = CurTime(), col = mCol:Copy(), boxcol = boxcol:Copy()}
			else
				local cur = pmd[1]

				cur.amt = cur.amt + (mon - pm)
				cur.ct = CurTime()

				if cur.amt < 0 then
					cur.col:Set(red)
				else
					cur.col:Set(green)
				end

			end

		end

		pl, pm, pe = lvl, mon
	end

	local lvX = 0
	local monY = 0

	local helpa = 0

	local mondiffY = 0


	local monYMax = 36
	local monYMin = -10

	local lvYMax = 36
	local lvYMin = 0


	local hintbox = Color(255, 255, 255)
	local lvbox = Color(50, 50, 50)

	function f:PrePaint(w,h)
		local ct = CurTime()

		if ct - PopupLevel < 4 then
			lvY = L(lvY, lvYMax, 8, true)
		else
			lvY = L(lvY, lvYMin, 15)
		end

		if ct - PopupLevel > 0.5 then
			LC(lvCol, color_white, 15)
		end

		if ct - PopupMoney < 4 then
			monY = L(monY, monYMax, 8, true)
		else
			monY = L(monY, monYMin, 15)
		end

		if ct - PopupMoney > 1 then
			LC(mCol, color_white, 15)
		end

		surface.SetDrawColor(255, 255, 255)

		surface.DisableClipping(true)


			if monY > 2 then

				local mtxt = Language.Currency .. BaseWars.NumberFormat(LocalPlayer():GetMoney())

				surface.SetFont("OSB28")
				local mw, mh = surface.GetTextSize(mtxt)

				draw.RoundedBox(6, 12, -monY - lvY, mw + 24 + 24, 32, boxcol)

				surface.SetDrawColor(255, 255, 255)
				surface.DrawMaterial("https://i.imgur.com/8b0nZI7.png", "moneybag.png", 20, 4 - monY - lvY, 25, 24)
				local col = ColorAlpha(mCol, monY * (255/24) )
				draw.SimpleText(mtxt, "OSB28", 48, 4 - monY - lvY, col, 0, 5)

				local i = 0

				for k,v in pairs(pmd) do 	--money popups

					if v.a and v.a > 10 then
						i = i + 1
					end

					local amt = v.amt

					local difftxt = Language.Currency .. BaseWars.NumberFormat(math.abs(amt))

					if amt < 0 then
						difftxt = "-" .. difftxt
					else
						difftxt = "+" .. difftxt
					end

					if monY > monYMax*0.9 then
						v.y = L(v.y, 28 * i, 10)

						if v.ct < CurTime() - 2.5 then
							v.a = L(v.a, 0, 15)
							if v.a <= 0.1 then
								table.remove(pmd, k)
							end
						else
							v.a = L(v.a, 255, 15)
						end

					else
						v.a = L(v.a, 0, 15)
					end


					surface.SetFont("OSB24")
					local tw, th = surface.GetTextSize(difftxt)

					v.boxcol.a = v.a / 1.2
					v.col.a = v.a

					draw.RoundedBox(4, 48 + 4, -monY - lvY - v.y, tw + 8, th, v.boxcol)
					draw.SimpleText(difftxt, "OSB24", 48 + 8,  -monY - lvY - v.y, v.col, 0, 5)
				end

			else
				mondiffY = 0
			end


			if lvY > 2 then
				local lv = tostring(LocalPlayer():GetLevel())
				surface.SetFont("OSB28")
				local mw, mh = surface.GetTextSize(lv)

				lvbox.a = lvY * (255/24)

				draw.RoundedBox(6, 12, -lvY, mw + 24 + 24, 32, lvbox)

				surface.SetDrawColor(255, 255, 255)
				surface.DrawMaterial("https://i.imgur.com/YYXglpb.png", "star.png", 20, 4 - lvY, 24, 24)

				local col = ColorAlpha(lvCol, lvY * (255/24) )
				draw.SimpleText(lv, "OSB28", 48, -lvY + 16, col, 0, 1)
			else
				--mondiffY = 0
			end

			if not used["ContextMenu"] then
				helpa = L(helpa, 255, 10, true)
			else
				helpa = L(helpa, 0, 10, true)
			end
			if helpa > 0 then
				local key = input.LookupBinding("+menu_context") or "UNBOUND"
				local str = ("Hold [%s] to see your money and level."):format(string.upper(key))

				hintbox.a = helpa

				draw.SimpleText(str, "OS24", w/2, -8, hintbox, 1, TEXT_ALIGN_BOTTOM)
			end

		surface.DisableClipping(false)
	end

	local lastfac

	local function faclen(s)
		return (utf8.len(lastfac) > 32 and (string.sub(lastfac, 0, 30) .. "..")) or lastfac
	end


	local facname

	function f:PostPaint(w, h)
		local x, y = av:GetPos()
		local w2, h2 = av:GetSize()

		draw.SimpleText(LocalPlayer():Nick(), "OSB32", x + w2 + 13, y - 4, tcol, 0, 5)

		surface.SetDrawColor(Color(255, 255, 255, 220))
		surface.DrawMaterial("https://i.imgur.com/5BQxS4m.png", "faction.png", x + w2 + 24, y + 32, 24, 24)
		local fac = LocalPlayer():GetFaction()

		if lastfac ~= fac then
			lastfac = fac
			facname = faclen(lastfac)
		end

		draw.SimpleText(facname, "FactionFont", x + w2 + 24 + 20 + 8, y + 32 + 20, Color(255, 255, 255, 20), 0, 4)

		local tm = LocalPlayer():Team()
		local col = (tm~=0 and team.GetColor(tm)) or Color(100, 100, 100)
		tcol = LC(tcol, col, 15)

		render.SetStencilEnable(true)

			render.ClearStencil()
			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )

			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )

			render.SetStencilReferenceValue( 1 ) --include

			surface.SetDrawColor(Color(0, 0, 255, 255))
			draw.NoTexture()
			draw.DrawCircle(x+w2/2, y+h2/2, w2/2, 50)

			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )


			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.SetStencilReferenceValue( 1 ) --include

			av:SetAlpha(255)
			av:PaintManual()

		render.SetStencilEnable(false)

		surface.SetDrawColor(tcol)
		surface.DrawMaterial("https://i.imgur.com/VMZue2h.png", "circle_outline.png", x-3, y-3, w2+6, h2+6)
	end

	function vls:Paint(w, h)

		local x, y = 12, av.Y
		y = y - hs
		local w2, h2 = av:GetSize()

		--self:SetSize(f:GetWide(), f:GetTall() - hs)

		hpfr = L(hpfr, (LocalPlayer():Health()/LocalPlayer():GetMaxHealth()), 15)
		arfr = L(arfr, LocalPlayer():Armor()/100, 15)

		local avx = x + 16 --contains X padding
		local avy = y + 32 + 32 + 18 --contains Y padding


		local sx, sy = self:LocalToScreen(avx, avy)
		local hpw = w - avx*2 - 48
		--[[
			Health & Armor
		]]
		local overheal = false
		local overar = false

		if hpfr > 1 then
			overheal = true
			hpfr = 1
		end

		if arfr > 1 then
			overar = true
			arfr = 1
		end


		--[[
			Health
		]]

			local hpw = w - avx*2 - 48
			local round = (hpw*hpfr > 16 and math.Round(math.Clamp(hpw*hpfr - 8, 0, 8)))

			draw.RoundedBox(8, avx, avy, w - avx*2 - 48, 16, Color(80, 80, 80))

			if not round then
				--draw.RoundedBox(8, avx, avy, hpw, 16, Color(240, 70, 70))
				if hpw*hpfr < 16 then
					render.SetScissorRect(sx, sy, sx+hpw*hpfr, sy+16, true)
						draw.RoundedBoxEx(8, avx, avy, 16, 16, Color(240, 70, 70), true, false, true, false)
					render.SetScissorRect(0, 0, 0, 0, false)
				else

					draw.RoundedBox(8, avx, avy, hpw*hpfr, 16, Color(240, 70, 70))

				end

			elseif round then

				draw.RoundedBoxExEx(8, avx, avy, hpw*hpfr, 16, Color(240, 70, 70), 8, round, 8, round)

			end

			draw.SimpleText(LocalPlayer():Health(), "OS28", w - avx*2 - 8, avy + 6, Color(255, 255, 255), 0, 1)


		--[[
			Armor
		]]

			avy = avy + 24
			local round = (hpw*arfr > 16 and math.Round(math.Clamp(hpw*arfr - 8, 0, 8)))

			draw.RoundedBox(8, avx, avy, w - avx*2 - 48, 16, Color(80, 80, 80))

			if not round then
				if hpw*arfr < 16 then
					render.SetScissorRect(sx, sy, sx+hpw*arfr, sy+16, true)
						draw.RoundedBox(8, avx, avy, 16, 16, Color(40, 120, 255))
					render.SetScissorRect(0, 0, 0, 0, false)
				else

					draw.RoundedBox(8, avx, avy, hpw*arfr, 16, Color(40, 120, 255))

				end

			elseif round then

				draw.RoundedBoxExEx(8, avx, avy, hpw*arfr, 16, Color(40, 120, 255), 8, round, 8, round)

			end

			draw.SimpleText(LocalPlayer():Armor(), "OS28", w - avx*2 - 8, avy + 6, Color(255, 255, 255), 0, 1)

	end

	function ecn:Paint(w,h)
		local x, y = av:GetPos()

		surface.SetDrawColor(255, 255, 255)
		surface.DrawMaterial("https://i.imgur.com/8b0nZI7.png", "moneybag.png", x + 18, y + 48, 25, 24)

		draw.SimpleText(Language.Currency .. BaseWars.NumberFormat(LocalPlayer():GetMoney()), "OS24", x + 50, y + 48 + 12, color_white, 0, 1)

		surface.DrawMaterial("https://i.imgur.com/YYXglpb.png", "star.png", x + 18, y + 80, 24, 24)

		draw.SimpleText(LocalPlayer():GetLevel(), "OS24", x + 50, y + 80 + 12, color_white, 0, 1)


		draw.RoundedBox(8, w - 204, y + 82, 128, 16, Color(75, 75, 75))
		draw.RoundedBox(8, w - 204, y + 82, (128) * (LocalPlayer():GetXP() / LocalPlayer():GetXPNextLevel()), 16, Color(140, 80, 220))
	end

end

hook.Add("InitPostEntity", "HUDCreate", function()
	DarkHUD.Create()
end)

hook.Add("OnContextMenuOpen", "DarkHUD", function()
	local f = DarkHUD.Essentials

	if not IsValid(f) then
		DarkHUD.Create()
		f = DarkHUD.Essentials
		if not IsValid(DarkHUD.Essentials) then return end
	end

	if not used["ContextMenu"] then
		DarkHUD.SetUsed("ContextMenu", 1)
	end

	if IsValid(f.Vitals) and IsValid(f.Economy) then
		f.Vitals:PopOut(nil, nil, function() end)
		f.Economy:PopIn()
	else

	end

end)

hook.Add("OnContextMenuClose", "DarkHUD", function()
	local f = DarkHUD.Essentials
	if not IsValid(f) then return end

	if IsValid(f.Vitals) and IsValid(f.Economy) then
		f.Economy:PopOut(nil, nil, function() end)
		f.Vitals:PopIn()
	else

	end

end)

hook.Add("HUDPaint", "DarkHUD", function()
	local f = DarkHUD.Essentials

	if not IsValid(f) then
		DarkHUD.Create()
		f = DarkHUD.Essentials
		if not IsValid(DarkHUD.Essentials) then return end
	end

	f:PaintManual()

end)
if wasvalid then
	DarkHUD.Create()
end