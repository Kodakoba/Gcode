local COLOR = FindMetaTable("Color")

local green = Color(60, 235, 60)
local red = Color(255, 70, 70)

Colors = Colors or {}

Colors.Green = green 
Colors.Red = red 

Colors.Gray = Color(50, 50, 50)
Colors.DarkGray = Color(35, 35, 35)
Colors.LightGray = Color(65, 65, 65)
Colors.LighterGray = Color(75, 75, 75)

function COLOR:Set(col, g, b, a)

	if IsColor(col) then 
		self.r = col.r 
		self.g = col.g 
		self.b = col.b 
		self.a = col.a 
	else 
		self.r = col or self.r
		self.g = g or self.g
		self.b = b or self.b 
		self.a = a or self.a 
	end

end

function COLOR:Copy()
	return Color(self.r, self.g, self.b, self.a)
end

function IsMaterial(m)
	return type(m) == "IMaterial"	--we can't really compare m.MetaName because m might not even be a table
end