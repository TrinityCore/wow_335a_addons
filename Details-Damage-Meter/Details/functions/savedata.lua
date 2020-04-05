--[[this file save the data when player leave the game]]

local _details = 		_G._details

function _details:WipeConfig()
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
	local b = CreateFrame("button", "DetailsResetConfigButton", UIParent, "OptionsButtonTemplate")
	tinsert(UISpecialFrames, "DetailsResetConfigButton")
	
	b:SetSize(250, 40)
	b:SetText(Loc["STRING_SLASH_WIPECONFIG_CONFIRM"])
	b:SetScript("OnClick", function() _details.wipe_full_config = true; ReloadUI(); end)
	b:SetPoint("center", UIParent, "center", 0, 0)
end

local is_exception = {
	["nick_tag_cache"] = true
}

function _details:SaveLocalInstanceConfig()
	for index, instance in _details:ListInstances() do
		local a1, a2 = instance:GetDisplay()
		
		local t = {
			pos = table_deepcopy(instance:GetPosition()), 
			is_open = instance:IsEnabled(),
			attribute = a1,
			sub_attribute = a2,
			mode = instance:GetMode(),
			segment = instance:GetSegment(),
			snap = table_deepcopy(instance.snap),
			horizontalSnap = instance.horizontalSnap,
			verticalSnap = instance.verticalSnap,
			sub_attribute_last = instance.sub_attribute_last,
			isLocked = instance.isLocked,
			last_raid_plugin = instance.last_raid_plugin
		}
		
		if (t.isLocked == nil) then
			t.isLocked = false
		end
		if (_details.profile_save_pos) then
			local cprofile = _details:GetProfile()
			local skin = cprofile.instances[instance:GetId()]
			if (skin) then
				t.pos = table_deepcopy(skin.__pos)
				t.horizontalSnap = skin.__snapH
				t.verticalSnap = skin.__snapV
				t.snap = table_deepcopy(skin.__snap)
				t.is_open = skin.__was_opened
				t.isLocked = skin.__locked
			end
		end
		
		_details.local_instances_config[index] = t
	end
end

function _details:SaveConfig()

	--> save instance configs localy
	_details:SaveLocalInstanceConfig()
	
	--> cleanup
		_details:PrepareTablesForSave()

		_details_database.table_instances = {} --_details.table_instances --[[instances now saves only inside the profile --]]
		_details_database.table_history = _details.table_history
		
		local name, ttype, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
		if (ttype == "party" or ttype == "raid") then
			--> salvar container de pet
			_details_database.table_pets = _details.table_pets.pets
		end
		
		_details:TimeDataCleanUpTimerary()
		
	--> buffs
		_details.Buffs:SaveBuffs()
	
	--> salva o container do personagem
		for key, value in pairs(_details.default_player_data) do
			if (not is_exception[key]) then
				_details_database[key] = _details[key]
			end
		end
	
	--> salva o container das globais
		for key, value in pairs(_details.default_global_data) do
			if (key ~= "__profiles") then
				_details_global[key] = _details[key]
			end
		end

	--> solo e raid mode
		if (_details.SoloTables.Mode) then
			_details_database.SoloTablesSaved = {}
			_details_database.SoloTablesSaved.Mode = _details.SoloTables.Mode
			if (_details.SoloTables.Plugins[_details.SoloTables.Mode]) then
				_details_database.SoloTablesSaved.LastSelected = _details.SoloTables.Plugins[_details.SoloTables.Mode].real_name
			end
		end
		
		_details_database.RaidTablesSaved = nil
		
	--> salva switch tables
		_details_global.switchSaved.slots = _details.switch.slots
		_details_global.switchSaved.table = _details.switch.table
	
	--> last boss
		_details_database.last_encounter = _details.last_encounter
	
	--> last versions
		_details_database.last_realversion = _details.realversion --> core number
		_details_database.last_version = _details.userversion --> version
		_details_global.got_first_run = true
	
end
