

function ENTITY:Distance(ent)
	return self:GetPos():Distance(ent:GetPos())
end

function IsPlayer(ent)
	if type(ent) ~= "Player" or not IsValid(ent) then return false end
	return true
end

if SERVER then

	local rtimes = {}

	function PLAYER:SetRespawnTime(time, abs)
		local rt = rtimes

		if not abs then
			rt[self] = CurTime() + time
		else
			rt[self] = time
		end

		self:SetNW2Float("NextRespawn", rt[self])
	end

	PLAYER.SetNextRespawn = PLAYER.SetRespawnTime

	hook.Add("PlayerSpawn", "DoRespawnTime", function(ply)
		rtimes[ply] = nil
		ply:SetNW2Float("NextRespawn", 0)
		ply:SetNW2Float("DeathTime", 0)
	end)

	hook.Add("PlayerDeath", "DoDeathTime", function(ply)
		ply:SetNW2Float("DeathTime", CurTime())
	end)

	hook.Add("PlayerDeathThink", "DoRespawnTime", function(ply)
		local t = rtimes[ply]
		if t and t > CurTime() then return true end
	end)

	function PLAYER:GetRespawnTime()
		return rtimes[self] or (self.NextSpawnTime - CurTime()) --base gamemode
	end

else

	function PLAYER:GetRespawnTime()
		local t = self:GetNW2Float("NextRespawn")

		if t == 0 then return nil else return t end
	end

	function PLAYER:GetDeathTime()
		local t = self:GetNW2Float("DeathTime")

		if t == 0 then return nil else return t end
	end

	function PLAYER:GetRespawnLeft()
		local t = self:GetNW2Float("NextRespawn")

		if t == 0 then
			return false
		else
			return CurTime() - t
		end
	end

end

PLAYER.GetNextRespawn = PLAYER.GetRespawnTime



if SERVER then
	util.AddNetworkString("FullLoad")

	FullyLoaded = {}

	net.Receive("FullLoad", function(_, ply)
		if FullyLoaded[ply] then return end

		FullyLoaded[ply] = true
		hook.Run("PlayerFullyLoaded", ply)
	end)

else

	FullLoadSent = FullLoadSent or false
	FullLoadRan = FullLoadRan or false

	hook.Add("CalcView", "FullyLoaded", function()
		if FullLoadSent then
			hook.Remove("CalcView", "FullyLoaded")
			return
		end

		net.Start("FullLoad")
		net.SendToServer()

		FullLoadSent = true

		hook.Remove("CalcView", "FullyLoaded")

		hook.Run("PlayerFullyLoaded", LocalPlayer())

		FullLoadRan = true

	end)


	net.Receive("FullLoad", function(len)
		if FullLoadRan then return end

		FullLoadSent = true
		FullLoadRan = true

		hook.Run("PlayerFullyLoaded", LocalPlayer())

	end)


	gameevent.Listen("player_info") --smh my head
	local ran = {}

	local function runHook(ply, uid)
		hook.Run("PlayerJoined", ply)
		ran[uid] = true
	end

	hook.Add("player_info", "GarryPls", function(dat)
		local uid = dat.userid

		if not ran[uid] then

			hook.Add("Think", "ValidatePlayer" .. uid, function() --yikers
				if ran[uid] then hook.Remove("Think", "ValidatePlayer" .. uid) return end

				local ply = Player(uid)
									--YIKERS
				if ply:IsValid() and ply:Team() ~= 0 then
					runHook(ply, uid)
				end
			end)

		end

	end)
end

