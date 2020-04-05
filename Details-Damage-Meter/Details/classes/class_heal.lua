
--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _setmetatable = setmetatable
local _pairs = pairs
local _ipairs = ipairs
local _unpack = unpack
local _type = type
local _table_sort = table.sort
local _cstr = string.format
local _table_insert = table.insert
local _bit_band = bit.band
local _math_min = math.min
--api locals
local GetSpellInfo = GetSpellInfo
local _GetSpellInfo = _details.getspellinfo
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup
local _UnitName = UnitName
local _GetNumGroupMembers = GetNumGroupMembers

local _details = 		_G._details
local _

local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )

local gump = 			_details.gump

local dst_of_ability = 	_details.dst_of_ability
local container_abilities = 	_details.container_abilities
local container_combatants =	_details.container_combatants
local attribute_heal =		_details.attribute_heal
local ability_heal = 		_details.ability_heal

local container_playernpc = _details.container_type.CONTAINER_PLAYERNPC
local container_heal = _details.container_type.CONTAINER_HEAL_CLASS
local container_heal_target = _details.container_type.CONTAINER_HEALTARGET_CLASS

local mode_ALONE = _details.modes.alone
local mode_GROUP = _details.modes.group
local mode_ALL = _details.modes.all

local class_type = _details.attributes.heal

local DATA_TYPE_START = _details._details_props.DATA_TYPE_START
local DATA_TYPE_END = _details._details_props.DATA_TYPE_END

local div_open = _details.dividers.open
local div_close = _details.dividers.close
local div_place = _details.dividers.placing

local ToKFunctions = _details.ToKFunctions
local SelectedToKFunction = ToKFunctions[1]
local UsingCustomRightText = false
local UsingCustomLeftText = false

local FormatTooltipNumber = ToKFunctions[8]
local TooltipMaximizedMethod = 1

local info = _details.window_info
local keyName

function attribute_heal:Newtable(serial, name, link)

	local alphabetical = _details:GetOrderNumber(name)

	--> constructor
	local _new_healActor = {

		type = class_type, --> attribute 2 = heal
		
		total = alphabetical,
		totalover = alphabetical,
		totalabsorb = alphabetical,
		custom = 0,
		
		total_without_pet = alphabetical,
		totalover_without_pet = alphabetical,
		
		healing_taken = alphabetical, --> total de heal que this player recebeu
		healing_from = {}, --> armazena os names que deram heal nthis player

		initialize_hps = false,  --> dps_started
		last_event = 0,
		on_hold = false,
		delay = 0,
		last_value = nil, --> ultimo valor que this player teve, sdst quando a bar dele é atualizada
		last_hps = 0, --> heal por segundo

		end_time = nil,
		start_time = 0,

		pets = {}, --> name já formatado: pet name <owner name>
		
		heal_enemy = {}, --> quando o player heal um enemy
		heal_enemy_amt = 0,

		--container armazenará os IDs das abilities usadas por this player
		spell_tables = container_abilities:NewContainer(container_heal),
		
		--container armazenará os seriais dos targets que o player aplicou damage
		targets = container_combatants:NewContainer(container_heal_target)
	}
	
	_setmetatable(_new_healActor, attribute_heal)
	
	if (link) then --> se não for a shadow
		--_new_healActor.last_events_table = _details:CreateActorLastEventTable()
		--_new_healActor.last_events_table.original = true
	
		_new_healActor.targets.shadow = link.targets
		_new_healActor.spell_tables.shadow = link.spell_tables
	end
	
	return _new_healActor
end


function _details.SortGroupHeal(container, keyName2)
	keyName = keyName2
	return _table_sort(container, _details.SortKeyGroupHeal)
end

function _details.SortKeyGroupHeal(table1, table2)
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

function _details.SortKeySimpleHeal(table1, table2)
	return table1[keyName] > table2[keyName]
end

function _details:ContainerSortHeal(container, amount, keyName2)
	keyName = keyName2
	_table_sort(container,  _details.SortKeySimpleHeal)
	
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

function attribute_heal:ContainerRefreshHps(container, combat_time)

	local total = 0
	
	if (_details.time_type == 2 or not _details:CaptureGet("heal")) then
		for _, actor in _ipairs(container) do
			if (actor.group) then
				actor.last_hps = actor.total / combat_time
			else
				actor.last_hps = actor.total / actor:Time()
			end
			total = total + actor.last_hps
		end
	else
		for _, actor in _ipairs(container) do
			actor.last_hps = actor.total / actor:Time()
			total = total + actor.last_hps
		end
	end
	
	return total
end

