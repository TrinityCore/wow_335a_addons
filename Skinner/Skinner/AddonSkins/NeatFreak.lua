if not Skinner:isAddonEnabled("NeatFreak") then return end

function Skinner:NeatFreak()

	if self.isTT then
		-- hook this to handle tabs when showing the frame
		self:SecureHook(NeatFreak, "Show", function()
			self:setActiveTab(self.skinFrame[NeatFreakTab1])
		end)
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("NeatFreakClickedTab",function(...)
			for i = 1, 3 do
				local tabSF = self.skinFrame[_G["NeatFreakTab"..i]]
				if i == this:GetID() then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	NeatFreakSortPageTheHorizontalBar:Hide()
	self:addSkinFrame{obj=self:getChild(NeatFreakSortPage, 1), kfs=true}-- ItemSortDisplay frame (first one!)
	self:skinScrollBar{obj=NeatFreakSortPageScrollFrame}
	self:skinEditBox{obj=ItemNameEditBox, regs={9}}
	self:skinEditBox{obj=ItemTypeInterfaceEditBox, regs={9}}
	self:skinEditBox{obj=ItemRarityInterfaceEditBox, regs={9}}
	self:skinDropDown{obj=ItemBagDropDownMenuButton}
	self:skinEditBox{obj=ItemSlotEditBox, regs={9}}
	self:addSkinFrame{obj=NeatFreakSortPageItemSortDisplayItemHiddenInfo, kfs=true}
	self:addSkinFrame{obj=NeatFreak, kfs=true, x1=12, y1=-12, x2=-31, y2=72}

-->>-- Tabs (bottom)
	for i = 1, 3 do
		local tabObj = _G["NeatFreakTab"..i]
		tabObj:SetWidth(80)
		tabObj:SetHeight(36)
		self:keepRegions(tabObj, {1, 3}) -- N.B. region 1 is text, 3 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
			self:moveObject{obj=tabObj, x=-20}
		else
			if self.isTT then self:setInactiveTab(tabSF) end
			self:moveObject{obj=tabObj, x=5}
		end
	end
-->>-- Tabs (side)
	for i = 1, 6 do
		local tabName = _G["NeatFreakRightTabs"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
		self:addSkinButton{obj=tabName, parent=tabName}
	end

end
