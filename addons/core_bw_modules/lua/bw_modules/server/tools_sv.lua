local cd = LibItUp.Cooldown()

hook.Add("CanTool", "AllowWire", function(ply, tool, name, ...)
	if not name:match("^wire_") then return end

	if not hook.Run("CanUseWire", ply, tool, name) then
		if cd:Put(ply, 0.5) then
			ply:Notify({Colors.Error, ("#tool.%s.name"):format(name), " is restricted!"})
		end

		return false
	end
end)

local hi_access = table.KeysToValues({
	"cpu", "expression2", "gpu", "spu",
	"explosive", "simple_explosive", "igniter",
	"spawner", "teleporter", "turret",
	"exit_point",
})

hook.Add("CanUseWire", "DefaultAllowed", function(ply, tbl, tool)
	if ply.DisallowWire then return false end

	if ply:IsUserGroup("electrician") and not hi_access[tool:match("wire_(.+)$")] then return true end
	if ply:IsAdmin() then return true end
end)