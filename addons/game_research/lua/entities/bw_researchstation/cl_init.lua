--soon:tm:
AddCSLuaFile()
include("shared.lua")

local yeet 
local yeet2

local animscale = 1
local anim

local researchscale = 0
local rsanim

local BeginResearch = false

local txt = "No research queued!"


local rndto = 2	
local rndmul = 10^rndto 

local pmain

function ENT:DrawDisplay()
	local res = self:GetRSPerk()

	if res==0 then --if not researching


		researchscale = L(researchscale, 0, 5)

		if BeginResearch and not rsanim and researchscale < 0.01 then

			rsanim = Animations.SpringIn(3, 10, 1, -1, function(frac)
				animscale = frac
			end, function()
				BeginResearch = false 
				rsanim = nil 
			end)

		end

	elseif not anim and not BeginResearch then --if researching and not animating and wasn't animated

		anim = Animations.SpringOut(4, 0.2, 1, -1, function(frac) --begin animation
			animscale = 1 - frac
		end, function()
			BeginResearch = true 
			anim = nil
		end, 0.9)

	end



	local w, h = 736, 300
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))

	if animscale > 0 then
		local vm = Matrix()
		local scale = 0.05 * animscale

		yeet2:RotateAroundAxis(yeet2:Forward(),180)

		local pos = yeet 
		pos = pos + yeet2:Forward() * 0.05 *  w*0.5
		pos = pos + (-yeet2:Right() * 0.05 * h*0.3)

		vm:SetTranslation(pos)

		vm:Rotate(yeet2)

		vm:Scale(Vector(scale, scale, 0))

		cam.PushModelMatrix(vm)
			draw.SimpleText(txt, "OSB64", 0, 0, color_white, 1, 1)
		cam.PopModelMatrix()
	end

	if BeginResearch then 
		if res~=0 then 
			researchscale = L(researchscale, 1, 4)
		end
		
		local col = ColorAlpha(color_white, researchscale*255)

		surface.SetDrawColor(col)

		local y = h/2 - 64*researchscale
		surface.DrawMaterial("https://i.imgur.com/UjEA5rr.png", "research256.png", w/2 - 64, y, 128, 128)

		y = h/2 - 64*researchscale + 128 + 8
		col.a = col.a ^ (researchscale^2)
		local perk = Research.IDs[res]
		local txt = "Researching %s"
		txt = txt:format(perk.Name)
		draw.SimpleText(txt, "OS48", w/2, y, col, 1, 5)
	end
end




function ENT:OpenMenu()
	local curperk = self:GetRSPerk()
	if curperk == 0 then 
		OpenResearchSelectMenu(self)
	else 
		OpenResearchInfoMenu(self, curperk)
	end
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + self:GetAngles():Up()*63.65 + self:GetAngles():Forward() * 16.1 + self:GetAngles():Right() * -4.6
	local ang = self:GetAngles()	

	ang:RotateAroundAxis(ang:Up(),90)
	ang:RotateAroundAxis(ang:Forward(),90)

	yeet = pos
	yeet2 = ang

	cam.Start3D2D(pos, ang, 0.05)
		local ok, err = pcall(self.DrawDisplay, self)
	cam.End3D2D()

	if not ok then
		error(err)
	end
end

net.Receive("ResearchComputer", function()
	local comp = net.ReadEntity()
	if not IsValid(comp) or not comp.ResearchComputer then return end 
	comp:OpenMenu()
end)