--

BaseWars.AreaMark.Tool:Finish()

local nw = Networkable("Areas")

nw:On("ReadChangeValue", 1, function(self, k)
	if not IsPlayer(k) and k ~= "Positions" then return end
	local isPos = k == "Positions"

	local amt = net.ReadUInt(isPos and 16 or 8)

	self:Set(k, self:Get(k) or {})

	local poses = self:Get(k)

	for i=1, amt do
		local k = net.ReadUInt(isPos and 16 or 8)
		local exists = net.ReadBool()

		if not exists then
			poses[k] = nil
		else
			local origin = net.ReadVector()
			local mins, maxs = net.ReadVector()
			poses[k] = {origin, mins, maxs}
		end
	end

	return poses
end)