--[[
aowl.AddCommand({"hp", "health"}, function(ply, line, amnt, target)
	target = target and easylua.FindEntity(target) or nil
	print(amnt)
	print(target)
	if not IsValid(target) or not target:IsPlayer() then
		target = ply
	end

	target:SetHealth(tonumber(amnt))
end, "admins")

]] --these are here as examples for me, kek

aowl.AddCommand("refundall", function(ply, line)
    --target = line and easylua.FindEntity(line)
    --if not target or not IsValid(target) or not target:IsPlayer() then return end
    
    BaseWars.UTIL.RefundAll()
end, "superadmin")

aowl.AddCommand({"dev", "devmode"}, function(ply, line, bool)
    if tonumber(bool)==1 or bool=="true" then 
        ply.InDevMode = true
    elseif bool=="false" or tonumber(bool)==0 then
        ply.InDevMode = false
    end
    ply:ChatPrint(string.format("You are now %sin dev mode.", (ply.InDevMode and "") or "not "))
end, "developer", true)

aowl.AddCommand("owner", function(ply)
    local ent = (IsValid(ply) and IsValid(ply.PlayerTrace.Entity) and ply.PlayerTrace.Entity)
    if not ent or not ent.CPPIGetOwner then return false,"not valid ent or owner" end
    ply:ChatPrint('Owner printed to console.')
    ply:ConsoleAddText(Color(128, 192, 128), "Owner of ", ent, ":", Color(100, 100, 228), ent:CPPIGetOwner(), "\n")

end, "mods")

aowl.AddCommand("bringprint", function(call, line, target, class)
	local ply = easylua.FindEntity(target)

	if not ply:IsPlayer() then return end

	local find = ""
	if not class then find = "bw_printer_" else find = class end 

    local pos
    if not call then pos = ply:GetEyeTrace().HitPos else pos = call:GetEyeTrace().HitPos end

    local ang
    if not call then ang = (ply:GetPos() - pos):Angle() else ang = ( call:GetPos() - pos ):Angle() end
    ang.p = 0

	for k,v in pairs(ents.GetAll()) do
		if not v.IsPrinter then continue end 
		if not v.CPPIGetOwner or not (v:CPPIGetOwner()==ply) then continue end 

		local c1 = v:GetClass()
		local c2 = v.PrintName 
		if string.find(c1, find) or string.find(c2, find) then 
			v:SetPos(pos)
			v:SetAngles(ang)
		end

	end

end, "mods")

aowl.AddCommand("abortion", function(ply) local baby = ents.Create( "prop_physics" ) baby:SetModel("models/props_c17/doll01.mdl") baby:SetPos(ply:GetEyeTrace().HitPos) baby:Spawn() return false, "abortion failed, you didnt inject ejectdick.dll when she clamped your dickangles" end)

