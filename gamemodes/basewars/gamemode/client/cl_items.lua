local haloPlayers,rainbowPlayers = {}, {}
local DrawHalo
local mat = Material("vgui/misc/feet1.png")
local rot,col = 0,0
local halodraw = CreateClientConVar("shop_drawhalo","1", true, false,"Enable halos under players' feet?" )
local rainbowdraw = CreateClientConVar("shop_drawrainbow","1", true, false,"Enable rainbow physguns for players?" )

timer.Create("itemsCheck", 0.5, 0, function()

for _,v in pairs(player.GetAll()) do

    local HasHalo = v:GetNWInt("HasHalo",0)
    local RainbowPhysgun = v:GetNWInt("RainbowPhysgun",0)

    if tonumber(HasHalo)~=0  then
        if !table.HasValue(haloPlayers, v) then
           table.insert(haloPlayers,v)
        end
    end

    if tonumber(HasHalo)==0 then 
        table.RemoveByValue(haloPlayers,v) 
    end


    if tonumber(RainbowPhysgun)~=0  then
        if !table.HasValue(rainbowPlayers, v) then
           table.insert(rainbowPlayers,v)
        end
    end

end



--ty to q2 for this i was too lazy to figure shit out
--V

hook.Add("PrePlayerDraw", "Halo", function(ply)
    if halodraw:GetInt()==0 then return end
    if !table.HasValue(haloPlayers, ply) then return end

    rot = rot + FrameTime() * 14.88 -- speed
    cam.Start3D2D(ply:GetPos() - Vector(0, 0, -1), Angle(0, 0, 0), 0.5) 
        local col = team.GetColor(ply:Team()) or Color(255,0,0)
        surface.SetDrawColor(col.r, col.g, col.b, 120)
        surface.SetMaterial(mat)

        surface.DrawTexturedRectRotated(0, 0, 64, 64, rot)
    cam.End3D2D()
end)

hook.Add("PrePlayerDraw", "RainbowPhys", function(ply)
    if rainbowdraw:GetInt()==0 then return end
    if !table.HasValue(rainbowPlayers, ply) then return end
    col=(col or 0) + FrameTime()*25
    local color = HSVToColor(col,1,0.6)
    ply:SetWeaponColor(Vector(color.r/255,color.g/255,color.b/255))
end)

hook.Add("Think", "RainbowPhys", function()
    if !table.HasValue(rainbowPlayers, LocalPlayer()) then return end
    col=(col or 0) + FrameTime()*25
    if col>360 then col=col-360 end
    local color = HSVToColor(col,1,0.6)
    LocalPlayer():SetWeaponColor(Vector(color.r/255,color.g/255,color.b/255))

    end)

end)

