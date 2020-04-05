-- actor container file

	local _details = 		_G._details
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _UnitClass = UnitClass --api local
	local _IsInInstance = IsInInstance --api local
	
	local _setmetatable = setmetatable --lua local
	local _getmetatable = getmetatable --lua local
	local _bit_band = bit.band --lua local
	local _table_sort = table.sort --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local combatant =			_details.combatant
	local container_combatants =	_details.container_combatants
	local dst_of_ability = 	_details.dst_of_ability
	local attribute_damage =		_details.attribute_damage
	local attribute_heal =			_details.attribute_heal
	local attribute_energy =		_details.attribute_energy
	local attribute_misc =			_details.attribute_misc

	local container_playernpc = 	_details.container_type.CONTAINER_PLAYERNPC
	local container_damage =		_details.container_type.CONTAINER_DAMAGE_CLASS
	local container_heal = 		_details.container_type.CONTAINER_HEAL_CLASS
	local container_heal_target = 	_details.container_type.CONTAINER_HEALTARGET_CLASS
	local container_friendlyfire =	_details.container_type.CONTAINER_FRIENDLYFIRE
	local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_energy = 		_details.container_type.CONTAINER_ENERGY_CLASS
	local container_energy_target =	_details.container_type.CONTAINER_ENERGYTARGET_CLASS
	local container_misc = 		_details.container_type.CONTAINER_MISC_CLASS
	local container_misc_target = 	_details.container_type.CONTAINER_MISCTARGET_CLASS
	local container_enemydebufftarget_target = _details.container_type.CONTAINER_ENEMYDEBUFFTARGET_CLASS

	--> flags
	local REACTION_HOSTILE	=	0x00000040
	local IS_GROUP_OBJECT 	= 	0x00000007
	local OBJECT_TYPE_MASK =	0x0000FC00
	local OBJECT_TYPE_OBJECT =	0x00004000
	local OBJECT_TYPE_PETGUARDIAN =	0x00003000
	local OBJECT_TYPE_GUARDIAN =	0x00002000
	local OBJECT_TYPE_PET =		0x00001000
	local OBJECT_TYPE_NPC =		0x00000800
	local OBJECT_TYPE_PLAYER =	0x00000400
	local OBJECT_TYPE_PETS = 	OBJECT_TYPE_PET + OBJECT_TYPE_GUARDIAN

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> api functions

	function container_combatants:GetAmount(actorName, key)
		key = key or "total"
		local index = self._NameIndexTable[actorName]
		if (index) then
			return self._ActorTable[index][key] or 0
		else
			return 0
		end
	end
	
	function container_combatants:GetTotal(key)
		local total = 0
		key = key or "total"
		for _, actor in _ipairs(self._ActorTable) do
			total = total +(actor[key] or 0)
		end
		
		return total
	end
	
	function container_combatants:GetTotalOnRaid(key, combat)
		local total = 0
		key = key or "total"
		local roster = combat.raid_roster
		for _, actor in _ipairs(self._ActorTable) do
			if (roster[actor.name]) then
				total = total +(actor[key] or 0)
			end
		end
		
		return total
	end

	function container_combatants:ListActors()
		return _ipairs(self._ActorTable)
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	--> build a new actor container
	function container_combatants:NewContainer(type_of_container, combat_table, combat_id)
		local _newContainer = {
			creation_func = container_combatants:CreationFunc(type_of_container),
			
			type = type_of_container,
			
			combatId = combat_id,
			
			_ActorTable = {},
			_NameIndexTable = {}
		}
		
		_setmetatable(_newContainer, container_combatants)

		return _newContainer
	end

	--> try to get the actor class from name
	local function get_actor_class(novo_objeto, name, flag)
		local _, engClass = _UnitClass(name)

		if (engClass) then
			novo_objeto.class = engClass
			return
		else	
			if (flag) then
				--> conferir se o player é um player
				if (_bit_band(flag, OBJECT_TYPE_PLAYER) ~= 0) then
					novo_objeto.class = "UNGROUPPLAYER"
					return
				elseif (_bit_band(flag, OBJECT_TYPE_PETGUARDIAN) ~= 0) then
					novo_objeto.class = "PET"
					return
				end
			end
			novo_objeto.class = "UNKNOW"
			return
		end
	end

	--> read the actor flag
	local read_actor_flag = function(novo_objeto, shadow_objeto, owner_of_pet, serial, flag, name, container_type)

		if (flag) then

			--> é um player
			if (_bit_band(flag, OBJECT_TYPE_PLAYER) ~= 0) then
			
				novo_objeto.displayName = _details:GetNickname(serial, false, true) --> serial, default, silent
				if (not novo_objeto.displayName) then
					if (_IsInInstance() and _details.remove_realm_from_name) then
						novo_objeto.displayName = name:gsub(("%-.*"), "")
					else
						novo_objeto.displayName = name
					end
				end
				
				if ((_bit_band(flag, IS_GROUP_OBJECT) ~= 0 and novo_objeto.class ~= "UNGROUPPLAYER")) then --> faz parte do group
					novo_objeto.group = true

					if (shadow_objeto) then
						shadow_objeto.group = true
					end
					
					if (_details:IsATank(serial)) then
						novo_objeto.isTank = true
						if (shadow_objeto) then
							shadow_objeto.isTank = true
						end
					end
				end
				
				if (_details.is_in_arena) then
				
					if (novo_objeto.group) then --> is ally
						novo_objeto.arena_ally = true
						
					else --> is enemy
						novo_objeto.arena_enemy = true
						
					end
					
					local arena_props = _details.arena_table[name]

					if (arena_props) then
						novo_objeto.role = arena_props.role
						
						if (arena_props.role == "NONE") then
							local role = UnitGroupRolesAssigned(name)
							if (role ~= "NONE") then
								novo_objeto.role = role
							end
						end
					else
						local oponentes = GetNumArenaOpponentSpecs()
						local found = false
						for i = 1, oponentes do
							local name = GetUnitName("arena" .. i, true)
							if (name == name) then
								local spec = GetArenaOpponentSpec(i)
								if (spec) then
									local id, name, description, icon, background, role, class = GetSpecializationInfoByID(spec)
									novo_objeto.role = role
									novo_objeto.class = class
									novo_objeto.enemy = true
									novo_objeto.arena_enemy = true
									found = true
								end
							end
						end
						
						local role = UnitGroupRolesAssigned(name)
						if (role ~= "NONE") then
							novo_objeto.role = role
							found = true
						end
						
						if (not found and name == _details.playername) then						
							local role = UnitGroupRolesAssigned("player")
							if (role ~= "NONE") then
								novo_objeto.role = role
							end
						end
						
					end
				
					novo_objeto.group = true
				end
			
			--> é um pet
			elseif (owner_of_pet) then 
				novo_objeto.owner = owner_of_pet
				novo_objeto.ownerName = owner_of_pet.name
				
				if (_IsInInstance() and _details.remove_realm_from_name) then
					novo_objeto.displayName = name:gsub(("%-.*"), ">")
				else
					novo_objeto.displayName = name
				end
				
			else
				novo_objeto.displayName = name
			end
			
			--> é enemy
			if (_bit_band(flag, 0x00000040) ~= 0) then 
				if (_bit_band(flag, OBJECT_TYPE_PLAYER) == 0 and _bit_band(flag, OBJECT_TYPE_PETGUARDIAN) == 0) then
					novo_objeto.monster = true
				end
			end
		end
		
		novo_objeto.flag_original = flag
		novo_objeto.serial = serial
	end
	-- CatchCombatant(GUID, name, flags, 
	function container_combatants:CatchCombatant(serial, name, flag, create, isOwner)
		--print("Serial: "..serial.." | Name: "..name)
		--> verifica se é um pet, se for confere se tem o name do owner, se não tiver, precisa por
		local owner_of_pet
		
		--if (flag and _bit_band(flag, OBJECT_TYPE_PETS) ~= 0) then --> é um pet
		if (_details.table_pets.pets[serial]) then --> é um pet
			--> aqui ele precisaria achar as tag < > pra saber se o name passado já não veio com o owner imbutido, se não tiver as tags, terá que ser posto aqui
			if (not name:find("<") or not name:find(">")) then --> finding is slow, do you have another way to do that?
				local name_dele, owner_name, owner_serial, owner_flag = _details.table_pets:CatchDono(serial, name, flag)
				if (name_dele and owner_name) then
					name = name_dele
					owner_of_pet = self:CatchCombatant(owner_serial, owner_name, owner_flag, true, name)
				end
			end
		end

		--> pega o index no mapa
		local index = self._NameIndexTable[name] 
		--> retorna o actor
		if (index) then
			return self._ActorTable[index], owner_of_pet, name
		
		--> não achou, create
		elseif (create) then

			--> espelho do container no overall
			local shadow = self.shadow 
			local shadow_objeto

			--> if you have the mirror(not the overall table already)
			if (shadow) then 
				--> just checks whether it exists or not
				shadow_objeto = shadow:CatchCombatant(_, name) 
				--> if doesn't exist, create it
				if (not shadow_objeto) then 
					--> take the name of the pet
					local novo_name = name:gsub((" <.*"), "") 
					--> create the object
					shadow_objeto = shadow:CatchCombatant(serial, novo_name, flag, true)
				end
			end

			local novo_objeto = self.creation_func(_, serial, name, shadow_objeto) --> shadow_objeto passa para o class_damage gravar no .targets e .spell_tables, mas não grava nele mesmo
			novo_objeto.name = name

		-- type do container
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

			if (self.type == container_damage) then --> CONTAINER DAMAGE

				get_actor_class(novo_objeto, name, flag)
				read_actor_flag(novo_objeto, shadow_objeto, owner_of_pet, serial, flag, name, "damage")
				
				if (owner_of_pet) then
					owner_of_pet.pets[#owner_of_pet.pets+1] = name
				end
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
					novo_objeto:CreateLink(shadow_objeto) --> criando o link
					if (novo_objeto.group and _details.in_combat) then
						_details.cache_damage_group[#_details.cache_damage_group+1] = novo_objeto
					end
				end
				
				if (novo_objeto.class == "UNGROUPPLAYER") then --> is a player
					if (_bit_band(flag, REACTION_HOSTILE ) ~= 0) then --> is hostile
						novo_objeto.enemy = true 
					end
					
					--> try to guess his class
					if (shadow) then --> não executar 2x
						_details:ScheduleTimer("GuessClass", 1, {novo_objeto, self, 1})
					end
				end
				
				if (novo_objeto.isTank) then
					novo_objeto.avoidance = _details:CreateActorAvoidanceTable()
				end
				
			elseif (self.type == container_heal) then --> CONTAINER HEALING
				
				get_actor_class(novo_objeto, name, flag)
				read_actor_flag(novo_objeto, shadow_objeto, owner_of_pet, serial, flag, name, "heal")
				
				if (owner_of_pet) then
					owner_of_pet.pets[#owner_of_pet.pets+1] = name
				end
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
					novo_objeto:CreateLink(shadow_objeto)  --> criando o link
					if (novo_objeto.group and _details.in_combat) then
						_details.cache_healing_group[#_details.cache_healing_group+1] = novo_objeto
					end
				end
				
				if (novo_objeto.class == "UNGROUPPLAYER") then --> is a player
					if (_bit_band(flag, REACTION_HOSTILE ) ~= 0) then --> is hostile
						novo_objeto.enemy = true --print(name.." EH UM INIMIGO -> " .. engRace)
					end
					
					--> try to guess his class
					if (shadow) then --> não executar 2x
						_details:ScheduleTimer("GuessClass", 1, {novo_objeto, self, 1})
					end
				end
				
				
			elseif (self.type == container_energy) then --> CONTAINER ENERGY
				
				get_actor_class(novo_objeto, name, flag)
				read_actor_flag(novo_objeto, shadow_objeto, owner_of_pet, serial, flag, name, "energy")
				
				if (owner_of_pet) then
					owner_of_pet.pets[#owner_of_pet.pets+1] = name
				end
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
					novo_objeto:CreateLink(shadow_objeto)  --> criando o link
				end
				
				if (novo_objeto.class == "UNGROUPPLAYER") then --> is a player
					if (_bit_band(flag, REACTION_HOSTILE ) ~= 0) then --> is hostile
						novo_objeto.enemy = true
					end
					
					--> try to guess his class
					if (shadow) then --> não executar 2x
						_details:ScheduleTimer("GuessClass", 1, {novo_objeto, self, 1})
					end
				end
				
			elseif (self.type == container_misc) then --> CONTAINER MISC
				
				get_actor_class(novo_objeto, name, flag)
				read_actor_flag(novo_objeto, shadow_objeto, owner_of_pet, serial, flag, name, "misc")
				
				--local test_class = 
				
				if (owner_of_pet) then
					owner_of_pet.pets[#owner_of_pet.pets+1] = name
				end
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
					novo_objeto:CreateLink(shadow_objeto)  --> criando o link
				end
				
				if (novo_objeto.class == "UNGROUPPLAYER") then --> is a player
					if (_bit_band(flag, REACTION_HOSTILE ) ~= 0) then --> is hostile
						novo_objeto.enemy = true
					end
					
					--> try to guess his class
					if (shadow) then --> não executar 2x
						_details:ScheduleTimer("GuessClass", 1, {novo_objeto, self, 1})
					end
				end
			
			elseif (self.type == container_damage_target) then --> CONTAINER ALVO DO DAMAGE
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
			
			elseif (self.type == container_heal_target) then --> CONTAINER ALVOS DO HEALING
				novo_objeto.overheal = 0
				novo_objeto.absorbed = 0
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
				
			elseif (self.type == container_energy_target) then --> CONTAINER ALVOS DO ENERGY
			
				novo_objeto.mana = 0
				novo_objeto.e_rage = 0
				novo_objeto.e_energy = 0
				novo_objeto.runepower = 0
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
				
			elseif (self.type == container_enemydebufftarget_target) then
				
				novo_objeto.uptime = 0
				novo_objeto.actived = false
				novo_objeto.activedamt = 0
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
				
			elseif (self.type == container_misc_target) then --> CONTAINER ALVOS DO MISC

				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
				
			elseif (self.type == container_friendlyfire) then --> CONTAINER FRIENDLY FIRE
				
				get_actor_class(novo_objeto, name)
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
			end
		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- grava o objeto no mapa do container
			local size = #self._ActorTable+1
			self._ActorTable[size] = novo_objeto --> grava na table de indexes
			self._NameIndexTable[name] = size --> grava no hash map o index dthis player

			return novo_objeto, owner_of_pet, name
		else
			return nil, nil, nil
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function container_combatants:CreationFunc(type)
		if (type == container_damage_target) then
			return dst_of_ability.Newtable
			
		elseif (type == container_damage) then
			return attribute_damage.Newtable
			
		elseif (type == container_heal_target) then
			return dst_of_ability.Newtable
			
		elseif (type == container_heal) then
			return attribute_heal.Newtable
			
		elseif (type == container_friendlyfire) then
			return attribute_damage.FF_creation_func
			
		elseif (type == container_enemydebufftarget_target) then
			return dst_of_ability.Newtable
			
		elseif (type == container_energy) then
			return attribute_energy.Newtable
			
		elseif (type == container_energy_target) then
			return dst_of_ability.Newtable
			
		elseif (type == container_misc) then
			return attribute_misc.Newtable
			
		elseif (type == container_misc_target) then
			return dst_of_ability.Newtable
			
		end
	end

	--> chama a função para ser executada em todos os atores
	function container_combatants:ActorCallFunction(func, ...)
		for index, actor in _ipairs(self._ActorTable) do
			func(nil, actor, ...)
		end
	end

	local bykey
	local sort = function(t1, t2)
		return t1[bykey] > t2[bykey]
	end
	
	function container_combatants:SortByKey(key)
		bykey = key
		_table_sort(self._ActorTable, sort)
		self:remapear()
	end
	
	function container_combatants:Remap()
		return self:remapear()
	end
	
	function container_combatants:remapear()
		local mapa = self._NameIndexTable
		local content = self._ActorTable
		for i = 1, #content do
			mapa[content[i].name] = i
		end
	end

	function _details.refresh:r_container_combatants(container, shadow)
		--> reconstrói meta e indexes
			_setmetatable(container, _details.container_combatants)
			container.__index = _details.container_combatants
			container.creation_func = container_combatants:CreationFunc(container.type)

		--> repara mapa
			local mapa = {}
			for i = 1, #container._ActorTable do
				mapa[container._ActorTable[i].name] = i
			end
			container._NameIndexTable = mapa

		--> seta a shadow
			container.shadow = shadow
	end

	function _details.clear:c_container_combatants(container)
		container.__index = nil
		container.shadow = nil
		container._NameIndexTable = nil
		container.need_refresh = nil
		container.creation_func = nil
	end