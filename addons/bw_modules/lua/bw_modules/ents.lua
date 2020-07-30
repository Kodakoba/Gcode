BaseWars.Ents = {} 
local MODULE = BaseWars.Ents

local ENTITY = FindMetaTable("Entity")

function MODULE.Valid(ent)
	return ent and (isentity(ent) and ent:IsValid()) and IsValid(ent) and ent
	
end

MODULE.Valid = Deprecated 
ENTITY.Valid = MODULE.Valid

function MODULE.ValidOwner(ent)

	local Owner = ent and (ent.CPPIGetOwner and ent:CPPIGetOwner())
	
	return MODULE.ValidPlayer(Owner)
	
end

MODULE.ValidOwner = Deprecated 
ENTITY.ValidOwner = MODULE.ValidOwner

function MODULE.ValidPlayer(ply)

	return MODULE.Valid(ply) and ply:IsPlayer() and ply
	
end

MODULE.ValidPlayer = Deprecated 
ENTITY.ValidPlayer = MODULE.ValidPlayer

function MODULE.ValidClose(ent, ent2, dist)

	return MODULE.Valid(ent) and ent:GetPos():DistToSqr(ent2:GetPos()) <= dist^2 and ent

end
MODULE.ValidClose = Deprecated 
ENTITY.ValidClose = MODULE.ValidClose