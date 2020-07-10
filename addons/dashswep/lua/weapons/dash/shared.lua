
if not GachiRP then easylua.StartWeapon("dash") end

setfenv(0, _G)

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
		hdl.DownloadFile("http://vaati.net/Gachi/shared/whoosh.ogg", "whoosh.dat")
		self:SetPredictable(false)
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
	self:SetDashCharges(1)
end


function SWEP:Think()

	if self:GetOwner():IsOnGround() and not DashTable[self:GetOwner()] and self:GetDashCharges() ~= 1 and not (CLIENT and self:GetDashing()) then --hmmmmmmmmmmmmmmmm

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
	if not IsFirstTimePredicted() then return end

	local dt = DashTable[owner]

	if dt.ground then

		if dt.jump or dt.down then return end


		local tr = util.TraceHull({
			start = owner:GetPos() + Vector(0, 0, 8),
			endpos = owner:GetPos() - Vector(0, 0, 16),
			filter = owner,
			mins = Vector( -16, -16, -4 ),
			maxs = Vector( 16, 16, 4 ),
			mask = MASK_SOLID
		})

		if tr.Hit then

			local vel

			if ducked then

				vel = dir * 2350
				vel.z = 300

			else
				vel = dir * 1500
				vel.z = 400
			end


			self:SetSuperMoving(true)

			if SERVER then
				self:StopDash()

				--self.Owner:SetNetworkOrigin(mv:GetOrigin())
				--mv:SetVelocity(vel)
				owner:SetPos(mv:GetOrigin())

				return vel

			elseif not self.StoppedDash then

				--owner:SetVelocity(vel)
				dt.newvel = vel/2

				--OverrideDashEnd = CurTime()
				--OverrideDashFinalVel = vel

				mv:SetVelocity(vel)

				self.StoppedDash = CurTime()

				--self:StopDash()

				return vel
			end

		end

	else --Dash started in mid-air

		if dt.jump or not dt.down then return end --Player must've dashed without space and dashed downwards

		local tr = util.TraceHull({
			start = owner:GetPos() + Vector(0, 0, 8),
			endpos = owner:GetPos() - Vector(0, 0, 24),
			filter = owner,
			mins = Vector( -16, -16, -4 ),
			maxs = Vector( 16, 16, 4 ),
			mask = MASK_SOLID
		})

		if tr.Hit then

			local vel

			local ang = dir:Angle()
			local strength = ang.p --the lower they aimed their dash, the more it will be

			local dir = Vector()
			dir:Set(dt.dir)
			dir.z = math.min(-dir.z, 0.9)

			local mul = 2000 * (1 - dir.z)

			vel = dir * mul
			vel.z = math.max(vel.z * (dir.z > 0.6 and (0.5 / (1 - dir.z)) or 1), 400)

			if SERVER then

				self:StopDash()

				owner:SetPos(mv:GetOrigin())

				--mv:SetVelocity(vel)
				return vel

			elseif not self.StoppedDash then

				--self:StopDash()

				dt.newvel = vel/2

				mv:SetVelocity(vel)

				self.StoppedDash = CurTime()

				return vel
			end

		end
	end

end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	if not IsFirstTimePredicted() or DashTable[owner] then return end

	if self:GetDashCharges() <= 0 or self.Dashed then return end

	self:SetDashCharges(self:GetDashCharges() - 1)

	if CLIENT then
		self.Dashed = true
		--self:EmitSound("dash/whoosh.ogg", 45)
		sound.PlayFile("data/hdl/whoosh.dat", "", function() end)
	end

	if SERVER then self:SetDashEndTime(CurTime() + self.DashTime) end
	self:SetDashing(true)
	local dir = owner:EyeAngles():Forward()
	local z = dir.z


	if z > -0.15 and z < 0.20 then
		dir.z = 0.1
	end

	if CLIENT then

		DashTable[owner] = {
			t = CurTime() + owner:Ping() / 1000,
			dir = dir,
			wep = self,
			ground = owner:IsOnGround(),
		}

	else

		DashTable[owner] = {
			t = CurTime(),
			dir = dir,
			wep = self,
			ground = owner:IsOnGround(),
		}

	end
	local dt = DashTable[owner]


	dt.ground = owner:IsOnGround()

	dt.jump = owner:KeyDown(IN_JUMP)
	dt.down = dir.z < -0.15

	--

	self:SetNextPrimaryFire(CurTime() + 0.4)

end

function Realm()
	return (CLIENT and "Client") or "Server" --for debugging prediction
end
hook.Remove("Move", "Dash")
hook.Add("FinishMove", "Dash", function(ply, mv, cmd)
	local dash = ply:GetActiveWeapon()

	if not dash or not dash:IsValid() or not dash.IsDash then return end

	if dash.EndSuperMove and SERVER then
		if mv:GetVelocity():Length() < 800 or ply:IsOnGround() then
			dash:SetSuperMoving(false)
		end
	end
	if not DashTable[ply] then return end

	if CLIENT and ply ~= LocalPlayer() then
		return
	end

	local t =  DashTable[ply]
	local self = t.wep
	if not IsValid(self) then DashTable[ply] = nil self.StoppedDash = nil return end

	local time = t.t
	local endtime = OverrideDashEnd or (CLIENT and self:GetDashEndTime()~=0 and self:GetDashEndTime() + 0.6) or t.t + self.DashTime
	local ping = (SERVER and ply:Ping()/2000) or 0
	local d = t.dir
	local vel = mv:GetVelocity()

	local newvel = t.newvel or d * 800

	--print(endtime, Realm(), "dont mind me just spamming numbers")
	if CurTime() - time < 0 then return end

	if CurTime() > endtime + ping then

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
		self.StoppedDash = nil
		return
	end

	local changed = self:CheckMoves(ply, mv, d)

	if isvector(changed) then --return bool to prevent mv
		--if not IsFirstTimePredicted() and CLIENT then return end

		ply:SetVelocity(-mv:GetVelocity() + changed)

		--self:StopDash()

		--mv:SetVelocity(changed)
	else
		mv:SetVelocity(newvel)
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
	local dasht = (IsValid(dash) and dash:GetTable())
	if dasht and (dasht.GetDashing and dasht.GetSuperMoving) and (dash:GetDashing() or dash:GetSuperMoving()) or DashTable[ply] then

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

	if wep.CW20Weapon then
		local oldMult = wep.DrawSpeedMult
		wep.DrawSpeedMult = wep.DrawSpeedMult * 3
		wep.GlobalDelay = 0
		wep:recalculateDeployTime()

		timer.Simple(0.2, function()
			if not IsValid(wep) then return end
			wep.DrawSpeedMult = wep.DrawSpeedMult / 3
			wep.GlobalDelay = 0
			wep:recalculateDeployTime()
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
	self.StoppedDash = nil

	DashTable[owner] = nil

end



function SWEP:SecondaryAttack()

	if DashTable[self:GetOwner()] then
		self:StopDash(false)
	end

end

if not GachiRP then easylua.EndWeapon("dash") end