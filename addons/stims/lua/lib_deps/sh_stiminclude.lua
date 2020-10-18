FInc.Recursive("stims/sh_*.lua", _SH)
FInc.Recursive("stims/sv_*.lua", _SV)
FInc.Recursive("stims/cl_*.lua", _CL)

if SERVER then
	include("vmanip/anims/stimpaks.lua")
end