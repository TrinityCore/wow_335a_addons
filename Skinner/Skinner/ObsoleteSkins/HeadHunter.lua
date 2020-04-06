
function Skinner:HeadHunter()

	self:keepFontStrings(HeadHunterFrame)
	self:moveObject(HeadHunterCloseButton, "+", 10, "+", 8)
	for _, v in pairs(self.classTable) do
		if v == "DeathKnight" then v= "Deathknight" end
		self:skinEditBox(_G["InputNumber"..v], {9})
		self:skinEditBox(_G["InputRange1"..v], {9})
		self:skinEditBox(_G["InputRange2"..v], {9})
	end
	self:skinEditBox(InputNumberRandom, {9})
	self:skinEditBox(InputRange1Random, {9})
	self:skinEditBox(InputRange2Random, {9})
	self:skinEditBox(InputCriteria, {9})
	self:skinEditBox(InputSlogan, {9})
	self:applySkin(HeadHunterFrame)
	
-->>-- Blacklist Frame
	self:keepFontStrings(HeadHunterBlacklistFrame)
	self:removeRegions(HeadHunterBlacklistScrollBar)
	self:skinScrollBar(HeadHunterBlacklistScrollBar)
	self:skinEditBox(HeadHunterBlacklistInput, {9})
	self:applySkin(HeadHunterBlacklistFrame)

-->>-- Options Frame
	self:keepFontStrings(HeadHunterOptionsFrame)
	self:skinEditBox(InputNumberAskCount, {9})
	self:applySkin(HeadHunterOptionsFrame)
	
-->>-- HeadHunterOverviewFrame
	self:keepFontStrings(HeadHunterOverviewFrame)
	self:removeRegions(HeadHunterOverviewScrollBar)
	self:skinScrollBar(HeadHunterOverviewScrollBar)
	self:skinEditBox(HeadHunterOverviewInputSay, {9})
	self:applySkin(HeadHunterOverviewFrame)
	
end
