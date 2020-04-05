
--> check unloaded files:
if (
	-- version 1.21.0
	not _G._details.attribute_custom.damagedoneTooltip or
	not _G._details.attribute_custom.damagetakenTooltip or
	not _G._details.attribute_custom.healdoneTooltip
	) then
	
	local f = CreateFrame("frame", "DetaisCorruptInstall", UIParent)
	f:SetSize(370, 70)
	f:SetPoint("center", UIParent, "center", 0, 0)
	f:SetPoint("top", UIParent, "top", 0, -20)
	local bg = f:CreateTexture(nil, "background")
	bg:SetAllPoints(f)
	bg:SetTexture([[Interface\AddOns\Details\images\welcome]])
	
	local image = f:CreateTexture(nil, "overlay")
	image:SetTexture([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
	image:SetSize(32, 32)
	
	local label = f:CreateFontString(nil, "overlay", "GameFontNormal")
	label:SetText("Restart game client in order to finish addons updates.")
	label:SetWidth(300)
	label:SetJustifyH("left")
	
	local close = CreateFrame("button", "DetaisCorruptInstall", f, "UIPanelCloseButton")
	close:SetSize(32, 32)
	close:SetPoint("topright", f, "topright", 0, 0)
	
	image:SetPoint("topleft", f, "topleft", 10, -20)	
	label:SetPoint("left", image, "right", 4, 0)

	_G._details.FILEBROKEN = true
end

function _G._details:InstallOkey()
	if (_G._details.FILEBROKEN) then
		return false
	end
	return true
end

--> start funtion
function _G._details:Start()

	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> row single click

	--> single click row function replace
		--damage, dps, damage taken, friendly fire
			self.row_singleclick_overwrite[1] = {true, true, true, true, self.attribute_damage.ReportSingleFragsLine, true, self.attribute_damage.ReportSingleVoidZoneLine} 
		--healing, hps, overheal, healing taken
			self.row_singleclick_overwrite[2] = {true, true, true, true, false, self.attribute_heal.ReportSingleDamagePreventedLine} 
		--mana, rage, energy, runepower
			self.row_singleclick_overwrite[3] = {true, true, true, true} 
		--cc breaks, ress, interrupts, dispells, deaths
			self.row_singleclick_overwrite[4] = {true, true, true, true, self.attribute_misc.ReportSingleDeadLine, self.attribute_misc.ReportSingleCooldownLine, self.attribute_misc.ReportSingleBuffUptimeLine, self.attribute_misc.ReportSingleDebuffUptimeLine} 
		
		function self:ReplaceRowSingleClickFunction(attribute, sub_attribute, func)
			assert(type(attribute) == "number" and attribute >= 1 and attribute <= 4, "ReplaceRowSingleClickFunction expects a attribute index on #1 argument.")
			assert(type(sub_attribute) == "number" and sub_attribute >= 1 and sub_attribute <= 10, "ReplaceRowSingleClickFunction expects a sub attribute index on #2 argument.")
			assert(type(func) == "function", "ReplaceRowSingleClickFunction expects a function on #3 argument.")
			
			self.row_singleclick_overwrite[attribute][sub_attribute] = func
			return true
		end
		
		self.click_to_report_color = {1, 0.8, 0, 1}
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialize

	--> build frames

		--> bookmarks
			if (self.switch.InitSwitch) then
				self.switch:InitSwitch()
			end
			
		--> custom window
			self.custom = self.custom or {}
			
		--> micro button alert
			self.MicroButtonAlert = CreateFrame("frame", "DetailsMicroButtonAlert", UIParent)--, "MicroButtonAlertTemplate")
			self.MicroButtonAlert:Hide()
			
		--> actor details window
			self.window_info = self.gump:CreateWindowInfo()
			self.gump:Fade(self.window_info, 1)
			
		--> copy and paste window
			self:CreateCopyPasteWindow()
			self.CreateCopyPasteWindow = nil
			
	--> start instances
		if (self:GetNumInstancesAmount() == 0) then
			self:Createinstance()
		end
		self:GetLowerInstanceNumber()
		self:CheckConsolidates()
		
	--> start time machine
		self.timeMachine:Ligar()
	
	--> update abbreviation shortcut
	
		self.attribute_damage:UpdateSelectedToKFunction()
		self.attribute_heal:UpdateSelectedToKFunction()
		self.attribute_energy:UpdateSelectedToKFunction()
		self.attribute_misc:UpdateSelectedToKFunction()
		self.attribute_custom:UpdateSelectedToKFunction()
		
	--> start instances updater
	
		_details:CheckSwitchOnLogon()
	
		self:UpdateGumpMain(-1, true)
		self.atualizador = self:ScheduleRepeatingTimer("UpdateGumpMain", _details.update_speed, -1)
		
		for index = 1, #self.table_instances do
			local instance = self.table_instances[index]
			if (instance:IsActive()) then
				self:ScheduleTimer("RefreshBars", 1, instance)
				self:ScheduleTimer("InstanceReset", 1, instance)
				self:ScheduleTimer("InstanceRefreshRows", 1, instance)
			end
		end

		function self:RefreshAfterStartup()
		
			self:UpdateGumpMain(-1, true)
			
			local lower_instance = _details:GetLowerInstanceNumber()

			for index = 1, #self.table_instances do
				local instance = self.table_instances[index]
				if (instance:IsActive()) then
					--> refresh wallpaper
					if (instance.wallpaper.enabled) then
						instance:InstanceWallpaper(true)
					else
						instance:InstanceWallpaper(false)
					end
					
					--> refresh desaturated icons if is lower instance
					if (index == lower_instance) then
						instance:DesaturateMenu()
					end
				end
			end
			
			_details.ToolBar:ReorganizeIcons() --> refresh all skin
		
			self.RefreshAfterStartup = nil
			
			function _details:CheckWallpaperAfterStartup()
				for i = 1, self.instances_amount do
					local instance = self:GetInstance(i)
					if (instance and instance:IsEnabled()) then
						if (not instance.wallpaper.enabled) then
							instance:InstanceWallpaper(false)
						end
						self.move_window_func(instance.baseframe, true, instance)
						self.move_window_func(instance.baseframe, false, instance)
					end
					self.CheckWallpaperAfterStartup = nil
				end
			end
			_details:ScheduleTimer("CheckWallpaperAfterStartup", 5)
			
		end
		self:ScheduleTimer("RefreshAfterStartup", 5)

		
	--> start garbage collector
	
		self.ultima_collect = 0
		self.interval_collect = 720
		--self.interval_collect = 10
		self.interval_memory = 180
		--self.interval_memory = 20
		self.garbagecollect = self:ScheduleRepeatingTimer("InitializeCollectGarbage", self.interval_collect)
		self.memorycleanup = self:ScheduleRepeatingTimer("CheckMemoryPeriodically", self.interval_memory)
		self.next_memory_check = time()+self.interval_memory

	--> role
		self.last_assigned_role = UnitGroupRolesAssigned("player")
		
	--> start parser
		
		--> load parser capture options
			self:CaptureRefresh()
		--> register parser events
			
			self.listener:RegisterEvent("PLAYER_REGEN_DISABLED")
			self.listener:RegisterEvent("PLAYER_REGEN_ENABLED")
			self.listener:RegisterEvent("SPELL_SUMMON")
			self.listener:RegisterEvent("UNIT_PET")

			self.listener:RegisterEvent("PARTY_MEMBERS_CHANGED")
			self.listener:RegisterEvent("GROUP_ROSTER_UPDATE")
			self.listener:RegisterEvent("PARTY_CONVERTED_TO_RAID")
			
			self.listener:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
			
			self.listener:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			self.listener:RegisterEvent("PLAYER_ENTERING_WORLD")
		
			--self.listener:RegisterEvent("ENCOUNTER_START")
			--self.listener:RegisterEvent("ENCOUNTER_END")
			
			self.listener:RegisterEvent("START_TIMER")
			self.listener:RegisterEvent("UNIT_NAME_UPDATE")

			self.listener:RegisterEvent("PET_BATTLE_OPENING_START")
			self.listener:RegisterEvent("PET_BATTLE_CLOSE")
			
			self.listener:RegisterEvent("PLAYER_ROLES_ASSIGNED")
			self.listener:RegisterEvent("ROLE_CHANGED_INFORM")
			
			self.parser_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	--> group
		self.details_users = {}
		self.in_group =(GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
		
	--> done
		self.initializing = nil
	
	--> scan pets
		_details:SchedulePetUpdate(1)
	
	--> send messages gathered on initialization
		self:ScheduleTimer("ShowDelayMsg", 10) 
	
	--> send instance open signal
		for index, instance in _details:ListInstances() do
			if (instance.active) then
				self:SendEvent("DETAILS_INSTANCE_OPEN", nil, instance)
			end
		end

	--> send details startup done signal
		function self:AnnounceStartup()
			self:SendEvent("DETAILS_STARTED", "SEND_TO_ALL")
			
			if (_details.in_group) then
				_details:SendEvent("GROUP_ONENTER")
			else
				_details:SendEvent("GROUP_ONLEAVE")
			end
			
			_details.last_zone_type = "INIT"
			_details.parser_functions:ZONE_CHANGED_NEW_AREA()
			
			_details.AnnounceStartup = nil
		end
		self:ScheduleTimer("AnnounceStartup", 5)
		
	--> announce alpha version
		function self:AnnounceVersion()
			for index, instance in _details:ListInstances() do
				if (instance.active) then
					self.gump:Fade(instance._version, "in", 0.1)
				end
			end
		end
		
	--> check version
		_details:CheckVersion(true)
		
	--> restore cooltip anchor position
		DetailsTooltipAnchor:Restore()
	
	--> check is this is the first run
		if (self.is_first_run) then
			if (#self.custom == 0) then
				_details:AddDefaultCustomDisplays()
			end
			
			_details:FillUserCustomSpells()
		end
		
	--> send feedback panel if the user got 100 or more logons with details
		if (self.tutorial.logons > 100) then --  and self.tutorial.logons < 104
			if (not self.tutorial.feedback_window1) then
				self.tutorial.feedback_window1 = true
				_details:ShowFeedbackRequestWindow()
			end
		end
	
	--> check is this is the first run of this version
		if (self.is_version_first_run) then
		
			local enable_reset_warning = true
		
			local lower_instance = _details:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _details:GetInstance(lower_instance)
				if (lower_instance) then
					lower_instance:InstanceAlert(Loc["STRING_VERSION_UPDATE"], {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, 60, {_details.OpenNewsWindow})
				end
			end
			
			_details:FillUserCustomSpells()
			_details:AddDefaultCustomDisplays()
			
			if (_details_database.last_realversion and _details_database.last_realversion < 20 and enable_reset_warning) then
				table.wipe(self.custom)
				_details:AddDefaultCustomDisplays()
			end
			
			if (_details_database.last_realversion and _details_database.last_realversion < 18 and enable_reset_warning) then
				
				for index, instance in ipairs(_details.table_instances) do 
					if (not instance.initiated) then
						instance:RestoreWindow()
						local skin = instance.skin
						instance:ChangeSkin("Default Skin")
						instance:ChangeSkin("Minimalistic v2")
						instance:ChangeSkin(skin)
						instance:DisableInstance()
					else
						local skin = instance.skin
						instance:ChangeSkin("Default Skin")
						instance:ChangeSkin("Minimalistic v2")
						instance:ChangeSkin(skin)
					end
				end
			end

		end
	
	local lower = _details:GetLowerInstanceNumber()
	if (lower) then
		local instance = _details:GetInstance(lower)
		if (instance) then

			--in development
			local dev_icon = instance.bgdisplay:CreateTexture(nil, "overlay")
			dev_icon:SetWidth(40)
			dev_icon:SetHeight(40)
			dev_icon:SetPoint("bottomleft", instance.baseframe, "bottomleft", 4, 8)
			dev_icon:SetTexture([[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]])
			dev_icon:SetAlpha(.3)
			
			local dev_text = instance.bgdisplay:CreateFontString(nil, "overlay", "GameFontNormalSmall")
			dev_text:SetHeight(64)
			dev_text:SetPoint("left", dev_icon, "right", 5, 0)
			dev_text:SetTextColor(1, 1, 1)
			dev_text:SetText("Details is Under\nDevelopment")
			dev_text:SetAlpha(.3)
		
			--version
			self.gump:Fade(instance._version, 0)
			instance._version:SetText("Details! Alpha " .. _details.userversion .. "(core: " .. self.realversion .. ")")
			instance._version:SetPoint("bottomleft", instance.baseframe, "bottomleft", 5, 1)

			if (instance.auto_switch_to_old) then
				instance:SwitchBack()
			end

			function _details:FadeStartVersion()
				_details.gump:Fade(dev_icon, "in", 2)
				_details.gump:Fade(dev_text, "in", 2)
				self.gump:Fade(instance._version, "in", 2)
				
				if (_details.switch.table) then
				
					local have_bookmark
					
					for index, t in ipairs(_details.switch.table) do
						if (t.attribute) then
							have_bookmark = true
							break
						end
					end
					
					if (not have_bookmark) then
						function _details:WarningAddBookmark()
							instance._version:SetText("right click to set bookmarks.")
							self.gump:Fade(instance._version, "out", 1)
							function _details:FadeBookmarkWarning()
								self.gump:Fade(instance._version, "in", 2)
							end
							_details:ScheduleTimer("FadeBookmarkWarning", 5)
						end
						_details:ScheduleTimer("WarningAddBookmark", 2)
					end
				end
				
			end
			
			_details:ScheduleTimer("FadeStartVersion", 12)
			
		end
	end	
	
	--> minimap
	_details:RegisterMinimap()
	function _details:SimulateEncounterStart(id, name)
		local _, _, diff, _, size = GetInstanceInfo()
		_details:ENCOUNTER_START(id, name, diff, size)
	end
	function _details:SimulateEncounterEnd(id, name, wipe)
		_details:ENCOUNTER_END(id, name, wipe)
	end
	
	
	
	function _details:RegisterHotCorner()
		_details:DoRegisterHotCorner()
	end
	_details:ScheduleTimer("RegisterHotCorner", 5)

	function _details:OpenOptionsWindowAtStart()
		--_details:OpenOptionsWindow(_details.table_instances[1])
		--print(_G["DetailsClearSegmentsButton1"]:GetSize())
		--_details:OpenCustomDisplayWindow()
		--_details:OpenWelcomeWindow()
	end
	_details:ScheduleTimer("OpenOptionsWindowAtStart", 2)
	--_details:OpenCustomDisplayWindow()
	
	--BNSendFriendInvite("tercio#1488")

	--> get in the realm chat channel
	if (not _details.schedule_chat_enter and not _details.schedule_chat_leave) then
		_details.schedule_chat_enter = _details:ScheduleTimer("EnterChatChannel", 30)
	end

	--> open profiler 
	_details:OpenProfiler()
	
	--> start announcers
	_details:StartAnnouncers()
	
	--> open welcome
	if (self.is_first_run) then
		_details:OpenWelcomeWindow()
	end
	
	_details:BrokerTick()
	
	--test realtime dps
	--[[
	local real_time_frame = CreateFrame("frame", nil, UIParent)
	local instance = _details:GetInstance(1)
	real_time_frame:SetScript("OnUpdate", function(self, elapsed)
		if (_details.in_combat and instance.attribute == 1 and instance.sub_attribute == 1) then
			for i = 1, instance:GetNumRows() do
				local row = instance:GetRow(index)
				if (row:IsShown()) then
					local actor = row.my_table
					local right_text = row.text_right
				end
			end
		end
	end)
	--]]
	
	-- test dbm callbacks
	
	if (_G.DBM) then
		local dbm_callback_phase = function(event, msg)

			local mod = _details.encounter_table.DBM_Mod
			
			if (not mod) then
				local id = _details:GetEncounterIdFromBossIndex(_details.encounter_table.mapid, _details.encounter_table.id)
				if (id) then
					for index, tmod in ipairs(DBM.Mods) do 
						if (tmod.id == id) then
							_details.encounter_table.DBM_Mod = tmod
							mod = tmod
						end
					end
				end
			end
			
			local phase = mod and mod.vb and mod.vb.phase
			if (phase and _details.encounter_table.phase ~= phase) then
				--_details:Msg("Current phase:", phase)
				_details.encounter_table.phase = phase
				--> do thing when the encounter changes the phase
			end
		end
		
		local dbm_callback_start = function(event, id, name)
			_details:SimulateEncounterStart(id, name)			
		end
		local dbm_callback_end = function(event, id, name, wipe)
			_details:SimulateEncounterEnd(id, name, wipe)			
		end
		
		local dbm_callback_pull = function(event, mod, delay, synced, startHp)
			_details.encounter_table.DBM_Mod = mod
			_details.encounter_table.DBM_ModTime = time()
		end
		DBM:RegisterCallback("DBM_EncounterStart", dbm_callback_start)
		DBM:RegisterCallback("DBM_EncounterEnd", dbm_callback_end)
		DBM:RegisterCallback("DBM_Announce", dbm_callback_phase)
		DBM:RegisterCallback("pull", dbm_callback_pull)
	end
end

