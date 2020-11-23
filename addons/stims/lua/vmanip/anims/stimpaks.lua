--[[

Hands
	"model" - path to model
	"lerp_peak" - time when the hand should transition back to the weapon
	"lerp_speed_in" - speed at which the hand transitions into the anim
	"lerp_speed_out" - speed at which the hand transitions out of the anim
	"lerp_curve" - power of the curve
	"speed" - playback speed
	"startcycle" - time to start the anim at
	"cam_ang" - angle offset for the camera
	"cam_angint" - intensity multiplier of the camera
	"sounds" - table of sounds, keys represent the path and their value the time it plays at. do not use past holdtime lmao
	"loop" - loop the anim instead of stopping
	"segmented" - when anim is over, freezes it and waits for SegmentPlay(sequence,lastanim). Repeat if lastanim is false
	^Note: lerp peak and related values are used for the "last segment" instead.

	"holdtime" - the time when the anim should be paused
	"preventquit" - ONLY accept QuitHolding request if the argument is our anim. Use very cautiously
	"assurepos" - for important anims, makes sure the position isn't offset by sweps. Use locktoply it's better
	"locktoply" - for when assurepos isn't enough.

]]

STIMPAK_INJECT_TIME = 0.57
STIMPAK_WORK_TIME = 0.8
STIMPAK_REMOVE_TIME = 0.4

if CLIENT then
	local mx = 0

	local files, _ = file.Find("models/c_grp_stim*", "DOWNLOAD")

	for k,v in ipairs(files) do
		local num = v:match("c_grp_stim(%d*)")

		mx = (num ~= "" and math.max(num and tonumber(num), mx)) or ""
	end

	local nm = "grp/stims/c_grp_stim" .. mx .. ".mdl"

	VManip:RegisterAnim("stim_inject_start",
		{
			["model"] = nm,
			["lerp_peak"] = STIMPAK_REMOVE_TIME,
			["lerp_speed_in"] = 0.4,
			["lerp_speed_out"] = 0.35,
			["lerp_curve"] = 3,
			["speed"] = 1,
			--["holdtime"] = 0.6,
			segmented = true
		}
	)



	VManip:RegisterAnim("stim_inject_end",
		{
			["model"] = nm,
			["lerp_peak"] = 0,
			["lerp_speed_in"] = 0.4,
			["lerp_speed_out"] = 0.8,
			["lerp_curve"] = 1.4,
			["speed"] = 1,
		}
	)
end