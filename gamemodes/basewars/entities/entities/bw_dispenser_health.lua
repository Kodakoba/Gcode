
AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "Health Dispenser"
ENT.Author = "grmx"

ENT.Model = "models/props_combine/health_charger001.mdl"

ENT.Sound = Sound("HL1/fvox/blip.wav")
ENT.EmitUnusableBeeps = false

function ENT:Init()
	self:SetModel(self.Model)
	self:SetHealth(500)

	self:SetUseType(CONTINUOUS_USE)
end

local blk = Color(0, 0, 0, 0)

function ENT:QMOnBeginClose(qm, self, pnl)
	pnl:MemberLerp(blk, "a", 0, 0.3, 0, 0.3)
	local midX, midY = pnl:GetWide() / 2, pnl:GetTall() / 2


	--[[local healBtn = pnl.HealBtn

	local x = midX - healBtn:GetWide() - pnl.CircleSize - 24
	local y = midY - healBtn:GetTall() / 2

	healBtn:CircleMoveTo(x, y, 0.3, 0.4, true)
	healBtn:PopOut(0.2):Then(function()
		qm:Close()
	end)]]

	local stimBtn = pnl.GiveStimBtn

	local x = midX + pnl.CircleSize + 24
	local y = midY - stimBtn:GetTall() / 2

	stimBtn:CircleMoveTo(x, y, 0.3, 0.4, true)
	stimBtn:PopOut(0.2):Then(function()
		qm:Close()
	end)

	pnl.Closing = true
end

local blur = Material( "pp/blurscreen" )
blur:SetFloat("$blur", 2)
blur:Recompute()

function ENT:QMOnReopen(qm, self, pnl)
	local minput = not not pnl.ShouldMouse
	pnl:SetMouseInputEnabled(minput)

	pnl:MemberLerp(blk, "a", minput and 160 or 90, 0.3, 0, 0.3)

	--[[local healBtn = pnl.HealBtn
	healBtn:CircleMoveTo(healBtn.ToX, healBtn.ToY, 0.3, 0.4)
	healBtn:PopIn(0.2)]]

	local stimBtn = pnl.GiveStimBtn
	stimBtn:CircleMoveTo(stimBtn.ToX, stimBtn.ToY, 0.3, 0.4)
	stimBtn:AlphaTo(pnl.StimAlpha, 0.3, 0, 0.3)

	pnl.Closing = false
end

