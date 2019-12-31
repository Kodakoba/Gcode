
netstack_meta = {}
local nsm = netstack_meta 

for k,v in pairs(net) do 
	if k:find("Write*") then 
		nsm[k] = function(self, ...)
			local aeiou = {...}	--stupid stupid lua
			self.Ops[#self.Ops + 1] = {
				type = k,
				args = aeiou,
				trace = debug.traceback(),
				func = function()
					net[k](unpack(aeiou))
				end
			}
		end
	end 
end

function net.WriteNetStack(ns)
	if not ns.Ops then local str = "net.WriteNetStack: expected netstack; got %s" error(str:format(type(ns))) return end 
	for k,v in ipairs(ns.Ops) do 
		local ok, err = pcall(v.func)
		if not ok then 
			local args = v.args
			local str = ""
			for k,v in pairs(args) do 
				str = str .. tostring(v) .. ", "
			end 
			str = str:sub(1, #str - 2)

			local errs = "Error while writing netstack: \"%s\"\nError while writing op #%d\nType: %s\nArgs: %s\nCaller traceback: \n\n\n"

			errs = errs:format(err, k, v.type, str, v.trace)
			error(errs)
		end
	end
end

netstack = {}
netstack.__index = netstack_meta
netstack.__call = net.WriteNetStack

function netstack:new()
	local ret = {}
	ret.Ops = {}
	setmetatable(ret, netstack)
	return ret
end

netstack.__tostring = function(self)
	local s = "NetStack: %d ops:"
	s = s:format(#self.Ops)
	local s2 = ""

	for k,v in ipairs(self.Ops) do 
		local argsstr = ""

		for k, arg in ipairs(v.args) do 
			argsstr = argsstr .. tostring(arg) .. ", "
		end 

		argsstr = argsstr:sub(1, #argsstr - 2)

		s2 = s2 .. ("%d: %s - %s\n"):format(k, v.type, argsstr)
	end 

	s2 = s2:sub(1, #s2 - 1)

	return s .. "\n" .. s2
end

function bit.GetLast(num, n)
	return num % (2^n)
end

function bit.GetFirst(num, n)
	local len = bit.GetLen(num)

	return bit.rshift(num, math.max(len - n, 0))
end

function bit.GetLen(num)
	return (num==0 and 1) or math.ceil(math.log(math.abs(num), 2))
end

--i gave up on bitstack

--[[
local maxbits = 31 

local rshift = bit.rshift 
local lshift = bit.lshift 


function bsm:JoinCells()
	for i=1, 512 do 
		local c = self.Stack[i]
		if not c then return end

		local pc = self.Stack[i-1]

		if c.size >= maxbits then continue end 
		if c.size <= 0 then table.remove(self.Stack, i) continue end 

		if c.size < maxbits and (pc and pc.size < maxbits) then 

			local pdiff = maxbits - pc.size 					--not enough to fill cell #1
			local rem = -maxbits + c.size + pc.size				--remaining bits on cell #2
			local move = math.min(pdiff, c.size) 				--will move from #2 to #1

			local add2 = bit.GetFirst(c[1], move)--c[1]%2^move 
			local shift = pc.size - (bit.GetLen(pc[1]) )--move --dont ask

			--print("so shifted", pc[1], " to", lshift(pc[1], shift), "then added", add2)
			pc[1] = lshift(pc[1], shift) + add2--lshift(pc[1], shift) + add2


			if rem <= 0 then 
				table.remove(self.Stack, i)
			else
				c[1] = rshift(c[1], move)
				c.size = rem
			end

			pc.size = pc.size + move 
			

		end
	end

	
end

function bsm:ReadBits(n)

	local int = 0

	local bits = n%maxbits
	local cells = (n - bits) / maxbits

	for i=1, cells do 
		if not self.Stack[1] then error("Underflow! " .. #self.Stack) return end 
		int = int + self.Stack[1][1]
		table.remove(self.Stack, 1)
	end

	local cell = self.Stack[1]

	if not cell or bits==0 then return int end 

	int = int + rshift(cell[1], cell.size - bits)
	--print(cell[1], cell.size - bits, rshift(cell[1], cell.size - bits))
	local bits_keep = 2^(cell.size - bits) 	--V read (4b)| remain (8b)
	cell[1] = cell[1]%bits_keep		 		--0111|00110010 -> 00110010

	cell.size = cell.size - bits

	self:JoinCells()
	return int
end

function bsm:WriteBits(num, n)

	if math.ceil(math.log(num, 2)) >= n then 
		local err = "number too big! (max for %d bits: %d; got: %d)"
		error(err:format(n, 2^n, num))
	end

	local cells, bits = math.floor(n/maxbits), n%maxbits
	local len = bit.GetLen(num)

	for i=1, cells do 
		self.Stack[#self.Stack + 1] = {bit.GetFirst(num, 31), size = maxbits}
		num = bit.GetLast(num, len - 31)
	end

	self.Stack[#self.Stack + 1] = {num, size = bits}
	self:JoinCells()
end

function bsm:WriteBool(b)
	self:WriteBits(1, 1)
end

function bsm:ReadBool()
	return self:ReadBits(1)
end

bitstack = {}
bitstack.__index = bitstack_meta

function bitstack:new(s)
	local ret = {}
	ret.Stack = {}
	setmetatable(ret, bitstack)
	return ret
end
--40000
--2 bytes
--1001110001000000

--rshift 8 = 10011100
--etc
]]