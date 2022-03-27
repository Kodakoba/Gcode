include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self.BoneAngle = Angle(0, 0, 0)
end

function ENT:Interp(to)
	-- very lazy
	self.BoneAngle = LerpAngle(FrameTime() * 10, self.BoneAngle, to)
end

local laser = Material("effects/bluelaser2")
local glare = Material("effects/whiteflare")

local offCpy = Vector()
local vcpy = Vector()
local angCpy = Angle()

local laserColors = {
	friendly = Color(0, 200, 70),
	hostile = Color(0, 255, 255)
}

local glareColors = {
	friendly = Color(70, 200, 70),
	hostile = Color(200, 70, 70),
	idle = Color(250, 250, 250),
}

local colVec = Vector()
local boneIdx = ENT.BoneIndex

function ENT:Think()
	if not self:IsPowered() then return end

	local tgt = self:GetTarget()
	local bpos, _ = self:GetBonePosition(boneIdx)
	local cang = self:GetAngles()

	local ang = self.BoneAngle or Angle()
	self.BoneAngle = ang -- autorefresh

	if IsValid(tgt) and not self:IsState("IDLE") then
		local pos = tgt:EyePos()
		local nang = (pos - bpos):Angle()

		local np = nang.y - cang.y

		np = math.ApproachAngle(ang[1], np, FrameTime() * 360) -- linear to avoid easing on tiny diffs
		ang[1] = np
		ang[3] = 0
	else
		angCpy:Zero()
		angCpy.p = math.sin(CurTime() * 0.5) * math.deg(self.Angle) / 2
		angCpy.r = math.cos(CurTime() * 0.75) * 4
		self:Interp(angCpy)
	end

	self:ManipulateBoneAngles(boneIdx, ang)
end

function ENT:DrawGlare(bpos, ang)
	local col = self:IsState("FRIENDLY") and glareColors.friendly or
			self:IsState("FIRING") and glareColors.hostile or
			glareColors.idle

	local glareSz = 16

	offCpy:Set(self.GlareOffset)
	offCpy:Rotate(ang)
	offCpy:Add(bpos)

	render.SetMaterial(glare)
	render.DrawSprite(offCpy, glareSz, glareSz, col)
end

function ENT:DrawLaser(bpos, ang, fromPos, toPos, tgt)
	local dist = toPos:Distance(fromPos)

	local col = self:IsState("FRIENDLY") and laserColors.friendly
		or laserColors.hostile

	render.SetMaterial(laser)

	colVec:SetUnpacked(col.r / 255, col.g / 255, col.b / 255)
	laser:SetVector("$color", colVec)
	render.DrawBeam(fromPos, toPos, 0.5, dist / 32 / 2, -dist / 32 / 2, col)

	colVec:SetUnpacked(1, 1, 1)
	laser:SetVector("$color", colVec)
end

function ENT:GetLaserFrom(bpos, ang, tgt)
	if not tgt:IsValid() then return false end

	offCpy:Set(self.LaserOffset)
	offCpy:Rotate(ang)
	offCpy:Add(bpos)

	return offCpy
end

function ENT:GetLaserTo(bpos, ang, tgt, offset)
	local toPos

	if tgt == CachedLocalPlayer() and not CachedLocalPlayer():ShouldDrawLocalPlayer() then
		toPos = EyePos()
		toPos.z = toPos.z - 16

		local distBack = 1

		vcpy:Set(toPos)
		vcpy:Sub(offset)
		vcpy.z = 0
		vcpy:Normalize() -- normal (turret -> me)
		vcpy:Mul(distBack)

		toPos:Sub(vcpy) -- sub the normal so the lasers dont intersect
		toPos:Sub(offset)
		local len = toPos:Length()
		toPos:Mul( len / (len + distBack) )
		toPos:Add(offset)
	else
		toPos = tgt:GetPos() + tgt:OBBCenter()
	end

	return toPos
end

function ENT:Draw(f)
	if not self:IsPowered() or halo.RenderedEntity() == self then
		self:DrawModel()
		return
	end

	local tgt = self:GetTarget()

	self.BoneAngle = self.BoneAngle or Angle()
	self:DrawModel()

	local bpos, ang = self:GetBonePosition(boneIdx)
	local offset = self:GetLaserFrom(bpos, ang, tgt)
	if offset then
		local to = self:GetLaserTo(bpos, ang, tgt, offset)

		self:DrawLaser(bpos, ang, offset, to, tgt)
	end

	self:DrawGlare(bpos, ang)
end