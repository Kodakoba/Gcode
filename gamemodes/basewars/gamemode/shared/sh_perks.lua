PerksSV = {
    [1] = {name="armup", eff=50},
    [2] = {name="hpup", eff=30},
    [3] = {name="spdup", eff=40},
    [4] = {name="jmpup", eff=70},
}


local err = Material("__error")

function CalculatePerkEffectiveness(id, eff)
    if not PerksSV[id] or not PerksSV[id].eff then return -1 end 
    return (eff/100) * PerksSV[id].eff

end

local descs = {
    [1] = "My name is Van, I'm an artist, I'm a performance artist. I'm hired to people to fulfill their fantasies, their deep dark fantasies. I was gonna be a movie star y'know, modeling and acting. After a hundred and two additions and small parts I decided y'know I had enough, Then I got in to Escort world. The client requests contain a lot of fetishes, so I just decided to go y'know... full ♂Master♂ and change my entire house into a dungeon... ♂Dungeon♂Master♂ now with a full dungeon in my house and It's going really well. Fisting is %s armor and usually the guy is pretty much hard on pop to get really relaxed y'know and I have this long latex glove that goes all the way up to my armpit and then I put on a surgical latex glove up to my wrist and just lube it up and it's a long process y'know to get your whole arm up there but it's an intense feeling for the other person I think for myself too, you go in places that even though it's physical with your hand but for some reason it's also more emotional it's more psychological too and we both get you know to the same place it's really strange at the same time and I find sessions like that really exhausting. I don't know I feel kinda naked because I am looking at myself for the first time, well not myself but this aspect of my life for the first time and it's been harsh... three to five years already? I never thought about it... Kinda sad I feel kinda sad right now, I don't know why.",
    [2] = "Increase your max HP by %s.",
    [3] = "Increase your runspeed by %s.",
    [4] = "Increase your jump power by %s.",
}

local names = {
    [1] = "Armor Spawn",
    [2] = "Max HP",
    [3] = "Run Speed",
    [4] = "Jump Power"
}

local mats = {
    [1] = Material("vgui/prestige/armor.png"),
    [2] = Material("vgui/prestige/health.png"),
    [3] = Material("vgui/prestige/speedperk.png"),
    [4] = Material("vgui/prestige/jumping-man.png")
}

local effs = {
    [1] = CalculatePerkEffectiveness,
    [2] = CalculatePerkEffectiveness,
    [3] = CalculatePerkEffectiveness,
    [4] = CalculatePerkEffectiveness,
}

--[[-------------------------------------------------------------------------
   Rarities
---------------------------------------------------------------------------]]

local defrarity = {
    {col = Color(120, 120, 120), prefix = "Common", start = 100},
    {col = Color(80, 200, 80), prefix = "Uncommon", start = 120},
    {col = Color(80, 80, 210), prefix = "Rare", start = 150},
    {col = Color(140, 60, 200), prefix = "Very Rare", start = 170},
    {col = Color(200, 200, 50), prefix = "GOLDEN LEGENDARY", start = 190}
}

local rar = {
    [1] = defrarity,
    [2] = defrarity,
    [3] = defrarity,
    [4] = defrarity,
}

Perks = Perks or {}
Perks.List = Perks.List or {}

for k,v in pairs(names) do 
    local desc = descs[k] or "[ERR: NO DESC]"
    local mat = mats[k] or err 
    local eff = effs[k] or -2
    local rar = rar[k] or {col = Color(255,0,0), prefix = "ERROR"}

    local perk = {
        name = v,
        desc = desc,
        mat = mat,
        eff = eff,
        rar = rar,
    }

    Perks.List[k] = perk
end