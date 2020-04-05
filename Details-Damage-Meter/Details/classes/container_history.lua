local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )

--lua api
local _table_remove = table.remove
local _table_insert = table.insert
local _setmetatable = setmetatable
local _table_wipe = table.wipe

local _details = 		_G._details
local gump = 			_details.gump

local combat =			_details.combat
local history = 			_details.history
local bar_total =		_details.bar_total
local container_pets =		_details.container_pets
local timeMachine =		_details.timeMachine

function history:Newhistory()
	local this_table = {tables = {}}
	_setmetatable(this_table, history)
	return this_table
end

function history:adicionar_overall(table)
	if (_details.overall_clear_newboss) then
		if (table.instance_type == "raid" and table.is_boss) then
			if (_details.last_encounter ~= _details.last_encounter2) then
				for index, combat in ipairs(_details.table_history.tables) do 
					combat.overall_added = false
				end
				history:reset_overall()
			end
		end
	end

	_details.table_overall = _details.table_overall + table
	table.overall_added = true
	
	if (_details.table_overall.start_time == 0) then
		_details.table_overall.start_time = table.start_time
		_details.table_overall.end_time = table.end_time
	end
	
	_details:ClockPluginTickOnSegment()
end

function _details:GetCurrentCombat()
	return _details.table_current
end
function _details:GetCombatSegments()
	return _details.table_history.tables
end

