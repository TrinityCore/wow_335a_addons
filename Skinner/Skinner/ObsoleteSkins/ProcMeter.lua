
function Skinner:ProcMeter()

-->>--	GUI
	self:keepFontStrings(ProcMeterGUI)
	self:applySkin(ProcMeterGUI)
-->>--	Ignore Add Frame
	self:keepFontStrings(ProcMeterOptions_IgnoreAddEditFrame)
	self:skinEditBox(ProcMeterOptions_IgnoreAddEditInputBox, {9})
	self:applySkin(ProcMeterOptions_IgnoreAddEditFrame)
-->>--	Proc Add Frame
	self:keepFontStrings(ProcMeterOptions_ProcAddEditFrame)
	self:skinEditBox(ProcMeterOptions_ProcAddEditNameInputBox, {9})
	self:skinEditBox(ProcMeterOptions_ProcAddEditCombatMsgInputBox, {9})
	self:applySkin(ProcMeterOptions_ProcAddEditFrame)
-->>--	Options Frame
	self:applySkin(ProcMeterOptions)
	self:applySkin(ProcMeterOptions_HeaderFrame)
	self:applySkin(ProcMeterOptions_GUIFrame)
	self:applySkin(ProcMeterOptions_IgnoreFrame)
	self:applySkin(ProcMeterOptions_IgnoreEntryContainer)
	self:applySkin(ProcMeterOptions_IgnoreScrollBarContainer)
	self:keepFontStrings(ProcMeterOptions_IgnoreScrollBar)
	self:skinScrollBar(ProcMeterOptions_IgnoreScrollBar)
	self:applySkin(ProcMeterOptions_ProcFrame)
	self:applySkin(ProcMeterOptions_ProcEntryContainer)
	self:applySkin(ProcMeterOptions_ProcScrollBarContainer)
	self:keepFontStrings(ProcMeterOptions_ProcScrollBar)
	self:skinScrollBar(ProcMeterOptions_ProcScrollBar)
-->>--	Help Frame
	self:keepFontStrings(ProcMeterHelp)
	self:applySkin(ProcMeterHelp)

end
