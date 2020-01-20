local function HexLibLoaded()

	Partizone = Object:extend()
	PartizoneMethods = Partizone.Meta

	getmetatable(Partizone).__call = Partizone.new

	PartizoneMethods.initialize = function(self, pos1, pos2)
		self.IsPartizone = true
		self[1] = pos1
		self[2] = pos2
	end

	PartizoneMethods.SetOnSpawn = function(self, func)
		self.OnSpawn = func
		return self
	end

	PartizoneMethods.SetStartTouchFunc = function(self, func)
		self.StartTouchFunc = func
		return self
	end

	PartizoneMethods.SetEndTouchFunc = function(self, func)
		self.EndTouchFunc = func
		return self
	end

	PartizoneMethods.SetTouchFunc = function(self, func)
		self.Touch = func
		return self
	end

end

if HexLib then 
    HexLibLoaded()
else 
    hook.Add("HexlibLoaded", "PartizonesClass", HexLibLoaded)
end