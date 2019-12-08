--hi
local AdminHesDoingItSideways = false 
local OkStop = false

hook.Add("Think", "dontforgettoxd", function()

	if IsValid(AdminHesDoingItSideways) then 
		local s = AdminHesDoingItSideways
		local vol = s:GetVolume() 

		vol = (OkStop and vol-FrameTime()/10) or vol+FrameTime()/5
		s:SetVolume(math.min(vol, 0.8))
		if vol<=0 then s:Stop() AdminHesDoingItSideways = false OkStop = fakse return end

	end
end)

net.Receive("gachiHop", function()
	local offedyam8 = net.ReadBool()
	if IsValid(AdminHesDoingItSideways) and offedyam8 then OkStop = false return end 
	if not offedyam8 then OkStop = true return end

	hdl.DownloadFile("http://vaati.net/Gachi/shared/gachiPhoon.mp3", "gachiPhoon.txt", function(name, body)
		sound.PlayFile(name,"noblock",function(s, eid, errname) 
			if eid and errname then return end 
			AdminHesDoingItSideways = s 
			s:EnableLooping(true)
			s:SetVolume(0)
			okstop = false
		end, nil, true) 

	end, function(err) end)



end)

