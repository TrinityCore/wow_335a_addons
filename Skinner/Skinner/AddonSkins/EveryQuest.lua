if not Skinner:isAddonEnabled("EveryQuest") then return end

function Skinner:EveryQuest()
	if not self.db.profile.QuestLog then return end

	local eq = LibStub("AceAddon-3.0"):GetAddon("EveryQuest", true)
	if not eq then return end
	-- button on QuestLog frame
	self:skinButton{obj=eq.frames.Show}
	-- Main frame
	self:skinDropDown{obj=eq.frames.Menu}
	self:skinScrollBar{obj=EveryQuestListScrollFrame}
	self:addSkinFrame{obj=EveryQuestFrame, kfs=true, x1=10, y1=-11, x2=-31, y2=-2}

end
