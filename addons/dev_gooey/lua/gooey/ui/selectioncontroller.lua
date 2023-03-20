local self = {}
Gooey.SelectionController = Gooey.MakeConstructor (self)

--[[
	Modifier Keys:
		Control: Toggle selection state
		Shift: Add to selection

	Events:
		ScrollRequested (deltaOffset)
			Fired when the view should be scrolled.
		SelectionChanged (item)
			Fired when the latest selected item has been changed.
		SelectionCleared ()
			Fired when the selection has been cleared.
]]

local SelectionAction =
{
	Override	= 0, -- default
	Toggle		= 1, -- control
	Merge		= 2, -- shift
	Ignore		= 3
}

Gooey.SelectionMode =
{
	None		= 0,
	One			= 1,
	Multiple	= 2
}
local SelectionMode = Gooey.SelectionMode

function self:ctor (control)
	self.Control = control
	
	-- Box selection
	self.MouseDownX = 0
	self.MouseDownY = 0
	self.ExpectingBoxSelection = false
	self.InBoxSelection = false
	
	self.SelectionMode   = Gooey.SelectionMode.Multiple
	self.SelectionAction = SelectionAction.Override
	
	self.ItemsInBox         = {}
	
	-- Selection items
	self.SelectedItem       = nil -- The last item added to the selection
	self.SelectedItems      = {}  -- Array of selected items
	self.SelectedItemSet    = {}  -- Set of selected items (items as keys)
	
	self.NewSelectedItems   = {}  -- Array of box selected items
	self.NewSelectedItemSet = {}  -- Set of box selected items (items as keys)
	
	Gooey.EventProvider (self)
	
	control:AddEventListener ("MouseDown", "Gooey.SelectionController." .. self:GetHashCode (), function (_, mouseCode, x, y) self:MouseDown (_, mouseCode, x, y) end)
	control:AddEventListener ("MouseUp",   "Gooey.SelectionController." .. self:GetHashCode (), function (_, mouseCode, x, y) self:MouseUp   (_, mouseCode, x, y) end)
	control:AddEventListener ("MouseMove", "Gooey.SelectionController." .. self:GetHashCode (), function (_, mouseCode, x, y) self:MouseMove (_, mouseCode, x, y) end)
end

