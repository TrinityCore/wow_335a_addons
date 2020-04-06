
function Skinner:myMusic()

	self:keepFontStrings(myMusic_frame)
	myMusic_frame:SetWidth(350)
	myMusic_frame:SetHeight(415)
	self:moveObject(myMusic_closeplayerbutton, "+", 28, "+", 8)
	self:moveObject(myMusic_shufflestring, "+", 30, nil, nil)
	self:moveObject(myMusic_shuffleButton, "-", 5, nil, nil)
	self:moveObject(mymusicplaylist_frame, "+", 10, nil, nil)
	self:applySkin(myMusic_frame)

-->>--	Options Frame
	self:keepFontStrings(myMusic_OptionsFrame)
	self:keepFontStrings(myMusic_ChannelDropDown)
	self:skinEditBox(myMusic_customPostChannel, {9})
	self:skinEditBox(myMusic_postMessage, {9})
	self:applySkin(myMusic_OptionsFrame)

end
