
--[[
	Creates a brand new item and waits until you stick it into SQL with all the data necessary.
]]

function Inventory.NewItem(iid, invobj, dat)
	local it = Inventory.Util.GetMeta(iid)
	if not it then errorf("No item meta for IID %s", iid) return end

	local item = it:new(nil, iid)
	item:SetInventory(invobj)

	local base = item:GetBaseItem()

	local def = table.Copy(base.DefaultData)

	if dat then
		for k,v in pairs(dat) do
			def[k] = v
		end
	end

	item.Data = def

	item:Once("AssignUID", "EmitCreatedNew", function()
		item:Emit("CreatedNew")
	end)

	return item
end

local function equalData(dat1, dat2)
	for k,v in pairs(dat1) do
		if dat2[k] ~= v and k ~= "Amount" then
			return false
		end
	end
	return true
end

-- if returned true that means the item was stacked in some existing items
-- if returned table then that's a table of new items it had ta create (the second arg will be how much was left unstacked)

function Inventory.CheckStackability(inv, iid, cb, dat)
	local base = Inventory.Util.GetBase(iid)

	if not dat or not dat.Amount then
		dat = {}
		if base:GetCountable() then
			dat.Amount = 1
		end
	end--return false end

	iid = Inventory.Util.ItemNameToID(iid)
	local base = Inventory.Util.GetBase(iid)

	if not base or not base.Countable then return false end
	local maxstack = base:GetMaxStack()

	local amt = dat.Amount
	local stackedIn = {}

	for k,v in pairs(inv:GetItems()) do
		if v:GetItemID() ~= iid then continue end
		if not equalData(dat, v:GetData()) then printf("not equal data (%s vs %s)", util.TableToJSON(dat), util.TableToJSON(v:GetData())) continue end --different-data'd items (except .Data.Amount) cannot be stacked

		local max = v:GetMaxStack()
		local cur = v:GetAmount()

		local canStack = math.min(max - cur, amt)
		v:SetAmount(cur + canStack)
		amt = amt - canStack
		if canStack > 0 then
			stackedIn[#stackedIn + 1] = v
		end

		if amt == 0 then return true, stackedIn end -- stacked all in; return true
		if amt < 0 then errorf("How the fuck did amount become less than 0: canStack %d, max %d, amt %d", canStack, max, amt) return true end
	end

	local canCreate = math.ceil(amt / maxstack)
	local ret = {}
	printf("creating %d items for %d amt", canCreate, amt)

	for i=1, canCreate do
		local free = inv:GetFreeSlot()
		if not free then break end

		local canGive = math.min(maxstack, amt)
		local it = Inventory.NewItem(iid, inv, {Amount = canGive})
		it:SetSlot(free)

		ret[i] = it

		amt = amt - canGive
	end

	return ret, amt
end


function Inventory.TakeItems(inv, iid, amt, filter)
	filter = filter or BlankFunc
	iid = Inventory.Util.ItemNameToID(iid)
	if not iid then errorf("not an itemID or name: %s", iid) return end

	local invs = {inv}

	if not IsInventory(inv) and istable(inv) then
		invs = inv
	end

	local matches = {}
	local have_amt = 0

	for k, inv in ipairs(invs) do
		for k,v in pairs(inv:GetItems()) do
			if v:GetItemID() ~= iid then continue end
			if filter(iid) ~= false then
				matches[#matches + 1] = v
				have_amt = have_amt + v:GetAmount()
			end
		end
	end

	if have_amt < amt then return false end
	table.sort(matches, function(a, b)
		if a:GetAmount() ~= b:GetAmount() then
			return a:GetAmount() < b:GetAmount()
		end

		return a:GetSlot() > b:GetSlot()
	end)

	for k,v in ipairs(matches) do
		local take = math.min(amt, v:GetAmount())
		if take == v:GetAmount() then
			v:Delete()
		else
			v:SetAmount(v:GetAmount() - take)
		end

		amt = amt - take
	end

	return true
end