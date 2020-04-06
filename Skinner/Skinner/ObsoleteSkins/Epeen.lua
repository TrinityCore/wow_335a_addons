
function Skinner:Epeen()

-->>--	Last Seen Frame
	self:keepRegions(LastSeenFrame, {7})
	LastSeenFrame:SetWidth(LastSeenFrame:GetWidth() * self.FxMult)
	LastSeenFrame:SetHeight(LastSeenFrame:GetHeight() * self.FyMult)
	self:moveObject(LastSeenFrame_CloseButton, "+", 77, "+", 8)
	self:keepRegions(LastSeenFrame_FactionDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LastSeenFrame_DropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(LastSeenFrame_ListDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(LastSeenFrame_Item1, nil, nil, "+", 5)
	self:removeRegions(LastSeenFrame_ScrollFrame)
	self:skinScrollBar(LastSeenFrame_ScrollFrame)
	self:moveObject(LastSeenFrame_ScrollFrame, "+", 65, "+", 5)
	self:applySkin(LastSeenFrame)

-->>--	Stats Frame
	self:keepRegions(EpeenStatsFrame_DateDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(EpeenStatsFrame_TypeDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:applySkin(EpeenStatsFrame)

-->>--	Popup Frame
	self:skinEditBox(Epeen_Popup_Name)
	self:skinEditBox(Epeen_Popup_Reason)
	Epeen_Popup_FrameHeader:Hide()
	self:moveObject(EpeenLabelText, nil, nil, "-", 9)
	self:applySkin(Epeen_Popup)

end
