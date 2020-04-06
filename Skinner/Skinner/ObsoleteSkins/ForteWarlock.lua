
function Skinner:ForteWarlock()

-->>--	Main Frame
	FWOptionsHeader:SetBackdrop(nil)
	self:keepFontStrings(FWOptionsFrame)
	self:skinScrollBar(FWOptionsFrame)
	self:applySkin(FWOptions)
-->>--	Sub Frames
	for i, data in ipairs(FW_Options) do
		_G["FWOptions"..i.."Header"]:SetBackdrop(nil)
		self:applySkin(_G["FWOptions"..i])
	end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then FWScanningTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(FWScanningTooltip)
	end

end
