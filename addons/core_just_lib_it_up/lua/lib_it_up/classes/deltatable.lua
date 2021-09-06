if not LibItUp.ShadowTable then include("shadowtable.lua") end

LibItUp.DeltaTable = LibItUp.DeltaTable or LibItUp.ShadowTable:extend()
local dt = LibItUp.DeltaTable


function dt:Initialize(t)
	local shad = self:GetShadow()
		shad.LastTable = (t and table.Copy(t)) or {}
end

function dt:Sync()
	local shad = self:GetShadow()
	local lt = shad.LastTable

	for k,v in pairs(self) do
		if istable(v) then
			lt[k] = dt:new(table.Copy(v)) -- keep track of subtable changes
		else
			lt[k] = v
		end
	end
end

-- compare against the last synced copy
function dt:Compare(t, cmpd)
	cmpd = cmpd or {}
	local changes = {}
	local shad = self:GetShadow()
	local lt = shad.LastTable
	local keyed = {}
	print("/->")
	print("Comparing:")
	PrintTable(self)
	print(",")
	PrintTable(t)
	print("/ last table of self is /")
	PrintTable(lt)
	print("---")
	for k,v in pairs(lt) do
		print(k, v, t[k])
		local last = v
		local cur = t[k]

		keyed[k] = true
		if cmpd[last] then continue end
		cmpd[last] = true

		if istable(last) and istable(cur) then
			
			local ineq = last:Compare(cur, cmpd)
			if next(ineq) ~= nil then
				changes[k] = ineq
			end
		elseif last ~= cur then
			changes[k] = {last, cur}
		end
	end

	for k,v in pairs(t) do
		if keyed[k] then continue end
		print("unkeyed", k, v)

		changes[k] = {nil, v}
	end
	print("<-/")
	return changes
end

function dt:GetChanges()
	return self:Compare(self)
end