--lua locals
local _cstr = string.format
local _math_floor = math.floor
local _table_sort = table.sort
local _table_insert = table.insert
local _table_size = table.getn
local _setmetatable = setmetatable
local _getmetatable = getmetatable
local _ipairs = ipairs
local _pairs = pairs
local _rawget= rawget
local _math_min = math.min
local _math_max = math.max
local _math_abs = math.abs
local _bit_band = bit.band
local _unpack = unpack
local _type = type
--api locals
local _GetSpellInfo = _details.getspellinfo
local GameTooltip = GameTooltip
local _IsInRaid = IsInRaid
local _IsInGroup = IsInGroup
local _GetNumGroupMembers = GetNumGroupMembers
local _GetNumSubgroupMembers = GetNumSubgroupMembers
local _UnitAura = UnitAura
local _UnitGUID = UnitGUID
local _UnitName = UnitName

local _details = 		_G._details
local AceLocale = LibStub("AceLocale-3.0")
local Loc = AceLocale:GetLocale( "Details" )

local gump = 			_details.gump
local _
local dst_of_ability = 	_details.dst_of_ability
local container_abilities = 	_details.container_abilities
local container_combatants = _details.container_combatants
local container_pets =		_details.container_pets
local attribute_misc =		_details.attribute_misc
local ability_misc = 	_details.ability_misc

local container_damage_target = _details.container_type.CONTAINER_DAMAGETARGET_CLASS
local container_playernpc = _details.container_type.CONTAINER_PLAYERNPC
local container_misc = _details.container_type.CONTAINER_MISC_CLASS
local container_misc_target = _details.container_type.CONTAINER_ENERGYTARGET_CLASS
--local container_friendlyfire = _details.container_type.CONTAINER_FRIENDLYFIRE

--local mode_ALONE = _details.modes.alone
local mode_GROUP = _details.modes.group
local mode_ALL = _details.modes.all

local class_type = _details.attributes.misc

local RaidBuffsSpells = _details.RaidBuffsSpells

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

function _details.SortIfHaveKey(table1, table2)
	if (table1[keyName] and table2[keyName]) then
		return table1[keyName] > table2[keyName] 
	elseif (table1[keyName] and not table2[keyName]) then
		return true
	else
		return false
	end
end

function _details.SortGroupIfHaveKey(table1, table2)
	if (table1.group and table2.group) then
		if (table1[keyName] and table2[keyName]) then
			return table1[keyName] > table2[keyName] 
		elseif (table1[keyName] and not table2[keyName]) then
			return true
		else
			return false
		end
	elseif (table1.group and not table2.group) then
		return true
	elseif (not table1.group and table2.group) then
		return false
	else
		if (table1[keyName] and table2[keyName]) then
			return table1[keyName] > table2[keyName] 
		elseif (table1[keyName] and not table2[keyName]) then
			return true
		else
			return false
		end
	end
end

function _details.SortGroupMisc(container, keyName2)
	keyName = keyName2
	return _table_sort(container, _details.SortKeyGroupMisc)
end

function _details.SortKeyGroupMisc(table1, table2)
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

function _details.SortKeySimpleMisc(table1, table2)
	return table1[keyName] > table2[keyName]
end

function _details:ContainerSortMisc(container, amount, keyName2)
	keyName = keyName2
	_table_sort(container,  _details.SortKeySimpleMisc)
	
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

function attribute_misc:Newtable(serial, name, link)

	local _new_miscActor = {
		last_event = 0,
		type = class_type, --> attribute 4 = misc
		pets = {} --> pets? okey pets
	}
	_setmetatable(_new_miscActor, attribute_misc)
	
	return _new_miscActor
end

function _details:ToolTipDead(instance, death, this_bar, keydown)
	
	local eventos = death[1]
	local hora_of_death = death[2]
	local hp_max = death[5]
	
	local battleress = false
	local lastcooldown = false
	
	local GameCooltip = GameCooltip
	
	GameCooltip:Reset()
	GameCooltip:SetType("tooltipbar")
	GameCooltip:SetOwner(this_bar)
	
	GameCooltip:AddLine(Loc["STRING_REPORT_LEFTCLICK"], nil, 1, _unpack(self.click_to_report_color))
	GameCooltip:AddIcon([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
	GameCooltip:AddStatusBar(0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar_serenity]]})
	
	--death parser
	for index, event in _ipairs(eventos) do 
	
		local hp = _math_floor(event[5]/hp_max*100)
		if (hp > 100) then 
			hp = 100
		end
		
		local evtype = event[1]
		local spellname, _, spellicon = _GetSpellInfo(event[2])
		local amount = event[3]
		local time = event[4]
		local source = event[6]

		if (type(evtype) == "boolean") then
			--> is damage or heal
			if (evtype) then
				--> damage
				GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "-" .. _details:ToK(amount) .. "(" .. hp .. "%)", 1, "white", "white")
				GameCooltip:AddIcon(spellicon)
				
				if (event[9]) then
					--> friendly fire
					GameCooltip:AddStatusBar(hp, 1, "darkorange", true)
				else
					--> from a enemy
					GameCooltip:AddStatusBar(hp, 1, "red", true)
				end
			else
				--> heal
				GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "+" .. _details:ToK(amount) .. "(" .. hp .. "%)", 1, "white", "white")
				GameCooltip:AddIcon(spellicon)
				GameCooltip:AddStatusBar(hp, 1, "green", true)
				
			end
			
		elseif (type(evtype) == "number") then
			if (evtype == 1) then
				--> cooldown
				GameCooltip:AddLine("" .. _cstr("%.1f", time - hora_of_death) .. "s " .. spellname .. "(" .. source .. ")", "cooldown(" .. hp .. "%)", 1, "white", "white")
				GameCooltip:AddIcon(spellicon)
				GameCooltip:AddStatusBar(100, 1, "yellow", true)
				
			elseif (evtype == 2 and not battleress) then
				--> battle ress
				battleress = event
				
			elseif (evtype == 3) then
				--> last cooldown used
				lastcooldown = event
				
			end
		end
	end

	GameCooltip:AddLine(death[6] .. " " .. Loc["STRING_TIME_OF_DEATH"] , "-- -- -- ", 1, "white")
	GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\small_icons", 1, 1, nil, nil, .75, 1, 0, 1)
	GameCooltip:AddStatusBar(0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar4_vidro]]})
	
	if (battleress) then
		local name_spell, _, icon_spell = _GetSpellInfo(battleress[2])
		GameCooltip:AddLine("+" .. _cstr("%.1f", battleress[4] - hora_of_death) .. "s " .. name_spell .. "(" .. battleress[6] .. ")", "", 1, "white")
		GameCooltip:AddIcon("Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons", 1, 1, nil, nil, .75, 1, 0, 1)
		GameCooltip:AddStatusBar(0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar4_vidro]]})
	end
	
	if (lastcooldown) then
		if (lastcooldown[3] == 1) then 
			local name_spell, _, icon_spell = _GetSpellInfo(lastcooldown[2])
			GameCooltip:AddLine(_cstr("%.1f", lastcooldown[4] - hora_of_death) .. "s " .. name_spell .. "(" .. Loc["STRING_LAST_COOLDOWN"] .. ")")
			GameCooltip:AddIcon(icon_spell)
		else
			GameCooltip:AddLine(Loc["STRING_NOLAST_COOLDOWN"])
			GameCooltip:AddIcon([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]], 1, 1, 18, 18)
		end
			GameCooltip:AddStatusBar(0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture =[[Interface\AddOns\Details\images\bar_serenity]]})
	end


	GameCooltip:SetOption("StatusBarHeightMod", -6)
	GameCooltip:SetOption("FixedWidth", 300)
	GameCooltip:SetOption("TextSize", 9)
	GameCooltip:SetOption("LeftBorderSize", -4)
	GameCooltip:SetOption("RightBorderSize", 5)
	GameCooltip:SetOption("StatusBarTexture",[[Interface\AddOns\Details\images\bar4_reverse]])
	GameCooltip:SetWallpaper(1,[[Interface\AddOns\Details\images\Spellbook-Page-1]], {.6, 0.1, 0.64453125, 0}, {.8, .8, .8, 0.2}, true)
	
	GameCooltip:ShowCooltip()
	
end

local function RefreshBarDeath(death, bar, instance)
	attribute_misc:DeadActualizeBar(death, death.my_bar, bar.placing, instance)
end

--objeto death:
--[1] table[2] time[3] name[4] class[5] maxhealth[6] time of death
--[1] true damage/ false heal[2] spellid[3] amount[4] time[5] current health[6] source

