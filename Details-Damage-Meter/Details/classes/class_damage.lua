-- damage object

	local _details = 		_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local gump = 			_details.gump
	local _

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _cstr = string.format --lua local
	local _math_floor = math.floor --lua local
	local _table_sort = table.sort --lua local
	local _table_insert = table.insert --lua local
	local _table_size = table.getn --lua local
	local _setmetatable = setmetatable --lua local
	local _getmetatable = getmetatable --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _rawget= rawget --lua local
	local _math_min = math.min --lua local
	local _math_max = math.max --lua local
	local _bit_band = bit.band --lua local
	local _unpack = unpack --lua local
	local _type = type --lua local
	local GameTooltip = GameTooltip --api local
	local _IsInRaid = IsInRaid --api local
	local _IsInGroup = IsInGroup --api local
	local _GetSpellInfo = _details.getspellinfo --details api

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local dst_of_ability	= 	_details.dst_of_ability
	local container_abilities	= 	_details.container_abilities
	local container_combatants =	_details.container_combatants
	local attribute_damage	=	_details.attribute_damage
	local attribute_misc		=	_details.attribute_misc
	local ability_damage		=	_details.ability_damage
	local container_damage_target =	_details.container_type.CONTAINER_DAMAGETARGET_CLASS
	local container_damage	=	_details.container_type.CONTAINER_DAMAGE_CLASS
	local container_friendlyfire	=	_details.container_type.CONTAINER_FRIENDLYFIRE

	local mode_GROUP = _details.modes.group
	local mode_ALL = _details.modes.all

	local class_type = _details.attributes.damage

	local ToKFunctions = _details.ToKFunctions
	local SelectedToKFunction = ToKFunctions[1]
	
	local UsingCustomLeftText = false
	local UsingCustomRightText = false
	
	local FormatTooltipNumber = ToKFunctions[8]
	local TooltipMaximizedMethod = 1

	local CLASS_ICON_TCOORDS = _G.CLASS_ICON_TCOORDS
	local is_player_class = _details.player_class

	local key_overlay = {1, 1, 1, .1}
	local key_overlay_press = {1, 1, 1, .2}
	local headerColor = "yellow"

	local info = _details.window_info
	local keyName

	local OBJECT_TYPE_PLAYER =	0x00000400
	
	local ntable = {} --temp
	local vtable = {} --temp

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> exported functions

--[[exported]]	function _details:CreateActorLastEventTable()
				local t = { {}, {}, {}, {}, {}, {}, {}, {} }
				t.n = 1
				return t
			end
			
--[[exported]]	function _details:CreateActorAvoidanceTable(no_overall)
				if (no_overall) then
					local t = {["ALL"] = 0,["DODGE"] = 0,["PARRY"] = 0,["HITS"] = 0,["ABSORB"] = 0, --quantas vezes foi dodge, parry, quandos hits tomou, quantos absorbs teve
					["FULL_HIT"] = 0,["FULL_ABSORBED"] = 0,["PARTIAL_ABSORBED"] = 0, --full hit full absorbed and partial absortion
					["FULL_HIT_AMT"] = 0,["PARTIAL_ABSORB_AMT"] = 0,["ABSORB_AMT"] = 0,["FULL_ABSORB_AMT"] = 0} --amounts
					return t
				else
					local t = {overall = {["ALL"] = 0,["DODGE"] = 0,["PARRY"] = 0,["HITS"] = 0,["ABSORB"] = 0, --quantas vezes foi dodge, parry, quandos hits tomou, quantos absorbs teve
					["FULL_HIT"] = 0,["FULL_ABSORBED"] = 0,["PARTIAL_ABSORBED"] = 0, --full hit full absorbed and partial absortion
					["FULL_HIT_AMT"] = 0,["PARTIAL_ABSORB_AMT"] = 0,["ABSORB_AMT"] = 0,["FULL_ABSORB_AMT"] = 0}} --amounts
					return t
				end
			end

--[[exported]]	function _details.SortGroup(container, keyName2)
				keyName = keyName2
				return _table_sort(container, _details.SortKeyGroup)
			end

--[[exported]]	function _details.SortKeyGroup(table1, table2)
				if (table1.group and table2.group) then
					return table1[keyName] > table2[keyName]
				elseif (table1.group and not table2.group) then
					return true
				elseif (not table1.group and table2.group) then
					return false
				else
					return table1[keyName] > table2[keyName]
				end
			end

--[[exported]] 	function _details.SortKeySimple(table1, table2)
				return table1[keyName] > table2[keyName]
			end
			
--[[exported]] 	function _details:ContainerSort(container, amount, keyName2)
				keyName = keyName2
				_table_sort(container,  _details.SortKeySimple)
				
				if (amount) then 
					for i = amount, 1, -1 do --> de trás pra frente
						if (container[i][keyName] < 1) then
							amount = amount-1
						else
							break
						end
					end
					
					return amount
				end
			end

--[[ exported]]	function _details:IsGroupPlayer()
				return self.group
			end
			
--[[ exported]] 	function _details:IsPlayer()
				if (self.flag_original) then
					if (_bit_band(self.flag_original, OBJECT_TYPE_PLAYER) ~= 0) then
						return true
					end
				end
				return false
			end
			
			-- enemies(sort function)
			local sortEnemies = function(t1, t2)
				local a = _bit_band(t1.flag_original, 0x00000060)
				local b = _bit_band(t2.flag_original, 0x00000060)
				
				if (a ~= 0 and b ~= 0) then
					return t1.total > t2.total
				elseif (a ~= 0 and b == 0) then
					return true
				elseif (a == 0 and b ~= 0) then
					return false
				end
				
				return false
			end

--[[exported]] 	function _details:ContainerSortEnemies(container, amount, keyName2)

				keyName = keyName2
				
				_table_sort(container, sortEnemies)
				
				local total = 0
				
				for index, player in _ipairs(container) do
					if (_bit_band(player.flag_original, 0x00000060) ~= 0) then --> é um enemy
						total = total + player[keyName]
					else
						amount = index-1
						break
					end
				end
				
				return amount, total
			end

--[[Exported]] 	function _details:TooltipForCustom(bar)
				GameCooltip:AddLine(Loc["STRING_LEFT_CLICK_SHARE"])
				return true
			end
			
--[[ Void Zone Sort]]
			local void_zone_sort = function(t1, t2)
				if (t1.damage == t2.damage) then
					return t1.name <= t2.name
				else
					return t1.damage > t2.damage
				end
			end


--[[exported]]	function _details.Sort1(table1, table2)
				return table1[1] > table2[1]
			end
			
--[[exported]]	function _details.Sort2(table1, table2)
				return table1[2] > table2[2]
			end
			
--[[exported]]	function _details.Sort3(table1, table2)
				return table1[3] > table2[3]
			end
			
--[[exported]]	function _details.Sort4(table1, table2)
				return table1[4] > table2[4]
			end
			
--[[exported]]	function _details.Sort4Reverse(table1, table2)
				if (not table2) then
					return true
				end
				return table1[4] < table2[4]
			end
			
