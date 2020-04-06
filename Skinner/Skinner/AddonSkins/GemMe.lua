if not Skinner:isAddonEnabled("GemMe") then return end

function Skinner:GemMe()

	self:keepFontStrings(GemMe_Frame)
	GemMe_Frame:SetWidth(GemMe_Frame:GetWidth() * self.FxMult)
	GemMe_Frame:SetHeight(GemMe_Frame:GetHeight() * self.FyMult)
	self:moveObject(self:getRegion(GemMe_Frame, 6), nil, nil, "+", 8)
	self:moveObject(self:getChild(GemMe_Frame, 1), "+", 30, "+", 8)
	self:keepFontStrings(GemMe_Column)
	self:keepFontStrings(GemMe_Scroll)
	self:skinScrollBar(GemMe_Scroll)
	self:applySkin(GemMe_Frame)

end
