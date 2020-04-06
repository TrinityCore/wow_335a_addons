
function Skinner:BeastTraining()
	if not self.db.profile.CraftFrame then return end

	BeastTrainingFrame:SetWidth(BeastTrainingFrame:GetWidth() * self.FxMult)
	BeastTrainingFrame:SetHeight(BeastTrainingFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(BeastTrainingFrame)
	self:moveObject(BT_PetNameText, nil, nil, "-", 25)
	self:moveObject(BT_FrameCloseButton, "+", 28, "+", 8)
	self:moveObject(BT_Talent1, "-", 10, nil, nil)
	self:moveObject(BT_PetTrainingPointText, nil, nil, "-", 70)
	self:moveObject(BT_CloseButton, "-", 10, nil, nil)
	self:applySkin(BeastTrainingFrame)

end
