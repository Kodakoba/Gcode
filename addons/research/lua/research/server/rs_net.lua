--hairy balls

util.AddNetworkString("Research")

net.Receive("Research", function(_, ply)
	local id = net.ReadUInt(16)
	local ent = net.ReadEntity()

	if not IsValid(ent) or not ent.ResearchComputer --[[or not ent:CPPIGetOwner() ~= ply]] or ply:Distance(ent) > 256 then print("no") return end
	if not Research.IDs[id] then print("no perk with", id) return end 

	Research.BeginResearch(ply, Research.IDs[id], ent)
end)