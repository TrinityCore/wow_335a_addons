if not SimpleSelfRebuff then return end
local SimpleSelfRebuff = SimpleSelfRebuff

local Reminder = SimpleSelfRebuff:NewModule("Reminder", "LibSink-2.0", "AceTimer-3.0", "AceBucket-3.0")

-- Really load module when first enabled
function Reminder:OnEnable()

	-------------------------------------------------------------------------------
	-- Externals
	-------------------------------------------------------------------------------

	local L = SimpleSelfRebuff.L

	local new = SimpleSelfRebuff.new
	local del = SimpleSelfRebuff.del
	local formatDuration = SimpleSelfRebuff.formatDuration
	local colorize = SimpleSelfRebuff.colorize

	local STATE_SET      = SimpleSelfRebuff.STATE_SET
	local STATE_FOUND    = SimpleSelfRebuff.STATE_FOUND
	local STATE_EXPIRING = SimpleSelfRebuff.STATE_EXPIRING
	local STATE_QUIET    = SimpleSelfRebuff.STATE_QUIET
	local STATE_DONTCAST = SimpleSelfRebuff.STATE_DONTCAST

	local bit_band = bit.band
	local bit_bor = bit.bor

	-------------------------------------------------------------------------------
	-- Locals
	-------------------------------------------------------------------------------

	local db

	local reminderDests = {}
	local states
	local lastRemindTime

	local remindAllEvents = {
		'PLAYER_UNGHOST',
		'PLAYER_REGEN_ENABLED',
		'PLAYER_CONTROL_GAINED'
	}

	local REMIND_COOLDOWN = 20

	-------------------------------------------------------------------------------
	-- Option declaration
	-------------------------------------------------------------------------------

	local function getReminderColor(info)
		local c = db.colors[info.arg]
		return c.r, c.g, c.b
	end

	local function setReminderColor(info, r, g, b)
		local c = db.colors[info.arg]
		c.r, c.g, c.b = r, g, b
	end

	function Reminder:OnEnable(first)
		self:RegisterSignal('StateChanged', 'UpdateState')
		self:RegisterBucketEvent(remindAllEvents, 1, 'RemindAll')

		lastRemindTime = new()
		states = new()
		for category, state, expected, actual, timeLeft in self.core:IterateCategories(STATE_SET) do
			self:UpdateState('ModuleEnabled', category, state, expected, actual, timeLeft)
		end
	end

	function Reminder:OnDisable()
		self.remindAllTimer = nil
		states = del(states)
		lastRemindTime = del(lastRemindTime)
		self:UnregisterAllSignals(self)
	end

	local function getStateLevel(state)
		if bit_band(state, STATE_SET) == 0 then
			return 0
		elseif bit_band(state, STATE_FOUND) == 0 then
			return 3
		elseif bit_band(state, STATE_EXPIRING) ~= 0 then
			return 2
		else
			return 1
		end
	end

	function Reminder:UpdateState(event, category, newState, expected, actual, timeLeft)
		if newState ~= states[category] then
			local newLevel = getStateLevel(newState or 0)
			lastRemindTime[category] = nil
			if newLevel > 1 and newLevel > getStateLevel(states[category] or 0) then
				-- Warn at least once
				self:PrintMessage(expected, timeLeft)
			end
			states[category] = newState
		end
		if next(states) then
			if not self.remindAllTimer then
				self.remindAllTimer = self:ScheduleRepeatingTimer('RemindAll', REMIND_COOLDOWN/4)
			end
		else
			if self.remindAllTimer then
				self:CancelTimer(self.remindAllTimer, true)
				self.remindAllTimer = nil
			end
		end
	end

	function Reminder:RemindAll()
		if UnitOnTaxi('player') or InCombatLockdown() then
			return
		end
		for category in pairs(states) do
			local state, expected, actual, timeLeft = category:GetState()
			if getStateLevel(state) > 1 and bit_band(state, STATE_QUIET) == 0 then
				self:PrintMessage(expected, timeLeft)
			end
		end
	end

	function Reminder:PrintMessage(buff, timeLeft)
		if not buff or not self.core:IsMonitoringActive() or UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then
			return
		end
		local lastTime, now = lastRemindTime[buff.category], GetTime()
		if lastTime and now - lastTime < REMIND_COOLDOWN then
			return
		end
		lastRemindTime[buff.category] = now
		local text, color
		if (timeLeft or 0) > 0 then
			text = L["%s expires in %s."]:format(buff.name, formatDuration(timeLeft))
			color = db.colors.refreshing
		else
			text = L["%s is missing."]:format(buff.name)
			color = db.colors.missing
		end
		self:Pour(text, color.r, color.g, color.b, nil, nil, nil, nil, nil, buff.texture)
	end

	function Reminder:FeedTooltip(tooltip)
		if not self.core:IsDebugging() then
			return
		end
		for category, state in self.core:IterateCategories(STATE_SET) do
			tooltip:AddDoubleLine(
				states[category] and self.core:fmtState(states[category]) or category.name,
				lastRemindTime[category] or '<never>'
			)
		end
	end

	-- Once loaded, initialize and enable
	self.db = self:RegisterNamespace({
		profile = {
			colors = {
				missing    = { r=0.9, g=0.2, b=0.2 },
				refreshing = { r=0.9, g=0.6, b=0.2 },
			},
			sink20 = {}
		}
	})
	db = self.db.profile
	self:SetSinkStorage(db.sink20)

	local options = 	{
		type = 'group',
		name = L["Reminder"],
		desc = L["Configure the reminder."],
		args = {
			colors = {
				type = 'group',
				name = 'Message colors',
				order = 100,
				inline = true,
				args = {
					missing = {
						type = 'color',
						name = L["Missing message"],
						desc = L["Set the color of the missing message."],
						get = getReminderColor,
						set = setReminderColor,
						arg = 'missing',
						order = 100,
					},
					refreshing = {
						type = 'color',
						name = L["Refreshing message"],
						desc = L["Set the color of the refreshing message."],
						get = getReminderColor,
						set = setReminderColor,
						arg = 'refreshing',
						disabled = function() return SimpleSelfRebuff.db.profile.rebuffThreshold == 0 end,
						order = 110,
					},
				},
			},
		},
	}

	options.args.output = self:GetSinkAce3OptionsDataTable()
	options.args.output.inline = true

	self:RegisterOptions(options)
	
	Reminder:OnEnable()
end
