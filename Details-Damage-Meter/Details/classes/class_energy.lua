--[[ Esta class irá abrigar todo a e_energy ganha de uma ability
Parents:
	addon -> combat atual -> e_energy-> container de players -> this class

]]

--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _table_sort = table.sort
local _table_insert = table.insert
local _setmetatable = setmetatable
local _ipairs = ipairs
local _pairs = pairs
local _rawget= rawget
local _math_min = math.min
local _math_max = math.max
local _bit_band = bit.band
local _unpack = unpack
local _type = type
--api locals
local _GetSpellInfo = _details.getspellinfo
local GameTooltip = GameTooltip
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup

local _details = 		_G._details
local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )
local _

local gump = 			_details.gump

local dst_of_ability = 	_details.dst_of_ability
local container_abilities = 	_details.container_abilities
local container_combatants = _details.container_combatants
local container_pets =		_details.container_pets
local attribute_energy =		_details.attribute_energy
local ability_energy = 	_details.ability_energy

--local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
local container_playernpc = _details.container_type.CONTAINER_PLAYERNPC
local container_energy = _details.container_type.CONTAINER_ENERGY_CLASS
local container_energy_target = _details.container_type.CONTAINER_ENERGYTARGET_CLASS
--local container_friendlyfire = _details.container_type.CONTAINER_FRIENDLYFIRE

--local mode_ALONE = _details.modes.alone
local mode_GROUP = _details.modes.group
local mode_ALL = _details.modes.all

local class_type = _details.attributes.e_energy

local DATA_TYPE_START = _details._details_props.DATA_TYPE_START
local DATA_TYPE_END = _details._details_props.DATA_TYPE_END

local div_open = _details.dividers.open
local div_close = _details.dividers.close
local div_place = _details.dividers.placing

local ToKFunctions = _details.ToKFunctions
local SelectedToKFunction = ToKFunctions[1]
local UsingCustomLeftText = false
local UsingCustomRightText = false

local FormatTooltipNumber = ToKFunctions[8]
local TooltipMaximizedMethod = 1

local info = _details.window_info
local keyName


function attribute_energy:Newtable(serial, name, link)

	--> constructor
	
	local alphabetical = _details:GetOrderNumber(name)
	
	local _new_energyActor = {
	
		last_event = 0,
		type = class_type, --> attribute 3 = e_energy
		
		mana = alphabetical,
		e_rage = alphabetical,
		e_energy = alphabetical,
		runepower = alphabetical,
		focus = alphabetical,
		holypower = alphabetical,

		mana_r = alphabetical,
		e_rage_r = alphabetical,
		e_energy_r = alphabetical,
		runepower_r = alphabetical,
		focus_r = alphabetical,
		holypower_r = alphabetical,
		
		mana_from = {},
		e_rage_from = {},
		e_energy_from = {},
		runepower_from = {},
		focus_from = {},
		holypower_from = {},
		
		last_value = nil, --> ultimo valor que this player teve, sdst quando a bar dele é atualizada

		pets = {},
		
		--container armazenará os seriais dos targets que o player aplicou damage
		targets = container_combatants:NewContainer(container_energy_target),
		
		--container armazenará os IDs das abilities usadas por this player
		spell_tables = container_abilities:NewContainer(container_energy),
	}
	
	_setmetatable(_new_energyActor, attribute_energy)
	
	if (link) then
		_new_energyActor.targets.shadow = link.targets
		_new_energyActor.spell_tables.shadow = link.spell_tables
	end
	
	return _new_energyActor
end

function _details.SortGroupEnergy(container, keyName2)
	keyName = keyName2
	return _table_sort(container, _details.SortKeyGroupEnergy)
end

function _details.SortKeyGroupEnergy(table1, table2)
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

function _details.SortKeySimpleEnergy(table1, table2)
	return table1[keyName] > table2[keyName]
end

function _details:ContainerSortEnergy(container, amount, keyName2)
	keyName = keyName2
	_table_sort(container,  _details.SortKeySimpleEnergy)
	
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

