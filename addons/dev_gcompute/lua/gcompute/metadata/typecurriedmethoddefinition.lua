local self = {}
GCompute.TypeCurriedMethodDefinition = GCompute.MakeConstructor (self, GCompute.MethodDefinition)

function self:ctor (name, parameterList, typeParameterList)
end

function self:InitializeTypeCurriedDefinition ()
	local typeParametricDefinition = self:GetTypeParametricDefinition ()
	
	local substitutionMap = GCompute.SubstitutionMap ()
	for i = 1, self.TypeArgumentList:GetArgumentCount () do
		local parameterName = self.TypeParameterList:GetParameterName (i)
		local typeParameter = typeParametricDefinition:GetNamespace ():GetMember (parameterName):ToType ()
		substitutionMap:Add (typeParameter, self.TypeArgumentList:GetArgument (i))
	end
	
	self.ParameterList = typeParametricDefinition:GetParameterList ():SubstituteTypeParameters (substitutionMap)
	
	self.ReturnType = typeParametricDefinition:GetReturnType ()
	self.ReturnType = self.ReturnType:SubstituteTypeParameters (substitutionMap) or self.ReturnType
	
	self:SetNativeString (typeParametricDefinition:GetNativeString ())
	self:SetNativeFunction (typeParametricDefinition:GetNativeFunction ())
	self:SetTypeCurryerFunction (typeParametricDefinition:GetTypeCurryerFunction ())
	if self:GetTypeCurryerFunction () then
		self:GetTypeCurryerFunction () (self, self:GetTypeArgumentList ())
	end
	
	self:BuildNamespace ()
end