--[[exported]]	function _details:GetBarColor(actor)
				actor = actor or self
				
				if (actor.owner) then
					return _unpack(_details.class_colors[actor.owner.class])
					
				elseif (actor.monster) then
					return _unpack(_details.class_colors.ENEMY)

				elseif (actor.arena_enemy) then
					return _unpack(_details.class_colors.ARENA_ENEMY)
				
				elseif (actor.arena_ally) then
					return _unpack(_details.class_colors.ARENA_ALLY)
				
				else
					if (not is_player_class[actor.class] and actor.flag_original and _bit_band(actor.flag_original, 0x00000020) ~= 0) then --> neutral
						return _unpack(_details.class_colors.NEUTRAL)
					else
						return _unpack(_details.class_colors[actor.class])
					end
				end
			end
			
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> class constructor

	function attribute_damage:Newtable(serial, name, link)

		local alphabetical = _details:GetOrderNumber(name)
	
		--> constructor
		local _new_damageActor = {
			
			type = class_type,
			
			total = alphabetical,
			total_without_pet = alphabetical,
			custom = 0,
			
			damage_taken = alphabetical,
			damage_from = {},
			
			dps_started = false,
			last_event = 0,
			on_hold = false,
			delay = 0,
			last_value = nil,
			last_dps = 0,

			end_time = nil,
			start_time = 0,
			
			pets = {},
			
			friendlyfire_total = 0,
			friendlyfire = container_combatants:NewContainer(container_friendlyfire),

			targets = container_combatants:NewContainer(container_damage_target),
			spell_tables = container_abilities:NewContainer(container_damage)
		}
		
		_setmetatable(_new_damageActor, attribute_damage)
		
		if (link) then
			--_new_damageActor.last_events_table = _details:CreateActorLastEventTable()
			--_new_damageActor.last_events_table.original = true
			
			_new_damageActor.targets.shadow = link.targets
			_new_damageActor.spell_tables.shadow = link.spell_tables
			_new_damageActor.friendlyfire.shadow = link.friendlyfire
		end
		
		return _new_damageActor
	end
	
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> special cases

	-- dps(calculate dps for actors)
	function attribute_damage:ContainerRefreshDps(container, combat_time)
	
		local total = 0
		
		if (_details.time_type == 2 or not _details:CaptureGet("damage")) then
			for _, actor in _ipairs(container) do
				if (actor.group) then
					actor.last_dps = actor.total / combat_time
				else
					actor.last_dps = actor.total / actor:Time()
				end
				total = total + actor.last_dps
			end
		else
			for _, actor in _ipairs(container) do
				actor.last_dps = actor.total / actor:Time()
				total = total + actor.last_dps
			end
		end
		
		return total
	end	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frags
	
	function _details:ToolTipFrags(instance, frag, this_bar, keydown)

		local name = frag[1]
		local GameCooltip = GameCooltip
		
		--> mantendo a função o mais low level possível
		local damage_container = instance.showing[1]
		
		local frag_actor = damage_container._ActorTable[damage_container._NameIndexTable[ name ]]

		if (frag_actor) then
			
			local damage_taken_table = {}

			local took_damage_from = frag_actor.damage_from
			local total_damage_taken = frag_actor.damage_taken

			for aggressor, _ in _pairs(took_damage_from) do
			
				local damager_actor = damage_container._ActorTable[damage_container._NameIndexTable[ aggressor ]]
				
				if (damager_actor and not damager_actor.owner) then --> checagem por causa do total e do garbage collector que não limpa os names que deram damage
				
					local targets = damager_actor.targets
					
					local specific_target = targets._ActorTable[targets._NameIndexTable[ name ]] --> é ele mesmo
					if (specific_target) then
						damage_taken_table[#damage_taken_table+1] = {aggressor, specific_target.total, damager_actor.class}
					end
				end
			end

			if (#damage_taken_table > 0) then
				
				_table_sort(damage_taken_table, _details.Sort2)
				
				GameCooltip:AddLine(Loc["STRING_DAMAGE_FROM"], nil, nil, headerColor, nil, 12)
				GameCooltip:AddIcon([[Interface\Addons\Details\images\icons]], 1, 1, 14, 14, 0.126953125, 0.1796875, 0, 0.0546875)
			
				local min = 6
				local ismaximized = false
				if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
					min = 99
					ismaximized = true
				end
				
				if (ismaximized) then
					--highlight shift key
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, 1)
				else
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
				end
			
				for i = 1, math.min(min, #damage_taken_table) do 
				
					local t = damage_taken_table[i]
				
					GameCooltip:AddLine(t[1], FormatTooltipNumber(_, t[2]))
					local class = t[3]
					if (not class) then
						class = "UNKNOW"
					end
					
					if (class == "UNKNOW") then
						GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
					else
						GameCooltip:AddIcon(instance.row_info.icon_file, nil, nil, 14, 14, _unpack(_details.class_coords[class]))
					end
					_details:AddTooltipBackgroundStatusbar()
				end
				
				GameCooltip:AddLine("")
				GameCooltip:AddLine(Loc["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack(self.click_to_report_color))
				GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
				GameCooltip:ShowCooltip()
			
			else
				GameCooltip:AddLine(Loc["STRING_NO_DATA"], nil, 1, "white")
				GameCooltip:AddIcon(instance.row_info.icon_file, nil, nil, 14, 14, _unpack(_details.class_coords["UNKNOW"]))
				GameCooltip:ShowCooltip()
			end
			
		else
			GameCooltip:AddLine(Loc["STRING_NO_DATA"], nil, 1, "white")
			GameCooltip:AddIcon(instance.row_info.icon_file, nil, nil, 14, 14, _unpack(_details.class_coords["UNKNOW"]))
			GameCooltip:ShowCooltip()
		end
		
	end

	local function RefreshBarFrags(table, bar, instance)
		attribute_damage:ActualizeFrags(table, table.my_bar, bar.placing, instance)
	end

	function attribute_damage:ReportSingleFragsLine(frag, instance)
		local bar = instance.bars[frag.my_bar]

		local report = {"Details! " .. Loc["STRING_ATTRIBUTE_DAMAGE_TAKEN"].. ": " .. frag[1]} --> localize-me
		for i = 1, GameCooltip:GetNumLines() do 
			local text_left, text_right = GameCooltip:GetText(i)
			if (text_left and text_right) then 
				text_left = text_left:gsub(("|T(.*)|t "), "")
				report[#report+1] = ""..text_left.." "..text_right..""
			end
		end

		return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
	end

	function attribute_damage:ActualizeFrags(table, which_bar, placing, instance)

		table["frags"] = true --> marca que this table é uma table de frags, usado no controla na hora de preparer o tooltip
		local this_bar = instance.bars[which_bar] --> pega a referência da bar na window
		
		if (not this_bar) then
			print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
			return
		end
		
		local table_previous = this_bar.my_table
		
		this_bar.my_table = table
		
		table.name = table[1] --> evita dar erro ao redimencionar a window
		table.my_bar = which_bar
		this_bar.placing = placing
		
		if (not _getmetatable(table)) then 
			_setmetatable(table, {__call = RefreshBarFrags}) 
			table._custom = true
		end

		local total = instance.showing.totals.frags_total
		local percentage
		
		if (instance.row_info.percent_type == 1) then
			percentage = _cstr("%.1f", table[2] / total * 100)
		elseif (instance.row_info.percent_type == 2) then
			percentage = _cstr("%.1f", table[2] / instance.top * 100)
		end
		
		this_bar.text_left:SetText(placing .. ". " .. table[1])
		this_bar.text_right:SetText(table[2] .. "(" .. percentage .. "%)")
		
		this_bar.text_left:SetSize(this_bar:GetWidth() - this_bar.text_right:GetStringWidth() - 20, 15)
		
		if (placing == 1) then
			this_bar.statusbar:SetValue(100)
		else
			this_bar.statusbar:SetValue(table[2] / instance.top * 100)
		end
		
		if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
			gump:Fade(this_bar, "out")
		end

		--> ele nao come o text quando a instância this muito pequena
		this_bar.texture:SetVertexColor(_unpack(_details.class_colors[table[3]]))
		
		if (table[3] == "UNKNOW" or table[3] == "UNGROUPPLAYER" or table[3] == "ENEMY") then
			--this_bar.icon_class:SetTexture("Interface\\LFGFRAME\\LFGROLE_BW")
			--this_bar.icon_class:SetTexCoord(.25, .5, 0, 1)
			--this_bar.icon_class:SetVertexColor(1, 1, 1)

			--this_bar.icon_class:SetTexture([[Interface\MINIMAP\Minimap_skull_normal]])
			--this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			--this_bar.icon_class:SetVertexColor(1, 1, 1)
			
			this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\classes_plus]])
			this_bar.icon_class:SetTexCoord(0.50390625, 0.62890625, 0, 0.125)
			this_bar.icon_class:SetVertexColor(1, 1, 1)
		else
			this_bar.icon_class:SetTexture(instance.row_info.icon_file)
			this_bar.icon_class:SetTexCoord(_unpack(_details.class_coords[table[3]]))
			this_bar.icon_class:SetVertexColor(1, 1, 1)
		end

		if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
			--gump:UpdateTooltip(which_bar, this_bar, instance)
		end

	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> void zones

	function attribute_damage:ReportSingleVoidZoneLine(actor, instance)
		local bar = instance.bars[actor.my_bar]

		local report = {"Details! " .. Loc["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"] .. ": " .. actor.name} --> localize-me
		for i = 1, GameCooltip:GetNumLines() do 
			local text_left, text_right = GameCooltip:GetText(i)
			if (text_left and text_right) then 
				text_left = text_left:gsub(("|T(.*)|t "), "")
				report[#report+1] = ""..text_left.." "..text_right..""
			end
		end

		return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
	end

	function _details:ToolTipVoidZones(instance, actor, bar, keydown)
		
		local damage_actor = instance.showing[1]:CatchCombatant(_, actor.damage_twin)
		local ability
		local targets
		
		if (damage_actor) then
			ability = damage_actor.spell_tables._ActorTable[actor.damage_spellid]
		end
		
		if (ability) then
			targets = ability.targets
		end
		
		local container = actor.debuff_uptime_targets._ActorTable
		
		for _, dst in _ipairs(container) do
			if (targets) then
				local damage_dst = targets._NameIndexTable[dst.name]
				if (damage_dst) then
					damage_dst = targets._ActorTable[damage_dst]
					dst.damage = damage_dst.total
				else
					dst.damage = 0
				end
			else
				dst.damage = 0
			end
		end

		--> sort no container:
		_table_sort(container, function(table1, table2)
			if (table1.damage > table2.damage) then
				return true;
			elseif (table1.damage == table2.damage) then
				return table1.uptime > table2.uptime;
			end
			return false;
		end)
		
		actor.debuff_uptime_targets:remapear()
		
		--> prepare o cooltip
		local GameCooltip = GameCooltip
		
		GameCooltip:AddLine(Loc["STRING_VOIDZONE_TOOLTIP"], nil, nil, headerColor, nil, 12)
		GameCooltip:AddIcon([[Interface\Addons\Details\images\icons]], 1, 1, 14, 14, 0.126953125, 0.1796875, 0, 0.0546875)
		
		for _, dst in _ipairs(container) do 

			local minutes, seconds = _math_floor(dst.uptime / 60), _math_floor(dst.uptime % 60)
			if (minutes > 0) then
				GameCooltip:AddLine(dst.name, FormatTooltipNumber(_, dst.damage) .. "(" .. minutes .. "m " .. seconds .. "s" .. ")")
			else
				GameCooltip:AddLine(dst.name, FormatTooltipNumber(_, dst.damage) .. "(" .. seconds .. "s" .. ")")
			end
			
			local class = _details:GetClass(dst.name)
			if (class) then	
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], nil, nil, 14, 14, unpack(_details.class_coords[class]))
			else
				GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
			end
			
			_details:AddTooltipBackgroundStatusbar()
		
		end
		
		GameCooltip:AddLine("")
		GameCooltip:AddLine(Loc["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack(self.click_to_report_color))
		GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
		
		GameCooltip:ShowCooltip()
		
	end

	local function RefreshBarVoidZone(table, bar, instance)
		table:ActualizeVoidZone(table.my_bar, bar.placing, instance)
	end

	function attribute_misc:ActualizeVoidZone(which_bar, placing, instance)

		--> pega a referência da bar na window
		local this_bar = instance.bars[which_bar]
		
		if (not this_bar) then
			print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
			return
		end
		
		self._refresh_window = RefreshBarVoidZone
		
		local table_previous = this_bar.my_table
		
		this_bar.my_table = self
		
		self.my_bar = which_bar
		this_bar.placing = placing
		
		local total = instance.showing.totals.voidzone_damage

		
		local combat_time = instance.showing:GetCombatTime()
		local dps = _math_floor(self.damage / combat_time)
		
		local formated_damage = SelectedToKFunction(_, self.damage)
		local formated_dps = SelectedToKFunction(_, dps)
		
		local percentage
		
		if (instance.row_info.percent_type == 1) then
			percentage = _cstr("%.1f", self.damage / total * 100)
		elseif (instance.row_info.percent_type == 2) then
			percentage = _cstr("%.1f", self.damage / instance.top * 100)
		end
		
		if (UsingCustomRightText) then
			this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_damage, formated_dps, percentage, self))
		else
			this_bar.text_right:SetText(formated_damage .. "(" .. formated_dps .. ", " .. percentage .. "%)")
		end

		this_bar.text_left:SetText(placing .. ". " .. self.name)
		this_bar.text_left:SetSize(this_bar:GetWidth() - this_bar.text_right:GetStringWidth() - 20, 15)
		
		this_bar.statusbar:SetValue(100)
		
		if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
			gump:Fade(this_bar, "out")
		end
		
		local _, _, icon = GetSpellInfo(self.damage_spellid)
		local school_color = _details.school_colors[self.spellschool]
		if (not school_color) then
			school_color = _details.school_colors["unknown"]
		end
		
		this_bar.texture:SetVertexColor(_unpack(school_color))
		this_bar.icon_class:SetTexture(icon)
		this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
		this_bar.icon_class:SetVertexColor(1, 1, 1)

		if (this_bar.mouse_over and not instance.baseframe.isMoving) then
			--need call a refresh function
		end

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> main refresh function


function attribute_damage:RefreshWindow(instance, combat_table, force, export, refresh_needed)
	
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable

	--> não há bars para mostrar -- not have something to show
	if (#showing._ActorTable < 1) then 
		--> colocado isso recentemente para do as bars de damage sumirem na troca de attribute
		return _details:HideBarsNotUsed(instance, showing) 
	end
	
	--> total
	local total = 0
	--> top actor #1
	instance.top = 0
	
	local using_cache = false
	
	local sub_attribute = instance.sub_attribute --> o que this sendo mostrado nthis instância
	local content = showing._ActorTable --> pega a list de players -- get actors table from container
	local amount = #content
	local mode = instance.mode
	
	--> pega which a sub key que será usada --sub keys
	if (export) then
	
		if (_type(export) == "boolean") then 		
			if (sub_attribute == 1) then --> DAMAGE DONE
				keyName = "total"
			elseif (sub_attribute == 2) then --> DPS
				keyName = "last_dps"
			elseif (sub_attribute == 3) then --> TAMAGE TAKEN
				keyName = "damage_taken"
			elseif (sub_attribute == 4) then --> FRIENDLY FIRE
				keyName = "friendlyfire_total"
			elseif (sub_attribute == 5) then --> FRAGS
				keyName = "frags"
			elseif (sub_attribute == 6) then --> ENEMIES
				keyName = "enemies"
			elseif (sub_attribute == 7) then --> AURAS VOIDZONES
				keyName = "voidzones"
			end
		else
			keyName = export.key
			mode = export.mode		
		end
	elseif (instance.attribute == 5) then --> custom
		keyName = "custom"
		total = combat_table.totals[instance.customName]
	else
		if (sub_attribute == 1) then --> DAMAGE DONE
			keyName = "total"
		elseif (sub_attribute == 2) then --> DPS
			keyName = "last_dps"
		elseif (sub_attribute == 3) then --> TAMAGE TAKEN
			keyName = "damage_taken"
		elseif (sub_attribute == 4) then --> FRIENDLY FIRE
			keyName = "friendlyfire_total"
		elseif (sub_attribute == 5) then --> FRAGS
			keyName = "frags"
		elseif (sub_attribute == 6) then --> ENEMIES
			keyName = "enemies"
		elseif (sub_attribute == 7) then --> AURAS VOIDZONES
			keyName = "voidzones"
		end
	end
	
	if (keyName == "frags") then 
	
		local frags = instance.showing.frags
		local frags_total_kills = 0
		local index = 0
		
		for fragName, fragAmount in _pairs(frags) do 
		
			index = index + 1
		
			local fragged_actor = showing._NameIndexTable[fragName] --> get index
			local actor_class
			if (fragged_actor) then
				fragged_actor = showing._ActorTable[fragged_actor] --> get object
				actor_class = fragged_actor.class
			end
			
			if (fragged_actor and fragged_actor.monster) then
				actor_class = "ENEMY"
			elseif (not actor_class) then
				actor_class = "UNGROUPPLAYER"
			end
			
			if (ntable[index]) then
				ntable[index][1] = fragName
				ntable[index][2] = fragAmount
				ntable[index][3] = actor_class
			else
				ntable[index] = {fragName, fragAmount, actor_class}
			end
			
			frags_total_kills = frags_total_kills + fragAmount
			
		end
		
		local tsize = #ntable
		if (index < tsize) then
			for i = index+1, tsize do
				ntable[i][2] = 0
			end
		end
		
		instance.top = 0
		if (tsize > 0) then
			_table_sort(ntable, _details.Sort2)
			instance.top = ntable[1][2]
		end
	
		total = index
		
		if (export) then 
			local export = {}
			for i = 1, index do 
				export[i] = {ntable[i][1], ntable[i][2], ntable[i][3]}
			end
			return export
		end
		
		if (total < 1) then
			instance:HideScrollBar()
			return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
		end
		
		combat_table.totals.frags_total = frags_total_kills
		
		instance:ActualizeScrollBar(total)
		
		local which_bar = 1
		local bars_container = instance.bars

		
		for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar só o range que this sendo mostrado
			attribute_damage:ActualizeFrags(ntable[i], which_bar, i, instance)
			which_bar = which_bar+1
		end
		
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	
	elseif (keyName == "voidzones") then 
		
		local index = 0
		local misc_container = combat_table[4]
		local voidzone_damage_total = 0
		
		for _, actor in _ipairs(misc_container._ActorTable) do
			if (actor.boss_debuff) then
				index = index + 1
			
				--pega no container de damage o actor responsável por aplicar o debuff
				local twin_damage_actor = showing._NameIndexTable[actor.damage_twin] or showing._NameIndexTable["[*] " .. actor.damage_twin]
				
				if (twin_damage_actor) then
					local index = twin_damage_actor
					twin_damage_actor = showing._ActorTable[twin_damage_actor]

					local spell = twin_damage_actor.spell_tables._ActorTable[actor.damage_spellid]
					
					if (spell) then
					
						--> fix spell, sometimes there is two spells with the same name, one is the cast and other is the debuff
						if (spell.total == 0 and not actor.damage_spellid_fixed) then
							local curname = _GetSpellInfo(actor.damage_spellid)
							for spellid, spelltable in _pairs(twin_damage_actor.spell_tables._ActorTable) do
								if (spelltable.total > spell.total) then
									local name = _GetSpellInfo(spellid)
									if (name == curname) then
										actor.damage_spellid = spellid
										spell = spelltable
									end
								end
							end
							actor.damage_spellid_fixed = true
						end
						
						actor.damage = spell.total
						voidzone_damage_total = voidzone_damage_total + spell.total
						
					elseif (not actor.damage_spellid_fixed) then --not
						--> fix spell, if the spellid passed for debuff uptime is actully the spell id of a ability and not if the aura it self
						actor.damage_spellid_fixed = true
						local found = false
						for spellid, spelltable in _pairs(twin_damage_actor.spell_tables._ActorTable) do
							local name = _GetSpellInfo(spellid)
							if (actor.damage_twin:find(name)) then
								actor.damage = spelltable.total
								voidzone_damage_total = voidzone_damage_total + spelltable.total
								actor.damage_spellid = spellid
								found = true
								break
							end
						end
						
						if (not found) then
							actor.damage = 0
						end
					else
						actor.damage = 0
					end
				else
					actor.damage = 0
				end
				
				vtable[index] = actor
			end
		end
		
		local tsize = #vtable
		if (index < tsize) then
			for i = index+1, tsize do
				vtable[i] = nil
			end
		end
		
		if (tsize > 0 and vtable[1]) then
			_table_sort(vtable, void_zone_sort)
			instance.top = vtable[1].damage
		end
		total = index 
		
		if (export) then 
			return vtable
		end
		
		if (total < 1) then
			instance:HideScrollBar()
			return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
		end
		
		combat_table.totals.voidzone_damage = voidzone_damage_total
		
		instance:ActualizeScrollBar(total)
		
		local which_bar = 1
		local bars_container = instance.bars

		for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar só o range que this sendo mostrado
			vtable[i]:ActualizeVoidZone(which_bar, i, instance)
			which_bar = which_bar+1
		end
		
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
		
	else
	
		if (instance.attribute == 5) then --> custom
			--> faz o sort da categoria e retorna o amount corrigido
			amount = _details:ContainerSort(content, amount, keyName)
			
			--> grava o total
			instance.top = content[1][keyName]
			
		elseif (keyName == "enemies") then 
		
			amount, total = _details:ContainerSortEnemies(content, amount, "total")
			--keyName = "enemies"
			--> grava o total
			instance.top = content[1][keyName]
			
		elseif (mode == mode_ALL) then --> showing ALL
		
			--> faz o sort da categoria e retorna o amount corrigido
			--print(keyName)
			if (sub_attribute == 2) then
				local combat_time = instance.showing:GetCombatTime()
				total = attribute_damage:ContainerRefreshDps(content, combat_time)
			else
				--> pega o total ja aplicado na table do combat
				total = combat_table.totals[class_type]
			end
			
			amount = _details:ContainerSort(content, amount, keyName)
			
			--> grava o total
			instance.top = content[1][keyName]
		
		elseif (mode == mode_GROUP) then --> showing GROUP
		
			--> organiza as tables
			
			if (_details.in_combat and instance.segment == 0 and not export) then
				using_cache = true
			end
			
			if (using_cache) then
			
				content = _details.cache_damage_group
				
				if (sub_attribute == 2) then --> dps
					local combat_time = instance.showing:GetCombatTime()
					attribute_damage:ContainerRefreshDps(content, combat_time)
				end
			
				if (#content < 1) then
					return _details:HideBarsNotUsed(instance, showing)
				end
			
				_table_sort(content, _details.SortKeySimple)
			
				if (content[1][keyName] < 1) then
					amount = 0
				else
					instance.top = content[1][keyName]
					amount = #content
				end
			
				for i = 1, amount do 
					total = total + content[i][keyName]
				end
			else
				if (sub_attribute == 2) then --> dps
					local combat_time = instance.showing:GetCombatTime()
					attribute_damage:ContainerRefreshDps(content, combat_time)
				end

				_table_sort(content, _details.SortKeyGroup)
			end
			--
			if (not using_cache) then
				for index, player in _ipairs(content) do
					if (player.group) then --> é um player e this em group
						if (player[keyName] < 1) then --> damage menor que 1, interromper o loop
							amount = index - 1
							break
						elseif (index == 1) then --> esse IF aqui, precisa mesmo ser aqui? não daria pra pega-lo com uma chave[1] nad group == true?
							instance.top = content[1][keyName]
						end
						
						total = total + player[keyName]
					else
						amount = index-1
						break
					end
				end
			end

		end
	end
	
	--> refaz o mapa do container
	if (not using_cache) then
		showing:remapear()
	end
	
	if (export) then 
		return total, keyName, instance.top, amount
	end

	if (amount < 1) then --> não há bars para mostrar
		if (force) then
			if (instance.mode == 2) then --> group
				for i = 1, instance.rows_fit_in_window  do
					gump:Fade(instance.bars[i], "in", 0.3)
				end
			end
		end
		instance:HideScrollBar() --> precisaria esconder a scroll bar
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	end

	instance:ActualizeScrollBar(amount)

	local which_bar = 1
	local bars_container = instance.bars --> evita buscar N vezes a key .bars dentro da instância
	local percentage_type = instance.row_info.percent_type
	local baseframe = instance.baseframe
	
	local use_animations = _details.is_using_row_animations and(not baseframe.isStretching and not force and not baseframe.isResizing)

	if (total == 0) then
		total = 0.00000001
	end
	
	local myPos
	local following = instance.following.enabled
	
	if (following) then
		if (using_cache) then
			local pname = _details.playername
			for i, actor in _ipairs(content) do
				if (actor.name == pname) then
					myPos = i
					break
				end
			end
		else
			myPos = showing._NameIndexTable[_details.playername]
		end
	end

	local combat_time = instance.showing:GetCombatTime()
	
	UsingCustomLeftText = instance.row_info.textL_enable_custom_text
	UsingCustomRightText = instance.row_info.textR_enable_custom_text
	
	local use_total_bar = false
	if (instance.total_bar.enabled) then
	
		use_total_bar = true
		
		if (instance.total_bar.only_in_group and(GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0)) then
			use_total_bar = false
		end
		
		if (sub_attribute > 4) then --enemies, frags, void zones
			use_total_bar = false
		end
		
	end
	
	if (instance.bars_sort_direction == 1) then --top to bottom
		
		if (use_total_bar and instance.barS[1] == 1) then
		
			which_bar = 2
			local iter_last = instance.barS[2]
			if (iter_last == instance.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = bars_container[1]
			row1.my_table = nil
			row1.text_left:SetText(Loc["STRING_TOTAL"])
			row1.text_right:SetText(_details:ToK2(total) .. "(" .. _details:ToK(total / combat_time) .. ")")
			
			row1.statusbar:SetValue(100)
			local r, b, g = unpack(instance.total_bar.color)
			row1.texture:SetVertexColor(r, b, g)
			
			row1.icon_class:SetTexture(instance.total_bar.icon)
			row1.icon_class:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade(row1, "out")
			
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[1], iter_last-1, 1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
				which_bar = which_bar+1
			else
				for i = instance.barS[1], iter_last, 1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
			end

		else
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[1], instance.barS[2]-1, 1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
				which_bar = which_bar+1
			else
				for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
			end
		end
		
	elseif (instance.bars_sort_direction == 2) then --bottom to top
	
		if (use_total_bar and instance.barS[1] == 1) then
		
			which_bar = 2
			local iter_last = instance.barS[2]
			if (iter_last == instance.rows_fit_in_window) then
				iter_last = iter_last - 1
			end
			
			local row1 = bars_container[1]
			row1.my_table = nil
			row1.text_left:SetText(Loc["STRING_TOTAL"])
			row1.text_right:SetText(_details:ToK2(total) .. "(" .. _details:ToK(total / combat_time) .. ")")
			
			row1.statusbar:SetValue(100)
			local r, b, g = unpack(instance.total_bar.color)
			row1.texture:SetVertexColor(r, b, g)
			
			row1.icon_class:SetTexture(instance.total_bar.icon)
			row1.icon_class:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
			
			gump:Fade(row1, "out")
			
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = iter_last-1, instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
				which_bar = which_bar+1
			else
				for i = iter_last, instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
			end
		else
			if (following and myPos and myPos > instance.rows_fit_in_window and instance.barS[2] < myPos) then
				for i = instance.barS[2]-1, instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
				
				content[myPos]:UpdateBar(instance, bars_container, which_bar, myPos, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
				which_bar = which_bar+1
			else
				for i = instance.barS[2], instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
					which_bar = which_bar+1
				end
			end
		end
		
	end
	
	if (use_animations) then
		instance:do_animations()
	end

	if (instance.attribute == 5) then --> custom
		--> zerar o .custom dos Actors
		for index, player in _ipairs(content) do
			if (player.custom > 0) then 
				player.custom = 0
			else
				break
			end
		end
	end
	
	--> beta, hidar bars não usadas durante um refresh forçado
	if (force) then
		if (instance.mode == 2) then --> group
			for i = which_bar, instance.rows_fit_in_window  do
				gump:Fade(instance.bars[i], "in", 0.3)
			end
		end
	end
	
	return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh

end

function attribute_damage:Custom(_customName, _combat, sub_attribute, spell, dst)
	--> vai ter só o que a spell causou em alguém
	--print(spell)
	--print(self.name)
	--print(self.spell_tables._ActorTable)
	
	--if (self.name == "Ditador") then 
		--for spellid, table in pairs(self.spell_tables._ActorTable) do 
			--print(spellid)
		--end
		local _Skill = self.spell_tables._ActorTable[tonumber(spell)]
		--print(_Skill)
		if (_Skill) then
			local spellName = _GetSpellInfo(tonumber(spell))
			--print(spell)
			--print(spellName)
			
			local SkillTargets = _Skill.targets._ActorTable
			
			for _, TargetActor in _ipairs(SkillTargets) do 
				--print(TargetActor.name)
				local TargetActorSelf = _combat(class_type, TargetActor.name)
				if (TargetActorSelf) then
					--print(TargetActor.total)
					TargetActorSelf.custom = TargetActor.total + TargetActorSelf.custom
					--print(TargetActorSelf.custom)
					_combat.totals[_customName] = _combat.totals[_customName] + TargetActor.total
					--print(self.name .. " " ..TargetActor.total)
				end
			end
		end
	--end
end

function _details:FastRefreshWindow(instance)
	if (instance.attribute == 1) then --> damage
		
	end
end

local actor_class_color_r, actor_class_color_g, actor_class_color_b

--self = this class de damage
function attribute_damage:UpdateBar(instance, bars_container, which_bar, place, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations)
							-- instância, container das bars, which bar, colocação, total?, sub attribute, forçar refresh, key
	
	local this_bar = bars_container[which_bar] --> pega a referência da bar na window
	
	if (not this_bar) then
		print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
		return
	end
	
	local table_previous = this_bar.my_table
	
	this_bar.my_table = self --> grava uma referência desse objeto na bar
	self.my_bar = this_bar --> grava uma referência da bar no objeto
	
	this_bar.placing = place --> salva na bar which a colocação mostrada.
	self.placing = place --> salva no objeto which a colocação mostrada
	
	local damage_total = self.total --> total de damage que this player deu
	local dps
	
	local percentage
	local this_percentage
	
	if (percentage_type == 1) then
		percentage = _cstr("%.1f", self[keyName] / total * 100)
	elseif (percentage_type == 2) then
		percentage = _cstr("%.1f", self[keyName] / instance.top * 100)
	end

	--time da shadow não é mais calcuside pela timemachine
	if ((_details.time_type == 2 and self.group) or not _details:CaptureGet("damage") or not self.shadow) then --not self.shadow is overall but...
		if (not self.shadow and combat_time == 0) then
			local p = _details.table_current(1, self.name)
			if (p) then
				local t = p:Time()
				dps = damage_total / t
				self.last_dps = dps
			else
				dps = damage_total / combat_time
				self.last_dps = dps
			end
		else
			dps = damage_total / combat_time
			self.last_dps = dps
		end
	else
		if (not self.on_hold) then
			dps = damage_total/self:Time() --calcula o dps dthis objeto
			self.last_dps = dps --salva o dps dele
		else
			if (self.last_dps == 0) then --> não calculou o dps dele ainda mas entrou em standby
				dps = damage_total/self:Time()
				self.last_dps = dps
			else
				dps = self.last_dps
			end
		end
	end
	
	-- >>>>>>>>>>>>>>> text da right
	if (instance.attribute == 5) then --> custom
		this_bar.text_right:SetText(_details:ToK(self.custom) .."(" .. percentage .. "%)") --seta o text da right
		this_percentage = _math_floor((self.custom/instance.top) * 100) --> determina which o tamanho da bar
	else
	
		if (sub_attribute == 1) then --> showing damage done
		
			dps = _math_floor(dps)
			local formated_damage = SelectedToKFunction(_, damage_total)
			local formated_dps = SelectedToKFunction(_, dps)

			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_damage, formated_dps, percentage, self))
			else
				this_bar.text_right:SetText(formated_damage .. "(" .. formated_dps .. ", " .. percentage .. "%)") --seta o text da right
			end
			this_percentage = _math_floor((damage_total/instance.top) * 100) --> determina which o tamanho da bar

		elseif (sub_attribute == 2) then --> showing dps
		
			dps = _math_floor(dps)
			local formated_damage = SelectedToKFunction(_, damage_total)
			local formated_dps = SelectedToKFunction(_, dps)
		
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_dps, formated_damage, percentage, self))
			else		
				this_bar.text_right:SetText(formated_dps .. "(" .. formated_damage .. ", " .. percentage .. "%)") --seta o text da right
			end
			this_percentage = _math_floor((dps/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 3) then --> showing damage taken

			local dtps = self.damage_taken / combat_time
		
			local formated_damage_taken = SelectedToKFunction(_, self.damage_taken)
			local formated_dtps = SelectedToKFunction(_, dtps)

			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_damage_taken, formated_dtps, percentage, self))
			else
				this_bar.text_right:SetText(formated_damage_taken .."(" .. formated_dtps .. ", " .. percentage .. "%)") --seta o text da right --
			end
			this_percentage = _math_floor((self.damage_taken/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 4) then --> showing friendly fire
		
			local formated_friendly_fire = SelectedToKFunction(_, self.friendlyfire_total)

			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_friendly_fire, "", percentage, self))
			else			
				this_bar.text_right:SetText(formated_friendly_fire .. "(" .. percentage .. "%)") --seta o text da right --
			end
			this_percentage = _math_floor((self.friendlyfire_total/instance.top) * 100) --> determina which o tamanho da bar
		
		elseif (sub_attribute == 6) then --> showing enemies
		
			dps = _math_floor(dps)
			local formated_damage = SelectedToKFunction(_, damage_total)
			local formated_dps = SelectedToKFunction(_, dps)
		
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_damage, formated_dps, percentage, self))
			else		
				this_bar.text_right:SetText(formated_damage .. "(" .. formated_dps .. ", " .. percentage .. "%)") --seta o text da right
			end
			this_percentage = _math_floor((damage_total/instance.top) * 100) --> determina which o tamanho da bar
			
		end
	end

	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end

	if (self.need_refresh) then
		self.need_refresh = false
		force = true
	end
	
	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)

