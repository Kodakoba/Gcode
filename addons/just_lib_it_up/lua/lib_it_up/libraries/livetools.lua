setfenv(0, _G)

ToolObj = _G.LiveToolObj or {}

include( "sandbox/entities/weapons/gmod_tool/ghostentity.lua" )
include( "sandbox/entities/weapons/gmod_tool/object.lua" )

if ( CLIENT ) then
	include( "sandbox/entities/weapons/gmod_tool/stool_cl.lua" )
end

local ToolObj = ToolObj
_G.ToolObj = nil
_G.LiveToolObj = ToolObj

function ToolObj:Create()

	local o = {}

	setmetatable( o, self )
	self.__index = self

	o.Mode				= nil
	o.SWEP				= nil
	o.Owner				= nil
	o.ClientConVar		= {}
	o.ServerConVar		= {}
	o.Objects			= {}
	o.Stage				= 0
	o.Message			= "start"
	o.LastMessage		= 0
	o.AllowedCVar		= 0

	return o

end

function ToolObj:CreateConVars()

	local mode = self:GetMode()

	if ( CLIENT ) then

		for cvar, default in pairs( self.ClientConVar ) do

			CreateClientConVar( mode .. "_" .. cvar, default, true, true )

		end

		return
	end

	-- Note: I changed this from replicated because replicated convars don't work
	-- when they're created via Lua.

	if ( SERVER ) then

		self.AllowedCVar = CreateConVar( "toolmode_allow_" .. mode, 1, FCVAR_NOTIFY )

		for cvar, default in pairs( self.ServerConVar ) do
			CreateConVar( mode .. "_" .. cvar, default, FCVAR_ARCHIVE )
		end
	end

end

function ToolObj:GetServerInfo( property )

	local mode = self:GetMode()

	return GetConVarString( mode .. "_" .. property )

end

function ToolObj:BuildConVarList()

	local mode = self:GetMode()
	local convars = {}

	for k, v in pairs( self.ClientConVar ) do convars[ mode .. "_" .. k ] = v end

	return convars

end

function ToolObj:GetClientInfo( property )

	return self:GetOwner():GetInfo( self:GetMode() .. "_" .. property )

end

function ToolObj:GetClientNumber( property, default )

	return self:GetOwner():GetInfoNum( self:GetMode() .. "_" .. property, tonumber( default ) or 0 )

end

function ToolObj:Allowed()

	if ( CLIENT ) then return true end
	return self.AllowedCVar:GetBool()

end

-- Now for all the ToolObj redirects

function ToolObj:Init() end

function ToolObj:GetMode()		return self.Mode end
function ToolObj:GetSWEP()		return self.SWEP end
function ToolObj:GetOwner()		return self:GetSWEP().Owner or self.Owner end
function ToolObj:GetWeapon()	return self:GetSWEP().Weapon or self.Weapon end

function ToolObj:LeftClick()	return false end
function ToolObj:RightClick()	return false end
function ToolObj:Reload()		self:ClearObjects() end
function ToolObj:Deploy()		self:ReleaseGhostEntity() return end
function ToolObj:Holster()		self:ReleaseGhostEntity() return end
function ToolObj:Think()		self:ReleaseGhostEntity() end

--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function ToolObj:CheckObjects()

	for k, v in pairs( self.Objects ) do

		if ( !v.Ent:IsWorld() && !v.Ent:IsValid() ) then
			self:ClearObjects()
		end

	end

end



local toolgun = weapons.GetStored("gmod_tool")

function ToolObj:Finish()
	self:CreateConVars()
	toolgun.Tool[self.Mode] = self

	for k, ply in ipairs(player.GetAll()) do
		local wep = ply:GetWeapon("gmod_tool")
		if wep:IsValid() then
			local self = table.Copy(self)
			wep.Tool[self.Mode] = self
			self.SWEP = wep
			self.Owner = ply
			self.Weapon = wep
			self:Init()
		end
	end
end

function IncludeTool(fn, name)
	if not name then name = fn:match("([%w_]*)%.lua") end
	TOOL = LiveToolObj:Create()
	TOOL.Mode = name
	TOOL.Category = "Uncategorized"

	AddCSLuaFile(fn)
	include(fn)

	TOOL:Finish()

	TOOL = nil
end

function CreateTool(name)
	local tool = LiveToolObj:Create()
	tool.Category = "Uncategorized"
	tool.Mode = name
	return tool
end


-- for live refreshes

function StartTool(name)
	if not name then name = fn:match("([%w_]*)%.lua") end

	TOOL = LiveToolObj:Create()
	TOOL.Mode = name
	TOOL.Category = "Uncategorized"

	return TOOL
end

function EndTool()
	TOOL:Finish()
	TOOL = nil
end