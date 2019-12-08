
SWEP.Author			= "1488khz gachi remix"
SWEP.Contact			= ""
SWEP.Purpose			= ""

 
SWEP.Spawnable			= true
 
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.DrawAmmo = false
SWEP.Primary.Automatic = false


function SWEP:SetupDataTables()

	self:NetworkVar("Int",0,"DashCharges")
	self:NetworkVar("Bool",1,"Dashing")
	self:NetworkVar("Float",2,"DashTime")
	self:NetworkVar("Vector",3,"DashDir")
end

function SWEP:Initialize()
	self:SetDashCharges(1)
	self:SetDashing(false)
	self:SetDashTime(CurTime())
	self.DashInfo = {}
	self.refilled = false
	self.Moved = false
	hook.Add("GetFallDamage", "DashFall", function(ply)
 		if ply:GetActiveWeapon() == self and self:GetDashTime() - CurTime() > -5 then 
 			ply:EmitSound("dash/land.ogg", 70, 100, 1, CHAN_AUTO)
 			return 0 
 		end
 	
 	end)

end

function SWEP:Reload()
	self:SetDashCharges(1)
end


function SWEP:Think()	
	if CLIENT then self:Think2() end

	if not self.DashInfo then self.DashInfo = {} end

	local owner = self:GetOwner()

	if owner:IsOnGround() and not self:GetDashing() and self:GetDashTime() - CurTime() < -0.3 then
		self.Moved = false
		if self.refilled and self:GetDashCharges()==0 then 
			owner:EmitSound("dash/rerefill.ogg", 50, 100, 1, CHAN_WEAPON)
		end 

		self:SetDashCharges(1) 
		
		self.refilled=false
	end

	if not self:GetDashing() then return end

	if CurTime()-self:GetDashTime() > 0.2 then self.DashInfo.CanReplenish = true end

	if CurTime()-self:GetDashTime() > 0.4 then self:StopDash() return end

	local dir=self:GetDashDir()

	if SERVER and self:CheckMoves(owner, dir) then self:StopDash(true) return end


	if self.HitPos:Distance(owner:GetPos()) < 76 then self:StopDash() return end

	

	owner:SetVelocity(dir-owner:GetVelocity())
end
 

function SWEP:CheckMoves(owner, dir)
--keep in mind, every condition was registered only once: at the start of the dash
--return true to stop dash

	local info = self.DashInfo
	local newDir
	local jumpComplete = false

	if info.HeldJump then return end
	if not info.MovePossible then return end

	if not owner:KeyDown(IN_JUMP) then return end	--this one is being checked every tick tho

	

	if info.InAir and dir.z < -100 and dir.z > -900 and owner:IsOnGround() then

		local mult = 400 / dir.z
		newDir = Vector(dir.x * ( (500 + dir.z) /250), dir.y * ( (500 + dir.z) /250) , -dir.z*2  )
		owner:SetVelocity(newDir)

		self:SetDashDir(newDir)
		jumpComplete = true
		info.MovePossible = false
		if CLIENT then
		owner:EmitSound("dash/duckjump.ogg", 60, math.min(mult*-100,254), 1, CHAN_AUTO)
		self.Moved = true
		end
		return jumpComplete, newDir
		
	end

	if not info.InAir and owner:Crouching() then

		if self.DashInfo.CanReplenish then 

			self:SetDashCharges(self:GetDashCharges()+1) 

			if CLIENT then 
				owner:EmitSound("dash/refill.ogg", 60, 100, 1, CHAN_AUTO)
			end

			self.refilled=true

		end

		

		newDir = Vector(dir.x/1.5, dir.y/1.5, 300)
		self:SetDashDir(newDir)
		owner:SetVelocity(newDir)

		jumpComplete = true
		info.MovePossible = false
		self.Moved = true
		if not self.refilled and CLIENT then owner:EmitSound("dash/duckjump.ogg", 60, 100, 1, CHAN_AUTO) end
		return jumpComplete, newDir
	end

end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if self:GetDashCharges() < 1 then return end
	self:SetDashCharges(self:GetDashCharges() - 1)
	self:SetDashing(true)
 	self:SetDashTime(CurTime())

 	if not self.PreJumpPower then 
 	self.PreJumpPower = owner:GetJumpPower()
 	end
 	owner:SetJumpPower(0)

 	local tr=util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector()*1000,
        filter = self.Owner})

    self.HitPos = tr.HitPos or Vector(0,0,0)

 	if owner:IsOnGround() then 
 		owner:SetPos(owner:GetPos()+Vector(0,0,5)) 
 		owner:SetNetworkOrigin(owner:GetPos()) 
 	end

 		self:SetDashDir(owner:GetAimVector() * 1000)
 

 	self:EmitSound("dash/whoosh.ogg", 60, 100, 1, CHAN_AUTO)
 	
 	self.DashInfo.InAir = not owner:IsOnGround()
 	self.DashInfo.MovePossible = true
 	print('Set!')
 	self.DashInfo.HeldJump = false--owner:KeyDown(IN_JUMP)
 	self.DashInfo.CanReplenish = false

 	if CLIENT then 

 		hook.Add("Move", "PlayerInDash", function(ply,m)
 			if not ply==owner then return end

 			if not self or not self.GetDashing then hook.Remove("Move", "PlayerInDash") return end
			if not self:GetDashing() then return end
			if self.Moved then return end
 			local vel = m:GetVelocity()
 			local dir = self:GetDashDir()
 			local moved, newdir = self:CheckMoves(ply, dir)
 			
 			if moved and newdir then
 				m:SetVelocity(newdir)
 				print(newdir)
 				print('AY YALL WE JUMPED HEYYYYYYYYYYYYYYY')
 				self.Moved = true
 				hook.Remove("Move", "PlayerInDash")
 			else
 				m:SetVelocity(Vector(vel[1],vel[2], dir[3]))
 				print('meh')
 			end

 			return false
 		end)

 	end

end

function SWEP:Holster(wep)
		local owner = self:GetOwner()

		if CLIENT then self:Holster2() end

		if SERVER then
			if owner:GetJumpPower() == 0 then 
			owner:SetJumpPower(self.PreJumpPower)
			end
		end

		if string.find(wep.Base or "", "cw_") then
        wep.DrawSpeed=wep.DrawSpeed*3
        wep.GlobalDelay = 0
	        timer.Simple(0.2, function()  
	        	if not wep then return end
	        wep.DrawSpeed=wep.DrawSpeed/3
	        wep.GlobalDelay = 0
	        end)
        end
        
		self.PreJumpPower = nil
		self:StopDash()
		return true
end

function SWEP:StopDash(moved)
	local owner = self:GetOwner()
	self:SetDashing(false)
	if moved then owner:SetVelocity(self:GetDashDir()) end
	self:SetDashDir(Vector(0,0,0))
	--self.DashInfo = {}
	if SERVER then
		if owner:GetJumpPower() == 0 then 
		owner:SetJumpPower(self.PreJumpPower)
		end
	end
	self.PreJumpPower = nil
end



function SWEP:SecondaryAttack()
 
end