end

--[[ exported]] function _details:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
	
	--> primeiro colocado
	if (this_bar.placing == 1) then
		if (not table_previous or table_previous ~= this_bar.my_table or force) then
			this_bar.statusbar:SetValue(100)
			
			if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
				gump:Fade(this_bar, "out")
			end
			
			return self:RefreshBar(this_bar, instance)
		else
			return
		end
	else

		if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
		
			--this_bar.statusbar:SetValue(this_percentage)
			
			if (use_animations) then
				this_bar.animation_end = this_percentage
			else
				this_bar.statusbar:SetValue(this_percentage)
				this_bar.animation_ignore = true
			end
				
			gump:Fade(this_bar, "out")
			
			if (instance.row_info.texture_class_colors) then
				this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			if (instance.row_info.texture_background_class_color) then
				this_bar.background:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
			end
			
			return self:RefreshBar(this_bar, instance)
			
		else
			--> agora this comparando se a table da bar é diferente da table na atualização previous
			if (not table_previous or table_previous ~= this_bar.my_table or force) then --> aqui diz se a bar do player mudou de posição ou se ela apenas será atualizada
			
				if (use_animations) then
					this_bar.animation_end = this_percentage
				else
					this_bar.statusbar:SetValue(this_percentage)
					this_bar.animation_ignore = true
				end
			
				this_bar.last_value = this_percentage --> reseta o ultimo valor da bar
				
				return self:RefreshBar(this_bar, instance)
				
			elseif (this_percentage ~= this_bar.last_value) then --> continua showing a mesma table então compara a percentage
				--> apenas atualizar
				if (use_animations) then
					this_bar.animation_end = this_percentage
				else
					this_bar.statusbar:SetValue(this_percentage)
				end
				this_bar.last_value = this_percentage
				
				return self:RefreshBar(this_bar, instance)
			end
		end

	end
	
