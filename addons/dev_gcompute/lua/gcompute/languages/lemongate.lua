--[[
	Lemon Gate
	
	Credit goes to Rusketh and Okar94
]]

local LANGUAGE = GCompute.Languages.Create ("Lemon Gate")
GCompute.LanguageDetector:AddPathPattern (LANGUAGE, "/lemongate/.*")

-- Lexer
LANGUAGE:GetTokenizer ()
	:AddCustomSymbols (GCompute.Lexing.TokenType.String, {"\"", "'"},
		function (code, offset)
			local quotationMark = string.sub (code, offset, offset)
			local searchStartOffset = offset + 1
			local backslashOffset = 0
			local quotationMarkOffset = 0
			while true do
				if backslashOffset and backslashOffset < searchStartOffset then
					backslashOffset = string.find (code, "\\", searchStartOffset, true)
				end
				if quotationMarkOffset and quotationMarkOffset < searchStartOffset then
					quotationMarkOffset = string.find (code, quotationMark, searchStartOffset, true)
				end
				
				if backslashOffset and quotationMarkOffset and backslashOffset > quotationMarkOffset then backslashOffset = nil end
				if not backslashOffset then
					if quotationMarkOffset then
						return string.sub (code, offset, quotationMarkOffset), quotationMarkOffset - offset + 1
					else
						return string.sub (code, offset), string.len (code) - offset + 1
					end
				end
				searchStartOffset = backslashOffset + 2
			end
		end
	)
	:AddCustomSymbol (GCompute.Lexing.TokenType.Comment, "/*",
		function (code, offset)
			local endOffset = string.find (code, "*/", offset + 2, true)
			if endOffset then
				return string.sub (code, offset, endOffset + 1), endOffset - offset + 2
			end
			return string.sub (code, offset), string.len (code) - offset + 1
		end
	)
	:AddPatternSymbol (GCompute.Lexing.TokenType.Comment,              "//[^\n\r]*")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Identifier,           "[a-zA-Z_][a-zA-Z0-9_]*")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "0b[01]+")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "0x[0-9a-fA-F]+")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+%.[0-9]*e[-+]?[0-9]+%.[0-9]*")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+%.[0-9]*e[-+]?[0-9]+")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+%.[0-9]*")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+e[-+]?[0-9]+%.[0-9]*")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+e[-+]?[0-9]+")
	:AddPatternSymbol (GCompute.Lexing.TokenType.Number,               "[0-9]+")
	:AddPlainSymbols  (GCompute.Lexing.TokenType.Operator,            {"##", "++", "--", "==", "!=", "<=", ">=", "<<=", ">>=", "+=", "-=", "*=", "/=", "^=", "||", "&&", "^^", ">>", "<<"})
	:AddPlainSymbols  (GCompute.Lexing.TokenType.MemberIndexer,       {".", ":"})
	:AddPlainSymbols  (GCompute.Lexing.TokenType.Operator,            {"!", "~", "#", "+", "-", "^", "&", "|", "*", "/", "=", "<", ">", "(", ")", "{", "}", "[", "]", "%", "?", ","})
	:AddPlainSymbol   (GCompute.Lexing.TokenType.StatementTerminator,  ";")
	:AddPlainSymbols  (GCompute.Lexing.TokenType.Newline,             {"\r\n", "\r", "\n"})
	:AddPatternSymbol (GCompute.Lexing.TokenType.Whitespace,           "[ \t]+")

LANGUAGE:GetKeywordClassifier ()
	:AddKeywords (GCompute.Lexing.KeywordType.Modifier, {"local", "global", "input", "output"})
	:AddKeywords (GCompute.Lexing.KeywordType.Control,  {"if", "else", "elseif", "while", "for", "foreach", "switch", "case", "default", "try", "catch"})
	:AddKeywords (GCompute.Lexing.KeywordType.Control,  {"break", "return", "continue", "throw"})
	:AddKeywords (GCompute.Lexing.KeywordType.DataType, {"function", "event"})
-- 	:AddKeywords (GCompute.Lexing.KeywordType.Constant, {"true", "false", "null"})

LANGUAGE:SetDirectiveCaseSensitivity (false)

LANGUAGE:LoadEditorHelper ("lemongate_editorhelper.lua")

LANGUAGE.WaitingNamespaces = GCompute.WeakKeyTable ()

function LANGUAGE:IsDataAvailable ()
	if not LemonGate then return false end
	
	if not LemonGate.TypeTable     then return false end
	if not LemonGate.FunctionTable then return false end
	if not LemonGate.OperatorTable then return false end
	if not LemonGate.EventsTable   then return false end
	return true
end

function LANGUAGE:RequestData (lemonGateNamespace)
	if self:IsDataAvailable () then return end
	if not LemonGate then return end
	
	if lemonGateNamespace then
		self.WaitingNamespaces [lemonGateNamespace] = true
	end
	
	RunConsoleCommand ("lemon_sync")
	
	timer.Create ("GCompute.LemonGate.DataCheck", 1, 0,
		function ()
			if not self:IsDataAvailable () then return end
			
			for lemonGateNamespace, _ in pairs (self.WaitingNamespaces) do
				lemonGateNamespace:ImportData ()
			end
			
			self:DispatchEvent ("NamespaceChanged")
			
			timer.Destroy ("GCompute.LemonGate.DataCheck")
		end
	)
	
	GCompute:AddEventListener ("Unloaded",
		function ()
			timer.Destroy ("GCompute.LemonGate.DataCheck")
		end
	)
end