function attribute_heal:ReportSingleDamagePreventedLine(actor, instance)
	local bar = instance.bars[actor.my_bar]

	local report = {"Details! " .. Loc["STRING_ATTRIBUTE_HEAL_PREVENT"].. ": " .. actor.name} --> localize-me
	for i = 1, GameCooltip:GetNumLines() do 
		local text_left, text_right = GameCooltip:GetText(i)
		if (text_left and text_right) then 
			text_left = text_left:gsub(("|T(.*)|t "), "")
			report[#report+1] = ""..text_left.." "..text_right..""
		end
	end

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

function attribute_heal:RefreshWindow(instance, combat_table, force, export)
	
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal

	--> não há bars para mostrar -- not have something to show
	if (#showing._ActorTable < 1) then --> não há bars para mostrar
		--> colocado isso recentemente para do as bars de damage sumirem na troca de attribute
		return _details:HideBarsNotUsed(instance, showing)
	end

	--> total
	local total = 0 
	--> top actor #1
	instance.top = 0
	
	local using_cache = false
	
	local sub_attribute = instance.sub_attribute --> o que this sendo mostrado nthis instância
	local content = showing._ActorTable
	local amount = #content
	local mode = instance.mode
	
	--> pega which a sub key que será usada
	if (export) then
	
		if (_type(export) == "boolean") then 
			if (sub_attribute == 1) then --> healing DONE
				keyName = "total"
			elseif (sub_attribute == 2) then --> HPS
				keyName = "last_hps"
			elseif (sub_attribute == 3) then --> overheal
				keyName = "totalover"
			elseif (sub_attribute == 4) then --> healing take
				keyName = "healing_taken"
			elseif (sub_attribute == 5) then --> enemy heal
				keyName = "heal_enemy_amt"
			elseif (sub_attribute == 6) then --> absorbs
				keyName = "totalabsorb"
			end
		else
			keyName = export.key
			mode = export.mode
		end
	elseif (instance.attribute == 5) then --> custom
		keyName = "custom"
		total = combat_table.totals[instance.customName]
	else	
		if (sub_attribute == 1) then --> healing DONE
			keyName = "total"
		elseif (sub_attribute == 2) then --> HPS
			keyName = "last_hps"
		elseif (sub_attribute == 3) then --> overheal
			keyName = "totalover"
		elseif (sub_attribute == 4) then --> healing take
			keyName = "healing_taken"
		elseif (sub_attribute == 5) then --> enemy heal
			keyName = "heal_enemy_amt"
		elseif (sub_attribute == 6) then --> absorbs
			keyName = "totalabsorb"
		end
	end

	if (instance.attribute == 5) then --> custom
		--> faz o sort da categoria e retorna o amount corrigido
		amount = _details:ContainerSortHeal(content, amount, keyName)
		
		--> grava o total
		instance.top = content[1][keyName]
	
	elseif (instance.mode == mode_ALL or sub_attribute == 5) then --> showing ALL
	
		amount = _details:ContainerSortHeal(content, amount, keyName)

		if (sub_attribute == 2) then --hps
			local combat_time = instance.showing:GetCombatTime()
			total = attribute_heal:ContainerRefreshHps(content, combat_time)
		else
			--> pega o total ja aplicado na table do combat
			total = combat_table.totals[class_type]
		end

		--> grava o total
		instance.top = content[1][keyName]
		
	elseif (instance.mode == mode_GROUP) then --> showing GROUP
	
		if (_details.in_combat and instance.segment == 0 and not export) then
			using_cache = true
		end
		
		if (using_cache) then
		
			content = _details.cache_healing_group

			if (sub_attribute == 2) then --> hps
				local combat_time = instance.showing:GetCombatTime()
				attribute_heal:ContainerRefreshHps(content, combat_time)
			end
			
			if (#content < 1) then
				return _details:HideBarsNotUsed(instance, showing)
			end
		
			_details:ContainerSortHeal(content, nil, keyName)
		
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
			if (sub_attribute == 2) then --> hps
				local combat_time = instance.showing:GetCombatTime()
				attribute_heal:ContainerRefreshHps(content, combat_time)
			end

			_details.SortGroupHeal(content, keyName)
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
	
	--> refaz o mapa do container
	--> se for cache não precisa remapear
	showing:remapear()

	if (export) then 
		return total, keyName, instance.top, amount
	end
	
	if (amount < 1) then --> não há bars para mostrar
		instance:HideScrollBar()
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	end

	instance:ActualizeScrollBar(amount)
	
	--depois faz a atualização normal dele através dos iterators
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

	-- showing.need_refresh = false
	return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	
end

function attribute_heal:Custom(_customName, _combat, sub_attribute, spell, dst)
	local _Skill = self.spell_tables._ActorTable[tonumber(spell)]
	if (_Skill) then
		local spellName = _GetSpellInfo(tonumber(spell))
		local SkillTargets = _Skill.targets._ActorTable
		
		for _, TargetActor in _ipairs(SkillTargets) do 
			local TargetActorSelf = _combat(class_type, TargetActor.name)
			if (TargetActorSelf) then
				TargetActorSelf.custom = TargetActor.total + TargetActorSelf.custom
				_combat.totals[_customName] = _combat.totals[_customName] + TargetActor.total
			end
		end
	end
end

local actor_class_color_r, actor_class_color_g, actor_class_color_b

--function attribute_heal:UpdateBar(instance, which_bar, place, total, sub_attribute, force)
function attribute_heal:UpdateBar(instance, bars_container, which_bar, place, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations)

	local this_bar = instance.bars[which_bar] --> pega a referência da bar na window
	
	if (not this_bar) then
		print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
		return
	end
	
	local table_previous = this_bar.my_table
	
	this_bar.my_table = self --grava uma referência dessa class de damage na bar
	self.my_bar = this_bar --> salva uma referência da bar no objeto do player
	
	this_bar.placing = place --> salva na bar which a colocação dela.
	self.placing = place --> salva which a colocação do player no objeto dele
	
	local healing_total = self.total --> total de damage que this player deu
	local hps
	
	--local percentage = self[keyName] / total * 100
	local percentage
	local this_percentage
	
	if (percentage_type == 1) then
		percentage = _cstr("%.1f", self[keyName] / total * 100)
	elseif (percentage_type == 2) then
		percentage = _cstr("%.1f", self[keyName] / instance.top * 100)
	end

	if ((_details.time_type == 2 and self.group) or(not _details:CaptureGet("heal") and not _details:CaptureGet("aura")) or not self.shadow) then
		if (not self.shadow and combat_time == 0) then
			local p = _details.table_current(2, self.name)
			if (p) then
				local t = p:Time()
				hps = healing_total / t
				self.last_hps = hps
			else
				hps = healing_total / combat_time
				self.last_hps = hps
			end
		else
			hps = healing_total / combat_time
			self.last_hps = hps
		end
	else -- /dump _details:GetCombat(2)(1, "Ditador").on_hold
		if (not self.on_hold) then
			hps = healing_total/self:Time() --calcula o dps dthis objeto
			self.last_hps = hps --salva o dps dele
		else
			hps = self.last_hps
			
			if (hps == 0) then --> não calculou o dps dele ainda mas entrou em standby
				hps = healing_total/self:Time()
				self.last_hps = hps
			end
		end
	end
	
	-- >>>>>>>>>>>>>>> text da right
	if (instance.attribute == 5) then --> custom
		this_bar.text_right:SetText(_details:ToK(self.custom) .. "(" .. percentage .. "%)") --seta o text da right
		this_percentage = _math_floor((self.custom/instance.top) * 100) --> determina which o tamanho da bar
	else	
		if (sub_attribute == 1) then --> showing healing done
		
			hps = _math_floor(hps)
			local formated_heal = SelectedToKFunction(_, healing_total)
			local formated_hps = SelectedToKFunction(_, hps)
		
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_heal, formated_hps, percentage, self))
			else
				this_bar.text_right:SetText(formated_heal .."(" .. formated_hps .. ", " .. percentage .. "%)") --seta o text da right
			end
			this_percentage = _math_floor((healing_total/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 2) then --> showing hps
		
			hps = _math_floor(hps)
			local formated_heal = SelectedToKFunction(_, healing_total)
			local formated_hps = SelectedToKFunction(_, hps)
			
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_hps, formated_heal, percentage, self))
			else			
				this_bar.text_right:SetText(formated_hps .. "(" .. formated_heal .. ", " .. percentage .. "%)") --seta o text da right
			end
			this_percentage = _math_floor((hps/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 3) then --> showing overall
		
			local formated_overheal = SelectedToKFunction(_, self.totalover)
			
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_overheal, "", percentage, self))
			else
				this_bar.text_right:SetText(formated_overheal .."(" .. percentage .. "%)") --seta o text da right --_cstr("%.1f", dps) .. " - ".. DPS do damage taken não será possivel correto?
			end
			this_percentage = _math_floor((self.totalover/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 4) then --> showing healing take
		
			local formated_healtaken = SelectedToKFunction(_, self.healing_taken)
			
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_healtaken, "", percentage, self))
			else		
				this_bar.text_right:SetText(formated_healtaken .. "(" .. percentage .. "%)") --seta o text da right --_cstr("%.1f", dps) .. " - ".. DPS do damage taken não será possivel correto?
			end
			this_percentage = _math_floor((self.healing_taken/instance.top) * 100) --> determina which o tamanho da bar
		
		elseif (sub_attribute == 5) then --> showing enemy heal
		
			local formated_enemyheal = SelectedToKFunction(_, self.heal_enemy_amt)
		
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_enemyheal, "", percentage, self))
			else
				this_bar.text_right:SetText(formated_enemyheal .. "(" .. percentage .. "%)") --seta o text da right --_cstr("%.1f", dps) .. " - ".. DPS do damage taken não será possivel correto?
			end
			this_percentage = _math_floor((self.heal_enemy_amt/instance.top) * 100) --> determina which o tamanho da bar
			
		elseif (sub_attribute == 6) then --> showing damage prevented
		
			local formated_absorbs = SelectedToKFunction(_, self.totalabsorb)
		
			if (UsingCustomRightText) then
				this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_absorbs, "", percentage, self))
			else
				this_bar.text_right:SetText(formated_absorbs .. "(" .. percentage .. "%)") --seta o text da right --_cstr("%.1f", dps) .. " - ".. DPS do damage taken não será possivel correto?
			end
			this_percentage = _math_floor((self.totalabsorb/instance.top) * 100) --> determina which o tamanho da bar
		end
	end
	
	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)	
