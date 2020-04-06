if not Skinner:isAddonEnabled("tekPad") then return end

function Skinner:tekPad()

	self:keepFontStrings(tekPadPanel)
	local titleText = self:getRegion(tekPadPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(tekPadPanel, 1) -- close button
	self:moveObject(cBut, "+", 0, "+", 11)
	self:applySkin(tekPadPanel)
	
end
