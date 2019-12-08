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

function ENT:UseFunc()

	self:EmitSound(self.Sounds[math.random(1, #self.Sounds)])
	self:ReceivePower(self.PowerGenerated2)
	
end
function ENT:Use()
    self:UseFunc()
end