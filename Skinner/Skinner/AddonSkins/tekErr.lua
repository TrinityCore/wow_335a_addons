if not Skinner:isAddonEnabled("tekErr") then return end

function Skinner:tekErr()

	self:keepFontStrings(tekErrPanel)
	local titleText = self:getRegion(tekErrPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(tekErrPanel, 1) -- close button
	self:moveObject(cBut, nil, ni, "+", 11)
	self:applySkin(tekErrPanel)
	
	self:SecureHookScript(tekErrPanel, "OnShow", function(this)
		local eBox = self:getChild(this, 3)
		self:skinEditBox(eBox, {9})
		self:Unhook(tekErrPanel, "OnShow")
		end)

end
