
function Skinner:Sanity2()

-->>--	Sanity Frame
	self:applySkin(SanityCategoriesFrame)
	self:applySkin(SanityBindFrame)
	self:applySkin(SanityTabsFrame)
	self:skinScrollBar(SanityDisplayFrameScrollFrame)
	self:applySkin(SanityDisplayFrame)
	self:applySkin(SanitySortFrame)
	self:keepRegions(SanityTitleFrame, {10, 11})
	self:applySkin(SanityTitleFrame)
	self:applySkin(SanityStatusBar)
	self:applySkin(SanityFrame)
-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then Sanity_ItemTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(Sanity_ItemTooltip)
	end

end
