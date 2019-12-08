--123
if not peepee then return end 

if IsValid(cumpnl) then cumpnl:Remove() end 

cumpnl = vgui.Create("TabbedFrame")

local f = cumpnl 
f:SetSize(750, 500)
f:Center()
f:MakePopup()
f.Shadow = {}

local tpnls = {}

local gr = Material("vgui/gradient-r")

f:AddTab("Commands", function()
	local p
	if IsValid(tpnls.cmds) then tpnls.cmds:PopIn() p = tpnls.cmds else p = vgui.Create("InvisPanel", f) p:PopIn() end 

	f:AlignPanel(p)

	local cats = CUM.Cats 

	local scr = p.Scroll or vgui.Create("FScrollPanel", p)
	p.Scroll = scr 

	scr:Dock(LEFT)
	scr:SetWide(200)
	scr:DockMargin(0, 40, 0, 0)
	scr.pnlCanvas:DockPadding(8, 8, 8, 8)
	scr.GradBorder = true 
	scr.Buttons = {}

	local srch
	local selpnls = {}

	local function CreateArgsSelection(btn, cmd, par, hasply)
		print("has ply?", hasply)
		if hasply and not selpnls.plys then 
			selpnls.plys = vgui.Create("FScrollPanel", p)
			local plys = selpnls.plys 
			plys:SetPos(scr.X + 200 + 25 + 8 + 32, par.Y)
			plys:MoveBy(-32, 0, 0.3, 0, 0.3)
			plys:SetSize(par:GetSize())
			plys:PopIn()
			plys.GradBorder = true 

			local i = 0

			for k,v in pairs(player.GetAll()) do 

				local b = vgui.Create("FButton", plys)
				i = i + 1 

				b:SetPos(16, -32 + i*40)
				b:SetSize(200 - 32, 32)

				b.Label = v:Nick()
				b:SetColor(Color(85, 85, 85))
			end
		end

	end

	local selcmd

	local function CreateCommandButtons(catcmds, par)

		local i = 0
		 

		for k, cmd in pairs(catcmds) do

			local b = vgui.Create("FButton", par)
			par.Buttons[k] = b 

			i = i + 1 

			b:SetPos(16, -40 + i*48)
			b:SetSize(200 - 32, 40)

			b.Label = k
			b:SetColor(Color(85, 85, 85))

			function b:DoClick()
				local hasply 
				for k,v in pairs(cmd.args) do 
					if v.type == "Player" then hasply = true break end 
				end 

				if hasply then 
					if selcmd == self then 
						par:UnRollBack()
						selcmd = nil
						self:SetColor(Color(85, 85, 85))
					else 
						par:RollBack()
						selcmd = self
						CreateArgsSelection(self, cmd, par, hasply)
						self:SetColor(Color(60, 160, 255))
						for k,v in pairs(par.Buttons) do 
							if v ~= self then 
								v:SetColor(85, 85, 85)
							end
						end
					end
				else 
					par:UnRollBack()
					selcmd = self
					self:SetColor(Color(60, 160, 255))
				end

			end
		end

	end


	local i = 0
	local btnpos = {}
	local cursel
	local cmds 

	local deroll = vgui.Create("DButton", p)

	deroll:SetAlpha(0)
	deroll:SetSize(40, p:GetTall() - 40)
	deroll.Y = 40
	deroll:SetMouseInputEnabled(false)

	function deroll:Think()
		if not IsValid(cmds) then return end
		if self:IsHovered() and cmds.RollBacked then
			cmds.X = L(cmds.X, scr.X + 40, 10, true)
		elseif cmds.RollBacked then 
			cmds.X = L(cmds.X, scr.X + 25, 10, true)
		end
	end

	function deroll:DoClick()
		if cmds.RolledBack then 
			cmds:UnRollBack()
		end
	end
	for k, catcmds in pairs(cats) do 
		
		local b = vgui.Create("FButton", scr)--scr.Buttons[k] or vgui.Create("FButton", scr)
		scr.Buttons[k] = b 

		i = i + 1 

		b:SetPos(16, -40 + i*48)
		b:SetSize(200 - 32, 40)

		b.Label = k
		b:SetColor(Color(85, 85, 85))

		function b:DoClick()
			if cursel == self then 
				cursel = nil 
				if IsValid(cmds) then
					cmds:PopOut() 
					cmds:MoveBy(-10, 0, 0.1, 0, 0.4)
					cmds = nil
				end
				self:SetColor(85, 85, 85)

				return 
			end

			cursel = self
			self:SetColor(60, 160, 250)
			if not IsValid(cmds) then
				cmds = vgui.Create("FScrollPanel", p) 
				cmds:SetPos(scr.X + 200, scr.Y)
				cmds:MoveBy(12, 0, 0.1, 0, 0.4)
				cmds:SetSize(200, scr:GetTall())
				cmds:PopIn() 
				cmds.pnlCanvas:DockPadding(8, 8, 8, 8)
				cmds.GradBorder = true 
				cmds.Buttons = {}

				function cmds:RollBack()
					print("rollbacking")

					if scr.RolledBack then print("nop") return end 
					scr.RolledBack = true 
					self.RolledBack = true 

					scr:AlphaTo(210, 0.2, 0)

					self:MoveTo(scr.X + 25, 40, 0.2, 0, 0.5)
					deroll:SetMouseInputEnabled(true)
				end

				function cmds:UnRollBack()

					if not self.RolledBack then print("nop un") return end 
					print("unrollbacking")

					self.RolledBack = false 
					scr.RolledBack = false 

					self:MoveTo(scr.X + 212, 40, 0.4, 0, 0.5)

					scr:AlphaTo(255, 0.2, 0)
					deroll:SetMouseInputEnabled(false)
					for k,v in pairs(selpnls) do 
						if IsValid(v) then 
							v:PopOut()
						end 
						selpnls[k] = nil
					end

					for k,v in pairs(self.Buttons) do 
						if not IsValid(v) then continue end 
						v:SetColor(85, 85, 85)
						selbtn = nil
					end

				end

				function cmds:PostPaint(w, h)
					surface.DisableClipping(true)
						surface.SetMaterial(gr)
						surface.SetDrawColor(f.BackgroundColor)
						surface.DrawTexturedRect(-16, 0, 16, h)
					surface.DisableClipping(false)
				end

				CreateCommandButtons(catcmds, cmds)
			end

		end
	end

end, function() f:PopOut() end)