MODULE.Name     = "Prestige"
MODULE.Author   = "1488khz gachi remix"
MODULE.Credits  = "Copypasted money module where everything is replaced with prestige"
MODULE.Realm = 1

local tag = "BaseWars.Prestige"
local tag_escaped = "basewars_prestige"

BaseWars.Prestige = {}
local MODULE = BaseWars.Prestige 

local PLAYER = debug.getregistry().Player

if CLIENT then error("What the fuck prestige_sv loaded clientside") return end

util.AddNetworkString("Prestige")  


sql.Query("CREATE TABLE IF NOT EXISTS player_prestige (SteamID64 TEXT, PrestigePts INT, AbsPrestige INT);")

local function isPlayer(ply)

    return (IsValid(ply) and ply:IsPlayer())
    
end
    function MODULE.NewPlayer(ply, double)

        local sid = (IsValid(ply) and ply:IsPlayer()) and ply:SteamID64()
        sid = SQLStr(sid)
        local res = sql.Query([[SELECT * FROM player_prestige WHERE SteamID64=]]..sid)

        if res==nil and not double then 
            sql.Query([[INSERT INTO player_prestige(SteamID64, PrestigePts, AbsPrestige) VALUES(]]..sid..[[, 0, 0)]])
            MODULE.NewPlayer(ply, true)
            return
        end

    end
    PLAYER.NewPrestige = (MODULE.NewPlayer)

    function MODULE.InitPrestige(ply)
        MODULE.NewPlayer(ply)
    end

    function MODULE.GetPrestige(ply, abs)

        if not IsValid(ply) or not ply:IsPlayer() then return end
        local needabs = ""
        if abs==true then needabs = ", AbsPrestige" end

        local PrestigeTbl = sql.Query("SELECT PrestigePts"..needabs.." FROM player_prestige WHERE SteamID64=='"..ply:SteamID64().."';")
        if not PrestigeTbl then 
            if PrestigeTbl==false then print('Prestige SQL errored out:\nPlayer:',ply,"\nError:",sql.LastError()) return end 
            if PrestigeTbl==nil then print('Prestige SQL did not return anything; returning 0 instead...') Prestige = 0 end 
        end 
        PrestigeTbl = PrestigeTbl[1] --only 1 match
        local Prestige = tonumber(PrestigeTbl.PrestigePts)

        local AbsPrestige = 0
        if abs==true then AbsPrestige = tonumber(PrestigeTbl.AbsPrestige) return Prestige, AbsPrestige end

        return Prestige
        
    end
    PLAYER.GetPrestige = (MODULE.GetPrestige)
        



    function MODULE.GetAbsPrestige(ply)

        local pt, absprestige = MODULE.GetPrestige(ply, true) --eh
        return absprestige
    end

    PLAYER.GetAbsPrestige = (MODULE.GetAbsPrestige)


    
    for k, v in next,player.GetAll() do
        
        MODULE.NewPlayer(v)
    
    end


    function MODULE.SavePrestige(ply, amount)
        local amt = tostring(amount) or tostring(ply:GetNWInt())
        sql.Check("UPDATE player_prestige SET PrestigePts="..tostring(amount).." WHERE SteamID64=='"..ply:SteamID64().."'")
        
    end

    PLAYER.SavePrestige = (MODULE.SavePrestige)
    


    function MODULE.LoadPrestige(ply)
    
        MODULE.InitPrestige(ply)
        ply:SetNWInt(tag, MODULE.GetPrestige(ply) )
        
    end

    PLAYER.LoadPrestige = (MODULE.LoadPrestige)

    function MODULE.SetPrestige(ply, amount)
    
        if not isnumber(amount) or amount < 0 then amount = 0 end
        if amount > 2^63 then amount = 2^63 end
        
        if amount ~= amount then amount = 0 end
        
        amount = math.Round(amount)
        MODULE.SavePrestige(ply, amount)
        
        ply:SetNWInt(tag, amount)
        
    end

    PLAYER.SetPrestige = (MODULE.SetPrestige)

    function MODULE.GivePrestige(ply, amount)
    
        MODULE.SetPrestige(ply, MODULE.GetPrestige(ply) + amount)

    end
    PLAYER.GivePrestige = (MODULE.GivePrestige)

    local FUCKINGGRAMMAR
    function MODULE.TakePrestige(ply, amount)
    
        MODULE.SetPrestige(ply, MODULE.GetPrestige(ply) - amount)
        if amount>1 then FUCKINGGRAMMAR="s" else FUCKINGGRAMMAR="" end
        ply:ChatPrint("You just lost " .. tostring(amount) .. " prestige point"..FUCKINGGRAMMAR.."!")

    end

    PLAYER.TakePrestige = (MODULE.TakePrestige)
        
    --ABS PRESTIGE
    function MODULE.SetAbsPrestige(ply, amount)

        if not IsValid(ply) then return end

        ply:NewPrestige()

        if not isnumber(amount) or amount < 0 then amount = 0 end

        if amount > 2^63 then amount = 2^63 end
        
        if amount ~= amount then amount = 0 end
        
        amount = math.Round(amount)

        sql.Query("UPDATE player_prestige SET AbsPrestige="..tostring(amount).." WHERE SteamID64=='"..ply:SteamID64().."'")
        
        ply:SetNWInt("BaseWars.AbsPrestige", amount)
        

    end
    PLAYER.SetAbsPrestige = (MODULE.SetAbsPrestige)

    function MODULE.AddAbsPrestige(ply)

         MODULE.SetAbsPrestige(ply, MODULE.GetAbsPrestige(ply) + 1)

    end
    PLAYER.AddAbsPrestige = (MODULE.AddAbsPrestige)

     function MODULE.LoadAbsPrestige(ply)
    
        MODULE.InitPrestige(ply)
        ply:SetNWInt("BaseWars.AbsPrestige", MODULE.GetAbsPrestige(ply) )
        
    end
        PLAYER.LoadAbsPrestige = (MODULE.LoadAbsPrestige)
    --/ABS PRESTIGE


    hook.Add("PlayerAuthed", tag .. ".Load", (MODULE.LoadPrestige))    
    hook.Add("PlayerDisconnected", tag .. ".Save", (MODULE.SavePrestige))

    hook.Add("PlayerAuthed", tag .. ".LoadAbs", (MODULE.LoadAbsPrestige))    






