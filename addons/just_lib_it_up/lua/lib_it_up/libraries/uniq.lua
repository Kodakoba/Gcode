uniq = {}

function uniq.UUID()
	error("Not implemented")
end

function uniq.Random(len)
	local ret = {}
	for i=1, len do
		ret[i] = math.random(0, 255)
	end

	return string.char(unpack(ret))
end

uniq.__seqs = uniq.__seqs or {} -- haha seks
local seqs = uniq.__seqs

function uniq.Seq(id, sz)
	id = id or ">tfw no id"
	local ret = (seqs[id] and seqs[id] + 1) or 1

	if isnumber(sz) then
		ret = bit.band(ret, bit.Fill(sz))
	end

	seqs[id] = ret
	return ret
end