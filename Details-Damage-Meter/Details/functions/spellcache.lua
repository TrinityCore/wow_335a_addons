--[[ Spell Cache store all spells shown on frames and make able to change spells name, icons, etc... ]]

do 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On The Fly SpellCache

	local _details = 	_G._details
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _
	local _rawget	=	rawget
	local _rawset	=	rawset
	local _setmetatable =	setmetatable
	local _GetSpellInfo =	GetSpellInfo
	local _unpack	=	unpack

	--> default container
	_details.spellcache =	{}
	local unknowSpell = {Loc["STRING_UNKNOWSPELL"], _, "Interface\\Icons\\Ability_Druid_Eclipse"} --> localize-me
	
	--> reset spell cache
	function _details:ClearSpellCache()
		_details.spellcache = _setmetatable({}, 
				{__index = function(table, valor) 
					local this_spell = _rawget(table, valor)
					if (this_spell) then
						return this_spell
					end

					--> should save only icon and name, other values are not used
					if (valor) then --> check if spell is valid before
						local cache = {_GetSpellInfo(valor)}
						table[valor] = cache
						return cache
					else
						return unknowSpell
					end
					
				end})

		--> default overwrites
		--_rawset(_details.spellcache, 1, {Loc["STRING_MELEE"], 1, "Interface\\AddOns\\Details\\images\\melee.tga"})
		--_rawset(_details.spellcache, 2, {Loc["STRING_AUTOSHOT"], 1, "Interface\\AddOns\\Details\\images\\autoshot.tga"})
		
		--> built-in overwrites
		for spellId, spellTable in pairs(_details.SpellOverwrite) do
			local name, _, icon = _GetSpellInfo(spellId)
			_rawset(_details.spellcache, spellId, {spellTable.name or name, 1, spellTable.icon or icon})
		end
		
		--> user overwrites
		--[1] spellid[2] spellname[3] spellicon
		for index, spellTable in ipairs(_details.savedCustomSpells) do
			_rawset(_details.spellcache, spellTable[1], {spellTable[2], 1, spellTable[3]})
		end
	end
	
	local default_user_spells = {
		[1] = {name = Loc["STRING_MELEE"], icon =[[Interface\AddOns\Details\images\melee.tga]]},
		[2] = {name = Loc["STRING_AUTOSHOT"], icon =[[Interface\AddOns\Details\images\autoshot.tga]]},
		[3] = {name = Loc["STRING_ENVIRONMENTAL_FALLING"], icon =[[Interface\ICONS\Spell_Magic_FeatherFall]]},
		[4] = {name = Loc["STRING_ENVIRONMENTAL_DROWNING"], icon =[[Interface\ICONS\Ability_Suffocate]]},
		[5] = {name = Loc["STRING_ENVIRONMENTAL_FATIGUE"], icon =[[Interface\ICONS\Spell_Arcane_MindMastery]]},
		[6] = {name = Loc["STRING_ENVIRONMENTAL_FIRE"], icon =[[Interface\ICONS\INV_SummerFest_FireSpirit]]},
		[7] = {name = Loc["STRING_ENVIRONMENTAL_LAVA"], icon =[[Interface\AddOns\Details\images\Ability_Rhyolith_Volcano]]},
		[8] = {name = Loc["STRING_ENVIRONMENTAL_SLIME"], icon =[[Interface\ICONS\Ability_Creature_Poison_02]]},
		
		--[124464] = {name = GetSpellInfo(124464) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> shadow word: pain mastery proc(priest)
		--[124465] = {name = GetSpellInfo(124465) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> vampiric touch mastery proc(priest)
		--[124468] = {name = GetSpellInfo(124468) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> mind flay mastery proc(priest)
		--[124469] = {name = GetSpellInfo(124469) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> mind sear mastery proc(priest)
		--[94472] = {name = GetSpellInfo(94472) .. "(" .. Loc["STRING_CRITICAL_ONLY"] .. ")"}, --> Atonement critical hit(priest)
		--[140816] = {name = GetSpellInfo(140816) .. "(" .. Loc["STRING_CRITICAL_ONLY"] .. ")"}, --> Power Word: Solace critical hit (priest)
		
		--[33778] = {name = GetSpellInfo(33778) .. "(bloom)"}, --lifebloom(bloom)
		
		--[121414] = {name = GetSpellInfo(121414) .. "(Glaive #1)"}, --> glaive toss(hunter)
		--[120761] = {name = GetSpellInfo(120761) .. "(Glaive #2)"}, --> glaive toss(hunter)
		
		--[77451] = {name = GetSpellInfo(77451) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> lava burst(shaman)
		--[45284] = {name = GetSpellInfo(45284) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> lightningbolt(shaman)
		--[45297] = {name = GetSpellInfo(45297) .. "(" .. Loc["STRING_MASTERY"] .. ")"}, --> chain lightning(shaman)
		
		--[131079] = {name = GetSpellInfo(131079) .. "(" .. GetSpellInfo(12472) .. ")"}, --> frostbolt with icy veins glyph(mage)
		--[131080] = {name = GetSpellInfo(131080) .. "(" .. GetSpellInfo(12472) .. ")"}, --> ice lance with icy veins glyph(mage)
		--[131081] = {name = GetSpellInfo(131081) .. "(" .. GetSpellInfo(12472) .. ")"}, --> frostfire with icy veins glyph(mage)
		
		--[108686] = {name = GetSpellInfo(108686) .. "(" .. GetSpellInfo(108683) .. ")" }, --> immolate(brimstone)
		--[108685] = {name = GetSpellInfo(108685) .. "(" .. GetSpellInfo(108683) .. ")" }, --> conflagrate(brimstone)
		--[114654] = {name = GetSpellInfo(114654) .. "(" .. GetSpellInfo(108683) .. ")" }, --> incinetate(brimstone)
	}

	function _details:UserCustomSpellUpdate(index, name, icon)
		local t = _details.savedCustomSpells[index]
		if (t) then
			t[2], t[3] = name or t[2], icon or t[3]
			return _rawset(_details.spellcache, t[1], {t[2], 1, t[3]})
		else
			return false
		end
	end
	
	function _details:UserCustomSpellReset(index)
		local t = _details.savedCustomSpells[index]
		if (t) then
			local spellid = t[1]
			local name, _, icon = _GetSpellInfo(spellid)
			
			if (default_user_spells[spellid]) then
				name = default_user_spells[spellid].name
				icon = default_user_spells[spellid].icon or icon or[[Interface\InventoryItems\WoWUnknownItem01]]
			end
			
			if (not name) then
				name = "Unknown"
			end
			if (not icon) then
				icon =[[Interface\InventoryItems\WoWUnknownItem01]]
			end
			
			_rawset(_details.spellcache, spellid, {name, 1, icon})
			
			t[2] = name
			t[3] = icon
		end
	end
	
	function _details:FillUserCustomSpells()
	
		for spellid, t in pairs(default_user_spells) do 
		
			local already_have
			for index, spelltable in ipairs(_details.savedCustomSpells) do 
				if (spelltable[1] == spellid) then
					already_have = spelltable
				end
			end
		
			if (not already_have) then
				local name, _, icon = GetSpellInfo(spellid)
				_details:UserCustomSpellAdd(spellid, t.name or name or "Unknown", t.icon or icon or[[Interface\InventoryItems\WoWUnknownItem01]])	
			end
			
		end
		
	end
	
	function _details:UserCustomSpellAdd(spellid, name, icon)
		local is_overwrite = false
		for index, t in ipairs(_details.savedCustomSpells) do 
			if (t[1] == spellid) then
				t[2] = name
				t[3] = icon
				is_overwrite = true
				break
			end
		end
		if (not is_overwrite) then
			tinsert(_details.savedCustomSpells, {spellid, name, icon})
		end
		return _rawset(_details.spellcache, spellid, {name, 1, icon})
	end
	
	function _details:UserCustomSpellRemove(index)
		local t = _details.savedCustomSpells[index]
		if (t) then
			local spellid = t[1]
			local name, _, icon = _GetSpellInfo(spellid)
			_rawset(_details.spellcache, spellid, {name, 1, icon})
			return tremove(_details.savedCustomSpells, index)
		end
		
		return false
	end
	
	--> overwrite for API GetSpellInfo function 
	_details.getspellinfo = function(spellid) return _unpack(_details.spellcache[spellid]) end 
	_details.GetSpellInfo = _details.getspellinfo

	--> overwrite SpellInfo if spell is a Dot, so GetSpellInfo will return the name modified
	function _details:SpellIsDot(spellid)
		local name, rank, icon = _GetSpellInfo(spellid)
		_rawset(_details.spellcache, spellid, {name .. Loc["STRING_DOT"], rank, icon})
	end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Cache All Spells

	function _details:BuildSpellListSlow()

		local load_frame = _G.DetailsLoadSpellCache
		if (load_frame and(load_frame.completed or load_frame.inprogress)) then
			return false
		end
	
		local step = 1
		local max = 160000
		
		if (not load_frame) then
			load_frame = CreateFrame("frame", "DetailsLoadSpellCache", UIParent)
			load_frame:SetFrameStrata("DIALOG")
			
			local progress_label = load_frame:CreateFontString("DetailsLoadSpellCacheProgress", "overlay", "GameFontNormalSmall")
			progress_label:SetText("Loading Spells: 0%")
			function _details:BuildSpellListSlowTick()
				progress_label:SetText("Loading Spells: " .. load_frame:GetProgress() .. "%")
			end
			load_frame.tick = _details:ScheduleRepeatingTimer("BuildSpellListSlowTick", 1)
			
			function load_frame:GetProgress()
				return math.floor(step / max * 100)
			end
		end
		
		local SpellCache = {a={}, b={}, c={}, d={}, e={}, f={}, g={}, h={}, i={}, j={}, k={}, l={}, m={}, n={}, o={}, p={}, q={}, r={}, s={}, t={}, u={}, v={}, w={}, x={}, y={}, z={}}
		local _string_lower = string.lower
		local _string_sub = string.sub
		local blizzGetSpellInfo = GetSpellInfo
		
		load_frame.inprogress = true
		
		_details.spellcachefull = SpellCache

		load_frame:SetScript("OnUpdate", function()
			for spellid = step, step+500 do
				local name, _, icon = blizzGetSpellInfo(spellid)
				if (name) then
					local LetterIndex = _string_lower(_string_sub(name, 1, 1)) --> get the first letter
					local CachedIndex = SpellCache[LetterIndex]
					if (CachedIndex) then
						CachedIndex[spellid] = {name, icon}
					end
				end
			end
			
			step = step + 500
			
			if (step > max) then
				step = max
				_G.DetailsLoadSpellCache.completed = true
				_G.DetailsLoadSpellCache.inprogress = false
				_details:CancelTimer(_G.DetailsLoadSpellCache.tick)
				DetailsLoadSpellCacheProgress:Hide()
				load_frame:SetScript("OnUpdate", nil)
			end
			
		end)
		

		
		return true
	end

	function _details:BuildSpellList()
	
		local SpellCache = {a={}, b={}, c={}, d={}, e={}, f={}, g={}, h={}, i={}, j={}, k={}, l={}, m={}, n={}, o={}, p={}, q={}, r={}, s={}, t={}, u={}, v={}, w={}, x={}, y={}, z={}}
		local _string_lower = string.lower
		local _string_sub = string.sub
		local blizzGetSpellInfo = GetSpellInfo

		for spellid = 1, 160000 do
			local name, rank, icon = blizzGetSpellInfo(spellid)
			if (name) then
				local index = _string_lower(_string_sub(name, 1, 1))
				local CachedIndex = SpellCache[index]
				if (CachedIndex) then
					CachedIndex[spellid] = {name, icon, rank}
				end
			end
		end

		_details.spellcachefull = SpellCache
		return true
	end
	
	function _details:ClearSpellList()
		_details.spellcachefull = nil
		collectgarbage()
	end
	

	
end