function attribute_energy:RefreshWindow(instance, combat_table, force, export)

	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable

	if (#showing._ActorTable < 1) then --> não há bars para mostrar
		return _details:HideBarsNotUsed(instance, showing) 
	end
	
	local total = 0 --> total iniciado como ZERO
	instance.top = 0
	
	local sub_attribute = instance.sub_attribute --> o que this sendo mostrado nthis instância
	local content = showing._ActorTable
	local amount = #content
	local mode = instance.mode
	
	if (export) then
		if (_type(export) == "boolean") then 		
			if (sub_attribute == 1) then --> MANA RECUPERADA
				keyName = "mana"
			elseif (sub_attribute == 2) then --> e_rage GANHA
				keyName = "e_rage"
			elseif (sub_attribute == 3) then --> ENERGIA GANHA
				keyName = "e_energy"
			elseif (sub_attribute == 4) then --> RUNEPOWER GANHO
				keyName = "runepower"
			end
		else
			keyName = export.key
			mode = export.mode		
		end
		
	elseif (instance.attribute == 5) then --> custom
		keyName = "custom"
		total = combat_table.totals[instance.customName]
		
	else
		if (sub_attribute == 1) then --> MANA RECUPERADA
			keyName = "mana"
		elseif (sub_attribute == 2) then --> e_rage GANHA
			keyName = "e_rage"
		elseif (sub_attribute == 3) then --> ENERGIA GANHA
			keyName = "e_energy"
		elseif (sub_attribute == 4) then --> RUNEPOWER GANHO
			keyName = "runepower"
		else
			--> not sure why this is happening
			return
		end
	end
	
	if (instance.attribute == 5) then --> custom
		--> faz o sort da categoria e retorna o amount corrigido
		amount = _details:ContainerSortEnergy(content, amount, keyName)
		
		--> grava o total
		instance.top = content[1][keyName]
	
	elseif (mode == mode_ALL) then --> showing ALL
	
		--> faz o sort da categoria
		_table_sort(content, function(a, b) return a[keyName] > b[keyName] end)
		
		--> não mostrar resultados com zero
		for i = amount, 1, -1 do --> de trás pra frente
			if (content[i][keyName] < 1) then
				amount = amount-1
			else
				break
			end
		end
		
		total = combat_table.totals[class_type][keyName] --> pega o total de damage já aplicado
		
		instance.top = content[1][keyName]
		
	elseif (mode == mode_GROUP) then --> showing GROUP
		
		--print("energy", keyName)
		
		_table_sort(content, function(a, b)
				if (a.group and b.group) then
					return a[keyName] > b[keyName]
				elseif (a.group and not b.group) then
					return true
				elseif (not a.group and b.group) then
					return false
				else
					return a[keyName] > b[keyName]
				end
			end)
		
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

	showing:remapear()

	if (export) then 
		return total, keyName, instance.top, amount
	end
	
	if (amount < 1) then --> não há bars para mostrar
		instance:HideScrollBar()
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	end

	instance:ActualizeScrollBar(amount)

	local which_bar = 1
	local bars_container = instance.bars
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

	return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh

end

function attribute_energy:Custom(_customName, _combat, sub_attribute, spell, dst)
	local _Skill = self.spell_tables._ActorTable[tonumber(spell)]
	if (_Skill) then
		local spellName = _GetSpellInfo(tonumber(spell))
		local SkillTargets = _Skill.targets._ActorTable
		
		for _, TargetActor in _ipairs(SkillTargets) do 
			local TargetActorSelf = _combat(class_type, TargetActor.name)
			TargetActorSelf.custom = TargetActor.total + TargetActorSelf.custom
			_combat.totals[_customName] = _combat.totals[_customName] + TargetActor.total
		end
	end
end

local actor_class_color_r, actor_class_color_g, actor_class_color_b

function attribute_energy:UpdateBar(instance, bars_container, which_bar, place, total, sub_attribute, force, keyName, combat_time, percentage_type, use_animations)

	local this_bar = instance.bars[which_bar] --> pega a referência da bar na window
	
	if (not this_bar) then
		print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
		return
	end
	
	local table_previous = this_bar.my_table
	
	this_bar.my_table = self
	this_bar.placing = place
	
	self.my_bar = this_bar
	self.placing = place

	local this_e_energy_total = self[keyName] --> total de damage que this player deu
	
--	local percentage = this_e_energy_total / total * 100
	local percentage
	if (percentage_type == 1) then
		percentage = _cstr("%.1f", this_e_energy_total / total * 100)
	elseif (percentage_type == 2) then
		percentage = _cstr("%.1f", this_e_energy_total / instance.top * 100)
	end

	local this_percentage = _math_floor((this_e_energy_total/instance.top) * 100)

	local formated_energy = SelectedToKFunction(_, this_e_energy_total)
	
	if (UsingCustomRightText) then
		this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_energy, "", percentage, self))
	else
		this_bar.text_right:SetText(formated_energy .. "(" .. percentage .. "%)") --seta o text da right
	end
	
	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end

	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	
	return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