function self:AddToSelection (item)
	if not item then return end
	if self:IsSelected (item) then return end
	
	self.SelectedItem = self.SelectedItem or item
	self.SelectedItems [#self.SelectedItems + 1] = item
	self.SelectedItemSet [item] = true
	self:DispatchEvent ("SelectionChanged", item)
end

function self:ClearSelection ()
	if #self.SelectedItems == 0 then return end
	self.SelectedItem = nil
	self.SelectedItems = {}
	self.SelectedItemSet = {}
	
	self:DispatchEvent ("SelectionCleared")
	self:DispatchEvent ("SelectionChanged", nil)
end

function self:GetSelectedItem ()
	return self.SelectedItem
end

function self:GetSelectedItems ()
	return self.SelectedItems
end

function self:GetSelectionEnumerator ()
	return GLib.ValueEnumerator (self.SelectedItems)
end

function self:GetSelectionMode ()
	return self.SelectionMode
end

function self:IsSelected (item)
	if self.SelectionMode == SelectionMode.None then return false end

	if self.InBoxSelection then
		if self.SelectionAction == SelectionAction.Override
			or self.SelectionAction == SelectionAction.Merge then
			if self.NewSelectedItemSet [item] then return true end
		elseif self.SelectionAction == SelectionAction.Toggle then
			return self.SelectedItemSet [item] ~= self.NewSelectedItemSet [item]
		end
	end
	if self.SelectedItemSet [item] then return true end
	return false
end

function self:RemoveFromSelection (item)
	if not self.SelectedItemSet [item] then return end
	for k, v in ipairs (self.SelectedItems) do
		if v == item then
			table.remove (self.SelectedItems, k)
			break
		end
	end
	self.SelectedItemSet [item] = false
	
	if self.SelectedItem == item then
		self.SelectedItem = self.SelectedItems [1]
		if #self.SelectedItems == 0 then
			self:DispatchEvent ("SelectionCleared")
		end
		self:DispatchEvent ("SelectionChanged", self.SelectedItem)
	end
end

function self:SetSelectionMode (selectionMode)
	self.SelectionMode = selectionMode
end

-- Internal, do not call
function self:ClampPosition (x, y)
	local x1, y1, x2, y2 = self.Control:GetContentBounds ()
	
	if x <  x1 then x = x1     end
	if y <  y1 then y = y1     end
	if x >= x2 then x = x2 - 1 end
	if y >= y2 then y = y2 - 1 end
	
	return x, y
end

function self:ClearNewSelection ()
	self.NewSelectedItems = {}
	self.NewSelectedItemSet = {}
end

function self:FinishSelection ()
	if self.SelectionAction == SelectionAction.Override then
		-- Avoid sending events if there's no change in the selection
		-- and the selection only consists of one item
		if #self.SelectedItems == 1 and
			#self.NewSelectedItems == 1 and
			self.SelectedItems [1] == self.NewSelectedItems [1] then
			return
		end
		
		self:ClearSelection ()
		for _, item in ipairs (self.NewSelectedItems) do
			self.SelectedItems [#self.SelectedItems + 1] = item
			self.SelectedItemSet [item] = true
			self.SelectedItem = item
		end
		
		if #self.NewSelectedItems > 0 then
			self:DispatchEvent ("SelectionChanged", self.SelectedItem)
		end
	elseif self.SelectionAction == SelectionAction.Toggle then
		for _, item in ipairs (self.NewSelectedItems) do
			if not self.SelectedItemSet [item] then
				if self.SelectionMode == SelectionMode.One and #self.SelectedItems > 0 then
					self.SelectedItemSet [self.SelectedItems [1]] = nil
					self.SelectedItems [1] = nil
					self.SelectedItem = nil
				end
				self.SelectedItems [#self.SelectedItems + 1] = item
				self.SelectedItemSet [item] = true
				self.SelectedItem = item
			else
				for k, v in ipairs (self.SelectedItems) do
					if v == item then
						table.remove (self.SelectedItems, k)
						break
					end
				end
				self.SelectedItemSet [item] = nil
				if self.SelectedItem == item then
					self.SelectedItem = self.SelectedItems [1]
				end
			end
		end
		
		if #self.NewSelectedItems > 0 then
			self:DispatchEvent ("SelectionChanged", self.SelectedItem)
		end
	elseif self.SelectionAction == SelectionAction.Merge then		
		-- Copy new selection into main selection
		if self.SelectionMode == SelectionMode.One and #self.NewSelectedItems > 0 then			
			-- Check if there's no change in the selection and bail if so
			if #self.SelectedItems == 1 and
				#self.NewSelectedItems == 1 and
				self.SelectedItems [1] == self.NewSelectedItems [1] then
				return
			end
			self:ClearSelection ()
		end
		
		for _, item in ipairs (self.NewSelectedItems) do
			if not self.SelectedItemSet [item] then
				self.SelectedItems [#self.SelectedItems + 1] = item
				self.SelectedItemSet [item] = true
				self.SelectedItem = item
			end
		end
		
		if #self.NewSelectedItems > 0 then
			self:DispatchEvent ("SelectionChanged", self.SelectedItem)
		end
	end
end

function self:GetBoxSelectionRectangle ()
	local mouseX, mouseY = self:ClampPosition (self.Control:CursorPos ())
	
	local width  = math.abs (self.MouseDownX - mouseX) + 1
	local height = math.abs (self.MouseDownY - mouseY) + 1
	local left   = math.min (self.MouseDownX, mouseX)
	local top    = math.min (self.MouseDownY, mouseY)
	
	return left, top, width, height
end

-- Event handlers
function self:MouseDown (_, mouseCode, x, y)
	if input.IsKeyDown (KEY_LSHIFT) then
		self.SelectionAction = SelectionAction.Merge
	elseif input.IsKeyDown (KEY_LCONTROL) then
		self.SelectionAction = SelectionAction.Toggle
	else
		self.SelectionAction = SelectionAction.Override
	end
	
	if mouseCode == MOUSE_LEFT then
		x, y = self:ClampPosition (x, y)
		self.MouseDownX = x
		self.MouseDownY = y
		self.ExpectingBoxSelection = true
		
		self.Control:MouseCapture (true)
	elseif mouseCode == MOUSE_RIGHT then
		local item = self.Control:ItemFromPoint (x, y)
		if self:IsSelected (item) then self.SelectionAction = SelectionAction.Ignore end
	end
end

local items = {}
function self:MouseMove (_, mouseCode, x, y)
	if self.ExpectingBoxSelection then
		self.ExpectingBoxSelection = false
		self.InBoxSelection = true
	end
	if not self.InBoxSelection then return end
	
	if self.SelectionAction == SelectionAction.Override then self:ClearSelection () end
	self:ClearNewSelection ()
	
	if Profiler then Profiler:Begin ("SelectionController : Box selection") end
	
	local x, y, w, h = self:GetBoxSelectionRectangle ()
	self.ItemsInBox = self.Control:ItemsIntersectingAABB (x, y, x + w, y + h, self.ItemsInBox)
	for i = 1, #self.ItemsInBox do
		local item = self.ItemsInBox [i]
		if item:CanSelect () then
			self.NewSelectedItems [#self.NewSelectedItems + 1] = item
			self.NewSelectedItemSet [item] = true
			
			if self.SelectionMode == SelectionMode.One and #self.NewSelectedItems == 1 then
				break
			end
		end
	end
	
	-- Cleanup results array for next time
	for i = 1, #self.ItemsInBox do
		self.ItemsInBox [i] = nil
	end
	
	if Profiler then Profiler:End () end
end

function self:MouseUp (_, mouseCode, x, y)
	if mouseCode == MOUSE_LEFT then
		self.ExpectingBoxSelection = false
		if self.InBoxSelection then
			self.InBoxSelection = false
		else
			local item = self.Control:ItemFromPoint (x, y)
			if item and item:CanSelect () then
				self.NewSelectedItems [#self.NewSelectedItems + 1] = item
				self.NewSelectedItemSet [item] = true
			end
		end
		
		self.Control:MouseCapture (false)
	elseif mouseCode == MOUSE_RIGHT then
		if self.SelectionAction ~= SelectionAction.Toggle then
			local item = self.Control:ItemFromPoint (x, y)
			if item and item:CanSelect () then
				self.NewSelectedItems [#self.NewSelectedItems + 1] = item
				self.NewSelectedItemSet [item] = true
			end
		end
	end
	self:FinishSelection ()
	self:ClearNewSelection ()
end

function self:PaintOver (control)
	if self.InBoxSelection then
		local left, top, width, height = self:GetBoxSelectionRectangle ()
		
		surface.SetDrawColor (51, 153, 255, 128)
		surface.DrawRect (left, top, width, height)
		surface.SetDrawColor (51, 153, 255, 255)
		surface.DrawOutlinedRect (left, top, width, height)
	end
end