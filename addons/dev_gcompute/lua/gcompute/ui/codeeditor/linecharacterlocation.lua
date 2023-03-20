local self = {}
GCompute.CodeEditor.LineCharacterLocation = GCompute.MakeConstructor (self)

function self:ctor (line, character)
	self.Line      = 0
	self.Character = 0
	
	if type (line) == "table" then
		self:Copy (line)
	else
		self:SetLine (line or self.Line)
		self:SetCharacter (character or self.Character)
	end
end

function self:Clone (clone)
	clone = clone or self.__ictor ()
	
	clone:Copy (self)
	
	return clone
end

function self:Copy (source)
	self.Line      = source:GetLine ()      or 0
	self.Character = source:GetCharacter () or 0
	
	return self
end

function self:AddCharacters (characters)
	local lineCharacterLocation     = GCompute.CodeEditor.lineCharacterLocation ()
	lineCharacterLocation.Line      = self.Line
	lineCharacterLocation.Character = math.max (0, self.Character + characters)
	
	return lineCharacterLocation
end

function self:GetCharacter ()
	return self.Character
end

function self:GetLine ()
	return self.Line
end

function self:IsLineCharacterLocation ()
	return true
end

function self:IsLineColumnLocation ()
	return false
end

function self:SetCharacter (character)
	self.Character = character
end

function self:SetLine (line)
	self.Line = line
end

function self:ToString ()
	return "Line " .. tostring (self.Line) .. ", char " .. tostring (self.Character)
end

function self:__eq (lineCharacterLocation)
	return self.Line      == lineCharacterLocation.Line and
	       self.Character == lineCharacterLocation.Character
end

function self:__lt (lineCharacterLocation)
	if self.Line < lineCharacterLocation.Line then return true end
	if self.Line > lineCharacterLocation.Line then return false end
	if self.Character < lineCharacterLocation.Character then return true end
	return false
end

function self:__le (lineCharacterLocation)
	if self.Line < lineCharacterLocation.Line then return true end
	if self.Line > lineCharacterLocation.Line then return false end
	if self.Character <= lineCharacterLocation.Character then return true end
	return false
end

function self:__add (lineCharacterLocation)
	return GCompute.CodeEditor.LineCharacterLocation (
		self.Line      + lineCharacterLocation.Line,
		self.Character + lineCharacterLocation.Character
	)
end

function self:__sub (lineCharacterLocation)
	return GCompute.CodeEditor.LineCharacterLocation (
		self.Line      - lineCharacterLocation.Line,
		self.Character - lineCharacterLocation.Character
	)
end