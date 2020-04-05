--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local _timestamp = time()
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	local _
	local _pairs = pairs --lua local
	local _ipairs = ipairs --lua local
	local _rawget = rawget --lua local
	local _setmetatable = setmetatable --lua local
	local _table_remove = table.remove --lua local
	local _bit_band = bit.band --lua local
	local _table_wipe = table.wipe --lua local
	local _time = time --lua local
	
	local _InCombatLockdown = InCombatLockdown --wow api local
	
	local attribute_damage =	_details.attribute_damage --details local
	local attribute_heal =		_details.attribute_heal --details local
	local attribute_energy =		_details.attribute_energy --details local
	local attribute_misc =		_details.attribute_misc --details local
	local dst_of_ability = 	_details.dst_of_ability --details local
	local ability_damage = 	_details.ability_damage --details local
	local ability_heal = 		_details.ability_heal --details local
	local container_abilities = 	_details.container_abilities --details local
	local container_combatants = _details.container_combatants --details local

	local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local class_type_damage = _details.attributes.damage
	local class_type_heal = _details.attributes.heal
	local class_type_e_energy = _details.attributes.e_energy
	local class_type_misc = _details.attributes.misc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	--> reconstrói o mapa do container
		local function ReconstroiMapa(table)
			local mapa = {}
			for i = 1, #table._ActorTable do
				mapa[table._ActorTable[i].name] = i
			end
			table._NameIndexTable = mapa
		end
		
	--> reaplica indexes e metatables
		function _details:RestoreMetaTables()
			
				_details.refresh:r_attribute_custom()
			
			--> container de pets e histórico
				_details.refresh:r_container_pets(_details.table_pets)
				_details.refresh:r_history(_details.table_history)

			--> tables dos combats
				local combat_overall = _details.table_overall
				local overall_damage = combat_overall[class_type_damage] --> damage atalho
				local overall_heal = combat_overall[class_type_heal] --> heal atalho
				local overall_energy = combat_overall[class_type_e_energy] --> energy atalho
				local overall_misc = combat_overall[class_type_misc] --> misc atalho
			
				local tables_of_history = _details.table_history.tables --> atalho

			--> recupera meta function
				for _, combat_table in _ipairs(tables_of_history) do
					combat_table.__call = _details.call_combat
				end
				
				for i = #tables_of_history-1, 1, -1 do
					local combat = tables_of_history[i]
					combat.previous_combat = tables_of_history[i+1]
				end
	
			--> time padrao do overall
				combat_overall.start_time = _timestamp
				combat_overall.end_time = _timestamp
			
			--> inicia a recuperação das tables e preparegem do overall
				if (#tables_of_history > 0) then
					for index, combat in _ipairs(tables_of_history) do
						
						combat.hasSaved = true
						
						--> aumenta o time do combat do overall
						if (combat.end_time and combat.start_time) then 
							combat_overall.start_time = combat_overall.start_time -(combat.end_time - combat.start_time)
						end
					
						--> recupera a meta e indexes da table do combat
						_details.refresh:r_combat(combat, combat_overall)
						
						--> recupera a meta e indexes dos 4 container
						_details.refresh:r_container_combatants(combat[class_type_damage], overall_damage)
						_details.refresh:r_container_combatants(combat[class_type_heal], overall_heal)
						_details.refresh:r_container_combatants(combat[class_type_e_energy], overall_energy)
						_details.refresh:r_container_combatants(combat[class_type_misc], overall_misc)
						
						--> table com os 4 tables de players
						local todos_attributes = {combat[class_type_damage]._ActorTable, combat[class_type_heal]._ActorTable, combat[class_type_e_energy]._ActorTable, combat[class_type_misc]._ActorTable}

						for class_type, attribute in _ipairs(todos_attributes) do
							for _, this_class in _ipairs(attribute) do
							
								local name = this_class.name
								this_class.displayName = name:gsub(("%-.*"), "")
								
								local shadow

								if (class_type == class_type_damage) then
									if (combat.overall_added) then
										shadow = attribute_damage:r_connect_shadow(this_class)
									else
										shadow = attribute_damage:r_onlyrefresh_shadow(this_class)
									end

								elseif (class_type == class_type_heal) then
									if (combat.overall_added) then
										shadow = attribute_heal:r_connect_shadow(this_class)
									else
										shadow = attribute_heal:r_onlyrefresh_shadow(this_class)
									end
									
								elseif (class_type == class_type_e_energy) then
									if (combat.overall_added) then
										shadow = attribute_energy:r_connect_shadow(this_class)
									else
										shadow = attribute_energy:r_onlyrefresh_shadow(this_class)
									end
									
								elseif (class_type == class_type_misc) then
									if (combat.overall_added) then
										shadow = attribute_misc:r_connect_shadow(this_class)
									else
										shadow = attribute_misc:r_onlyrefresh_shadow(this_class)
									end
								end

								--shadow:FazLinkagem(this_class)

							end
						end
						
						--> reconstrói a table dos pets
						for class_type, attribute in _ipairs(todos_attributes) do
							for _, this_class in _ipairs(attribute) do
								if (this_class.ownerName) then --> name do owner
									this_class.owner = combat(class_type, this_class.ownerName)
								end
							end
						end
						
					end
				--end
				end
			
			--> restore last_events_table
				local primeiro_combat = tables_of_history[1] --> primeiro combat
				if (primeiro_combat) then
					primeiro_combat[1]:ActorCallFunction(attribute_damage.r_last_events_table)
					primeiro_combat[2]:ActorCallFunction(attribute_heal.r_last_events_table)
				end
				
				local segundo_combat = tables_of_history[2] --> segundo combat
				if (segundo_combat) then
					segundo_combat[1]:ActorCallFunction(attribute_damage.r_last_events_table)
					segundo_combat[2]:ActorCallFunction(attribute_heal.r_last_events_table)
				end
			
		end


	--> limpa indexes, metatables e shadows
		function _details:PrepareTablesForSave()

		----------------------------//overall

			local tables_de_combat = {}
			
			local history_tables = _details.table_history.tables or {}
			
			--> remove os segments de trash
			for i = #history_tables, 1, -1  do
				local combat = history_tables[i]
				if (combat:IsTrash()) then
					table.remove(history_tables, i)
				end
			end
			
			--> remove os segments > que o limite permitido para salvar
			if (_details.segments_amount_to_save and _details.segments_amount_to_save < _details.segments_amount) then
				for i = _details.segments_amount, _details.segments_amount_to_save+1, -1  do
					if (_details.table_history.tables[i]) then
						table.remove(_details.table_history.tables, i)
					end
				end
			end
			
			--table do combat atual
			local table_atual = _details.table_current or _details.combat:Newtable(_, _details.table_overall)
			
			--limpa a table overall
			_details.table_overall = nil			
			
			for _, _table in _ipairs(history_tables) do
				tables_de_combat[#tables_de_combat+1] = _table
			end

			--verifica se a database existe mesmo
			_details_database = _details_database or {}
			
			for table_index, _combat in _ipairs(tables_de_combat) do

				--> limpa a table do grafico -- clear graphic table
				if (_details.clear_graphic) then 
					_combat.TimeData = {}
				end
				
				--> limpa a referencia do ultimo combat
				_combat.previous_combat = nil
			
				local container_damage = _combat[class_type_damage] or {}
				local container_heal = _combat[class_type_heal] or {}
				local container_e_energy = _combat[class_type_e_energy] or {}
				local container_misc = _combat[class_type_misc] or {}

				local todos_attributes = {container_damage, container_heal, container_e_energy, container_misc}
				
				local IsBossEncounter = _combat.is_boss
				if (IsBossEncounter) then
					if (_combat.pvp) then
						IsBossEncounter = false
					end
				end
				
				for class_type, _table in _ipairs(todos_attributes) do
				
					local content = _table._ActorTable

					--> Limpa tables que não thisjam em group
					
					_details.clear_ungrouped = true
					
					if (_details.clear_ungrouped) then
					
						local _iter = {index = 1, data = content[1], cleaned = 0} --> ._ActorTable[1] para pegar o primeiro index

						while(_iter.data) do --serach key: deletar apagar
							local can_erase = true
							
							if (_iter.data.group or _iter.data.boss or _iter.data.boss_fight_component or IsBossEncounter) then
								can_erase = false
							else
								local owner = _iter.data.owner
								if (owner) then 
									local owner_actor = _combat(class_type, owner.name)
									if (owner_actor) then 
										if (owner.group or owner.boss or owner.boss_fight_component) then
											--if (class_type == 1) then
											--	print("SAVE",  _iter.data.name, "| owner:",_iter.data.owner.name, table_index)
											--end
											can_erase = false
										end
									end
								else
									--if (class_type == 1) then
									--	print("DELETANDO",  _iter.data.name, table_index)
									--end
								end
							end
							
							if (can_erase) then 
								
								if (not _iter.data.owner) then --> pet(not a pet?)
									local myself = _iter.data
								
									if (myself.type == class_type_damage or myself.type == class_type_heal) then
										_combat.totals[myself.type] = _combat.totals[myself.type] - myself.total
										if (myself.group) then
											_combat.totals_group[myself.type] = _combat.totals_group[myself.type] - myself.total
										end
									elseif (myself.type == class_type_e_energy) then
										_combat.totals[myself.type]["mana"] = _combat.totals[myself.type]["mana"] - myself.mana
										_combat.totals[myself.type]["e_rage"] = _combat.totals[myself.type]["e_rage"] - myself.e_rage
										_combat.totals[myself.type]["e_energy"] = _combat.totals[myself.type]["e_energy"] - myself.e_energy
										_combat.totals[myself.type]["runepower"] = _combat.totals[myself.type]["runepower"] - myself.runepower
										if (myself.group) then
											_combat.totals_group[myself.type]["mana"] = _combat.totals_group[myself.type]["mana"] - myself.mana
											_combat.totals_group[myself.type]["e_rage"] = _combat.totals_group[myself.type]["e_rage"] - myself.e_rage
											_combat.totals_group[myself.type]["e_energy"] = _combat.totals_group[myself.type]["e_energy"] - myself.e_energy
											_combat.totals_group[myself.type]["runepower"] = _combat.totals_group[myself.type]["runepower"] - myself.runepower
										end
									elseif (myself.type == class_type_misc) then
										if (myself.cc_break) then 
											_combat.totals[myself.type]["cc_break"] = _combat.totals[myself.type]["cc_break"] - myself.cc_break 
											if (myself.group) then
												_combat.totals_group[myself.type]["cc_break"] = _combat.totals_group[myself.type]["cc_break"] - myself.cc_break 
											end
										end
										if (myself.ress) then 
											_combat.totals[myself.type]["ress"] = _combat.totals[myself.type]["ress"] - myself.ress
											if (myself.group) then
												_combat.totals_group[myself.type]["ress"] = _combat.totals_group[myself.type]["ress"] - myself.ress
											end
										end
										--> não precisa diminuir o total dos buffs e debuffs
										if (myself.cooldowns_defensive) then 
											_combat.totals[myself.type]["cooldowns_defensive"] = _combat.totals[myself.type]["cooldowns_defensive"] - myself.cooldowns_defensive 
											if (myself.group) then
												_combat.totals_group[myself.type]["cooldowns_defensive"] = _combat.totals_group[myself.type]["cooldowns_defensive"] - myself.cooldowns_defensive 
											end
										end
										if (myself.interrupt) then 
											_combat.totals[myself.type]["interrupt"] = _combat.totals[myself.type]["interrupt"] - myself.interrupt 
											if (myself.group) then
												_combat.totals_group[myself.type]["interrupt"] = _combat.totals_group[myself.type]["interrupt"] - myself.interrupt 
											end
										end
										if (myself.dispell) then 
											_combat.totals[myself.type]["dispell"] = _combat.totals[myself.type]["dispell"] - myself.dispell 
											if (myself.group) then
												_combat.totals_group[myself.type]["dispell"] = _combat.totals_group[myself.type]["dispell"] - myself.dispell 
											end
										end
										if (myself.dead) then 
											_combat.totals[myself.type]["dead"] = _combat.totals[myself.type]["dead"] - myself.dead 
											if (myself.group) then
												_combat.totals_group[myself.type]["dead"] = _combat.totals_group[myself.type]["dead"] - myself.dead 
											end
										end
									end						
								end

								_table_remove(content, _iter.index)
								_iter.cleaned = _iter.cleaned + 1
								_iter.data = content[_iter.index]
							else
								_iter.index = _iter.index + 1
								_iter.data = content[_iter.index]
							end
						end
						
						if (_iter.cleaned > 0) then --> desencargo de consciência, reconstruir o mapa depois de excluir
							ReconstroiMapa(_table)
						end
						
					end

					for _, this_class in _ipairs(content) do 
					
						--> limpa o displayName, não precisa salvar
						this_class.displayName = nil
						this_class.owner = nil
						
						if (class_type == class_type_damage) then
							_details.clear:c_attribute_damage(this_class)
						elseif (class_type == class_type_heal) then
							_details.clear:c_attribute_heal(this_class)
						elseif (class_type == class_type_e_energy) then
							_details.clear:c_attribute_energy(this_class)
						elseif (class_type == class_type_misc) then
							_details.clear:c_attribute_misc(this_class)
							
							if (this_class.interrupt) then
								for _, _dst in _ipairs(this_class.interrupt_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.buff_uptime) then
								for _, _dst in _ipairs(this_class.buff_uptime_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.debuff_uptime) then
								for _, _dst in _ipairs(this_class.debuff_uptime_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.cooldowns_defensive) then
								for _, _dst in _ipairs(this_class.cooldowns_defensive_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.ress) then
								for _, _dst in _ipairs(this_class.ress_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.dispell) then
								for _, _dst in _ipairs(this_class.dispell_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
							
							if (this_class.cc_break) then
								for _, _dst in _ipairs(this_class.cc_break_targets._ActorTable) do 
									_details.clear:c_dst_of_ability(_dst)
								end
							end
						end
						
						if (class_type ~= class_type_misc) then
							for _, _dst in _ipairs(this_class.targets._ActorTable) do 
								_details.clear:c_dst_of_ability(_dst)
							end
							
							for _, ability in _pairs(this_class.spell_tables._ActorTable) do
								if (class_type == class_type_damage) then
									_details.clear:c_ability_damage(ability)
								elseif (class_type == class_type_heal) then
									_details.clear:c_ability_heal(ability)
								elseif (class_type == class_type_e_energy) then
									_details.clear:c_ability_e_energy(ability)
								end
								
								for _, _dst in ipairs(ability.targets._ActorTable) do
									_details.clear:c_dst_of_ability(_dst)
								end
							end
						else
							if (this_class.interrupt) then
								for _, ability in _pairs(this_class.interrupt_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.buff_uptime) then
								for _, ability in _pairs(this_class.buff_uptime_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.debuff_uptime) then
								for _, ability in _pairs(this_class.debuff_uptime_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.cooldowns_defensive) then
								for _, ability in _pairs(this_class.cooldowns_defensive_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.ress) then
								for _, ability in _pairs(this_class.ress_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.dispell) then
								for _, ability in _pairs(this_class.dispell_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
							
							if (this_class.cc_break) then
								for _, ability in _pairs(this_class.cc_break_spell_tables._ActorTable) do
									_details.clear:c_ability_misc(ability)
									
									for _, _dst in ipairs(ability.targets._ActorTable) do
										_details.clear:c_dst_of_ability(_dst)
									end
								end
							end
						end
						
					end
				end

			end
			
			--> Clear Containers
				for table_index, _combat in _ipairs(tables_de_combat) do
					local container_damage = _combat[class_type_damage]
					local container_heal = _combat[class_type_heal]
					local container_e_energy = _combat[class_type_e_energy]
					local container_misc = _combat[class_type_misc]

					local todos_attributes = {container_damage, container_heal, container_e_energy, container_misc}
					
					for class_type, _table in _ipairs(todos_attributes) do
						_details.clear:c_combat(_combat)
						_details.clear:c_container_combatants(container_damage)
						_details.clear:c_container_combatants(container_heal)
						_details.clear:c_container_combatants(container_e_energy)
						_details.clear:c_container_combatants(container_misc)
					end
				end	
			
				
			--> panic mode
				if (_details.segments_panic_mode and _details.can_panic_mode) then
					if (_details.table_current.is_boss) then
						_details.table_history = _details.history:Newhistory()
					end
				end
			
			--> Limpa instâncias
			for _, this_instance in _ipairs(_details.table_instances) do
				--> detona a window do Solo Mode

				if (this_instance.StatusBar.left) then
					this_instance.StatusBarSaved = {
						["left"] = this_instance.StatusBar.left.real_name or "NONE",
						["center"] = this_instance.StatusBar.center.real_name or "NONE",
						["right"] = this_instance.StatusBar.right.real_name or "NONE",
						--["options"] = this_instance.StatusBar.options
					}
					this_instance.StatusBarSaved.options = {
						[this_instance.StatusBarSaved.left] = this_instance.StatusBar.left.options,
						[this_instance.StatusBarSaved.center] = this_instance.StatusBar.center.options,
						[this_instance.StatusBarSaved.right] = this_instance.StatusBar.right.options
					}
				end

				--> erase all widgets frames
				
				this_instance.scroll = nil
				this_instance.baseframe = nil
				this_instance.bgframe = nil
				this_instance.bgdisplay = nil
				this_instance.freeze_icon = nil
				this_instance.freeze_text = nil
				this_instance.bars = nil
				this_instance.showing = nil
				this_instance.agrupada_a = nil
				this_instance.grupada_pos = nil
				this_instance.agrupado = nil
				this_instance._version = nil
				
				this_instance.h_baixo = nil
				this_instance.h_left = nil
				this_instance.h_right = nil
				this_instance.h_cima = nil
				this_instance.break_snap_button = nil
				this_instance.alert = nil
				
				this_instance.StatusBar = nil
				this_instance.consolidateFrame = nil
				this_instance.consolidateButtonTexture = nil
				this_instance.consolidateButton = nil
				this_instance.lastIcon = nil
				
				this_instance.menu_attribute_string = nil
				
				this_instance.wait_for_plugin_created = nil
				this_instance.waiting_raid_plugin = nil
				this_instance.waiting_pid = nil

			end
			
			_details.clear:c_attribute_custom()

		end
	
	function _details:reset_window(instance)
		if (instance.segment == -1) then
			instance.showing[instance.attribute].need_refresh = true
			instance.v_bars = true
			instance:ResetGump()
			instance:UpdateGumpMain(true)
		end
	end

	function _details:CheckMemoryAfterCombat()
		if (_details.next_memory_check < time()) then
			if (_details.debug) then
				_details:Msg("(debug) checking memory after combat.")
			end
			_details.next_memory_check = time()+_details.interval_memory
			UpdateAddOnMemoryUsage()
			local memory = GetAddOnMemoryUsage("Details")
			if (memory > _details.memory_ram) then
				_details:InitializeCollectGarbage(true, 60) --> sending true doesn't check anythink
			end
		end
	end
	function _details:CheckMemoryPeriodically()
		if (_details.next_memory_check <= time() and not _InCombatLockdown() and not _details.in_combat) then
			_details.next_memory_check = time() + _details.interval_memory - 3
			UpdateAddOnMemoryUsage()
			local memory = GetAddOnMemoryUsage("Details")
			if (_details.debug) then
				_details:Msg("(debug) checking memory periodically. Using: ",math.floor(memory), "of", _details.memory_ram * 1000)
			end
			if (memory > _details.memory_ram * 1000) then
				if (_details.debug) then
					_details:Msg("(debug) Memory is too high, starting garbage collector")
				end
				_details:InitializeCollectGarbage(1, 60) --> sending 1 only check for combat and ignore garbage collect cooldown
			end
		end
	end

	function _details:InitializeCollectGarbage(force, lastevent)

		if (not force) then
			if (_details.ultima_collect + _details.interval_collect > _details._time + 1)  then
				return
			elseif (_details.in_combat or _InCombatLockdown() or _details:IsInInstance()) then 
				if (_details.debug) then
					_details:Msg("(debug) garbage collect queued due combatlockdown(forced false)")
				end
				_details:ScheduleTimer("InitializeCollectGarbage", 5) 
				return
			end
		else
			if (type(force) ~= "boolean") then
				if (force == 1) then
					if (_details.in_combat or _InCombatLockdown()) then
						if (_details.debug) then
							_details:Msg("(debug) garbage collect queued due combatlockdown(forced 1)")
						end
						_details:ScheduleTimer("InitializeCollectGarbage", 5, force) 
						return
					end
				end
			end
		end

		if (_details.debug) then
			if (force) then
				_details:Msg("(debug) collecting garbage with forced state: ", force)
			else
				_details:Msg("(debug) collecting garbage.")
			end
		end
		
		local memory = GetAddOnMemoryUsage("Details")
		
		--> reseta o cache do parser
		_details:ClearParserCache()
		
		--> limpa bars que não estão sendo usadas nas instâncias.
		for index, instance in _ipairs(_details.table_instances) do 
			if (instance.bars and instance.bars[1]) then
				for i, bar in _ipairs(instance.bars) do 
					if (not bar:IsShown()) then
						bar.my_table = nil
					end
				end
			end
		end
		
		--> faz a collect nos 4 attributes
		local damage = attribute_damage:CollectGarbage(lastevent)
		local heal = attribute_heal:CollectGarbage(lastevent)
		local energy = attribute_energy:CollectGarbage(lastevent)
		local misc = attribute_misc:CollectGarbage(lastevent)

		local limpados = damage + heal + energy + misc
		
		--> refresh nas windows
		if (limpados > 0) then
			_details:instanceCallFunction(_details.reset_window)
		end

		_details:ManutencaoTimeMachine()
		
		--> print cache states
		if (_details.debug) then
			_details:Msg("(debug) removed: damage "..damage.." heal "..heal.." energy "..energy.." misc "..misc)
		end
		
		--> elimina pets antigos
		_details:LimparPets()
		
		--> wipa container de shields
		_table_wipe(_details.shields)

		_details.ultima_collect = _details._time

		if (_details.debug) then
			collectgarbage()
			UpdateAddOnMemoryUsage()
			local memory2 = GetAddOnMemoryUsage("Details")
			_details:Msg("(debug) memory before: "..memory.." memory after: "..memory2)
		end
		
	end

	--> combats Normais
	local function FazCollect(_combat, type, interval_overwrite)
		
		local content = _combat[type]._ActorTable
		local _iter = {index = 1, data = content[1], cleaned = 0}
		local _timestamp  = _time()
		
		--local links_removed = 0
		
		while(_iter.data) do
		
			local _actor = _iter.data
			local can_garbage = false
			
			local t
			if (interval_overwrite) then 
				t =  _actor.last_event + interval_overwrite
			else
				t = _actor.last_event + _details.interval_collect
			end
			
			if (t < _timestamp and not _actor.group and not _actor.boss and not _actor.fight_component and not _actor.boss_fight_component) then 
				local owner = _actor.owner
				if (owner) then 
					local owner_actor = _combat(type, owner.name)
					if (not owner.group and not owner.boss and not owner.boss_fight_component) then
						can_garbage = true
					end
				else
					can_garbage = true
				end
			end

			if (can_garbage) then
				if (not _actor.owner) then --> pet
					_actor:subtract_total(_combat)
				end
			
				--> fix para a weak table
				--[[
				local shadow = _actor.shadow
				local _it = {index = 1, link = shadow.links[1]}
				while(_it.link) do
					if (_it.link == _actor) then
						_table_remove(shadow.links, _it.index)
						_it.link = shadow.links[_it.index]
					else
						_it.index = _it.index+1
						_it.link = shadow.links[_it.index]
					end
				end
				--]]
				
				_iter.cleaned = _iter.cleaned+1
				
				if (_actor.type == 1 or _actor.type == 2) then
					_actor:UnregisterInTimeMachine()
				end				
				
				_table_remove(content, _iter.index)
				_iter.data = content[_iter.index]
			else
				_iter.index = _iter.index + 1
				_iter.data = content[_iter.index]
			end
		
		end
		
		if (_details.debug) then
			-- _details:Msg("- garbage collect:", type, "actors removed:",_iter.cleaned)
		end
		
		if (_iter.cleaned > 0) then
			ReconstroiMapa(_combat[type])
			_combat[type].need_refresh = true
		end
		
		return _iter.cleaned
	end

	--> Combate overall
	function _details:CollectGarbage(type, lastevent)

		--print("fazendo collect...")
	
		local _timestamp  = _time()
		local limpados = 0

		--> prepare a list de combats
		local tables_de_combat = {}
		for _, _table in _ipairs(_details.table_history.tables) do
			if (_table ~= _details.table_current) then
				tables_de_combat[#tables_de_combat+1] = _table
			end
		end
		tables_de_combat[#tables_de_combat+1] = _details.table_current
		
		--> faz a collect em todos os combats para this attribute
		for _, _combat in _ipairs(tables_de_combat) do 
			limpados = limpados + FazCollect(_combat, type, lastevent)
		end

		--> limpa a table overall para o attribute atual(limpa para os 4, um de cada vez através do ipairs)
		local _overall_combat = _details.table_overall	
		local content = _overall_combat[type]._ActorTable
		local _iter = {index = 1, data = content[1], cleaned = 0} --> ._ActorTable[1] para pegar o primeiro index

		while(_iter.data) do
		
			local _actor = _iter.data
		
		--[[
			local mine_links = _rawget(_actor, "links")
			local can_garbage = true
			local new_weak_table = _setmetatable({}, _details.weaktable) --> precisa da new weak table para remover os NILS da table antiga
			
			if (mine_links) then
				for _, ref in _pairs(mine_links) do --> trocando pairs por _ipairs
					if (ref) then
						can_garbage = false
						new_weak_table[#new_weak_table+1] = ref
					end
				end
				_table_wipe(mine_links)
			end
		--]]
		
			local can_garbage = false
			if (not _actor.group and not _actor.owner and not _actor.boss_fight_component and not _actor.fight_component) then
				can_garbage = true
			end
		
			--if (can_garbage or not mine_links) then --> não há referências a this objeto
			if (can_garbage) then --> não há referências a this objeto
				
				--print("garbaged:", _actor.name)
				
				if (not _actor.owner) then --> pet
					_actor:subtract_total(_overall_combat)
				end

				--> apaga a referência dthis player na table overall
				_iter.cleaned = _iter.cleaned+1
				
				--if (_details.debug) then
				--	if (#_actor.links > 0) then
				--		_details:Msg("(debug) " .. _actor.name, " has been garbaged but have links: ", #_actor.links)
				--	end
				--end
				
				if (_actor.type == 1 or _actor.type == 2) then
					_actor:UnregisterInTimeMachine()
				end
				_table_remove(content, _iter.index)

				_iter.data = content[_iter.index]
			else
				--_actor.links = new_weak_table
				_iter.index = _iter.index + 1
				_iter.data = content[_iter.index]
			end

		end

		--> termina o coletor de lixo
		if (_iter.cleaned > 0) then
			_overall_combat[type].need_refresh = true
			ReconstroiMapa(_overall_combat[type])
			limpados = limpados + _iter.cleaned
		end
		
		if (limpados > 0) then
			_details:instanceCallFunction(_details.ScheduleUpdate)
			_details:UpdateGumpMain(-1)
		end

		return limpados
	end
