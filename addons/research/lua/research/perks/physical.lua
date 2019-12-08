--poop

local vit = Research.SubCategories.Vitality

local PERKS = {}

local prk = Research.AddPerk({
	Name = "Health Up",
	ID = "healthup",
})

for i=1, 25 do
	prk:AddLevel({sulfur = i, gold_bar = math.ceil(i/3)})
end

table.insert(PERKS, prk)


prk = Research.AddPerk({
	Name = "Regeneration",
	ID = "regen"
})

for i=1, 5 do 
	prk:AddLevel({})
end 

table.insert(PERKS, prk)


for k,v in pairs(PERKS) do 
	vit:AddPerk(v)
end

PERKS = {}

local mob = Research.SubCategories.Mobility

local prk = Research.AddPerk("Run Speed Up", "speedup")

for i=1, 50 do
	prk:AddLevel({})
	prk:AddYield("misc", {

		{
			Description = {
				{	
					Text = "Run ",
				},
				{
					Text = "faster!",
					Color = Color(50, 150, 250),
					Continuation = true
				},
			},
			Icon = {
				URL = "https://i.imgur.com/dO5eomW.png",
				Name = "plus.png",
			}
		},

	})

	local offy = (i%18 < 9 and 95) or 15
	local mul = offy==95 and -1 or 1

	local x = 20 + math.floor(i/9)*10
	local y = offy + (i%9)*10*mul

	prk:SetPos(i, x, y)
end

prk:SetDescription([[Congratulations! 
The simple fact that you're sitting over there, reading this means you've made a glorious contribution to science.
And everything is working. So far.]])

mob:AddPerk(prk)

prk = Research.AddPerk("Jump Up", "jumpup")

for i=1, 5 do 
	prk:AddLevel({gold_bar = i*3})
	prk:AddYield("misc", {

		{
			Name = "Poop!",
			Description = {
				{	
					Text = "Jump ",
				},
				{
					Text = "higher!",
					Color = Color(50, 150, 250),
					Continuation = true
				},
			},
			Icon = {
				URL = "https://i.imgur.com/dO5eomW.png",
				Name = "plus.png",
				W = 48,
				H = 48
			}
		},

	})
	prk:SetPos(i, 80, 105 - i*10)
end 

prk:SetDescription([[Hello investors, Cave Johnson here. 
Now I know you've sunk a lot of money into the money printing devices. 
But I'm here to tell you we're not banging rocks together over here. We know how to make a quantum space hole.
Now, we have run into a reproducible human error problem: a lot of expensive printers getting broken due to the lack of mobility on the defenders' part. 
But don't worry, Cave took care of it.]])

mob:AddPerk(prk)
