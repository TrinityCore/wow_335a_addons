if not Skinner:isAddonEnabled("Outfitter") then return end

function Skinner:Outfitter()
	if not self.db.profile.CharacterFrames then return end

	 -- wait until Outfitter has been initialized
	if not Outfitter.Initialized then
		self:ScheduleTimer("checkAndRunAddOn", 0.1, "Outfitter")
		return
	end

	-- N.B. Outfitter changes the framelevel and framestrata of some of its frames and their children

	local function skinOutfitterTabs(tabId)

		for i = 1, OutfitterFrame.numTabs do
			if i == OutfitterFrame.selectedTab then Skinner:setActiveTab(_G["OutfitterFrameTab"..i])
			else Skinner:setInactiveTab(_G["OutfitterFrameTab"..i]) end
		end

	end

	if self.db.profile.TexturedTab then
		--  Handle new and old versions
		if type(Outfitter['ShowPanel']) == "function" then
			self:SecureHook(Outfitter, "ShowPanel", function(tabId)
--				self:Debug("Outfitter:ShowPanel: [%s]", tabId)
				skinOutfitterTabs(tabId)
			end)
		else
			self:SecureHook(Outfitter_ShowPanel, function(tabId)
--				self:Debug("Outfitter_ShowPanel: [%s]", tabId)
				skinOutfitterTabs(tabId)
			end)
		end
	end

	local function skinOutfitBars(this, ...)

		-- handle no Bars showing
		if not this.Bars then return end

		for i = 1, #this["Bars"] do
			local oBar = _G["OutfitterOutfitBar"..i]
			if not Skinner.skinFrame[oBar] then
				self:addSkinFrame{obj=oBar, kfs=true, x1=-2, y1=3, x2=0, y2=1}
			end
		end
		for i = 1, 2 do
			local dBar = this["DragBar"..i]
			if dBar and not Skinner.skinFrame[dBar] then
				Skinner:addSkinFrame{obj=dBar, kfs=true, x1=-2, y1=3, x2=0, y2=1}
				if not dBar.Vertical then dBar:SetWidth(20)
				else dBar:SetHeight(20) end
				-- hook this to handle an Orientation change
				Skinner:SecureHook(dBar, "SetVerticalOrientation", function(this, pVertical)
--					Skinner:Debug("O.OB._DB_SVO : [%s, %s, %s]", this, pVertical, this:GetWidth())
					if not this.Vertical then this:SetWidth(20)
					else this:SetHeight(20) end
				end)
			end
		end

	end

	local function skinDropDown(obj)

		if not Skinner.db.profile.TexturedDD then Skinner:keepFontStrings(obj) return end
		-- dropdown
		self:moveObject{obj=obj.LeftTexture, x=2, y=-21}
		obj.LeftTexture:SetAlpha(0)
		obj.LeftTexture:SetHeight(19)
		obj.LeftTexture:SetWidth(2)
		obj.RightTexture:SetAlpha(0)
		obj.RightTexture:SetHeight(19)
		obj.RightTexture:SetWidth(2)
		obj.MiddleTexture:SetTexture(Skinner.itTex)

	end

	local function skinMultiStats(obj)

		for i = 1, #obj.ConfigLines do
			if not Skinner.skinned[obj.ConfigLines[i]] then
				skinDropDown(obj.ConfigLines[i].StatMenu)
				skinDropDown(obj.ConfigLines[i].OpMenu)
				if obj.ConfigLines[i].DeleteButton then Skinner:skinButton{obj=obj.ConfigLines[i].DeleteButton} end
			end
		end

	end
 	-- hook these to handle the Outfit Bars
	self:SecureHook(Outfitter.OutfitBar, "UpdateBar", function(this, ...)
		skinOutfitBars(this, ...)
	end)
	self:SecureHook(Outfitter.OutfitBar, "DragBar_OnClick", function(this)
		if OutfitBarSettingsDialog then
			self:Unhook(Outfitter.OutfitBar, "DragBar_OnClick")
			self:applySkin(OutfitBarSettingsDialog)
		end
	end)

	-- hook this to skin additional Shopping tooltips
	self:SecureHook(Outfitter._ExtendedCompareTooltip, "AddShoppingLink", function(this, ...)
		for i = 1, #this.Tooltips do
			if self.db.profile.Tooltips.skin then
				if self.db.profile.Tooltips.style == 3 and not self.skinned[this.Tooltips[i]] then
					this.Tooltips[i]:SetBackdrop(self.Backdrop[1])
				end
				self:skinTooltip(this.Tooltips[i])
			end
		end
	end)

-->>--	Outfitter Frame
	self:SecureHook(OutfitterFrame, "Show", function(this, ...)
		self:Unhook(OutfitterFrame, "Show")
		self:getChild(OutfitterFrame, 8):SetAlpha(0) -- hide band on the left
		self:skinButton{obj=OutfitterCloseButton, cb2=true, x1=6, y1=-6, x2=-6, y2=6} -- due to frame level & strata being changed we pretend it's not a proper close button
		self:skinButton{obj=OutfitterNewButton, as=true}
		self:addSkinFrame{obj=OutfitterFrame, kfs=true, bg=true, y1=2, x2=2, y2=-2, nb=true}
	end)

