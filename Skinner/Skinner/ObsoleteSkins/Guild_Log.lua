
function Skinner:Guild_Log()

	self:applySkin(Guild_Log_History_Frame)
	self:applySkin(Guild_Log_History_TextBox_Frame)
	self:applySkin(Guild_Log_History_Clear_Frame)
	self:moveObject(Guild_Log_History_Option_Frame, "+", 7, nil, nil)
	self:keepFontStrings(Guild_Log_History_ScrollBar)
	self:skinScrollBar(Guild_Log_History_ScrollBar)
	self:moveObject(Guild_Log_Frame, nil, nil, "+", 16)
	self:applySkin(Guild_Log_History_Option_Frame)

end
