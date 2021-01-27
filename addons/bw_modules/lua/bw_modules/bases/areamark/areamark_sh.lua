--

StartTool("AreaMark")

	function TOOL:LeftClick(tr)
		return true
	end

	function TOOL:Allowed()
		return self:GetOwner():IsSuperAdmin()
	end

	function TOOL:RightClick(tr)
		return true
	end

	function TOOL:Reload()

	end

	BaseWars.Bases.MarkTool = TOOL

EndTool()