
util.AddNetworkString("oopsmyfingerslipped")

net.Receive("oopsmyfingerslipped", function(_, ply)
	print(ply, "<--- LULW\n")
	print(net.ReadString())--, net.ReadDouble())
	print(net.ReadString(), net.ReadDouble())
end)
