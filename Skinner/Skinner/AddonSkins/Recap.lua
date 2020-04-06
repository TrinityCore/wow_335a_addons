if not Skinner:isAddonEnabled("Recap") then return end

function Skinner:Recap()

-->>-- Recap Frame
	self:keepFontStrings(RecapCombatEvents)
	self:applySkin(RecapCombatEvents)
	self:keepFontStrings(RecapDropSubFrame)
	self:applySkin(RecapDropSubFrame)
	self:keepFontStrings(RecapMenu)
	self:applySkin(RecapMenu)
	self:keepFontStrings(Recap_xml_424)
	self:applySkin(Recap_xml_424)
	self:keepFontStrings(RecapFrame)
	self:removeRegions(RecapScrollBar)
	self:skinScrollBar(RecapScrollBar)
	self:applySkin(RecapFrame)

	RecapFrame.SetBackdrop = function() end
	RecapFrame.SetBackdropColor = function() end
	RecapFrame.SetBackdropBorderColor = function() end

-->>-- Recap Panel
	self:keepFontStrings(RecapPanel_xml_424)
	self:applySkin(RecapPanel_xml_424)
	self:removeRegions(RecapPanelIncomingDetailsScrollBar)
	self:skinScrollBar(RecapPanelIncomingDetailsScrollBar)
	self:removeRegions(RecapPanelOutgoingDetailsScrollBar)
	self:skinScrollBar(RecapPanelOutgoingDetailsScrollBar)
	self:keepFontStrings(RecapPanel)
	self:applySkin(RecapPanel, nil)

	RecapPanel.SetBackdrop = function() end

-->>-- Recap Options Frame
	self:keepFontStrings(Recap_DropMenu)
	self:applySkin(Recap_DropMenu)
	self:keepFontStrings(RecapOptAnchorFrame)
	self:applySkin(RecapOptAnchorFrame)
	self:keepFontStrings(RecapOptions_xml_424)
	self:applySkin(RecapOptions_xml_424)
	self:removeRegions(RecapFightSetsScrollBar)
	self:skinScrollBar(RecapFightSetsScrollBar)
	self:keepFontStrings(RecapOpt_StatDropDown)
	self:keepFontStrings(RecapOpt_ChannelDropDown)
	self:removeRegions(RecapClipScrollFrame)
	self:skinScrollBar(RecapClipScrollFrame)
	-- Opt Clip Frame
	self:keepFontStrings(RecapOptClipFrame)
	self:applySkin(RecapOptClipFrame)
	self:skinEditBox(RecapSetEditBox, {9})
	self:skinEditBox(RecapClipEditBox, {9})
	self:skinEditBox(RecapIgnoresEditBox, {9})
	self:keepFontStrings(RecapOptFrame)
	self:applySkin(RecapOptFrame)

	RecapOptFrame.SetBackdrop = function() end

	if self.db.profile.Tooltips.skin then
		self:SecureHookScript(RecapTooltip, "OnShow", function(this)
			self:skinTooltip(RecapTooltip)
		end)
		if self.db.profile.Tooltips.style == 3 then RecapTooltip:SetBackdrop(self.backdrop) end
	end
	
	-- Tabs
	for i = 1, 6 do
		local tabObj = _G["RecapOptTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "+", 19)
		end 
		self:keepRegions(tabObj, {1, 5})
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook("RecapOptTab_OnClick", function()
			for i = 1, 6 do
				local tabObj = _G["RecapOptTab"..i]
				if i == this:GetID() then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end
	
end
