BaseWars.Solar = BaseWars.Solar or {}
local sol = BaseWars.Solar

local rayPos = Vector(2.4543991088867, -32.136005401611, 3.2566497325897)
local tout = {}
local tdat = {output = tout}

local skylessPower = BaseWars.Solar.SkylessPower
local skyPower = BaseWars.Solar.SkyPower

function sol:Initialize()
	self.BaseHandle = ents.Create("bw_invismarker")
	local bh = self.BaseHandle

	bh:SetParent(self)
	bh:SetPos(self:GetPos() + Vector(0, 0, -192))
	bh.SolarAttachment = self
	bh:Spawn()

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
	tdat.start = pos
	tdat.endpos = pos + self:GetAngles():Up() * 16384,

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