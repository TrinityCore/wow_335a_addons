if not Skinner:isAddonEnabled("GupCharacter") then return end

function Skinner:GupCharacter()

	self:skinFFToggleTabs("GupCharacter_PetPaperDollFrameTab")
	self:skinButton{obj=GupCharacter_CharacterFrameCloseButton, cb=true}
	self:keepFontStrings(GupCharacter_PaperDollFrame)
	self:keepFontStrings(GupCharacter_CharacterAttributesFrame)
	self:skinDropDown{obj=GupCharacter_PlayerStatFrameDropDown1}
	self:skinDropDown{obj=GupCharacter_PlayerStatFrameDropDown2}
	self:skinDropDown{obj=GupCharacter_PlayerStatFrameDropDown3}
	self:keepFontStrings(GupCharacter_PetPaperDollFrame)
	self:skinScrollBar{obj=GC_PetPaperDollFrameDataContainer}
	self:addSkinFrame{obj=GC_PetPaperDollFrameData, x1=-2, y1=2, x2=2, y2=-2}
	self:keepFontStrings(GupCharacter_ReputationFrame)
	self:keepFontStrings(GupCharacter_SkillFrame)
	self:keepFontStrings(GupCharacter_TokenFrame)

end
