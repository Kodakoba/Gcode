include("shared.lua")
AddCSLuaFile("shared.lua")

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)

local curtip = ""
local popup = false
local hovd

function ENT:QMOnClose(qm, self, pnl)

end

function ENT:QMThink(qm, self, pnl)

end

function ENT:OpenShit(qm, self, pnl)

	local me = BWEnts[self]

	local b = vgui.Create("FButton", pnl)
	b:SetSize(190, 60)
	b.Label = "Cycle Text"
	b:Center()
	b.AlwaysDrawShadow = true
	b.Y = b.Y - 8

	b:SetDoubleClickingEnabled(false)

	b.DoClick = function()
		local ok = self.Delta:CycleNext()
		if not ok then 
			self.Delta:CycleReset()
			self.Delta:CycleNext()
		end
	end
	qm:AddPopIn(b, b.X, b.Y - pnl.CircleSize, 0, -32)

end


function ENT:CLInit()
	
	local me = BWEnts[self]
		
	self.Delta = DeltaText()
	local dt = self.Delta 

	dt:AddText("Boomer")
	dt:AddText("Bruh")
	dt:AddText("Tchu say?")

	local tp = dt:AddText("Dumbass")
	tp:SetOffsetAppear(0, -64)
	tp:SetFont("BS72")

	local ret = dt:AddText("Retard")
	
	function ret:OnAppear()
		if not self.Fragmented then self:AddFragment(1, 2) end
	end
	local ev = dt:AddEvent()

	function ev:OnActive()
		local ok = ret:ReplaceText(2, "Faking ri")
		if not ok then dt:CycleNext() end
	end

	dt:AddText("Idiota")

	dt:CycleNext()

	local qm = self:SetQuickInteractable()

	qm.OnOpen = function(...) self:OpenShit(...) end
	qm.Think = function(...) self:QMThink(...) end
	qm.OnFullClose = function(...) self:QMOnClose(...) end

end

local col = Color(70, 70, 70, 120)

function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(-12, -14, 79))
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos, ang, 0.05)
		local ok, err = pcall(function()
			draw.RoundedBox(8, 0, 0, 450, 390, col)
			self.Delta:Paint(225, 225)

		end)
	cam.End3D2D()

	if not ok then 
		print("err", err)
	end
end