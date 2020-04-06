
function Skinner:NotesUNeed()

-->>--	Micro Frame
	self:applySkin(NuNMicroFrame)
	NuNMicroFrame:SetHeight(NuNMicroFrame:GetHeight() + 3)

-->>--	NuN Options Frame
	self:keepFontStrings(NuNOptionsFrame)
	self:moveObject(NuNOptionsHeader, nil, nil, "-", 6)
	self:moveObject(NuNOptionsGuildCheckBoxLabel, "+", 4, nil, nil)
	self:moveObject(NuNOptionsAACheckBoxLabel, "+", 4, nil, nil)
	self:moveObject(NuNOptionsDeleteCheckBoxLabel, "+", 4, nil, nil)
	self:moveObject(NuNOptionsAddCheckBoxLabel, "+", 4, nil, nil)
	self:keepFontStrings(NuNOptionsSearchDropDown)
	self:skinEditBox(NuNOptionsTTLengthTextBox)
	self:moveObject(NuNOptionsTTLengthTextBox, nil, nil, "-", 14)
	self:skinEditBox(NuNOptionsTTLineLengthTextBox)
	self:moveObject(NuNOptionsTTLineLengthTextBox, nil, nil, "-", 14)
	self:applySkin(NuNOptionsFrame)

-->>--	Scale Frame
	self:applySkin(NuN_ScaleFrame)

-->>--	Search Frame
	self:keepFontStrings(NuNSearchFrame)
	NuNSearchFrame:SetWidth(NuNSearchFrame:GetWidth() * self.FxMult + 3)
	NuNSearchFrame:SetHeight(NuNSearchFrame:GetHeight() * self.FyMult)
	self:moveObject(NuNSearchTitleText, nil, nil, "+", 10)
	self:moveObject(NuNSearchFrameCloseButton, "+", 28, "+", 8)
	self:keepFontStrings(NuNSearchClassDropDown)
	self:moveObject(NuNSearchClassDropDown, "-", 3, "-", 6)
	self:keepFontStrings(NuNSearchProfDropDown)
	self:moveObject(NuNSearchProfDropDown, "-", 3, "-", 6)
	self:skinEditBox(NuNSearchTextBox)
	self:moveObject(NuNSearchTextBox, nil, nil, "-", 6)
	self:moveObject(NuNSearchFrameSearchButton, "+", 30, "+", 8)
	self:moveObject(NuNSearchFrameBackButton, "+", 30, "+", 4)
	self:keepFontStrings(NuNSearchListScrollFrame)
	self:skinScrollBar(NuNSearchListScrollFrame)
	self:moveObject(NuNSearchListScrollFrame, nil, nil, "+", 4)
	self:applySkin(NuNSearchFrame)
	self:applySkin(NuNExtraOptions)
	self:moveObject(NuNExtraOptions, "-", 5, nil, nil)

-->>--	Contact Frame
	self:keepFontStrings(NuNFrame)
	NuNFrame:SetWidth(NuNFrame:GetWidth() * self.FxMult + 20)
	self:moveObject(NuNHeader, nil, nil, "-", 6)
	self:moveObject(NuNFrameCloseButton, "+", 40, nil, nil)
	self:moveObject(NuNCOpenChatButton, "+", 40, nil, nil)
	self:keepFontStrings(NuNARaceDropDown)
	self:keepFontStrings(NuNHRaceDropDown)
	self:keepFontStrings(NuNAClassDropDown)
	self:keepFontStrings(NuNHClassDropDown)
	self:keepFontStrings(NuNSexDropDown)
	self:keepFontStrings(NuNPRatingDropDown)
	self:keepFontStrings(NuNProf1DropDown)
	self:keepFontStrings(NuNProf2DropDown)
	self:keepFontStrings(NuNACRankDropDown)
	self:keepFontStrings(NuNHCRankDropDown)
	self:keepFontStrings(NuNAHRankDropDown)
	self:keepFontStrings(NuNHHRankDropDown)
	NuNDivider:Hide()
	self:keepFontStrings(NuNScrollFrame)
	self:skinScrollBar(NuNScrollFrame)
	self:moveObject(NuNScrollFrame, nil, nil, "-", 10)
	self:moveObject(NuNButtonSaveNote, "+", 40, "-", 12)
	self:moveObject(NuNButtonTarget, nil, nil, "-", 12)
	self:moveObject(NuNDropDownFrame, "+", 40, "-", 6)
	self:applySkin(NuNDropDownFrame)
	self:applySkin(NuNFrame)

