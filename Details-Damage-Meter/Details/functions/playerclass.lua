--[[ detect actor class ]]

do 

	local _details	= 	_G._details
	local _
	local _pairs = pairs
	local _ipairs = ipairs
	local _UnitClass = UnitClass
	local _select = select
	local _unpack = unpack

	-- try get the class from actor name
	function _details:GetClass(name)
		local _, class = _UnitClass(name)
		
		if (not class) then
			for _, container in _ipairs(_details.table_overall) do
				local index = container._NameIndexTable[name]
				if (index) then
					local actor = container._ActorTable[index]
					if (actor.class ~= "UNGROUPPLAYER") then
						return actor.class, _details:unpacks(_details.class_coords[actor.class] or {0.75, 1, 0.75, 1}, _details.class_colors[actor.class])
					end
				end
			end
		else
			return class, _details:unpacks(_details.class_coords[class] or {0.75, 1, 0.75, 1}, _details.class_colors[class])
		end
	end
	
	local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
	function _details:GetClassIcon(class)
	
		local c
	
		if (self.class) then
			c = self.class
		elseif (type(class) == "table" and class.class) then
			c = class.class
		elseif (type(class) == "string") then
			c = class
		else
			c = "UNKNOW"
		end
		
		if (c == "UNKNOW") then
			return[[Interface\LFGFRAME\LFGROLE_BW]], 0.25, 0.5, 0, 1
		elseif (c == "UNGROUPPLAYER") then
			return[[Interface\AddOns\Details\images\Achievement_Character_Orc_Male]], 0, 1, 0, 1
		elseif (c == "PET") then
			return[[Interface\AddOns\Details\images\classes_small]], 0.25, 0.49609375, 0.75, 1
		else
			return[[Interface\AddOns\Details\images\classes_small]], _unpack(CLASS_ICON_TCOORDS[c])
		end
	end
	
	local default_color = {1, 1, 1, 1}
	function _details:GetClassColor(class)
		if (self.class) then
			return unpack(_details.class_colors[self.class] or default_color)
			
		elseif (type(class) == "table" and class.class) then
			return unpack(_details.class_colors[class.class] or default_color)
		
		elseif (type(class) == "string") then
			return unpack(_details.class_colors[class] or default_color)
			
		else
			unpack(default_color)
		end
	end
	
	function _details:GuessClass(t)
	
		local Actor, container, tries = t[1], t[2], t[3]
		
		if (not Actor) then
			return false
		end
		
		if (Actor.spell_tables) then --> correcao pros containers misc, precisa pegar os diferentes types de containers de  lá
			for spellid, _ in _pairs(Actor.spell_tables._ActorTable) do 
				local class = _details.ClassSpellList[spellid]
				if (class) then
					Actor.class = class
					Actor.shadow.class = class
					Actor.guessing_class = nil
					
					if (container) then
						container.need_refresh = true
						container.shadow.need_refresh = true
					end
					
					if (Actor.my_bar) then
						Actor.my_bar.my_table = nil
					end
				
					return class
				end
			end
		end

		local class = _details:GetClass(Actor.name)
		if (class) then
			Actor.class = class
			Actor.shadow.class = class
			Actor.need_refresh = true
			Actor.shadow.need_refresh = true
			Actor.guessing_class = nil
			
			if (container) then
				container.need_refresh = true
				container.shadow.need_refresh = true
			end
			
			if (Actor.my_bar) then
				Actor.my_bar.my_table = nil
			end
			
			return class
		end
		
		if (tries and tries < 10) then 
			_details:ScheduleTimer("GuessClass", 2, {Actor, container, tries+1})
		end
		
		return false
	end

end