end

function attribute_energy:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
	
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

function attribute_energy:RefreshBar(this_bar, instance, from_resize)
	
	if (from_resize) then
		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
	end
	
	if (instance.row_info.texture_class_colors) then
		this_bar.texture:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	if (instance.row_info.texture_background_class_color) then
		this_bar.background:SetVertexColor(actor_class_color_r, actor_class_color_g, actor_class_color_b)
	end
	
	if (self.class == "UNKNOW") then
		this_bar.icon_class:SetTexture("Interface\\LFGFRAME\\LFGROLE_BW")
		this_bar.icon_class:SetTexCoord(.25, .5, 0, 1)
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
function attribute_energy:KeyNames(sub_attribute)
	if (sub_attribute == 1) then --> MANA RECUPERADA
		return "mana", "mana_from"
	elseif (sub_attribute == 2) then --> e_rage GANHA
		return "e_rage", "e_rage_from"
	elseif (sub_attribute == 3) then --> ENERGIA GANHA
		return "e_energy", "e_energy_from"
	elseif (sub_attribute == 4) then --> RUNEPOWER GANHO
		return "runepower", "runepower_from"
	end
end

function attribute_energy:Sources_and_Spells(received_from, showing, keyName, ability_dst)

	local abilities = {}
	local sources = {}
	local spells_dst = {}
	local max = 0
	
	for name, _ in _pairs(received_from) do
		local this_source = showing._ActorTable[showing._NameIndexTable[name]]
		if (this_source) then
		
			local targets = this_source.targets
			local _abilities = this_source.spell_tables
			
			local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
			if (this_dst) then
				sources[#sources+1] = {name, this_dst[keyName], this_source.class} --> mostra QUEM deu regen, a QUANTIDADE e a CLASSE
				--print(name, this_dst[keyName], this_source.class)
			end
			
			for spellid, ability in _pairs(_abilities._ActorTable) do 
				local targets = ability.targets
				local this_dst = targets._ActorTable[targets._NameIndexTable[self.name]]
				if (this_dst) then
					if (not abilities[spellid]) then
						abilities[spellid] = 0 --> mostra A SPELL e a amount que ela deu regen
					end
					abilities[spellid] = abilities[spellid] + this_dst[keyName]
					if (abilities[spellid] > max) then
						max = abilities[spellid]
					end
					if (ability_dst and ability_dst == spellid) then
						spells_dst[#spells_dst + 1] = {name, this_dst[keyName], this_source.class}
					elseif (ability_dst == true) then
						--print(name, name, this_dst[keyName], spellid)
						spells_dst[#spells_dst + 1] = {name, this_dst[keyName], spellid}
					end
				end
			end
		end
	end

	local sorted_table = {}
	for spellid, amt in _pairs(abilities) do 
		local name, _, icon = _GetSpellInfo(spellid)
		sorted_table[#sorted_table+1] = {spellid, amt, amt/max*100, name, icon}
	end
	_table_sort(sorted_table, function(a, b) return a[2] > b[2] end)
	
	_table_sort(sources, function(a, b) return a[2] > b[2] end)
	
	if (ability_dst) then
		_table_sort(spells_dst, function(a, b) return a[2] > b[2] end)
	end
	
	return sources, sorted_table, spells_dst
end


---------> TOOLTIPS BIFURCAÇÃO
function attribute_energy:ToolTip(instance, number, bar, keydown)
	--> seria possivel aqui colocar o icon da class dele?
	--GameCooltip:AddLine(bar.placing..". "..self.name)
	if (instance.sub_attribute <= 4) then
		return self:ToolTipRegenReceived(instance, number, bar, keydown)
	end
end
--> tooltip locals
local r, g, b
local headerColor = "yellow"
local barAlpha = .6

local key_overlay = {1, 1, 1, .1}
local key_overlay_press = {1, 1, 1, .2}

function attribute_energy:ToolTipRegenReceived(instance, number, bar, keydown)
	
	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	
	
	local combat_table = instance.showing
	local showing = combat_table[class_type] 
	
	local keyName, keyName_from = attribute_energy:KeyNames(instance.sub_attribute)
	
	local total_regenerated = self[keyName]
	local received_from = self[keyName_from]
	
	local sources, abilities = self:Sources_and_Spells(received_from, showing, keyName)

-----------------------------------------------------------------	
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #abilities)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\ReportLagIcon-Spells]], 1, 1, 14, 14, 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "shift" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 3) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_shift]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	local max = #abilities
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end

	for i = 1, math.min(#abilities, max) do
		local name_spell, _, icon_spell = _GetSpellInfo(abilities[i][1])
		GameCooltip:AddLine(name_spell..": ", FormatTooltipNumber(_,  abilities[i][2]).."(".._cstr("%.1f",(abilities[i][2]/total_regenerated) * 100).."%)")
		GameCooltip:AddIcon(icon_spell)
		_details:AddTooltipBackgroundStatusbar()
	end
	
-----------------------------------------------------------------

	_details:AddTooltipSpellHeaderText(Loc["STRING_PLAYERS"], headerColor, r, g, b, #sources)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\HelpIcon-HotIssues]], 1, 1, 14, 14, 0.21875, 0.78125, 0.21875, 0.78125)
	
	local ismaximized = false
	if (keydown == "ctrl" or TooltipMaximizedMethod == 2 or TooltipMaximizedMethod == 4) then
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay_press)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		ismaximized = true
	else
		GameCooltip:AddIcon([[Interface\AddOns\Details\images\key_ctrl]], 1, 2, 24, 12, 0, 1, 0, 0.640625, key_overlay)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	end
	
	max = #sources
	if (max > 3) then
		max = 3
	end
	
	if (ismaximized) then
		max = 99
	end
	
	for i = 1, math.min(#sources, max) do
		GameCooltip:AddLine(sources[i][1]..": ", FormatTooltipNumber(_,  sources[i][2]).."(".._cstr("%.1f",(sources[i][2]/total_regenerated) * 100).."%)")
		_details:AddTooltipBackgroundStatusbar()
		
		local class = sources[i][3]
		if (not class) then
			class = "UNKNOW"
		end
		if (class == "UNKNOW") then
			GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, nil, 14, 14, .25, .5, 0, 1)
		else
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\classes_small", nil, nil, 14, 14, _unpack(_details.class_coords[class]))
		end
		
	end
	
	return true
end

--------------------------------------------- // JANELA DETALHES // ---------------------------------------------

---------> DETALHES BIFURCAÇÃO
function attribute_energy:SetInfo()
	if (info.sub_attribute <= 4) then --> damage done & dps
		return self:SetInfoRegenReceived()
	end
end

---------> DETALHES bloco da right BIFURCAÇÃO
function attribute_energy:SetDetails(spellid, bar)
	if (info.sub_attribute <= 4) then
		return self:SetDetailsRegenReceived(spellid, bar)
	end
end

function attribute_energy:SetInfoRegenReceived()

	local bars = info.bars1
	local bars2 = info.bars2
	local bars3 = info.bars3
	
	local instance = info.instance

	local keyName, keyName_from = attribute_energy:KeyNames(instance.sub_attribute)
	
	local combat_table = instance.showing
	local showing = combat_table[class_type] 
	
	local total_regenerated = self[keyName]
	local received_from = self[keyName_from]
	
	if (not received_from) then
		return
	end
	
	local sources, abilities = self:Sources_and_Spells(received_from, showing, keyName)
	
	local amt = #abilities
	
	if (amt < 1) then --> caso houve apenas friendly fire
		return true
	end
	
	gump:JI_UpdateContainerBars(amt)
	local max_ = abilities[1][2]
	
	for index, table in _ipairs(abilities) do
		
		local bar = bars[index]

		if (not bar) then
			bar = gump:CreateNewBarInfo1(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
			
			bar.on_focus = false
		end

		self:FocusLock(bar, table[1])
		self:UpdadeInfoBar(bar, index, table[1], table[4], table[2], _details:comma_value(table[2]), max_, table[3], table[5], true)

		bar.my_table = self
		bar.show = table[1]
		bar:Show()

		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar)
		end
		
	end
	

	local amt_sources = #sources
	gump:JI_UpdateContainerTargets(amt_sources)
	
	local max_sources = sources[1][2]
	
	local bar
	for index, table in _ipairs(sources) do
	
		bar = info.bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_sources*100)
		end
		
		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .._cstr("%.1f", table[2]/total_regenerated * 100) .. instance.dividers.close) --seta o text da right
		
		if (bar.mouse_over) then --> atualizar o tooltip
			if (bar.isTarget) then
				GameTooltip:Hide() 
				GameTooltip:SetOwner(bar, "ANCHOR_TOPRIGHT")
				if (not bar.my_table:SetTooltipTargets(bar, index)) then
					return
				end
				GameTooltip:Show()
			end
		end	

		bar.my_table = self --> grava o player na table
		bar.name_enemy = table[1] --> salva o name do enemy na bar --> isso é necessário?

		bar:Show()
	end	

end

function attribute_energy:SetDetailsRegenReceived(name, bar)
	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end
	
	local bars = info.bars3
	local instance = info.instance

	local combat_table = info.instance.showing
	local showing = combat_table[class_type]
	
	local keyName, keyName_from = attribute_energy:KeyNames(instance.sub_attribute)
	local received_from = self[keyName_from]
	local total_regenerated = self[keyName]
	
	local _, _, from = self:Sources_and_Spells(received_from, showing, keyName, name)
	
	if (not from[1] or not from[1][2]) then
		return
	end
	
	local max_ = from[1][2]
	
	local bar
	for index, table in _ipairs(from) do
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

		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(_details:comma_value(table[2]) .." ".. instance.dividers.open .._cstr("%.1f", table[2] /total_regenerated *100) .."%".. instance.dividers.close) --seta o text da right
		
		bar.texture:SetStatusBarColor(_unpack(_details.class_colors[table[3]]))
		bar.icon:SetTexture("Interface\\AddOns\\Details\\images\\classes_small")
		
		bar.icon:SetTexCoord(_unpack(_details.class_coords[table[3]]))

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
end

function attribute_energy:SetTooltipTargets(this_bar, index)
	local instance = info.instance
	local combat_table = instance.showing
	local showing = combat_table[class_type] 
	
	local keyName, keyName_from = attribute_energy:KeyNames(instance.sub_attribute)
	
	local total_regenerated = self[keyName]
	local received_from = self[keyName_from]
	
	local _, _, spells_dst = self:Sources_and_Spells(received_from, showing, keyName, true)

-----------------------------------------------------------------	
	GameTooltip:AddLine(Loc["STRING_SPELLS"]..":")
	for _, table in _ipairs(spells_dst) do
		if (table[1] == this_bar.name_enemy) then
			local name_spell, _, icon_spell = _GetSpellInfo(table[3])
			GameTooltip:AddDoubleLine(name_spell..": ", _details:comma_value(table[2]).."(".._cstr("%.1f",(table[2]/total_regenerated) * 100).."%)", 1, 1, 1, 1, 1, 1)
			GameTooltip:AddTexture(icon_spell)
		end
	end

	return true
end


--controla se o dps do player this travado ou destravado
function attribute_energy:Initialize(initialize)
	return false --retorna se o dps this aberto ou closedo para this player
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a func de opsendcao
		function attribute_energy:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
			TooltipMaximizedMethod = _details.tooltip.maximize_method
		end

	--> subtract total from a combat table
		function attribute_energy:subtract_total(combat_table)
			combat_table.totals[class_type].mana = combat_table.totals[class_type].mana - self.mana
			combat_table.totals[class_type].e_rage = combat_table.totals[class_type].e_rage - self.e_rage
			combat_table.totals[class_type].e_energy = combat_table.totals[class_type].e_energy - self.e_energy
			combat_table.totals[class_type].runepower = combat_table.totals[class_type].runepower - self.runepower

			if (self.group) then
				combat_table.totals_group[class_type].mana = combat_table.totals_group[class_type].mana - self.mana
				combat_table.totals_group[class_type].e_rage = combat_table.totals_group[class_type].e_rage - self.e_rage
				combat_table.totals_group[class_type].e_energy = combat_table.totals_group[class_type].e_energy - self.e_energy
				combat_table.totals_group[class_type].runepower = combat_table.totals_group[class_type].runepower - self.runepower
			end
		end
		function attribute_energy:add_total(combat_table)
			combat_table.totals[class_type].mana = combat_table.totals[class_type].mana + self.mana
			combat_table.totals[class_type].e_rage = combat_table.totals[class_type].e_rage + self.e_rage
			combat_table.totals[class_type].e_energy = combat_table.totals[class_type].e_energy + self.e_energy
			combat_table.totals[class_type].runepower = combat_table.totals[class_type].runepower + self.runepower

			if (self.group) then
				combat_table.totals_group[class_type].mana = combat_table.totals_group[class_type].mana + self.mana
				combat_table.totals_group[class_type].e_rage = combat_table.totals_group[class_type].e_rage + self.e_rage
				combat_table.totals_group[class_type].e_energy = combat_table.totals_group[class_type].e_energy + self.e_energy
				combat_table.totals_group[class_type].runepower = combat_table.totals_group[class_type].runepower + self.runepower
			end
		end
		
	--> restore e liga o ator com a sua shadow durante a inicialização
	
		function attribute_energy:r_onlyrefresh_shadow(actor)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_energy = _details.table_overall[3]
				local shadow = overall_energy._ActorTable[overall_energy._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_energy:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end
			
			--> restore a meta e indexes ao ator
				_details.refresh:r_attribute_energy(actor, shadow)
			
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

					--> refresh na meta e indexes
					_details.refresh:r_ability_e_energy(ability, shadow.spell_tables)
				end

			return shadow
		end
	
		function attribute_energy:r_connect_shadow(actor, no_refresh)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_energy = _details.table_overall[3]
				local shadow = overall_energy._ActorTable[overall_energy._NameIndexTable[actor.name]]

				if (not shadow) then 
					shadow = overall_energy:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end
			
			--> restore a meta e indexes ao ator
				if (not no_refresh) then
					_details.refresh:r_attribute_energy(actor, shadow)
				end
			
			--> total das energias(captura de dados)
				shadow.mana = shadow.mana + actor.mana
				shadow.e_rage = shadow.e_rage + actor.e_rage
				shadow.e_energy = shadow.e_energy + actor.e_energy
				shadow.runepower = shadow.runepower + actor.runepower
				shadow.focus = shadow.focus + actor.focus
				shadow.holypower = shadow.holypower + actor.holypower
				
				shadow.mana_r = shadow.mana_r + actor.mana_r
				shadow.e_rage_r = shadow.e_rage_r + actor.e_rage_r
				shadow.e_energy_r = shadow.e_energy_r + actor.e_energy_r
				shadow.runepower_r = shadow.runepower_r + actor.runepower_r
				shadow.focus_r = shadow.focus_r + actor.focus_r
				shadow.holypower_r = shadow.holypower_r + actor.holypower_r
				
			--> total no combat overall(captura de dados)
				_details.table_overall.totals[3].mana = _details.table_overall.totals[3].mana + actor.mana
				_details.table_overall.totals[3].e_rage = _details.table_overall.totals[3].e_rage + actor.e_rage
				_details.table_overall.totals[3].e_energy = _details.table_overall.totals[3].e_energy + actor.e_energy
				_details.table_overall.totals[3].runepower = _details.table_overall.totals[3].runepower + actor.runepower
				
				if (actor.group) then
					_details.table_overall.totals_group[3]["mana"] = _details.table_overall.totals_group[3]["mana"] + actor.mana
					_details.table_overall.totals_group[3]["e_rage"] = _details.table_overall.totals_group[3]["e_rage"] + actor.e_rage
					_details.table_overall.totals_group[3]["e_energy"] = _details.table_overall.totals_group[3]["e_energy"] + actor.e_energy
					_details.table_overall.totals_group[3]["runepower"] = _details.table_overall.totals_group[3]["runepower"] + actor.runepower
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
					--> refresh na meta e indexes
					if (not no_refresh) then
						_details.refresh:r_ability_e_energy(ability, shadow.spell_tables)
					end
				end

			return shadow
		end

function attribute_energy:CollectGarbage(lastevent)
	return _details:CollectGarbage(class_type, lastevent)
end

function _details.refresh:r_attribute_energy(this_player, shadow)
	_setmetatable(this_player, _details.attribute_energy)
	this_player.__index = _details.attribute_energy
	
	if (shadow ~= -1) then
		this_player.shadow = shadow
		_details.refresh:r_container_combatants(this_player.targets, shadow.targets)
		_details.refresh:r_container_abilities(this_player.spell_tables, shadow.spell_tables)
	else
		_details.refresh:r_container_combatants(this_player.targets, -1)
		_details.refresh:r_container_abilities(this_player.spell_tables, -1)
	end
end

function _details.clear:c_attribute_energy(this_player)
	--this_player.__index = {}
	this_player.__index = nil
	this_player.shadow = nil
	this_player.links = nil
	this_player.my_bar = nil
	
	_details.clear:c_container_combatants(this_player.targets)
	_details.clear:c_container_abilities(this_player.spell_tables)
end

attribute_energy.__add = function(table1, table2)

	--> soma os totais das energias
		table1.mana = table1.mana + table2.mana
		table1.e_rage = table1.e_rage + table2.e_rage
		table1.e_energy = table1.e_energy + table2.e_energy
		table1.runepower = table1.runepower + table2.runepower
		table1.focus = table1.focus + table2.focus
		table1.holypower = table1.holypower + table2.holypower
		
		table1.mana_r = table1.mana_r + table2.mana_r
		table1.e_rage_r = table1.e_rage_r + table2.e_rage_r
		table1.e_energy_r = table1.e_energy_r + table2.e_energy_r
		table1.runepower_r = table1.runepower_r + table2.runepower_r
		table1.focus_r = table1.focus_r + table2.focus_r
		table1.holypower_r = table1.holypower_r + table2.holypower_r

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
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_ENERGY", false)
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
	
	return table1
end

attribute_energy.__sub = function(table1, table2)

	--> soma os totais das energias
		table1.mana = table1.mana - table2.mana
		table1.e_rage = table1.e_rage - table2.e_rage
		table1.e_energy = table1.e_energy - table2.e_energy
		table1.runepower = table1.runepower - table2.runepower
		table1.focus = table1.focus - table2.focus
		table1.holypower = table1.holypower - table2.holypower
		
		table1.mana_r = table1.mana_r - table2.mana_r
		table1.e_rage_r = table1.e_rage_r - table2.e_rage_r
		table1.e_energy_r = table1.e_energy_r - table2.e_energy_r
		table1.runepower_r = table1.runepower_r - table2.runepower_r
		table1.focus_r = table1.focus_r - table2.focus_r
		table1.holypower_r = table1.holypower_r - table2.holypower_r

	--> soma os containers de targets
		for index, dst in _ipairs(table2.targets._ActorTable) do 
			--> pega o dst no ator
			local dst_table1 = table1.targets:CatchCombatant(nil, dst.name, nil, true)
			--> soma o valor
			dst_table1.total = dst_table1.total - dst.total
		end
	
	--> soma o container de abilities
		for spellid, ability in _pairs(table2.spell_tables._ActorTable) do 
			--> pega a ability no primeiro ator
			local ability_table1 = table1.spell_tables:CatchSpell(spellid, true, "SPELL_ENERGY", false)
			--> soma os targets
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
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
