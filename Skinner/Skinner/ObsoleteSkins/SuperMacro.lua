
function Skinner:SuperMacro()

	if not self:isVersion("SuperMacro", {"3.16", "3.16a", "3.16b", "3.16c", "3.16d", "4.03"}, SUPERMACRO_VERSION) then return end

	if self.db.profile.TexturedTab then
		self:SecureHook("SuperMacroFrame_Update" , function()
			if SM_VARS.tabShown == "regular" then
				self:setActiveTab(SuperMacroFrameTab1)
				self:setInactiveTab(SuperMacroFrameTab2)
			else
				self:setActiveTab(SuperMacroFrameTab2)
				self:setInactiveTab(SuperMacroFrameTab1)
			end
		end)
	end

	self:keepRegions(SuperMacroFrame, {8, 12, 13, 14}) -- N.B. regions 8, 12-14 are text
	SuperMacroFrame:SetWidth(SuperMacroFrame:GetWidth() - 30)
	SuperMacroFrame:SetHeight(SuperMacroFrame:GetHeight() - 70)
	self:moveObject(SuperMacroFrameTitle, nil, nil, "+", 12)
	self:moveObject(SuperMacroDeleteButton, "-", 5, "-", 70)
	self:moveObject(SuperMacroSaveButton, "-", 5, "-", 70)
	self:moveObject(SuperMacroSaveExtendButton, "+", 25, nil, nil)
	self:moveObject(SuperMacroDeleteExtendButton, "+", 25, nil, nil)
	self:moveObject(SuperMacroFrameCharLimitText, "-", 5, "-", 70)
	self:moveObject(SuperMacroFrameSuperCharLimitText, "-", 5, "-", 70)
	self:removeRegions(SuperMacroFrameScrollFrame)
	self:skinScrollBar(SuperMacroFrameScrollFrame)
	self:removeRegions(SuperMacroFrameExtendScrollFrame)
	self:skinScrollBar(SuperMacroFrameExtendScrollFrame)
	self:removeRegions(SuperMacroFrameSuperScrollFrame)
	self:skinScrollBar(SuperMacroFrameSuperScrollFrame)
	self:removeRegions(SuperMacroFrameSuperEditScrollFrame)
	self:skinScrollBar(SuperMacroFrameSuperEditScrollFrame)
	self:removeRegions(SuperMacroPopupScrollFrame)
	self:skinScrollBar(SuperMacroPopupScrollFrame)
	self:moveObject(SuperMacroOptionsButton, "-", 5, "-", 70)
	self:moveObject(SuperMacroExitButton, "+", 25, nil, nil)
	self:moveObject(SuperMacroFrameCloseButton, "+", 28, "+", 8)
	self:keepRegions(SuperMacroFrameTab1, {7, 8}) -- N.B. region 7 is text, 8 is highlight
	self:keepRegions(SuperMacroFrameTab2, {7, 8}) -- N.B. region 7 is text, 8 is highlight
	self:moveObject(SuperMacroFrameTab1, nil, nil, "-", 70)
	self:moveObject(SuperMacroFrameTab2, "+", 10, nil, nil)
	if self.db.profile.TexturedTab then
		self:applySkin(SuperMacroFrameTab1, nil, 0)
		self:setActiveTab(SuperMacroFrameTab1)
		self:applySkin(SuperMacroFrameTab2, nil, 0)
		self:setInactiveTab(SuperMacroFrameTab2)
	else
		self:applySkin(SuperMacroFrameTab1)
		self:applySkin(SuperMacroFrameTab2)
	end
	self:keepRegions(SuperMacroPopupFrame, {7, 8}) -- N.B. region 7 is text, 8 is icon
	self:applySkin(SuperMacroPopupFrame)
	self:moveObject(SuperMacroPopupCancelButton, nil, nil, "+", 8)
	self:applySkin(SuperMacroFrame)

	-- Options Frame
	self:keepRegions(SuperMacroOptionsFrame, {6}) -- N.B. region 6 is text
	SuperMacroOptionsFrame:SetWidth(SuperMacroOptionsFrame:GetWidth() - 30)
	SuperMacroOptionsFrame:SetHeight(SuperMacroOptionsFrame:GetHeight() - 70)
	self:moveObject(SuperMacroOptionsTitleText, nil, nil, "-", 20)
	self:moveObject(SuperMacroOptionsCloseButton, "+", 28, "+", 8)
	self:moveObject(SuperMacroOptionsExitButton, "+", 20, nil, nil)
	for i = 1, 8 do
		_G["SuperMacroOptionsFrameCheckButton"..i.."Text"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	for i = 1, 1 do
		_G["SuperMacroOptionsFrameColorSwatch"..i.."Text"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:applySkin(SuperMacroOptionsFrame)

end
