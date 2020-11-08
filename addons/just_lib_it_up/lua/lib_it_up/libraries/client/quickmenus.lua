--ent quickmenus

QuickMenus = QuickMenus or {}
QuickMenus.Registered = QuickMenus.Registered or {} --table that holds ents that registered for quickmenus for fast lookups
QuickMenus.IRegistered = QuickMenus.IRegistered or {} --table that holds same shit but sequential for fast ipairs, yes its microoptimization stfu

local qmregistered = QuickMenus.Registered

local iqmr = QuickMenus.IRegistered

openedQM = nil --panel

local ENTITY = FindMetaTable("Entity")

QuickMenus.QuickMenu = QuickMenus.QuickMenu or Animatable:callable()
local qobj = QuickMenus.QuickMenu

AccessorFunc(qobj, "progress", "Progress")
AccessorFunc(qobj, "dist", "UseDistance")
AccessorFunc(qobj, "time", "Time")
AccessorFunc(qobj, "KeepAlive", "KeepAlive")
AccessorFunc(qobj, "ent", "Entity")

local CreateQuickMenu

--[[
	Functions for override
]]

function qobj:OnOpen(ent, pnl)
end
function qobj:OnHold(ent, pnl)
end
function qobj:OnClose(ent, pnl)		--this is called when the qm progress was 1 but became less than 1
end
function qobj:OnFullClose(ent, pnl)	--this is called when the qm progress reaches 0
end
function qobj:OnUnhold(ent, pnl)
end
function qobj:OnReopen(ent, pnl)
end
function qobj:OnRehold(ent, pnl)
end
function qobj:Think(ent, pnl)
end
function qobj:Paint(ent, pnl)
end

function qobj:Destroy()
	table.RemoveByValue(iqmr, self)
	qmregistered[self.ent] = nil
end

function qobj:StartClose()
	if self.Closing or self.progress == 0 then
		self.Closing = true
		self.Opening = false
		return
	end

	local anim, new = self:To("progress", 0, self.progress * self.time, 0, 1)
	print("Closing", self.ent)

	self.Closing = true
	self.Opening = false

	if anim then
		self._progressAnim = anim
	end

	if self.wasopened then
		print("	was opened once;")
		if new then
			print("on end we'll full-close")
			anim:On("End", 1, function() print("fullclose called!", self.ent) self:__OnFullClose() end)
		end

		if self.progress == 1 then
			print("we're fully open so we're beginning close now")
			self:Emit("Close")
			self:__OnClose()
		end
	end

end

function qobj:StartOpen()
	if self.Opening then return end

	local anim, new = self:To("progress", 1, (1 - self.progress) * self.time, 0, 1)

	self.Opening = true
	self.Closing = false

	if anim then
		self._progressAnim = anim
	end
								-- panel Think runs b4 GM think,	(i think)
								-- so the panel can get removed before
								-- the QM starts reopening, thus causing a
								-- reopen on a fresh panel which is bad

								-- to proc that bug you need to open on exactly the same frame as the progress reaches 0
								-- sounds hard but i managed to proc it so let's put safeguards
	if self.progress > 0 and self.wasopened and IsValid(openedQM) then
		if anim then
			anim:On("End", 1, function()
				self:Emit("Reopen")
				self:__OnReopen()
			end)
		end

		return
	end

	if new then
		anim:On("End", 1, function() self:__OnOpen() end)
	end
end

function qobj:StopProgress()
	if self._progressAnim then self._progressAnim:Stop() end
end

function qobj:Close()

	--[[self:Emit("Close")
	self:__OnClose()]]

	--self:Emit("FullClose")
	--self:__OnFullClose()
	--self:StopProgress()

	self.Opening = false
	self.Closing = true
	self:StartClose()

	if openedQM and openedQM:IsValid() then openedQM:Remove() print("requested QM removal", debug.traceback()) end
	openedQM = CreateQuickMenu()
end

