local self = {}
GCompute.ASTRunner = GCompute.MakeConstructor (self)

function self:ctor ()
	self.NodeStack  = GCompute.Containers.Stack ()
	self.StateStack = GCompute.Containers.Stack ()
	self.ValueStack = GCompute.Containers.Stack ()
	
	self.YieldEnabled = true
end

-- Stacks
function self:PeekNode (offset)
	return self.NodeStack:Peek (offset)
end

function self:PeekState (offset)
	return self.StateStack:Peek (offset)
end

function self:PeekValue (offset)
	return self.ValueStack:Peek (offset)
end

function self:PopNode ()
	-- print (string.rep (" ", self.NodeStack.Count - 1) .. "POP: " .. self.NodeStack.Top:ToString ())
	return self.NodeStack:Pop ()
end

function self:PopState ()
	return self.StateStack:Pop ()
end

function self:PopValue ()
	-- print (string.rep (" ", self.ValueStack.Count - 1) .. "POP: " .. tostring (self.ValueStack.Top))
	return self.ValueStack:Pop ()
end

function self:PushNode (astNode)
	-- print (string.rep (" ", self.NodeStack.Count) .. "PUSH: " .. astNode:ToString ())
	self.NodeStack:Push (astNode)
end

function self:PushState (state)
	self.StateStack:Push (state)
end

function self:PushValue (value)
	-- print (string.rep (" ", self.ValueStack.Count) .. "PUSH: " .. tostring (value))
	self.ValueStack:Push (value)
end

-- Execution
function self:Execute ()
	self:Resume ()
end

function self:Resume ()
	for i = 1, (self:IsYieldEnabled () and 1000 or math.huge) do
		local topNode = self.NodeStack.Top
		if not topNode then
			self:PopNode ()
			return
		end
		local state = self.StateStack:Pop ()
		-- print (("    "):rep (self.NodeStack.Count) .. (topNode and topNode:GetNodeType () or "nil") .. ":" .. (state or 0))
		if topNode.ExecuteAsAST then
			topNode:ExecuteAsAST (self, state)
		else
			ErrorNoHalt ("ASTRunner: Unhandled node type " .. topNode:GetNodeType () .. "\n")
			self.NodeStack:Pop ()
		end
	end
	
	if self:IsYieldEnabled () then
		self:Yield ()
	end
end

-- Yielding
function self:IsYieldEnabled ()
	return self.YieldEnabled
end

function self:SetYieldEnabled (yieldEnabled)
	self.YieldEnabled = yieldEnabled
end

function self:Yield ()
	executionContext:PushResumeFunction (
		function ()
			self:Resume ()
		end
	)
end