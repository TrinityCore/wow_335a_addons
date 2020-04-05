--File Revision: 1
--Last Modification: 07/04/2014
-- Change Log:
	-- 07/04/2014: File Created.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load default keys into the main object

function _details:ApplyBasicKeys()

	--> we are not in debug mode
		self.debug = false
		
	--> connected to realm channel
		self.is_connected = false

	--> who is
		self.playername = UnitName("player")
		self.playerserial = UnitGUID("player")
		
	--> player faction and enemy faction
		self.faction = UnitFactionGroup("player")
		if (self.faction == PLAYER_FACTION_GROUP[0]) then --> player is horde
			self.faction_against = PLAYER_FACTION_GROUP[1] --> ally
		elseif (self.faction == PLAYER_FACTION_GROUP[1]) then --> player is alliance
			self.faction_against = PLAYER_FACTION_GROUP[0] --> horde
		end
		
		self.zone_type = nil
		_details.temp_table1 = {}
		
	--> combat
		self.encounter = {}
		self.in_combat = false
		self.combat_id = 0

	--> instances(windows)
		self.solo = self.solo or nil 
		self.raid = self.raid or nil 
		self.opened_windows = 0
		
		self.default_texture =[[Interface\AddOns\Details\images\bar4]]
		self.default_texture_name = "Details D'ictum"

		self.tooltip_max_targets = 3
		self.tooltip_max_abilities = 3
		self.tooltip_max_pets = 1

		self.class_coords_version = 1
		self.class_colors_version = 1
		
		self.school_colors = {
			[1] = {1.00, 1.00, 0.00},
			[2] = {1.00, 0.90, 0.50},
			[4] = {1.00, 0.50, 0.00},
			[8] = {0.30, 1.00, 0.30},
			[16] = {0.50, 1.00, 1.00},
			[32] = {0.50, 0.50, 1.00},
			[64] = {1.00, 0.50, 1.00},
			["unknown"] = {0.5, 0.75, 0.75, 1}
		}
		
	--> load default profile keys
		for key, value in pairs(_details.default_profile) do 
			if (type(value) == "table") then
				local ctable = table_deepcopy(value)
				self[key] = ctable
			else
				self[key] = value
			end
		end
	
	--> end
		return true

end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> check if this is a first run, reset, or just load the saved data.

function _details:LoadGlobalAndCharacterData()

	--> check and build the default container for character database
	
		--> it exists?
		if (not _details_database) then
			_details_database = table_deepcopy(_details.default_player_data)
		end

		--> load saved values
		for key, value in pairs(_details.default_player_data) do
		
			--> check if key exists, e.g. a new key was added
			if (_details_database[key] == nil) then
				if (type(value) == "table") then
					_details_database[key] = table_deepcopy(_details.default_player_data[key])
				else
					_details_database[key] = value
				end
				
			elseif (type(_details_database[key]) == "table") then
				for key2, value2 in pairs(_details.default_player_data[key]) do 
					if (_details_database[key][key2] == nil) then
						if (type(value2) == "table") then
							_details_database[key][key2] = table_deepcopy(_details.default_player_data[key][key2])
						else
							_details_database[key][key2] = value2
						end
					end
				end
			end
			
			--> copy the key from saved table to details object
			if (type(value) == "table") then
				_details[key] = table_deepcopy(_details_database[key])
			else
				_details[key] = _details_database[key]
			end
			
		end
	
	--> check and build the default container for account database
		if (not _details_global) then
			_details_global = table_deepcopy(_details.default_global_data)
		end
		
		for key, value in pairs(_details.default_global_data) do 
		
			--> check if key exists
			if (_details_global[key] == nil) then
				if (type(value) == "table") then
					_details_global[key] = table_deepcopy(_details.default_global_data[key])
				else
					_details_global[key] = value
				end
				
			elseif (type(_details_global[key]) == "table") then
				for key2, value2 in pairs(_details.default_global_data[key]) do 
					if (_details_global[key][key2] == nil) then
						if (type(value2) == "table") then
							_details_global[key][key2] = table_deepcopy(_details.default_global_data[key][key2])
						else
							_details_global[key][key2] = value2
						end
					end
				end
			end
			
			--> copy the key from saved table to details object
			if (type(value) == "table") then
				_details[key] = table_deepcopy(_details_global[key])
			else
				_details[key] = _details_global[key]
			end

		end
		
	--> end
		return true
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load previous saved combat data

function _details:LoadCombatTables()

	--> if isn't nothing saved, build a new one
		if (not _details_database.table_history) then
			_details.table_history = _details.history:Newhistory()
			_details.table_overall = _details.combat:Newtable()
			_details.table_current = _details.combat:Newtable(_, _details.table_overall)
			_details.table_pets = _details.container_pets:NewContainer()
		else

		--> build basic containers
			-- segments
			_details.table_history = _details_database.table_history or _details.history:Newhistory()
			-- overall
			_details.table_overall = _details.combat:Newtable()
			
			-- pets
			_details.table_pets = _details.container_pets:NewContainer()
			if (_details_database.table_pets) then
				_details.table_pets.pets = table_deepcopy(_details_database.table_pets)
			end
			
		--> if the core revision was incremented, reset all combat data
			if (_details_database.last_realversion and _details_database.last_realversion < _details.realversion) then
				--> details was been hard upgraded
				_details.table_history = _details.history:Newhistory()
				_details.table_overall = _details.combat:Newtable()
				_details.table_current = _details.combat:Newtable(_, _details.table_overall)
				_details.table_pets = _details.container_pets:NewContainer()
			end

		--> re-build all indexes and metatables
			_details:RestoreMetaTables()

		--> get last combat table
			local history_UM = _details.table_history.tables[1]
			
			if (history_UM) then
				_details.table_current = history_UM --> significa que elas eram a mesma table, então aqui elas se tornam a mesma table
			else
				_details.table_current = _details.combat:Newtable(_, _details.table_overall)
			end
			
		--> need refresh for all containers
			for _, container in ipairs(_details.table_overall) do 
				container.need_refresh = true
			end
			for _, container in ipairs(_details.table_current) do 
				container.need_refresh = true
			end
		
		--> erase combat data from the database
			_details_database.table_current = nil
			_details_database.table_history = nil
			_details_database.table_pets = nil
			
			-- double check for pet container
			if (not _details.table_pets or not _details.table_pets.pets) then
				_details.table_pets = _details.container_pets:NewContainer()
			end
		
		end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> load the saved config on the addon

