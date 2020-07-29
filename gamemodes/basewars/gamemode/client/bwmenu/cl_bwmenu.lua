BaseWars.Menu = BaseWars.Menu or {
	Tabs = {}, -- ["name"] = {onOpenFunc, onCloseFunc, onCreateTabFunc(bw_frame, tab), ["Order"] = ?, ["IsDefault"] = true/false}

	Frame = nil, --will be a panel
}

if IsValid(BaseWars.Menu.Frame) then BaseWars.Menu.Frame:Remove() end

local PopoutTime = 0

local function CreateBWFrame()
	local f = vgui.Create("NavFrame")

	BaseWars.Menu.Frame = f

	f.Scale = math.max(ScrH() / 1080, 0.6)
	local sc = f.Scale
	f:SetSize(sc * 800, sc * 600)
	f:Center()
	f:MakePopup()
	f.Shadow = {}

	f:PopIn()

	function f:Disappear()
		self:PopOut(nil, nil, function()
			self:Remove()
			PopoutTime = CurTime()
		end)
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)
	end

	function f:OnKeyCodePressed(key)
		if key == KEY_F3 then
			self:Disappear()
		end
	end

	local sorted = {}

	for name, funcs in pairs(BaseWars.Menu.Tabs) do
		sorted[#sorted + 1] = {name, funcs.Order or 0, funcs}
	end

	table.sort(sorted, function(a, b)
		return a[2] > b[2]
	end)

	for _, data in ipairs(sorted) do

--[[	{
			[1] = "Name",
			[2] = order_number,
			[3] = {
				openFunc,
				closeFunc,
				createTabFunc
			}
		}	]]

		local name = data[1]
		local funcs = data[3]

		local tab = f:AddTab(name, funcs[1], funcs[2])
		if funcs[3] then
			funcs[3] (f, tab)
		end

		if funcs.IsDefault then
			f:SelectTab(name, true)
		end
	end
end

hook.Add("PlayerButtonDown", "BaseWarsMenu", function(ply, btn)
	if btn ~= KEY_F3 then return end
	if not IsFirstTimePredicted() then return end

	local wep = LocalPlayer():GetActiveWeapon()
	if wep ~= NULL and wep.CW20Weapon and wep.dt.State == (CW_CUSTOMIZE or 4) then return end

	if IsValid(BaseWars.Menu.Frame) then return end
	if math.abs(PopoutTime - CurTime()) <= 0.1 then return end

	CreateBWFrame()

end)


include("cl_factions_ext.lua")
include("cl_raids_ext.lua")