if not Skinner:isAddonEnabled("MobMap") then return end

function Skinner:MobMap()

	self:applySkin(MobMapFrame)
	self:applySkin(MobMapExportFrame)
	self:applySkin(MobMapErrorMessageFrame)

-->>--	Tooltips
	if not self.db.profile.Tooltips.skin then return end
	if self.db.profile.Tooltips.style == 3 then
		MobMapTooltip:SetBackdrop(self.backdrop)
		MobMapScanTooltip:SetBackdrop(self.backdrop)
	end
	self:skinTooltip(MobMapTooltip)
	self:skinTooltip(MobMapScanTooltip)


end

function Skinner:MobMapDatabaseStub1()

-->>--	Positions Frame
	self:keepFontStrings(MobMapMobSearchFrameZoneListScrollFrame)
	self:skinScrollBar(MobMapMobSearchFrameZoneListScrollFrame)
	self:skinEditBox(MobMapMobSearchFrameSearchBox, {9})
	self:skinEditBox(MobMapMobSearchFrameSubtitleSearchBox, {9})

end

function Skinner:MobMapDatabaseStub2()

-->>--	Quests Detail Frame
	self:skinEditBox(MobMapQuestListNameFilter, {9})
	self:skinEditBox(MobMapQuestListNPCFilter, {9})
	self:skinEditBox(MobMapQuestListZoneFilter)
	self:keepFontStrings(MobMapQuestListTypeFilter)
	self:skinEditBox(MobMapQuestListMinLevelFilter, {9})
	self:skinEditBox(MobMapQuestListMaxLevelFilter, {9})
	self:skinMoneyFrame(MobMapQuestListMoneyFilter)
	self:keepFontStrings(MobMapQuestListScrollFrame)
	self:skinScrollBar(MobMapQuestListScrollFrame)
	self:applySkin(MobMapQuestDetailFrame)
	MobMapQuestDetailFrameBackground:Hide()
-->>--	Quests Comment Frame
	MobMapQuestCommentFrameBackground:Hide()
	self:applySkin(MobMapQuestCommentFrame)
-->>--	Quests Comment Editor Frame
	MobMapQuestCommentEditorFrameBackground:Hide()
	self:applySkin(MobMapQuestCommentEditorFrame)

end

function Skinner:MobMapDatabaseStub3()

-->>--	Merchants Frame
	self:skinEditBox(MobMapMerchantListNameFilter, {9})
	self:skinEditBox(MobMapMerchantListSubtitleFilter, {9})
	self:skinEditBox(MobMapMerchantListZoneFilter)
	self:keepFontStrings(MobMapMerchantListScrollFrame)
	self:skinScrollBar(MobMapMerchantListScrollFrame)

end

function Skinner:MobMapDatabaseStub4()

-->>--	Recipes Frame
	self:keepFontStrings(MobMapRecipeListProfessionFilter)
	self:skinEditBox(MobMapRecipeListNameFilter, {9})
	self:keepFontStrings(MobMapRecipeListScrollFrame)
	self:skinScrollBar(MobMapRecipeListScrollFrame)

end

function Skinner:MobMapDatabaseStub5()

-->>--	ItemName Frame
	self:keepFontStrings(MobMapItemNameSelectionFrame)
	self:skinEditBox(MobMapItemNameSelectionFrameNameFilter)
	self:keepFontStrings(MobMapItemNameSelectionFrameScrollFrame)
	self:skinScrollBar(MobMapItemNameSelectionFrameScrollFrame)
	self:applySkin(MobMapItemNameSelectionFrame)

end

function Skinner:MobMapDatabaseStub7()

-->>--	Drop Chances Frame
	self:skinEditBox(MobMapDropListItemNameFilter, {9})
	self:keepFontStrings(MobMapDropListItemScrollFrame)
	self:skinScrollBar(MobMapDropListItemScrollFrame)

end

function Skinner:MobMapDatabaseStub8()

-->>--	Pickups Frame
	self:keepFontStrings(MobMapPickupListTypeFilter)
	self:skinEditBox(MobMapPickupListNameFilter, {9})
	self:keepFontStrings(MobMapPickupItemListScrollFrame)
	self:skinScrollBar(MobMapPickupItemListScrollFrame)

end
