MODULE.Name     = "Prestige"
MODULE.Author   = "1488khz gachi remix"

MODULE.Realm = 2

local tag = "BaseWars.Prestige"
local tag_escaped = "basewars_prestige"

local PLAYER = debug.getregistry().Player

BaseWars.Prestige = {}
local MODULE = BaseWars.Prestige 

local function isPlayer(ply)

    return (IsValid(ply) and ply:IsPlayer())
    
end

function MODULE.GetPrestige(ply)

        return tonumber(ply:GetNWString(tag)) or 0

end
PLAYER.GetPrestige = (MODULE.GetPrestige)
    

    function MODULE.GetAbsPrestige(ply)

        return tonumber(ply:GetNWString("BaseWars.AbsPrestige")) or 0

    end

    PLAYER.GetAbsPrestige = (MODULE.GetAbsPrestige)



hook.Add("Move", "PrestigeFreeze", function(ply) 
    if ply:GetNWBool("Prestiging", false) then return true end 
end)


    function DrawPrestigeFX(ply)

        if not ply:GetNWBool("Prestiging", false) then ply.PlayedParticles = false return end
            ply.PlayedPart = ply.PlayedPart or 0
            if CurTime() - ply.PlayedPart < 0.02 then return end

            if not ply.PlayedParticles then 

                ply.PartInfo = {}
                ply.Started = CurTime()
                for i=1,4 do 
                    
                    local effinfo = {}
                    
                    effinfo.Dir = ply:GetAimVector()/2 * Vector(math.random(128,256), math.random(128,256), math.random(16,64)) + Vector(0,0,8)
                    effinfo.Acc = 1
                    effinfo.Pos = ply:GetPos()

                    table.insert(ply.PartInfo, effinfo)
                end
                ply.PlayedParticles = true
            end

            for k, i in pairs(ply.PartInfo) do
                local v = EffectData()

                v:SetScale(1)

               

                if CurTime() - ply.Started > 0.8 then 
                    i.Dir.x = ValGoTo(i.Dir.x, 0, 4)
                    i.Dir.y = ValGoTo(i.Dir.y, 0, 3)
                    i.Dir.z = ValGoTo(i.Dir.z, 0, 2)
                    i.Pos = ValGoTo(i.Pos, ply:GetPos() + i.Dir + Vector(0,0,32), 4)
                    if i.Pos:IsEqualTol(ply:GetPos() + Vector(0,0,32), 16) then table.RemoveByValue(ply.PartInfo, i) return end
                else  i.Pos = ValGoTo(i.Pos, ply:GetPos() + i.Dir + Vector(0,0,32) , 1.6) end
                
                
               v:SetOrigin(i.Pos)
               
                util.Effect("inflator_magic", v)
            end
            ply.PlayedPart = CurTime()

    end

    hook.Add("PreDrawEffects", "PrestigeFX", function(ply) 
        for k, ply in pairs(player.GetAll()) do 
            DrawPrestigeFX(ply)
        end
    end)
