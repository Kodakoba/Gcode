ENT.Base = "base_brush"
ENT.Type = "brush"

local points = SafezonePoints or {} 


Safezones = Safezones or {}


function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	Safezones[#Safezones+1] = self

	local d = ents.Create("bw_safezone_dummy")
	d.ZoneName = self.ZoneName
	d:Spawn()

	self.Dummy = d

end

function ENT:SetBrushBounds(p1, p2)
	if not isvector(p1) or not isvector(p2) then error('Trying to set an invalid brush vector!') return end 
	self:SetCollisionBoundsWS(p1, p2)
	self.P1 = p1 
	self.P2 = p2
	local mid = (p1 + p2) / 2
	local d = self.Dummy
	if not IsValid(d) then return end 

	d:SetPos(mid)
	d.P1 = p1 
	d.P2 = p2 
end

--[[---------------------------------------------------------
	Name: StartTouch
-----------------------------------------------------------]]
local RemoveEm = {}

function ENT:StartTouch(ent)
	if not IsValid(ent) then return end 

	if ent:IsPlayer() then
		ent:SetNWFloat("Safezone", CurTime())
	end
	if ent.IsBaseWars then 
		if IsValid(ent:CPPIGetOwner()) then 
			ent:CPPIGetOwner():ChatPrint("Remove your " .. (ent.PrintName or ent:GetClass()) .. " from spawn or it will be removed!")
			RemoveEm[ent] = CurTime()
		end 
	end

end

--[[---------------------------------------------------------
	Name: EndTouch
-----------------------------------------------------------]]
function ENT:EndTouch(ent)

	if IsValid(ent) and ent:IsPlayer() then
		ent:SetNWFloat("Safezone", 0)
	end

	RemoveEm[ent] = nil
end

--[[---------------------------------------------------------
	Name: Touch
-----------------------------------------------------------]]
function ENT:Touch(ent)
	
	if RemoveEm[ent] and CurTime() - RemoveEm[ent] >= 5 then 
		ent:Remove()
		if IsValid(ent:CPPIGetOwner()) then 
			ent:CPPIGetOwner():ChatPrint("Your " .. (ent.PrintName or ent:GetClass()) .. " was destroyed because it was in a safezone for too long!")
			RemoveEm[ent] = nil
		end 
	end

end
function ReloadSafezones()

	for k,v in pairs(Safezones) do 

		if IsValid(v) then 
			if IsValid(v.Dummy) then 
				v.Dummy:Remove()
			end

			v:Remove() 
			Safezones[k] = nil 
		end

	end

	for k,v in pairs(points) do 
		local me = ents.Create("bw_safezone_brush")
		me.ZoneName = k
		me:Spawn()

		me:SetBrushBounds(v[1], v[2])
		
	end
end
hook.Add("InitPostEntity", "SafezonesSpawn", ReloadSafezones)
hook.Add("OnReloaded", "SafezonesSpawn", ReloadSafezones)

hook.Add("PlayerShouldTakeDamage", "Safezones", function( ply, atk )
	if not IsValid(ply) then return end 
	if ply:GetNWFloat("Safezone", 0)~=0 and ply:GetNWFloat("Safezone", 0) < CurTime()-5 then return false end 
	if atk:GetNWFloat("Safezone", 0) > 0 then return false end 

end)
hook.Add("PostCleanupMap", "Safezones", ReloadSafezones)