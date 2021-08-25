
function ENT:CreateClaimCanvas(menu, inv)
	local canv = vgui.Create("InvisPanel", menu)
	canv:SetSize(menu:GetWide(), menu:GetTall() - menu.HeaderSize)
	canv.Y = menu.HeaderSize

	
end