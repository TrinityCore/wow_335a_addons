if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_CastBar requires PitBull4")
end
local L = PitBull4.L

local EXAMPLE_VALUE = 0.4
local EXAMPLE_ICON = [[Interface\Icons\Spell_Shadow_Teleport]]
local TEMP_ICON = [[Interface\Icons\Temp]]

local PitBull4_CastBar = PitBull4:NewModule("CastBar", "AceEvent-3.0")

PitBull4_CastBar:SetModuleType("bar")
PitBull4_CastBar:SetName(L["Cast bar"])
PitBull4_CastBar:SetDescription(L["Show a cast bar."])
PitBull4_CastBar:SetDefaults({
	size = 1,
	position = 10,
	show_icon = true,
	auto_hide = false,
	idle_background = false,
},{
	casting_interruptible_color   = { 1, 0.7, 0 },
	casting_uninterruptible_color = { 1, 222/255, 144/255},
	casting_complete_color = { 0, 1, 0 },
	casting_failed_color = { 1, 0, 0 },
	channel_interruptible_color   = { 0, 0, 1 },
	channel_uninterruptible_color = { 96/255, 180/255, 211/255 },
})

local cast_data = {}
PitBull4_CastBar.cast_data = cast_data

local timer_frame = CreateFrame("Frame")
timer_frame:Hide()
timer_frame:SetScript("OnUpdate", function() PitBull4_CastBar:FixCastDataAndUpdateAll() end)

local player_guid
function PitBull4_CastBar:OnEnable()
	player_guid = UnitGUID("player")
	
	timer_frame:Show()
	
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
end

function PitBull4_CastBar:OnDisable()
	timer_frame:Hide()
end

function PitBull4_CastBar:FixCastDataAndUpdateAll()
	self:FixCastData()
	self:UpdateAll()
end

local new, del
do
	local pool = setmetatable({}, {__mode='k'})
	function new()
		local t = next(pool)
		if t then
			pool[t] = nil
			return t
		end
		
		return {}
	end
	function del(t)
		wipe(t)
		pool[t] = true
	end
end

function PitBull4_CastBar:GetValue(frame)
	local guid = frame.guid
	local data = cast_data[guid]
	if frame.is_wacky or not data then
		self:UpdateInfo(nil, frame.unit)
		data = cast_data[guid]
	end
	
	local db = self:GetLayoutDB(frame)
	if not data then
		if db.auto_hide then
			return nil
		end
		return 0, nil, nil
	end
	
	local icon = db.show_icon and data.icon or nil
	
	if data.casting then
		local start_time = data.start_time
		return (GetTime() - start_time) / (data.end_time - start_time), nil, icon
	elseif data.channeling then	
		local end_time = data.end_time
		return (end_time - GetTime()) / (end_time - data.start_time), nil, icon
	elseif data.fade_out then
		return frame.CastBar and frame.CastBar:GetValue() or 0, nil, icon
	end
	
	if db.auto_hide then
		return nil
	end
	return 0, nil, icon
end

function PitBull4_CastBar:GetExampleValue(frame)
	local db = self:GetLayoutDB(frame)
	return EXAMPLE_VALUE, nil, db.show_icon and EXAMPLE_ICON or nil
end

function PitBull4_CastBar:GetColor(frame, value)
	local guid = frame.guid
	local data = cast_data[guid]
	if not data then
		return 0, 0, 0, 0
	end
	
	if data.casting then
		if data.interruptible then
			local r, g, b = unpack(self.db.profile.global.casting_interruptible_color)
			return r, g, b, 1 
		else
			local r, g, b = unpack(self.db.profile.global.casting_uninterruptible_color)
			return r, g, b, 1
		end
	elseif data.channeling then
		if data.interruptible then
			local r, g, b = unpack(self.db.profile.global.channel_interruptible_color)
			return r, g, b, 1
		else
			local r, g, b = unpack(self.db.profile.global.channel_uninterruptible_color)
			return r, g, b, 1
		end
	elseif data.fade_out then
		local alpha, r, g, b
		local stop_time = data.stop_time
		if stop_time then
			alpha = stop_time - GetTime() + 1
		else
			alpha = 0
		end
		if alpha >= 1 then
			alpha = 1
		end
		if alpha <= 0 then
			return 0, 0, 0, 0
		else
			-- Decide which color to use
			if not data.was_channeling then -- Last cast was a normal one...
				if data.failed then
					r, g, b = unpack(self.db.profile.global.casting_failed_color)
				else
					r, g, b = unpack(self.db.profile.global.casting_complete_color)
				end
			else
				if data.interruptible then -- Last cast was a channel...
					r, g, b = unpack(self.db.profile.global.channel_interruptible_color)
				else
					r, g, b = unpack(self.db.profile.global.channel_uninterruptible_color)
				end
			end
			return r, g, b, alpha
		end
	end
	return 0, 0, 0, 0
end

