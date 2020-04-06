if not Skinner:isAddonEnabled("sienasGemViewer") then return end

function Skinner:sienasGemViewer()
	if not self.db.profile.AuctionUI then return end

	self:keepFontStrings(SGV_BrowseDropDown)
	self:keepFontStrings(SGV_Filter)
	self:removeRegions(SGV_GemScrollFrame)
	self:skinScrollBar(SGV_GemScrollFrame)

end
