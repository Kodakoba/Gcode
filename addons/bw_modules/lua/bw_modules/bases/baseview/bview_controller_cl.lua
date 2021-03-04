local bw = BaseWars.Bases
local bv = bw.BaseView

local cont = bv.Controller or Emitter:extend()
bv.Controller = cont
bv.Controllers = {} -- [baseID] = Controller


function cont:Initialize(ent, base)
	CheckArg(1, ent, bw.IsCore)

	base = base or ent:GetBase()
	if not base or not base:IsValid() then
		errorf("Entity %s had an invalid base assigned (%s)", ent, base)
		return
	end

	if bv.Controllers[base:GetID()] then
		bv.Controllers[base:GetID()]:Destroy()
	end

	bv.Controllers[base:GetID()] = self

	self:SetBaseCore(ent)
	self:SetBase(base)
	self.VGUI = nil
end

ChainAccessor(cont, "BaseCore", "BaseCore")
ChainAccessor(cont, "Base", "Base")
ChainAccessor(cont, "VGUI", "VGUI")

function cont:Activate()
	self:Emit("Activate")
end

function cont:Deactivate()
	self:Emit("Deactivate")
end

function cont:Destroy()
	self:Emit("Destroy")
end

function bv.Activate(core)
	local base = core:GetBase()
	if not base or not base:IsValid() then
		errorf("Entity %s had an invalid base assigned (%s)", ent, base)
		return
	end

	if bv.Controllers[base:GetID()] then
		bv.Controllers[base:GetID()]:Activate()
	end
end

hook.Add("NotifyShouldTransmit", "BaseViewController", function(e, add)
	if not add then return end
	if e:GetClass() ~= "bw_basecore" then return end

	local ENT = scripted_ents.GetStored("bw_basecore").t
	local base = ENT.GetBase(e) -- fucking gmod is insane
	if not base then print(self, myBaseID, "didn't find base with that ID when entered PVS?") return end

	bv.Controller:new(e, base)
end)