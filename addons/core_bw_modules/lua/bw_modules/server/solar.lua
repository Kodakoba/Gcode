BaseWars.Solar = BaseWars.Solar or {}
local sol = BaseWars.Solar

BaseWars.Solar.SkylessPower = 4
BaseWars.Solar.SkyPower = 10

local rayPos = Vector(2.4543991088867, -32.136005401611, 3.2566497325897)
local tout = {}
local tdat = {output = tout}

local skylessPower = BaseWars.Solar.SkylessPower
local skyPower = BaseWars.Solar.SkyPower

function sol:Initialize()
	self.BaseHandle = ents.Create("bw_invismarker")
	local bh = self.BaseHandle

	local solMax = self:OBBMaxs()
	local solCenter = self:OBBCenter()

	bh:SetParent(self)
	bh.SolarAttachment = self

	bh.CustomOBB = {
		Vector(-50, -50, -200),
		Vector(50, 50, 200),
	}

	bh.Model = false
	bh:Spawn()
	bh:Activate()

	local bhMin, bhMax = unpack(bh.CustomOBB)

	local vertOff = bhMax.z - bhMin.z

	local horOff = Vector()

	horOff[1] = -(bhMax.z + bhMin.z) / 2
	horOff[2] = (bhMax.y + bhMin.y) / 2
	horOff[3] = -vertOff / 2

	bh:SetPos(horOff)

	self._LastThink = 0
	self.ForceUpdate = true
	self:Think()
	self.ForceUpdate = false
end

function sol:Think()
	if CurTime() - self._LastThink < 0.25 then return end
	self._LastThink = CurTime()

	local grid = self:GetPowerGrid()
	self:SetBaseAccess(not not grid)
	if not grid then return end

	local pos = self:LocalToWorld(rayPos)
	tdat.output = tout
	tdat.start = pos
	tdat.endpos = pos + self:GetAngles():Up() * 16384
	tdat.filter = {self}

	util.TraceLine(tdat)
	local isSky = tout.HitSky

	if isSky then
		local upd = self.ForceUpdate or self.PowerGenerated ~= skyPower
		self.PowerGenerated = skyPower

		if upd then
			grid:UpdatePowerIn()
		end
	else
		local upd = self.ForceUpdate or self.PowerGenerated ~= skylessPower
		self.PowerGenerated = skylessPower

		if upd then
			grid:UpdatePowerIn()
		end
	end

	self:SetSunAccess(isSky)
end

local function entToBoth(ent)
	if not ent:IsValid() or (not ent.SolarAttachment and ent:GetClass() ~= "bw_gen_solar") then return end

	local solar = ent:GetClass() == "bw_gen_solar" and ent or ent.SolarAttachment
	local handle = ent.SolarAttachment and ent or ent.BaseHandle

	return solar, handle
end

hook.Add("EntityExitBase", "SolarPanelAttach", function(base, ent)
	local solar, handle = entToBoth(ent)

	if not solar then return end

	local ents = base:GetEntities()
	-- this hook runs before the entity exits; the exiter will still be in the list

	-- if the solar exited with handle still inside, don't remove

	solar.ActuallyInside = solar.ActuallyInside and ent ~= solar

	if ent == solar and ents[handle] then print("disallowing exit") return false end
	if ent == handle and not solar.ActuallyInside and ents[solar] then
		ents[handle] = nil
		solar:BW_ExitBase(base)
	end

end)

hook.Add("EntityEnterBase", "SolarPanelAttach", function(base, ent)
	local solar, handle = entToBoth(ent)
	if not solar then return end

	solar.ActuallyInside = solar.ActuallyInside or ent == solar

	local ents = base:GetEntities()

	-- if the handle entered with no solar inside, add the solar as well
	if ent == handle and not ents[solar] then
		local inside = solar.ActuallyInside
		solar:BW_EnterBase(base)
		solar.ActuallyInside = inside
	end
end)