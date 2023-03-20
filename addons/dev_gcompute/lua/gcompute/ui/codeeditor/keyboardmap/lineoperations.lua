GCompute.CodeEditor.KeyboardMap:Register (KEY_UP,
	function (self, key, ctrl, shift, alt)
		if not ctrl or not shift then return false end
		local selectionStart, selectionEnd = self:GetSelection ():GetSelectionEndPoints ()
		local lineShiftAction = GCompute.CodeEditor.LineShiftAction (self, self:CreateSelectionSnapshot (), selectionStart:GetLine (), selectionEnd:GetLine (), -1)
		lineShiftAction:Redo ()
		if lineShiftAction:GetShift () == 0 then return end
		self:GetUndoRedoStack ():Push (lineShiftAction)
	end
)

GCompute.CodeEditor.KeyboardMap:Register (KEY_DOWN,
	function (self, key, ctrl, shift, alt)
		if not ctrl or not shift then return false end
		local selectionStart, selectionEnd = self:GetSelection ():GetSelectionEndPoints ()
		local lineShiftAction = GCompute.CodeEditor.LineShiftAction (self, self:CreateSelectionSnapshot (), selectionStart:GetLine (), selectionEnd:GetLine (), 1)
		lineShiftAction:Redo ()
		if lineShiftAction:GetShift () == 0 then return end
		self:GetUndoRedoStack ():Push (lineShiftAction)
	end
)
