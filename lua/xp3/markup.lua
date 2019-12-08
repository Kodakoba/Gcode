if true then return end 
local type = class.type

local Base = {}

function Base:__ctor(markup, buffer, data)
	self.markup = markup
	self.data = data
end

function Base:__dtor() end

function Base:PerformLayout(markup, buffer, data) end
function Base:Think(markup, buffer, data) end
function Base:Draw(markup, buffer, data) end
function Base:ModifyBuffer(markup, buffer, data) end
function Base:TagStart(markup, buffer, data) end
function Base:TagEnd(markup, buffer, data) end
function Base:StartChar(markup, buffer, data, char, cx, cy, cw, ch, font) end
function Base:EndChar(markup, buffer, data, char, cx, cy, cw, ch, font) end
function Base:StartWord(markup, buffer, data) end
function Base:EndWord(markup, buffer, data) end

class:register("BaseChunk", Base, nil, true)

local Text = {}

local spaces =
"[" ..
"\x20\xC2\xA0\xE1\x9A\x80\xE1\xA0\x8E\xE2\x80\x80\xE2\x80\x81\xE2\x80\x82" ..
"\xE2\x80\x83\xE2\x80\x84\xE2\x80\x85\xE2\x80\x86\xE2\x80\x87\xE2\x80\x88" ..
"\xE2\x80\x89\xE2\x80\x8A\xE2\x80\x8B\xE2\x80\xAF\xE2\x81\x9F\xE3\x80\x80" ..
"\xEF\xBB\xBF]"

local f = "DermaDefault"
surface.__SetFont = surface.__SetFont or surface.SetFont

function surface.SetFont(font)
	surface.__SetFont(font)
	f = font
end

function surface.GetFont()
	return f
end

local cche = {}

surface.__GetTextSize = surface.__GetTextSize or surface.GetTextSize
function surface.GetTextSize(t)
	if cche[f] and cche[f][t] then
		return cche[f][t][1], cche[f][t][2]
	end
	cche[f] = cche[f] or {}
	local w, h = surface.__GetTextSize(t)
	cche[f][t] = {w, h}
	return w, h
end

surface.__CreateFont = surface.__CreateFont or surface.CreateFont

function surface.CreateFont(font, ...)
	surface.__CreateFont(font, ...)
	cche[font] = nil
end

function surface.IsValidFont(...)
	return not not pcall(surface.SetFont, ...)
end

local fallbackFont = "DermaDefault"
function surface.SetFontFallback(font)
	if surface.IsValidFont(font) then
		surface.SetFont(font)
	else
		surface.SetFont(fallbackFont)
	end
end


local function env()
	local tick = 0
	return {
		sin = math.sin,
		cos = math.cos,
		tan = math.tan,
		sinh = math.sinh,
		cosh = math.cosh,
		tanh = math.tanh,
		rand = math.random,
		pi = math.pi,
		log = math.log,
		log10 = math.log10,
		time = CurTime,
		t = CurTime,
		realtime = RealTime,
		rt = RealTime,
		tick = function()
			local o = tick
			tick = tick + 1
			return o / 100
		end,
	}
end

local Expression = {}

function Expression:__ctor(expression, filter)
	self.expression = expression
	self.resfilter = filter
end

function Expression:Compile()
	local env, expression = env(), self.expression
	local ch = expression:match("[^=1234567890%-%+%*/%%%^%(%)%.A-z%s]")
	if ch then
		return "expression:1: invalid character " .. ch
	end

	local compiled = CompileString("return (" .. expression .. ")", "expression", false)
	if isstring(compiled) then
		compiled = CompileString(expression, "expression", false)
	end
	if isstring(compiled) then
		return compiled
	end
	if not isfunction(compiled) then
		return "expression:1: unknown error"
	end
	setfenv(compiled, env)
	self.compiled = compiled
end

function Expression:Run(resfilter)
	if not self.compiled then return end
	local ok, why = pcall(self.compiled)
	if not ok then
		return false, why
	end
	if self.resfilter then why = self.resfilter(why) end
	return why
end

class:register("Expression", Expression)

class:makeFunction("Expression")

