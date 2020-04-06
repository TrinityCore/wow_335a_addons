if not Skinner:isAddonEnabled("ProfessionsBook") then return end

function Skinner:ProfessionsBook()

	self:keepFontStrings(ProfessionsBook_Frame)
	ProfessionsBook_Frame:SetWidth(ProfessionsBook_Frame:GetWidth() - 120)
	ProfessionsBook_Frame:SetHeight(ProfessionsBook_Frame:GetHeight() - 70)
	self:moveObject(ProfessionsBook_FrameTitle, nil, nil, "+", 8)
	self:moveObject(ProfessionsBook_XCloseButton, "+", 126, "+", 8)
	self:moveObject(ProfessionsBook_OpenSearchButton, "+", 60, "-", 30)
	local xOfs, yOfs = 120, 20
	self:moveObject(ProfessionsBook_CharacterDropDownMenu, "+", xOfs, "+", yOfs)
	self:moveObject(ProfessionsBook_PlacesDropDownMenu, "+", xOfs, "+", yOfs)
	self:moveObject(ProfessionsBook_TradeTypeDropDownMenu, "+", xOfs, "+", yOfs)
	self:moveObject(ProfessionsBook_TradeItemListScrollFrame, "+", xOfs, "+", yOfs)
	yOfs = 70
	self:moveObject(ProfessionsBook_ChannelsDropDownMenu, "+", xOfs, "-", yOfs)
	self:moveObject(ProfessionsBook_SendButton, "+", xOfs, "-", yOfs)
	self:moveObject(ProfessionsBook_OptionsButton, "+", xOfs, "-", yOfs)
	self:moveObject(ProfessionsBook_CloseButton, "+", xOfs, "-", yOfs)
	self:moveObject(ProfessionsBook_DetailScrollFrame, nil, nil, "-", 30)
	for i = 1, 6 do
		local tsb = _G["ProfessionsBook_TradeSkillButton"..i]
		self:keepRegions(tsb, {3, 4})
		self:applySkin(tsb)
	end
	self:keepFontStrings(ProfessionsBook_CharacterDropDownMenu)
	self:keepFontStrings(ProfessionsBook_ChannelsDropDownMenu)
	self:keepFontStrings(ProfessionsBook_PlacesDropDownMenu)
	self:keepFontStrings(ProfessionsBook_TradeTypeDropDownMenu)
	self:keepFontStrings(ProfessionsBook_DetailScrollFrame)
	self:skinScrollBar(ProfessionsBook_DetailScrollFrame)
	self:keepFontStrings(ProfessionsBook_TradeItemExpandButtonFrame)
	self:keepFontStrings(ProfessionsBook_TradeItemListScrollFrame)
	self:skinScrollBar(ProfessionsBook_TradeItemListScrollFrame)
	self:applySkin(ProfessionsBook_Frame)

-->>--	Search Frame
	self:SecureHook(ProfessionsBook, "HideSearchFrame", function()
		ProfessionsBook_Frame.sf:Hide()
	end)
	self:SecureHook(ProfessionsBook, "ShowSearchFrame", function()
		ProfessionsBook_Frame.sf:Show()
	end)
	ProfessionsBook_Frame.sf = CreateFrame("Frame", nil, ProfessionsBook_Frame)
	ProfessionsBook_Frame.sf:SetPoint("TOPLEFT", ProfessionsBook_Frame, "TOPRIGHT", -10, -60)
	ProfessionsBook_Frame.sf:SetWidth(320)
	ProfessionsBook_Frame.sf:SetHeight(360)
	self:applySkin(ProfessionsBook_Frame.sf)
	self:skinEditBox(ProfessionsBook_SearchBox, {})
	self:moveObject(ProfessionsBook_SearchButton, "+", 10, nil, nil)
	self:keepFontStrings(ProfessionsBook_SearchResultScrollFrame)
	self:skinScrollBar(ProfessionsBook_SearchResultScrollFrame)

-->>--	Options Frame
	self:applySkin(ProfessionsBook_OptionsDialog)

end
