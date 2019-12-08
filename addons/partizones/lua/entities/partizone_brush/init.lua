ENT.Base = "base_brush"
ENT.Type = "brush"

Partizones = Partizones or {}

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self.Created = CurTime()

	Partizones[#Partizones+1] = self

	local d = ents.Create("partizone_dummy")
	d.ZoneName = self.ZoneName
	d:Spawn()

	self.Dummy = d

end

function ENT:CheckCoolDown()
	if CurTime() - self.Created < 2 then return false end 
	return true
end

function ENT:SetBrushBounds(p1, p2)
	if not isvector(p1) or not isvector(p2) then error('Trying to set an invalid brush vector!') return end 
	self:SetCollisionBoundsWS(p1, p2)
	self.P1 = p1 
	self.P2 = p2

	if PartizonePoints[self.ZoneName].OnSpawn then PartizonePoints[self.ZoneName].OnSpawn(self) end

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
function ENT:StartTouch(ent)
	if not self:CheckCoolDown() then return end 

	if self.StartTouchFunc then self:StartTouchFunc(ent) end

end

--[[---------------------------------------------------------
	Name: EndTouch
-----------------------------------------------------------]]
function ENT:EndTouch(ent)
	if not self:CheckCoolDown() then return end 

	if self.EndTouchFunc then self:EndTouchFunc(ent) end

end

--[[---------------------------------------------------------
	Name: Touch
-----------------------------------------------------------]]
function ENT:Touch(ent)
	if not self:CheckCoolDown() then return end 

	if self.TouchFunc then self:TouchFunc(ent) end
end

function ReloadPartizones()

	for k,v in pairs(Partizones) do 

		if IsValid(v) then 

			if IsValid(v.Dummy) then 
				v.Dummy:Remove()
			end

			v:Remove() 
			Partizones[k] = nil 
		end

	end

	for k,v in pairs(PartizonePoints) do 
		local me = ents.Create("partizone_brush")
		me.ZoneName = k
		me:Spawn()

		me:SetBrushBounds(v[1], v[2])
		me.TouchFunc = v.TouchFunc 
		me.EndTouchFunc = v.EndTouchFunc 
		me.StartTouchFunc = v.StartTouchFunc 

		Partizones[me.ZoneName] = me
	end
end

hook.Add("InitPostEntity", "PartizonesSpawn", ReloadPartizones)
hook.Add("OnReloaded", "PartizonesSpawn", ReloadPartizones)
hook.Add("PostCleanupMap", "PartizonesSpawn", ReloadPartizones)

if CurTime() > 30 then 
	ReloadPartizones()
end