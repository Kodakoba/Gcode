

--[[
	DeltaText: The object that holds all of the deltatext objects and calls appropriate functions.
]]


DeltaText = DeltaText or Object:extend() 	--allow autorefresh of existing objects' metas
local dmeta = DeltaText.Meta 

DeltaText.__call = DeltaText.new 


function dmeta:Initialize()
	self.Texts = {}
	self.Active = {}
	self.Disappearing = {}

	self.Font = "SDZ20"
end

function dmeta:AddText(tx, rep)
	local key = #self.Texts + 1

	local t = DeltaTextPiece:new(self, tx, self.Font, key, rep)
	self.Texts[key] = t

	return t 
end

function dmeta:AddEvent(tx, rep)
	local key = #self.Texts + 1

	local t = DeltaTextEvent:new()
	self.Texts[key] = t 	--it's not really a text

	return t 
end

function dmeta:CycleReset()
	local last

	for i=1, #self.Active do 
		local elem = self.Active[i]
		if elem and not elem.IsEvent then 
			elem:OnReset() 
			last = elem 
		end
	end

	self.LastActive = 0
	table.Empty(self.Active)

	last:Disappear()

end

function dmeta:GetCurrentText()
	return self.Active[#self.Active]
end

function dmeta:CycleNext()
	
	local key = self.LastActive or #self.Active
	local tx = self.Texts[key + 1] --new object to activate

	local lasttx = self.LastElement

	if tx then 

		if tx.IsEvent then 
			self.Active[key + 1] = tx
			self.LastActive = key + 1

			tx:OnActive()		
			return tx
		end

		tx:Appear()
		tx:OnAppear()

		self.Active[key + 1] = tx

		self.LastActive = key + 1
		self.LastElement = key + 1

		local ac = self.Active[lasttx]	--current text, make it disappear
		if ac and not ac.IsEvent then key = ac.Key ac:Disappear() end

		return self.Active[key + 1]
	else 
		return false 
	end
	
end

function dmeta:GetSize()

	--[[
		TODO: make dmeta loop around all of its' active objects and
		return the maximum width with offsets and text width calculations here
	]]

end

function dmeta:Paint(x, y)

	for k, tp in pairs(self.Active) do 

		if not tp or not tp.Paint then continue end
		tp:Paint(x, y)
	end

	for k, tp in pairs(self.Disappearing) do 
		if not tp or not tp.Paint then continue end
		tp:Paint(x, y)
	end
end