end

function attribute_heal:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
	
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

function attribute_heal:RefreshBar(this_bar, instance, from_resize)
	
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

function _details:CloseShields()

	if (GetNumRaidMembers() == 0) then
		return
	end

	local name_table = {}
	for i = 1, GetNumRaidMembers() do
		name_table[_UnitName("raid" .. i)] = "raid" .. i
	end
	
	local spells_table = {}

	--não da de close os shields, precisa saber o total dele, unitaura nao retorna o valor do shield
	for dst_name, spellid_table in _pairs(shields) do
		for spellid, caster_table in _pairs(spellid_table) do
			if (not spells_table[spellid]) then
				local spellname = GetSpellInfo(spellid)
				spells_table[spellid] = spellname
			end
			for caster_name, amount in _pairs(caster_table) do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura(name_table[dst_name], buffIndex, nil, "HELPFUL")
				
			end
		end
	end

	--shield[dst_name][spellid][src_name]
end

--------------------------------------------- // TOOLTIPS // ---------------------------------------------


---------> TOOLTIPS BIFURCAÇÃO
function attribute_heal:ToolTip(instance, number, bar, keydown)
	--> seria possivel aqui colocar o icon da class dele?

	if (instance.attribute == 5) then --> custom
		return self:TooltipForCustom(bar)
	else
		--GameTooltip:ClearLines()
		--GameTooltip:AddLine(bar.placing..". "..self.name)
		if (instance.sub_attribute <= 3) then --> healing done, HPS or Overheal
			return self:ToolTip_HealingDone(instance, number, bar, keydown)
		elseif (instance.sub_attribute == 6) then --> healing done, HPS or Overheal	
			return self:ToolTip_HealingDone(instance, number, bar, keydown)
		elseif (instance.sub_attribute == 4) then --> healing taken
			return self:ToolTip_HealingTaken(instance, number, bar, keydown)
		end
	end
end
--> tooltip locals
local r, g, b
local headerColor = "yellow"
local barAlpha = .6
local key_overlay = {1, 1, 1, .1}
local key_overlay_press = {1, 1, 1, .2}

---------> HEALING TAKEN
function attribute_heal:ToolTip_HealingTaken(instance, number, bar, keydown)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end

	local healers = self.healing_from
	local total_healed = self.healing_taken
	
	local combat_table = instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	
	local mine_healers = {}
	
	for name, _ in _pairs(healers) do --> agressores seria a list de names
		local this_healer = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_healer) then --> checagem por causa do total e do garbage collector que não limpa os names que deram damage
			local targets = this_healer.targets
			local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
			if (this_dst and this_dst.total > 0) then
				mine_healers[#mine_healers+1] = {name, this_dst.total, this_healer.class}
			end
		end
	end
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_FROM"], headerColor, r, g, b, #mine_healers)

	GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 1, 1, 14, 14, 0.10546875, 0.89453125, 0.05859375, 0.6796875)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)

	local ismaximized = false
	
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end

	_table_sort(mine_healers, function(a, b) return a[2] > b[2] end)
	local max = #mine_healers
	if (max > 6) then
		max = 6
	end
	
	if (ismaximized) then
		max = 99
	end

	for i = 1, _math_min(max, #mine_healers) do
		GameCooltip:AddLine(mine_healers[i][1]..": ", FormatTooltipNumber(_, mine_healers[i][2]).."(".._cstr("%.1f",(mine_healers[i][2]/total_healed) * 100).."%)")
		local class = mine_healers[i][3]
		if (not class) then
			class = "UNKNOW"
		end
		if (class == "UNKNOW") then
			GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
		else
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords[class]))
		end
		_details:AddTooltipBackgroundStatusbar()
	end
	
	return true
end

---------> HEALING DONE / HPS / OVERHEAL
local background_heal_vs_absorbs = {value = 100, color = {1, 1, 0, .25}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar4_glass]]}

