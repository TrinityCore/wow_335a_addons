if not Skinner:isAddonEnabled("GemHelper") then return end

function Skinner:GemHelper()

	self:moveObject(GemHelper_CloseButton, "-", 1, "+", 1)
	self:moveObject(GemHelper_ColorSwatch, nil, nil, "+", 3)
	for i = 1, 4 do
		local ghb = _G["GemHelper_Background"..i]
		self:applySkin(ghb)
	end
	self:removeRegions(GemHelper_ListScrollFrame)
	self:skinScrollBar(GemHelper_ListScrollFrame)
	self:skinEditBox(GemHelper_InputBox, {9})
	GemHelper_InputBox:SetWidth(GemHelper_InputBox:GetWidth() + 5)
	self:skinDropDown(GemHelper_UserDropdown, nil, true)
	self:moveObject(GemHelper_UserDropdown, "+", 9, "+", 3)
	self:keepFontStrings(GemHelper_Frame)
	self:applySkin(GemHelper_Frame, true)

	GemHelper_Frame.SetBackdropColor = function() end

end
