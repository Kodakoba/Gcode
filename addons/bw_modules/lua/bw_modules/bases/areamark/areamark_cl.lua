--

--BaseWars.Bases.MarkTool:Finish()

local nw = Networkable("BW_Areas")

nw:On("ReadChangeValue", "ReadServerAreas", function(self, k)
	if k ~= "CurrentAreas" then return end

	local amt = net.ReadUInt(16)

	self:Set(k, self:Get(k) or {})

	local poses = self:Get(k)

	for i=1, amt do
		local k = net.ReadUInt(16)

		if not exists then
			poses[k] = nil
		else
			local origin = net.ReadVector()
			local mins, maxs = net.ReadVector()
			poses[k] = {origin, mins, maxs}
		end
	end

	return poses
end)

local TOOL = BaseWars.Bases.MarkTool

local STATE_FIRST = 0
local STATE_SECOND = 1
local STATE_CONFIRM = 2

TOOL.State = STATE_FIRST
TOOL.ConfirmedStateUCMD = 0

TOOL.CurrentArea = {}

TOOL.Information = {}
TOOL.Name = "[sadmin] AreaMark"
TOOL.Category = "Admin Tools"
TOOL.CurrentBase = nil

function TOOL:DrawHUD()
	return false
end

function TOOL:LeftClick(tr)
	local ucmd = LocalPlayer():GetCurrentCommand():CommandNumber()

	if not IsFirstTimePredicted() then
		local ret = self.State < STATE_CONFIRM or ucmd == self.ConfirmedStateUCMD
		print("predicted ret", ret)
		return ret
	end

	if self.State < STATE_CONFIRM then
		print("added state", self.State)
		self.CurrentArea[self.State] = tr.HitPos
		self.State = self.State + 1

		if self.State == STATE_CONFIRM then
			OrderVectors(self.CurrentArea[0], self.CurrentArea[1])
			self.ConfirmedStateUCMD = ucmd
		end

		return true
	end

	return false -- first pred
end

function TOOL:RightClick(tr)
	if self.State == 3 then
		print("Creating area:", unpack(self.CurrentArea))
		self.State = STATE_FIRST
		table.Empty(self.CurrentArea)
		return true
	elseif self.State > 0 then
		self.CurrentArea[self.State] = nil
		self.State = self.State - 1
	end
end

function TOOL:DrawToolScreen(w, h)
	surface.SetDrawColor(color_black)
	surface.DrawRect(0, 0, w, h)
end

TOOL:Finish()