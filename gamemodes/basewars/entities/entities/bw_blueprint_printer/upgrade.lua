AddCSLuaFile()

ENT.LevelsData = {
	[1] = {
		Slots = 2,
		PrintTime = 60,
		Cost = 0,
	},

	[2] = {
		Slots = 3,
		PrintTime = 45,
		Cost = 2.5e6,
	},

	[3] = {
		Slots = 4,
		PrintTime = 30,
		Cost = 50e6,
	},

	[4] = {
		Slots = 6,
		PrintTime = 25,
		Cost = 500e6,
	},

	[5] = {
		Slots = 8,
		PrintTime = 20,
		Cost = 5e9,
	},
}

function ENT:GetUpgradeCost(lv)
	local dat = self.LevelsData[ lv or (self:GetLevel() + 1) ]
	if not dat then return end

	return dat.Cost
end

function ENT:DoUpgrade(lv)
	if not self.Storage then self:SHInit() end

	lv = lv or self:GetLevel() + 1

	self.Level = lv

	if SERVER then
		local calcM = self:GetUpgradeCost(lv)
		BaseWars.Worth.Add(self, calcM)

		self:SetLevel(self.Level)
	end

	local dat = self.LevelsData[self.Level]

	self.Slots = dat.Slots
	self.PrintTime = dat.PrintTime
	self.Storage.MaxItems = self.Slots

	self:SetNextFinish(math.min(CurTime() + self.PrintTime, self:GetNextFinish()))
	self:CalculateScrollSpeed()
end

function ENT:RequestUpgrade(ply, cur, total)
	if not ply then return end

	local ow = self:BW_GetOwner()

	if GetPlayerInfo(ply) ~= ow then
		ply:Notify("You can't upgrade others' entities!", BASEWARS_NOTIFICATION_ERROR)
		return false
	end

	local plyM = ply:GetMoney()
	local calcM = self:GetUpgradeCost()

	if not calcM then
		ply:Notify(BaseWars.LANG.UpgradeMaxLevel, BASEWARS_NOTIFICATION_ERROR)
		return false
	end

	if plyM < calcM then
		ply:Notify(BaseWars.LANG.UpgradeNoMoney, BASEWARS_NOTIFICATION_ERROR)
		return false
	end

	ply:TakeMoney(calcM)

	self:DoUpgrade(self:GetLevel() + 1)

	if cur == total then
		self:EmitSound("replay/rendercomplete.wav")
	end
end