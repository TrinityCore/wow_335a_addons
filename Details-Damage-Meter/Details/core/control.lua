--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	local _timestamp = time()
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	
	local _math_floor = math.floor --lua local
	local _math_max = math.max --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _table_wipe = table.wipe --lua local
	local _bit_band = bit.band --lua local
	
	local _GetInstanceInfo = GetInstanceInfo --wow api local
	local _UnitExists = UnitExists --wow api local
	local _UnitGUID = UnitGUID --wow api local
	local _UnitName = UnitName --wow api local

	local _IsAltKeyDown = IsAltKeyDown
	local _IsShiftKeyDown = IsShiftKeyDown
	local _IsControlKeyDown = IsControlKeyDown
	
	local attribute_damage = _details.attribute_damage --details local
	local attribute_heal = _details.attribute_heal --details local
	local attribute_energy = _details.attribute_energy --details local
	local attribute_misc = _details.attribute_misc --details local
	local attribute_custom = _details.attribute_custom --details local
	local info = _details.window_info --details local
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local mode_GROUP = _details.modes.group
	local mode_ALL = _details.modes.all
	local class_type_damage = _details.attributes.damage
	local OBJECT_TYPE_PETS = 0x00003000
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> try to find the opponent of last fight, can be called during a fight as well
		function _details:FindEnemy()
			
			local zoneName, InstanceType, DifficultyID, _, _, _ = _GetInstanceInfo()
			if (InstanceType == "party" or InstanceType == "raid") then
				return Loc["STRING_SEGMENT_TRASH"]
			end
			
			for _, actor in _ipairs(_details.table_current[class_type_damage]._ActorTable) do 
			
				if (not actor.group and not actor.owner and not actor.name:find("[*]") and _bit_band(actor.flag_original, 0x00000060) ~= 0) then --> 0x20+0x40 neutral + enemy reaction
					for name, _ in _pairs(actor.targets._NameIndexTable) do
						if (name == _details.playername) then
							return actor.name
						else
							local _target_actor = _details.table_current(class_type_damage, name)
							if (_target_actor and _target_actor.group) then 
								return actor.name
							end
						end
					end
				end
				
			end
			
			for _, actor in _ipairs(_details.table_current[class_type_damage]._ActorTable) do 
			
				if (actor.group and not actor.owner) then
					for index, target in _ipairs(actor.targets._ActorTable) do 
						return target.name
					end
				end
				
			end
			
			return Loc["STRING_UNKNOW"]
		end
	
	-- try get the current encounter name during the encounter
	
		local boss_found = function(index, name, zone, mapid, diff)
			local boss_table = {
				index = index,
				name = name,
				encounter = name,
				zone = zone,
				mapid = mapid,
				diff = diff,
				diff_string = select(4, GetInstanceInfo()),
				--ej_instance_id = EJ_GetCurrentInstance(),
			}
			
			_details.table_current.is_boss = boss_table
			
			if (_details.in_combat and not _details.leaving_combat) then
			
				--> catch boss function if any
				local bossFunction, bossFunctionType = _details:GetBossFunction(zoneMapID, BossIndex)
				if (bossFunction) then
					if (_bit_band(bossFunctionType, 0x1) ~= 0) then --realtime
						_details.bossFunction = bossFunction
						_details.table_current.bossFunction = _details:ScheduleTimer("bossFunction", 1)
					end
				end
				
				if (_details.zone_type ~= "raid") then
					local endType, endData = _details:GetEncounterEnd(zoneMapID, BossIndex)
					if (endType and endData) then
					
						if (_details.debug) then
							_details:Msg("(debug) setting boss end type to:", endType)
						end
					
						_details.encounter_end_table.type = endType
						_details.encounter_end_table.killed = {}
						_details.encounter_end_table.data = {}
						
						if (type(endData) == "table") then
							if (_details.debug) then
								_details:Msg("(debug) boss type is table:", endType)
							end
							if (endType == 1 or endType == 2) then
								for _, npcID in ipairs(endData) do 
									_details.encounter_end_table.data[npcID] = false
								end
							end
						else
							if (endType == 1 or endType == 2) then
								_details.encounter_end_table.data[endData] = false
							end
						end
					end
				end
			end
			
			_details:SendEvent("COMBAT_BOSS_FOUND", nil, index, name)
			
			return boss_table
		end
	
		function _details:ReadBossFrames()
		
			if (_details.table_current.is_boss) then
				return --no need to check
			end
		
			if (_details.encounter_table.name) then
				local encounter_table = _details.encounter_table
				return boss_found(encounter_table.index, encounter_table.name, encounter_table.zone, encounter_table.mapid, encounter_table.diff)
			end
		
			for index = 1, 5, 1 do 
				if (_UnitExists("boss"..index)) then 
					local guid = _UnitGUID("boss"..index)
					if (guid) then
						local serial = tonumber(guid:sub(9, 12), 16)
						
						if (serial) then
						
							local zoneName, zoneType, DifficultyID, _, _, _ = _GetInstanceInfo()
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
							local BossIds = _details:GetBossIds(zoneMapID)
							if (BossIds) then
								local BossIndex = BossIds[serial]

								if (BossIndex) then 
									if (_details.debug) then
										_details:Msg("(debug) boss found:",_details:GetBossName(zoneMapID, BossIndex))
									end
									
									return boss_found(BossIndex, _details:GetBossName(zoneMapID, BossIndex), zoneName, zoneMapID, DifficultyID)
								end
							end
						end
					end
				end
			end
		end	
	
	--try to get the encounter name after the encounter(can be called during the combat as well)
		function _details:FindBoss()

			if (_details.encounter_table.name) then
				local encounter_table = _details.encounter_table
				return boss_found(encounter_table.index, encounter_table.name, encounter_table.zone, encounter_table.mapid, encounter_table.diff)
			end
		
			local zoneName, zoneType, DifficultyID, _, _, _ = _GetInstanceInfo()
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
			
			local BossIds = _details:GetBossIds(zoneMapID)
			
			if (BossIds) then
				local BossIndex = nil
				local ActorsContainer = _details.table_current[class_type_damage]._ActorTable
				
				if (ActorsContainer) then
					for index, Actor in _ipairs(ActorsContainer) do 
						if (not Actor.group) then
							local serial = tonumber(Actor.serial:sub(9, 12), 16)
							if (serial) then
								BossIndex = BossIds[serial]
								if (BossIndex) then
									Actor.boss = true
									Actor.shadow.boss = true
									return boss_found(BossIndex, _details:GetBossName(zoneMapID, BossIndex), zoneName, zoneMapID, DifficultyID)
								end
							end
						end
					end
				end
			end
			
			return false
		end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

		-- ~start
		function _details:EnterCombat(...)

			if (_details.debug) then
				_details:Msg("(debug) started a new combat.")
			end

			--> não tem history, addon foi resetado, a primeira table é descartada -- Erase first table is do es not have a firts segment history, this occour after reset or first run
			if (not _details.table_history.tables[1]) then 
				--> precisa zerar aqui a table overall
				_table_wipe(_details.table_overall)
				_table_wipe(_details.table_current)
				--> aqui ele lost o self.showing das instâncias, precisa do com que elas atualizem
				_details.table_overall = _details.combat:Newtable()
				
				_details:instanceCallFunction(_details.ResetGump, nil, -1) --> reseta scrollbar, iterators, rodapé, etc
				_details:instanceCallFunction(_details.instanceFadeBars, -1) --> esconde todas as bars
				_details:instanceCallFunction(_details.UpdateSegments) --> atualiza o showing
			end

			--> conta o time na table overall -- start time at overall table
			if (_details.table_overall.end_time) then
				_details.table_overall.start_time = _timestamp -(_details.table_overall.end_time - _details.table_overall.start_time)
				_details.table_overall.end_time = nil
			else
				_details.table_overall.start_time = _timestamp
			end

			--> re-lock nos times da table passada -- lock again last table times
			_details.table_current:LockTimes() --> lá em cima é feito wipe, não deveria ta dando merda nisso aqui? ou ela puxa da __index e da zero players no mapa e container
			
			local n_combat = _details:NumeroCombate(1) --aumenta o contador de combats -- combat number up
			
			--> cria a new table de combats -- create new table
			local ultimo_combat = _details.table_current
			_details.table_current = _details.combat:Newtable(true, _details.table_overall, n_combat, ...) --cria uma new table de combat
			_details.table_current.previous_combat = ultimo_combat
			
			--> verifica se há alguma instância showing o segment atual -- change segment
			_details:instanceCallFunction(_details.SwitchSegmentoAtual)

			_details.table_current:seta_data(_details._details_props.DATA_TYPE_START) --seta na table do combat a data do start do combat -- setup time data
			_details.in_combat = true --sinaliza ao addon que há um combat em andamento -- in combat flag up
			
			_details.table_current.combat_id = n_combat --> grava o número dthis combat na table atual -- setup combat id on new table
			
			--> é o timer que ve se o player ta em combat ou não -- check if any party or raid members are in combat
			_details.table_current.verifica_combat = _details:ScheduleRepeatingTimer("EstaEmCombate", 1) 

			_table_wipe(_details.encounter_end_table)
			
			_table_wipe(_details.pets_ignored)
			_table_wipe(_details.pets_no_owner)
			_details.container_pets:BuscarPets()
			
			_table_wipe(_details.cache_damage_group)
			_table_wipe(_details.cache_healing_group)
			_details:UpdateParserGears()
			
			_details.host_of = nil
			_details.host_by = nil
			
			if (_details.in_group and _details.cloud_capture) then
				if (_details:IsInInstance() or _details.debug) then
					if (not _details:CaptureIsAllEnabled()) then
						_details:ScheduleSendCloudRequest()
						if (_details.debug) then
							_details:Msg("(debug) requesting a cloud server.")
						end
					end
				else
					if (_details.debug) then
						_details:Msg("(debug) isn't inside a registred instance", _details:IsInInstance())
					end
				end
			else
				if (_details.debug) then
					_details:Msg("(debug) isn't in group or cloud is turned off", _details.in_group, _details.cloud_capture)
				end
			end
			
			_details:CatchRaidBuffUptime("BUFF_UPTIME_IN")
			_details:CatchRaidDebuffUptime("DEBUFF_UPTIME_IN")
			_details:UptadeRaidMembersCache()
			
			--> hide / alpha / switch in combat
			for index, instance in ipairs(_details.table_instances) do 
				if (instance.active) then
					--instance:SetCombatAlpha(nil, nil, true) --passado para o regen disable
					instance:CheckSwitchOnCombatStart(true)
				end
			end
			
			_details:SendEvent("COMBAT_PLAYER_ENTER", nil, _details.table_current)
			_details:HaveOneCurrentInstance()
			
		end
		
		function _details:DelayedSyncAlert()
			local lower_instance = _details:GetLowerInstanceNumber()
			if (lower_instance) then
				lower_instance = _details:GetInstance(lower_instance)
				if (lower_instance) then
					if (not lower_instance:HaveInstanceAlert()) then
						lower_instance:InstanceAlert(Loc["STRING_EQUILIZING"], {[[Interface\AddOns\Details\images\StreamCircle]], 22, 22, true}, 5, {function() end})
					end
				end
			end
		end
		
		-- ~end
		function _details:EndCombat(bossKilled, from_encounter_end)
		
			if (_details.debug) then
				_details:Msg("(debug) ended a combat.")
			end
			
			_details.leaving_combat = true
			
			if (_details.schedule_remove_overall and not from_encounter_end and not InCombatLockdown()) then
				if (_details.debug) then
					_details:Msg("(debug) found schedule overall data deletion.")
				end
				_details.schedule_remove_overall = false
				_details.table_history:reset_overall()
			end
			
			_details:CatchRaidBuffUptime("BUFF_UPTIME_OUT")
			_details:CatchRaidDebuffUptime("DEBUFF_UPTIME_OUT")
			_details:CloseEnemyDebuffsUptime()
			
			--> ugly fix for warlocks soul link, need to rewrite friendly fire code.
			for index, actor in pairs(_details.table_current[1]._ActorTable) do
				if (actor.class == "WARLOCK") then
					local soullink = actor.spell_tables._ActorTable[108446]
					if (soullink) then
						actor.total = actor.total - soullink.total
						actor.total_without_pet = actor.total_without_pet - soullink.total
						soullink.total = 0
					end
				end
			end
			
			--> pega a zona do player e vê se foi uma fight against um Boss -- identifica se a fight foi com um boss
			if (not _details.table_current.is_boss) then 
		
				--> function which runs after a boss encounter to try recognize a encounter
				_details:FindBoss()
				
				if (not _details.table_current.is_boss) then
					local zoneName, zoneType, DifficultyID, _, _, _ = _GetInstanceInfo()
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
					local findboss = _details:GetRaidBossFindFunction(zoneMapID)
					if (findboss) then
						local BossIndex = findboss()
						if (BossIndex) then
							boss_found(BossIndex, _details:GetBossName(zoneMapID, BossIndex), zoneName, zoneMapID, DifficultyID)
						end
					end
				end
			end
			
			if (_details.table_current.bossFunction) then
				_details:CancelTimer(_details.table_current.bossFunction)
				_details.bossFunction = nil
			end

			--> finaliza a checagem se this ou não no combat -- finish combat check
			if (_details.table_current.verifica_combat) then 
				_details:CancelTimer(_details.table_current.verifica_combat)
				_details.table_current.verifica_combat = nil
			end

			--> lock timers
			_details.table_current:LockTimes() 
			
			_details.table_current:seta_data(_details._details_props.DATA_TYPE_END) --> salva hora, minuto, segundo do end da fight
			_details.table_overall:seta_data(_details._details_props.DATA_TYPE_END) --> salva hora, minuto, segundo do end da fight
			_details.table_current:seta_time_elapsed() --> salva o end_time
			_details.table_overall:seta_time_elapsed() --seta o end_time
			
			--> drop last events table to garbage collector
			_details.table_current.player_last_events = {}
			
			--> flag instance type
			local _, InstanceType = _GetInstanceInfo()
			_details.table_current.instance_type = InstanceType
			
			if (not _details.table_current.is_boss) then

				if (InstanceType == "party" or InstanceType == "raid") then
					_details.table_current.is_trash = true
				end
				
				if (not _details.table_current.enemy) then
					local enemy = _details:FindEnemy()
					
					if (enemy and _details.debug) then
						_details:Msg("(debug) enemy found", enemy)
					end
					
					_details.table_current.enemy = enemy
				end
				
				if (_details.debug) then
					_details:Msg("(debug) forcing ewhichize actors behavior.")
					_details:EwhichizeActorsSchedule(_details.host_of)
				end
				
				--> verifica memory
				_details:FlagActorsOnCommonFight() --fight_component
				_details:CheckMemoryAfterCombat()
				
			else
			
				if (not InCombatLockdown() and not UnitAffectingCombat("player")) then
					_details:FlagActorsOnBossFight()
				else
					_details.schedule_flag_boss_components = true
				end
				
				if (bossKilled) then
					_details.table_current.is_boss.killed = true
				end

				if (_details:GetBossDetails(_details.table_current.is_boss.mapid, _details.table_current.is_boss.index)) then
					
					_details.table_current.enemy = _details.table_current.is_boss.encounter

					if (_details.table_current.instance_type == "raid") then
					
						_details.last_encounter2 = _details.last_encounter
						_details.last_encounter = _details.table_current.is_boss.name

						if (_details.pre_pot_used and _details.announce_prepots.enabled) then
							_details:Msg(_details.pre_pot_used or "")
							_details.pre_pot_used = nil
						end
					end
					
					if (from_encounter_end) then
						_details.table_current.end_time = _details.encounter_table["end"]
					end

					--> encounter boss function
					local bossFunction, bossFunctionType = _details:GetBossFunction(_details.table_current.is_boss.mapid, _details.table_current.is_boss.index)
					if (bossFunction) then
						if (_bit_band(bossFunctionType, 0x2) ~= 0) then --end of combat
							bossFunction()
						end
					end
					
					if (_details.table_current.instance_type == "raid") then
						--> schedule captures off
						
						_details:CaptureSet(false, "damage", false, 15)
						_details:CaptureSet(false, "energy", false, 15)
						_details:CaptureSet(false, "aura", false, 15)
						_details:CaptureSet(false, "energy", false, 15)
						_details:CaptureSet(false, "spellcast", false, 15)
						
						if (_details.debug) then
							_details:Msg("(debug) freezing parser for 15 seconds.")
						end
					end
					
					--> schedule sync
					_details:EwhichizeActorsSchedule(_details.host_of)
					if (_details:GetEncounterEwhichize(_details.table_current.is_boss.mapid, _details.table_current.is_boss.index)) then
						_details:ScheduleTimer("DelayedSyncAlert", 3)
					end
					
				else
					if (_details.debug) then
						_details:EwhichizeActorsSchedule(_details.host_of)
					end
				end
			end

			if (_details.solo) then
				--> debuffs need a checkup, not well functional right now
				_details.CloseSoloDebuffs()
			end
			
			local time_of_combat = _details.table_current.end_time - _details.table_current.start_time
			
			--if ( time_of_combat >= _details.minimum_combat_time) then --> time minimo precisa ser 5 seconds pra acrecentar a table ao history
			if ( time_of_combat >= 5 or not _details.table_history.tables[1]) then --> time minimo precisa ser 5 seconds pra acrecentar a table ao history
				_details.table_history:adicionar(_details.table_current) --move a table atual para dentro do histórico
			else
				--> this is a little bit complicated, need a specific function for combat cancellation
			
				--_table_wipe(_details.table_current) --> descarta ela, não será mais usada
				_details.table_current = _details.table_history.tables[1] --> pega a table do ultimo combat

				if (_details.table_current.start_time == 0) then
					_details.table_current.start_time = _details._time
					_details.table_current.end_time = _details._time
				end
				
				_details.table_current.resincked = true
				
				--> table foi descartada, precisa atualizar os baseframes // precisa atualizer todos ou apenas o overall?
				_details:instanceCallFunction(_details.ActualizeWindow)
				
				if (_details.solo) then
					local this_instance = _details.table_instances[_details.solo]
					if (_details.SoloTables.CombatID == _details:NumeroCombate()) then --> significa que o solo mode validou o combat, como matar um bixo muito low level com uma só porrada
						if (_details.SoloTables.CombatIDLast and _details.SoloTables.CombatIDLast ~= 0) then --> volta os dados da fight previous
						
							_details.SoloTables.CombatID = _details.SoloTables.CombatIDLast
						
						else
							if (_details.RefreshSolo) then
								_details:RefreshSolo()
							end
							_details.SoloTables.CombatID = nil
						end
					end
				end
				
				_details:NumeroCombate(-1)
			end
			
			_details.host_of = nil
			_details.host_by = nil
			
			if (_details.cloud_process) then
				_details:CancelTimer(_details.cloud_process)
			end
			
			_details.in_combat = false --sinaliza ao addon que não há combat no momento
			_details.leaving_combat = false --sinaliza que não this mais saindo do combat
			
			_table_wipe(_details.cache_damage_group)
			_table_wipe(_details.cache_healing_group)
			
			_details:UpdateParserGears()
			
			--> hide / alpha in combat
			for index, instance in ipairs(_details.table_instances) do 
				if (instance.active) then
					--instance:SetCombatAlpha(nil, nil, true) --passado para o regen enabled
					if (instance.auto_switch_to_old) then
						instance:CheckSwitchOnCombatEnd()
					end
				end
			end
			
			_details.pre_pot_used = nil
			_table_wipe(_details.encounter_table)
			
			_details:SendEvent("COMBAT_PLAYER_LEAVE", nil, _details.table_current)
		end

		function _details:GetPlayersInArena()
			local aliados = GetNumPartyMembers()
			for i = 1, aliados do
				local role = UnitGroupRolesAssigned("party" .. i)
				if (role ~= "NONE") then
					local name = GetUnitName("party" .. i, true)
					_details.arena_table[name] = {role = role}
				end
			end
			
			local role = UnitGroupRolesAssigned("player")
			if (role ~= "NONE") then
				local name = GetUnitName("player", true)
				_details.arena_table[name] = {role = role}
			end
			if (_details.debug) then
				_details:Msg("(debug) Found", oponentes, "enemies and", aliados, "allies")
			end
		end
		
		function _details:CreateArenaSegment()
		
			_details:GetPlayersInArena()
		
			_details.arena_begun = true
			_details.start_arena = nil
		
			if (_details.in_combat) then
				_details:EndCombat()
			end
		
			--> inicia um novo combat
			_details:EnterCombat()
		
			--> sinaliza que esse combat é arena
			_details.table_current.arena = true
			_details.table_current.is_arena = {name = _details.zone_name, zone = _details.zone_name, mapid = _details.zone_id}
		end
		
		function _details:StartArenaSegment(...)
			if (_details.debug) then
				_details:Msg("(debug) starting a new arena segment.")
			end
			
			local timerType, timeSeconds, totalTime = select(1, ...)
			
			if (_details.start_arena) then
				_details:CancelTimer(_details.start_arena, true)
			end
			_details.start_arena = _details:ScheduleTimer("CreateArenaSegment", timeSeconds)
			_details:GetPlayersInArena()
		end

		function _details:EnteredInArena()

			if (_details.debug) then
				_details:Msg("(debug) arena detected.")
			end
		
			_details.arena_begun = false

			_details:GetPlayersInArena()
		end
		
		function _details:LeftArena()
		
			_details.is_in_arena = false
			_details.arena_begun = false
		
			if (_details.start_arena) then
				_details:CancelTimer(_details.start_arena, true)
			end
		end
		
		function _details:MakeEwhichizeOnActor(player, realm, receivedActor)
		
			local combat = _details:GetCombat("current")
			local damage, heal, energy, misc = _details:GetAllActors("current", player)
			
			if (not damage and not heal and not energy and not misc) then
			
				--> try adding server name
				damage, heal, energy, misc = _details:GetAllActors("current", player.."-"..realm)
				
				if (not damage and not heal and not energy and not misc) then
					--> not found any actor object, so we need to create
					
					local actorName
					
					if (realm ~= GetRealmName()) then
						actorName = player.."-"..realm
					else
						actorName = player
					end
					
					local guid = _details:FindGUIDFromName(player)
					
					-- 0x512 normal party
					-- 0x514 normal raid
					
					if (guid) then
						damage = combat[1]:CatchCombatant(guid, actorName, 0x514, true)
						heal = combat[2]:CatchCombatant(guid, actorName, 0x514, true)
						energy = combat[3]:CatchCombatant(guid, actorName, 0x514, true)
						misc = combat[4]:CatchCombatant(guid, actorName, 0x514, true)
						
						if (_details.debug) then
							_details:Msg("(debug) ewhichize received actor:", actorName, damage, heal)
						end
					else
						if (_details.debug) then
							_details:Msg("(debug) ewhichize couldn't get guid for player ",player)
						end
					end
				end
			end
			
			combat[1].need_refresh = true
			combat[2].need_refresh = true
			combat[3].need_refresh = true
			combat[4].need_refresh = true
			
			if (damage) then
				if (damage.total < receivedActor[1][1]) then
					if (_details.debug) then
						_details:Msg(player .. " damage before: " .. damage.total .. " damage received: " .. receivedActor[1][1])
					end
					damage.total = receivedActor[1][1]
				end
				if (damage.damage_taken < receivedActor[1][2]) then
					damage.damage_taken = receivedActor[1][2]
				end
				if (damage.friendlyfire_total < receivedActor[1][3]) then
					damage.friendlyfire_total = receivedActor[1][3]
				end
			end
			
			if (heal) then
				if (heal.total < receivedActor[2][1]) then
					heal.total = receivedActor[2][1]
				end
				if (heal.totalover < receivedActor[2][2]) then
					heal.totalover = receivedActor[2][2]
				end
				if (heal.healing_taken < receivedActor[2][3]) then
					heal.healing_taken = receivedActor[2][3]
				end
			end
			
			if (energy) then
				if (energy.mana and(receivedActor[3][1] > 0 and energy.mana < receivedActor[3][1])) then
					energy.mana = receivedActor[3][1]
				end
				if (energy.e_rage and(receivedActor[3][2] > 0 and energy.e_rage < receivedActor[3][2])) then
					energy.e_rage = receivedActor[3][2]
				end
				if (energy.e_energy and(receivedActor[3][3] > 0 and energy.e_energy < receivedActor[3][3])) then
					energy.e_energy = receivedActor[3][3]
				end
				if (energy.runepower and(receivedActor[3][4] > 0 and energy.runepower < receivedActor[3][4])) then
					energy.runepower = receivedActor[3][4]
				end
			end
			
			if (misc) then
				if (misc.interrupt and(receivedActor[4][1] > 0 and misc.interrupt < receivedActor[4][1])) then
					misc.interrupt = receivedActor[4][1]
				end
				if (misc.dispell and(receivedActor[4][2] > 0 and misc.dispell < receivedActor[4][2])) then
					misc.dispell = receivedActor[4][2]
				end
			end
		end
		
		function _details:EwhichizePets()
			--> check for pets without owner
			for _, actor in _ipairs(_details.table_current[1]._ActorTable) do 
				--> have flag and the flag tell us he is a pet
				if (actor.flag_original and bit.band(actor.flag_original, OBJECT_TYPE_PETS) ~= 0) then
					--> do not have owner and he isn't on owner container
					if (not actor.owner and not _details.table_pets.pets[actor.serial]) then
						_details:SendPetOwnerRequest(actor.serial, actor.name)
					end
				end
			end
		end
		
		function _details:EwhichizeActorsSchedule(host_of)
		
			--> store pets sent through 'needpetowner'
			_details.sent_pets = _details.sent_pets or {n = time()}
			if (_details.sent_pets.n+20 < time()) then
				_table_wipe(_details.sent_pets)
				_details.sent_pets.n = time()
			end
			
			--> pet equilize disabled on details 1.4.0
			--_details:ScheduleTimer("EwhichizePets", 1+math.random())

			--> do not equilize if there is any disabled capture
			--if (_details:CaptureIsAllEnabled()) then
				_details:ScheduleTimer("EwhichizeActors", 2+math.random()+math.random() , host_of)
			--end
		end
		
		function _details:EwhichizeActors(host_of)
		
			if (_details.debug) then
				_details:Msg("(debug) sending equilize actor data")
			end
		
			local damage, heal, energy, misc
		
			if (host_of) then
				damage, heal, energy, misc = _details:GetAllActors("current", host_of)
			else
				damage, heal, energy, misc = _details:GetAllActors("current", _details.playername)
			end
			
			if (damage) then
				damage = {damage.total or 0, damage.damage_taken or 0, damage.friendlyfire_total or 0}
			else
				damage = {0, 0, 0}
			end
			
			if (heal) then
				heal = {heal.total or 0, heal.totalover or 0, heal.healing_taken or 0}
			else
				heal = {0, 0, 0}
			end
			
			if (energy) then
				energy = {energy.mana or 0, energy.e_rage or 0, energy.e_energy or 0, energy.runepower or 0}
			else
				energy = {0, 0, 0, 0}
			end
			
			if (misc) then
				misc = {misc.interrupt or 0, misc.dispell or 0}
			else
				misc = {0, 0}
			end
			
			local data = {damage, heal, energy, misc}

			--> send os dados do proprio host pra ele antes
			if (host_of) then
				_details:SendRaidDataAs(_details.network.ids.CLOUD_EQUALIZE, host_of, nil, data)
				_details:EwhichizeActors()
			else
				_details:SendRaidData(_details.network.ids.CLOUD_EQUALIZE, data)
			end
			
		end
		
		function _details:FlagActorsOnBossFight()
			for class_type, container in _ipairs(_details.table_current) do 
				for _, actor in _ipairs(container._ActorTable) do 
					actor.boss_fight_component = true
					if (actor.shadow) then 
						actor.shadow.boss_fight_component = true
					end
				end
			end
		end
		
		local fight_component = function(energy_container, misc_container, name)
			local on_energy = energy_container._ActorTable[energy_container._NameIndexTable[name]]
			if (on_energy) then
				on_energy.fight_component = true
				if (on_energy.shadow) then
					on_energy.shadow.fight_component = true
				end
			end
			local on_misc = misc_container._ActorTable[misc_container._NameIndexTable[name]]
			if (on_misc) then
				on_misc.fight_component = true
				if (on_misc.shadow) then
					on_misc.shadow.fight_component = true
				end
			end
		end
		
		function _details:FlagActorsOnCommonFight()
		
			local damage_container = _details.table_current[1]
			local healing_container = _details.table_current[2]
			local energy_container = _details.table_current[3]
			local misc_container = _details.table_current[4]
			
			for class_type, container in _ipairs({damage_container, healing_container}) do 
			
				for _, actor in _ipairs(container._ActorTable) do 
					if (actor.group) then
						if (class_type == 1 or class_type == 2) then
							for _, target_actor in _ipairs(actor.targets._ActorTable) do 
								local target_object = container._ActorTable[container._NameIndexTable[target_actor.name]]
								if (target_object) then
									target_object.fight_component = true
									if (target_object.shadow) then
										target_object.shadow.fight_component = true
									end
									fight_component(energy_container, misc_container, target_actor.name)
								end
							end
							if (class_type == 1) then
								for damager_actor, _ in _pairs(actor.damage_from) do 
									local target_object = container._ActorTable[container._NameIndexTable[damager_actor]]
									if (target_object) then
										target_object.fight_component = true
										if (target_object.shadow) then
											target_object.shadow.fight_component = true
										end
										fight_component(energy_container, misc_container, damager_actor)
									end
								end
							elseif (class_type == 2) then
								for healer_actor, _ in _pairs(actor.healing_from) do 
									local target_object = container._ActorTable[container._NameIndexTable[healer_actor]]
									if (target_object) then
										target_object.fight_component = true
										if (target_object.shadow) then
											target_object.shadow.fight_component = true
										end
										fight_component(energy_container, misc_container, healer_actor)
									end
								end
							end
						end
					end
				end
				
			end
		end

		function _details:ActualizeWindow(instance, _segment)
			if (_segment) then --> apenas atualizar windows que thisjam showing o segment solicitado
				if (_segment == instance.segment) then
					instance:SwitchTable(instance, instance.segment, instance.attribute, instance.sub_attribute, true)
				end
			else
				if (instance.mode == mode_GROUP or instance.mode == mode_ALL) then
					instance:SwitchTable(instance, instance.segment, instance.attribute, instance.sub_attribute, true)
				end
			end
		end

		function _details:SwitchSegmentoAtual(instance)
			if (instance.segment == 0) then --> this showing a table Atual
				instance.showing =_details.table_current
				instance:ResetGump()
				_details.gump:Fade(instance, "in", nil, "bars")
			end
		end

	--> internal GetCombatId() version
		function _details:NumeroCombate(flag)
			if (flag == 0) then
				_details.combat_id = 0
			elseif (flag) then
				_details.combat_id = _details.combat_id + flag
			end
			return _details.combat_id
		end

	--> tooltip fork / search key: ~tooltip
		local avatarPoint = {"bottomleft", "topleft", -3, -4}
		local backgroundPoint = {{"bottomleft", "topleft", 0, -3}, {"bottomright", "topright", 0, -3}}
		local textPoint = {"left", "right", -11, -5}
		local avatarTexCoord = {0, 1, 0, 1}
		
		function _details:AddTooltipBackgroundStatusbar()
			GameCooltip:AddStatusBar(100, 1, unpack(_details.tooltip.background))
		end
		
		function _details:AddTooltipSpellHeaderText(headerText, headerColor, r, g, b, amount)
			if (_details.tooltip.show_amount) then
				GameCooltip:AddLine(headerText, "x" .. amount .. "", nil, headerColor, r, g, b, .2, 12)
			else
				GameCooltip:AddLine(headerText, nil, nil, headerColor, nil, 12)
			end
		end
		
		function _details:SetTooltip(frame, which_bar, keydown)
			
			local GameCooltip = GameCooltip
			GameCooltip:Reset()
			GameCooltip:SetType("tooltip")
			
			GameCooltip:SetOption("TextSize", _details.tooltip.fontsize)
			GameCooltip:SetOption("TextFont",  _details.tooltip.fontface)
			GameCooltip:SetOption("TextColor", _details.tooltip.fontcolor)
			GameCooltip:SetOption("TextShadow", _details.tooltip.fontshadow and "OUTLINE")
			
			GameCooltip:SetOption("LeftBorderSize", -5)
			GameCooltip:SetOption("RightBorderSize", 5)
			GameCooltip:SetOption("MinWidth", _math_max(230, self.baseframe:GetWidth()*0.8))
			GameCooltip:SetOption("StatusBarTexture",[[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]]) --[[Interface\Addons\Details\images\bar_flat]]

			GameCooltip:SetBackdrop(1, _details.tooltip_backdrop, nil, _details.tooltip_border_color)
			
			local myPoint = _details.tooltip.anchor_point
			local anchorPoint = _details.tooltip.anchor_relative
			local x_Offset = _details.tooltip.anchor_offset[1]
			local y_Offset = _details.tooltip.anchor_offset[2]
			
			if (_details.tooltip.anchored_to == 1) then
				GameCooltip:SetHost(frame, myPoint, anchorPoint, x_Offset, y_Offset)
			else
				GameCooltip:SetHost(DetailsTooltipAnchor, myPoint, anchorPoint, x_Offset, y_Offset)
			end
			
			local this_bar = self.bars[which_bar] --> bar que o mouse passou em cima e irá mostrar o tooltip
			local objeto = this_bar.my_table --> pega a referencia da table --> retorna a class_damage ou class_heal
			if (not objeto) then --> a bar não possui um objeto
				return false
			end

			--verifica por tooltips especiais:
			if (objeto.dead) then --> é uma bar de dead
				return _details:ToolTipDead(self, objeto, this_bar, keydown) --> instância,[death], bar
			elseif (objeto.frags) then
				return _details:ToolTipFrags(self, objeto, this_bar, keydown)
			elseif (objeto.boss_debuff) then
				return _details:ToolTipVoidZones(self, objeto, this_bar, keydown)
			end
			
			local t = objeto:ToolTip(self, which_bar, this_bar, keydown) --> instância, nº bar, objeto bar, keydown
			
			if (t) then
			
				if (this_bar.my_table.serial and this_bar.my_table.serial ~= "") then
					local avatar = NickTag:GetNicknameTable(this_bar.my_table.serial)
					if (avatar) then
						if (avatar[2] and avatar[4] and avatar[1]) then
							GameCooltip:SetBannerImage(1, avatar[2], 80, 40, avatarPoint, avatarTexCoord, nil) --> overlay[2] avatar path
							GameCooltip:SetBannerImage(2, avatar[4], 200, 55, backgroundPoint, avatar[5], avatar[6]) --> background
							GameCooltip:SetBannerText(1, avatar[1], textPoint) --> text[1] nickname
						end
					end
				end

				GameCooltip:ShowCooltip()
			end
		end
		
		function _details.gump:UpdateTooltip(which_bar, this_bar, instance)
			if (_IsShiftKeyDown()) then
				return instance:SetTooltip(this_bar, which_bar, "shift")
			elseif (_IsControlKeyDown()) then
				return instance:SetTooltip(this_bar, which_bar, "ctrl")
			elseif (_IsAltKeyDown()) then
				return instance:SetTooltip(this_bar, which_bar, "alt")
			else
				return instance:SetTooltip(this_bar, which_bar)
			end
		end

		function _details:EndRefresh(instance, total, combat_table, showing)
			_details:HideBarsNotUsed(instance, showing)
		end
		
		function _details:HideBarsNotUsed(instance, showing)
			--> primeira atualização após uma mudança de segment -->  verifica se há mais bars sendo mostradas do que o necessário	
			--------------------
				if (instance.v_bars) then
					for bar_number = instance.rows_showing+1, instance.rows_created do
						_details.gump:Fade(instance.bars[bar_number], "in")
					end
					instance.v_bars = false
				end

			return showing
		end

	--> call update functions
		function _details:ActualizeALL(force)

			local combat_table = self.showing

			--> confere se a instância possui uma table válida
			if (not combat_table) then
				if (not self.freezed) then
					return self:Freeze()
				end
				return
			end

			local need_refresh = combat_table[self.attribute].need_refresh
			if (not need_refresh and not force) then
				return --> não precisa de refresh
			--else
				--combat_table[self.attribute].need_refresh = false
			end
			
			if (self.attribute == 1) then --> damage
				return attribute_damage:RefreshWindow(self, combat_table, force, nil, need_refresh)
			elseif (self.attribute == 2) then --> heal
				return attribute_heal:RefreshWindow(self, combat_table, force, nil, need_refresh)
			elseif (self.attribute == 3) then --> energy
				return attribute_energy:RefreshWindow(self, combat_table, force, nil, need_refresh)
			elseif (self.attribute == 4) then --> others
				return attribute_misc:RefreshWindow(self, combat_table, force, nil, need_refresh)
			elseif (self.attribute == 5) then --> ocustom
				return attribute_custom:RefreshWindow(self, combat_table, force, nil, need_refresh)
			end

		end

		function _details:UpdateGumpMain(instance, force)
			
			if (not instance or type(instance) == "boolean") then --> o primeiro parâmetro não foi uma instância ou ALL
				force = instance
				instance = self
			end
			
			if (instance == -1) then
	
				--> update
				for index, this_instance in _ipairs(_details.table_instances) do
					if (this_instance.active) then
						if (this_instance.mode == mode_GROUP or this_instance.mode == mode_ALL) then
							this_instance:ActualizeALL(force)
						end
					end
				end
				
				--> marcar que não precisa ser atualizada
				for index, this_instance in _ipairs(_details.table_instances) do
					if (this_instance.active and this_instance.showing) then
						if (this_instance.mode == mode_GROUP or this_instance.mode == mode_ALL) then
							if (this_instance.attribute <= 4) then
								this_instance.showing[this_instance.attribute].need_refresh = false
							end
						end
					end
				end

				if (not force) then --atualizar o gump de details também se ele estiver aberto
					if (info.active) then
						return info.player:SetInfo()
					end
				end
				
				return
				
			else
				if (not instance.active) then
					return
				end
			end
			
			if (instance.mode == mode_ALL or instance.mode == mode_GROUP) then
				return instance:ActualizeALL(force)
			end
		end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details:AutoEraseConfirm()
	
		local panel = _G.DetailsEraseDataConfirmation
		if (not panel) then
			
			panel = CreateFrame("frame", "DetailsEraseDataConfirmation", UIParent)
			panel:SetSize(400, 85)
			panel:SetBackdrop({bgFile =[[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
			edgeFile =[[Interface\AddOns\Details\images\border_2]], edgeSize = 12})
			panel:SetPoint("center", UIParent)
			panel:SetBackdropColor(0, 0, 0, 0.4)
			
			panel:SetScript("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					panel:Hide()
				end
			end)
			
			--local icon = _details.gump:CreateImage(panel,[[Interface\AddOns\Details\images\logotype]], 512*0.4, 256*0.4)
			--icon:SetPoint("bottomleft", panel, "topleft", -10, -11)
			
			local text = _details.gump:CreateLabel(panel, Loc["STRING_OPTIONS_CONFIRM_ERASE"], nil, nil, "GameFontNormal")
			text:SetPoint("center", panel, "center")
			text:SetPoint("top", panel, "top", 0, -10)
			
			local no = _details.gump:CreateButton(panel, function() panel:Hide() end, 90, 20, Loc["STRING_NO"])
			no:SetPoint("bottomleft", panel, "bottomleft", 30, 10)
			no:InstallCustomTexture(nil, nil, nil, nil, true)
			
			local yes = _details.gump:CreateButton(panel, function() panel:Hide(); _details.table_history:reset() end, 90, 20, Loc["STRING_YES"])
			yes:SetPoint("bottomright", panel, "bottomright", -30, 10)
			yes:InstallCustomTexture(nil, nil, nil, nil, true)
		end
		
		panel:Show()
	end

	function _details:CheckForAutoErase(mapid)

		if (_details.last_instance_id ~= mapid) then
			if (_details.segments_auto_erase == 2) then
				--ask
				_details:ScheduleTimer("AutoEraseConfirm", 1)
			elseif (_details.segments_auto_erase == 3) then
				--erase
				_details.table_history:reset()
			end
		else
			if (_timestamp > _details.last_instance_time + 21600) then --6 hours
				if (_details.segments_auto_erase == 2) then
					--ask
					_details:ScheduleTimer("AutoEraseConfirm", 1)
				elseif (_details.segments_auto_erase == 3) then
					--erase
					_details.table_history:reset()
				end
			end
		end
		
		_details.last_instance_id = mapid
		_details.last_instance_time = _timestamp
		--_details.last_instance_time = 0 --debug
	end

	function _details:UpdateControl()
		_timestamp = _details._time
	end			
