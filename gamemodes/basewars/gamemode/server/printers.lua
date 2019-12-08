
BaseWars.Printers = BaseWars.Printers or {}
BaseWars.Printers.MasterTable = BaseWars.Printers.MasterTable or {}
local mt = BaseWars.Printers.MasterTable

function BaseWars.Printers.Add(self, func) --you can add a func instead to run the function instead
	local rate = self.PrintAmount or 1
	local cap = self.Capacity or 1
	local mult = self.Multiplier or 1
	mt[self] = {rate = rate, cap = cap, mult = mult, func = func}
end


BaseWars.Printers.Update = BaseWars.Printers.Add


timer.Create("BW_Printers",1,0, function()

	for k,v in pairs(mt) do 
		if not IsValid(k) then mt[k] = nil continue end 
		if k.IsPowered and not k:IsPowered() then continue end
		if v.func then v.func(k) continue end 
		
		k.Money = math.min(k.Money + (v.rate*v.mult*k.Level), v.cap)

		if k.NetworkVars then k:NetworkVars() end
	end

end)