function qobj:Initialize(ent)
	qmregistered[ent] = self

	iqmr[#iqmr + 1] = self


	self.progress = 0
	self.active = false
	self.wasopened = false
	self.ent = ent
	self.PopIns = {}
end


--[[
	Internal functions
]]

function qobj:__HidePopins()
	for k,v in pairs(self.PopIns) do
		if not IsValid(v.Panel) then self.PopIns[k] = nil continue end

		local btn = v.Panel

		local oX, oY = v.OffX, v.OffY

		if v.PopInAnim then

			oX = v.X - btn.X + oX
			oY = v.Y - btn.Y + oY

			v.PopInAnim:Stop()
			v.PopInAnim = nil
		end
		if v.MoveInAnim then v.MoveInAnim:Stop() v.MoveInAnim = nil end

		v.PopOutAnim = btn:PopOutHide()
		v.MoveOutAnim = btn:MoveBy(oX, oY, self:GetTime(), 0, 0.2)
	end
end



function qobj:__ShowPopins()
	for k,v in pairs(self.PopIns) do

		if not IsValid(v.Panel) then self.PopIns[k] = nil continue end

		local btn = v.Panel

		if v.PopOutAnim then v.PopOutAnim:Stop() v.PopOutAnim = nil end
		if v.MoveOutAnim then v.MoveOutAnim:Stop() v.MoveOutAnim = nil end

		v.PopInAnim = btn:PopInShow()
		v.MoveInAnim = btn:MoveTo(v.X, v.Y, self:GetTime(), 0, 0.2)
	end
end

function qobj:__OnFullClose()
	if not self.wasopened then return end

	self.opened = false
	self.wasopened = false
	self:__HidePopins()
	self.Closing = false
	self.Opening = false
	self.progress = 0

	self:Emit("FullClose")
	self:OnFullClose(self.ent, openedQM)
end

-- begin closing after qm reached 1
function qobj:__OnClose()
	if not self.wasopened then return end

	self:__HidePopins()

	self.opened = false
	self.Open = false
	self.Closing = true

	self:OnClose(self.ent, openedQM)
end

-- opened again after it has been opened once
function qobj:__OnReopen()

	self:__ShowPopins()

	self.opened = true
	self.wasopened = true

	self.Open = true

	self:OnReopen(self.ent, openedQM)
end

-- full open for the first time
function qobj:__OnOpen()
	self.opened = true
	self.wasopened = true

	self:__ShowPopins()

	self.Open = true
	self.Closing = false

	self:OnOpen(self.ent, openedQM)
end

--quick function for making fancy button pop-in & out animations without much hassle

function qobj:AddPopIn(pnl, x, y, offx, offy)
	local pop = {}

	self.PopIns[#self.PopIns + 1] = pop

	pop.Panel = pnl
	pop.X = x
	pop.Y = y

	pop.OffX = offx or 0
	pop.OffY = offy or 0

	pnl:SetPos(x + offx, y + offy)

	pnl:SetAlpha(0)

	pop.PopInAnim = pnl:PopIn()
	pop.MoveInAnim = pnl:MoveTo(x, y, self:GetTime(), 0, 0.2)

	return pop
end

function ENTITY:SetQuickInteractable(b)

	if b==nil or b then

		local qm = qobj:new(self)
			qm.dist = 192
			qm.time = 0.4
			qm.ease = 1.4

		local id = ("QuickMenus:%p"):format(self)

		hook.OnceRet("EntityRemoved", id, function(ent)
			if ent ~= self then return false end
			if qm.progress > 0 then
				qm:Close()
				qm:Destroy()
			end
		end)

		return qm
	end

	table.RemoveByValue(iqmr, qmregistered[self])
	qmregistered[self] = nil
end

function ENTITY:SetQuickMenuDist(num)
	qmregistered[self].dist = num
end

function ENTITY:SetQuickMenuTime(num)
	qmregistered[self].time = num
end

function ENTITY:SetQuickMenuEase(num)
	qmregistered[self].ease = num
end

local function DoTimer(qm)

	if not qm then
		for k,v in ipairs(iqmr) do
			DoTimer(v)
		end
		return
	end

	if qm.active then
		qm:StartOpen()
	else
		qm:StartClose()
	end

	if qm.progress > 0 then
		qm:Think()
	end

end

local function mostActiveQM()
	local mx, qm = 0, nil

	for i=1, #iqmr do
		local v = iqmr[i]
		local pr = v.progress
		if pr > mx then
			qm = v
			mx = pr
		end
	end

	return qm, mx
end

local opened

function CreateQuickMenu()
	if IsValid(openedQM) then error("creating a panel on top of an existing panel -- this is really bad") end
	print("creating qm")
	local p = vgui.Create("DPanel")
	p:SetSize(600, 400)
	p:Center()

	p.Size = 64
	local maxperc = 0

	local qm	--the quick menu with maximum progress
	local lastEase = 1

	local pad = 6

	local shrinking = false

	function p:Think()

		maxperc = 0

		-- iterate all QM's, find the 'most active'

		qm, maxperc = mostActiveQM()

		-- check if we should even keep the panel open and
		-- whether we should shrink the circle now

		if qm then
			lastEase = qm.ease
		end

		if not qm or maxperc == 0 then
			print("not qm or maxperc == 0; removing QM pnl", qm, maxperc)
			self:Remove()
			openedQM = nil
			return
		end

		if maxperc == 1 and not shrinking then
			shrinking = true

			self:To("Size", 40, 0.1, 0, 0.4)

			self:MakePopup()

			if not qm.NoMouseInput then
				self:SetMouseInputEnabled(true)
			end

			self:SetKeyBoardInputEnabled(false)

		elseif shrinking and maxperc < 1 then
			shrinking = false
			self:To("Size", 64, 0.1, 0, 0.4)

			self:SetMouseInputEnabled(false)

		end

		--DoTimer()

		self.CurrentQM = qm.progress == 1 and qm
	end

	local circleOuterCol = Color(10, 10, 10)
	p.CircleOuterColor = circleOuterCol

	p.CircleInnerColor = Color(250, 250, 250)
	p.MaxInnerAlpha = 255
	p.CircleSize = 64

	function p:Paint(w, h)
		self.Fraction = frac

		self:Emit("PrePaint", w, h)
		local midX, midY = self.CircleX, self.CircleY

		if not midX or not midY then

			local x, y = self:ScreenToLocal(ScrW()/2, ScrH()/2)	--w, h might change and the circle always needs to draw in the middle
																--(unless overridden with self.CircleX, self.CircleY)
			midX, midY = midX or x, midY or y

			self.CircleX = midX
			self.CircleY = midY

		end

		local perc = (maxperc ^ lastEase)
		local size = self.Size

		local mask = function()
			draw.Circle(midX, midY, size+6, 32, perc * 100)
		end

		self.Alpha = perc * 100
		self.QMFrac = perc

		local op = function()
			surface.SetDrawColor(self.CircleInnerColor:Unpack())
			draw.MaterialCircle(midX, midY, (size-pad)*2 )
		end

		self.CircleOuterColor.a = perc * 100
		self.CircleInnerColor.a = perc * self.MaxInnerAlpha

		if qm and qm.MaxInnerAlpha then
			self:To("MaxInnerAlpha", qm.MaxInnerAlpha, qm:GetTime() * (1 - perc), 0, 0.3)
		else
			self:To("MaxInnerAlpha", 255, 0.3, 0, 0.3)
		end

		surface.SetDrawColor(self.CircleOuterColor:Unpack())
		draw.MaterialCircle(midX, midY, size*2)

		draw.Masked(mask, op)

		self.CircleSize = size

		self:Emit("PostPaint", w, h)

		if qm then qm:Paint(qm.ent, self) end
	end


	return p
end

hook.Add("Think", "QuickMenus", function()

	for k,v in ipairs(iqmr) do
		if not IsValid(v.ent) then
			table.remove(iqmr, k)
			qmregistered[v.ent] = nil
		end
	end

	local haveKeepAlive = false

	for k,v in ipairs(iqmr) do
		if not v.KeepAlive then
			v.active = false
		else
			haveKeepAlive = true
		end
	end

	-- if we have a keepalive QM then we don't even do the logic for the rest,
	-- since we don't want two QM's active
	if haveKeepAlive then DoTimer() return end

	local lp = LocalPlayer()

	local using = lp:KeyDown(IN_USE)
	local physgunning = lp:GetPhysgunningEntity()

	local tr = lp:GetEyeTrace()

	if not using or (not IsValid(tr.Entity) or physgunning) then DoTimer() return end

	local ent = tr.Entity
	local qm = qmregistered[ent]

	if not qm then DoTimer() return end --??

	if tr.Fraction*32768 > qm.dist then DoTimer(qm) return end

	--if:
	-- 	1. player held use
	-- 	2. player looks at a valid ent
	-- 	3. distance is ok

	--then quickmenu counts up

	qm.active = true

	DoTimer()

	if not IsValid(openedQM) then
		openedQM = CreateQuickMenu()
	end

	qm:OnHold(qm.ent, openedQM)

end)