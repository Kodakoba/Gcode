
if ispanel(FFF) then FFF:Remove() end

FFF = vgui.Create("FFrame")
local f = FFF
f:SetSize(600, 500)
f:Center()
f:MakePopup()

local n1 = vgui.Create("FNumSlider", FFF)
n1:SetMinMax(0, 10)
n1:SetDecimals(0)
n1:SetSize(500, 100)
n1:Center()
n1:CenterVertical(0.3)

local n = vgui.Create("FNumSlider", FFF)
n:SetMinMax(0, 360)
n:SetDecimals(0)
n:SetSize(500, 100)
n:Center()
n:CenterVertical(0.5)

local n2 = vgui.Create("FNumSlider", FFF)
n2:SetMinMax(0, 10)
n2:SetDecimals(0)
n2:SetSize(500, 100)
n2:Center()
n2:CenterVertical(0.7)

f.Shadow = {}

function n1:OnValueChanged(new)
	f.Shadow.spread = new
end

function n:OnValueChanged(new)
	local col = HSVToColor(new, 1, 1)
	f.Shadow.color = col
end

function n2:OnValueChanged(new)
	f.Shadow.intensity = new
end