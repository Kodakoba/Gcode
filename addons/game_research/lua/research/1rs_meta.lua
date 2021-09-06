
Research.Categories = Research.Categories or {}
Research.SubCategories = Research.SubCategories or {}

Research.Perks = Research.Perks or {}
print("Included research")
rescatmeta = {}

	function rescatmeta:SetName(str)
		self.Name = str 
	end

	function rescatmeta:SetIcon(str)
		self.Icon = str 
	end

	function rescatmeta:GetName()
		return self.Name 
	end 

	function rescatmeta:GetIcon()
		return self.Icon 
	end 



		ressubcatmeta = table.Copy(rescatmeta)

		function ressubcatmeta:SetDescription(str)
			self.Description = str
		end

		function ressubcatmeta:GetDescription(str)
			return self.Description
		end
		function ressubcatmeta:AddPerk(perk)
			if not perk.ID then error("Tried adding a non-perk to subcategory " .. self:GetName() .. "!") return end 
			self.Perks[perk.ID] = perk
			Research.Perks[perk.Name] = perk
		end

		ressubcatobj = {}
		ressubcatobj.__index = ressubcatmeta


	function rescatmeta:SetID(id)
		self.ID = tonumber(id)
	end

	function rescatmeta:GetID()
		return self.ID 
	end

	function rescatmeta:GetSubCategories()
		return self.SubCats 
	end 

	function rescatmeta:AddSubCategory(...)

		local name, icon, desc

		if istable(...) then 
			local t = ...

			name, icon, desc = t.Name, t.Icon, t.Desc or t.Description
		else 

			name, icon, desc = unpack({...})

		end

		local subcat = ressubcatobj:new(name, icon, desc)

		self.SubCats[name] = subcat
		Research.SubCategories[name] = subcat 

		return subcat
	end

rescatobj = {}
rescatobj.__index = rescatmeta

setmetatable(rescatobj, rescatmeta)

	function rescatobj:new(id, name, icon)
		local cat = {}
		setmetatable(cat, rescatobj)

		cat:SetID(id)
		cat:SetName(name)
		cat:SetIcon(icon)

		cat.SubCats = {}

		return cat
	end


setmetatable(ressubcatobj, ressubcatmeta)

	function ressubcatobj:new(name, icon, desc)
		local subcat = {}
		setmetatable(subcat, ressubcatobj)

		subcat:SetDescription(desc)
		subcat:SetName(name)
		subcat:SetIcon(icon)

		subcat.Perks = {}

		return subcat
	end

function Research.AddCategory(id, name, icon)

	local cat = rescatobj:new(id, name, icon)
	Research.Categories[id] = cat

	return cat
end


resperkmeta = {}
local perkmeta = resperkmeta
function perkmeta:SetName(str)
	self.Name = str 
end

function perkmeta:SetID(id)
	self.ID = id
end

function perkmeta:GetName()
	return self.Name 
end 

function perkmeta:GetID()
	return self.ID 
end 

function perkmeta:GetLevels()
	return self.Levels 
end

function perkmeta:GetRequirements(lv)
	return (self.Levels[lv] and self.Levels[lv].reqs) or false
end

function perkmeta:AddLevel(req)
	self.Levels[#self.Levels + 1] = {reqs = req}
end

function perkmeta:GetIcon()
	return self.Icon 
end

function perkmeta:SetIcon(str)
	self.Icon = str 
end

function perkmeta:SetDescription(str)
	local desc = tostring(str)

	self.Description = desc
end

local function HandleEntYield(what, self)

	local ylds = {}

	for k,v in pairs(what) do 
		local ent = scripted_ents.Get(v.Class)

		if v.Class and ent then 
			local t = {}

			t.ent = ent
			t.name = v.Name or ent.PrintName or "[Undefined name!]"
			t.desc = v.Description
			t.icon = v.Icon
			t.model = v.Model

			ylds[#ylds + 1] = t
		else 
			error("Missing Class in perk " .. self.Name .. " or entity with this class doesn't exist! (" .. v.Class or "[UNDEFINED]" .. ")")
		end

	end
	return ylds
end

--[[
	Name = string,
	Description = table {
		{	
			txt = string,
			col = color,
			font = string
		},

		...
	},
	
	Model = string, --path to model;  takes priority over Icon if exists
	Icon = table { url = string, name = string } OR IMaterial
	
]]

local aliases = {
	Name = "name",
	Description = "desc",
	Icon = "icon",
	Model = "model",
}

function perkmeta:AddYield(typ, what, lv)

	local curlv = self.Levels[lv or #self.Levels]

	if not curlv then 
		self.Levels[lv or #self.levels] = {}
		curlv = self.Levels[lv or #self.levels]
	end 


	if typ:lower() == "ents" then 

		local ylds = HandleEntYield(what, self)

		curlv.Yields = ylds

		return 
	end

	local ylds = {}

	for num, yield in pairs(what) do
		local yld = {}

		for k, val in pairs(yield) do 

			local key = aliases[k] or k

			yld[key] = val
		end

		ylds[num] = yld
	end

	curlv.Yields = ylds

end

function perkmeta:SetPos(lv, x, y)
	local lev = self.Levels[lv] or {}
	lev.Pos = {}

	lev.Pos.x = x 
	lev.Pos.y = y

	self.Levels[lv] = lev
end

function perkmeta:GetDescription()
	return self.Description or "No description provided!"
end 

perkobj = {}
perkobj.__index = perkmeta

setmetatable(perkobj, perkmeta)

function perkobj:new()
	local tbl = {}
	setmetatable(tbl, perkobj)

	tbl.Levels = {}

	return tbl
end




--name, ID, icon
--OR
--{Name = name, ID = id, misc = misc}

function Research.AddPerk(...)
	local perk = perkobj:new()
	local enum

	if not istable(...) then

		local args = {...}
		enum = args

		perk:SetName(args[1])
		perk:SetID(args[2])

	else 

		local args = ...
		enum = args

		perk:SetName(args.Name)
		perk:SetID(args.ID)

		args.Name, args.ID = nil, nil 

		table.Merge(perk, args)

	end

	Research.EnumPerk(perk)

	return perk
end

function Research.EnumPerk(prk)
	local cur = Research.CurID
	local id = prk:GetID()

	if Research.IDs[id] then 
		Research.IDs[Research.IDs[id].NumID] = prk
		Research.IDs[id] = prk

		prk.NumID = cur
	else
		Research.IDs[prk:GetID()] = prk 
		Research.IDs[cur] = prk 

		prk.NumID = cur

		Research.CurID = Research.CurID + 1
	end

end



local PLAYER = FindMetaTable("Player")

function PLAYER:GetPerk(name)
	return 0
end