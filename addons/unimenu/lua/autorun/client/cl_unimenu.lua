
unimenu = {}

unimenu.Frame = nil

function unimenu.Open()
    if not IsValid(g_ContextMenu) then return end 

    local f = vgui.Create("FFrame", g_ContextMenu)
    f:MoveToFront()
    f:SetPos(ScrW() - 1, ScrH()/2 - 300)
    f:MoveTo(ScrW() - 20, f.Y, 0.3, 0, 0.4)
    unimenu.Frame = f

end

local iv = IsValid --im lazy

function unimenu.Close()
    if IsValid(unimenu.Frame) then
        local f = unimenu.Frame 
        f:MoveTo(ScrW()+1, f.Y, 0.4, 0, 0.3, function() if IsValid(f) then f:Remove() end end)
    end
end 

hook.Add("OnContextMenuOpen", "UniMenuOpen", function()
    if isstring(LocalPlayer():GetActiveWeapon().Base) and string.find(LocalPlayer():GetActiveWeapon().Base, "tfa") then return end 

    unimenu.Open()
end)

 hook.Add("OnContextMenuClose", "UniMenuOpen", function() 
    unimenu.Close()
end)



