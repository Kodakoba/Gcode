local self = {}
GCompute.AliasDefinition = GCompute.MakeConstructor (self, GCompute.ObjectDefinition)

--- @param name The name of this alias
-- @param objectName The object this alias points to, as a string
function self:ctor (name, objectName)
	self.DeferredObjectResolution = nil
	self.ObjectName = nil
	self.Object = nil
	
	self.AliasedType = nil
	
	if type (objectName) == "string" then
		self.DeferredObjectResolution = GCompute.DeferredObjectResolution (objectName)
		self.ObjectName = objectName
	elseif objectName:IsDeferredObjectResolution () then
		self.DeferredObjectResolution = objectName
		self.ObjectName = objectName:GetName ()
		self.Object = objectName:IsResolved () and objectName:GetObject () or nil
	elseif objectName:IsObjectDefinition () or
	       objectName:IsType () then
		self.ObjectName = objectName:GetFullName ()
		self.Object = objectName
	else
		GCompute.Error ("AliasDefinition constructed with unknown object.")
	end
end

-- Alias
function self:GetObject ()
	if not self:IsResolved () then
		GCompute.Error ("AliasDefinition:GetObject : " .. self:ToString () .. " has not been resolved yet.")
	end
	if self.Object and
	   self.Object:IsOverloadedClass () and
	   self.Object:GetClassCount () == 1 then
		return self.Object:GetClass (1)
	end
	return self.Object
end

function self:IsResolved ()
	return self.Object and true or false
end

local unwrapAlias = {}
--- Returns the target of this AliasDefinition
-- @return The target of this AliasDefinition
function self:UnwrapAlias ()
	if unwrapAlias [self] then
		GCompute.Error ("AliasDefinition:UnwrapAlias : Cycle in alias " .. self:ToString () .. " detected.")
		return nil
	end

	if not self:IsResolved () then
		GCompute.Error ("AliasDefinition:UnwrapAlias : This alias has not been resolved yet (" .. self:ToString () .. ")!")
		return nil
	end
	
	local ret = self:GetObject ()
	if ret and ret:IsAlias () then
		unwrapAlias [self] = true
		ret = ret:UnwrapAlias ()
		unwrapAlias [self] = nil
	end
	return ret
end

-- Definition
function self:CreateRuntimeObject ()
	return {}
end

function self:GetType ()
	if self.Object then
		return self.Object:GetType ()
	end
	GCompute.Error ("AliasDefinition:GetType : This AliasDefinition is unresolved (" .. self:GetFullName () .. ", " .. self:ToString () .. ").")
end

--- Gets whether this object is an alias for another object
-- @return A boolean indicating whether this object is an alias for another object
function self:IsAlias ()
	return true
end

function self:ResolveAlias (objectResolver, compilerMessageSink)
	compilerMessageSink = compilerMessageSink or GCompute.DefaultCompilerMessageSink
	
	if self:IsResolved () then return end
	
	local deferredObjectResolution = self.DeferredObjectResolution
	if deferredObjectResolution:IsResolved () then return end
	
	deferredObjectResolution:SetLocalNamespace (self:GetDeclaringObject ())
	deferredObjectResolution:Resolve (objectResolver)
	if deferredObjectResolution:IsFailedResolution () then
		deferredObjectResolution:GetAST ():GetMessages ():PipeToCompilerMessageSink (compilerMessageSink)
	else
		self.Object = deferredObjectResolution:GetObject ()
		if self.Object:IsObjectDefinition () then
			self.Object = self.Object:UnwrapAlias ()
		end
	end
end

function self:ResolveTypes (objectResolver, compilerMessageSink)
end

function self:ToString ()
	local aliasDefinition = "[Alias] "
	aliasDefinition = aliasDefinition .. (self:GetName () or "[Unnamed]")
	aliasDefinition = aliasDefinition .. " = "
	if self.Object then
		aliasDefinition = aliasDefinition .. self.ObjectName
	else
		aliasDefinition = aliasDefinition .. self.DeferredObjectResolution:ToString ()
	end
	return aliasDefinition
end

function self:ToType ()
	if not self.AliasedType then
		local innerType = self:UnwrapAlias ():ToType ()
		self.AliasedType = GCompute.AliasedType (self, innerType)
	end
	return self.AliasedType
end

function self:Visit (namespaceVisitor, ...)
	namespaceVisitor:VisitAlias (self, ...)
end