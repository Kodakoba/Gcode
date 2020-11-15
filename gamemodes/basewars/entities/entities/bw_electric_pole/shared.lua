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

ENT.Powerless = true

ENT.ConnectPoint = Vector (3.6, 0, 24)
ENT.ChainPoints = {
	Vector (12.8, -3.2, 72),
	Vector (-0.02, -3, 72),
	Vector (-29, -4, 72),
	Vector (-40, -4, 72)
}


ENT.UseSpline = true
ENT.SplineStrength = 1

ENT.DontPreview = true

ENT.MaxGenerators = 8
ENT.MaxElectronics = 16

ENT.MultipleGenerators = true

function ENT:DerivedDataTables()
	--self:NetworkVar("Int", 3, "GridID")
	--self:NetworkVar("Entity", 1, "")
	if CLIENT then
		self:NetworkVarNotify("GridID", function(self, name, old, new)
			self:OnChangeGridID(new)
		end)
	end

end