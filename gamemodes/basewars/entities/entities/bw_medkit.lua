AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Medkit"
ENT.Author = "Frumorn"
ENT.Information = "A medkit when used, gives 20 health after 5 seconds"
ENT.Category = "BaseWars"
ENT.Spawnable = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/Items/HealthKit.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysWake()
		self:Activate()
		self:SetUseType(SIMPLE_USE)
	end
	
	function ENT:Use(act)
    	if not act:IsPlayer() then return end
    	if act._MedkitCooldown then return act:ChatPrint(string.format(BaseWars.LANG.OnItemCoolDown, self.PrintName)) end 
    	
    	local maxhealth = act:GetMaxHealth()
    
    	if act:Health() < maxhealth then
    	    act._MedkitCooldown = true
    	    
    		self:EmitSound("items/smallmedkit1.wav")
    		self:Remove()
    
    		timer.Simple(1, function()
    			if IsValid(act) and act:Alive() then
    				act:EmitSound("HL1/fvox/automedic_on.wav")
    			end
    		end)
    
    		timer.Simple(5, function()
    			if IsValid(act) and act:Alive() then
    				act:SetHealth(math.Clamp(act:Health() + 20, 0, maxhealth))
    				act:EmitSound("items/medshot4.wav")
    				act._MedkitCooldown = nil
    			end
    		end)
        end
    end

else
    function ENT:Draw()
    	self:DrawModel()
    end
end