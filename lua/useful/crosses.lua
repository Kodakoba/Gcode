if SERVER then
    util.AddNetworkString("cross")

    function cross(vec, sz, lf, col, igz)
        net.Start("cross")
            net.WriteVector(vec)
            net.WriteUInt(sz, 8)
            net.WriteFloat(lf or 1)
            net.WriteColor(col or color_white)
            net.WriteBool(igz)
        net.Broadcast()
    end

else

    net.Receive("cross", function()
        local where, sz, lf, col, igz = net.ReadVector(), net.ReadUInt(8), net.ReadFloat(), net.ReadColor(), net.ReadBool()
        debugoverlay.Cross(where, sz, lf, col, igz)
    end)

    cross = debugoverlay.Cross

end
