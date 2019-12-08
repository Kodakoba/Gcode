include("shared.lua")
AddCSLuaFile("shared.lua")



PowerPoles = PowerPoles or {}
local poles = PowerPoles

function ENT:OnConnectionChange(id, old, new)
	local me = BWEnts[self]

	if not IsValid(new) then 
		new = nil 
	end 
	print("new", id, new)
	me.Generators[id + 1] = new

end

local function OpenShit(qm, self, pnl)

	local recon = vgui.Create("FButton", pnl)
	recon:SetSize(192, 50)
	recon:Center()

	recon.Label = "Reconnect to nearby"

	qm:AddPopIn(recon, pnl:GetWide() / 2 + pnl.CircleSize + 8, recon.Y, 32, 0)


	local discon = vgui.Create("FButton", pnl)
	discon:SetSize(192, 50)
	discon:Center()

	discon.Label = "Disconnect from all"

	qm:AddPopIn(discon, discon.X, discon.Y - pnl.CircleSize - 8, 0, -32)

end


function ENT:CLInit()
	print("called")
	
	poles[#poles + 1] = self
	local me = BWEnts[self]
	me.Generators = {}

	me.Electronics = {}

	local qm = self:SetQuickInteractable()
	qm.OnOpen = OpenShit

end

local cab = Material("cable/cable2")

hook.Add("PostDrawTranslucentRenderables", "DrawPoleCables", function(d, sb)
	local b = bench()
	b:Open()

	if sb or #poles <= 0 then return end 

	render.SetMaterial( cab )

	for k, pole in pairs(poles) do 

		if not IsValid(pole) then table.remove(poles, k) continue end

		local me = BWEnts[pole]
		local pos = pole:LocalToWorld(pole.ConnectPoint)

		if not me.Generators then continue end 

		for id, gen in pairs(me.Generators) do
			--print("drawing", gen)
			if not IsValid(gen) then me.Generators[gen] = nil continue end
			local cable = GenerateCable(pos, gen:GetPos(), 3, 10)

			render.StartBeam(#cable)

				for k, v in ipairs(cable) do
					render.AddBeam( v, 2, 0.5, color_white)
				end

			render.EndBeam()
		end

	end
	b:Close()
	--print(b)
end)