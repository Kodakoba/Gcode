file.CreateDir("emoticon_cache")

local col = Color(255, 200, 0, 255)
local Msg = function(...) MsgC(col, ...)  end
local surface = surface 

local utflen = function(s)
	return (utf8.len(s:sub(#s, #s-1)) == 1 and #(s:sub(#s, #s-1) == 2)) and 2 or 1
end

local Run = function(func, ...)	--kinda like eval
	if isfunction(func) then 
		return func(...)
	end
end

local Emote = chathud.Emote 

chathud.oldShadow = chathud.oldShadow or false

--[[
	This chat is a piece of shit. Don't poke around for too long or you'll gouge your fucking eyes out.
	Good luck.
]]

chathud.FFZChannels = {
	"pajlada",
	"1poseidon3",
	"forsen",
	"benignmc",
	"clay0m"
}

chathud.Shortcuts = {}
chathud.Items = chathud.Items or {}

chathud.x = 0.84 * 64

local ChatHUDYPos = ScrH() - (0.84 * 200) - (0.84 * 140)
chathud.y = ChatHUDYPos

chathud.W = 500

local blacklist = {
	["0"] = true,
	["1"] = true,
}
file.CreateDir("emoticon_cache")
file.CreateDir("emoticon_cache/twitch")
file.CreateDir("emoticon_cache/ffz")

--This is shitcode written when i was starting out lua, pls skip

function chathud.CreateFFZShortcuts(update)


	local function ReadChannelInfo(filename, chan)

		filename = string.lower(filename)
		Msg("[ChatHUD]: FFZ data file found! Creating shortcuts... \n")

		if file.Exists(filename, "DATA") and not update then

			local data = file.Read(filename, "DATA")
			local d = util.JSONToTable(data)
			if not d then print(#data) return ErrorNoHalt("ChatHUD: Failed to read existing FFZ Emote cache.\n") end

			local name

			for name1, v in pairs(d) do
				--if isnumber(v) then continue end
				if name1=="sets" then
					for k,_ in pairs(v) do --i hate it as much as you do
						name=_
					end
				continue
				end 
			end
			if not name then return end

			if istable(name["emoticons"]) then
				for num, cont in pairs(name["emoticons"]) do
					if (cont.name) and not chathud.Shortcuts[cont.name] and not blacklist[cont.name] then 
						local url
						if cont.urls[4] then url=cont.urls[4] elseif cont.urls[2] then url=cont.urls[2] else url=cont.urls[1] end

						chathud.Emotes[cont.display_name or cont.name] = Emote(cont.display_name or cont.name, "https:" .. url)
																			:AddToCollection("FFZ")
																			:SetStatic(true)
																			:AddShortcut()
					end

				end
			end
		end
	end

	local function DownloadChannelInfo(chan)

	 	local chan = string.lower(chan)
		local filename = "emoticon_cache/ffz_global_emotes_" .. chan .. ".dat"
		Msg("[ChatHUD]: FFZ data for channel "..chan.." not found! Downloading... \n")

		http.Fetch("https://api.frankerfacez.com/v1/room/"..tostring(chan), function(b)
				local d = util.JSONToTable(b)
				if not d then return ErrorNoHalt("ChatHUD: Failed to updated FFZ Emote cache.\n") end

				for name1, v in pairs(d) do
					--if isnumber(v) then continue end

					if name1=="sets" then
						for k,_ in pairs(v) do --i hate it as much as you do
							name=_
						end
						continue
					end 
				end

				if istable(name["emoticons"]) then
					for num, cont in pairs(name["emoticons"]) do
						if (cont.name) and not chathud.Shortcuts[cont.name] and not blacklist[cont.name] then 
							local url

							if cont.urls[4] then url=cont.urls[4] elseif cont.urls[2] then url=cont.urls[2] else url=cont.urls[1] end
							chathud.Emotes[cont.display_name or cont.name] = Emote(cont.display_name or cont.name, "https:" .. url)
																				:AddToCollection("FFZ")
																				:SetStatic(true)
																				:AddShortcut()
						end

					end
				end

				if not file.Exists(filename, "DATA") then
					file.Write(filename, b .. " ")
				else
					file.Append(filename, b .. " " )
				end

			end, 

		function() 
			print("send help") 
		end)
		
	end



	local found = file.Find("emoticon_cache/ffz_global_emotes_*.dat", "DATA")

	for k,chan in pairs(chathud.FFZChannels) do
		if table.HasValue(found,"ffz_global_emotes_"..string.lower(chan)..".dat") then 
			ReadChannelInfo("emoticon_cache/ffz_global_emotes_"..string.lower(chan)..".dat", string.lower(chan))
		else
			DownloadChannelInfo(string.lower(chan))
		end
	end

end


--[[
	Twitch emotes shortcuts scrapped because Twitch changed API versions and i CBA to rewrite it.
	All of those emotes mostly suck anyways.

	"This api version is gone."
]]

chathud.markups = {}

local function env(msg)
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
		st = msg.SendTime,
	}
end

local badlua = {
	["while"] = true,
	["for"] = true,
	["do"] = true,
	["end"] = true,
	["if"] = true
}

local function CompileExpression(str, msg)
	local env = env(msg)

	local ch = str:match("[^=1234567890%-%+%*/%%%^%(%)%.A-z%s]")
	
	if ch then 	--disallow strings and string methods ( e.g. ("Stinky poopy"):rep(999) )
				--fun fact; the string library may not be in the envinroment but string methods will still work!
		return "expression: invalid character " .. ch
	end

	for word in str:gmatch("(.-)%s") do 
		if badlua[word] then return "simple expressions please" end
	end

	local compiled = CompileString("return (" .. str .. ")", "expression", false)
	
	if isstring(compiled) then
		compiled = CompileString(str, "expression", false)
	end

	if isstring(compiled) then
		return compiled
	end

	if not isfunction(compiled) then
		return "expression:1: unknown error"
	end
	setfenv(compiled, env)

	return compiled
end


--[[

	PepeLaugh YOU DONT EVEN KNOWN WHAT YOU ARE GOING INTO PepeLaugh

	Wear eye protection.

]]

local tagptrn = "(.-)=(.+)"
local tagendptrn = "/(.+)"
local spacearg = "[%s]*(.-)[%s]*,"	--match arg from a tag and sanitize spaces and potential commas
local lastarg = "[%s]*(.+)[%s]*,*"	--match last arg in a tag

--[[
	Returns a string without tags + draw queue for the tags (tag -> text -> tag -> text ...)
]]

function ParseTags(str)

	local tags = {}
	
	local prevtagwhere

	for s1 in string.gmatch(str, ":(.-):") do --shortcuts, then tags 

		if chathud.Shortcuts[s1] then 
			str = str:gsub((":%s:"):format(s1), chathud.Shortcuts[s1], 1)
		end
		
	end

	for s1 in string.gmatch( str, "%b<>" ) do
		local tagcont = s1:GetBetween("<>")

		if not tagcont then continue end

		local starts = str:find(s1, 1, true)

		

		local tag, argsstr = tagcont:match(tagptrn)

		local chTag = chathud.TagTable[tag]

		if not chTag then 
			local isend = tagcont:match(tagendptrn)
			if not isend or not chathud.TagTable[isend] then print("no such tag:", tag, isend) continue end

			for k,v in ipairs(table.Reverse(tags)) do
				if not istable(v) then continue end  
				if v.tag == isend and not v.ends and not v.ender then 
					--create an ender tag, which will disable tag at k
					v.ends = starts 
					str = str:gsub(s1:PatternSafe(), "", 1)

					local key = #tags + 1

					if prevtagwhere then 
						tags[key] = str:sub(prevtagwhere, starts+utflen(str)-2)	--if ender, put text first ender later
						key = key + 1
					end

					tags[key] = {
						tag = isend, 
						ender = true, 
						ends = v.realkey,	--ends tag with key v.realkey
						realkey = key
					}
					
					prevtagwhere = starts--+1

					break
				end 
			end
			continue
		end

		local info = {
			SendTime = CurTime(),
		}

		if not prevtagwhere then 
			tags[#tags + 1] = str:sub(1, starts-utflen(str))
		end

		local args = {}

		for argtmp in string.gmatch(argsstr, ".-,") do 
			local arg = argtmp:match(spacearg)

			argsstr = argsstr:gsub(argtmp:PatternSafe(), "", 1)

			local exp = arg:match("%[(.+)%]") 

			if exp then 

				local func = CompileExpression(exp, info)

				if isstring(func) then 
					print("Expression error: " .. func)
					continue
				end 

				args[#args + 1] = func 
				continue
			end

			local num = #args + 1

			if not chTag.args[num] then break end 

			local typ = chTag.args[num].type
			if not chathud.TagTypes[typ] then print("Unknown argument type! ", typ) break end 

			local ret = chathud.TagTypes[typ](arg)	

			if ret then args[#args + 1] = ret end --if conversion to type succeeded
		end 

		local key = #tags + 1

		local lastarg = argsstr:match(lastarg)

		if lastarg then  

			local exp = lastarg:match("%[(.+)%]") 

			if exp then 

				local func = CompileExpression(exp, info)

				if isstring(func) then 
					print("Expression error: " .. func)
				end 

				args[#args + 1] = func 
				
			else
				args[#args + 1] = lastarg 
			end

		end

		str = str:gsub(s1:PatternSafe(), "", 1)

		if prevtagwhere then 

			tags[key] = str:sub(prevtagwhere+utflen(str)-1, starts-1)
			key = key + 1

		end


		for k,v in pairs(chTag.args) do 
			if isnumber(args[k]) then
				if v.min then 
					args[k] = math.max(args[k], v.min)
				end 
				if v.max then 
					args[k] = math.min(args[k], v.max)
				end
			end

			if not args[k] then 
				args[k] = v.default 
			end 

		end

		tags[key] = {
			tag = tag, 
			args = args,
			starts = starts,
			realkey = key --for ender to keep track due to table reversing
		}

		prevtagwhere = starts
	end

	tags[#tags + 1] = string.sub(str, (prevtagwhere and prevtagwhere+utflen(str)-1) or 1, #str)


	return str, tags
end

function chathud:AddMarkup()
	
end

function chathud:CleanupOldMarkups()
	
end

local consoleColor = Color(106, 90, 205, 255)
chathud.History = {}
chathud.HistNum = 0

local names = {}

function chathud:AddText(...)

	local cont = {...}

	local time = CurTime()
	local nw = 0

	

	local msgstarted = false 
	local entparsed = false 
	local hasentity = false 

	local name = ""	--sender name

	local retcont = {}

	local fulltxt = ""
	local curtext = ""

	local wrappedtxt = ""


	for k,v in ipairs(cont) do

		--[[ 
			Parse entity name. 
			Usually the sender, except on very rare occasions. 
		]]

		if isentity(v) then 
			fulltxt = fulltxt .. ((v.Nick and v:Nick()) or "Console")
			hasentity = true
			continue
		end

		if not isstring(v) then continue end 

		fulltxt = fulltxt .. v
	end


	local curwidth = 0

	local merged = {} --final table, containing everything 

	for k,v in ipairs(cont) do 

		--[[ 
			Parse entity name and color.  
		]]

		if isentity(v) then 
			local col = GAMEMODE.GetTeamColor and GAMEMODE:GetTeamColor(v)

			merged[#merged + 1] = col 

			local n = (v.Nick and v:Nick()) or 
			(IsValid(v) and 
				(v.GetName and v:GetName()) or 
				(v.GetClass and v:GetClass())
			) 
			or "Console"

			names[v], nw = string.WordWrap2(n, chathud.W, "CH_Name")
			curwidth = curwidth + nw
			merged[#merged + 1] = n

			name = name .. names[v]
			entparsed = true 

			continue
		end

		if IsTag(v) then 
			local tag = {}

			tag.tag = v.Name
			tag.args = v.Args 
			tag.starts = #curtext
			tag.realkey = #merged + 1

			merged[#merged + 1] = tag
		end

		--[[
			Tag-parse the string and merge content table and tag table while also word-wrapping them.
		]]

		if isstring(v) then

			curtext = curtext .. v

			local untagged, tags = ParseTags(v)

			surface.SetFont("CH_Text")
			

			for k2,tg in pairs(tags) do 

				if isstring(tg) then
					local tw, th = surface.GetTextSize(tg)
	
					local str, newwid = string.WordWrap2(tg, {chathud.W - curwidth, chathud.W})

					curwidth = curwidth + (newwid or tw)

					wrappedtxt = wrappedtxt .. str
					merged[#merged + 1] = str
					continue 
				end

				if istable(tg) then 	--tag
					merged[#merged + 1] = tg
				end
			end

				
		end

		if IsColor(v) then 
			merged[#merged + 1] = v 
		end
	end

	local ignore = {}

	contents = untagged

	local key = #self.History + 1
	self.History[key] = {
		t = time,	--time(for history time tracking)
		a = 255,	--alpha(for history fadeout)
		c = merged,	--contents(text+colors+tags to show)

		name = name,	--sender name
		namelen = utf8.len(name),

		fulltxt = fulltxt,	--just the text
		wrappedtxt = wrappedtxt,

		tags = {},		--tags tbl which will be filled in
		buffer = buffer,	--buffer to use
		realkey = key,
	}

	return self.History[key]
end

function chathud:Think()

end

function chathud:PerformLayout()
	
end

function chathud:TagPanic()
	for _, markup in pairs(self.markups) do
		markup:TagPanic(false)
	end
end

surface.CreateFont("CH_Text", {
        font = "Roboto",
        size = 22,
        weight = 400,
})

surface.CreateFont("CH_Name", {
    font = "Titillium Web SemiBold",
    size = 28,
    weight = 400,
})

surface.CreateFont("CH_NameShadow", {
    font = "Titillium Web SemiBold",
    size = 28,
    weight = 400,
    blursize = 3
})

surface.CreateFont("CH_TextShadow", {
        font = "Roboto",
        size = 22,
        weight = 400,
        blursize = 3,

})

local matrix = Matrix()

chathud.CharH = 22


local function DrawText(txt, buffer, y, x, a)
	local y = y

	local xo, yo = unpack(buffer.translate or {0, 0})

	local font = buffer.font or "CH_Text"

	local col = buffer.fgColor or Color(255, 255, 255)

	local amtoflines = 0
	local lines = {}
	local h = 22

	for s in string.gmatch(txt, "(.-)\n") do 

		surface.SetFont( font .. "Shadow")

		surface.SetTextColor( ColorAlpha(Color(0,0,0), a) )

		for i=1, 2 do
			surface.SetTextPos(buffer.x + i, buffer.y + i )
			surface.DrawText(s)
			if addText then
				surface.DrawText(addText)
			end
		end

		local tx, ty = surface.GetTextSize(s)

		surface.SetFont(font)

		surface.SetTextColor(ColorAlpha(col, a))

		surface.SetTextPos(buffer.x, buffer.y)

		surface.DrawText(s)

		buffer.y = buffer.y + ty
		buffer.x = x
		h = h + ty

		txt = txt:gsub(s:PatternSafe() .. "\n", "", 1)

	end

	surface.SetFont( font .. "Shadow")

	surface.SetTextColor( ColorAlpha(Color(0,0,0), a) )

	for i=1, 2 do
		surface.SetTextPos(buffer.x + i, buffer.y + i )
		surface.DrawText(txt)
		if addText then
			surface.DrawText(addText)
		end
	end

	local tx, ty = surface.GetTextSize(txt)

	surface.SetFont(font)
	

	surface.SetTextColor(ColorAlpha(col, a))

	surface.SetTextPos(buffer.x, buffer.y)

	surface.DrawText(txt)

	buffer.x = buffer.x + tx
	return h
end


local frstY = 0
local frstnum = 0

chathud.Filter = true 

function chathud:Draw()
	local x, y = self.x, self.y 
	local chh = chathud.CharH 

	local isfirst = true 

	if chathud.Filter then 
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	end


	local ok, err = pcall(function()
		for histnum,dat in SortedPairs(self.History, true) do

			if dat.t - CurTime() < -5 or y < (self.y-220) then 
				local mult = 120

				if y < (self.y-220) then 
					mult = 500
				end

				dat.a = dat.a - FrameTime() * mult
				if dat.a <= 0 or y < 0 or (histnum < 20 and #self.History > 20) then 

					table.remove(self.History, histnum)
					return
				end
			end

			local tags = dat.tags

			local name = dat.name
			local nlen = dat.namelen

			local text = dat.text
			

			local cols = {}
				
			if isfirst then 
				--if frstnum == histnum then 
					--frstY = L(frstY, 0,)
				--else 
					frstnum = histnum 
					frstY = 0 
				--end 
			end
			--[[

				DrawQueue types:

				Text: {string = true, cont = "I am the content.", san = true/false} // san means if the string should be sanitized("#VAC_ConnectionRefusedDetail")
				Tag: {tag = true, args = {}, TagStart = func, ModifyBuffer = func, TagEnd = func}
				Color: {color = true, cont = Color}

			]]

			local drawq = {}
			local tagfuncs = {}
			if not dat.DrawQ then

				--[[
					Create a Draw Queue table, which will define & parse objects and the order they will be executed in.
					This includes tags, texts, colors and entities.
				]]

				for k,v in ipairs(dat.c) do 

					--Parse color in data:

					if IsColor(v) then 
						drawq[#drawq+1] = {color = true, cont = v}
						continue
					end

					--[[
						Parse string in data.
						Handles shitty language exploits("#VAC_ConnectionRefusedDetail")
					]]

					if isstring(v) then 

						if drawq[#drawq] and drawq[#drawq].string then 

							local str = v

							if drawq[#drawq].san then 

								str = v:sub(2)

								if language.GetPhrase(sub) == sub then 
									drawq[#drawq].san = nil 
								end 

							end

							drawq[#drawq].cont = drawq[#drawq].cont .. str

						else 

							local sub = string.sub(v, 2)
							local san = false

							if v[1] == "#" and language.GetPhrase(sub) ~= sub then
								san = true
							end

							if san then
								drawq[#drawq+1] = {cont = "#", string = true, san = true}
								drawq[#drawq+1] = {cont = sub, string = true, san = true}
							else 
								drawq[#drawq+1] = {cont = v, string = true}
							end
						
						end

						continue
					end

					
					if istable(v) then 

						--TODO: Tag add to draw 
						local func
						local tag = {} --for storing data within the tag's function

						if v.ender then 
							func = function(buf)
								Run(tagfuncs[v.ends].TagEnd, tag, tag, buf, Run(tagfuncs[v.ends].getargs))
							end

							drawq[#drawq+1] = {name = v.tag, func = func, ender = v.ends}
						else 
							local chTag = chathud.TagTable[v.tag]
							if not chTag then print("no such tag", v.tag) continue end --???

							local function getargs()

								local args = {}
								v.errs = v.errs or {}

								for key, val in pairs(v.args) do 
									if v.errs[key] then continue end 
									if not chTag.args[key] then continue end 

									local arg = chTag.args[key]

									local default = arg.default
									local typ = arg.type

									local min, max = arg.min, arg.max

									if isfunction(val) then 
										local ok, ret = pcall(val)
										if not ok then print("Tag error!", ret) v.errs[key] = true continue end 

										if not ret then 

											if not tag.ComplainedAboutReturning then
												print("Tag function must return a value! Defaulting to", val)
												tag.ComplainedAboutReturning = true
											end

											args[key] = default

										elseif ret then
											ret = chathud.TagTypes[typ](ret) or default

											if min then 
												ret = math.max(min, ret)
											end 

											if max then 
												ret = math.min(max, ret)
											end

											args[key] = ret 

										end

									else 
										val = chathud.TagTypes[typ](val) or default

										if min then 
											val = math.max(min, val)
										end 

										if max then 
											val = math.min(max, val)
										end

										args[key] = val 

									end
								end 

								return args
							end

							func = function(buf)
								local args = getargs()

								local tagbuf = {}	--buffer for the tag to store vars in

								Run(chTag.TagStart, tagbuf, buf, buf, args)
								Run(chTag.Draw, tagbuf, buf, buf, args)
								Run(chTag.ModifyBuffer, tagbuf, buf, buf, args)
								

							end 

							drawq[#drawq+1] = {name = v.tag, func = func, ModifyBuffer = chTag.ModifyBuffer, TagEnd = chTag.TagEnd, ends = v.ends, taginfo = tag, getargs = getargs}
							tagfuncs[v.realkey] = {TagStart = chTag.TagStart, ModifyBuffer = chTag.ModifyBuffer, TagEnd = chTag.TagEnd}
						end
						--drawq[#drawq+1] = v
						continue
					end

					--functions are ignored

				end
				dat.DrawQ = drawq 
			end

			--[[
				Draw queue was created; now actually paint
			]]
			drawq = table.Copy(dat.DrawQ)

			local lastseg = 0
			

			local a = dat.a

			local buffer = {}

			local amtoflines = 0

			for s in string.gmatch(dat.wrappedtxt, "(.-)\n") do 
				amtoflines = amtoflines + 1 
			end

			local txh = chh + amtoflines * chh 

			buffer.y = y - txh
			buffer.x = x 
			buffer.h = txh 
			buffer.w = 0
			
			local buf = buffer

			local fakebuf = {}

			fakebuf.y = buffer.y
			fakebuf.x = buffer.x
			fakebuf.h = buffer.h 
			fakebuf.w = buffer.w

			for k,v in ipairs(drawq) do 
				if v.func and v.ModifyBuffer then 

					local needh = v.ModifyBuffer(v.taginfo, fakebuf, fakebuf, v.getargs(), true)

				end 
			end

			local yoff = 0	--offset for the next msg, in case thats ever needed

			if fakebuf.h ~= buffer.h then 
				buffer.h = math.max(buffer.h, fakebuf.h)
				buffer.y = fakebuf.y - buffer.h/2
			end

			buffer.y = buffer.y
			local oldh = buffer.h
			for k,v in ipairs(drawq) do 

				if v.string then 
					DrawText(v.cont, buf, y, x, a)
					continue
				end

				if v.color then 
					buffer.fgColor = v.cont 
					continue
				end

				if v.func then
					buffer.fgColor = ColorAlpha(buffer.fgColor, a)
					v.func(buffer)
				end
			end

			for k,v in ipairs(drawq) do 
				if not v.ender and not v.ends and v.func and v.TagEnd then 
					v.TagEnd(buf, buf, buffer, v.getargs and v.getargs())
				end
			end

			y = y - buffer.h

		end

	end) --End PCall
	
	if chathud.Filter then 
		render.PopFilterMag()
		render.PopFilterMin()
	end

	if not ok then 
		errorf("[ChatHUD] Error during rendering! %s", err)
	end

end

-------------------------

local emoticon_cache = {}
local busy = {}

local function MakeCache(filename, emoticon)
	local mat = Material("data/" .. string.lower(filename), "noclamp smooth")
	filename=string.lower(filename)
	emoticon_cache[emoticon or string.StripExtension(string.GetFileFromFilename(filename))] = mat

end

local Mcche = {}

local function MaterialCache(a, b)
	a = a:lower()
	if Mcche[a] then return Mcche[a] end
	local m = Material(a, b)
	Mcche[a] = m
	return m
end

local dec
do
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	function dec(data)
		data = string.gsub(data, "[^" .. b .. "=]", "")
		return data:gsub(".", function(x)
			if x == "=" then return "" end
			local r, f = "", b:find(x) - 1
			for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0") end
			return r
		end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
			if #x ~= 8 then return "" end
			local c = 0
			for i = 1,8 do c = c + (x:sub(i,i) == "1" and 2 ^ (8 - i) or 0) end
			return string.char(c)
		end)
	end
end

function chathud:GetSteamEmoticon(emoticon)
	emoticon = emoticon:gsub(":",""):Trim()
	if emoticon_cache[emoticon] then
		return emoticon_cache[emoticon]
	end
	if busy[emoticon] then
		return false
	end
	if file.Exists("emoticon_cache/" .. emoticon .. ".png", "DATA") then
		MakeCache("emoticon_cache/" .. emoticon .. ".png", emoticon)
	return emoticon_cache[emoticon] or false end
	Msg"ChatHUD " print("Downloading emoticon " .. emoticon)
	http.Fetch("http://steamcommunity-a.akamaihd.net/economy/emoticonhover/:" .. emoticon .. ":	", function(body, len, headers, code)
		if code == 200 then
			if body == "" then
				Msg"ChatHUD " print("Server returned OK but empty response")
			return end
			Msg"ChatHUD " print("Download OK")
			local whole = body
			body = body:match("src=\"data:image/png;base64,(.-)\"")
			if not body then Msg"ChatHUD " print("ERROR! (no body)", whole) return end
			local b64 = body
			body = dec(body)
			if not body then Msg"ChatHUD " print("ERROR! (not b64)", b64) return end
			file.Write("emoticon_cache/" .. emoticon .. ".png", body)
			MakeCache("emoticon_cache/" .. emoticon .. ".png", emoticon)
		else
			Msg"ChatHUD " print("Download failure. Code: " .. code)
		end
	end)
	busy[emoticon] = true
	return false
end

function chathud:GetFFZEmoticon(emoticon)
	if emoticon_cache[emoticon] then
		return emoticon_cache[emoticon]
	end
	if busy[emoticon] then
		return false
	end
	if file.Exists("emoticon_cache/ffz/" .. emoticon, "DATA") then
		MakeCache("emoticon_cache/ffz/" .. emoticon, emoticon)
	return emoticon_cache[emoticon] or false end
	Msg"ChatHUD " print("Downloading FFZ emoticon https://cdn.frankerfacez.com/" .. emoticon)
	http.Fetch("https://cdn.frankerfacez.com/" .. emoticon, function(body, len, headers, code)
		if code == 200 then
			if body == "" then
				Msg"ChatHUD " print("Server returned OK but empty response")
			return end
			Msg"ChatHUD " print("Download OK")
			file.Write("emoticon_cache/ffz/" .. string.lower(emoticon) , body)
			MakeCache("emoticon_cache/ffz/" .. emoticon , emoticon)
		else
			Msg"ChatHUD " print("Download failure. Code: " .. code)
		end
	end, function() print("why emote dead wtf????") end)
	busy[emoticon] = true
	return false
end

emote_json = emote_json
emote_data = emote_data

local failed = false 
local forced = false 


local function ParseEmotes(js)
	emote_json = js
	emote_data = util.JSONToTable(emote_json)

	--[[
	collections:
		{	
			collection = "collection name",
			emote_data = {
				1. names of animated emotes
				2. names of static emotes
			}
		},
		{
			...
		}
	]]

	local url = "https://vaati.net/Gachi/emotes/%s.png"

	for _, collection in pairs(emote_data) do
		local colname = collection.collection

		local coldesc = collection.collectiondescription or chathud.CollectionDescriptions[colname]
		local colnicename = collection.collectionname or chathud.CollectionNames[colname]

		Emotes.Collections[colname] = Emotes.Collections[colname] or Emotes.Collection(colname, coldesc)
		local col = Emotes.Collections[colname]

		col	:SetDescription(coldesc)
			:SetNiceName(colnicename)

		local data = collection.data

		for k,v in ipairs(data[1]) do 
			chathud.Emotes[v] = Emote(v, url:format(v))
									:SetAnimated(true)
									:AddToCollection("Animated")
									:AddToCollection(colname)
									:AddShortcut()
		end

		for k,v in ipairs(data[2]) do 
			chathud.Emotes[v] = Emote(v, url:format(v))
									:SetStatic(true)
									:AddToCollection("Static")
									:AddToCollection(colname)
									:AddShortcut()
		end

	end

	if forced then
		for k,v in pairs(emote_data) do 
			MoarPanelsMats[k] = nil 
		end
		MsgC(Color(100, 220, 100), "[ChatHUD] Loaded emote data successfully! Also unloaded cached emotes.\n")
	elseif failed then 
		MsgC(Color(100, 220, 100), "[ChatHUD] Loaded cached emote data successfully!\n\n")
	else
		MsgC(Color(100, 220, 100), "[ChatHUD] Loaded emote data successfully!\n")
	end

	
	
	return emote_data
end

function UpdateEmotes()
	if failed and not file.Exists("emoticon_cache/emote_info.dat", "DATA") and not forced then 
		MsgC(Color(200, 50, 50), "[ChatHUD] Failed to update emote data and failed to load cached emote data, since it doesn't exist.\n") 
		return 
	end 

	if failed and file.Exists("emoticon_cache/emote_info.dat", "DATA") then 
		local data = file.Read("emoticon_cache/emote_info.dat", "DATA")
		ParseEmotes(js)
		MsgC(Color(220, 220, 10), "[ChatHUD] Loaded cached emote data. Keep in mind it may be outdated.\n")
		return
	end
	
	MsgC(Color(100, 220, 100), "\n[ChatHUD] Loading new emote data...\n")

	hdl.DownloadFile("https://vaati.net/Gachi/emotes/emotes_list.dat", "-emoticon_cache/emote_info.dat", function(fn, body)
		if body:find("404 -") then error("Emotes list 404'd!") return end
		ParseEmotes(body)

		forced = false	
		failed = false

	end, function() 
		failed = true 
		forced = false
		MsgC(Color(250, 55, 55), "\n[ChatHUD] Failed to get emote data!\n")

		if file.Exists("emoticon_cache/emote_info.dat", "DATA") then 
			local data = file.Read("emoticon_cache/emote_info.dat", "DATA")
			MsgC(Color(220, 220, 10), "[ChatHUD] We'll use cached emote data. Keep in mind, it may be outdated.\n")
			ParseEmotes(data)
		else
			MsgC(Color(200, 50, 50), "[ChatHUD] You don't have any cached emote data, so emotes will be pretty much disabled.\nYou can try doing emotes_update to re-attempt fetching data.\n") 
		end 


	end, true)
end

hook.Add("HUDPaint", "ChatHUDEmotes", function() 
	hook.Remove("HUDPaint", "ChatHUDEmotes")

	timer.Simple(10, UpdateEmotes) 
	chathud.CreateFFZShortcuts()
end)

function DeleteEmotes()
	if not emote_data then print("No emotes data to use!") return end 
	for k,v in pairs(chathud.Emotes) do 
		if not v:GetName() then continue end

		local name = ("hdl/%s"):format(v:GetName())
		

		if file.Exists(name .. ".png", "DATA") then 
			file.Delete(name .. ".png")
			file.Delete(name .. "_info.png")
		end

		MoarPanelsMats[v:GetName() .. ".png"] = nil
		MoarPanelsMats[v:GetName()] = nil
	end

end
concommand.Add("emotes_update", function() failed = false forced = true UpdateEmotes() end)
concommand.Add("emotes_clearemotes", function() DeleteEmotes() end)

function chathud:GetEmoticon(emoticon)
	if not chathud.Emotes then return false end 

	local emote = chathud.Emotes[emoticon]
	if not emote then return false end --emote doesnt exist 

	return emote:GetURL()
end

function chathud:GetTwitchEmoticon(emoticon)
	if emoticon_cache[emoticon] then
		return emoticon_cache[emoticon]
	end
	if busy[emoticon] then
		return false
	end
	if file.Exists("emoticon_cache/twitch/" .. emoticon .. ".png", "DATA") then
		MakeCache("emoticon_cache/twitch/" .. emoticon .. ".png", emoticon)
	return emoticon_cache[emoticon] or false end
	Msg"ChatHUD " print("Downloading emoticon " .. emoticon)
	http.Fetch("https://static-cdn.jtvnw.net/emoticons/v1/" .. emoticon .. "/3.0", function(body, len, headers, code)
		if code == 200 then
			if body == "" then
				Msg"ChatHUD " print("Server returned OK but empty response")
			return end
			Msg"ChatHUD " print("Download OK")
			file.Write("emoticon_cache/twitch/" .. emoticon .. ".png", body)
			MakeCache("emoticon_cache/twitch/" .. emoticon .. ".png", emoticon)
		else
			Msg"ChatHUD " print("Download failure. Code: " .. code)
		end
	end)
	busy[emoticon] = true
	return false
end


-------------------------


ChatHUDEmoticonCache = emoticon_cache

return chathud
