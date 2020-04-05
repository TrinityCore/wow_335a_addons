--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _timestamp = time()
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _UnitAffectingCombat = UnitAffectingCombat --wow api local
	local _UnitHealth = UnitHealth --wow api local
	local _UnitHealthMax = UnitHealthMax --wow api local
	local _UnitIsFeignDeath = UnitIsFeignDeath --wow api local
	local _UnitGUID = UnitGUID --wow api local
	local _GetUnitName = GetUnitName --wow api local
	local _GetInstanceInfo = GetInstanceInfo --wow api local
	local _IsInRaid = IsInRaid --wow api local
	local _IsInGroup = IsInGroup --wow api local
	local _GetNumGroupMembers = GetNumGroupMembers --wow api local
	local _UnitGroupRolesAssigned = UnitGroupRolesAssigned --wow api local

	local _cstr = string.format --lua local
	local _table_insert = table.insert --lua local
	local _select = select --lua local
	local _bit_band = bit.band --lua local
	local _math_floor = math.floor --lua local
	local _table_remove = table.remove --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _table_sort = table.sort --lua local
	local _type = type --lua local
	local _math_ceil = math.ceil --lua local
	local _table_wipe = table.wipe --lua local

	local _GetSpellInfo = _details.getspellinfo --details api
	--local shield = _details.shields --details local
	local parser = _details.parser --details local
	local absorb_spell_list = _details.AbsorbSpells --details local
	local defensive_cooldown_spell_list = _details.DefensiveCooldownSpells --details local
	local defensive_cooldown_spell_list_no_buff = _details.DefensiveCooldownSpellsNoBuff --details local
	local cc_spell_list = _details.CrowdControlSpells --details local
	local container_combatants = _details.container_combatants --details local
	local container_abilities = _details.container_abilities --details local
	
	local RaidBuffsSpells = _details.RaidBuffsSpells
	
	local spell_damage_func = _details.ability_damage.Add --details local
	local spell_heal_func = _details.ability_heal.Add --details local
	local spell_energy_func = _details.ability_e_energy.Add --details local
	
	--> current combat and overall pointers
		local _current_combat = _details.table_current or {} --> placeholder table
	--> total container pointers
		local _current_total = _current_combat.totals
		local _current_gtotal = _current_combat.totals_group
	--> actors container pointers
		local _current_damage_container = _current_combat[1]
		local _current_heal_container = _current_combat[2]
		local _current_energy_container = _current_combat[3]
		local _current_misc_container = _current_combat[4]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> cache
	--> damage
		local damage_cache = setmetatable({}, _details.weaktable)
		local damage_cache_pets = setmetatable({}, _details.weaktable)
		local damage_cache_petsOwners = setmetatable({}, _details.weaktable)
	--> healing
		local healing_cache = setmetatable({}, _details.weaktable)
	--> energy
		local energy_cache = setmetatable({}, _details.weaktable)
	--> misc
		local misc_cache = setmetatable({}, _details.weaktable)
	--> party & raid members
		local raid_members_cache = setmetatable({}, _details.weaktable)
	--> tanks
		local tanks_members_cache = setmetatable({}, _details.weaktable)
	--> damage and heal last events
		local last_events_cache = {} --> placeholder
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_misc = _details.container_type.CONTAINER_MISC_CLASS
	local container_enemydebufftarget_target = _details.container_type.CONTAINER_ENEMYDEBUFFTARGET_CLASS
	
	local OBJECT_TYPE_PLAYER = 0x00000400
	local OBJECT_TYPE_PETS = 0x00003000
	local AFFILIATION_GROUP = 0x00000007
	local REACTION_FRIENDLY = 0x00000010 
	
	local ENVIRONMENTAL_FALLING_NAME = Loc["STRING_ENVIRONMENTAL_FALLING"]
	local ENVIRONMENTAL_DROWNING_NAME = Loc["STRING_ENVIRONMENTAL_DROWNING"]
	local ENVIRONMENTAL_FATIGUE_NAME = Loc["STRING_ENVIRONMENTAL_FATIGUE"]
	local ENVIRONMENTAL_FIRE_NAME = Loc["STRING_ENVIRONMENTAL_FIRE"]
	local ENVIRONMENTAL_LAVA_NAME = Loc["STRING_ENVIRONMENTAL_LAVA"]
	local ENVIRONMENTAL_SLIME_NAME = Loc["STRING_ENVIRONMENTAL_SLIME"]
	
	-- DODANE
	local shields = _details.shields
	local shieldFlags = {}
	local AbsorbSpellDuration = 
	{
	-- Death Knight
	[48707] = 5, -- Anti-Magic Shell(DK) Rank 1 -- Does not currently seem to show tracable combat log events. It shows energizes which do not reveal the amount of damage absorbed
	[51052] = 10, -- Anti-Magic Zone(DK)( Rank 1(Correct spellID?)
		-- Does DK Spell Deflection show absorbs in the CL?
	[51271] = 20, -- Unbreakable Armor(DK)
	[77535] = 10, -- Blood Shield(DK)
	-- Druid
	[62606] = 10, -- Savage Defense proc.(Druid) Tooltip of the original spell doesn't clearly state that this is an absorb, but the buff does.
	-- Mage
	[11426] = 60, -- Ice Barrier(Mage) Rank 1
	[13031] = 60,
	[13032] = 60,
	[13033] = 60,
	[27134] = 60,
	[33405] = 60,
	[43038] = 60,
	[43039] = 60, -- Rank 8
	[6143] = 30, -- Frost Ward(Mage) Rank 1
	[8461] = 30, 
	[8462] = 30,  
	[10177] = 30,  
	[28609] = 30,
	[32796] = 30,
	[43012] = 30, -- Rank 7
	[1463] = 60, --  Mana shield(Mage) Rank 1
	[8494] = 60,
	[8495] = 60,
	[10191] = 60,
	[10192] = 60,
	[10193] = 60,
	[27131] = 60,
	[43019] = 60,
	[43020] = 60, -- Rank 9
	[543] = 30 , -- Fire Ward(Mage) Rank 1
	[8457] = 30,
	[8458] = 30,
	[10223] = 30,
	[10225] = 30,
	[27128] = 30,
	[43010] = 30, -- Rank 7
	-- Paladin
	[58597] = 6, -- Sacred Shield(Paladin) proc(Fixed, thanks to Julith)
	-- Priest
	[17] = 30, -- Power Word: Shield(Priest) Rank 1
	[592] = 30,
	[600] = 30,
	[3747] = 30,
	[6065] = 30,
	[6066] = 30,
	[10898] = 30,
	[10899] = 30,
	[10900] = 30,
	[10901] = 30,
	[25217] = 30,
	[25218] = 30,
	[48065] = 30,
	[48066] = 30, -- Rank 14
	[47509] = 12, -- Divine Aegis(Priest) Rank 1
	[47511] = 12,
	[47515] = 12, -- Divine Aegis(Priest) Rank 3(Some of these are not actual buff spellIDs)
	[47753] = 12, -- Divine Aegis(Priest) Rank 1
	[54704] = 12, -- Divine Aegis(Priest) Rank 1
	[47788] = 10, -- Guardian Spirit (Priest)(50 nominal absorb, this may not show in the CL)
	-- Warlock
	[7812] = 30, -- Sacrifice(warlock) Rank 1
	[19438] = 30,
	[19440] = 30,
	[19441] = 30,
	[19442] = 30,
	[19443] = 30,
	[27273] = 30,
	[47985] = 30,
	[47986] = 30, -- rank 9
	[6229] = 30, -- Shadow Ward(warlock) Rank 1
	[11739] = 30,
	[11740] = 30,
	[28610] = 30,
	[47890] = 30,
	[47891] = 30, -- Rank 6
	-- Consumables
	[29674] = 86400, -- Lesser Ward of Shielding
	[29719] = 86400, -- Greater Ward of Shielding(these have infinite duration, set for a day here :P)
	[29701] = 86400,
	[28538] = 120, -- Major Holy Protection Potion
	[28537] = 120, -- Major Shadow
	[28536] = 120, --  Major Arcane
	[28513] = 120, -- Major Nature
	[28512] = 120, -- Major Frost
	[28511] = 120, -- Major Fire
	[7233] = 120, -- Fire
	[7239] = 120, -- Frost
	[7242] = 120, -- Shadow Protection Potion
	[7245] = 120, -- Holy
	[6052] = 120, -- Nature Protection Potion
	[53915] = 120, -- Mighty Shadow Protection Potion
	[53914] = 120, -- Mighty Nature Protection Potion
	[53913] = 120, -- Mighty Frost Protection Potion
	[53911] = 120, -- Mighty Fire
	[53910] = 120, -- Mighty Arcane
	[17548] = 120, --  Greater Shadow
	[17546] = 120, -- Greater Nature
	[17545] = 120, -- Greater Holy
	[17544] = 120, -- Greater Frost
	[17543] = 120, -- Greater Fire
	[17549] = 120, -- Greater Arcane
	[28527] = 15, -- Fel Blossom
	[29432] = 3600, -- Frozen Rune usage(Naxx classic)
	-- Item usage
	[36481] = 4, -- Arcane Barrier(TK Kael'Thas) Shield
	[57350] = 6, -- Darkmoon Card: Illusion
	[17252] = 30, -- Mark of the Dragon Lord(LBRS epic ring) usage
	[25750] = 15, -- Defiler's Talisman/Talisman of Arathor Rank 1
	[25747] = 15,
	[25746] = 15,
	[23991] = 15,
	[31000] = 300, -- Pendant of Shadow's End Usage
	[30997] = 300, -- Pendant of Frozen Flame Usage
	[31002] = 300, -- Pendant of the Null Rune
	[30999] = 300, -- Pendant of Withering
	[30994] = 300, -- Pendant of Thawing
	[31000] = 300, -- 
	[23506]= 20, -- Arena Grand Master Usage(Aura of Protection)
	[12561] = 60, -- Goblin Construction Helmet usage
	[31771] = 20, -- Runed Fungalcap usage
	[21956] = 10, -- Mark of Resolution usage
	[29506] = 20, -- The Burrower's Shell
	[4057] = 60, -- Flame Deflector
	[4077] = 60, -- Ice Deflector
	[39228] = 20, -- Argussian Compass(may not be an actual absorb)
	-- Item procs
	[27779] = 30, -- Divine Protection - Priest dungeon set 1/2  Proc
	[11657] = 20, -- Jang'thraze(Zul Farrak) proc
	[10368] = 15, -- Uther's Strength proc
	[37515] = 15, -- Warbringer Armor Proc
	[42137] = 86400, -- Greater Rune of Warding Proc
	[26467] = 30, -- Scarab Brooch proc
	[26470] = 8, -- Scarab Brooch proc(actual)
	[27539] = 6, -- Thick Obsidian Breatplate proc
	[28810] = 30, -- Faith Set Proc Armor of Faith
	[54808] = 12, -- Noise Machine proc Sonic Shield 
	[55019] = 12, -- Sonic Shield(one of these too ought to be wrong)
	[64411] = 15, -- Blessing of the Ancient(Val'anyr Hammer of Ancient Kings equip effect)
	[64413] = 8, -- Val'anyr, Hammer of Ancient Kings proc Protection of Ancient Kings
	-- Misc
	[40322] = 30, -- Teron's Vengeful Spirit Ghost - Spirit Shield
	-- Boss abilities
	[65874] = 15, -- Twin Val'kyr's Shield of Darkness 175000
	[67257] = 15, -- 300000
	[67256] = 15, -- 700000
	[67258] = 15, -- 1200000
	[65858] = 15, -- Twin Val'kyr's Shield of Lights 175000
	[67260] = 15, -- 300000
	[67259] = 15, -- 700000
	[67261] = 15, -- 1200000
	}
	
	--> recording data options flags
		local _recording_self_buffs = false
		local _recording_ability_with_buffs = false
		local _recording_healing = false
		local _recording_buffs_and_debuffs = false
	--> in combat flag
		local _in_combat = false
	--> hooks
		local _hook_cooldowns = false
		local _hook_deaths = false
		local _hook_battleress = false
		local _hook_interrupt = false
		
		local _hook_cooldowns_container = _details.hooks["HOOK_COOLDOWN"]
		local _hook_deaths_container = _details.hooks["HOOK_DEATH"]
		local _hook_battleress_container = _details.hooks["HOOK_BATTLERESS"]
		local _hook_interrupt_container = _details.hooks["HOOK_INTERRUPT"]

		local _hook_buffs = false --[[REMOVED]]
		local _hook_buffs_container = _details.hooks["HOOK_BUFF"] --[[REMOVED]]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions

-----------------------------------------------------------------------------------------------------------------------------------------
	--> DAMAGE 	serach key: ~damage											|
-----------------------------------------------------------------------------------------------------------------------------------------
	-- DODANE
	local function consider_absorb(absorbed, dstName, srcName, timestamp, dstFlags)
		local mintime = nil
		local found_shield_src
		local found_shield_id
		--print("consider_absorb("..absorbed..", "..dstName..", "..timestamp.."):")
		for shield_id, spells in pairs(shields[dstName]) do
			for shield_src, ts in pairs(spells) do
				--print("Shield: ", shield_id, shield_src, ts)
				if ts - timestamp > 0 then 
					if (mintime == nil or ts - timestamp < mintime) then
					mintime = ts - timestamp
					found_shield_src = shield_src
					found_shield_id = shield_id
					end
				else
					--shields[dstName][shield_id][shield_src] = nil
				end
			end
		end
		if found_shield_src then
			--print("Shield owner: "..found_shield_src.." shieldId: "..found_shield_id)
			local found_shield_srcFlags = shieldFlags and shieldFlags[dstName] and shieldFlags[dstName][found_shield_id] and shieldFlags[dstName][found_shield_id][found_shield_src]
			local found_shield_name = GetSpellInfo(found_shield_id)
			parser:heal("SPELL_HEAL", timestamp, UnitGUID(found_shield_src), found_shield_src, found_shield_srcFlags, UnitGUID(dstName), dstName, dstFlags, found_shield_id, found_shield_name, nil, absorbed, 0, 0, 0, nil)
			--log_absorb(Skada.current, found_shield_src, dstName, absorbed)
			--log_absorb(Skada.total, found_shield_src, dstName, absorbed)
		
		end
	end


	function parser:swing(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
		return parser:spell_dmg(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, 1, "Corpo-a-Corpo", 00000001, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing) --> localize-me
																		--spellid, spellname, spelltype
	end

	function parser:range(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
		return parser:spell_dmg(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, 2, "Auto Shot", 00000001, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)  --> localize-me
																		--spellid, spellname, spelltype
	end

	function parser:spell_dmg(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing)
		if absorbed and absorbed > 0 and dst_name and shields[dst_name] and src_name then
			--Skada:Print(dstName.." absorbed "..absorbed.." from "..srcName)
			consider_absorb(absorbed, dst_name, src_name, time, dst_flags)
		end
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
	
		if (src_serial == "0x0000000000000000") then
			if (src_flags and _bit_band(src_flags, OBJECT_TYPE_PETS) ~= 0) then --> é um pet
				--> pets must have an serial
				return
			end
			--src_serial = nil
		end

		if (not dst_name) then
			--> no target name, just quit
			return
		elseif (not src_name) then
			--> no actor name, use spell name instead
			src_name = "[*] "..spellname
		end

	------------------------------------------------------------------------------------------------	
	--> check if need start an combat

		if (not _in_combat) then
			if (	token ~= "SPELL_PERIODIC_DAMAGE" and 
			( 
				(src_flags and _bit_band(src_flags, AFFILIATION_GROUP) ~= 0 and _UnitAffectingCombat(src_name) )
					or 
				(dst_flags and _bit_band(dst_flags, AFFILIATION_GROUP) ~= 0 and _UnitAffectingCombat(dst_name) ) 
					or
				(not _details.in_group and src_flags and _bit_band(src_flags, AFFILIATION_GROUP) ~= 0)
				)
			) then 
				--> não entra em combat se for DOT
				--if (_details.encounter_table.id and _details.encounter_table["start"] >= _G.time()-3 and _details.announce_firsthit.enabled) then
				--[[
				if(IsInInstance()) then
					local link
					if (spellid <= 10) then
						link = _GetSpellInfo(spellid)
					else
						link = GetSpellLink(spellid)
					end
					local _, _, srcName = _current_damage_container:CatchCombatant(src_serial, src_name, src_flags, true)
					_details:Msg("First hit: " ..(link or "") .. " from " ..(srcName or "Unknown"))
				end
				]]--
				_details:EnterCombat(src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags)
			end
		end
		
		_current_damage_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
	
		--> damager
		local this_player, mine_owner = damage_cache[src_name] or damage_cache_pets[src_serial], damage_cache_petsOwners[src_serial]
		
		if (not this_player) then --> pode ser um desconhecido ou um pet
		
			this_player, mine_owner, src_name = _current_damage_container:CatchCombatant(src_serial, src_name, src_flags, true)
			
			if (mine_owner) then --> é um pet
				damage_cache_pets[src_serial] = this_player
				damage_cache_petsOwners[src_serial] = mine_owner
				--conferir se o owner já this no cache
				if (not damage_cache[mine_owner.name]) then
					damage_cache[mine_owner.name] = mine_owner
				end
			else
				if (src_flags) then --> ter certeza que não é um pet
					damage_cache[src_name] = this_player
					--> se for spell actor
					if (src_name:find("[*]")) then
						local _, _, icon = _GetSpellInfo(spellid or 1)
						this_player.spellicon = icon
						--print("spell actor:", src_name, "icon:", icon)
					end
				end
			end
			
		end
		
		--> his target
		local player_dst, dst_owner = damage_cache[dst_name] or damage_cache_pets[dst_serial], damage_cache_petsOwners[dst_serial]
		
		if (not player_dst) then
		
			player_dst, dst_owner, dst_name = _current_damage_container:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			
			if (dst_owner) then
				damage_cache_pets[dst_serial] = player_dst
				damage_cache_petsOwners[dst_serial] = dst_owner
				--conferir se o owner já this no cache
				if (not damage_cache[dst_owner.name]) then
					damage_cache[dst_owner.name] = dst_owner
				end
			else
				if (dst_flags) then --> ter certeza que não é um pet
					damage_cache[dst_name] = player_dst
				end
			end
			
		end
		
		--> last event
		this_player.last_event = _timestamp
		
	------------------------------------------------------------------------------------------------
	--> group checks and avoidance

		if (this_player.group) then 
			_current_gtotal[1] = _current_gtotal[1]+amount
			
		elseif (player_dst.group) then
		
			--> record death log
			local t = last_events_cache[dst_name]
			
			if (not t) then
				t = _current_combat:CreateLastEventsTable(dst_name)
			end
			
			local i = t.n
			
			local this_event = t[i]
			
			this_event[1] = true --> true if this is a damage || false for healing
			this_event[2] = spellid --> spellid || false if this is a battle ress line
			this_event[3] = amount --> amount of damage or healing
			this_event[4] = time --> parser time
			this_event[5] = _UnitHealth(dst_name) --> current unit heal
			this_event[6] = src_name --> source name
			this_event[7] = absorbed
			this_event[8] = school
			
			i = i + 1
			
			if (i == 17) then
				t.n = 1
			else
				t.n = i
			end
			
			--> record avoidance only for player actors
			
			if (tanks_members_cache[dst_serial]) then --> autoshot or melee hit
				--> avoidance
				local avoidance = player_dst.avoidance
				local overall = avoidance.overall
				
				local mob = avoidance[src_name]
				if (not mob) then --> if isn't in the table, build on the fly
					mob =  _details:CreateActorAvoidanceTable(true)
					avoidance[src_name] = mob
				end				
				
				overall["ALL"] = overall["ALL"] + 1  --> whichtype de hit ou absorb
				mob["ALL"] = mob["ALL"] + 1  --> whichtype de hit ou absorb
				
				if (spellid < 3) then
					--> overall
					overall["HITS"] = overall["HITS"] + 1
					mob["HITS"] = mob["HITS"] + 1
				end
				
				--> absorbs status
				if (absorbed) then
					--> aqui pode ser apenas absorb parcial
					overall["ABSORB"] = overall["ABSORB"] + 1
					overall["PARTIAL_ABSORBED"] = overall["PARTIAL_ABSORBED"] + 1
					overall["PARTIAL_ABSORB_AMT"] = overall["PARTIAL_ABSORB_AMT"] + absorbed
					overall["ABSORB_AMT"] = overall["ABSORB_AMT"] + absorbed
					mob["ABSORB"] = mob["ABSORB"] + 1
					mob["PARTIAL_ABSORBED"] = mob["PARTIAL_ABSORBED"] + 1
					mob["PARTIAL_ABSORB_AMT"] = mob["PARTIAL_ABSORB_AMT"] + absorbed
					mob["ABSORB_AMT"] = mob["ABSORB_AMT"] + absorbed
				else
					--> adicionar aos hits sem absorbs
					overall["FULL_HIT"] = overall["FULL_HIT"] + 1
					overall["FULL_HIT_AMT"] = overall["FULL_HIT_AMT"] + amount
					mob["FULL_HIT"] = mob["FULL_HIT"] + 1
					mob["FULL_HIT_AMT"] = mob["FULL_HIT_AMT"] + amount
				end
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> damage taken 

		--> target
		player_dst.damage_taken = player_dst.damage_taken + amount --> adiciona o damage tomado
		if (not player_dst.damage_from[src_name]) then --> adiciona a pool de damage tomado de quem
			player_dst.damage_from[src_name] = true
		end
		
	------------------------------------------------------------------------------------------------
	--> time start 

		if (not this_player.dps_started) then
		
			this_player:Initialize(true) --registra na timemachine
			
			if (mine_owner and not mine_owner.dps_started) then
				mine_owner:Initialize(true)
				if (mine_owner.end_time) then
					mine_owner.end_time = nil
				else
					mine_owner:InitializeTime(_timestamp, mine_owner.shadow)
				end
			end
			
			if (this_player.end_time) then
				this_player.end_time = nil
			else
				this_player:InitializeTime(_timestamp, this_player.shadow)
			end

			if (this_player.name == _details.playername and token ~= "SPELL_PERIODIC_DAMAGE") then --> starting o dps do "PLAYER"
				if (_details.solo) then
					--> save solo attributes
					_details:UpdateSolo()
				end

				if (_UnitAffectingCombat("player")) then
					_details:SendEvent("COMBAT_PLAYER_TIMESTARTED", nil, _current_combat, this_player)
				end
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> firendly fire

		--if (_bit_band(src_flags, REACTION_FRIENDLY) ~= 0 and _bit_band(dst_flags, REACTION_FRIENDLY) ~= 0) then(old friendly check)
		if (raid_members_cache[src_serial] and raid_members_cache[dst_serial]) then

			--> record death log
			local t = last_events_cache[dst_name]
			
			if (not t) then
				t = _current_combat:CreateLastEventsTable(dst_name)
			end
			
			local i = t.n

			local this_event = t[i]
			
			this_event[1] = true --> true if this is a damage || false for healing
			this_event[2] = spellid --> spellid || false if this is a battle ress line
			this_event[3] = amount --> amount of damage or healing
			this_event[4] = time --> parser time
			this_event[5] = _UnitHealth(dst_name) --> current unit heal
			this_event[6] = src_name --> source name
			this_event[7] = absorbed
			this_event[8] = school
			this_event[9] = true
			i = i + 1
			
			if (i == 17) then
				t.n = 1
			else
				t.n = i
			end
		
			--> faz a adução do friendly fire
			this_player.friendlyfire_total = this_player.friendlyfire_total + amount
			
			local amigo = this_player.friendlyfire._NameIndexTable[dst_name]
			if (not amigo) then
				amigo = this_player.friendlyfire:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			else
				amigo = this_player.friendlyfire._ActorTable[amigo]
			end

			amigo.total = amigo.total + amount

			local spell = amigo.spell_tables._ActorTable[spellid]
			if (not spell) then
				spell = amigo.spell_tables:CatchSpell(spellid, true, token)
			end

			return spell:AddFF(amount) --adiciona a class da ability, a class da ability se encarrega de adicionar aos targets dela
		else
			_current_total[1] = _current_total[1]+amount
			
		end
		
	------------------------------------------------------------------------------------------------
	--> amount add

		--> actor owner(if any)
		if (mine_owner) then --> se for damage de um Pet
			mine_owner.total = mine_owner.total + amount --> e adiciona o damage ao pet
			
			--> add owner targets
			local owner_target = mine_owner.targets._NameIndexTable[dst_name]
			if (not owner_target) then
				owner_target = mine_owner.targets:CatchCombatant(dst_serial, dst_name, dst_flags, true) --retorna o objeto class_target -> ALVO_DA_HABILIDADE:Newtable()
			else
				owner_target = mine_owner.targets._ActorTable[owner_target]
			end
			owner_target.total = owner_target.total + amount
			
			mine_owner.last_event = _timestamp
		end

		--> actor
		this_player.total = this_player.total + amount
		
		--> actor without pets
		this_player.total_without_pet = this_player.total_without_pet + amount

		--> actor targets
		local this_dst = this_player.targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.targets:CatchCombatant(dst_serial, dst_name, dst_flags, true) --retorna o objeto class_target -> ALVO_DA_HABILIDADE:Newtable()
		else
			this_dst = this_player.targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + amount

		--> actor spells table
		local spell = this_player.spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.spell_tables:CatchSpell(spellid, true, token)
		end
		
		return spell_damage_func(spell, dst_serial, dst_name, dst_flags, amount, src_name, resisted, blocked, absorbed, critical, glacing, token)
	end

	function parser:swingmissed(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, missType, amountMissed)
		return parser:missed(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, 1, "Corpo-a-Corpo", 00000001, missType, amountMissed)
	end

	function parser:rangemissed(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, missType, amountMissed)
		return parser:missed(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, 2, "Auto Shot", 00000001, missType, amountMissed)
	end

	function parser:missed(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, missType, amountMissed)
		if missType == "ABSORB" and amountMissed > 0 and dst_name and shields[dst_name] and src_name then
		--Skada:Print(dstName.." absorbed "..absorbed.." from "..srcName.."(MISS)")
		consider_absorb(amountMissed, dst_name, src_name, time, dst_flags)
		end
	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (not src_name or not dst_name) then
			return --> just return
		end

	------------------------------------------------------------------------------------------------
	--> get actors
		
		--> 'misser'
		local this_player = damage_cache[src_name]
		if (not this_player) then
			this_player, mine_owner, src_name = _current_damage_container:CatchCombatant(nil, src_name)
			if (not this_player) then
				return --> just return if actor doen't exist yet
			end
		end

		if (tanks_members_cache[dst_serial]) then --> only track tanks
			local TargetActor = damage_cache[dst_name]
			if (TargetActor) then
			
				local avoidance = TargetActor.avoidance
				local missTable = avoidance.overall[missType]
				
				if (missTable) then
					--> overall
					local overall = avoidance.overall
					overall[missType] = missTable + 1 --> adicionado a amount do miss

					--> from this mob
					local mob = avoidance[src_name]
					if (not mob) then --> if isn't in the table, build on the fly
						mob = _details:CreateActorAvoidanceTable(true)
						avoidance[src_name] = mob
					end
					
					mob[missType] = mob[missType] + 1
					
					if (missType == "ABSORB") then --full absorb
						overall["ALL"] = overall["ALL"] + 1 --> whichtype de hit ou absorb
						overall["FULL_ABSORBED"] = overall["FULL_ABSORBED"] + 1 --amount
						overall["ABSORB_AMT"] = overall["ABSORB_AMT"] + amountMissed
						overall["FULL_ABSORB_AMT"] = overall["FULL_ABSORB_AMT"] + amountMissed
						
						mob["ALL"] = mob["ALL"] + 1  --> whichtype de hit ou absorb
						mob["FULL_ABSORBED"] = mob["FULL_ABSORBED"] + 1 --amount
						mob["ABSORB_AMT"] = mob["ABSORB_AMT"] + amountMissed
						mob["FULL_ABSORB_AMT"] = mob["FULL_ABSORB_AMT"] + amountMissed
					end
					
				end

			end
		end
		
	------------------------------------------------------------------------------------------------
	--> amount add
		
		--> actor spells table
		local spell = this_player.spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.spell_tables:CatchSpell(spellid, true, token)
		end
		return spell:AddMiss(dst_serial, dst_name, dst_flags, src_name, missType)
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------
	--> SUMMON 	serach key: ~summon										|
-----------------------------------------------------------------------------------------------------------------------------------------
	function parser:summon(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellName)
	
		if (not src_name) then
			src_name = "[*] " .. spellName
		end
	
		--> pet summon another pet
		local sou_pet = _details.table_pets.pets[src_serial]
		if (sou_pet) then --> okey, ja é um pet
			src_name, src_serial, src_flags = sou_pet[1], sou_pet[2], sou_pet[3]
		end
		
		local dst_pet = _details.table_pets.pets[dst_serial]
		if (dst_pet) then
			src_name, src_serial, src_flags = dst_pet[1], dst_pet[2], dst_pet[3]
		end

		return _details.table_pets:Adicionar(dst_serial, dst_name, dst_flags, src_serial, src_name, src_flags)
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> HEALING 	serach key: ~heal											|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:heal(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, amount, overhealing, absorbed, critical, is_shield)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		--print("parser:heal: "..src_name, dst_name, spellid, spellname, amount)
		--> only capture heal if is in combat
		if (not _in_combat) then
			return
		end
	
		--> check nil serial against pets
		if (src_serial == "0x0000000000000000") then
			if (src_flags and _bit_band(src_flags, OBJECT_TYPE_PETS) ~= 0) then --> é um pet
				return
			end
			--src_serial = nil
		end

		--> no name, use spellname
		if (not src_name) then
			src_name = "[*] "..spellname
		end

		--> no target, just ignore
		if (not dst_name) then
			return
		end
		-- effective healing
		local heal_efetiva = absorbed
		if (is_shield) then 
			--> o shield ja passa o number exato da heal e o overheal
			heal_efetiva = amount
		else
			--effective healing = absorbed + amount - overhealing
			heal_efetiva = heal_efetiva + amount - overhealing
		end
		
		_current_heal_container.need_refresh = true
	
	------------------------------------------------------------------------------------------------
	--> get actors
		-- healed player, srcOwner
		local this_player, mine_owner = healing_cache[src_name]
		if (not this_player) then --> can be stranger or pet
			-- this player, my owner, srcName
			this_player, mine_owner, src_name = _current_heal_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner and src_flags) then --> if it's not a pet, add to cache
				healing_cache[src_name] = this_player
			end
		end
		-- dstName, dstOwner 
		local player_dst, dst_owner = healing_cache[dst_name]
		if (not player_dst) then
			-- target played, target owner, target name
			player_dst, dst_owner, dst_name = _current_heal_container:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			if (not dst_owner and dst_flags) then
				healing_cache[dst_name] = player_dst
			end
		end
		
		this_player.last_event = _timestamp

	------------------------------------------------------------------------------------------------
	--> an enemy healing enemy or an player actor healing an enemy

		if (_bit_band(dst_flags, REACTION_FRIENDLY) == 0 and not _details.is_in_arena) then
			if (not this_player.heal_enemy[spellid]) then 
				this_player.heal_enemy[spellid] = heal_efetiva
			else
				this_player.heal_enemy[spellid] = this_player.heal_enemy[spellid] + heal_efetiva
			end
			
			this_player.heal_enemy_amt = this_player.heal_enemy_amt + heal_efetiva
			
			return
		end	
		
	------------------------------------------------------------------------------------------------
	--> group checks

		if (this_player.group) then 
			_current_combat.totals_group[2] = _current_combat.totals_group[2] + heal_efetiva
		end
		
		if (player_dst.group and amount > 200) then
		
			local t = last_events_cache[dst_name]
			
			if (not t) then
				t = _current_combat:CreateLastEventsTable(dst_name)
			end
			
			local i = t.n
			
			local this_event = t[i]
			
			this_event[1] = false --> true if this is a damage || false for healing
			this_event[2] = spellid --> spellid || false if this is a battle ress line
			this_event[3] = amount --> amount of damage or healing
			this_event[4] = time --> parser time
			this_event[5] = _UnitHealth(dst_name) --> current unit heal
			this_event[6] = src_name --> source name
			this_event[7] = is_shield
			this_event[8] = absorbed
			
			i = i + 1
			
			if (i == 17) then
				t.n = 1
			else
				t.n = i
			end
			
		end

	------------------------------------------------------------------------------------------------
	--> timer
		
		if (not this_player.initialize_hps) then
		
			this_player:Initialize(true) -- start player hps timer
			-- start owner's timer
			if (mine_owner and not mine_owner.dps_started) then
				mine_owner:Initialize(true)
				if (mine_owner.end_time) then
					mine_owner.end_time = nil
				else
					mine_owner:InitializeTime(_timestamp, mine_owner.shadow)
				end
			end
			
			if (this_player.end_time) then --> the fight is over, repoen the time
				this_player.end_time = nil
			else
				this_player:InitializeTime(_timestamp, this_player.shadow)
			end
		end

	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> actor target
		local this_dst = this_player.targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.targets._ActorTable[this_dst]
		end
		
		if (heal_efetiva > 0) then
		
			--> combat total
			_current_total[2] = _current_total[2] + heal_efetiva
		
			--> healing taken 
			player_dst.healing_taken = player_dst.healing_taken + heal_efetiva --> adiciona o damage tomado
			if (not player_dst.healing_from[src_name]) then --> adiciona a pool de damage tomado de quem
				player_dst.healing_from[src_name] = true
			end
			
			--> actor healing amount
			this_player.total = this_player.total + heal_efetiva
			
			if (is_shield) then
				this_player.totalabsorb = this_player.totalabsorb + heal_efetiva
			end

			this_player.total_without_pet = this_player.total_without_pet + heal_efetiva
			
			--> pet
			if (mine_owner) then
				mine_owner.total = mine_owner.total + heal_efetiva --> heal do pet
				
				local owner_target = mine_owner.targets._NameIndexTable[dst_name]
				if (not owner_target) then
					owner_target = mine_owner.targets:CatchCombatant(dst_serial, dst_name, dst_flags, true) --retorna o objeto class_target -> ALVO_DA_HABILIDADE:Newtable()
				else
					owner_target = mine_owner.targets._ActorTable[owner_target]
				end
				owner_target.total = owner_target.total + amount
			end
			
			--> target amount
			this_dst.total = this_dst.total + heal_efetiva
		end
		
		if (mine_owner) then
			mine_owner.last_event = _timestamp
		end
		
		if (overhealing > 0) then
			this_player.totalover = this_player.totalover + overhealing
			this_dst.overheal = this_dst.overheal + overhealing
			if (mine_owner) then
				mine_owner.totalover = mine_owner.totalover + overhealing
			end
		end

		--> actor spells table
		local spell = this_player.spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.spell_tables:CatchSpell(spellid, true, token)
		end
		
		if (is_shield) then
			--return spell:Add(dst_serial, dst_name, dst_flags, heal_efetiva, src_name, 0, 		  nil, 	     overhealing, true)
			return spell_heal_func(spell, dst_serial, dst_name, dst_flags, heal_efetiva, src_name, 0, 		  nil, 	     overhealing, true)
		else
			--return spell:Add(dst_serial, dst_name, dst_flags, heal_efetiva, src_name, absorbed, critical, overhealing)
			return spell_heal_func(spell, dst_serial, dst_name, dst_flags, heal_efetiva, src_name, absorbed, critical, overhealing)
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> BUFFS & DEBUFFS 	serach key: ~buff ~aura ~shield								|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:buff(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, type, amount)
		if AbsorbSpellDuration[spellid] then
			--print("parser:buff("..time..", "..src_name..", "..dst_name..", "..spellname)
			shields[dst_name] = shields[dst_name] or {}
			shieldFlags[dst_name] = shieldFlags[dst_name] or {}
			shields[dst_name][spellid] = shields[dst_name][spellid] or {}
			shieldFlags[dst_name][spellid] = shieldFlags[dst_name][spellid] or {}
			--print("ts = "..time + AbsorbSpellDuration[spellid])
			shields[dst_name][spellid][src_name] = time + AbsorbSpellDuration[spellid]
			--print("shields["..dst_name.."]["..spellid.."]["..src_name.."] = "..shields[dst_name][spellid][src_name])
			shieldFlags[dst_name][spellid][src_name] = src_flags
		end
		
	--> not yet well know about unnamed buff casters
		if (not dst_name) then
			dst_name = "[*] Unknown shield target"
		elseif (not src_name) then 
			src_name = "[*] " .. spellname
		end 
		
	------------------------------------------------------------------------------------------------
	--> handle shields

		if (type == "BUFF") then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					-- jade spirit doesn't send src_name, that's a shame. 
					if ((src_name == dst_name or RaidBuffsSpells[spellid]) and raid_members_cache[dst_serial] and _in_combat) then
						--> call record buffs uptime
	--[[not tail call, need to fix this]]	parser:add_buff_uptime(token, time, dst_serial, dst_name, dst_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "BUFF_UPTIME_IN")
					end
				end
			------------------------------------------------------------------------------------------------
			--> defensive cooldowns
				if (defensive_cooldown_spell_list[spellid]) then
					--> usou cooldown
					return parser:add_defensive_cooldown(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
				
			------------------------------------------------------------------------------------------------
			--> recording buffs
				elseif (_recording_self_buffs) then
					--> or dst_name needded, seems jade spirit not send src_name correctly
					if (src_name == _details.playername or dst_name == _details.playername) then
						local bufftable = _details.Buffs.BuffsTable[spellname]
						if (bufftable) then
							return bufftable:UpdateBuff("new")
						else
							return false
						end
					end

			end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif (type == "DEBUFF") then
			
			if (_in_combat) then
			
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (raid_members_cache[dst_serial] and RaidBuffsSpells[spellid]) then
						parser:add_buff_uptime(token, time, dst_serial, dst_name, dst_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "BUFF_UPTIME_IN")
					end				
					if (raid_members_cache[src_serial]) then
						--> call record debuffs uptime
	--[[not tail call, need to fix this]]	parser:add_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "DEBUFF_UPTIME_IN")
	
					elseif (raid_members_cache[dst_serial] and not raid_members_cache[src_serial]) then --> dst é da raide é alguem de fora da raide
	--[[not tail call, need to fix this]]	parser:add_bad_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_IN")
					end
				end
			
				if (_recording_ability_with_buffs) then
					if (src_name == _details.playername) then

						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if (not SoloDebuffUptime) then
							SoloDebuffUptime = {}
							_current_combat.SoloDebuffUptime = SoloDebuffUptime
						end
						
						local ThisDebuff = SoloDebuffUptime[spellid]
						
						if (not ThisDebuff) then
							ThisDebuff = {name = spellname, duration = 0, start = _timestamp, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true}
							SoloDebuffUptime[spellid] = ThisDebuff
						else
							ThisDebuff.castedAmt = ThisDebuff.castedAmt + 1
							ThisDebuff.start = _timestamp
							ThisDebuff.Active = true
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (not SoloDebuffPower) then
							SoloDebuffPower = {}
							_current_combat.SoloDebuffPower = SoloDebuffPower
						end
						
						local ThisDebuff = SoloDebuffPower[spellid]
						if (not ThisDebuff) then
							ThisDebuff = {}
							SoloDebuffPower[spellid] = ThisDebuff
						end
					
						local ThisDebuffOnTarget = ThisDebuff[dst_serial]
						
						local base, posBuff, negBuff = UnitAttackPower("player")
						local AttackPower = base+posBuff+negBuff
						local base, posBuff, negBuff = UnitRangedAttackPower("player")
						local RangedAttackPower = base+posBuff+negBuff
						local SpellPower = GetSpellBonusDamage(3)
						
						--> record buffs active on player when the debuff was applied
						local BuffsOn = {}
						for BuffName, BuffTable in _pairs(_details.Buffs.BuffsTable) do
							if (BuffTable.active) then
								BuffsOn[#BuffsOn+1] = BuffName
							end
						end
						
						if (not ThisDebuffOnTarget) then --> apply
							ThisDebuff[dst_serial] = {power = math.max(AttackPower, RangedAttackPower, SpellPower), onTarget = true, buffs = BuffsOn}
						else --> re applying
							ThisDebuff[dst_serial].power = math.max(AttackPower, RangedAttackPower, SpellPower)
							ThisDebuff[dst_serial].buffs = BuffsOn
							ThisDebuff[dst_serial].onTarget = true
						end
						
						--> send event for plugins
						_details:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
						
					end
				end
			end
		end
	end

	function parser:buff_refresh(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, type, amount)
		if AbsorbSpellDuration[spellid] then	
			shields[dst_name] = shields[dst_name] or {}
			shieldFlags[dst_name] = shields[dst_name] or {}
			shields[dst_name][spellid] = shields[dst_name][spellid] or {}
			shieldFlags[dst_name][spellid] = shieldFlags[dst_name][spellid] or {}
			shields[dst_name][spellid][src_name] = time + AbsorbSpellDuration[spellid]
			--print("shields["..dst_name.."]["..spellid.."]["..src_name.."] = "..shields[dst_name][spellid][src_name])
			shieldFlags[dst_name][spellid][src_name] = src_flags
		end
	------------------------------------------------------------------------------------------------
	--> handle shields

		if (type == "BUFF") then
		
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if ((src_name == dst_name  or RaidBuffsSpells[spellid]) and raid_members_cache[src_serial] and _in_combat) then
						--> call record buffs uptime
	--[[not tail call, need to fix this]]	parser:add_buff_uptime(token, time, dst_serial, dst_name, dst_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "BUFF_UPTIME_REFRESH")
					end
				end
		
			------------------------------------------------------------------------------------------------
			--> healing done(shields)
				--[[ if (absorb_spell_list[spellid] and _recording_healing and amount) then
					
					if (shield[dst_name] and shield[dst_name][spellid] and shield[dst_name][spellid][src_name]) then
					
						local absorb = shield[dst_name][spellid][src_name] - amount
						local overheal = amount - absorb
						shield[dst_name][spellid][src_name] = amount
						
						--if (absorb > 0) then
							return parser:heal(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, nil, _math_ceil(absorb), _math_ceil(overheal), 0, 0, true)
						--end
					else
						--> should apply aura if not found in already applied buff list?
					end
				]]--
			------------------------------------------------------------------------------------------------
			--> defensive cooldowns
				if (defensive_cooldown_spell_list[spellid]) then
					--> usou cooldown
					return parser:add_defensive_cooldown(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
					
			------------------------------------------------------------------------------------------------
			--> recording buffs

				elseif (_recording_self_buffs) then
					if (src_name == _details.playername or dst_name == _details.playername) then --> foi colocado pelo player
					
						local bufftable = _details.Buffs.BuffsTable[spellname]
						if (bufftable) then
							return bufftable:UpdateBuff("refresh")
						else
							return false
						end
					end
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player

		elseif (type == "DEBUFF") then
		
			if (_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (raid_members_cache[dst_serial] and RaidBuffsSpells[spellid]) then
						parser:add_buff_uptime(token, time, dst_serial, dst_name, dst_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "BUFF_UPTIME_IN")
					end						
					if (raid_members_cache[src_serial]) then
						--> call record debuffs uptime
	--[[not tail call, need to fix this]]	parser:add_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "DEBUFF_UPTIME_REFRESH")
					elseif (raid_members_cache[dst_serial] and not raid_members_cache[src_serial]) then --> dst é da raide e o caster é enemy
	--[[not tail call, need to fix this]]	parser:add_bad_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_REFRESH")
					end
				end
		
				if (_recording_ability_with_buffs) then
					if (src_name == _details.playername) then
					
						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						if (SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime[spellid]
							if (ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.refreshAmt = ThisDebuff.refreshAmt + 1
								ThisDebuff.duration = ThisDebuff.duration +(_timestamp - ThisDebuff.start)
								ThisDebuff.start = _timestamp
								
								--> send event for plugins
								_details:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
							end
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower[spellid]
							if (ThisDebuff) then
								local ThisDebuffOnTarget = ThisDebuff[dst_serial]
								if (ThisDebuffOnTarget) then
									local base, posBuff, negBuff = UnitAttackPower("player")
									local AttackPower = base+posBuff+negBuff
									local base, posBuff, negBuff = UnitRangedAttackPower("player")
									local RangedAttackPower = base+posBuff+negBuff
									local SpellPower = GetSpellBonusDamage(3)
									
									local BuffsOn = {}
									for BuffName, BuffTable in _pairs(_details.Buffs.BuffsTable) do
										if (BuffTable.active) then
											BuffsOn[#BuffsOn+1] = BuffName
										end
									end
									
									ThisDebuff[dst_serial].power = math.max(AttackPower, RangedAttackPower, SpellPower)
									ThisDebuff[dst_serial].buffs = BuffsOn
									
									--> send event for plugins
									_details:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
								end
							end
						end
						
					end
				end
			end
		end
	end

	function parser:unbuff(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, type, amount)
		if AbsorbSpellDuration[spellid] then
			if shields[dst_name] and shields[dst_name][spellid] and shields[dst_name][spellid][dst_name] then
				-- As advised in RecountGuessedAbsorbs, do not remove shields straight away as an absorb can come after the aura removed event.
				shields[dst_name][spellid][src_name] = time + 0.1
			end
		end
	------------------------------------------------------------------------------------------------
	--> handle shields

		if (type == "BUFF") then
		
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if ((src_name == dst_name or RaidBuffsSpells[spellid]) and raid_members_cache[dst_serial] and _in_combat) then
						--> call record buffs uptime
	--[[not tail call, need to fix this]]	parser:add_buff_uptime(token, time, dst_serial, dst_name, dst_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "BUFF_UPTIME_OUT")
					end
				end
			------------------------------------------------------------------------------------------------
			--> recording buffs
				if (_recording_self_buffs) then
					if (src_name == _details.playername or dst_name == _details.playername) then --> foi colocado pelo player
					
						local bufftable = _details.Buffs.BuffsTable[spellname]
						if (bufftable) then
							return bufftable:UpdateBuff("remove")
						else
							return false
						end			
					end			
				end

	------------------------------------------------------------------------------------------------
	--> recording debuffs applied by player
		elseif (type == "DEBUFF") then
		
			if (_in_combat) then
			------------------------------------------------------------------------------------------------
			--> buff uptime
				if (_recording_buffs_and_debuffs) then
					if (raid_members_cache[src_serial]) then
						--> call record debuffs uptime
	--[[not tail call, need to fix this]]	parser:add_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, "DEBUFF_UPTIME_OUT")
					elseif (raid_members_cache[dst_serial] and not raid_members_cache[src_serial]) then --> dst é da raide e o caster é enemy
	--[[not tail call, need to fix this]]	parser:add_bad_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, "DEBUFF_UPTIME_OUT")
					end
				end
			
				if (_recording_ability_with_buffs) then
			
					if (src_name == _details.playername) then
					
						--> record debuff uptime
						local SoloDebuffUptime = _current_combat.SoloDebuffUptime
						local sendevent = false
						if (SoloDebuffUptime) then
							local ThisDebuff = SoloDebuffUptime[spellid]
							if (ThisDebuff and ThisDebuff.Active) then
								ThisDebuff.duration = ThisDebuff.duration +(_timestamp - ThisDebuff.start)
								ThisDebuff.droppedAmt = ThisDebuff.droppedAmt + 1
								ThisDebuff.start = nil
								ThisDebuff.Active = false
								sendevent = true
							end
						end
						
						--> record debuff spell and attack power
						local SoloDebuffPower = _current_combat.SoloDebuffPower
						if (SoloDebuffPower) then
							local ThisDebuff = SoloDebuffPower[spellid]
							if (ThisDebuff) then
								ThisDebuff[dst_serial] = nil
								sendevent = true
							end
						end
						
						if (sendevent) then
							_details:SendEvent("BUFF_UPDATE_DEBUFFPOWER")
						end
					end
				end
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~buffuptime ~buffsuptime									|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:add_bad_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spellschool, in_out)
		
		if (not dst_name) then
			--> no target name, just quit
			return
		elseif (not src_name) then
			--> no actor name, use spell name instead
			src_name = "[*] "..spellname
		end
		
		------------------------------------------------------------------------------------------------
		--> get actors
			--> name do debuff será usado para armazenar o name do ator
			local this_player = misc_cache[spellname]
			if (not this_player) then --> pode ser um desconhecido ou um pet
				this_player = _current_misc_container:CatchCombatant(src_serial, spellname, src_flags, true)
				misc_cache[spellname] = this_player
			end
		
		------------------------------------------------------------------------------------------------
		--> build containers on the fly
			
			if (not this_player.debuff_uptime) then
				this_player.boss_debuff = true
				this_player.damage_twin = src_name
				this_player.spellschool = spellschool
				this_player.damage_spellid = spellid
				this_player.debuff_uptime = 0
				this_player.debuff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
				this_player.debuff_uptime_targets = container_combatants:NewContainer(container_enemydebufftarget_target)
				
				if (not this_player.shadow.debuff_uptime_targets) then
					this_player.shadow.boss_debuff = true
					this_player.shadow.damage_twin = src_name
					this_player.shadow.spellschool = spellschool
					this_player.shadow.damage_spellid = spellid
					this_player.shadow.debuff_uptime = 0
					this_player.shadow.debuff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
					this_player.shadow.debuff_uptime_targets = container_combatants:NewContainer(container_enemydebufftarget_target)
				end
				
				this_player.debuff_uptime_targets.shadow = this_player.shadow.debuff_uptime_targets
				this_player.debuff_uptime_spell_tables.shadow = this_player.shadow.debuff_uptime_spell_tables
				
			end
		
		------------------------------------------------------------------------------------------------
		--> add amount
			
			--> update last event
			this_player.last_event = _timestamp
			
			--> actor target
			local this_dst = this_player.debuff_uptime_targets._NameIndexTable[dst_name]
			if (not this_dst) then
				this_dst = this_player.debuff_uptime_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			else
				this_dst = this_player.debuff_uptime_targets._ActorTable[this_dst]
			end
			
			if (in_out == "DEBUFF_UPTIME_IN") then
				this_dst.actived = true
				this_dst.activedamt = this_dst.activedamt + 1
				if (this_dst.actived_at and this_dst.actived) then
					this_dst.uptime = this_dst.uptime + _timestamp - this_dst.actived_at
					this_player.debuff_uptime = this_player.debuff_uptime + _timestamp - this_dst.actived_at
				end
				this_dst.actived_at = _timestamp
				
			elseif (in_out == "DEBUFF_UPTIME_REFRESH") then
				if (this_dst.actived_at and this_dst.actived) then
					this_dst.uptime = this_dst.uptime + _timestamp - this_dst.actived_at
					this_player.debuff_uptime = this_player.debuff_uptime + _timestamp - this_dst.actived_at
				end
				this_dst.actived_at = _timestamp
				this_dst.actived = true
				
			elseif (in_out == "DEBUFF_UPTIME_OUT") then
				if (this_dst.actived_at and this_dst.actived) then
					this_dst.uptime = this_dst.uptime + _details._time - this_dst.actived_at
					this_player.debuff_uptime = this_player.debuff_uptime + _timestamp - this_dst.actived_at --> token = actor misc object
				end
				
				this_dst.activedamt = this_dst.activedamt - 1
				
				if (this_dst.activedamt == 0) then
					this_dst.actived = false
					this_dst.actived_at = nil
				else
					this_dst.actived_at = _timestamp
				end
			end
	end

	-- ~debuff
	function parser:add_debuff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, in_out)
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
		local this_player = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			misc_cache[src_name] = this_player
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not this_player.debuff_uptime) then
			this_player.debuff_uptime = 0
			this_player.debuff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
			this_player.debuff_uptime_targets = container_combatants:NewContainer(container_damage_target)
			
			if (not this_player.shadow.debuff_uptime_targets) then
				this_player.shadow.debuff_uptime = 0
				this_player.shadow.debuff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
				this_player.shadow.debuff_uptime_targets = container_combatants:NewContainer(container_damage_target)
			end
			
			this_player.debuff_uptime_targets.shadow = this_player.shadow.debuff_uptime_targets
			this_player.debuff_uptime_spell_tables.shadow = this_player.shadow.debuff_uptime_spell_tables
		end
	
	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> update last event
		this_player.last_event = _timestamp

		--> actor spells table
		local spell = this_player.debuff_uptime_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.debuff_uptime_spell_tables:CatchSpell(spellid, true, "DEBUFF_UPTIME")
		end
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, this_player, "BUFF_OR_DEBUFF", in_out)
		
	end

	function parser:add_buff_uptime(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, in_out)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
		local this_player = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			misc_cache[src_name] = this_player
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not this_player.buff_uptime) then
			this_player.buff_uptime = 0
			this_player.buff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
			this_player.buff_uptime_targets = container_combatants:NewContainer(container_damage_target)
			
			if (not this_player.shadow.buff_uptime_targets) then
				this_player.shadow.buff_uptime = 0
				this_player.shadow.buff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
				this_player.shadow.buff_uptime_targets = container_combatants:NewContainer(container_damage_target)
			end
			
			this_player.buff_uptime_targets.shadow = this_player.shadow.buff_uptime_targets
			this_player.buff_uptime_spell_tables.shadow = this_player.shadow.buff_uptime_spell_tables
		end	

	------------------------------------------------------------------------------------------------
	--> hook
	
		if (_hook_buffs) then
			--> send event to registred functions
			for _, func in _ipairs(_hook_buffs_container) do 
				func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, in_out)
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount
		
		--> update last event
		this_player.last_event = _timestamp

		--> actor spells table
		local spell = this_player.buff_uptime_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.buff_uptime_spell_tables:CatchSpell(spellid, true, "BUFF_UPTIME")
		end
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, this_player, "BUFF_OR_DEBUFF", in_out)
		
	end

