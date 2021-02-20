local bw = BaseWars.Bases

function bw.Zone:_EntityEntered(brush, ent)
	print("zone: entity entered:", ent)
end

function bw.Zone:_EntityExited(brush, ent)
	print("zone: entity exited:", ent)
end