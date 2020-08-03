BaseWars.Menu = BaseWars.Menu or {
	Tabs = {}, -- ["name"] = {onOpenFunc, onCloseFunc, onCreateTabFunc(bw_frame, tab), ["Order"] = ?, ["IsDefault"] = true/false}

	Frame = nil, --will be a panel

	Fonts = {}
}

if IsValid(BaseWars.Menu.Frame) then BaseWars.Menu.Frame:Remove() end

local PopoutTime = 0
local fonts = BaseWars.Menu.Fonts

function BaseWars.Menu.ReScale()

	local scale = ScrH() / 1080

	fonts.Sizes = fonts.Sizes or {}
	local sz = fonts.Sizes

	sz.Big = 20 + 16 * scale
	sz.MediumBig = 16 + 16 * scale
	sz.Medium = 10 + 16 * scale
	sz.Small = 8 + 12 * scale

	for k,v in pairs(sz) do
		surface.CreateFont("BWMenu_" .. k, {
			font = "Open Sans Regular",
			size = v
		})

		fonts[k] = "BWMenu_" .. k
	end

	fonts.BoldSizes = fonts.BoldSizes or {}
	local bsz = fonts.BoldSizes

	bsz.Small = 8 + 16 * scale
	bsz.Medium = 16 + 12 * scale

	for k,v in pairs(bsz) do
		surface.CreateFont("BWMenu_Bold" .. k, {
			font = "Open Sans SemiBold",
			size = v
		})

		fonts["Bold" .. k] = "BWMenu_Bold" .. k
	end
end

BaseWars.Menu.ReScale()

hook.Add("OnScreenSizeChanged", "BWMenuScale", BaseWars.Menu.ReScale)

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
	f:SetRetractedSize(f:GetRetractedSize() * 1.2)
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