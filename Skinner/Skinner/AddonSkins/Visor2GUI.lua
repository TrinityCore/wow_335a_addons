if not Skinner:isAddonEnabled("Visor2GUI") then return end

function Skinner:Visor2GUI()

	self:keepFontStrings(Visor2GUIFrame)
	self:moveObject(Visor2GUIFrameTitleString, nil, nil, "-", 4)
	self:moveObject(Visor2GUIFrameGrabParent, nil, nil, "+", 16)
	self:skinEditBox(Visor2GUIFrameEditBox, {9})
	self:skinEditBox(Visor2GUIFrameEditWidth, {9})
	self:skinEditBox(Visor2GUIFrameEditHeight, {9})
	self:skinEditBox(Visor2GUIFrameEditX, {9})
	self:skinEditBox(Visor2GUIFrameEditY, {9})
	self:applySkin(Visor2GUIFrame)
	self:applySkin(Visor2GUIFrameConfirm)

end
