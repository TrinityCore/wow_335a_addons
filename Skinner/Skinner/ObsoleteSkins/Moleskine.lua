
function Skinner:Moleskine()

	MoleskineFrame:SetWidth(MoleskineFrame:GetWidth() * self.FxMult)
	MoleskineFrame:SetHeight(MoleskineFrame:GetHeight() * self.FyMult)
	self:moveObject(MoleskineFrameTitle, nil, nil, "-", 30)
	self:moveObject(MoleskineFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(MoleskineMailButton, "-", 20, "+", 10)
	self:moveObject(MoleskineFrameNoteEditBox, "-", 15, "+", 20)
	MoleskineFrameNoteEditBox:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:moveObject(MoleskinePrevNoteButton, "-", 10, "-", 80)
	self:moveObject(MoleskinePageNumberText, "-", 10, "-", 80)
	self:moveObject(MoleskineNextNoteButton, "-", 10, "-", 80)
	self:keepRegions(MoleskineFrame, {6,7})
	self:applySkin(MoleskineFrame, nil)

end
