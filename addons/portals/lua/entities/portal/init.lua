include("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

function ENT:Initialize()

	print("Initalized portal render")
end

function ReloadPortals()
	for k,v in pairs(ents.FindByClass("portal")) do 
		v:Remove()
	end

	for k,v in pairs(PortalPoints) do
		local port = ents.Create("portal")
		port:Spawn()
		port:SetPos(v.Position)
		
		port:SetRenderPosition(v.RenderPosition)
		port:SetRenderAnglesBrokeName(v.RenderAngles)
		
		port:SetCamAngles(v.Angle)

		port:SetPortalSize(Vector(v.SizeW, v.SizeH))

	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end