if not Skinner:isAddonEnabled("tomQuest2") then return end

function Skinner:tomQuest2()

	local tq2 = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true)

	local ver = GetAddOnMetadata("tomQuest2", "Version")
--	self:Debug("tq2 ver: [%s]", ver)
	if ver == "3.3 beta 5" then self:tq233beta5(tq2) end

	-- tested against ver. 299

	local prdb = tq2.db.profile
	local function changeDefaults(objName)

		prdb[objName].bgTexture = self.db.profile.BdTexture
		prdb[objName].borderTexture = self.db.profile.BdBorderTexture
		prdb[objName].borderInset = self.db.profile.BdInset
		prdb[objName].borderWidth = self.db.profile.BdEdgeSize
		prdb[objName].backDropColor = CopyTable(self.bColour)
		prdb[objName].borderColor = CopyTable(self.bbColour)
		if objName == "achievementsTracker" then
			prdb[objName].statusBarTexture = self.db.profile.StatusBar.texture
			prdb[objName].defaultStatusBarColor = CopyTable(self.sbColour)
		end

	end

	-- skin the tooltip if required
	if self.db.profile.Tooltips.skin then
		changeDefaults("questsTooltip")
		self:skinSlider{obj=tomQuest2QuestsTooltip.slider, size=4}
		self:addSkinFrame{obj=tomQuest2QuestsTooltip}
	end
	-- skin the Quest & Achievement Trackers if required
	if self.db.profile.WatchFrame then
		changeDefaults("questsTracker")
		self:skinSlider{obj=tomQuest2QuestsTracker.slider, size=4}
		self:addSkinFrame{obj=tomQuest2QuestsTracker}
		changeDefaults("achievementsTracker")
		self:skinSlider{obj=tomQuest2AchievementsTracker.slider, size=4}
		self:addSkinFrame{obj=tomQuest2AchievementsTracker}
	end

	local tq2Evt
	local function skinParentFrame()

		if tomQuest2ParentFrame
		and tomQuest2ParentFrame.ql.share
		then
			Skinner:CancelTimer(tq2Evt, true)
			tq2Evt = nil
			-- skin the Parent frame and its sub panels
			-- Parent Frame
			self:addSkinFrame{obj=tomQuest2ParentFrame, x1=3, y1=-3, x2=-3, y2=3}
			-- Quest Log sub panel
			self:moveObject{obj=tomQuest2ParentFrame.ql.title, y=-5}
			self:skinScrollBar{obj=tomQuest2ParentFrame.ql.scroll}
			if LightHeaded then
				-- LightHeaded sub panel
				self:moveObject{obj=tomQuest2ParentFrame.lh.title, y=-5}
				self:skinScrollBar{obj=tomQuest2ParentFrame.lh.scroll}
			end
		end

	end

	-- setup a timer to check for frame being created
	if tomQuest2.moduleState["informations"]
	and not tomQuest2ParentFrame
	then
		tq2Evt = self:ScheduleRepeatingTimer(skinParentFrame, 0.5)
	end

	--[=[
		TODO QuestLevel text colour & minus/plus buttons
			they became local functions in the last alpha :(
	--]=]

end

function Skinner:tq233beta5(tq2) -- 3.3 beta 5

	local qTrkr = tq2:GetModule("questsTracker", true)
	local aTrkr = tq2:GetModule("achievementTracker", true)
	-- hook this to handle collapse buttons
	if self.modBtns then
		self:RawHook(tq2, "getCollapseButton", function(this)
			local btn = self.hooks[this].getCollapseButton(this)
--			self:Debug("getCollapseButton: [%s]", btn)
			if not self:IsHooked(btn.iconTexture, "SetTexture") then
				self:RawHook(btn.iconTexture, "SetTexture", function(this, iconTex)
--					self:Debug("SetTexture: [%s, %s, %s]", btn, this, iconTex)
					self.hooks[this].SetTexture(this, iconTex)
					this:SetAlpha(1) -- show texture
					if not iconTex:find("Icons") then -- it's a m/p button
						if not btn.skin then self:skinButton{obj=btn, mp3=true} end
						this:SetAlpha(0)
						if iconTex:find("MinusButton") then
							btn:SetText(self.modBtns.minus)
						elseif iconTex:find("PlusButton") then
							btn:SetText(self.modBtns.plus)
						end
					end
				end, true)
			end
			return btn
		end, true)
		self:SecureHook(tq2, "recycleButton", function(this, btn)
--			self:Debug("recycleButton: [%s, %s, %s]", this, btn, btn.type)
			if btn.type == "collapse" then
				btn:SetText("")
				btn:SetBackdrop(nil)
				btn:SetBackdropColor(nil)
				btn:SetBackdropBorderColor(nil)
				if btn.tfade then btn.tfade:SetTexture(nil) end
				btn.skin = nil
			end
		end)
		-- force existing buttons to be skinned
		if qTrkr then
			qTrkr:updateQuestsTracker() -- force update
		end
		if aTrkr then
			aTrkr:updateAchievementTracker() -- force update
		end
	end

	-- Parent Frame
	local info = tq2:GetModule("informations", true)
	if info then
		self:SecureHook(info, "createLhGUI", function(this)
			self:moveObject{obj=tomQuest2LhFrame.title, y=-5}
			self:skinScrollBar{obj=tomQuest2LhScrollFrame}
			self:addSkinFrame{obj=tomQuest2LhFrame, x1=3, y1=-3, x2=-3, y2=3}
			self:Unhook(info, "createLhGUI")
		end)
		self:SecureHook(info, "createQlGUI", function(this)
			self:moveObject{obj=tomQuest2QlFrame.title, y=-5}
			self:skinScrollBar{obj=tomQuest2QlScrollFrame}
			self:addSkinFrame{obj=tomQuest2QlFrame, x1=3, y1=-3, x2=-3, y2=3}
			self:Unhook(info, "createQlGUI")
		end)
		self:SecureHook(info, "lockUnlockQlFrame", function()
			if tomQuest2ParentFrame then
				self:addSkinFrame{obj=tomQuest2ParentFrame}
				-- hook these to show/hide the individual skinFrames
				self:SecureHook(tomQuest2ParentFrame, "Show", function()
					self.skinFrame[tomQuest2LhFrame]:Hide()
					self.skinFrame[tomQuest2QlFrame]:Hide()
				end)
				self:SecureHook(tomQuest2ParentFrame, "Hide", function()
					self.skinFrame[tomQuest2LhFrame]:Show()
					self.skinFrame[tomQuest2QlFrame]:Show()
				end)
				self:Unhook(info, "lockUnlockQlFrame")
			end
		end)

		info.db.profile.backDropColor = CopyTable(self.bColour)
		info.db.profile.borderColor = CopyTable(self.bbColour)
	end

	-- find the tracker anchors and skin them
	if qTrkr or aTrkr then
		for _, child in pairs{UIParent:GetChildren()} do
			if child:IsObjectType("Button")
			and child:GetName() == nil
			then
				if floor(child:GetHeight()) == 24 and child:GetFrameStrata() == "MEDIUM" then
					local r, g, b, a = child:GetBackdropColor()
					if  ("%.2f"):format(r) == "0.09"
					and ("%.2f"):format(g) == "0.09"
					and ("%.2f"):format(b) == "0.19"
					and ("%.1f"):format(a) == "0.5"
					then
						self:addSkinFrame{obj=child, x1=-2, x2=2} -- tracker anchor frame
					end
				end
			end
		end
	end

	-- skin the Quest & Achievement Trackers if required
	if self.db.profile.WatchFrame then
		if qTrkr then
			qTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			qTrkr.db.profile.borderColor = CopyTable(self.bbColour)
		end
		if aTrkr then
			aTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			aTrkr.db.profile.borderColor = CopyTable(self.bbColour)
			aTrkr.db.profile.statusBarTexture = self.db.profile.StatusBar.texture
			aTrkr:updateAchievementTracker() -- force update
		end
	else
		-- if LibQTip skin is loaded then flag them to be ignored
		if self.ignoreLQTT then
			self.ignoreLQTT["tomQuest2Tracker"] = true
			self.ignoreLQTT["tomQuest2Achievements"] = true
		end
	end

	local qG = tq2:GetModule("questsGivers", true)
	if qG then
		-- hook this to change text colour before level number added
		self:RawHook(qG, "QUEST_GREETING", function(this)
			for i = 1, MAX_NUM_QUESTS do
				local text = self:getRegion(_G["QuestTitleButton"..i], 3)
				text:SetTextColor(self.BTr, self.BTg, self.BTb)
			end
			self.hooks[qG].QUEST_GREETING(this)
		end, true)
	end

end
