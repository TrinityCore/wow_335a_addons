-- spells container file

local _details = 		_G._details
local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local container_playernpc	=	_details.container_type.CONTAINER_PLAYERNPC
	local container_damage	=	_details.container_type.CONTAINER_DAMAGE_CLASS
	local container_heal		= 	_details.container_type.CONTAINER_HEAL_CLASS
	local container_heal_target = 	_details.container_type.CONTAINER_HEALTARGET_CLASS
	local container_friendlyfire 	= 	_details.container_type.CONTAINER_FRIENDLYFIRE
	local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_energy 	=	_details.container_type.CONTAINER_ENERGY_CLASS
	local container_energy_target =	_details.container_type.CONTAINER_ENERGYTARGET_CLASS
	local container_misc 		=	_details.container_type.CONTAINER_MISC_CLASS
	local container_misc_target =	_details.container_type.CONTAINER_MISCTARGET_CLASS

	local ability_damage 	= 	_details.ability_damage
	local ability_heal 		=	_details.ability_heal
	local ability_e_energy 	= 	_details.ability_e_energy
	local ability_misc 	=	_details.ability_misc

	local container_abilities = 	_details.container_abilities

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals
	
	function container_abilities:NewContainer(type_of_container)
		local _newContainer = {
			creation_func = container_abilities:CreationFunc(type_of_container),
			type = type_of_container,
			_ActorTable = {}
		}
		
		_setmetatable(_newContainer, container_abilities)
		
		return _newContainer
	end

	function container_abilities:GetSpell(id)
		return self._ActorTable[id]
	end

	function container_abilities:CatchSpell(id, create, token, cria_shadow)
	
		local this_ability = self._ActorTable[id]
		
		if (this_ability) then
			return this_ability
		else
			if (create) then
				local novo_objeto = self.creation_func(nil, id, shadow_objeto, token)
				self._ActorTable[id] = novo_objeto
				
				--[[
				if (cria_shadow) then 
					local novo_objeto = self.creation_func(nil, id, nil, "")
					self._ActorTable[id] = novo_objeto
					return novo_objeto
				end
				
				local shadow = self.shadow
				local shadow_objeto = nil
				
				if (shadow) then
					--> apenas verifica se ele existe ou não
					shadow_objeto = shadow:CatchSpell(id) 
					--> se não existir, cria-lo
					if (not shadow_objeto) then 
						shadow_objeto = shadow:CatchSpell(id, true, token)
					end
				end
				
				local novo_objeto = self.creation_func(nil, id, shadow_objeto, token)
				
				if (shadow_objeto) then
					novo_objeto.shadow = shadow_objeto
				end
			
				self._ActorTable[id] = novo_objeto
				]]--
				return novo_objeto
			else
				return nil
			end
		end
	end

	function container_abilities:CreationFunc(type)
		if (type == container_damage) then
			return ability_damage.Newtable
			
		elseif (type == container_heal) then
			return ability_heal.Newtable

		elseif (type == container_energy) then
			return ability_e_energy.Newtable
			
		elseif (type == container_misc) then
			return ability_misc.Newtable
			
		end
	end

	function _details.refresh:r_container_abilities(container, shadow)
		--> reconstrói meta e indexes
			_setmetatable(container, _details.container_abilities)
			container.__index = _details.container_abilities
			local func_creation = container_abilities:CreationFunc(container.type)
			container.creation_func = func_creation
		--> seta a shadow
			container.shadow = shadow
	end

	function _details.clear:c_container_abilities(container)
		--container.__index = {}
		container.__index = nil
		container.shadow = nil
		container.creation_func = nil
	end
