-- energy ability file

	local _details = 		_G._details
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _UnitAura = UnitAura --api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	=	_details.dst_of_ability
	local ability_energy	=	_details.ability_e_energy
	local container_combatants	= _details.container_combatants
	local container_energy_target	= _details.container_type.CONTAINER_ENERGYTARGET_CLASS
	local container_playernpc		= _details.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_energy:Newtable(id, link, token)

		local _newEnergySpell = {

			id = id,
			counter = 0,
			
			mana = 0,
			e_rage = 0,
			e_energy = 0,
			runepower = 0,
			
			targets = container_combatants:NewContainer(container_energy_target)
		}
		
		_setmetatable(_newEnergySpell, ability_energy)
		
		if (link) then
			_newEnergySpell.targets.shadow = link.targets
		end
		
		return _newEnergySpell
	end

	function ability_energy:Add(serial, name, flag, amount, src_name, powertype)

		self.counter = self.counter + 1

		local dst = self.targets._NameIndexTable[name]
		if (not dst) then
			dst = self.targets:CatchCombatant(serial, name, flag, true)
		else
			dst = self.targets._ActorTable[dst]
		end
		
		if (powertype == 0) then --> MANA
			self.mana = self.mana + amount
			dst.mana = dst.mana + amount
			
		elseif (powertype == 1) then --> e_rage
			self.e_rage = self.e_rage + amount
			dst.e_rage = dst.e_rage + amount
			
		elseif (powertype == 3) then --> ENERGIA
			self.e_energy = self.e_energy + amount
			dst.e_energy = dst.e_energy + amount
			
		elseif (powertype == 6) then --> RUNEPOWER
			self.runepower = self.runepower + amount
			dst.runepower = dst.runepower + amount
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details.refresh:r_ability_e_energy(ability, shadow) --recebeu o container shadow
		_setmetatable(ability, ability_energy)
		ability.__index = ability_energy
		
		if (shadow ~= -1) then
			ability.shadow = shadow._ActorTable[ability.id]
			_details.refresh:r_container_combatants(ability.targets, ability.shadow.targets)
		else
			_details.refresh:r_container_combatants(ability.targets, -1)
		end
	end

	function _details.clear:c_ability_e_energy(ability)
		--ability.__index = {}
		ability.__index = {}
		ability.shadow = nil
		
		_details.clear:c_container_combatants(ability.targets)
	end

	ability_energy.__sub = function(table1, table2)

		table1.mana = table1.mana - table2.mana
		table1.e_rage = table1.e_rage - table2.e_rage
		table1.e_energy = table1.e_energy - table2.e_energy
		table1.runepower = table1.runepower - table2.runepower
		
		table1.counter = table1.counter - table2.counter

		return table1
	end
