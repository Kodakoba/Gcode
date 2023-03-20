local self = {}
GCompute.CodeEditor.SyntaxHighlighter = GCompute.MakeConstructor (self, GCompute.CodeEditor.ITokenSink)

--[[
	Events:
		HighlightingFinished ()
			Fired when syntax highlighting has finished.
		HighlightingProgress (linesProcessed, totalLines)
			Fired when syntax highlighting has advanced.
		HighlightingStarted ()
			Fired when syntax highlighting has started.
		LineHighlighted (lineNumber, tokenArray)
			Fired when a line has been syntax highlighted.
]]

function self:ctor (document)
	self.Document = document
	
	self.Enabled = true
	
	self.Language = nil
	self.LanguageName = nil
	self.EditorHelper = nil
	
	self.LastThinkTime = CurTime ()
	
	self.InProgress = true
	self.CurrentLine = 0
	self.CurrentLineTokens = {}
	self.TokenizationStartTime = SysTime ()
	
	self.Document:AddEventListener ("LanguageChanged", self:GetHashCode (),
		function (_, oldLanguage, language)
			self:HandleLanguageChange (language)
		end
	)
	self.Document:AddEventListener ("LinesShifted", self:GetHashCode (),
		function (_, startLine, endLine, shift)
			self:InvalidateLine (startLine)
			self:InvalidateLine (startLine + shift)
		end
	)
	self.Document:AddEventListener ("TextCleared", self:GetHashCode (),
		function (_)
			self:InvalidateLine (0)
		end
	)
	self.Document:AddEventListener ("TextDeleted", self:GetHashCode (),
		function (_, deletionStart)
			self:InvalidateLine (deletionStart:GetLine ())
		end
	)
	self.Document:AddEventListener ("TextInserted", self:GetHashCode (),
		function (_, insertionLocation)
			self:InvalidateLine (insertionLocation:GetLine ())
		end
	)
	
	self:HandleLanguageChange (self.Document:GetLanguage ())
	
	GCompute.EventProvider (self)
end

function self:dtor ()
	self.Document:RemoveEventListener ("LanguageChanged", self:GetHashCode ())
	self.Document:RemoveEventListener ("TextChanged",     self:GetHashCode ())
end

function self:ForceHighlightLine (lineNumber)
	if not self:IsEnabled () then return end
	if self.CurrentLine > lineNumber then return end
	
	if not self.EditorHelper then return end
	
	local previousLine = self.Document:GetLine (lineNumber - 1)
	local previousOutState = previousLine and previousLine.TokenizationOutState
	local line = self.Document:GetLine (lineNumber)
	
	line.TokenizationLanguage = self.LanguageName
	line.TokenizationInState  = previousOutState or {}
	line.TokenizationOutState = {}
	self.CurrentLineTokens = {}
	self.EditorHelper:TokenizeLine (line:GetText (), self, line.TokenizationInState, line.TokenizationOutState)
	line.Tokens = self.CurrentLineTokens
	
	self:ProcessLineTokens (line, line.Tokens)
		
	self:DispatchEvent ("LineHighlighted", lineNumber, line.Tokens)
	
	if self.CurrentLine == lineNumber then
		self.CurrentLine = self.CurrentLine + 1
		self:DispatchEvent ("HighlightingProgress", self.CurrentLine, self.Document:GetLineCount ())
	end
end

function self:GetDocument ()
	return self.Document
end

function self:GetEditorHelper ()
	return self.EditorHelper
end

function self:GetLanguage ()
	return self.Language
end

function self:GetProgress ()
	if self.Document:GetLineCount () == 0 then return 1 end
	return self.CurrentLine / self.Document:GetLineCount ()
end

function self:IsEnabled ()
	return self.Enabled
end

function self:SetEnabled (enabled)
	self.Enabled = enabled
end

