--[[ Declare all Details classes and container indexes ]]

do 
	local _details = 	_G._details
	local setmetatable = setmetatable
	-------- container que armazena o cache de pets
		_details.container_pets = {}
		_details.container_pets.__index = _details.container_pets
		setmetatable(_details.container_pets, _details)

	-------- time machine controla o time em combat dos players
		_details.timeMachine = {}
		_details.timeMachine.__index = _details.timeMachine
		setmetatable(_details.timeMachine, _details)

	-------- class da table que armazenará todos os combats efetuados
		_details.history = {}
		_details.history.__index = _details.history
		setmetatable(_details.history, _details)

	---------------- class da table onde serão armazenados cada combat efetuado
			_details.combat = {}
			_details.combat.__index = _details.combat
			setmetatable(_details.combat, _details.history)

	------------------------ armazenas classes de players ou others derivados
				_details.container_combatants = {}
				_details.container_combatants.__index = _details.container_combatants
				setmetatable(_details.container_combatants, _details.combat)

	-------------------------------- damage das abilities.
					_details.attribute_damage = {}
					_details.attribute_damage.__index = _details.attribute_damage
					setmetatable(_details.attribute_damage, _details.container_combatants)
					
	-------------------------------- heal das abilities.
					_details.attribute_heal = {}
					_details.attribute_heal.__index = _details.attribute_heal
					setmetatable(_details.attribute_heal, _details.container_combatants)

	-------------------------------- e_energy ganha
					_details.attribute_energy = {}
					_details.attribute_energy.__index = _details.attribute_energy
					setmetatable(_details.attribute_energy, _details.container_combatants)
					
	-------------------------------- others attributes
					_details.attribute_misc = {}
					_details.attribute_misc.__index = _details.attribute_misc
					setmetatable(_details.attribute_misc, _details.container_combatants)
					
	-------------------------------- attributes customizados
					_details.attribute_custom = {}
					_details.attribute_custom.__index = _details.attribute_custom
					setmetatable(_details.attribute_custom, _details.container_combatants)
					
	-------------------------------- armazena as classes de abilities usadas pelo combatant
					_details.container_abilities = {}
					_details.container_abilities.__index = _details.container_abilities
					setmetatable(_details.container_abilities, _details.combat)

	---------------------------------------- class das abilities que dão heal
						_details.ability_heal = {}
						_details.ability_heal.__index = _details.ability_heal
						setmetatable(_details.ability_heal, _details.container_abilities)
						
	---------------------------------------- class das abilities que dão damages
						_details.ability_damage = {}
						_details.ability_damage.__index = _details.ability_damage
						setmetatable(_details.ability_damage, _details.container_abilities)
						
	---------------------------------------- class das abilities que dão e_energy
						_details.ability_e_energy = {}
						_details.ability_e_energy.__index = _details.ability_e_energy
						setmetatable(_details.ability_e_energy, _details.container_abilities)

	---------------------------------------- class das abilities variadas
						_details.ability_misc = {}
						_details.ability_misc.__index = _details.ability_misc
						setmetatable(_details.ability_misc, _details.container_abilities)
						
		---------------------------------------- class dos targets das habilidads
							_details.dst_of_ability = {}
							_details.dst_of_ability.__index = _details.dst_of_ability
							setmetatable(_details.dst_of_ability, _details.container_combatants)

							

	--[[ Armazena os diferentes types de containers ]] --[[ Container Types ]]
	_details.container_type = {
		CONTAINER_PLAYERNPC = 1,
		CONTAINER_DAMAGE_CLASS = 2,
		CONTAINER_HEAL_CLASS = 3,
		CONTAINER_HEALTARGET_CLASS = 4,
		CONTAINER_FRIENDLYFIRE = 5,
		CONTAINER_DAMAGETARGET_CLASS = 6,
		CONTAINER_ENERGY_CLASS = 7,
		CONTAINER_ENERGYTARGET_CLASS = 8,
		CONTAINER_MISC_CLASS = 9,
		CONTAINER_MISCTARGET_CLASS = 10,
		CONTAINER_ENEMYDEBUFFTARGET_CLASS = 11
	}
	
	function _details:Name(actor)
		return self.name or actor.name
	end
	function _details:GetName(actor)
		return self.name or actor.name
	end
	function _details:GetDisplayName(actor)
		return self.displayName or actor.displayName
	end
	function _details:GetOnlyName(string)
		if (string) then
			return string:gsub(("%-.*"), "")
		end
		return self.name:gsub(("%-.*"), "")
	end
	function _details:Class(actor)
		return self.class or actor.class
	end
	function _details:GetActorSpells()
		return self.spell_tables._ActorTable
	end
	function _details:GetSpell(spellid)
		return self.spell_tables._ActorTable[spellid]
	end
end