function MODULE.StartPrestige(ply)
    local level=BaseWars.PlayerLevel:GetLevel(ply)

    if level < 5000 then ply:ChatPrint("You don't have enough levels!") return end
    if BaseWars.Raid:IsOnGoing() or ( ply and ply:InRaid() ) then return end
    local tr = util.TraceLine({

    start = ply:GetPos(),
    endpos = ply:GetPos() + Vector(0,0,256),
    filter = ply,

    })
    if tr.Hit and tr.HitPos:DistToSqr(ply:GetPos()) < 19600 then
        ply:ChatPrint("Go somewhere with a higher ceiling(or outside...)")
        return
    end
    BaseWars.UTIL.RefundAll(ply)
    ply:SetLevel(10)
    ply:SetMoney(0)
    timer.Simple(2, function()
        if not IsValid(ply) then return end
        ply:SetMoney(1500000)
    end)
    ply:SetXP(0)

    ply:SetNWBool("Prestiging", true)
    ply.Prestiging = true

    ply:GodEnable()
    ply:SetMoveType(MOVETYPE_NOCLIP)


    ply:SetPos(ply:GetPos() + Vector(0,0,64))


    ply:SetSelectingPerks(true) --NOW YOURE FUCKED BOI

    for i=1, 3 do 
        local id = math.random(1, #PerksSV)
        local eff = math.random(0, 100)
        ply:QueuePerk(id, eff)
    end
    
    ply:SendQueuedPerks()
    ply:IsSelectingPerks(true) --force an update


    BaseWars.Prestige:AddAbsPrestige(ply)
    timer.Simple(30, function() if not IsValid(ply) then return end ply.Prestiging = false end)
    
end


net.Receive("ConfirmPrestige", function(len, ply)
    BaseWars.Prestige:StartPrestige(ply)
    end)

net.Receive("FinishPrestige", function(len, ply)
    ply.Prestiging = false 
    ply:SetMoveType(MOVETYPE_WALK)
    ply:SetNWBool("Prestiging", false)
    ply:GodDisable()
    if ply.IsInDebug then ply:SetLevel(5000) end


end)

hook.Add("Move", "PrestigeFreeze", function(ply) 
    if ply.Prestiging then return true end 
end)
