AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Electric Pole"

ENT.Model = "models/grp/powerpole/powerpole.mdl"
ENT.Skin = 0

ENT.IsPole = true
ENT.PowerType = "Line"

ENT.ConnectDistance = 1500

ENT.Connectable = true
ENT.Cableable = true
ENT.ConnectPoint = Vector (3.6, 0, 24)

ENT.UseSpline = true
ENT.SplineStrength = 1

ENT.DontPreview = true

ENT.MaxGenerators = 8
ENT.MaxElectronics = 16

ENT.MultipleGenerators = true

function ENT:DerivedDataTables()

	for i=0, 31 do
		self:NetworkVar("Entity", i, "Connection" .. i)

		if CLIENT then
			self:NetworkVarNotify("Connection" .. i, function(self, name, old, new)
				self:OnConnectionChange(i, old, new)
			end)
		end

	end


end