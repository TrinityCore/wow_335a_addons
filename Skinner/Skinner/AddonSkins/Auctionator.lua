if not Skinner:isAddonEnabled("Auctionator") then return end

function Skinner:Auctionator()

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("Atr_ShowWhichRB",function(id)
			for i = 1, Atr_ListTabs.numTabs do
				local tabSF = self.skinFrame[_G["Atr_ListTabsTab"..i]]
				if i == Atr_ListTabs.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>-- AuctionUI panels
	self:skinEditBox{obj=Atr_Search_Box, regs={9}}
	-- item drag & drop frame
	self:addSkinFrame{obj=Atr_Hilite1, kfs=true}
	self:addSkinFrame{obj=Atr_HeadingsBar, kfs=true, y1=-19, y2=19}
	-- scroll frame below heading bar
	self:skinScrollBar{obj=AuctionatorScrollFrame}
	for i = 1, Atr_ListTabs.numTabs do
		local tabObj = _G["Atr_ListTabsTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:moveObject{obj=self:getRegion(tabObj, 8), y=3}
		self:addSkinFrame{obj=tabObj, noBdr=self.isTT, y1=-4, x2=4, y2=-4}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

	-- Buy
	self:skinDropDown{obj=Atr_DropDownSL}
	-- Sell
	self:skinScrollBar{obj=Atr_Hlist_ScrollFrame}
	self:addSkinFrame{obj=Atr_Hlist, kfs=true, x1=-4, x2=8}
	self:skinMoneyFrame{obj=Atr_StackPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=Atr_ItemPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=Atr_StartingPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinEditBox{obj=Atr_Batch_NumAuctions, regs={9}}
	self:skinEditBox{obj=Atr_Batch_Stacksize, regs={9}}
	self:skinDropDown{obj=Atr_Duration}
	-- More...
	self:skinDropDown{obj=Atr_DropDown1}

-->>-- Error Frame
	self:addSkinFrame{obj=Atr_Error_Frame, kfs=true}
-->>-- Confirm Frame
	self:addSkinFrame{obj=Atr_Confirm_Frame, kfs=true}
-->>-- Buy_Confirm Frame
	self:skinEditBox{obj=Atr_Buy_Confirm_Numstacks, regs={9}}
	self:addSkinFrame{obj=Atr_Buy_Confirm_Frame, kfs=true}
-->>-- CheckActives Frame
	self:addSkinFrame{obj=Atr_CheckActives_Frame, kfs=true}
-->>-- FullScan Frame
	self:addSkinFrame{obj=Atr_FullScanFrame, kfs=true, y1=4}

-->>-- Options Panels
	-- Undercutting panel
	self:skinMoneyFrame{obj=UC_5000000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_1000000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_200000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_50000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_10000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_2000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_500_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	-- Sell Stacking
	self:addSkinFrame{obj=Atr_Stacking_List, kfs=true}
	-- Memorize Stacking screen
	self:skinEditBox{obj=Atr_Mem_EB_itemName, regs={9}}
	self:skinDropDown{obj=Atr_Mem_DD_numStacks}
	self:skinEditBox{obj=Atr_Mem_EB_stackSize, regs={9}}
	self:addSkinFrame{obj=Atr_MemorizeFrame, kfs=true}
	
	-- disable changes to InterfaceOptionsFrame(s) backdrop
	Atr_MakeOptionsFrameOpaque = function() end

end
