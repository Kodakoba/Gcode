LibItUp.SetIncluded()

if SERVER then util.AddNetworkString("test") end -- good for testing

function net.WriteCompressedString(s, maxsz)
	local comp = util.Compress(s)
	local complen, slen = #comp, #s
	local iscomp = complen < slen

	local min = math.min(complen, slen)

	if min == complen then
		s = comp
	end

	local bitsz = math.min(bit.GetLen(maxsz or 0xFFFF), 16)

	if min > bit.Fill(bitsz) then
		errorf("string too big: %d %scompressed vs. %d max.", min, iscomp and "" or "un", bit.Fill(bitsz))
	end

	net.WriteBool(iscomp)
	net.WriteUInt(min, bitsz)
	net.WriteData(s, min)
end

function net.ReadCompressedString(maxsz)
	local bitsz = math.min(bit.GetLen(maxsz or 0xFFFF), 16)

	local comp = net.ReadBool()
	local len = net.ReadUInt(bitsz)
	local dat = net.ReadData(len)

										-- hey no decompression bombs on my watch
	if comp then dat = util.Decompress(dat, SERVER and 2^20 or nil) end

	return dat
end