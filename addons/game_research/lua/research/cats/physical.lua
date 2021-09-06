local phicon = {
	url = "https://i.imgur.com/XQG1MfQ.png", 
	name = "faction.png"
}

local phcat = Research.AddCategory(1, "Physical", phicon)

	
	--[[

		Mobility SubCategory

	]]

	local mobicon = {
		url = "https://i.imgur.com/bbnkFOW.png",
		name = "mobility.png"
	}

	local mob = phcat:AddSubCategory("Mobility", mobicon, "Mobility is key.")


	--[[
	
		Vitality SubCategory

	]]

	local viticon = {
		url = "https://i.imgur.com/5BQxS4m.png", 
		name = "vitality.png"
	}

	local vit = phcat:AddSubCategory({
		Name = "Vitality",
		Icon = viticon,
		Description = "Everything related to your survival."
	})
