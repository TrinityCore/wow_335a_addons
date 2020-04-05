--File Revision: 1
--Last Modification: 07/04/2014
-- Change Log:
	-- 07/04/2014: File Created.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> return the current profile name
	
function _details:GetCurrentProfileName()

	--> check is have a profile name
		if (_details_database.active_profile == "") then
			local character_key = UnitName("player") .. "-" .. GetRealmName()
			_details_database.active_profile = character_key
		end
	
	--> end
		return _details_database.active_profile
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> create a new profile

function _details:CreateProfile(name)

	if (not name or type(name) ~= "string" or name == "") then
		return false
	end

	--> check if already exists
		if (_details_global.__profiles[name]) then
			return false
		end
		
	--> copy the default table
		local new_profile = table_deepcopy(_details.default_profile)
		new_profile.instances = {}
	
	--> add to global container
		_details_global.__profiles[name] = new_profile
		
	--> end
		return new_profile
	
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> return the list os all profiles
	
function _details:GetProfileList()
	
	--> build the table
		local t = {}
		for name, profile in pairs(_details_global.__profiles) do 
			t[#t + 1] = name
		end
	
	--> end
		return t
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> delete a profile
	
function _details:EraseProfile(profile_name)
	
	--> erase profile table
		_details_global.__profiles[profile_name] = nil
	
		if (_details_database.active_profile == profile_name) then
		
			local character_key = UnitName("player") .. "-" .. GetRealmName()
			
			local my_profile = _details:GetProfile(character_key)
			
			if (my_profile) then
				_details:ApplyProfile(character_key, true)
			else
				local profile = _details:CreateProfile(character_key)
				_details:ApplyProfile(character_key, true)
			end
		
		end

	--> end
		return true
end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> return the profile table requested
	
function _details:GetProfile(name, create)

	--> get the profile, create and return
		if (not name) then
			name = _details:GetCurrentProfileName()
		end
		
		local profile = _details_global.__profiles[name]
		
		if (not profile and not create) then
			return false

		elseif (not profile and create) then
			profile = _details:CreateProfile(name)

		end
	
	--> end
		return profile
end	

function _details:SetProfileCProp(name, cprop, value)
	if (not name) then
		name = _details:GetCurrentProfileName()
	end

	local profile = _details:GetProfile(name, false)
	
	if (profile) then
		if (type(value) == "table") then
			rawset(profile, cprop, table_deepcopy(value))
		else
			rawset(profile, cprop, value)
		end
	else
		return
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> reset the profile
function _details:ResetProfile(profile_name)

	--> get the profile
		local profile = _details:GetProfile(profile_name, true)
		
		if (not profile) then
			return false
		end
	
	--> reset all already created instances
		for index, instance in _details:ListInstances() do
			if (not instance.baseframe) then
				instance:EnableInstance()
			end
			instance.skin = ""
			instance:ChangeSkin("Minimalistic v2")
		end
		
		for index, instance in pairs(_details.unused_instances) do
			if (not instance.baseframe) then
				instance:EnableInstance()
			end
			instance.skin = ""
			instance:ChangeSkin("Minimalistic v2")
		end
	
	--> reset the profile
		table.wipe(profile.instances)

		--> export first instance
		local instance = _details:GetInstance(1)
		local exported = instance:ExportSkin()
		exported.__was_opened = instance:IsEnabled()
		exported.__pos = table_deepcopy(instance:GetPosition())
		exported.__locked = instance.isLocked
		exported.__snap = {}
		exported.__snapH = false
		exported.__snapV = false
		profile.instances[1] = exported
		instance.horizontalSnap = false
		instance.verticalSnap = false
		instance.snap = {}
		
		_details:ApplyProfile(profile_name, true)
		
	--> end
		return true
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> return the profile table requested
	
function _details:ApplyProfile(profile_name, nosave, is_copy)

	--> get the profile
		local profile = _details:GetProfile(profile_name, true)

	--> if the profile doesn't exist, just quit
		if (not profile) then
			_details:Msg("Profile Not Found.")
			return false
		end
		
	--> always save the previous profile, except if nosave flag is up
		if (not nosave) then
			--> salva o profile active no momento
			_details:SaveProfile()
		end

	--> update profile keys before go
		for key, value in pairs(_details.default_profile) do 
			if (profile[key] == nil) then
				if (type(value) == "table") then
					profile[key] = table_deepcopy(_details.default_profile[key])
				else
					profile[key] = value
				end
				
			elseif (type(value) == "table") then
				for key2, value2 in pairs(value) do 
					if (profile[key][key2] == nil) then
						if (type(value2) == "table") then
							profile[key][key2] = table_deepcopy(_details.default_profile[key][key2])
						else
							profile[key][key2] = value2
						end
					end
				end
				
			end
		end
		
	--> apply the profile values
		for key, _ in pairs(_details.default_profile) do 
			local value = profile[key]

			if (type(value) == "table") then
				local ctable = table_deepcopy(value)
				_details[key] = ctable
			else
				_details[key] = value
			end
		end
		
	--> set the current profile
	if (not is_copy) then
		_details.active_profile = profile_name
		_details_database.active_profile = profile_name
	end
	
	--> apply the skin
		
		--> first save the local instance configs
		_details:SaveLocalInstanceConfig()
		
		local saved_skins = profile.instances
		local instance_limit = _details.instances_amount
		
		--> then close all opened instances
		for index, instance in _details:ListInstances() do
			if (not getmetatable(instance)) then
				instance.initiated = false
				setmetatable(instance, _details)
			end
			if (instance:IsStarted()) then
				if (instance:IsEnabled()) then
					instance:ShutDown()
				end
			end
		end

		--> check if there is a skin saved or this is a empty profile
		if (#saved_skins == 0) then
			--> is empty profile, let's set default skin on #1 window
			local instance1 = _details:GetInstance(1)
			if (not instance1) then
				instance1 = _details:CreateInstance(1)
			end

			--> apply default config on this instance(flat skin texture was 'ResetInstanceConfig' running).
			instance1:ResetInstanceConfig()
			instance1.skin = "no skin"
			instance1:ChangeSkin("Minimalistic v2")
			
			--> release the snap and lock
			instance1:LoadLocalInstanceConfig()
			instance1.snap = {}
			instance1.horizontalSnap = nil
			instance1.verticalSnap = nil
			instance1:LockInstance(false)
			
			if (#_details.table_instances > 1) then
				for i = #_details.table_instances, 2, -1 do
					_details.unused_instances[i] = _details.table_instances[i]
					_details.table_instances[i] = nil
				end
			end
			
		else	
		
			--> load skins
			local instances_loaded = 0
			
			for index, skin in ipairs(saved_skins) do
				if (instance_limit < index) then
					break
				end
				
				if (skin.skin == "Flat Color") then
					skin.skin = "Serenity"
				end
				
				--> get the instance
				local instance = _details:GetInstance(index)
				if (not instance) then
					--> create a instance without creating its frames(not initializing)
					instance = _details:CreateDisabledInstance(index, skin)
				end
				
				--> copy skin
				for key, value in pairs(skin) do
					if (type(value) == "table") then
						instance[key] = table_deepcopy(value)
					else
						instance[key] = value
					end
				end
				
				--> reset basic config
				instance.snap = {}
				instance.horizontalSnap = nil
				instance.verticalSnap = nil
				instance:LockInstance(false)
				
				--> fix for old versions
				if (type(instance.segment) ~= "number") then
					instance.segment = 0
				end
				if (type(instance.attribute) ~= "number") then
					instance.attribute = 1
				end
				if (type(instance.sub_attribute) ~= "number") then
					instance.sub_attribute = 1
				end
				
				--> load data saved for this character only
				instance:LoadLocalInstanceConfig()
				if (skin.__was_opened) then
					instance:EnableInstance()
				else
					instance.active = false
				end
				
				--> load data saved again
				instance:LoadLocalInstanceConfig()
				--> check window positioning
				if (_details.profile_save_pos) then
					--print("is profile save pos", skin.__pos.normal.x, skin.__pos.normal.y)
					if (skin.__pos) then
						instance.position = table_deepcopy(skin.__pos)
					else
						if (not instance.position) then
							instance.position = {normal = {x = 1, y = 1, w = 300, h = 200}, solo = {}}
						elseif (not instance.position.normal) then
							instance.position.normal = {x = 1, y = 1, w = 300, h = 200}
						end
					end

					instance.isLocked = skin.__locked
					instance.snap = table_deepcopy(skin.__snap) or {}
					instance.horizontalSnap = skin.__snapH
					instance.verticalSnap = skin.__snapV
				else
					if (not instance.position) then
						instance.position = {normal = {x = 1, y = 1, w = 300, h = 200}, solo = {}}
					elseif (not instance.position.normal) then
						instance.position.normal = {x = 1, y = 1, w = 300, h = 200}
					end
				end

--				/dump _details:GetInstance(1).sub_attribute
				--> open the instance
				if (instance:IsEnabled()) then
					if (not instance.baseframe) then
						instance:EnableInstance()
					end

					instance:LockInstance(instance.isLocked)
					instance:RestoreMainWindowPosition()
					instance:ReadjustGump()
					instance:SaveMainWindowPosition()
					instance:ChangeSkin()

				else
					instance.skin = skin.skin
				end
				
				instances_loaded = instances_loaded + 1

			end
			
			--> move unused instances for unused container
			if (#_details.table_instances > instances_loaded) then
				for i = #_details.table_instances, instances_loaded+1, -1 do
					_details.unused_instances[i] = _details.table_instances[i]
					_details.table_instances[i] = nil
				end
			end
			
			--> check all snaps for invalid entries
			for i = 1, instances_loaded do
				local instance = _details:GetInstance(i)
				local previous_instance_id = _details:GetInstance(i-1) and _details:GetInstance(i-1):GetId() or 0
				local next_instance_id = _details:GetInstance(i+1) and _details:GetInstance(i+1):GetId() or 0
				
				for snap_side, instance_id in pairs(instance.snap) do
					if (instance_id < 1) then --> invalid instance
						instance.snap[snap_side] = nil
					elseif (instance_id ~= previous_instance_id and instance_id ~= next_instance_id) then --> no match
						instance.snap[snap_side] = nil
					end
				end
			end
			
			--> auto realign windows
			if (not _details.initializing) then
				for _, instance in _details:ListInstances() do
					if (instance:IsEnabled()) then
						_details.move_window_func(instance.baseframe, true, instance)
						_details.move_window_func(instance.baseframe, false, instance)
					end
				end
			end
			
		end
		
		--> check instance amount
		_details.opened_windows = 0
		for index = 1, _details.instances_amount do
			local instance = _details.table_instances[index]
			if (instance and instance.active) then
				_details.opened_windows = _details.opened_windows + 1
			end
		end
		
		--> update tooltip settings
		_details:SetTooltipBackdrop()

	--> end

		return true	
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Profiles:
	--> return the profile table requested
	
function _details:SaveProfile(saveas)
	
	--> get the current profile
	
		local profile_name
	
		if (saveas) then
			profile_name = saveas
		else
			profile_name = _details:GetCurrentProfileName()
		end
		
		local profile = _details:GetProfile(profile_name, true)

	--> save default keys

		for key, _ in pairs(_details.default_profile) do 
		
			local current_value = _details[key]

			if (type(current_value) == "table") then
				local ctable = table_deepcopy(current_value)
				profile[key] = ctable
			else
				profile[key] = current_value
			end

		end

	--> save skins
		table.wipe(profile.instances)

		for index, instance in ipairs(_details.table_instances) do
			local exported = instance:ExportSkin()
			exported.__was_opened = instance:IsEnabled()
			exported.__pos = table_deepcopy(instance:GetPosition())
			exported.__locked = instance.isLocked
			exported.__snap = table_deepcopy(instance.snap)
			exported.__snapH = instance.horizontalSnap
			exported.__snapV = instance.verticalSnap
			profile.instances[index] = exported
		end
		
		_details:SaveLocalInstanceConfig()

	--> end
		return profile
end

local default_profile = {

	--> class icons and colors
		class_icons_small =[[Interface\AddOns\Details\images\classes_small]],
		class_coords = {
			["HUNTER"] = {
				0, --[1]
				0.25, --[2]
				0.25, --[3]
				0.5, --[4]
			},
			["WARRIOR"] = {
				0, --[1]
				0.25, --[2]
				0, --[3]
				0.25, --[4]
			},
			["ROGUE"] = {
				0.49609375, --[1]
				0.7421875, --[2]
				0, --[3]
				0.25, --[4]
			},
			["MAGE"] = {
				0.25, --[1]
				0.49609375, --[2]
				0, --[3]
				0.25, --[4]
			},
			["PET"] = {
				0.25, --[1]
				0.49609375, --[2]
				0.75, --[3]
				1, --[4]
			},
			["DRUID"] = {
				0.7421875, --[1]
				0.98828125, --[2]
				0, --[3]
				0.25, --[4]
			},
			["DEATHKNIGHT"] = {
				0.25, --[1]
				0.5, --[2]
				0.5, --[3]
				0.75, --[4]
			},
			["UNKNOW"] = {
				0.5, --[1]
				0.75, --[2]
				0.75, --[3]
				1, --[4]
			},
			["PRIEST"] = {
				0.49609375, --[1]
				0.7421875, --[2]
				0.25, --[3]
				0.5, --[4]
			},
			["UNGROUPPLAYER"] = {
				0.5, --[1]
				0.75, --[2]
				0.75, --[3]
				1, --[4]
			},
			["Alliance"] = {
				0.49609375, --[1]
				0.7421875, --[2]
				0.75, --[3]
				1, --[4]
			},
			["WARLOCK"] = {
				0.7421875, --[1]
				0.98828125, --[2]
				0.25, --[3]
				0.5, --[4]
			},
			["ENEMY"] = {
				0, --[1]
				0.25, --[2]
				0.75, --[3]
				1, --[4]
			},
			["Horde"] = {
				0.7421875, --[1]
				0.98828125, --[2]
				0.75, --[3]
				1, --[4]
			},
			["PALADIN"] = {
				0, --[1]
				0.25, --[2]
				0.5, --[3]
				0.75, --[4]
			},
			["MONSTER"] = {
				0, --[1]
				0.25, --[2]
				0.75, --[3]
				1, --[4]
			},
			["SHAMAN"] = {
				0.25, --[1]
				0.49609375, --[2]
				0.25, --[3]
				0.5, --[4]
			},
			},
		
		class_colors = {
			["HUNTER"] = {
				0.67, --[1]
				0.83, --[2]
				0.45, --[3]
			},
			["WARRIOR"] = {
				0.78, --[1]
				0.61, --[2]
				0.43, --[3]
			},
			["PALADIN"] = {
				0.96, --[1]
				0.55, --[2]
				0.73, --[3]
			},
			["SHAMAN"] = {
				0, --[1]
				0.44, --[2]
				0.87, --[3]
			},
			["MAGE"] = {
				0.41, --[1]
				0.8, --[2]
				0.94, --[3]
			},
			["ROGUE"] = {
				1, --[1]
				0.96, --[2]
				0.41, --[3]
			},
			["UNKNOW"] = {
				0.2, --[1]
				0.2, --[2]
				0.2, --[3]
			},
			["PRIEST"] = {
				1, --[1]
				1, --[2]
				1, --[3]
			},
			["WARLOCK"] = {
				0.58, --[1]
				0.51, --[2]
				0.79, --[3]
			},
			["UNGROUPPLAYER"] = {
				0.4, --[1]
				0.4, --[2]
				0.4, --[3]
			},
			["ENEMY"] = {
				0.94117, --[1]
				0, --[2]
				0.0196, --[3]
				1, --[4]
			},
			["version"] = 1,
			["PET"] = {
				0.3, --[1]
				0.4, --[2]
				0.5, --[3]
			},
			["DRUID"] = {
				1, --[1]
				0.49, --[2]
				0.04, --[3]
			},
			["DEATHKNIGHT"] = {
				0.77, --[1]
				0.12, --[2]
				0.23, --[3]
			},
			["ARENA_ALLY"] = {
				0.2, --[1]
				1, --[2]
				0.2, --[3]
			},
			["ARENA_ENEMY"] = {
				1, --[1]
				1, --[2]
				0, --[3]
			},
			["NEUTRAL"] = {
				1, --[1]
				1, --[2]
				0, --[3]
			},
			},

	--> minimap
		minimap = {hide = false, radius = 160, minimapPos = 220, onclick_what_todo = 1, text_type = 1, text_format = 3},
		data_broker_text = "",
	--> horcorner
		hotcorner_topleft = {hide = false},
		
	--> PvP
		only_pvp_frags = false,

	--> window size
		max_window_size = {width = 480, height = 450},
		new_window_size = {width = 320, height = 130},
		window_clamp = {-8, 0, 21, -14},
		disable_window_groups = false,
		disable_reset_button = false,
		
	--> segments
		segments_amount = 12,
		segments_amount_to_save = 5,
		segments_panic_mode = true,
		segments_auto_erase = 1,
	--> instances
		instances_amount = 5,
		instances_segments_locked = false,
		
	--> if clear ungroup characters when logout
		clear_ungrouped = true,
	--> if clear graphic data when logout
		clear_graphic = true, 
	
	--> text sizes
		font_sizes = {menus = 10},
		ps_abbreviation = 3,
		total_abbreviation = 2,
	
	--> performance
		use_row_animations = false,
		animate_scroll = false,
		use_scroll = false,
		update_speed = 1,
		time_type = 2,
		memory_threshold = 3,
		memory_ram = 64,
		remove_realm_from_name = true,
		trash_concatenate = false,
		trash_auto_remove = true,
	
	--> death log
		deadlog_limit = 12,
	
	--> report
		report_lines = 5,
		report_to_who = "",
		report_heal_links = false,
		
	--> colors
		default_bg_color = 0.0941,
		default_bg_alpha = 0.5,
		
	--> fades
		row_fade_in = {"in", 0.2},
		windows_fade_in = {"in", 0.2},
		row_fade_out = {"out", 0.2},
		windows_fade_out = {"out", 0.2},

	--> captures
		capture_real = {
			["damage"] = true,
			["heal"] = true,
			["energy"] = true,
			["miscdata"] = true,
			["aura"] = true,
			["spellcast"] = true,
		},
	
	--> cloud capture
		cloud_capture = true,
		
	--> combat
		minimum_combat_time = 5,
		overall_flag = 0xD,
		overall_clear_newboss = true,
		overall_clear_newchallenge = true,
	
	--> skins
		standard_skin = false,
		skin = "Default Skin",
		profile_save_pos = true,
		
	--> tooltip
		tooltip = {
			fontface = "Friz Quadrata TT", 
			fontsize = 10, 
			fontcolor = {1, 1, 1, 1}, 
			fontshadow = false, 
			background = {.45, .45, .45, .28}, 
			abbreviation = 5, --ToK I Lower -- was 8
			maximize_method = 1, 
			show_amount = false, 
			commands = {},
			
			anchored_to = 1,
			anchor_screen_pos = {507.700, -350.500},
			anchor_point = "bottom",
			anchor_relative = "top",
			anchor_offset = {0, 0},
			
			border_texture = "Blizzard Tooltip",
			border_color = {1, 1, 1, 1},
			border_size = 16,
		},
	
}

_details.default_profile = default_profile

-- aqui fica as propriedades do player que não serão armazenadas no profile
local default_player_data = {
	--> current combat number
		combat_id = 0,
		combat_counter = 0,
		last_instance_id = 0,
		last_instance_time = 0,
	--> nicktag cache
		nick_tag_cache = {},
	--> plugin data
		plugin_database = {},
	--> information about this character
		character_data = {logons = 0},
	--> version
		last_realversion = _details.realversion,
		last_version = "v1.0.0",
	--> profile
		active_profile = "",
	--> plugins tables
		SoloTablesSaved = {},
		RaidTablesSaved = {},
	--> saved skins
		savedStyles = {},
	--> instance config
		local_instances_config = {},
	--> announcements
		announce_deaths = {
			enabled = false,
			only_first = 5,
			last_hits = 1,
			where = 1,
		},
		announce_cooldowns = {
			enabled = false,
			channel = "RAID",
			ignored_cooldowns = {},
			custom = "",
		},
		announce_interrupts = {
			enabled = false,
			channel = "SAY",
			whisper = "",
			next = "",
			custom = "",
		},
		announce_prepots = {
			enabled = true,
			reverse = false,
			channel = "SELF",
		},
		announce_firsthit = {
			enabled = true,
			channel = "SELF",
		},
}

_details.default_player_data = default_player_data

local default_global_data = {

	--> profile pool
		__profiles = {},
		always_use_profile = false,
		custom = {},
		savedStyles = {},
		savedCustomSpells = {},
		savedTimeCaptures = {},
		lastUpdateWarning = 0,
		report_where = "SAY",
		realm_sync = true,
	--> switch tables
		switchSaved = {slots = 4, table = {
			{["attribute"] = 1,["sub_attribute"] = 1}, --damage done
			{["attribute"] = 2,["sub_attribute"] = 1}, --healing done
			{["attribute"] = 1,["sub_attribute"] = 6}, --enemies
			{["attribute"] = 4,["sub_attribute"] = 5}, --deaths
		}},
		report_pos = {1, 1},
	--> tutorial
		tutorial = {
			logons = 0, 
			unlock_button = 0, 
			version_announce = 0, 
			main_help_button = 0, 
			alert_frames = {false, false, false, false, false, false}, 
			bookmark_tutorial = false,
		},
		performance_profiles = {
			["RaidFinder"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Raid15"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Raid30"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Mythic"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Battleground15"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Battleground40"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Arena"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
			["Dungeon"] = {enabled = false, update_speed = 1, use_row_animations = false, damage = true, heal = true, aura = true, energy = false, miscdata = true},
		}
}

_details.default_global_data = default_global_data

function _details:GetTutorialCVar(key, default)
	local value = _details.tutorial[key]
	if (value == nil and default) then
		_details.tutorial[key] = default
		value = default
	end
	return value
end
function _details:SetTutorialCVar(key, value)
	_details.tutorial[key] = value
end

function _details:SaveProfileSpecial()
	
	--> get the current profile
		local profile_name = _details:GetCurrentProfileName()
		local profile = _details:GetProfile(profile_name, true)

	--> save default keys
		for key, _ in pairs(_details.default_profile) do 

			local current_value = _details_database[key] or _details_global[key] or _details.default_player_data[key] or _details.default_global_data[key]

			if (type(current_value) == "table") then
				local ctable = table_deepcopy(current_value)
				profile[key] = ctable
			else
				profile[key] = current_value
			end

		end

	--> save skins
		table.wipe(profile.instances)

		if (_details.table_instances) then
			for index, instance in ipairs(_details.table_instances) do
				local exported = instance:ExportSkin()
				profile.instances[index] = exported
			end
		end

	--> end
		return profile
end