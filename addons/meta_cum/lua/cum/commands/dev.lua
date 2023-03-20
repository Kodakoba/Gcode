--123
CUM.CurCat = "Development"

CUM.AddCommand({"admin", "adm", "admun", "powers"}, function(ply, b)
	if b == -1 then b = not ply.AdminPowers end

	ply.AdminPowers = b
end)
	:AddBoolArg(true, -1, desc)

	:SetReportFunc(function(self, rply, caller)
		if IsValid(rply) and not rply:IsAdmin() then return end

		return "{1} set their admin mode to {2}.", {
			[2] = "<col=50,150,250>" .. tostring(caller.AdminPowers)
		}
	end)

	:SetSilent(true)