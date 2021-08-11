local bw = BaseWars.Bases
bw.Errors = {}
local err = bw.Errors
local id = 0

local function makeErr(s)
	err[id] = LocalString(s, id)

	id = id + 1

	return err[id - 1]
end

	err.AlreadyClaimed = function(base)
		local fac, own = base:GetOwner()
		return ("This base is already claimed by %s!"):format(
			fac and fac:GetName() or
			(own[1] and (own[1]:GetNick() or own[1]:GetSteamID64())) or "someone"
		)
	end

	err.AlreadyHaveABase = function(ply)
		return ("You already have a claimed base%s!"):format(
			ply and ply:GetBase() and (": `%s`"):format( ply:GetBase():GetName() )
				or ""
		)
	end


for k,v in pairs(err) do
	err[k] = makeErr(v)
end