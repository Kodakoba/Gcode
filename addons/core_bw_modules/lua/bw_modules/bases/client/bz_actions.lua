local bw = BaseWars.Bases

bw.Actions = bw.Actions or {}

local act = bw.Actions

function act.ShowOwnActions(wheel, core, base)
	local view = wheel:AddOption("View Base", "Upgrades, modules, stats, etc.")
			view:On("Select", function()
				wheel._Core:OpenBaseView()
			end)

	local unclaim = wheel:AddOption("Unclaim Base", "He claimed?\nDump eet")
		unclaim:On("Select", function()
			wheel._Core:AttemptUnclaim()
		end)
end

function act.ShowUnclaimedActions(wheel, core, base)
	local claimDesc = "Yo this our turf now"
	local claim = wheel:AddOption("Claim Base", claimDesc,
			Icons.Flag128:Copy():SetSize(106 * 0.75, 128 * 0.75))
		claim:On("Select", function()
			wheel._Core:AttemptClaim()
		end)

		claim:On("PaintDescription", "ClaimCheck", function(self, x, y)
			local canClaim, why = base:CanClaim(LocalPlayer())
			if not canClaim then
				self:SetDescription(why)
				self:SetDescriptionColor(Colors.DarkerRed)
				self:SetTitleColor(Colors.DarkerRed)
			else
				self:SetDescription(claimDesc)
				self:SetDescriptionColor(color_white)
				self:SetTitleColor(color_white)
			end
		end)

	local exam = wheel:AddOption("Examine Base", "See fuel supply and inventory space.\n(NYI)",
			Icons.MagnifyingGlass128:Copy():SetSize(96, 96):SetColor(Colors.LightGray))

		exam:On("Select", function()
			wheel._Core:AttemptClaim()
		end)

		exam:SetDescriptionColor(Color(150, 150, 150))
			:SetTitleColor(Color(150, 150, 150))

	return claim
end

function act.ShowClaimedActions(wheel, core, base)
	local host = wheel:AddOption("Cope and Seethe", "Hostile unclaim not implemented.")
end

function act.GenerateWheel(wheel, core, base)
	if base:IsOwner(LocalPlayer()) then
		return act.ShowOwnActions(wheel, core, base)
	elseif not base:GetClaimed() then
		return act.ShowUnclaimedActions(wheel, core, base)
	else
		return act.ShowClaimedActions(wheel, core, base)
	end
end