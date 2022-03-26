__realNet = __realNet or net

__disableReadnet = false

local realPrint = print
local print = function(...)
	if __disableReadnet then return end
	realPrint(...)
end

net = setmetatable({}, {
	__index = function(self, key)
		--print("Indexed", key)

		if isfunction(__realNet[key]) then

			return function(...)
				--print("Called function net." .. key, "with args", ...)
				local ret = __realNet[key](...)
				--print("Returned:", ret)
				return ret
			end

		end

		return __realNet[key]
	end
})

local ignore = {
	["vj_weapon_curbulletpos"] = true,
	["pac_in_editor_posang"] = true,
	["BaseWars.AFK"] = true,
	["pcr"] = true,
	["pcs"] = true
}

_nStart = _nStart or net.Start
local curnet_ignore = false
function net.Start(s)
	if ignore[s] then curnet_ignore = true return end

	print("Started net", s)
	return _nStart(s)
end

_nwAng = _nwAng or net.WriteAngle

function net.WriteAngle(a)
	if curnet_ignore then return end

	print("Written Angle", a)
	return _nwAng(a)
end

_nwBit = _nwBit or net.WriteBit

function net.WriteBit(u)
	if curnet_ignore then return end

	print("Written Bit", u)
	return _nwBit(u)
end

_nwB = _nwB or net.WriteBool

function net.WriteBool(u)
	if curnet_ignore then return end

	print("Written Bool", u)
	return _nwB(u)
end

_nwColor = _nwColor or net.WriteColor

function net.WriteColor(u)
	if curnet_ignore then return end

	print("Written Color", u)
	return _nwColor(u)
end

_nWDat = _nWDat or net.WriteData

function net.WriteData(d, a)
	if curnet_ignore then return end

	print("Written data:\nLen:", a, "\nData: ", d)

	return _nWDat(d, a)
end

_nWD = _nWD or net.WriteDouble

function net.WriteDouble(u, b)
	if curnet_ignore then return end

	print("Written Double", u, b)
	return _nWD(u, b)
end

_nwE = _nwE or net.WriteEntity

function net.WriteEntity(u)
	if curnet_ignore then return end

	print("Written Entity", u)
	return _nwE(u)
end

_nWF = _nWF or net.WriteFloat

function net.WriteFloat(u, b)
	if curnet_ignore then return end

	print("Written Float", u, b)
	return _nWF(u, b)
end

_nWI = _nWI or net.WriteInt

function net.WriteInt(u, b)
	if curnet_ignore then return end

	print("Written Int", u, b)
	return _nWI(u, b)
end

_nWMatrix = _nWMatrix or net.WriteMatrix

function net.WriteMatrix(u, b)
	if curnet_ignore then return end

	print("Written Matrix", u, b)
	return _nWMatrix(u, b)
end

_nWNormal = _nWNormal or net.WriteNormal

function net.WriteNormal(u, b)
	if curnet_ignore then return end

	print("Written Normal", u, b)
	return _nWNormal(u, b)
end

_nWS = _nWS or net.WriteString

function net.WriteString(u, b)
	if curnet_ignore then return end

	print("Written String", u)
	return _nWS(u, b)
end

_nWT = _nWT or net.WriteTable

function net.WriteTable(u, b)
	if curnet_ignore then return end

	print("Written Table")
	PrintTable(u)
	return _nWT(u, b)
end

_nWUI = _nWUI or net.WriteUInt

function net.WriteUInt(u, b)
	if curnet_ignore then return end

	print("Written UInt", u, b)
	return _nWUI(u, b)
end

_nWV = _nWV or net.WriteVector

function net.WriteVector(u, b)
	if curnet_ignore then return end

	print("Written Vector", u)

	return _nWV(u, b)
end

_nWType = _nWType or net.WriteType

function net.WriteType(u, b)
	if curnet_ignore then return end

	print("Written Type", u)

	return _nWType(u, b)
end

_RCC = _RCC or RunConsoleCommand

_nStS = _nStS or net.SendToServer

function net.SendToServer(...)
	curnet_ignore = false
	return _nStS(...)
end

function RunConsoleCommand(...)
	print("Ran ConsoleCommand", ...)
	return _RCC(...)
end

_meConCmd = FindMetaTable("Player").ConCommand

FindMetaTable("Player").ConCommand = function(me, ...)
	print ("Ran Player's ConCommand:", ...)
	return _meConCmd(me, ...)
end