BASEWARS_CHOSEN_LANGUAGE = "ENGLISH"

BackupWeaponKeys = {}

BaseWars.Config = {
	DiscordLink = "https://discord.gg/TCVwCAZqGW",

	AFKTime = 90,
	AFKConserveTime = 180, -- FPS gets limited after this time

	SpawnWeps = {
		"weapon_physcannon",
		"hands",
		"dash"
	},

	WeaponDropBlacklist = {
		["hands"] = true,
		["weapon_physcannon"] = true,
		["weapon_physgun"] = true,
		["gmod_tool"] = true,
		["gmod_camera"] = true,
		["dash"] = true,
	},

	PhysgunBlockClasses = {
		["bw_spawnpoint"] = true,
	},

	BlockedTools = {
		["dynamite"] = true,
		["duplicator"] = true,
	},

	ModelBlacklist = {
	},

	StartMoney 			= 300,

	-- Finds all physics props on the map and removes them when
	-- all the entities are first initialized
	CleanProps			= false,

	AllowFriendlyFire	= false,

	DefaultWalk			= 220,
	DefaultRun			= 300,

	DefaultLimit		= 4,
	SpawnOffset			= Vector(0, 0, 40),	-- weapon spawn offset

	UniversalPropConstant = 20,
	DestroyReturn 		= 0.6,

	DispenserTime		= 2,

	VIPRanks = {"vip"},
}

BaseWars.Config.EXPMult = 1