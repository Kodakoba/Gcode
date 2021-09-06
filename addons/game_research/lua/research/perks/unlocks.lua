--poop

local ent = Research.SubCategories.Entities

local prk = Research.AddPerk("Unlock Printer Tier", "printers")

--[[
t.ent = v.Class
			t.name = v.Name or ent.PrintName or "[Undefined name!]"
			t.desc = v.Description
			t.icon = v.Model or v.Icon
]]

--[[
	Name = string,
	Description = table {
		{	
			Text = string,
			[Color = color,]
			[font = string,]
			[Continuation = bool,]
		},

		...
	},
	
	Model = string, --path to model;  takes priority over Icon if exists
	Icon = table { url = string, name = string } OR IMaterial
	
]]

--[[
	Icons:
		icurl = i.URL
		icname = i.Name
		ix, iy, iw, ih = i.X, i.Y, i.W, i.H
		icol = i.Color 
]]

for i=1, 5 do
	prk:AddLevel({penises = i})
	prk:AddYield("ents", {

		{
			Class = "bw_printer_nuclear",
			Description = {
				{	
					Text = "Unlocks ",
				},
				{
					Text = "Nuclear Printer",
					Color = Color(100, 200, 100),
					Continuation = true
				},
				{Text = "Nigga"}
			},
			Model = "models/grp/printers/printer.mdl"
		},

		{
			Class = "bw_printer_mobius",
			Description = {
				{	
					Text = "Unlocks ",
				},
				{
					Text = "Mobius Printer",
					Color = Color(225, 20, 255),
					Continuation = true
				}
			},
			Model = "models/grp/printers/printer.mdl"
		}

	})
end

prk:SetDescription("Unlock faster and more efficient money printers.")

ent:AddPerk(prk)

prk = Research.AddPerk("Unlock Generator tier", "generators")

for i=1, 5 do 
	prk:AddLevel({Peepee = i})
end 

prk:SetDescription("Unlock more powerful, more efficient and more convenient generators.")

ent:AddPerk(prk)