function self:Think ()
	if self.LastThinkTime == CurTime () then return end
	self.LastThinkTime = CurTime ()
	
	if not self.EditorHelper then return end
	
	if self:IsEnabled () then
		if not self.InProgress then return end
		
		local startTime = SysTime ()
		
		local previousLine = self.Document:GetLine (self.CurrentLine - 1)
		local previousOutState = previousLine and previousLine.TokenizationOutState
		local line
		
		while self.CurrentLine < self.Document:GetLineCount () do
			if SysTime () - startTime > 0.010 then break end
			
			line = self.Document:GetLine (self.CurrentLine)
			
			if line.TokenizationLanguage ~= self.LanguageName or
			   not self:StateEquals (line.TokenizationInState, previousOutState) or
			   not line.TokenizationOutState then
				line.TokenizationLanguage = self.LanguageName
				line.TokenizationInState  = previousOutState or {}
				line.TokenizationOutState = {}
				self.CurrentLineTokens = {}
				self.EditorHelper:TokenizeLine (line:GetText (), self, line.TokenizationInState, line.TokenizationOutState)
				line.Tokens = self.CurrentLineTokens
				
				self:ProcessLineTokens (line, line.Tokens)
				
				self:DispatchEvent ("LineHighlighted", self.CurrentLine, line.Tokens)
			end
			
			previousLine = line
			previousOutState = line.TokenizationOutState
			self.CurrentLine = self.CurrentLine + 1
		end
		
		self:DispatchEvent ("HighlightingProgress", self.CurrentLine, self.Document:GetLineCount ())
		
		if self.CurrentLine >= self.Document:GetLineCount () then
			self.InProgress = false
			
			self:DispatchEvent ("HighlightingFinished")
			self.TokenizationStartTime = nil
		end
	end
end

-- ITokenSink
function self:Token (startCharacter, endCharacter, tokenType, tokenValue)
	if endCharacter <= 0 then return end
	
	local token =
	{
		Previous       = self.CurrentLineTokens [#self.CurrentLineTokens],
		Next           = nil,
		
		StartCharacter = startCharacter,
		EndCharacter   = endCharacter,
		TokenType      = tokenType,
		Value          = tokenValue
	}
	if #self.CurrentLineTokens > 0 then
		self.CurrentLineTokens [#self.CurrentLineTokens].Next = token
	end
	self.CurrentLineTokens [#self.CurrentLineTokens + 1] = token
end

function self:GetTokenColor (tokenType)
	if tokenType == GCompute.Lexing.TokenType.String then
		return GLib.Colors.Gray
	elseif tokenType == GCompute.Lexing.TokenType.Number then
		return GLib.Colors.SandyBrown
	elseif tokenType == GCompute.Lexing.TokenType.Comment then
		return GLib.Colors.ForestGreen
	elseif tokenType == GCompute.Lexing.TokenType.Keyword then
		return GLib.Colors.RoyalBlue
	elseif tokenType == GCompute.Lexing.TokenType.Preprocessor then
		return GLib.Colors.Wheat
	elseif tokenType == GCompute.Lexing.TokenType.Identifier then
		return GLib.Colors.PaleGreen
	elseif tokenType == GCompute.Lexing.TokenType.Unknown then
		return GLib.Colors.Tomato
	end
	return GLib.Colors.White
end

-- Internal, do not call
function self:HandleLanguageChange (language)
	self.Language = language
	self.LanguageName = self.Language and self.Language:GetName () or nil
	self.EditorHelper = self.Language and self.Language:GetEditorHelper ()
	
	self:InvalidateLine (0)
end

function self:InvalidateLine (line)
	if line < 0 then return end
	if line >= self.Document:GetLineCount () then return end
	
	if not self.InProgress then
		self.InProgress = true
		self.TokenizationStartTime = SysTime ()
		self:DispatchEvent ("HighlightingStarted")
	end
	self.Document:GetLine (line).TokenizationOutState = nil
	self.CurrentLine = math.min (self.CurrentLine, line)
end

function self:ProcessLineTokens (line, tokens)
	local startCharacter
	local endCharacter
	local previousTokenType
	local tokenType
	for _, token in ipairs (tokens) do
		local startCharacter = token.StartCharacter
		local endCharacter   = token.EndCharacter
		local tokenType      = token.TokenType
		local color = self:GetTokenColor (previousTokenType == GCompute.Lexing.TokenType.Preprocessor and previousTokenType or token.TokenType)
		
		line:SetColor (color, startCharacter, endCharacter)
		line:SetAttribute ("Token",     token,     startCharacter, endCharacter)
		line:SetAttribute ("TokenType", tokenType, startCharacter, endCharacter)
		
		previousTokenType = tokenType
	end
end

function self:StateEquals (s1, s2)
	if s1 == s2 then return true end
	if not s1 and s2     then return false end
	if     s1 and not s2 then return false end
	
	for k, v in pairs (s1) do
		if s2 [k] ~= v then return false end
	end
	for k, v in pairs (s2) do
		if s1 [k] ~= v then return false end
	end
	return true
end