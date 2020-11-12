
netstack = netstack or Object:callable()
netstack.IsNetStack = true

local nsm = netstack

local sizes = {
	Float = 32,
	Double = 64,
	Entity = 16,
	Vector = 32 * 3,

	Normal = 12*2 + 3, --https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/tier1/bitbuf.cpp#L692-L710

	Angle = 32 * 3,
	Color = 8 * 4,
	Bool = 1,
	Bit = 1,
}

local function determineSize(typ, ...)
	typ = typ:gsub("Write", "")
	if typ == "UInt" or typ == "Int" then
		return select(2, ...)
	elseif typ == "String" then
		return #(select(1, ...)) * 8 + 8 -- + 8 = null byte
	elseif typ == "Data" then
		return select(2, ...) * 8
	else
		return sizes[typ] or 0
	end
end

for k,v in pairs(net) do
	if k:find("Write.+") then
		nsm[k] = function(self, ...)
			local aeiou = {...}	--stupid stupid lua
			self.Ops[#self.Ops + 1] = {
				type = k,
				args = aeiou,
				size = determineSize(k, ...),
				--trace = debug.traceback(),	--not worth it
				func = function()
					net[k](unpack(aeiou)) --i cant use ... cuz its outside of this function!!!
				end
			}
			return self.Ops[#self.Ops]
		end
	end
end


local function detourSender(s)
	_G["__realnet" .. s] = _G["__realnet" .. s] or net[s]

	net[s] = function(...)
		hook.Run("NetSent", s, ...)
		return _G["__realnet" .. s] (...)
	end
end

detourSender("Send")
detourSender("SendPVS")
detourSender("SendPAS")
detourSender("SendOmit")
detourSender("SendToServer")

function net.WriteNetStack(ns)
	if not ns.Ops then local str = "net.WriteNetStack: expected netstack; got %s" error(str:format(type(ns))) return end

	for k,v in ipairs(ns.Ops) do
		local ok, err = pcall(v.func)
		if not ok then
			local args = v.args
			local str = ""

			for _, v in ipairs(args) do
				str = str .. tostring(v) .. ", "
			end

			str = str:sub(1, #str - 2)

			local errs = "Error while writing netstack: \"%s\"\nError while writing op #%d\nType: %s\nArgs: %s\nCaller traceback: \n\n\n"

			errs = errs:format(err, k, v.type, str, v.trace)
			error(errs)
		end
	end
end

local hijacked = {} --cache for hijacked functions that write into the active netstack

local function hijackNet()
	for k,v in pairs(net) do
		local name = k:find("^Write.+")
		if name and v ~= net.WriteNetStack and isfunction(v) then

			if not net["__Real" .. k] then net["__Real" .. k] = v end

			local hj = hijacked[name] or function(...)
				if net.ActiveNetstack then
					return net.ActiveNetstack[k] (net.ActiveNetstack, ...)
				else
					local ok, err = pcall(net["__Real" .. k], ...)
					if not ok then
						error(err, 2)
					end
				end
			end

			net[k] = hj
		end
	end
end

local function unhijackNet()
	for k,v in pairs(net) do
		local name = k:find("Write.+")
		if name and v ~= net.WriteNetStack and net["__Real" .. name] then
			net[k] = net["__Real" .. k]
		end
	end
end

netstack.__call = net.WriteNetStack

function netstack:Initialize()
	self.Ops = {}
end

function netstack:GetOps()
	return self.Ops
end


function netstack:BytesWritten()
	local bits = 0
	for k,v in ipairs(self.Ops) do
		bits = bits + v.size
	end

	return bits / 8, bits
end

-- hijacks all net.Write* calls to instead write to this netstack

function netstack:Hijack(b)
	if b == nil or b then
		net.ActiveNetstack = self
		hijackNet()

		hook.Once("NetSent", ("unhijack_netstack:%p"):format(self), function()
			self:Hijack(false)
		end)

	else
		net.ActiveNetstack = nil
		unhijackNet()
	end
end

function netstack:MergeInto(ns)
	for k,v in ipairs(self.Ops) do
		ns.Ops[#ns.Ops + 1] = v
	end
end

function netstack:Send(netname, where)
		net.Start(netname)
			net.WriteNetStack(self)
	if CLIENT then
		net.SendToServer()
	else
		net.Send(where)
	end
end
netstack.__tostring = function(self)
	local head = "NetStack: %d ops:"
	head = head:format(#self.Ops)

	local args = ""

	for k,v in ipairs(self.Ops) do
		local argsstr = ""	--can't do `table.concat(v.args, ", ")` because it may have shit like userdata(entities) which table.concat doesn't like
		for k,v in ipairs(v.args) do
			argsstr = argsstr .. tostring(v) .. ", "
		end

		argsstr = argsstr:sub(1, #argsstr - 2)
		if v.Description then
			argsstr = argsstr .. "	| " .. v.Description
		end
		args = args .. ("%d: %s - %s\n"):format(k, v.type, argsstr)
	end

	args = args:sub(1, #args - 1)

	return head .. "\n" .. args
end


function IsNetStack(what)
	return what.IsNetStack
end
IsNetstack = IsNetStack