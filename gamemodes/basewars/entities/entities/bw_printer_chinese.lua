ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.PowerRequired = 0

ENT.PrintInterval 	= 1
ENT.PrintAmount		= 198900
ENT.Capacity = 1989e4

ENT.PrintName = "Print Machine"

ENT.FontColor = Color(30, 180, 30)
ENT.BackColor = Color(60,60,60)

ENT.IsValidRaidable = true
ENT.PresetMaxHealth = 100

local china_great = "一乙二十丁厂七卜八人入儿匕几九刁了刀力乃又三干于亏工土士才下寸大丈与万上小口山巾千乞川亿个夕久么勺凡丸及广亡门丫义之尸己已巳弓子卫也女刃飞习叉马乡丰王开井天夫元无云专丐扎艺木五支厅不犬太区历歹友尤匹车"
local china_nation = {}

for i, code in utf8.codes(china_great) do
	local sym = utf8.char(code)
	china_nation[#china_nation + 1] = sym
end

China = china_nation

function ENT:Initialize()
	local suf = ""

	for i=1, math.random(5, 9) do
		suf = suf .. china_nation[math.random(#china_nation)]
	end

	suf = suf .. self.PrintName

	for i=1, math.random(2, 5) do
		suf = suf .. china_nation[math.random(#china_nation)]
	end

	self.PrintName = suf

	baseclass.Get(self.Base).Initialize(self)
end

function ENT:DrawUpgradeCost(y, w, h)
	surface.SetDrawColor(255, 255, 255)
	draw.DrawGIF("http://vaati.net/Gachi/shared/quake-grunt.png",
	 	"queik", 0, h * 0.2, w, h * 0.6)

	draw.DrawGIF("http://vaati.net/Gachi/shared/chinese-flag-1.png",
	 	"chaina", w * 0.2, 0, w * 0.6, h * 0.3)

	draw.DrawGIF("http://vaati.net/Gachi/shared/chinese-flag-1.png",
	 	"chaina", w * 0.2, h * 0.7, w * 0.6, h * 0.3)
end

function ENT:Use()
	if math.random() < 0.1 then
		self:Explode()
	end
end