local IGNORE = function() end
local function parse(self, str, ply, tags, shouldEscape, stopFunc, addFunc, addTagFunc)
	local stopFunc = stopFunc or IGNORE
	local addFunc = addFunc or IGNORE
	local addTagFunc = addTagFunc or IGNORE
	local makeTagObjFunc = makeTagObjFunc or IGNORE

	local cur = ""
	local inTag
	local activeTags = {}
	local escaped

	for _, s in pairs(utf_totable(str)) do
		if s == "<" and not inTag then
			inTag = true
			if cur ~= "" then
				addFunc(self, cur)
				cur = ""
			end
		continue end

		if s == ">" and inTag then
			inTag = nil
			--cur = cur:lower()
			if cur:sub(1, 1) == "/" then
				cur = cur:sub(2)

				if shouldEscape and escaped and cur == "noparse" then
					escaped = false
					cur = ""
					continue
				elseif not escaped and activeTags[cur] and #activeTags[cur] > 0 then
					stopFunc(self, activeTags[cur][#activeTags[cur]])
					table.remove(activeTags[cur], #activeTags[cur])
					cur = ""
					continue
				else
					addFunc(self, "</" .. cur .. ">")
					cur = ""
					continue
				end
			else
				local tag, args = cur:match("(.-)=(.+)")
				if not tag then
					tag, args = cur, ""
				end
				local tagobject = tags[tag]

				if shouldEscape and not escaped and tag == "noparse" then
					escaped = true
					cur = ""
					continue
				elseif escaped or not tagobject then
					addFunc(self, "<" .. cur .. ">")
					cur = ""
					continue
				end

				args = chathud:DoArgs(args, tagobject.args)
				if isentity(ply) and ply:IsPlayer() and hook.Run("CanPlayerUseTag", ply, tag, args) == false then
					addFunc(self, "<" .. cur .. ">")
					cur = ""
					continue
				end

				local t = addTagFunc(self, tagobject, args)
				activeTags[tag] = activeTags[tag] or {}
				activeTags[tag][#activeTags[tag] + 1] = t or {}
			end

			cur = ""
		continue end

		cur = cur .. s
	end

	if cur ~= "" or inTag then
		local var = cur
		if inTag then
			var = "<" .. var
		end

		addFunc(self, var)
	end

end

local function evalPreTags(data)
	local str = ""
	local buffer = ""
	local shouldEdit = false

	parse(_, data, ply, chathud.PreTags, false,
	function(_, tag)
		local content = tag.func(buffer, tag.data)
		str = str .. content

		shouldEdit = false
		buffer = ""
	end,
	function(_, content)
		buffer = buffer .. content
	end,
	function(_, tagobject, args)
		if not shouldEdit and #buffer > 0 then
			str = str .. buffer
			buffer = ""
		end

		local newargs = {} -- Pretags don't get to evaluate their arguments more than once
		for _, arg in pairs(args) do
			newargs[#newargs + 1] = arg()
		end

		local t = {}
		t.data = newargs
		t.func = tagobject.func

		shouldEdit = true

		return t
	end)

	return str .. buffer
end
--[[
function Markup:Parse(data, ply, noPreTags, noShortcuts)
	local str = ""
	if noPreTags then
		str = data
	else
		str = evalPreTags(data)
	end

	if not noShortcuts then
		str = str:gsub("%:([0-9A-z%-_]-)%:", function(a)
			local sh = chathud.Shortcuts[a]
			if sh then
				return sh
			end
		end)
	end

	parse(self, str, ply, chathud.Tags, true,
	self.AddTagStopper,
	self.AddString,
	function(_, tagobject, args)
		local t = table.Copy(tagobject)
		t.data = args

		return self:AddTag(t)
	end)
end

local cache = {}
function markup_quickParse(data, ply)
	if cache[data] then
		return cache[data]
	end

	local str = ""
	if noPreTags then
		str = data
	else
		str = evalPreTags(data)
	end

	local ret = ""

	parse(nil, str, ply, chathud.Tags, true,
	nil,
	function(_, content)
		ret = ret .. content
	end,
	nil)

	cache[data] = ret

	return ret
end


class:register("Markup", Markup)
class:makeFunction("Markup")
]]