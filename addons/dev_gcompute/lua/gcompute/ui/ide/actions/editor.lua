GCompute.IDE.ActionMap:Register ("Exit",
	function (self)
		self:SetVisible (false)
	end
)

GCompute.IDE.ActionMap:Register ("Close",
	function (self)
		if not self:GetActiveView () then return end
		self:GetIDE ():CloseView (self:GetActiveView ())
	end,
	function (self)
		return self:GetIDE ():CanCloseView (self:GetActiveView ()) or self:GetActiveView ():CanHide ()
	end
)