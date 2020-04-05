--> customized display script

	local _details = 		_G._details
	local gump = 			_details.gump
	local _
	
	_details.custom_function_cache = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _cstr = string.format --lua local
	local _math_floor = math.floor --lua local
	local _table_sort = table.sort --lua local
	local _table_insert = table.insert --lua local
	local _table_size = table.getn --lua local
	local _setmetatable = setmetatable --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _rawget= rawget --lua local
	local _math_min = math.min --lua local
	local _math_max = math.max --lua local
	local _bit_band = bit.band --lua local
	local _unpack = unpack --lua local
	local _type = type --lua local
	
	local _GetSpellInfo = _details.getspellinfo -- api local
	local _IsInRaid = IsInRaid -- api local
	local _IsInGroup = IsInGroup -- api local
	local _GetNumGroupMembers = GetNumGroupMembers -- api local
	local _GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers -- api local
	local _GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers -- api local
	local _GetUnitName = GetUnitName -- api local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local attribute_custom = _details.attribute_custom
	attribute_custom.mt = {__index = attribute_custom}
	
	local combat_containers = {
		["damagedone"] = 1,
		["healdone"] = 2,
	}
	
	--> hold the mini custom objects
	attribute_custom._InstanceActorContainer = {}
	attribute_custom._InstanceLastCustomShown = {}
	attribute_custom._InstanceLastCombatShown = {}
	attribute_custom._TargetActorsProcessed = {}
	
	local ToKFunctions = _details.ToKFunctions
	local SelectedToKFunction = ToKFunctions[1]
	local FormatTooltipNumber = ToKFunctions[8]
	local TooltipMaximizedMethod = 1
	local UsingCustomRightText = false
	local UsingCustomLeftText = false
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	function attribute_custom:GetCombatContainerIndex(attribute)
		return combat_containers[attribute]
	end

	function attribute_custom:RefreshWindow(instance, combat, force, export)

		--> get the custom object
		local custom_object = instance:GetCustomObject()

		if (not custom_object) then
			return instance:ResetAttribute()
		end

		--> save the custom name in the instance
		instance.customName = custom_object:GetName()
		
		--> get the container holding the custom actor objects for this instance
		local instance_container = attribute_custom:GetInstanceCustomActorContainer(instance)
		
		local last_shown = attribute_custom._InstanceLastCustomShown[instance:GetId()]
		if (last_shown and last_shown ~= custom_object:GetName()) then
			instance_container:WipeCustomActorContainer()
		end
		attribute_custom._InstanceLastCustomShown[instance:GetId()] = custom_object:GetName()
		
		local last_combat_shown = attribute_custom._InstanceLastCombatShown[instance:GetId()]
		if (last_combat_shown and last_combat_shown ~= combat) then
			instance_container:WipeCustomActorContainer()
		end
		attribute_custom._InstanceLastCombatShown[instance:GetId()] = combat
		
		--> declare the main locals
		local total = 0
		local top = 0
		local amount = 0
		
		--> check if is a custom script
		if (custom_object:IsScripted()) then

			--> be save reseting the values on every refresh
			instance_container:ResetCustomActorContainer()
		
			local func
			
			if (_details.custom_function_cache[instance.customName]) then
				func = _details.custom_function_cache[instance.customName]
			else
				func = loadstring(custom_object.script)
				if (func) then
					_details.custom_function_cache[instance.customName] = func
				end

				local tooltip_script  = custom_object.tooltip and loadstring(custom_object.tooltip)
				if (tooltip_script) then
					_details.custom_function_cache[instance.customName .. "Tooltip"] = tooltip_script
				end
				local total_script = custom_object.total_script and loadstring(custom_object.total_script)
				if (total_script) then
					_details.custom_function_cache[instance.customName .. "Total"] = total_script
				end
				local percent_script = custom_object.percent_script and loadstring(custom_object.percent_script)
				if (percent_script) then
					_details.custom_function_cache[instance.customName .. "Percent"] = percent_script
				end
			end
			
			if (not func) then
				_details:Msg(Loc["STRING_CUSTOM_FUNC_INVALID"], func)
				_details:EndRefresh(instance, 0, combat, combat[1])
			end
			
			--> call the loop function
			total, top, amount = func(combat, instance_container, instance)
		else
			--> get the attribute
			local attribute = custom_object:GetAttribute()
			
			--> get the custom function(actor, source, target, spellid)
			local func = attribute_custom[attribute]
			
			--> get the combat container
			local container_index = self:GetCombatContainerIndex(attribute)
			local combat_container = combat[container_index]._ActorTable

			--> build container
			total, top, amount = attribute_custom:BuildActorList(func, custom_object.source, custom_object.target, custom_object.spellid, combat, combat_container, container_index, instance_container, instance, custom_object)

		end

		if (custom_object:IsSpellTarget()) then
			amount = attribute_custom._TargetActorsProcessedAmt
			total = attribute_custom._TargetActorsProcessedTotal
			top = attribute_custom._TargetActorsProcessedTop
		end

		if (amount == 0) then
			if (force) then
				if (instance:IsGroupMode()) then
					for i = 1, instance.rows_fit_in_window  do
						gump:Fade(instance.bars[i], "in", 0.3)
					end
				end
			end
			instance:HideScrollBar()
			return _details:EndRefresh(instance, total, combat, combat[container_index])
		end
		
		combat.totals[custom_object:GetName()] = total
		
		instance_container:Sort()
		instance_container:Remap()
		
		if (export) then
			-- key name value need to be formated
			if (custom_object) then
			
				local percent_script = _details.custom_function_cache[instance.customName .. "Percent"]
				local total_script = _details.custom_function_cache[instance.customName .. "Total"]
				
				for index, actor in _ipairs(instance_container._ActorTable) do 	
					local percent, ptotal
					if (percent_script) then
						percent = percent_script(_math_floor(actor.value), top, total, combat, instance)
					else
						percent = _cstr("%.1f", _math_floor(actor.value) / total * 100)
					end
					
					if (total_script) then
						local value = total_script(_math_floor(actor.value), top, total, combat, instance)
						if (type(value) == "number") then
							ptotal = SelectedToKFunction(_, value)
						else
							ptotal = value
						end
					else
						ptotal = SelectedToKFunction(_, _math_floor(actor.value))
					end
					
					actor.report_value = ptotal .. "(" .. percent .. "%)"
				end

			end
			
			return total, instance_container._ActorTable, top, amount
		end
		
		instance:ActualizeScrollBar(amount)

		attribute_custom:Refresh(instance, instance_container, combat, force, total, top, custom_object)
		
		return _details:EndRefresh(instance, total, combat, combat[container_index])

	end

	function attribute_custom:BuildActorList(func, source, target, spellid, combat, combat_container, container_index, instance_container, instance, custom_object)

		--> do the loop
		
		local total = 0
		local top = 0
		local amount = 0
		
		--> check if is a spell target custom
		if (custom_object:IsSpellTarget()) then
			table.wipe(attribute_custom._TargetActorsProcessed)
			attribute_custom._TargetActorsProcessedAmt = 0
			attribute_custom._TargetActorsProcessedTotal = 0
			attribute_custom._TargetActorsProcessedTop = 0
			instance_container:ResetCustomActorContainer()
		end
		
		if (source == "[all]") then
			
			for _, actor in _ipairs(combat_container) do 
				local actortotal = func(_, actor, source, target, spellid, combat, instance_container)
				if (actortotal > 0) then
					total = total + actortotal
					amount = amount + 1
					
					if (actortotal > top) then
						top = actortotal
					end
					
					instance_container:SetValue(actor, actortotal)
				end
			end
			
		elseif (source == "[raid]") then
		
			if (_details.in_combat and instance.segment == 0 and not export) then
				if (container_index == 1) then
					combat_container = _details.cache_damage_group
				elseif (container_index == 2) then
					combat_container = _details.cache_healing_group
				end
			end

			for _, actor in _ipairs(combat_container) do 
				if (actor.group) then
					local actortotal = func(_, actor, source, target, spellid, combat, instance_container)

					if (actortotal > 0) then
						total = total + actortotal
						amount = amount + 1
						
						if (actortotal > top) then
							top = actortotal
						end
						
						instance_container:SetValue(actor, actortotal)
					end
					
				end
			end
			
		elseif (source == "[player]") then
			local pindex = combat[container_index]._NameIndexTable[_details.playername]
			if (pindex) then
				local actor = combat[container_index]._ActorTable[pindex]
				local actortotal = func(_, actor, source, target, spellid, combat, instance_container)
				
				if (actortotal > 0) then
					total = total + actortotal
					amount = amount + 1
					
					if (actortotal > top) then
						top = actortotal
					end
					
					instance_container:SetValue(actor, actortotal)
				end
			end
		else

			local pindex = combat[container_index]._NameIndexTable[source]
			if (pindex) then
				local actor = combat[container_index]._ActorTable[pindex]
				local actortotal = func(_, actor, source, target, spellid, combat, instance_container)
				
				if (actortotal > 0) then
					total = total + actortotal
					amount = amount + 1
					
					if (actortotal > top) then
						top = actortotal
					end
					
					instance_container:SetValue(actor, actortotal)
				end
			end
		end
		
		return total, top, amount
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> refresh functions

	function attribute_custom:Refresh(instance, instance_container, combat, force, total, top, custom_object)
		local which_bar = 1
		local bars_container = instance.bars
		local percentage_type = instance.row_info.percent_type
		
		local combat_time = combat:GetCombatTime()
		UsingCustomLeftText = instance.row_info.textL_enable_custom_text
		UsingCustomRightText = instance.row_info.textR_enable_custom_text
		
		--> total bar
		local use_total_bar = false
		if (instance.total_bar.enabled) then
			use_total_bar = true
			if (instance.total_bar.only_in_group and(GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0)) then
				use_total_bar = false
			end
		end

		local percent_script = _details.custom_function_cache[instance.customName .. "Percent"]
		local total_script = _details.custom_function_cache[instance.customName .. "Total"]

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
				
				for i = instance.barS[1], iter_last, 1 do
					instance_container._ActorTable[i]:UpdateBar(bars_container, which_bar, percentage_type, i, total, top, instance, force, percent_script, total_script, combat)
					which_bar = which_bar+1
				end
			
			else
				for i = instance.barS[1], instance.barS[2], 1 do
					instance_container._ActorTable[i]:UpdateBar(bars_container, which_bar, percentage_type, i, total, top, instance, force, percent_script, total_script, combat)
					which_bar = which_bar+1
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
				
				for i = iter_last, instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					instance_container._ActorTable[i]:UpdateBar(bars_container, which_bar, percentage_type, i, total, top, instance, force, percent_script, total_script, combat)
					which_bar = which_bar+1
				end
			
			else
				for i = instance.barS[2], instance.barS[1], -1 do --> vai atualizar só o range que this sendo mostrado
					instance_container._ActorTable[i]:UpdateBar(bars_container, which_bar, percentage_type, i, total, top, instance, force, percent_script, total_script, combat)
					which_bar = which_bar+1
				end
			end
			
		end	
		
		if (force) then
			if (instance:IsGroupMode()) then
				for i = which_bar, instance.rows_fit_in_window  do
					gump:Fade(instance.bars[i], "in", 0.3)
				end
			end
		end
		
	end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> custom object functions

	local actor_class_color_r, actor_class_color_g, actor_class_color_b
	
	function attribute_custom:UpdateBar(row_container, index, percentage_type, rank, total, top, instance, is_forced, percent_script, total_script, combat)
	
		local row = row_container[index]
		
		local previous_table = row.my_table
		row.placing = rank
		row.my_table = self
		self.my_bar = row
		
		local percent

		if (percent_script) then
			--local value, top, total, combat, instance = ...
			percent = percent_script(self.value, top, total, combat, instance)
		else
			if (percentage_type == 1) then
				percent = _cstr("%.1f", self.value / total * 100)
			elseif (percentage_type == 2) then
				percent = _cstr("%.1f", self.value / top * 100)
			end
		end
		
		if (total_script) then
			local value = total_script(self.value, top, total, combat, instance)
			if (type(value) == "number") then
				row.text_right:SetText(SelectedToKFunction(_, value) .. "(" .. percent .. "%)")
			else
				row.text_right:SetText(value .. "(" .. percent .. "%)")
			end
		else
			local formated_value = SelectedToKFunction(_, self.value)
			if (UsingCustomRightText) then
				row.text_right:SetText(instance.row_info.textR_custom_text:ReplaceData(formated_value, "", percent, self))
			else
				row.text_right:SetText(formated_value .. "(" .. percent .. "%)")
			end
		end
		
		local row_value = _math_floor((self.value / top) * 100)

		-- update tooltip function--

		actor_class_color_r, actor_class_color_g, actor_class_color_b = self:GetBarColor()
		
		self:RefreshBar2(row, instance, previous_table, is_forced, row_value, index, row_container)
		
	end
	
	function attribute_custom:RefreshBar2(this_bar, instance, table_previous, force, this_percentage, which_bar, bars_container)
		
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
			
				this_bar.statusbar:SetValue(this_percentage)
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
				
					this_bar.statusbar:SetValue(this_percentage)
				
					this_bar.last_value = this_percentage --> reseta o ultimo valor da bar
					
					if (_details.is_using_row_animations and force) then
						this_bar.has_animation = 0
						this_bar:SetScript("OnUpdate", nil)
					end
					
					return self:RefreshBar(this_bar, instance)
					
				elseif (this_percentage ~= this_bar.last_value) then --> continua showing a mesma table então compara a percentage
					--> apenas atualizar
					if (_details.is_using_row_animations) then
						
						local upRow = bars_container[which_bar-1]
						if (upRow) then
							if (upRow.statusbar:GetValue() < this_bar.statusbar:GetValue()) then
								this_bar.statusbar:SetValue(this_percentage)
							else
								instance:AnimarBar(this_bar, this_percentage)
							end
						else
							instance:AnimarBar(this_bar, this_percentage)
						end
					else
						this_bar.statusbar:SetValue(this_percentage)
					end
					this_bar.last_value = this_percentage
				end
			end

		end
		
	end

	function attribute_custom:RefreshBar(this_bar, instance, from_resize)
		
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

	function attribute_custom:CreateCustomActorContainer()
		return _setmetatable({
			_NameIndexTable = {},
			_ActorTable = {}
		}, {__index = attribute_custom})
	end
	
	function attribute_custom:ResetCustomActorContainer()
		for _, actor in _ipairs(self._ActorTable) do
			actor.value = actor.value - _math_floor(actor.value)
			--actor.value = _details:GetOrderNumber(actor.name)
		end
	end
	
	function attribute_custom:WipeCustomActorContainer()
		table.wipe(self._ActorTable)
		table.wipe(self._NameIndexTable)
	end

	function attribute_custom:GetValue(actor)
		local actor_table = self:GetActorTable(actor)
		return actor_table.value
	end
	
	function attribute_custom:AddValue(actor, actortotal, checktop)
		local actor_table = self:GetActorTable(actor)
		actor_table.my_actor = actor
		actor_table.value = actor_table.value + actortotal
		
		if (checktop) then
			if (actor_table.value > attribute_custom._TargetActorsProcessedTop) then
				attribute_custom._TargetActorsProcessedTop = actor_table.value
			end
		end
		
		return actor_table.value
	end
	
	function attribute_custom:SetValue(actor, actortotal)
		local actor_table = self:GetActorTable(actor)
		actor_table.my_actor = actor
		actor_table.value = actortotal
	end

	function attribute_custom:UpdateClass(actors)
		actors.new_actor.class = actors.actor.class
	end
	
	function attribute_custom:GetActorTable(actor)
		local index = self._NameIndexTable[actor.name]
		if (index) then
			return self._ActorTable[index]
		else
			local new_actor = _setmetatable({
			name = actor.name,
			class = actor.class,
			value = _details:GetOrderNumber(actor.name),
			}, attribute_custom.mt)
			
			new_actor.displayName = new_actor.name
			
			if (not new_actor.class) then
				new_actor.class = _details:GetClass(actor.name) or "UNKNOW"
			end
			if (new_actor.class == "UNGROUPPLAYER") then
				attribute_custom:ScheduleTimer("UpdateClass", 5, {new_actor = new_actor, actor = actor})
			end

			index = #self._ActorTable+1
			
			self._ActorTable[index] = new_actor
			self._NameIndexTable[actor.name] = index
			return new_actor
		end
	end
	
	function attribute_custom:GetInstanceCustomActorContainer(instance)
		if (not attribute_custom._InstanceActorContainer[instance:GetId()]) then
			attribute_custom._InstanceActorContainer[instance:GetId()] = self:CreateCustomActorContainer()
		end
		return attribute_custom._InstanceActorContainer[instance:GetId()]
	end

	function attribute_custom:CreateCustomDisplayObject()
		return _setmetatable({
			name = "new custom",
			icon =[[Interface\ICONS\TEMP]],
			author = "unknown",
			attribute = "damagedone",
			source = "[all]",
			target = "[all]",
			spellid = false,
			script = false,
		}, {__index = attribute_custom})
	end

	local custom_sort = function(t1, t2)
		return t1.value > t2.value
	end
	function attribute_custom:Sort(container)
		container = container or self
		_table_sort(container._ActorTable, custom_sort)
	end
	
	function attribute_custom:Remap()
		local map = self._NameIndexTable
		local actors = self._ActorTable
		for i = 1, #actors do
			map[actors[i].name] = i
		end
	end

	function attribute_custom:ToolTip(instance, bar_number, row_object, keydown)
	
		--> get the custom object
		local custom_object = instance:GetCustomObject()
		
		--> get the actor
		local actor = self.my_actor
		
		local r, g, b = actor:GetClassColor()
		
		_details:AddTooltipSpellHeaderText(custom_object:GetName(), "yellow", 1, 0, 0, 0)
		GameCooltip:AddIcon(custom_object:GetIcon(), 1, 1, 14, 14, 0.90625, 0.109375, 0.15625, 0.875)
		GameCooltip:AddStatusBar(100, 1, r, g, b, 1)
		
		if (custom_object:IsScripted()) then
			if (custom_object.tooltip) then
				local func = loadstring(custom_object.tooltip)
				func(actor, instance.showing, instance)
			end
		else
			--> get the attribute
			local attribute = custom_object:GetAttribute()
			local container_index = attribute_custom:GetCombatContainerIndex(attribute)
			
			--> get the tooltip function
			local func = attribute_custom[attribute .. "Tooltip"]
			
			--> build the tooltip
			func(_, actor, custom_object.target, custom_object.spellid, instance.showing, instance)
		end
		
		return true
	end
	
	function attribute_custom:GetName()
		return self.name
	end
	function attribute_custom:GetIcon()
		return self.icon
	end
	function attribute_custom:GetAuthor()
		return self.author
	end
	function attribute_custom:GetDesc()
		return self.desc
	end
	function attribute_custom:GetAttribute()
		return self.attribute
	end
	function attribute_custom:GetSource()
		return self.source
	end
	function attribute_custom:GetTarget()
		return self.target
	end
	function attribute_custom:GetSpellId()
		return self.spellid
	end
	function attribute_custom:GetScript()
		return self.script
	end
	function attribute_custom:GetScriptToolip()
		return self.tooltip
	end
	function attribute_custom:GetScriptTotal()
		return self.total_script
	end
	function attribute_custom:GetScriptPercent()
		return self.percent_script
	end

	function attribute_custom:SetName(name)
		self.name = name
	end
	function attribute_custom:SetIcon(path)
		self.icon = path
	end
	function attribute_custom:SetAuthor(author)
		self.author = author
	end
	function attribute_custom:SetDesc(desc)
		self.desc = desc
	end
	function attribute_custom:SetAttribute(newattribute)
		self.attribute = newattribute
	end
	function attribute_custom:SetSource(source)
		self.source = source
	end
	function attribute_custom:SetTarget(target)
		self.target = target
	end
	function attribute_custom:SetSpellId(spellid)
		self.spellid = spellid
	end
	function attribute_custom:SetScript(code)
		self.script = code
	end
	function attribute_custom:SetScriptToolip(code)
		self.tooltip = code
	end

	function attribute_custom:IsScripted()
		return self.script and true or false
	end
	
	function attribute_custom:IsSpellTarget()
		return self.spellid and self.target and true
	end
	
	function attribute_custom:RemoveCustom(index)
	
		if (not _details.table_instances) then
			--> do not remove customs while the addon is loading.
			return
		end
	
		table.remove(_details.custom, index)
		
		for _, instance in _ipairs(_details.table_instances) do 
			if (instance.attribute == 5 and instance.sub_attribute == index) then 
				instance:ResetAttribute()
			elseif (instance.attribute == 5 and instance.sub_attribute > index) then
				instance.sub_attribute = instance.sub_attribute - 1
				instance.sub_attribute_last[5] = 1
			else
				instance.sub_attribute_last[5] = 1
			end
		end
		
		_details.switch:OnRemoveCustom(index)
	end
	
	function _details:ResetCustomFunctionsCache()
		table.wipe(_details.custom_function_cache)
	end
	
	function _details.refresh:r_attribute_custom()
		--> check for non used temp displays
		if (_details.table_instances) then

			for i = #_details.custom, 1, -1 do
				local custom_object = _details.custom[i]
				if (custom_object.temp) then
					--> check if there is a instance showing this custom
					local showing = false
					
					for index, instance in _ipairs(_details.table_instances) do
						if (instance.attribute == 5 and instance.sub_attribute == i) then 
							showing = true
						end
					end
					
					if (not showing) then
						attribute_custom:RemoveCustom(i)
					end
				end
			end
		end
	
		--> restore metatable and indexes
		for index, custom_object in _ipairs(_details.custom) do
			_setmetatable(custom_object, attribute_custom)
			custom_object.__index = attribute_custom
		end
	end

	function _details.clear:c_attribute_custom()
		for _, custom_object in _ipairs(_details.custom) do
			custom_object.__index = nil
		end
	end

	function attribute_custom:UpdateSelectedToKFunction()
		SelectedToKFunction = ToKFunctions[_details.ps_abbreviation]
		FormatTooltipNumber = ToKFunctions[_details.tooltip.abbreviation]
		TooltipMaximizedMethod = _details.tooltip.maximize_method
		attribute_custom:UpdateDamageDoneBracket()
		attribute_custom:UpdateHealingDoneBracket()
		attribute_custom:UpdateDamageTakenBracket()
	end

	function _details:AddDefaultCustomDisplays()
	
		local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
		
		local PotionUsed = {
			name = Loc["STRING_CUSTOM_POT_DEFAULT"],
			icon =[[Interface\ICONS\INV_Alchemy_Elixir_04]],
			attribute = false,
			spellid = false,
			author = "Details!",
			desc = Loc["STRING_CUSTOM_POT_DEFAULT_DESC"],
			source = false,
			target = false,
			script =[[
				--init:
				local combat, instance_container, instance = ...
				local total, top, amount = 0, 0, 0

				--get the misc actor container
				local misc_container = combat:GetActorList( DETAILS_ATTRIBUTE_MISC )

				--do the loop:
				for _, player in ipairs( misc_container ) do 
				    
				    --only player in group
				    if (player:IsGroupPlayer()) then
					
					local found_potion = false
					
					--get the spell debuff uptime container
					local debuff_uptime_container = player.debuff_uptime and player.debuff_uptime_spell_tables and player.debuff_uptime_spell_tables._ActorTable
					
					--get the spell buff uptime container
					local buff_uptime_container = player.buff_uptime and player.buff_uptime_spell_tables and player.buff_uptime_spell_tables._ActorTable
					if (buff_uptime_container) then
					    
					    --potion of the jade serpent
					    local potion_of_speed = buff_uptime_container[53908]
					    if (potion_of_speed) then
						local used = potion_of_speed.activedamt
						if (used > 0) then
						    total = total + used
						    found_potion = true
						    if (used > top) then
							top = used
						    end
						    --add amount to the player 
						    instance_container:AddValue(player, used)
						end
					    end
					    
					    --potion of mogu power
					    local potion_of_wild_magic = buff_uptime_container[53909]
					    if (potion_of_wild_magic) then
						local used = potion_of_wild_magic.activedamt
						if (used > 0) then
						    total = total + used
						    found_potion = true
						    if (used > top) then
							top = used
						    end
						    --add amount to the player 
						    instance_container:AddValue(player, used)
						end
					    end
					    
					    --virmen's bite
					    local insane_strength_potion = buff_uptime_container[28494]
					    if (insane_strength_potion) then
							local used = insane_strength_potion.activedamt
							if (used > 0) then
								total = total + used
								found_potion = true
								if (used > top) then
									top = used
								end
								--add amount to the player 
								instance_container:AddValue(player, used)
							end
					    end
						
						--armor potion
					    local armor_potion = buff_uptime_container[53762]
					    if (armor_potion) then
							local used = armor_potion.activedamt
							if (used > 0) then
								total = total + used
								found_potion = true
								if (used > top) then
									top = used
								end
								--add amount to the player 
								instance_container:AddValue(player, used)
							end
					    end

					end
					
					if (found_potion) then
					    amount = amount + 1
					end    
				    end
				end

				--return:
				return total, top, amount
				]],
			tooltip =[[
			--init:
			local player, combat, instance = ...

			--get the buff container for all the others potions
			local buff_uptime_container = player.buff_uptime and player.buff_uptime_spell_tables and player.buff_uptime_spell_tables._ActorTable
			if (buff_uptime_container) then
			    --potion of the jade serpent
			    local jade_serpent_potion = buff_uptime_container[53908]
			    if (jade_serpent_potion) then
				local name, _, icon = GetSpellInfo(53908)
				GameCooltip:AddLine(name, jade_serpent_potion.activedamt)
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon(icon, 1, 1, 14, 14)
			    end
			    
			    --potion of mogu power
			    local mogu_power_potion = buff_uptime_container[53909]
			    if (mogu_power_potion) then
				local name, _, icon = GetSpellInfo(53909)
				GameCooltip:AddLine(name, mogu_power_potion.activedamt)
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon(icon, 1, 1, 14, 14)
			    end
			    
			    --virmen's bite
			    local virmens_bite_potion = buff_uptime_container[28494]
			    if (virmens_bite_potion) then
				local name, _, icon = GetSpellInfo(28494)
				GameCooltip:AddLine(name, virmens_bite_potion.activedamt)
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon(icon, 1, 1, 14, 14)
			    end
				--armor potion
			    local armor_potion = buff_uptime_container[53762]
			    if (armor_potion) then
				local name, _, icon = GetSpellInfo(53762)
				GameCooltip:AddLine(name, armor_potion.activedamt)
				_details:AddTooltipBackgroundStatusbar()
				GameCooltip:AddIcon(icon, 1, 1, 14, 14)
			    end
				
			end
		]]
		}
		
		local have = false
		for _, custom in ipairs(self.custom) do
			if (custom.name == Loc["STRING_CUSTOM_POT_DEFAULT"]) then
				have = true
				break
			end
		end
		if (not have) then
			setmetatable(PotionUsed, _details.attribute_custom)
			PotionUsed.__index = _details.attribute_custom
			self.custom[#self.custom+1] = PotionUsed
		end
		
		local Healthstone = {
			name = Loc["STRING_CUSTOM_HEALTHSTONE_DEFAULT"],
			icon =[[Interface\ICONS\INV_Stone_04]],
			attribute = "healdone",
			spellid = 47875, 
			author = "Details!",
			desc = Loc["STRING_CUSTOM_HEALTHSTONE_DEFAULT_DESC"],
			source = "[raid]",
			target = "[raid]",
			script = false,
			tooltip = false
		}

		local have = false
		for _, custom in ipairs(self.custom) do
			if (custom.name == Loc["STRING_CUSTOM_HEALTHSTONE_DEFAULT"]) then
				have = true
				break
			end
		end
		if (not have) then
			setmetatable(Healthstone, _details.attribute_custom)
			Healthstone.__index = _details.attribute_custom
			self.custom[#self.custom+1] = Healthstone
		end
		
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		local DamageActivityTime = {
			name = Loc["STRING_CUSTOM_ACTIVITY_DPS"],
			icon =[[Interface\ICONS\Achievement_PVP_H_06]],
			attribute = false,
			spellid = false,
			author = "Details!",
			desc = Loc["STRING_CUSTOM_ACTIVITY_DPS_DESC"],
			source = false,
			target = false,
			total_script =[[
				local value, top, total, combat, instance = ...
				local minutes, seconds = math.floor(value/60), math.floor(value%60)
				return minutes .. "m " .. seconds .. "s"
			]],
			percent_script =[[
				local value, top, total, combat, instance = ...
				return string.format("%.1f", value/top*100)
			]],
			script =[[
				--init:
				local combat, instance_container, instance = ...
				local total, amount = 0, 0

				--get the misc actor container
				local damage_container = combat:GetActorList( DETAILS_ATTRIBUTE_DAMAGE )
				
				--do the loop:
				for _, player in ipairs( damage_container ) do 
					if (player.group) then
						local activity = player:Time()
						total = total + activity
						amount = amount + 1
						--add amount to the player 
						instance_container:AddValue(player, activity)
					end
				end
				
				--return:
				return total, combat:GetCombatTime(), amount
			]],
			tooltip =[[
				
			]],
		}
		
		local have = false
		for _, custom in ipairs(self.custom) do
			if (custom.name == Loc["STRING_CUSTOM_ACTIVITY_DPS"]) then
				have = true
				break
			end
		end
		if (not have) then
			setmetatable(DamageActivityTime, _details.attribute_custom)
			DamageActivityTime.__index = _details.attribute_custom		
			self.custom[#self.custom+1] = DamageActivityTime
		end

		local HealActivityTime = {
			name = Loc["STRING_CUSTOM_ACTIVITY_HPS"],
			icon =[[Interface\ICONS\Achievement_PVP_G_06]],
			attribute = false,
			spellid = false,
			author = "Details!",
			desc = Loc["STRING_CUSTOM_ACTIVITY_HPS_DESC"],
			source = false,
			target = false,
			total_script =[[
				local value, top, total, combat, instance = ...
				local minutes, seconds = math.floor(value/60), math.floor(value%60)
				return minutes .. "m " .. seconds .. "s"
			]],
			percent_script =[[
				local value, top, total, combat, instance = ...
				return string.format("%.1f", value/top*100)
			]],
			script =[[
				--init:
				local combat, instance_container, instance = ...
				local total, top, amount = 0, 0, 0

				--get the misc actor container
				local damage_container = combat:GetActorList( DETAILS_ATTRIBUTE_HEAL )
				
				--do the loop:
				for _, player in ipairs( damage_container ) do 
					if (player.group) then
						local activity = player:Time()
						total = total + activity
						amount = amount + 1
						--add amount to the player 
						instance_container:AddValue(player, activity)
					end
				end
				
				--return:
				return total, combat:GetCombatTime(), amount
			]],
			tooltip =[[
				
			]],
		}
		
		local have = false
		for _, custom in ipairs(self.custom) do
			if (custom.name == Loc["STRING_CUSTOM_ACTIVITY_HPS"]) then
				have = true
				break
			end
		end
		if (not have) then
			setmetatable(HealActivityTime, _details.attribute_custom)
			HealActivityTime.__index = _details.attribute_custom
			self.custom[#self.custom+1] = HealActivityTime
		end
		
	end



