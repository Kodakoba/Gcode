-- { time_in_seconds, abbreviation, [padding] }
-- padding is optional and will default to 2

local times = {
	{1, 			"s"}, 		-- seconds
	{60, 			"m"}, 		-- minutes
	{3600, 			"h"},		-- you get the idea
	{3600 * 24, 	"d"},
	{3600 * 24 * 7, "w", 1},	-- only 1 number necessary for week
	{3600 * 24 * 30, "mo"}
}

-- biggest time -> smallest time
table.sort(times, function(a, b)
	return a[1] > b[1]
end)

for k,v in ipairs(times) do
	-- generate format string
	v[4] = "%0" .. (v[3] or 2) .. "d" .. v[2] .. "."
end

-- if you provide firstTimes, it'll start from only the Xth time
-- eg if firstTimes is 2, it'll only start counting from hours

-- if you provide lastTimes, it won't count beyond the Xth time
-- eg if lastTimes is 2, it won't include anything larger than weeks

-- you can omit any of them, so `timeToString(1440)` also works
local function timeToString(t, firstTimes, lastTimes)
	firstTimes = (firstTimes and math.max(firstTimes, 1)) or 1
	lastTimes = (lastTimes and math.min(lastTimes, #times)) or 1

	local ret = {}

	for i=lastTimes, #times - firstTimes do
		local dat = times[i]
		local amt = math.floor(t / dat[1])
		t = t - amt * dat[1]
		ret[#ret + 1] = dat[4]:format(amt)
	end

	return table.concat(ret, " ")
end

--[[
	usage:

		(18 days, 12 hours, 20 minutes, 10 seconds)
		(or also: 2 weeks, 4 days, 12 hours, 20 minutes, 10 seconds)

		timeToString(10 + 20*60 + 12*3600 + 18*24*3600)			->	'00mo. 2w. 04d. 12h. 20m.'
		timeToString(10 + 20*60 + 12*3600 + 18*24*3600, 2)		->	'00mo. 2w. 04d. 12h.'
		timeToString(10 + 20*60 + 12*3600 + 18*24*3600, 2, 2) 	->	'2w. 04d. 12h.'
]]