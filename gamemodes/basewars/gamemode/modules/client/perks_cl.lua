
MODULE.Name = "Perks (CL)"
MODULE.Realm = 2

if SERVER then return end 

Perks = Perks or {}
local err = Material("__error")

Perks.Data = Perks.Data or {}

perkmeta = {}
perkmeta.__index = perkmeta

function perkmeta:GetEffect()
	return self.PerkEffect 
end

function perkmeta:GetID()
	return self.PerkID
end
function perkmeta:GetUID()
	return self.PerkUID
end

function perkmeta:GetData()
	if not self.PerkData then 
		self.PerkData = Perks.List[self:GetID()]
	end
	return self.PerkData
end

function perkmeta:GetDescription()
	local desc = self:GetData().desc

	if isfunction(self:GetData().eff) then
		desc = desc:format(self:GetData().eff(self.PerkID, self.PerkEffect))
	end

	return desc
end


function perkmeta:GetIcon()
	return self:GetData().mat
end


function perkmeta:GetName(rarpref)
	local name = self:GetData().name
	if rarpref then 
		local info = self:GetData()
		local eff = self:GetEffect()
		local col = Color(0,0,0)
		local pref = "Rusty"
		for k,v in ipairs(info.rar or {}) do 

			local next = info.rar[k+1]
			if not next then 
				col = v.col
				pref = v.prefix
				break 
			end

			if eff >= v.start and eff >= next.start then continue end

			if eff < next.start and eff >= v.start then 
				col = v.col
				pref = v.prefix
				break
			end

		end
		return pref .. " " .. name, col
	end
	return name
end

function perkmeta:IsSpecial()
	return self.PerkEffect > 190
end

local shorts = {
	PerkID = "i",
	PerkUID = "u",
	PerkEffect = "e",
	Equipped = "q",
}
local longs = {}

for k,v in pairs(shorts) do 
	longs[v] = k 
end

net.Receive("FetchPerks", function(len)
	--local amt = net.ReadUInt(16)
	local tbl = {}
	len = len/8
	local col = (len < 100 and Color(75, 200, 75)) or (len < 250 and Color(150, 150, 50)) or Color(200, 75, 75)
	MsgC(Color(70, 200, 250), "[Perks] Net message length: ", col, len, "\n")
	if Perks.Debug then
		MsgC(Color(70, 200, 250), "	Contents:", col, "\n")
	end
	local dlen = net.ReadUInt(32)
	local dat = net.ReadData(dlen)
	local json = util.Decompress(dat)

	if not json then json = dat end

	local ctbl = util.JSONToTable(json)

	for uid, perk in pairs(ctbl) do 
		tbl[uid] = {}
		local tbl = tbl[uid]

		for k, v in pairs(perk) do

			if longs[k] then 
				tbl[longs[k]] = tonumber(v) or v
			else 
				tbl[k] = tonumber(v) or v
			end

		end
		tbl = setmetatable(tbl, perkmeta)

	end

	if Perks.Debug then
		for k,v in pairs(tbl) do 
			MsgC(Color(60, 180, 220), "		ID: ", color_white, v.PerkID, "\n")
			MsgC(Color(60, 180, 220), "		UID: ", color_white, v.PerkUID, "\n")
			MsgC(Color(60, 180, 220), "		Effect: ", color_white, v.PerkEffect, "\n")
			MsgC(Color(60, 180, 220), "		Equipped: ", (v.Equipped~=0 and Color(100, 200, 100)) or Color(200, 120, 120), v.Equipped, "\n")
			MsgC("\n")
		end
	end

	Perks.Data = tbl

	hook.Run("PerksFetched", Perks.Data)

end)

function CreatePerkFrame(uid, par)

	local info = Perks.Data[uid]
	if not info then return end 

	local perk = vgui.Create("FButton", par)
	perk.RBRadius = 0
	perk.DrawShadow = false

	local name, col = info:GetName(true)
	local desc = info:GetDescription()
	local icon = info:GetIcon()

	local id = info.PerkID
	local eff = info.PerkEffect or -1

	function perk:Paint(w,h)
		self:Draw(w,h)

		surface.SetDrawColor(col)
		self:DrawGradientBorder(w,h, 3, 3)

		surface.SetMaterial(icon)
		surface.DrawTexturedRect(4, 4, h-8, h-8)

		draw.SimpleText(name, "TWB24", h-8 + 12, 4, color_white, 0, 5)
		draw.SimpleText(desc, "TW18", 4 + h-8 + 8, 32, color_white, 0, 5)
	end

	perk.UID = uid 
	perk.ID = id

	perk.Name = name 
	perk.Desc = desc 
	perk.Icon = icon 
	perk.Effect = eff

	return perk
end

--[[
snus2 = CreateMaterial("swedishpizza2", "VertexLitGeneric", { 
	["$basetexture"] = "../data/hdl/lava.vtf", 
	["$model"] = 1, 
	["Proxies"] = {
		["AnimatedTexture"] = { 
			["animatedTextureVar"] = "$basetexture",
			["animatedTextureFrameNumVar"] = "$frame",
			["animatedTextureFrameRate"] = "18",
		}
	}
	
})

hook.Add("HUDPaint", "DrawMat", function() surface.SetMaterial(snus2) surface.DrawTexturedRect(0, 0, 64, 64) end)
]]