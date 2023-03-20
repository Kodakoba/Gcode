local self, info = GCompute.IDE.ViewTypes:CreateType ("Image")
self.Icon = "icon16/image.png"
info:SetDocumentType ("ImageDocument")

function self:ctor (container)
	self:CreateSavableProxy ()
	
	self.HTMLPanel = vgui.Create ("GHTML", container)
	
	self.SavableProxy:AddEventListener ("Reloaded",
		function (_)
			extension = self.Document:GetResource () and self.Document:GetResource ():GetExtension () or "png"
			extension = string.lower (extension)
			self.HTMLPanel:OpenURL ("data:image/" .. extension .. ";base64," .. util.Base64Encode (self.Document:GetData ()))
		end
	)
end

function self:dtor ()
	if not self.HTMLPanel then return end
	if not self.HTMLPanel:IsValid () then return end
	self.HTMLPanel:Remove ()
	self.HTMLPanel = nil
end

-- Persistance
function self:LoadSession (inBuffer)
	local title = inBuffer:String ()
	
	local document = self:GetDocumentManager ():GetDocumentById (inBuffer:String ())
	if document then
		self:SetDocument (document)
	end
	self:SetTitle (title)
end

function self:SaveSession (outBuffer)
	outBuffer:String (self:GetTitle ())
	outBuffer:String (self:GetDocument () and self:GetDocument ():GetId () or "")
end

-- Internal, do not call
function self:CreateFileChangeNotificationBar ()
	if self.FileChangeNotificationBar then return end
	self.FileChangeNotificationBar = vgui.Create ("GComputeFileChangeNotificationBar", self:GetContainer ())
	self.FileChangeNotificationBar:SetVisible (false)
	self.FileChangeNotificationBar:AddEventListener ("VisibleChanged",
		function ()
			self:InvalidateLayout ()
		end
	)
	self.FileChangeNotificationBar:AddEventListener ("ReloadRequested",
		function ()
			self:GetDocument ():Reload (self:GetSerializerRegistry ())
		end
	)
	self:InvalidateLayout ()
end

-- Event handlers
function self:OnDocumentChanged (oldDocument, document)
	if not document then return end
	
	self:OnDocumentLoaded (document, false)
end

function self:OnDocumentLoaded (document, reloaded)
	extension = self.Document:GetResource () and self.Document:GetResource ():GetExtension () or "png"
	extension = string.lower (extension)
	self.HTMLPanel:OpenURL ("data:image/" .. extension .. ";base64," .. (util.Base64Encode (self.Document:GetData () or "") or ""))
end

function self:PerformLayout (w, h)
	local y = 0
	
	if self.FileChangeNotificationBar and
	   self.FileChangeNotificationBar:IsVisible () then
		self.FileChangeNotificationBar:SetPos (0, y)
		self.FileChangeNotificationBar:SetWide (w)
		y = y + self.FileChangeNotificationBar:GetTall ()
	end
	
	self.HTMLPanel:SetPos (0, y)
	self.HTMLPanel:SetSize (w, h - y)
end