function attribute_heal:ToolTip_HealingDone(instance, number, bar, keydown)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end
	
	local ActorHealingTable = {}
	local ActorHealingTargets = {}
	local ActorSkillsContainer = self.spell_tables._ActorTable

	local actor_key, skill_key = "total", "total"
	if (instance.sub_attribute == 3) then
		actor_key, skill_key = "totalover", "overheal"
	elseif (instance.sub_attribute == 6) then
		actor_key, skill_key = "totalabsorb", "totalabsorb"
	end
	
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = instance.showing:GetCombatTime()
	end
	
	local ActorTotal = self[actor_key]
	
	for _spellid, _skill in _pairs(ActorSkillsContainer) do 
		local SkillName, _, SkillIcon = _GetSpellInfo(_spellid)
		if (_skill[skill_key] > 0) then
			_table_insert(ActorHealingTable, {_spellid, _skill[skill_key], _skill[skill_key]/ActorTotal*100, {SkillName, nil, SkillIcon}, _skill[skill_key]/mine_time, _skill.total})
		end
	end
	_table_sort(ActorHealingTable, _details.Sort2)
	
	--> TOP Curados
	ActorSkillsContainer = self.targets._ActorTable
	for _, TargetTable in _ipairs(ActorSkillsContainer) do
		if (TargetTable.total > 0) then
			_table_insert(ActorHealingTargets, {TargetTable.name, TargetTable.total, TargetTable.total/ActorTotal*100})
		end
	end
	_table_sort(ActorHealingTargets, _details.Sort2)

	--> Mostra as abilities no tooltip
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #ActorHealingTable)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\Raid-Icon-Rez]], 1, 1, 14, 14, 0.109375, 0.890625, 0.0625, 0.90625)

	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end

	local tooltip_max_abilities = _details.tooltip_max_abilities
	if (instance.sub_attribute == 3 or instance.sub_attribute == 2) then
		tooltip_max_abilities = 6
	end

	if (ismaximized) then
		tooltip_max_abilities = 99
	end
	
	for i = 1, _math_min(tooltip_max_abilities, #ActorHealingTable) do
		if (ActorHealingTable[i][2] < 1) then
			break
		end
		if (instance.sub_attribute == 2) then --> hps
			GameCooltip:AddLine(ActorHealingTable[i][4][1]..": ", FormatTooltipNumber(_,  _math_floor(ActorHealingTable[i][5])).."(".._cstr("%.1f", ActorHealingTable[i][3]).."%)")
		elseif (instance.sub_attribute == 3) then --> overheal
			local overheal = ActorHealingTable[i][2]
			local total = ActorHealingTable[i][6]
			GameCooltip:AddLine(ActorHealingTable[i][4][1] .."(|cFFFF3333" .. _math_floor((overheal /(overheal+total)) *100)  .. "%|r):", FormatTooltipNumber(_,  _math_floor(ActorHealingTable[i][2])).."(".._cstr("%.1f", ActorHealingTable[i][3]).."%)")
		else
			GameCooltip:AddLine(ActorHealingTable[i][4][1]..": ", FormatTooltipNumber(_, ActorHealingTable[i][2]).."(".._cstr("%.1f", ActorHealingTable[i][3]).."%)")
		end
		GameCooltip:AddIcon(ActorHealingTable[i][4][3], nil, nil, 14, 14)
		_details:AddTooltipBackgroundStatusbar()
	end
	
	if (instance.sub_attribute == 6) then
		GameCooltip:AddLine("")
		GameCooltip:AddLine(Loc["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack(self.click_to_report_color))
		GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
		
		GameCooltip:ShowCooltip()
	end
	
	local container = instance.showing[2]
	
	if (instance.sub_attribute == 1) then -- 1 or 2 -> healing done or hps
	
		_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #ActorHealingTargets)
		GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TutorialFrame-LevelUp]], 1, 1, 14, 14, 0.10546875, 0.89453125, 0.05859375, 0.6796875)

		local ismaximized = false
		if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
			GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
			ismaximized = true
		else
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
			GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
		end
		
		local tooltip_max_abilities2 = _details.tooltip_max_abilities
		if (ismaximized) then
			tooltip_max_abilities2 = 99
		end
		
		for i = 1, _math_min(tooltip_max_abilities2, #ActorHealingTargets) do
			if (ActorHealingTargets[i][2] < 1) then
				break
			end
			
			if (ismaximized and ActorHealingTargets[i][1]:find(_details.playername)) then
				GameCooltip:AddLine(ActorHealingTargets[i][1]..": ", FormatTooltipNumber(_, ActorHealingTargets[i][2]) .."(".._cstr("%.1f", ActorHealingTargets[i][3]).."%)", nil, "yellow")
				GameCooltip:AddStatusBar(100, 1, .5, .5, .5, .7)
			else
				GameCooltip:AddLine(ActorHealingTargets[i][1]..": ", FormatTooltipNumber(_, ActorHealingTargets[i][2]) .."(".._cstr("%.1f", ActorHealingTargets[i][3]).."%)")
				_details:AddTooltipBackgroundStatusbar()
			end
			
			local targetActor = container:CatchCombatant(nil, ActorHealingTargets[i][1])
			
			if (targetActor) then
				local class = targetActor.class
				if (not class) then
					class = "UNKNOW"
				end
				if (class == "UNKNOW") then
					GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
				else
					GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords[class]))
				end
			end
		end
	end
	
	--> PETS
	local mine_pets = self.pets
	
	if (#mine_pets > 0 and(instance.sub_attribute == 1 or instance.sub_attribute == 2)) then --> teve ajudantes
		
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
					
					local mine_time
					if (_details.time_type == 1 or not self.group) then
						mine_time = my_self:Time()
					elseif (_details.time_type == 2) then
						mine_time = instance.showing:GetCombatTime()
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
				if (instance.sub_attribute == 2) then
					GameCooltip:AddLine(n, FormatTooltipNumber(_,  _math_floor(_table[3])) .. "(" .. _math_floor(_table[2]/self.total*100) .. "%)")
				else
					GameCooltip:AddLine(n, FormatTooltipNumber(_, _table[2]) .. "(" .. _math_floor(_table[2]/self.total*100) .. "%)")
				end
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
		
	end
	
	--> absorbs vs heal
	if (instance.sub_attribute == 1 or instance.sub_attribute == 2) then
		local total_healed = self.total - self.totalabsorb
		local total_prevented = self.totalabsorb
		
		local healed_percentage = total_healed / self.total * 100
		local prevented_percentage = total_prevented / self.total * 100
		
		if (healed_percentage > 1 and prevented_percentage > 1) then
			GameCooltip:AddLine(_math_floor(healed_percentage).."%", _math_floor(prevented_percentage).."%")
			local r, g, b = _unpack(_details.class_colors[self.class])
			background_heal_vs_absorbs.color[1] = r
			background_heal_vs_absorbs.color[2] = g
			background_heal_vs_absorbs.color[3] = b
			background_heal_vs_absorbs.specialSpark = false
			GameCooltip:AddStatusBar(healed_percentage, 1, r, g, b, .9, false, background_heal_vs_absorbs)
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_Priest_ReflectiveShield]], 1, 2, 14, 14, 0.0625, 0.9375, 0.0625, 0.9375)
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_Monk_ChiWave]], 1, 1, 14, 14, 0.9375, 0.0625, 0.0625, 0.9375)
		end
		
	elseif (instance.sub_attribute == 3) then
		local total_healed = self.total
		local total_overheal = self.totalover
		local both = total_healed + total_overheal
		
		local healed_okey = total_healed / both * 100
		local healed_disposed = total_overheal / both * 100
		
		if (healed_okey > 1 and healed_disposed > 1) then
			GameCooltip:AddLine(_math_floor(healed_okey).."%", _math_floor(healed_disposed).."%")
			background_heal_vs_absorbs.color[1] = 1
			background_heal_vs_absorbs.color[2] = 0
			background_heal_vs_absorbs.color[3] = 0
			background_heal_vs_absorbs.specialSpark = false
			GameCooltip:AddStatusBar(healed_okey, 1, 0, 1, 0, .9, false, background_heal_vs_absorbs)
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\ScenarioIcon-Check]], 1, 1, 14, 14, 0, 1, 0, 1)
			GameCooltip:AddIcon([[Interface\Glues\LOGIN\Glues-CheckBox-Check]], 1, 2, 14, 14, 1, 0, 0, 1)
		end
	end
	
	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------
