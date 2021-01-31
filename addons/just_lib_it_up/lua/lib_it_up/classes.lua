AddCSLuaFile()

--[[----------------------------------]]
--  Idea shamelessly stolen from Luvit
--[[----------------------------------]]

setfenv(0, _G)

BlankFunc = function() end
BLANKFUNC = BlankFunc

Class = {}

local Class = Class
local rawget = rawget
local ipairs = ipairs
local unpack = unpack
local table_maxn = table.maxn
local type = type
local setmetatable = setmetatable

Class.__index = Class --[[function(self, k)
	local parval = rawget(Class, k)

	if parval ~= nil then
		return parval
	else
		return Class.Meta[k]
	end

end]]

Class.Meta = {__index = Class}

--[[
	Inheritance table:
		Object - The very base class; everything inherits from this. Don't add function to this unless you know what you're doing.

		Object:extend():

			The new extended class, with this lookup chain:
				NewClass -> NewClassMeta -> OldClass -> OldClassMeta

			The .Meta key is the metatable for the class you get, so if you wanna change metamethods for _the class itself_ instead of its' instances,
			then do it in its' .Meta
--]]

local function getInitFunc(self)
	return self.Initialize or self.initialize or (self.Meta and (self.Meta.Initialize or self.Meta.initialize))
end

local function rawgetInitFunc(self)
	return 	(rawget(self, "Initialize") or rawget(self, "initialize"))
end


local metamethods = {

	--metamethods (except __index) aren't inherited

	"__newindex",
	"__mode",
	"__concat",
	"__call",
	"__tostring"

	-- cba with math metamethods
}

local recursiveExtend = function(new, old, ...)
	-- we want OnExtend's to go from oldest to newest, so
	-- we'll store the chain and iterate in reverse order
	local chain, i = {new}, 1
	local prev = old --provided `old` is merely the parent from which it got extended

	while old do
		i = i + 1
		chain[i] = old
		old = old.__parent
	end

	for i2=i, 1, -1 do --iterate in reverse order, from oldest to newest
		local obj = chain[i2]
		local onExt = rawget(obj, "OnExtend")
		if onExt then
			onExt(prev, new, ...)
		end
	end
end

function Class:CopyMetamethods(old)
	for k,v in ipairs(metamethods) do
		self[v] = rawget(old, v)
	end
end

function Class:AliasMethod(method, ...)
	if not type(method) == "function" then errorf("arg #1 is not a function (got %q)", type(method)) return end

	for k,v in ipairs({...}) do
		self[v] = method
	end
end

-- todo: do i even need this feature?
function Class:ChangeInitArgs(...)
	Class.__args = {...}
end

function Class:extend(...)
	
	local old = self

	local new = {}
	new.Meta = {}
	new.Meta.__index = old 				-- this time, __index points to the the parent
										-- which points to that parent's meta, which points to that parent's parent, so on
	Class.CopyMetamethods(new, old)

	setmetatable(new.Meta, old)
	setmetatable(new, new.Meta)

	new.__index = new
	new.__parent = old
	new.__super = old
	new.__instance = new

	local curobj

	new.__init = function(newobj, ...) --this function is kinda hard to wrap your head around, so i'll try to explain
		--`self` is the parent class
		--`new` is the new class

		local is_def = false 	--is this the function call that defined curobj?

		curobj = newobj
		local oldArgs

		if newobj.__instance == new then
			is_def = true
			oldArgs = Class.__args
			Class.__args = {...}
		end

		local args = Class.__args

		if self.__init and rawget(new, "AutoInitialize") ~= false then 	--recursively call the parents' __init's
			--[[if self.___Debugging then
				print("found __init in", self.Name)
				print("Calling with args:", unpack(args, 1, table_maxn(args)))
			end]]

			local ret = self.__init(curobj, unpack(args, 1, table_maxn(args)))		--if any of the initializes return a new object,
			curobj = ret or curobj						--that object will be used forward going up the chain
		end


	  --[[------------------------------]]
	  --	  calling :Initialize()
	  --[[------------------------------]]
	  	args = Class.__args

		local func = rawgetInitFunc(new)	--after the oldest __init was called it'll start calling :Initialize()
											--this way we call :Initialize() starting from the oldest one and going up to the most recent one

		if func then
			--[[if self.___Debugging then
				print("Rawgot init function from", new.Name)
				print("Calling with args:", unpack(args, 1, table_maxn(args)))
			end]]

			local ret = func(curobj, unpack(args, 1, table_maxn(args)))		--returning an object from any of the Initializes will use
			curobj = ret or curobj 				--that returned object on every initialize up the chain
		end

		if is_def then
			local temp = curobj 	--return curobj to original state
			curobj = nil
			Class.__args = oldArgs

			return temp
		end

		return curobj
	end

	recursiveExtend(new, old, ...)


	return new
end

function Class:callable(...)
	local new = self:extend(...)
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

	local func = self.__init

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