ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self.Created = CurTime()

	Partizones[#Partizones+1] = self

	self:ReloadDummy()

	if self.Partizone.OnSpawn then self.Partizone.OnSpawn(self) end
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:ReloadDummy()
	if IsValid(self.Dummy) then self.Dummy:Remove() end

	local d = ents.Create("partizone_dummy")

	d.ZoneName = self.ZoneName
	d:Spawn()

	d:SetPos(self:GetPos())

	d:SetParent(self)

	self.Dummy = d


end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end

function ENT:CheckCoolDown()
	if CurTime() - self.Created < 2 then return false end
	return true
end

function ENT:SetBrushBounds(p1, p2)
	if not isvector(p1) or not isvector(p2) then error('Trying to set an invalid brush vector!') return end

	local mid = (p1 + p2) / 2

	self:SetPos(mid)

	self:SetCollisionBoundsWS(p1, p2)	--seems like even though the coordinates are in world,
										--it still depends on the entity's position, so you gotta setpos first

	self.P1 = p1
	self.P2 = p2

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
	local me = self.Partizone
	if me.StartTouchFunc then me.StartTouchFunc(self, ent) end

end

--[[---------------------------------------------------------
	Name: EndTouch
-----------------------------------------------------------]]
function ENT:EndTouch(ent)
	if not self:CheckCoolDown() then return end

	local me = self.Partizone
	if me.EndTouchFunc then me.EndTouchFunc(self, ent) end

end

--[[---------------------------------------------------------
	Name: Touch
-----------------------------------------------------------]]
function ENT:Touch(ent)
	if not self:CheckCoolDown() then return end

	local me = self.Partizone
	if me.TouchFunc then me.TouchFunc(self, ent) end
end

local function loadPartizones()
	FInc.Recursive("partizones/*.lua", _SH, false, function(s)
		if s:find("^cl_") or s:find("^sv_") then return false, false end
	end)
	FInc.Recursive("partizones/sv_*.lua", _SV)
	FInc.Recursive("partizones/cl_*.lua", _CL)


	for k,v in pairs(PawwtizOwOnePOwOints) do
		OrderVectors(v[1], v[2])
	end
end

function ReloadPartizones()

	loadPartizones()

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

		me.TouchFunc = v.TouchFunc
		me.EndTouchFunc = v.EndTouchFunc
		me.StartTouchFunc = v.StartTouchFunc

		me.Partizone = v

		Partizones[me.ZoneName] = me

		me:Spawn()

		me.Dummy.ZoneName = k
		me:SetBrushBounds(v[1], v[2])
	end
end