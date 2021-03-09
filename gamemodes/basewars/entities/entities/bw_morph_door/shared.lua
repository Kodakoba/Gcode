AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Admin how 2 buy door"

ENT.Model = "models/hunter/blocks/cube025x025x025.mdl"
ENT.Skin = 0

ENT.Connectable = true
ENT.Cableable = true

ENT.BoxThickness = 4
ENT.IsMorphDoor = true
ENT._UsesNetDTNotify = true

function ENT:DerivedDataTables()
	self:NetworkVar("Vector", 0, "Bound1")
	self:NetworkVar("Vector", 1, "Bound2")

	self:NetworkVar("Bool", 2, "Installed")
	self:NetworkVar("Bool", 3, "Open")

	if CLIENT then
		self:On("DTVarsChanged", "Boundzz", function(self, vars)
			local v1, v2 = vars.Bound1 and vars.Bound1[2], vars.Bound2 and vars.Bound2[2]

			if v1 and v2 and v1 ~= Vector(0, 0, 0) and v2 ~= Vector(0, 0, 0) then
				self:BoksFiziks(v1, v2)
			elseif v1 and v2 then
				print("brr")
				self:PhysicsDestroy()
				self:EnableCustomCollisions(false)
			end


			local open = vars.Open

			if open ~= nil then
				if open[2] then
					self:OnOpen()
				else
					self:OnClose()
				end
			end
		end)
	end
end

local trtbl = {
	start = nil,
	endpos = nil,

	ignoreworld = false,
	output = out
}

local sides = {}

local dist = {
	[1] = 128, 	-- 256u left/right
	[2] = 72	-- 72u up/down
}

ENT.Dists = dist

local outs = {}

for i=1, 6 do
	outs[i] = {}
end

function ENT:SHInit()

end

function ENT:CreateCollision()
	if not self.BoxMesh then
		local _, vertDist, allHit = self:GetBounds()
		if not allHit then return false end

		local mins = Vector(-self.BoxThickness, -vertDist[2], vertDist[4])
		local maxs = Vector(self.BoxThickness, vertDist[1], -vertDist[3])

		self:BoksFiziks(mins, maxs)
		return true
	end

	self:PhysicsInitConvex(self.BoxMesh)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:EnableCustomCollisions( true )
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()
end

hook.Add("ShouldCollide", "NocollideOpenDoors", function(ent1, ent2)
	if not ent1.IsMorphDoor and not ent2.IsMorphDoor then return end

	local door = ent1.IsMorphDoor and ent1 or ent2
	local other = ent1.IsMorphDoor and ent2 or ent1

	if other:IsWorld() then print("yeah", ent1, ent2, Realm()) return true end -- ALWAYS collide with world
	if door:GetOpen() then
		return false
	end
end)

function ENT:BoksFiziks(min, max)
	local x0 = min.x
	local y0 = min.y
	local z0 = min.z

	local x1 = max.x
	local y1 = max.y
	local z1 = max.z

	local mesh = {
		Vector( x0, y0, z0 ),
		Vector( x0, y0, z1 ),
		Vector( x0, y1, z0 ),
		Vector( x0, y1, z1 ),
		Vector( x1, y0, z0 ),
		Vector( x1, y0, z1 ),
		Vector( x1, y1, z0 ),
		Vector( x1, y1, z1 )
	}

	self.BoxMesh = mesh
	self:PhysicsInitConvex(mesh)

	-- Set up solidity and movetype
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Enable custom collisions on the entity
	self:EnableCustomCollisions( true )

	if SERVER then
		self:SetBound1(min)
		self:SetBound2(max)
	end

	if self.GenerateMesh then
		self:GenerateMesh(mesh)
	end

	self:SetInstalled(true)
	self:SetOpen(false)
	self:SetCustomCollisionCheck(true)
end

function ENT:GetBounds()
	sides[1], sides[2] = self:GetRight(), self:GetUp()
	local pos = self:GetPos()
	trtbl.filter = self

	local verts = {}
	local vertDist = {}

	local all_hit = true

	for i=1, 4 do
		local ind = math.ceil(i / 2)
		local dT = dist[ind]
		local mul = (i % 2 == 0 and -1) or -dT

		local dir = sides[ ind ]
		dir:Mul(mul)

		local out = outs[i]
		trtbl.output = out
		trtbl.start = pos
		trtbl.endpos = dir + pos

		util.TraceLine(trtbl)

		if CLIENT then
			render.SetColorMaterial()
			render.DrawSphere(out.HitPos, 4, 8, 8, out.Hit and Colors.Green or Colors.Red)
		end

		if all_hit then all_hit = out.Hit end
		verts[i] = out.HitPos
		vertDist[i] = out.Fraction * dT
	end

	return verts, vertDist, all_hit
end


hook.Add("PhysgunPickup", "NoPhysgunningInstalledDoors", function(ply, ent)
	if not ent.IsMorphDoor then return end
	if ent:GetInstalled() then return false end
end)