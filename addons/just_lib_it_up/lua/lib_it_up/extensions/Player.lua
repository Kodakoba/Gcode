
local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

function Entity:Distance(ent)
	return self:GetPos():Distance(ent:GetPos())
end

function IsPlayer(ent)
	if type(ent) ~= "Player" or not IsValid(ent) then return false end
	return true 
end

if SERVER then 

	local rtimes = {}

	function Player:SetRespawnTime(time, abs)
		local rt = rtimes

		if not abs then 
			rt[self] = CurTime() + time 
		else
			rt[self] = time 
		end 

		self:SetNW2Float("NextRespawn", rt[self])
	end

	Player.SetNextRespawn = Player.SetRespawnTime

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

	function Player:GetRespawnTime()
		return rtimes[self] or (self.NextSpawnTime - CurTime()) --base gamemode
	end

else 

	function Player:GetRespawnTime()
		local t = self:GetNW2Float("NextRespawn")

		if t==0 then return nil else return t end
	end

	function Player:GetDeathTime()
		local t = self:GetNW2Float("DeathTime")

		if t==0 then return nil else return t end
	end

	function Player:GetRespawnLeft()
		local t = self:GetNW2Float("NextRespawn")

		if t==0 then 
			return false 
		else 
			return CurTime() - t
		end
	end

end

Player.GetNextRespawn = Player.GetRespawnTime


--[[
	The subscription system code is confusing, but the idea is i'll never have to touch it again :)
	It's fairly simple and the only reason you would want to go back is nanooptimizations
]]




EntitySubscribers = EntitySubscribers or {}

local subs = EntitySubscribers.Players or {} 		-- key = player, value = { {ply, dist_sqr, callback}, {ply, dist_sqr, callback} }
EntitySubscribers.Players = subs					-- this is used for distance-checking logic 



local ent_subs = EntitySubscribers.Entities or {}		-- key = entity, value = { [player] = ntid_in_plysub, [player] = entid_in_plysub }
EntitySubscribers.Entities = ent_subs					-- this is used for adding/removing subs from entity

--[[
	onunsub callback will be called with args:
		entity - from which the player unsubscribed
		player - which got unsubscribed

	make 4th arg "true" if you want to add subscriber multiple times
]]


local BlankFunc = function() end 

function Entity:Subscribe(ply, dist, onunsub, addtwice)

	if CLIENT then 
		ply = LocalPlayer() 
	end
	onunsub = onunsub or BlankFunc 

	if ent_subs[self] and ent_subs[self][ply] and not addtwice then return end  --prevent subscribing multiple times for the same entity
																				--..unless you want to.

	local sub_ply = subs[ply] or {}
	subs[ply] = sub_ply 

	local plysub_key = #sub_ply + 1

	sub_ply[plysub_key] = {self, dist^2, onunsub}


	local sub_ent = ent_subs[self] or {}
	ent_subs[self] = sub_ent 

	sub_ent[ply] = ply
end

function Entity:IsSubscribed(ply)
	local my_subs = ent_subs[self]

	if my_subs then 
		if my_subs[ply] then return true end
	end

	return false
end

function Entity:Unsubscribe(ply)
	local my_subs = ent_subs[self]

	if my_subs then 
		table.remove(subs, my_subs[ply])
		ent_subs[self][ply] = nil
	end
end

function Entity:GetSubscribers()
	local t = {}
	local i = 1

	local my_subs = ent_subs[self]

	if my_subs then 

		for k,v in pairs(my_subs) do 
			t[i] = k 
			i = i + 1
		end 

	end

	return t
end

function Entity:GetSubscribersKeys()
	
	local my_subs = ent_subs[self]

	return my_subs or {}
end


function Player:Subscribe(ent, ...)
	return ent:Subscribe(self, ...)
end

function Player:IsSubscribed(ent)
	return ent:IsSubscribed(self)
end

hook.Add("FinishMove", "EntitySubscriptions", function(pl, mv)
	if not subs[pl] then return end 

	local pos = mv:GetOrigin()

	for key, dat in ipairs(subs[pl]) do 

		local ent = dat[1]
		local dist = dat[2]
		local callback = dat[3]

		local epos = ent:GetPos()

		if pos:DistToSqr(epos) > dist then 
			local unsub = callback(ent, pl)

			if unsub ~= false then 
				table.remove(subs[pl], key) --preserve sequential order
				ent_subs[ent][pl] = nil
			end

		end

	end
end)













