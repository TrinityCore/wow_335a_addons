if not SimpleSelfRebuff then return end
local SimpleSelfRebuff = SimpleSelfRebuff

local CastBinding = SimpleSelfRebuff:NewModule('CastBinding')

-- Really load module when first enabled
function CastBinding:OnEnable()

	-------------------------------------------------------------------------------
	-- Externals
	-------------------------------------------------------------------------------

	local L = SimpleSelfRebuff.L

	local STATE_SET      = SimpleSelfRebuff.STATE_SET
	local STATE_FOUND    = SimpleSelfRebuff.STATE_FOUND
	local STATE_EXPIRING = SimpleSelfRebuff.STATE_EXPIRING
	local STATE_QUIET    = SimpleSelfRebuff.STATE_QUIET
	local STATE_DONTCAST = SimpleSelfRebuff.STATE_DONTCAST

	local bit_band = bit.band
	local bit_bor = bit.bor

	local STATE_CASTABLE_MASK  = bit_bor(STATE_SET, STATE_DONTCAST)
	local STATE_CASTABLE_VALUE = STATE_SET

	local new = SimpleSelfRebuff.new
	local del = SimpleSelfRebuff.del

	-------------------------------------------------------------------------------
	-- Locals
	-------------------------------------------------------------------------------

	local db

	local button
	local TEH_BUTTON_NAME = "SimpleSelfRebuffButton"

	local pendingBuff
	local boundBuff

	local bindingKeys = {}
	
	local changedAttributes = {}

	function CastBinding:OnEnable()

		self:RegisterSignal('MonitoringEnabled', 'UpdateBinding')
		self:RegisterSignal('StateChanged', 'UpdateBinding')
		self:RegisterEvent('PLAYER_CONTROL_GAINED', 'UpdateBinding')
		self:RegisterEvent('PLAYER_REGEN_ENABLED', 'UpdateBinding')
		self:RegisterEvent('PLAYER_REGEN_DISABLED', 'SetBinding', false)
		self:RegisterSignal('MonitoringDisabled', 'SetBinding', false)

		self:KeyBindingChanged()

		self:UpdateBinding()
	end
	
	function CastBinding:OnDisable()
		self:SetBinding(false)
		self:UnregisterAllSignals(self)		
	end

	function CastBinding:Bind()
		if button and boundBuff then
			for i,key in ipairs(bindingKeys) do
				SetOverrideBindingClick(button, true, key, TEH_BUTTON_NAME, key)
			end
		end
	end

	function CastBinding:Unbind()
		if button then
			ClearOverrideBindings(button)
		end
	end

	function CastBinding:KeyBindingChanged()
		self:Unbind()
		bindingKeys = del(bindingKeys)
		if db.mousewheel then
			bindingKeys = new("MOUSEWHEELUP", "MOUSEWHEELDOWN", "SHIFT-MOUSEWHEELUP", "SHIFT-MOUSEWHEELDOWN")
		else
			bindingKeys = new()
		end
		if db.keybinding then
			tinsert(bindingKeys, db.keybinding)
		end
		self:Bind()
	end

	local function checkBuffStatus(buff)
		if not buff or not buff:IsUsable() then
			return nil
		end
		local state, timeLeft = buff:GetState()
		if bit_band(state, STATE_SET) == 0 or bit_band(state, STATE_DONTCAST) ~= 0 then
			-- Unset or ignored buff
			return nil
		elseif bit_band(state, STATE_FOUND) == 0 then
			-- Missing buff
			return buff, 1, state, nil
		elseif bit_band(state, STATE_EXPIRING) ~= 0 then
			-- Expiring buff
			return buff, 0, state, timeLeft
		else
			-- Buff is ok
			return nil
		end
	end

	function CastBinding:UpdateBinding()
		self:Debug('updating binding');
		if self.core:IsMonitoringActive() then

			local pendingPriority, pendingState, pendingTimeLeft
			if pendingBuff then
				pendingBuff, pendingPriority, pendingState, pendingTimeLeft = checkBuffStatus(pendingBuff)
			end

			for category, state, expected, actual, timeLeft in self.core:IterateCategories(STATE_SET) do
				local expected, priority, state, timeLeft = checkBuffStatus(expected)
				if expected then
					if
						not pendingBuff
						or (priority > pendingPriority)
						or (priority == pendingPriority and timeLeft and pendingTimeLeft and timeLeft < pendingTimeLeft)
					then
						pendingBuff, pendingPriority, pendingState, pendingTimeLeft = expected, priority, state, timeLeft
					end
				end
			end

			self:Debug('pendingBuff=%q, prio=%q, state=%q, timeLeft=%q', pendingBuff, pendingPriority, pendingState, pendingTimeLeft)

			self:SetBinding(pendingBuff)
		else
			self:SetBinding(false)
		end
		self:SendSignal('DisplayChanged')
	end

	function CastBinding:SetBinding(buff)
		if InCombatLockdown() then return end
		if buff then
			if not button then
				button = CreateFrame("Button", TEH_BUTTON_NAME, UIParent, "SecureActionButtonTemplate")
				button:RegisterForClicks("LeftButtonUp")
				button:SetPoint("CENTER",0,0)
				button:SetScript("PreClick", function(...) return self:OnButtonPreClick(...) end)
				button:SetScript("PostClick", function(...) return self:OnButtonPostClick(...) end)
				button:SetScript("OnAttributeChanged", function(...) return self:OnButtonAttributeChanged(...) end)
				button:Hide()
				self:ClearButtonAttributes()
			end
			-- Binding
			boundBuff = buff
			self:Bind()
			self:Debug('Bound buff: '..boundBuff.name)
		else
			boundBuff = nil
			self:ClearButtonAttributes()
			self:Unbind()
		end
	end

	function CastBinding:OnButtonPreClick()
		if InCombatLockdown() then return end
		self:Debug('OnButtonPreClick-START')
		if boundBuff then
			if not boundBuff:IsInCooldown() and boundBuff:IsUsable() then
				self:Debug('Setting up casting for '..boundBuff.name)
				boundBuff:SetupSecureButton(button)
			else
				self:Debug(boundBuff.name.." in cooldown or not usable")
				--self:ClearButtonAttributes()
			end
		else
			self:Debug("No bound buff")
			--self:ClearButtonAttributes()
		end
		self:Debug('OnButtonPreClick-END')
	end

	function CastBinding:OnButtonPostClick(button, key)
		if db.zoom then
			if key:match('MOUSEWHEELUP') then
				CameraZoomIn(1)
			elseif key:match('MOUSEWHEELDOWN') then
				CameraZoomOut(1)
			end
		end
		if InCombatLockdown() then return end
		self:ClearButtonAttributes()
	end

	function CastBinding:OnButtonAttributeChanged(button, name, value)
		if value == nil then
			changedAttributes[name] = nil
			self:Debug('Button attribute %q cleansed', name)
		else
			changedAttributes[name] = true
			self:Debug('Button attribute %q set to %q', name, value)
		end
	end

	function CastBinding:ClearButtonAttributes()
		if button and next(changedAttributes) then
			self:Debug('Clearing up binding button')
			for name in pairs(changedAttributes) do
				button:SetAttribute(name, nil)
			end
		end
	end

	function CastBinding:DummyBinding()
		self:Debug("Do nothing")
	end

	function CastBinding:FeedDataObject()
		if pendingBuff then
			return 10, pendingBuff.name, pendingBuff.texture
		end
	end

	local attrs = { "type", "target-slot", "unit", "spell" }
	function CastBinding:FeedTooltip(tooltip)
		if not self.core:IsDebugging() then
			return
		end
		tooltip:AddDoubleLine('pendingBuff:', tostring(pendingBuff and pendingBuff.name))
		if pendingBuff then
			tooltip:AddDoubleLine('pendingBuff:IsUsable():', tostring(not not pendingBuff:IsUsable()))
		end
		tooltip:AddDoubleLine('boundBuff:', tostring(boundBuff and boundBuff.name))
		if boundBuff then
			tooltip:AddDoubleLine('boundBuff:IsUsable():', tostring(not not boundBuff:IsUsable()))
		end
		tooltip:AddDoubleLine('isBound:', tostring(not not isBound))
		tooltip:AddDoubleLine('IsMonitoringActive:',tostring(not not self.core:IsMonitoringActive()))
		tooltip:AddDoubleLine('button:', tostring(button))

		if button then
			for i,name in ipairs(attrs) do
				tooltip:AddDoubleLine('button-'..name..':', tostring(button:GetAttribute(name)))
			end
		end
	end

	-- Once loaded, initialize and enable
	self.db = self:RegisterNamespace({
		profile = {
			mousewheel = true,
			zoom = true,
			keybindin
		}
	})
	db = self.db.profile
	
	-- Setup options
	self:RegisterOptions({
		name = L['Cast bindings'],
		type = 'group',
		args = {
			mousewheel = {
				order = 100,
				width = 'double',
				type = 'toggle',
				name = L["Enable mousewheel binding"],
				desc = L["Allow SimpleSelfRebuff to bind buff casting to the mousewheel."],
				get = function() return db.mousewheel end,
				set = function(info, v) 
					db.mousewheel = v 
					self:KeyBindingChanged()
				end,
			},
			zoom = {
				order = 110,
				type = 'toggle',
				name = L["Zoom when casting"],
				desc = L["Enable zooming when using the mousewheel to cast."],
				get = function() return db.zoom end,
				set = function(info, v) db.zoom = v end,
				disabled = function() return not db.mousewheel end,
			},
			key = {
				order = 120,
				type = 'keybinding',
				name = L['Key binding'],
				get = function() return db.keybinding end,
				set = function(info, v)
					db.keybinding = v
					self:KeyBindingChanged()
				end
			},
			macroHelp = {
				order = 130,
				type = 'description',
				name = L['Notice: you can trigger SimpleSelfRebuff from a macro using the following code:\n\n/click %s']:format(TEH_BUTTON_NAME),
			},
		}
	})

	self:OnEnable()
end
