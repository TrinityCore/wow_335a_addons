if not Skinner:isAddonEnabled("GroupCalendar5") then return end

function Skinner:GroupCalendar5()

	local function skinSEB(frame)
		
		-- Scrolling EditBox
		self:addSkinFrame{obj=frame, x1=-6, y1=4, y2=-6}
		frame.BackgroundTextures:Hide()
		frame.ScrollbarTrench:Hide()
		self:skinSlider(frame.Scrollbar)
		
	end


	local function skinDD(frame)
		
		-- DropDown Menu
		if not self.db.profile.TexturedDD then self:keepFontStrings(frame)
		else
			local leftTex, rightTex, midTex = frame:GetRegions()
			leftTex:SetAlpha(0)
			leftTex:SetHeight(18)
			midTex:SetTexture(self.itTex)
			midTex:SetTexCoord(0, 1, 0, 1)
			rightTex:SetAlpha(0)
			rightTex:SetHeight(18)
			-- move the middle texture
			midTex:ClearAllPoints()
			midTex:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
			midTex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3)
			
		end
		
	end
	
	local gcUI = GroupCalendar.UI
	local gcW = gcUI.Window
	local tV = gcW.TabbedView
	
	-- hook this to manage Tabs
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(tV.Tabs, "SelectTab",function(this, ...)
--			self:Debug("Tabs: [%s, %s]", #this.Tabs, this.SelectedTab)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = self.skinFrame[vTab]
				if vTab == this.SelectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	-- remove the clock
	gcW.Clock:Hide()
	-- skin the main frame
	self:addSkinFrame{obj=gcW, kfs=true, x1=10, y1=-11, x2=2, y2=-3}
-->>-- Tabbed Views
	-- Month View
	-- Settings View
	-- Partners View
	local pV = gcW.PartnersView
	self:skinEditBox{obj=pV.CharacterName, regs={9}}
	self:glazeStatusBar(pV.ProgressBar, 0)
	-- Export View
	local eV = gcW.ExportView
	skinSEB(eV.ExportData)
	-- About View

-->>-- NewerVersion Frame
	self:addSkinFrame{obj=gcW.NewerVersionFrame, kfs=true, y1=1, y2=-1}
	
-->>-- ClassLimits Dialog
	local clD = gcUI.ClassLimitsDialog
	skinDD(clD.PriorityMenu)
	for _, class in pairs(self.classTable) do	
		self:skinEditBox{obj=clD[strupper(class)].Min, regs={9}, noWidth=true}
		self:skinEditBox{obj=clD[strupper(class)].Max, regs={9}, noWidth=true}
	end
	skinDD(clD.MaxPartySizeMenu)
	self:addSkinFrame{obj=clD, kfs=true, y1=4, y2=4}
	
-->>-- RoleLimits Dialog
	local rlD = gcUI.RoleLimitsDialog
	skinDD(rlD.PriorityMenu)
	for _, role in pairs({"H", "T", "R", "M"}) do
		self:skinEditBox{obj=rlD[role].Min, regs={9}, noWidth=true}
		self:skinEditBox{obj=rlD[role].Max, regs={9}, noWidth=true}
		for _, class in pairs(self.classTable) do	
			self:skinEditBox{obj=rlD[role][strupper(class)], regs={9}, noWidth=true}
		end
	end
	skinDD(rlD.MaxPartySizeMenu)
	self:addSkinFrame{obj=rlD, kfs=true, y1=4, y2=4}

-->>-- DaySidebar
	local dSB = gcW.DaySidebar
	dSB.Foreground:Hide()
	dSB.ScrollingList.ScrollbarTrench:Hide()
	self:skinScrollBar{obj=dSB.ScrollingList.ScrollFrame}
	self:addSkinFrame{obj=dSB, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}

-->>-- EventSidebar
	local eSB = gcW.EventSidebar
	local etV = eSB.TabbedView
	-- hook this to manage Tabs
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(etV.Tabs, "SelectTab",function(this, ...)
--			self:Debug("Tabs: [%s, %s]", #this.Tabs, this.SelectedTab)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = self.skinFrame[vTab]
				if vTab == this.SelectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	eSB.Foreground:Hide()
	self:addSkinFrame{obj=eSB, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}
-->>-- Tabbed Views
	-- Event View
	-- Edit View
	local eeV = eSB.EventEditor
	-- Date Picker
	skinDD(eeV.DatePicker.MonthMenu)
	skinDD(eeV.DatePicker.DayMenu)
	skinDD(eeV.DatePicker.YearMenu)
	skinDD(eeV.EventTypeMenu)
	self:skinEditBox{obj=eeV.EventTitle, regs={9}}
	skinDD(eeV.EventModeMenu)
	self:skinEditBox{obj=eeV.LevelRangePicker.MinLevel, regs={9}, noWidth=true}
	self:skinEditBox{obj=eeV.LevelRangePicker.MaxLevel, regs={9}, noWidth=true}
	skinSEB(eeV.Description)
	-- Time Picker
	skinDD(eeV.TimePicker.HourMenu)
	skinDD(eeV.TimePicker.MinuteMenu)
	skinDD(eeV.TimePicker.AMPMMenu)
	skinDD(eeV.DurationMenu)
	skinDD(eeV.RepeatMenu)
	skinDD(eeV.LockoutMenu)
	-- Invite View
	local eiV = eSB.EventInvite
	self:skinEditBox{obj=eiV.CharacterName, regs={9}, x=-2}
	eiV.ExpandAll.TabLeft:SetAlpha(0)
	eiV.ExpandAll.TabMiddle:SetAlpha(0)
	eiV.ExpandAll.TabRight:SetAlpha(0)
	eiV.ScrollingList.ScrollbarTrench:Hide()
	self:skinScrollBar{obj=eiV.ScrollingList.ScrollFrame}
	self:keepFontStrings(eiV.StatusSection)
	-- Group View
	local egV = eSB.EventGroup
	skinDD(egV.ViewMenu)
	egV.ExpandAll.TabLeft:SetAlpha(0)
	egV.ExpandAll.TabMiddle:SetAlpha(0)
	egV.ExpandAll.TabRight:SetAlpha(0)
	egV.ScrollingList.ScrollbarTrench:Hide()
	self:skinScrollBar{obj=egV.ScrollingList.ScrollFrame}
	self:keepFontStrings(egV.TotalsSection)
	self:keepFontStrings(egV.StatusSection)
	
-->>-- All Tabs
	for i = 1, MC2UIElementsLib.TabNameIndex - 1 do
		local tabName = _G["MC2UIElementsLibTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end
