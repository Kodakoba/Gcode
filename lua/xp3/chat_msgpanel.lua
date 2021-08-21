
local MSG = {}	

function MSG:Init()

	self.Texts = {}
	self.OrigTexts = {}

	self.Buttons = {}	--"""""""""buttons"""""""""
	self.TextX = 4
	self.TextY = 0

end

function MSG:AddText(txt, col, font, key)
	local rem = self:GetWide() - self.TextX

	if rem <= 16 then 
		self.TextY = self.TextY + 22 
		self.TextX = 4
		rem = self:GetWide() - 4
	end
	self.OrigTexts[#self.OrigTexts + 1] = txt
	local wrapped, widths, height = string.WordWrap(txt, {rem, self:GetWide()}, font or "CH_Text")

	local added = {}
	local i = 1 

	wrapped = wrapped .. "\n"	--i hate patterns

	for s in string.gmatch(wrapped, "(.-)\n") do 
		if #s == 0 then break end 

		local key = key or #self.Texts + 1

		self.Texts[key] = {
			x = self.TextX,
			y = self.TextY,
			w = widths[i],
			h = height,
			origtext = #self.OrigTexts,
			text = s,
			col = col or color_white,
			font = font or "CH_Text",
			key = key
		}


		added[#added + 1] = self.Texts[key]

		if #widths > 1 then 
			self.TextX = 4
			self.TextY = self.TextY + height 
		else 
			self.TextX = self.TextX + widths[i]
		end

		i = i + 1
	end
	
	return added
end

local BLANK = function() end 

function MSG:Recalculate()
	for k,v in pairs(self.Texts) do 

	end
end
function MSG:AddClickableText(txt, col, font)
	local pieces = self:AddText(txt, col, font)

	local funcs = CommunistTable()

	for k,v in pairs(pieces) do
		local el = {}	--element, holder for piece

		el.x = v.x 
		el.y = v.y 
		el.w = v.w 
		el.h = v.h
		el.piece = v 

		v.element = el
		v.funcs = funcs

		el.DoClick = BLANK

		el.OnHover = BLANK
		el.OnUnhover = BLANK
		el.Hovered = BLANK
		el.Paint = BLANK 

		el.cl_id = funcs:AddChild(el)

	end

	self.Buttons[#self.Buttons + 1] = funcs 

	function funcs.SetText(el, txt)

		if self.OrigTexts[el.piece.origtext] == txt then return end 

		local i = 1 
		local key = el.piece.key

		local oldW = el.piece.w

		local oldText = self.Texts[key]
		local oldElement = oldText.element


		local earliestX, earliestY = el.piece.x, el.piece.y 	--because clicked element may be on not-the-earliest line,
																--we have to search for the earliest one as well
		print("el piece is", el.piece.x, el.piece.y)
		--before nilling current text, check its' x, y

		if self.Texts[key].y < earliestY then 
			print("Matched", self.Texts[key].text)
			earliestX = self.Texts[key].x 
			earliestY = self.Texts[key].y
		end
		
		self.Texts[key] = nil
		self.OrigTexts[el.piece.origtext] = txt 

		for k,v in pairs(self.Texts) do 

			if v.origtext == el.piece.origtext then
				funcs.__Children[v.element.cl_id] = nil
				print("nilled element", v.element.cl_id)
				self.Texts[k] = nil 

				if v.y < earliestY then 
					earliestX = v.x
					earliestY = v.y 
				end
			end 
		end


		print("preloop: textx was", self.TextX, "now", earliestX)

		self.TextX = earliestX
		self.TextY = earliestY 


		local W = self:GetWide()

		local rem = W - earliestX 

		local wrapped, widths, height = string.WordWrap(txt, {rem, W}, font or "CH_Text")


		local changed = {}

		--[[
			Calculating change in X and Y from changing the text
		]]

		wrapped = wrapped .. "\n"


		local excludekeys = {x = true, y = true, w = true, h = true, piece = true, __Children = true}

		for s in string.gmatch(wrapped, "(.-)\n") do 
			print("starting t1 loop:", i, s, "current textx", self.TextX)
			if #s == 0 then break end 

			if i==1 then --its the original element: just change its' values and its' funcs values and restore it
				print("t1: editing old element", i)
				local t2 = oldText

				t2.w = widths[i]
				t2.h = height
				t2.x = self.TextX
				t2.y = self.TextY
				t2.key = key 

				t2.text = s

				local el = oldElement
				el.w = t2.w 
				el.h = t2.h 
				el.x = t2.x 
				el.y = t2.y 

				t2.element = el 

				self.Texts[key] = t2
	
			else 	--new element from wrapping text: create new funcs and stuff

				local t = {
					x = self.TextX,
					y = self.TextY,
					w = widths[i],
					h = height,
					text = s,
					origtext = el.piece.origtext,
					col = col or color_white,
					font = font or "CH_Text",
					key = key + i-1,
					funcs = funcs
				}
				print("t1: creating new element", i)
				local newel = table.Copy(el)

				newel.x = t.x 
				newel.y = t.y 
				newel.w = t.w 
				newel.h = t.h 
				newel.piece = t

				t.element = newel 
				t.funcs = funcs 
				--[[
				for k,v in pairs(el) do --copy funcs and stuff from the old element to "inherit" it
					if not excludekeys[k] then 
						newel[k] = v 
					end
				end
				]]

				if self.Texts[key+i-1] then
					table.insert(self.Texts, key + i-1, t)
				else 
					self.Texts[key+i-1] = t
				end

				newel.cl_id = funcs:AddChild(newel)
				print("that element's cl_id is", newel.cl_id, "and origtext is", el.piece.origtext)
			end

			
			

			changed[key + i-1] = true

			if #widths > 1 and i~=#widths then 
				self.TextX = 4
				self.TextY = self.TextY + height
			else 
				print("t1: textX was", self.TextX, " adding", widths[i])
				self.TextX = self.TextX + widths[#widths]
			end

			i = i + 1
		end

		--[[
			Applying change in X and Y to other pieces of text
		]]
		local done = {}

		for k, v in pairs(self.Texts) do 

			if k < key then continue end --this piece of text was before the change; it couldn'tve been affected
			if changed[k] or done[k] then continue end --we changed them already

			print("t2: starting loop", k, v.text)
			local wrapchanged = false 

			if W - self.TextX - v.w < 0 then wrapchanged = true end --less space available for word; need to recalculate cuz it might need to wrap this time
			local wrapscount = 0
			local orig = v.origtext 

			for k,v in pairs(self.Texts) do 
				if v.origtext == orig then 
					wrapscount = wrapscount + 1
				end 
			end 

			if wrapscount > 1 then wrapchanged = true end --the word was wrapped before and space changed; need to recalculate

			if wrapchanged then --lets recalculate it

				local text = self.OrigTexts[v.origtext]
				local orig = v.origtext
				local elem = v.element 

				local col, font = v.col, v.font --they may be different from the current wrapped button

				for k,v2 in pairs(self.Texts) do 
					if v2.origtext == orig then 
						if v2.element then v2.funcs.__Children[v2.element.cl_id] = nil end
						print(v2.origtext, orig, "nilled element", v2.element.cl_id)
						self.Texts[k] = nil 		--nil all wrapped derivatives of that one text, cuz we're regenerating them starting from new TextX
					end 
				end 

				local rem = W - self.TextX
				local wrapped, widths, height = string.WordWrap(text, {rem, W}, font or "CH_Text")
				local i = 1
				wrapped = wrapped .. "\n"

				for s in string.gmatch(wrapped, "(.-)\n") do 
	
					if #s == 0 then break end 

					local key = k + i-1
					print("putting new text @", self.TextX, self.TextY, s)
					local t = {
						x = self.TextX,
						y = self.TextY,
						w = widths[i],
						h = height,
						text = s,
						origtext = orig,
						col = col or color_white,
						font = font or "CH_Text",
						key = key,
						funcs = v.funcs
					}

					v.x = t.x 
					v.y = t.y

					t.piece = t

					local elem = elem 

					if elem then 	--clickable text

						if i~=1 then --requires an another element
							local newelem = {}

							for k,v in pairs(elem) do --port everything from old element
								newelem[k] = v 
							end

							elem = newelem --set to new

						end

						print(s, "has element", elem)
						t.element = elem

						--set new values for current element

						elem.x = v.x 
						elem.y = v.y 
						elem.w = v.w 
						elem.h = v.h
						print("new x,y,w,h", v.x, v.y, v.w, v.h)

						for k,v in pairs(elem) do 
							if not excludekeys[k] then 
								t[k] = v 
							end 
						end

						elem.cl_id = v.funcs:AddChild(t)
					end
					

					self.Texts[key] = t
					done[key] = true 

					if #widths > 1 and i~=#widths then 
						self.TextX = 4
						self.TextY = self.TextY + 22 
					else
						self.TextX = self.TextX + widths[#widths]
					end

					i = i + 1
				end

			else
				print("recalc unnecessary")
				v.x = self.TextX
				v.y = self.TextY
				v.key = k

				local elem = v.element

				if elem then
					print("has element", v.text)
					elem.x = v.x 
					elem.y = v.y 
					elem.w = v.w 
					elem.h = v.h
				end

				self.TextX = self.TextX + v.w 
			end

			
		end


		_TEXTS = self.Texts
	end

	return funcs
end

function MSG:OnMouseReleased(mc)

	if mc==MOUSE_LEFT then 

		local cx, cy = self:ScreenToLocal(gui.MousePos())

		for _, pieces in pairs(self.Buttons) do 
			
			for k, piece in pairs(pieces.__Children) do

				local inbox = math.PointIn2DBox(cx, cy, piece.x, piece.y, piece.w, piece.h) 

				if inbox then 
					print("Clicked", piece)
					piece:DoClick()
					return
				end

			end

		end
	else 
		print("Stinky", self:ScreenToLocal(gui.MousePos()))
	end

end
function MSG:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 100))	--debug
	local lfont
	local lcol

	for k,v in pairs(self.Texts) do 

		if lfont ~= v.font then 
			lfont = v.font 
			surface.SetFont(lfont)
		end 

		if lcol ~= v.col then 
			lcol = v.col
			surface.SetTextColor(lcol)
		end

		surface.SetTextPos(v.x, v.y)
		surface.DrawText(v.text)
	end

	for _, pieces in pairs(self.Buttons) do 
			
		for k, piece in pairs(pieces.__Children) do
			piece:Paint(piece.x, piece.y, piece.w, piece.h)
		end

	end

end

vgui.Register("CH_Text", MSG, "Panel")
