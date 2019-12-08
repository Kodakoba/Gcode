AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local max = 9 --max printers

function ENT:Init()
    local me = BWEnts[self]
    me.Power = 0 
    me.MaxPower = self.PowerCapacity
    me.TransmitOverride = 1000

    self.Money = 0

    self:SetHealth(self.PresetMaxHealth or 100)

    self.rtb = 0
    self:SetTrigger(true)
    self.Printers = {}
end

local pos = {
    Vector (0.912353515625, -0.44677734375, 13.148170471191),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*2),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*3 - 0.2),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*4 - 0.4),

    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*6 - 0.9),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*7 - 1),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*8 - 1.1),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*9 - 1.1),
    Vector (0.912353515625, -0.44677734375, 13.148170471191 + 6.25*10 - 1.1),
}

local function ParsePrintersOut(str)
    local t = string.Explode(" ", str)
    return t
end

local function ParsePrintersIn(tbl)
    local t = {}

    for i=1, max do

        local ent = tbl[i]
        local id = (IsValid(ent) and ent:EntIndex()) or "0"
        t[#t+1] = id

    end

    local str = table.concat(t, " ")
    return str
end

function ENT:NetworkPrinters()
    local str = ParsePrintersIn(self.Printers)
    self:SetPrinters(str)
end

function ENT:Touch(ent)

    if not ent.IsPrinter or ent.IsInRack or self.Printers[ent] or ent:CPPIGetOwner() ~= self:CPPIGetOwner() then return end 
    if table.Count(self.Printers) >= max then return end 

    local fr = 0

    for i=1, max do 
        if not self.Printers[i] then fr = i break end 
    end
    if fr==0 then error('no free key for printer!') end 

    self.Printers[fr] = ent

    if not pos[fr] then error('wtf!!!') end

    local off = pos[fr]
    local pos = self:GetPos()
    local ang = self:GetAngles()
    

    pos = pos + ang:Up() * off.z
    pos = pos + ang:Right() * off.y 
    pos = pos + ang:Forward() * off.x

    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetMoveType(MOVETYPE_NONE)
    ent:SetParent(self)
    ent.IsInRack = true
    BWEnts[ent].DontPower = true
    self:NetworkPrinters()
    self.CurrentValue = 15000
    for k,v in pairs(self.Printers) do 
        if v.CurrentValue then self.CurrentValue = self.CurrentValue + v.CurrentValue end
    end
end

function ENT:ThinkFunc()
    local me = self:GetTable()
    for k,v in pairs(me.Printers) do 

        if not IsValid(v) then me.Printers[k] = nil continue end 

        local pw = BWEnts[self].Power
        local req = v.PowerRequired
 
        if pw <= req then break end 
        
        BWEnts[v].Power =  math.min(BWEnts[v].Power + (req + 5), BWEnts[v].MaxPower or 1000)
        BWEnts[self].Power = math.max(pw - (req), 0)

    end
    self:NetworkPrinters()
end

function ENT:Eject(num)
    local me = self:GetTable()

    if not me.Printers[num] then print("no printer!", num) return end

    local ent = me.Printers[num]
    if not ent or not IsValid(ent) then print('not valid') return end 

    local mins = ent:OBBMins()
    local maxs = ent:OBBMaxs()

    mins, maxs = ent:GetRotatedAABB(mins, maxs)

    OrderVectors(mins, maxs)

    local ang = self:GetAngles()

    local startpos = ent:GetPos()
    local dir = ang:Forward()
    local len = 64

    local ignore = {self, ent}

    table.Add(ignore, me.Printers)

    local tr = util.TraceHull( {
        start = startpos,
        endpos = startpos + dir * len,
        maxs = maxs,
        mins = mins,
        filter = ignore
    } )
    if not tr.Hit then 
        me.Printers[num] = nil 
        ent.IsInRack = false
        BWEnts[ent].DontPower = nil
        ent:SetParent(nil)
        ent:SetMoveType(MOVETYPE_VPHYSICS)
        ent:SetPos(ent:GetPos() + ang:Forward() * 56)
        ent:SetGravity(1)

        ent:GetPhysicsObject():EnableGravity(true)
        ent:SetAbsVelocity(Vector(0, 0, 0))
        self.CurrentValue = 15000
        for k,v in pairs(self.Printers) do 
            if v.CurrentValue then self.CurrentValue = self.CurrentValue + v.CurrentValue end
        end
    end
end 
util.AddNetworkString("EjectPrinter")

net.Receive("EjectPrinter", function(_, ply) 
    local ent = net.ReadEntity()
    if not IsValid(ent) or ent:GetClass() ~= "bw_printerrack" or ply:GetPos():Distance(ent:GetPos()) > 192 or ent:CPPIGetOwner() ~= ply then return end 
    local pr = net.ReadUInt(8)
    ent:Eject(pr)

end)

function ENT:Use(ply)
    for k,v in pairs(self.Printers) do 
        if not IsValid(v) then continue end 
        local _ = v.UseFunc and v:UseFunc(ply, ply, _, _, true)
    end
    ply:EmitSound("mvm/mvm_money_pickup.wav")
end