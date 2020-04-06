if not Skinner:isAddonEnabled("beql") then return end

function Skinner:beql()
	if not self.db.profile.QuestLog then return end

	-- do nothing if only using simple QuestLog
	if beql.db.profile.QuestLog.style == "simple" then return end

	-- skin buttons on QL frame
	self:removeRegions(beqlQuestLogCollapseAllButton, {7, 8, 9})
	self:skinButton{obj=beqlQuestLogCollapseAllButton, mp=true}
	self:SecureHook(beql, "Hooks_QuestLog_Update", function(this)
		self:checkTex(beqlQuestLogCollapseAllButton)
	end)
	self:adjHeight{obj=beqlQuestLogFrameConfigButton, adj=-4}
	-- minimize button
	self:skinButton{obj=beqlQuestLogFrameMinimizeButton, ob="_"}

	-- History Frame
	if self.modBtns then
		local function qlUpd()

			for i = 1, #beqlHistoryFrameCharlistScrollFrame.buttons do
				Skinner:checkTex(beqlHistoryFrameCharlistScrollFrame.buttons[i])
			end
			for i = 1, #beqlHistoryFrameQuestScrollFrame.buttons do
				Skinner:checkTex(beqlHistoryFrameQuestScrollFrame.buttons[i])
			end

		end
		-- hook these to manage changes to button textures
		self:SecureHook(beql, "UpdateBrwoserCharList", function()
			qlUpd()
		end)
		self:SecureHook(beql, "UpdateBrowserQuestList", function()
			qlUpd()
		end)
	end

	self:moveObject{obj=beqlHistoryFrameTitleText, y=-6}
	self:skinScrollBar{obj=beqlHistoryFrameCharlistScrollFrame}
	-- skin minus/plus buttons
	for i = 1, #beqlHistoryFrameCharlistScrollFrame.buttons do
		self:skinButton{obj=beqlHistoryFrameCharlistScrollFrame.buttons[i], mp=true, plus=true}
	end
	self:skinScrollBar{obj=beqlHistoryFrameQuestScrollFrame}
	-- skin minus/plus buttons
	for i = 1, #beqlHistoryFrameQuestScrollFrame.buttons do
		self:skinButton{obj=beqlHistoryFrameQuestScrollFrame.buttons[i], mp=true, plus=true}
	end
	self:addSkinFrame{obj=beqlHistoryFrame, kfs=true}

-->>-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then beqlQuestWatchFrame.Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(beqlQuestWatchFrame.Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then beqlAchievementWatchFrame.Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(beqlAchievementWatchFrame.Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end
-->>-- Watch frames
	if self.db.profile.WatchFrame then
		-- QuestWatch frame
		self:addSkinFrame{obj=beqlQuestWatchFrame.TitleFrame}
		self:addSkinFrame{obj=beqlQuestWatchFrame.Backdrop, y1=-2, y2=2}
		-- AchievementWatch frame
		self:addSkinFrame{obj=beqlAchievementWatchFrame.TitleFrame}
		self:addSkinFrame{obj=beqlAchievementWatchFrame.Backdrop, y1=-2}
		beql:AchievementTrackermaximize(beqlAchievementWatchFrame.TitleFrame.Minimize) -- force redraw
	end

end
