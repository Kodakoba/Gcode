local PLAYER = debug.getregistry().Player 
print('hello title')

function PLAYER:SetTitle(txt, fromdb)

	if not txt and not fromdb then 
		self:SetPData("Title", "")
		self:SetNWString("Title", "")

	elseif fromdb and not txt then 	--i forgot what this was for tbh

		local txt = self:GetPData("Title", nil)

		if not txt then return end
		self:SetPData("Title", txt)
		self:SetNWString("Title", txt)

	elseif isstring(txt) then 
		self:SetPData("Title", txt)
		self:SetNWString("Title", txt)

	else return end

end

function PLAYER:GrantTitleAccess()
	self:SetPData("TitleAccess", true)
	self.HasTitleAccess=true
	self:SetNWBool("TitleAccess", true)
end

function PLAYER:RevokeTitleAccess()
	self:SetPData("TitleAccess", false)
	self.HasTitleAccess=false
	self:SetNWBool("TitleAccess", false)
end

function PLAYER:SetTitleAccess(bool)
	self:SetPData("TitleAccess", tobool(bool))
	self.HasTitleAccess=tobool(bool)
	self:SetNWBool("TitleAccess", tobool(bool))
end

function PLAYER:GetTitleAccess()
	if self.HasTitleAccess==nil then self.HasTitleAccess = self:GetPData("TitleAccess", false) end

	return self.HasTitleAccess
end

function PLAYER:ReadTitle()

	return self:GetPData("Title", nil)
end

hook.Add("PlayerInitialSpawn", "ApplyTitle", function(ply)

	timer.Simple(0, function() if ply:IsValid() then ply:SetTitle(nil, true) end end)
	ply:SetNWBool("TitleAccess", ply:GetTitleAccess())
end)