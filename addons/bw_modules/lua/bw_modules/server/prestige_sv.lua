MODULE.Name     = "Prestige"
MODULE.Author   = "1488khz gachi remix"
MODULE.Credits  = "Copypasted money module where everything is replaced with prestige"
MODULE.Realm = 1

BaseWars.Prestige = {}

local PLAYER = debug.getregistry().Player

util.AddNetworkString("Prestige")

function MODULE.NewPlayer(ply, double)

end
PLAYER.NewPrestige = MODULE.NewPlayer

function MODULE.InitPrestige(ply)
    MODULE.NewPlayer(ply)
end

function MODULE.GetPrestige(ply, abs)

end
PLAYER.GetPrestige = MODULE.GetPrestige

function MODULE.GetAbsPrestige(ply)

end

PLAYER.GetAbsPrestige = MODULE.GetAbsPrestige

function MODULE.SavePrestige(ply, amount)

end

PLAYER.SavePrestige = MODULE.SavePrestige

function MODULE.LoadPrestige(ply)

end

PLAYER.LoadPrestige = MODULE.LoadPrestige

function MODULE.SetPrestige(ply, amount)

end

PLAYER.SetPrestige = MODULE.SetPrestige

function MODULE.GivePrestige(ply, amount)

end
PLAYER.GivePrestige = MODULE.GivePrestige

function MODULE.TakePrestige(ply, amount)

end

PLAYER.TakePrestige = MODULE.TakePrestige

function MODULE.SetAbsPrestige(ply, amount)

end
PLAYER.SetAbsPrestige = MODULE.SetAbsPrestige

function MODULE.AddAbsPrestige(ply)

end
PLAYER.AddAbsPrestige = MODULE.AddAbsPrestige

function MODULE.LoadAbsPrestige(ply)

end

function MODULE.StartPrestige(ply)

end
