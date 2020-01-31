include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("BlueprintMaker")

function ENT:Init(me)
	
end

function ENT:OpenMenu(ply)
	net.Start("BlueprintMaker")
	
	net.Send(ply)
end

function ENT:Think()
	local me = BWEnts[self]
end

function ENT:Use(ply)
	self:SendInfo(ply)
end