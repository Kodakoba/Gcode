local imp = Settings.Create("new_impacts", "bool")
	:SetDefaultValue(true)
	:SetCategory("Visual")
	:SetName("Enable new impacts")
	:SetConVar("cl_new_impact_effects")


local imp = Settings.Create("comp_iknow", "bool")
	:SetDefaultValue(false)
	:SetCategory("Visual")
	:SetName("Hide Double Yield indicator")


hook.Add("ShouldPaintComp", "HideComp", function()
	if imp:GetValue() then return false end
end)