include("shared.lua")
AddCSLuaFile("shared.lua")

local wheel

local function makeWheel(ent)
	if wheel then wheel._Core = ent return wheel end

	local wh = LibItUp.InteractWheel:new()
	wh._Core = ent
	wheel = wh

	if ent:GetClaimed() then

		local view = wh:AddOption("View Base", "Upgrades, modules, stats, etc.")
			view:On("Select", function()
				wheel._Core:OpenBaseView()
			end)

	else
		local claim = wh:AddOption("Claim Base", "Yo this our turf now",
				Icons.Flag128:Copy():SetSize(106 * 0.75, 128 * 0.75))
			claim:On("Select", function()
				wheel._Core:AttemptClaim()
			end)

		local exam = wh:AddOption("Examine Base", "See fuel supply and inventory space.\n(NYI)",
				Icons.MagnifyingGlass128:Copy():SetSize(96, 96))
			exam:On("Select", function()
				wheel._Core:AttemptClaim()
			end)
	end

	return wh
end

local colThroughWalls = Colors.Sky:Copy():ModHSV(0, -0.1, -0.1)
local colObeyZ = Colors.Greenish:Copy():ModHSV(0, 0.1, 0.1)

function ENT:Initialize()
	self.Colors = {
		colThroughWalls:Copy(),
		colObeyZ:Copy()
	}

	self.HaloTable = {self}
	self.Claimed = false
	self.Using = 0
end

local useTime = 0.3

function ENT:Draw()
	self:DrawModel()
	if halo.RenderedEntity() == self then
		render.CullMode(1)
			self:DrawModel()
		render.CullMode(0)
	end
	local lp = LocalPlayer()
	local myBaseID = self:GetBaseID()
	if not myBaseID then print(self, "has no fuckin base ID?") return end

	local base = BaseWars.Bases.GetBase(myBaseID)
	if not base then print(self, myBaseID, "didn't find base with that ID?") return end

	if lp:BW_GetBase() ~= base then return end

	local using = lp:KeyDown(IN_USE) and lp:GetEyeTrace().Entity == self and lp:GetEyeTrace().Fraction * 32768 < 96

	if using then
		self.Using = math.min(self.Using + FrameTime(), useTime)
	else
		self.Using = math.max(0, self.Using - FrameTime() * 2)
		if wheel and wheel._Core == self then
			wheel:Hide()
			wheel = nil
		end
	end

	if self.Using == useTime and not wheel then
		local wh = makeWheel(self)
		wh:Show()
	end
end

function ENT:AttemptClaim()
	net.Start("BaseCore")
		net.WriteUInt(BaseWars.Bases.Actions.Claim, BaseWars.Bases.Actions.SZ)
		net.WriteEntity(self)
	net.SendToServer()
end

function ENT:OpenBaseView()
	BaseWars.Bases.BaseView.Activate(self)
end

hook.Add("NotifyShouldTransmit", "BaseCoreHalo", function(e, add)
	if not add then return end
	if not BaseWars.Bases.IsCore(e) then return end

	local ENT = scripted_ents.GetStored("bw_basecore").t
	local base = ENT.GetBase(e) -- fucking gmod is insane
	if not base then print(e, myBaseID, "didn't find base with that ID when entered PVS?") return end

	base:SetBaseCore(e)
end)


hook.Add("PreDrawHalos", "BaseCoreHalo", function()
	local lp = LocalPlayer()
	local base = lp:BW_GetBase()
	if not base then return end

	local core = base:GetBaseCore()
	if not core or not core:IsValid() then return end

	local dist = lp:GetPos():Distance(core:GetPos())
	local fr = math.max(math.min( (dist - 96) / 96, (768 - dist) / 512, 1 ), 0)

	if fr > 0 then
		local h,s,v = colObeyZ:ToHSV()

		core.Colors[2]:SetHSV(h, s * fr, v * fr)
		halo.Add(core.HaloTable, core.Colors[2], fr * 3, fr * 3, 3, true, false)
	end

	local blur = math.min(2, fr * 18)
	if blur > 0 then
		local h,s,v = colThroughWalls:ToHSV()
		core.Colors[1]:SetHSV( h, s, v * (blur / 2) )
		halo.Add(core.HaloTable, core.Colors[1], blur, blur, 1, true, true)
	end

end)