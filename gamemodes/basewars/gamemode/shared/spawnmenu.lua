
local SpawnList = {}
BaseWars.Limits = BaseWars.Limits or {}
BaseWars.Purchased = BaseWars.Purchased or {}

BaseWars.Generators = BaseWars.Generators or {}
local gens = BaseWars.Generators
SpawnList = BaseWars.SpawnList

local function LimitDeduct(self, ent, ply)

	self.o_OnRemove = self.OnRemove
	local sid = ""

	if IsValid(ply) then
		sid = ply:SteamID64()
	end

	local entname = ent
	local sent = sid .. entname

	self:CallOnRemove("LimitDeduct"..sid, function(ent, sid)
		if not BaseWars.Limits[sent] then return end

		BaseWars.Limits[sent] = BaseWars.Limits[sent] - 1

		BaseWars.Purchased[sid] = BaseWars.Purchased[sid] or {}
		BaseWars.Purchased[sid][entname] = (BaseWars.Purchased[sid][entname] or 1) - 1
	end, sid )

	BaseWars.Limits[sent] = BaseWars.Limits[sent] + 1

	BaseWars.Purchased[sid] = BaseWars.Purchased[sid] or {}
	BaseWars.Purchased[sid][entname] = (BaseWars.Purchased[sid][entname] or 0) + 1
end

local function IsGroup(ply, group)
	if not ply.CheckGroup then error("what the fuck where's ULX") return end
	if not IsValid(ply) or not ply:IsPlayer() then return end

	if ply:CheckGroup(string.lower(group)) or (ply:IsAdmin() and (group=="vip" or group=="trusted")) or ply:IsSuperAdmin() then
		return true
	end

	return false

end


