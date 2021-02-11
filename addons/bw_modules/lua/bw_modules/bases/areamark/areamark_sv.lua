--

local TOOL = BaseWars.Bases.MarkTool

function TOOL:LeftClick(tr)
	--print("Brrt", tr.HitPos)
	--return true
end

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end

function TOOL:RightClick(tr)
	--return true
end

function TOOL:Reload()

end

TOOL:Finish()
--BaseWars.Bases.MarkTool:Finish()