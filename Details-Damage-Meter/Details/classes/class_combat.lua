-- combat class object

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	
--[[global]] DETAILS_TOTALS_ONLYGROUP = true

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable -- lua local
	local _ipairs = ipairs -- lua local
	local _pairs = pairs -- lua local
	local _bit_band = bit.band -- lua local
	local _date = date -- lua local
	local _table_remove = table.remove -- lua local
	local _rawget = rawget

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local combat 	=	_details.combat
	local container_combatants = _details.container_combatants
	local class_type_damage 	= _details.attributes.damage
	local class_type_heal		= _details.attributes.heal
	local class_type_e_energy 	= _details.attributes.e_energy
	local class_type_misc 	= _details.attributes.misc
	
	local REACTION_HOSTILE =	0x00000040
	local CONTROL_PLAYER =		0x00000100

	local _timestamp = time()
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> api functions

	--combat(container type, actor name)
	_details.call_combat = function(self, class_type, name)
		local container = self[class_type]
		local index_mapa = container._NameIndexTable[name]
		local actor = container._ActorTable[index_mapa]
		return actor
	end
	combat.__call = _details.call_combat

	--get the start date and end date
	function combat:GetDate()
		return self.data_start, self.data_end
	end
	
	--return data for charts
	function combat:GetTimeData(name)
		return self.TimeData[name]
	end
	
	function combat:IsTrash()
		return _rawget(self, "is_trash")
	end
	
	function combat:GetDifficult()
		return self.is_boss and self.is_boss.diff
	end
	
	function combat:GetBossInfo()
		return self.is_boss
	end
	
	function combat:GetDeaths()
		return self.last_events_tables
	end
	
	function combat:GetCombatNumber()
		return self.combat_counter
	end
	
	--return the name of the encounter or enemy
	function combat:GetCombatName(try_find)
		if (self.is_pvp) then
			return self.is_pvp.name
		elseif (self.is_boss) then
			return self.is_boss.encounter
		elseif (_rawget(self, "is_trash")) then
			return Loc["STRING_SEGMENT_TRASH"]
		else
			if (self.enemy) then
				return self.enemy
			end
			if (try_find) then
				return _details:FindEnemy()
			end
		end
		return Loc["STRING_UNKNOW"]
	end

	--return a numeric table with all actors on the specific containter
	function combat:GetActorList(container)
		return self[container]._ActorTable
	end

	--return the combat time in seconds
	function combat:GetCombatTime()
		if (self.end_time) then
			return self.end_time - self.start_time
		elseif (self.start_time and _details.in_combat) then
			return _timestamp - self.start_time
		else
			return 0
		end
	end

	--return the total of a specific attribute
	function combat:GetTotal(attribute, subAttribute, onlyGroup)
		if (attribute == 1 or attribute == 2) then
			if (onlyGroup) then
				return self.totals_group[attribute]
			else
				return self.totals[attribute]
			end
			
		elseif (attribute == 3 or attribute == 4) then
			local subName = _details:GetInternalSubAttributeName(attribute, subAttribute)
			if (onlyGroup) then
				return self.totals_group[attribute][subName]
			else
				return self.totals[attribute][subName]
			end
		end
		return 0
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	--class constructor
	function combat:Newtable(initiated, _table_overall, combatId, ...)

		local this_table = {true, true, true, true, true}
		
		this_table[1] = container_combatants:NewContainer(_details.container_type.CONTAINER_DAMAGE_CLASS, this_table, combatId) --> Damage
		this_table[2] = container_combatants:NewContainer(_details.container_type.CONTAINER_HEAL_CLASS, this_table, combatId) --> Healing
		this_table[3] = container_combatants:NewContainer(_details.container_type.CONTAINER_ENERGY_CLASS, this_table, combatId) --> Energies
		this_table[4] = container_combatants:NewContainer(_details.container_type.CONTAINER_MISC_CLASS, this_table, combatId) --> Misc
		this_table[5] = container_combatants:NewContainer(_details.container_type.CONTAINER_DAMAGE_CLASS, this_table, combatId) --> place holder for customs
		
		_setmetatable(this_table, combat)
		
		_details.combat_counter = _details.combat_counter + 1
		this_table.combat_counter = _details.combat_counter
		
		--> try discover if is a pvp combat
		local src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags = ...
		if (src_serial) then --> aqui irá identificar o boss ou o oponente
			if (dst_name and _bit_band(dst_flags, REACTION_HOSTILE) ~= 0) then --> tentando pegar o enemy pelo dst
				this_table.against = dst_name
				if (_bit_band(dst_flags, CONTROL_PLAYER) ~= 0) then
					this_table.pvp = true --> o dst é da facção oposta ou foi dado mind control
				end
			elseif (src_name and _bit_band(src_flags, REACTION_HOSTILE) ~= 0) then --> tentando pegar o enemy pelo who caso o mob é quem deu o primeiro hit
				this_table.against = src_name
				if (_bit_band(src_flags, CONTROL_PLAYER) ~= 0) then
					this_table.pvp = true --> o who é da facção oposta ou foi dado mind control
				end
			else
				this_table.pvp = true --> se ambos são friendly, seria isso um PVP entre players da mesma facções?
			end
		end

		--> start/end time(duration)
		this_table.data_end = 0
		this_table.data_start = 0
		
		--> record deaths
		this_table.last_events_tables = {}
		
		--> last events from players
		this_table.player_last_events = {}
		
		--> players in the raid
		this_table.raid_roster = {}
		
		--> frags
		this_table.frags = {}
		this_table.frags_need_refresh = false
		
		--> time data container
		this_table.TimeData = _details:TimeDataCreateCombatTables()
		
		--> Skill cache(not used)
		this_table.CombatSkillCache = {}

		-- a table sem o time de start é a table descartavel do start do addon
		if (initiated) then
			this_table.start_time = _timestamp
			this_table.end_time = nil
		else
			this_table.start_time = 0
			this_table.end_time = nil
		end

		-- o container irá armazenar as classes de damage -- cria um novo container de indexes de seriais de players --parâmetro 1 class armazenada no container, parâmetro 2 = flag da class
		this_table[1].need_refresh = true
		this_table[2].need_refresh = true
		this_table[3].need_refresh = true
		this_table[4].need_refresh = true
		this_table[5].need_refresh = true
		
		if (_table_overall) then --> link é a table de combat do overall
			this_table[1].shadow = _table_overall[1] --> diz ao objeto which a shadow dele na table overall
			this_table[2].shadow = _table_overall[2] --> diz ao objeto which a shadow dele na table overall
			this_table[3].shadow = _table_overall[3] --> diz ao objeto which a shadow dele na table overall
			this_table[4].shadow = _table_overall[4] --> diz ao objeto which a shadow dele na table overall
		end

		this_table.totals = {
			0, --> damage
			0, --> heal
			{--> e_energy
				mana = 0, --> mana
				e_rage = 0, --> rage
				e_energy = 0, --> energy(rogues cat)
				runepower = 0 --> runepower(dk)
			},
			{--> misc
				cc_break = 0, --> armazena quantas quebras de CC
				ress = 0, --> armazena quantos pessoas ele reviveu
				interrupt = 0, --> armazena quantos interrupt a pessoa deu
				dispell = 0, --> armazena quantos dispell this pessoa recebeu
				dead = 0, --> armazena quantas vezes essa pessia morreu
				cooldowns_defensive = 0, --> armazena quantos cooldowns a raid usou
				buff_uptime = 0, --> armazena quantos cooldowns a raid usou
				debuff_uptime = 0 --> armazena quantos cooldowns a raid usou
			},
			
			--> avoid using this values bellow, they aren't updated by the parser, only on demand by a user interaction.
				voidzone_damage = 0,
				frags_total = 0,
			--> end
		}
		
		this_table.totals_group = {
			0, --> damage
			0, --> heal
			{--> e_energy
				mana = 0, --> mana
				e_rage = 0, --> rage
				e_energy = 0, --> energy(rogues cat)
				runepower = 0 --> runepower(dk)
			}, 
			{--> misc
				cc_break = 0, --> armazena quantas quebras de CC
				ress = 0, --> armazena quantos pessoas ele reviveu
				interrupt = 0, --> armazena quantos interrupt a pessoa deu
				dispell = 0, --> armazena quantos dispell this pessoa recebeu
				dead = 0, --> armazena quantas vezes essa oessia morreu		
				cooldowns_defensive = 0, --> armazena quantos cooldowns a raid usou
				buff_uptime = 0,
				debuff_uptime = 0
			}
		}

		return this_table
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function combat:CreateLastEventsTable(player_name)
		--> sixteen indexes, thinking in 32 but it's just too much
		local t = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }
		t.n = 1
		self.player_last_events[player_name] = t
		return t
	end

	--trava o time dos players após o término do combat.
	function combat:LockTimes()
		if (self[1]) then
			for _, player in _ipairs(self[1]._ActorTable) do --> damage
				if (player:Initialize()) then -- retorna se ele this com o dps active
					player:FinishTime()
					player:Initialize(false) --trava o dps do player
				else
					if (player.start_time == 0) then
						player.start_time = _timestamp
					end
					if (not player.end_time) then
						player.end_time = _timestamp
					end
				end
			end
		end
		if (self[2]) then
			for _, player in _ipairs(self[2]._ActorTable) do --> healing
				if (player:Initialize()) then -- retorna se ele this com o dps active
					player:FinishTime()
					player:Initialize(false) --trava o dps do player
				else
				
					--print("Time NAO Iniciando:", self.name, self.start_time, self.end_time, self.delay, _timestamp)
				
					if (player.start_time == 0) then
						player.start_time = _timestamp
					end
					if (not player.end_time) then
						player.end_time = _timestamp
					end
				end
			end
		end
	end

	function combat:seta_data(type)
		if (type == _details._details_props.DATA_TYPE_START) then
			self.data_start = _date("%H:%M:%S")
		elseif (type == _details._details_props.DATA_TYPE_END) then
			self.data_end = _date("%H:%M:%S")
		end
	end

	function combat:seta_time_elapsed()
		if (self.playing_solo) then
			local damage_actor = self(1, _details.playername)
			if (damage_actor) then
				self.end_time = damage_actor.last_event or _timestamp
			else
				self.end_time = _timestamp
			end
		else
			self.end_time = _timestamp
		end
	end

	function _details.refresh:r_combat(table_combat, shadow)
		_setmetatable(table_combat, _details.combat)
		table_combat.__index = _details.combat
		table_combat.shadow = shadow
	end

	function _details.clear:c_combat(table_combat)
		--table_combat.__index = {}
		table_combat.__index = nil
		table_combat.__call = {}
		table_combat._combat_table = nil
		table_combat.shadow = nil
	end

	combat.__sub = function(combat1, combat2)

		if (combat1 ~= _details.table_overall) then
			return
		end

		--> sub damage
			for index, actor_T2 in _ipairs(combat2[1]._ActorTable) do
				local actor_T1 = combat1[1]:CatchCombatant(actor_T2.serial, actor_T2.name, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total(combat1)
			end
			combat1[1].need_refresh = true
			
		--> sub heal
			for index, actor_T2 in _ipairs(combat2[2]._ActorTable) do
				local actor_T1 = combat1[2]:CatchCombatant(actor_T2.serial, actor_T2.name, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total(combat1)
			end
			combat1[2].need_refresh = true
			
		--> sub energy
			for index, actor_T2 in _ipairs(combat2[3]._ActorTable) do
				local actor_T1 = combat1[3]:CatchCombatant(actor_T2.serial, actor_T2.name, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total(combat1)
			end
			combat1[3].need_refresh = true
			
		--> sub misc
			for index, actor_T2 in _ipairs(combat2[4]._ActorTable) do
				local actor_T1 = combat1[4]:CatchCombatant(actor_T2.serial, actor_T2.name, actor_T2.flag_original, true)
				actor_T1 = actor_T1 - actor_T2
				actor_T2:subtract_total(combat1)
			end
			combat1[4].need_refresh = true

		--> reduz o time 
			combat1.start_time = combat1.start_time +(combat2.end_time - combat2.start_time)
			
		--> apaga as deaths da fight diminuida
			local amt_deaths =  #combat2.last_events_tables --> quantas deaths teve nessa fight
			if (amt_deaths > 0) then
				for i = #combat1.last_events_tables, #combat1.last_events_tables-amt_deaths, -1 do 
					_table_remove(combat1.last_events_tables, #combat1.last_events_tables)
				end
			end
			
		--> frags
			for fragName, fragAmount in pairs(combat2.frags) do 
				if (fragAmount) then
					if (combat1.frags[fragName]) then
						combat1.frags[fragName] = combat1.frags[fragName] - fragAmount
					else
						combat1.frags[fragName] = fragAmount
					end
				end
			end
			combat1.frags_need_refresh = true
			
		return combat1
		
	end

	combat.__add = function(combat1, combat2)

		local all_containers = {combat2[class_type_damage]._ActorTable, combat2[class_type_heal]._ActorTable, combat2[class_type_e_energy]._ActorTable, combat2[class_type_misc]._ActorTable}
		
		for class_type, actor_container in ipairs(all_containers) do
			for _, actor in ipairs(actor_container) do
				local shadow
				
				if (class_type == class_type_damage) then
					shadow = _details.attribute_damage:r_connect_shadow(actor, true)
				elseif (class_type == class_type_heal) then
					shadow = _details.attribute_heal:r_connect_shadow(actor, true)
				elseif (class_type == class_type_e_energy) then
					shadow = _details.attribute_energy:r_connect_shadow(actor, true)
				elseif (class_type == class_type_misc) then
					shadow = _details.attribute_misc:r_connect_shadow(actor, true)
				end
				
				shadow.boss_fight_component = actor.boss_fight_component
				shadow.fight_component = actor.fight_component
				shadow.group = actor.group
			end
		end

		return combat1
	end

	function _details:UpdateCombat()
		_timestamp = _details._time
	end
