if not Skinner:isAddonEnabled("GuildBankAccount") then return end

function Skinner:GuildBankAccount()

-->>--	Guild Frame Button
	self:moveObject(GuildBankAccountToggleButton, "-", 40, "+", 30)
-->>--	Stock Frame
	GuildBankAccountFrame:SetWidth(GuildBankAccountFrame:GetWidth() * self.FxMult)
	GuildBankAccountFrame:SetHeight(GuildBankAccountFrame:GetHeight() * self.FyMult)
	self:moveObject(GuildBankAccountOptionsButton, "+", 28, "+", 8)
	self:moveObject(GuildBankAccountFrameCloseButton, "+", 28, "+", 8)
	self:skinEditBox(GuildBankAccountFilter, {9})
	self:moveObject(GuildBankAccountFilter, "+", 40, nil, nil)
	self:moveObject(GuildBankAccountFilterClear, "+", 40, nil, nil)
	self:keepFontStrings(GuildBankAccountBrowseStockScrollFrame)
	self:moveObject(GuildBankAccountBrowseStockScrollFrame, "+", 66, nil, nil)
	self:skinScrollBar(GuildBankAccountBrowseStockScrollFrame)
	self:moveObject(GuildBankAccountCreditsText, nil, nil, "-", 58)
	self:moveObject(GuildBankAccountCreditsStatic, nil, nil, "+", 10)
	self:keepFontStrings(GuildBankAccountMainToonDropDown)
	self:moveObject(GuildBankAccountMainToonDropDown, nil, nil, "+", 10)
	self:moveObject(GuildBankAccountCloseButton, "+", 34, "-", 58)
	self:keepFontStrings(GuildBankAccountFrame)
	self:applySkin(GuildBankAccountFrame)
-->>--	Options Frame
	self:keepFontStrings(GuildBankAccountOptionsFrame)
	self:skinEditBox(GuildBankAccountOptionsChannelSpeedPackets, {9})
	self:skinEditBox(GuildBankAccountOptionsChannelSpeedSeconds, {9})
	self:applySkin(GuildBankAccountOptionsFrame, true)

end