--> sai do combat, chamou adicionar a table ao histórico
function history:adicionar(table)

	local tamanho = #self.tables
	
	--> verifica se precisa dar UnFreeze()
	if (tamanho < _details.segments_amount) then --> vai preencher um novo index vazio
		local ultima_table = self.tables[tamanho]
		if (not ultima_table) then --> não ha tables no history, this será a #1
			--> pega a table do combat atual
			ultima_table = table
		end
		_details:instanceCallFunction(_details.CheckFreeze, tamanho+1, ultima_table)
	end

	--> adiciona no index #1
	_table_insert(self.tables, 1, table)
	
	local overall_added = false
	
	if (not overall_added and bit.band(_details.overall_flag, 0x1) ~= 0) then --> raid boss - flag 0x1
		if (table.is_boss and table.instance_type == "raid" and not table.is_pvp) then
			overall_added = true
		end
		--print("0x1")
	end

	if (not overall_added and bit.band(_details.overall_flag, 0x2) ~= 0) then --> raid trash - flag 0x2
		if (table.is_trash and table.instance_type == "raid") then --check if the player is in a raid
			overall_added = true
		end
		--print("0x2")
	end
	
	if (not overall_added and bit.band(_details.overall_flag, 0x4) ~= 0) then --> dungeon boss - flag 0x4
		if (table.is_boss and table.instance_type == "party" and not table.is_pvp) then --check if this is a dungeon boss
			overall_added = true
		end
		--print("0x4")
	end

	if (not overall_added and bit.band(_details.overall_flag, 0x8) ~= 0) then --> dungeon trash - flag 0x8
		if (table.is_trash and table.instance_type == "party") then --check if the player is in a raid
			overall_added = true
		end
		--print("0x8")
	end
	
	if (not overall_added and bit.band(_details.overall_flag, 0x10) ~= 0) then --> any combat
		overall_added = true
		--print("0x10")
	end
	
	if (overall_added) then
		if (_details.debug) then
			_details:Msg("(debug) overall data flag match with the current combat.")
		end
		if (InCombatLockdown()) then
			_details.schedule_add_to_overall = true
			if (_details.debug) then
				_details:Msg("(debug) player is in combat, scheduling overall addition.")
			end
		else
			history:adicionar_overall(table)
		end
	end
	
	if (self.tables[2]) then
	
		--> do limpeza na table

		local _segundo_combat = self.tables[2]
		
		local container_damage = _segundo_combat[1]
		local container_heal = _segundo_combat[2]
		
		for _, player in ipairs(container_damage._ActorTable) do 
			--> remover a table de last events
			player.last_events_table =  nil
			--> verifica se ele ainda this registrado na time machine
			if (player.timeMachine) then
				player:UnregisterInTimeMachine()
			end
		end
		for _, player in ipairs(container_heal._ActorTable) do 
			--> remover a table de last events
			player.last_events_table =  nil
			--> verifica se ele ainda this registrado na time machine
			if (player.timeMachine) then
				player:UnregisterInTimeMachine()
			end
		end
		
		if (_details.trash_auto_remove) then
		
			local _terceiro_combat = self.tables[3]
		
			if (_terceiro_combat) then
			
				if (_terceiro_combat.is_trash and not _terceiro_combat.is_boss) then
					--if (_terceiro_combat.overall_added) then
					--	_details.table_overall = _details.table_overall - _terceiro_combat
					--	print("removendo combat 1")
					--end
					--> verificar newmente a time machine
					for _, player in ipairs(_terceiro_combat[1]._ActorTable) do --> damage
						if (player.timeMachine) then
							player:UnregisterInTimeMachine()
						end
					end
					for _, player in ipairs(_terceiro_combat[2]._ActorTable) do --> heal
						if (player.timeMachine) then
							player:UnregisterInTimeMachine()
						end
					end
					--> remover
					_table_remove(self.tables, 3)
					_details:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
				
			end

		end
		
	end

	--> verifica se precisa apagar a última table do histórico
	if (#self.tables > _details.segments_amount) then
		
		local combat_removed = self.tables[#self.tables]
	
		--> diminuir amounts no overall
		--if (combat_removed.overall_added) then
		--	_details.table_overall = _details.table_overall - combat_removed
		--	print("removendo combat 2")
		--end

		--> verificar newmente a time machine
		for _, player in ipairs(combat_removed[1]._ActorTable) do --> damage
			if (player.timeMachine) then
				player:UnregisterInTimeMachine()
			end
		end
		for _, player in ipairs(combat_removed[2]._ActorTable) do --> heal
			if (player.timeMachine) then
				player:UnregisterInTimeMachine()
			end
		end
		
		--> remover
		_table_remove(self.tables, #self.tables)
		_details:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
		
	end
	
	--> chama a função que irá atualizar as instâncias com segments no histórico
	_details:instanceCallFunction(_details.UpdateSegments_AfterCombat, self)
	
	_details:instanceCallFunction(_details.ActualizeWindow)
end

--> verifica se tem alguma instance congelada showing o segment recém liberado
function _details:CheckFreeze(instance, index_liberado, table)
	if (instance.freezed) then --> this congelada
		if (instance.segment == index_liberado) then
			instance.showing = table
			instance:UnFreeze()
		end
	end
end

function _details:OverallOptions(reset_new_boss, reset_new_challenge)
	if (reset_new_boss == nil) then
		reset_new_boss = _details.overall_clear_newboss
	end
	if (reset_new_challenge == nil) then
		reset_new_challenge = _details.overall_clear_newchallenge
	end
	
	_details.overall_clear_newboss = reset_new_boss
	_details.overall_clear_newchallenge = reset_new_challenge
end

function history:reset_overall()
	if (InCombatLockdown()) then
		_details:Msg(Loc["STRING_ERASE_IN_COMBAT"])
		_details.schedule_remove_overall = true
	else
		--> close a window de informações do player
		_details:CloseWindowInfo()
		
		_details.table_overall = combat:Newtable()
		
		for index, instance in ipairs(_details.table_instances) do 
			if (instance.active and instance.segment == -1) then
				instance:InstanceReset()
				instance:ReadjustGump()
			end
		end
	end
	
	_details:ClockPluginTickOnSegment()
end

function history:reset()

	if (_details.bosswindow) then
		_details.bosswindow:Reset()
	end
	
	if (_details.table_current.verifica_combat) then --> finaliza a checagem se this ou não no combat
		_details:CancelTimer(_details.table_current.verifica_combat)
	end
	
	--> close a window de informações do player
	_details:CloseWindowInfo()
	
	--> empty timerary tables
	_details.attribute_damage:ClearTempTables()
	
	for _, combat in ipairs(_details.table_history.tables) do 
		_table_wipe(combat)
	end
	_table_wipe(_details.table_current)
	_table_wipe(_details.table_overall)
	_table_wipe(_details.spellcache)
	
	_details:LimparPets()
	
	-- novo container de history
	_details.table_history = history:Newhistory() --joga fora a table antiga e cria uma new
	--novo container para armazenar pets
	_details.table_pets = _details.container_pets:NewContainer()
	_details.container_pets:BuscarPets()
	-- new table do overall e current
	_details.table_overall = combat:Newtable() --joga fora a table antiga e cria uma new
	-- cria new table do combat atual
	_details.table_current = combat:Newtable(nil, _details.table_overall)
	
	--marca o addon como fora de combat
	_details.in_combat = false
	--zera o contador de combats
	_details:NumeroCombate(0)
	
	--> limpa o cache de spells
	_details:ClearSpellCache()
	
	--> limpa a table de shields
	_table_wipe(_details.shields)
	
	--> reinicia a time machine
	timeMachine:Reinitialize()
	
	_table_wipe(_details.cache_damage_group)
	_table_wipe(_details.cache_healing_group)
	_details:UpdateParserGears()

	collectgarbage()
	
	_details:instanceCallFunction(_details.UpdateSegments) -- atualiza o instance.showing para as news tables criadas
	_details:instanceCallFunction(_details.UpdateSoloMode_AfertReset) -- verifica se precisa zerar as table da window solo mode
	_details:instanceCallFunction(_details.ResetGump) --_details:ResetGump("de todas as instances")
	_details:instanceCallFunction(gump.Fade, "in", nil, "bars")
	
	_details:UpdateGumpMain(-1) --atualiza todas as instances
	
	_details:SendEvent("DETAILS_DATA_RESET", nil, nil)
end

function _details.refresh:r_history(this_history)
	_setmetatable(this_history, history)
	--this_history.__index = history
end

--[[
		elseif (_details.trash_concatenate) then
			
			if (true) then
				return
			end
			
			if (_terceiro_combat) then
				if (_terceiro_combat.is_trash and _segundo_combat.is_trash and not _terceiro_combat.is_boss and not _segundo_combat.is_boss) then
					--> table 2 deve ser deletada e somada a table 1
					if (_details.debug) then
						details:Msg("(debug) concatenating two trash segments.")
					end
					
					_segundo_combat = _segundo_combat + _terceiro_combat
					_details.table_overall = _details.table_overall - _terceiro_combat
					
					_segundo_combat.is_trash = true

					--> verificar newmente a time machine
					for _, player in ipairs(_terceiro_combat[1]._ActorTable) do --> damage
						if (player.timeMachine) then
							player:UnregisterInTimeMachine()
						end
					end
					for _, player in ipairs(_terceiro_combat[2]._ActorTable) do --> heal
						if (player.timeMachine) then
							player:UnregisterInTimeMachine()
						end
					end
					--> remover
					_table_remove(self.tables, 3)
					_details:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
			end
--]]