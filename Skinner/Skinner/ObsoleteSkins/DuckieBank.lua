
function Skinner:DuckieBank()

-->>--	Banker Requests Frame
	self:keepFontStrings(DuckieBank_BankerFrame)
	self:moveObject(DuckieBank_BankerFrame_CloseButton, "-", 4, "-", 4)
	self:applySkin(DuckieBank_BankerFrame)

-->>--	Bank Frame
	self:keepFontStrings(DuckieBank_AFrame)
	self:moveObject(DuckieBank_CloseButton, "-", 4, "-", 4)
	self:keepFontStrings(DuckieBank_BankerSelectDropDown)
	self:keepFontStrings(DuckieBank_FilterSelectDropDown)
	self:skinEditBox(DuckieBank_EditCustomCost, {9})
	self:keepFontStrings(DuckieBank_BankerNotes)
	self:skinScrollBar(DuckieBank_BankerNotes)
	self:skinEditBox(DuckieBank_RequestNote, {9})
	self:glazeStatusBar(DuckieBank_AFramePB, 0)
	self:applySkin(DuckieBank_AFrame)

end
