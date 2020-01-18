local PLAYER = debug.getregistry().Player

BaseWars.PlayerLevel = {}
local MODULE = BaseWars.PlayerLevel

local startEXP = 10

local reqs = {}
local moneyreqs = {}

for i=1, 5000 do 
	--[[
		calculate EXP to lv i
	]]

	local exp = startEXP + math.min(i*50, i^3)
	reqs[i] = exp

	--[[
		calculate money to next lv starting from this lv
	]]

	local div = 300
	local pad = math.max(20 - i, 0) * 14
	div = div - pad 

	local money = exp * div / BaseWars.Config.EXPMult

	moneyreqs[i] = money
end

local prt = {}

for i=1, 20 do 
	prt[i] = reqs[i]
end

reqs[5001] = math.huge

BaseWars.LevelXP = reqs 

function GetEXPAtLevel(lv)
	return reqs[lv]
end 

function GetMoneyAtLevel(lv)

	local money = 0 

	for i=1, lv do 
		money = money + moneyreqs[i]
	end 

	return money
end 

function MODULE.RegenerateEXPReqs(func)
	for i=1, 5000 do 
		local exp = func(i)

		reqs[i] = exp

		local div = 300
		local pad = math.max(50 - i, 0) * 3
		div = div - pad 

		local money = exp * div / BaseWars.Config.EXPMult

		moneyreqs[i] = money

	end
end

local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())
	
end


function MODULE.GetLevel(ply, uncache)

	if SERVER then
		if uncache or not ply.level then
			local puid = MODULE.Init(ply)
			local level = sql.Check("SELECT lvl FROM bw_plyData WHERE puid=="..puid, true )

			return tonumber(level[1].lvl) or 0
		elseif ply.level then
			return tonumber(ply.level)
		end
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString("BWLevel")) or 0
		
	end
	
end
PLAYER.GetLevel = (MODULE.GetLevel)

function MODULE.GetXP(ply)
	
	if SERVER then
	
		local puid = MODULE.Init(ply)
		local xp = ply.xp 

		if not xp then 
			local data = sql.Check("SELECT * FROM bw_plyData WHERE puid=="..puid, true )
			data = data[1]
			xp = data.xp 
			ply.xp = xp
		end

		return tonumber(xp)
		
	elseif CLIENT then
	
		return tonumber(ply:GetNWString("BWXP")) or 0
		
	end
	
end
PLAYER.GetXP = (MODULE.GetXP)

function MODULE.GetXPNextLevel(ply)
	local n = ply:GetLevel(true)
	return reqs[n+1]
end
PLAYER.GetXPNextLevel = (MODULE.GetXPNextLevel)

function MODULE.HasLevel(ply, level)
	local plylevel = ply:GetLevel(true)
	return (plylevel >= level)
end
PLAYER.HasLevel = (MODULE.HasLevel)

if SERVER then

	function MODULE.Init(ply)

		local puid = ply:GetUID()
		if not puid then error('Failed to get PUID for ' .. ply) return end 
		
		local data = sql.Check("SELECT * FROM bw_plyData WHERE puid=="..puid, true )

		if not data then 
			BaseWars.FirstEntry(ply)
			return puid
		end
		data = data[1]

		return puid
		
	end
	PLAYER.InitLevel = (MODULE.Init)

	for k, v in next, player.GetAll() do
		
		MODULE.Init(v)
	
	end

	function MODULE.Save(ply)

		local puid = MODULE.Init(ply)
		if not puid then return end 

		local q = "UPDATE bw_plyData SET xp = %s, lvl = %s WHERE puid==%s"
		q = q:format(ply:GetXP(), ply:GetNWString("BWLevel", 0) , puid)

		sql.Check(q)

	end
	PLAYER.SaveLevels = (MODULE.Save)

	function MODULE.Load(ply)
	
		MODULE.Init(ply)
		local lvl = tostring(ply:GetLevel(true))
		local xp = tostring(ply:GetXP())
		ply:SetNWString("BWLevel", lvl)
		ply:SetNWString("BWXP", xp)
		ply.level = lvl
		ply.xp = xp
		
	end
	PLAYER.LoadLevels = (MODULE.Load)

	function MODULE.CheckLevels(ply)
		local curxp = ply:GetXP()
		local lvs = 0
		local curneeded = 0
		local curlvl = ply:GetLevel(true)

		for i=curlvl, 5000 do 
			curneeded = curneeded + reqs[i+1]

			if curxp >= curneeded then

				if curlvl+lvs >= 5000 then
					curxp = 0
					break
				end
			
				lvs = lvs + 1
				curxp = curxp - curneeded

			else 
				break 
			end

		end

		ply.xp = curxp
		ply:SetNWString("BWXP", tostring(curxp))
		ply:AddLevel(lvs)

	end
	
	function MODULE.Set(ply, amount)

		if not isnumber(amount) or amount < 0 then amount = 0 end
		if amount > 5000 then amount = 5000 end
		
		amount = math.Round(amount)
		
		ply.level = amount
		ply:SetNWString("BWLevel", tostring(amount))
		MODULE.Save(ply)

	end
	PLAYER.SetLevel = (MODULE.Set)

	function MODULE.AddLevel(ply, amount)
		
		local Value = ply:GetLevel(true)
		
		ply:SetLevel(Value + amount)
		
	end
	PLAYER.AddLevel = (MODULE.AddLevel)
	
	function MODULE.SetXP(ply, amount)

		if not isnumber(amount) or amount < 0 then amount = 0 end

		local netamount = math.Round(amount)

		ply.xp = amount
		ply.AwaitsSave = true
		ply:SetNWString("BWXP", tostring(netamount))
		
		MODULE.CheckLevels( ply )
		
	end
	PLAYER.SetXP = (MODULE.SetXP)

	function MODULE.AddXP(ply, amount)
		
		local Value = ply:GetXP()
		
		ply:SetXP(Value + amount)
		
	end
	PLAYER.AddXP = (MODULE.AddXP)

	hook.Add("PlayerAuthed", "BWLoad", (MODULE.Load))
	hook.Add("PlayerDisconnected", "BWSave", (MODULE.Save))
	
end