---------- bifurcação
function attribute_heal:SetInfo()
	if (info.sub_attribute == 1 or info.sub_attribute == 2) then
		return self:SetInfoHealingDone()
	elseif (info.sub_attribute == 3) then
		return self:SetInfoOverHealing()
	elseif (info.sub_attribute == 4) then
		return self:SetInfoHealTaken()
	end
end

function attribute_heal:SetInfoHealTaken()

	local healing_taken = self.healing_taken
	local healers = self.healing_from
	local instance = info.instance
	local combat_table = instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	local bars = info.bars1
	local mine_healers = {}
	
	local this_healer	
	for name, _ in _pairs(healers) do
		this_healer = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_healer) then
			local targets = this_healer.targets
			local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
			if (this_dst) then
				mine_healers[#mine_healers+1] = {name, this_dst.total, this_dst.total/healing_taken*100, this_healer.class}
			end
		end
	end
	
	local amt = #mine_healers
	
	if (amt < 1) then
		return true
	end
	
	_table_sort(mine_healers, function(a, b) return a[2] > b[2] end)
	
	gump:JI_UpdateContainerBars(amt)

	local max_ = mine_healers[1] and mine_healers[1][2] or 0
	
	local bar
	for index, table in _ipairs(mine_healers) do
		bar = bars[index]
		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
		end

		self:FocusLock(bar, table[1])
		
		--hes:UpdadeInfoBar(row, index, spellid, name, value, max, percent, icon, details)
		
		local texCoords = CLASS_ICON_TCOORDS[table[4]]
		if (not texCoords) then
			texCoords = _details.class_coords["UNKNOW"]
		end
		
		self:UpdadeInfoBar(bar, index, table[1], table[1], table[2], _details:comma_value(table[2]), max_, table[3], "Interface\\AddOns\\Details\\images\\classes_small", true, texCoords)
	end	
	
	--[[
	for index, table in _ipairs(mine_healers) do
		
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
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end

		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(table[2] .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right
		
		local class = table[4]
		if (not class) then
			class = "monster"
		end

		bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\"..class:lower().."_small")

		bar.my_table = self
		bar.show = table[1]
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
		
	end
	--]]
end

function attribute_heal:SetInfoOverHealing()
--> pegar as ability de dar sort no heal
	
	local instance = info.instance
	local total = self.totalover
	local table = self.spell_tables._ActorTable
	local mine_heals = {}
	local bars = info.bars1

	for spellid, table in _pairs(table) do
		local name, _, icon = _GetSpellInfo(spellid)
		_table_insert(mine_heals, {spellid, table.overheal, table.overheal/total*100, name, icon})
	end

	_table_sort(mine_heals, function(a, b) return a[2] > b[2] end)

	local amt = #mine_heals
	gump:JI_UpdateContainerBars(amt)

	local max_ = mine_heals[1] and mine_heals[1][2] or 0

	for index, table in _ipairs(mine_heals) do

		local bar = bars[index]

		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
			bar.on_focus = false
		end

		if (not info.showing_mouse_over) then
			if (table[1] == self.details) then --> table[1] = spellid = spellid que this na caixa da right
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
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end

		bar.text_left:SetText(index..instance.dividers.placing..table[4]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .. _cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right

		bar.icon:SetTexture(table[5])

		bar.my_table = self
		bar.show = table[1]
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
	end
	
	--> TOP OVERHEALED
	local players_overhealed = {}
	table = self.targets._ActorTable
	local heal_container = instance.showing[2]
	for _, table in _ipairs(table) do
		local class = "UNKNOW"
		local actor_object = heal_container._ActorTable[heal_container._NameIndexTable[table.name]]
		if (actor_object) then
			class = actor_object.class
		end
		_table_insert(players_overhealed, {table.name, table.overheal, table.overheal/total*100, class})
	end
	_table_sort(players_overhealed, function(a, b) return a[2] > b[2] end )	
	
	local amt_targets = #players_overhealed
	gump:JI_UpdateContainerTargets(amt_targets)
	
	local max_enemies = players_overhealed[1] and players_overhealed[1][2] or 0
	
	for index, table in _ipairs(players_overhealed) do
	
		local bar = info.bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_*100)
		end
		
		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .. _cstr("%.1f", table[3]) .. instance.dividers.close) --seta o text da right
		bar.text_left:SetWidth(bar:GetWidth() - bar.text_right:GetStringWidth() - 30)
		
		-- icon
		bar.icon:SetTexture([[Interface\AddOns\Details\images\classes_small]])
		
		local texCoords = _details.class_coords[table[4]]
		if (not texCoords) then
			texCoords = _details.class_coords["UNKNOW"]
		end
		bar.icon:SetTexCoord(_unpack(texCoords))
		
		bar.my_table = self
		bar.name_enemy = table[1]
		
		-- no place do spell id colocar o que?
		--bar.spellid = table[5]
		bar:Show()
		
		--if (self.details and self.details == bar.spellid) then
		--	self:SetDetails(self.details, bar)
		--end
	end
end

function attribute_heal:SetInfoHealingDone()

	--> pegar as ability de dar sort no heal
	
	local instance = info.instance
	local total = self.total
	local table = self.spell_tables._ActorTable
	local mine_heals = {}
	local bars = info.bars1

	--get time type
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	for spellid, table in _pairs(table) do
		local name, rank, icon = _GetSpellInfo(spellid)
		_table_insert(mine_heals, {spellid, table.total, table.total/total*100, name, icon})
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
				_table_insert(mine_heals, {_spellid, _skill.total, _skill.total/total*100, name .. "(|c" .. class_color .. PetName:gsub((" <.*"), "") .. "|r)", icon, PetActor})
			end
			--_table_insert(ActorSkillsSortTable, {PetName, PetActor.total, PetActor.total/ActorTotalDamage*100, PetName:gsub((" <.*"), ""), "Interface\\AddOns\\Details\\images\\classes_small"})
		end
	end
	
	_table_sort(mine_heals, _details.Sort2)

	local amt = #mine_heals
	gump:JI_UpdateContainerBars(amt)

	local max_ = mine_heals[1] and mine_heals[1][2] or 0

	for index, table in _ipairs(mine_heals) do

		local bar = bars[index]

		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
			bar.on_focus = false
		end

		self:FocusLock(bar, table[1])
		
		bar.other_actor = table[6]
		
		if (info.sub_attribute == 2) then
			self:UpdadeInfoBar(bar, index, table[1], table[4], table[2], _details:comma_value(_math_floor(table[2]/mine_time)), max_, table[3], table[5], true)
		else
			self:UpdadeInfoBar(bar, index, table[1], table[4], table[2], _details:comma_value(table[2]), max_, table[3], table[5], true)
		end

		bar.my_table = self
		bar.show = table[1]
		bar.spellid = self.name
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
	end
	
	--> TOP HEALERS
	local mine_enemies = {}
	table = self.targets._ActorTable
	for _, table in _ipairs(table) do
		_table_insert(mine_enemies, {table.name, table.total, table.total/total*100})
	end
	_table_sort(mine_enemies, function(a, b) return a[2] > b[2] end )	
	
	local amt_targets = #mine_enemies
	gump:JI_UpdateContainerTargets(amt_targets)
	
	local max_enemies = mine_enemies[1] and mine_enemies[1][2] or 0
	
	for index, table in _ipairs(mine_enemies) do
	
		local bar = info.bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_*100) --> muito mais rapido...
		end
		
		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		
		if (info.sub_attribute == 2) then
			bar.text_right:SetText(_details:comma_value(_math_floor(table[2]/mine_time)) .." ".. instance.dividers.open .. _cstr("%.1f", table[3]) .. instance.dividers.close) --seta o text da right
		else
			bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .. _cstr("%.1f", table[3]) .. instance.dividers.close) --seta o text da right
		end
		
		-- o que mostrar no local do ícone?
		--bar.icon:SetTexture(table[4][3])
		
		bar.my_table = self
		bar.name_enemy = table[1]
		
		-- no place do spell id colocar o que?
		bar.spellid = table[5]
		bar:Show()
		
		--if (self.details and self.details == bar.spellid) then
		--	self:SetDetails(self.details, bar)
		--end
	end
	
