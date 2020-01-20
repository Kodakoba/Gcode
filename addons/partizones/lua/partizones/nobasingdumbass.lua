nobase = {}

local zone = Partizone("nobase")

zone:SetBounds(Vector (-8022.0180664063, -7884.939453125, 457), Vector (-8693.8173828125, -7393.03125, 702))

zone.StartTouchFunc = function(self, ent)

	if not IsPlayer(ent) then return end 
	if nobase[ent] then nobase[ent] = nobase[ent] + 1 return end 

	timer.Simple(0, function()

		net.Start("NoBasingDumbass")
		net.Send(ent)
		nobase[ent] = 1
	end)


end

zone.EndTouchFunc = function(self, ent)

	if not IsPlayer(ent) or not nobase[ent] then return end 

	nobase[ent] = nobase[ent] - 1
	if nobase[ent] <= 0 then nobase[ent] = nil return end 
end

local part2 = zone:Inherit("nobase2")

part2:SetBounds(Vector (-8022.0786132813, -7884.888671875, 456.03125), Vector (-7766.037109375, -7393.1440429688, 701.96875))

PartizonePoints.NoBase = zone 
PartizonePoints.NoBase2 = part2 
if CLIENT then 
	net.Receive("NoBasingDumbass", function()
		hdl.PlayURL("http://vaati.net/Gachi/shared/earrape.mp3", "nobasingidiot.dat", "", function() end)
	end)
end

AddPartizone(zone)
AddPartizone(part2)