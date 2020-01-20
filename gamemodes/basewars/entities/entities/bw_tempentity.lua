
easylua.StartEntity("bw_blueprint_maker")

ENT.Base = "bw_base_electronics"

ENT.Model = "models/props_vtmb/safe.mdl" --Model.
ENT.Skin = 0

ENT.Capacity        = 10000000000
ENT.Money           = 0
ENT.MaxPaper        = 0
ENT.PrintInterval   = 1
ENT.PrintAmount     = 3
ENT.MaxLevel        = 3
ENT.UpgradeCost     = 1000

ENT.PrintName       = "Bank" --Title
ENT.IsPrinter       = true
ENT.IsValidRaidable = false

local Clamp = math.Clamp
function ENT:GSAT(vartype, slot, name, min, max)

    self:NetworkVar(vartype, slot, name)

end

function ENT:StableNetwork()
    self:GSAT("Float", 2, "Capacity")

    self:GSAT("Float", 3, "Money", 0, "GetCapacity")

    self:GSAT("Int", 5, "Level", 0, "MaxLevel")
end

if SERVER then

	AddCSLuaFile()

	function ENT:Init()

		self.time = CurTime()
		self.time_p = CurTime()

		self:SetCapacity(self.Capacity)

		self:SetHealth(self.PresetMaxHealth or 2000)

		self.rtb = 0

		self.FontColor = color_white
		self.BackColor = color_black

		self.ct = CurTime() + 2
		self:SetLevel(1)
	end

	function ENT:SetUpgradeCost()

	end
	
	function ENT:ThinkFunc()
		if CurTime() < self.ct then return end

		local owner=self:CPPIGetOwner()

		if self.Disabled or self:BadlyDamaged() then return end
		local added

		local level = self:GetLevel() ^ 1.3


		for k, v in pairs( ents.FindByClass( "*printer*" ) ) do
			if not v.IsPrinter then continue end
			if v:CPPIGetOwner() == owner then
				if self:GetMoney() < self.Capacity then
					local allmoney = v.Money or 0
					v.Money = 0
					v:SetMoney(0)
					self:SetMoney(self:GetMoney() + allmoney)
				end
			end
		end
        self.CurrentValue = self:GetMoney()

		self.ct = CurTime() + 2
	end

	function ENT:PlayerTakeMoney(ply)
		local money = self:GetMoney()
		if not IsValid(ply) then return end
		
		local Res, Msg = hook.Run("BaseWars_PlayerCanEmptyPrinter", ply, self, money)
		if Res == false then

			if Msg then

				ply:Notify(Msg, BASEWARS_NOTIFICATION_ERROR)

			end

		return end


		self:SetMoney(0)
		self.Money = 0
		ply:GiveMoney(money)
		
        self.CurrentValue = self:GetMoney()

		hook.Run("BaseWars_PlayerEmptyPrinter", ply, self, money)

	end

	function ENT:UseFuncBypass(activator, caller, usetype, value)

		if self.Disabled then return end

		if activator:IsPlayer() and caller:IsPlayer() and tonumber(self:GetMoney()) > 0 then

			self:PlayerTakeMoney(activator)

		end

	end

	function ENT:SetDisabled(a)

		self.Disabled = a and true or false
		self:SetNWBool("printer_disabled", a and true or false)

	end

else

	function ENT:Initialize()

		self.FontColor = Color(46, 141, 222)
		if not self.FontColor then self.FontColor = Color(255,255,255) end
		if not self.BackColor then self.BackColor = color_black end

	end




	local WasPowered
	if CLIENT then

		local function drawCircl( x, y, radius, seg, ang )
			local cir = {}
			table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
			for i = 0, (ang/5) do
				local a = math.rad( ( i / (ang/5) ) * -ang +180)
				table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
			end
			draw.NoTexture()
			surface.DrawPoly( cir )
		end


		ENT.Col = Color(50, 50, 50)
		function ENT:DrawDisplay(pos, ang, scale)

            	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 65536 then return end

			local Pos, Ang, pWidth = self:GetPos(), self:GetAngles(), 770

			local w, h = 370, 136 * 2

			local Pw = self:IsPowered()
			local Lv = self:GetLevel()
			local Cp = tonumber(self:GetCapacity()) or 0

			if not Pw then 
				self.Col = ValGoTo(self.Col, Color(37, 46, 80), 1)

				surface.SetDrawColor(self.Col)
				surface.DrawRect(0, 0, pWidth, 730)

				surface.SetDrawColor(80, 89, 123)
				surface.DrawRect(0, 0, pWidth, 50)

				surface.SetDrawColor(17, 168, 171)
				surface.DrawRect(0, 50, pWidth, 3)

				draw.SimpleText("NO POWER!", "R56",pWidth/2, 165, Color(200+math.sin(CurTime()*4)*40,50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return end
			

			if disabled then

			return end
			
			if disabled then return end
			
			local money = tonumber(self:GetMoney()) or 0
			local cap = tonumber(Cp) or 0
			
			local currentMoney = string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(money))
			local maxMoney = string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(cap))
			
			self.Col = ValGoTo(self.Col, Color(57, 66, 100), 1)

			surface.SetDrawColor(self.Col)
			surface.DrawRect(0, 0, pWidth, 760)

			surface.SetDrawColor(80, 89, 123)
			surface.DrawRect(0, 0, pWidth, 90)

			draw.SimpleText( self.PrintName , "R56", pWidth/2, 50-32-9, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )

			surface.SetDrawColor(17, 168, 171)
			surface.DrawRect(0, 90, pWidth, 3)

			local rad = 250
			local cW = pWidth/2
			local cH = 760/2
			surface.SetDrawColor(230, 76, 101)
			drawCircl(cW, cH, rad-1, 20, 360)

			surface.SetDrawColor(79, 196, 246)
			drawCircl(cW, cH, rad, 20, (money*360/cap))

			surface.SetDrawColor(57, 66, 100)
			drawCircl(cW, cH, rad*0.8, 20, 360)


			draw.SimpleText(string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(money)) .. "/" .. string.format(BaseWars.LANG.CURFORMER, BaseWars.NumberFormat(Cp)), "R56", cW, cH + rad + 20, Color( 255, 255, 255 , 255 ), TEXT_ALIGN_CENTER )

		end

		function ENT:Calc3D2DParams()

			local pos = self:GetPos()
			local ang = self:GetAngles()

			pos = pos + ang:Up() * 42
			pos = pos + ang:Forward() * -19
			pos = pos + ang:Right() * 19

			--ang:RotateAroundAxis(ang:Right(), -90)
			ang:RotateAroundAxis(ang:Up(), 90)

			return pos, ang, 0.1 / 2

		end

	end

	function ENT:Draw()

		self:DrawModel()

		if CLIENT then

			local pos, ang, scale = self:Calc3D2DParams()

			cam.Start3D2D(pos, ang, scale)
				local ok, err = pcall(self.DrawDisplay, self, pos, ang, scale)
				if not ok then print(err) end
			cam.End3D2D()

		end

	end

end
easylua.EndEntity()