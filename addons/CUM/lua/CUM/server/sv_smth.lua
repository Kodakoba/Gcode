--[[
	Report funcs:
		{1}, {2}, {3} will forward 1, 2 or 3rd argument.
		1st argument is usually the caller.
		Player colors will be automatically modified with team color
]]
local function IsPlayer(arg)
	return type(arg) == "Player"
end
CUM = CUM or {}
CUM.Receipts = CUM.Receipts or {}
CUM.Cats = {}

local log = CUM.Log

function CUM.UpdateRanks()
	local adms = {}
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() or v:IsSuperAdmin() then
			adms[#adms + 1] = v
		end
	end
	CUM.Receipts["admins"] = adms

	local sadms = {}
	for k,v in pairs(player.GetAll()) do
		if v:IsSuperAdmin() then
			sadms[#sadms + 1] = v
		end
	end

	CUM.Receipts["superadmins"] = sadms

	CUM.Receipts["all"] = player.GetAll()
end
CUM.UpdateRanks()

timer.Create("CUM.UpdateRanks", 10, 0, CUM.UpdateRanks)

CUM.cmds = CUM.cmds or {}

cmdfuncs = {}

local cmdmeta = {}
cmdmeta.__index = cmdfuncs

function CUM.ParsePlayer(str)
	str = str:lower()
	for _, ply in pairs(player.GetBots()) do 	--search bots first

		if ply:Nick():lower():find(str, nil, true) and IsValid(ply) then
			return ply
		end

	end

	for _, ply in pairs(player.GetHumans()) do 	--then players for start of name exact

		if ply:Nick():lower():find(str, nil, true) == 1 and IsValid(ply) then
			return ply
		end

	end

	local matches = {}

	for _, ply in pairs(player.GetHumans()) do 	--then best match

		local st, en = ply:Nick():lower():find(str, nil, true)

		if st and IsValid(ply) then
			matches[#matches+1] = {len = en-st, ply = ply}
		end

	end

	table.sort(matches, function(a, b) return a.len > b.len end)

	if matches[1] and IsValid(matches[1].ply) then return matches[1].ply else return false end
end

local boolaliases = {
	["1"] = true,
	["true"] = true,
	["y"] = true,
	["yes"] = true,
	["ys"] = true,
	["u"] = true,
	["t"] = true,

	["0"] = false,
	["false"] = false,
	["n"] = false,
	["no"] = false,
	["m"] = false,
	["b"] = false
}
function CUM.ParseBool(str)
	if boolaliases[str:lower()] ~= nil then
		return boolaliases[str:lower()]
	end
end

function CUM.ParseEntity(str, own)

end

function CUM.ParsePlayerOrEnt(str, own)
	local ent = CUM.ParsePlayer(str)
	local isply = true

	if not ent then
		ent = CUM.ParseEntity(str, own)
		isply = false
	end

	if not IsValid(ent) then return false, false end

	return ent, isply
end

local function SortArgs(cmd)


end

function cmdfuncs:AddPlayerArg(opt, def, desc, forceguess)
	local opt = opt or false
	if isstring(def) then desc = def def = nil end

	self.Args[#self.Args + 1] = {type = "Player", opt = opt, nicetype = "Player", parse = function(s, ...)

		local parse = isstring(s) and CUM.ParsePlayer(s)
		local isself = (s=="^" and self.Runner)
		local opt = (not isstring(s) and opt and self.Runner)

		local out = {}

		if ((not parse and not isself) or forceguess) and def then
			out = {eval(def, s, ...)}

			if out[1]=="^" then out[1] = self.Runner return out end
		end

		return parse or isself or out or opt or "err", "Didn't find player! (" .. ((isstring(s) and s) or "???????wtf") .. ")"
	end, desc = desc}
	SortArgs(self)
	return self
end

function cmdfuncs:AddFullArg()

	self.Args[#self.Args + 1] = {type = "string", full = true, nicetype = false}
	SortArgs(self)

	return self
end

function cmdfuncs:AddStringArg(opt, desc)
	local opt = opt or false

	self.Args[#self.Args + 1] = {type = "string", opt = opt, nicetype = "Text", desc = desc}
	SortArgs(self)
	return self
end

function cmdfuncs:AddNumberArg(opt, def, desc)
	if isnumber(opt) then def = opt opt = true end
	local opt = opt or false

	self.Args[#self.Args + 1] = {type = "number", opt = opt, nicetype = "Number", parse = function(s, ...)
		return tonumber(s) or tonumber(eval(def, ...)) or 0
	end, desc = desc}

	SortArgs(self)
	return self
end

function cmdfuncs:AddBoolArg(opt, def, desc)
	local opt = opt or false

	self.Args[#self.Args + 1] = {type = "boolean", opt = opt, nicetype = "Boolean (true/false)", parse = function(s, ...) return CUM.ParseBool(s) or eval(def, ...) end, desc = desc}
	SortArgs(self)
	return self
end

local txColor = Color(230, 230, 230)

local function checkcol(tbl, col)
	if tbl[#tbl+1] ~= col then
		tbl[#tbl+1] = col
		if IsColor(tbl[#tbl-1]) then table.remove(tbl, #tbl-1) end
	end
end

function cmdfuncs:AddCallerArg()
	self.RequiresCaller = true
	--self.Args[#self.Args + 1] = {type = "Player", opt = opt, nicetype = "Caller(filled)", parse = function(s) return self.Runner end}
	--SortArgs(self)
	return self
end

function cmdfuncs:SetReportFunc(func, recname)

	self.reportfunc = function(self, ...)
		local repargs = {...}

		local receipts

		if recname then
			receipts = CUM.Receipts[recname]
			if not receipts then
				print("[CUM] Invalid name for recepients in report func! ("..recname..")\n" .. debug.traceback())
			end
		else
			receipts = player.GetAll()
		end

		local strs = {}
		local plys = {}

		for _, ply in pairs(receipts) do
			print("reporting for", ply)
			local str, custtbl = func(self, ply, ...)

			if not str or not isstring(str) then print('well ok', str) continue end

			if custtbl then table.Merge(repargs, custtbl) end

			local key = str .. table.ToString(repargs)

			local tbl = {}

			if strs[key] then

				tbl = strs[key]
				plys[key][#plys[key] + 1] = ply
			else

				if str:match("{(%d+)}") then

					local lastend = 0
					local str2 = str

					local lastcol

					str:gsub( "({%d+})", function( i )
						local num = tonumber(i:match("{(%d+)}"))
						local arg = repargs[num]
						local where, ends = str2:find(i)
						checkcol(tbl, txColor)
						local subbed = str2:sub(lastend+1, where-1)
						if #subbed >= 1 then
							tbl[#tbl + 1] = subbed
						end

						lastend = ends

						if not arg then return "" end

						if IsPlayer(arg) and num == 0 then
							checkcol(tbl, Color(100, 220, 100))
							lastcol = Color(100, 220, 100)
							tbl[#tbl + 1] = arg:Nick()

						elseif IsPlayer(arg) then
							checkcol(tbl, team.GetColor(arg:Team()))
							lastcol = team.GetColor(arg:Team())

							tbl[#tbl + 1] = arg:Nick()
							if lastcol ~= txColor then
								checkcol(tbl, txColor)
								lastcol = txColor
							end

						elseif tostring(arg) then
							arg = tostring(arg)
							local match = arg:match("<col=(.+)>") or arg:match("<color=(.+)")
							local where, ends = arg:find("<col=.+>")
							if not where and match then
								where, ends = arg:find("<color=.+>")
							end
							if match then
								local r,g,b = match:match("(%d+),(%d+),(%d+)")
								tbl[#tbl + 1] = Color(r or 0, g or 0, b or 0)
								lastCol = tbl[#tbl]
							end

							tbl[#tbl + 1] = arg:sub((ends or 0) + 1, #arg)
						end

						return ""
					end )

					if lastcol ~= txColor then
						checkcol(tbl, txColor)
						lastCol = txColor
					end

					tbl[#tbl + 1] = str2:sub(lastend+1, #str)

					strs[key] = tbl

					plys[key] = {}
					plys[key][1] = ply
				end

			end

		end

		for k,v in pairs(strs) do

			net.Start("ChatAddText")
				net.WriteTable(v)
			net.Send(plys[k] or receipts or player.GetAll())
		end

	end

	return self
end

function cmdfuncs:AddEntityArg(opt, desc)
	local opt = opt or false

	self.Args[#self.Args + 1] = {type = "Entity", opt = opt, parse = CUM.ParseEntity, desc = desc}
	SortArgs(self)
	return self
end

function cmdfuncs:SetSilent(bool)

	bool = (bool==nil and true) or bool
	self.Silent = bool
	return self
end

function cmdfuncs:SetHiddenCaller(bool)

	bool = (bool==nil and true) or bool
	self.HideCaller = bool
	return self
end

function cmdfuncs:SetAdminLog(bool)

	bool = (bool==nil and true) or bool
	self.OnlyAdminsSee = bool
	return self
end

function cmdfuncs:SetDescription(str)
	self.Description = str
	return self
end
function CUM.AddCommand(str, func)
	local cat = "Uncategorized"

	if CUM.CurCat then
		cat = CUM.CurCat
	end

	local cmds = CUM.cmds
	local cmd = {}

	cmd.name = (isstring(str) and str) or str[1]
	cmd.func = func
	cmd.Args = {}

	setmetatable(cmd, cmdmeta)

	CUM.Cats[cat] = CUM.Cats[cat] or {}

	if isstring(str) then

		cmds[str] = cmd
		CUM.Cats[cat][str] = str

	elseif istable(str) then

		for k,v in pairs(str) do

			if isstring(v) then
				cmds[v] = cmd
				CUM.Cats[cat][v] = v
			end

		end
	end

	return cmd
end

local prefix = "^[%./]"

local argsep = "[%s,]"

local arg = "([.%S]+)[%s]*"

local quotarg = '[^\\](.+)"'
local quotes = '["\']'
function CUM.ParseArgs(str)
	local args = {}

	if str:find(quotes) then
		local seps = {}

		for s in string.gmatch(str, argsep) do
			local pos = seps[#seps] or 0

			local where, ended, txt = string.find(str, s, pos + 1, true)
			if not where then continue end

			seps[#seps+1] = where
		end

		local str2 = str

		for s in string.gmatch(str, quotarg) do

			local s2 = s:gsub("\\\"", [["]])

			local num = 1
			local at, ended = str2:find(string.PatternSafe(s))

			for k,v in pairs(seps) do

				if at < v and ended > v then
					seps[k] = nil  --within the arg; remove it
					continue
				end


				if at > v then
					num = num + 1
				end
			end
			args[num] = s2

			str = str:gsub(argsep .. [[*"]] .. string.PatternSafe(s) .. [["]], "")
		end

		for s in string.gmatch(str, arg) do
			local match = s:match(quotarg) or s:match(quotes)

			if match then str:gsub(match, "") continue end

			local num = 1
			local at, ended = str2:find(string.PatternSafe(s))

			for k,v in pairs(seps) do
				if at > v then
					num = num + 1
				end
			end

			args[num] = s

		end

		args[#args + 1] = str2

		return args
	end

	for s in string.gmatch(str, arg) do
		args[#args+1] = s
	end

	if #str > 1 then
		args[#args + 1] = str
	end

	return args
end

function CUM.MissingArgFormat(cmd, num)
	local form = "Argument #%d (type: %s) is missing and is not optional.\n(Usage: %s)"
	local usage = ""
	for k,v in pairs(cmd.Args) do
		if v.nicetype == false then continue end
		usage = usage .. v.nicetype or v.type
		if next(cmd.Args, k) then usage = usage .. ", " end
	end

	return form:format(num, cmd.Args[num].type, usage)
end

function CUM.SendError(ply, str)
	ply:ChatAddText(Color(250, 150, 20), str)
end

hook.Add("PlayerSay", "CUM.Commands", function(ply, str)

	if not ply:IsAdmin() then return end

	if str:match(prefix) then
		local cmd = str:match(prefix .. "(%w+)")
		local cmdtbl = CUM.cmds[cmd]

		if not cmdtbl then return end

		if cmdtbl.Executing then cmdtbl.Runner = false cmdtbl.Executing = false cmdtbl.ExecArgs = {} end

		local args = {}

		local argstr = str:gsub(prefix .. "(%w+)%s-", "")


		args = CUM.ParseArgs(argstr)

		local err = false
		local full = args[#args]

		args[#args] = nil

		local needsfull = false

		cmdtbl.Runner = ply
		cmdtbl.Executing = true
		cmdtbl.ExecArgs = {}
		cmdtbl.ReportArgs = {}

		local RETURN = cmdtbl.Silent and "" or nil

		if not cmdtbl.HideCaller then cmdtbl.ReportArgs[0] = ply end
		local opts = 0

		PrintTable(args)
		for k,v in ipairs(cmdtbl.Args) do --preparse optional args & shift optional to required

			local arg = args[k]

			if v.opt then opts = opts + 1 end

			if not arg and not v.opt then
				if args[k-1] and cmdtbl.Args[k-1].opt then
					arg = args[k-1]
					args[k-1] = nil
					cmdtbl.ExecArgs[k-1] = nil
					cmdtbl.ReportArgs[k-1] = nil
				else
					local err = CUM.MissingArgFormat(cmdtbl, k)
					CUM.SendError(ply, err)

					return RETURN
				end
			end

			cmdtbl.ExecArgs[k] = arg
		end

		local add = 0



		for k,v in ipairs(cmdtbl.Args) do --fill up and parse execargs


			local arg = cmdtbl.ExecArgs[k]

			if v.full then
				needsfull = k
			end

			if v.parse then

				local ret, errstr = v.parse(arg, unpack(cmdtbl.ExecArgs))

				if ret=="err" and isstring(errstr) then
					CUM.SendError(ply, errstr)
					err = errstr
					break
				end

				if istable(ret) then
					for _,v in pairs(ret) do

						if v=="err" and isstring(errstr) then
							CUM.SendError(ply, errstr)
							err = errstr
							return RETURN
						end

						cmdtbl.ExecArgs[k + add] = v
						add = add + 1
					end
					add = add - 1
				else
					cmdtbl.ExecArgs[k + add] = ret
				end
			end

		end

		if err then return RETURN end



		if needsfull then
			table.insert(cmdtbl.ExecArgs, needsfull, full)
		end

		local caller = cmdtbl.RequiresCaller

		if caller then
			table.insert(cmdtbl.ExecArgs, 1, ply)
		end

		local ok, err = pcall(cmdtbl.func, unpack(cmdtbl.ExecArgs))

		if not ok then
			print("[CUM] Error! :", err)
		end

		if cmdtbl.reportfunc and err ~= false then

			table.Merge(cmdtbl.ReportArgs, cmdtbl.ExecArgs)
			table.insert(cmdtbl.ReportArgs, 1, ply)

			local ok, err = pcall(cmdtbl.reportfunc, cmdtbl, unpack(cmdtbl.ReportArgs))

			if not ok then
				print("[CUM] Report Error! :", err)
			end
		end

		cmdtbl.Runner = nil
		cmdtbl.Executing = false
		cmdtbl.ExecArgs = {}
		return RETURN
	end

end)

concommand.Add("CUM", function(ply, _, argt, argstr)
	local cmd = argt[1]
	local cmdtbl = CUM.cmds[cmd]

	if not cmdtbl then return end

	if cmdtbl.Executing then cmdtbl.Runner = false cmdtbl.Executing = false cmdtbl.ExecArgs = {} end

	local argstr = table.Copy(argt)
	table.remove(argstr, 1)
	local argstr = table.concat(argstr, " ")


	local args = CUM.ParseArgs(argstr)

	local err = false
	local full = args[#args]

	args[#args] = nil

	local needsfull = false

	cmdtbl.Runner = ply
	cmdtbl.Executing = true
	cmdtbl.ExecArgs = {}
	cmdtbl.ReportArgs = {}
	if not cmdtbl.HideCaller then cmdtbl.ReportArgs[0] = ply end
	local opts = 0

	for k,v in ipairs(cmdtbl.Args) do --preparse optional args & shift optional to required

		local arg = args[k]

		if v.opt then opts = opts + 1 end

		if not arg and not v.opt then
			if args[k-1] and cmdtbl.Args[k-1].opt then
				arg = args[k-1]
				args[k-1] = nil
				cmdtbl.ExecArgs[k-1] = nil
				cmdtbl.ReportArgs[k-1] = nil
			else
				local err = CUM.MissingArgFormat(cmdtbl, k)
				CUM.SendError(ply, err)
				return
			end
		end

		cmdtbl.ExecArgs[k] = arg
	end

	for k,v in ipairs(cmdtbl.Args) do --fill up and parse execargs

		local arg = cmdtbl.ExecArgs[k]
		if v.full then
			needsfull = k
		end

		if v.parse then
			local ret, errstr = v.parse(arg)

			if ret=="err" and isstring(errstr) then
				CUM.SendError(ply, errstr)
				err = errstr
			end

			cmdtbl.ExecArgs[k] = ret
		end

	end

	if err then return end



	if needsfull then
		table.insert(cmdtbl.ExecArgs, needsfull, full)
	end

	local caller = cmdtbl.RequiresCaller

	if caller then
		table.insert(cmdtbl.ExecArgs, 1, ply)
	end

		local ok, err = pcall(cmdtbl.func, unpack(cmdtbl.ExecArgs))

		if not ok then
			print("[CUM] Error! :", err)
		end

		if cmdtbl.reportfunc then

			table.Merge(cmdtbl.ReportArgs, cmdtbl.ExecArgs)
			table.insert(cmdtbl.ReportArgs, 1, ply)

			local ok, err = pcall(cmdtbl.reportfunc, cmdtbl, unpack(cmdtbl.ReportArgs))

			if not ok then
				print("[CUM] Report Error! :", err)
			end
		end
	cmdtbl.Runner = nil
	cmdtbl.Executing = false
	cmdtbl.ExecArgs = {}

end)
