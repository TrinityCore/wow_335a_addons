-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local table = _G.table
local string = _G.string

local pairs, ipairs = _G.pairs, _G.ipairs

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = LibStub

local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

-- Set up the private intra-file namespace.
local private	= select(2, ...)

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local ORDERED_PROFESSIONS	= private.ordered_professions

local A = private.acquire_types

-------------------------------------------------------------------------------
-- Upvalues
-------------------------------------------------------------------------------
local AcquireTable = private.AcquireTable
local SetTextColor = private.SetTextColor

function private.InitializeTabs()
	local MainPanel = addon.Frame
	local ListFrame = MainPanel.list_frame

	local function Tab_Enable(self)
		self.left:ClearAllPoints()
		self.left:SetPoint("BOTTOMLEFT")
		self.left:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-ActiveTab")
		self.middle:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-ActiveTab")
		self.right:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-ActiveTab")
		self:Disable()
	end

	local function Tab_Disable(self)
		self.left:ClearAllPoints()
		self.left:SetPoint("TOPLEFT")
		self.left:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-InactiveTab")
		self.middle:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-InactiveTab")
		self.right:SetTexture("Interface\\PAPERDOLLINFOFRAME\\UI-Character-InactiveTab")
		self:Enable()
	end

	local function Tab_SetText(self, ...)
		local text = self.Real_SetText(self, ...)
		self:SetWidth(40 + self:GetFontString():GetStringWidth())

		return ...
	end

	local function Tab_OnClick(self, button, down)
		local id_num = self:GetID()

		for index in ipairs(MainPanel.tabs) do
			local tab = MainPanel.tabs[index]

			if index == id_num then
				self:ToFront()
			else
				tab:ToBack()
			end
		end
		addon.db.profile.current_tab = id_num
		MainPanel.current_tab = id_num

		ListFrame:Update(nil, false)
		PlaySound("igCharacterInfoTab")
	end

	-- Expands or collapses a list entry in the current active tab.
	local function Tab_ModifyEntry(self, entry, expanded)
		local member = ORDERED_PROFESSIONS[MainPanel.profession] .. " expanded"

		if entry.acquire_id then
			self[member][private.acquire_names[entry.acquire_id]] = expanded or nil
		end

		if entry.location_id then
			self[member][entry.location_id] = expanded or nil
		end

		if entry.recipe_id then
			self[member][entry.recipe_id] = expanded or nil
		end
	end

	local function CreateTab(id_num, text, ...)
		local tab = CreateFrame("Button", nil, MainPanel)

		tab:SetID(id_num)
		tab:SetHeight(32)
		tab:SetPoint(...)
		tab:SetFrameLevel(tab:GetFrameLevel() + 4)

		tab.left = tab:CreateTexture(nil, "BORDER")
		tab.left:SetWidth(20)
		tab.left:SetHeight(32)
		tab.left:SetTexCoord(0, 0.15625, 0, 1)

		tab.right = tab:CreateTexture(nil, "BORDER")
		tab.right:SetWidth(20)
		tab.right:SetHeight(32)
		tab.right:SetPoint("TOP", tab.left)
		tab.right:SetPoint("RIGHT", tab)
		tab.right:SetTexCoord(0.84375, 1, 0, 1)

		tab.middle = tab:CreateTexture(nil, "BORDER")
		tab.middle:SetHeight(32)
		tab.middle:SetPoint("LEFT", tab.left, "RIGHT")
		tab.middle:SetPoint("RIGHT", tab.right, "LEFT")
		tab.middle:SetTexCoord(0.15625, 0.84375, 0, 1)

		tab:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")

		local tab_highlight = tab:GetHighlightTexture()
		tab_highlight:ClearAllPoints()
		tab_highlight:SetPoint("TOPLEFT", tab, "TOPLEFT", 8, 1)
		tab_highlight:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -8, 1)

		tab:SetDisabledFontObject(GameFontHighlightSmall)
		tab:SetHighlightFontObject(GameFontHighlightSmall)
		tab:SetNormalFontObject(GameFontNormalSmall)
		tab.Real_SetText = tab.SetText

		tab.SetText = Tab_SetText
		tab:SetText(text)

		tab.ToFront = Tab_Enable
		tab.ToBack = Tab_Disable
		tab.ModifyEntry = Tab_ModifyEntry

		tab:ToBack()

		tab:SetScript("OnClick", Tab_OnClick)

		return tab
	end
	local AcquisitionTab = CreateTab(1, L["Acquisition"], "TOPLEFT", MainPanel, "BOTTOMLEFT", 4, 81)
	local LocationTab = CreateTab(2, L["Location"], "LEFT", AcquisitionTab, "RIGHT", -14, 0)
	local RecipesTab = CreateTab(3, _G.TRADESKILL_SERVICE_LEARN, "LEFT", LocationTab, "RIGHT", -14, 0)

	-- Used for Location and Acquisition sort - since many recipes have multiple locations/acquire types it is
	-- necessary to ensure each is counted only once.
	local recipe_registry = {}

	local function FactionTally(source_data, unit_list, location)
		local good, bad = 0, 0

		for id_num in pairs(source_data) do
			local unit_faction = unit_list[id_num].faction

			if not location or unit_list[id_num].location == location then
				if not unit_faction or unit_faction == BFAC[private.Player.faction] or unit_faction == BFAC["Neutral"] then
					good = good + 1
				else
					bad = bad + 1
				end
			end
		end
		return good, bad
	end

	-------------------------------------------------------------------------------
	-- Variables used to hold tables for sorting the various tabs:
	-- The tables are only sorted once, upon creation.
	-------------------------------------------------------------------------------
	local sorted_acquires
	local sorted_locations

	function AcquisitionTab:Initialize(expand_mode)
		local search_box = MainPanel.search_editbox

		local recipe_count = 0
		local insert_index = 1

		table.wipe(recipe_registry)

		if not sorted_acquires then
			-- Sorting function: Only used once and then thrown away.
			local function Sort_Acquisition(a, b)
				local acquire_list = private.acquire_list
				local acquire_a = acquire_list[a]
				local acquire_b = acquire_list[b]

				return acquire_a.name < acquire_b.name
			end
			sorted_acquires = {}

			for acquire_name in pairs(private.acquire_list) do
				table.insert(sorted_acquires, acquire_name)
			end
			table.sort(sorted_acquires, Sort_Acquisition)
		end
		local prof_name = ORDERED_PROFESSIONS[MainPanel.profession]

		self[prof_name.." expanded"] = self[prof_name.." expanded"] or {}

		for index = 1, #sorted_acquires do
			local acquire_type = sorted_acquires[index]
			local count = 0

			-- Check to see if any recipes for this acquire type will be shown - otherwise, don't show the type in the list.
			for spell_id, affiliation in pairs(private.acquire_list[acquire_type].recipes) do
				local recipe = private.recipe_list[spell_id]

				if recipe:HasState("VISIBLE") and search_box:MatchesRecipe(recipe) then
					count = count + 1

					if not recipe_registry[recipe] then
						recipe_registry[recipe] = true
						recipe_count = recipe_count + 1
					end
				else
					self[prof_name.." expanded"][spell_id] = nil
				end
			end

			if count > 0 then
				local t = AcquireTable()

				local acquire_str = string.gsub(private.acquire_strings[acquire_type]:lower(), "_", "")
				local color_code = private.category_colors[acquire_str] or "ffffff"
				local is_expanded = self[prof_name.." expanded"][private.acquire_names[acquire_type]]

				t.text = string.format("%s (%d)", SetTextColor(color_code, private.acquire_names[acquire_type]), count)
				t.acquire_id = acquire_type

				insert_index = ListFrame:InsertEntry(t, nil, insert_index, "header", is_expanded or expand_mode, is_expanded or expand_mode)
			else
				self[prof_name.." expanded"][private.acquire_names[acquire_type]] = nil
			end
		end
		return recipe_count
	end

	function LocationTab:Initialize(expand_mode)
		local search_box = MainPanel.search_editbox

		local recipe_count = 0
		local insert_index = 1

		table.wipe(recipe_registry)

		if not sorted_locations then
			-- Sorting function: Only used once and then thrown away.
			local function Sort_Location(a, b)
				local location_list = private.location_list
				local loc_a = location_list[a]
				local loc_b = location_list[b]

				return loc_a.name < loc_b.name
			end
			sorted_locations = {}

			for loc_name in pairs(private.location_list) do
				table.insert(sorted_locations, loc_name)
			end
			table.sort(sorted_locations, Sort_Location)
		end
		local prof_name = ORDERED_PROFESSIONS[MainPanel.profession]

		self[prof_name.." expanded"] = self[prof_name.." expanded"] or {}

		for index = 1, #sorted_locations do
			local loc_name = sorted_locations[index]
			local count = 0

			-- Check to see if any recipes for this location will be shown - otherwise, don't show the location in the list.
			for spell_id, affiliation in pairs(private.location_list[loc_name].recipes) do
				local recipe = private.recipe_list[spell_id]

				if recipe:HasState("VISIBLE") and search_box:MatchesRecipe(recipe) then
					local trainer_data = recipe.acquire_data[A.TRAINER]
					local good_count, bad_count = 0, 0
					local fac_toggle = addon.db.profile.filters.general.faction

					if not fac_toggle then
						if trainer_data then
							local good, bad = FactionTally(trainer_data, private.trainer_list, loc_name)

							if good == 0 and bad > 0 then
								bad_count = bad_count + 1
							else
								good_count = good_count + 1
							end
						end
						local vendor_data = recipe.acquire_data[A.VENDOR]

						if vendor_data then
							local good, bad = FactionTally(vendor_data, private.vendor_list, loc_name)

							if good == 0 and bad > 0 then
								bad_count = bad_count + 1
							else
								good_count = good_count + 1
							end
						end
						local quest_data = recipe.acquire_data[A.QUEST]

						if quest_data then
							local good, bad = FactionTally(quest_data, private.quest_list, loc_name)

							if good == 0 and bad > 0 then
								bad_count = bad_count + 1
							else
								good_count = good_count + 1
							end
						end
					end

					if fac_toggle or not (good_count == 0 and bad_count > 0) then
						count = count + 1

						if not recipe_registry[recipe] then
							recipe_registry[recipe] = true
							recipe_count = recipe_count + 1
						end
					end
				else
					self[prof_name.." expanded"][spell_id] = nil
				end
			end

			if count > 0 then
				local t = AcquireTable()

				local is_expanded = self[prof_name.." expanded"][loc_name]

				t.text = string.format("%s (%d)", SetTextColor(private.category_colors["location"], loc_name), count)
				t.location_id = loc_name

				insert_index = ListFrame:InsertEntry(t, nil, insert_index, "header", is_expanded or expand_mode, is_expanded or expand_mode)
			else
				self[prof_name.." expanded"][loc_name] = nil
			end
		end
		return recipe_count
	end

	function RecipesTab:Initialize(expand_mode)
		local sorted_recipes = addon.sorted_recipes
		local recipe_list = private.recipe_list
		local search_box = MainPanel.search_editbox

		local recipe_count = 0
		local insert_index = 1
		local prof_name = ORDERED_PROFESSIONS[MainPanel.profession]

		self[prof_name.." expanded"] = self[prof_name.." expanded"] or {}

		private.SortRecipeList(recipe_list)

		for i = 1, #sorted_recipes do
			local recipe_index = sorted_recipes[i]
			local recipe = recipe_list[recipe_index]

			if recipe:HasState("VISIBLE") and search_box:MatchesRecipe(recipe) then
				local t = AcquireTable()

				local is_expanded = self[prof_name.." expanded"][recipe_index]

				t.text = recipe:GetDisplayName()
				t.recipe_id = recipe_index

				recipe_count = recipe_count + 1

				insert_index = ListFrame:InsertEntry(t, nil, insert_index, "header", is_expanded or expand_mode, is_expanded or expand_mode)
			else
				self[prof_name.." expanded"][recipe_index] = nil
			end
		end
		return recipe_count
	end

	MainPanel.tabs = {
		AcquisitionTab,
		LocationTab,
		RecipesTab,
	}

	private.InitializeTabs = nil
end