end

--[[ exported]] function _details:RefreshBar(this_bar, instance, from_resize)
	
	if (from_resize) then
		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	end
	
	if (instance.row_info.texture_class_colors) then
		this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.texture_background_class_color) then
		this_bar.background:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end	
	
	--icon
	if (self.spellicon) then
		this_bar.icon_class:SetTexture(self.spellicon)
		this_bar.icon_class:SetTexCoord(0.078125, 0.921875, 0.078125, 0.921875)
		this_bar.icon_class:SetVertexColor(1, 1, 1)
		
	elseif (self.class == "UNKNOW") then
		--this_bar.icon_class:SetTexture("Interface\\LFGFRAME\\LFGROLE")
		--this_bar.icon_class:SetTexCoord(.25, .5, 0, 1)
		
		--this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\PetBadge-Undead]])
		--this_bar.icon_class:SetTexCoord(0.09375, 0.90625, 0.09375, 0.90625)
		
		this_bar.icon_class:SetTexture([[Interface\AddOns\Details\images\classes_plus]])
		this_bar.icon_class:SetTexCoord(0.50390625, 0.62890625, 0, 0.125)
		
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	
	elseif (self.class == "UNGROUPPLAYER") then
		if (self.enemy) then
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Orc_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Human_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		else
			if (_details.faction_against == "Horde") then
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Human_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			else
				this_bar.icon_class:SetTexture("Interface\\AddOns\\Details\\images\\Achievement_Character_Orc_Male")
				this_bar.icon_class:SetTexCoord(0, 1, 0, 1)
			end
		end
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	
	elseif (self.class == "PET") then
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		this_bar.icon_class:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)

	else
		this_bar.icon_class:SetTexture(instance.row_info.icon_file)
		this_bar.icon_class:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[self.class])) --very slow method
		this_bar.icon_class:SetVertexColor(1, 1, 1)
	end

	--texture and text
	local bar_number = ""
	if (instance.row_info.textL_show_number) then
		bar_number = this_bar.placing .. ". "
	end
	
	if (self.enemy) then
		if (self.arena_enemy) then
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(instance.row_info.textL_custom_text:ReplaceData(this_bar.placing, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t"))
			else
				this_bar.text_left:SetText(bar_number .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t" .. self.displayName)
			end
			this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
		else
			if (_details.faction_against == "Horde") then
				if (UsingCustomLeftText) then
					this_bar.text_left:SetText(instance.row_info.textL_custom_text:ReplaceData(this_bar.placing, self.displayName, "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:0:32:0:32|t"))
				else
					this_bar.text_left:SetText(bar_number .. "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:0:32:0:32|t"..self.displayName) --seta o text da esqueda -- HORDA
				end
			else
				if (UsingCustomLeftText) then
					this_bar.text_left:SetText(instance.row_info.textL_custom_text:ReplaceData(this_bar.placing, self.displayName, "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:32:64:0:32|t"))
				else
					this_bar.text_left:SetText(bar_number .. "|TInterface\\AddOns\\Details\\images\\icons_bar:"..instance.row_info.height..":"..instance.row_info.height..":0:0:256:32:32:64:0:32|t"..self.displayName) --seta o text da esqueda -- ALLY
				end
			end
			
			if (instance.row_info.texture_class_colors) then
				this_bar.texture:SetVertexColor(0.94117, 0, 0.01960, 1)
			end
		end
	else
		if (self.arena_ally) then
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(instance.row_info.textL_custom_text:ReplaceData(this_bar.placing, self.displayName, "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t"))
			else
				this_bar.text_left:SetText(bar_number .. "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. instance.row_info.height .. ":" .. instance.row_info.height .. ":0:0:256:256:" .. _details.role_texcoord[self.role or "NONE"] .. "|t" .. self.displayName)
			end
		else
			if (UsingCustomLeftText) then
				this_bar.text_left:SetText(instance.row_info.textL_custom_text:ReplaceData(this_bar.placing, self.displayName, ""))
			else
				this_bar.text_left:SetText(bar_number .. self.displayName) --seta o text da esqueda
			end
		end
	end
	
	if (instance.row_info.textL_class_colors) then
		this_bar.text_left:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.textR_class_colors) then
		this_bar.text_right:SetTextColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	
	this_bar.text_left:SetSize(this_bar:GetWidth() - this_bar.text_right:GetStringWidth() - 20, 15)
	
end


--------------------------------------------- // TOOLTIPS // ---------------------------------------------



---------> TOOLTIPS BIFURCAÇÃO

function attribute_damage:ToolTip(instance, number, bar, keydown)
	--> seria possivel aqui colocar o icon da class dele?

	if (instance.attribute == 5) then --> custom
		return self:TooltipForCustom(bar)
	else
		if (instance.sub_attribute == 1 or instance.sub_attribute == 2) then --> damage done or Dps or enemy
			return self:ToolTip_DamageDone(instance, number, bar, keydown)
		elseif (instance.sub_attribute == 3 or instance.sub_attribute == 6) then --> damage taken
			return self:ToolTip_DamageTaken(instance, number, bar, keydown)
		elseif (instance.sub_attribute == 4) then --> friendly fire
			return self:ToolTip_FriendlyFire(instance, number, bar, keydown)
		end
	end
end
--> tooltip locals
local r, g, b
local barAlpha = .6



---------> DAMAGE DONE & DPS


function attribute_damage:ToolTip_DamageDone(instance, number, bar, keydown)
	
	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end
	
	do
		--> TOP HABILIDADES
		
			--get variables
			local ActorDamage = self.total_without_pet
			local ActorDamageWithPet = self.total
			if (ActorDamage == 0) then
				ActorDamage = 0.00000001
			end
			local ActorSkillsContainer = self.spell_tables._ActorTable
			local ActorSkillsSortTable = {}
			
			--get time type
			local mine_time
			if (_details.time_type == 1 or not self.group) then
				mine_time = self:Time()
			elseif (_details.time_type == 2) then
				mine_time = instance.showing:GetCombatTime()
			end
			
			--print("time:", mine_time)
			
			--add and sort
			for _spellid, _skill in _pairs(ActorSkillsContainer) do
				ActorSkillsSortTable[#ActorSkillsSortTable+1] = {_spellid, _skill.total, _skill.total/mine_time}
			end
			_table_sort(ActorSkillsSortTable, _details.Sort2)
		
		--> TOP INIMIGOS
			--get variables
			local ActorTargetsContainer = self.targets._ActorTable
			local ActorTargetsSortTable = {}
			
			--add and sort
			for _, _target in _ipairs(ActorTargetsContainer) do
				ActorTargetsSortTable[#ActorTargetsSortTable+1] = {_target.name, _target.total}
			end
			_table_sort(ActorTargetsSortTable, _details.Sort2)

			--tooltip stuff
			local tooltip_max_abilities = _details.tooltip_max_abilities
			if (instance.sub_attribute == 2) then
				tooltip_max_abilities = 6
			end
			
			local is_maximized = false
			if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
				tooltip_max_abilities = 99
				is_maximized = true
			end
			
		--> MOSTRA HABILIDADES
			_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #ActorSkillsSortTable)
			
			--GameCooltip:AddIcon([[Interface\ICONS\Spell_Shaman_BlessingOfTheEternals]], 1, 1, 14, 14, 0.90625, 0.109375, 0.15625, 0.875)
			GameCooltip:AddIcon(_details.tooltip_spell_icon.file, 1, 1, 14, 14, unpack(_details.tooltip_spell_icon.coords))
			
			if (is_maximized) then
				--highlight shift key
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
				GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
			else
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
				GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
			end
			
			--abilities
			if (#ActorSkillsSortTable > 0) then
				for i = 1, _math_min(tooltip_max_abilities, #ActorSkillsSortTable) do
					local SkillTable = ActorSkillsSortTable[i]
					local name_spell, _, icon_spell = _GetSpellInfo(SkillTable[1])
					if (instance.sub_attribute == 1 or instance.sub_attribute == 6) then
						GameCooltip:AddLine(name_spell..": ", FormatTooltipNumber(_, SkillTable[2]) .."(".._cstr("%.1f", SkillTable[2]/ActorDamage*100).."%)")
					else
						GameCooltip:AddLine(name_spell..": ", FormatTooltipNumber(_, _math_floor(SkillTable[3])) .."(".._cstr("%.1f", SkillTable[2]/ActorDamage*100).."%)")
					end
					GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
					_details:AddTooltipBackgroundStatusbar()
				end
			else
				GameCooltip:AddLine(Loc["STRING_NO_SPELL"])
			end
			
		--> MOSTRA INIMIGOS
			if (instance.sub_attribute == 1 or instance.sub_attribute == 6) then
				
				_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #ActorTargetsSortTable)

				local max_targets = _details.tooltip_max_targets
				local is_maximized = false
				if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
					max_targets = 99
					is_maximized = true
				end
				
				GameCooltip:AddIcon([[Interface\Addons\Details\images\icons]], 1, 1, 14, 14, 0, 0.03125, 0.126953125, 0.15625)
				
				if (is_maximized) then
					--highlight
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
					GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
				else
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
					GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
				end

				for i = 1, _math_min(max_targets, #ActorTargetsSortTable) do
					local this_enemy = ActorTargetsSortTable[i]
					GameCooltip:AddLine(this_enemy[1]..": ", FormatTooltipNumber(_, this_enemy[2]) .."(".._cstr("%.1f", this_enemy[2]/ActorDamageWithPet*100).."%)")
					--GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\espadas", nil, nil, 14, 14)
					--GameCooltip:AddIcon([[Interface\CHARACTERFRAME\UI-StateIcon]], nil, nil, 14, 14, 33/64, 61/64, 31/64, 60/64)
					--GameCooltip:AddIcon([[Interface\FriendsFrame\StatusIcon-Offline]], nil, nil, 14, 14, 0, 1, 0, 15/16)
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\PetBattle-StatIcons]], nil, nil, 12, 12, 0, 0.5, 0, 0.5, {.7, .7, .7, 1}, nil, true)
					_details:AddTooltipBackgroundStatusbar()
				end
			end
	end
	
	--> PETS
	local mine_pets = self.pets
	if (#mine_pets > 0) then --> teve ajudantes
		
		local amount = {} --> armazena a amount de pets iguais
		local damages = {} --> armazena as abilities
		local targets = {} --> armazena os targets
		local totais = {} --> armazena o damage total de cada objeto
		
		for index, name in _ipairs(mine_pets) do
			if (not amount[name]) then
				amount[name] = 1
				
				local my_self = instance.showing[class_type]:CatchCombatant(nil, name)
				if (my_self) then
					local mine_total = my_self.total_without_pet
					local table = my_self.spell_tables._ActorTable
					local mine_damages = {}
					
					--totais[name] = my_self.total_without_pet
					local mine_time
					if (_details.time_type == 1 or not self.group) then
						mine_time = my_self:Time()
					elseif (_details.time_type == 2) then
						mine_time = my_self:GetCombatTime()
					end
					totais[#totais+1] = {name, my_self.total_without_pet, my_self.total_without_pet/mine_time}
					
					for spellid, table in _pairs(table) do
						local name, rank, icon = _GetSpellInfo(spellid)
						_table_insert(mine_damages, {spellid, table.total, table.total/mine_total*100, {name, rank, icon}})
					end
					_table_sort(mine_damages, _details.Sort2)
					damages[name] = mine_damages
					
					local mine_enemies = {}
					table = my_self.targets._ActorTable
					for _, table in _ipairs(table) do
						_table_insert(mine_enemies, {table.name, table.total, table.total/mine_total*100})
					end
					_table_sort(mine_enemies,_details.Sort2)
					targets[name] = mine_enemies
				end
				
			else
				amount[name] = amount[name]+1
			end
		end
		
		--GameTooltip:AddLine(" ")
		--GameCooltip:AddLine(" ")
		
		local _amount = 0
		local added_logo = false
		
		_table_sort(totais, _details.Sort2)
		
		local ismaximized = false
		if (keydown == "alt" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 5) then
			ismaximized = true
		end
		
		for index, _table in _ipairs(totais) do
			
			if (_table[2] > 0 and(index < 3 or ismaximized)) then
			
				if (not added_logo) then
					added_logo = true
					
					_details:AddTooltipSpellHeaderText(Loc["STRING_PETS"], headerColor, r, g, b, #totais)
					
					GameCooltip:AddIcon([[Interface\AddOns\Details\images\friendship-heart]], 1, 1, 14, 14, 0.21875, 0.78125, 0.09375, 0.6875)
					
					if (ismaximized) then
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_alt]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
						GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
					else
						GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_alt]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
						GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
					end

				end
			
				local n = _table[1]:gsub(("%s%<.*"), "")
				if (instance.sub_attribute == 1) then
					GameCooltip:AddLine(n, FormatTooltipNumber(_, _table[2]) .. "(" .. _math_floor(_table[2]/self.total*100) .. "%)")
				else
					GameCooltip:AddLine(n, FormatTooltipNumber(_,  _math_floor(_table[3])) .. "(" .. _math_floor(_table[2]/self.total*100) .. "%)")
				end
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
			
	end
	
	--> enemies
	if (instance.sub_attribute == 6) then
		GameCooltip:AddLine(" ")
		GameCooltip:AddLine(Loc["STRING_LEFTCLICK_DAMAGETAKEN"])
		--GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 8/512, 70/512, 224/512, 306/512)
		GameCooltip:AddLine(Loc["STRING_MIDDLECLICK_DAMAGETAKEN"])
		--GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 14/512, 64/512, 127/512, 204/512)
	end
	
	return true
end

---------> DAMAGE TAKEN
function attribute_damage:ToolTip_DamageTaken(instance, number, bar, keydown)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end

	local agressores = self.damage_from
	local damage_taken = self.damage_taken
	
	local combat_table = instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	
	local mine_agressores = {}

	for name, _ in _pairs(agressores) do --> agressores seria a list de names
		local this_agressor = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_agressor) then --> checagem por causa do total e do garbage collector que não limpa os names que deram damage
			local targets = this_agressor.targets
			local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
			if (this_dst) then
				mine_agressores[#mine_agressores+1] = {name, this_dst.total, this_agressor.class}
			end
		end
	end

	_table_sort(mine_agressores, function(a, b) return a[2] > b[2] end)
	
	local max = #mine_agressores
	if (max > 6) then
		max = 6
	end
	
	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		max = #mine_agressores
		ismaximized = true
	end

	if (instance.sub_attribute == 6) then
		_details:AddTooltipSpellHeaderText(Loc["STRING_DAMAGE_TAKEN_FROM"], headerColor, r, g, b, #mine_agressores)
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\UI-MicroStream-Red]], 1, 1, 14, 14, 0.1875, 0.8125, 0.15625, 0.78125)
	else
		_details:AddTooltipSpellHeaderText(Loc["STRING_FROM"], headerColor, r, g, b, #mine_agressores)
		GameCooltip:AddIcon([[Interface\Addons\Details\images\icons]], 1, 1, 14, 14, 0.126953125, 0.1796875, 0, 0.0546875)
	end

	if (ismaximized) then
		--highlight
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		if (instance.sub_attribute == 6) then
			GameCooltip:AddStatusBar(100, 1, 0.7, g, b, 1)
		else
			GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		end
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		if (instance.sub_attribute == 6) then
			GameCooltip:AddStatusBar(100, 1, 0.7, 0, 0, barAlpha)
		else
			GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
		end
	end	
	
	for i = 1, max do
		if (ismaximized and mine_agressores[i][1]:find(_details.playername)) then
			GameCooltip:AddLine(mine_agressores[i][1]..": ", FormatTooltipNumber(_, mine_agressores[i][2]).."(".._cstr("%.1f",(mine_agressores[i][2]/damage_taken) * 100).."%)", nil, "yellow")
		else
			GameCooltip:AddLine(mine_agressores[i][1]..": ", FormatTooltipNumber(_, mine_agressores[i][2]).."(".._cstr("%.1f",(mine_agressores[i][2]/damage_taken) * 100).."%)")
		end
		local class = mine_agressores[i][3]
		
		if (not class) then
			class = "UNKNOW"
		end
		
		if (class == "UNKNOW") then
			GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
		else
			GameCooltip:AddIcon(instance.row_info.icon_file, nil, nil, 14, 14, _unpack(_details.class_coords[class]))
		end
		_details:AddTooltipBackgroundStatusbar()
	end
	
	--> enemies
	if (instance.sub_attribute == 6) then
		GameCooltip:AddLine(" ")
		GameCooltip:AddLine(Loc["STRING_LEFTCLICK_DAMAGETAKEN"])
		--GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 8/512, 70/512, 224/512, 306/512)
		GameCooltip:AddLine(Loc["STRING_MIDDLECLICK_DAMAGETAKEN"])
		--GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 10, 14, 14/512, 64/512, 127/512, 204/512)
	end
	
	return true
end

---------> FRIENDLY FIRE
function attribute_damage:ToolTip_FriendlyFire(instance, number, bar, keydown)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end

	local FriendlyFire = self.friendlyfire --> container de players
	local FriendlyFireTotal = self.friendlyfire_total

	local combat_table = instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	
	local DamagedPlayers = {}
	local Skills = {}

	for name, index in _pairs(FriendlyFire._NameIndexTable) do
		local TargetActor = FriendlyFire._ActorTable[index]
		DamagedPlayers[#DamagedPlayers+1] = {name, TargetActor.total, TargetActor.class}
		
		local SkillTable = TargetActor.spell_tables --> container das abilities
		for spellid, table in _pairs(SkillTable._ActorTable) do
			Skills[#Skills+1] = {spellid, table.total, table.counter}
		end
	end
	
	_table_sort(DamagedPlayers, _details.Sort2)
	_table_sort(Skills, _details.Sort2)

	_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #DamagedPlayers)
	
	GameCooltip:AddIcon([[Interface\Addons\Details\images\icons]], 1, 1, 14, 14, 0.126953125, 0.224609375, 0.056640625, 0.140625)
	
	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	local max_abilities = _details.tooltip_max_abilities
	if (ismaximized) then
		max_abilities = 99
	end
	
	for i = 1, _math_min(max_abilities, #DamagedPlayers) do
		local class = DamagedPlayers[i][3]
		if (not class) then
			class = "UNKNOW"
		end

		GameCooltip:AddLine(DamagedPlayers[i][1]..": ", FormatTooltipNumber(_, DamagedPlayers[i][2]).."(".._cstr("%.1f", DamagedPlayers[i][2]/FriendlyFireTotal*100).."%)")
		GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\espadas", nil, nil, 14, 14)
		_details:AddTooltipBackgroundStatusbar()
		
		if (class == "UNKNOW") then
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords["UNKNOW"]))
		else
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords[class]))
		end
		
	end
	
	GameCooltip:AddLine(Loc["STRING_SPELLS"].."", nil, nil, headerColor, nil, 12)

	GameCooltip:AddIcon([[Interface\AddOns\Details\images\bg-down-on]], 1, 1, 14, 14, 0, 1, 0, 1)
	
	local ismaximized = false
	if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	local max_abilities2 = _details.tooltip_max_abilities
	if (ismaximized) then
		max_abilities2 = 99
	end
	
	for i = 1, _math_min(max_abilities2, #Skills) do
		local name, _, icon = _GetSpellInfo(Skills[i][1])
		GameCooltip:AddLine(name.."(x".. Skills[i][3].."): ", FormatTooltipNumber(_, Skills[i][2]).."(".._cstr("%.1f", Skills[i][2]/FriendlyFireTotal*100).."%)")
		GameCooltip:AddIcon(icon, nil, nil, 14, 14)
		_details:AddTooltipBackgroundStatusbar()
	end	
	
	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------


---------> DETALHES BIFURCAÇÃO
function attribute_damage:SetInfo()
	if (info.sub_attribute == 1 or info.sub_attribute == 2 or info.sub_attribute == 6) then --> damage done & dps
		return self:SetInfoDamageDone()
	elseif (info.sub_attribute == 3) then --> damage taken
		return self:SetInfoDamageTaken()
	elseif (info.sub_attribute == 4) then --> friendly fire
		return self:SetInfoFriendlyFire()
	end
end

---------> DETALHES bloco da right BIFURCAÇÃO
function attribute_damage:SetDetails(spellid, bar)
	if (info.sub_attribute == 1 or info.sub_attribute == 2) then
		return self:SetDetailsDamageDone(spellid, bar)
	elseif (info.sub_attribute == 3) then
		return self:SetDetailsDamageTaken(spellid, bar)
	elseif (info.sub_attribute == 4) then
		return self:SetDetailsFriendlyFire(spellid, bar)
	elseif (info.sub_attribute == 6) then
		if (_bit_band(self.flag_original, 0x00000400) ~= 0) then --é um player
			return self:SetDetailsDamageDone(spellid, bar)
		end
		return self:SetDetailsEnemy(spellid, bar)
	end
end


------ Friendly Fire
function attribute_damage:SetInfoFriendlyFire()

	-- ESQUERDA -> JOGADORES ATINGIDOS - players que o player atingiu com o fogo amigo
	-- DIREITA -> MAGIAS USADAS - spells que o player usou para causar damage no amigo
	-- ALVOS -> overall de todas as spells, total de damage que elas causaram

	local FriendlyFireTotal = self.friendlyfire_total --> total de fogo amigo dado por this player
	local content = self.friendlyfire._ActorTable --> _ipairs[] com os names dos players em que this player deu damage
	
	local bars = info.bars1
	local bars2 = info.bars2
	local bars3 = info.bars3
	
	local instance = info.instance
	
	local DamagedPlayers = {}
	local Skills = {}
	
	for name, index in _pairs(self.friendlyfire._NameIndexTable) do --> da foreach em cada spellid do container
		local TargetActor = content[index]
		local TargetActorDamage = TargetActor.total
		_table_insert(DamagedPlayers, {name, TargetActorDamage, TargetActorDamage/FriendlyFireTotal*100, TargetActor.class})
		
		for spellid, ability in _pairs(TargetActor.spell_tables._ActorTable) do
			if (not Skills[spellid]) then 
				Skills[spellid] = ability.total
			else
				Skills[spellid] = Skills[spellid] + ability.total
			end
		end
	end
	
	_table_sort(DamagedPlayers, _details.Sort2)
	
	local amt = #DamagedPlayers
	gump:JI_UpdateContainerBars(amt)
	
	local FirstPlaceDamage = DamagedPlayers[1] and DamagedPlayers[1][2] or 0
	
	for index, table in _ipairs(DamagedPlayers) do
		local bar = bars[index]

		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
			bar.on_focus = false
		end
		
		if (not info.showing_mouse_over) then
			if (table[1] == self.details) then --> table[1] = NOME = NOME que this na caixa da right
				if (not bar.on_focus) then --> se a bar não tiver no focus
					bar.texture:SetStatusBarColor(129/255, 125/255, 69/255, 1)
					bar.on_focus = true
					if (not info.displaying) then
						info.displaying = bar
					end
				end
			else
				if (bar.on_focus) then
					bar.texture:SetStatusBarColor(1, 1, 1, 1) --> volta a cor antiga
					bar:SetAlpha(.9) --> volta a alfa antiga
					bar.on_focus = false
				end
			end
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/FirstPlaceDamage*100)
		end
		
		bar.text_left:SetText(index .. instance.dividers.placing .. table[1]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .. "(" .. _cstr("%.1f", table[3]) .."%)") --seta o text da right
		
		local class = table[4]
		if (not class) then
			class = "monster"
		end
		
		bar.icon:SetTexture(info.instance.row_info.icon_file)
		
		if (CLASS_ICON_TCOORDS[class]) then
			bar.icon:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[class]))
		else
			bar.icon:SetTexture(nil)
		end

		bar.my_table = self
		bar.show = table[1]
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
	end

	local SkillTable = {}
	for spellid, amt in _pairs(Skills) do
		local name, _, icon = _GetSpellInfo(spellid)
		SkillTable[#SkillTable+1] = {name, amt, amt/FriendlyFireTotal*100, icon}
	end

	_table_sort(SkillTable, _details.Sort2)	
	
	amt = #SkillTable
	if (amt < 1) then
		return
	end

	gump:JI_UpdateContainerTargets(amt)
	
	FirstPlaceDamage = SkillTable[1] and SkillTable[1][2] or 0
	
	for index, table in _ipairs(SkillTable) do
		local bar = bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/FirstPlaceDamage*100)
		end
		
		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .."(" .._cstr("%.1f", table[3]) .. ")") --seta o text da right
		bar.icon:SetTexture(table[4])
		
		bar.my_table = nil --> desactive o tooltip
	
		bar:Show()
	end
	
