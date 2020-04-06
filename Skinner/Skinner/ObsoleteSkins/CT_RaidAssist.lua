
function Skinner:CT_RaidAssist()
	if not self.db.profile.FriendsFrame then return end

-->>--	Tab Frame
	CT_RATabFrame:SetWidth(CT_RATabFrame:GetWidth() * self.FxMult)
	CT_RATabFrame:SetHeight(CT_RATabFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(CT_RATabFrame)
	self:moveObject(CT_RATabFrameTitleText, nil, nil, "+", 10)
	self:moveObject(CT_RATabFrameCloseButton, "+", 28, "+", 8)
	self:applySkin(CT_RATabFrame)

-->>--	Options Frame
	self:moveObject(CT_RAOptionsButton, "-", 40, "+", 10)
	self:moveObject(CT_RACheckAllGroups, "-", 40, "+", 10)
	self:moveObject(CT_RAOptionsFrameCheckAllGroupsText, "-", 40, "+", 10)
	self:moveObject(CT_RAOptionsGroup1, "-", 7, "+", 8)

-->>-- Menu Frame
	self:keepFontStrings(CT_RAMenuFrame)
	self:moveObject(CT_RAMenuFrameHeader, nil, nil, "-", 8)
	self:moveObject(CT_RAMenuFrameCloseButton, "+", 40, "+", 2)
	self:applySkin(CT_RAMenuFrame)

	self:keepFontStrings(CT_RAMenuFrameGeneralDisplayHealthDropDown)
	self:applySkin(CT_RAMenuFrameGeneralDisplay)
	self:keepFontStrings(CT_RAMenuFrameGeneralMiscDropDown)
	CT_RAMenuFrameGeneralMisc:SetWidth(CT_RAMenuFrameGeneralMisc:GetWidth() + 25)
	self:applySkin(CT_RAMenuFrameGeneralMisc)
	self:applySkin(CT_RAMenuFrameGeneralMTs)
	self:keepFontStrings(CT_RAMenuFrameBuffsBuffsDropDown)
	self:applySkin(CT_RAMenuFrameBuffsNotify)
	self:applySkin(CT_RAMenuFrameMiscNotifications)
	self:applySkin(CT_RAMenuFrameMiscDisplay)
	self:applySkin(CT_RAMenuFrameAdditionalScaling)
	self:applySkin(CT_RAMenuFrameAdditionalEM)
	self:applySkin(CT_RAMenuFrameAdditionalBG)
	self:applySkin(CT_RAMenuFrameAdditionalAlpha)

-->>--	Option Sets Frame
	self:RawHookScript(CT_RAMenu_NewSetFrame, "OnShow", function()
		self.hooks[CT_RAMenu_NewSetFrame].OnShow()
		self:keepFontStrings(CT_RAMenu_NewSetFrame)
		self:applySkin(CT_RAMenu_NewSetFrame)
		local ebName = CT_RAMenu_NewSetFrameNameEB
		self:moveObject(ebName, "+", 5, "-", 10)
		self:skinEditBox(ebName, {9})
		self:Unhook(CT_RAMenu_NewSetFrame, "OnShow")
	end)

	self:RawHookScript(CT_RAMenu_DeleteSetFrame, "OnShow", function()
		self.hooks[CT_RAMenu_DeleteSetFrame].OnShow()
		self:keepFontStrings(CT_RAMenu_DeleteSetFrame)
		self:applySkin(CT_RAMenu_DeleteSetFrame)
		self:Unhook(CT_RAMenu_DeleteSetFrame, "OnShow")
	end)

-->>--	SlashCmd Frame
	self:applySkin(CT_RA_SlashCmdFrame, true)
	self:keepFontStrings(CT_RA_SlashCmdFrameScrollFrame)
	self:skinScrollBar(CT_RA_SlashCmdFrameScrollFrame)
-->>--	Changelog Frame
	self:applySkin(CT_RA_ChangelogFrame)
	self:keepFontStrings(CT_RA_ChangelogFrameScrollFrame)
	self:skinScrollBar(CT_RA_ChangelogFrameScrollFrame)
-->>--	Target Frame
	self:applySkin(CT_RATargetFrame)
-->>--	Assist Frame
	self:applySkin(CT_RA_AssistFrame, true)
-->>--	Meters Frame
	self:applySkin(CT_RAMetersFrame)
	self:keepFontStrings(CT_RAMetersFrameDropDown)
-->>--	Res Frame
	self:applySkin(CT_RA_ResFrame)
-->>--	Ready Frame
	self:applySkin(CT_RA_ReadyFrame, true)
-->>--	Vote Frame
	self:applySkin(CT_RA_VoteFrame, true)
-->>--	Rly Frame
	self:applySkin(CT_RA_RlyFrame)
-->>--	Durability Check Frame
	self:applySkin(CT_RA_DurabilityFrame, true)
	self:keepFontStrings(CT_RA_DurabilityFrameScrollFrame)
	self:skinScrollBar(CT_RA_DurabilityFrameScrollFrame)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then CT_RATooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(CT_RATooltip)
	end

end
