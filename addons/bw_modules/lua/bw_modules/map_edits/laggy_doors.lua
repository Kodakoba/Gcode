local dumbShit = {
	1742,
	1743,
	1746,
	1747,
	1748,
	1749,

	-- gas station doors (courtesy of flame)
	1500,
	1501,
}

function CleanupDumbDoors()
	for k,v in ipairs(dumbShit) do
		local ent = ents.GetMapCreatedEntity(v)
		if ent:IsValid() then
			ent:Remove()
		end
	end
end

hook.Add("InitPostEntity", "FuckYou", CleanupDumbDoors)
hook.Add("PostCleanupMap", "FuckYou", CleanupDumbDoors)