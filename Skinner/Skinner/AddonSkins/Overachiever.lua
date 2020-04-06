if not Skinner:isAddonEnabled("Overachiever") then return end

function Skinner:Overachiever()
	if not self.db.profile.AchievementUI then return end

	local function findOptionsPanel(panel)
		local panelName
		if type(panel) == "string" then
			panelName = panel
			panel = nil
		end
		local elementToDisplay
		for _, element in next, INTERFACEOPTIONS_ADDONCATEGORIES do
			if ( element == panel or (panelName and element.name and element.name == panelName) ) then
				elementToDisplay = element
				break
			end
		end
		return elementToDisplay
	end

	local panel = findOptionsPanel("Overachiever")
	self:SecureHookScript(panel, "OnShow", function(this)
    	local tab = this.TjOpt_tab
		if tab.scrolling then
			self:skinScrollBar{obj=TjOptionsScrollFrame1}
		end
		for i = 1, #tab.items do
			local itm = _G["TjOptionsItemNumber"..i]
			if itm and itm.TjDDM then
--				self:Debug("Found a DropDown: [%s]", i)
				self:skinDropDown{obj=itm}
			end
		end
		self:Unhook(panel, "OnShow")
	end)

end


function Skinner:Overachiever_Tabs()
	if not self.db.profile.AchievementUI then return end

	self:skinAllButtons{obj=Overachiever_LeftFrame}
-->>-- Search Frame
	self:keepFontStrings(Overachiever_SearchFrame)
	self:skinDropDown(Overachiever_SearchFrameSortDrop)
	self:skinEditBox(Overachiever_SearchFrameNameEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameDescEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameCriteriaEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameRewardEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameAnyEdit, {9})
	self:skinSlider(Overachiever_SearchFrameContainerScrollBar)
	self:applySkin(self:getChild(Overachiever_SearchFrame, 1))
	LowerFrameLevel(self:getChild(Overachiever_SearchFrame, 1))

-->>-- Suggestions Frame
	self:keepFontStrings(Overachiever_SuggestionsFrame)
	self:skinDropDown(Overachiever_SuggestionsFrameSortDrop)
	self:skinEditBox{obj=Overachiever_SuggestionsFrameZoneOverrideEdit, regs={9}}
	self:skinDropDown(Overachiever_SuggestionsFrameSubzoneDrop)
	self:skinSlider(Overachiever_SuggestionsFrameContainerScrollBar)
	self:applySkin(self:getChild(Overachiever_SuggestionsFrame, 1))
	LowerFrameLevel(self:getChild(Overachiever_SuggestionsFrame, 1))

-->>-- Watch Frame
	self:keepFontStrings(Overachiever_WatchFrame)
	self:skinDropDown(Overachiever_WatchFrameSortDrop)
	self:skinSlider(Overachiever_WatchFrameContainerScrollBar)
	local wFrame = self:getChild(Overachiever_WatchFrame, 1)
	self:applySkin(wFrame)
	wFrame:SetFrameLevel(wFrame:GetFrameLevel() - 2) -- make sure text is shown

end