function attribute_misc:ReportSingleDeadLine(death, instance)
-- 
	local bar = instance.bars[death.my_bar]
	
	local max_health = death[5]
	local time_of_death = death[2]
	
	do
		if (not _details.fontstring_len) then
			_details.fontstring_len = _details.listener:CreateFontString(nil, "background", "GameFontNormal")
		end
		local _, fontSize = FCF_GetChatWindowInfo(1)
		if (fontSize < 1) then
			fontSize = 10
		end
		local source, _, flags = _details.fontstring_len:GetFont()
		_details.fontstring_len:SetFont(source, fontSize, flags)
		_details.fontstring_len:SetText("thisisspacement")
	end
	local default_len = _details.fontstring_len:GetStringWidth()
	
	local report = {"Details! " .. Loc["STRING_REPORT_SINGLE_DEATH"] .. " " .. death[3] .. " " .. Loc["STRING_ACTORFRAME_REPORTAT"] .. " " .. death[6]}
	
	local report_array = {}
	
	for index, evento in _ipairs(death[1]) do
		if (evento[1] and type(evento[1]) == "boolean") then --> damage
			if (evento[3]) then
				local elapsed = _cstr("%.1f", evento[4] - time_of_death) .."s"
				local spellname, _, spellicon = _GetSpellInfo(evento[2])
				local spelllink
				if (evento[2] > 10) then
					spelllink = GetSpellLink(evento[2])
				else
					spelllink = spellname
				end
				local source = _details:GetOnlyName(evento[6])
				local amount = evento[3]
				local hp = _math_floor(evento[5] / max_health * 100)
				if (hp > 100) then 
					hp = 100
				end
				
				tinsert(report_array, {elapsed .. " ", spelllink, "(" .. source .. ")", "-" .. _details:ToK(amount) .. "(" .. hp .. "%) "})
			end
			
		elseif (not evento[1] and type(evento[1]) == "boolean") then --> heal
			local elapsed = _cstr("%.1f", evento[4] - time_of_death) .."s"
			local spelllink = GetSpellLink(evento[2])
			local source = _details:GetOnlyName(evento[6])
			local spellname, _, spellicon = _GetSpellInfo(evento[2])
			local amount = evento[3]
			local hp = _math_floor(evento[5] / max_health * 100)
			if (hp > 100) then 
				hp = 100
			end

			if (_details.report_heal_links) then
				tinsert(report_array, {elapsed .. " ", spelllink, "(" .. source .. ")", "+" .. _details:ToK(amount) .. "(" .. hp .. "%) "})
			else
				tinsert(report_array, {elapsed .. " ", spellname, "(" .. source .. ")", "+" .. _details:ToK(amount) .. "(" .. hp .. "%) "})
			end
		end
	end
	
	for index = #report_array, 1, -1 do
		local table = report_array[index]
		report[#report+1] = table[1] .. table[4] .. table[2] .. table[3]
	end
	
	--for index, table in _ipairs(report_array) do
	--	report[#report+1] = table[1] .. table[4] .. table[2] .. table[3]
	--end
	
	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

function attribute_misc:ReportSingleCooldownLine(misc_actor, instance)

	local bar = misc_actor.my_bar

	local report = {"Details! " .. Loc["STRING_REPORT_SINGLE_COOLDOWN"] .. " " .. bar.text_left:GetText()} --> localize-me
	report[#report+1] = "> " .. Loc["STRING_SPELLS"] .. ":"
	
	for i = 1, GameCooltip:GetNumLines() do 
		local text_left, text_right = GameCooltip:GetText(i)
		
		if (text_left and text_right) then 
			text_left = text_left:gsub(("|T(.*)|t "), "")
			report[#report+1] = "  "..text_left.." "..text_right..""
		elseif (i ~= 1) then
			report[#report+1] = "> " .. Loc["STRING_TARGETS"] .. ":"
		end
	end

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

function attribute_misc:ReportSingleBuffUptimeLine(misc_actor, instance)

	local bar = misc_actor.my_bar

	local report = {"Details! " .. Loc["STRING_REPORT_SINGLE_BUFFUPTIME"] .. " " .. bar.text_left:GetText()} --> localize-me
	report[#report+1] = "> " .. Loc["STRING_SPELLS"] .. ":"
	
	for i = 1, GameCooltip:GetNumLines() do 
		local text_left, text_right = GameCooltip:GetText(i)
		
		if (text_left and text_right) then 
			text_left = text_left:gsub(("|T(.*)|t "), "")
			report[#report+1] = "  "..text_left.." "..text_right..""
		elseif (i ~= 1) then
			report[#report+1] = "> " .. Loc["STRING_TARGETS"] .. ":"
		end
	end

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

function attribute_misc:ReportSingleDebuffUptimeLine(misc_actor, instance)

	local bar = misc_actor.my_bar

	local report = {"Details! " .. Loc["STRING_REPORT_SINGLE_DEBUFFUPTIME"]  .. " " .. bar.text_left:GetText()} --> localize-me
	report[#report+1] = "> " .. Loc["STRING_SPELLS"] .. ":"
	
	for i = 1, GameCooltip:GetNumLines() do 
		local text_left, text_right = GameCooltip:GetText(i)
		
		if (text_left and text_right) then 
			text_left = text_left:gsub(("|T(.*)|t "), "")
			report[#report+1] = "  "..text_left.." "..text_right..""
		elseif (i ~= 1) then
			report[#report+1] = "> " .. Loc["STRING_TARGETS"] .. ":"
		end
	end

	return _details:Report(report, {_no_current = true, _no_inverse = true, _custom = true})
end

function attribute_misc:DeadActualizeBar(death, which_bar, placing, instance)

	death["dead"] = true --> marca que this table é uma table de deaths, usado no controla na hora de preparer o tooltip
	local this_bar = instance.bars[which_bar] --> pega a referência da bar na window
	
	if (not this_bar) then
		print("DEBUG: problema com <instance.this_bar> "..which_bar.." "..place)
		return
	end
	
	local table_previous = this_bar.my_table
	
	this_bar.my_table = death
	
	death.name = death[3] --> evita dar erro ao redimencionar a window
	death.my_bar = which_bar
	this_bar.placing = placing
	
	if (not _getmetatable(death)) then 
		_setmetatable(death, {__call = RefreshBarDeath}) 
		death._custom = true
	end

	this_bar.text_left:SetText(placing .. ". " .. death[3]:gsub(("%-.*"), ""))
	this_bar.text_right:SetText(death[6])
	
	this_bar.statusbar:SetValue(100)
	if (this_bar.hidden or this_bar.fading_in or this_bar.faded) then
		gump:Fade(this_bar, "out")
	end
	this_bar.texture:SetVertexColor(_unpack(_details.class_colors[death[4]]))
	this_bar.icon_class:SetTexture(instance.row_info.icon_file)
	this_bar.icon_class:SetTexCoord(_unpack(CLASS_ICON_TCOORDS[death[4]]))
	
	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end

	--return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage)
end

function attribute_misc:RefreshWindow(instance, combat_table, force, export, refresh_needed)
	
	local showing = combat_table[class_type] --> o que this sendo mostrado ->[1] - damage[2] - heal --> pega o container com ._NameIndexTable ._ActorTable
	
	if (#showing._ActorTable < 1) then --> não há bars para mostrar
		return _details:HideBarsNotUsed(instance, showing)
	end
	
	local total = 0	
	instance.top = 0
	
	local sub_attribute = instance.sub_attribute --> o que this sendo mostrado nthis instância
	local content = showing._ActorTable
	local amount = #content
	local mode = instance.mode
	
	if (export) then
		if (_type(export) == "boolean") then 		
			if (sub_attribute == 1) then --> CC BREAKS
				keyName = "cc_break"
			elseif (sub_attribute == 2) then --> RESS
				keyName = "ress"
			elseif (sub_attribute == 3) then --> INTERRUPT
				keyName = "interrupt"
			elseif (sub_attribute == 4) then --> DISPELLS
				keyName = "dispell"
			elseif (sub_attribute == 5) then --> DEATHS
				keyName = "dead"
			elseif (sub_attribute == 6) then --> DEFENSIVE COOLDOWNS
				keyName = "cooldowns_defensive"
			elseif (sub_attribute == 7) then --> BUFF UPTIME
				keyName = "buff_uptime"
			elseif (sub_attribute == 8) then --> DEBUFF UPTIME
				keyName = "debuff_uptime"
			end
		else
			keyName = export.key
			mode = export.mode
		end
		
	elseif (instance.attribute == 5) then --> custom
		keyName = "custom"
		total = combat_table.totals[instance.customName]		
		
	else	
		
		--> pega which a sub key que será usada
		if (sub_attribute == 1) then --> CC BREAKS
			keyName = "cc_break"
		elseif (sub_attribute == 2) then --> RESS
			keyName = "ress"
		elseif (sub_attribute == 3) then --> INTERRUPT
			keyName = "interrupt"
		elseif (sub_attribute == 4) then --> DISPELLS
			keyName = "dispell"
		elseif (sub_attribute == 5) then --> DEATHS
			keyName = "dead"
		elseif (sub_attribute == 6) then --> DEFENSIVE COOLDOWNS
			keyName = "cooldowns_defensive"
		elseif (sub_attribute == 7) then --> BUFF UPTIME
			keyName = "buff_uptime"
		elseif (sub_attribute == 8) then --> DEBUFF UPTIME
			keyName = "debuff_uptime"
		end
	
	end
	
	if (keyName == "dead") then 
		local deaths = combat_table.last_events_tables
		--> não precisa reordenar, uma vez que sempre vai da na ordem do último a morrer até o primeiro
		-- _table_sort(deaths, function(m1, m2) return m1[2] < m2[2] end) --[1] = table com a death[2] = time[3] = name do player
		instance.top = 1
		total = #deaths
		
		if (export) then 
			return deaths
		end

		if (total < 1) then
			instance:HideScrollBar()
			return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
		end
		
		--estra showing ALL então posso seguir o padrão correto? primeiro, atualiza a scroll bar...
		instance:ActualizeScrollBar(total)
		
		--depois faz a atualização normal dele através dos iterators
		local which_bar = 1
		local bars_container = instance.bars
		local percentage_type = instance.row_info.percent_type

		if (instance.bars_sort_direction == 1) then
			for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar só o range que this sendo mostrado
				if (deaths[i]) then --> correção para um raro e desconhecido problema onde deaths[i] é nil
					attribute_misc:DeadActualizeBar(deaths[i], which_bar, i, instance)
					which_bar = which_bar+1
				end
			end
			
		elseif (instance.bars_sort_direction == 2) then
			for i = instance.barS[2], instance.barS[1], 1 do --> vai atualizar só o range que this sendo mostrado
				attribute_misc:DeadActualizeBar(deaths[i], which_bar, i, instance)
				which_bar = which_bar+1
			end
			
		end
		
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
		
	else
	
		if (instance.attribute == 5) then --> custom
			--> faz o sort da categoria e retorna o amount corrigido
			_table_sort(content, _details.SortIfHaveKey)
			
			--> não mostrar resultados com zero
			for i = amount, 1, -1 do --> de trás pra frente
				if (not content[i][keyName] or content[i][keyName] < 1) then
					amount = amount - 1
				else
					break
				end
			end

			--> pega o total ja aplicado na table do combat
			total = combat_table.totals[class_type][keyName]
			
			--> grava o total
			instance.top = content[1][keyName]
	
		elseif (mode == mode_ALL) then --> showing ALL
		
			_table_sort(content, _details.SortIfHaveKey)
			
			--> não mostrar resultados com zero
			for i = amount, 1, -1 do --> de trás pra frente
				if (not content[i][keyName] or content[i][keyName] < 1) then
					amount = amount - 1
				else
					break
				end
			end

			--> pega o total ja aplicado na table do combat
			total = combat_table.totals[class_type][keyName]
			
			--> grava o total
			instance.top = content[1][keyName]
		
		elseif (mode == mode_GROUP) then --> showing GROUP
		
			--if (refresh_needed) then
				_table_sort(content, _details.SortGroupIfHaveKey)
			--end
			
			for index, player in _ipairs(content) do
				if (player.group) then --> é um player e this em group
					if (not player[keyName] or player[keyName] < 1) then --> damage menor que 1, interromper o loop
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
	showing:remapear()

	if (export) then 
		return total, keyName, instance.top, amount
	end
	
	if (amount < 1) then --> não há bars para mostrar
		instance:HideScrollBar() --> precisaria esconder a scroll bar
		return _details:EndRefresh(instance, total, combat_table, showing) --> retorna a table que precisa ganhar o refresh
	end

	--estra showing ALL então posso seguir o padrão correto? primeiro, atualiza a scroll bar...
	instance:ActualizeScrollBar(amount)
	
	--depois faz a atualização normal dele através dos iterators
	local which_bar = 1
	local bars_container = instance.bars
	local percentage_type = instance.row_info.percent_type
	local use_animations = _details.is_using_row_animations and(not instance.baseframe.isStretching and not force)
	
	if (total == 0) then
		total = 0.00000001
	end
	
	UsingCustomLeftText = instance.row_info.textL_enable_custom_text
	UsingCustomRightText = instance.row_info.textR_enable_custom_text
	
	if (instance.bars_sort_direction == 1) then --top to bottom
		for i = instance.barS[1], instance.barS[2], 1 do --> vai atualizar só o range que this sendo mostrado
			content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, nil, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
			which_bar = which_bar+1
		end
		
	elseif (instance.bars_sort_direction == 2) then --bottom to top
		for i = instance.barS[2], instance.barS[1], 1 do --> vai atualizar só o range que this sendo mostrado
			content[i]:UpdateBar(instance, bars_container, which_bar, i, total, sub_attribute, force, keyName, nil, percentage_type, use_animations) --> instância, index, total, valor da 1º bar
			which_bar = which_bar+1
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

--self = this class de damage

function attribute_misc:Custom(_customName, _combat, sub_attribute, spell, dst)
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

function attribute_misc:UpdateBar(instance, bars_container, which_bar, place, total, sub_attribute, force, keyName, is_dead, percentage_type, use_animations)

	--print(self.ress)

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
	
	local mine_total = _math_floor(self[keyName] or 0) --> total
	if (not mine_total) then
		return
	end
	
	--local percentage = mine_total / total * 100
	if (not percentage_type or percentage_type == 1) then
		percentage = _cstr("%.1f", mine_total / total * 100)
	elseif (percentage_type == 2) then
		percentage = _cstr("%.1f", mine_total / instance.top * 100)
	end
	
	local this_percentage = _math_floor((mine_total/instance.top) * 100)

	if (UsingCustomRightText) then
		this_bar.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(mine_total, "", percentage, self))
	else
		this_bar.text_right:SetText(mine_total .."(" .. percentage .. "%)") --seta o text da right
	end
	
	if (this_bar.mouse_over and not instance.baseframe.isMoving) then --> precisa atualizar o tooltip
		gump:UpdateTooltip(which_bar, this_bar, instance)
	end
	
	actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()	

	return self:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
end

function attribute_misc:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container, use_animations)
	
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

function attribute_misc:RefreshBar(this_bar, instance, from_resize)
	
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


---------> TOOLTIPS BIFURCAÇÃO
function attribute_misc:ToolTip(instance, number, bar, keydown)
	--> seria possivel aqui colocar o icon da class dele?
	GameTooltip:ClearLines()
	GameTooltip:AddLine(bar.placing..". "..self.name)
	
	if (instance.sub_attribute == 3) then --> interrupt
		return self:ToolTipInterrupt(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 1) then --> cc_break
		return self:ToolTipCC(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 2) then --> ress 
		return self:ToolTipRess(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 4) then --> dispell
		return self:ToolTipDispell(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 5) then --> deaths
		return self:ToolTipDead(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 6) then --> defensive cooldowns
		return self:ToolTipDefensiveCooldowns(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 7) then --> buff uptime
		return self:ToolTipBuffUptime(instance, number, bar, keydown)
	elseif (instance.sub_attribute == 8) then --> debuff uptime
		return self:ToolTipDebuffUptime(instance, number, bar, keydown)
	end
end

--> tooltip locals
local r, g, b
local headerColor = "yellow"
local barAlpha = .6

function attribute_misc:ToolTipDead(instance, number, bar)
	
	local last_dead = self.dead_log[#self.dead_log]

end

function attribute_misc:ToolTipCC(instance, number, bar)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	

	local mine_total = self["cc_break"]
	local abilities = self.cc_break_spell_tables._ActorTable
	
	--> ability usada para tirar o CC

	for _spellid, _table in _pairs(abilities) do
		
		--> amount
		local name_spell, _, icon_spell = _GetSpellInfo(_spellid)
		GameCooltip:AddLine(name_spell, _table.cc_break .. "(" .. _cstr("%.1f", _table.cc_break / mine_total * 100) .. "%)")
		GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
		GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
		
		--> o que quebrou
		local quebrou_oque = _table.cc_break_oque
		for spellid_quebrada, amt_quebrada in _pairs(_table.cc_break_oque) do 
			local name_spell, _, icon_spell = _GetSpellInfo(spellid_quebrada)
			GameCooltip:AddLine(name_spell..": ", amt_quebrada)
			GameCooltip:AddIcon([[Interface\Buttons\UI-GroupLoot-Pass-Down]], nil, 1, 14, 14)
			GameCooltip:AddIcon(icon_spell, nil, 2, 14, 14)
			GameCooltip:AddStatusBar(100, 1, 1, 0, 0, .2)
		end
		
		--> em quem quebrou
		--GameCooltip:AddLine(Loc["STRING_TARGETS"] .. ":") 
		for _, target in _ipairs(_table.targets._ActorTable) do
		
			GameCooltip:AddLine(target.name..": ", target.total)
			
			local class = _details:GetClass(target.name)
			GameCooltip:AddIcon([[Interface\AddOns\Details\images\espadas]], nil, 1, 14, 14)
			if (class) then	
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], nil, 2, 14, 14, unpack(_details.class_coords[class]))
			else
				GameCooltip:AddIcon("Interface\\LFGFRAME\\LFGROLE_BW", nil, 2, 14, 14, .25, .5, 0, 1)
			end
			
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
			
		end
	end
	
	
	return true
end

function attribute_misc:ToolTipDispell(instance, number, bar)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	

	local mine_total = self["dispell"]
	local abilities = self.dispell_spell_tables._ActorTable
	
--> ability usada para dispelar
	local mine_dispells = {}
	for _spellid, _table in _pairs(abilities) do
		mine_dispells[#mine_dispells+1] = {_spellid, _table.dispell}
	end
	_table_sort(mine_dispells, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #mine_dispells)

	GameCooltip:AddIcon([[Interface\ICONS\Spell_Arcane_ArcaneTorrent]], 1, 1, 14, 14, 0.078125, 0.9375, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#mine_dispells > 0) then
		for i = 1, _math_min(25, #mine_dispells) do
			local this_ability = mine_dispells[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	else
		GameTooltip:AddLine(Loc["STRING_NO_SPELL"])
	end
	
--> quais abilities foram dispaladas
	local buffs_dispelled = {}
	for _spellid, amt in _pairs(self.dispell_oque) do
		buffs_dispelled[#buffs_dispelled+1] = {_spellid, amt}
	end
	_table_sort(buffs_dispelled, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_DISPELLED"], headerColor, r, g, b, #buffs_dispelled)

	GameCooltip:AddIcon([[Interface\ICONS\Spell_Arcane_ManaTap]], 1, 1, 14, 14, 0.078125, 0.9375, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)

	if (#buffs_dispelled > 0) then
		for i = 1, _math_min(25, #buffs_dispelled) do
			local this_ability = buffs_dispelled[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	end
	
	local targets_dispelled = {}
	for _, TargetTable in _ipairs(self.dispell_targets._ActorTable) do
		targets_dispelled[#targets_dispelled + 1] = {TargetTable.name, TargetTable.total, TargetTable.total/mine_total*100}
	end
	_table_sort(targets_dispelled, _details.Sort2)

	_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #targets_dispelled)
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\ACHIEVEMENT_GUILDPERK_EVERYONES A HERO_RANK2]], 1, 1, 14, 14, 0.078125, 0.9375, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	for i = 1, _math_min(25, #targets_dispelled) do
		if (targets_dispelled[i][2] < 1) then
			break
		end
		
		GameCooltip:AddLine(targets_dispelled[i][1]..": ", _details:comma_value(targets_dispelled[i][2]) .."(".._cstr("%.1f", targets_dispelled[i][3]).."%)")
		GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		
		local targetActor = instance.showing[4]:CatchCombatant(_, targets_dispelled[i][1])
		
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
	
--> Pet
	local mine_pets = self.pets
	if (#mine_pets > 0) then --> teve ajudantes
		
		local amount = {} --> armazena a amount de pets iguais
		local interrupts = {} --> armazena as abilities
		local targets = {} --> armazena os targets
		local totais = {} --> armazena o damage total de cada objeto
		
		for index, name in _ipairs(mine_pets) do
			if (not amount[name]) then
				amount[name] = 1
				
				local my_self = instance.showing[class_type]:CatchCombatant(nil, name)
				if (my_self) then
					totais[#totais+1] = {name, my_self.dispell}
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
					GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
				end
			
				local n = _table[1]:gsub(("%s%<.*"), "")
				GameCooltip:AddLine(n, _table[2] .. "(" .. _math_floor(_table[2]/self.dispell*100) .. "%)")
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
			
	end
	
	return true
end

local UnitReaction = UnitReaction

function _details:CloseEnemyDebuffsUptime()
	local combat = _details.table_current
	local misc_container = combat[4]._ActorTable
	
	for _, actor in _ipairs(misc_container) do 
		if (actor.boss_debuff) then
			for index, target in _ipairs(actor.debuff_uptime_targets._ActorTable) do 
				if (target.actived and target.actived_at) then
					target.uptime = target.uptime + _details._time - target.actived_at
					actor.debuff_uptime = actor.debuff_uptime + _details._time - target.actived_at
					target.actived = false
					target.actived_at = nil
				end
			end
		end
	end
	
	return
end

function _details:CatchRaidDebuffUptime(in_or_out) -- "DEBUFF_UPTIME_IN"

	if (in_or_out == "DEBUFF_UPTIME_OUT") then
		local combat = _details.table_current
		local misc_container = combat[4]._ActorTable
		
		for _, actor in _ipairs(misc_container) do 
			if (actor.debuff_uptime) then
				for spellid, spell in _pairs(actor.debuff_uptime_spell_tables._ActorTable) do 
					if (spell.actived and spell.actived_at) then
						spell.uptime = spell.uptime + _details._time - spell.actived_at
						actor.debuff_uptime = actor.debuff_uptime + _details._time - spell.actived_at
						spell.actived = false
						spell.actived_at = nil
					end
				end
			end
		end
		
		return
	end

	if (GetNumRaidMembers() > 0) then
	
		local checked = {}
		
		for raidIndex = 1, GetNumRaidMembers() do
			local his_target = _UnitGUID("raid"..raidIndex.."target")
			local rect = UnitReaction("raid"..raidIndex.."target", "player")
			if (his_target and rect and not checked[his_target] and rect <= 4) then
				
				checked[his_target] = true
				
				for debuffIndex = 1, 41 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff("raid"..raidIndex.."target", debuffIndex)
					if (name and unitCaster) then
						local playerName, realmName = _UnitName(unitCaster)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						_details.parser:add_debuff_uptime(nil, GetTime(), _UnitGUID(unitCaster), playerName, 0x00000417, his_target, _UnitName("raid"..raidIndex.."target"), 0x842, spellid, name, in_or_out)
					elseif (name and RaidBuffsSpells[spellid]) then
						local playerName, realmName = _UnitName("raid"..raidIndex)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("raid"..raidIndex), playerName, 0x00000514, _UnitGUID("raid"..raidIndex), playerName, 0x00000514, spellid, name, in_or_out)
					end
				end
			end
		end
		
	elseif (GetNumPartyMembers() > 0) then
		
		local checked = {}
		
		for raidIndex = 1, GetNumPartyMembers() do
			local his_target = _UnitGUID("party"..raidIndex.."target")
			local rect = UnitReaction("party"..raidIndex.."target", "player")
			if (his_target and not checked[his_target] and rect and rect <= 4) then
				
				checked[his_target] = true
				
				for debuffIndex = 1, 40 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff("party"..raidIndex.."target", debuffIndex)
					if (name and unitCaster) then
						local playerName, realmName = _UnitName(unitCaster)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						_details.parser:add_debuff_uptime(nil, GetTime(), _UnitGUID(unitCaster), playerName, 0x00000417, his_target, _UnitName("party"..raidIndex.."target"), 0x842, spellid, name, in_or_out)
					end
				end
			end
		end
		
		local his_target = _UnitGUID("playertarget")
		local rect = UnitReaction("playertarget", "player")
		if (his_target and not checked[his_target] and rect and rect <= 4) then
			for debuffIndex = 1, 40 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff("playertarget", debuffIndex)
				if (name and unitCaster) then
					local playerName, realmName = _UnitName(unitCaster)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end
					_details.parser:add_debuff_uptime(nil, GetTime(), _UnitGUID(unitCaster), playerName, 0x00000417, his_target, _UnitName("playertarget"), 0x842, spellid, name, in_or_out)
				end
			end
		end
		
	else
		local his_target = _UnitGUID("playertarget")
		
		if (his_target and UnitReaction("playertarget", "player") <= 4) then
			for debuffIndex = 1, 40 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitDebuff("playertarget", debuffIndex)
				if (name and unitCaster) then
					local playerName, realmName = _UnitName(unitCaster)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end
					_details.parser:add_debuff_uptime(nil, GetTime(), _UnitGUID(unitCaster), playerName, 0x00000417, his_target, _UnitName("playertarget"), 0x842, spellid, name, in_or_out)
				end
			end
		end
	end
end



function _details:CatchRaidBuffUptime(in_or_out)

	if (GetNumRaidMembers() > 0) then
	
		local pot_usage = {}
	
		--> raid groups
		for raidIndex = 1, GetNumRaidMembers() do
			for buffIndex = 1, 41 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("raid"..raidIndex, buffIndex, nil, "HELPFUL")
				
				if (name and unitCaster == "raid"..raidIndex or RaidBuffsSpells[spellid]) then
					local playerName, realmName = _UnitName("raid"..raidIndex)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end
					
					_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("raid"..raidIndex), playerName, 0x00000514, _UnitGUID("raid"..raidIndex), playerName, 0x00000514, spellid, name, in_or_out)
					
					if (in_or_out == "BUFF_UPTIME_IN") then
						if (_details.PotionList[spellid]) then
							pot_usage[playerName] = spellid
						end
					end
				end
			end
		end
		
--		/run print(GetNumSubgroupMembers());for i=1,GetNumSubgroupMembers()do print(UnitName("party"..i))end
		
		--> player sub group
		for partyIndex = 1, GetNumPartyMembers() do
			for buffIndex = 1, 41 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("party"..partyIndex, buffIndex, nil, "HELPFUL")
				
				if (name and unitCaster == "party"..partyIndex) then
					local playerName, realmName = _UnitName("party"..partyIndex)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end
					
					_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("party"..partyIndex), playerName, 0x00000514, _UnitGUID("party"..partyIndex), playerName, 0x00000514, spellid, name, in_or_out)
					
					if (in_or_out == "BUFF_UPTIME_IN") then
						if (_details.PotionList[spellid]) then
							pot_usage[playerName] = spellid
						end
					end
				end
			end
		end
		
		--> unitCaster return player instead of raidIndex
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName("player")
				
				if (in_or_out == "BUFF_UPTIME_IN") then
					if (_details.PotionList[spellid]) then
						pot_usage[playerName] = spellid
					end
				end
				
				_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("player"), playerName, 0x00000514, _UnitGUID("player"), playerName, 0x00000514, spellid, name, in_or_out)

			end
		end
		
		if (in_or_out == "BUFF_UPTIME_IN") then
			local string_output = "pre-potion: "
			for playername, potspellid in _pairs(pot_usage) do
				local name, _, icon = _GetSpellInfo(potspellid)
				local _, class = UnitClass(playername)
				local c = RAID_CLASS_COLORS[class]
				local class_color = ("ff%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
				string_output = string_output .. "|c" .. class_color .. playername .. "|r |T" .. icon .. ":14:14:0:0:64:64:0:64:0:64|t "
			end
			_details.pre_pot_used = string_output
		end
		
	elseif (GetNumPartyMembers() > 0) then
		for groupIndex = 1, GetNumPartyMembers() do 
			for buffIndex = 1, 41 do
				local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("party"..groupIndex, buffIndex, nil, "HELPFUL")
				if (name and unitCaster == "party"..groupIndex or RaidBuffsSpells[spellid]) then
				
					local playerName, realmName = _UnitName("party"..groupIndex)
					if (realmName and realmName ~= "") then
						playerName = playerName .. "-" .. realmName
					end
				
					_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("party"..groupIndex), playerName, 0x00000417, _UnitGUID("party"..groupIndex), playerName, 0x00000417, spellid, name, in_or_out)

				end
			end
		end
		
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName("player")
				_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("player"), playerName, 0x00000417, _UnitGUID("player"), playerName, 0x00000417, spellid, name, in_or_out)
			end
		end
		
	else
	
		local pot_usage = {}
	
		for buffIndex = 1, 41 do
			local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = _UnitAura("player", buffIndex, nil, "HELPFUL")
			if (name and unitCaster == "player") then
				local playerName = _UnitName("player")
				
				if (in_or_out == "BUFF_UPTIME_IN") then
					if (_details.PotionList[spellid]) then
						pot_usage[playerName] = spellid
					end
				end
				
				_details.parser:add_buff_uptime(nil, GetTime(), _UnitGUID("player"), playerName, 0x00000417, _UnitGUID("player"), playerName, 0x00000417, spellid, name, in_or_out)
			end
		end
		
		local string_output = "pre-potion: "
		
		for playername, potspellid in _pairs(pot_usage) do
			local name, _, icon = _GetSpellInfo(potspellid)
			local _, class = UnitClass(playername)
			local c = RAID_CLASS_COLORS[class]
			local class_color = ("ff%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
			string_output = string_output .. "|c" .. class_color .. playername .. "|r |T" .. icon .. ":14:14:0:0:64:64:0:64:0:64|t "
		end
		
		-- _details:Msg(string_output)
		
	end
end

local Sort2Reverse = function(a, b)
	return a[2] < b[2]
end

function attribute_misc:ToolTipDebuffUptime(instance, number, bar)
	
	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	
	
	local mine_total = self["debuff_uptime"]
	local my_table = self.debuff_uptime_spell_tables._ActorTable
	
--> ability usada para interromper
	local debuffs_used = {}
	
	local _combat_time = instance.showing:GetCombatTime()
	
	for _spellid, _table in _pairs(my_table) do
		debuffs_used[#debuffs_used+1] = {_spellid, _table.uptime}
	end
	--_table_sort(debuffs_used, Sort2Reverse)
	_table_sort(debuffs_used, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #debuffs_used)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_Safeguard]], 1, 1, 14, 14, 0.9375, 0.078125, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)

	if (#debuffs_used > 0) then
		for i = 1, _math_min(30, #debuffs_used) do
			local this_ability = debuffs_used[i]
			
			if (this_ability[2] > 0) then
				local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
				
				local minutes, seconds = _math_floor(this_ability[2]/60), _math_floor(this_ability[2]%60)
				if (this_ability[2] >= _combat_time) then
					GameCooltip:AddLine(name_spell..": ", minutes .. "m " .. seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)", nil, "gray", "gray")
					GameCooltip:AddStatusBar(100, nil, 1, 0, 1, .3, false)
				elseif (minutes > 0) then
					GameCooltip:AddLine(name_spell..": ", minutes .. "m " .. seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)")
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
				else
					GameCooltip:AddLine(name_spell..": ", seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)")
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
				end
				
				GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14) --0.03125, 0.96875, 0.03125, 0.96875
			end
		end
	else
		GameCooltip:AddLine(Loc["STRING_NO_SPELL"]) 
	end
	
	return true
	
end

function attribute_misc:ToolTipBuffUptime(instance, number, bar)
	
	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	
	
	local mine_total = self["buff_uptime"]
	local my_table = self.buff_uptime_spell_tables._ActorTable
	
--> ability usada para interromper
	local buffs_used = {}
	
	local _combat_time = instance.showing:GetCombatTime()
	
	for _spellid, _table in _pairs(my_table) do
		buffs_used[#buffs_used+1] = {_spellid, _table.uptime}
	end
	--_table_sort(buffs_used, Sort2Reverse)
	_table_sort(buffs_used, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #buffs_used)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_Safeguard]], 1, 1, 14, 14, 0.9375, 0.078125, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)

	if (#buffs_used > 0) then
		for i = 1, _math_min(30, #buffs_used) do
			local this_ability = buffs_used[i]
			
			if (this_ability[2] > 0) then
				local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
				
				local minutes, seconds = _math_floor(this_ability[2]/60), _math_floor(this_ability[2]%60)
				if (this_ability[2] >= _combat_time) then
					GameCooltip:AddLine(name_spell..": ", minutes .. "m " .. seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)", nil, "gray", "gray")
					GameCooltip:AddStatusBar(100, nil, 1, 0, 1, .3, false)
				elseif (minutes > 0) then
					GameCooltip:AddLine(name_spell..": ", minutes .. "m " .. seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)")
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
				else
					GameCooltip:AddLine(name_spell..": ", seconds .. "s" .. "(" .. _cstr("%.1f", this_ability[2] / _combat_time * 100) .. "%)")
					GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
				end
				
				GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14) --0.03125, 0.96875, 0.03125, 0.96875
			end
		end
	else
		GameCooltip:AddLine(Loc["STRING_NO_SPELL"]) 
	end
	
	return true
	
end

function attribute_misc:ToolTipDefensiveCooldowns(instance, number, bar)
	
	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	
	
	local mine_total = self["cooldowns_defensive"]
	local my_table = self.cooldowns_defensive_spell_tables._ActorTable
	
--> ability usada para interromper
	local cooldowns_used = {}
	
	for _spellid, _table in _pairs(my_table) do
		cooldowns_used[#cooldowns_used+1] = {_spellid, _table.counter}
	end
	_table_sort(cooldowns_used, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #cooldowns_used)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_Safeguard]], 1, 1, 14, 14, 0.9375, 0.078125, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#cooldowns_used > 0) then
		for i = 1, _math_min(25, #cooldowns_used) do
			local this_ability = cooldowns_used[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14) --0.03125, 0.96875, 0.03125, 0.96875
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	else
		GameCooltip:AddLine(Loc["STRING_NO_SPELL"]) 
	end

--> quem foi que o cara reviveu
	local mine_targets = self.cooldowns_defensive_targets._ActorTable
	local targets = {}
	
	for _, _table in _ipairs(mine_targets) do
		targets[#targets+1] = {_table.name, _table.total}
	end
	_table_sort(targets, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #targets)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_DefensiveStance]], 1, 1, 14, 14, 0.9375, 0.125, 0.0625, 0.9375)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#targets > 0) then
		for i = 1, _math_min(25, #targets) do
			GameCooltip:AddLine(targets[i][1]..": ", targets[i][2], 1, "white", "white")
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
			
			GameCooltip:AddIcon("Interface\\AddOns\\Details\\images\\PALADIN_HOLY", nil, nil, 14, 14)
			
			local targetActor = instance.showing[4]:CatchCombatant(_, targets[i][1])
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
	
	return true
	
end

function attribute_misc:ToolTipRess(instance, number, bar)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	

	local mine_total = self["ress"]
	local my_table = self.ress_spell_tables._ActorTable
	
--> ability usada para interromper
	local mine_ress = {}
	
	for _spellid, _table in _pairs(my_table) do
		mine_ress[#mine_ress+1] = {_spellid, _table.ress}
	end
	_table_sort(mine_ress, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #mine_ress)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Paladin_BlessedMending]], 1, 1, 14, 14, 0.098125, 0.828125, 0.953125, 0.168125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#mine_ress > 0) then
		for i = 1, _math_min(3, #mine_ress) do
			local this_ability = mine_ress[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	else
		GameCooltip:AddLine(Loc["STRING_NO_SPELL"]) 
	end

--> quem foi que o cara reviveu
	local mine_targets = self.ress_targets._ActorTable
	local targets = {}
	
	for _, _table in _ipairs(mine_targets) do
		targets[#targets+1] = {_table.name, _table.total}
	end
	_table_sort(targets, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_TARGETS"], headerColor, r, g, b, #targets)
	--GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_DeathKnight_IcyGrip]], 1, 1, 14, 14, 0.9375, 0.078125, 0.953125, 0.078125)
	
	GameCooltip:AddIcon([[Interface\AddOns\Details\images\Ability_Priest_Cascade]], 1, 1, 14, 14, 0.9375, 0.0625, 0.0625, 0.9375)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#targets > 0) then
		for i = 1, _math_min(3, #targets) do
			GameCooltip:AddLine(targets[i][1]..": ", targets[i][2])
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
			
			local targetActor = instance.showing[4]:CatchCombatant(_, targets[i][1])
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
	
	return true

end

function attribute_misc:ToolTipInterrupt(instance, number, bar)

	local owner = self.owner
	if (owner and owner.class) then
		r, g, b = unpack(_details.class_colors[owner.class])
	else
		r, g, b = unpack(_details.class_colors[self.class])
	end	

	local mine_total = self["interrupt"]
	local my_table = self.interrupt_spell_tables._ActorTable
	
--> ability usada para interromper
	local mine_interrupts = {}
	
	for _spellid, _table in _pairs(my_table) do
		mine_interrupts[#mine_interrupts+1] = {_spellid, _table.counter}
	end
	_table_sort(mine_interrupts, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELLS"], headerColor, r, g, b, #mine_interrupts)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_PunishingBlow]], 1, 1, 14, 14, 0.9375, 0.078125, 0.078125, 0.953125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#mine_interrupts > 0) then
		for i = 1, _math_min(25, #mine_interrupts) do
			local this_ability = mine_interrupts[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	else
		GameTooltip:AddLine(Loc["STRING_NO_SPELL"])
	end
	
--> quais abilities foram interrompidas
	local abilities_interrompidas = {}
	
	for _spellid, amt in _pairs(self.interrompeu_oque) do
		abilities_interrompidas[#abilities_interrompidas+1] = {_spellid, amt}
	end
	_table_sort(abilities_interrompidas, _details.Sort2)
	
	_details:AddTooltipSpellHeaderText(Loc["STRING_SPELL_INTERRUPTED"] .. ":", headerColor, r, g, b, #abilities_interrompidas)
	GameCooltip:AddIcon([[Interface\ICONS\Ability_Warrior_Sunder]], 1, 1, 14, 14, 0.078125, 0.9375, 0.128125, 0.913125)
	GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
	
	if (#abilities_interrompidas > 0) then
		for i = 1, _math_min(25, #abilities_interrompidas) do
			local this_ability = abilities_interrompidas[i]
			local name_spell, _, icon_spell = _GetSpellInfo(this_ability[1])
			GameCooltip:AddLine(name_spell..": ", this_ability[2].."(".._cstr("%.1f", this_ability[2]/mine_total*100).."%)")
			GameCooltip:AddIcon(icon_spell, nil, nil, 14, 14)
			GameCooltip:AddStatusBar(100, 1, .1, .1, .1, .3)
		end
	end
	
--> Pet
	local mine_pets = self.pets
	if (#mine_pets > 0) then --> teve ajudantes
		
		local amount = {} --> armazena a amount de pets iguais
		local interrupts = {} --> armazena as abilities
		local targets = {} --> armazena os targets
		local totais = {} --> armazena o damage total de cada objeto
		
		for index, name in _ipairs(mine_pets) do
			if (not amount[name]) then
				amount[name] = 1
				
				local my_self = instance.showing[class_type]:CatchCombatant(nil, name)
				if (my_self) then
					totais[#totais+1] = {name, my_self.interrupt}
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
					GameCooltip:AddStatusBar(100, 1, r, g, b, barAlpha)
				end
			
				local n = _table[1]:gsub(("%s%<.*"), "")
				GameCooltip:AddLine(n, _table[2] .. "(" .. _math_floor(_table[2]/self.interrupt*100) .. "%)")
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon([[Interface\AddOns\Details\images\classes_small]], 1, 1, 14, 14, 0.25, 0.49609375, 0.75, 1)
			end
		end
			
	end
	
	return true
end


--------------------------------------------- // JANELA DETALHES // ---------------------------------------------


---------> DETALHES BIFURCAÇÃO
function attribute_misc:SetInfo()
	if (info.sub_attribute == 3) then --> interrupt
		return self:SetInfoInterrupt()
	end
end

---------> DETALHES bloco da right BIFURCAÇÃO
function attribute_misc:SetDetails(spellid, bar)
	if (info.sub_attribute == 3) then --> interrupt
		return self:SetDetailsInterrupt(spellid, bar)
	end
end

------ Interrupt
function attribute_misc:SetInfoInterrupt()

	local mine_total = self["interrupt"]
	local my_table = self.interrupt_spell_tables._ActorTable

	local bars = info.bars1
	local instance = info.instance
	
	local mine_interrupts = {}

	--player
	for _spellid, _table in _pairs(my_table) do --> da foreach em cada spellid do container
		local name, _, icon = _GetSpellInfo(_spellid)
		_table_insert(mine_interrupts, {_spellid, _table.counter, _table.counter/mine_total*100, name, icon})
	end
	--pet
	local ActorPets = self.pets
	local class_color = "FFDDDDDD"
	for _, PetName in _ipairs(ActorPets) do
		local PetActor = instance.showing(class_type, PetName)
		if (PetActor and PetActor.interrupt and PetActor.interrupt > 0) then 
			local PetSkillsContainer = PetActor.interrupt_spell_tables._ActorTable
			for _spellid, _skill in _pairs(PetSkillsContainer) do --> da foreach em cada spellid do container
				local name, _, icon = _GetSpellInfo(_spellid)
				_table_insert(mine_interrupts, {_spellid, _skill.counter, _skill.counter/mine_total*100, name .. "(|c" .. class_color .. PetName:gsub((" <.*"), "") .. "|r)", icon, PetActor})
			end
		end
	end
	
	_table_sort(mine_interrupts, _details.Sort2)

	local amt = #mine_interrupts
	gump:JI_UpdateContainerBars(amt)

	local max_ = mine_interrupts[1][2] --> damage que a primeiro spell vez

	local bar
	for index, table in _ipairs(mine_interrupts) do

		bar = bars[index]

		if (not bar) then --> se a bar não existir, create ela então
			bar = gump:CreateNewBarInfo1(instance, index)
			
			bar.texture:SetStatusBarColor(1, 1, 1, 1) --> isso aqui é a parte da seleção e desceleção
			bar.on_focus = false --> isso aqui é a parte da seleção e desceleção
		end

		--> isso aqui é tudo da seleção e desceleção das bars
		
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
		bar.text_right:SetText(table[2] .." ".. instance.dividers.open .._cstr("%.1f", table[3]) .."%".. instance.dividers.close) --seta o text da right
		
		bar.icon:SetTexture(table[5])

		bar.my_table = self --> grava o player na barrinho... é estranho pq todas as bars vão ter o mesmo valor do player
		bar.show = table[1] --> grava o spellid na bar
		bar:Show() --> mostra a bar

		-- player . details ?? 
		if (self.details and self.details == bar.show) then
			self:SetDetails(self.details, bar) --> poderia deixar isso pro final e preparer uma tail call??
		end
	end
	
	
	
	--[
	--> Targets do interrupt
	local mine_targets = {}
	for _, table in _pairs(self.interrupt_targets._ActorTable) do
		mine_targets[#mine_targets+1] = {table.name, table.total}
	end
	_table_sort(mine_targets, _details.Sort2)
	
	local amt_targets = #mine_targets
	if (amt_targets < 1) then
		return
	end
	gump:JI_UpdateContainerTargets(amt_targets)
	
	local max_targets = mine_targets[1][2]
	
	local bar
	for index, table in _ipairs(mine_targets) do
	
		bar = info.bars2[index]
		
		if (not bar) then
			bar = gump:CreateNewBarInfo2(instance, index)
			bar.texture:SetStatusBarColor(1, 1, 1, 1)
		end
		
		if (index == 1) then
			bar.texture:SetValue(100)
		else
			bar.texture:SetValue(table[2]/max_targets*100)
		end

		bar.text_left:SetText(index..instance.dividers.placing..table[1]) --seta o text da esqueda
		bar.text_right:SetText(table[2] .." ".. instance.dividers.open .._cstr("%.1f", table[2]/mine_total*100) .. instance.dividers.close) --seta o text da right
		
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
		
		--gump:TextBarOnInfo2(index, , )
		-- o que mostrar no local do ícone?
		--bar.icon:SetTexture(table[4][3])
		
		bar.my_table = self --> grava o player na table
		bar.name_enemy = table[1] --> salva o name do enemy na bar --> isso é necessário?
		
		-- no place do spell id colocar o que?
		--bar.spellid = table[5]
		bar:Show()
		
		--if (self.details and self.details == bar.spellid) then
		--	self:SetDetails(self.details, bar)
		--end
	end
	--]]

end


------ Detail Info Interrupt
function attribute_misc:SetDetailsInterrupt(spellid, bar)

	for _, bar in _ipairs(info.bars3) do 
		bar:Hide()
	end

	local this_spell = self.interrupt_spell_tables._ActorTable[spellid]
	if (not this_spell) then
		return
	end
	
	--> icon direito superior
	local name, _, icon = _GetSpellInfo(spellid)
	local infospell = {name, nil, icon}

	_details.window_info.spell_icon:SetTexture(infospell[3])

	local total = self.interrupt
	local mine_total = this_spell.counter
	
	local index = 1
	
	local data = {}	
	
	local bars = info.bars3
	local instance = info.instance
	
	local abilities_targets = {}
	for spellid, amt in pairs(this_spell.interrompeu_oque) do 
		abilities_targets[#abilities_targets+1] = {spellid, amt}
	end
	_table_sort(abilities_targets, _details.Sort2)
	local max_ = abilities_targets[1][2]
	
	local bar
	for index, table in _ipairs(abilities_targets) do
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
		
		local name, _, icon = _GetSpellInfo(table[1])

		bar.text_left:SetText(index..instance.dividers.placing..name) --seta o text da esqueda
		bar.text_right:SetText(table[2] .." ".. instance.dividers.open .._cstr("%.1f", table[2]/total*100) .."%".. instance.dividers.close) --seta o text da right
		
		bar.icon:SetTexture(icon)

		bar:Show() --> mostra a bar
		
		if (index == 15) then 
			break
		end
	end
	
end


function attribute_misc:SetTooltipTargets(this_bar, index)
	
	local enemy = this_bar.name_enemy
	
	local container
	if (info.instance.sub_attribute == 3) then --interrupt
		container = self.interrupt_spell_tables._ActorTable
	end
	
	local abilities = {}
	local total = self.interrupt
	
	for spellid, table in _pairs(container) do
		--> table = class_damage_ability
		local targets = table.targets._ActorTable
		for _, table in _ipairs(targets) do
			--> table = class_target
			if (table.name == enemy) then
				abilities[#abilities+1] = {spellid, table.total}
			end
		end
	end
	
	table.sort(abilities, function(a, b) return a[2] > b[2] end)
	
	GameTooltip:AddLine(index..". "..enemy)
	GameTooltip:AddLine(Loc["STRING_SPELL_INTERRUPTED"] .. ":") 
	GameTooltip:AddLine(" ")
	
	for index, table in _ipairs(abilities) do
		local name, rank, icon = _GetSpellInfo(table[1])
		if (index < 8) then
			GameTooltip:AddDoubleLine(index..". |T"..icon..":0|t "..name, table[2].."(".._cstr("%.1f", table[2]/total*100).."%)", 1, 1, 1, 1, 1, 1)
			--GameTooltip:AddTexture(icon)
		else
			GameTooltip:AddDoubleLine(index..". "..name, table[2].."(".._cstr("%.1f", table[2]/total*100).."%)", .65, .65, .65, .65, .65, .65)
		end
	end
	
	return true
	--GameTooltip:AddDoubleLine(mine_damages[i][4][1]..": ", mine_damages[i][2].."(".._cstr("%.1f", mine_damages[i][3]).."%)", 1, 1, 1, 1, 1, 1)
	
end


--if (this_spell.counter == this_spell.c_amt) then --> só teve critical
--	gump:SetaDetailInfoText(1, nil, nil, nil, nil, nil, "DPS: "..crit_dps)
--end

--controla se o dps do player this travado ou destravado
function attribute_misc:Initialize(initialize)
	return false --retorna se o dps this aberto ou closedo para this player
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core functions

	--> atualize a func de opsendcao
		function attribute_misc:UpdateSelectedToKFunction()
			SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
			FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
			TooltipMaximizedMethod = _details.tooltip.maximize_method
		end
		

	local sub_list = {"cc_break", "ress", "interrupt", "cooldowns_defensive", "dispell", "dead"}

	--> subtract total from a combat table
		function attribute_misc:subtract_total(combat_table)
			for _, sub_attribute in _ipairs(sub_list) do 
				if (self[sub_attribute]) then
					combat_table.totals[class_type][sub_attribute] = combat_table.totals[class_type][sub_attribute] - self[sub_attribute]
					if (self.group) then
						combat_table.totals_group[class_type][sub_attribute] = combat_table.totals_group[class_type][sub_attribute] - self[sub_attribute]
					end
				end
			end
		end
		function attribute_misc:add_total(combat_table)
			for _, sub_attribute in _ipairs(sub_list) do 
				if (self[sub_attribute]) then
					combat_table.totals[class_type][sub_attribute] = combat_table.totals[class_type][sub_attribute] + self[sub_attribute]
					if (self.group) then
						combat_table.totals_group[class_type][sub_attribute] = combat_table.totals_group[class_type][sub_attribute] + self[sub_attribute]
					end
				end
			end
		end
		
	--> restore e liga o ator com a sua shadow durante a inicialização
	
		function attribute_misc:r_onlyrefresh_shadow(actor)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_misc = _details.table_overall[4]
				local shadow = overall_misc._ActorTable[overall_misc._NameIndexTable[actor.name]]
			
				if (not actor.name) then
					actor.name = "unknown"
				end
				
				if (not shadow) then 
					shadow = overall_misc:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end

			--> aplica a meta e indexes
				_details.refresh:r_attribute_misc(actor, shadow)

			--> somar os targets do ator
				local somar_targets = function(container)
					for index, dst in _ipairs(actor[container]._ActorTable) do
						--> cria e soma o valor do total
						local dst_shadow = shadow[container]:CatchCombatant(nil, dst.name, nil, true)
						--> refresh no dst
						_details.refresh:r_dst_of_ability(dst, shadow[container])
					end
				end
			--> somar as abilities do ator
				local somar_abilities = function(container, shadow)
					for spellid, ability in _pairs(actor[container]._ActorTable) do 
						--> cria e soma o valor
						local ability_shadow = shadow[container]:CatchSpell(spellid, true, nil, true)
						--> refresh e soma os valores dos targets
						for index, dst in _ipairs(ability.targets._ActorTable) do 
							--> cria e soma o valor do total
							local dst_shadow = ability_shadow.targets:CatchCombatant(nil, dst.name, nil, true)
							--> refresh no dst da ability
							_details.refresh:r_dst_of_ability(dst, ability_shadow.targets)
						end
						--> refresh na ability
						_details.refresh:r_ability_misc(ability, shadow[container])
					end
				end
				
			--> cooldowns
				if (actor.cooldowns_defensive) then
					--> copia o container de targets(captura de dados)
						somar_targets("cooldowns_defensive_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("cooldowns_defensive_spell_tables", shadow)
				end
				
			--> buff uptime
				if (actor.buff_uptime) then
					--> copia o container de targets(captura de dados)
						somar_targets("buff_uptime_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("buff_uptime_spell_tables", shadow)
				end
				
			--> debuff uptime
				if (actor.debuff_uptime) then
					--> copia o container de targets(captura de dados)
						somar_targets("debuff_uptime_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("debuff_uptime_spell_tables", shadow)
				end
				
			--> interrupt
				if (actor.interrupt) then
					--> copia o container de targets(captura de dados)
						somar_targets("interrupt_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("interrupt_spell_tables", shadow)
					--> copia o que cada ability interrompeu
						for spellid, ability in _pairs(actor.interrupt_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.interrupt_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities interrompidas
							ability_shadow.interrompeu_oque = ability_shadow.interrompeu_oque or {}
						end
				end

			--> ress
				if (actor.ress) then
					--> copia o container de targets(captura de dados)
						somar_targets("ress_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("ress_spell_tables", shadow)
				end

			--> dispell
				if (actor.dispell) then
					--> copia o container de targets(captura de dados)
						somar_targets("dispell_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("dispell_spell_tables", shadow)
					--> copia o que cada ability dispelou
						for spellid, ability in _pairs(actor.dispell_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.dispell_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities dispeladas
							ability_shadow.dispell_oque = ability_shadow.dispell_oque or {}
						end
				end
			--> cc break
				if (actor.cc_break) then
					--> copia o container de targets(captura de dados)
						somar_targets("cc_break_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("cc_break_spell_tables", shadow)
					--> copia o que cada ability quebrou
						for spellid, ability in _pairs(actor.cc_break_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.cc_break_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities quebradas
							ability_shadow.cc_break_oque = ability_shadow.cc_break_oque or {}
						end
				end

			return shadow
		
		end
	
		function attribute_misc:r_connect_shadow(actor, no_refresh)
		
			--> create uma shadow desse ator se ainda não tiver uma
				local overall_misc = _details.table_overall[4]
				local shadow = overall_misc._ActorTable[overall_misc._NameIndexTable[actor.name]]
			
				if (not actor.name) then
					actor.name = "unknown"
				end
				
				if (not shadow) then 
					shadow = overall_misc:CatchCombatant(actor.serial, actor.name, actor.flag_original, true)
					shadow.class = actor.class
					shadow.group = actor.group
				end

			--> aplica a meta e indexes
				if (not no_refresh) then
					_details.refresh:r_attribute_misc(actor, shadow)
				end

			--> somar as keys das abilities
				local somar_keys = function(ability, ability_shadow)
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
				end
			--> somar os targets do ator
				local somar_targets = function(container)
					for index, dst in _ipairs(actor[container]._ActorTable) do
						--> cria e soma o valor do total
						--if (shadow[container]) then -- index ?? a nil value
							local dst_shadow = shadow[container]:CatchCombatant(nil, dst.name, nil, true)
							dst_shadow.total = dst_shadow.total + dst.total
							if (dst.uptime) then --> boss debuff
								dst_shadow.uptime = dst_shadow.uptime + dst.uptime
								dst_shadow.activedamt = dst_shadow.activedamt + dst.activedamt
							end
						--end
						--> refresh no dst
						if (not no_refresh) then
							_details.refresh:r_dst_of_ability(dst, shadow[container])
						end
						
					end
				end
			--> somar as abilities do ator
				local somar_abilities = function(container, shadow)
					for spellid, ability in _pairs(actor[container]._ActorTable) do 
						--> cria e soma o valor
						local ability_shadow = shadow[container]:CatchSpell(spellid, true, nil, true)
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
						somar_keys(ability, ability_shadow)
						--> refresh na ability
						if (not no_refresh) then
							_details.refresh:r_ability_misc(ability, shadow[container])
						end
					end
				end
				
			--> cooldowns
				if (actor.cooldowns_defensive) then
				
					--> verifica se tem o container
						if (not shadow.cooldowns_defensive_targets) then
							shadow.cooldowns_defensive = 0
							shadow.cooldowns_defensive_targets = container_combatants:NewContainer(container_damage_target)
							shadow.cooldowns_defensive_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS)
						end
				
					--> soma o total(captura de dados)
						shadow.cooldowns_defensive = shadow.cooldowns_defensive + actor.cooldowns_defensive
					--> total no combat overall(captura de dados)
						_details.table_overall.totals[4].cooldowns_defensive = _details.table_overall.totals[4].cooldowns_defensive + actor.cooldowns_defensive
						if (actor.group) then
							_details.table_overall.totals_group[4].cooldowns_defensive = _details.table_overall.totals_group[4].cooldowns_defensive + actor.cooldowns_defensive
						end
					--> copia o container de targets(captura de dados)
						somar_targets("cooldowns_defensive_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("cooldowns_defensive_spell_tables", shadow)
				end
				
			--> buff uptime
				if (actor.buff_uptime) then
				
					--> verifica se tem o container
						if (not shadow.buff_uptime_spell_targets) then
							shadow.buff_uptime = 0
							shadow.buff_uptime_spell_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
							shadow.buff_uptime_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
						end
				
					--> soma o total(captura de dados)
						shadow.buff_uptime = shadow.buff_uptime + actor.buff_uptime
					--> copia o container de targets(captura de dados)
						somar_targets("buff_uptime_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("buff_uptime_spell_tables", shadow)
				end
				
			--> debuff uptime
				if (actor.debuff_uptime) then
				
					--> verifica se tem o container
						if (not shadow.debuff_uptime_targets) then
							shadow.debuff_uptime = 0
							if (actor.boss_debuff) then
								shadow.debuff_uptime_targets = container_combatants:NewContainer(_details.container_type.CONTAINER_ENEMYDEBUFFTARGET_CLASS)
								shadow.boss_debuff = true
								shadow.damage_twin = actor.damage_twin
								shadow.spellschool = actor.spellschool
								shadow.damage_spellid = actor.damage_spellid
								shadow.debuff_uptime = 0
							else
								shadow.debuff_uptime_targets = container_combatants:NewContainer(container_damage_target)
							end
							shadow.debuff_uptime_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS)
						end
				
					--> soma o total(captura de dados)
						shadow.debuff_uptime = shadow.debuff_uptime + actor.debuff_uptime
					--> copia o container de targets(captura de dados)
						somar_targets("debuff_uptime_targets", shadow)
					--> copia o container de abilities(captura de dados)
						somar_abilities("debuff_uptime_spell_tables", shadow)
				end
				
			--> interrupt
				if (actor.interrupt) then
				
					--verifica se tem o container
						if (not shadow.interrupt_targets) then
							shadow.interrupt = 0
							shadow.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
							shadow.interrupt_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
							shadow.interrompeu_oque = {}
						end
				
					--> soma o total(captura de dados)
						shadow.interrupt = shadow.interrupt + actor.interrupt
					--> total no combat overall(captura de dados)
						_details.table_overall.totals[4].interrupt = _details.table_overall.totals[4].interrupt + actor.interrupt
						if (actor.group) then
							_details.table_overall.totals_group[4].interrupt = _details.table_overall.totals_group[4].interrupt + actor.interrupt
						end
					--> copia o container de targets(captura de dados)
						somar_targets("interrupt_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("interrupt_spell_tables", shadow)
					--> copia o que cada ability interrompeu
						for spellid, ability in _pairs(actor.interrupt_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.interrupt_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities interrompidas
							ability_shadow.interrompeu_oque = ability_shadow.interrompeu_oque or {}
							for _spellid, amount in _pairs(ability.interrompeu_oque) do
								if (ability_shadow.interrompeu_oque[_spellid]) then
									ability_shadow.interrompeu_oque[_spellid] = ability_shadow.interrompeu_oque[_spellid] + amount
								else
									ability_shadow.interrompeu_oque[_spellid] = amount
								end
							end
						end
					--> copia o que ator interrompeu
						for spellid, amount in _pairs(actor.interrompeu_oque) do 
							if (not shadow.interrompeu_oque[spellid]) then 
								shadow.interrompeu_oque[spellid] = 0
							end
							shadow.interrompeu_oque[spellid] = shadow.interrompeu_oque[spellid] + amount
						end
				end

			--> ress
				if (actor.ress) then
					
					--> verifica se tem o container
						if (not shadow.ress_targets) then
							shadow.ress = 0
							shadow.ress_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
							shadow.ress_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
						end
				
					--> soma o total(captura de dados)
						shadow.ress = shadow.ress + actor.ress
					--> total no combat overall(captura de dados)
						_details.table_overall.totals[4].ress = _details.table_overall.totals[4].ress + actor.ress
						if (actor.group) then
							_details.table_overall.totals_group[4].ress = _details.table_overall.totals_group[4].ress + actor.ress
						end
					--> copia o container de targets(captura de dados)
						somar_targets("ress_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("ress_spell_tables", shadow)
				end

			--> dispell
				if (actor.dispell) then
				
					--> verifica se tem o container
						if (not shadow.dispell_targets) then
							shadow.dispell = 0
							shadow.dispell_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
							shadow.dispell_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
							shadow.dispell_oque = {}
						end
				
					--> soma o total(captura de dados)
						shadow.dispell = shadow.dispell + actor.dispell
					--> total no combat overall(captura de dados)	
						_details.table_overall.totals[4].dispell = _details.table_overall.totals[4].dispell + actor.dispell
						if (actor.group) then
							_details.table_overall.totals_group[4].dispell = _details.table_overall.totals_group[4].dispell + actor.dispell
						end
					--> copia o container de targets(captura de dados)
						somar_targets("dispell_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("dispell_spell_tables", shadow)
					--> copia o que cada ability dispelou
						for spellid, ability in _pairs(actor.dispell_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.dispell_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities dispeladas
							ability_shadow.dispell_oque = ability_shadow.dispell_oque or {}
							for _spellid, amount in _pairs(ability.dispell_oque) do
								if (ability_shadow.dispell_oque[_spellid]) then
									ability_shadow.dispell_oque[_spellid] = ability_shadow.dispell_oque[_spellid] + amount
								else
									ability_shadow.dispell_oque[_spellid] = amount
								end
							end
						end
					--> copia o que ator dispelou
						for spellid, amount in _pairs(actor.dispell_oque) do 
							if (not shadow.dispell_oque[spellid]) then 
								shadow.dispell_oque[spellid] = 0
							end
							shadow.dispell_oque[spellid] = shadow.dispell_oque[spellid] + amount
						end					
					
				end
			--> cc break
				if (actor.cc_break) then
				
					--> verifica se tem o container
						if (not shadow.cc_break) then
							shadow.cc_break = 0
							shadow.cc_break_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
							shadow.cc_break_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
							shadow.cc_break_oque = {}
						end
				
					--> soma o total(captura de dados)
						shadow.cc_break = shadow.cc_break + actor.cc_break
					--> total no combat overall(captura de dados)	
						_details.table_overall.totals[4].cc_break = _details.table_overall.totals[4].cc_break + actor.cc_break
						if (actor.group) then
							_details.table_overall.totals_group[4].cc_break = _details.table_overall.totals_group[4].cc_break + actor.cc_break
						end
					--> copia o container de targets(captura de dados)
						somar_targets("cc_break_targets", shadow)
					--> copia o container de abilities(captura de dados)	
						somar_abilities("cc_break_spell_tables", shadow)
					--> copia o que cada ability quebrou
						for spellid, ability in _pairs(actor.cc_break_spell_tables._ActorTable) do 
							--> pega o actor da shadow
							local ability_shadow = shadow.cc_break_spell_tables:CatchSpell(spellid, true, nil, true)
							--> copia as abilities quebradas
							ability_shadow.cc_break_oque = ability_shadow.cc_break_oque or {}
							for _spellid, amount in _pairs(ability.cc_break_oque) do
								if (ability_shadow.cc_break_oque[_spellid]) then
									ability_shadow.cc_break_oque[_spellid] = ability_shadow.cc_break_oque[_spellid] + amount
								else
									ability_shadow.cc_break_oque[_spellid] = amount
								end
							end
						end
					--> copia o que ator quebrou
						for spellid, amount in _pairs(actor.cc_break_oque) do 
							if (not shadow.cc_break_oque[spellid]) then 
								shadow.cc_break_oque[spellid] = 0
							end
							shadow.cc_break_oque[spellid] = shadow.cc_break_oque[spellid] + amount
						end
				end

			return shadow
		
		end

function attribute_misc:CollectGarbage(lastevent)
	return _details:CollectGarbage(class_type, lastevent)
end


function _details.refresh:r_attribute_misc(this_player, shadow)
	_setmetatable(this_player, _details.attribute_misc)
	this_player.__index = _details.attribute_misc

	this_player.shadow = shadow
	
	--> refresh interrupts
	if (this_player.interrupt_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.interrupt_targets) then
				shadow.interrupt = 0
				shadow.interrupt_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				shadow.interrupt_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
				shadow.interrompeu_oque = {}
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.interrupt_targets, shadow.interrupt_targets)
			_details.refresh:r_container_abilities(this_player.interrupt_spell_tables, shadow.interrupt_spell_tables)
	end
	
	--> refresh buff uptime
	if (this_player.buff_uptime_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.buff_uptime_spell_targets) then
				shadow.buff_uptime = 0
				shadow.buff_uptime_spell_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				shadow.buff_uptime_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.buff_uptime_targets, shadow.buff_uptime_targets)
			_details.refresh:r_container_abilities(this_player.buff_uptime_spell_tables, shadow.buff_uptime_spell_tables)
	end
	
	--> refresh buff uptime
	if (this_player.debuff_uptime_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.debuff_uptime_targets) then
				shadow.debuff_uptime = 0
				if (this_player.boss_debuff) then
					shadow.debuff_uptime_targets = container_combatants:NewContainer(_details.container_type.CONTAINER_ENEMYDEBUFFTARGET_CLASS)
					shadow.boss_debuff = true
					shadow.damage_twin = this_player.damage_twin
					shadow.spellschool = this_player.spellschool
					shadow.damage_spellid = this_player.damage_spellid
					shadow.debuff_uptime = 0
				else
					shadow.debuff_uptime_targets = container_combatants:NewContainer(container_damage_target)
				end
				shadow.debuff_uptime_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS)
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.debuff_uptime_targets, shadow.debuff_uptime_targets)
			_details.refresh:r_container_abilities(this_player.debuff_uptime_spell_tables, shadow.debuff_uptime_spell_tables)
	end
	
	--> refresh cooldowns defensive
	if (this_player.cooldowns_defensive_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.cooldowns_defensive_targets) then
				shadow.cooldowns_defensive = 0
				shadow.cooldowns_defensive_targets = container_combatants:NewContainer(container_damage_target)
				shadow.cooldowns_defensive_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS)
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.cooldowns_defensive_targets, shadow.cooldowns_defensive_targets)
			_details.refresh:r_container_abilities(this_player.cooldowns_defensive_spell_tables, shadow.cooldowns_defensive_spell_tables)
	end
	
	--> refresh ressers
	if (this_player.ress_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.ress_targets) then
				shadow.ress = 0
				shadow.ress_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				shadow.ress_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.ress_targets, shadow.ress_targets)
			_details.refresh:r_container_abilities(this_player.ress_spell_tables, shadow.ress_spell_tables)
	end
	
	--> refresh dispells
	if (this_player.dispell_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.dispell_targets) then
				shadow.dispell = 0
				shadow.dispell_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				shadow.dispell_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
				shadow.dispell_oque = {}
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.dispell_targets, shadow.dispell_targets)
			_details.refresh:r_container_abilities(this_player.dispell_spell_tables, shadow.dispell_spell_tables)
	end
	
	--> refresh cc_breaks
	if (this_player.cc_break_targets) then
		--> constrói os containers na shadow se não existir
			if (not shadow.cc_break) then
				shadow.cc_break = 0
				shadow.cc_break_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
				shadow.cc_break_spell_tables = container_abilities:NewContainer(_details.container_type.CONTAINER_MISC_CLASS) --> cria o container das abilities usadas para interromper
				shadow.cc_break_oque = {}
			end
		--> recupera metas e indexes
			_details.refresh:r_container_combatants(this_player.cc_break_targets, shadow.cc_break_targets)
			_details.refresh:r_container_abilities(this_player.cc_break_spell_tables, shadow.cc_break_spell_tables)
	end

end

function _details.clear:c_attribute_misc(this_player)

	--this_player.__index = {}
	this_player.__index = nil
	this_player.shadow = nil
	this_player.links = nil
	this_player.my_bar = nil
	
	if (this_player.interrupt_targets) then
		_details.clear:c_container_combatants(this_player.interrupt_targets)
		_details.clear:c_container_abilities(this_player.interrupt_spell_tables)
	end
	
	if (this_player.cooldowns_defensive_targets) then
		_details.clear:c_container_combatants(this_player.cooldowns_defensive_targets)
		_details.clear:c_container_abilities(this_player.cooldowns_defensive_spell_tables)
	end
	
	if (this_player.buff_uptime_targets) then
		_details.clear:c_container_combatants(this_player.buff_uptime_targets)
		_details.clear:c_container_abilities(this_player.buff_uptime_spell_tables)
	end
	
	if (this_player.debuff_uptime_targets) then
		_details.clear:c_container_combatants(this_player.debuff_uptime_targets)
		_details.clear:c_container_abilities(this_player.debuff_uptime_spell_tables)
	end
	
	if (this_player.ress_targets) then
		_details.clear:c_container_combatants(this_player.ress_targets)
		_details.clear:c_container_abilities(this_player.ress_spell_tables)
	end
	
	if (this_player.cc_break_targets) then
		_details.clear:c_container_combatants(this_player.cc_break_targets)
		_details.clear:c_container_abilities(this_player.cc_break_spell_tables)
	end
	
	if (this_player.dispell_targets) then
		_details.clear:c_container_combatants(this_player.dispell_targets)
		_details.clear:c_container_abilities(this_player.dispell_spell_tables)
	end
	
end

attribute_misc.__add = function(table1, table2)

	local somar_keys = function(ability, ability_table1)
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

	if (table2.interrupt) then
	
		if (not table1.interrupt) then
			table1.interrupt = 0
			table1.interrupt_targets = container_combatants:NewContainer(container_damage_target)
			table1.interrupt_spell_tables = container_abilities:NewContainer(container_misc)
			table1.interrompeu_oque = {}
		end
	
		--> total de interrupts
			table1.interrupt = table1.interrupt + table2.interrupt
		--> soma o interrompeu o que
			for spellid, amount in _pairs(table2.interrompeu_oque) do 
				if (not table1.interrompeu_oque[spellid]) then 
					table1.interrompeu_oque[spellid] = 0
				end
				table1.interrompeu_oque[spellid] = table1.interrompeu_oque[spellid] + amount
			end
		--> soma os containers de targets
			for index, dst in _ipairs(table2.interrupt_targets._ActorTable) do 
				--> pega o dst no ator
				local dst_table1 = table1.interrupt_targets:CatchCombatant(nil, dst.name, nil, true)
				--> soma o valor
				dst_table1.total = dst_table1.total + dst.total
			end
		
		--> soma o container de abilities
			for spellid, ability in _pairs(table2.interrupt_spell_tables._ActorTable) do 
				--> pega a ability no primeiro ator
				local ability_table1 = table1.interrupt_spell_tables:CatchSpell(spellid, true, nil, false)
				--> soma o que essa ability interrompeu
				ability_table1.interrompeu_oque = ability_table1.interrompeu_oque or {}
				for _spellid, amount in _pairs(ability.interrompeu_oque) do
					if (ability_table1.interrompeu_oque[_spellid]) then
						ability_table1.interrompeu_oque[_spellid] = ability_table1.interrompeu_oque[_spellid] + amount
					else
						ability_table1.interrompeu_oque[_spellid] = amount
					end
				end
				--> soma os targets
				for index, dst in _ipairs(ability.targets._ActorTable) do 
					local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
					dst_table1.total = dst_table1.total + dst.total
				end
				
				somar_keys(ability, ability_table1)
			end	

	end
	
	if (table2.buff_uptime) then
	
		if (not table1.buff_uptime) then
			table1.buff_uptime = 0
			table1.buff_uptime_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			table1.buff_uptime_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas
		end
	
		table1.buff_uptime = table1.buff_uptime + table2.buff_uptime
		
		for index, dst in _ipairs(table2.buff_uptime_targets._ActorTable) do 
			local dst_table1 = table1.buff_uptime_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
		end
		
		for spellid, ability in _pairs(table2.buff_uptime_spell_tables._ActorTable) do 
			local ability_table1 = table1.buff_uptime_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end

			somar_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.debuff_uptime) then
	
		if (not table1.debuff_uptime) then
		
			if (table2.boss_debuff) then
				table1.debuff_uptime_targets = container_combatants:NewContainer(_details.container_type.CONTAINER_ENEMYDEBUFFTARGET_CLASS)
				table1.boss_debuff = true
				table1.damage_twin = table2.damage_twin
				table1.spellschool = table2.spellschool
				table1.damage_spellid = table2.damage_spellid
			else
				table1.debuff_uptime_targets = container_combatants:NewContainer(container_damage_target)
			end
			
			table1.debuff_uptime = 0
			table1.debuff_uptime_spell_tables = container_abilities:NewContainer(container_misc)
		end
	
		table1.debuff_uptime = table1.debuff_uptime + table2.debuff_uptime
		
		for index, dst in _ipairs(table2.debuff_uptime_targets._ActorTable) do 
			local dst_table1 = table1.debuff_uptime_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
			if (dst.uptime) then --> boss debuff
				dst_table1.uptime = dst_table1.uptime + dst.uptime
				dst_table1.activedamt = dst_table1.activedamt + dst.activedamt
			end
		end
		
		for spellid, ability in _pairs(table2.debuff_uptime_spell_tables._ActorTable) do 
			local ability_table1 = table1.debuff_uptime_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			
			somar_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.cooldowns_defensive) then
	
		if (not table1.cooldowns_defensive) then
			table1.cooldowns_defensive = 0
			table1.cooldowns_defensive_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			table1.cooldowns_defensive_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas
		end
	
		table1.cooldowns_defensive = table1.cooldowns_defensive + table2.cooldowns_defensive
		
		for index, dst in _ipairs(table2.cooldowns_defensive_targets._ActorTable) do 
			local dst_table1 = table1.cooldowns_defensive_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
		end
		
		for spellid, ability in _pairs(table2.cooldowns_defensive_spell_tables._ActorTable) do 
			local ability_table1 = table1.cooldowns_defensive_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			
			somar_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.ress) then
	
		if (not table1.ress) then
			table1.ress = 0
			table1.ress_targets = container_combatants:NewContainer(container_damage_target)
			table1.ress_spell_tables = container_abilities:NewContainer(container_misc)
		end
	
		table1.ress = table1.ress + table2.ress
		
		for index, dst in _ipairs(table2.ress_targets._ActorTable) do 
			local dst_table1 = table1.ress_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
		end
		
		for spellid, ability in _pairs(table2.ress_spell_tables._ActorTable) do 
			local ability_table1 = table1.ress_spell_tables:CatchSpell(spellid, true, nil, false)
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			
			somar_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.dispell) then
	
		if (not table1.dispell) then
			table1.dispell = 0
			table1.dispell_targets = container_combatants:NewContainer(container_damage_target)
			table1.dispell_spell_tables = container_abilities:NewContainer(container_misc)
			table1.dispell_oque = {}
		end
	
		table1.dispell = table1.dispell + table2.dispell
		
		for index, dst in _ipairs(table2.dispell_targets._ActorTable) do 
			local dst_table1 = table1.dispell_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
		end
		
		for spellid, ability in _pairs(table2.dispell_spell_tables._ActorTable) do 
			local ability_table1 = table1.dispell_spell_tables:CatchSpell(spellid, true, nil, false)
			
			ability_table1.dispell_oque = ability_table1.dispell_oque or {}

			for _spellid, amount in _pairs(ability.dispell_oque) do
				if (ability_table1.dispell_oque[_spellid]) then
					ability_table1.dispell_oque[_spellid] = ability_table1.dispell_oque[_spellid] + amount
				else
					ability_table1.dispell_oque[_spellid] = amount
				end
			end
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			
			somar_keys(ability, ability_table1)
		end
		
		for spellid, amount in _pairs(table2.dispell_oque) do 
			if (not table1.dispell_oque[spellid]) then 
				table1.dispell_oque[spellid] = 0
			end
			table1.dispell_oque[spellid] = table1.dispell_oque[spellid] + amount
		end
		
	end
	
	if (table2.cc_break) then
	
		if (not table1.cc_break) then
			table1.cc_break = 0
			table1.cc_break_targets = container_combatants:NewContainer(container_damage_target) --> pode ser um container de dst de damage, pois irá usar apenas o .total
			table1.cc_break_spell_tables = container_abilities:NewContainer(container_misc) --> cria o container das abilities usadas para interromper
			table1.cc_break_oque = {}
		end
	
		table1.cc_break = table1.cc_break + table2.cc_break
		
		for index, dst in _ipairs(table2.cc_break_targets._ActorTable) do 
			local dst_table1 = table1.cc_break_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total + dst.total
		end
		
		for spellid, ability in _pairs(table2.cc_break_spell_tables._ActorTable) do 
			local ability_table1 = table1.cc_break_spell_tables:CatchSpell(spellid, true, nil, false)
			
			ability_table1.cc_break_oque = ability_table1.cc_break_oque or {}
			for _spellid, amount in _pairs(ability.cc_break_oque) do
				if (ability_table1.cc_break_oque[_spellid]) then
					ability_table1.cc_break_oque[_spellid] = ability_table1.cc_break_oque[_spellid] + amount
				else
					ability_table1.cc_break_oque[_spellid] = amount
				end
			end
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total + dst.total
			end
			
			somar_keys(ability, ability_table1)
		end

		for spellid, amount in _pairs(table2.cc_break_oque) do 
			if (not table1.cc_break_oque[spellid]) then 
				table1.cc_break_oque[spellid] = 0
			end
			table1.cc_break_oque[spellid] = table1.cc_break_oque[spellid] + amount
		end
	end
	
	return table1
end

attribute_misc.__sub = function(table1, table2)

	local subtrair_keys = function(ability, ability_table1)
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

	if (table2.interrupt) then
	
		--> total de interrupts
			table1.interrupt = table1.interrupt - table2.interrupt
		--> soma o interrompeu o que
			for spellid, amount in _pairs(table2.interrompeu_oque) do 
				if (not table1.interrompeu_oque[spellid]) then 
					table1.interrompeu_oque[spellid] = 0
				end
				table1.interrompeu_oque[spellid] = table1.interrompeu_oque[spellid] - amount
			end
		--> soma os containers de targets
			for index, dst in _ipairs(table2.interrupt_targets._ActorTable) do 
				--> pega o dst no ator
				local dst_table1 = table1.interrupt_targets:CatchCombatant(nil, dst.name, nil, true)
				--> soma o valor
				dst_table1.total = dst_table1.total - dst.total
			end
		
		--> soma o container de abilities
			for spellid, ability in _pairs(table2.interrupt_spell_tables._ActorTable) do 
				--> pega a ability no primeiro ator
				local ability_table1 = table1.interrupt_spell_tables:CatchSpell(spellid, true, nil, false)
				--> soma o que essa ability interrompeu
				ability_table1.interrompeu_oque = ability_table1.interrompeu_oque or {}
				for _spellid, amount in _pairs(ability.interrompeu_oque) do
					if (ability_table1.interrompeu_oque[_spellid]) then
						ability_table1.interrompeu_oque[_spellid] = ability_table1.interrompeu_oque[_spellid] - amount
					else
						ability_table1.interrompeu_oque[_spellid] = amount
					end
				end
				--> soma os targets
				for index, dst in _ipairs(ability.targets._ActorTable) do 
					local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
					dst_table1.total = dst_table1.total - dst.total
				end
				
				subtrair_keys(ability, ability_table1)
			end	

	end
	
	if (table2.buff_uptime) then
	
		table1.buff_uptime = table1.buff_uptime - table2.buff_uptime
		
		for index, dst in _ipairs(table2.buff_uptime_targets._ActorTable) do 
			local dst_table1 = table1.buff_uptime_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
		end
		
		for spellid, ability in _pairs(table2.buff_uptime_spell_tables._ActorTable) do 
			local ability_table1 = table1.buff_uptime_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end

			subtrair_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.debuff_uptime) then
	
		table1.debuff_uptime = table1.debuff_uptime - table2.debuff_uptime
		
		for index, dst in _ipairs(table2.debuff_uptime_targets._ActorTable) do 
			local dst_table1 = table1.debuff_uptime_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
			if (dst.uptime) then --> boss debuff
				dst_table1.uptime = dst_table1.uptime - dst.uptime
				dst_table1.activedamt = dst_table1.activedamt - dst.activedamt
			end
		end
		
		for spellid, ability in _pairs(table2.debuff_uptime_spell_tables._ActorTable) do 
			local ability_table1 = table1.debuff_uptime_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			
			subtrair_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.cooldowns_defensive) then
	
		table1.cooldowns_defensive = table1.cooldowns_defensive - table2.cooldowns_defensive
		
		for index, dst in _ipairs(table2.cooldowns_defensive_targets._ActorTable) do 
			local dst_table1 = table1.cooldowns_defensive_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
		end
		
		for spellid, ability in _pairs(table2.cooldowns_defensive_spell_tables._ActorTable) do 
			local ability_table1 = table1.cooldowns_defensive_spell_tables:CatchSpell(spellid, true, nil, false)

			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			
			subtrair_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.ress) then
	
		table1.ress = table1.ress - table2.ress
		
		for index, dst in _ipairs(table2.ress_targets._ActorTable) do 
			local dst_table1 = table1.ress_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
		end
		
		for spellid, ability in _pairs(table2.ress_spell_tables._ActorTable) do 
			local ability_table1 = table1.ress_spell_tables:CatchSpell(spellid, true, nil, false)
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			
			subtrair_keys(ability, ability_table1)
		end	
		
	end
	
	if (table2.dispell) then
	
		table1.dispell = table1.dispell - table2.dispell
		
		for index, dst in _ipairs(table2.dispell_targets._ActorTable) do 
			local dst_table1 = table1.dispell_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
		end
		
		for spellid, ability in _pairs(table2.dispell_spell_tables._ActorTable) do 
			local ability_table1 = table1.dispell_spell_tables:CatchSpell(spellid, true, nil, false)
			
			ability_table1.dispell_oque = ability_table1.dispell_oque or {}

			for _spellid, amount in _pairs(ability.dispell_oque) do
				if (ability_table1.dispell_oque[_spellid]) then
					ability_table1.dispell_oque[_spellid] = ability_table1.dispell_oque[_spellid] - amount
				else
					ability_table1.dispell_oque[_spellid] = amount
				end
			end
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			
			subtrair_keys(ability, ability_table1)
		end
		
		for spellid, amount in _pairs(table2.dispell_oque) do 
			if (not table1.dispell_oque[spellid]) then 
				table1.dispell_oque[spellid] = 0
			end
			table1.dispell_oque[spellid] = table1.dispell_oque[spellid] - amount
		end
		
	end
	
	if (table2.cc_break) then
	
		table1.cc_break = table1.cc_break - table2.cc_break
		
		for index, dst in _ipairs(table2.cc_break_targets._ActorTable) do 
			local dst_table1 = table1.cc_break_targets:CatchCombatant(nil, dst.name, nil, true)
			dst_table1.total = dst_table1.total - dst.total
		end
		
		for spellid, ability in _pairs(table2.cc_break_spell_tables._ActorTable) do 
			local ability_table1 = table1.cc_break_spell_tables:CatchSpell(spellid, true, nil, false)
			
			ability_table1.cc_break_oque = ability_table1.cc_break_oque or {}
			for _spellid, amount in _pairs(ability.cc_break_oque) do
				if (ability_table1.cc_break_oque[_spellid]) then
					ability_table1.cc_break_oque[_spellid] = ability_table1.cc_break_oque[_spellid] - amount
				else
					ability_table1.cc_break_oque[_spellid] = amount
				end
			end
			
			for index, dst in _ipairs(ability.targets._ActorTable) do 
				local dst_table1 = ability_table1.targets:CatchCombatant(nil, dst.name, nil, true)
				dst_table1.total = dst_table1.total - dst.total
			end
			
			subtrair_keys(ability, ability_table1)
		end

		for spellid, amount in _pairs(table2.cc_break_oque) do 
			if (not table1.cc_break_oque[spellid]) then 
				table1.cc_break_oque[spellid] = 0
			end
			table1.cc_break_oque[spellid] = table1.cc_break_oque[spellid] - amount
		end
	end
	
	return table1
end
