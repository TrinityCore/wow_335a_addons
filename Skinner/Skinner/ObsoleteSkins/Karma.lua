
function Skinner:Karma()

	self:keepFontStrings(KarmaWindow)
	self:moveObject(KarmaWindow_Title, nil, nil, "-", 6)
	self:moveObject(KarmaWindowCloseButton, "-", 4, "-", 4)
	self:moveObject(KarmaWindow_KarmaSlider, nil, nil, "-", 6)
	KarmaWindow_KarmaSlider:SetHeight(KarmaWindow_KarmaSlider:GetHeight() + 6)
	self:glazeStatusBar(KarmaWindow_KarmaIndicator, 0)
	KarmaWindow_KarmaIndicator:SetWidth(KarmaWindow_KarmaIndicator:GetWidth() + 15)
	KarmaWindow_KarmaIndicator:SetHeight(KarmaWindow_KarmaIndicator:GetHeight() + 1)
	self:moveObject(KarmaWindow_KarmaIndicator, "-", 6, "-", 4)
	self:keepFontStrings(KarmaWindow_MemberList_ScrollFrame)
	self:skinScrollBar(KarmaWindow_MemberList_ScrollFrame)
	self:keepFontStrings(KarmaWindow_Notes_ScrollFrame)
	self:skinScrollBar(KarmaWindow_Notes_ScrollFrame)
	self:moveObject(KarmaWindow_KarmaQuestList, nil, nil, "-", 6)
	self:keepFontStrings(KarmaWindow_QuestList_ScrollFrame)
	self:skinScrollBar(KarmaWindow_QuestList_ScrollFrame)
	self:keepFontStrings(KarmaWindow_ZoneList_ScrollFrame)
	self:skinScrollBar(KarmaWindow_ZoneList_ScrollFrame)
	self:skinEditBox(KarmaWindow_Filter_EditBox)
	self:applySkin(KarmaWindow)

-->>--	Karma Options
	self:keepFontStrings(KarmaOptionsWindow)
	self:keepFontStrings(KarmaOptionsWindow_SortType_DropDown)
	self:keepFontStrings(KarmaOptionsWindow_ColorType_DropDown)
	self:skinEditBox(KarmaOptionWindow_AutoIgnoreThreshold)
	self:moveObject(KarmaOptionWindow_AutoIgnoreThreshold, "-", 12, "+", 4)
	KarmaOptionsWindow_Other:SetHeight(KarmaOptionsWindow_Other:GetHeight() + 15)
	self:applySkin(KarmaOptionsWindow)

-->>--	Minimap Menu
	self:applySkin(Karma_Minimap_Menu)

-->>--	Tooltip
	self:applySkin(Karma_Tooltip)

end
