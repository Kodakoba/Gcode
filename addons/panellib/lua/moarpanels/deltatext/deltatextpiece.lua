
--[[
	DeltaTextPiece: the object that holds the text and values for it.
]]


DeltaTextPiece = DeltaTextPiece or Object:extend()
local pmeta = DeltaTextPiece.Meta 

function pmeta:Initialize(par, tx, font, key, rep)
	self.Text = tx 
	self.Font = font
	self.Key = key

	self.DropStrength = 24	--Text replacement animation: height to which text drops FROM the text
	self.LiftStrength = 24	--Text replacement animation: height to which text drops TO the text

	self.Parent = par 		--DeltaTextMain

	self.Color = color_white:Copy()
	self.Alpha = 0

	local aninfo = {}
	self.Animation = aninfo

	self.Offsets = {X = 0, Y = 0}

	self.Offsets.XAppear = 0
	self.Offsets.YAppear = -36

	self.Offsets.XDisappear = 0
	self.Offsets.YDisappear = 24


	--[[
		Default animation data; if you don't provide length and delay
		to :CreateAnimation, this will be used
	]]

	aninfo.Length = 0.3
	aninfo.Ease = 0.4
	aninfo.Delay = 0
	aninfo.AnimationFunction = function(self, len, delay, ease, onend, think) return NewAnimation(len, delay, ease, onend) end

	self.Animations = {}	--Keeping track of existing animations for the ability to stop and run any animation, as long as you know the name

	--[[
		Text fragments.
		TODO: Make a text fragment into an object as well.
	]]

	self.Fragmented = false 
	self.Fragments = {}
end

function pmeta:SetColor(col, g, b, a)
	self.Color:Set(col, g, b, a)
end

function pmeta:StopAnimation(name)

	if self.Animations[name] then 
		self.Animations[name]:Stop() 
		self.Animations[name] = nil 
	end

end

ChainAccessor(pmeta, "DropStrength", "DropStrength")
ChainAccessor(pmeta, "LiftStrength", "LiftStrength")

ChainAccessor(pmeta, "Text", "Text")
ChainAccessor(pmeta, "Font", "Font")
ChainAccessor(pmeta, "Parent", "Parent")

function pmeta:CreateAnimation(name, think, cb, len, del)
	local anim = self.Animations.Alpha
	local aninfo = self.Animation

	if anim and not anim.Finished then return end 

	if anim then 
		anim:Swap(len or aninfo.Length, del or aninfo.Delay, aninfo.Ease)
		return
	end

	local anim, nooverride = aninfo.AnimationFunction(self, len or aninfo.Length, del or aninfo.Delay, aninfo.Ease, cb, think)

	if not nooverride then 
		anim.Animate = think
	end

	self.Animations[name] = anim
end

--[[
	Returning anything in these functions will stop default animations from playing.
]]

function pmeta:AppearAnimation(fr)

end

function pmeta:DisappearAnimation(fr)

end

--[[
	This is called by the Appear and Disappear animation(which, in turn, is created by :Appear() and :Disappear())
	Don't override it; use :AppearAnimation() and :DisappearAnimation callbacks instead.
]]

function pmeta:AnimateAppearance(fr)
	if self:AppearAnimation(fr) then return end

	self.Alpha = fr * 255

	local xo, yo = self.Offsets.XAppear, self.Offsets.YAppear

	self.Offsets.X = -xo + fr * xo
	self.Offsets.Y = -yo + fr * yo

	self:AppearAnimation(fr)
end

function pmeta:AnimateDisappearance(fr)
	if self:DisappearAnimation(fr) then return end

	self.Alpha = 255 - fr * 255
	local xo, yo = self.Offsets.XDisappear, self.Offsets.YDisappear

	self.Offsets.X = fr * xo
	self.Offsets.Y = fr * yo

end


function pmeta:Disappear()
	self:StopAnimation("Appear")	--stop spazzing out

	self.Parent.Active[self.Key] = false		-- Deactivate self for the parent
	self.Parent.Disappearing[self.Key] = self	-- and set self for disappearing

	self:CreateAnimation("Disappear", function(fr) 
		self:AnimateDisappearance(fr) 
	end, function() 
		self.Parent.Disappearing[self.Key] = nil 
	end)

end

function pmeta:Appear()	
	--it's unlikely an :Appear() will be ever called after a Disappear so we're not stopping animations here
	self:CreateAnimation("Appear", function(fr) self:AnimateAppearance(fr) end, function() end)
end

--[[
	:CreateAnimation uses a regular NewAnimation function by default. 
	

	By setting your own animation you can change what kind of animation it uses. The AnimationFunction gets called with these arguments:
	self, Length, Delay, Ease, onend, think

	For example,
	piece:SetAnimationFunction(function(self, len, del, ease, onend, think)
		return Animations.InElastic(len, del, think, onend, ease), true
	end)

	Don't forget to return true as the second arg, otherwise the Animate function will be replaced.
]]

