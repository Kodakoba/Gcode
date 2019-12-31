
SWEP.Author			= "grmx"
SWEP.Contact			= ""
SWEP.Purpose			= ""

 
SWEP.Spawnable			= true
 
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.DrawAmmo = false

SWEP.IsDash = true
SWEP.Primary.Automatic = false
SWEP.DashTime = 0.3

function SWEP:SetupDataTables()

	self:NetworkVar("Int", 0, "DashCharges")

	self:NetworkVar("Bool", 0, "Dashing")
	self:NetworkVar("Bool", 1, "SuperMoving")

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

		if tr.Hit then
			
			local vel = dir * 1000


			if ducked then 

				vel = dir * 2000
				vel.z = 2000

			else 
				vel.z = 3500
			end

			
			self:SetSuperMoving(true)

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
	self:SetDashing(true)
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
	local dash = ply:GetWeapon("dash")
	if not IsValid(dash) then return end 

	if dash.EndSuperMove and SERVER then 
		if mv:GetVelocity():Length() < 800 or ply:IsOnGround() then 
			dash:SetSuperMoving(false)
		end
	end
	if not DashTable[ply] then return end 

	if CLIENT and ply~=LocalPlayer() then 
		return 
	end

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
			self:SetSuperMoving(false)
		end

		if SERVER then 
			self:SetDashEndTime(0) 
			self:SetDashing(false) 
			self.EndSuperMove = true 
		end

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

		mv:SetVelocity(changed or newvel) 
	end

end)

local trails = {}

local st = 0
local two = math.pi/2 
local fin = math.pi

local trail = Material("models/props_combine/stasisshield_sheet")
trail:SetFloat("$refractamount", 0.05)

trail:SetFloat("$alpha", 1)

hook.Add("PostPlayerDraw", "Dash", function(ply)
	local t = trails[ply]
	local dash = ply:GetWeapon("dash")

	if IsValid(dash) and (dash:GetDashing() or dash:GetSuperMoving()) or DashTable[ply] then 

		local widmul = (dash:GetDashing() or DashTable[ply]) and 15 or 8

		local wid = math.min(ply:GetVelocity():Length() / 50, widmul)
		
		t = t or {}

		trails[ply] = t

		local pos = ply:GetPos()
		local cent = ply:OBBCenter()
		cent:Mul(1.5)
		pos:Add(cent)

		t[#t + 1] = {pos, CurTime(), wid}
	elseif t then
		if #t == 0 or CurTime() - t[#t][2] > 1 then trails[ply] = nil return end 
	end

	if not t then return end 

	local rems = {}

	render.StartBeam(#t)

		for i=1, #t do
			local time = (CurTime() - t[i][2])
	
			local one = Lerp(time, two, fin)
			local two = Lerp((time - 0.3)*2, fin, two)


			local sin = math.sin(two)
			local wid = math.abs(1 - sin) * t[i][3]

			render.SetMaterial(trail)

			render.AddBeam(t[i][1], wid, 1/i, Color(255, 255, 255))
			if wid < 0.5 then rems[#rems + 1] = i end
		end

	render.EndBeam()

	for k,v in ipairs(rems) do
		table.remove(t, v) 
	end
end)

function SWEP:Holster(wep)
	local owner = self:GetOwner()

	if string.find(wep.Base or "", "cw_") then

	    wep.DrawSpeed=wep.DrawSpeed*3
	    wep.GlobalDelay = 0

        timer.Simple(0.2, function()  
        	if not IsValid(wep) then return end
	        wep.DrawSpeed=wep.DrawSpeed/3
	        wep.GlobalDelay = 0
        end)
        
    end

	return true
end

function SWEP:StopDash()
	local owner = self:GetOwner()

	self:SetDashing(false)


	self:SetDashEndTime(0)
	self.Moved = false
	self.EndSuperMove = true

	DashTable[owner] = nil

end



function SWEP:SecondaryAttack()

 	if DashTable[self:GetOwner()] then 
 		self:StopDash(false)
 	end

end
