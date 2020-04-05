-- damage ability file

	local _details = 		_G._details
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers
	local _setmetatable = setmetatable--lua local
	local _ipairs = ipairs--lua local
	local _pairs =  pairs--lua local
	local _UnitAura = UnitAura--api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	= 	_details.dst_of_ability
	local ability_damage 	= 	_details.ability_damage
	local container_combatants =	_details.container_combatants
	local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_playernpc 	=	_details.container_type.CONTAINER_PLAYERNPC

	local _recording_ability_with_buffs = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function ability_damage:Newtable(id, link, token)

		local _newDamageSpell = {
		
			total = 0, --total damage
			counter = 0, --counter
			id = id, --spellid
			successful_casted = 0, --successful casted times(only for enemies)
			
			--> normal hits
			n_min = 0,
			n_max = 0,
			n_amt = 0,
			n_dmg = 0,
			
			--> critical hits
			c_min = 0,
			c_max = 0,
			c_amt = 0,
			c_dmg = 0,

			--> glacing hits
			g_amt = 0,
			g_dmg = 0,
			
			--> resisted
			r_amt = 0,
			r_dmg = 0,
			
			--> blocked
			b_amt = 0,
			b_dmg = 0,

			--> obsorved
			a_amt = 0,
			a_dmg = 0,
			
			targets = container_combatants:NewContainer(container_damage_target)
		}
		
		_setmetatable(_newDamageSpell, ability_damage)
		
		if (link) then
			_newDamageSpell.targets.shadow = link.targets
		end
		
		if (token == "SPELL_PERIODIC_DAMAGE") then
			_details:SpellIsDot(id)
		end
		
		return _newDamageSpell
	end

	function ability_damage:AddMiss(serial, name, flags, src_name, missType)
		self.counter = self.counter + 1

		local miss = self[missType] or 0
		miss = miss + 1
		self[missType] = miss
		
		self.targets:CatchCombatant(serial, name, flags, true) --apenas create o dst para a abilidade
	end

	function ability_damage:AddFF(amount)
		self.counter = self.counter + 1
		self.total = self.total + amount
	end

	function ability_damage:Add(serial, name, flag, amount, src_name, resisted, blocked, absorbed, critical, glacing, token)

		self.counter = self.counter + 1
		
		local dst = self.targets._NameIndexTable[name]
		if (not dst) then
			dst = self.targets:CatchCombatant(serial, name, flag, true)
		else
			dst = self.targets._ActorTable[dst]
		end

		if (resisted and resisted > 0) then
			self.r_dmg = self.r_dmg+amount --> table.total é o total de damage
			self.r_amt = self.r_amt+1 --> table.total é o total de damage
		end
		
		if (blocked and blocked > 0) then
			self.b_dmg = self.b_dmg+amount --> amount é o total de damage
			self.b_amt = self.b_amt+1 --> amount é o total de damage
		end
		
		if (absorbed and absorbed > 0) then
			self.a_dmg = self.a_dmg+amount --> amount é o total de damage
			self.a_amt = self.a_amt+1 --> amount é o total de damage
		end	
		
		self.total = self.total + amount
		dst.total = dst.total + amount

		if (glacing) then
			self.g_dmg = self.g_dmg+amount --> amount é o total de damage
			self.g_amt = self.g_amt+1 --> amount é o total de damage

		elseif (critical) then
			self.c_dmg = self.c_dmg+amount --> amount é o total de damage
			self.c_amt = self.c_amt+1 --> amount é o total de damage
			if (amount > self.c_max) then
				self.c_max = amount
			end
			if (self.c_min > amount or self.c_min == 0) then
				self.c_min = amount
			end
		else
			self.n_dmg = self.n_dmg+amount
			self.n_amt = self.n_amt+1
			if (amount > self.n_max) then
				self.n_max = amount
			end
			if (self.n_min > amount or self.n_min == 0) then
				self.n_min = amount
			end
		end
		
		if (_recording_ability_with_buffs) then
			if (src_name == _details.playername) then --aqui ele vai detalhar tudo sobre a spell usada
			
				local buffsNames = _details.SoloTables.BuffsTableNameCache
				
				local SpellBuffDetails = self.BuffTable
				if (not SpellBuffDetails) then
					self.BuffTable = {}
					SpellBuffDetails = self.BuffTable
				end
				
				if (token == "SPELL_PERIODIC_DAMAGE") then
					--> precisa ver se ele tinha na hora que aplicou
					local SoloDebuffPower = _details.table_current.SoloDebuffPower
					if (SoloDebuffPower) then
						local ThisDebuff = SoloDebuffPower[self.id]
						if (ThisDebuff) then
							local ThisDebuffOnTarget = ThisDebuff[serial]
							if (ThisDebuffOnTarget) then
								for index, buff_name in _ipairs(ThisDebuffOnTarget.buffs) do
									local buff_info = SpellBuffDetails[buff_name] or {["counter"] = 0,["total"] = 0,["critical"] = 0,["critical_damage"] = 0}
									buff_info.counter = buff_info.counter+1
									buff_info.total = buff_info.total+amount
									if (critical ~= nil) then
										buff_info.critical = buff_info.critical+1
										buff_info.critical_damage = buff_info.critical_damage+amount
									end
									SpellBuffDetails[buff_name] = buff_info
								end
							end
						end
					end
					
				else

					for BuffName, _ in _pairs(_details.Buffs.BuffsTable) do
						local name = _UnitAura("player", BuffName)
						if (name ~= nil) then
							local buff_info = SpellBuffDetails[name] or {["counter"] = 0,["total"] = 0,["critical"] = 0,["critical_damage"] = 0}
							buff_info.counter = buff_info.counter+1
							buff_info.total = buff_info.total+amount
							if (critical ~= nil) then
								buff_info.critical = buff_info.critical+1
								buff_info.critical_damage = buff_info.critical_damage+amount
							end
							SpellBuffDetails[name] = buff_info
						end
					end
				end
			end
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function _details.refresh:r_ability_damage(ability, shadow) --recebeu o container shadow
		_setmetatable(ability, ability_damage)
		ability.__index = ability_damage
		ability.shadow = shadow._ActorTable[ability.id]
		_details.refresh:r_container_combatants(ability.targets, ability.shadow.targets)
	end

	function _details.clear:c_ability_damage(ability)
		--ability.__index = {}
		ability.__index = nil
		ability.shadow = nil
		
		_details.clear:c_container_combatants(ability.targets)
	end

	ability_damage.__add = function(table1, table2)
		table1.total = table1.total + table2.total
		table1.counter = table1.counter + table2.counter
		table1.successful_casted = table1.successful_casted + table2.successful_casted
		
		table1.n_min = table1.n_min + table2.n_min
		table1.n_max = table1.n_max + table2.n_max
		table1.n_amt = table1.n_amt + table2.n_amt
		table1.n_dmg = table1.n_dmg + table2.n_dmg

		table1.c_min = table1.c_min + table2.c_min
		table1.c_max = table1.c_max + table2.c_max
		table1.c_amt = table1.c_amt + table2.c_amt
		table1.c_dmg = table1.c_dmg + table2.c_dmg
		
		table1.g_amt = table1.g_amt + table2.g_amt 
		table1.g_dmg = table1.g_dmg + table2.g_dmg
		
		table1.r_amt = table1.r_amt + table2.r_amt 
		table1.r_dmg = table1.r_dmg + table2.r_dmg
		
		table1.b_amt = table1.b_amt + table2.b_amt
		table1.b_dmg = table1.b_dmg + table2.b_dmg
		
		table1.a_amt = table1.a_amt + table2.a_amt 
		table1.a_dmg = table1.a_dmg + table2.a_dmg
		
		return table1
	end

	ability_damage.__sub = function(table1, table2)
		table1.total = table1.total - table2.total
		table1.counter = table1.counter - table2.counter
		table1.successful_casted = table1.successful_casted - table2.successful_casted

		table1.n_min = table1.n_min - table2.n_min
		table1.n_max = table1.n_max - table2.n_max
		table1.n_amt = table1.n_amt - table2.n_amt
		table1.n_dmg = table1.n_dmg - table2.n_dmg

		table1.c_min = table1.c_min - table2.c_min
		table1.c_max = table1.c_max - table2.c_max
		table1.c_amt = table1.c_amt - table2.c_amt
		table1.c_dmg = table1.c_dmg - table2.c_dmg
		
		table1.g_amt = table1.g_amt - table2.g_amt 
		table1.g_dmg = table1.g_dmg - table2.g_dmg
		
		table1.r_amt = table1.r_amt - table2.r_amt 
		table1.r_dmg = table1.r_dmg - table2.r_dmg
		
		table1.b_amt = table1.b_amt - table2.b_amt
		table1.b_dmg = table1.b_dmg - table2.b_dmg
		
		table1.a_amt = table1.a_amt - table2.a_amt 
		table1.a_dmg = table1.a_dmg - table2.a_dmg
		
		return table1
	end

	function _details:UpdateDamageAbilityGears()
		_recording_ability_with_buffs = _details.RecordPlayerAbilityWithBuffs
	end
