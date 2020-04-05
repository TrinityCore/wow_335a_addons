--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = _G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _math_floor = math.floor --lua local
	local _cstr = string.format --lua local
	
	local gump = _details.gump --details local
	
	local _GetSpellInfo = _details.getspellinfo --details api
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local mode_raid = _details._details_props["MODE_RAID"]
	local mode_alone = _details._details_props["MODE_ALONE"]
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions	
	
	function _details.RaidTables:DisableRaidMode(instance)
		--free
		self:SetInUse(instance.current_raid_plugin, nil)
		--hide
		local current_plugin_object = _details:GetPlugin(instance.current_raid_plugin)
		if (current_plugin_object) then
			current_plugin_object.Frame:Hide()
		end
		instance.current_raid_plugin = nil
	end
	
	function _details:RaidPluginInstalled(plugin_name)
		if (self.waiting_raid_plugin) then
			--print(self.mine_id, 2, self.last_raid_plugin, " == ", plugin_name)
			if (self.last_raid_plugin == plugin_name) then
				if (self.waiting_pid) then
					self:CancelTimer(self.waiting_pid, true)
				end
				self:CancelWaitForPlugin()
				_details.RaidTables:EnableRaidMode(self, plugin_name)
			end
		end
	end
	
	function _details.RaidTables:EnableRaidMode(instance, plugin_name, from_cooltip, from_mode_menu)

		--> check if came from cooltip
		if (from_cooltip) then
			self = _details.RaidTables
			instance = plugin_name
			plugin_name = from_cooltip
		end
	
		--> set the mode
		if (instance.mode == mode_alone) then
			instance:SoloMode(false)
		end
		instance.mode = mode_raid
		
		--> hide rows, scrollbar
		gump:Fade(instance, 1, nil, "bars")
		if (instance.scrolling) then
			instance:HideScrollBar(true) --> hida a scrollbar
		end
		_details:ResetGump(instance)
		instance:UpdateGumpMain(true)
		
		--> get the plugin name
		
		--if the desired plugin isn't passed, try to get the latest used.
		if (not plugin_name) then
			local last_plugin_used = instance.last_raid_plugin
			if (last_plugin_used) then
				if (self:IsAvailable(last_plugin_used, instance)) then
					plugin_name = last_plugin_used
				end
			end
		end

		--if we still doesnt have a name, try to get the first available
		if (not plugin_name) then
			local available = self:GetAvailablePlugins()
			if (#available == 0) then
				if (not instance.wait_for_plugin_created or not instance.WaitForPlugin) then
					instance:CreateWaitForPlugin()
				end
				return instance:WaitForPlugin()
			end
			
			plugin_name = available[1][4]
		end

		--last check if the name is okey
		if (self:IsAvailable(plugin_name, instance)) then
			self:switch(nil, plugin_name, instance)
			
			if (from_mode_menu) then
				--refresh
				instance.baseframe.header.mode_selecao:GetScript("OnEnter")(instance.baseframe.header.mode_selecao)
			end
		else
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end

	end

	function _details.RaidTables:GetAvailablePlugins()
		local available = {}
		for index, plugin in ipairs(self.Menu) do
			if (not self.PluginsInUse[ plugin[4] ] and plugin[3].__enabled) then -- 3 = plugin object 4 = absolute name
				tinsert(available, plugin)
			end
		end
		return available
	end
	
	function _details.RaidTables:IsAvailable(plugin_name, instance)
		--check if is installed
		if (not self.NameTable[plugin_name]) then
			return false
		end

		--check if is enabled
		if (not self.NameTable[plugin_name].__enabled) then
			return false
		end
		
		--check if is available
		local in_use = self.PluginsInUse[ plugin_name ]
		
		if (in_use and in_use ~= instance:GetId()) then
			return false
		else
			return true
		end
	end
	
	function _details.RaidTables:SetInUse(absolute_name, instance_number)
		if (absolute_name) then
			self.PluginsInUse[ absolute_name ] = instance_number
		end
	end

	----------------
	
	function _details.RaidTables:switch(_, plugin_name, instance)
	
		local update_menu = false
		if (not self) then --came from cooltip
			self = _details.RaidTables
			update_menu = true
		end
	
		--only hide the current plugin shown
		if (not plugin_name) then
			if (instance.current_raid_plugin) then
				--free
				self:SetInUse(instance.current_raid_plugin, nil)
				--hide
				local current_plugin_object = _details:GetPlugin(instance.current_raid_plugin)
				if (current_plugin_object) then
					current_plugin_object.Frame:Hide()
				end
				instance.current_raid_plugin = nil
			end
			return
		end
		
		--check if is realy available
		if (not self:IsAvailable(plugin_name, instance)) then
			instance.last_raid_plugin = plugin_name
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end
		
		--hide current shown plugin
		if (instance.current_raid_plugin) then
			--free
			self:SetInUse(instance.current_raid_plugin, nil)
			--hide
			local current_plugin_object = _details:GetPlugin(instance.current_raid_plugin)
			if (current_plugin_object) then
				current_plugin_object.Frame:Hide()
			end
		end
		
		local plugin_object = _details:GetPlugin(plugin_name)

		if (plugin_object and plugin_object.__enabled and plugin_object.Frame) then
			instance.last_raid_plugin = plugin_name
			instance.current_raid_plugin = plugin_name
			
			self:SetInUse(plugin_name, instance:GetId())
			plugin_object.instance_id = instance:GetId()
			plugin_object.Frame:SetPoint("TOPLEFT", instance.bgframe)
			plugin_object.Frame:Show()
			instance:ChangeIcon(plugin_object.__icon)--; print(instance:GetId(),"icon",plugin_object.__icon)
			_details:SendEvent("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, instance.attribute, instance.sub_attribute)
			
			if (update_menu) then
				GameCooltip:ExecFunc(instance.baseframe.header.attribute)
				--instance _details.popup:ExecFunc(DeleteButton)
			end
		else
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end

	end

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> built in announcers
	
	function _details:SendMsgToChannel(msg, channel, towho)
		if (channel == "RAID" or channel == "PARTY") then
			SendChatMessage(msg, channel)
			
		elseif (channel == "BNET") then
		
			if (type(towho) == "number") then
				BNSendWhisper(towho, msg)
			
			elseif (type(towho) == "string") then
				local BnetFriends = BNGetNumFriends()
				for i = 1, BnetFriends do 
					local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo(i)
					if ((presenceName == towho or toonName == towho) and isOnline) then
						BNSendWhisper(presenceID, msg)
						break
					end
				end
			end
		
		elseif (channel == "CHANNEL") then
			SendChatMessage(msg, channel, nil, GetChannelName(towho))
		
		elseif (channel == "WHISPER") then
			SendChatMessage(msg, channel, nil, towho)
		
		elseif (channel == "PRINT") then
			print(msg)
		
		else
			SendChatMessage(msg, channel)
		
		--elseif (channel == "SAY" or channel == "YELL" or channel == "RAID_WARNING" or channel == "OFFICER" or channel == "GUILD" or channel == "EMOTE") then
		
		end
	end
	
	--/run local s="test {spell}"; s=s:gsub("{spell}", "tercio");print(s)
	
	function _details:interrupt_announcer(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
		if (src_name == _details.playername) then -- and _details.announce_interrupts.enabled
			local channel = _details.announce_interrupts.channel
			local next = _details.announce_interrupts.next
			local custom = _details.announce_interrupts.custom
			
			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink(extraSpellID)
			else
				spellname = _GetSpellInfo(extraSpellID)
			end

			if (custom ~= "") then
				custom = custom:gsub("{spell}", spellname)
				custom = custom:gsub("{next}", next)
				_details:SendMsgToChannel(custom, channel, _details.announce_interrupts.whisper)
			else
				local msg = _cstr(Loc["STRING_OPTIONS_RT_INTERRUPT"], spellname)
				if (next ~= "") then
					msg = msg .. " " .. _cstr(Loc["STRING_OPTIONS_RT_INTERRUPT_NEXT"], next)
				end
				
				_details:SendMsgToChannel(msg, channel, _details.announce_interrupts.whisper)
			end
		end
	end
	
	function _details:cooldown_announcer(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
		if (src_name == _details.playername) then -- and _details.announce_cooldowns.enabled
			local ignored = _details.announce_cooldowns.ignored_cooldowns
			if (ignored[spellid]) then
				return
			end
			
			local channel = _details.announce_cooldowns.channel
			
			if (channel == "WHISPER") then
				if (dst_name == _details.playername) then
					return
				end
				if (dst_name == Loc["STRING_RAID_WIDE"]) then
					channel = "RAID"
				end
			end

			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink(spellid)
			else
				spellname = _GetSpellInfo(spellid)
			end
			
			local custom = _details.announce_cooldowns.custom
			
			if (custom ~= "") then
				custom = custom:gsub("{spell}", spellname)
				custom = custom:gsub("{target}", dst_name)
				_details:SendMsgToChannel(custom, channel, _details.announce_interrupts.whisper)
			else
				local msg
				
				if (dst_name == Loc["STRING_RAID_WIDE"]) then
					msg = _cstr(Loc["STRING_OPTIONS_RT_COOLDOWN2"], spellname)
				else
					msg = _cstr(Loc["STRING_OPTIONS_RT_COOLDOWN1"], spellname, dst_name)
				end

				_details:SendMsgToChannel(msg, channel, _details.announce_interrupts.whisper)
			end
		end
	end
	
	function _details:death_announcer(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, death_table, last_cooldown, death_at, max_health)
		--if (_details.announce_deaths.enabled) then
			
			local where = _details.announce_deaths.where
			local zone = _details:GetZoneType()
			local channel = ""
			if (where == 1) then
				if (zone ~= "party" and zone ~= "raid") then
					return
				end
				if (zone == "raid") then
					channel = "RAID"
				end
			elseif (where == 2) then
				if (zone ~= "raid") then
					return
				end
				channel = "RAID"
			elseif (where == 3) then
				if (zone ~= "party") then
					return
				end
				channel = "PARTY"
			end
			
			local only_first = _details.announce_deaths.only_first
			--_details:GetCombat("current"):GetDeaths() is the same thing, but, it's faster without using the API.
			if (zone == "raid" and not _details.table_current.is_boss) then
				return
			end
			if (only_first > 0 and #_details.table_current.last_events_tables > only_first) then
				return
			end
			
			dst_name = _details:GetOnlyName(dst_name)
			
			local msg = _cstr(Loc["STRING_OPTIONS_RT_DEATH_MSG"], dst_name) .. ":"
			local spells = ""
			local last = #death_table
			
			for i = 1, _details.announce_deaths.last_hits do
				for o = last, 1, -1 do
					local this_death = death_table[o]
					if (type(this_death[1]) == "boolean" and this_death[1] and this_death[4]+5 > time) then
						local spelllink
						if (this_death[2] > 10) then
							spelllink = GetSpellLink(this_death[2])
						else
							spelllink = "[" .. _GetSpellInfo(this_death[2]) .. "]"
						end
						spells = spelllink .. ": " .. _details:ToK2(_math_floor(this_death[3])) .. " " .. spells
						last = o-1
						break
					end
				end
			end
			
			msg = msg .. " " .. spells
			_details:SendMsgToChannel(msg, channel)
			--print(msg)
		--end
	end

	function _details:StartAnnouncers()
		if (_details.announce_interrupts.enabled) then
			_details:InstallHook(DETAILS_HOOK_INTERRUPT, _details.interrupt_announcer)
		end
		if (_details.announce_cooldowns.enabled) then
			_details:InstallHook(DETAILS_HOOK_COOLDOWN, _details.cooldown_announcer)
		end
		if (_details.announce_deaths.enabled) then
			_details:InstallHook(DETAILS_HOOK_DEATH, _details.death_announcer)
		end
	end
	
	function _details:EnableInterruptAnnouncer()
		_details.announce_interrupts.enabled = true
		_details:InstallHook(DETAILS_HOOK_INTERRUPT, _details.interrupt_announcer)
	end
	function _details:DisableInterruptAnnouncer()
		_details.announce_interrupts.enabled = false
		_details:UnInstallHook(DETAILS_HOOK_INTERRUPT, _details.interrupt_announcer)
	end
	
	function _details:EnableCooldownAnnouncer()
		_details.announce_cooldowns.enabled = true
		_details:InstallHook(DETAILS_HOOK_COOLDOWN, _details.cooldown_announcer)
	end
	function _details:DisableCooldownAnnouncer()
		_details.announce_cooldowns.enabled = false
		_details:UnInstallHook(DETAILS_HOOK_COOLDOWN, _details.cooldown_announcer)
	end
	
	function _details:EnableDeathAnnouncer()
		_details.announce_deaths.enabled = true
		_details:InstallHook(DETAILS_HOOK_DEATH, _details.death_announcer)
	end
	function _details:DisableDeathAnnouncer()
		_details.announce_deaths.enabled = false
		_details:UnInstallHook(DETAILS_HOOK_DEATH, _details.death_announcer)
	end
	
	