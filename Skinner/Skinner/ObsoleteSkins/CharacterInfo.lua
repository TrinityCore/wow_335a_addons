
function Skinner:CharacterInfo()

	self:keepRegions(CharacterInfoCharacterSelection, {4,5})
	self:moveObject(CharacterInfoFrameCloseButton, "-", 5, "-", 5)
	self:applySkin(CharacterInfoAttributesFrame)
	self:applySkin(CharacterInfoMeleeFrame)
	self:applySkin(CharacterInfoRangeFrame)
	self:applySkin(CharacterInfoFrame)
	self:applySkin(CharacterInfoBagsFrame)
	self:applySkin(CharacterInfoBankFrame)
	self:applySkin(CharacterInfoMailFrame)

end
