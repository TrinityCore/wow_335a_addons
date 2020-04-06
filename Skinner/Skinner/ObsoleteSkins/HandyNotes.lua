
function Skinner:HandyNotes()

	-- thanks to Xinhuan for the pointer in the code :-)
	local HNEditFrame = LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame
	
	self:keepFontStrings(HNEditFrame)
	self:moveObject(HNEditFrame.title, nil, nil, "-", 4, HNEditFrame)
	HNEditFrame.titleinputframe:SetBackdrop(nil)
	self:skinEditBox(HNEditFrame.titleinputbox, {})
	self:moveObject(HNEditFrame.titleinputbox, "-", 5, nil, nil, HNEditFrame.titleinputframe)
	self:applySkin(HNEditFrame.descframe)
	self:removeRegions(HNEditFrame.descscrollframe)
	self:skinScrollBar(HNEditFrame.descscrollframe)
	self:skinDropDown(HNEditFrame.icondropdown, true, nil, true)
	self:moveObject(_G[HNEditFrame.icondropdown:GetName().."Button"], nil, nil, "-", 2)
	self:applySkin(HNEditFrame)

end
