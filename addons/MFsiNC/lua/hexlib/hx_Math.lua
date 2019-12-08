
function math.Percent(num, perc)
	perc = perc / 100 
	return num * perc
end

//One in
function math.OneIn(num)
	return math.random(0, (num or 1) ) == 0
end

//Within
function math.Within(This, Low,High)
	return This > Low and This < High
end

//Minus
function math.Minus(This)
	return This < 0 and -This or This
end

//Bytes
local Units = {"B", "KB", "MB", "GB, Whoops!"}
function math.Bytes(bytes, all_data)
	if not isnumber(bytes) then return error("! math.Bytes: No bytes\n") end
	
	local Div 	= math.floor( math.log(bytes) / math.log(1024) );
	local Raw 	= (bytes / math.pow(1024, math.floor(Div) ) )
	
	Div = Div + 1
	
	if all_data then
		return math.Round(Raw, 2),Units[ Div ], Raw,Div
	else
		return math.Round(Raw, 2).." "..Units[ Div ]
	end
end

--two if's are faster than math sqrt addition multiplication bullshit, dont @ me
--(its not for rotated shit)

function math.PointIn2DBox(px, py, rx, ry, rw, rh)
		

	local cond1 = (rx < px) and (px < rx + rw)	--X
	if not cond1 then return false end 

	local cond2 = (ry < py) and (py < ry + rh)	--Y
	if not cond2 then return false end 

	return true
end

function bit.bool(bool)
  return bool and 1 or 0
end

--why no 64bit bitops wtf mike

function bit.biglshift(num, amt)
	return num * 2^amt
end

function bit.bigrshift(num, amt)
	local n2 = num / 2^amt
	return n2 - n2%1
end


--makes a number out of any(reasonable) amount of chars
--because \0 lol

local function sub1(str, key)
	if not str[key] then 
		error("what")
		return
	end

	local sub = 0
	--print("str, key:", str, key, str[key])
	local b = string.byte(str[key]) - 1

	if b==0 then 
		if #str[key-1] > 0 then
			--print("go ahead", str, key-1, str[key-1], #str[key-1])
			sub = sub1(str, key-1) - bit.biglshift(1, (#str - key)*8)
		else 
			--print("well shit")
			sub = bit.biglshift(1, (#str - key - 1) * 8)
			--print("new sub", sub, b, (#str-key) * 8)
		end 
	else 

		sub = bit.biglshift(b, (#str - key) * 8)
		--print("else: new sub", sub)
	end

	return sub
end

function string.CharsToNum(str, len)
	len = len or #str

	local lastval = 0
	local ret = 0
	local sub = 0


	for i=1, len do 
		local s = str[i]
		local bts = nextval or string.byte(s) - sub
		nextval = nil 

		local _bts
		local _sub
		print(bts, sub)

		if bts==255 and len > 1 and lastval == 1 then
			print("bts==255")
			bts = 0
			ret = ret - bit.biglshift(1, (len - i)*8) 
		end

		if bts<=0 and lastval == 1 and i~=len then 
			print("fuk u")
			bts = 0xff 
			ret = ret - bit.biglshift(1, (len - i + 1)*8) 
			_sub = 0
		end

		if bts<=0 and lastval > 1 and i~=len then
			print("bts<=0")
			_sub = -bts
			if bts==0 then nextval = 0xff end
			bts = 0

			ret = ret - bit.biglshift(1, (len - i + 1)*8) 

			

			print("subbed", bit.biglshift(1, (len - i + 1)*8), "from", ret + bit.biglshift(1, (len - i + 1)*8))

			--print("now ret is", ret, ", adding", bit.biglshift(bts, (len - i) * 8), bts, len - i)
		end
		--print("nuthin new")
		lastval = _bts or bts
		ret = ret + bit.biglshift(bts, (len - i) * 8)
		--print(i, "added", bts, "now", ret)
		sub = _sub or bts
	end

	return ret
end

local one = string.char(1)
local two = string.char(2)
local t55 = string.char(255)
local function add1(t, key)
	if not t[key] then 
		print("add 1", t, key)
		PrintTable(t)
		table.insert(t, 1, one)
		return 1
	end
	local b = string.byte(t[key]) + 1

	if b==256 then 
		if t[key-1] then

			add1(t, key-1)
		else 
			print("add 2")
			t[key] = one
			table.insert(t, 1, one)
		end 
		b = 1
	end

	t[key] = string.char(b)
end


function string.NumToChars(num, nozeroes)
	local _num = num
	local len = math.ceil(bit.GetLen(num)/8) * 8 --bring bit count to upper multiple of 8
	local t = {}
	local add = 0 

	for i=1, len/8 do 
		local sub = bit.bigrshift(num, len - i*8)
		local byte = sub
		print("cur byte", byte, "add is", add)

		--if byte+add == 255 then add1(t, i-1) byte = 1 end
		local added = false 

		if byte==0 then print("dickfuck") 
			byte = (byte + add)%256 
			added = true 
			if add==1 then 
				add1(t, i-1) 
			end
		end
		--print(i, byte, add)
		if byte + add >= 256 and not added then 
			byte = add1(t, i-1) or (byte + add + 1)%256
		elseif not added then
			--print("regular add")
			byte = byte + add 
		end

		--print("now byte is", byte)

		if byte<0 or byte>=256 then 
			error("Faggot " .. byte .. "; " .. _num)
		end
		local char = string.char(byte)
		t[#t + 1] = char

		add = byte
		num = num - sub * (2^(len - i*8))

	end

	if num ~= 0 then t[#t + 1] = string.char(num) end

	return table.concat(t)
end