include("shared.lua")
AddCSLuaFile("shared.lua")

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)


function ENT:CLInit()

	local me = BWEnts[self]

end

local col = Color(70, 70, 70, 120)

function ENT:Draw()
	self:DrawModel()

	local pos = self:LocalToWorld(Vector(-12, -14, 79))
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos, ang, 0.03)
	
		local ok, err = pcall(function()
			draw.RoundedBox(8, 0, 0, 750, 650, col)
		end)

	cam.End3D2D()

	if not ok then 
		print("err", err)
	end
	
end