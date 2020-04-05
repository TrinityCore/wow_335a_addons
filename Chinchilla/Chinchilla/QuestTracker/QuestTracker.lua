local Chinchilla = Chinchilla
local Chinchilla_QuestTracker = Chinchilla:NewModule("QuestTracker")
local self = Chinchilla_QuestTracker
local L = Chinchilla.L

Chinchilla_QuestTracker.desc = L["Tweak the quest tracker"]


local origTitleShow, origCollapseShow = WatchFrameTitle.Show, WatchFrameCollapseExpandButton.Show

function Chinchilla_QuestTracker:OnInitialize()
	self.db = Chinchilla.db:RegisterNamespace("QuestTracker", {
		profile = {
			showTitle = true,
			showCollapseButton = true,
			frameWidth = 204,
			frameHeight = 140,
		},
	})

	if not self.db.profile.enabled then
		self:SetEnabledState(false)
	end
end

function Chinchilla_QuestTracker:OnEnable()
	self:ToggleTitle()
	self:ToggleButton()

	WATCHFRAME_MAXLINEWIDTH = self.db.profile.frameWidth - 8
	WatchFrame:SetWidth(self.db.profile.frameWidth)
	WatchFrame:SetHeight(self.db.profile.frameHeight)
end

function Chinchilla_QuestTracker:OnDisable()
	WatchFrameTitle.Show = origTitleShow -- "unhook"
	WatchFrameTitle:Show()

	WatchFrameCollapseExpandButton.Show = origCollapseShow -- "unhook"
	WatchFrameCollapseExpandButton:Show()

	WATCHFRAME_MAXLINEWIDTH = 192
	WatchFrame:SetWidth(204)
	WatchFrame:SetHeight(140)
end


function Chinchilla_QuestTracker:ToggleTitle()
	if self.db.profile.showTitle then
		WatchFrameTitle.Show = origTitleShow -- "unhook"
		WatchFrameTitle:Show()
	else
		WatchFrameTitle:Hide()
		WatchFrameTitle.Show = WatchFrameTitle.Hide -- clearly not the best way, but it works and doesn't seem to cause taint
	end
end

function Chinchilla_QuestTracker:ToggleButton()
	if self.db.profile.showCollapseButton then
		WatchFrameCollapseExpandButton.Show = origCollapseShow -- "unhook"
		WatchFrameCollapseExpandButton:Show()
	else
		WatchFrameCollapseExpandButton:Hide()
		WatchFrameCollapseExpandButton.Show = WatchFrameCollapseExpandButton.Hide -- clearly not the best way, but it works and doesn't seem to cause taint
	end
end


Chinchilla_QuestTracker:AddChinchillaOption(function() return {
	name = L["Quest Tracker"],
	desc = Chinchilla_QuestTracker.desc,
	type = 'group',
	args = {
		showTitle = {
			name = L["Show title"],
			desc = L["Show the title of the quest tracker."],
			type = 'toggle',
			get = function(info) return self.db.profile.showTitle end,
			set = function(info, value)
				self.db.profile.showTitle = value
				self:ToggleTitle()
			end,
			order = 1,
		},
		showCollapseButton = {
			name = L["Show collapse button"],
			desc = L["Show the collapse button on the quest tracker."],
			type = 'toggle',
			get = function(info) return self.db.profile.showCollapseButton end,
			set = function(info, value)
				self.db.profile.showCollapseButton = value
				self:ToggleButton()
			end,
			order = 2,
		},
		frameWidth = {
			name = L["Width"],
			desc = L["Set the width of the quest tracker."],
			type = 'range',
			min = 204,
			max = floor(GetScreenWidth()),
			step = 1,
			bigStep = 5,
			get = function(info) return self.db.profile.frameWidth end,
			set = function(info, value)
				self.db.profile.frameWidth = value
				WatchFrame:SetWidth(value)
				WATCHFRAME_MAXLINEWIDTH = value - 8
			end,
			order = 3,
		},
		frameHeight = {
			name = L["Height"],
			desc = L["Set the height of the quest tracker."],
			type = 'range',
			min = 140,
			max = floor(GetScreenHeight()),
			step = 1,
			bigStep = 5,
			get = function(info) return self.db.profile.frameHeight end,
			set = function(info, value)
				self.db.profile.frameHeight = value
				WatchFrame:SetHeight(value)
			end,
			order = 4,
		},
	},
} end)
