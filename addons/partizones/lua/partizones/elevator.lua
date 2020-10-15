local zone = Partizone("Elevator")


zone:SetBounds(Vector(-7275.4965820313, -9253.8486328125, 60), Vector (-7104.03125, -9434.9052734375, 2745))

zone.OnSpawn = function(self)
	local p1, p2 = zone:GetBounds()

	for k,v in pairs(ents.FindInBox(p1,p2)) do

		if IsValid(v) and v.GetClass and v:GetClass()=="ambient_generic" then
			v:Remove()
		end

	end


end

zone.StartTouchFunc = function(self, ent)	--Started touch

	if not IsPlayer(ent) then
		return
	end

	net.Start("Partizone")
		net.WriteBool(true)
		net.WriteUInt(2, 8)
	net.Send(ent)

end


zone.EndTouchFunc = function(self, ent)

	if not IsPlayer(ent) then
		return
	end

	net.Start("Partizone")
		net.WriteBool(false)
		net.WriteUInt(2, 8)
	net.Send(ent)

end

AddPartizone(zone)