-->>--	Main Frame
	self:keepRegions(OutfitterMainFrame, {2, 3}) -- N.B. region 2 is text, 3 is background texture
	self:removeRegions(OutfitterMainFrameScrollbarTrench)
	self:keepFontStrings(OutfitterMainFrameScrollFrame)
	self:skinScrollBar(OutfitterMainFrameScrollFrame)
	-- m/p buttons
	for i = 0, Outfitter.cMaxDisplayedItems - 1 do
		local iBtn = "OutfitterItem"..i
		self:skinButton{obj=_G[iBtn.."CategoryExpand"], mp=true} -- treat as a texture
		self:SecureHook(_G[iBtn.."CategoryExpand"], "SetNormalTexture", function(this, nTex)
			self:checkTex{obj=this, nTex=nTex}
		end)
	end

-->>--	Outfitter Tabs
	for i = 1, #Outfitter.cPanelFrames do
		local tabName = _G["OutfitterFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		-- nil out the OnShow script to stop the tabs being resized
		tabName:SetScript("OnShow", nil)
		tabName:SetWidth(tabName:GetTextWidth() + 30)
		_G[tabName:GetName().."HighlightTexture"]:SetWidth(tabName:GetTextWidth() + 30)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject{obj=tabName, y=4}
			self:setActiveTab(tabName)
		else
			self:moveObject{obj=tabName, x=-10}
			self:setInactiveTab(tabName)
		end
	end

-->>--	New Outfit Panel
	self:SecureHook(Outfitter.NameOutfitDialog, "Show", function(this)
		self:Unhook(Outfitter.NameOutfitDialog, "Show")
		self:skinEditBox{obj=this.Name, regs={9, 15, 16}}
		self:moveObject{obj=this.Title, y=-6}
		skinDropDown(this.ScriptMenu)
		self:applySkin{obj=this.InfoSection}
		self:applySkin{obj=this.BuildSection}
		self:applySkin{obj=this.StatsSection}
		local msc = this.MultiStatConfig
		skinMultiStats(msc)
		self:skinButton{obj=msc.AddStatButton, as=true}
		self:SecureHook(msc, "SetNumConfigLines", function(this2, ...)
			skinMultiStats(this2)
		end)
		self:skinButton{obj=this.CancelButton, as=true}
		self:skinButton{obj=this.DoneButton, as=true}
		self:applySkin{obj=this, kfs=true} -- apply skin as title is hidden on redisplay
	end)
-->>--	Rebuild Outfit Panel
	self:SecureHook(Outfitter.RebuildOutfitDialog, "Show", function(this)
		self:Unhook(Outfitter.RebuildOutfitDialog, "Show")
		self:moveObject{obj=this.Title, y=-6}
		self:applySkin{obj=this.StatsSection}
		local msc = this.MultiStatConfig
		skinMultiStats(msc)
		self:skinButton{obj=msc.AddStatButton, as=true}
		self:SecureHook(msc, "SetNumConfigLines", function(this2, ...)
			skinMultiStats(this2)
		end)
		self:skinButton{obj=this.CancelButton, as=true}
		self:skinButton{obj=this.DoneButton, as=true}
		self:applySkin{obj=this, kfs=true} -- apply skin as title is hidden on redisplay
	end)

-->>--	ChooseIcon Dialog
	self:getChild(OutfitterChooseIconDialog, 1):SetBackdrop(nil) -- remove textures from anonymous frame
	self:skinDropDown{obj=OutfitterChooseIconDialogIconSetMenu}
	self:skinEditBox{obj=OutfitterChooseIconDialogFilterEditBox, regs={6}}
	self:skinScrollBar{obj=OutfitterChooseIconDialogScrollFrame}
	self:addSkinFrame{obj=OutfitterChooseIconDialog, x1=12, y1=-12, x2=-16, y2=16}

-->>--	EditScript Dialog
	if OutfitterEditScriptDialog then
		self:skinDropDown{obj=OutfitterEditScriptDialogPresetScript}
		self:keepFontStrings(OutfitterEditScriptDialogSourceScript)
		self:skinScrollBar{obj=OutfitterEditScriptDialogSourceScript, noRR=true}
		self:addSkinFrame{obj=OutfitterEditScriptDialog, kfs=true, x2=1, y2=-5}
		-- Tabs
		for i = 1, OutfitterEditScriptDialog.numTabs do
			local tabObj = _G["OutfitterEditScriptDialogTab"..i]
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
			self:SecureHook(OutfitterEditScriptDialog, "SetPanelIndex",function(...)
				for i = 1, OutfitterEditScriptDialog.numTabs do
					local tabSF = self.skinFrame[_G["OutfitterEditScriptDialogTab"..i]]
					if i == OutfitterEditScriptDialog.selectedTab then
						self:setActiveTab(tabSF)
					else
						self:setInactiveTab(tabSF)
					end
				end
			end)
		end
	end

-->>-- QuickSlots frame
	self:SecureHook(Outfitter, "InitializeQuickSlots", function()
		self:Unhook(Outfitter, "InitializeQuickSlots")
		self:addSkinFrame{obj=Outfitter.QuickSlots, kfs=true, x2=-3, y2=3}
		Outfitter.QuickSlots.HideBackground = true
	end)

-->>-- Outfit Bars
	self:ScheduleTimer(skinOutfitBars, 1, Outfitter.OutfitBar) -- wait for a second before skinning the Outfit Bars

-->>-- Character panel buttons
	self:skinButton{obj=OutfitterEnableAll}
	self:skinButton{obj=OutfitterEnableNone}

end