function PitBull4_CastBar:GetBackgroundColor(frame, value)
	local guid = frame.guid
	local data = cast_data[guid]

	if not data then
		if not self:GetLayoutDB(frame).idle_background then
			return nil, nil, nil, 0
		end
	elseif data.fade_out then
		local alpha
		local stop_time = data.stop_time
		if stop_time then
			alpha = stop_time - GetTime() + 1
		else
			alpha = 0
		end
		if alpha >= 1 then
			alpha = 1
		end
		if alpha <= 0 then
			alpha = 0
		end
		return nil, nil, nil, alpha
	end
end

function PitBull4_CastBar:GetExampleColor(frame, value)
	return 0, 1, 0, 1
end

function PitBull4_CastBar:ClearFramesByGUID(guid)
	for frame in PitBull4:IterateFramesForGUID(guid) do
		self:Update(frame)
	end
end

function PitBull4_CastBar:UpdateInfo(event, unit, event_spell, event_rank, event_cast_id)
	local guid = UnitGUID(unit)
	if not guid then
		return
	end
	local data = cast_data[guid]
	if not data then
		data = new()
		cast_data[guid] = data
	end
	
	local spell, rank, display_name, icon, start_time, end_time, is_trade_skill, cast_id, uninterruptible = UnitCastingInfo(unit)
	local channeling = false
	if not spell then
		spell, rank, display_name, icon, start_time, end_time, is_trade_skill, uninterruptible = UnitChannelInfo(unit)
		channeling = true
	end
	if spell then
		if icon == TEMP_ICON then
			icon = nil
		end
		data.icon = icon
		data.start_time = start_time * 0.001
		data.end_time = end_time * 0.001
		data.casting = not channeling
		data.channeling = channeling
		data.interruptible = not uninterruptible
		data.fade_out = false
		data.was_channeling = channeling -- persistent state even after interrupted
		data.stop_time = nil
		if event ~= "UNIT_SPELLCAST_INTERRUPTED" then
			-- We can't update the cache of teh cast_id on UNIT_SPELLCAST_INTERRUPTED because
			-- for whatever reason it ends up giving us 0 inside this event.
			data.cast_id = cast_id
		end
		timer_frame:Show()
		return
	end
	
	if not data.icon then
		cast_data[guid] = del(data)
		if not next(cast_data) then
			timer_frame:Hide()
		end
		return
	end

	if data.cast_id == event_cast_id then
		-- The event was for the cast we're currently casting
		if event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
			data.failed = true
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			-- This is necessary because if the interrupt happens just as the cast finishes
			-- it can look to the client like it failed but the server sends the success
			-- message after.  
			data.failed = false
		end
	end

	data.casting = false
	data.channeling = false
	data.fade_out = true
	if not data.stop_time then
		data.stop_time = GetTime()
	end
end

local tmp = {}
function PitBull4_CastBar:FixCastData()
	local frame
	local current_time = GetTime()
	for guid, data in pairs(cast_data) do
		tmp[guid] = data
	end
	for guid, data in pairs(tmp) do
		local found = false
		for frame in PitBull4:IterateFramesForGUID(guid) do
			if self:GetLayoutDB(frame).enabled then
				found = true
				if data.casting then
					if current_time > data.end_time and player_guid ~= guid then
						data.casting = false
						data.fade_out = true
						data.stop_time = current_time
					end
				elseif data.channeling then
					if current_time > data.end_time then
						data.channeling = false
						data.fade_out = true
						data.stop_time = current_time
					end
				elseif data.fade_out then
					local alpha = 0
					local stop_time = data.stop_time
					if stop_time then
						alpha = stop_time - current_time + 1
					end
					
					if alpha <= 0 then
						cast_data[guid] = del(data)
						self:ClearFramesByGUID(guid)
					end
				else
					cast_data[guid] = del(data)
					self:ClearFramesByGUID(guid)
				end
				break
			end	
		end
		if not found then
			cast_data[guid] = del(data)
		end
	end
	if not next(cast_data) then
		timer_frame:Hide()
	end
	wipe(tmp)
end

PitBull4_CastBar.UNIT_SPELLCAST_START = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_CHANNEL_START = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_STOP = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_FAILED = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_INTERRUPTED = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_SUCCEEDED = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_DELAYED = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_INTERRUPTIBLE = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_NOT_INTERRUPTIBLE = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_CHANNEL_UPDATE = PitBull4_CastBar.UpdateInfo
PitBull4_CastBar.UNIT_SPELLCAST_CHANNEL_STOP = PitBull4_CastBar.UpdateInfo

