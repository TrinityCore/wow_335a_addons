if not Skinner:isAddonEnabled("WebDKP") then return end

function Skinner:WebDKP()

-->>--	Frame
	self:keepFontStrings(WebDKP_FrameScrollFrame)
	self:skinScrollBar(WebDKP_FrameScrollFrame)
	self:keepFontStrings(WebDKP_Tables_DropDown)
	self:applySkin(WebDKP_Frame, true)
	-- Filters Frame
	self:applySkin(WebDKP_FiltersFrame)
	-- Award DKP Frame
	self:skinEditBox(WebDKP_AwardDKP_FrameReason, {})
	self:skinEditBox(WebDKP_AwardDKP_FramePoints, {})
	self:applySkin(WebDKP_AwardDKP_Frame)
	-- Award Items Frame
	self:skinEditBox(WebDKP_AwardItem_FrameItemName, {})
	self:skinEditBox(WebDKP_AwardItem_FrameItemCost, {})
	self:applySkin(WebDKP_AwardItem_Frame)
	-- Tabs
	for i = 1, 3 do
		local tabName = _G["WebDKP_FrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName)
			else self:setInactiveTab(tabName) end
		else self:applySkin(tabName) end
		if i ~= 1 then self:moveObject(tabName, "+", 10, "+", 0) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("WebDKP_Tab_OnClick", function()
			for i = 1, 3 do
				local tabName = _G["WebDKP_FrameTab"..i]
				if this:GetID() == i then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end
-->>--	Award Frame
	self:skinEditBox(WebDKP_AwardFrameCost, {})
	self:applySkin(WebDKP_AwardFrame)
-->>--	Bid Frame
	self:skinEditBox(WebDKP_BidFrameItem, {})
	self:skinEditBox(WebDKP_BidFrameStartingBid, {})
	self:skinEditBox(WebDKP_BidFrameTime, {})
	self:keepFontStrings(WebDKP_BidFrameScrollFrame)
	self:skinScrollBar(WebDKP_BidFrameScrollFrame)
	self:applySkin(WebDKP_BidFrame, true)
	self:applySkin(WebDKP_BidConfirmFrame)
	self:skinEditBox(WebDKP_BidConfirmFrameCost, {})
-->>--	Help Frame
	self:keepFontStrings(WebDKP_Help_DropDown)
	self:keepFontStrings(WebDKP_Help_ScrollFrame)
	self:skinScrollBar(WebDKP_Help_ScrollFrame)
	self:applySkin(WebDKP_HelpFrame, true)
-->>--	Options Frame
	self:applySkin(WebDKP_GeneralOptions_Frame)
	self:keepFontStrings(WebDKP_GeneralOptions_FrameAutofillDropDown)
	self:applySkin(WebDKP_BiddingOptions_Frame)
	self:applySkin(WebDKP_AutoAwardOptions_Frame)
	self:applySkin(WebDKP_OptionsFrame, true)
	-- Tabs
	for i = 1, 2 do
		local tabName = _G["WebDKP_OptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName)
			else self:setInactiveTab(tabName) end
		else self:applySkin(tabName) end
		if i ~= 1 then self:moveObject(tabName, "+", 10, "+", 0) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook("WebDKP_Options_Tab_OnClick", function()
			for i = 1, 3 do
				local tabName = _G["WebDKP_OptionsFrameTab"..i]
				if this:GetID() == i then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end
-->>--	Timed Award Frame
	self:skinEditBox(WebDKP_TimedAwardFrameDkp, {})
	self:skinEditBox(WebDKP_TimedAwardFrameTime, {})
	self:applySkin(WebDKP_TimedAwardFrame, true)
	self:applySkin(WebDKP_TimedAward_MiniFrame)

end
