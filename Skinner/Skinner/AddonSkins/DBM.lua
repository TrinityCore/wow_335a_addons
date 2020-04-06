if not Skinner:isAddonEnabled("DBM-Core") then return end

function Skinner:DBM_GUI()
	
	-- (BUGFIX for DBM): reparent the Huge Bar statusBar 
	for bar in DBM.Bars:GetBarIterator() do
-- 		self:Debug("Status Bar info: [%s, %s]", bar, bar.id)
		if bar.id == "dummy3" then
			local relTo = select(2, bar.frame:GetPoint())
			bar.frame:SetParent(relTo)
			break
		end	
	end
	-- Bar Sub frames are not right, some cover their children etc
	-- this is because of a bug in DBM_GUI, this is a workaround for it
	-- (BUGFIX for DBM): reparent sliders
	local barSetupSubPanel, barSetupSmallSubPanel = false, false
	local function fixForBarSetup(subPanel)
		local fName = _G[subPanel.framename.."Title"]:GetText()
		-- check to see if this is the BarSetup or BarSetupSmall subPanel
		if fName == DBM_GUI_Translations.AreaTitle_BarSetup then
			barSetupSubPanel = subPanel.frame
		elseif fName == DBM_GUI_Translations.AreaTitle_BarSetupSmall then
			barSetupSmallSubPanel = subPanel.frame
		end
-- 		Skinner:Debug("fixForBarSetup: [%s, %s]", barSetupSubPanel, barSetupSmallSubPanel)
		if barSetupSubPanel and barSetupSmallSubPanel then
			-- reparent the sliders
-- 			Skinner:Debug("fixForBarSetup#2: [%s]", barSetupSubPanel:GetNumChildren())
			-- work backwards as the reparenting shortens the table
			for i = barSetupSubPanel:GetNumChildren(), 1, -1 do
				local child = select(i, barSetupSubPanel:GetChildren())
				if child:IsObjectType("Slider") then
					child:SetParent(barSetupSmallSubPanel)
				end
			end
			fixForBarSetup = nil
		end
	end
	local panelPrefix = "DBM_GUI_Option_"
	local function skinPizzaEBs(subPanel)
-- 		Skinner:Debug("skinPizzaEBs")
		-- check to see if this is the pizza timer option subPanel
		local fName = subPanel.framename
		if _G[fName.."Title"]:GetText() == DBM_GUI_Translations.PizzaTimer_Headline then
-- 			Skinner:Debug("Found Pizza Timer panel:[%s]", fName)
			local si, ei, fNo = strfind(fName, panelPrefix.."(%d+)")
-- 			Skinner:Debug("find info:[%s, %s, %s]", si, ei, fNo)
			-- next four option frames are editboxes
			for i = fNo + 1, fNo + 4 do
				self:skinEditBox(_G[panelPrefix..i], {9})
			end
			skinPizzaEBs = nil
		end
	end
	local function skinSubPanels(panel)
	
		for _, subPanel in pairs(panel.areas) do
			if not Skinner.skinned[subPanel] then
-- 				Skinner:Debug("skinSubPanel:[%s, %s, %s]", panel, subPanel.frame, subPanel.framename)
				Skinner:applySkin(subPanel.frame)
				-- check to see if any children are dropdowns
				for i = 1, subPanel.frame:GetNumChildren() do
					local child = select(i, subPanel.frame:GetChildren())
					if Skinner:isDropDown(child) then
						Skinner:skinDropDown(child)
					end
				end
				-- check to see if this is the pizza timer option subPanel
				if skinPizzaEBs then skinPizzaEBs(subPanel) end
				-- (BUGFIX for DBM): look for the Bar Setup panels
				if fixForBarSetup then fixForBarSetup(subPanel) end
			end
		end
		
	end
	
-->>--	Options Frame
	self:keepFontStrings(DBM_GUI_OptionsFrame)
	self:moveObject(DBM_GUI_OptionsFrameHeaderText, nil, nil, "-", 6)
	self:keepFontStrings(DBM_GUI_OptionsFrameBossModsList)
	self:skinSlider(DBM_GUI_OptionsFrameBossModsListScrollBar, 3)
	self:addSkinFrame{obj=DBM_GUI_OptionsFrameBossMods, kfs=true}--, x1=10, y1=-12, x2=-32, y2=71}
	self:addSkinFrame{obj=DBM_GUI_OptionsFrameDBMOptions, kfs=true}--, x1=10, y1=-12, x2=-32, y2=71}
	self:skinScrollBar{obj=DBM_GUI_OptionsFramePanelContainerFOV, size=3}
	self:applySkin(DBM_GUI_OptionsFramePanelContainer)
	self:applySkin(DBM_GUI_OptionsFrame)
	-- skin dropdown
	self:addSkinFrame{obj=DBM_GUI_DropDown}
	
	-- hook this to skin sub panels
	self:SecureHook(DBM_GUI, "CreateNewPanel", function(this, ...)
		for _, panel in pairs(DBM_GUI.panels) do
-- 			self:Debug("CreateNewPanel:[%s, %s]", panel.frame, panel.framename)
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
-- 					self:Debug("New - CreateArea:[%s]", panel)
					skinSubPanels(panel)
				end)
				panel.hooked = true
			end
		end
	end)
	
	-- loop through all the existing panels
	for _, panel in pairs(DBM_GUI.panels) do
-- 		self:Debug("Panels:[%s, %s]", panel.frame, panel.framename)
		if panel.areas then
			skinSubPanels(panel)
		else
			if not panel.hooked then
				self:SecureHook(panel, "CreateArea", function(this, ...)
-- 					self:Debug("Existing - CreateArea:[%s]", panel)
					skinSubPanels(panel)
				end)
				panel.hooked = true
			end
		end
	end
	
	-- change StatusBar texture
	DBM.Bars:SetOption("Texture", self.sbTexture)
	
	-- Options Frame Tabs
	for i = 1, 2 do
		local tabName = _G["DBM_GUI_OptionsFrameTab"..i]
		local tnText = _G["DBM_GUI_OptionsFrameTab"..i.."Text"]
		local tnHighlight = _G["DBM_GUI_OptionsFrameTab"..i.."HighlightTexture"]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 4)
		else
			self:moveObject(tabName, "+", 13, nil, nil)
		end
		self:moveObject(tnText, nil, nil, "+", 3)
		tnHighlight:SetWidth(tabName:GetWidth() - 10)
		self:moveObject(tnHighlight, "-", 4, "+", 3)
		tabName:SetFrameLevel(tabName:GetFrameLevel() + 5)
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
			self:SecureHookScript(tabName, "OnClick", function(this)
--				self:Debug("DBM_GUI_OptionsFrameTab_OnClick: [%s, %s]", this:GetName(), this:GetID())
				for i = 1, 2 do
					local tabName = _G["DBM_GUI_OptionsFrameTab"..i]
					if i == this:GetID() then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
				end
			end, true)
		else self:applySkin(tabName) end
	end
	
end

function Skinner:DBMCore()

	-- hook this to skin the RangeCheck frame (actually a tooltip)
	self:SecureHook(DBM.RangeCheck, "Show", function(this, ...)
--		self:Debug("DBM.RC_Show")
		if not self.skinned[DBMRangeCheck] then
			self:skinDropDown{obj=DBMRangeCheckDropdown}
		end
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then DBMRangeCheck:SetBackdrop(self.Backdrop[1]) end
			self:skinTooltip(DBMRangeCheck)
		end
	end)	

end
