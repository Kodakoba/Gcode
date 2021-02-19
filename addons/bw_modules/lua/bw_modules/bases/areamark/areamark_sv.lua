--

local TOOL = BaseWars.Bases.MarkTool

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end

TOOL:Finish()
--BaseWars.Bases.MarkTool:Finish()