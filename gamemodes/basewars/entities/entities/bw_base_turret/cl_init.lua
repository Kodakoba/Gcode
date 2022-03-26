include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self.BoneAngle = Angle(0, 0, 0)
end

-- ENT.BoneAngle = Angle(0, 0, 0)

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

local boneIdx = 1

function ENT:Draw(f)
	if not self:IsPowered() or halo.RenderedEntity() == self then
		self:DrawModel()
		return
	end

	local tgt = self:GetTarget()
	local cang = self:GetAngles()

	local ang = self.BoneAngle or Angle()
	self.BoneAngle = ang -- autorefresh

	if IsValid(tgt) and not self:IsState("IDLE") then
		local pos = tgt:EyePos()
		local nang = (pos - self:GetBonePosition(boneIdx)):Angle()
		local np = nang.y - cang.y

		np = math.ApproachAngle(self.BoneAngle[1], np, FrameTime() * 480) -- linear to avoid easing on tiny diffs
		self.BoneAngle[1] = np
	else
		angCpy:Zero()
		angCpy.p = math.sin(CurTime() * 0.5) * math.deg(self.Angle) / 2
		angCpy.r = math.cos(CurTime() * 0.75) * 4
		self:Interp(angCpy)
	end

	self:ManipulateBoneAngles(boneIdx, ang)
	self:DrawModel()

	offCpy:Set(self.LaserOffset)
	angCpy:Set(ang)
	angCpy.y = angCpy.p
	angCpy.p = 0
	offCpy:Rotate(angCpy)

	local offset = self:LocalToWorld(offCpy)
	if IsValid(tgt) then
		local toPos

		if tgt == CachedLocalPlayer() then
			toPos = EyePos()
			toPos.z = toPos.z - 16

			local distBack = 1

			vcpy:Set(toPos)
			vcpy:Sub(offset)
			vcpy.z = 0
			vcpy:Normalize()
			vcpy:Mul(-distBack)

			toPos:Add(vcpy)
			toPos:Sub(offset)
			local len = toPos:Length()
			toPos:Mul( len / (len + distBack) )
			toPos:Add(offset)
		else
			toPos = tgt:LocalToWorld(tgt:OBBCenter())
		end

		local dist = toPos:Distance(offset)

		local col = self:IsState("FRIENDLY") and laserColors.friendly
			or laserColors.hostile

		render.SetMaterial(laser)

		colVec:SetUnpacked(col.r / 255, col.g / 255, col.b / 255)
		laser:SetVector("$color", colVec)
		render.DrawBeam(offset, toPos, 0.5, dist / 32 / 2, -dist / 32 / 2, col)

		colVec:SetUnpacked(1, 1, 1)
		laser:SetVector("$color", colVec)
	end

	local col = self:IsState("FRIENDLY") and glareColors.friendly or
			self:IsState("FIRING") and glareColors.hostile or
			glareColors.idle


	local glareSz = 16

	local bpos, ang = self:GetBonePosition(boneIdx)

	offCpy:Set(self.GlareOffset)
	offCpy:Rotate(ang)
	offCpy:Add(bpos)

	render.SetMaterial(glare)
	render.DrawSprite(offCpy, glareSz, glareSz, col)

	--[[cang:RotateAroundAxis(fwd, 90)
	cang:RotateAroundAxis(cang:Right(), -90)

	cam.Start3D2D(offset + Vector(0, 0, 16), cang, 0.1)
		draw.SimpleText("state: " .. self:GetStateEnum(), "OSB64", 0, 0, color_white, 1, 1)
	cam.End3D2D()]]
end