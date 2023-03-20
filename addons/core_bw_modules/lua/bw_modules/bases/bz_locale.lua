local bw = BaseWars.Bases
bw.Errors = {}
local err = bw.Errors
local id = 0

local function makeErr(s)
	err[id] = LocalString(s, id)

	id = id + 1

	return err[id - 1]
end

	err.AlreadyUnclaimed = "This base doesn't belong to anyone!"
	err.AlreadyClaimed = function(base)
		local fac, own = base:GetOwner()
		return ("This base is already claimed by %s!"):format(
			fac and fac:GetName() or
			(own[1] and (own[1]:GetNick() or own[1]:GetSteamID64())) or "someone"
		)
	end

	err.NotYourBase = "This isn't even your base!"
	err.AlreadyHaveABase = function(ply)
		return ("You already have a claimed base%s!"):format(
			ply and ply:GetBase() and (": `%s`"):format( ply:GetBase():GetName() )
				or ""
		)
	end

	err.NotOwner = "You're not the owner of your faction to do that!"
	

for k,v in pairs(err) do
	err[k] = makeErr(v)
end