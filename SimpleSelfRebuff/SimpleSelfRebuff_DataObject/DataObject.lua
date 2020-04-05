if not SimpleSelfRebuff then return end
local SimpleSelfRebuff = SimpleSelfRebuff

local DataObject = SimpleSelfRebuff:NewModule("DataObject")

-- Do not load before we are enabled
function DataObject:OnEnable()

	local L = SimpleSelfRebuff.L

	local colorize = SimpleSelfRebuff.colorize
	local formatDuration = SimpleSelfRebuff.formatDuration

	local STATE_SET      = SimpleSelfRebuff.STATE_SET
	local STATE_FOUND    = SimpleSelfRebuff.STATE_FOUND
	local STATE_EXPIRING = SimpleSelfRebuff.STATE_EXPIRING
	local STATE_QUIET    = SimpleSelfRebuff.STATE_QUIET
	local STATE_DONTCAST = SimpleSelfRebuff.STATE_DONTCAST

	local bit_band = bit.band
	local bit_bor = bit.bor

	-------------------------------------------------------------------------------
	-- Helpers
	-------------------------------------------------------------------------------

	local function GetBuffInfo(category, state, expected, actual, timeLeft)
		if bit_band(state or 0, STATE_SET) == 0 then
			return nil
		elseif bit_band(state, STATE_DONTCAST) ~= 0 then
			return expected.name, L["Ignored"], 1, 0.5, 0
		elseif bit_band(state, STATE_FOUND) == 0 then
			return expected.name, L["Missing"], 1, 0, 0
		else
			timeLeft = formatDuration(timeLeft, "-")
			if expected == actual then
				return actual.name, timeLeft, 0, 1, 0
			else
				return actual.name, timeLeft, 1, 1, 0
			end
		end
	end

	-------------------------------------------------------------------------------
	-- DataObject attributes and methods
	-------------------------------------------------------------------------------

	local DEFAULT_ICON = 'Interface\\Icons\\Spell_Holy_LayOnHands'

	local object = {
		label = SimpleSelfRebuff.name,
		icon = DEFAULT_ICON,
	}

	function object.OnClick()
		SimpleSelfRebuff:OpenGUI()
	end

	function object.OnTooltipShow(tooltip)
		tooltip:AddLine(object.label, 1, 1, 1)
		for name, module in SimpleSelfRebuff:IterateModules() do
			if module:IsEnabled() and type(module.FeedTooltip) == 'function' then
				if SimpleSelfRebuff:IsDebugging() then
					tooltip:AddLine('-- '..module:GetName()..' --', 1, 1, 1)
				end
				module:FeedTooltip(tooltip)
			end
		end
	end

	function DataObject:OnEnable()
		self:RegisterSignal('DisplayChanged', 'Update')
		self:RegisterSignal('StateChanged', 'Update')
		self:Update()
	end

	function DataObject:Update()
		local textWeight, text = 0, nil
		local iconWeight, icon = 0, DEFAULT_ICON
		for name, module in self.core:IterateModules() do
			if module:IsEnabled() and type(module.FeedDataObject) == 'function' then
				local modWeight, modText, modIcon = module:FeedDataObject()
				if modWeight then
					self:Debug('%s: weight=%s, text=%q icon=%q', module:GetName(), modWeight, modText, modIcon)
					if modText and modWeight > textWeight then
						textWeight, text = modWeight, modText
					end
					if modIcon and modWeight > iconWeight then
						iconWeight, icon = modWeight, modIcon
					end
				end
			end
		end
		self:Debug('Finally: text=%q (%s), icon=%q (%s)', text, textWeight, icon, iconWeight)
		object.text = text
		object.icon = icon
	end

	function DataObject:FeedTooltip(tooltip)
		if not self.core:IsMonitoringActive() then
			tooltip:AddLine(L["Currently inactive (resting/dead)."])
			return
		end

		for category, state, expected, actual, timeLeft in self.core:IterateCategories(STATE_SET) do
			local name, timeLeft, r, g, b = GetBuffInfo(category, state, expected, actual, timeLeft)
			if self.core:IsDebugging() then
				timeLeft = ("state=%s, expected=%s, actual=%s, timeLeft=%s"):format(
					tostring(self.core:fmtState(state)),
					tostring(expected and expected.name),
					tostring(actual and actual.name),
					tostring(timeLeft)
				)
				name = name or "-"
			end
			if name then
				tooltip:AddDoubleLine(name, timeLeft, r,g,b, r,g,b)
			end
		end
	end

	-- Once loaded, initialize and enable
	object = LibStub('LibDataBroker-1.1'):NewDataObject('SimpleSelfRebuff', object)
	self:OnEnable()
end
