--hi

hook.Add("PlayerSay", "FuckOff", function(ply, txt)

end)

hook.Add("CheckPassword", "FuckOffIdiots", function(sid64, ip, pw1, pw2, name)
	if name == "#VAC_ConnectionRefusedDetail" and sid64 ~= "76561198101997214" then --eclipse steamid
		return false, "if i ever see you with that name you're getting permabanned"
	end
end)