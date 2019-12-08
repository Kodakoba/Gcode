plogs.Register('BW: Raids', true, Color(0,255,160))

plogs.AddHook('RaidStart', function(init, vict, fac)
    
        local logname = ""
        local fac1
        local fac2
        
        if fac then
            logname = "Faction " .. (init:GetFaction() or "ERROR?") .. " started raid on faction " .. vict:GetFaction() .."!"
            fac1 = BaseWars.Factions.FactionTable[init:GetFaction()] or nil
            fac2 = BaseWars.Factions.FactionTable[vict:GetFaction()] or nil
        else
            logname = "Player " .. init:GetName() .. " started raid on player " .. vict:GetName() .. "!"
        end
        
        local namesid1
        local namesid2
        if istable(fac1) then
            for k,ply in pairs(fac1.members) do
                
                if not namesid1 then
                    namesid1 = "Initiators: " .. ply:SteamID().." "..ply:Name()
                else
                    namesid1 = namesid1 .. " | " ..ply:SteamID() .. " "..ply:Name()
                end
            end
        end
    
        if istable(fac2) then
            for k,ply in pairs(fac2.members) do

                if not namesid2 then
                    namesid2 = "Victims: " .. ply:SteamID().." "..ply:Name()
                else
                    namesid2 = namesid2 .. " | "  .. ply:SteamID() .. " "..ply:Name()
                end

            end
        end
        if not istable(fac1) then
            namesid1 = "Initiator: " .. init:SteamID() .. " " .. init:Name()
            namesid2 = "Victim: " .. vict:SteamID() .. " " .. vict:Name()
        end
	plogs.PlayerLog(init, 'BW: Raids', logname, {
		["Initiators' names + SteamIDs"] 	= namesid1,
		["Victims' names + SteamIDs"]	= namesid2,
	})

end)

plogs.AddHook('RaidEnded', function(init, vict, fac)
    
        local logname = ""
        local fac1
        local fac2
        local namesid1
        local namesid2
        
        if not IsValid(init) or not IsValid(vict) then 
            logname = "Raid ended in someone leaving prematurely; could not read names. (Read the most recent raid start below)"
            namesid1 = "???"
            namesid2 = "???"
        else
            
            if fac then
                logname = "Raid between faction " .. (init:GetFaction() or "ERROR?") .. " and faction " .. vict:GetFaction() .." ended!"
                fac1 = BaseWars.Factions.FactionTable[init:GetFaction()] or nil
                fac2 = BaseWars.Factions.FactionTable[vict:GetFaction()] or nil
            else
                logname = "Raid between player " .. init:GetName() .. " and player " .. vict:GetName() .. " ended!"
            end
            
            if istable(fac1) then
                for k,ply in pairs(fac1.members) do
                    
                    if not namesid1 then
                        namesid1 = "Initiators: " .. ply:SteamID().." "..ply:Name()
                    else
                        namesid1 = namesid1 .. " | " ..ply:SteamID() .. " "..ply:Name()
                    end
                end
            end
        
            if istable(fac2) then
                for k,ply in pairs(fac2.members) do
    
                    if not namesid2 then
                        namesid2 = "Victims: " .. ply:SteamID().." "..ply:Name()
                    else
                        namesid2 = namesid2 .. " | "  .. ply:SteamID() .. " "..ply:Name()
                    end
    
                end
            end
            if not istable(fac1) then
                namesid1 = "Initiator: " .. init:SteamID() .. " " .. init:Name()
                namesid2 = "Victim: " .. vict:SteamID() .. " " .. vict:Name()
            end
        end
	plogs.PlayerLog((IsValid(init) and init) or vict, 'BW: Raids', logname, {
		["Initiators' names + SteamIDs"] 	= namesid1,
		["Victims' names + SteamIDs"]	= namesid2,
	})

end)
-- hook.Run("BaseWars_EntityDestroyed", self, Attacker, owner, owner:InRaid())


plogs.AddHook('BaseWars_EntityDestroyed', function(ent, atk, own, raid)
        if not IsValid(atk) or not IsValid(own) or not atk:IsPlayer() or not own:IsPlayer() then return end
        local logname = ""
        local fac1
        local fac2
        local fac = (IsValid(atk) and atk:InFaction())
        
        if fac then
            logname = (atk:Nick() or "[NO ATTACKER NAME?]") .. " destroyed " .. (own:Nick() or "[NO OWNER NAME?]") .. "'s " ..  (ent:GetClass() or "[NO ENT NAME?]") .. ((raid and " in") or " outside of") .. " a raid."
            fac1 = BaseWars.Factions.FactionTable[atk:GetFaction()] or nil
            fac2 = BaseWars.Factions.FactionTable[own:GetFaction()] or nil
        end
    
        local namesid1
        local namesid2
        
        if istable(fac1) then
            for k,ply in pairs(fac1.members) do
                
                if not namesid1 then
                    namesid1 = "(Faction) Destroyers: " .. ply:SteamID().." "..ply:Name()
                else
                    namesid1 = namesid1 .. " | " ..ply:SteamID() .. " "..ply:Name()
                end
            end
        end
        
        
        if not istable(fac1) then
            logname = (atk:Nick() or "[NO ATTACKER NAME?]") .. " destroyed "
            namesid1 = "Destroyer: " .. atk:SteamID() .. " " .. atk:Name()
        end
        
        if not namesid2 then
            logname = logname .. (own:Nick() or "[NO OWNER NAME?]") .. "'s " ..  (ent:GetClass() or "[NO ENT NAME?]") .. ((raid and " in") or " outside of") .. " a raid."
            namesid2 = "Owner: " .. own:SteamID().." "..own:Name()
        end

        
	plogs.PlayerLog(atk, 'BW: Raids', logname, {
		["Destroyers' names + SteamIDs"] 	= namesid1,
		["Owners' names + SteamIDs"]	= namesid2,
	})

end)