function ENT:OpenShit(qm, self, pnl)

	--pnl:SetSize(850, 600)	--cant fit
	--pnl:CenterHorizontal()
	print("opening shite", qm)

	pnl:SetMouseInputEnabled(false)
	pnl:On("PrePaint", function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		DisableClipping(true)
			surface.SetDrawColor(blk:Unpack())
			surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)

			if self:IsMouseInputEnabled() then
				-- only blur if the user wants to interact with the dispenser
				render.UpdateScreenEffectTexture()
				surface.SetMaterial(blur)
				for i = -1, 1 do
					surface.DrawTexturedRect(-x + i, -y + i, ScrW(), ScrH())
				end
			end

		DisableClipping(false)

		--[[if self:IsMouseInputEnabled() and not pnl.Closing then
			pnl:MemberLerp(blk, "a", 160, 0.3, 0, 0.3)
		end]]

		if input.IsMouseDown(MOUSE_RIGHT) and not self:IsMouseInputEnabled() then
			self:SetMouseInputEnabled(true)
			self.ShouldMouse = true
			pnl:MemberLerp(blk, "a", 160, 0.3, 0, 0.3)
			if pnl.GiveStimBtn and pnl.GiveStimBtn:IsValid() then
				local b = pnl.GiveStimBtn
				b:PopIn(nil, nil, nil, true)
				b:MemberLerp(b.Shadow, "Intensity", 4, 0.2, 0, 0.3)
				b:MemberLerp(b.Shadow, "MinSpread", 1.2, 0.2, 0, 0.3)

				pnl.StimAlpha = 255
				qm.MaxInnerAlpha = 255
			end
		end
	end)

	pnl:MemberLerp(blk, "a", 90, 0.3, 0, 0.3)

	local give_stim = vgui.Create("FButton", pnl)
		give_stim:SetSize(200, 60)
		give_stim:Center()
		--give_stim.Y = give_stim.Y - pnl.CircleSize / 2 - give_stim:GetTall() / 2 - 22

		give_stim.AlwaysDrawShadow = true
		give_stim.Shadow.Intensity = 1
		give_stim.Shadow.MaxSpread = 2
		give_stim.Shadow.MinSpread = 0.6
		give_stim.Shadow.Blur = 1

		give_stim.Label = "give me a stim,\nbartender"
		give_stim.Font = "OS22"
		give_stim.TextY = give_stim:GetTall() / 2 - 1
		give_stim.TextHeight = 18

		local toX = give_stim.X
		local toY = give_stim.Y - pnl.CircleSize - give_stim:GetTall() / 2 - 22

		give_stim.Y = give_stim.Y - give_stim:GetTall() / 2 - pnl.CircleSize / 2
		give_stim.X = give_stim.X - give_stim:GetWide() / 2 - pnl.CircleSize / 2

		give_stim.FromX, give_stim.FromY = give_stim:GetPos()
		give_stim.ToX, give_stim.ToY = toX, toY

		give_stim:SetIcon("https://i.imgur.com/0SwgoHs.png", "adrenaline_shot.png", 32, 32)
		give_stim:CircleMoveTo(toX, toY, 0.3, 0.4)

		give_stim:SetAlpha(0)
		give_stim:AlphaTo(120, 0.1, 0)

		pnl.GiveStimBtn = give_stim
		pnl.StimAlpha = 120
		qm.MaxInnerAlpha = 120

	--qm:AddPopIn(give_stim, give_stim.X, give_stim.Y, 0, -32)


	--[[local healBtn = vgui.Create("FButton", pnl)
		healBtn:SetSize(200, 60)
		healBtn.AlwaysDrawShadow = true
		healBtn.Shadow.Intensity = 3
		healBtn.Shadow.MaxSpread = 2
		healBtn.Shadow.MinSpread = 1.2
		healBtn.Shadow.Blur = 1

		healBtn.Label = "give me a heal,\nbartender"
		healBtn.Font = "OS22"
		healBtn.TextY = healBtn:GetTall() / 2 - 1
		healBtn.TextHeight = 18

		healBtn:Center()

		local toX = healBtn.X
		local toY = healBtn.Y + pnl.CircleSize + healBtn:GetTall() / 2 + 22

		healBtn.Y = healBtn.Y + healBtn:GetTall() / 2 + pnl.CircleSize / 2
		healBtn.X = healBtn.X + healBtn:GetWide() / 2 + pnl.CircleSize / 2

		local fromX, fromY = healBtn:GetPos()

		healBtn.FromX, healBtn.FromY = fromX, fromY
		healBtn.ToX, healBtn.ToY = toX, toY

		healBtn:CircleMoveTo(toX, toY, 0.3, 0.4)

		healBtn:PopIn(0.2)

		pnl.HealBtn = healBtn]]

	--qm:AddPopIn(give_stim, give_stim.X, give_stim.Y, 0, 32)
end

function ENT:CLInit()

	local qm = self:SetQuickInteractable()

	qm:SetTime(0.35)
	qm.OnOpen = function(...) self:OpenShit(...) end
	--qm.Think = function(...) self:QMThink(...) end
	qm.OnClose = function(...) self:QMOnBeginClose(...) end
	--qm.OnFullClose = function(...) self:QMOnClose(...) end
	qm.OnReopen = function(...) self:QMOnReopen(...) end

end

function ENT:CheckUsable()

	if self.Time and self.Time + 0.5 > CurTime() then return false end
	
end

function ENT:UseFunc(ply)
	
	if not IsPlayer(ply) then return end
	
	self.Time = CurTime()
	
	local hp = ply:Health()
	if hp >= ply:GetMaxHealth() then return end
	
	ply:SetHealth(math.min(hp + 10, math.max(ply:Health(), ply:GetMaxHealth())))
	self:EmitSound(self.Sound, 100, 60)
	
end
