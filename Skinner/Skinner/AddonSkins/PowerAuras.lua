if not Skinner:isAddonEnabled("PowerAuras") then return end

function Skinner:PowerAuras()

	self:keepFontStrings(PowaOptionsFrame)
	self:moveObject(PowaOptionsHeader, nil, nil, "-", 5)
	self:moveObject(PowaOptionsFrameCloseButton, "+", 6, "+", 6)
	self:applySkin(PowaOptionsPlayerListFrame, nil, nil, nil, 50)
	self:applySkin(PowaOptionsGlobalListFrame, nil, nil, nil, 50)
	self:applySkin(PowaOptionsSelectorFrame, nil, nil, nil, 20)
	self:skinEditBox(PowaOptionsRenameEditBox, {9})
	self:applySkin(PowaOptionsFrame)
-->>-- Config Frame
	self:keepFontStrings(PowaBarConfigFrame)
	self:moveObject(PowaHeader, nil, nil, "-", 4)
	self:moveObject(PowaCloseButton, "+", 6, "+", 6)
	self:applySkin(PowaBarConfigFrame)
	-- top Panel
	self:skinEditBox(PowaBarAuraCoordXEdit, {9})
	self:skinEditBox(PowaBarAuraCoordYEdit, {9})
	self:applySkin(PowaBarConfigFrameEditor)
	-- Activation Panel
	self:skinDropDown(PowaDropDownBuffType)
	self:skinEditBox(PowaBarBuffStacks, {9})
	self:moveObject(PowaBarBuffStacks, "-", 5, "-", 2)
	self:skinEditBox(PowaBarBuffName, {9, 10})
	self:moveObject(PowaExactButton, nil, nil, "+", 8)
	self:skinEditBox(PowaBarMultiID, {9, 10})
	self:moveObject(PowaBarMultiID, nil, nil, "+", 8)
	self:applySkin(PowaBarConfigFrameEditor2)
	-- Animation Panel
	self:skinDropDown(PowaDropDownAnimBegin)
	self:skinDropDown(PowaDropDownAnimEnd)
	self:skinDropDown(PowaDropDownAnim1)
	self:skinDropDown(PowaDropDownAnim2)
	self:applySkin(PowaBarConfigFrameEditor3)
	-- Sound Panel
	self:skinDropDown(PowaDropDownSound)
	self:skinEditBox(PowaBarCustomSound, {9, 10})
	self:applySkin(PowaBarConfigFrameEditor5)
	-- Timer Panel
	self:applySkin(PowaBarConfigFrameEditor4)
	
end
