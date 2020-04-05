-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local string = _G.string
local table = _G.table
local math = _G.math

local pairs = _G.pairs

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = LibStub

local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local BZ	= LibStub("LibBabble-Zone-3.0"):GetLookupTable()
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local QTip	= LibStub("LibQTip-1.0")

-- Set up the private intra-file namespace.
local private	= select(2, ...)

local Player	= private.Player

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local NUM_RECIPE_LINES	= 25
local SCROLL_DEPTH	= 5
local LISTFRAME_WIDTH	= 295

local CATEGORY_COLORS	= private.category_colors
local BASIC_COLORS	= private.basic_colors

local SF		= private.recipe_state_flags
local COMMON1		= private.common_flags_word1

local A			= private.acquire_types
local A_MAX		= 9

local FACTION_NEUTRAL	= BFAC["Neutral"]

-------------------------------------------------------------------------------
-- Upvalues
-------------------------------------------------------------------------------
local ListItem_ShowTooltip

local acquire_tip
local spell_tip

local AcquireTable = private.AcquireTable
local ReleaseTable = private.ReleaseTable
local SetTextColor = private.SetTextColor
local GenericCreateButton = private.GenericCreateButton

-------------------------------------------------------------------------------
-- Frame creation and anchoring
-------------------------------------------------------------------------------
function private.InitializeListFrame()
	local MainPanel	= addon.Frame
	local ListFrame = CreateFrame("Frame", nil, MainPanel)

	MainPanel.list_frame = ListFrame

	ListFrame:SetHeight(335)
	ListFrame:SetWidth(LISTFRAME_WIDTH)
	ListFrame:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 22, -75)
	ListFrame:SetBackdrop({
				      bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
				      tile = true,
				      tileSize = 16,
			      })
	ListFrame:SetBackdropColor(1, 1, 1)
	ListFrame:EnableMouse(true)
	ListFrame:EnableMouseWheel(true)

	-------------------------------------------------------------------------------
	-- Scroll bar.
	-------------------------------------------------------------------------------
	local ScrollBar = CreateFrame("Slider", nil, ListFrame)

	ScrollBar:SetPoint("TOPLEFT", ListFrame, "TOPRIGHT", 5, -11)
	ScrollBar:SetPoint("BOTTOMLEFT", ListFrame, "BOTTOMRIGHT", 5, 12)
	ScrollBar:SetWidth(24)

	ScrollBar:EnableMouseWheel(true)
	ScrollBar:SetOrientation("VERTICAL")

	ScrollBar:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	ScrollBar:SetMinMaxValues(0, 1)
	ScrollBar:SetValueStep(1)

	ListFrame.scroll_bar = ScrollBar

	local ScrollUpButton = CreateFrame("Button", nil, ScrollBar, "UIPanelScrollUpButtonTemplate")

	ScrollUpButton:SetHeight(16)
	ScrollUpButton:SetWidth(18)
	ScrollUpButton:SetPoint("BOTTOM", ScrollBar, "TOP", 0, -4)

	local ScrollDownButton = CreateFrame("Button", nil, ScrollBar,"UIPanelScrollDownButtonTemplate")

	ScrollDownButton:SetHeight(16)
	ScrollDownButton:SetWidth(18)
	ScrollDownButton:SetPoint("TOP", ScrollBar, "BOTTOM", 0, 4)

	local function ScrollBar_Scroll(delta)
		if not ScrollBar:IsShown() then
			return
		end
		local cur_val = ScrollBar:GetValue()
		local min_val, max_val = ScrollBar:GetMinMaxValues()

		if delta < 0 and cur_val < max_val then
			cur_val = math.min(max_val, cur_val + SCROLL_DEPTH)
			ScrollBar:SetValue(cur_val)
		elseif delta > 0 and cur_val > min_val then
			cur_val = math.max(min_val, cur_val - SCROLL_DEPTH)
			ScrollBar:SetValue(cur_val)
		end
	end

	ScrollUpButton:SetScript("OnClick",
				 function(self, button, down)
					 if _G.IsAltKeyDown() then
						 local min_val = ScrollBar:GetMinMaxValues()
						 ScrollBar:SetValue(min_val)
					 else
						 ScrollBar_Scroll(1)
					 end
				 end)

	ScrollDownButton:SetScript("OnClick",
				   function(self, button, down)
					   if _G.IsAltKeyDown() then
						   local _, max_val = ScrollBar:GetMinMaxValues()
						   ScrollBar:SetValue(max_val)
					   else
						   ScrollBar_Scroll(-1)
					   end
				   end)

	ScrollBar:SetScript("OnMouseWheel",
			    function(self, delta)
				    ScrollBar_Scroll(delta)
			    end)

	ListFrame:SetScript("OnMouseWheel",
			    function(self, delta)
				    ScrollBar_Scroll(delta)
			    end)

	-- This can be called either from ListFrame's OnMouseWheel script, manually
	-- sliding the thumb, or from clicking the up/down buttons.
	ScrollBar:SetScript("OnValueChanged",
			    function(self, value)
				    local min_val, max_val = self:GetMinMaxValues()
				    local current_tab = MainPanel.tabs[MainPanel.current_tab]
				    local member = "profession_"..MainPanel.profession.."_scroll_value"

				    current_tab[member] = value

				    if value == min_val then
					    ScrollUpButton:Disable()
					    ScrollDownButton:Enable()
				    elseif value == max_val then
					    ScrollUpButton:Enable()
					    ScrollDownButton:Disable()
				    else
					    ScrollUpButton:Enable()
					    ScrollDownButton:Enable()
				    end
				    ListFrame:Update(nil, true)
			    end)

	local function Button_OnEnter(self)
		ListItem_ShowTooltip(self, ListFrame.entries[self.string_index])
	end

	local function Button_OnLeave()
		QTip:Release(acquire_tip)
		spell_tip:Hide()
	end

	local function Bar_OnEnter(self)
		ListItem_ShowTooltip(self, ListFrame.entries[self.string_index])
	end

	local function Bar_OnLeave()
		QTip:Release(acquire_tip)
		spell_tip:Hide()
	end

	local function ListItem_OnClick(self, button, down)
		local clickedIndex = self.string_index

		-- Don't do anything if they've clicked on an empty button
		if not clickedIndex or clickedIndex == 0 then
			return
		end
		local clicked_line = ListFrame.entries[clickedIndex]
		local traverseIndex = 0

		if not clicked_line then
			return
		end
		-- First, check if this is a "modified" click, and react appropriately
		if clicked_line.recipe_id and _G.IsModifierKeyDown() then
			if _G.IsControlKeyDown() and _G.IsShiftKeyDown() then
				addon:AddWaypoint(clicked_line.recipe_id, clicked_line.acquire_id, clicked_line.location_id, clicked_line.npc_id)
			elseif _G.IsShiftKeyDown() then
				local itemID = private.recipe_list[clicked_line.recipe_id].item_id

				if itemID then
					local _, itemLink = _G.GetItemInfo(itemID)

					if itemLink then
						local edit_box = _G.ChatEdit_ChooseBoxForSend()

						_G.ChatEdit_ActivateChat(edit_box)
						edit_box:Insert(itemLink)
					else
						addon:Print(L["NoItemLink"])
					end
				else
					addon:Print(L["NoItemLink"])
				end
			elseif _G.IsControlKeyDown() then
				local edit_box = _G.ChatEdit_ChooseBoxForSend()

				_G.ChatEdit_ActivateChat(edit_box)
				edit_box:Insert(GetSpellLink(private.recipe_list[clicked_line.recipe_id].spell_id))
			elseif _G.IsAltKeyDown() then
				local exclusion_list = addon.db.profile.exclusionlist
				local recipe_id = clicked_line.recipe_id

				exclusion_list[recipe_id] = (not exclusion_list[recipe_id] and true or nil)
				ListFrame:Update(nil, false)
			end
		elseif clicked_line.type == "header" or clicked_line.type == "subheader" then
			-- three possibilities here (all with no modifiers)
			-- 1) We clicked on the recipe button on a closed recipe
			-- 2) We clicked on the recipe button of an open recipe
			-- 3) we clicked on the expanded text of an open recipe
			if clicked_line.is_expanded then
				traverseIndex = clickedIndex + 1

				local check_type = clicked_line.type
				local entry = ListFrame.entries[traverseIndex]
				local current_tab = MainPanel.tabs[MainPanel.current_tab]

				-- get rid of our expanded lines
				while entry and entry.type ~= check_type do
					-- Headers are never removed.
					if entry.type == "header" then
						break
					end
					current_tab:ModifyEntry(entry, false)
					ReleaseTable(table.remove(ListFrame.entries, traverseIndex))
					entry = ListFrame.entries[traverseIndex]

					if not entry then
						break
					end
				end
				current_tab:ModifyEntry(clicked_line, false)
				clicked_line.is_expanded = false
			else
				ListFrame:ExpandEntry(clickedIndex)
				clicked_line.is_expanded = true
			end
		else
			-- clicked_line is an expanded entry - find the index for its parent, and remove all of the parent's child entries.
			local parent = clicked_line.parent

			if parent then
				local parent_index
				local entries = ListFrame.entries

				for index = 1, #entries do
					if entries[index] == parent then
						parent_index = index
						break
					end
				end

				if not parent_index then
					addon:Debug("clicked_line (%s): parent wasn't found in ListFrame.entries", clicked_line.text)
					return
				end
				local current_tab = MainPanel.tabs[MainPanel.current_tab]

				parent.is_expanded = false
				current_tab:ModifyEntry(parent, false)

				local child_index = parent_index + 1

				while entries[child_index] and entries[child_index].parent == parent do
					ReleaseTable(table.remove(entries, child_index))
				end
			else
				addon:Debug("Error: clicked_line has no parent.")
			end
		end
		QTip:Release(acquire_tip)
		spell_tip:Hide()

		ListFrame:Update(nil, true)
	end

	-------------------------------------------------------------------------------
	-- The state and entry buttons and the container frames which hold them.
	-------------------------------------------------------------------------------
	ListFrame.entries = {}
	ListFrame.button_containers = {}
	ListFrame.state_buttons = {}
	ListFrame.entry_buttons = {}

	for i = 1, NUM_RECIPE_LINES do
		local cur_container = CreateFrame("Frame", nil, ListFrame)

		cur_container:SetHeight(16)
		cur_container:SetWidth(LISTFRAME_WIDTH)

		local cur_state = GenericCreateButton(nil, ListFrame, 16, 16, nil, nil, nil, nil, 2)
		local cur_entry = GenericCreateButton(nil, ListFrame, 16, LISTFRAME_WIDTH, "GameFontNormalSmall", "Blort", "LEFT", nil, 0)

		if i == 1 then
			cur_container:SetPoint("TOPLEFT", ListFrame, "TOPLEFT", 0, 0)
			cur_state:SetPoint("TOPLEFT", cur_container, "TOPLEFT", 0, 0)
			cur_entry:SetPoint("TOPLEFT", cur_state, "TOPRIGHT", -3, 0)
		else
			local prev_container = ListFrame.button_containers[i - 1]

			cur_container:SetPoint("TOPLEFT", prev_container, "BOTTOMLEFT", 0, 3)
			cur_state:SetPoint("TOPLEFT", cur_container, "TOPLEFT", 0, 0)
			cur_entry:SetPoint("TOPLEFT", cur_state, "TOPRIGHT", -3, 0)
		end
		cur_state.container = cur_container

		cur_state:SetScript("OnClick", ListItem_OnClick)
		cur_entry:SetScript("OnClick", ListItem_OnClick)

		ListFrame.button_containers[i] = cur_container
		ListFrame.state_buttons[i] = cur_state
		ListFrame.entry_buttons[i] = cur_entry
	end

	function ListFrame:InsertEntry(entry, parent_entry, entry_index, entry_type, entry_expanded, expand_mode)
		entry.type = entry_type

		if parent_entry then
			if parent_entry ~= entry then
				entry.parent = parent_entry

				local recipe_id = parent_entry.recipe_id
				local acquire_id = parent_entry.acquire_id
				local location_id = parent_entry.location_id
				local npc_id = parent_entry.npc_id

				if recipe_id then
					entry.recipe_id = recipe_id
				end

				if acquire_id then
					entry.acquire_id = acquire_id
				end

				if location_id then
					entry.location_id = location_id
				end

				if npc_id then
					entry.npc_id = npc_id
				end
			else
				addon:Debug("Attempting to parent an entry to itself.")
			end
		elseif entry.type ~= "header" then
			addon:Debug("Non-header entry without a parent: %s - %s", entry.type, entry.text)
		end
		local insert_index = entry_index

		-- If we have acquire information for this entry, push the data table into the list
		-- and start processing the acquires.
		if expand_mode then
			local current_tab = MainPanel.tabs[MainPanel.current_tab]

			entry.is_expanded = true
			table.insert(self.entries, insert_index, entry)

			current_tab:ModifyEntry(entry, entry_expanded)

			if entry_type == "header" or entry_type == "subheader" then
				insert_index = self:ExpandEntry(insert_index, expand_mode)
			else
				insert_index = insert_index + 1
			end
		else
			entry.is_expanded = entry_expanded
			table.insert(self.entries, insert_index, entry)

			insert_index = insert_index + 1
		end
		return insert_index
	end

	-------------------------------------------------------------------------------
	-- Filter flag data and functions for ListFrame:Initialize()
	-------------------------------------------------------------------------------
	do
		local filter_db		= addon.db.profile.filters

		local binding_filters	= filter_db.binding
		local player_filters	= filter_db.player
		local armor_filters	= filter_db.item.armor
		local weapon_filters	= filter_db.item.weapon
		local obtain_filters	= filter_db.obtain

		local V = private.game_versions
		local EXPANSION_FILTERS = {
			[V.ORIG]	= "expansion0",
			[V.TBC]		= "expansion1",
			[V.WOTLK]	= "expansion2",
		}

		local Q = private.item_qualities
		local QUALITY_FILTERS = {
			[Q.COMMON]	= "common",
			[Q.UNCOMMON]	= "uncommon",
			[Q.RARE]	= "rare",
			[Q.EPIC]	= "epic",
		}

		-- HARD_FILTERS and SOFT_FILTERS are used to determine if a recipe should be shown based on the value of the key compared to the value
		-- of its saved_var.
		local ITEM1 = private.item_flags_word1
		local HARD_FILTERS = {
			------------------------------------------------------------------------------------------------
			-- Binding flags.
			------------------------------------------------------------------------------------------------
			["itemboe"]	= { flag = COMMON1.IBOE,	index = 1,	sv_root = binding_filters },
			["itembop"]	= { flag = COMMON1.IBOP,	index = 1,	sv_root = binding_filters },
			["itemboa"]	= { flag = COMMON1.IBOA,	index = 1,	sv_root = binding_filters },
			["recipeboe"]	= { flag = COMMON1.RBOE,	index = 1,	sv_root = binding_filters },
			["recipebop"]	= { flag = COMMON1.RBOP,	index = 1,	sv_root = binding_filters },
			["recipeboa"]	= { flag = COMMON1.RBOA,	index = 1,	sv_root = binding_filters },
			------------------------------------------------------------------------------------------------
			-- Player Type flags.
			------------------------------------------------------------------------------------------------
			["melee"]	= { flag = COMMON1.DPS,		index = 1,	sv_root = player_filters },
			["tank"]	= { flag = COMMON1.TANK,	index = 1,	sv_root = player_filters },
			["healer"]	= { flag = COMMON1.HEALER,	index = 1,	sv_root = player_filters },
			["caster"]	= { flag = COMMON1.CASTER,	index = 1,	sv_root = player_filters },
			------------------------------------------------------------------------------------------------
			-- Armor flags.
			------------------------------------------------------------------------------------------------
			["cloth"]	= { flag = ITEM1.CLOTH,		index = 5,	sv_root = armor_filters },
			["leather"]	= { flag = ITEM1.LEATHER,	index = 5,	sv_root = armor_filters },
			["mail"]	= { flag = ITEM1.MAIL,		index = 5,	sv_root = armor_filters },
			["plate"]	= { flag = ITEM1.PLATE,		index = 5,	sv_root = armor_filters },
			["trinket"]	= { flag = ITEM1.TRINKET,	index = 5,	sv_root = armor_filters },
			["cloak"]	= { flag = ITEM1.CLOAK,		index = 5,	sv_root = armor_filters },
			["ring"]	= { flag = ITEM1.RING,		index = 5,	sv_root = armor_filters },
			["necklace"]	= { flag = ITEM1.NECK,		index = 5,	sv_root = armor_filters },
			["shield"]	= { flag = ITEM1.SHIELD,	index = 5,	sv_root = armor_filters },
			------------------------------------------------------------------------------------------------
			-- Weapon flags.
			------------------------------------------------------------------------------------------------
			["onehand"]	= { flag = ITEM1.ONE_HAND,	index = 5,	sv_root = weapon_filters },
			["twohand"]	= { flag = ITEM1.TWO_HAND,	index = 5,	sv_root = weapon_filters },
			["axe"]		= { flag = ITEM1.AXE,		index = 5,	sv_root = weapon_filters },
			["sword"]	= { flag = ITEM1.SWORD,		index = 5,	sv_root = weapon_filters },
			["mace"]	= { flag = ITEM1.MACE,		index = 5,	sv_root = weapon_filters },
			["polearm"]	= { flag = ITEM1.POLEARM,	index = 5,	sv_root = weapon_filters },
			["dagger"]	= { flag = ITEM1.DAGGER,	index = 5,	sv_root = weapon_filters },
			["fist"]	= { flag = ITEM1.FIST,		index = 5,	sv_root = weapon_filters },
			["gun"]		= { flag = ITEM1.GUN,		index = 5,	sv_root = weapon_filters },
			["staff"]	= { flag = ITEM1.STAFF,		index = 5,	sv_root = weapon_filters },
			["wand"]	= { flag = ITEM1.WAND,		index = 5,	sv_root = weapon_filters },
			["thrown"]	= { flag = ITEM1.THROWN,	index = 5,	sv_root = weapon_filters },
			["bow"]		= { flag = ITEM1.BOW,		index = 5,	sv_root = weapon_filters },
			["crossbow"]	= { flag = ITEM1.XBOW,		index = 5,	sv_root = weapon_filters },
			["ammo"]	= { flag = ITEM1.AMMO,		index = 5,	sv_root = weapon_filters },
		}

		local SOFT_FILTERS = {
			["trainer"]	= { flag = COMMON1.TRAINER,	index = 1,	sv_root = obtain_filters },
			["vendor"]	= { flag = COMMON1.VENDOR,	index = 1,	sv_root = obtain_filters },
			["instance"]	= { flag = COMMON1.INSTANCE,	index = 1,	sv_root = obtain_filters },
			["raid"]	= { flag = COMMON1.RAID,	index = 1,	sv_root = obtain_filters },
			["seasonal"]	= { flag = COMMON1.SEASONAL,	index = 1,	sv_root = obtain_filters },
			["quest"]	= { flag = COMMON1.QUEST,	index = 1,	sv_root = obtain_filters },
			["pvp"]		= { flag = COMMON1.PVP,		index = 1,	sv_root = obtain_filters },
			["worlddrop"]	= { flag = COMMON1.WORLD_DROP,	index = 1,	sv_root = obtain_filters },
			["mobdrop"]	= { flag = COMMON1.MOB_DROP,	index = 1,	sv_root = obtain_filters },
			["discovery"]	= { flag = COMMON1.DISC,	index = 1,	sv_root = obtain_filters },
		}

		local REP1 = private.rep_flags_word1
		local REP_FILTERS = {
			[REP1.ARGENTDAWN]		= "argentdawn",
			[REP1.CENARION_CIRCLE]		= "cenarioncircle",
			[REP1.THORIUM_BROTHERHOOD]	= "thoriumbrotherhood",
			[REP1.TIMBERMAW_HOLD]		= "timbermaw",
			[REP1.ZANDALAR]			= "zandalar",
			[REP1.ALDOR]			= "aldor",
			[REP1.ASHTONGUE]		= "ashtonguedeathsworn",
			[REP1.CENARION_EXPEDITION]	= "cenarionexpedition",
			[REP1.HELLFIRE]			= "hellfire",
			[REP1.CONSORTIUM]		= "consortium",
			[REP1.KOT]			= "keepersoftime",
			[REP1.LOWERCITY]		= "lowercity",
			[REP1.NAGRAND]			= "nagrand",
			[REP1.SCALE_SANDS]		= "scaleofthesands",
			[REP1.SCRYER]			= "scryer",
			[REP1.SHATAR]			= "shatar",
			[REP1.SHATTEREDSUN]		= "shatteredsun",
			[REP1.SPOREGGAR]		= "sporeggar",
			[REP1.VIOLETEYE]		= "violeteye",
			[REP1.ARGENTCRUSADE]		= "argentcrusade",
			[REP1.FRENZYHEART]		= "frenzyheart",
			[REP1.EBONBLADE]		= "ebonblade",
			[REP1.KIRINTOR]			= "kirintor",
			[REP1.HODIR]			= "sonsofhodir",
			[REP1.KALUAK]			= "kaluak",
			[REP1.ORACLES]			= "oracles",
			[REP1.WYRMREST]			= "wyrmrest",
			[REP1.WRATHCOMMON1]		= "wrathcommon1",
			[REP1.WRATHCOMMON2]		= "wrathcommon2",
			[REP1.WRATHCOMMON3]		= "wrathcommon3",
			[REP1.WRATHCOMMON4]		= "wrathcommon4",
			[REP1.WRATHCOMMON5]		= "wrathcommon5",
		}

		local REP2 = private.rep_flags_word2
		local REP_FILTERS_2 = {
			[REP2.ASHEN_VERDICT]	= "ashenverdict",
		}

		local CLASS1 = private.class_flags_word1
		local CLASS_FILTERS = {
			["deathknight"]	= CLASS1.DK,
			["druid"]	= CLASS1.DRUID,
			["hunter"]	= CLASS1.HUNTER,
			["mage"]	= CLASS1.MAGE,
			["paladin"]	= CLASS1.PALADIN,
			["priest"]	= CLASS1.PRIEST,
			["shaman"]	= CLASS1.SHAMAN,
			["rogue"]	= CLASS1.ROGUE,
			["warlock"]	= CLASS1.WARLOCK,
			["warrior"]	= CLASS1.WARRIOR,
		}

		---Scans a specific recipe to determine if it is to be displayed or not.
		-- For flag info see comments at start of file in comments
		local function CanDisplayRecipe(recipe)
			if addon.db.profile.exclusionlist[recipe.spell_id] and not addon.db.profile.ignoreexclusionlist then
				return false
			end
			local general_filters = filter_db.general

			-------------------------------------------------------------------------------
			-- Stage 1 - Loop through exclusive flags (hard filters).
			-- If one of these does not pass, the recipe is not displayed.
			-------------------------------------------------------------------------------

			-- Display both horde and alliance factions?
			if not general_filters.faction and not Player:HasRecipeFaction(recipe) then
				return false
			end

			-- Display all skill levels?
			if not general_filters.skill and recipe.skill_level > Player["ProfessionLevel"] then
				return false
			end

			-- Display all specialities?
			if not general_filters.specialty then
				local specialty = recipe.specialty

				if specialty and specialty ~= Player["Specialty"] then
					return false
				end
			end

			-- Display retired recipes?
			if not general_filters.retired and bit.band(recipe.flags.common1, COMMON1.RETIRED) == COMMON1.RETIRED then
				return false
			end
			local game_version = private.game_versions[recipe.genesis]

			-- Expansion filters.
			if not obtain_filters[EXPANSION_FILTERS[game_version]] then
				return false
			end
			local quality_filters = filter_db.quality
			local recipe_quality = recipe.quality

			-- Quality filters.
			if not quality_filters[QUALITY_FILTERS[recipe_quality]] then
				return false
			end

			-------------------------------------------------------------------------------
			-- Check the hard filter flags
			-------------------------------------------------------------------------------
			for filter, data in pairs(HARD_FILTERS) do
				local bitfield = recipe.flags[private.flag_members[data.index]]

				if bitfield and bit.band(bitfield, data.flag) == data.flag and not data.sv_root[filter] then
					return false
				end
			end

			-------------------------------------------------------------------------------
			-- Check the reputation filter flags - _all_ of the pertinent reputation or
			-- class flags must be toggled off or the recipe is still shown.
			-------------------------------------------------------------------------------
			local toggled_off, toggled_on = 0, 0

			for flag, name in pairs(REP_FILTERS) do
				local bitfield = recipe.flags.reputation1

				if bitfield and bit.band(bitfield, flag) == flag then
					if filter_db.rep[name] then
						toggled_on = toggled_on + 1
					else
						toggled_off = toggled_off + 1
					end
				end
			end

			if toggled_off > 0 and toggled_on == 0 then
				return false
			end

			toggled_off, toggled_on = 0, 0

			for flag, name in pairs(REP_FILTERS_2) do
				local bitfield = recipe.flags.reputation2

				if bitfield and bit.band(bitfield, flag) == flag then
					if filter_db.rep[name] then
						toggled_on = toggled_on + 1
					else
						toggled_off = toggled_off + 1
					end
				end
			end

			if toggled_off > 0 and toggled_on == 0 then
				return false
			end

			-------------------------------------------------------------------------------
			-- Check the class filter flags
			-------------------------------------------------------------------------------
			local class_filters = filter_db.classes

			toggled_off, toggled_on = 0, 0

			for class, flag in pairs(CLASS_FILTERS) do
				local bitfield = recipe.flags.class1

				if bitfield and bit.band(bitfield, flag) == flag then
					if class_filters[class] then
						toggled_on = toggled_on + 1
					else
						toggled_off = toggled_off + 1
					end
				end
			end

			if toggled_off > 0 and toggled_on == 0 then
				return false
			end

			------------------------------------------------------------------------------------------------
			-- Stage 2
			-- loop through nonexclusive (soft filters) flags until one is true
			-- If one of these is true (ie: we want to see trainers and there is a trainer flag) we display the recipe
			------------------------------------------------------------------------------------------------
			for filter, data in pairs(SOFT_FILTERS) do
				local bitfield = recipe.flags[private.flag_members[data.index]]

				if bitfield and bit.band(bitfield, data.flag) == data.flag and data.sv_root[filter] then
					return true
				end
			end

			-- If we get here it means that no flags matched our values
			return false
		end

		function ListFrame:Initialize(expand_mode)
			for i = 1, #self.entries do
				ReleaseTable(self.entries[i])
			end
			table.wipe(self.entries)

			-------------------------------------------------------------------------------
			-- Update recipe filters.
			-------------------------------------------------------------------------------
			local general_filters = addon.db.profile.filters.general

			local recipes_total = 0
			local recipes_known = 0

			local recipes_total_filtered = 0
			local recipes_known_filtered = 0

			local recipe_list = private.recipe_list
			local current_prof = MainPanel.prof_name or private.ordered_professions[MainPanel.profession]
			local can_display = false

			for recipe_id, recipe in pairs(recipe_list) do
				recipe:RemoveState("VISIBLE")

				if recipe.profession == current_prof then
					local is_known

					if MainPanel.is_linked then
						is_known = recipe:HasState("LINKED")
					else
						is_known = recipe:HasState("KNOWN")
					end

					can_display = CanDisplayRecipe(recipe)
					recipes_total = recipes_total + 1
					recipes_known = recipes_known + (is_known and 1 or 0)

					if can_display then
						recipes_total_filtered = recipes_total_filtered + 1
						recipes_known_filtered = recipes_known_filtered + (is_known and 1 or 0)

						if not general_filters.known and is_known then
							can_display = false
						end

						if not general_filters.unknown and not is_known then
							can_display = false
						end
					end
				else
					can_display = false
				end

				if can_display then
					recipe:AddState("VISIBLE")
				end
			end
			Player.recipes_total = recipes_total
			Player.recipes_known = recipes_known
			Player.recipes_total_filtered = recipes_total_filtered
			Player.recipes_known_filtered = recipes_known_filtered

			-------------------------------------------------------------------------------
			-- Mark all exclusions in the recipe database to not be displayed, and update
			-- the player's known and unknown counts.
			-------------------------------------------------------------------------------
			local exclusion_list = addon.db.profile.exclusionlist
			local ignored = not addon.db.profile.ignoreexclusionlist
			local known_count = 0
			local unknown_count = 0

			for spell_id in pairs(exclusion_list) do
				local recipe = recipe_list[spell_id]

				if recipe then
					if recipe:HasState("KNOWN") and recipe.profession == current_prof then
						known_count = known_count + 1
					elseif recipe_profession == current_prof then
						unknown_count = unknown_count + 1
					end
				end
			end
			Player.excluded_recipes_known = known_count
			Player.excluded_recipes_unknown = unknown_count

			-------------------------------------------------------------------------------
			-- Initialize the expand button and entries for the current tab.
			-------------------------------------------------------------------------------
			local current_tab = MainPanel.tabs[addon.db.profile.current_tab]
			local expanded_button = current_tab["expand_button_"..MainPanel.profession]

			if expanded_button then
				MainPanel.expand_button:Expand(current_tab)
			else
				MainPanel.expand_button:Contract(current_tab)
			end
			local recipe_count = current_tab:Initialize(expand_mode)

			-------------------------------------------------------------------------------
			-- Update the progress bar display.
			-------------------------------------------------------------------------------
			local profile = addon.db.profile
			local max_value = profile.includefiltered and Player.recipes_total or Player.recipes_total_filtered
			local cur_value = profile.includefiltered and Player.recipes_known or Player.recipes_known_filtered

			if not profile.includeexcluded and not profile.ignoreexclusionlist then
				max_value = max_value - Player.excluded_recipes_known
			end
			local progress_bar = MainPanel.progress_bar

			progress_bar:SetMinMaxValues(0, max_value)
			progress_bar:SetValue(cur_value)

			local percentage = cur_value / max_value * 100

			if (math.floor(percentage) < 101) and cur_value >= 0 and max_value >= 0 then
				local results = string.format(_G.SINGLE_PAGE_RESULTS_TEMPLATE, recipe_count)
				progress_bar.text:SetFormattedText("%d/%d - %1.2f%% (%s)", cur_value, max_value, percentage, results)
			else
				progress_bar.text:SetFormattedText("%s", L["NOT_YET_SCANNED"])
			end
		end
	end	-- do-block

	-- Reset the current buttons/lines
	function ListFrame:ClearLines()
		local font_object = addon.db.profile.frameopts.small_list_font and "GameFontNormalSmall" or "GameFontNormal"

		for i = 1, NUM_RECIPE_LINES do
			local entry = self.entry_buttons[i]
			local state = self.state_buttons[i]

			entry.string_index = 0
			entry.text:SetFontObject(font_object)

			entry:SetText("")
			entry:SetScript("OnEnter", nil)
			entry:SetScript("OnLeave", nil)
			entry:SetWidth(LISTFRAME_WIDTH)
			entry:Disable()

			state.string_index = 0

			state:Hide()
			state:SetScript("OnEnter", nil)
			state:SetScript("OnLeave", nil)
			state:Disable()

			state:ClearAllPoints()
		end
	end

	function ListFrame:Update(expand_mode, refresh)
		if not refresh then
			self:Initialize(expand_mode)
		end

		local num_entries = #self.entries

		if num_entries == 0 then
			self:ClearLines()

			-- disable expand button, it's useless here and would spam the same error again
			MainPanel.expand_button:SetNormalFontObject("GameFontDisableSmall")
			MainPanel.expand_button:Disable()
			self.scroll_bar:Hide()

			local showpopup = false

			if not addon.db.profile.hidepopup then
				showpopup = true
			end

			-- If we haven't run this before we'll show pop-ups for the first time.
			if addon.db.profile.addonversion ~= addon.version then
				addon.db.profile.addonversion = addon.version
				showpopup = true
			end
			local editbox_text = MainPanel.search_editbox:GetText()

			if Player.recipes_total == 0 then
				if showpopup then
					_G.StaticPopup_Show("ARL_NOTSCANNED")
				end
			elseif Player.recipes_known == Player.recipes_total then
				if showpopup then
					_G.StaticPopup_Show("ARL_ALLKNOWN")
				end
			elseif (Player.recipes_total_filtered - Player.recipes_known_filtered) == 0 then
				if showpopup then
					_G.StaticPopup_Show("ARL_ALLFILTERED")
				end
			elseif Player.excluded_recipes_unknown ~= 0 then
				if showpopup then
					_G.StaticPopup_Show("ARL_ALLEXCLUDED")
				end
			elseif editbox_text ~= "" and editbox_text ~= _G.SEARCH then
				_G.StaticPopup_Show("ARL_SEARCHFILTERED")
			else
				addon:Print(L["NO_DISPLAY"])
				addon:Debug("Current tab is %s", _G.tostring(addon.db.profile.current_tab))
				addon:Debug("recipes_total check for 0")
				addon:Debug("recipes_total: " .. Player.recipes_total)
				addon:Debug("recipes_total check for equal to recipes_total")
				addon:Debug("recipes_known: " .. Player.recipes_known)
				addon:Debug("recipes_total: " .. Player.recipes_total)
				addon:Debug("recipes_total_filtered - recipes_known_filtered = 0")
				addon:Debug("recipes_total_filtered: " .. Player.recipes_total_filtered)
				addon:Debug("recipes_known_filtered: " .. Player.recipes_known_filtered)
				addon:Debug("excluded_recipes_unknown ~= 0")
				addon:Debug("excluded_recipes_unknown: " .. Player.excluded_recipes_unknown)
			end
			return
		end
		local offset = 0

		addon:ClosePopups()

		MainPanel.expand_button:SetNormalFontObject("GameFontNormalSmall")
		MainPanel.expand_button:Enable()

		if num_entries <= NUM_RECIPE_LINES then
			self.scroll_bar:Hide()
		else
			local max_val = num_entries - NUM_RECIPE_LINES
			local current_tab = MainPanel.tabs[MainPanel.current_tab]
			local scroll_value = current_tab["profession_"..MainPanel.profession.."_scroll_value"] or 0

			scroll_value = math.max(0, math.min(scroll_value, max_val))
			offset = scroll_value

			self.scroll_bar:SetMinMaxValues(0, math.max(0, max_val))
			self.scroll_bar:SetValue(scroll_value)
			self.scroll_bar:Show()
		end
		self:ClearLines()

		local button_index = 1
		local string_index = button_index + offset

		-- Populate the buttons with new values
		while button_index <= NUM_RECIPE_LINES and string_index <= num_entries do
			local cur_state = self.state_buttons[button_index]
			local cur_entry = self.entries[string_index]

			if cur_entry.type == "header" or cur_entry.type == "subheader" then
				cur_state:Show()

				if cur_entry.is_expanded then
					cur_state:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
					cur_state:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
					cur_state:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
					cur_state:SetDisabledTexture("Interface\\Buttons\\UI-MinusButton-Disabled")
				else
					cur_state:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
					cur_state:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
					cur_state:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
					cur_state:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")
				end
				cur_state.string_index = string_index
				cur_state:SetScript("OnEnter", Button_OnEnter)
				cur_state:SetScript("OnLeave", Button_OnLeave)
				cur_state:Enable()
			else
				cur_state:Hide()
				cur_state:Disable()
			end
			local cur_container = cur_state.container
			local cur_button = self.entry_buttons[button_index]

			if cur_entry.type == "header" or cur_entry.type == "entry" then
				cur_state:SetPoint("TOPLEFT", cur_container, "TOPLEFT", 0, 0)
			elseif cur_entry.type == "subheader" or cur_entry.type == "subentry" then
				cur_state:SetPoint("TOPLEFT", cur_container, "TOPLEFT", 15, 0)
				cur_button:SetWidth(LISTFRAME_WIDTH - 15)
			end
			cur_button.string_index = string_index
			cur_button:SetText(cur_entry.text)
			cur_button:SetScript("OnEnter", Bar_OnEnter)
			cur_button:SetScript("OnLeave", Bar_OnLeave)
			cur_button:Enable()

			button_index = button_index + 1
			string_index = string_index + 1
		end
		button_index = 1
		string_index = button_index + offset

		-- This function could possibly have been called from a mouse click or by scrolling. Since, in those cases, the list entries have
		-- changed, the mouse is likely over a different entry - a tooltip should be generated for it.
		while button_index <= NUM_RECIPE_LINES and string_index <= num_entries do
			local cur_state = self.state_buttons[button_index]
			local cur_button = self.entry_buttons[button_index]

			if cur_state:IsMouseOver() then
				Button_OnEnter(cur_state)
				break
			elseif cur_button:IsMouseOver() then
				Bar_OnEnter(cur_button)
				break
			end
			button_index = button_index + 1
			string_index = string_index + 1
		end
	end

	-------------------------------------------------------------------------------
	-- Functions and data pertaining to individual list entries.
	-------------------------------------------------------------------------------
	local faction_strings

	local function CanDisplayFaction(faction)
		if addon.db.profile.filters.general.faction then
			return true
		end
		return (not faction or faction == BFAC[Player.faction] or faction == FACTION_NEUTRAL)
	end

	-- Padding for list entries/subentries
	local PADDING = "    "

	-- Changes the color of "name" based on faction type.
	local function ColorNameByFaction(name, faction)
		if faction == FACTION_NEUTRAL then
			name = SetTextColor(private.reputation_colors["neutral"], name)
		elseif faction == BFAC[Player.faction] then
			name = SetTextColor(private.reputation_colors["exalted"], name)
		else
			name = SetTextColor(private.reputation_colors["hated"], name)
		end
		return name
	end

	local function ExpandTrainerData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local trainer = private.trainer_list[id_num]

		if not CanDisplayFaction(trainer.faction) then
			return entry_index
		end

		local name = ColorNameByFaction(trainer.name, trainer.faction)
		local coord_text = ""

		if trainer.coord_x ~= 0 and trainer.coord_y ~= 0 then
			coord_text = SetTextColor(CATEGORY_COLORS["coords"], "(" .. trainer.coord_x .. ", " .. trainer.coord_y .. ")")
		end
		local t = AcquireTable()

		t.text = string.format("%s%s %s", PADDING, hide_type and "" or SetTextColor(CATEGORY_COLORS["trainer"], L["Trainer"])..":", name)
		t.recipe_id = recipe_id
		t.npc_id = id_num

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		if coord_text == "" and hide_location then
			return entry_index
		end
		t = AcquireTable()
		t.text = string.format("%s%s%s %s", PADDING, PADDING,
				       hide_location and "" or SetTextColor(CATEGORY_COLORS["location"], trainer.location), coord_text)
		t.recipe_id = recipe_id
		t.npc_id = id_num

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	-- Right now PVP obtained items are located on vendors so they have the vendor and PVP flag.
	-- We need to display the vendor in the drop down if we want to see vendors or if we want to see PVP
	-- This allows us to select PVP only and to see just the PVP recipes
	local function ExpandVendorData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local vendor = private.vendor_list[id_num]

		if not CanDisplayFaction(vendor.faction) then
			return entry_index
		end

		local name = ColorNameByFaction(vendor.name, vendor.faction)
		local coord_text = ""

		if vendor.coord_x ~= 0 and vendor.coord_y ~= 0 then
			coord_text = SetTextColor(CATEGORY_COLORS["coords"], "(" .. vendor.coord_x .. ", " .. vendor.coord_y .. ")")
		end
		local t = AcquireTable()
		local quantity = vendor.item_list[recipe_id]

		t.text = string.format("%s%s %s%s", PADDING,
				       hide_type and "" or SetTextColor(CATEGORY_COLORS["vendor"], L["Vendor"])..":", name,
				       type(quantity) == "number" and SetTextColor(BASIC_COLORS["white"], string.format(" (%d)", quantity)) or "")
		t.recipe_id = recipe_id
		t.npc_id = id_num

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		if coord_text == "" and hide_location then
			return entry_index
		end
		t = AcquireTable()
		t.text = string.format("%s%s%s %s", PADDING, PADDING,
				       hide_location and "" or SetTextColor(CATEGORY_COLORS["location"], vendor.location), coord_text)
		t.recipe_id = recipe_id
		t.npc_id = id_num

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	-- Mobs can be in instances, raids, or specific mob related drops.
	local function ExpandMobData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local mob = private.mob_list[id_num]
		local coord_text = ""

		if mob.coord_x ~= 0 and mob.coord_y ~= 0 then
			coord_text = SetTextColor(CATEGORY_COLORS["coords"], "(" .. mob.coord_x .. ", " .. mob.coord_y .. ")")
		end
		local t = AcquireTable()

		t.text = string.format("%s%s %s", PADDING, hide_type and "" or SetTextColor(CATEGORY_COLORS["mobdrop"], L["Mob Drop"])..":",
				       SetTextColor(private.reputation_colors["hostile"], mob.name))
		t.recipe_id = recipe_id
		t.npc_id = id_num

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		if coord_text == "" and hide_location then
			return entry_index
		end
		t = AcquireTable()
		t.text = string.format("%s%s%s %s", PADDING, PADDING, hide_location and "" or SetTextColor(CATEGORY_COLORS["location"], mob.location),
				       coord_text)
		t.recipe_id = recipe_id
		t.npc_id = id_num

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandQuestData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local quest = private.quest_list[id_num]

		if not CanDisplayFaction(quest.faction) then
			return entry_index
		end

		local name = ColorNameByFaction(private.quest_names[id_num], quest.faction)
		local coord_text = ""

		if quest.coord_x ~= 0 and quest.coord_y ~= 0 then
			coord_text = SetTextColor(CATEGORY_COLORS["coords"], "(" .. quest.coord_x .. ", " .. quest.coord_y .. ")")
		end
		local t = AcquireTable()

		t.text = string.format("%s%s %s", PADDING, hide_type and "" or SetTextColor(CATEGORY_COLORS["quest"], L["Quest"])..":", name)
		t.recipe_id = recipe_id

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		if coord_text == "" and hide_location then
			return entry_index
		end
		t = AcquireTable()
		t.text = string.format("%s%s%s %s", PADDING, PADDING,
				       hide_location and "" or SetTextColor(CATEGORY_COLORS["location"], quest.location), coord_text)
		t.recipe_id = recipe_id

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandSeasonalData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local t = AcquireTable()

		t.text = string.format("%s%s %s", PADDING,
				       hide_type and "" or SetTextColor(CATEGORY_COLORS["seasonal"], private.acquire_names[A.SEASONAL])..":",
				       SetTextColor(CATEGORY_COLORS["seasonal"], private.seasonal_list[id_num].name))
		t.recipe_id = recipe_id

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandReputationData(entry_index, entry_type, parent_entry, vendor_id, rep_id, rep_level, recipe_id, hide_location, hide_type)
		local rep_vendor = private.vendor_list[vendor_id]

		if not CanDisplayFaction(rep_vendor.faction) then
			return entry_index
		end

		if not faction_strings then
			local rep_color = private.reputation_colors

			faction_strings = {
				[0] = SetTextColor(rep_color["neutral"], FACTION_NEUTRAL .. " : "),
				[1] = SetTextColor(rep_color["friendly"], BFAC["Friendly"] .. " : "),
				[2] = SetTextColor(rep_color["honored"], BFAC["Honored"] .. " : "),
				[3] = SetTextColor(rep_color["revered"], BFAC["Revered"] .. " : "),
				[4] = SetTextColor(rep_color["exalted"], BFAC["Exalted"] .. " : ")
			}
		end

		local name = ColorNameByFaction(rep_vendor.name, rep_vendor.faction)
		local t = AcquireTable()

		t.text = string.format("%s%s %s", PADDING, hide_type and "" or SetTextColor(CATEGORY_COLORS["reputation"], _G.REPUTATION)..":",
				       SetTextColor(CATEGORY_COLORS["repname"], private.reputation_list[rep_id].name))
		t.recipe_id = recipe_id
		t.npc_id = vendor_id

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		t = AcquireTable()
		t.text = PADDING .. PADDING .. faction_strings[rep_level] .. name
		t.recipe_id = recipe_id
		t.npc_id = vendor_id

		entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)

		local coord_text = ""

		if rep_vendor.coord_x ~= 0 and rep_vendor.coord_y ~= 0 then
			coord_text = SetTextColor(CATEGORY_COLORS["coords"], "(" .. rep_vendor.coord_x .. ", " .. rep_vendor.coord_y .. ")")
		end

		if coord_text == "" and hide_location then
			return entry_index
		end
		t = AcquireTable()
		t.text = string.format("%s%s%s%s %s", PADDING, PADDING, PADDING,
				       hide_location and "" or SetTextColor(CATEGORY_COLORS["location"], rep_vendor.location), coord_text)
		t.recipe_id = recipe_id
		t.npc_id = vendor_id

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandWorldDropData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local _, _, _, hex_color = GetItemQualityColor(private.recipe_list[recipe_id].quality)
		local drop_location = type(id_num) == "string" and BZ[id_num] or nil

		if drop_location then
			drop_location = string.format(": %s", SetTextColor(CATEGORY_COLORS["location"], drop_location))
		else
			drop_location = ""
		end
		local t = AcquireTable()

		t.text = string.format("%s%s%s|r%s", PADDING, hex_color, L["World Drop"], drop_location)
		t.recipe_id = recipe_id

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandCustomData(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
		local t = AcquireTable()

		t.text = PADDING .. SetTextColor(CATEGORY_COLORS["custom"], private.custom_list[id_num].name)
		t.recipe_id = recipe_id

		return ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
	end

	local function ExpandAcquireData(entry_index, entry_type, parent_entry, acquire_type, acquire_data, recipe_id, hide_location, hide_type)
		local obtain_filters = addon.db.profile.filters.obtain

		for id_num, info in pairs(acquire_data) do
			local func

			if acquire_type == A.TRAINER and obtain_filters.trainer then
				func = ExpandTrainerData
			elseif acquire_type == A.VENDOR and (obtain_filters.vendor or obtain_filters.pvp) then
				func = ExpandVendorData
			elseif acquire_type == A.MOB_DROP and (obtain_filters.mobdrop or obtain_filters.instance or obtain_filters.raid) then
				func = ExpandMobData
			elseif acquire_type == A.QUEST and obtain_filters.quest then
				func = ExpandQuestData
			elseif acquire_type == A.SEASONAL and obtain_filters.seasonal then
				func = ExpandSeasonalData
			elseif acquire_type == A.REPUTATION then
				for rep_level, level_info in pairs(info) do
					for vendor_id in pairs(level_info) do
						entry_index =  ExpandReputationData(entry_index, entry_type, parent_entry, vendor_id, id_num,
										    rep_level, recipe_id, hide_location, hide_type)
					end
				end
			elseif acquire_type == A.WORLD_DROP and obtain_filters.worlddrop then
				if not hide_type then
					func = ExpandWorldDropData
				end
			elseif acquire_type == A.CUSTOM then
				if not hide_type then
					func = ExpandCustomData
				end
				--@alpha@
			elseif acquire_type > A_MAX then
				local t = AcquireTable()

				t.text = "Unhandled Acquire Case - Type: " .. acquire_type
				t.recipe_id = recipe_id

				entry_index = ListFrame:InsertEntry(t, parent_entry, entry_index, entry_type, true)
				--@end-alpha@
			end

			if func then
				entry_index = func(entry_index, entry_type, parent_entry, id_num, recipe_id, hide_location, hide_type)
			end
		end	-- for
		return entry_index
	end

	-- This function is called when an un-expanded entry in the list has been clicked.
	function ListFrame:ExpandEntry(entry_index, expand_mode)
		local orig_index = entry_index
		local current_entry = self.entries[orig_index]
		local expand_all = expand_mode == "deep"
		local search_box = MainPanel.search_editbox
		local current_tab = MainPanel.tabs[MainPanel.current_tab]
		local prof_name = private.ordered_professions[MainPanel.profession]

		-- Entry_index is the position in self.entries that we want to expand. Since we are expanding the current entry, the return
		-- value should be the index of the next button after the expansion occurs
		entry_index = entry_index + 1

		current_tab:ModifyEntry(current_entry, true)

		-- This entry was generated using sorting based on Acquisition.
		if current_entry.acquire_id then
			local acquire_id = current_entry.acquire_id

			if current_entry.type == "header" then
				local recipe_list = private.acquire_list[acquire_id].recipes
				local sorted_recipes = addon.sorted_recipes

				private.SortRecipeList(recipe_list)

				for index = 1, #sorted_recipes do
					local spell_id = sorted_recipes[index]
					local recipe_entry = private.recipe_list[spell_id]

					if recipe_entry:HasState("VISIBLE") and search_box:MatchesRecipe(recipe_entry) then
						local t = AcquireTable()
						local expand = false
						local type = "subheader"

						if acquire_id == A.WORLD_DROP or acquire_id == A.CUSTOM then
							expand = true
							type = "entry"
						end
						local is_expanded = (current_tab[prof_name.." expanded"][spell_id]
								     and current_tab[prof_name.." expanded"][private.acquire_names[acquire_id]])

						t.text = recipe_entry:GetDisplayName()
						t.recipe_id = spell_id
						t.acquire_id = acquire_id

						entry_index = self:InsertEntry(t, current_entry, entry_index, type, expand or is_expanded,
									       expand_all or is_expanded)
					end
				end
			elseif current_entry.type == "subheader" then
				for acquire_type, acquire_data in pairs(private.recipe_list[current_entry.recipe_id].acquire_data) do
					if acquire_type == acquire_id then
						entry_index = ExpandAcquireData(entry_index, "subentry", current_entry, acquire_type, acquire_data,
										current_entry.recipe_id, false, true)
					end
				end
			end
			return entry_index
		end

		-- This entry was generated using sorting based on Location.
		if current_entry.location_id then
			local location_id = current_entry.location_id

			if current_entry.type == "header" then
				local recipe_list = private.location_list[location_id].recipes
				local sorted_recipes = addon.sorted_recipes

				private.SortRecipeList(recipe_list)

				for index = 1, #sorted_recipes do
					local spell_id = sorted_recipes[index]
					local recipe_entry = private.recipe_list[spell_id]

					if recipe_entry:HasState("VISIBLE") and search_box:MatchesRecipe(recipe_entry) then
						local expand = false
						local type = "subheader"
						local t = AcquireTable()

						-- Add World Drop entries as normal entries.
						if recipe_list[spell_id] == "world_drop" then
							expand = true
							type = "entry"
						end
						local is_expanded = (current_tab[prof_name.." expanded"][spell_id]
								     and current_tab[prof_name.." expanded"][location_id])

						t.text = recipe_entry:GetDisplayName()
						t.recipe_id = spell_id
						t.location_id = location_id

						entry_index = self:InsertEntry(t, current_entry, entry_index, type, expand or is_expanded,
									       expand_all or is_expanded)
					end
				end
			elseif current_entry.type == "subheader" then
				local recipe_entry = private.recipe_list[current_entry.recipe_id]

				-- World Drops are not handled here because they are of type "entry".
				for acquire_type, acquire_data in pairs(recipe_entry.acquire_data) do
					-- Only expand an acquisition entry if it is from this location.
					for id_num, info in pairs(acquire_data) do
						if acquire_type == A.TRAINER and private.trainer_list[id_num].location == location_id then
							entry_index = ExpandTrainerData(entry_index, "subentry", current_entry,
											id_num, current_entry.recipe_id, true)
						elseif acquire_type == A.VENDOR and private.vendor_list[id_num].location == location_id then
							entry_index = ExpandVendorData(entry_index, "subentry", current_entry,
										       id_num, current_entry.recipe_id, true)
						elseif acquire_type == A.MOB_DROP and private.mob_list[id_num].location == location_id then
							entry_index = ExpandMobData(entry_index, "subentry", current_entry,
										    id_num, current_entry.recipe_id, true)
						elseif acquire_type == A.QUEST and private.quest_list[id_num].location == location_id then
							entry_index = ExpandQuestData(entry_index, "subentry", current_entry,
										      id_num, current_entry.recipe_id, true)
						elseif acquire_type == A.SEASONAL and private.seasonal_list[id_num].location == location_id then
							-- Hide the acquire type for this - it will already show up in the location list as
							-- "World Events".
							entry_index = ExpandSeasonalData(entry_index, "subentry", current_entry,
											 id_num, current_entry.recipe_id, true, true)
						elseif acquire_type == A.CUSTOM and private.custom_list[id_num].location == location_id then
							entry_index = ExpandCustomData(entry_index, "subentry", current_entry,
										       id_num, current_entry.recipe_id, true, true)
						elseif acquire_type == A.REPUTATION then
							for rep_level, level_info in pairs(info) do
								for vendor_id in pairs(level_info) do
									if private.vendor_list[vendor_id].location == location_id then
										entry_index =  ExpandReputationData(entry_index, "subentry", current_entry,
														    vendor_id, id_num, rep_level, current_entry.recipe_id, true)
									end
								end
							end
						end
					end
				end
			end
			return entry_index
		end

		-- Normal entry - expand all acquire types.
		local recipe_id = self.entries[orig_index].recipe_id

		for acquire_type, acquire_data in pairs(private.recipe_list[recipe_id].acquire_data) do
			entry_index = ExpandAcquireData(entry_index, "entry", current_entry, acquire_type, acquire_data, recipe_id)
		end
		return entry_index
	end
end	-- InitializeListFrame()

-------------------------------------------------------------------------------
-- Tooltip functions and data.
-------------------------------------------------------------------------------
spell_tip = CreateFrame("GameTooltip", "AckisRecipeList_SpellTooltip", UIParent, "GameTooltipTemplate")

-- Font Objects needed for acquire_tip
local narrowFont
local normalFont

do
	-- Fallback in case the user doesn't have LSM-3.0 installed
	if not LibStub:GetLibrary("LibSharedMedia-3.0", true) then

		local locale = GetLocale()
		-- Fix for font issues on koKR
		if locale == "koKR" then
			narrowFont = "Fonts\\2002.TTF"
			normalFont = "Fonts\\2002.TTF"
		else
			narrowFont = "Fonts\\ARIALN.TTF"
			normalFont = "Fonts\\FRIZQT__.TTF"
		end
	else
		-- Register LSM 3.0
		local LSM3 = LibStub("LibSharedMedia-3.0")

		narrowFont = LSM3:Fetch(LSM3.MediaType.FONT, "Arial Narrow")
		normalFont = LSM3:Fetch(LSM3.MediaType.FONT, "Friz Quadrata TT")
	end
	local narrowFontObj = CreateFont(MODNAME.."narrowFontObj")
	local normalFontObj = CreateFont(MODNAME.."normalFontObj")

	-- I want to do a bit more comprehensive tooltip processing. Things like changing font sizes,
	-- adding padding to the left hand side, and using better color handling. So... this function
	-- will do that for me.
	local function ttAdd(
			leftPad,		-- number of times to pad two spaces on left side
			textSize,		-- add to or subtract from addon.db.profile.tooltip.acquire_fontsize to get fontsize
			narrow,			-- if 1, use ARIALN instead of FRITZQ
			str1,			-- left-hand string
			hexcolor1,		-- hex color code for left-hand side
			str2,			-- if present, this is the right-hand string
			hexcolor2)		-- if present, hex color code for right-hand side

		-- are we changing fontsize or narrow?
		local fontSize

		if narrow or textSize ~= 0 then
			local font = narrow and narrowFont or normalFont
			local fontObj = narrow and narrowFontObj or normalFontObj

			fontSize = addon.db.profile.tooltip.acquire_fontsize + textSize

			fontObj:SetFont(font, fontSize)
			acquire_tip:SetFont(fontObj)
		end

		-- Add in our left hand padding
		local loopPad = leftPad
		local leftStr = str1

		while loopPad > 0 do
			leftStr = "    " .. leftStr
			loopPad = loopPad - 1
		end
		-- Set maximum width to match fontSize to maintain uniform tooltip size. -Torhal
		local width = math.ceil(fontSize * 37.5)
		local line = acquire_tip:AddLine()

		if str2 then
			width = width / 2

			acquire_tip:SetCell(line, 1, "|cff"..hexcolor1..leftStr.."|r", "LEFT", nil, nil, 0, 0, width, width)
			acquire_tip:SetCell(line, 2, "|cff"..hexcolor2..str2.."|r", "RIGHT", nil, nil, 0, 0, width, width)
		else
			acquire_tip:SetCell(line, 1, "|cff"..hexcolor1..leftStr.."|r", nil, "LEFT", 2, nil, 0, 0, width, width)
		end
	end

	local function SetSpellTooltip(owner, loc, link)
		spell_tip:SetOwner(owner, "ANCHOR_NONE")
		spell_tip:ClearAllPoints()

		if loc == "Top" then
			spell_tip:SetPoint("BOTTOMLEFT", owner, "TOPLEFT")
		elseif loc == "Bottom" then
			spell_tip:SetPoint("TOPLEFT", owner, "BOTTOMLEFT")
		elseif loc == "Left" then
			spell_tip:SetPoint("TOPRIGHT", owner, "TOPLEFT")
		elseif loc == "Right" then
			spell_tip:SetPoint("TOPLEFT", owner, "TOPRIGHT")
		end

		-- Add TipTac Support
		if _G.TipTac and _G.TipTac.AddModifiedTip and not spell_tip.tiptac then
			_G.TipTac:AddModifiedTip(spell_tip)
			spell_tip.tiptac = true
		end

		-- Set the spell tooltip's scale, and copy its other values from GameTooltip so AddOns which modify it will work.
		spell_tip:SetBackdrop(GameTooltip:GetBackdrop())
		spell_tip:SetBackdropColor(GameTooltip:GetBackdropColor())
		spell_tip:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
		spell_tip:SetScale(addon.db.profile.tooltip.scale)
		spell_tip:SetClampedToScreen(true)
		spell_tip:SetHyperlink(link)
		spell_tip:Show()
	end

	local function GetTipFactionInfo(comp_faction)
		local display_tip
		local color

		if comp_faction == FACTION_NEUTRAL then
			color = private.reputation_colors["neutral"]
			display_tip = true
		elseif comp_faction == BFAC[Player.faction] then
			color = private.reputation_colors["exalted"]
			display_tip = true
		else
			color = private.reputation_colors["hated"]
			display_tip = addon.db.profile.filters.general.faction
		end
		return display_tip, color
	end

	-------------------------------------------------------------------------------
	-- Functions for adding individual acquire type data to the tooltip.
	-------------------------------------------------------------------------------
	local function Tooltip_AddTrainer(id_num, location, addline_func)
		local trainer = private.trainer_list[id_num]

		if location and trainer.location ~= location then
			return
		end
		local display_tip, name_color = GetTipFactionInfo(trainer.faction)

		if display_tip then
			local coord_text = ""

			if trainer.coord_x ~= 0 and trainer.coord_y ~= 0 then
				coord_text = "(" .. trainer.coord_x .. ", " .. trainer.coord_y .. ")"
			end
			addline_func(0, -2, false, L["Trainer"], CATEGORY_COLORS["trainer"], trainer.name, name_color)
			addline_func(1, -2, true, trainer.location, CATEGORY_COLORS["location"], coord_text, CATEGORY_COLORS["coords"])
		end
	end

	local function Tooltip_AddVendor(recipe_id, id_num, location, addline_func)
		local vendor = private.vendor_list[id_num]

		if location and vendor.location ~= location then
			return
		end
		local type_color = CATEGORY_COLORS["vendor"]
		local display_tip, name_color = GetTipFactionInfo(vendor.faction)

		if display_tip then
			local coord_text = ""

			if vendor.coord_x ~= 0 and vendor.coord_y ~= 0 then
				coord_text = "(" .. vendor.coord_x .. ", " .. vendor.coord_y .. ")"
			end
			addline_func(0, -1, false, L["Vendor"], type_color, vendor.name, name_color)
			addline_func(1, -2, true, vendor.location, CATEGORY_COLORS["location"], coord_text, CATEGORY_COLORS["coords"])

			local quantity = vendor.item_list[recipe_id]

			if type(quantity) == "number" then
				addline_func(2, -2, true, L["LIMITED_SUPPLY"], type_color, string.format("(%d)", quantity), BASIC_COLORS["white"])
			end
		end
	end

	local function Tooltip_AddMobDrop(id_num, location, addline_func)
		local mob = private.mob_list[id_num]

		if location and mob.location ~= location then
			return
		end
		local coord_text = ""

		if mob.coord_x ~= 0 and mob.coord_y ~= 0 then
			coord_text = "(" .. mob.coord_x .. ", " .. mob.coord_y .. ")"
		end
		addline_func(0, -1, false, L["Mob Drop"], CATEGORY_COLORS["mobdrop"], mob.name, private.reputation_colors["hostile"])
		addline_func(1, -2, true, mob.location, CATEGORY_COLORS["location"], coord_text, CATEGORY_COLORS["coords"])
	end

	local function Tooltip_AddQuest(id_num, location, addline_func)
		local quest = private.quest_list[id_num]

		if location and quest.location ~= location then
			return
		end
		local type_color = CATEGORY_COLORS["quest"]
		local display_tip, name_color = GetTipFactionInfo(quest.faction)

		if display_tip then
			local coord_text = ""

			if quest.coord_x ~= 0 and quest.coord_y ~= 0 then
				coord_text = "(" .. quest.coord_x .. ", " .. quest.coord_y .. ")"
			end
			addline_func(0, -1, false, L["Quest"], type_color, private.quest_names[id_num], name_color)
			addline_func(1, -2, true, quest.location, CATEGORY_COLORS["location"], coord_text, CATEGORY_COLORS["coords"])
		end
	end

	local function Tooltip_AddRepVendor(id_num, location, rep_level, vendor_id, addline_func)
		local rep_vendor = private.vendor_list[vendor_id]

		if location and rep_vendor.location ~= location then
			return
		end
		local display_tip, name_color = GetTipFactionInfo(rep_vendor.faction)

		if display_tip then
			local rep_color = private.reputation_colors
			local rep_str = ""
			local type_color

			if rep_level == 0 then
				rep_str = FACTION_NEUTRAL
				type_color = rep_color["neutral"]
			elseif rep_level == 1 then
				rep_str = BFAC["Friendly"]
				type_color = rep_color["friendly"]
			elseif rep_level == 2 then
				rep_str = BFAC["Honored"]
				type_color = rep_color["honored"]
			elseif rep_level == 3 then
				rep_str = BFAC["Revered"]
				type_color = rep_color["revered"]
			else
				rep_str = BFAC["Exalted"]
				type_color = rep_color["exalted"]
			end
			addline_func(0, -1, false, _G.REPUTATION, CATEGORY_COLORS["reputation"], private.reputation_list[id_num].name, CATEGORY_COLORS["repname"])
			addline_func(1, -2, false, rep_str, type_color, rep_vendor.name, name_color)

			local coord_text = ""

			if rep_vendor.coord_x ~= 0 and rep_vendor.coord_y ~= 0 then
				coord_text = "(" .. rep_vendor.coord_x .. ", " .. rep_vendor.coord_y .. ")"
			end
			addline_func(2, -2, true, rep_vendor.location, CATEGORY_COLORS["location"], coord_text, CATEGORY_COLORS["coords"])
		end
	end

	local function Tooltip_AddWorldDrop(recipe_id, id_num, location, addline_func)
		local drop_location = type(id_num) == "string" and BZ[id_num] or nil

		if location and drop_location ~= location then
			return
		end
		local item_id = private.spell_to_recipe_map[recipe_id]
		local _, item_level

		if item_id then
			_, _, _, item_level = GetItemInfo(item_id)
		end
		local _, _, _, quality_color = GetItemQualityColor(private.recipe_list[recipe_id].quality)
		local type_color = string.gsub(quality_color, "|cff", "")

		if type(id_num) == "string" then
			local location_text = item_level and string.format("%s (%d - %d)", drop_location, item_level - 5, item_level + 5) or drop_location

			addline_func(0, -1, false, L["World Drop"], type_color, location_text, CATEGORY_COLORS["location"])
		else
			local location_text = item_level and string.format("%s (%d - %d)", _G.UNKNOWN, item_level - 5, item_level + 5) or _G.UNKNOWN

			addline_func(0, -1, false, L["World Drop"], type_color, location_text, CATEGORY_COLORS["location"])
		end
	end

	-------------------------------------------------------------------------------
	-- Public API function for displaying a recipe's acquire data.
	-- * The addline_func paramater must be a function which accepts the same
	-- * arguments as ARL's ttAdd function.
	-------------------------------------------------------------------------------
	function addon:DisplayAcquireData(recipe_id, acquire_id, location, addline_func)
		local recipe = private.recipe_list[recipe_id]

		if not recipe then
			return
		end

		for acquire_type, acquire_data in pairs(recipe.acquire_data) do
			local can_display = (not acquire_id or acquire_type == acquire_id)

			if can_display then
				for id_num, info in pairs(acquire_data) do
					if acquire_type == A.TRAINER then
						Tooltip_AddTrainer(id_num, location, addline_func)
					elseif acquire_type == A.VENDOR then
						Tooltip_AddVendor(recipe_id, id_num, location, addline_func)
					elseif acquire_type == A.MOB_DROP then
						Tooltip_AddMobDrop(id_num, location, addline_func)
					elseif acquire_type == A.QUEST then
						Tooltip_AddQuest(id_num, location, addline_func)
					elseif acquire_type == A.SEASONAL then
						local color_1 = CATEGORY_COLORS["seasonal"]
						addline_func(0, -1, 0, private.acquire_names[A.SEASONAL], color_1, private.seasonal_list[id_num].name, color_1)
					elseif acquire_type == A.REPUTATION then
						for rep_level, level_info in pairs(info) do
							for vendor_id in pairs(level_info) do
								Tooltip_AddRepVendor(id_num, location, rep_level, vendor_id, addline_func)
							end
						end
					elseif acquire_type == A.WORLD_DROP then
						Tooltip_AddWorldDrop(recipe_id, id_num, location, addline_func)
					elseif acquire_type == A.CUSTOM then
						addline_func(0, -1, false, private.custom_list[id_num].name, CATEGORY_COLORS["custom"])
						--@alpha@
					elseif can_display then
						-- Unhandled
						addline_func(0, -1, 0, L["Unhandled Recipe"], BASIC_COLORS["normal"])
						--@end-alpha@
					end
				end	-- for id_num
			end	-- if can_display
		end	-- for acquire_type
	end

	-------------------------------------------------------------------------------
	-- Main tooltip-generating function.
	-------------------------------------------------------------------------------
	local BINDING_FLAGS = {
		[COMMON1.IBOE] = L["BOEFilter"],
		[COMMON1.IBOP] = L["BOPFilter"],
		[COMMON1.IBOA] = L["BOAFilter"],
		[COMMON1.RBOE] = L["RecipeBOEFilter"],
		[COMMON1.RBOP] = L["RecipeBOPFilter"],
		[COMMON1.RBOA] = L["RecipeBOAFilter"]
	}

	function ListItem_ShowTooltip(owner, list_entry)
		if not list_entry then
			return
		end
		local recipe_id = list_entry.recipe_id
		local recipe = private.recipe_list[recipe_id]

		if not recipe then
			return
		end
		local spell_tip_anchor = addon.db.profile.spelltooltiplocation
		local acquire_tip_anchor = addon.db.profile.acquiretooltiplocation
		local spell_link = GetSpellLink(recipe.spell_id)
		local MainPanel = addon.Frame

		if acquire_tip_anchor == _G.OFF then
			QTip:Release(acquire_tip)

			-- If we have the spell link tooltip, anchor it to MainPanel instead so it shows
			if spell_tip_anchor ~= _G.OFF and spell_link then
				SetSpellTooltip(MainPanel, spell_tip_anchor, spell_link)
			else
				spell_tip:Hide()
			end
			return
		end
		acquire_tip = QTip:Acquire(MODNAME.." Tooltip", 2, "LEFT", "LEFT")
		acquire_tip:ClearAllPoints()

		if acquire_tip_anchor == "Right" then
			acquire_tip:SetPoint("TOPLEFT", MainPanel, "TOPRIGHT", MainPanel.is_expanded and -90 or -35, 0)
		elseif acquire_tip_anchor == "Left" then
			acquire_tip:SetPoint("TOPRIGHT", MainPanel, "TOPLEFT")
		elseif acquire_tip_anchor == "Top" then
			acquire_tip:SetPoint("BOTTOMLEFT", MainPanel, "TOPLEFT")
		elseif acquire_tip_anchor == "Bottom" then
			acquire_tip:SetPoint("TOPLEFT", MainPanel, "BOTTOMLEFT", 0, 55)
		elseif acquire_tip_anchor == "Mouse" then
			local x, y = GetCursorPosition()
			local uiscale = UIParent:GetEffectiveScale()

			acquire_tip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / uiscale, y / uiscale)
		end
		acquire_tip:SetClampedToScreen(true)

		if _G.TipTac and _G.TipTac.AddModifiedTip then
			-- Pass true as second parameter because hooking OnHide causes C stack overflows -Torhal
			_G.TipTac:AddModifiedTip(acquire_tip, true)
		end
		local _, _, _, quality_color = GetItemQualityColor(recipe.quality)

		acquire_tip:Clear()
		acquire_tip:SetScale(addon.db.profile.tooltip.scale)
		acquire_tip:AddHeader()
		acquire_tip:SetCell(1, 1, quality_color..recipe.name, "CENTER", 2)

		-- check if the recipe is excluded
		if addon.db.profile.exclusionlist[recipe_id] then
			ttAdd(0, -1, true, L["RECIPE_EXCLUDED"], "ff0000")
		end

		-- Add in skill level requirement, colored correctly
		local color_1 = BASIC_COLORS["normal"]
		local color_2

		local skill_level = Player["ProfessionLevel"]
		local recipe_level = recipe.skill_level
		local optimal_level = recipe.optimal_level
		local medium_level = recipe.medium_level
		local easy_level = recipe.easy_level
		local trivial_level = recipe.trivial_level
		local difficulty = private.difficulty_colors

		if recipe_level > skill_level then
			color_2 = difficulty["impossible"]
		elseif skill_level >= trivial_level then
			color_2 = difficulty["trivial"]
		elseif skill_level >= easy_level then
			color_2 = difficulty["easy"]
		elseif skill_level >= medium_level then
			color_2 = difficulty["medium"]
		elseif skill_level >= optimal_level then
			color_2 = difficulty["optimal"]
		else
			color_2 = difficulty["trivial"]
		end
		ttAdd(0, -1, false, string.format("%s:", _G.SKILL_LEVEL), color_1, recipe.skill_level, color_2)

		-- Binding info
		acquire_tip:AddSeparator()
		color_1 = BASIC_COLORS["normal"]

		for flag, label in pairs(BINDING_FLAGS) do
			if _G.bit.band(recipe.flags.common1, flag) == flag then
				ttAdd(0, -1, true, label, color_1)
			end
		end
		acquire_tip:AddSeparator()

		if recipe.specialty then
			local spec = recipe.specialty
			local spec_name = GetSpellInfo(spec)
			local known = (spec == Player["Specialty"])

			ttAdd(0, -1, false, string.format(_G.ITEM_REQ_SKILL, spec_name), known and BASIC_COLORS["white"] or difficulty["impossible"])
			acquire_tip:AddSeparator()
		end

		ttAdd(0, -1, false, L["Obtained From"] .. " : ", BASIC_COLORS["normal"])

		local acquire_id = list_entry.acquire_id
		local location = list_entry.location_id

		addon:DisplayAcquireData(recipe_id, acquire_id, location, ttAdd)

		if not addon.db.profile.hide_tooltip_hint then
			-- Give the tooltip hint a unique color.
			color_1 = "c9c781"

			acquire_tip:AddSeparator()
			acquire_tip:AddSeparator()

			ttAdd(0, -1, 0, L["ALT_CLICK"], color_1)
			ttAdd(0, -1, 0, L["CTRL_CLICK"], color_1)
			ttAdd(0, -1, 0, L["SHIFT_CLICK"], color_1)

			if acquire_id ~= A.WORLD_DROP and acquire_id ~= A.CUSTOM and (_G.TomTom or _G.Cartographer_Waypoints) and (addon.db.profile.worldmap or addon.db.profile.minimap) then
				ttAdd(0, -1, 0, L["CTRL_SHIFT_CLICK"], color_1)
			end
		end
		acquire_tip:Show()

		-- If we have the spell link tooltip, link it to the acquire tooltip.
		if spell_tip_anchor ~= _G.OFF and spell_link then
			SetSpellTooltip(acquire_tip, spell_tip_anchor, spell_link)
		else
			spell_tip:Hide()
		end
	end
end	-- do