if SERVER then

	function BWSpawn(ply, cat, subcat, num)
		num = tonumber(num)

		if ply.IsBanned and ply:IsBanned() then return end

		if not ply:Alive() then ply:Notify(Language.DeadBuy, BASEWARS_NOTIFICATION_ERROR) return end

		local l = SpawnList and SpawnList.Models

		if not l then print("no spawnlist") return end

		if not cat or not num then print("no cat or num") return end

		local i = l[cat]

		if not i then print("no cat:", cat) return end

		i = i[subcat]

		if not i then print("no subcat:", subcat) return end

		i = i[num]

		if not i then print("no item:", num) return end

		local item = i.Name
		local model, price, ent, sf, lim, vip, trust = i.Model, i.Price, i.ClassName, i.UseSpawnFunc, i.Limit, i.vip, i.trust
		local gun, drug, raidpurchase = i.Gun, i.Drug, i.Raid

		if vip and not IsGroup(ply, "vip") then ply:EmitSound("buttons/button10.wav") return end
		if trust and not IsGroup(ply, "trusted") then ply:EmitSound("buttons/button10.wav") return end
		local sid64 = ply:SteamID64()

		local level = i.Level
		if gun and (not level or level < BaseWars.Config.LevelSettings.BuyWeapons) then level = BaseWars.Config.LevelSettings.BuyWeapons end

		if level and not ply:HasLevel(level) then

			ply:EmitSound("buttons/button10.wav")

		return end

		local tr

		if ent then

			tr = {}

			tr.start = ply:EyePos()
			tr.endpos = tr.start + ply:GetAimVector() * 85
			tr.filter = ply

			tr = util.TraceLine(tr)

		else

			tr = ply:GetEyeTraceNoCursor()

			if not tr.Hit then return end

		end

		local SpawnPos = tr.HitPos + BaseWars.Config.SpawnOffset
		local SpawnAng = ply:EyeAngles()
		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180
		SpawnAng.y = math.Round(SpawnAng.y / 45) * 45

		if not gun and not drug and not raidpurchase and ply:InRaid() then

			ply:Notify(Language.CannotPurchaseRaid, BASEWARS_NOTIFICATION_ERROR)

		return end

		if lim then

			local Amount = BaseWars.Limits[sid64 .. ent] or 0
			BaseWars.Limits[sid64 .. ent] = Amount

			if lim and lim <= Amount then

				ply:Notify(string.format(Language.EntLimitReached, item), BASEWARS_NOTIFICATION_ERROR)

			return end

		end

		local Res, Msg

		if gun then

			Res, Msg = hook.Run("BaseWars_PlayerCanBuyGun", ply, ent) -- Player, Gun class

		elseif ent then

			Res, Msg = hook.Run("BaseWars_PlayerCanBuyEntity", ply, ent) -- Player, Entity class

		end

		if Res == false then
			if Msg then
				ply:Notify(Msg, BASEWARS_NOTIFICATION_ERROR)
			end
		return end

		if price > 0 then

			local plyMoney = ply:GetMoney()

			if plyMoney < price then

				ply:Notify(Language.SpawnMenuMoney, BASEWARS_NOTIFICATION_ERROR)

			return end

			ply:SetMoney(plyMoney - price)
			ply:EmitSound("mvm/mvm_money_pickup.wav")

			ply:Notify(string.format(Language.SpawnMenuBuy, item, BaseWars.NumberFormat(price)), BASEWARS_NOTIFICATION_MONEY)

		end

		if gun then

			local Ent = ents.Create("bw_weapon")
				Ent.WeaponClass = ent
				Ent.Model = model
				Ent:SetPos(SpawnPos)
				Ent:SetAngles(SpawnAng)
				Ent:Spawn()
				Ent:Activate()
				Ent.Bought = true

			if lim then
				LimitDeduct(Ent, ent, ply)
			end

			hook.Run("BaseWars_PlayerBuyGun", ply, Ent) -- Player, Gun entity

		return end


		local prop
		local noundo

		if ent then

			local newEnt = ents.Create(ent)

			if not newEnt then return end


			if newEnt.SpawnFunction and sf then

				newEnt = newEnt:SpawnFunction(ply, tr, ent)

				if newEnt.CPPISetOwner then

					newEnt:CPPISetOwner(ply)
					newEnt.Bought = true

				end

				if lim then

					LimitDeduct(newEnt, ent, ply)

				end

				newEnt.CurrentValue = price
				if newEnt.SetUpgradeCost then newEnt:SetUpgradeCost(price) end

				newEnt.DoNotDuplicate = true

				hook.Run("BaseWars_PlayerBuyEntity", ply, newEnt) -- Player, Entity

			return end

			if lim then
				LimitDeduct(newEnt, ent, ply)
			end


			if newEnt.IsGenerator then
				gens[sid64] = (gens[sid64] or 0) + 1
			end

			newEnt.CurrentValue = price
			if newEnt.SetUpgradeCost then newEnt:SetUpgradeCost(price) end

			newEnt.DoNotDuplicate = true

			prop = newEnt
			noundo = true

		end

		if not prop then prop = ents.Create(ent or "prop_physics") end
		if not noundo then undo.Create("prop") end

		if not prop or not IsValid(prop) then return end

		prop:SetPos(SpawnPos)
		prop:SetAngles(SpawnAng)

		if model and not ent then

			prop:SetModel(model)

		end

		if lim and not ent then

			LimitDeduct(prop, ent, ply)

		end

		prop:Spawn()
		prop:Activate()

		prop:DropToFloor()

		local phys = prop:GetPhysicsObject()

		if IsValid(phys) then

			if i.ShouldFreeze then

				phys:EnableMotion(false)

			end

		end

		undo.AddEntity(prop)
		undo.SetPlayer(ply)
		undo.Finish()

		if prop.CPPISetOwner then

			prop:CPPISetOwner(ply)

		end

		if ent then

			hook.Run("BaseWars_PlayerBuyEntity", ply, prop) -- Player, Entity

		else

			hook.Run("BaseWars_PlayerBuyProp", ply, prop) -- Player, Prop

		end

	end

	concommand.Add("basewars_spawn",function(ply,_,args)

		if not IsValid(ply) then return end
		BWSpawn(ply, args[1], args[2], args[3], args[4])

	end)

	local function Disallow_Spawning(ply, ...)

		--BaseWars.UTIL.Log(ply, ...)

		if not ply:IsAdmin()  then

			ply:Notify(Language.UseSpawnMenu, BASEWARS_NOTIFICATION_ERROR)
			return false

		end

	end

	local name = "BaseWars.Disallow_Spawning"

	if BaseWars.Config.RestrictProps then

		hook.Add("PlayerSpawnObject", 	name, Disallow_Spawning)

	end

	hook.Add("PlayerSpawnSENT", 	name, Disallow_Spawning)
	hook.Add("PlayerGiveSWEP", 		name, Disallow_Spawning)
	hook.Add("PlayerSpawnSWEP", 	name, Disallow_Spawning)
	hook.Add("PlayerSpawnVehicle", 	name, Disallow_Spawning)

return end

language.Add("spawnmenu.category.basewars", "BaseWars")

