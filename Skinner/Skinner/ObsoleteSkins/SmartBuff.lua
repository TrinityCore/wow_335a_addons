
function Skinner:SmartBuff()

-->>--	Options Frame
	self:keepFontStrings(SmartBuffOptionsFrame_ddTemplates)
	self:keepFontStrings(SmartBuff_PlayerSetup_ScrollFrame)
	self:skinScrollBar(SmartBuff_PlayerSetup_ScrollFrame)
	self:skinEditBox(SmartBuff_BuffSetup_txtManaLimit, {9})
	self:skinEditBox(SmartBuff_PlayerSetup_Title, {9})
	self:skinEditBox(SmartBuff_PlayerSetup_EditBox, {9})
	self:moveObject(SmartBuffOptionsFrameDone, "+", 50, nil, nil)
	self:applySkin(SmartBuff_BuffSetup)
	self:applySkin(SmartBuffOptionsFrame, true)

-->>--	Mini Group Panel
	self:applySkin(SmartBuff_MiniGroup)

-->>--	Key Button
	self:addSkinButton(SmartBuff_KeyButton, SmartBuff_KeyButton)

end
