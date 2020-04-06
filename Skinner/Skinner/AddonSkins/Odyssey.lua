if not Skinner:isAddonEnabled("Odyssey") then return end

function Skinner:Odyssey()

	self:addSkinFrame{obj=OdysseyFrame, kfs=true, y1=-11, y2=4}
	self:skinEditBox{obj=OdysseyFrame_SearchEditBox, regs={9}}
	for i = 1, OdysseyFrame.numTabs do
		local tabObj = _G["OdysseyFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(Odyssey.Tabs, "OnClick",function(...)
			for i = 1, OdysseyFrame.numTabs do
				local tabSF = self.skinFrame[_G["OdysseyFrameTab"..i]]
				if i == OdysseyFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then OdyTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(OdyTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

-->>-- Quests Tab panel
	-- headers
	for i = 1, 8 do
		local hdr = _G["OdysseyTabQuests_Sort"..i]
		self:keepRegions(hdr, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=hdr, nb=true}
	end
	-- filters
	for i = 1, 3 do
		local fltr = _G["OdysseyTabQuestsMenuItem"..i]
		self:keepRegions(fltr, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=fltr, ft=ftype, nb=true}
	end
	-- QuestDB subpanel
	self:skinEditBox{obj=OdysseyFrameQuestDB_MinLevel, regs={9}}
	self:skinEditBox{obj=OdysseyFrameQuestDB_MaxLevel, regs={9}}
	self:skinScrollBar{obj=OdysseyFrameQuestDBScrollFrame}
	-- Realm Summary sub panel
	self:skinDropDown{obj=OdysseyFrameRealmSummary_SelectContinent}
	self:skinScrollBar{obj=OdysseyFrameRealmSummaryScrollFrame}
	-- Quest Details subpanel
	self:addSkinFrame{obj=OdysseyFrameQuestDetailsSeries}
	self:skinScrollBar{obj=OdysseyFrameQuestDetailsSeriesScrollFrame}

-->>-- Maps Tab panel
	-- filters
	for i = 1, 15 do
		local fltr = _G["OdysseyTabMapsMenuItem"..i]
		self:keepRegions(fltr, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=fltr, ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=OdysseyMapsMenuScrollFrame}

-->>-- Search Tab panel
	-- filters
	for i = 1, 15 do
		local fltr = _G["OdysseyTabSearchMenuItem"..i]
		self:keepRegions(fltr, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=fltr, ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=OdysseySearchMenuScrollFrame}


end
