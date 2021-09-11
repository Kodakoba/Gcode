--
local bz = BaseWars.Bases
bz.NW.Residence = Networkable("bw_base_residence")

local resid = bz.NW.Residence

resid:On("ReadChangeValue", "ReadEnt", function(key)
	local resides = net.ReadBool()

	if resides then
		-- if resides, set [eid] = {bool, bool}
		local protected = net.ReadBool()

		return {resides, protected}, false
	else
		-- if doesn't reside, nil out the key
		return false, true
	end
end)

hook.Add("BW_CanBlowtorchRaidless", "ResidenceCheck", function(ply, ent, wep)
	-- stuff on the street can be blowtorched
	local eid = ent:EntIndex()
	local dat = resid:Get(eid)

	if not dat then return true end -- doesnt reside in a base, byebye
	if not dat[2] then return true end -- unprotected, byebye
end)