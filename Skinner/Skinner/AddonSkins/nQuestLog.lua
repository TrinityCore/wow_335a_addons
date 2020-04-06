if not Skinner:isAddonEnabled("nQuestLog") then return end

function Skinner:nQuestLog()

	self:applySkin(nQuestLogFrame)
	nQuestLogFrame.SetBackdrop = function() end
	nQuestLogFrame.SetBackdropColor = function() end
	nQuestLogFrame.SetBackdropBorderColor = function() end

	local bf = nQuestLog:GetModule("BlizzardFrames")
	-- hook this and change text colour before level number added
	self:RawHook(bf, "OnQuestGreeting", function(this)
		for i = 1, MAX_NUM_QUESTS do
			local text = self:getRegion(_G["QuestTitleButton"..i], 3)
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self.hooks[bf].OnQuestGreeting(this)
	end, true)

end