end

------ Damage Taken
function attribute_damage:SetInfoDamageTaken()

	local damage_taken = self.damage_taken
	local agressores = self.damage_from
	local instance = info.instance
	local combat_table = instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	local bars = info.bars1	
	local mine_agressores = {}
	
	local this_agressor	
	for name, _ in _pairs(agressores) do
		this_agressor = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_agressor) then
			local targets = this_agressor.targets
			local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
			if (this_dst) then
				mine_agressores[#mine_agressores+1] = {name, this_dst.total, this_dst.total/damage_taken*100, this_agressor.class}
			end
		end
	end

	local amt = #mine_agressores
	
	if (amt < 1) then --> caso houve apenas friendly fire
		return true
	end
	
	--_table_sort(mine_agressores, function(a, b) return a[2] > b[2] end)
	_table_sort(mine_agressores, _details.Sort2)
	
	gump:JI_UpdateContainerBars(amt)

	local max_ = mine_agressores[1] and mine_agressores[1][2] or 0

	local bar
	for index, table in _ipairs(mine_agressores) do
		bar = bars[index]
		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
		end

		self:FocusLock(bar, table[1])
		
		local texCoords = CLASS_ICON_TCOORDS[table[4]]
		if (not texCoords) then
			texCoords = _details.class_coords["UNKNOW"]
		end
		
		self:UpdadeInfoBar(bar, index, table[1], table[1], table[2], _details:comma_value(table[2]), max_, table[3], "Interface\\AddOns\\Details\\images\\classes_small", true, texCoords)
	end
	
end

--[[exported]] function _details:UpdadeInfoBar(row, index, spellid, name, value, value_formated, max, percent, icon, details, texCoords)
	--> seta o tamanho da bar
	if (index == 1) then
		row.texture:SetValue(100)
	else
		row.texture:SetValue(value/max*100)
	end
	
	--end
	row.text_left:SetText(index.."."..name)
	--> seta o text da right
	row.text_right:SetText(value_formated .. "(" .. _cstr("%.1f", percent) .."%)")
	
	--> seta o icon
	if (icon) then 
		row.icon:SetTexture(icon)
		if (icon == "Interface\\AddOns\\Details\\images\\classes_small") then
			row.icon:SetTexCoord(0.25, 0.49609375, 0.75, 1)
		else
			row.icon:SetTexCoord(0, 1, 0, 1)
		end
	else
		row.icon:SetTexture("")
	end
	
	if (texCoords) then
		row.icon:SetTexCoord(unpack(texCoords))
	end
	
	row.my_table = self
	row.show = spellid
	row:Show() --> mostra a bar
	
	if (details and self.details and self.details == spellid and info.showing == index) then
		--self:SetDetails(spellid, row) --> poderia deixar isso pro final e preparer uma tail call??
		self:SetDetails(row.show, row, info.instance) --> poderia deixar isso pro final e preparer uma tail call??
	end
end

--[[exported]] function _details:FocusLock(row, spellid)
	if (not info.showing_mouse_over) then
		if (spellid == self.details) then --> table[1] = spellid = spellid que this na caixa da right
			if (not row.on_focus) then --> se a bar não tiver no focus
				row.texture:SetStatusBarColor(129/255, 125/255, 69/255, 1)
				row.on_focus = true
				if (not info.displaying) then
					info.displaying = row
				end
			end
		else
			if (row.on_focus) then
				row.texture:SetStatusBarColor(1, 1, 1, 1) --> volta a cor antiga
				row:SetAlpha(.9) --> volta a alfa antiga
				row.on_focus = false
			end
		end
	end
end

------ Damage Done & Dps
function attribute_damage:SetInfoDamageDone()

	local bars = info.bars1
	local instance = info.instance
	local total = self.total_without_pet --> total de damage aplicado por this player 
	
	local ActorTotalDamage = self.total
	local ActorSkillsSortTable = {}
	local ActorSkillsContainer = self.spell_tables._ActorTable
	
	--get time type
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	for _spellid, _skill in _pairs(ActorSkillsContainer) do --> da foreach em cada spellid do container
		local name, _, icon = _GetSpellInfo(_spellid)
		_table_insert(ActorSkillsSortTable, {_spellid, _skill.total, _skill.total/ActorTotalDamage*100, name, icon})
	end

	--> add pets
	local ActorPets = self.pets
	--local class_color = RAID_CLASS_COLORS[self.class] and RAID_CLASS_COLORS[self.class].colorStr
	local class_color = "FFDDDDDD"
	for _, PetName in _ipairs(ActorPets) do
		local PetActor = instance.showing(class_type, PetName)
		if (PetActor) then 
			local PetSkillsContainer = PetActor.spell_tables._ActorTable
			for _spellid, _skill in _pairs(PetSkillsContainer) do --> da foreach em cada spellid do container
				local name, _, icon = _GetSpellInfo(_spellid)
				_table_insert(ActorSkillsSortTable, {_spellid, _skill.total, _skill.total/ActorTotalDamage*100, name .. "(|c" .. class_color .. PetName:gsub((" <.*"), "") .. "|r)", icon, PetActor})
			end
			--_table_insert(ActorSkillsSortTable, {PetName, PetActor.total, PetActor.total/ActorTotalDamage*100, PetName:gsub((" <.*"), ""), "Interface\\AddOns\\Details\\images\\classes_small"})
		end
	end
	
	_table_sort(ActorSkillsSortTable, _details.Sort2)

	gump:JI_UpdateContainerBars(#ActorSkillsSortTable)

	local max_ = ActorSkillsSortTable[1] and ActorSkillsSortTable[1][2] or 0 --> damage que a primeiro spell vez

	local bar
	for index, table in _ipairs(ActorSkillsSortTable) do
		bar = bars[index]
		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
		end

		self:FocusLock(bar, table[1])
		
		bar.other_actor = table[6]

		if (info.sub_attribute == 2) then
			self:UpdadeInfoBar(bar, index, table[1], table[4], table[2], _details:comma_value(_math_floor(table[2]/mine_time)), max_, table[3], table[5], true)
		else
			self:UpdadeInfoBar(bar, index, table[1], table[4], table[2], _details:comma_value(table[2]), max_, table[3], table[5], true)
		end

	end
	
	--> TOP INIMIGOS
	if (instance.sub_attribute == 6) then
	
		local damage_taken = self.damage_taken
		local agressores = self.damage_from
		local combat_table = instance.showing
		local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
		local bars = info.bars2
		local mine_agressores = {}
		
		local this_agressor	
		for name, _ in _pairs(agressores) do
			this_agressor = showing._ActorTable[showing._NameIndexTable[name]]
			if (this_agressor) then
				local targets = this_agressor.targets
				local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
				if (this_dst) then
					mine_agressores[#mine_agressores+1] = {name, this_dst.total, this_dst.total/damage_taken*100, this_agressor.class}
				end
			end
		end

		local amt = #mine_agressores
		
		if (amt < 1) then --> caso houve apenas friendly fire
			return true
		end
		
		gump:JI_UpdateContainerTargets(amt)
		
		--_table_sort(mine_agressores, function(a, b) return a[2] > b[2] end)
		_table_sort(mine_agressores, _details.Sort2)
		
		local max_ = mine_agressores[1] and mine_agressores[1][2] or 0 --> damage que a primeiro spell vez
		
		local bar
		for index, table in _ipairs(mine_agressores) do
			bar = bars[index]

			if (not bar) then --> se a bar não existir, create ela então
				bar = gump:CreateNewBarInfo2(instance, index)
				bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
			end
			
			if (index == 1) then
				bar.texture:SetValue(100)
			else
				bar.texture:SetValue(table[2]/max_*100)
			end

			bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
			bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .. _cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right
			
			bar.icon:SetTexture([[Interface\AddOns\Details\images\classes_small]]) --CLASSE
			
			local texCoords = _details.class_coords[table[4]]
			if (not texCoords) then
				texCoords = _details.class_coords["UNKNOW"]
			end
			bar.icon:SetTexCoord(_unpack(texCoords))
			
			_details:name_space_info(bar)
			
			if (bar.mouse_over) then --> atualizar o tooltip
				if (bar.isTarget) then
					GameTooltip:Hide() 
					GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
					if (not bar.my_table:SetTooltipDamageTaken(bar, index)) then
						return
					end
					GameTooltip:Show()
				end
			end
			
			bar.my_table = self --> grava o player na table
			bar.name_enemy = table[1] --> salva o name do enemy na bar --> isso é necessário?
			
			-- no place do spell id colocar o que?
			bar.spellid = "enemies"

			bar:Show() --> mostra a bar
		end
	else
		local mine_enemies = {}
		
		--> my target container
		content = self.targets._ActorTable
		for _, table in _ipairs(content) do
			_table_insert(mine_enemies, {table.name, table.total, table.total/total*100})
		end
		
		--> sort
		_table_sort(mine_enemies, function(a, b) return a[2] > b[2] end )	
		
		local amt_targets = #mine_enemies
		if (amt_targets < 1) then
			return
		end
		
		gump:JI_UpdateContainerTargets(amt_targets)
		
		local max_enemies = mine_enemies[1] and mine_enemies[1][2] or 0
		
		local bar
		for index, table in _ipairs(mine_enemies) do
		
			bar = info.bars2[index]
			
			if (not bar) then
				bar = gump:CreateNewBarInfo2(instance, index)
				bar.texture:SetStatusBarColor(1, 1, 1, 1)
			end
			
			if (index == 1) then
				bar.texture:SetValue(100)
			else
				bar.texture:SetValue(table[2]/max_enemies*100)
			end
			
			bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
			if (info.sub_attribute == 2) then
				bar.text_right:SetText(_details:comma_value( _math_floor(table[2]/mine_time)) .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .. instance.dividers.close) --seta o text da right
			else
				bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .. instance.dividers.close) --seta o text da right
			end
			
			if (bar.mouse_over) then --> atualizar o tooltip
				if (bar.isTarget) then
					GameTooltip:Hide() 
					GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
					if (not bar.my_table:SetTooltipTargets(bar, index, instance)) then
						return
					end
					GameTooltip:Show()
				end
			end
			
			bar.my_table = self --> grava o player na table
			bar.name_enemy = table[1] --> salva o name do enemy na bar --> isso é necessário?
			
			-- no place do spell id colocar o que?
			bar.spellid = table[5]
			bar:Show()
		end
	end
end


------ Detail Info Friendly Fire
function attribute_damage:SetDetailsFriendlyFire(name, bar)

	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	local bars = info.bars3
	local instance = info.instance
	
	local combat_table = info.instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable

	--> será apresentada as spells que deram damage no player dst
	
	local friendlyfire = self.friendlyfire

	local total = friendlyfire._ActorTable[friendlyfire._NameIndexTable[name]].total
	local content = friendlyfire._ActorTable[friendlyfire._NameIndexTable[name]].spell_tables._ActorTable --> assumindo que name é o name do Target que tomou damage // bastaria pegar a table de abilities dele

	local my_spells = {}

	for spellid, table in _pairs(content) do --> da foreach em cada spellid do container
		local name, _, icon = _GetSpellInfo(spellid)
		_table_insert(my_spells, {spellid, table.total, table.total/total*100, name, icon})
	end

	_table_sort(my_spells, function(a, b) return a[2] > b[2] end)

	--local amt = #my_spells
	--gump:JI_UpdateContainerBars(amt)

	local max_ = my_spells[1] and my_spells[1][2] or 0 --> damage que a primeiro spell vez
	
	local bar
	for index, table in _ipairs(my_spells) do
		bar = bars[index]

		if (not bar) then --> se a bar não existir, create ela então
			bar = gump:CreateNewBarInfo3(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end

		bar.text_left:SetText(index..instance.dividers.placing..table[4]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .. " " .. instance.dividers.open .. _cstr("%.1f", table[3]) .. "%" .. instance.dividers.close) --seta o text da right
		
		bar.icon:SetTexture(table[5])
		bar.icon:SetTexCoord(0, 1, 0, 1)
		
		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
	
end

-- details info enemies
function attribute_damage:SetDetailsEnemy(spellid, bar)
	
	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	local container = info.instance.showing[1]
	local bars = info.bars3
	local instance = info.instance
	local spell = self.spell_tables:CatchSpell(spellid)
	if (not spell) then return; end
	local targets = spell.targets._ActorTable
	local target_pool = {}
	
	for _, target in _ipairs(targets) do	
		local class
		local this_actor = info.instance.showing(1, target.name)
		if (this_actor) then
			class = this_actor.class or "UNKNOW"
		else
			class = "UNKNOW"
		end

		target_pool[#target_pool+1] = {target.name, target.total, class}
	end
	
	_table_sort(target_pool, _details.Sort2)
	
	local max_ = target_pool[1] and target_pool[1][2] or 0
	
	local bar
	for index, table in _ipairs(target_pool) do
		bar = bars[index]

		if (not bar) then --> se a bar não existir, create ela então
			bar = gump:CreateNewBarInfo3(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end

		bar.text_left:SetText(index .. ". " .. table[1]) --seta o text da esqueda
		_details:name_space_info(bar)
		
		if (spell.total > 0) then
			bar.text_right:SetText(_details:comma_value(table[2]) .."(".. _cstr("%.1f", table[2] / spell.total * 100) .."%)") --seta o text da right
		else
			bar.text_right:SetText(table[2] .."(0%)") --seta o text da right
		end
		
		local texCoords = _details.class_coords[table[3]]
		if (not texCoords) then
			texCoords = _details.class_coords["UNKNOW"]
		end
		
		bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\classes_small")
		bar.icon:SetTexCoord(unpack(texCoords))

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
	
end

------ Detail Info Damage Taken
function attribute_damage:SetDetailsDamageTaken(name, bar)

	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	local bars = info.bars3
	local instance = info.instance
	
	local combat_table = info.instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable

	local this_agressor = showing._ActorTable[showing._NameIndexTable[name]]
	
	if (not this_agressor ) then 
		--print("EROO this agressor eh NIL")
		return
	end
	
	local content = this_agressor.spell_tables._ActorTable --> _pairs[] com os IDs das spells
	
	local actor = info.player.name
	
	local total = this_agressor.targets._ActorTable[this_agressor.targets._NameIndexTable[actor]].total

	local my_spells = {}

	for spellid, table in _pairs(content) do --> da foreach em cada spellid do container
	
		--> preciso pegar os targets que this spell atingiu
		local targets = table.targets
		local index = targets._NameIndexTable[actor]
		
		if (index) then --> this spell deu damage no actor
			local this_dst = targets._ActorTable[index] --> pega a class_target
			local spell_name, rank, icon = _GetSpellInfo(spellid)
			_table_insert(my_spells, {spellid, this_dst.total, this_dst.total/total*100, spell_name, icon})
		end

	end

	_table_sort(my_spells, function(a, b) return a[2] > b[2] end)

	--local amt = #my_spells
	--gump:JI_UpdateContainerBars(amt)

	local max_ = my_spells[1] and my_spells[1][2] or 0 --> damage que a primeiro spell vez
	
	local bar
	for index, table in _ipairs(my_spells) do
		bar = bars[index]

		if (not bar) then --> se a bar não existir, create ela então
			bar = gump:CreateNewBarInfo3(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end

		bar.text_left:SetText(index..instance.dividers.placing..table[4]) --seta o text da esqueda
		_details:name_space_info(bar)
		
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right
		
		bar.icon:SetTexture(table[5])
		bar.icon:SetTexCoord(0, 1, 0, 1)

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
	
end

------ Detail Info Damage Done e Dps
function attribute_damage:SetDetailsDamageDone(spellid, bar, instance)

	if (_type(spellid) == "string") then 
	
		local _bar = info.groups_details[1]
		
		if (not _bar.pet) then 
			_bar.bg.PetIcon = _bar.bg:CreateTexture(nil, "overlay")
			
			--_bar.bg.PetIcon:SetTexture("Interface\\ICONS\\Ability_Druid_SkinTeeth")
			_bar.bg.PetIcon:SetTexture("Interface\\AddOns\\Details\\images\\classes")
			_bar.bg.PetIcon:SetTexCoord(0.25, 0.49609375, 0.75, 1)

			_bar.bg.PetIcon:SetPoint("left", _bar.bg, "left", 2, 2)
			_bar.bg.PetIcon:SetWidth(40)
			_bar.bg.PetIcon:SetHeight(40)
			gump:NewLabel(_bar.bg, _bar.bg, nil, "PetText", Loc["STRING_ISA_PET"], "GameFontHighlightLeft")
			_bar.bg.PetText:SetPoint("topleft", _bar.bg.PetIcon, "topright", 10, -2)
			gump:NewLabel(_bar.bg, _bar.bg, nil, "PetDps", "", "GameFontNormalSmall")
			_bar.bg.PetDps:SetPoint("left", _bar.bg.PetIcon, "right", 10, 2)
			_bar.bg.PetDps:SetPoint("top", _bar.bg.PetText, "bottom", 0, -5)
			_bar.pet = true
		end
		
		_bar.IsPet = true
		_bar.bg:SetValue(100)
		gump:Fade(_bar.bg.overlay, "OUT")
		_bar.bg:SetStatusBarColor(1, 1, 1)
		_bar.bg_end:SetPoint("LEFT", _bar.bg, "LEFT",(_bar.bg:GetValue()*2.19)-6, 0)
		_bar.bg.PetIcon:SetVertexColor(_unpack(_details.class_colors[self.class]))
		_bar.bg:Show()
		_bar.bg.PetIcon:Show()
		_bar.bg.PetText:Show()
		_bar.bg.PetDps:Show()
		
		local PetActor = info.instance.showing(info.instance.attribute, spellid)
		
		if (PetActor) then 
			local OwnerActor = PetActor.ownerName
			if (OwnerActor) then --> nor necessary
				OwnerActor = info.instance.showing(info.instance.attribute, OwnerActor)
				if (OwnerActor) then 
					local mine_time = OwnerActor:Time()
					local normal_dmg = PetActor.total
					local T =(mine_time*normal_dmg)/PetActor.total
					_bar.bg.PetDps:SetText("Dps: " .. _cstr("%.1f", normal_dmg/T))
				end
			end
		
		end
		
		for i = 2, 5 do
			gump:HidaDetailInfo(i)
		end
		
		local ThisBox = _details.window_info.groups_details[1]
		ThisBox.name:Hide()
		ThisBox.damage:Hide()
		ThisBox.damage_percent:Hide()
		ThisBox.damage_media:Hide()
		ThisBox.damage_dps:Hide()
		ThisBox.name2:Hide()

		return
	end
	
	local this_spell
	if (bar.other_actor) then
		this_spell = bar.other_actor.spell_tables._ActorTable[spellid]
	else
		this_spell = self.spell_tables._ActorTable[spellid]
	end

	if (not this_spell) then
		return
	end
	
	--> icon direito superior
	local name, rank, icon = _GetSpellInfo(spellid)
	local infospell = {name, rank, icon}

	_details.window_info.spell_icon:SetTexture(infospell[3])

	local total = self.total
	
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	local total_hits = this_spell.counter
	
	local index = 1
	
	local data = {}
	
	--print(debugstack())
	
	--> GENERAL
		local media = this_spell.total/total_hits
		
		local this_dps = nil
		if (this_spell.counter > this_spell.c_amt) then
			this_dps = Loc["STRING_DPS"]..": ".._cstr("%.1f", this_spell.total/mine_time)
		else
			this_dps = Loc["STRING_DPS"]..": "..Loc["STRING_SEE_BELOW"]
		end
		
		gump:SetaDetailInfoText( index, 100,
			Loc["STRING_GENERAL"],
			Loc["STRING_DAMAGE"]..": ".._details:ToK(this_spell.total), 
			Loc["STRING_PERCENTAGE"]..": ".._cstr("%.1f", this_spell.total/total*100) .. "%", 
			Loc["STRING_MEDIA"]..": " .. _cstr("%.1f", media), 
			this_dps,
			Loc["STRING_HITS"]..": " .. total_hits)
	
	--> NORMAL
		local normal_hits = this_spell.n_amt
		if (normal_hits > 0) then
			local normal_dmg = this_spell.n_dmg
			local media_normal = normal_dmg/normal_hits
			local T =(mine_time*normal_dmg)/this_spell.total
			local P = media/media_normal*100
			T = P*T/100

			data[#data+1] = {
				this_spell.n_amt, 
				normal_hits/total_hits*100, 
				Loc["STRING_NORMAL_HITS"],
				Loc["STRING_MINIMUM"]..": ".._details:comma_value(this_spell.n_min),
				Loc["STRING_MAXIMUM"]..": ".._details:comma_value(this_spell.n_max), 
				Loc["STRING_MEDIA"]..": ".._cstr("%.1f", media_normal), 
				Loc["STRING_DPS"]..": ".._cstr("%.1f", normal_dmg/T), 
				normal_hits.. " / ".._cstr("%.1f", normal_hits/total_hits*100).."%"
				}
		end

	--> CRITICAL
		if (this_spell.c_amt > 0) then	
			local media_critical = this_spell.c_dmg/this_spell.c_amt
			local T =(mine_time*this_spell.c_dmg)/this_spell.total
			local P = media/media_critical*100
			T = P*T/100
			local crit_dps = this_spell.c_dmg/T
			if (not crit_dps) then
				crit_dps = 0
			end
			
			data[#data+1] = {
				this_spell.c_amt,
				this_spell.c_amt/total_hits*100, 
				Loc["STRING_CRITICAL_HITS"], 
				Loc["STRING_MINIMUM"]..": ".._details:comma_value(this_spell.c_min),
				Loc["STRING_MAXIMUM"]..": ".._details:comma_value(this_spell.c_max),
				Loc["STRING_MEDIA"]..": ".._cstr("%.1f", media_critical), 
				Loc["STRING_DPS"]..": ".._cstr("%.1f", crit_dps),
				this_spell.c_amt.. " / ".._cstr("%.1f", this_spell.c_amt/total_hits*100).."%"
				}
		end
		
	--> Outros misses: GLACING, resisted, blocked, absorbed
		local others_deviations = this_spell.g_amt + this_spell.r_amt + this_spell.b_amt + this_spell.a_amt
		
		if (others_deviations > 0) then
			local percentage_defenses = others_deviations/total_hits*100
			data[#data+1] = {
				others_deviations,
				{["p"] = percentage_defenses,["c"] = {117/255, 58/255, 0/255}},
				Loc["STRING_DEFENSES"], 
				Loc["STRING_GLANCING"]..": "..this_spell.g_amt.." / ".._math_floor(this_spell.g_amt/this_spell.counter*100).."%", --this_spell.g_dmg
				Loc["STRING_RESISTED"]..": "..this_spell.r_dmg, --this_spell.resisted.amt.." / "..
				Loc["STRING_ABSORBED"]..": "..this_spell.a_dmg, --this_spell.absorbed.amt.." / "..
				Loc["STRING_BLOCKED"]..": "..this_spell.b_amt.." / "..this_spell.b_dmg,
				others_deviations.." / ".._cstr("%.1f", percentage_defenses).."%"
				}
		end
		
	--> Erros de Ataque	--ability.missType  -- {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"}
		local miss = this_spell["MISS"] or 0
		local parry = this_spell["PARRY"] or 0
		local dodge = this_spell["DODGE"] or 0
		local misses = miss + parry + dodge
		
		if (misses > 0) then
			local percentage_misses = misses/total_hits*100
			data[#data+1] = { 
				misses,
				{["p"] = percentage_misses,["c"] = {0.5, 0.1, 0.1}},
				Loc["STRING_FAIL_ATTACKS"], 
				Loc["STRING_MISS"]..": "..miss,
				Loc["STRING_PARRY"]..": "..parry,
				Loc["STRING_DODGE"]..": "..dodge,
				"",
				misses.." / ".._cstr("%.1f", percentage_misses).."%"
				}
		end

	table.sort(data, function(a, b) return a[1] > b[1] end)
	
	for index, table in _ipairs(data) do
		gump:SetaDetailInfoText(index+1, table[2], table[3], table[4], table[5], table[6], table[7], table[8])
	end
	
	for i = #data+2, 5 do
		gump:HidaDetailInfo(i)
	end
	
end

function attribute_damage:SetTooltipDamageTaken(this_bar, index)
	
	local aggressor = info.instance.showing[1]:CatchCombatant(_, this_bar.name_enemy)
	local container = aggressor.spell_tables._ActorTable
	local abilities = {}

	local total = 0
	
	for spellid, spell in _pairs(container) do 
		for _, actor in _ipairs(spell.targets._ActorTable) do 
			if (actor.name == self.name) then
				total = total + actor.total
				abilities[#abilities+1] = {spellid, actor.total, actor.name}
			end
		end
	end

	table.sort(abilities, function(a, b) return a[2] > b[2] end)
	
	GameTooltip:AddLine(index..". "..this_bar.name_enemy)
	GameTooltip:AddLine(Loc["STRING_DAMAGE_TAKEN_FROM2"]..":")
	GameTooltip:AddLine(" ")
	
	for index, table in _ipairs(abilities) do
		local name, rank, icon = _GetSpellInfo(table[1])
		if (index < 8) then
			GameTooltip:AddDoubleLine(index..". |T"..icon..":0|t "..name, _details:comma_value(table[2]).."(".._cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			--GameTooltip:AddTexture(icon)
		else
			GameTooltip:AddDoubleLine(index..". "..name, _details:comma_value(table[2]).."(".._cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
		end
	end
	
	return true
	--GameTooltip:AddDoubleLine(mine_damages[i][4][1]..": ", mine_damages[i][2].."(".._cstr("%.1f", mine_damages[i][3]).."%)", 1, 1, 1, 1, 1, 1)
	
end

function attribute_damage:SetTooltipTargets(this_bar, index, instance)
	
	local enemy = this_bar.name_enemy
	local container = self.spell_tables._ActorTable
	local abilities = {}
	local total = self.total
	
	for spellid, table in _pairs(container) do
		local targets = table.targets._ActorTable
		for _, table in _ipairs(targets) do
			if (table.name == enemy) then
				local name, _, icon = _GetSpellInfo(spellid)
				abilities[#abilities+1] = {name, table.total, icon}
			end
		end
	end
	
	--> add pets
	local ActorPets = self.pets
	for _, PetName in _ipairs(ActorPets) do
		local PetActor = instance.showing(class_type, PetName)
		if (PetActor) then 
			local PetSkillsContainer = PetActor.spell_tables._ActorTable
			for _spellid, _skill in _pairs(PetSkillsContainer) do
				local targets = _skill.targets._ActorTable
				for _, table in _ipairs(targets) do
					if (table.name == enemy) then
						local name, _, icon = _GetSpellInfo(_spellid)
						abilities[#abilities+1] = {name .. "(" .. PetName:gsub((" <.*"), "") .. ")", table.total, icon}
					end
				end
			end
		end
	end	
	
	table.sort(abilities, function(a, b) return a[2] > b[2] end)
	
	--get time type
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	local is_dps = info.instance.sub_attribute == 2
	
	if (is_dps) then
		GameTooltip:AddLine(index..". "..enemy)
		GameTooltip:AddLine(Loc["STRING_DAMAGE_DPS_IN"] .. ":")
		GameTooltip:AddLine(" ")
	else
		GameTooltip:AddLine(index..". "..enemy)
		GameTooltip:AddLine(Loc["STRING_DAMAGE_FROM"] .. ":")
		GameTooltip:AddLine(" ")
	end

	for index, table in _ipairs(abilities) do
		
		if (index < 8) then
			if (is_dps) then
				GameTooltip:AddDoubleLine(index..". |T"..table[3]..":0|t "..table[1], _details:comma_value( _math_floor(table[2] / mine_time) ).."(".._cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			else
				GameTooltip:AddDoubleLine(index..". |T"..table[3]..":0|t "..table[1], _details:comma_value(table[2]).."(".._cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			end
		else
			if (is_dps) then
				GameTooltip:AddDoubleLine(index..". "..table[1], _details:comma_value( _math_floor(table[2] / mine_time) ).."(".._cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			else
				GameTooltip:AddDoubleLine(index..". "..table[1], _details:comma_value(table[2]).."(".._cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			end
		end
	end
	
	return true
	--GameTooltip:AddDoubleLine(mine_damages[i][4][1]..": ", mine_damages[i][2].."(".._cstr("%.1f", mine_damages[i][3]).."%)", 1, 1, 1, 1, 1, 1)
	
end

--controla se o dps do player this travado ou destravado
function attribute_damage:Initialize(initialize)
	if (initialize == nil) then 
		return self.dps_started --retorna se o dps this aberto ou closedo para this player
	elseif (initialize) then
		self.dps_started = true
		self:RegisterInTimeMachine() --coloca ele da timeMachine
		if (self.shadow) then
			self.shadow.dps_started = true --> isso foi posto recentemente
			--self.shadow:RegisterInTimeMachine()
		end
	else
		self.dps_started = false
		self:UnregisterInTimeMachine() --retira ele da timeMachine
		if (self.shadow) then
			--self.shadow:UnregisterInTimeMachine()
			self.shadow.dps_started = false --> isso foi posto recentemente
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> limpa as tables timerárias ao reset
		function attribute_damage:ClearTempTables()
			for i = #ntable, 1, -1 do
				ntable[i] = nil
			end
			for i = #vtable, 1, -1 do
				vtable[i] = nil
			end
		end

	--> atualize a func de opsendcao
		function attribute_damage:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
			TooltipMaximizedMethod = _details.tooltip.maximize_method
		end

	--> diminui o total das tables do combat
		function attribute_damage:subtract_total(combat_table)
			combat_table.totals[class_type] = combat_table.totals[class_type] - self.total
			if (self.group) then
				combat_table.totals_group[class_type] = combat_table.totals_group[class_type] - self.total
			end
		end
		function attribute_damage:add_total(combat_table)
			combat_table.totals[class_type] = combat_table.totals[class_type] + self.total
			if (self.group) then
				combat_table.totals_group[class_type] = combat_table.totals_group[class_type] + self.total
			end
		end
		
	--> restore a table de last event
		function attribute_damage:r_last_events_table(actor)
			if (not actor) then
				actor = self
			end
			--actor.last_events_table = _details:CreateActorLastEventTable()
		end
		
	--> restore e liga o ator com a sua shadow durante a inicialização(startup function)
		function attribute_damage:r_onlyrefresh_shadow(actor)
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_damage = _details.table_overall[1]
				local shadow = overall_damage._ActorTable[overall_damage._NameIndexTable[actor.name]]
				
				if (not shadow) then 
					shadow = overall_damage:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end

			--> restore a meta e indexes ao ator
			_details.refresh:r_attribute_damage(actor, shadow)
			
			--> copia o container de targets(captura de dados)
				for index, dst in _ipairs(actor.targets._ActorTable) do 
					--> cria e soma o valor do total
					local dst_shadow = shadow.targets:CatchCombatant(nil, dst.name, nil, true)
					--> refresh no dst
					_details.refresh:r_dst_of_ability(dst, shadow.targets)
				end
				
			--> copia o container de abilities(captura de dados)
				for spellid, ability in _pairs(actor.spell_tables._ActorTable) do 
					--> cria e soma o valor
					local ability_shadow = shadow.spell_tables:CatchSpell(spellid, true, nil, true)
					--> refresh e soma os valores dos targets
					for index, dst in _ipairs(ability.targets._ActorTable) do 
						--> cria e soma o valor do total
						local dst_shadow = ability_shadow.targets:CatchCombatant(nil, dst.name, nil, true)
						--> refresh no dst da ability
						_details.refresh:r_dst_of_ability(dst, ability_shadow.targets)
					end
					
					--> refresh na ability
					_details.refresh:r_ability_damage(ability, shadow.spell_tables)
				end
				
			--> copia o container de friendly fire(captura de dados)
				for index, friendlyFire in _ipairs(actor.friendlyfire._ActorTable) do 
					--> cria ou pega a shadow
					local friendlyFire_shadow = shadow.friendlyfire:CatchCombatant(nil, friendlyFire.name, nil, true)
					--> refresh na table e no container de abilities
					_setmetatable(friendlyFire, _details)
					friendlyFire.shadow = friendlyFire_shadow

					for spellid, ability in _pairs(friendlyFire.spell_tables._ActorTable) do
						--> cria ou pega a ability no container de ability
						local ability_shadow = friendlyFire_shadow.spell_tables:CatchSpell(spellid, true, nil, true)
						--> refresh na ability
						_details.refresh:r_ability_damage(ability, friendlyFire_shadow.spell_tables)
					end
					--> refresh na meta e indexes
					_details.refresh:r_container_abilities(friendlyFire.spell_tables, friendlyFire_shadow.spell_tables)
				end
			
			return shadow
		end
		
		function attribute_damage:r_connect_shadow(actor, no_refresh)
	
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_damage = _details.table_overall[1]
				local shadow = overall_damage._ActorTable[overall_damage._NameIndexTable[actor.name]]
				
				if (not shadow) then 
					shadow = overall_damage:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end

			--> restore a meta e indexes ao ator
			if (not no_refresh) then
				_details.refresh:r_attribute_damage(actor, shadow)
			end
			--> time elapsed(captura de dados)
				if (actor.end_time) then
					local time =(actor.end_time or time()) - actor.start_time
					shadow.start_time = shadow.start_time - time
				end
				
			--> total de damage(captura de dados)
				shadow.total = shadow.total + actor.total				
			--> total de damage sem o pet(captura de dados)
				shadow.total_without_pet = shadow.total_without_pet + actor.total_without_pet
			--> total de damage que o ator sofreu(captura de dados)
				shadow.damage_taken = shadow.damage_taken + actor.damage_taken
			--> total do friendly fire causado
				shadow.friendlyfire_total = shadow.friendlyfire_total + actor.friendlyfire_total

			--> total no combat overall(captura de dados)
				_details.table_overall.totals[1] = _details.table_overall.totals[1] + actor.total
				if (actor.group) then
					_details.table_overall.totals_group[1] = _details.table_overall.totals_group[1] + actor.total
				end
				
			--> copia o damage_from(captura de dados)
				for name, _ in _pairs(actor.damage_from) do 
					shadow.damage_from[name] = true
				end
			
			--> copia o container de targets(captura de dados)
				for index, dst in _ipairs(actor.targets._ActorTable) do 
					--> cria e soma o valor do total
					local dst_shadow = shadow.targets:CatchCombatant(nil, dst.name, nil, true)
					dst_shadow.total = dst_shadow.total + dst.total
					--> refresh no dst
					if (not no_refresh) then
						_details.refresh:r_dst_of_ability(dst, shadow.targets)
					end
				end
				
			--> copia o container de abilities(captura de dados)
				for spellid, ability in _pairs(actor.spell_tables._ActorTable) do 
					--> cria e soma o valor
					local ability_shadow = shadow.spell_tables:CatchSpell(spellid, true, nil, true)
					--> refresh e soma os valores dos targets
					for index, dst in _ipairs(ability.targets._ActorTable) do 
						--> cria e soma o valor do total
						local dst_shadow = ability_shadow.targets:CatchCombatant(nil, dst.name, nil, true)
						dst_shadow.total = dst_shadow.total + dst.total
						--> refresh no dst da ability
						if (not no_refresh) then
							_details.refresh:r_dst_of_ability(dst, ability_shadow.targets)
						end
					end
					--> soma todos os demais valores
					for key, value in _pairs(ability) do 
						if (_type(value) == "number") then
							if (key ~= "id") then
								if (not ability_shadow[key]) then 
									ability_shadow[key] = 0
								end
								ability_shadow[key] = ability_shadow[key] + value
							end
						end
					end
					
					--> refresh na ability
					if (not no_refresh) then
						_details.refresh:r_ability_damage(ability, shadow.spell_tables)
					end
				end
				
			--> copia o container de friendly fire(captura de dados)
				for index, friendlyFire in _ipairs(actor.friendlyfire._ActorTable) do 
					--> cria ou pega a shadow
					local friendlyFire_shadow = shadow.friendlyfire:CatchCombatant(nil, friendlyFire.name, nil, true)
					--> refresh na table e no container de abilities
					_setmetatable(friendlyFire, _details)
					friendlyFire.shadow = friendlyFire_shadow
					--> soma o total
					friendlyFire_shadow.total = friendlyFire_shadow.total + friendlyFire.total

					for spellid, ability in _pairs(friendlyFire.spell_tables._ActorTable) do
						--> cria ou pega a ability no container de ability
						local ability_shadow = friendlyFire_shadow.spell_tables:CatchSpell(spellid, true, nil, true)
						--> soma os valores
						ability_shadow.counter = ability_shadow.counter + ability.counter
						ability_shadow.total = ability_shadow.total + ability.total
						--> refresh na ability
						if (not no_refresh) then
							_details.refresh:r_ability_damage(ability, friendlyFire_shadow.spell_tables)
						end
					end
					--> refresh na meta e indexes
					if (not no_refresh) then
						_details.refresh:r_container_abilities(friendlyFire.spell_tables, friendlyFire_shadow.spell_tables)
					end
				end
			
			return shadow
		end

function attribute_damage:FF_creation_func(_, _, link)
	local table = _setmetatable({}, _details) --> mudei de _details para attribute_damage
	table.total = 0
	table.spell_tables = container_abilities:NewContainer(container_damage)
	if (link) then
		table.spell_tables.shadow = link.spell_tables
	end
	return table
end

function attribute_damage:CollectGarbage(lastevent)
	return _details:CollectGarbage(class_type, lastevent)
end

function _details.refresh:r_attribute_damage(this_player, shadow)

	--> restore metas do ator
		_setmetatable(this_player, _details.attribute_damage)
		this_player.__index = _details.attribute_damage
	--> atribui a shadow a ele
		this_player.shadow = shadow
	--> restore as metas dos container de targets, abilities e ff
		_details.refresh:r_container_combatants(this_player.targets, shadow.targets)
		_details.refresh:r_container_combatants(this_player.friendlyfire, shadow.friendlyfire)
		_details.refresh:r_container_abilities(this_player.spell_tables, shadow.spell_tables)
end

function _details.clear:c_attribute_damage(this_player)
	--this_player.__index = {}
	this_player.__index = nil
	this_player.shadow = nil
	this_player.links = nil
	this_player.my_bar = nil
	
	_details.clear:c_container_combatants(this_player.targets)
	_details.clear:c_container_abilities(this_player.spell_tables)
	_details.clear:c_attribute_damage_FF(this_player.friendlyfire)
end

function _details.clear:c_attribute_damage_FF(container)
	_details.clear:c_container_combatants(container)
	
	for _, _table in _ipairs(container._ActorTable) do 
		_table.__index = {}
		_table.shadow = nil
		
		local abilities = _table.spell_tables
		_details.clear:c_container_abilities(abilities)
		
		for _, ability in _pairs(abilities._ActorTable) do
			_details.clear:c_ability_damage(ability)
			--pode parar aqui, o container de targets não é usado no friendly fire
		end
	end	
end

attribute_damage.__add = function(table1, table2)

	--> time elapsed
		local time =(table2.end_time or time()) - table2.start_time
		table1.start_time = table1.start_time - time
	
	--> total de damage
		table1.total = table1.total + table2.total
	--> total de damage sem o pet
		table1.total_without_pet = table1.total_without_pet + table2.total_without_pet
	--> total de damage que o cara levou
		table1.damage_taken = table1.damage_taken + table2.damage_taken
	--> total do friendly fire causado
		table1.friendlyfire_total = table1.friendlyfire_total + table2.friendlyfire_total

	--> soma o damage_from
		for name, _ in _pairs(table2.damage_from) do 
			table1.damage_from[name] = true
		end
	
	--> soma os containers de targets
		for index, dst in _ipairs(table2.targets._ActorTable) do 
			--> pega o dst no ator
			local dst_table1 = table1.targets:CatchCombatant(nil, dst.name, nil, true)
			--> soma o valor
			dst_table1.total = dst_table1.total + dst.total
		end
		
	--> soma o container de abilities
		for spellid, ability in _pairs(table2.spell_tables._ActorTable) do 
			--> pega a ability no primeiro ator
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_DAMAGE", false)
			--> soma os targets
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			--> soma os valores da ability
			for key, value in _pairs(ability) do 
				if (_type(value) == "number") then
					if (key ~= "id") then
						if (not ability_table1[key]) then 
							ability_table1[key] = 0
						end
						ability_table1[key] = ability_table1[key] + value
					end
				end
			end
		end
	
	--> soma o container de friendly fire
		for index, friendlyFire in _ipairs(table2.friendlyfire._ActorTable) do 
			--> pega o ator ff no ator main
			local friendlyFire_table1 = table1.friendlyfire:CatchCombatant(nil, friendlyFire.name, nil, true)
			--> soma o total
			friendlyFire_table1.total = friendlyFire_table1.total + friendlyFire.total
			--> soma as abilities
			for spellid, ability in _pairs(friendlyFire.spell_tables._ActorTable) do
				local ability_table1 = friendlyFire_table1.spell_tables:CatchSpell(spellid, true, nil, false)
				ability_table1.counter = ability_table1.counter + ability.counter
				ability_table1.total = ability_table1.total + ability.total
			end
		end

	return table1
end

attribute_damage.__sub = function(table1, table2)

	--> time elapsed
		local time =(table2.end_time or time()) - table2.start_time
		table1.start_time = table1.start_time + time
	
	--> total de damage
		table1.total = table1.total - table2.total
	--> total de damage sem o pet
		table1.total_without_pet = table1.total_without_pet - table2.total_without_pet
	--> total de damage que o cara levou
		table1.damage_taken = table1.damage_taken - table2.damage_taken
	--> total do friendly fire causado
		table1.friendlyfire_total = table1.friendlyfire_total - table2.friendlyfire_total
		
	--> reduz os containers de targets
		for index, dst in _ipairs(table2.targets._ActorTable) do 
			--> pega o dst no ator
			local dst_table1 = table1.targets:CatchCombatant(nil, dst.name, nil, true)
			--> subtrai o valor
			dst_table1.total = dst_table1.total - dst.total
		end
		
	--> reduz o container de abilities
		for spellid, ability in _pairs(table2.spell_tables._ActorTable) do 
			--> pega a ability no primeiro ator
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_DAMAGE", false)
			--> soma os targets
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			--> subtrai os valores da ability
			for key, value in _pairs(ability) do 
				if (_type(value) == "number") then
					if (key ~= "id") then
						if (not ability_table1[key]) then 
							ability_table1[key] = 0
						end
						ability_table1[key] = ability_table1[key] - value
					end
				end
			end
		end
		
	--> reduz o container de friendly fire
		for index, friendlyFire in _ipairs(table2.friendlyfire._ActorTable) do 
			--> pega o ator ff no ator main
			local friendlyFire_table1 = table1.friendlyfire:CatchCombatant(nil, friendlyFire.name, nil, true)
			--> soma o total
			friendlyFire_table1.total = friendlyFire_table1.total - friendlyFire.total
			--> soma as abilities
			for spellid, ability in _pairs(friendlyFire.spell_tables._ActorTable) do
				local ability_table1 = friendlyFire_table1.spell_tables:CatchSpell(spellid, true, nil, false)
				ability_table1.counter = ability_table1.counter - ability.counter
				ability_table1.total = ability_table1.total - ability.total
			end
		end
	
	return table1
end

		--local cor = self.cor
		
		--this_bar.statusbar:SetStatusBarColor(cor[1], cor[2], cor[3], cor[4])
		
		--print(cor[1], cor[2], cor[3])
		--this_bar.texture:SetVertexColor(cor[1], cor[2], cor[3], cor[4])
		
		--local grayscale =(cor[1] + cor[2] + cor[3]) / 3.0 -- lightness
		
		-- local grayscale =(_math_max(cor[1], cor[2], cor[3]) + _math_min(cor[1], cor[2], cor[3])) / 2 -- average
		-- local grayscale = cor[1]*0.21 + cor[2]*0.71  + cor[3]*0.07
		--(max(R, G, B) + min(R, G, B)) / 2

		
		