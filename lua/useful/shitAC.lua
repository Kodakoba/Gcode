
local enums = {}

local plys = {}

local sens = {}

hook.Add("StartCommand", "e", function(ply, cmd)
	--if ply:IsBot() then return end

	local lp = plys[ply] or {}
	local cp = {}

	plys[ply] = lp

	--[[
	local bt = cmd:GetButtons()
	local ks = "<-\n"

	for k,v in SortedPairsByValue(enums, true) do
		if bt >= v then
			bt = bt - v
			ks = ks .. k.. "\n"
		end
	end

	ks = ks:sub(1, #ks-1)



	if mx ~= 0 or my ~= 0 then
		ks = ks .. "\n"
		ks = "MouseX: " .. cmd:GetMouseX() .. "\nMouseY: " .. cmd:GetMouseY() .. "\n"
	end
	]]

	local ct = CurTime()

	local mx, my = cmd:GetMouseX(), cmd:GetMouseY()

	local ang = cmd:GetViewAngles()
	local margin = ply:GetViewPunchAngles()

	local oldang = lp.ang or ang

	if ang==oldang then lp.ang = ang return end

	--print(ang, lp.ang, ply:GetViewPunchAngles())

	local added = false

	if ang~=oldang then
		local diff = ang - oldang
		local adiff = diff - margin

		--if mx==0 and my==0 then print(adiff, margin) end

		--print("difference:", diff)
		--print("mx, my", mx, my)

		local p, yaw = diff.p, diff.y
		p, yaw = math.abs(p), math.abs(yaw)

		local dx, dy = p / my, yaw / mx

		if mx ~= 0 and dx < 0.00001 then
			--print("HONEYDETECTED X")
		end

		if my~=0 and dy < 0.00001 then
			--print("HONEYDETECTED Y")
		end

		if mx==0 and lp.lastmx ==0 and yaw > 0 then
			lp.detects = (lp.detects or 0) + 1
			lp.start = lp.start or ct
			lp.last = ct
			lp.consec = (lp.consec or 0) + 1

			added = true
			--print(mx, yaw, "X caught")
		end

		if my==0 and lp.lastmy == 0 and p > 0 and not added then
			--print(my, p, "Y caught")
			lp.detects = (lp.detects or 0) + 1
			lp.start = lp.start or ct
			lp.last = ct
			lp.consec = (lp.consec or 0) + 1

			added = true
		end

		if not added then
			lp.consec = 0

			if lp.last then
				local time_passed = ct - lp.last > 0.5
				local few_detects = (lp.detects < 5 and ct-lp.last > 0.1)
				if time_passed or few_detects then
					lp.detects = lp.detects - 1
					if lp.detects <= 0 then
						lp.start = nil
						lp.detects = nil
						lp.last = nil
					end
				end
			end

		end

		if ct - (lp.start or ct) > 0.5 and lp.detects >= 30 and ct - lp.last < 0.3 and lp.consec > 10 then
			print("DETECTED FULL", lp.start, lp.detects, lp.last)
		end

		lp.ang = ang
		lp.lastmx = mx
		lp.lastmy = my
	end


end)
--hook.Remove("StartCommand", "e")

for k,v in pairs(_G) do
	if isstring(k) and k:sub(1, 3) == "IN_" then
		enums[k] = v
	end
end


--PrintTable(enums)