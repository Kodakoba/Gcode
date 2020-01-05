AddCSLuaFile()

ENT.Base 			= "bw_base_generator"
ENT.PrintName 		= "Manual Generator"

ENT.Model 			= "models/props_c17/TrapPropeller_Engine.mdl"

ENT.PowerGenerated 	= 0
ENT.PowerGenerated2 = 150
ENT.PowerCapacity 	= 5000

ENT.TransmitRadius 	= 300
ENT.TransmitRate 	= 25

ENT.Sounds 			= {Sound("physics/flesh/flesh_squishy_impact_hard1.wav"), Sound("physics/flesh/flesh_squishy_impact_hard2.wav"), Sound("physics/flesh/flesh_squishy_impact_hard3.wav"), Sound("physics/flesh/flesh_squishy_impact_hard4.wav")}
ENT.Color			= Color(0, 0, 0, 255)

ENT.IsManualGen 	= true 

if SERVER then util.AddNetworkString("ManualGen") end 

function ENT:GenPower()

	self:EmitSound(self.Sounds[math.random(1, #self.Sounds)])
	self:ReceivePower(self.PowerGenerated2)
	
end

function ENT:GenerateOptions(qm, pnl)
	local gen = vgui.Create("FButton", pnl)
	gen:SetLabel("Make some power!")
	
	gen:SetSize(160, 48)

	gen:Center()

	gen.AlwaysDrawShadow = true 

	gen:PopIn()
	gen:SetDoubleClickingEnabled(false)
	gen:SetMouseInputEnabled(true)

	gen.DoClick = function()
		net.Start("ManualGen")
			net.WriteEntity(self)
		net.SendToServer()
	end

	local pw = vgui.Create("InvisPanel", pnl)
	
	pw:SetSize(200, 40)

	pw:Center()
	pw.Y = pw.Y + pnl.CircleSize

	local w, h = pw:GetContentSize()
	local ent = self 

	function pw:Paint(w, h)
		surface.SetDrawColor(60, 60, 60, 150)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(("Power: %d/%d"):format(ent:GetPower(), ent.PowerCapacity), "OSB24", w/2, h/2, Color(50, 160, 250), 1, 1)

		surface.SetDrawColor(0, 0, 0)
		self:DrawGradientBorder(w, h, 3, 3)
	end

	qm:AddPopIn(pw, pw.X, pw.Y, 0, -32)
	qm:AddPopIn(gen, gen.X, gen.Y - pnl.CircleSize - 8, 0, -32)
end

if SERVER then 
	net.Receive("ManualGen", function(_, ply)
		local gen = net.ReadEntity()
		if not IsValid(gen) or not gen.IsManualGen then return end 

		if ply:GetPos():Distance(gen:GetPos()) > 196 then return end 

		gen:GenPower()
	end)
end