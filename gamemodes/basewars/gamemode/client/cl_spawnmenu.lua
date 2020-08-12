


local gens = BaseWars.Generators
local SpawnList = BaseWars.SpawnList

local function IsGroup(ply, group)
	if not ply.CheckGroup then error("what the fuck where's ULX") return end
	if not IsValid(ply) or not ply:IsPlayer() then return end

	if ply:CheckGroup(string.lower(group)) or (ply:IsAdmin() and (group=="vip" or group=="trusted")) or ply:IsSuperAdmin() then
		return true
	end

	return false

end

local tohide = {}

hook.Add("OnSpawnMenuClose", "RemoveClouds", function()	--grrrrrrrrrr

	for k,v in pairs(tohide) do
		if not IsValid(v) then tohide[k] = nil continue end

		v:Remove()
	end

end)

if not Icon then
	include("lib_it_up/classes/icon.lua")
end

local treetabs = {

	entities = {
		Name = "Entities",
		Icon = Icon("https://i.imgur.com/1a5sZQc.png", "entities56.png"):SetSize(28, 28),
	},

	loadout = {
		Name = "Loadout",
		Icon = "icon16/gun.png",
	},

	printers = {
		Name = "Printers",
		Icon = Icon("https://i.imgur.com/vzrqPxk.png", "coins_pound64.png"):SetSize(28, 28),
	},

	recreational = {
		Name = "Recreational",
		Icon = Icon("https://i.imgur.com/tKMbV5S.png", "gamepad56.png"):SetSize(28, 28),
	},

}

--https://i.imgur.com/s5Xbx2b.png

local function createSubCategory(canv, name, items)
	local pnl = vgui.Create("DPanel", canv)
	pnl:Dock(TOP)
	pnl:DockMargin(0, 8, 0, 4)
	pnl:SetTall(96)
end

local function openCategory(pnl, btn)
	local cat = btn.Category
	if not SpawnList[cat] then
		errorf("attempt to open unknown basewars spawnlist category: %s", cat)
		return
	end

	local canv = vgui.Create("FScrollPanel", pnl)
	canv:SetSize(pnl:GetSize())
	canv.NoDraw = true
	canv:GetCanvas():DockPadding(8, 36, 8, 4)


	local boxcol = Colors.Gray:Copy()
	boxcol.a = 210

	local titleCol = color_white:Copy()
	local h, s, v = titleCol:ToHSV()
	draw.ColorModHSV(titleCol, h, s - 0.1, v - 0.1)

	local iconCol = draw.ColorModHSV(titleCol:Copy(), h, s, v + 0.1)
	local ic = IsIcon(btn.Icon) and btn.Icon:Copy()

	local iconPadding = 4
	local boxPadding = 8

	if ic then
		ic:SetColor(iconCol)
	end

	canv:GetCanvas().Paint = function(self, w, h)
		surface.SetFont("BS32")

		local tw = (surface.GetTextSize(cat))
		local tx = w/2 - tw/2

		if ic then
			tw = tw + (ic:GetSize()) + iconPadding
			tx = w/2 - tw/2 + (ic:GetSize()) + iconPadding
		end

		draw.RoundedBox(8, w/2 - tw/2 - boxPadding, 5, tw + boxPadding * 2, 34, boxcol)

		if ic then
			ic:Paint(w/2 - tw/2, 8)
		end

		surface.SetTextPos(tx, 8)
		surface.SetTextColor(titleCol)
		surface.DrawText(cat)
	end

	pnl:AddCatCanvas(canv)

	for subcat, items in pairs(SpawnList[cat]) do
		print("creating subcat", subcat)
		local b = createSubCategory(canv, subcat, items)
	end
end

local function MakeSpawnList()

	local pnl = vgui.Create("InvisPanel")	-- main canvas for the entire basewars tab

	local its -- items list on the right; predefined

	local cats = vgui.Create("FScrollPanel", pnl)
	cats:GetCanvas():DockPadding(0, 4, 0, 4)
	cats:Dock(LEFT)
	cats:SetWide(192)
	cats:DockMargin(0, 24, 16, 0)
	cats.GradBorder = true
	cats.BackgroundColor = Color(200, 200, 200)

	for k,v in SortedPairsByMemberValue(treetabs, "Name") do
		local tab = vgui.Create("FButton", cats)
		tab:Dock(TOP)
		tab:SetTall(32)
		tab:DockMargin(0, 0, 0, 0)
		tab.NoDraw = true
		tab.Category = v.Name
		tab.Icon = v.Icon

		if IsIcon(v.Icon) then
			v.Icon:SetColor(Colors.LightGray)
			v.Icon:SetFilter(true)
		end

		function tab:PostPaint(w, h)
			local x = 4

			if IsIcon(v.Icon) then
				local iw, ih = v.Icon:GetSize()
				v.Icon:Paint(x, h/2 - ih/2)
				x = x + iw + 4
			end

			draw.SimpleText(v.Name, "BS28", x, h/2, Colors.LightGray, 0, 1)
		end

		function tab:DoClick()
			openCategory(its, tab)
		end
	end

	its = vgui.Create("GradPanel", pnl)
	its:Dock(FILL)
	its:SetColor(Color(130, 130, 130))

	function its:AddCatCanvas(new)
		if IsValid(self.oldCanvas) then
			self.oldCanvas:To("Y", 16, 0.2, 0, 1.8)
			self.oldCanvas:PopOut(0.15, 0.05)
			self.oldCanvas:SetZPos(15)
		end

		self.oldCanvas = new
		new:PopIn()
		new.X = new.X - 16
		new:To("X", 0, 0.3, 0, 0.3)
	end

	return pnl

end

local spawnMenuTabs = {}

local function RemoveTabs()

	local ply = LocalPlayer()
	if not ply or not IsValid(ply) then return end

	--local Admin = ply:IsAdmin()

	function spawnmenu.Reload()
		for k,v in pairs(spawnMenuTabs) do
			spawnmenu.AddCreationTab(k, v.Function, v.Icon, v.Order)
		end
		RunConsoleCommand("spawnmenu_reload")

	end


	function spawnmenu.RemoveCreationTab(blah)
		spawnMenuTabs[blah] = spawnmenu.GetCreationTabs()[blah]
		spawnmenu.GetCreationTabs()[blah] = nil

	end

	spawnmenu.RemoveCreationTab("#spawnmenu.category.saves")
	spawnmenu.RemoveCreationTab("#spawnmenu.category.dupes")
	spawnmenu.RemoveCreationTab("#spawnmenu.category.postprocess")

	--if not Admin then

		spawnmenu.RemoveCreationTab("#spawnmenu.category.vehicles")
		spawnmenu.RemoveCreationTab("#spawnmenu.category.weapons")
		spawnmenu.RemoveCreationTab("#spawnmenu.category.npcs")
		--spawnmenu.RemoveCreationTab("#spawnmenu.category.entities")

	--end

	spawnmenu.Reload()

end


language.Add("spawnmenu.category.basewars", "BaseWars")
spawnmenu.AddCreationTab("#spawnmenu.category.basewars", MakeSpawnList, "icon16/building.png", BaseWars.Config.RestrictProps and -100 or 2)

if GetConVar("developer"):GetInt() < 1 then
	hook.Add("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs", RemoveTabs)
	RemoveTabs()
else

	hook.Remove("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs")
	RunConsoleCommand("spawnmenu_reload")
end
