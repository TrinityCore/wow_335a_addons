if not Skinner:isAddonEnabled("HeadCount") then return end

function Skinner:HeadCount()

-->-- Main frame
	self:moveObject{obj=HeadCountFrameTitleHeaderString, y=-10}
	self:skinButton{obj=HeadCountFrameTitleCloseButton, cb=true, x1=3, y1=-3, x2=-3, y2=3}
	self:keepFontStrings(HeadCountFrameTitleHeader)
	self:addSkinFrame{obj=HeadCountFrame, kfs=true}
-->>-- Raid History panel
	self:skinScrollBar{obj=HeadCountFrameRaidHistoryContentScroll}
	self:addSkinFrame{obj=HeadCountFrameRaidHistory, kfs=true}
-->>-- Content panel
	self:skinScrollBar{obj=HeadCountFrameContentMembersScroll}
	self:skinScrollBar{obj=HeadCountFrameContentWaitListScroll}
	self:skinScrollBar{obj=HeadCountFrameContentBossScroll}
	self:skinScrollBar{obj=HeadCountFrameContentLootScroll}
	self:skinScrollBar{obj=HeadCountFrameContentSnapshotScroll}
	self:skinScrollBar{obj=HeadCountFrameContentPlayerScroll}
	self:addSkinFrame{obj=HeadCountFrameContent, kfs=true}
-->>-- Confirm frame	
	self:skinButton{obj=HeadCountFrameConfirmConfirmButton}
	self:skinButton{obj=HeadCountFrameConfirmCancelButton}
	self:addSkinFrame{obj=HeadCountFrameConfirm, kfs=true}
-->>-- Export frame
	self:skinScrollBar{obj=HeadCountFrameExportScroll}
	self:skinButton{obj=HeadCountFrameExportRefreshButton}
	self:skinButton{obj=HeadCountFrameExportCloseButton}
	self:addSkinFrame{obj=HeadCountFrameExport, kfs=true}
-->>-- Loot Management frame
	self:skinEditBox{obj=HeadCountFrameLootManagementLooterEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementSourceEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementCostEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementNoteEditBox, move=true}
	self:skinButton{obj=HeadCountFrameLootManagementSaveButton}
	self:skinButton{obj=HeadCountFrameLootManagementCancelButton}
	self:addSkinFrame{obj=HeadCountFrameLootManagement, hdr=true}
-->>-- Loot Management popup
	self:skinEditBox{obj=HeadCountFrameLootManagementPopupLooterEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementPopupSourceEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementPopupCostEditBox, move=true}
	self:skinEditBox{obj=HeadCountFrameLootManagementPopupNoteEditBox, move=true}
	self:skinButton{obj=HeadCountFrameLootManagementPopupSaveButton}
	self:skinButton{obj=HeadCountFrameLootManagementPopupCancelButton}
	self:addSkinFrame{obj=HeadCountFrameLootManagementPopup, hdr=true}
-->>-- Announcement frame
	self:adjHeight{obj=HeadCountFrameAnnouncementTypeEditBoxButton, adj=4}
	self:moveObject{obj=HeadCountFrameAnnouncementTypeEditBoxButton, y=2}
	self:skinUsingBD{obj=HeadCountFrameAnnouncementTypeEditBoxButton} -- not really an EditBox
	self:adjHeight{obj=HeadCountFrameAnnouncementChannelEditBoxButton, adj=4}
	self:moveObject{obj=HeadCountFrameAnnouncementChannelEditBoxButton, y=2}
	self:skinUsingBD{obj=HeadCountFrameAnnouncementChannelEditBoxButton} -- not really an EditBox
	self:skinButton{obj=HeadCountFrameAnnouncementAnnounceButton}
	self:skinButton{obj=HeadCountFrameAnnouncementCancelButton}
	self:addSkinFrame{obj=HeadCountFrameAnnouncement}

end
