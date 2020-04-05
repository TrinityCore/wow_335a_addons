-- misc ability file
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
	local ability_misc		=	_details.ability_misc
	local container_combatants	=	_details.container_combatants
	local container_misc_target	= 	_details.container_type.CONTAINER_MISCTARGET_CLASS
	local container_playernpc	=	_details.container_type.CONTAINER_PLAYERNPC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_misc:Newtable(id, link, token)

		local _newMiscSpell = {
			id = id,
			counter = 0,
			targets = container_combatants:NewContainer(container_misc_target)
		}
		
		if (token == "BUFF_UPTIME" or token == "DEBUFF_UPTIME") then
			_newMiscSpell.uptime = 0
			_newMiscSpell.actived = false
			_newMiscSpell.activedamt = 0
		elseif (token == "SPELL_INTERRUPT") then
			_newMiscSpell.interrompeu_oque = {}
		elseif (token == "SPELL_DISPEL" or token == "SPELL_STOLEN") then
			_newMiscSpell.dispell_oque = {}
		elseif (token == "SPELL_AURA_BROKEN" or token == "SPELL_AURA_BROKEN_SPELL") then
			_newMiscSpell.cc_break_oque = {}
		end	

		_setmetatable(_newMiscSpell, ability_misc)
		
		if (link) then
			_newMiscSpell.targets.shadow = link.targets
		end
		
		return _newMiscSpell
	end

	function ability_misc:Add(serial, name, flag, src_name, token, spellID, spellName)

		if (spellID == "BUFF_OR_DEBUFF") then
			
			if (spellName == "COOLDOWN") then
				self.counter = self.counter + 1
				
				--> dst
				local dst = self.targets._NameIndexTable[name]
				if (not dst) then
					dst = self.targets:CatchCombatant(serial, name, flag, true)
				else
					dst = self.targets._ActorTable[dst]
				end
				dst.total = dst.total + 1
				
			elseif (spellName == "BUFF_UPTIME_REFRESH") then
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _details._time - self.actived_at
					token.buff_uptime = token.buff_uptime + _details._time - self.actived_at --> token = actor misc object
					
				end
				self.actived_at = _details._time
				self.actived = true
				
			elseif (spellName == "BUFF_UPTIME_OUT") then	
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _details._time - self.actived_at
					token.buff_uptime = token.buff_uptime + _details._time - self.actived_at --> token = actor misc object
				end
				self.actived = false
				self.actived_at = nil
				
			elseif (spellName == "BUFF_UPTIME_IN" or spellName == "DEBUFF_UPTIME_IN") then
				self.actived = true
				self.activedamt = self.activedamt + 1
				
				if (self.actived_at and self.actived and spellName == "DEBUFF_UPTIME_IN") then
					--> ja this active em outro mob e jogou num novo
					self.uptime = self.uptime + _details._time - self.actived_at
					token.debuff_uptime = token.debuff_uptime + _details._time - self.actived_at
				end
				
				self.actived_at = _details._time
				
			elseif (spellName == "DEBUFF_UPTIME_REFRESH") then
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _details._time - self.actived_at
					token.debuff_uptime = token.debuff_uptime + _details._time - self.actived_at
				end
				self.actived_at = _details._time
				self.actived = true

			elseif (spellName == "DEBUFF_UPTIME_OUT") then	
				if (self.actived_at and self.actived) then
					self.uptime = self.uptime + _details._time - self.actived_at
					token.debuff_uptime = token.debuff_uptime + _details._time - self.actived_at --> token = actor misc object
				end
				
				self.activedamt = self.activedamt - 1
				
				if (self.activedamt == 0) then
					self.actived = false
					self.actived_at = nil
				else
					self.actived_at = _details._time
				end

			end
			
		elseif (token == "SPELL_INTERRUPT") then
			self.counter = self.counter + 1

			if (not self.interrompeu_oque[spellID]) then --> interrompeu_oque a NIL value
				self.interrompeu_oque[spellID] = 1
			else
				self.interrompeu_oque[spellID] = self.interrompeu_oque[spellID] + 1
			end
			
			--dst
			local dst = self.targets._NameIndexTable[name]
			if (not dst) then
				dst = self.targets:CatchCombatant(serial, name, flag, true)
			else
				dst = self.targets._ActorTable[dst]
			end
			dst.total = dst.total + 1		
		
		elseif (token == "SPELL_RESURRECT") then
			if (not self.ress) then
				self.ress = 1
			else
				self.ress = self.ress + 1
			end
			
			--dst
			local dst = self.targets._NameIndexTable[name]
			if (not dst) then
				dst = self.targets:CatchCombatant(serial, name, flag, true)
			else
				dst = self.targets._ActorTable[dst]
			end
			dst.total = dst.total + 1		
			
			
		elseif (token == "SPELL_DISPEL" or token == "SPELL_STOLEN") then
			if (not self.dispell) then
				self.dispell = 1
			else
				self.dispell = self.dispell + 1
			end
			
			if (not self.dispell_oque[spellID]) then
				self.dispell_oque[spellID] = 1
			else
				self.dispell_oque[spellID] = self.dispell_oque[spellID] + 1
			end

			--dst
			local dst = self.targets._NameIndexTable[name]
			if (not dst) then
				dst = self.targets:CatchCombatant(serial, name, flag, true)
			else
				dst = self.targets._ActorTable[dst]
			end
			dst.total = dst.total + 1		
			
			
		elseif (token == "SPELL_AURA_BROKEN_SPELL" or token == "SPELL_AURA_BROKEN") then
		
			if (not self.cc_break) then
				self.cc_break = 1
			else
				self.cc_break = self.cc_break + 1
			end
			
			if (not self.cc_break_oque[spellID]) then
				self.cc_break_oque[spellID] = 1
			else
				self.cc_break_oque[spellID] = self.cc_break_oque[spellID] + 1
			end
			
			--dst
			local dst = self.targets._NameIndexTable[name]
			if (not dst) then
				dst = self.targets:CatchCombatant(serial, name, flag, true)
			else
				dst = self.targets._ActorTable[dst]
			end
			dst.total = dst.total + 1
		end

	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details.refresh:r_ability_misc(ability, shadow) --recebeu o container shadow
		_setmetatable(ability, ability_misc)
		ability.__index = ability_misc
		
		if (shadow ~= -1) then
			ability.shadow = shadow._ActorTable[ability.id]
			_details.refresh:r_container_combatants(ability.targets, ability.shadow.targets)
		else
			_details.refresh:r_container_combatants(ability.targets, -1)
		end
	end

	function _details.clear:c_ability_misc(ability)
		--ability.__index = {}
		ability.__index = nil
		ability.shadow = nil
		
		_details.clear:c_container_combatants(ability.targets)
	end

	ability_misc.__sub = function(table1, table2)

		--interrupts & cooldowns
		table1.counter = table1.counter - table2.counter
		
		--buff uptime ou debuff uptime
		if (table1.uptime and table2.uptime) then
			table1.uptime = table1.uptime - table2.uptime
		end
		
		--ressesrs
		if (table1.ress and table2.ress) then
			table1.ress = table1.ress - table2.ress
		end
		
		--dispells
		if (table1.dispell and table2.dispell) then
			table1.dispell = table1.dispell - table2.dispell
		end
		
		--cc_breaks
		if (table1.cc_break and table2.cc_break) then
			table1.cc_break = table1.cc_break - table2.cc_break
		end

		return table1
	end