end

function attribute_heal:SetTooltipTargets(this_bar, index, instance)
	-- eu ja sei quem é o dst a mostrar os details
	-- dar foreach no container de abilities -- pegar os targets da ability -- e ver se dentro do container tem o mine dst.
	
	local enemy = this_bar.name_enemy
	local container = self.spell_tables._ActorTable
	local abilities = {}
	local total
	local sub_attribute = info.instance.sub_attribute
	
	if (sub_attribute == 3) then --> overheal
		total = self.totalover
	else
		total = self.total
	end

	--> add spells
	for spellid, table in _pairs(container) do
		local targets = table.targets._ActorTable
		for _, table in _ipairs(targets) do
			if (table.name == enemy) then
				local name, _, icon = _GetSpellInfo(spellid)
				if (sub_attribute == 3) then --> overheal
					abilities[#abilities+1] = {name, table.overheal, icon}
				else
					abilities[#abilities+1] = {name, table.total, icon}
				end
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
						if (sub_attribute == 3) then --> overheal
							abilities[#abilities+1] = {name .. "(" .. PetName:gsub((" <.*"), "") .. ")", table.overheal, icon}
						else
							abilities[#abilities+1] = {name .. "(" .. PetName:gsub((" <.*"), "") .. ")", table.total, icon}
						end
					end
				end
			end
		end
	end	
	
	_table_sort(abilities, function(a, b) return a[2] > b[2] end)
	
	--get time type
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	local is_hps = info.instance.sub_attribute == 2
	
	if (is_hps) then
		GameTooltip:AddLine(index..". "..enemy)
		GameTooltip:AddLine(Loc["STRING_HEALING_HPS_FROM"] .. ":")
		GameTooltip:AddLine(" ")
	else
		GameTooltip:AddLine(index..". "..enemy)
		GameTooltip:AddLine(Loc["STRING_HEALING_FROM"] .. ":")
		GameTooltip:AddLine(" ")
	end
	
	for index, table in _ipairs(abilities) do
		local name, icon = table[1], table[3]
		if (index < 8) then
			if (is_hps) then
				GameTooltip:AddDoubleLine(index..". |T"..icon..":0|t "..name, _details:comma_value(_math_floor(table[2]/mine_time)).."(".. _cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			else
				GameTooltip:AddDoubleLine(index..". |T"..icon..":0|t "..name, _details:comma_value(table[2]).."(".. _cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			end
		else
			if (is_hps) then
				GameTooltip:AddDoubleLine(index..". "..name, _details:comma_value(_math_floor(table[2]/mine_time)).."(".. _cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			else
				GameTooltip:AddDoubleLine(index..". "..name, _details:comma_value(table[2]).."(".. _cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
			end
		end
	end
	
	return true
	--GameTooltip:AddDoubleLine(mine_heals[i][4][1]..": ", mine_heals[i][2].."(".._cstr("%.1f", mine_heals[i][3]).."%)", 1, 1, 1, 1, 1, 1)
	
end

function attribute_heal:SetDetails(spellid, bar)
	--> bifurgações
	if (info.sub_attribute == 1 or info.sub_attribute == 2 or info.sub_attribute == 3) then
		return self:SetDetailsHealingDone(spellid, bar)
	elseif (info.sub_attribute == 4) then
		attribute_heal:SetDetailsHealingTaken(spellid, bar)
	end
end

function attribute_heal:SetDetailsHealingTaken(name, bar)

	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	local bars = info.bars3
	local instance = info.instance
	
	local combat_table = info.instance.showing
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable

	local this_healer = showing._ActorTable[showing._NameIndexTable[name]]
	local content = this_healer.spell_tables._ActorTable --> _pairs[] com os IDs das spells
	
	local actor = info.player.name
	
	local total = this_healer.targets._ActorTable[this_healer.targets._NameIndexTable[actor]].total

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
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right
		
		bar.icon:SetTexture(table[5])

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
end

function attribute_heal:SetDetailsHealingDone(spellid, bar)

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

	info.spell_icon:SetTexture(infospell[3])

	local total = self.total
	
	local overheal = this_spell.overheal
	local mine_total = this_spell.total + overheal
	
	local mine_time
	if (_details.time_type == 1 or not self.group) then
		mine_time = self:Time()
	elseif (_details.time_type == 2) then
		mine_time = info.instance.showing:GetCombatTime()
	end
	
	--local total_hits = this_spell.counter
	local total_hits = this_spell.n_amt+this_spell.c_amt
	
	local index = 1
	
	local data = {}
	
	if (this_spell.total > 0) then
	
	--> GENERAL
		local media = this_spell.total/total_hits
		
		local this_hps = nil
		if (this_spell.counter > this_spell.c_amt) then
			this_hps = Loc["STRING_HPS"]..": ".._cstr("%.1f", this_spell.total/mine_time) --> localiza-me
		else
			this_hps = Loc["STRING_HPS"]..": "..Loc["STRING_SEE_BELOW"]
		end
		
		gump:SetaDetailInfoText( index, 100, --> Localize-me
			Loc["STRING_GENERAL"], --> localiza-me
			Loc["STRING_HEAL"]..": ".._details:ToK(this_spell.total), --> localiza-me
			Loc["STRING_PERCENTAGE"]..": ".._cstr("%.1f", this_spell.total/total*100) .. "%", --> localiza-me
			Loc["STRING_MEDIA"]..": ".._cstr("%.1f", media), --> localiza-me
			this_hps,
			Loc["STRING_HITS"]..": " .. total_hits) --> localiza-me
	
	--> NORMAL
		local normal_hits = this_spell.n_amt
		if (normal_hits > 0) then
			local normal_healed = this_spell.n_healed
			local media_normal = normal_healed/normal_hits
			local T =(mine_time*normal_healed)/this_spell.total
			local P = media/media_normal*100
			T = P*T/100

			data[#data+1] = {
				this_spell.n_amt, 
				normal_hits/total_hits*100, 
				--this_spell.n_healed/this_spell.total*100, 
				Loc["STRING_HEAL"], --> localiza-me
				Loc["STRING_MINIMUM"] .. ": " .. _details:comma_value(this_spell.n_min), --> localiza-me
				Loc["STRING_MAXIMUM"] .. ": " .. _details:comma_value(this_spell.n_max), --> localiza-me
				Loc["STRING_MEDIA"] .. ": " .. _cstr("%.1f", media_normal), --> localiza-me
				Loc["STRING_HPS"] .. ": " .. _cstr("%.1f", normal_healed/T), --> localiza-me
				normal_hits .. " / ".. _cstr("%.1f", normal_hits/total_hits*100).."%"
				}
		end

	--> CRITICAL
		if (this_spell.c_amt > 0) then	
			local media_critical = this_spell.c_healed/this_spell.c_amt
			local T =(mine_time*this_spell.c_healed)/this_spell.total
			local P = media/media_critical*100
			T = P*T/100
			local crit_hps = this_spell.c_healed/T
			if (not crit_hps) then
				crit_hps = 0
			end
			
			data[#data+1] = {
				this_spell.c_amt,
				this_spell.c_amt/total_hits*100, 
				--this_spell.c_healed/this_spell.total*100,
				Loc["STRING_HEAL_CRIT"], --> localiza-me
				Loc["STRING_MINIMUM"] .. ": " .. _details:comma_value(this_spell.c_min), --> localiza-me
				Loc["STRING_MAXIMUM"] .. ": " .. _details:comma_value(this_spell.c_max), --> localiza-me
				Loc["STRING_MEDIA"] .. ": " .. _cstr("%.1f", media_critical), --> localiza-me
				Loc["STRING_HPS"] .. ": " .. _cstr("%.1f", crit_hps), --> localiza-me
				this_spell.c_amt .. " / ".._cstr("%.1f", this_spell.c_amt/total_hits*100).."%"
				}
		end
		
	end
	
	_table_sort(data, function(a, b) return a[1] > b[1] end)

	--> Aqui pode vir a heal absorvida

		local absorbed = this_spell.absorbed

		if (absorbed > 0) then
			local percentage_absorbed = absorbed/this_spell.total*100
			data[#data+1] = {
				absorbed,
				{["p"] = percentage_absorbed,["c"] = {117/255, 58/255, 0/255}},
				Loc["STRING_HEAL_ABSORBED"], --> localiza-me
				"", --this_spell.glacing.healed
				"",
				"",
				"",
				absorbed.." / ".._cstr("%.1f", percentage_absorbed).."%"
				}
		end

	for i = #data+1, 3 do --> para o overheal aparecer na ultima bar
		data[i] = nil
	end
		
	--> overhealing

		if (overheal > 0) then
			local percentage_overheal = overheal/mine_total*100
			data[4] = { 
				overheal,
				{["p"] = percentage_overheal,["c"] = {0.5, 0.1, 0.1}},
				Loc["STRING_OVERHEAL"], --> localiza-me
				"",
				"",
				"",
				"",
				_details:comma_value(overheal).." / ".._cstr("%.1f", percentage_overheal).."%"
				}
		end
	
	for index = 1, 4 do
		local table = data[index]
		if (not table) then
			gump:HidaDetailInfo(index+1)
		else
			gump:SetaDetailInfoText(index+1, table[2], table[3], table[4], table[5], table[6], table[7], table[8])
		end
	end

	--for i = #data+2, 5 do
	--	gump:HidaDetailInfo(i)
	--end

end

--controla se o dps do player this travado ou destravado
function attribute_heal:Initialize(initialize)
	if (initialize == nil) then 
		return self.initialize_hps --retorna se o dps this aberto ou closedo para this player
	elseif (initialize) then
		self.initialize_hps = true
		self:RegisterInTimeMachine() --coloca ele da timeMachine
		if (self.shadow) then
			self.shadow.initialize_hps = true --> isso foi posto recentemente
			--self.shadow:RegisterInTimeMachine()
		end
	else
		self.initialize_hps = false
		self:UnregisterInTimeMachine() --retira ele da timeMachine
		if (self.shadow) then
			self.shadow.initialize_hps = false --> isso foi posto recentemente
			--self.shadow:UnregisterInTimeMachine()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a func de opsendcao
		function attribute_heal:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
			TooltipMaximizedMethod = _details.tooltip.maximize_method
		end

	--> subtract total from a combat table
		function attribute_heal:subtract_total(combat_table)
			combat_table.totals[class_type] = combat_table.totals[class_type] - self.total
			if (self.group) then
				combat_table.totals_group[class_type] = combat_table.totals_group[class_type] - self.total
			end
		end
		function attribute_heal:add_total(combat_table)
			combat_table.totals[class_type] = combat_table.totals[class_type] + self.total
			if (self.group) then
				combat_table.totals_group[class_type] = combat_table.totals_group[class_type] + self.total
			end
		end		
		
	--> restore a table de last event
		function attribute_heal:r_last_events_table(actor)
			if (not actor) then
				actor = self
			end
			--actor.last_events_table = _details:CreateActorLastEventTable()
		end
		
	--> restore e liga o ator com a sua shadow durante a inicialização
		function attribute_heal:r_onlyrefresh_shadow(actor)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_heal = _details.table_overall[2]
				local shadow = overall_heal._ActorTable[overall_heal._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_heal:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end
			
			--> restore a meta e indexes ao ator
				_details.refresh:r_attribute_heal(actor, shadow)
				
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
					_details.refresh:r_ability_heal(ability, shadow.spell_tables)
				end
			
			return shadow
		end
	
		function attribute_heal:r_connect_shadow(actor, no_refresh)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_heal = _details.table_overall[2]
				local shadow = overall_heal._ActorTable[overall_heal._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_heal:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
					shadow.start_time = time() - 3
					shadow.end_time = time()
				end
			
			--> restore a meta e indexes ao ator
				if (not no_refresh) then
					_details.refresh:r_attribute_heal(actor, shadow)
				end
			
			--> time elapsed(captura de dados)
				if (actor.end_time) then
					local time =(actor.end_time or time()) - actor.start_time
					shadow.start_time = shadow.start_time - time
				end

			--> total de heal(captura de dados)
				shadow.total = shadow.total + actor.total
			--> total de overheal(captura de dados)
				shadow.totalover = shadow.totalover + actor.totalover
			--> total de absorbs(captura de dados)
				shadow.totalabsorb = shadow.totalabsorb + actor.totalabsorb
			--> total de heal feita em enemies(captura de dados)
				shadow.heal_enemy_amt = shadow.heal_enemy_amt + actor.heal_enemy_amt
			--> total sem pets(captura de dados)
				shadow.total_without_pet = shadow.total_without_pet + actor.total_without_pet
				shadow.totalover_without_pet = shadow.totalover_without_pet + actor.totalover_without_pet
			--> total de heal recebida(captura de dados)
				shadow.healing_taken = shadow.healing_taken + actor.healing_taken

			--> total no combat overall(captura de dados)
				_details.table_overall.totals[2] = _details.table_overall.totals[2] + actor.total
				if (actor.group) then
					_details.table_overall.totals_group[2] = _details.table_overall.totals_group[2] + actor.total
				end
				
			--> copia o healing_from (captura de dados)
				for name, _ in _pairs(actor.healing_from) do 
					shadow.healing_from[name] = true
				end
				
			--> copia o heal_enemy(captura de dados)
				for spellid, amount in _pairs(actor.heal_enemy) do 
					if (shadow.heal_enemy[spellid]) then 
						shadow.heal_enemy[spellid] = shadow.heal_enemy[spellid] + amount
					else
						shadow.heal_enemy[spellid] = amount
					end
				end
			
			--> copia o container de targets(captura de dados)
				for index, dst in _ipairs(actor.targets._ActorTable) do 
					--> cria e soma o valor do total
					local dst_shadow = shadow.targets:CatchCombatant(nil, dst.name, nil, true)
					dst_shadow.total = dst_shadow.total + dst.total
					dst_shadow.overheal = dst_shadow.overheal + dst.overheal
					dst_shadow.absorbed = dst_shadow.absorbed + dst.absorbed 
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
						dst_shadow.overheal = dst_shadow.overheal + dst.overheal
						dst_shadow.absorbed = dst_shadow.absorbed + dst.absorbed 
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
						_details.refresh:r_ability_heal(ability, shadow.spell_tables)
					end
				end
			
			return shadow
		end

function attribute_heal:CollectGarbage(lastevent)
	return _details:CollectGarbage(class_type, lastevent)
end

function _details.refresh:r_attribute_heal(this_player, shadow)
	_setmetatable(this_player, attribute_heal)
	this_player.__index = attribute_heal
	
	if (shadow ~= -1) then
		this_player.shadow = shadow
		_details.refresh:r_container_combatants(this_player.targets, shadow.targets)
		_details.refresh:r_container_abilities(this_player.spell_tables, shadow.spell_tables)
	else
		_details.refresh:r_container_combatants(this_player.targets, -1)
		_details.refresh:r_container_abilities(this_player.spell_tables, -1)
	end
end

function _details.clear:c_attribute_heal(this_player)
	--this_player.__index = {}
	this_player.__index = nil
	this_player.shadow = nil
	this_player.links = nil
	this_player.my_bar = nil
	
	_details.clear:c_container_combatants(this_player.targets)
	_details.clear:c_container_abilities(this_player.spell_tables)
end

attribute_heal.__add = function(table1, table2)

	--> time elapsed
		local time =(table2.end_time or time()) - table2.start_time
		table1.start_time = table1.start_time - time

	--> total de heal
		table1.total = table1.total + table2.total
	--> total de overheal
		table1.totalover = table1.totalover + table2.totalover
	--> total de absorbs
		table1.totalabsorb = table1.totalabsorb + table2.totalabsorb
	--> total de heal feita em enemies
		table1.heal_enemy_amt = table1.heal_enemy_amt + table2.heal_enemy_amt
	--> total sem pets
		table1.total_without_pet = table1.total_without_pet + table2.total_without_pet
		table1.totalover_without_pet = table1.totalover_without_pet + table2.totalover_without_pet
	--> total de heal recebida
		table1.healing_taken = table1.healing_taken + table2.healing_taken
		
	--> soma o healing_from
		for name, _ in _pairs(table2.healing_from) do 
			table1.healing_from[name] = true
		end
	
	--> somar o heal_enemy
		for spellid, amount in _pairs(table2.heal_enemy) do 
			if (table1.heal_enemy[spellid]) then 
				table1.heal_enemy[spellid] = table1.heal_enemy[spellid] + amount
			else
				table1.heal_enemy[spellid] = amount
			end
		end
	
	--> somar o container de targets
		for index, dst in _ipairs(table2.targets._ActorTable) do 
			--> pega o dst no ator
			local dst_table1 = table1.targets:CatchCombatant(nil, dst.name, nil, true)
			--> soma os valores
			dst_table1.total = dst_table1.total + dst.total
			dst_table1.overheal = dst_table1.overheal + dst.overheal
			dst_table1.absorbed = dst_table1.absorbed + dst.absorbed 
		end
	
	--> soma o container de abilities
		for spellid, ability in _pairs(table2.spell_tables._ActorTable) do 
			--> pega a ability no primeiro ator
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_HEAL", false)
			--> soma os targets
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
				dst_table1.overheal = dst_table1.overheal + dst.overheal
				dst_table1.absorbed = dst_table1.absorbed + dst.absorbed 
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
	
	return table1
end

attribute_heal.__sub = function(table1, table2)

	--> time elapsed
		local time =(table2.end_time or time()) - table2.start_time
		table1.start_time = table1.start_time + time

	--> total de heal
		table1.total = table1.total - table2.total
	--> total de overheal
		table1.totalover = table1.totalover - table2.totalover
	--> total de absorbs
		table1.totalabsorb = table1.totalabsorb - table2.totalabsorb
	--> total de heal feita em enemies
		table1.heal_enemy_amt = table1.heal_enemy_amt - table2.heal_enemy_amt
	--> total sem pets
		table1.total_without_pet = table1.total_without_pet - table2.total_without_pet
		table1.totalover_without_pet = table1.totalover_without_pet - table2.totalover_without_pet
	--> total de heal recebida
		table1.healing_taken = table1.healing_taken - table2.healing_taken

	--> reduz o heal_enemy
		for spellid, amount in _pairs(table2.heal_enemy) do 
			if (table1.heal_enemy[spellid]) then 
				table1.heal_enemy[spellid] = table1.heal_enemy[spellid] - amount
			else
				table1.heal_enemy[spellid] = amount
			end
		end
		
	--> reduz o container de targets
		for index, dst in _ipairs(table2.targets._ActorTable) do 
			--> pega o dst no ator
			local dst_table1 = table1.targets:CatchCombatant(nil, dst.name, nil, true)
			--> soma os valores
			dst_table1.total = dst_table1.total - dst.total
			dst_table1.overheal = dst_table1.overheal - dst.overheal
			dst_table1.absorbed = dst_table1.absorbed - dst.absorbed 
		end

	--> reduz o container de abilities
		for spellid, ability in _pairs(table2.spell_tables._ActorTable) do 
			--> pega a ability no primeiro ator
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_HEAL", false)
			--> soma os targets
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
				dst_table1.overheal = dst_table1.overheal - dst.overheal
				dst_table1.absorbed = dst_table1.absorbed - dst.absorbed 
			end
			--> soma os valores da ability
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
	
	return table1
end
