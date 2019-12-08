muldim = {}

mdimobj = {}
mdimobj.__index = mdimobj

function mdimobj:Get(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do 
		if not curvar[v] then return end 
		curvar = curvar[v]
	end

	return curvar
end

function mdimobj:Set(val, ...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do 
		local nextkey = next(ks, k)	

		if not curvar[v] then 
			
			if nextkey then --if next key in ... exists
				curvar[v] = muldim:new() --recursively create new dim objects
			else 
				curvar[v] = val --or just set the value
				return val
			end 
		else 
			if not nextkey then 
				curvar[v] = val 
			end 
		end

		curvar = curvar[v]
	end

	return val
end

function muldim:new()
	local tbl = {}

	setmetatable(tbl, mdimobj)
	return tbl
end

muldim.__call = muldim.new

setmetatable(muldim, muldim)