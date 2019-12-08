
SWEP.Author			= "1488khz gachi remix"
SWEP.Contact			= ""
SWEP.Purpose			= ""

 
SWEP.Spawnable			= true
 
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.DrawAmmo = false
SWEP.Primary.Automatic = false
SWEP.DashTime = 0.3

function SWEP:SetupDataTables()

	self:NetworkVar("Int", 0, "DashCharges")

	self:NetworkVar("Bool", 0, "Dashing")

	self:NetworkVar("Float", 0, "DashEndTime")

end
DashTable = {}
function SWEP:Initialize()
	if CLIENT then 
		self:SetPredictable(true)
		self.Dashed = false
	end
end

hook.Add("GetFallDamage", "DashFall", function(ply)
 	if ply:GetActiveWeapon():GetClass() == "dash" then --and ply:GetActiveWeapon():GetDashTime() - CurTime() > -5 then 
 		--ply:EmitSound("dash/land.ogg", 70, 100, 1, CHAN_AUTO)
 		return 0 
 	end
 	
 end)

function SWEP:Reload()
	--self:SetDashCharges(1)
end


function SWEP:Think()	

	if self:GetOwner():IsOnGround() and not DashTable[self:GetOwner()] and self:GetDashCharges() ~= 1 then 
		self:SetDashCharges(1) 
		if CLIENT then 
			self.Dashed = false 
		end 
	end
	
end
 
local OverrideDashEnd 
local OverrideDashFinalVel
function SWEP:CheckMoves(owner, mv, dir)

	local jumping = mv:KeyDown(IN_JUMP)
	local ducked = mv:KeyDown(IN_DUCK)

	if not jumping or OverrideDashEnd then return end 

	local dt = DashTable[owner]

	if dt.ground then 

		if dt.jump then return end 

		local tr = util.TraceHull({
			start = owner:GetPos(),
			endpos = owner:GetPos() - Vector(0, 0, 8),
			filter = owner,
			mins = Vector( -16, -16, -16 ),
			maxs = Vector( 16, 16, 16 ),
			mask = MASK_SOLID
		})

		if tr.Hit then--owner:IsOnGround() then 
			
			local vel = dir * 1000


			if ducked then 

				vel = dir * 2000
				vel.z = 2000

			else 
				vel.z = 3500
			end

			

			if SERVER then
				self:StopDash()

				local vel2 = Vector()
				vel2:Set(vel)
				vel2.z = vel2.z / 15

				--mv:SetVelocity(vel2)
				--owner:SetVelocity(vel)
				owner:SetNetworkOrigin(owner:GetPos())
				return vel2
			else 

				mv:SetVelocity(vel)
				local vel2 = Vector()
				vel2:Set(vel)
				vel2.z = 0

				OverrideDashEnd = CurTime() + owner:Ping() / 1000
				OverrideDashFinalVel = vel

				
				return vel
			end
			
		end

	end

end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	--if not IsFirstTimePredicted() and DashTable[owner] then return end 

	if self:GetDashCharges() <= 0 or self.Dashed then return end 

	self:SetDashCharges(self:GetDashCharges() - 1)

	if CLIENT then 
		self.Dashed = true 
		self:EmitSound("dash/whoosh.ogg", 45)
	end

	

	if SERVER then self:SetDashEndTime(CurTime() + self.DashTime) end
	local dir = owner:EyeAngles():Forward()
	local z = dir.z


	if z > -0.15 and z < 0.20 then 
		dir.z = 0.1
	end

	DashTable[owner] = {
		t = CurTime(), 
		dir = dir, 
		wep = self,
		ground = owner:IsOnGround(),
	}
	local dt = DashTable[owner]

	

	if SERVER then 
		dt.ground = owner:IsOnGround()

		dt.jump = owner:KeyDown(IN_JUMP)
	end

	--

 	self:SetNextPrimaryFire(CurTime() + 0.4)

end

function Realm()
	return (CLIENT and "Client") or (SERVER and "Server") or "wat"	--for debugging prediction
end

hook.Remove("Move", "Dash")

hook.Add("FinishMove", "Dash", function(ply, mv, cmd)
	if not DashTable[ply] then return end 
	if CLIENT and ply~=LocalPlayer() then return end

	local t =  DashTable[ply]
	local self = t.wep
	if not IsValid(self) then DashTable[ply] = nil return end 
	
	local time = t.t
	local endtime = OverrideDashEnd or (self:GetDashEndTime()~=0 and self:GetDashEndTime() + (CLIENT and ply:Ping()/1000 or 0)) or t.t+self.DashTime
	local ping = (SERVER and 0) or ply:Ping()/500
	local d = t.dir
	local vel = mv:GetVelocity()

	local newvel = t.newvel or d * 800 


	if CurTime() - time < 0 then return end 

	if CurTime() > endtime then 

		if OverrideDashFinalVel then 
			mv:SetVelocity(OverrideDashFinalVel)
		end

		if SERVER then self:SetDashEndTime(0)  end

		DashTable[ply] = nil 
		OverrideDashEnd = nil 
		OverrideDashFinalVel = nil 

		return
	end 

	local changed = self:CheckMoves(ply, mv, d)

	if not isbool(changed) then --return bool to prevent mv

		if changed or t.newvel then 
			ply:SetVelocity(changed or t.newvel)
			return 
		end

		local _ = (changed or t.newvel) and print("applied modified vel", changed or t.newvel)

		mv:SetVelocity(changed or newvel) 
	end

end)

hook.Add("StartCommand", "Dash", function(ply, cmd)

end)
function SWEP:Holster(wep)
		local owner = self:GetOwner()

		if string.find(wep.Base or "", "cw_") then
        wep.DrawSpeed=wep.DrawSpeed*3
        wep.GlobalDelay = 0
	        timer.Simple(0.2, function()  
	        	if not wep then return end
	        wep.DrawSpeed=wep.DrawSpeed/3
	        wep.GlobalDelay = 0
	        end)
        end
        
		--self.PreJumpPower = nil
		--self:StopDash()
		return true
end

function SWEP:StopDash()
	local owner = self:GetOwner()

	self:SetDashing(false)

	self:SetDashEndTime(0)
	self.Moved = false

	DashTable[owner] = nil

end



function SWEP:SecondaryAttack()

 	if DashTable[self:GetOwner()] then 
 		self:StopDash(false)
 	end

end
