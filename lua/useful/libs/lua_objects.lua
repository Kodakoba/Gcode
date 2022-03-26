do
	--[[----------------------------------]]
	--  Idea shamelessly stolen from Luvit
	--[[----------------------------------]]

	BlankFunc = function() end
	BLANKFUNC = BlankFunc

	Class = {}
	Class.Meta = {__index = Class}

	--[[
		Inheritance table:
			Object - The very base class; everything inherits from this. Don't add function to this unless you know what you're doing.

			Object:extend():

				The new extended class, with this lookup chain:
					NewClass -> NewClassMeta -> OldClass -> OldClassMeta

				There's not much difference between sticking methods in the class and the class' .Meta afaik so do whatever
	--]]

	local function getInitFunc(self)
		return self.Initialize or self.initialize or self.Meta.Initialize or self.Meta.initialize
	end

	function Class:extend()
		local new = {}
		local old = self

		new.Meta = {}
		new.Meta.__index = old 				-- this time, __index points to the the parent
											-- which points to that parent's meta, which points to that parent's parent, so on
		setmetatable(new.Meta, old)

		new.__index = function(t, k)
			return rawget(new, k) or new.Meta[k]
		end

		new.__parent = old

		local curobj

		new.__init = function(newobj, ...) --this function is kinda hard to wrap your head around, so i'll try to explain
			local is_def = false 	--is this the function call that defined curobj?

			if not curobj then
				curobj = newobj
				is_def = true
			end

			if self.__init then 							--recursively call the parents' __init's
				local ret = self.__init(curobj, ...)		--if any of the initializes return a new object,
				curobj = ret or curobj						--that object will be used forward going up the chain
			end


		  --[[------------------------------]]
		  --	  calling :Initialize()
		  --[[------------------------------]]

			local func = getInitFunc(curobj)	--after the oldest __init was called it'll start calling :Initialize()
												--this way we call :Initialize() starting from the oldest one and going up to the most recent one
			if func then
				local ret = func(curobj, ...)		--returning an object from any of the Initializes will use
				curobj = ret or curobj 				--that returned object on every initialize up the chain
			end

			if is_def then
				local temp = curobj 	--return curobj to original state
				curobj = nil

				return temp
			end

			return curobj
		end

		if old.OnExtend then
			old:OnExtend(new)
		end


		return setmetatable(new, new.Meta)
	end

	function Class:callable()
		local new = self:extend()
		new.Meta.__call = new.new
		return new
	end
	Class.Callable = Class.callable

	--[[
		For override:
			Class:(I/i)nitialize:
				Called when a new instance of the object is constructed with a pre-created object.
	]]

	function Class:new(...)

		local func = self.__init or getInitFunc(self)

		local obj = {}
		setmetatable(obj, self)

		if func then
			local new = func(obj, ...)
			if new then return new end
		end

		return obj

	end

	Class.extend = Class.extend
	Class.Extend = Class.extend

	Class.Meta.new = Class.new

	Object = Class
end

do

	--rip your RAM

	muldim = Class:callable()
	local mmeta = muldim.Meta

	local weak = muldim:Callable()
	weak.__mode = "kv"

	function mmeta:Get(...)
		local ks = {...}
		local curvar = self

		for k,v in ipairs(ks) do
			if not curvar[v] then return end
			curvar = curvar[v]
		end

		return curvar
	end

	function mmeta:GetOrSet(...)
		local ks = {...}
		local curvar = self

		for k,v in ipairs(ks) do
			if not curvar[v] then curvar[v] = muldim:new() end
			curvar = curvar[v]
		end

		return curvar
	end

	function mmeta:Set(val, ...)
		local ks = {...}
		local curvar = self

		for k,v in ipairs(ks) do
			local nextkey = next(ks, k)

			if not curvar[v] then

				if nextkey then --if next key in ... exists
					curvar[v] = muldim:new() --recursively create new dim objects
				else
					curvar[v] = val --or just set the value
					return val
				end

			else

				if not nextkey then
					curvar[v] = val
				end

			end

			curvar = curvar[v]
		end

		return val
	end

	function muldim:Initialize(mode)
		if mode then
			return weak()
		end
	end

end

do

	--[[

		how 2 use:

			emitter:On(event_name, [id_name,] callback)
				creates an event listener for when :Emit(event_name) gets called
				if id_name is provided, it MUST be a string, a number or something with an :IsValid() method
				callback args are self + arguments passed from :Emit()

				id_name functions kinda like hook.Add's identifier

				returns id_name where it put the emitter


			emitter:Emit(event_name, ...)
				emits an event to all listeners; can provide arguments


			emitter:RemoveListener(event_name, id_name)
				if no id_name is provided it'll remove every fucking listener for event_name so be careful


			emitter.__Events - muldim table of	[event_name]:[id_name]:function , pls dont touch it
															 [id_name]:function
															 [id_name]:function

												[event_name]:[id_name]:function
															 ...
	]]

	Emitter = Emitter or Class:callable()

	function Emitter:Initialize()
		self.__Events = muldim:new()
	end

	function Emitter:On(event, name, cb)
		self.__Events = self.__Events or muldim:new() 	--deadass no clue why i have to do this, some shit doesn't get __Events... somehow.
		local events = self.__Events

		if isfunction(name) then
			cb = name
			name = #(events:GetOrSet(event)) + 1
		end

		events:Set(cb, event, name)

		return name
	end

	function Emitter:Emit(event, ...)
		self.__Events = self.__Events or muldim:new()

		local events = self.__Events
		if not events then return end

		local evs = events:Get(event)

		if evs then
			for k,v in pairs(evs) do
				--if event name isn't a string, isn't a number and isn't valid then bail
				if not (isstring(k) or isnumber(k) or IsValid(k)) then
					evs[k] = nil
				else
					v(self, ...)
				end
			end
		end

	end

	function Emitter:RemoveListener(event, name)
		self.__Events:Set(nil, event, name)
	end

end


do
	--[[
		A union table:
			Calling methods on it will call the methods on its' children instead.

			Can only have numbered keys.

			Easylua, anyone?
	]]

	UnionTable = {}
	UnionTable.Meta = {}

	local meta = UnionTable.Meta

	meta.IsUnion = true

	function meta.__index(self, key)
		local raw = rawget(self, key) or rawget(meta, key)

		if raw or isnumber(key) then
			return raw
		end

		--[[
			we have to construct a closure each time, i can't think of an another way :(
		]]

		local func = function(...)

			local args_orig = {...}
			local args = {...}

			local outs = {}


			local useself = false

			if args_orig[1] == self then
				useself = true
				table.remove(args, 1)
			end

			for k,v in pairs(self) do

				if isfunction(v[key]) then

					local func = v[key]

					outs[v] = func( useself and v or args_orig[1], unpack(args) )
				end
			end

			return outs
		end

		return func
	end

	function UnionTable:new()
		return setmetatable({}, self.Meta)
	end
	UnionTable.__call = UnionTable.new
	setmetatable(UnionTable, UnionTable)
end