if not Skinner:isAddonEnabled("EnchantMe") then return end

function Skinner:EnchantMe()

	self:keepFontStrings(EnchantMe_Frame)
	EnchantMe_Frame:SetWidth(EnchantMe_Frame:GetWidth() * self.FxMult)
	EnchantMe_Frame:SetHeight(EnchantMe_Frame:GetHeight() * self.FyMult)
	self:moveObject(self:getRegion(EnchantMe_Frame, 6), nil, nil, "+", 8)
	self:moveObject(self:getChild(EnchantMe_Frame, 1), "+", 30, "+", 8)
	self:keepFontStrings(EnchantMe_Column)
	self:keepFontStrings(EnchantMe_Scroll)
	self:skinScrollBar(EnchantMe_Scroll)
	self:applySkin(EnchantMe_Frame)

end
