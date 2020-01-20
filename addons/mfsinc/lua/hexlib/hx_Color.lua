local COLOR = FindMetaTable("Color")

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