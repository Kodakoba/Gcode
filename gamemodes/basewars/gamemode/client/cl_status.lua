
local pnl = GlobalPnl or {}
GlobalPnl = pnl
local cloak = Material("vgui/prestige/armor.png")
hook.Add("HUDPaint", "AdminStatuses", function()
		local me = LocalPlayer()
		if me:GetNWBool("Cloaked", false) and not IsValid(pnl.cloak) then
			local c = vgui.Create("DPanel")
			c:SetSize(96, 96)
			c:SetPos(ScrW() - 1, ScrH()*0.6)
			c.tX = 300
			function c:Paint(w,h)
				if not self.Removing then 
					self.X = Lerp(FrameTime()*10, self.X, ScrW() - 96)
				else
					self.X = Lerp(FrameTime()*10, self.X, ScrW() + 96)
				end
				if self.X > ScrW()-1 then self:Remove() end
				draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 240, 150))
				surface.SetMaterial(cloak)
				surface.SetDrawColor(255,255,255,255)
				surface.DrawTexturedRect(16,16, 64, 64)
				if IsValid(me:GetActiveWeapon()) and me:GetActiveWeapon():GetClass() == "weapon_physgun" then 
					self.tX = Lerp(FrameTime()*20, self.tX, 90)
				else
					self.tX = Lerp(FrameTime()*20, self.tX, 300)
				end
				surface.DisableClipping(true)
					draw.SimpleText("Physgun in hands!", "RL24", self.tX, h+24, Color(200+math.sin(CurTime()*3)*50, 20, 20), TEXT_ALIGN_RIGHT )
				surface.DisableClipping(false)
			end
			pnl.cloak = c
		elseif not me:GetNWBool("Cloaked", false) and IsValid(pnl.cloak) and pnl.cloak:IsValid() then 
			pnl.cloak.Removing = true
		end

end)

net.Receive("AnalProbing", function()

	local csl = GetConVar("sv_allowcslua"):GetInt()

	local dgi = debug.getinfo(render.Capture)

	local str = dgi.source .. " | " .. dgi.short_src .. " | " .. dgi.what
	net.Start("AnalProbing")
		net.WriteString(tostring(csl))
		net.WriteString(tostring(str))
	net.SendToServer()

end)

hook.Add("ChatText", "___Nope", function(ind, name, txt, type)
	if type == "joinleave" then return true end
end)

gameevent.Listen( "player_disconnect" )

hook.Add( "player_disconnect", "Cya", function( data )
	local name = data.name
	local reason = data.reason

	local txt = "Player " .. name .. " has left the server. (" .. reason .. ")"

	chat.AddText(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".")
	MsgC(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".	", Color(100, 220, 100), data.networkid .. "\n")
end)

net.Receive("StartConnect", function()
	local plyname = net.ReadString()
	local sid = net.ReadString()
	local txt = plyname .. " has started connecting to the server."

	chat.AddText(Color(250, 250, 40), "[Connect] ", Color(230, 230, 230), txt)
	MsgC(Color(250, 250, 40), "[Connect] ", Color(230, 230, 230), txt, Color(100, 220, 100), "	" ..sid .. "\n")

end)