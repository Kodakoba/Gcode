local self = {}
GCompute.PropertyDefinition = GCompute.MakeConstructor (self, GCompute.ObjectDefinition)

function self:ctor (name, type)
	self.Type   = nil
	self.Getter = nil
	self.Setter = nil
	
	self:SetType (type)
end

function self:AddGetter ()
	if not self.Getter then
		self.Getter = GCompute.PropertyAccessorDefinition (self:GetName ())
			:SetReturnType (self:GetType ())
			:SetMemberVisibility (self:GetMemberVisibility ())
		self:GetDeclaringObject ():GetNamespace ():SetupMemberHierarchy (self.Getter)
	end
	return self.Getter
end

function self:AddSetter ()
	if not self.Setter then
		self.Setter = GCompute.PropertyAccessorDefinition (self:GetName (), { { self:GetType (), "value" } })
			:SetMemberVisibility (self:GetMemberVisibility ())
		self:GetDeclaringObject ():GetNamespace ():SetupMemberHierarchy (self.Setter)
	end
	return self.Setter
end

function self:GetGetter ()
	return self.Getter
end

function self:GetSetter ()
	return self.Setter
end

function self:SetType (type)
	self.Type = GCompute.ToDeferredTypeResolution (type, self:GetDeclaringObject ())
	if self.Getter then self.Getter:SetReturnType (self.Type) end
	if self.Setter then self.Setter:GetParameterList ():SetParameterType (1, self.Type) end
	return self
end

-- Definition
function self:GetDisplayText ()
	local displayText = ""
	displayText = displayText .. (self:GetType () and self:GetType ():GetRelativeName (self) or "[Nothing]")
	displayText = displayText .. " " .. self:GetShortName () .. " { "
	if self.Getter then
		displayText = displayText .. "get; "
	end
	if self.Setter then
		displayText = displayText .. "set; "
	end
	displayText = displayText .. "}"
	return displayText
end

function self:GetType ()
	return self.Type
end

function self:IsProperty ()
	return true
end

function self:ResolveTypes (objectResolver, compilerMessageSink)
	compilerMessageSink = compilerMessageSink or GCompute.DefaultCompilerMessageSink
	
	if self.Type and self.Type:IsDeferredObjectResolution () then
		self.Type:Resolve (objectResolver)
		if self.Type:IsFailedResolution () then
			self.Type:GetAST ():GetMessages ():PipeToCompilerMessageSink (compilerMessageSink)
			self.Type = GCompute.ErrorType ()
		else
			self.Type = self.Type:GetObject ():ToType ()
		end
	end
	
	if self.Getter then
		self.Getter:ResolveTypes (objectResolver, compilerMessageSink)
	end
	if self.Setter then
		self.Setter:ResolveTypes (objectResolver, compilerMessageSink)
	end
end

function self:ToString ()
	return self:GetDisplayText ()
end

function self:Visit (namespaceVisitor, ...)
	namespaceVisitor:VisitProperty (self, ...)
	if self.Getter then
		self.Getter:Visit (namespaceVisitor, ...)
	end
	if self.Setter then
		self.Setter:Visit (namespaceVisitor, ...)
	end
end