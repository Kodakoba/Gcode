
if SkyFlash and IsValid(SkyFlash) then SkyFlash:Remove() end 
if IsValid(SkyStream) then SkyStream:Stop() end 

SkyFlash = vgui.Create("FFrame")

local w, h = 700, 500

SkyFlash:SetSize(w, h)
SkyFlash:Center()
SkyFlash.Shadow = {}
SkyFlash:MakePopup()


local waves = 1
local cyclespeed = 60


hdl.PlayURL("http://vaati.net/Gachi/shared/goodbye%20to%20a%20world.mp3", "mus/bye.dat", "noblock", function(s, err, er2)
	if not IsValid(s) then return end 
	SkyStream = s
	--s:SetVolume(0.01)
	s:SetTime(90)
end)

local enum = FFT_256

local FFTLen = 2 ^ (enum + 7)
local lerpamt = 25

local fft = {}
local fftlerp = {}

for i=1, FFTLen do 
	fftlerp[i] = {}
end

local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")

local function FFTSum(i)
	local sum = 0

	for k,v in ipairs(fftlerp[i]) do 
		sum = sum + v 
	end

	return sum / lerpamt
end

function SkyFlash:PostPaint(w, h)

	if IsValid(SkyStream) then 
		SkyStream:FFT(fft, enum)
	end

	local lastsplit = 1
	local splits = {}

	local diff

	for i=2, FFTLen do 
		if not fft[i] then break end 

		fftlerp[i][#fftlerp[i] + 1] = Lerp(0.4, fft[i] * 5000, FFTSum(i))--fft[i] * 5000

		if #fftlerp[i] > lerpamt then table.remove(fftlerp[i], 1) end

		local sum = FFTSum(i)

		fft[i] = sum
		-- Lerp(1 - FrameTime() * 15, fft[i], lastfft[i] or 0)

		--end

		local curdiff = fft[i] - fft[i - 1]
		diff = diff or curdiff
		if ((curdiff < 0 and diff > curdiff) or (curdiff > 0 and diff < curdiff)) and (i - lastsplit > 16) then

			splits[lastsplit] = i - lastsplit
			lastsplit = i 

			splits[1] = splits[1] or i
			diff = curdiff
		end

		--lastfft[i] = fft[i]
	end

	

	local lastwaveind = 0
	local cursinx = 0
	local lastdeg = 0

	surface.SetDrawColor(color_white)
	surface.SetMaterial(gu)

	local maxh = h

	draw.Masked(function() 

		for k,v in pairs(splits) do 

			local ind, len = k, v

			local x = w / FFTLen * ind 	--X of the current segment group
			local segw = w / FFTLen		--length of one segment

			local poly = {
				{x = x, y = h, u = 0, v = 0}
			}

			for i=0, len do 

				local sx = segw*i
				local sy = math.abs(math.log10(fft[ind + i] or 0.001) * 50)

				poly[i+2] = {x = x + sx, y = h/2 - sy, u = 1 / len * i, v = 1}
				maxh = math.min(maxh, h/2 - sy)
			end

			poly[#poly + 1] = {x = x + segw*len, y = h, u = 1, v = 0}

			surface.DrawPoly(poly)

		end
	end, function()
		surface.DrawTexturedRect(0, maxh, w, h - maxh)
	end)
end

function SkyFlash:OnClose()
	SkyStream:Stop()
end