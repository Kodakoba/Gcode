local PLAYER = debug.getregistry().Player
BaseWars.AFK = {}

local MODULE = BaseWars.AFK 

if SERVER then

	util.AddNetworkString("AFK")

	function MODULE.HandleNetMessage(len, ply)

		local Mode = net.ReadUInt(2)

		if Mode == 0 then

			MODULE.ClearAFK(ply)

		end

	end
	net.Receive("AFK", MODULE.HandleNetMessage)

	for k, v in next, player.GetAll() do

		v:SetNW2Int("AFK", CurTime())

	end

	if SERVER then 
    
	    util.AddNetworkString("AFKFocus")

	    net.Receive("AFKFocus", function(len, ply)
	        local focus = net.ReadBool()
	        if focus==nil then return end
	        ply:SetNW2Bool("AFKFocused", focus)
	    end)
	end

end



local lastClear = CurTime()
function MODULE.ClearAFK(ply)

	if CLIENT and ply and ply ~= LocalPlayer() then return end
    if CLIENT and CurTime() - lastClear < 2 then return end
	if CLIENT then

		net.Start("AFK")
			net.WriteUInt(0, 2)
		net.SendToServer()
        lastClear = CurTime()
		return

	end
    
	ply:SetNW2Int("AFK", CurTime())
	ply:SetNW2Bool("AFKFocused", true)

end

PLAYER.ClearAFK = MODULE.ClearAFK

function MODULE.IsAFK(ply)

	return (CurTime() - ply:GetNW2Int("AFK")) > BaseWars.Config.AFK.Time

end
PLAYER.IsAFK = MODULE.IsAFK

function MODULE.AFKTime(ply)

	return CurTime() - ply:GetNW2Int("AFK")

end
PLAYER.AFKTime = MODULE.AFKTime

function MODULE.PlayerAuth(ply)

	MODULE.ClearAFK(ply)

end
hook.Add("PlayerAuth", "AFKAuth", MODULE.PlayerAuth)

function MODULE.PlayerInitialSpawn(ply)

	if CLIENT then return end
	ply:SetNW2Int("AFK", CurTime())

end
hook.Add("PlayerInitialSpawn", "AFKInit", MODULE.PlayerInitialSpawn)

local trans = Color(255, 255, 255)
local green = Color(120, 210, 120)

local shade = Color(0, 0, 0, 250)


if CLIENT then

	surface.CreateFont("AFKTimeBlur", {
		font = "Roboto Condensed",
		size = 48,
		blursize = 6,
		weight = 600,
	})

	surface.CreateFont("AFKTime", {
		font = "Roboto Condensed",
		size = 48,
		weight = 600,
	})
end

local ta = 0

local gone = 0
local back = 0

local col = (CLIENT and trans:Copy())

local time = 0

function MODULE.Paint()

	local ply = LocalPlayer()
	

	if not ply:IsAFK() then 

		if back==0 and gone~=0 then 
			back = CurTime() 
			gone = 0
		end 

		if CurTime() - back < 1.5 then 
			LC(col, green)
		elseif ta > 1 then

			ta = L(ta, 0, 20)

			if ta<=1 then 
				back = 0 
				col:Set(trans)
			end 
		end

	else

		gone = CurTime()
		time = ply:AFKTime()
		ta = L(ta, 255, 3)

	end

	local AFKTime = string.TimeParse(time)
	local str = "You have been AFK for"
	
	shade.a = ta
	col.a = ta 

	draw.SimpleText(str, "AFKTimeBlur", ScrW()/2+1, ScrH()/4+1, shade, 1, 1)
	draw.SimpleText(str, "AFKTime", ScrW()/2, ScrH()/4, col, 1, 1)

	draw.SimpleText(AFKTime, "AFKTimeBlur", ScrW()/2+1, ScrH()/4+53, shade, 1, 1)
	draw.SimpleText(AFKTime, "AFKTime", ScrW()/2, ScrH()/4+52, col, 1, 1)

end
hook.Add("HUDPaint", "PaintAFK", MODULE.Paint)


local clear = MODULE.ClearAFK

local ox, oy, oa

local cmdclear = function(cmd)

	local ply = LocalPlayer()

	if ply:IsAFK() and cmd:GetMouseX() ~= ox or cmd:GetMouseY() ~= oy then

		clear()
		ox, oy = cmd:GetMouseX(), cmd:GetMouseY()

	end

end

local tickclear = function()

	local ply = LocalPlayer()

	if not IsValid(ply) then

		return

	end

	if ply.IsAFK and ply:IsAFK() and ply:GetAngles() ~= oa then

		clear()

	end

	oa = ply:GetAngles()

end


hook.Add("PlayerSay", "AFKClear", clear)
hook.Add("KeyPress", "AFKClear", clear)

if CLIENT then

	hook.Add("PlayerBindPress", "AFKClear", clear)
	hook.Add("CreateMove", "AFKClear", cmdclear)
	hook.Add("Tick", "AFKClear", tickclear)
	hook.Add("StartChat", "AFKClear", clear)

end
