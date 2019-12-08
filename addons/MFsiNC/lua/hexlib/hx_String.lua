--- === String === ---

function string.Random(len)
	local rnd = ""
	for i=1,( len or math.random(6,11) ) do
		local c = math.random(65,116)
		if c >= 91 and c <= 96 then
			c = c + 6
		end
		rnd = rnd..string.char(c)
	end
	return rnd
end



function ValidString(v)
	return isstring(v) and v != ""
end

local cachetbl = {}
local cachenums = {}
local wrapped = {}

function string.WordWrap(name, w, font)	-- not hex's necessarily, also stolen from prestige v1.5

	surface.SetFont(font or "RL18")

	local txw, height = surface.GetTextSize(name)

	if istable(w) then 

		if txw < table.GetWinningKey(w) then return name, {txw}, height end --no actions necessary
	else
		if txw < w then return name, {txw}, height end --no actions necessary
	end

	--check cache with width as table

	if cachetbl[name] and istable(w) then 
		local cch = cachetbl[name]
		
		local rettxt, retwids = false, false

		for final, tbl in pairs(cch) do 

			if tbl.w then 
				local ineq = false
				for k,wid in pairs(tbl.w) do 
					if wid ~= w[k] then ineq = true break end 
				end 
				if not ineq then rettxt = final retwids = tbl.widths break end
			end

		end 

		if rettxt then 
			return rettxt, retwids, height
		end 

	end
	
	if cachenums[w] and cachenums[w][name] then 
		return cachenums[w][name].text, cachenums[w][name].widths, height
	end

	local utflen, kk = utf8.len(name)
	local len = 0
	if kk then len = utflen else len = #name end

	local text = ""
	local ctxw = 0	--current text width
	local curline = 1

	local widths = {}

	local iter = utf8.codes(name)

	for i, char in iter do 

		local notalot = utflen - i <= 4

		if char==10 then --newline
			text = text .. "\n"
			widths[#widths+1] = ctxw																	
			ctxw = 0
			curline = curline + 1
			continue 
		end

		local char = utf8.char(char)
		text = text .. char
		ctxw = ctxw + surface.GetTextSize(char)

		local ww = w 	--current line's required width
		if istable(w) then ww = w[curline] or w[#w] or 600 end

		if ctxw > ww*0.8 then --attempt \n'ing nicely

			if char==" " and not notalot then 
				text = text .. "\n"	--hijack the space
				widths[#widths+1] = ctxw																	
				ctxw = 0
				curline = curline + 1
				continue
			end

		end

		if ctxw > ww*0.8 and utflen - i >= 2 then  --wrap asap

			for i2 = 0, 2 do 		
				if name[i+i2] == " " then continue end --disregard, it can still be done nicely
			end

			text = text .. "-\n"
			widths[#widths+1] = ctxw
			ctxw = 0
			curline = curline + 1

		end

		if ctxw > ww*0.95 then --you _HAVE_ to wrap it
			text = text .. "-\n"
			widths[#widths+1] = ctxw
			ctxw = 0
			curline = curline + 1
		end

	end

	if istable(w) then 
		cachetbl[name] = cachetbl[name] or {}
		local cch = cachetbl[name]
		widths[#widths + 1] = ctxw
		cch[text] = {w = w, widths = widths} 
	end

	if isnumber(w) then 
		cachenums[w] = cachenums[w] or {}
		local cch = cachenums[w]
		widths[#widths + 1] = ctxw
		cch[name] = {text = text, widths = widths}
	end 

	return text, widths, height
end

function string.GetBetween(str, tag, num)
	local pat = "%b" .. tag 
	local pat2 = tag[1] .. "(.+)" .. tag[2]

	local str = str 

	if num then 

		for i=1, 10000 do 

			local match = str:match(pat)
			if not match then return end

			if match then 
				if i ~= num then 
					str = str:gsub(match:PatternSafe(), "")
				else
					return match:match(pat2)
				end 
			end 
		end

	else 
		return str:match(pat):match(pat2)
	end
end
function string.TimeParse(time)

	local h = math.floor(time / 3600)
	local m = math.floor(time/60) - h*60
	local s = time - h*3600 - m*60

	return string.format("%.2d:%.2d:%.2d", h, m, s)

end


function string.YeetNewlines(str, also_spaces)
	str = str:gsub("\n", " ")
	str = str:gsub("\r", "")
	str = str:gsub("\t", " ")
	
	if also_spaces then
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
		str = str:gsub("  ", " ")
	end
	return str
end

function string.NiceTimeEx(Secs)
	if not Secs then Secs = 0 end
	if Secs < 0 then Secs = -Secs end
	
	local hours 	= math.floor(Secs / 3600)
	local minutes	= math.floor( (Secs / 60) % 60)
	Secs 			= math.floor(Secs % 60)
	
	return (
		(hours >= 1 	and "0"..hours..":" or "")..
		(minutes <= 9 	and "0"..minutes 	or minutes)..":"..
		(Secs <= 9 		and "0"..Secs 		or Secs)
	)
end


--- === string.ToBinary / string.FromBinary by RyanJGray === ---
local function toBits(num)
    local t = {}
    while num > 0 do
        rest = math.fmod(num, 2)
        t[ #t + 1 ] = rest
        num = ( num-rest ) / 2
    end
    return t
end

local function makeEight(str)
    return ( "0" ):rep( 8 - #str )..str
end

function string.ToBinary(str)
    local txt = ""

    for i=1, #str do
        txt = txt..makeEight( table.concat( toBits( string.byte( str:sub(i,i) ) ) ):reverse() )
    end

    return txt
end

function string.FromBinary(str)
    local txt2 = ""
    for k,v in pairs( str:Split("\n") ) do
        local q = 1
        for i=1, #v / 8 do
            txt2 = txt2..string.char( tonumber( v:sub(q, q + 7), 2 ) )
            q = q + 8
        end
    end

    return txt2
end





function string.FromVA(...)
	local Tab = {...}
	local Out = ""
	local Tot = select("#", ...)
	for k=1,Tot do
		Out = Out.."[["..tostring( Tab[k] ).."]]"..(k == Tot and "" or ", ")
	end
	return Out
end

local vowels = {
	["a"] = true, 
	["e"] = true,
	["i"] = true,
	["o"] = true, 
	["u"] = true,
}

function string.IsVowel(char)
	return (not not vowels[string.lower(char)])
end


