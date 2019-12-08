hudmus.Settings = hudmus.Settings or {}

local shorts = {
	["Volume"] = "v",
	["FFTEnabled"] = "fe",
}

local back = {
	["v"] = "Volume",
	["fe"] = "FFTEnabled",
}


function hudmus.SaveSettings()
	local set = table.Copy(hudmus.Settings)

	for k,v in pairs(set) do 
		if shorts[k] then 
			set[shorts[k]] = v
			set[k] = nil
		end
	end

	local json = util.TableToJSON(set)
	local dat = util.Compress(json)

	if #dat > #json then dat = json end -- :(
	
	file.Write("hudmus_settings.txt", dat)


end

local convert_url = "https://youtubemp3music.info/@api/json/mp3/%s"	--much love to them <3

local illegal = '[\\/:%*%?"<>|]'

local iltbl = {}

hudmus.ConvertingURL = hudmus.ConvertingURL or false 

function hudmus.ParseMusicURL(url)

	local url1 = string.gsub(url, "http%a://", "")
	print(url1)
	url1 = string.gsub(url1, "www.", "")
	print(url1)
	local p = "youtu.be" 
	local p2 = "youtube.com" 

	local urlsub = string.sub(url1, 0, 14)

	local short = string.match(urlsub, p)
	local long = string.match(urlsub, p2)


	if short or long then 
		local selpattern = (short and p) or p2
		local url2 = string.gsub(url1,selpattern,"")

		local vidid = ""
		if long then 
			url2 = url2 .. ")"
			vidid = string.match(url2,"%b=)")
			vidid = vidid:gsub("[=)]", "")
		else
			url2 = url2 .. ")"
			vidid = string.match(url2,"%b/)")
			vidid = vidid:gsub("[/)]", "")
		end

		local name = hudmus.DLFromYoutube(vidid)
		print('dling from youtube')
		return 1
	end

	if #url > 4 then 
		local format = string.sub(url, #url - 6)
		if not format:find(".mp3") then return "Not a link to an MP3 or YouTube!", 0 end

		if file.Exists("hdl/"..util.CRC(url) .. ".txt", "DATA") then return "A file from this URL already exists!", 1 end
		hudmus.ConvertingURL = true

		hdl.DownloadFile(url, "hudmus_temp.txt", function(name) 
			print('DLd from URL') 
			file.Rename("hdl/hudmus_temp.txt", "hdl/"..util.CRC(url) .. ".txt")
			hudmus.ConvertingURL = false 
			hook.Run("HUDMusOnDLFinish", util.CRC(url) .. ".txt")

		end, function(err) print('errored!') hudmus.ConvertingURL = false end)
		return 2
	end

end

function hudmus.DLFromYoutube(url)
	if not hdl or not url then return end 
	local murl 
	local curl = string.format(convert_url, url)
	local ret = "-"
	hudmus.ConvertingURL = true
	print('droppin a', curl)
	http.Fetch(curl,function(b, s)

		result = util.JSONToTable(b)


		if not result then error('Failed to turn the JSON into a table') hudmus.ConvertingURL = false return end 
		if result.error then hudmus.ConvertingURL = false error('Converter threw an error; halting conversion. Error: ' .. result.errorMsg or "uh?unknown???") return end
		for k,v in pairs(result.vidInfo) do 
			if v.bitrate == 128 then 
				murl = v.dloadUrl
			end

		end

		if not murl then hudmus.ConvertingURL = false print('ERROR:\n', b) error('oops could not find 128bitrate') return end

		ret = result.vidTitle or "_unnamed"
		hook.Run("HUDMusOnFetchYTName", ret)

		local name = util.CRC(url) .. ".txt"

		name = string.gsub(name, illegal, "")

		if not murl:StartWith("https:") then 
			murl = "https:" .. murl
		end



		hdl.DownloadFile(murl, name, function() 
			hudmus.ConvertingURL = false 
			hook.Run("HUDMusOnDLYT", name)
		end, function(err) print('errored!') hudmus.ConvertingURL = false end)
		

	end, function(s) hudmus.ConvertingURL = false error('Failed to fetch the mp3 or something: ' .. s) end)
end
--[[-------------------------------------------------------------------------
Essentially adds a new playlist to the current playlists table.

For reference:
Playlist table is:
[PlaylistName] = {
	 [SongName] = {fn = "FileName"},
	 ...
 }

---------------------------------------------------------------------------]]
function hudmus.CreatePlaylist(tbl)

	local ex = file.Read("hudmus_playlists.txt", "DATA")
	local decomp = util.Decompress(ex)

	if decomp then ex = decomp end 

	local prev = util.JSONToTable(ex) 
	if not prev then print('whot in the fok') prev = {} end 
	print('-------')
	PrintTable(prev)
	PrintTable(tbl)
	print('-------')
	local merge = table.Merge(prev, tbl)

	local json = util.TableToJSON(merge)
	local comp = util.Compress(json)
	if #json > #comp then json = comp end 
	file.Write("hudmus_playlists.txt", comp)

end

--[[-------------------------------------------------------------------------
	Overrides existing playlists table.
---------------------------------------------------------------------------]]
function hudmus.OverridePlaylist(tbl)

	local json = util.TableToJSON(tbl)
	local comp = util.Compress(json)

	if #json > #comp then json = comp end 

	file.Write("hudmus_playlists.txt", comp)

end

function hudmus.FetchPlaylists()
	local ex = file.Read("hudmus_playlists.txt", "DATA")
	if not ex then return {} end

	local decomp = util.Decompress(ex)

	if decomp then ex = decomp end 

	local prev = util.JSONToTable(ex) 
	if not prev then print('whot in the fok') prev = {} end 
	return prev
end

function hudmus.RestoreSettings()

	local str = file.Read("hudmus_settings.txt", "DATA")
	if not str then return end
	local dec = util.Decompress(str)

	if dec then str = dec end --successful

	local tbl = util.JSONToTable(str)
	
	for k,v in pairs(tbl) do 
		if back[k] then 
			tbl[back[k]] = v 
			tbl[k] = nil
		end
	end
	hudmus.Settings = tbl or {}
end

function hudmus:PlayURL(url, name, ply, client)
	if IsValid(s) and s:GetState() == GMOD_CHANNEL_PLAYING then 
		print('Cannot play a new stream on top of an existing one; queueing it up instead..')
		hudmus:Enqueue(name)

	end
	hudmus.LoadingStream = true

	sound.PlayURL(url,"",function(s, errid, errstr) 
		hudmus.LoadingStream = false
		if errid and (errid~=0 and errid~="0") then
			error("Music stream failed! Error ID: "..errid.."\nError string: "..errstr)
		end

		if not IsValid(s) then print('janked up stream; not valid') return end
		s:SetVolume(hudmus.Settings.Volume or 0.5)
		self.CurrentStream = {stream = s, name = name, ply = ply, cl = client}
		hook.Run("HUDMus", self.CurrentStream)
	end)

end

PlayMusURL = PlayURL

function hudmus:StopURL(ply)

		local s = istable(self.CurrentStream) and self.CurrentStream.stream

		if s and IsValid(s) and s:IsValid() and s:GetState() ~= GMOD_CHANNEL_STOPPED then 
			s:Stop()
			self.CurrentStream = nil
			hook.Run("HUDMusStop")
		end

end
StopMusURL = StopURL

hudmus.Queue = hudmus.Queue or {}
hudmus.UQueue = hudmus.UQueue or {}

local pl = {
	["♂Gachi Tunes♂"] = {
		["Hotline Gachimuchi - Cum"] = "http://vaati.net/Gachi/shared/%E2%99%82%20Hotline%20Gachimuchi%20-%20Run%20%E2%99%82.mp3",
		["Cum Buster"] = "http://vaati.net/Gachi/shared/%E2%99%82Gachirune_-_Cum_buster%28Battle_theme%29%E2%99%82.mp3",
	},
	["Rocket League Vol. 5"] = {
		["Muzzy - Horsepower"] = "http://vaati.net/Gachi/shared/Muzzy%20-%20Horsepower%20%281%29.mp3",
		["Rogue - Badlands"] = "http://vaati.net/Gachi/shared/Rogue%20-%20Badlands.mp3",
	},
}
local tracks = {}

hudmus.Playlists = hudmus.Playlists or pl

for k,v in pairs(pl) do 
	for k2, track in pairs(v) do
		tracks[k2] = {name = k2, url = track}
	end
end

function hudmus:GetPlaylists()
	return pl
end
function hudmus:PlayNextInQueue()

	if not self.Queue or not self.Queue[1] then return end 
	if self.LoadingStream then return end 

	local url = self.Queue[1].url
	local name = self.Queue[1].name 

	if not url or not name then return end 
	
	self:PlayURL(url, name, LocalPlayer(), true)
	table.remove(self.Queue, 1)

	local min = math.huge

	for k,v in pairs(self.UQueue) do 
		if k < min then min = k continue end
	end

	if min==math.huge then return end
	self.UQueue[min] = nil
end

hudmus.uID = hudmus.uID or 0

function hudmus:Enqueue(name)
	local q = self.Queue
	if not tracks[name] or not istable(tracks[name]) then print('No such tracks exist!') return end
	local uID = hudmus.uID 
	uID = uID + 1 
	hudmus.uID = uID

	local tbl = table.Copy(tracks[name])

	tbl.UID = uID

	q[#q+1] = tbl
	self.UQueue[uID] = tbl
end

net.Receive("StartMusicStream", function()

 	local url = net.ReadString()
 	local name = net.ReadString()
 	local ply = net.ReadEntity()
 	local cl = net.ReadBool()

 	if not IsValid(ply) or not ply:IsPlayer() then return end

 	hudmus:PlayURL(url, name, ply, cl)

end)

net.Receive("StopMusicStream", function()
	local ply = net.ReadEntity()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	hudmus:StopURL(ply)

end)
