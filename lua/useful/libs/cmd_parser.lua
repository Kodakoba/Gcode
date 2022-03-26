
local cmdPattern = "^[%.!/](%S+)"
local sep = "[%s,]"
local quote = "[\"']"
local function toCommand(s)
	local cmd = s:match(cmdPattern)
	return cmd
end

local function toArgs(s, cmd)
	local args = s:sub(1 + #cmd + 1)	-- 1 due to 1-indexed, +1 for command symbol
	args = args:match("%s*(.+)")

	local retArgs = {}
	if not args then return retArgs end

	local inQuote = false
	local curArg = ""
	local escape = false

	for i=1, #args do
		local char = args:sub(i, i)

		if char:match(sep) and not inQuote and #curArg > 0 then
			retArgs[#retArgs + 1] = curArg
			curArg = ""
			escape = false
			inQuote = false
			goto cont
		end

		if char:match(quote) and not escape then
			inQuote = not inQuote
			if #curArg > 0 then
				retArgs[#retArgs + 1] = curArg
				curArg = ""
				escape = false
			end
			goto cont
		end

		if char == "\\" and not escape then
			escape = true
			goto cont
		end

		curArg = curArg .. char
		escape = false

		::cont::
	end

	if #curArg > 0 then
		retArgs[#retArgs + 1] = curArg
	end
	return retArgs
end


local input = ".cock"
local cmd = toCommand(input)
if cmd then
	local args = toArgs(input, cmd)

	print("cmd = '" .. cmd .. "'")
	p(args)
else
	print("no commands")
end
