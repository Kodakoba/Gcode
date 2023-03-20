local self = {}
self.__Type = "StaticMemberAccess"
GCompute.AST.StaticMemberAccess = GCompute.AST.MakeConstructor (self, GCompute.AST.Expression)

function self:ctor (leftExpression, name, typeArgumentList)
	self.LeftExpression = nil
	self.Name = name
	self.TypeArgumentList = nil
	
	self.RuntimeName = nil
	
	self:SetLeftExpression (leftExpression)
	self:SetTypeArgumentList (typeArgumentList)
	
	self.ResolutionResults = GCompute.ResolutionResults ()
	self.ResolutionResult  = nil
end

function self:ComputeMemoryUsage (memoryUsageReport)
	memoryUsageReport = memoryUsageReport or GCompute.MemoryUsageReport ()
	if memoryUsageReport:IsCounted (self) then return end
	
	memoryUsageReport:CreditTableStructure ("Syntax Trees", self)
	
	if self.LeftExpression then
		self.LeftExpression:ComputeMemoryUsage (memoryUsageReport)
	end
	if self.TypeArgumentList then
		self.TypeArgumentList:ComputeMemoryUsage (memoryUsageReport)
	end
	
	self.ResolutionResults:ComputeMemoryUsage (memoryUsageReport)
	return memoryUsageReport
end

function self:ExecuteAsAST (astRunner, state)
	-- State 0: Evaluate left
	-- State 1: Lookup member
	if state == 0 then
		-- Return to state 1
		astRunner:PushState (1)
		
		if self:GetLeftExpression () then
			-- Expression, state 0
			astRunner:PushNode (self:GetLeftExpression ())
			astRunner:PushState (0)
		else
			astRunner:PushValue (__)
		end
	elseif state == 1 then
		-- Discard StaticMemberAccess
		astRunner:PopNode ()
		
		astRunner:PushValue (astRunner:PopValue () [self.RuntimeName])
	end
end

function self:GetChildEnumerator ()
	local i = 0
	return function ()
		i = i + 1
		if i == 1 then
			return self.LeftExpression
		elseif i == 2 then
			return self.TypeArgumentList
		end
		return nil
	end
end

function self:GetLeftExpression ()
	return self.LeftExpression
end

function self:GetName ()
	return self.Name
end

function self:GetResolutionResult ()
	return self.ResolutionResult or self.__base.GetResolutionResult (self)
end

function self:GetRuntimeName ()
	return self.RuntimeName
end

function self:GetTypeArgumentList ()
	return self.TypeArgumentList
end

function self:SetLeftExpression (leftExpression)
	self.LeftExpression = leftExpression
	if self.LeftExpression then self.LeftExpression:SetParent (self) end
end

function self:SetName (name)
	self.Name = name
end

function self:SetResolutionResult (resolutionResult)
	self.ResolutionResult = resolutionResult
	return self
end

function self:SetResolutionResults (resolutionResults)
	self.ResolutionResults = resolutionResults
	return self
end

function self:SetRuntimeName (runtimeName)
	self.RuntimeName = runtimeName
end

function self:SetTypeArgumentList (typeArgumentList)
	self.TypeArgumentList = typeArgumentList
	if self.TypeArgumentList then self.TypeArgumentList:SetParent (self) end
end

function self:ToString ()
	if self.TypeArgumentList then
		return (self.LeftExpression and (self.LeftExpression:ToString () .. ".") or "") .. (self.Name or "[Nothing]") .. " " .. self.TypeArgumentList:ToString ()
	end
	return (self.LeftExpression and (self.LeftExpression:ToString () .. ".") or "")  .. (self.Name or "[Nothing]")
end

function self:ToTypeNode ()
	return self
end

function self:Visit (astVisitor, ...)
	if self:GetLeftExpression () then
		self:SetLeftExpression (self:GetLeftExpression ():Visit (astVisitor, ...) or self:GetLeftExpression ())
	end
	if self:GetTypeArgumentList () then
		self:SetTypeArgumentList (self:GetTypeArgumentList ():Visit (astVisitor, ...) or self:GetTypeArgumentList ())
	end
	

	return astVisitor:VisitExpression (self, ...)
end