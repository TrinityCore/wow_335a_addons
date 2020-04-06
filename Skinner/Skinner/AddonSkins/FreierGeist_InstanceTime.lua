if not Skinner:isAddonEnabled("FreierGeist_InstanceTime") then return end

function Skinner:FreierGeist_InstanceTime()

	self:addSkinFrame{obj=InstanceTimeFrame}
	self:addSkinFrame{obj=InstanceTime_TimerFrameXP}
	self:addSkinFrame{obj=InstanceTime_TimerFrameRep}
	self:skinScrollBar{obj=InstanceTimeScrollBar}
	self:addSkinFrame{obj=InstanceTime_ListFrame}
	self:addSkinFrame{obj=InstanceTime_TellToFrame}
	self:skinScrollBar{obj=InstanceTimeClassScrollBar}
	self:addSkinFrame{obj=InstanceTime_ClassFrame}
	self:skinScrollBar{obj=InstanceTimeLootScrollBar}
	self:addSkinFrame{obj=InstanceTime_LootFrame}
	self:skinScrollBar{obj=InstanceTimeBossScrollBar}
	self:addSkinFrame{obj=InstanceTime_BosskillFrame}
	self:skinScrollBar{obj=InstanceTime_ScrollFrame}
	self:addSkinFrame{obj=InstanceTime_ClipFrame}
-->>--	Options Frame
	self:skinEditBox(InstanceTimeOptionsFrameAnnouncement)
	self:skinEditBox(InstanceTimeOptionsFrameLeaveChannels)
	self:skinEditBox(InstanceTimeOptionsFrameContinueWithin)
	self:skinEditBox(InstanceTimeOptionsFrameRepairUntil)
	self:skinEditBox(InstanceTimeOptionsFrameDateFormat)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem1)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem2)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem3)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem4)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem5)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem6)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem7)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem8)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem9)
	self:skinEditBox(InstanceTimeOptionsFrameExcludeItem10)
	self:skinDropDown{obj=InstanceTimeOptionsFrameDropDownPostTo}
	self:addSkinFrame{obj=InstanceTimeOptionsFrame}
-->>--	Help Frame
	self:skinFFToggleTabs("InstanceTime_HelpTab_", 6)
	self:skinScrollBar{obj=InstanceTime_HelpScrollFrame}
	self:addSkinFrame{obj=InstanceTime_Help}

end
