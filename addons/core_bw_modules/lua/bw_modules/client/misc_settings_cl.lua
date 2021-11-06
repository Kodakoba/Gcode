local imp = Settings.Create("new_impacts", "bool")
	:SetDefaultValue(true)
	:SetCategory("Visual")
	:SetName("Enable new impacts")

imp:On("Change", "convar", function(self, old, new)
	RunConsoleCommand("cl_new_impact_effects", new and 1 or 0)
end)