-->>--	Edit Detail Frame
	self:keepFontStrings(NuNEditDetailsFrame)
	self:moveObject(NuNEditDetailsHeader, nil, nil, "-", 6)
	self:skinEditBox(NuNEditDetailsBox)
	self:applySkin(NuNEditDetailsFrame)

-->>--	Chat Frame
	self:keepFontStrings(NuN_ChatFrame)
	self:moveObject(NuNChatHeader, nil, nil, "-", 6)
	self:keepFontStrings(NuNChatDropDown)
	self:applySkin(NuN_ChatFrame)

-->>--	Delete Frame
	self:keepFontStrings(NuNcDeleteFrame)
	self:moveObject(NuNcDeleteHeader, nil, nil, "-", 6)
	self:applySkin(NuNcDeleteFrame)

-->>--	Note Frame
	self:keepFontStrings(NuNGNoteFrame)
	NuNGNoteFrame:SetWidth(NuNGNoteFrame:GetWidth() * self.FxMult + 20)
	self:moveObject(NuNGNoteHeader, nil, nil, "-", 6)
	self:moveObject(NuNGNoteFrameCloseButton, "+", 40, nil, nil)
	self:moveObject(NuNGNoteFrameRunButton, "+", 40, nil, nil)
	self:moveObject(NuNGOpenChatButton, "+", 38, nil, nil)
	self:moveObject(NuNNPCTargetButton, nil, nil, "-", 12)
	self:keepFontStrings(NuNGTypeDropDown)
	self:moveObject(NuNGTypeDropDown, nil, nil, "-", 14)
	self:skinEditBox(NuNGNoteTextBox)
	NuNGNoteDivider:Hide()
	self:keepFontStrings(NuNGNoteScrollFrame)
	self:skinScrollBar(NuNGNoteScrollFrame)
	self:moveObject(NuNGNoteButtonSaveNote, "+", 40, "-", 12)
	self:applySkin(NuNGNoteFrame)

-->>--	Confirm Frame
	self:keepFontStrings(NuN_ConfirmFrame)
	self:moveObject(NuNConfirmHeader, nil, nil, "-", 6)
	self:applySkin(NuN_ConfirmFrame)

-->>--	Friends Frame Button
	self:moveObject(NuN_FFButton, "-", 50, nil, nil)

-->>--	Quest Notes Buttons
	self:moveObject(NuN_QuestNotesButton1, "+", 80, nil, nil)
	self:moveObject(NuN_QuestNotesButton2, "+", 80, nil, nil)
	self:moveObject(NuN_QuestNotesButton3, "+", 80, nil, nil)
	self:moveObject(NuN_QuestNotesButton4, "+", 80, nil, nil)
	self:moveObject(NuN_QuestNotesButton5, "+", 80, nil, nil)
	self:moveObject(NuN_QuestNotesButton6, "+", 80, nil, nil)

-->>--	Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			NuN_Tooltip:SetBackdrop(self.backdrop)
			NuN_PinnedTooltip:SetBackdrop(self.backdrop)
			NuN_MapTooltip:SetBackdrop(self.backdrop)
			NuNPopup:SetBackdrop(self.backdrop)
		end
		self:skinTooltip(NuN_Tooltip)
		self:RawHookScript(NuN_Tooltip, "OnLoad", function()
			this.fadeStartTime = 0.0
			this.fadeHoldTime = 1.0
			this.fadeOutTime = 1.0
			end)
		self:skinTooltip(NuN_PinnedTooltip)
		self:skinTooltip(NuN_MapTooltip)
		self:RawHookScript(NuN_MapTooltip, "OnLoad", function() end)
		self:skinTooltip(NuNPopup)
	end

end