-----------------------------------------------------------------------------------------------------------------------------------------
	--> ENERGY	serach key: ~energy												|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:energize(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, amount, powertype, p6, p7)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (not src_name) then
			src_name = "[*] "..spellname
		elseif (not dst_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> get regen key name
		
		local key_regenDone
		local key_regenFrom 
		local key_regenType
		
		if (powertype == 0) then --> MANA
			key_regenDone = "mana_r"
			key_regenFrom = "mana_from"
			key_regenType = "mana"
		elseif (powertype == 1) then --> RAGE
			key_regenDone = "e_rage_r"
			key_regenFrom = "e_rage_from"
			key_regenType = "e_rage"
		elseif (powertype == 3) then --> ENERGY
			key_regenDone = "e_energy_r"
			key_regenFrom = "e_energy_from"
			key_regenType = "e_energy"
		elseif (powertype == 6) then --> RUNEPOWER
			key_regenDone = "runepower_r"
			key_regenFrom = "runepower_from"
			key_regenType = "runepower"
		else
			--> not tracking this regen type
			return
		end
		
		_current_energy_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local this_player, mine_owner = energy_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_energy_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				energy_cache[src_name] = this_player
			end
		end
		
		--> target
		local player_dst, dst_owner = energy_cache[dst_name]
		if (not player_dst) then
			player_dst, dst_owner, dst_name = _current_energy_container:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			if (not dst_owner) then
				energy_cache[dst_name] = player_dst
			end
		end
		
		--> actor targets
		local this_dst = this_player.targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.targets:CatchCombatant(dst_serial, dst_name, dst_flags, true) --retorna o objeto class_target -> ALVO_DA_HABILIDADE:Newtable()
		else
			this_dst = this_player.targets._ActorTable[this_dst]
		end
		
		this_player.last_event = _timestamp

	------------------------------------------------------------------------------------------------
	--> amount add
		
		--> combat total
		_current_total[3][key_regenType] = _current_total[3][key_regenType] + amount
		
		if (this_player.group) then 
			_current_gtotal[3][key_regenType] = _current_gtotal[3][key_regenType] + amount
		end

		--> regen produced amount
		this_player[key_regenType] = this_player[key_regenType] + amount
		this_dst[key_regenType] = this_dst[key_regenType] + amount
		
		--> target regenerated amount
		player_dst[key_regenDone] = player_dst[key_regenDone] + amount
		
		--> regen from
		if (not player_dst[key_regenFrom][src_name]) then
			player_dst[key_regenFrom][src_name] = true
		end
		
		--> owner
		if (mine_owner) then
			mine_owner[key_regenType] = mine_owner[key_regenType] + amount --> e adiciona o damage ao pet
		end

		--> actor spells table
		local spell = this_player.spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.spell_tables:CatchSpell(spellid, true, token)
		end
		
		--return spell:Add(dst_serial, dst_name, dst_flags, amount, src_name, powertype)
		return spell_energy_func(spell, dst_serial, dst_name, dst_flags, amount, src_name, powertype)
	end


	
-----------------------------------------------------------------------------------------------------------------------------------------
	--> MISC 	search key: ~cooldown											|
-----------------------------------------------------------------------------------------------------------------------------------------

	function parser:add_defensive_cooldown(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
	
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors
	
		--> main actor
		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not this_player.cooldowns_defensive) then
			this_player.cooldowns_defensive = _details:GetOrderNumber(src_name)
			this_player.cooldowns_defensive_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			this_player.cooldowns_defensive_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities
			
			if (not this_player.shadow.cooldowns_defensive_targets) then
				this_player.shadow.cooldowns_defensive = _details:GetOrderNumber(src_name)
				this_player.shadow.cooldowns_defensive_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				this_player.shadow.cooldowns_defensive_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas
			end

			this_player.cooldowns_defensive_targets.shadow = this_player.shadow.cooldowns_defensive_targets
			this_player.cooldowns_defensive_spell_tables.shadow = this_player.shadow.cooldowns_defensive_spell_tables
		end	
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor cooldowns used
		this_player.cooldowns_defensive = this_player.cooldowns_defensive + 1

		--> combat totals
		_current_total[4].cooldowns_defensive = _current_total[4].cooldowns_defensive + 1
		
		if (this_player.group) then
			_current_gtotal[4].cooldowns_defensive = _current_gtotal[4].cooldowns_defensive + 1
			
			if (src_name == dst_name) then
			
				local damage_actor = damage_cache[src_name]
				if (not damage_actor) then --> pode ser um desconhecido ou um pet
					damage_actor = _current_damage_container:CatchCombatant(src_serial, src_name, src_flags, true)
					if (src_flags) then --> se não for um pet, adicionar no cache
						damage_cache[src_name] = damage_actor
					end
				end

				--> last events
				local t = last_events_cache[src_name]
				
				if (not t) then
					t = _current_combat:CreateLastEventsTable(src_name)
				end
			
				local i = t.n
				local this_event = t[i]
				
				this_event[1] = 1 --> true if this is a damage || false for healing || 1 for cooldown
				this_event[2] = spellid --> spellid || false if this is a battle ress line
				this_event[3] = 1 --> amount of damage or healing
				this_event[4] = time --> parser time
				this_event[5] = _UnitHealth(src_name) --> current unit heal
				this_event[6] = src_name --> source name
				
				i = i + 1
				if (i == 17) then
					t.n = 1
				else
					t.n = i
				end
				
				this_player.last_cooldown = {time, spellid}
				
			end
			
		end
		
		--> update last event
		this_player.last_event = _timestamp
		
		--> actor targets
		local this_dst = this_player.cooldowns_defensive_targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.cooldowns_defensive_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.cooldowns_defensive_targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + 1

		--> actor spells table
		local spell = this_player.cooldowns_defensive_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.cooldowns_defensive_spell_tables:CatchSpell(spellid, true, token)
		end
		
		if (_hook_cooldowns) then
			--> send event to registred functions
			for _, func in _ipairs(_hook_cooldowns_container) do 
				func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
			end
		end
		
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, token, "BUFF_OR_DEBUFF", "COOLDOWN")
		
	end

	
	--serach key: ~interrupt
	function parser:interrupt(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (not src_name) then
			src_name = "[*] "..spellname
		elseif (not dst_name) then
			return
		end
		
		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not this_player.interrupt) then
			this_player.interrupt = _details:GetOrderNumber(src_name)
			this_player.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			this_player.interrupt_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
			this_player.interrompeu_oque = {}
			
			if (not this_player.shadow.interrupt_targets) then
				this_player.shadow.interrupt = _details:GetOrderNumber(src_name)
				this_player.shadow.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				this_player.shadow.interrupt_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
				this_player.shadow.interrompeu_oque = {}
			end

			this_player.interrupt_targets.shadow = this_player.shadow.interrupt_targets
			this_player.interrupt_spell_tables.shadow = this_player.shadow.interrupt_spell_tables
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> actor interrupt amount
		this_player.interrupt = this_player.interrupt + 1

		--> combat totals
		_current_total[4].interrupt = _current_total[4].interrupt + 1
		
		if (this_player.group) then
			_current_gtotal[4].interrupt = _current_gtotal[4].interrupt + 1
		end

		--> update last event
		this_player.last_event = _timestamp
		--shadow.last_event = _timestamp
		
		--> spells interrupted
		if (not this_player.interrompeu_oque[extraSpellID]) then
			this_player.interrompeu_oque[extraSpellID] = 1
		else
			this_player.interrompeu_oque[extraSpellID] = this_player.interrompeu_oque[extraSpellID] + 1
		end
		
		--> actor targets
		local this_dst = this_player.interrupt_targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.interrupt_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.interrupt_targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + 1

		--> actor spells table
		local spell = this_player.interrupt_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.interrupt_spell_tables:CatchSpell(spellid, true, token)
		end
		spell:Add(dst_serial, dst_name, dst_flags, src_name, token, extraSpellID, extraSpellName)
		
		--> verifica se tem owner e adiciona o interrupt para o owner
		if (mine_owner) then
			
			if (not mine_owner.interrupt) then
				mine_owner.interrupt = 0
				mine_owner.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				mine_owner.interrupt_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
				mine_owner.interrompeu_oque = {}
				
				if (not mine_owner.shadow.interrupt_targets) then
					mine_owner.shadow.interrupt = 0
					mine_owner.shadow.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
					mine_owner.shadow.interrupt_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
					mine_owner.shadow.interrompeu_oque = {}
				end

				mine_owner.interrupt_targets.shadow = mine_owner.shadow.interrupt_targets
				mine_owner.interrupt_spell_tables.shadow = mine_owner.shadow.interrupt_spell_tables
			end
			
			-- adiciona ao total
			mine_owner.interrupt = mine_owner.interrupt + 1
			
			-- adiciona aos targets
			local this_dst = mine_owner.interrupt_targets._NameIndexTable[dst_name]
			if (not this_dst) then
				this_dst = mine_owner.interrupt_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			else
				this_dst = mine_owner.interrupt_targets._ActorTable[this_dst]
			end
			this_dst.total = this_dst.total + 1
			
			-- update last event
			mine_owner.last_event = _timestamp
			
			-- spells interrupted
			if (not mine_owner.interrompeu_oque[extraSpellID]) then
				mine_owner.interrompeu_oque[extraSpellID] = 1
			else
				mine_owner.interrompeu_oque[extraSpellID] = mine_owner.interrompeu_oque[extraSpellID] + 1
			end
			
			--> pet interrupt
			if (_hook_interrupt) then
				for _, func in _ipairs(_hook_interrupt_container) do 
					func(nil, token, time, mine_owner.serial, mine_owner.name, mine_owner.flag_original, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		else
			--> player interrupt
			if (_hook_interrupt) then
				for _, func in _ipairs(_hook_interrupt_container) do 
					func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
				end
			end
		end

	end
	
	--> search key: ~spellcast ~castspell ~cast
	function parser:spellcast(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype)
	
		--print(token, time, "WHO:",src_serial, src_name, src_flags, "TARGET:",dst_serial, dst_name, dst_flags, "SPELL:",spellid, spellname, spelltype)

	------------------------------------------------------------------------------------------------
	--> record cooldowns cast which can't track with buff applyed.
	
		--> foi um player que castou
		if (raid_members_cache[src_serial]) then
			--> check if is a cooldown :D
			if (defensive_cooldown_spell_list_no_buff[spellid]) then
				--> usou cooldown
				if (not dst_name) then
					if (defensive_cooldown_spell_list_no_buff[spellid][3] == 1) then
						dst_name = src_name
					else
						dst_name = Loc["STRING_RAID_WIDE"]
					end
				end
				return parser:add_defensive_cooldown(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
			else
				return
			end
		else
			--> successful casts(not interrupted)
			if (_bit_band(src_flags, 0x00000040) ~= 0 and src_name) then --> byte 2 = 4(enemy)
				--> damager
				local this_player = damage_cache[src_name]
				if (not this_player) then
					this_player = _current_damage_container:CatchCombatant(src_serial, src_name, src_flags, true)
				end
				--> actor spells table
				local spell = this_player.spell_tables._ActorTable[spellid]
				if (not spell) then
					spell = this_player.spell_tables:CatchSpell(spellid, true, token)
				end
				spell.successful_casted = spell.successful_casted + 1
				--print("cast success", src_name, spellname)
			end
			return
		end
		
		
	-- para aqui --
	------------------------------------------------------------------------------------------------
	--> record how many times the spell has been casted successfully

		if (not src_name) then
			src_name = "[*] ".. spellname
		end
		
		if (not dst_name) then
			dst_name = "[*] ".. spellid
		end
		
		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor

		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end
		local shadow = this_player.shadow

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not this_player.spellcast) then
			--> constrói aqui a table dele
			this_player.spellcast = 0
			this_player.spellcast_spell_tables = container_abilities:NewContainer(container_misc)

			if (not this_player.shadow.spellcast_targets) then
				this_player.shadow.spellcast = 0
				this_player.shadow.spellcast_spell_tables = container_abilities:NewContainer(container_misc)
			end

			this_player.spellcast_targets.shadow = this_player.shadow.spellcast_targets
			this_player.spellcast_spell_tables.shadow = this_player.shadow.spellcast_spell_tables
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> last event update
		this_player.last_event = _timestamp

		--> actor dispell amount
		this_player.spellcast = this_player.spellcast + 1
		shadow.spellcast = shadow.spellcast + 1
		
		--> actor spells table
		local spell = this_player.spellcast_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.spellcast_spell_tables:CatchSpell(spellid, true, token)
		end
		
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, token)
	end


	--serach key: ~dispell
	function parser:dispell(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)
		
	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		
		--> this dando erro onde o name é NIL, fazendo um fix para isso
		if (not src_name) then
			src_name = "[*] "..extraSpellName
		end
		if (not dst_name) then
			dst_name = "[*] "..spellid
		end
		
		_current_misc_container.need_refresh = true
		
	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		--> debug - no cache
		--[[
		local this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
		--]]
		--[
		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end
		--]]

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not this_player.dispell) then
			--> constrói aqui a table dele
			this_player.dispell = _details:GetOrderNumber(src_name)
			this_player.dispell_targets = container_combatants:NewContainer(container_damage_target)
			this_player.dispell_spell_tables = container_abilities:NewContainer(container_misc)
			this_player.dispell_oque = {}
			
			if (not this_player.shadow.dispell_targets) then
				this_player.shadow.dispell = _details:GetOrderNumber(src_name)
				this_player.shadow.dispell_targets = container_combatants:NewContainer(container_damage_target)
				this_player.shadow.dispell_spell_tables = container_abilities:NewContainer(container_misc)
				this_player.shadow.dispell_oque = {}
			end

			this_player.dispell_targets.shadow = this_player.shadow.dispell_targets
			this_player.dispell_spell_tables.shadow = this_player.shadow.dispell_spell_tables
		end

	------------------------------------------------------------------------------------------------
	--> add amount

		--> last event update
		this_player.last_event = _timestamp
		--shadow.last_event = _timestamp

		--> total dispells in combat
		_current_total[4].dispell = _current_total[4].dispell + 1
		
		if (this_player.group) then
			_current_gtotal[4].dispell = _current_gtotal[4].dispell + 1
		end

		--> actor dispell amount
		this_player.dispell = this_player.dispell + 1
		
		--> dispell what
		if (extraSpellID) then
			if (not this_player.dispell_oque[extraSpellID]) then
				this_player.dispell_oque[extraSpellID] = 1
			else
				this_player.dispell_oque[extraSpellID] = this_player.dispell_oque[extraSpellID] + 1
			end
		end
		
		--> actor targets
		local this_dst = this_player.dispell_targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.dispell_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.dispell_targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + 1

		--> actor spells table
		local spell = this_player.dispell_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.dispell_spell_tables:CatchSpell(spellid, true, token)
		end
		spell:Add(dst_serial, dst_name, dst_flags, src_name, token, extraSpellID, extraSpellName)
		
		--> verifica se tem owner e adiciona o interrupt para o owner
		if (mine_owner) then
			
			if (not mine_owner.dispell) then
				--> constrói aqui a table dele
				mine_owner.dispell = 0
				mine_owner.dispell_targets = container_combatants:NewContainer(container_damage_target)
				mine_owner.dispell_spell_tables = container_abilities:NewContainer(container_misc)
				mine_owner.dispell_oque = {}
				
				if (not mine_owner.shadow.dispell_targets) then
					mine_owner.shadow.dispell = 0
					mine_owner.shadow.dispell_targets = container_combatants:NewContainer(container_damage_target)
					mine_owner.shadow.dispell_spell_tables = container_abilities:NewContainer(container_misc)
					mine_owner.shadow.dispell_oque = {}
				end

				mine_owner.dispell_targets.shadow = mine_owner.shadow.dispell_targets
				mine_owner.dispell_spell_tables.shadow = mine_owner.shadow.dispell_spell_tables
			end
			
			-- adiciona ao total
			mine_owner.dispell = mine_owner.dispell + 1
			
			-- adiciona aos targets
			local this_dst = mine_owner.dispell_targets._NameIndexTable[dst_name]
			if (not this_dst) then
				this_dst = mine_owner.dispell_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
			else
				this_dst = mine_owner.dispell_targets._ActorTable[this_dst]
			end
			this_dst.total = this_dst.total + 1
			
			-- update last event
			mine_owner.last_event = _timestamp
			
			-- spells interrupted
			if (not mine_owner.dispell_oque[extraSpellID]) then
				mine_owner.dispell_oque[extraSpellID] = 1
			else
				mine_owner.dispell_oque[extraSpellID] = mine_owner.dispell_oque[extraSpellID] + 1
			end
		end		
		
	end

	--serach key: ~ress
	function parser:ress(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes

		if (_bit_band(src_flags, AFFILIATION_GROUP) == 0) then
			return
		end
		
		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end

	------------------------------------------------------------------------------------------------
	--> build containers on the fly

		if (not this_player.ress) then
			--> constrói aqui a table dele
			this_player.ress = _details:GetOrderNumber(src_name)
			this_player.ress_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			this_player.ress_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
			
			if (not this_player.shadow.ress_targets) then
				this_player.shadow.ress = _details:GetOrderNumber(src_name)
				this_player.shadow.ress_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				this_player.shadow.ress_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
			end

			this_player.ress_targets.shadow = this_player.shadow.ress_targets
			this_player.ress_spell_tables.shadow = this_player.shadow.ress_spell_tables
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		this_player.last_event = _timestamp
		--shadow.last_event = _timestamp

		--> combat ress total
		_current_total[4].ress = _current_total[4].ress + 1
		
		if (this_player.group) then
			_current_combat.totals_group[4].ress = _current_combat.totals_group[4].ress+1
		end	

		--> add ress amount
		this_player.ress = this_player.ress + 1
		
		--> add battle ress
		if (_UnitAffectingCombat(src_name)) then 
			--> proheal a última death do dst na table do combat:
			for i = 1, #_current_combat.last_events_tables do 
				if (_current_combat.last_events_tables[i][3] == dst_name) then

					local deadLog = _current_combat.last_events_tables[i][1]
					local jaTem = false
					for _, evento in _ipairs(deadLog) do 
						if (evento[1] and not evento[3]) then
							jaTem = true
						end
					end
					
					if (not jaTem) then 
						_table_insert(_current_combat.last_events_tables[i][1], 1, {
							2,
							spellid, 
							1, 
							time, 
							_UnitHealth(dst_name), 
							src_name 
						})
						break
					end
				end
			end
			
			if (_hook_battleress) then
				for _, func in _ipairs(_hook_battleress_container) do 
					func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname)
				end
			end

		end	
		
		--> actor targets
		local this_dst = this_player.ress_targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.ress_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.ress_targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + 1

		--> actor spells table
		local spell = this_player.ress_spell_tables._ActorTable[spellid]
		if (not spell) then
			spell = this_player.ress_spell_tables:CatchSpell(spellid, true, token)
		end
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, token, extraSpellID, extraSpellName)
	end

	--serach key: ~cc
	function parser:break_cc(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool, auraType)

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
		if (not cc_spell_list[spellid]) then
			--return print("nao ta na list")
		end

		if (_bit_band(src_flags, AFFILIATION_GROUP) == 0) then
			return
		end
		
		if (not spellname) then
			spellname = "Melee"
		end	

		_current_misc_container.need_refresh = true

	------------------------------------------------------------------------------------------------
	--> get actors

		--> main actor
		--> debug - no cache
		--[[
		local this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
		--]]
		--[
		local this_player, mine_owner = misc_cache[src_name]
		if (not this_player) then --> pode ser um desconhecido ou um pet
			this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(src_serial, src_name, src_flags, true)
			if (not mine_owner) then --> se não for um pet, adicionar no cache
				misc_cache[src_name] = this_player
			end
		end
		--]]
		
	------------------------------------------------------------------------------------------------
	--> build containers on the fly
		
		if (not this_player.cc_break) then
			--> constrói aqui a table dele
			this_player.cc_break = _details:GetOrderNumber(src_name)
			this_player.cc_break_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			this_player.cc_break_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
			this_player.cc_break_oque = {}
			
			if (not this_player.shadow.cc_break) then
				this_player.shadow.cc_break = _details:GetOrderNumber(src_name)
				this_player.shadow.cc_break_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				this_player.shadow.cc_break_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
				this_player.shadow.cc_break_oque = {}
			end

			this_player.cc_break_targets.shadow = this_player.shadow.cc_break_targets
			this_player.cc_break_spell_tables.shadow = this_player.shadow.cc_break_spell_tables
		end
		
	------------------------------------------------------------------------------------------------
	--> add amount

		--> update last event
		this_player.last_event = _timestamp
		--shadow.last_event = _timestamp
		
		--> combat cc break total
		_current_total[4].cc_break = _current_total[4].cc_break + 1

		if (this_player.group) then
			_current_combat.totals_group[4].cc_break = _current_combat.totals_group[4].cc_break+1
		end	
		
		--> add amount
		this_player.cc_break = this_player.cc_break + 1
		
		--> broke what
		if (not this_player.cc_break_oque[spellid]) then
			this_player.cc_break_oque[spellid] = 1
		else
			this_player.cc_break_oque[spellid] = this_player.cc_break_oque[spellid] + 1
		end
		
		--> actor targets
		local this_dst = this_player.cc_break_targets._NameIndexTable[dst_name]
		if (not this_dst) then
			this_dst = this_player.cc_break_targets:CatchCombatant(dst_serial, dst_name, dst_flags, true)
		else
			this_dst = this_player.cc_break_targets._ActorTable[this_dst]
		end
		this_dst.total = this_dst.total + 1

		--> actor spells table
		local spell = this_player.cc_break_spell_tables._ActorTable[extraSpellID]
		if (not spell) then
			spell = this_player.cc_break_spell_tables:CatchSpell(extraSpellID, true, token)
		end
		return spell:Add(dst_serial, dst_name, dst_flags, src_name, token, spellid, spellname)
	end

	--serach key: ~dead ~death ~death
	function parser:dead(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags)

	--> not yet well cleaned, need more improvements

	------------------------------------------------------------------------------------------------
	--> early checks and fixes
	
		if (not dst_name) then
			return
		end

	------------------------------------------------------------------------------------------------
	--> build dead
		
		
		if (_in_combat and dst_flags and _bit_band(dst_flags, 0x00000008) ~= 0) then -- and _in_combat --byte 1 = 8(AFFILIATION_OUTSIDER)
			--> outsider death while in combat
			
			--> frags
			
				if (_details.only_pvp_frags and(_bit_band(dst_flags, 0x00000400) == 0 or(_bit_band(dst_flags, 0x00000040) == 0 and _bit_band(dst_flags, 0x00000020) == 0))) then --byte 2 = 4(HOSTILE) byte 3 = 4(OBJECT_TYPE_PLAYER)
					return
				end
			
				if (not _current_combat.frags[dst_name]) then
					_current_combat.frags[dst_name] = 1
				else
					_current_combat.frags[dst_name] = _current_combat.frags[dst_name] + 1
				end
				
				_current_combat.frags_need_refresh = true
				
			--> detect dungeon boss
				--if (_details.zone_type == "party") then
				--	local npcID = tonumber(dst_serial:sub(9, 12), 16)
				--	local boss_ids = _details:GetBossIds(_details.zone_id)
					
				--	if (boss_ids) then
				--		if (_details.zone_id[npcID]) then
							
				--		end
				--	end
				--end

		--> player death
		elseif (not _UnitIsFeignDeath(dst_name)) then
			if (
				--> player in your group
				_bit_band(dst_flags, AFFILIATION_GROUP) ~= 0 and 
				--> must be a player
				_bit_band(dst_flags, OBJECT_TYPE_PLAYER) ~= 0 and 
				--> must be in combat
				_in_combat
			) then
			
				--> true dead was a attempt to get the last hit because parser sometimes send the dead token before send the hit wich really killed the actor
				--> but unfortunately seems parser not send at all any damage after actor dead
				--_details:ScheduleTimer("TrueDead", 1, {time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags}) 
				
				_current_misc_container.need_refresh = true
				
				--> combat totals
				_current_total[4].dead = _current_total[4].dead + 1
				_current_gtotal[4].dead = _current_gtotal[4].dead + 1
				
				--> main actor no container de misc que irá armazenar a death
				local this_player, mine_owner = misc_cache[dst_name]
				if (not this_player) then --> pode ser um desconhecido ou um pet
					this_player, mine_owner, src_name = _current_misc_container:CatchCombatant(dst_serial, dst_name, dst_flags, true)
					if (not mine_owner) then --> se não for um pet, adicionar no cache
						misc_cache[dst_name] = this_player
					end
				end
				
				--> prepare a estrutura da death pegando a table de damage e a table de heal
				--> objeto da death
				local this_death = {}
				
				--> add events
				local t = last_events_cache[dst_name]
				if (not t) then
					t = _current_combat:CreateLastEventsTable(dst_name)
				end
				
				--lesses index = older / higher index = newer
				
				local last_index = t.n --or 'next index'
				if (last_index < 17 and not t[last_index][4]) then
					for i = 1, last_index-1 do
						if (t[i][4] and t[i][4]+16 > time) then
							_table_insert(this_death, t[i])
						end
					end
				else
					for i = last_index, 16 do --next index to 16
						if (t[i][4] and t[i][4]+16 > time) then
							_table_insert(this_death, t[i])
						end
					end
					for i = 1, last_index-1 do --1 to latest index
						if (t[i][4] and t[i][4]+16 > time) then
							_table_insert(this_death, t[i])
						end
					end
				end

				if (_hook_deaths) then
					--> send event to registred functions
					local death_at = _timestamp - _current_combat.start_time
					local max_health = _UnitHealthMax(dst_name)

					for _, func in _ipairs(_hook_deaths_container) do 
						local new_death_table = table_deepcopy(this_death)
						func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, new_death_table, this_player.last_cooldown, death_at, max_health)
					end
				end
				
				if (_details.deadlog_limit and #this_death > _details.deadlog_limit) then
					while(#this_death > _details.deadlog_limit) do
						_table_remove(this_death, 1)
					end
				end
				
				if (this_player.last_cooldown) then
					local t = {}
					t[1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t[2] = this_player.last_cooldown[2] --> spellid || false if this is a battle ress line
					t[3] = 1 --> amount of damage or healing
					t[4] = this_player.last_cooldown[1] --> parser time
					t[5] = 0 --> current unit heal
					t[6] = dst_name --> source name
					this_death[#this_death+1] = t
				else
					local t = {}
					t[1] = 3 --> true if this is a damage || false for healing || 1 for cooldown usage || 2 for last cooldown
					t[2] = 0 --> spellid || false if this is a battle ress line
					t[3] = 0 --> amount of damage or healing
					t[4] = 0 --> parser time
					t[5] = 0 --> current unit heal
					t[6] = dst_name --> source name
					this_death[#this_death+1] = t
				end
				
				local elapsed = _timestamp - _current_combat.start_time
				local minutes, seconds = _math_floor(elapsed/60), _math_floor(elapsed%60)
				
				local t = {this_death, time, this_player.name, this_player.class, _UnitHealthMax(dst_name), minutes.."m "..seconds.."s", ["dead"] = true,["last_cooldown"] = this_player.last_cooldown,["dead_at"] = elapsed}
				
				_table_insert(_current_combat.last_events_tables, #_current_combat.last_events_tables+1, t)

				--> reseta a pool
				last_events_cache[dst_name] = nil
				--damage.last_events_table =  _details:CreateActorLastEventTable()
				--heal.last_events_table =  _details:CreateActorLastEventTable()

			end
		end
	end

	local sort_dead = function(table1, table2)
			if (not table1) then 
				--print(1)
				return false 
				
			elseif (not table2) then 
				--print(2)
				return false
				
			elseif (table1[4] == table2[4]) then --> os 2 tem o mesmo time
				if (type(table1[1]) == "boolean" and table1[1] and type(table2[1]) == "boolean" and table2) then --> ambos sao damage
					--print(3)
					return table1[5] > table2[5] --> joga pra cima quem tem mais vida
				elseif (type(table1[1]) == "boolean" and not table1[1] and type(table2[1]) == "boolean" and not table2) then --> ambos sao heal
					--print(4)
					return table1[5] < table2[5] --> joga pra cima quem tem menos vida
				else
					if (type(table1[1]) == "boolean" and table1 and type(table2[1]) == "boolean" and table2) then --> primeiro é damage e segundo é heal
						--print(5)
						return true --> passa o damage pra frente
					elseif (type(table2[1]) == "boolean" and table2 and type(table1[1]) == "boolean" and table1) then --> primeiro é heal e o segundo é damage
						--print(6)
						return false --> passa o heal pra frente
					else
						--print(7)
						return table1[5] < table2[5] --> passa quem tem menos vida
					end
				end
			else
				--print(8)
				return table1[4] < table2[4]
			end
		end
	
	local function sort_error(error)
		return error
	end
	
	local death_table
	function do_death_sort()
		_table_sort(death_table, sort_dead)
	end
	
	function parser:safe_sort_dead(t)
		death_table = t
		local status, error = xpcall(do_death_sort, sort_error)
		if (not status) then
			--_details:Msg("(debug) xpcall return false, sort got error.")
			_table_sort(t, _details.Sort4Reverse)
		end
	end
	
	function parser:environment(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, env_type, amount, overkill, school, resisted, blocked, absorbed)
		local spelid
	
		if (env_type == "Falling") then
			src_name = ENVIRONMENTAL_FALLING_NAME
			spelid = 3
		elseif (env_type == "Drowning") then
			src_name = ENVIRONMENTAL_DROWNING_NAME
			spelid = 4
		elseif (env_type == "Fatigue") then
			src_name = ENVIRONMENTAL_FATIGUE_NAME
			spelid = 5
		elseif (env_type == "Fire") then
			src_name = ENVIRONMENTAL_FIRE_NAME
			spelid = 6
		elseif (env_type == "Lava") then
			src_name = ENVIRONMENTAL_LAVA_NAME
			spelid = 7
		elseif (env_type == "Slime") then
			src_name = ENVIRONMENTAL_SLIME_NAME
			spelid = 8
		end
	
		return parser:spell_dmg(token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, spelid or 1, env_type, 00000003, amount, overkill, school, resisted, blocked, absorbed) --> localize-me
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	local token_list = {
		-- neutral
		["SPELL_SUMMON"] = parser.summon,
		--["SPELL_CAST_FAILED"] = parser.spell_fail
	}

	--serach key: ~capture

	_details.capture_types = {"damage", "heal", "energy", "miscdata", "aura", "spellcast"}

	function _details:CaptureIsAllEnabled()
		for _, _thisType in _ipairs(_details.capture_types) do 
			if (not _details.capture_real[_thisType]) then
				return false
			end
		end
		return true
	end
	
	function _details:CaptureIsEnabled(capture)
		if (_details.capture_real[capture]) then
			return true
		end
		return false
	end
	
	function _details:CaptureRefresh()
		for _, _thisType in _ipairs(_details.capture_types) do 
			if (_details.capture_current[_thisType]) then
				_details:CaptureEnable(_thisType)
			else
				_details:CaptureDisable(_thisType)
			end
		end
	end
	
	function _details:CaptureGet(capture_type)
		return _details.capture_real[capture_type]
	end

	function _details:CaptureSet(on_off, capture_type, real, time)

		if (real) then
			--> hard switch
			_details.capture_real[capture_type] = on_off
			_details.capture_current[capture_type] = on_off
		else
			--> soft switch
			_details.capture_current[capture_type] = on_off
			if (time) then
				_details:ScheduleTimer("CaptureTimeout", time, capture_type)
			end
		end
		
		_details:CaptureRefresh()
	end

	function _details:CaptureTimeout(capture_type)
		_details.capture_current[capture_type] = _details.capture_real[capture_type]
		_details:CaptureRefresh()
	end

	function _details:CaptureDisable(capture_type)

		capture_type = string.lower(capture_type)
		
		if (capture_type == "damage") then
			token_list["SPELL_PERIODIC_DAMAGE"] = nil
			token_list["SPELL_EXTRA_ATTACKS"] = nil
			token_list["SPELL_DAMAGE"] = nil
			token_list["SWING_DAMAGE"] = nil
			token_list["RANGE_DAMAGE"] = nil
			token_list["DAMAGE_SHIELD"] = nil
			token_list["DAMAGE_SPLIT"] = nil
			token_list["RANGE_MISSED"] = nil
			token_list["SWING_MISSED"] = nil
			token_list["SPELL_MISSED"] = nil
			token_list["ENVIRONMENTAL_DAMAGE"] = nil
		
		elseif (capture_type == "heal") then
			token_list["SPELL_HEAL"] = nil
			token_list["SPELL_PERIODIC_HEAL"] = nil
			_recording_healing = false
		
		elseif (capture_type == "aura") then
			token_list["SPELL_AURA_APPLIED"] = parser.buff
			token_list["SPELL_AURA_REMOVED"] = parser.unbuff
			token_list["SPELL_AURA_REFRESH"] = parser.buff_refresh
			_recording_buffs_and_debuffs = false
		
		elseif (capture_type == "energy") then
			token_list["SPELL_ENERGIZE"] = nil
			token_list["SPELL_PERIODIC_ENERGIZE"] = nil
		
		elseif (capture_type == "spellcast") then
			token_list["SPELL_CAST_SUCCESS"] = nil
		
		elseif (capture_type == "miscdata") then
			-- dispell
			token_list["SPELL_DISPEL"] = nil
			token_list["SPELL_STOLEN"] = nil
			-- cc broke
			token_list["SPELL_AURA_BROKEN"] = nil
			token_list["SPELL_AURA_BROKEN_SPELL"] = nil
			-- ress
			token_list["SPELL_RESURRECT"] = nil
			-- interrupt
			token_list["SPELL_INTERRUPT"] = nil
			-- dead
			token_list["UNIT_DIED"] = nil
			token_list["UNIT_DESTROYED"] = nil
		
		end
	end

	--SPELL_PERIODIC_MISSED --> need research
	--DAMAGE_SHIELD_MISSED --> need research
	--SPELL_EXTRA_ATTACKS --> need research
	--SPELL_DRAIN --> need research
	--SPELL_LEECH --> need research
	--SPELL_PERIODIC_DRAIN --> need research
	--SPELL_PERIODIC_LEECH --> need research
	--SPELL_DISPEL_FAILED --> need research
	
	function _details:CaptureEnable(capture_type)

		capture_type = string.lower(capture_type)
		
		if (capture_type == "damage") then
			token_list["SPELL_PERIODIC_DAMAGE"] = parser.spell_dmg
			token_list["SPELL_EXTRA_ATTACKS"] = parser.spell_dmg
			token_list["SPELL_DAMAGE"] = parser.spell_dmg
			token_list["SWING_DAMAGE"] = parser.swing
			token_list["RANGE_DAMAGE"] = parser.range
			token_list["DAMAGE_SHIELD"] = parser.spell_dmg
			token_list["DAMAGE_SPLIT"] = parser.spell_dmg
			token_list["RANGE_MISSED"] = parser.rangemissed
			token_list["SWING_MISSED"] = parser.swingmissed
			token_list["SPELL_MISSED"] = parser.missed
			token_list["SPELL_PERIODIC_MISSED"] = parser.missed
			token_list["DAMAGE_SHIELD_MISSED"] = parser.missed
			token_list["ENVIRONMENTAL_DAMAGE"] = parser.environment

		elseif (capture_type == "heal") then
			token_list["SPELL_HEAL"] = parser.heal
			token_list["SPELL_PERIODIC_HEAL"] = parser.heal
			_recording_healing = true

		elseif (capture_type == "aura") then
			token_list["SPELL_AURA_APPLIED"] = parser.buff
			token_list["SPELL_AURA_REMOVED"] = parser.unbuff
			token_list["SPELL_AURA_REFRESH"] = parser.buff_refresh
			_recording_buffs_and_debuffs = true

		elseif (capture_type == "energy") then
			token_list["SPELL_ENERGIZE"] = parser.energize
			token_list["SPELL_PERIODIC_ENERGIZE"] = parser.energize

		elseif (capture_type == "spellcast") then
			token_list["SPELL_CAST_SUCCESS"] = parser.spellcast

		elseif (capture_type == "miscdata") then
			-- dispell
			token_list["SPELL_DISPEL"] = parser.dispell
			token_list["SPELL_STOLEN"] = parser.dispell
			-- cc broke
			token_list["SPELL_AURA_BROKEN"] = parser.break_cc
			token_list["SPELL_AURA_BROKEN_SPELL"] = parser.break_cc
			-- ress
			token_list["SPELL_RESURRECT"] = parser.ress
			-- interrupt
			token_list["SPELL_INTERRUPT"] = parser.interrupt
			-- dead
			token_list["UNIT_DIED"] = parser.dead
			token_list["UNIT_DESTROYED"] = parser.dead
			
		end
	end

	-- PARSER
	--serach key: ~parser ~event ~start ~start
	function _details:GetZoneType()
		return _details.zone_type
	end
	function _details.parser_functions:ZONE_CHANGED_NEW_AREA(...)
		local zoneName, zoneType, _, _, _, _ = _GetInstanceInfo()
		if (_details.last_zone_type ~= zoneType) then
			_details:SendEvent("ZONE_TYPE_CHANGED", nil, zoneType)
			_details.last_zone_type = zoneType
		end
		local zoneMapID
		if(zoneType == "raid") then
			if (zoneName == "Ulduar") then zoneMapID = 530
			elseif (zoneName == "Naxxramas") then zoneMapID = 536
			elseif (zoneName == "Trial of the Crusader") then zoneMapID = 544
			elseif (zoneName == "The Eye of Eternity") then zoneMapID = 528
			elseif (zoneName == "Icecrown Citadel") then zoneMapID = 605
			elseif (zoneName == "Onyxia's Lair") then zoneMapID = 718
			elseif (zoneName == "The Obsidian Sanctum") then zoneMapID = 531
			elseif (zoneName == "Vault of Archavon") then zoneMapID = 533
			elseif (zoneName == "The Ruby Sanctum") then zoneMapID = 610
			else zoneMapID = 4
			end
		else zoneMapID = 4
		end
		_details.zone_type = zoneType
		_details.zone_id = zoneMapID
		_details.zone_name = zoneName
		
		if (_details.debug) then
			_details:Msg("(debug) zone change:", _details.zone_name, "is a", _details.zone_type, "zone.")
		end
		
		if (_details.is_in_arena and zoneType ~= "arena") then
			_details:LeftArena()
		end
		
		if (zoneType == "pvp") then
			if (not _current_combat.pvp) then
			
				if (_details.debug) then
					_details:Msg("(debug) battleground found, starting new combat table.")
				end
				
				_details:EnterCombat()
				--> sinaliza que esse combat é pvp
				_current_combat.pvp = true
				_current_combat.is_pvp = {name = zoneName, zone = ZoneName, mapid = ZoneMapID}
				_details.listener:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
			end
		
		elseif (zoneType == "arena") then
		
			if (_details.debug) then
				_details:Msg("(debug) zone type is arena.")
			end
		
			_details.is_in_arena = true
			_details:EnteredInArena()
			
		else
			if (zoneType == "raid" or zoneType == "party") then
				_details:CheckForAutoErase(zoneMapID)
			end
			
			if (_details:IsInInstance()) then
				_details.last_instance = zoneMapID
			end
			
			if (_current_combat.pvp) then 
				_current_combat.pvp = false
			end
		end
		
		_details:SchedulePetUpdate(7)
		_details:CheckForPerformanceProfile()
	end
	
	function _details.parser_functions:PLAYER_ENTERING_WORLD(...)
		return _details.parser_functions:ZONE_CHANGED_NEW_AREA(...)
	end
	
	-- ~encounter
	function _details:ENCOUNTER_START(id, name, diff, size)
	
		_details.latest_ENCOUNTER_END = _details.latest_ENCOUNTER_END or 0
		if (_details.latest_ENCOUNTER_END + 10 > _details._time) then
			return
		end
	
		local encounterID, encounterName, difficultyID, raidSize = id, name, diff, size
		--_select(1, ...)
	
		if (_in_combat and not _details.table_current.is_boss) then
			--print("encounter start while in combat... finishing the combat...")
			_details:EndCombat()
			_details:Msg("encounter against|cFFFFFF00", encounterName, "|rbegan, GL HF!")
		else
			_details:Msg("encounter against|cFFFFC000", encounterName, "|rbegan, GL HF!")
		end
		
		local dbm_mod, dbm_time = _details.encounter_table.DBM_Mod, _details.encounter_table.DBM_ModTime
		_table_wipe(_details.encounter_table)
		
		local zoneName, zoneType, _, _, _, _ = _GetInstanceInfo()
		local zoneMapID
		if(zoneType == "raid") then
			if (zoneName == "Ulduar") then zoneMapID = 530
			elseif (zoneName == "Naxxramas") then zoneMapID = 536
			elseif (zoneName == "Trial of the Crusader") then zoneMapID = 544
			elseif (zoneName == "The Eye of Eternity") then zoneMapID = 528
			elseif (zoneName == "Icecrown Citadel") then zoneMapID = 605
			elseif (zoneName == "Onyxia's Lair") then zoneMapID = 718
			elseif (zoneName == "The Obsidian Sanctum") then zoneMapID = 531
			elseif (zoneName == "Vault of Archavon") then zoneMapID = 533
			elseif (zoneName == "The Ruby Sanctum") then zoneMapID = 610
			else zoneMapID = 4
			end
		else zoneMapID = 4
		end
		--print(encounterID, encounterName, difficultyID, raidSize)
		
		_details.encounter_table.phase = 1
		
		_details.encounter_table["start"] = time()
		_details.encounter_table["end"] = nil
		
		_details.encounter_table.id = encounterID
		_details.encounter_table.name = encounterName
		_details.encounter_table.diff = difficultyID
		_details.encounter_table.size = raidSize
		_details.encounter_table.zone = zoneName
		_details.encounter_table.mapid = zoneMapID
		
		if (dbm_mod and dbm_time == time()) then
			_details.encounter_table.DBM_Mod = dbm_mod
		end
		
		local encounter_start_table = _details:GetEncounterStartInfo(zoneMapID, encounterID)
		if (encounter_start_table) then
			if (encounter_start_table.delay) then
				if (type(encounter_start_table.delay) == "function") then
					local delay = encounter_start_table.delay()
					if (delay) then
						_details.encounter_table["start"] = time() + delay
					end
				else
					_details.encounter_table["start"] = time() + encounter_start_table.delay
				end
			end
			if (encounter_start_table.func) then
				encounter_start_table:func()
			end
		end

		local encounter_table, boss_index = _details:GetBossEncounterDetailsFromEncounterId(zoneMapID, encounterID)
		if (encounter_table) then
			_details.encounter_table.index = boss_index
		end
		
	end
	
	function _details:ENCOUNTER_END(id, encounterName, wipe)
		
		--local encounterID, encounterName, difficultyID, raidSize, endStatus = _select(1, ...)
	
		_details:Msg("encounter against|cFFFFC000", encounterName, "|rended.")
	
		if (not _details.encounter_table.start) then
			return
		end
		
		_details.latest_ENCOUNTER_END = _details.latest_ENCOUNTER_END or 0
		if (_details.latest_ENCOUNTER_END + 15 > _details._time) then
			return
		end
		_details.latest_ENCOUNTER_END = _details._time
		
		_details.encounter_table["end"] = time() - 0.4
		
		
		if (_in_combat) then
			if (wipe == 1) then
				_details.encounter_table.kill = false
				_details:EndCombat(false, true) --wiped
			else
				_details.encounter_table.kill = true
				_details:EndCombat(true, true) --killed
			end
		else
			if (_details.table_current.end_time and _details.table_current.end_time + 2 >= _details.encounter_table["end"]) then
				--_details.table_current.start_time = _details.encounter_table["start"]
				_details.table_current.end_time = _details.encounter_table["end"]
				_details:UpdateGumpMain(-1, true)
			end
		end

		_table_wipe(_details.encounter_table)
	end
	
	function _details.parser_functions:CHAT_MSG_BG_SYSTEM_NEUTRAL(...)
		local frase = _select(1, ...)
		--> reset combat timer
		if ((frase:find("The battle") and frase:find("has begun!") ) and _current_combat.pvp) then
			local time_of_combat = _timestamp - _current_combat.start_time
			_details.table_overall.start_time = _details.table_overall.start_time + time_of_combat
			_current_combat.start_time = _timestamp
			_details.listener:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
		end
	end
	
	function _details.parser_functions:UNIT_PET(...)
		_details:SchedulePetUpdate(1)
	end

	function _details.parser_functions:PLAYER_REGEN_DISABLED(...)
		if (_details.EncounterInformation[_details.zone_id]) then 
			_details:ScheduleTimer("ReadBossFrames", 1)
			_details:ScheduleTimer("ReadBossFrames", 30)
		end
		
		if (not _details:CaptureGet("damage")) then
			_details:EnterCombat()
		end

		--> essa parte do solo mode ainda sera usada?
		if (_details.solo and _details.PluginCount.SOLO > 0) then --> solo mode
			local this_instance = _details.table_instances[_details.solo]
			this_instance.atualizando = true
		end
		
		for index, instance in ipairs(_details.table_instances) do 
			if (instance.active) then
				instance:SetCombatAlpha(nil, nil, true)
			end
		end
	end

	function _details.parser_functions:PLAYER_REGEN_ENABLED(...)
	
		--> playing alone, just finish the combat right now
		if (GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0) then	
			_details.table_current.playing_solo = true
			_details:EndCombat()
		end
		
		--> aqui, tentactive de do o timer da window do Solo funcionar corretamente:
		if (_details.solo and _details.PluginCount.SOLO > 0) then
			if (_details.SoloTables.Plugins[_details.SoloTables.Mode].Stop) then
				_details.SoloTables.Plugins[_details.SoloTables.Mode].Stop()
			end
		end
		
		if (_details.schedule_flag_boss_components) then
			_details.schedule_flag_boss_components = false
			_details:FlagActorsOnBossFight()
		end

		if (_details.schedule_remove_overall) then
			if (_details.debug) then
				_details:Msg("(debug) found schedule overall data deletion.")
			end
			_details.schedule_remove_overall = false
			_details.table_history:reset_overall()
		end
		
		if (_details.schedule_add_to_overall) then
			if (_details.debug) then
				_details:Msg("(debug) found schedule overall data addition.")
			end
			_details.schedule_add_to_overall = false

			_details.history:adicionar_overall(_details.table_current)
		end
		
		for index, instance in ipairs(_details.table_instances) do 
			if (instance.active) then
				instance:SetCombatAlpha(nil, nil, true)
			end
		end

	end

	function _details.parser_functions:ROLE_CHANGED_INFORM(...)
		if (_details.last_assigned_role ~= _UnitGroupRolesAssigned("player")) then
			_details:CheckSwitchOnLogon(true)
			_details.last_assigned_role = _UnitGroupRolesAssigned("player")
		end
	end
	
	function _details.parser_functions:PLAYER_ROLES_ASSIGNED(...)
		if (_details.last_assigned_role ~= _UnitGroupRolesAssigned("player")) then
			_details:CheckSwitchOnLogon(true)
			_details.last_assigned_role = _UnitGroupRolesAssigned("player")
		end
	end
	
	function _details:InGroup()
		return _details.in_group
	end
	function _details.parser_functions:GROUP_ROSTER_UPDATE(...)
		if (not _details.in_group) then
			_details.in_group =(GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
			if (_details.in_group) then
				--> entrou num group
				_details:InitializeCollectGarbage(true)
				_details:WipePets()
				_details:SchedulePetUpdate(1)
				_details:InstanceCall(_details.SetCombatAlpha, nil, nil, true)
				_details:CheckSwitchOnLogon()
				_details:CheckVersion()
				_details:SendEvent("GROUP_ONENTER")
			end
		else
			_details.in_group =(GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0)
			if (not _details.in_group) then
				--> saiu do group
				_details:InitializeCollectGarbage(true)
				_details:WipePets()
				_details:SchedulePetUpdate(1)
				_table_wipe(_details.details_users)
				_details:InstanceCall(_details.SetCombatAlpha, nil, nil, true)
				_details:CheckSwitchOnLogon()
				_details:SendEvent("GROUP_ONLEAVE")
			else
				_details:SchedulePetUpdate(2)
			end
		end
		
		_details:SchedulePetUpdate(6)
	end

	function _details.parser_functions:START_TIMER(...)
	
		if (_details.debug) then
			_details:Msg("(debug) found a timer.")
		end
	
		if (C_Scenario.IsChallengeMode() and _details.overall_clear_newchallenge) then
			_details.history:reset_overall()
			if (_details.debug) then
				_details:Msg("(debug) timer is a challenge mode start.")
			end
			
		elseif (_details.is_in_arena) then
			_details:StartArenaSegment(...)
			if (_details.debug) then
				_details:Msg("(debug) timer is a arena countdown.")
			end
		end
	end

	-- ~load
	function _details.parser_functions:ADDON_LOADED(...)
	
		local addon_name = _select(1, ...)
		
		if (addon_name == "Details") then
		
			--> cooltip
			if (not _G.GameCooltip) then
				_details.popup = DetailsCreateCoolTip()
			else
				_details.popup = _G.GameCooltip
			end
		
			--> check group
			_details.in_group = GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0
		
			--> write into details object all basic keys and default profile
			_details:ApplyBasicKeys()
			--> check if is first run, update keys for character and global data
			_details:LoadGlobalAndCharacterData()
			
			--> details updated and not reopened the game client
			if (_details.FILEBROKEN) then
				return
			end
			
			--> load all the saved combats
			_details:LoadCombatTables()
			--> load the profiles
			_details:LoadConfig()

			_details:UpdateParserGears()
			_details:Start()
		end	
	end
	
	function _details.parser_functions:PET_BATTLE_OPENING_START(...)
		_details.pet_battle = true
		for index, instance in _ipairs(_details.table_instances) do
			if (instance.active) then
				instance:SetWindowAlphaForCombat(true, true)
			end
		end
	end
	
	function _details.parser_functions:PET_BATTLE_CLOSE(...)
		_details.pet_battle = false
		for index, instance in _ipairs(_details.table_instances) do
			if (instance.active) then
				instance:SetWindowAlphaForCombat()
			end
		end
	end
	
	function _details.parser_functions:UNIT_NAME_UPDATE(...)
		_details:SchedulePetUpdate(5)
	end
	
	local parser_functions = _details.parser_functions
	
	function _details:OnEvent(evento, ...)
		local func = parser_functions[evento]
		if (func) then
			return func(nil, ...)
		end
	end

	_details.listener:SetScript("OnEvent", _details.OnEvent)
	
	--> logout function ~save
		function _details:PLAYER_LOGOUT(...)
		
			--> close info window
				if (_details.CloseWindowInfo) then
					_details:CloseWindowInfo()
				end

			--> do not save window pos
				for id, instance in _details:ListInstances() do
					if (instance.baseframe) then
						instance.baseframe:SetUserPlaced(false)
					end
				end
				
			--> leave combat start save tables
				if (_details.in_combat and _details.table_current) then 
					_details:EndCombat()
					_details.can_panic_mode = true
				end
				
				if (_details.CheckSwitchOnLogon and _details.table_instances[1] and getmetatable(_details.table_instances[1])) then
					_details:CheckSwitchOnLogon()
				end
				
				if (_details.wipe_full_config) then
					_details_global = nil
					_details_database = nil
					return
				end
			
			--> save the config
				_details:SaveConfig()
				_details:SaveProfile()

			--> save the nicktag cache
				_details_database.nick_tag_cache = table_deepcopy(_details_database.nick_tag_cache)
		end
		
		local saver = CreateFrame("frame", "_details_saver_frame", UIParent)
		saver:RegisterEvent("PLAYER_LOGOUT")
		saver:SetScript("OnEvent", _details.PLAYER_LOGOUT)
		
	--> end

	function _details:OnParserEvent(evento, time, token, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, ...)
		local func = token_list[token]
		
		--print(evento, time, token, src_serial, src_name)
		
		if (func) then
			return func(nil, token, time, src_serial, src_name, src_flags, dst_serial, dst_name, dst_flags, ... )
		else
			return
		end
	end
	_details.parser_frame:SetScript("OnEvent", _details.OnParserEvent)

	function _details:UpdateParser()
		_timestamp = _details._time
	end

	function _details:PrintParserCacheIndexes()
	
		local amount = 0
		for n, nn in pairs(damage_cache) do 
			amount = amount + 1
		end
		print("parser damage_cache", amount)
		
		amount = 0
		for n, nn in pairs(damage_cache_pets) do 
			amount = amount + 1
		end
		print("parser damage_cache_pets", amount)
		
		amount = 0
		for n, nn in pairs(damage_cache_petsOwners) do 
			amount = amount + 1
		end
		print("parser damage_cache_petsOwners", amount)
		
		amount = 0
		for n, nn in pairs(healing_cache) do 
			amount = amount + 1
		end
		print("parser healing_cache", amount)
		
		amount = 0
		for n, nn in pairs(energy_cache) do 
			amount = amount + 1
		end
		print("parser energy_cache", amount)

		amount = 0
		for n, nn in pairs(misc_cache) do 
			amount = amount + 1
		end
		print("parser misc_cache", amount)
		
		print("group damage", #_details.cache_damage_group)
		print("group damage", #_details.cache_healing_group)
	end
	
	function _details:GetActorsOnDamageCache()
		return _details.cache_damage_group
	end
	function _details:GetActorsOnHealingCache()
		return _details.cache_healing_group
	end
	
	function _details:ClearParserCache()
		
		--> clear cache | not sure if replacing the old table is the best approach
	
		_table_wipe(damage_cache)
		_table_wipe(damage_cache_pets)
		_table_wipe(damage_cache_petsOwners)
		_table_wipe(healing_cache)
		_table_wipe(energy_cache)
		_table_wipe(misc_cache)
	
		damage_cache = setmetatable({}, _details.weaktable)
		damage_cache_pets = setmetatable({}, _details.weaktable)
		damage_cache_petsOwners = setmetatable({}, _details.weaktable)
		
		healing_cache = setmetatable({}, _details.weaktable)
		
		energy_cache = setmetatable({}, _details.weaktable)
		
		misc_cache = setmetatable({}, _details.weaktable)
		
	end

	function _details:UptadeRaidMembersCache()
	
		_table_wipe(raid_members_cache)
		_table_wipe(tanks_members_cache)
		
		local roster = _details.table_current.raid_roster
		
		if (GetNumRaidMembers() > 0) then
			for i = 1, GetNumRaidMembers() do 
				local name = _GetUnitName("raid"..i, true)
				
				raid_members_cache[_UnitGUID("raid"..i)] = true
				roster[name] = true
				
				local role = _UnitGroupRolesAssigned(name)
				if (role == "TANK") then
					tanks_members_cache[_UnitGUID("raid"..i)] = true
				end
			end
			
		elseif (GetNumPartyMembers() > 0) then
			--party
			for i = 1, GetNumPartyMembers() do 
				local name = _GetUnitName("party"..i, true)
				
				raid_members_cache[_UnitGUID("party"..i)] = true
				roster[name] = true
				
				local role = _UnitGroupRolesAssigned(name)
				if (role == "TANK") then
					tanks_members_cache[_UnitGUID("party"..i)] = true
				end
			end
			
			--player
			local name = GetUnitName("player", true)
			
			raid_members_cache[_UnitGUID("player")] = true
			roster[name] = true
			
			local role = _UnitGroupRolesAssigned(name)
			if (role == "TANK") then
				tanks_members_cache[_UnitGUID("player")] = true
			end
		else
			local name = GetUnitName("player", true)
			
			raid_members_cache[_UnitGUID("player")] = true
			roster[name] = true
			
			local role = _UnitGroupRolesAssigned(name)
			if (role == "TANK") then
				tanks_members_cache[_UnitGUID("player")] = true
			end
		end
	end

	function _details:IsATank(playerguid)
		return tanks_members_cache[playerguid]
	end
	
	function _details:IsInCache(playerguid)
		return raid_members_cache[playerguid]
	end
	function _details:GetParserPlayerCache()
		return raid_members_cache
	end
	
	--serach key: ~cache
	function _details:UpdateParserGears()

		--> refresh combat tables
		_current_combat = _details.table_current
		
		--> last events pointer
		last_events_cache = _current_combat.player_last_events

		--> refresh total containers
		_current_total = _current_combat.totals
		_current_gtotal = _current_combat.totals_group
		
		--> refresh actors containers
		_current_damage_container = _current_combat[1]

		_current_heal_container = _current_combat[2]
		_current_energy_container = _current_combat[3]
		_current_misc_container = _current_combat[4]
		
		--> refresh data capture options
		_recording_self_buffs = _details.RecordPlayerSelfBuffs
		--_recording_healing = _details.RecordHealingDone
		--_recording_took_damage = _details.RecordRealTimeTookDamage
		_recording_ability_with_buffs = _details.RecordPlayerAbilityWithBuffs
		_in_combat = _details.in_combat
		
		if (_details.hooks["HOOK_COOLDOWN"].enabled) then
			_hook_cooldowns = true
		else
			_hook_cooldowns = false
		end
		
		if (_details.hooks["HOOK_DEATH"].enabled) then
			_hook_deaths = true
		else
			_hook_deaths = false
		end
		
		if (_details.hooks["HOOK_BATTLERESS"].enabled) then
			_hook_battleress = true
		else
			_hook_battleress = false
		end
		
		if (_details.hooks["HOOK_INTERRUPT"].enabled) then
			_hook_interrupt = true
		else
			_hook_interrupt = false
		end
		
		if (_details.hooks["HOOK_BUFF"].enabled) then --[[REMOVED]]
			_hook_buffs = true
		else
			_hook_buffs = false
		end

		return _details:ClearParserCache()
	end
	
	
	
--serach key: ~api
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> number of combat
	function  _details:GetCombatId()
		return _details.combat_id
	end

	--> if in combat
	function _details:IsInCombat()
		return _in_combat
	end

	--> get combat
	function _details:GetCombat(_combat)
		if (not _combat) then
			return _current_combat
		elseif (_type(_combat) == "number") then
			if (_combat == -1) then --> overall
				return _overall_combat
			elseif (_combat == 0) then --> current
				return _current_combat
			else
				return _details.table_history.tables[_combat]
			end
		elseif (_type(_combat) == "string") then
			if (_combat == "overall") then
				return _overall_combat
			elseif (_combat == "current") then
				return _current_combat
			end
		end
		
		return nil
	end

	function _details:GetAllActors(_combat, _actorname)
		return _details:GetActor(_combat, 1, _actorname), _details:GetActor(_combat, 2, _actorname), _details:GetActor(_combat, 3, _actorname), _details:GetActor(_combat, 4, _actorname)
	end
	
	--> get an actor
	function _details:GetActor(_combat, _attribute, _actorname)

		if (not _combat) then
			_combat = "current" --> current combat
		end
		
		if (not _attribute) then
			_attribute = 1 --> damage
		end
		
		if (not _actorname) then
			_actorname = _details.playername
		end
		
		if (_combat == 0 or _combat == "current") then
			local actor = _details.table_current(_attribute, _actorname)
			if (actor) then
				return actor
			else
				return nil --_details:NewError("Current combat doesn't have an actor called ".. _actorname)
			end
			
		elseif (_combat == -1 or _combat == "overall") then
			local actor = _details.table_overall(_attribute, _actorname)
			if (actor) then
				return actor
			else
				return nil --_details:NewError("Combat overall doesn't have an actor called ".. _actorname)
			end
			
		elseif (type(_combat) == "number") then
			local _combatOnHistoryTables = _details.table_history.tables[_combat]
			if (_combatOnHistoryTables) then
				local actor = _combatOnHistoryTables(_attribute, _actorname)
				if (actor) then
					return actor
				else
					return nil --_details:NewError("Combat ".. _combat .." doesn't have an actor called ".. _actorname)
				end
			else
				return nil --_details:NewError("Combat ".._combat.." not found.")
			end
		else
			return nil --_details:NewError("Couldn't find a combat object for passed parameters")
		end
	end
	

