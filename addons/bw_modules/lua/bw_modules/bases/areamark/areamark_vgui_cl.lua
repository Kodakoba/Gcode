local bases = BaseWars.Bases
local bnd = Bind("areamark_baseselect")
local TOOL = BaseWars.Bases.MarkTool

function TOOL:OpenBaseGUI(base)
	if IsValid(bases.BaseGUI) then
		bases.BaseGUI:SwitchToBase(base)
		return
	end

	local pnl = self:CreateTemplateGUI()
end

function TOOL:OpenNewBaseGUI()
	if IsValid(bases.BaseGUI) then
		bases.BaseGUI:SwitchToNewBase()
		return
	end

	local pnl = self:CreateTemplateGUI()
end

function TOOL:CreateTemplateGUI()
	local ff = vgui.Create("FFrame")

	local ratio = 5 / 3
	local min = math.min(ScrW() * 0.4 / ratio, ScrH() * 0.6)

	ff:SetSize(min * ratio, min)
	ff:Center()
	local x = ff.X
	ff.X = (ff.X + self.BaseSelection.X) / 2
	ff:To("X", x, 0.6, 0, 0.1)
	ff:MakePopup()
	ff:PopIn()

	bases.BaseGUI = ff

	return ff
end

TOOL:Finish()