local white = Color(255, 255, 255)
local gray = Color(192, 192, 192)
local black = Color(0, 0, 0)
local errorcolor = Color(255, 100, 100)
local highlight = Color(100, 100, 100, 200)

local white = Color(255, 255, 255)
local trans = Color(0, 0, 0, 0)

local blue 	= Color(0, 90, 200, 180)
local green = Color(90, 200, 0, 180)
local grey	= Color(90, 90, 90, 180)
local red	= Color(200, 0, 20, 180)

local shade = Color(0, 0, 0, 200)

local blueEnough = Color(80, 110, 220, 180)
local greenEnough = Color(120, 200, 120, 200)
local lvlLocked = Color(80, 80, 80, 220)
local notEnough = Color(200, 100, 100)


local SpawnList = BaseWars.SpawnList

if not SpawnList then return end

local Models = SpawnList.Models

local tohide = {}

hook.Add("OnSpawnMenuClose", "RemoveClouds", function()	--grrrrrrrrrr

	for k,v in pairs(tohide) do
		if not IsValid(v) then tohide[k] = nil continue end

		v:Remove()
	end

end)

local function MakeTab(type)

	if not Models[type] then return end

	local cats = vgui.Create("DCategoryList")

	function cats:Paint() end

	for catName, subT in SortedPairs(Models[type]) do

		local cat = cats:Add(catName)

		local iLayout = vgui.Create("DIconLayout", cat)

		iLayout:Dock(FILL)

		iLayout:SetSpaceX(4)
		iLayout:SetSpaceY(4)


		local topair = {}

		for k,v in pairs(subT) do
			v.Key = k
			topair[#topair + 1] = v
		end

		table.sort(topair, function(a, b)
			local ret = false

			local lv = a.Level < b.Level

			if not lv and a.Level == b.Level then
				ret = a.Price < b.Price
			else
				ret = lv
			end

			return ret
		end)

		--creating item buttons

		for id, tab in ipairs(topair) do


			local model = tab.Model
			local money = tab.Price
			local level = tab.Level or 0
            local tooltip = tab.Tooltip or ""
            local vip = tab.vip
            local trust = tab.trust
            local name = tab.Name or tostring(v.Key)

            if tooltip~="" then tooltip="\n" .. tooltip end
			if tab.Gun and (not level or level < BaseWars.Config.LevelSettings.BuyWeapons) then level = BaseWars.Config.LevelSettings.BuyWeapons end

			if not IsValid(iLayout) then return end

			local fr = iLayout:Add("FButton")

			fr:SetSize(80, 80)
			fr:SetText("")

			fr.Border = {w=2, h=2}

			fr.borderColor = Colors.LighterGray:Copy()

			fr:SetDoubleClickingEnabled(false)
			local fw, fh = 80, 80

			tohide[#tohide+1] = p

			local mcol = (LocalPlayer():GetMoney() >= money and Color(100, 220, 100)) or Color(240, 70, 70)
			local lvcol = (LocalPlayer():GetLevel() >= level and Color(100, 130, 250)) or Color(240, 70, 70)

			--p:AddSeperator(nil, 8, 4)

			local mstr = Language.Currency .. BaseWars.NumberFormat(money)



			function fr:OnHover()
				local cl = self:GetCloud("price")

				if not cl then
					cl = self:AddCloud("price", name)
					cl.MaxW = 256
					cl:SetRelPos(40, 0)
					cl:AddFormattedText(mstr, mcol, "OS24", 20, 1)
					cl:AddFormattedText("LV" .. tostring(level), lvcol, "OS24", 20, 2)
					cl.RemoveWhenDone = true

					tohide[#tohide + 1] = cl
				end

				cl:Popup(true)
			end

			function fr:OnUnhover()
				self:RemoveCloud("price")
			end

			-- https://i.imgur.com/CNRTtIj.png

			local frcol = Color(0, 0, 0)
			local set = false
			function fr:PrePaint()

				local haslv = LocalPlayer():GetLevel() >= level

				local enuff = LocalPlayer():GetMoney() >= money
				local wayenuff = enuff and LocalPlayer():GetMoney() >= money*50

				local col = (not haslv and lvlLocked) or (wayenuff and blueEnough) or (enuff and greenEnough) or notEnough

				if not set then
					frcol:Set(col)
				else
					LC(frcol, col)
				end


				self:SetColor(frcol.r, frcol.g, frcol.b, frcol.a)

				local mcol = (LocalPlayer():GetMoney() >= money and Colors.Money) or Colors.Red
				local lvcol = (LocalPlayer():GetLevel() >= level and Colors.Sky) or Colors.Red

				local cl = self:GetCloud("price")

				if cl then
					cl.DoneText[1].Color = LC(cl.DoneText[1].Color, mcol, 15)
					cl.DoneText[2].Color = LC(cl.DoneText[2].Color, lvcol, 15)
				end

				LC(fr.borderColor, Colors.LighterGray, 5)
			end

			local ty = 0

			function fr:PaintOver(w, h)
				if not self:IsHovered() then
					ty = L(ty, 4, 15)
				else
					ty = L(ty, -32, 15)
				end

				local name = tab.ShortName or name

				if not isstring(name) then name = "no_str" .. (tostring(name)) end
				local len = utf8.len(name)

				if len >= 12 then
					name = string.sub(name, 0, 10) .. ".."
				end

				draw.SimpleText(name, "OS16", w/2, ty, color_white, 1, 5)
			end

			local icon = vgui.Create("SpawnIcon", fr)
			icon:SetModel(model)
			icon:SetTooltip(name .. (money > 0 and " (" .. Language.CURRENCY .. BaseWars.NumberFormat(money) .. ")" or "") ..  tooltip)
			icon:SetSize(64, 64)
			icon:SetPos(8, fh/2 - 32)
			icon:SetMouseInputEnabled(false)

			local function Clicc()

				fr.borderColor:Set(color_white)

				local HasLevel = not level or LocalPlayer():HasLevel(level)
				if not HasLevel then

					surface.PlaySound("buttons/button10.wav")

				return end

				local myMoney = LocalPlayer():GetMoney()

				surface.PlaySound("ui/buttonclickrelease.wav")

				local function DoIt()
					print("rannnn")
					RunConsoleCommand("basewars_spawn", type, catName, tab.Key)

				end

				if (money > 0) and not (myMoney / 20 > money) then

					if myMoney < money then

						Derma_Message(Language.SpawnMenuMoney, "Error")

					return end

					Derma_Query(string.format(Language.SpawnMenuBuyConfirm, name, BaseWars.NumberFormat(money)),
						Language.SpawnMenuConf, "   " .. Language.Yes .. "   ", DoIt, "   " .. Language.No .. "   ")

				else

					DoIt()

				end

			end

			function fr:DoClick()
				Clicc()
			end
			function icon:DoClick()
				Clicc()
			end

		end

		cat:SetContents(iLayout)
		cat:SetExpanded(true)

	end

	return cats
end

local treetabs = {

	entities = {
		Name = "Entities",
		AssociatedPanel = "Entities",
		Icon = "icon16/bricks.png",
	},

	loadout = {
		Name = "Loadout",
		AssociatedPanel = "Loadout",
		Icon = "icon16/gun.png",
	},

    printers = {
        Name = "Printers",
        AssociatedPanel = "Printers",
        Icon = "icon16/money.png",
    },

    recreational = {
        Name = "Recreational",
        AssociatedPanel = "Recreational",
        Icon = "icon16/star.png",
    },

}

local function MakeSpawnList()

	local pnl = vgui.Create("InvisPanel")	--main

	local cats = vgui.Create("InvisPanel", pnl)
	cats:Dock(LEFT)
	cats:SetWide(192)
	cats:DockMargin(0, 24, 16, 0)

	local its = vgui.Create("DPanel", pnl)
	its:Dock(FILL)


	local tree = vgui.Create("DTree", cats)
	tree:Dock(FILL)

	local main = tree:AddNode("BaseWars")
	main:SetExpanded(true, true)
	main:SetIcon("icon16/application_put.png")

	local sel

	for k,v in SortedPairs(treetabs) do

		local node = main:AddNode(v.Name)

		if v.Icon then
			node:SetIcon(v.Icon)
		end
		node.sel = v.AssociatedPanel

	end

	function tree:OnNodeSelected(pnl)
		if IsValid(sel) then sel:PopOut() end
		if not pnl.sel then return end

		sel = MakeTab(pnl.sel)
		sel:SetParent(its)
		sel:Dock(FILL)
		sel:PopIn()

	end

	return pnl

end

spawnmenu.AddCreationTab("#spawnmenu.category.basewars", MakeSpawnList, "icon16/building.png", BaseWars.Config.RestrictProps and -100 or 2)

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

if GetConVar("developer"):GetInt() < 1 then

	hook.Add("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs", RemoveTabs)
	RemoveTabs()

else

	hook.Remove("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs")
	RunConsoleCommand("spawnmenu_reload")
end
