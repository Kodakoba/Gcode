local self = {}
GCompute.VariableReadPlan = GCompute.MakeConstructor (self)

function self:ctor ()
	self.VariableReadType = GCompute.VariableReadType.None
	
	self.CachedLeft = nil
	self.RuntimeName = nil
end

function self:GetRuntimeName ()
	return self.RuntimeName
end

function self:GetVariableReadType ()
	return self.VariableReadType
end

function self:SetRuntimeName (runtimeName)
	self.RuntimeName = runtimeName
end

function self:SetVariableReadType (VariableReadType)
	self.VariableReadType = VariableReadType
end

function self:ExecuteAsAST (astRunner, node, state)
	-- Discard Identifier
	astRunner:PopNode ()
	
	if self.VariableReadType == GCompute.AssignmentType.NamespaceMember then
		if not self.CachedLeft then
			self.CachedLeft = __
		end
		
		astRunner:PushValue (self.CachedLeft [self.RuntimeName])
	elseif self.VariableReadType == GCompute.AssignmentType.Local then
		astRunner:PushValue (executionContext.TopStackFrame [self.RuntimeName])
	else
		error ("VariableReadPlan:ExecuteAsAST : Unhandled VariableReadType (" .. GCompute.VariableReadType [self.VariableReadType] .. ") on node: " .. node:ToString () .. "\n")
	end
end