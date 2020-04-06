if not Skinner:isAddonEnabled("Ludwig") then return end

function Skinner:Ludwig()

	self:keepFontStrings(LudwigFrame)
	LudwigFrame:SetWidth(LudwigFrame:GetWidth() * self.FxMult + 20)
	LudwigFrame:SetHeight(LudwigFrame:GetHeight() * self.FyMult)
	self:moveObject(LudwigFrameCloseButton, "+", 28, "+", 8)
	self:skinEditBox(LudwigFrameSearch, {9})
	self:skinEditBox(LudwigFrameMinLevel, {9})
	self:skinEditBox(LudwigFrameMaxLevel, {9})
	self:keepFontStrings(LudwigFrameScroll)
	self:skinScrollBar(LudwigFrameScroll)
	self:keepFontStrings(LudwigFrameQuality)
	self:moveObject(LudwigFrameQuality, nil, nil, "-", 70)
	self:keepFontStrings(LudwigFrameType)
	self:moveObject(LudwigFrameType, nil, nil, "-", 70)
	self:applySkin(LudwigFrame)

end
