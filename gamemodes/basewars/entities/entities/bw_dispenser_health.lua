
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
end

local blur = Material( "pp/blurscreen" )
blur:SetFloat("$blur", 2)

function ENT:QMOnReopen(qm, self, pnl)
	pnl:MemberLerp(blk, "a", 160, 0.3, 0, 0.3)
end

function ENT:OpenShit(qm, self, pnl)

	--pnl:SetSize(850, 600)	--cant fit
	--pnl:CenterHorizontal()

	pnl:On("PrePaint", function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)
		
		DisableClipping(true)
			surface.SetDrawColor(blk:Unpack())
			surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
			render.UpdateScreenEffectTexture()
			surface.SetMaterial(blur)
			for i = -1, 1 do
				surface.DrawTexturedRect(-x + i, -y + i, ScrW(), ScrH())
			end
		DisableClipping(false)
	end)

	pnl:MemberLerp(blk, "a", 160, 0.3, 0, 0.3)

	local give_stim = vgui.Create("FButton", pnl)
	give_stim:SetSize(200, 60)
	give_stim:Center()
	give_stim.Y = give_stim.Y - pnl.CircleSize / 2 - give_stim:GetTall() / 2 - 22

	give_stim.AlwaysDrawShadow = true
	give_stim.Shadow.Intensity = 5
	give_stim.Shadow.MaxSpread = 2
	give_stim.Shadow.MinSpread = 1.3
	give_stim.Shadow.Blur = 4

	give_stim.Label = "give me a stim,\nbartender"
	give_stim.Font = "OS22"
	give_stim.TextY = give_stim:GetTall() / 2 - 1
	give_stim.TextHeight = 18

	qm:AddPopIn(give_stim, give_stim.X, give_stim.Y, 0, -32)


	local give_stim = vgui.Create("FButton", pnl)
	give_stim:SetSize(200, 60)
	give_stim:Center()
	give_stim.Y = give_stim.Y + pnl.CircleSize / 2 + give_stim:GetTall() / 2 + 22

	give_stim.AlwaysDrawShadow = true
	give_stim.Shadow.Intensity = 5
	give_stim.Shadow.MaxSpread = 2
	give_stim.Shadow.MinSpread = 1.3
	give_stim.Shadow.Blur = 4

	give_stim.Label = "give me a heal,\n         bartender"
	give_stim.Font = "OS22"
	give_stim.TextY = give_stim:GetTall() / 2 - 1
	give_stim.TextHeight = 18

	qm:AddPopIn(give_stim, give_stim.X, give_stim.Y, 0, 32)
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
