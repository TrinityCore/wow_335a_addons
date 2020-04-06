
function Skinner:TuringTest()

	TT_ConfigFrame:SetWidth(TT_ConfigFrame:GetWidth() * self.FxMult)
	TT_ConfigFrame:SetHeight(TT_ConfigFrame:GetHeight() * self.FyMult - 30)
	self:keepFontStrings(TT_ConfigFrame)
	self:moveObject(TT_ConfigFrame_btnClose, "+", 30, "+", 8)
	self:moveObject(TT_ConfigFrame_btnListLeechers, nil, nil, "-", 20)
	self:applySkin(TT_ConfigFrame)

end
