local tw = LibItUp.TwoWayTable or Object:callable()
LibItUp.TwoWayTable = tw
TwoWayTable = LibItUp.TwoWayTable

function tw:Initialize(t)
	self[1] = {}
	self[2] = {}

	if t then
		for k,v in pairs(t) do
			self[1][k] = v
			self[2][v] = k
		end
	end
end

function tw:Get(k)
	return self[1][k]
end

function tw:GetByValue(k)
	return self[2][k]
end

function tw:GetKeys()
	return self[1]
end

function tw:GetValues()
	return self[2]
end

function tw:Set(k, v)
	self[1][k] = v
	self[2][v] = k
end