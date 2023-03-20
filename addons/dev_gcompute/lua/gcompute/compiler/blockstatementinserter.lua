local self = {}
GCompute.BlockStatementInserter = GCompute.MakeConstructor (self, GCompute.ASTVisitor)

--[[
	BlockStatementInserter
	
	1. Ensures that the body statement of all statements which can have one are Blocks
	   if the original body statement was a VariableDeclaration or FunctionDeclaration
]]

function self:ctor (compilationUnit)
	self.CompilationUnit = compilationUnit
	self.AST = self.CompilationUnit:GetAbstractSyntaxTree ()
end

function self:VisitStatement (statement)
end