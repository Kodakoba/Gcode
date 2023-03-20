local self = {}
GCompute.IDE.View = GCompute.MakeConstructor (self)

--[[
	Events:
		CanCloseChanged (canClose)
			Fired when the view's closability has changed.
		CanHideChanged (canHide)
			Fired when the view's hideability has changed.
		DocumentChanged (oldDocument, newDocument)
			Fired when the view's document has changed.
		IconChanged (icon)
			Fired when the view's icon has changed.
		TitleChanged (title)
			Fired when the view's title has changed.
		ToolTipChanged (toolTip)
			Fired when the view's tooltip text has changed.
		VisibleChanged (visible)
			Fired when the view's visibility has changed.
]]

function self:ctor (container)
	self.Id = nil
	
	-- IDE
	self.IDE         = nil
	self.ViewManager = nil
	
	self.Container = container
	
	-- Documents
	self.Document = nil
	self.DocumentManager = nil
	self.SavableProxy = nil
	
	-- UI
	if self.Closable == nil then self.Closable = true  end
	if self.Hideable == nil then self.Hideable = false end
	if self.Visible  == nil then self.Visible  = true  end
	
	self.Icon = self.Icon or "icon16/cross.png"
	self.Title = self.Title or "View"
	self.ToolTipText = nil
	
	GCompute.EventProvider (self)
	
	self.Container:SetView (self)
	self.Container:AddEventListener ("Removed", self:GetHashCode (),
		function ()
			self:DispatchEvent ("Removed")
		end
	)
end

function self:dtor ()
	if self:GetDocument () then
		self:SetDocument (nil)
	end
	
	self.Container:Remove ()
	
	if self.ViewManager then
		self.ViewManager:RemoveView (self)
	end
end

-- IDE
function self:GetDocumentManager ()
	if not self.IDE then return nil end
	return self.IDE:GetDocumentManager ()
end

function self:GetSerializerRegistry ()
	if not self.IDE then return nil end
	return self.IDE:GetSerializerRegistry ()
end

function self:GetViewManager ()
	return self.ViewManager
end

function self:GetIDE ()
	return self.IDE
end

function self:SetIDE (ide)
	self.IDE = ide
end

function self:SetViewManager (viewManager)
	self.ViewManager = viewManager
end

-- View
function self:CanClose ()
	return self.Closable
end

function self:CanHide ()
	return self.Hideable
end

function self:EnsureVisible ()
	if not self.Container then return end
	self.Container:EnsureVisible ()
end

function self:Focus ()
	if not self.Container:GetContents () then return end
	self.Container:GetContents ():Focus ()
end

function self:GetActionMap ()
	if not self.Container then return nil, nil end
	if not self.Container:GetContents () then return nil, nil end
	if type (self.Container:GetContents ().GetActionMap) ~= "function" then return nil, nil end
	return self.Container:GetContents ():GetActionMap ()
end

function self:GetIcon ()
	return self.Icon
end

function self:GetId ()
	return self.Id
end

function self:GetTitle ()
	return self.Title or ""
end

function self:GetToolTipText ()
	return self.ToolTipText
end

function self:GetType ()
	return self.__Type
end

function self:Select ()
	if not self.Container then return end
	self.Container:Select ()
end

function self:SetCanClose (closable)
	if self.Closable == closable then return end
	
	self.Closable = closable
	self:DispatchEvent ("CanCloseChanged", self.Closable)
end

function self:SetCanHide (hideable)
	if self.Hideable == hideable then return end
	
	self.Hideable = hideable
	self:DispatchEvent ("CanHideChanged", self.Hideable)
end

function self:SetIcon (icon)
	if self.Icon == icon then return end
	
	self.Icon = icon
	self:DispatchEvent ("IconChanged", self.Icon)
end

function self:SetId (id)
	self.Id = id
end

function self:SetTitle (title)
	if self.Title == title then return end
	
	self.Title = title
	self:DispatchEvent ("TitleChanged", self.Title)
end

function self:SetToolTipText (toolTipText)
	if self.ToolTipText == toolTipText then return end
	
	self.ToolTipText = toolTipText
	self:DispatchEvent ("ToolTipTextChanged", self.ToolTipText)
end

-- UI
function self:GetContainer ()
	return self.Container
end

function self:InvalidateLayout ()
	if not self.Container then return end
	self.Container:InvalidateLayout ()
end

function self:IsVisible ()
	return self.Visible
end

function self:Select ()
	if not self.Container then return end
	self.Container:Select ()
end

function self:SetVisible (visible)
	if self.Visible == visible then return self end
	
	self.Visible = visible
	self:DispatchEvent ("VisibleChanged", self.Visible)
	
	return self
end

-- Components
function self:CreateSavableProxy ()
	self.SavableProxy = self.SavableProxy or GCompute.SavableProxy ()
	return self.SavableProxy
end

function self:GetClipboardTarget ()
	return nil
end

function self:GetDocument ()
	return self.Document
end

function self:GetSavable ()
	return self.SavableProxy
end

function self:GetUndoRedoStack ()
	if not self.Document then return nil end
	return self.Document:GetUndoRedoStack ()
end

function self:SetDocument (document)
	if self.Document == document then return end
	
	local oldDocument = self.Document
	if oldDocument then
		oldDocument:RemoveEventListener ("Loaded", self:GetHashCode ())
		self:UnhookDocument (oldDocument)
		oldDocument:RemoveView (self)
	end
	self.Document = document
	if document then
		document:AddEventListener ("Loaded", self:GetHashCode (),
			function (_, reloaded)
				self:OnDocumentLoaded (document, reloaded)
			end
		)
		self:HookDocument (document)
		document:AddView (self)
	end
	if self.SavableProxy then
		self.SavableProxy:SetSavable (document)
	end
	
	self:OnDocumentChanged (oldDocument, document)
	self:DispatchEvent ("DocumentChanged", oldDocument, document)
end

-- Persistance
function self:LoadSession (inBuffer)
end

function self:SaveSession (outBuffer)
end

-- Event handlers
function self:OnDocumentChanged (oldDocument, document)
end

function self:OnDocumentLoaded (document, reloaded)
end

function self:HookDocument (document)
end

function self:UnhookDocument (document)
end