include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("BlueprintMaker")

function ENT:Init(me)
	
end

function ENT:SendInfo(ply)
	net.Start("BlueprintMaker")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Think()
	local me = BWEnts[self]
end

function ENT:Use(ply)
	self:SendInfo(ply)
end