function _details:LoadConfig()

	--> plugins data
		_details.plugin_database = _details_database.plugin_database or {}

	--> startup
	
		--> set the nicktag cache host
			_details:NickTagSetCache(_details_database.nick_tag_cache)
			
		--> count data
			_details:CountDataOnLoad()
			
		--> solo e raid plugin
			if (_details_database.SoloTablesSaved) then
				if (_details_database.SoloTablesSaved.Mode) then
					_details.SoloTables.Mode = _details_database.SoloTablesSaved.Mode
					_details.SoloTables.LastSelected = _details_database.SoloTablesSaved.LastSelected
				else
					_details.SoloTables.Mode = 1
				end
			end
			
		--> switch tables
			_details.switch.slots = _details_global.switchSaved.slots
			_details.switch.table = _details_global.switchSaved.table
		
		--> last boss
			_details.last_encounter = _details_database.last_encounter
		
		--> buffs
			_details.savedbuffs = _details_database.savedbuffs
			_details.Buffs:BuildTables()
		
		--> initialize parser
			_details.capture_current = {}
			for captureType, captureValue in pairs(_details.capture_real) do 
				_details.capture_current[captureType] = captureValue
			end
			
		--> row animations
			_details:SetUseAnimations()

		--> initialize spell cache
			_details:ClearSpellCache() 
			
		--> version first run
			if (not _details_database.last_version or _details_database.last_version ~= _details.userversion) then
				_details.is_version_first_run = true
			end
			
	--> profile
	
		--> check for "always use this profile"
			if (_details.always_use_profile and type(_details.always_use_profile) == "string") then
				_details_database.active_profile = _details.always_use_profile
			end
	
		--> character first run
			if (_details_database.active_profile == "") then
				_details.character_first_run = true
				--> é a primeira vez que this character usa profiles,  precisa copiar as keys existentes
				local current_profile_name = _details:GetCurrentProfileName()
				_details:GetProfile(current_profile_name, true)
				_details:SaveProfileSpecial()
			end
	
		--> load profile and active instances
			local current_profile_name = _details:GetCurrentProfileName()
		--> check if exists, if not, create one
			local profile = _details:GetProfile(current_profile_name, true)
		
		--> instances
			_details.table_instances = _details_database.table_instances or {}
			
			--> fix for version 1.21.0
			if (#_details.table_instances > 0) then --> only happens once after the character logon
				--if (current_profile_name:find(UnitName("player"))) then
					for index, saved_skin in ipairs(profile.instances) do
						local instance = _details.table_instances[index]
						if (instance) then
							saved_skin.__was_opened = instance.active
							saved_skin.__pos = table_deepcopy(instance.position)
							saved_skin.__locked = instance.isLocked
							saved_skin.__snap = table_deepcopy(instance.snap)
							saved_skin.__snapH = instance.horizontalSnap
							saved_skin.__snapV = instance.verticalSnap
							
							for key, value in pairs(instance) do
								if (_details.instance_defaults[key] ~= nil) then	
									if (type(value) == "table") then
										saved_skin[key] = table_deepcopy(value)
									else
										saved_skin[key] = value
									end
								end
							end
						end
					end
					
					for index, instance in _details:ListInstances() do
						_details.local_instances_config[index] = {
							pos = table_deepcopy(instance.position),
							is_open = instance.active,
							attribute = instance.attribute,
							sub_attribute = instance.sub_attribute,
							mode = instance.mode,
							segment = instance.segment,
							snap = table_deepcopy(instance.snap),
							horizontalSnap = instance.horizontalSnap,
							verticalSnap = instance.verticalSnap,
							sub_attribute_last = instance.sub_attribute_last,
							isLocked = instance.isLocked
						}
						
						if (_details.local_instances_config[index].isLocked == nil) then
							_details.local_instances_config[index].isLocked = false
						end
					end
				--end
				
				_details.table_instances = {}
			end
			--_details:Reactivateinstances()
		
		--> apply the profile
			_details:ApplyProfile(current_profile_name, true)
			
		--> custom
			_details.custom = _details_global.custom
			_details.refresh:r_attribute_custom()
			
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On Details! Load:
	--> count logons, tutorials, etc

function _details:CountDataOnLoad()
	
	--> basic
		if (not _details_global.got_first_run) then
			_details.is_first_run = true
		end
		
	--> tutorial
		self.tutorial = self.tutorial or {}
		
		self.tutorial.logons = self.tutorial.logons or 0
		self.tutorial.logons = self.tutorial.logons + 1
		
		self.tutorial.unlock_button = self.tutorial.unlock_button or 0
		self.tutorial.version_announce = self.tutorial.version_announce or 0
		self.tutorial.main_help_button = self.tutorial.main_help_button or 0
		self.tutorial.alert_frames = self.tutorial.alert_frames or {false, false, false, false, false, false}
		
		self.tutorial.main_help_button = self.tutorial.main_help_button + 1
		
		self.character_data = self.character_data or {logons = 0}
		self.character_data.logons = self.character_data.logons + 1

end