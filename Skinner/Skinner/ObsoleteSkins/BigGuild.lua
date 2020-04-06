
function Skinner:BigGuild()

	self:keepFontStrings(BigGuildFrame)
	self:moveObject(BigGuildFrameText, nil, nil, "-", 6)
	self:applySkin(BigGuildFrame)
	self:keepFontStrings(BigGuildListScrollFrame)
	self:skinScrollBar(BigGuildListScrollFrame)
	self:applySkin(BigGuildMemberListFrame)
	self:keepFontStrings(BigGuildFilterRankDropDown)
	self:applySkin(BigGuildFilterSelectFrame)
	self:applySkin(BigGuildDetailFrame)
-->>--	Export Frame
	self:keepFontStrings(BigGuildExportFrame)
	self:moveObject(BigGuildExportWindowTitle, nil, nil, "-", 6)
	self:keepFontStrings(BigGuildExportScrollFrame)
	self:skinScrollBar(BigGuildExportScrollFrame)
	self:applySkin(BigGuildExportFrame)

end
