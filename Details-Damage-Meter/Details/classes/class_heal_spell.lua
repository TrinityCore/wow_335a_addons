-- heal ability file

	local _details = 		_G._details
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	=	_details.dst_of_ability
	local ability_heal		=	_details.ability_heal
	local container_combatants =	_details.container_combatants
	local container_heal_target	=	_details.container_type.CONTAINER_HEALTARGET_CLASS
	local container_playernpc	=	_details.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_heal:Newtable(id, link)

		local _newHealSpell = {
		
			total = 0, 
			totalabsorb = 0,
			counter = 0,
			id = id,

			--> normal hits		
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_healed = 0,
			
			--> critical hits 		
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_healed = 0,

			absorbed = 0,
			overheal = 0,
			
			targets = container_combatants:NewContainer(container_heal_target)
		}
		
		_setmetatable(_newHealSpell, ability_heal)
		
		if (link) then
			_newHealSpell.targets.shadow = link.targets
		end
		
		return _newHealSpell
	end

	function ability_heal:Add(serial, name, flag, amount, src_name, absorbed, critical, overhealing, is_shield)

		self.counter = self.counter + 1

		local dst = self.targets._NameIndexTable[name]
		if (not dst) then
			dst = self.targets:CatchCombatant(serial, name, flag, true)
		else
			dst = self.targets._ActorTable[dst]
		end

		if (absorbed and absorbed > 0) then
			self.absorbed = self.absorbed + absorbed
			dst.absorbed = dst.absorbed + absorbed
		end
		
		if (overhealing and overhealing > 0) then
			self.overheal = self.overheal + overhealing
			dst.overheal = dst.overheal + overhealing
		end
		
		if (amount and amount > 0) then

			self.total = self.total + amount
			dst.total = dst.total + amount
			
			if (is_shield) then
				self.totalabsorb = self.totalabsorb + amount
			end

			if (critical) then
				self.c_healed = self.c_healed+amount --> amount é o total de damage
				self.c_amt = self.c_amt+1 --> amount é o total de damage
				if (amount > self.c_max) then
					self.c_max = amount
				end
				if (self.c_min > amount or self.c_min == 0) then
					self.c_min = amount
				end
			else
				self.n_healed = self.n_healed+amount
				self.n_amt = self.n_amt+1
				if (amount > self.n_max) then
					self.n_max = amount
				end
				if (self.n_min > amount or self.n_min == 0) then
					self.n_min = amount
				end
			end
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details.refresh:r_ability_heal(ability, shadow)
		_setmetatable(ability, ability_heal)
		ability.__index = ability_heal
		
		if (shadow ~= -1) then
			ability.shadow = shadow._ActorTable[ability.id]
			_details.refresh:r_container_combatants(ability.targets, ability.shadow.targets)
		else
			_details.refresh:r_container_combatants(ability.targets, -1)
		end
	end

	function _details.clear:c_ability_heal(ability)
		--ability.__index = {}
		ability.__index = nil
		ability.shadow = nil
		
		_details.clear:c_container_combatants(ability.targets)
	end

	ability_heal.__sub = function(table1, table2)
		table1.total = table1.total - table2.total
		table1.totalabsorb = table1.totalabsorb - table2.totalabsorb
		table1.counter = table1.counter - table2.counter

		table1.n_min = table1.n_min - table2.n_min
		table1.n_max = table1.n_max - table2.n_max
		table1.n_amt = table1.n_amt - table2.n_amt
		table1.n_healed = table1.n_healed - table2.n_healed

		table1.c_min = table1.c_min - table2.c_min
		table1.c_max = table1.c_max - table2.c_max
		table1.c_amt = table1.c_amt - table2.c_amt
		table1.c_healed = table1.c_healed - table2.c_healed

		table1.absorbed = table1.absorbed - table2.absorbed
		table1.overheal = table1.overheal - table2.overheal
		
		return table1
	end
