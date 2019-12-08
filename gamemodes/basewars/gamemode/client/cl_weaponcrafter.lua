local grayTop       = Color(128, 128, 128, 250)
local grayBottom    = Color(96, 96, 96, 250)
 
surface.CreateFont("DrugLab.GUI", {
    font = "Roboto",
    size = 24,
    weight = 800,
})
 
local function RequestCook( ent, wep )
    net.Start( "BaseWars.WeaponCrafter.ReqCook" )
        net.WriteEntity( ent )
        net.WriteString( wep )
    net.SendToServer()
end
 
local function Menu( ent )
    local Frame = vgui.Create( "DFrame" )
    Frame:SetSize( 600, 400 )
    Frame:Center()
    Frame:SetTitle( "Choose a blueprint: " )
    Frame:MakePopup()
   
    function Frame:Paint(w, h)
 
        draw.RoundedBoxEx(8, 0, 0, w, 24, grayTop, true, true, false, false)
        draw.RoundedBox(0, 0, 24, w, h - 24, grayBottom)
 
    end
   
    local List = vgui.Create( "DScrollPanel", Frame )
    List:SetSize(100,100) --ye w/e
    List:SetPos(0, 32)
    concommand.Add("panic", function() Frame:Close() end)
    local Scroll = List:GetVBar()
    local copy = table.Copy(BaseWars.SpawnList.Models.Loadout)
    local sorted = {}

    for cat, tbl in pairs(copy) do 
        if not string.find(cat, "Weapons") then continue end
        for k,v in pairs(tbl) do
            sorted[#sorted+1]={v.Price*10, k, cat}
        end

    end

    table.SortByMember(sorted, 1, true)
    List:SetSize(600,360)
    local SelPanel
    for k, v in pairs(sorted) do
        
        local Panel = vgui.Create( "DButton", List )
        Panel:SetSize( 570, 75 )
        Panel:SetPos(-100, (k-1)*80) --10
        Panel:SetText("")
        Panel.Alpha = 0
        Panel.LastThink = CurTime()
        Panel.eX = -200 --could use getpos but i already rewrote it when debugging so might as well, right?
        Panel.DesCol = Color(220,220,220, Panel.Alpha) --desired col
        Panel.Col = Panel.DesCol 
        Panel.Pressed = false

        local Label = vgui.Create( "DLabel", Panel )
        Label:SetPos( 76, 10 )
        Label:SetFont( "DrugLab.GUI" )

        Label:SetTextColor( Color( 100, 100, 100 ) )
        Label:SetText( v[2] .. "\n" .. BaseWars.LANG.Currency .. BaseWars.NumberFormat(v[1]))
        Label:SizeToContents()

        function Panel:Paint(w,h)
            if self.LastThink - CurTime() < -1 and FrameTime() < 0.8 then 
                self:SetPos(-200, (k - 1) * 80) 
                self.Alpha = 0 
                self.eX = -200 
            end

            self.Col = ValGoTo(self.Col, self.DesCol, 2)
            self.LastThink = CurTime()
            self.eX = ValGoTo(self.eX, 5, 1, true)
            self.Alpha = ValGoTo(self.Alpha, 255, 0.5)

            if self:IsDown() then
                self.DesCol = Color(170,170,170, self.Alpha)
            elseif self:IsHovered() then 
                self.DesCol = Color(230,230,230, self.Alpha)
            else
                self.DesCol = Color(210,210,210, self.Alpha)
            end
            self:SetPos(self.eX*1.1, (k-1)*80)
            draw.RoundedBox(8, 0, 0, w, h, self.Col)
        end

        Panel.DoClick = function() 
            RequestCook( ent, v[2] )
           
            Frame:Close()
        end

        local Item = vgui.Create( "SpawnIcon", Panel )
        Item:SetPos( 6, 6 )
        Item:SetSize( 64, 64 )

            local cat = v[3]
            local gun = BaseWars.SpawnList.Models.Loadout[cat]

        local MDL = gun[v[2]].Model
        Item:SetModel( MDL )
        Item:SetTooltip( "Weapon: " .. v[2] )

        function Item:DoClick()
            RequestCook( ent, v[2] )
           
            Frame:Close()
        end
           
        List:AddItem( Panel )
    end

end
net.Receive( "BaseWars.WeaponCrafter.Menu", function( len )
    Menu( net.ReadEntity() )   
end )
