if not Skinner:isAddonEnabled("QuestGuru") then return end

function Skinner:QuestGuru()
	if not self.db.profile.QuestLog then return end

	-- LightHeaded support
	if IsAddOnLoaded("LightHeaded") then
		self:moveObject{obj=LightHeadedFrame, x=-55}
		self:RawHook(LightHeadedFrame, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
--			self:Debug("LHF_SP: [%s, %s, %s, %s, %s, %s, %s]", point, relTo, relPoint, xOfs, yOfs, relTo == QuestGuru_QuestLogFrame, floor(xOfs) > -16)
			if relTo == QuestGuru_QuestLogFrame and floor(xOfs) > -56 then xOfs = -55 end
			self.hooks[this].SetPoint(this, point, relTo, relPoint, xOfs, yOfs)
		end, true)
	end

	local function colourText(type)
	
		local prefix = "QuestGuru_Quest"..type
		-- headers
		_G[prefix.."QuestTitle"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G[prefix.."DescriptionTitle"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G[prefix.."RewardTitleText"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G[prefix.."PlayerTitleText"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- others
		_G[prefix.."StartLabel"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."StartPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."StartNPCName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."FinishLabel"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."FinishPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."FinishNPCName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."FinishPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."ObjectivesText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."TimerText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."RequiredMoneyText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."SuggestedGroupNum"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."QuestDescription"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."ItemChooseText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."ItemReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."SpellLearnText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."HonorFrameReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prefix.."TalentFrameReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- XP text
		if type == "Log" then
			QuestGuru_QuestLogXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		if type == "History" then
			QuestGuru_QuestHistoryXPText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		-- Quest objectives
		for i = 1, MAX_OBJECTIVES do
			local r, g, b = _G[prefix.."Objective"..i]:GetTextColor()
			_G[prefix.."Objective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
	end
	-- m/p buttons
	if self.modBtns then
		-- hook to manage changes to button textures (Current Tab)
		self:SecureHook("QuestLog_Update", function()
			for i = 1, QUESTGURU_QUESTS_DISPLAYED do
				self:checkTex(_G["QuestGuru_QuestLogTitle"..i])
			end
		end)
		if IsAddOnLoaded("QuestGuru_History") then
			-- hook to manage changes to button textures (History Tab)
			self:SecureHook("QuestGuru_UpdateHistory", function()
				for i = 1, QUESTGURU_QUESTS_DISPLAYED do
					self:checkTex(_G["QuestGuru_QuestHistoryTitle"..i])
				end
			end)
		end
		-- hook to manage changes to button textures (Abandoned Tab)
		self:SecureHook("QuestGuru_UpdateAbandon", function()
			for i = 1, QUESTGURU_QUESTS_DISPLAYED do
				self:checkTex(_G["QuestGuru_QuestAbandonTitle"..i])
			end
		end)
	end
-->>-- Quest Log frame
	self:keepFontStrings(QuestGuru_QuestLogCount)
	self:keepFontStrings(QuestGuru_EmptyQuestLogFrame)
	self:skinFFToggleTabs("QuestGuru_QuestLogFrameTab", QUESTGURU_NUMTABS)
	self:moveObject{obj=QuestGuru_QuestLogFrameTab1, y=-10}
	QuestGuru_QuestLogFrameTab1.SetPoint = function() end -- stop it being moved again
	QuestGuru_QuestLogDummyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=QuestGuru_QuestLogFrame, kfs=true, x1=6, y1=-6, x2=-45, y2=14}
-->>-- Empty QuestLog frame
	QuestGuru_QuestLogNoQuestsText:SetTextColor(self.BTr, self.BTg, self.BTb)
-->>-- Tab1 (Current)
	self:SecureHook("QuestLog_UpdateQuestDetails", function(...)
		colourText("Log")
	end)
	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["QuestGuru_QuestLogTitle"..i], mp=true}
	end
	self:skinScrollBar{obj=QuestGuru_QuestLogListScrollFrame}
	self:skinScrollBar{obj=QuestGuru_QuestLogDetailScrollFrame}
-->>-- Tab2 (History)
	if IsAddOnLoaded("QuestGuru_History") then
		self:SecureHook("QuestLog_UpdateQuestHistoryDetails", function(...)
			colourText("History")
		end)
		self:skinEditBox{obj=QuestGuru_QuestHistorySearch, regs={9}}
		for i = 1, QUESTGURU_QUESTS_DISPLAYED do
			self:skinButton{obj=_G["QuestGuru_QuestHistoryTitle"..i], mp=true}
		end
		self:skinScrollBar{obj=QuestGuru_QuestHistoryListScrollFrame}
		self:skinScrollBar{obj=QuestGuru_QuestHistoryDetailScrollFrame}
		self:addSkinFrame{obj=QuestGuru_TabPage2, kfs=true, x1=10, y1=-6, x2=-45, y2=16}
	end
-->>-- Tab3 (Abandoned)
	self:SecureHook("QuestLog_UpdateQuestAbandonDetails", function(...)
		colourText("Abandon")
	end)
	self:skinEditBox{obj=QuestGuru_QuestAbandonSearch, regs={9}}
	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["QuestGuru_QuestAbandonTitle"..i], mp=true}
	end
	self:skinScrollBar{obj=QuestGuru_QuestAbandonListScrollFrame}
	self:skinScrollBar{obj=QuestGuru_QuestAbandonDetailScrollFrame}
-->>-- Tab4
-->>-- Tab5
-->>--	Tracker Frame(s)
	if IsAddOnLoaded("QuestGuru_Tracker") then
		if self.db.profile.WatchFrame then
			self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
			QGT_SetQuestWatchBorder = function() end
			self:addSkinFrame{obj=QGT_AchievementWatchFrame, kfs=true}
			QGT_SetAchievementWatchBorder = function() end
		end
		self:skinSlider(QGT_QuestWatchFrameSlider)
		self:skinSlider(QGT_AchievementWatchFrameSlider)
		-- glaze Achievement StatusBars
		for i = 1, 40 do
			local sBar = "QGT_AchievementWatchLine"..i.."StatusBar"
			if not self.sbGlazed[_G[sBar]] then
				self:removeRegions(_G[sBar], {3, 4, 5}) -- remove textures
				self:glazeStatusBar(_G[sBar], 0, _G[sBar.."BG"])
			end
		end
		-- Tooltips
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then
				QGT_AchievementWatchFrameTooltip:SetBackdrop(self.Backdrop[1])
				QGT_QuestWatchFrameTooltip:SetBackdrop(self.Backdrop[1])
			end
			self:SecureHook(QGT_AchievementWatchFrameTooltip, "Show", function()
				self:skinTooltip(QGT_AchievementWatchFrameTooltip)
			end)
			self:SecureHook(QGT_QuestWatchFrameTooltip, "Show", function()
				self:skinTooltip(QGT_QuestWatchFrameTooltip)
			end)
		end
	end

end
