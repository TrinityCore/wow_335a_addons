
function Skinner:Accountant()

	self:skinDropDown{obj=Accountant_CharDropDown}
	for i = 1, Accountant.MaxRows do
		self:keepFontStrings(_G["AccountantFrameRow"..i])
	end
	self:skinMoneyFrame{obj=AccountantFrameCacheAmount, moveSEB=true}
	self:addSkinFrame{obj=AccountantFrame, kfs=true, x1=8, y1=-11, x2=-11, y2=4}

-->>-- Tabs
	for i = 1, AccountantFrame.numTabs do
		local tabObj = _G["AccountantFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[AccountantFrame] = true

end
