if not Skinner:isAddonEnabled("ItemSync") then return end

function Skinner:ItemSync()

	for i = 1, 6 do
		self:removeRegions(_G["ISync_Tab"..i], {1})
--		self:moveObject(_G["ISync_Tab"..i], "+", 15, nil, nil)
		self:applySkin(_G["ISync_Tab"..i])
	end

	self:keepFontStrings(ISync_MainFrame_DropDown)
	ISync_MainFrame_DropDown:SetBackdrop(nil)
	self:keepFontStrings(ISync_MainFrame_ListScrollFrame)
	self:skinScrollBar(ISync_MainFrame_ListScrollFrame)
	self:applySkin(ISync_MainFrameHeader_Box)
	self:applySkin(ISync_MainFrame)
	self:skinEditBox(ISyncMainFrame_QuickSearch, {9})
	self:applySkin(ISyncMainFrame_QuickSearchBox)

-->>--	Help Frame
	self:applySkin(ISync_HelpFrameHeader_Box)
	self:keepFontStrings(ISync_HelpFrameDescFrameScrollFrame)
	self:skinScrollBar(ISync_HelpFrameDescFrameScrollFrame)
	self:applySkin(ISync_HelpFrame)

-->>--	Search Frame
	self:applySkin(ISync_SearchFrameHeader_Box)
	self:keepFontStrings(ISync_DD_Location)
	ISync_DD_Location:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Rarity)
	ISync_DD_Rarity:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Weapon)
	ISync_DD_Weapon:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Level)
	ISync_DD_Level:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Tradeskill)
	ISync_DD_Tradeskill:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Armor)
	ISync_DD_Armor:SetBackdrop(nil)
	self:keepFontStrings(ISync_DD_Shield)
	ISync_DD_Shield:SetBackdrop(nil)
	self:applySkin(ISync_SearchFrame_NameBox)
	self:skinEditBox(ISync_SearchFrameName_Search, {9})
	self:applySkin(ISync_SearchFrame)

-->>--	Options Frame
	self:applySkin(ISync_OptionsFrameHeader_Box)
	self:applySkin(ISync_Opt_ShowMoney)
	self:applySkin(ISync_Opt_External)
	self:applySkin(ISync_Opt_Database)
	self:applySkin(ISync_Opt_Additional)
	self:applySkin(ISync_OptionsFrame)

-->>--	Filters Frame
	self:applySkin(ISync_FiltersFrameHeader_Box)
	self:applySkin(ISync_Filters_Rarity)
	self:applySkin(ISync_Filters_InvalidPurge)
	self:applySkin(ISync_Filters_RarityPurge)
	self:keepFontStrings(ISync_Filters_Rarity_DropDown)
	ISync_Filters_Rarity_DropDown:SetBackdrop(nil)
	self:applySkin(ISync_FiltersFrame)

-->>--	Favourites Frame
	self:applySkin(ISync_FavoritesHeader_Box)
	self:keepFontStrings(ISync_Favorites_DropDown)
	ISync_Favorites_DropDown:SetBackdrop(nil)
	self:keepFontStrings(ISync_Favorites_ListScrollFrame)
	self:skinScrollBar(ISync_Favorites_ListScrollFrame)
	self:applySkin(ISync_Favorites)

-->>--	ItemID Frame
	self:applySkin(ISync_ItemIDFrameHeader_Box)
	self:skinEditBox(ISync_ItemIDFrameEdit, {9})
	self:applySkin(ISync_ItemIDFrame)

-->>--	QuickBag Frame
	self:applySkin(ISync_QuickBagFrame_HeaderBox)
	self:keepFontStrings(ISync_QuickBag_ScrollFrame)
	self:skinScrollBar(ISync_QuickBag_ScrollFrame)
	self:applySkin(ISync_QuickBagFrame)

-->>--	Dialog Frame
	self:applySkin(ISync_Dialog)

-->>--	Count Frame
	self:applySkin(ItemSync_CountFrame)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ISyncTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(ISyncTooltip)
	end

end
