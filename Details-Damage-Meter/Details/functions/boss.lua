
do 

	local _details = _G._details
	_details.EncounterInformation = {}
	local _ipairs = ipairs --> lua local
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions
	
	--> return if the player is inside a raid supported by details
	function _details:IsInInstance()
		local zoneName, zoneType, _, _, _, _ = GetInstanceInfo()
		local zoneMapID
		if(zoneType == "raid") then
			if (zoneName == "Ulduar") then zoneMapID = 530
			elseif (zoneName == "Naxxramas") then zoneMapID = 536
			elseif (zoneName == "Trial of the Crusader") then zoneMapID = 544
			elseif (zoneName == "The Eye of Eternity") then zoneMapID = 528
			elseif (zoneName == "Icecrown Citadel") then zoneMapID = 605
			elseif (zoneName == "Onyxia's Lair") then zoneMapID = 718
			elseif (zoneName == "The Obsidian Sanctum") then zoneMapID = 531
			elseif (zoneName == "Vault of Archavon") then zoneMapID = 533
			elseif (zoneName == "The Ruby Sanctum") then zoneMapID = 610
			else zoneMapID = 4
			end
		else zoneMapID = 4
		end
		if (_details.EncounterInformation[zoneMapID]) then
			return true
		else
			return false
		end
	end

	--> return the ids of trash mobs in the instance
	function _details:GetInstanceTrashInfo(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].trash_ids
	end
	
	--> return the boss table using a encounter id
	function _details:GetBossEncounterDetailsFromEncounterId(mapid, encounterid)
		local bossindex = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounter_ids and _details.EncounterInformation[mapid].encounter_ids[encounterid]
		if (bossindex) then
			return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex], bossindex
		else
			local bossindex = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounter_ids2 and _details.EncounterInformation[mapid].encounter_ids2[encounterid]
			if (bossindex) then
				return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex], bossindex
			end
		end
	end
	
	--> return the EJ boss id
	function _details:GetEncounterIdFromBossIndex(mapid, index)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounter_ids and _details.EncounterInformation[mapid].encounter_ids[index]
	end
	
	--> return the table which contain information about the start of a encounter
	function _details:GetEncounterStartInfo(mapid, encounterid)
		local bossindex = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounter_ids and _details.EncounterInformation[mapid].encounter_ids[encounterid]
		if (bossindex) then
			return _details.EncounterInformation[mapid].encounters[bossindex] and _details.EncounterInformation[mapid].encounters[bossindex].encounter_start
		end
	end
	
	--> return the table which contain information about the end of a encounter
	function _details:GetEncounterEndInfo(mapid, encounterid)
		local bossindex = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounter_ids and _details.EncounterInformation[mapid].encounter_ids[encounterid]
		if (bossindex) then
			return _details.EncounterInformation[mapid].encounters[bossindex] and _details.EncounterInformation[mapid].encounters[bossindex].encounter_end
		end
	end
	
	--> return the function for the boss
	function _details:GetEncounterEnd(mapid, bossindex)
		local t = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex]
		if (t) then
			local _end = t.combat_end
			if (_end) then
				return unpack(_end)
			end
		end
		return 
	end
	
	--> generic boss find function
	function _details:GetRaidBossFindFunction(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].find_boss_encounter
	end
	
	--> return if the boss need sync
	function _details:GetEncounterEwhichize(mapid, bossindex)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex] and _details.EncounterInformation[mapid].encounters[bossindex].ewhichize
	end
	
	--> return the function for the boss
	function _details:GetBossFunction(mapid, bossindex)
		local func = _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex] and _details.EncounterInformation[mapid].encounters[bossindex].func
		if (func) then
			return func, _details.EncounterInformation[mapid].encounters[bossindex].funcType
		end
		return 
	end
	
	--> return the boss table with information about name, adds, spells, etc
	function _details:GetBossDetails(mapid, bossindex)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex]
	end
	
	--> return a table with all names of boss enemies
	function _details:GetEncounterActors(mapid, bossindex)
		
	end
	
	--> return a table with spells id of specified encounter
	function _details:GetEncounterSpells(mapid, bossindex)
		local encounter = _details:GetBossDetails(mapid, bossindex)
		local abilities_poll = {}
		if (encounter.continuo) then
			for index, spellid in _ipairs(encounter.continuo) do 
				abilities_poll[spellid] = true
			end
		end
		local fases = encounter.phases
		for fase_id, fase in _ipairs(fases) do 
			if (fase.spells) then
				for index, spellid in _ipairs(fase.spells) do 
					abilities_poll[spellid] = true
				end
			end
		end
		return abilities_poll
	end
	
	--> return a table with all boss ids from a raid instance
	function _details:GetBossIds(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].boss_ids
	end
	
	function _details:InstanceIsRaid(mapid)
		return _details:InstanceisRaid(mapid)
	end
	function _details:InstanceisRaid(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].is_raid
	end
	
	--> return a table with all encounter names present in raid instance
	function _details:GetBossNames(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].boss_names
	end
	
	--> return the encounter name
	function _details:GetBossName(mapid, bossindex)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].boss_names[bossindex]
	end
	
	--> same thing as GetBossDetails, just a alias
	function _details:GetBossEncounterDetails(mapid, bossindex)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex]
	end
	
	--> return the wallpaper for the raid instance
	function _details:GetRaidBackground(mapid)
		local bosstables = _details.EncounterInformation[mapid]
		if (bosstables) then
			local bg = bosstables.backgroundFile
			if (bg) then
				return bg.file, unpack(bg.coords)
			end
		end
	end
	--> return the icon for the raid instance
	function _details:GetRaidIcon(mapid)
		return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].icon
	end
	
	--> return the boss icon
	function _details:GetBossIcon(mapid, bossindex)
		if (_details.EncounterInformation[mapid]) then
			local line = math.ceil(bossindex / 4)
			local x =( bossindex -((line-1) * 4 ) )  / 4
			return x-0.25, x, 0.25 *(line-1), 0.25 * line, _details.EncounterInformation[mapid].icons
		end
	end
	
	--> return the boss portrit
	function _details:GetBossPortrait(mapid, bossindex)
		if (mapid and bossindex) then
			return _details.EncounterInformation[mapid] and _details.EncounterInformation[mapid].encounters[bossindex].portrait
		else
			return false
		end
	end
	
	--> return a list with names of adds and bosses
	function _details:GetEncounterActorsName(EJ_EncounterID)
		--code snippet from wowpedia
		local actors = {}
		local stack, encounter, _, _, curSectionID = {}, EJ_GetEncounterInfo(EJ_EncounterID)
		repeat
			local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = EJ_GetSectionInfo(curSectionID)
			if (displayInfo ~= 0 and abilityIcon == "") then
				actors[title] = {model = displayInfo, info = description}
			end
			table.insert(stack, siblingID)
			table.insert(stack, nextSectionID)
			curSectionID = table.remove(stack)
		until not curSectionID
		
		return actors
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details:InstallEncounter(InstanceTable)
		_details.EncounterInformation[InstanceTable.id] = InstanceTable
		return true
	end
end