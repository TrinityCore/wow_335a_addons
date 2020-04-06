
function Skinner:InsultDevice()

	InsultDevice:SetWidth(InsultDevice:GetWidth() * self.FxMult)
	InsultDevice:SetHeight(InsultDevice:GetHeight() * self.FyMult)
	self:keepFontStrings(InsultDevice)
	for _, v in pairs{ InsultDevice:GetChildren() } do
		self:moveObject(v, "-", 5, "+", 6)
	end
	self:applySkin(InsultDevice)

end
