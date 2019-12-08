local tag = "BaseWars.Factions"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

local facs = Factions


local PLAYER = debug.getregistry().Player

net.Receive("Factions", function(len)

	local type = net.ReadUInt(4)

	print(('CL: Factions: Type %s; size: %s bytes'):format(type, len/8))

	if type == 1 then

		facs.Factions = {}

		local amt = net.ReadUInt(16)

		for i=1, amt do
			local id = net.ReadUInt(24)
			local name = net.ReadString()
			local col = net.ReadColor()
			local lead = net.ReadUInt(24)

			if IsValid(Player(lead)) then --sometimes the player doesnt yet exist for client
				lead = Player(lead)		  --in this case, leader will be attempted to autoconvert to real owner when the time to parse the name comes
			end

			local haspw = net.ReadBool()

			team.SetUp(id, name, col, false)
			facs.Factions[name] = {id = id, name = name, col = col, own = lead, pw = haspw}
			facs.FactionIDs[id] = {id = id, name = name, col = col, own = lead, pw = haspw}
		end

	elseif type==2 then 

		local id = net.ReadUInt(24)
		local name = net.ReadString()
		local col = net.ReadColor()
		local lead = net.ReadUInt(24)
		if IsValid(Player(lead)) then 
			lead = Player(lead)
		end
		local haspw = net.ReadBool()

		team.SetUp(id, name, col, false)

		facs.Factions[name] = {id = id, name = name, col = col, own = lead, pw = haspw}
		facs.FactionIDs[id] = {id = id, name = name, col = col, own = lead, pw = haspw}

	elseif type==3 then 

		local id = net.ReadUInt(24)

		for k,v in pairs(facs.Factions) do 
			if v.id and v.id==id then 
				facs.Factions[k] = nil
				facs.FactionIDs[id] = nil
				break
			end
		end

	elseif type==4 then --update leader
		local id = net.ReadUInt(24)
		local lead = net.ReadUInt(24)
		print('updating faction', id)
		if IsValid(Player(lead)) then 
			lead = Player(lead)
		end
		print('to ', lead)
		facs.FactionIDs[id].own = lead
		facs.Factions[facs.FactionIDs[id].name].own = lead
	end

	if type==10 then 
		if FacErrorReceiver then FacErrorReceiver() end
		return
	end
	hook.Run("FactionsUpdate")
end)

function GetFactions()
	return Factions.Factions 
end

function PLAYER:GetFaction()
	local fac = Factions.FactionIDs[self:Team()]
	if fac then return fac.name end
	return "no faction"
end

function PLAYER:InFaction(ply2)
	local fac = Factions.FactionIDs[self:Team()]

	if not ply2 then 
		if fac then return fac.name else return false end
	elseif IsPlayer(ply2) then
		local fac2 = Factions.FactionIDs[ply2:Team()]
		if self:Team()~=1 and fac==fac2 then 
			return fac.name 
		else 
			return false 
		end 
	elseif isnumber(ply2) then 
		return self:Team() == ply2
	end
	return false --???
end