function pmeta:SetAnimationFunction(func)
	self.AnimationFunction = func
end

function pmeta:Paint(x, y)
	self.Color.a = self.Alpha

	surface.SetFont(self.Font)

	if self.Fragmented then

		local x = 0

		for k,v in pairs(self.Fragments) do 
			v.Color.a = math.min(v.Alpha or 255, self.Alpha)

			surface.SetTextPos(x + v.OffsetX + self.Offsets.X, y + v.OffsetY + self.Offsets.Y)

			surface.SetTextColor(v.Color)

			surface.DrawText(v.Text)

			local tw, th = surface.GetTextSize(v.Text)
			if not v.RewindTextPos then x = x + tw end
		end

		return 
	end

	surface.SetTextPos(x + self.Offsets.X, y + self.Offsets.Y)
	surface.SetTextColor(self.Color)

	surface.DrawText(self.Text)

end

function pmeta:OnAppear()	--for override

end

--[[
	When the text appears or disappears due to cycling,
	it uses these offsets to animate from/to.
]]

function pmeta:SetOffsetDisappear(x, y)
	self.Offsets.XDisappear = x
	self.Offsets.YDisappear = y
end

function pmeta:SetOffsetAppear(x, y)
	self.Offsets.XAppear = x
	self.Offsets.YAppear = y
end

--[[
	TODO: Return fragment object.
]]
function pmeta:AddFragment(from, to)

	if not self.Fragmented then 

		self.Fragmented = true

		local t = {}

		t[1] = {
			Text = self.Text:sub(0, from-1),
			OffsetX = 0,
			OffsetY = 0,
			Color = self.Color,
		}

		t[2] = {
			Text = self.Text:sub(from, to),
			OffsetX = 0,
			OffsetY = 0,
			Color = self.Color,
		}

		t[3] = {
			Text = self.Text:sub(to+1, #self.Text),
			OffsetX = 0,
			OffsetY = 0,
			Color = self.Color,
		}
		self.Fragments = t
		return t
	else 
		local len = 0

		for k,v in pairs(self.Fragments) do 
			local txt = v.Text

			len = len + #txt

			if from < len and to <= len then 
				local frag = {
					Text = txt:sub(from - len + #txt, to - len + #txt),
					OffsetX = 0,
					OffsetY = 0,
					Color = self.Color,
				}

				v.Text = txt:sub(0, from - len + #txt - 1)
				table.insert(self.Fragments, k+1, frag)
				break
			end
		end

	end
end

--[[
	TODO: Have a callback for OnReset as well.

	Having fragmented text isn't really nice, especially since it doesn't need to be after a reset(probably...)
	Either way, just re-fragment it if you really need it.

	Gets called after a cycle reset.
]]

function pmeta:OnReset()
	if self.Fragmented then 
		local tx = self.Text
		self:CollectFragments()
		self.Text = tx
	end
end

--[[
	The first argument is the number of a fragment you're going to be changing. Text MUST be fragmented for this!
	The second argument is the string you're going to be changing the fragment to.
	The third arg is optional and is a callback for when the text is inserted.

	Returns the new fragment which is inserted into the text object on success,
	or false if it failed(either because the fragment with this number doesn't exist or
	the text in the fragment is exactly the same as you're trying to change it to)
]]

function pmeta:ReplaceText(num, rep, onend)
	local newfrag = {
		Text = rep, 
		OffsetY = 0, 
		OffsetX = 0, 
		Alpha = 0,
		Color = self.Color,}
		--RewindTextPos = true}
	local frag = self.Fragments[num]
	if not frag then return false end 

	if frag.Text == rep then return false end 

	frag.RewindTextPos = true	--to prevent the new fragment's X pos being impacted by the one we're removing.


	self:CreateAnimation("SubText" .. frag.Text, function(fr)
		frag.OffsetY = fr * self:GetDropStrength()
		frag.Alpha = 255 - fr*255
	end, function()
		table.remove(self.Fragments, num)
	end)

	self:CreateAnimation("AddText" .. newfrag.Text, function(fr)
		newfrag.OffsetY = 24 - (fr * 24)
		newfrag.Alpha = fr*255
	end, function() 
		if onend then onend() end
	end, nil, 0.1)

	table.insert(self.Fragments, num+1, newfrag)

	return newfrag
end

--[[
	Re-collects all fragments, and if an argument isn't provided, 
	unites all text fragments into its' .Text member.

	Removes fragmentation entirely.
]]
function pmeta:CollectFragments(keeptxt)

	if not keeptxt then 
		local s = ""

		for k,v in pairs(self.Fragments) do 
			s = s .. v.Text
		end

		self.Text = s 
	end

	self.Fragmented = false 
	
	table.Empty(self.Fragments)
end