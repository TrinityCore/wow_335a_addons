
function Skinner:DepositBox()

	self:applySkin(DepositBoxUI_Main_BlockButton)
	self:skinMoneyFrame(DepositBoxUI_DepositBox_MoneyInputFrame)
	self:skinMoneyFrame(DepositBoxUI_DepositBox_ThresholdInputFrame)
	self:applySkin(DepositBoxUI_DepositBoxFrame, nil)

-->>--	Options Frame
	self:skinMoneyFrame(DepositBoxUI_Options_MoneyInputFrame)
	self:applySkin(DepositBoxUI_OptionsFrame)

-->>--	Tabs
	-- N.B. CheckButtons are used for the tabs and the backdrop texture can't be changed
	-- throws a nil error
	self:keepRegions(DepositBoxUI_DepositBoxTab, {10, 11, 12}) -- N.B. these regions are text
	self:keepRegions(DepositBoxUI_OptionsTab, {10, 11, 12}) -- N.B. these regions are text
	if self.db.profile.TexturedTab then self:applySkin(DepositBoxUI_DepositBoxTab, nil, 0)
	else self:applySkin(DepositBoxUI_DepositBoxTab) end
	if self.db.profile.TexturedTab then self:applySkin(DepositBoxUI_OptionsTab, nil, 0)
	else self:applySkin(DepositBoxUI_OptionsTab) end

end
