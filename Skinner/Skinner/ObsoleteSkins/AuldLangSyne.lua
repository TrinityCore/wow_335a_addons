
function Skinner:AuldLangSyne()

	self:keepFontStrings(AuldLangSyne_Edit)
	self:skinEditBox(self:getChild(AuldLangSyne_Edit, 1), {9})
	self:applySkin(AuldLangSyne_Edit)

end

function Skinner:AuldLangSyne_Note()

	self:moveObject(AWSNoteFrameAddButton, nil, nil, "-", 70)

end
