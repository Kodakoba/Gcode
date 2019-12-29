--123

function Log(mod, str, ...)
	mod = mod or {name = "Unnamed! " .. debug.traceback(), col = Color(255, 255, 255)}
	local n = mod.name or "???"
	local col = mod.col or Color(255, 0, 0)
	
	str = str:format(...)

	local tbl = {
		col, 
		("[%s] "):format(n), 
		Color(255, 255, 255)}

	local str2 = str 

	local tags = str:match("%b[]")

	if tags then 
		local lastsub = 0

		for s in str:gmatch("%[(.-)%]") do 
			local r, g, b = s:match("col[%s]*=[%s]*(%d+),[%s]*(%d+),[%s]*(%d+)")

			if r or g or b then 
				
				local where, ends = string.find(str2, s, 1, true)
				str2 = str2:gsub(s, "")
				
				tbl[#tbl + 1] = string.sub(str2, lastsub+1, where-2)
				
				tbl[#tbl + 1] = Color(r, g or 0, b or 0)
				lastsub = where
			end
		end 

		tbl[#tbl + 1] = string.sub(str2, lastsub+1, #str2)
	else 
		tbl[#tbl + 1] = str 
	end

	tbl[#tbl + 1] = "\n"

	MsgC(unpack(tbl))

end