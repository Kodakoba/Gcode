local META = {}

local function hex(p)
	return ("%p"):format(p)
end

function META:Timer(name, sec, reps, func, ...)
	local args = {...} -- luwa

	-- i don't like writing these out manually but eh..
	if isfunction(sec) then
		func = sec
		if reps ~= nil then table.insert(args, 1, reps) end
		sec = 0
		reps = 1
	end

	if isfunction(reps) then
		if func ~= nil then table.insert(args, 1, func) end
		func = reps
		reps = 1
	end

	if not func then error("Nice function") return end --ya idiot

	name = name or uniq.Seq("__Timerified:" .. hex(self))
	local id = (name and "__Timerified:" .. hex(self) .. ":" .. name)

	if reps == 0 then
		ErrorNoHalt("created a 0 rep timer:" .. debug.traceback())
	end
	
	timer.Create(id, sec or 0, reps or 1, function()
		if not self:IsValid() then return end
		func(self, unpack(args))
	end)

	return id
end

function META:RemoveTimer(name)
	if not name then error("Nice ID") return end
	timer.Remove("__Timerified:" .. hex(self) .. ":" .. name)
end

local metas = {
	FindMetaTable("Entity"),
	FindMetaTable("Panel"),
}

for k,v in pairs(metas) do
	v.Timer = META.Timer
	v.RemoveTimer = META.RemoveTimer
end