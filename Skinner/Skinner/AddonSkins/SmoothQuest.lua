if not Skinner:isAddonEnabled("SmoothQuest") then return end

function Skinner:SmoothQuest()

	local SQ = LibStub("AceAddon-3.0"):GetAddon("SmoothQuest")
	-- hook this and change text colour before level number added
	self:RawHook(SQ, "QUEST_GREETING", function(this)
		for i = 1, MAX_NUM_QUESTS do
			local text = self:getRegion(_G["QuestTitleButton"..i], 3)
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self.hooks[SQ].QUEST_GREETING(this)
	end, true)

end