PitBull4_CastBar:SetLayoutOptionsFunction(function(self)
	return 'auto_hide', {
		name = L["Auto-hide"],
		desc = L["Automatically hide the cast bar when not casting."],
		type = 'toggle',
		get = function(info)
			return PitBull4.Options.GetLayoutDB(self).auto_hide
		end,
		set = function(info, value)
			PitBull4.Options.GetLayoutDB(self).auto_hide = value

			PitBull4.Options.UpdateFrames()
		end,
	}, 'show_icon', {
		name = L["Show icon"],
		desc = L["Whether to show the icon that is being cast."],
		type = 'toggle',
		get = function(info)
			return PitBull4.Options.GetLayoutDB(self).show_icon
		end,
		set = function(info, value)
			PitBull4.Options.GetLayoutDB(self).show_icon = value
			
			PitBull4.Options.RefreshFrameLayouts()
		end,
	}, 'icon_on_left', {
		name = L["Icon position"],
		desc = L["What side of the bar to show the icon on."],
		type = 'select',
		values = function(info)
			local db = PitBull4.Options.GetLayoutDB(self)
			local icon_on_left = db.icon_on_left
			local side = db.side
			local reverse = db.reverse
			
			if not reverse then
				if side == "center" then
					return {
						left = L["Left"],
						right = L["Right"],
					}
				else
					return {
						left = L["Bottom"],
						right = L["Top"],
					}
				end
			else
				if side == "center" then
					return {
						left = L["Right"],
						right = L["Left"],
					}
				else
					return {
						left = L["Top"],
						right = L["Bottom"],
					}
				end
			end
		end,
		get = function(info)
			return PitBull4.Options.GetLayoutDB(self).icon_on_left and "left" or "right"
		end,
		set = function(info, value)
			PitBull4.Options.GetLayoutDB(self).icon_on_left = (value == "left")

			PitBull4.Options.RefreshFrameLayouts()
		end,
		hidden = function(info)
			return not PitBull4.Options.GetLayoutDB(self).show_icon
		end
	}, 'idle_background', {
		name = L["Idle background"],
		desc = L["Show background on the cast bar when nothing is being cast."],
		type = 'toggle',
		get = function(info)
			local db = PitBull4.Options.GetLayoutDB(self)
			return db.idle_background and not db.auto_hide
		end,
		set = function(info, value)
			PitBull4.Options.GetLayoutDB(self).idle_background = value

			PitBull4.Options.RefreshFrameLayouts()
		end,
		disabled = function(info)
			return PitBull4.Options.GetLayoutDB(self).auto_hide
		end,
	}
end)

PitBull4_CastBar:SetColorOptionsFunction(function(self)
	return 'casting', {
		type = 'group',
		name = L["Casting"],
		inline = true,
		args = {
			casting_interruptible_color = {
				type = 'color',
				name = L['Interruptible'],
				desc = L['Sets which color to use on casting bar of casts that are interruptible.'],
				get = function(info)
					return unpack(self.db.profile.global.casting_interruptible_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.casting_interruptible_color = { r, g, b }
					self:UpdateAll()
				end,
				order = 1,
			},
			casting_uninterruptible_color = {
				type = 'color',
				name = L['Uninterruptible'],
				desc = L['Sets which color to use on casting bar of casts that are not interruptible.'],
				get = function(info)
					return unpack(self.db.profile.global.casting_uninterruptible_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.casting_uninterruptible_color = { r, g, b }
					self:UpdateAll()
				end,
				order = 2,
			},
			casting_complete_color = {
				type = 'color',
				name = L['Complete'],
				desc = L['Sets which color to use on casting bar of casts that completed.'],
				get = function(info)
					return unpack(self.db.profile.global.casting_complete_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.casting_complete_color = { r, g, b }
					self:UpdateAll()
				end,
				order = 3,
			},
			casting_failed_color = {
				type = 'color',
				name = L['Failed'],
				desc = L['Sets which color to use on casting bar of casts that failed.'],
				get = function(info)
					return unpack(self.db.profile.global.casting_failed_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.casting_failed_color = { r, g, b }
					self:UpdateAll()
				end,
				order = 4,
			},
		},
	}, 'channeling', {
		type = 'group',
		name = L["Channeling"],
		inline = true,
		args = {
			channel_interruptible_color = {
				type = 'color',
				name = L['Interruptible'],
				desc = L['Sets which color to use on casting bar of channeled casts that are interruptible.'],
				get = function(info)
					return unpack(self.db.profile.global.channel_interruptible_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.channel_interruptible_color = { r, g, b }
					self:UpdateAll()
				end,
				order = 1,
			},
			channel_uninterruptible_color = {
				type = 'color',
				name = L['Uninterruptible'],
				desc = L['Sets which color to use on casting bar of channeled casts that are not interruptible.'],
				get = function(info)
					return unpack(self.db.profile.global.channel_uninterruptible_color)
				end,
				set = function(info, r, g, b)
					self.db.profile.global.channel_uninterruptible_color = { r, g, b } 
					self:UpdateAll()
				end,
				order = 2,
			},
		},
	},
	function(info)
		self.db.profile.global.casting_interruptible_color = { 1, 0.7, 0 }
		self.db.profile.global.casting_uninterruptible_color = { 1, 222/255, 144/255 }
		self.db.profile.global.casting_complete_color = { 0, 1, 0 }
		self.db.profile.global.casting_failed_color = { 1, 0, 0 }
		self.db.profile.global.channel_interruptible_color = { 0, 0, 1 }
		self.db.profile.global.channel_uninterruptible_color = { 96/255, 180/255, 211/255 }
	end
end)
