-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local string = _G.string

local table = _G.table

local pairs = _G.pairs

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = LibStub

local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local QTip	= LibStub("LibQTip-1.0")

-- Set up the private intra-file namespace.
local private	= select(2, ...)

local Player	= private.Player

-------------------------------------------------------------------------------
-- Upvalues
-------------------------------------------------------------------------------
local SetTextColor = private.SetTextColor
local GenericCreateButton = private.GenericCreateButton
local SetTooltipScripts = private.SetTooltipScripts

local A = private.acquire_types

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local FILTERMENU_HEIGHT		= 312
local FILTERMENU_WIDTH		= 210

local EXPANSION_FRAMES = {
	["expansion0"]	= true,
	["expansion1"]	= true,
	["expansion2"]	= true,
}

local CATEGORY_TOOLTIP = {
	["general"]	= L["FILTERING_GENERAL_DESC"],
	["obtain"]	= L["FILTERING_OBTAIN_DESC"],
	["binding"]	= L["FILTERING_BINDING_DESC"],
	["item"]	= L["FILTERING_ITEM_DESC"],
	["quality"]	= L["FILTERING_QUALITY_DESC"],
	["player"]	= L["FILTERING_PLAYERTYPE_DESC"],
	["rep"]		= L["FILTERING_REP_DESC"],
	["misc"]	= L["FILTERING_MISC_DESC"]
}

-------------------------------------------------------------------------------
-- Function to create and initialize a check-button with the given values.
-- Used in all of the sub-menus of MainPanel.filter_menu
-------------------------------------------------------------------------------
local GenerateCheckBoxes
do
	local function CheckButton_OnClick(self, button, down)
		local script_val = self.script_val
		local MainPanel = addon.Frame

		MainPanel.filter_menu.value_map[script_val].svroot[script_val] = MainPanel.filter_menu.value_map[script_val].cb:GetChecked() and true or false
		MainPanel:UpdateTitle()
		MainPanel.list_frame:Update(nil, false)
	end

	local function CreateCheckButton(parent, ttText, scriptVal, row, col)
		-- set the position of the new checkbox
		local xPos = 2 + ((col - 1) * 175)
		local yPos = -3 - ((row - 1) * 17)

		local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
		check:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, yPos)
		check:SetHeight(24)
		check:SetWidth(24)

		check.text = check:CreateFontString(nil, "OVERLAY", "QuestFontNormalSmall")
		check.text:SetPoint("LEFT", check, "RIGHT", 0, 0)

		check.script_val = scriptVal

		check:SetScript("OnClick", CheckButton_OnClick)

		SetTooltipScripts(check, ttText, 1)

		return check
	end

	function GenerateCheckBoxes(parent, source)
		for section, data in pairs(source) do
			parent[section] = CreateCheckButton(parent, data.tt, section, data.row, data.col)
			parent[section].text:SetText(data.text)
		end
	end
end	-- do

-------------------------------------------------------------------------------
-- Functions for initializing specific filter menu panels.
-------------------------------------------------------------------------------
local function InitializeMenu_General()
	local MainPanel = addon.Frame
	local FilterPanel = MainPanel.filter_menu

end

-- local MENU_CONSTRUCTORS = {
-- 	["general"]	= InitializeMenu_General,
-- 	["obtain"]	= InitializeMenu_Obtain,
-- 	["binding"]	= InitializeMenu_Binding,
-- 	["item"]	= InitializeMenu_Item,
-- 	["quality"]	= InitializeMenu_Quality,
-- 	["player"]	= InitializeMenu_Player,
-- 	["rep"]		= InitializeMenu_Reputation,
-- 	["misc"]	= InitializeMenu_Miscellaneous,
-- }

-- function InitializeFilterMenu(category)
-- 	local init_func = MENU_CONSTRUCTORS[category]

-- 	if init_func then
-- 		init_func()
-- 	end
-- end

-- Set all the current options in the filter menu to make sure they are consistent with the SV options.
local function UpdateFilterMarks()
	for filter, info in pairs(addon.Frame.filter_menu.value_map) do
		if info.svroot then
			info.cb:SetChecked(info.svroot[filter])
		end
	end
end

function private.InitializeFilterPanel()
	local MainPanel = addon.Frame

	-------------------------------------------------------------------------------
	-- The filter_reset button
	-------------------------------------------------------------------------------
	local filter_reset = GenericCreateButton(nil, MainPanel, 22, 78, "GameFontNormalSmall", _G.RESET, "CENTER", L["RESET_DESC"], 1)
	filter_reset:SetPoint("BOTTOMRIGHT", MainPanel, "BOTTOMRIGHT", -95, 80)
	filter_reset:Hide()

	MainPanel.filter_reset = filter_reset

	do
		local function recursiveReset(t)
			-- Thanks to Antiarc for this code
			for k, v in pairs(t) do
				if _G.type(v) == "table" then
					recursiveReset(v)
				else
					t[k] = true
				end
			end
		end

		filter_reset:SetScript("OnClick",
				       function(self, button, down)
					       local filterdb = addon.db.profile.filters

					       -- Reset all filters to true.
					       recursiveReset(addon.db.profile.filters)

					       -- Reset specific filters to false.
					       filterdb.general.specialty = false
					       filterdb.general.known = false
					       filterdb.general.retired = false

					       -- Reset all classes to false.
					       for class in pairs(filterdb.classes) do
						       filterdb.classes[class] = false
					       end
					       -- Set your own class to true.
					       filterdb.classes[string.lower(Player["Class"])] = true

					       if MainPanel:IsVisible() then
						       MainPanel:UpdateTitle()
						       UpdateFilterMarks()
						       MainPanel.list_frame:Update(nil, false)
					       end
				       end)
	end	-- do

	-------------------------------------------------------------------------------
	-- This manages the filter menu panel, as well as checking or unchecking the
	-- buttons that got us here in the first place
	-------------------------------------------------------------------------------
	local function ToggleFilterMenu(panel)
		local rep_menu = MainPanel.filter_menu.rep
		local ChangeFilters = false

		-- Make sure the expansion frames and toggle buttons are hidden/unchecked.
		for expansion in pairs(EXPANSION_FRAMES) do
			rep_menu[expansion]:Hide()
			rep_menu["toggle_" .. expansion]:SetChecked(false)
		end

		local toggle = "menu_toggle_" .. panel

		if not MainPanel[toggle]:GetChecked() then
			local panel_menu = MainPanel.filter_menu[panel]

			-- Display the selected filter_menu category frame
			MainPanel[toggle]:SetChecked(true)

			-- if not panel_menu then
			-- 	InitializeFilterMenu(panel)
			-- else
				panel_menu:Show()
			-- end

			-- Hide all of the other filter_menu category frames, and un-check them as well.
			for category in pairs(MainPanel.filter_menu) do
				if category ~= panel and CATEGORY_TOOLTIP[category] then
					local tog = "menu_toggle_" .. category

					MainPanel[tog]:SetChecked(false)
					MainPanel.filter_menu[category]:Hide()
				end
			end
			ChangeFilters = true
		else
			MainPanel[toggle]:SetChecked(false)
			ChangeFilters = false
		end

		if ChangeFilters then
			-- Change the filters to the current panel
			MainPanel.filter_menu:Show()
		else
			MainPanel.filter_menu:Hide()
		end
	end

	local function CreateFilterMenuButton(button_texture, category)
		local button_size = 22
		local cButton = CreateFrame("CheckButton", nil, MainPanel)

		cButton:SetWidth(button_size)
		cButton:SetHeight(button_size)
		cButton:SetScript("OnClick",
				  function(self, button, down)
					  -- The button must be unchecked for ToggleFilterMenu() to work correctly.
					  cButton:SetChecked(false)
					  ToggleFilterMenu(category)
				  end)

		local bgTex = cButton:CreateTexture(nil, "BACKGROUND")
		bgTex:SetTexture("Interface/SpellBook/UI-Spellbook-SpellBackground")
		bgTex:SetHeight(button_size + 6)
		bgTex:SetWidth(button_size + 4)
		bgTex:SetTexCoord(0, (43/64), 0, (43/64))
		bgTex:SetPoint("CENTER", cButton, "CENTER", 0, 0)

		local iconTex = cButton:CreateTexture(nil, "BORDER")
		iconTex:SetTexture("Interface/Icons/" .. button_texture)
		iconTex:SetAllPoints(cButton)

		local pushedTexture = cButton:CreateTexture(nil, "ARTWORK")
		pushedTexture:SetTexture("Interface/Buttons/UI-Quickslot-Depress")
		pushedTexture:SetAllPoints(cButton)
		cButton:SetPushedTexture(pushedTexture)

		local highlightTexture = cButton:CreateTexture()
		highlightTexture:SetTexture("Interface/Buttons/ButtonHilight-Square")
		highlightTexture:SetAllPoints(cButton)
		highlightTexture:SetBlendMode("ADD")
		cButton:SetHighlightTexture(highlightTexture)

		local checkedTexture = cButton:CreateTexture()
		checkedTexture:SetTexture("Interface/Buttons/CheckButtonHilight")
		checkedTexture:SetAllPoints(cButton)
		checkedTexture:SetBlendMode("ADD")
		cButton:SetCheckedTexture(checkedTexture)

		-- And throw up a tooltip
		SetTooltipScripts(cButton, CATEGORY_TOOLTIP[category])
		cButton:Hide()

		return cButton
	end

	-------------------------------------------------------------------------------
	-- Create the seven buttons for opening/closing the filter menus
	-------------------------------------------------------------------------------
	local general = CreateFilterMenuButton("INV_Misc_Note_06", "general")
	general:SetPoint("LEFT", MainPanel.filter_toggle, "RIGHT", 3, 0)

	local obtain = CreateFilterMenuButton("INV_Misc_Bag_07", "obtain")
	obtain:SetPoint("LEFT", general, "RIGHT", 15, 0)

	local binding = CreateFilterMenuButton("INV_Belt_20", "binding")
	binding:SetPoint("LEFT", obtain, "RIGHT", 15, 0)

	local item = CreateFilterMenuButton("INV_Misc_EngGizmos_19", "item")
	item:SetPoint("LEFT", binding, "RIGHT", 15, 0)

	local quality = CreateFilterMenuButton("INV_Enchant_VoidCrystal", "quality")
	quality:SetPoint("LEFT", item, "RIGHT", 15, 0)

	local player = CreateFilterMenuButton("INV_Misc_GroupLooking", "player")
	player:SetPoint("LEFT", quality, "RIGHT", 15, 0)

	local rep = CreateFilterMenuButton("Achievement_Reputation_01", "rep")
	rep:SetPoint("LEFT", player, "RIGHT", 15, 0)

	local misc = CreateFilterMenuButton("Trade_Engineering", "misc")
	misc:SetPoint("LEFT", rep, "RIGHT", 15, 0)

	-- Assign the buttons as members.
	MainPanel.menu_toggle_general = general
	MainPanel.menu_toggle_obtain = obtain
	MainPanel.menu_toggle_binding = binding
	MainPanel.menu_toggle_item = item
	MainPanel.menu_toggle_quality = quality
	MainPanel.menu_toggle_player = player
	MainPanel.menu_toggle_rep = rep
	MainPanel.menu_toggle_misc = misc

	-------------------------------------------------------------------------------
	-- Main filter_menu frame.
	-------------------------------------------------------------------------------
	local FilterPanel = CreateFrame("Frame", nil, MainPanel)
	FilterPanel:SetWidth(300)
	FilterPanel:SetHeight(FILTERMENU_HEIGHT)
	FilterPanel:SetFrameStrata("MEDIUM")
	FilterPanel:SetPoint("TOPRIGHT", MainPanel, "TOPRIGHT", -135, -60)
	FilterPanel:EnableMouse(true)
	FilterPanel:EnableKeyboard(true)
	FilterPanel:SetMovable(false)
	FilterPanel:SetHitRectInsets(5, 5, 5, 5)
	FilterPanel:Hide()

	FilterPanel:SetScript("OnShow", UpdateFilterMarks)

	FilterPanel.value_map = {}

	function FilterPanel:CreateSubMenu(name)
		local submenu = CreateFrame("Frame", nil, self)

		submenu:SetWidth(FILTERMENU_WIDTH)
		submenu:SetHeight(FILTERMENU_HEIGHT)
		submenu:EnableMouse(true)
		submenu:EnableKeyboard(true)
		submenu:SetMovable(false)
		submenu:SetPoint("TOPLEFT", self, "TOPLEFT", 17, -16)
		submenu:Hide()

		self[name] = submenu
		return submenu
	end
	MainPanel.filter_menu = FilterPanel

	-------------------------------------------------------------------------------
	-- Create FilterPanel.general, and set its scripts.
	-------------------------------------------------------------------------------
	local general_frame = FilterPanel:CreateSubMenu("general")

	-------------------------------------------------------------------------------
	-- Create the general CheckButtons.
	-------------------------------------------------------------------------------
	local general_buttons = {
		["specialty"]	= { tt = L["SPECIALTY_DESC"],	text = L["Specialties"],	row = 1, col = 1 },
		["skill"]	= { tt = L["SKILL_DESC"],	text = _G.SKILL,		row = 1, col = 2 },
		["faction"]	= { tt = L["FACTION_DESC"],	text = _G.FACTION,		row = 2, col = 1 },
		["known"]	= { tt = L["KNOWN_DESC"],	text = L["Show Known"],		row = 2, col = 2 },
		["unknown"]	= { tt = L["UNKNOWN_DESC"],	text = _G.UNKNOWN,		row = 3, col = 1 },
		["retired"]	= { tt = L["RETIRED_DESC"],	text = L["Retired"],		row = 3, col = 2 },
	}
	GenerateCheckBoxes(general_frame, general_buttons)
	general_buttons = nil

	-------------------------------------------------------------------------------
	-- Create the Class toggle and CheckButtons.
	-------------------------------------------------------------------------------
	local class_toggle = GenericCreateButton(nil, general_frame, 20, 105, "GameFontHighlight", L["Classes"] .. ":", "LEFT", L["CLASS_TEXT_DESC"], 0)
	class_toggle:SetPoint("TOPLEFT", FilterPanel.general.unknown, "BOTTOMLEFT", -4, -10)
	class_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
	class_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	class_toggle:SetScript("OnClick",
			       function(self, button)
				       local classes = addon.db.profile.filters.classes
				       local toggle = (button == "LeftButton") and true or false

				       for class in pairs(classes) do
					       classes[class] = toggle
					       general_frame[class]:SetChecked(toggle)
				       end

				       if toggle == false then
					       local class = string.lower(Player["Class"])
					       classes[class] = true
					       general_frame[class]:SetChecked(true)
				       end
				       MainPanel:UpdateTitle()
				       MainPanel.list_frame:Update(nil, false)
			       end)

	general_frame.class_toggle = class_toggle

	local class_buttons = {
		["deathknight"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"],	row = 6,  col = 1 },
		["druid"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["DRUID"],		row = 6,  col = 2 },
		["hunter"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["HUNTER"],		row = 7,  col = 1 },
		["mage"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["MAGE"],		row = 7,  col = 2 },
		["paladin"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["PALADIN"],		row = 8,  col = 1 },
		["priest"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["PRIEST"],		row = 8,  col = 2 },
		["rogue"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["ROGUE"],		row = 9,  col = 1 },
		["shaman"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"],		row = 9,  col = 2 },
		["warlock"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["WARLOCK"],		row = 10, col = 1 },
		["warrior"]	= { tt = L["CLASS_DESC"],	text = LOCALIZED_CLASS_NAMES_MALE["WARRIOR"],		row = 10, col = 2 },
	}
	GenerateCheckBoxes(general_frame, class_buttons)
	class_buttons = nil

	-------------------------------------------------------------------------------
	-- Create FilterPanel.obtain, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local obtain_frame = FilterPanel:CreateSubMenu("obtain")

		-------------------------------------------------------------------------------
		-- Create the CheckButtons
		-------------------------------------------------------------------------------
		local obtain_buttons = {
			["instance"]	= { tt = L["INSTANCE_DESC"],		text = _G.INSTANCE,				row = 1, col = 1 },
			["raid"]	= { tt = L["RAID_DESC"],		text = _G.RAID,					row = 1, col = 2 },
			["quest"]	= { tt = L["QUEST_DESC"],		text = L["Quest"],				row = 2, col = 1 },
			["seasonal"]	= { tt = L["SEASONAL_DESC"],		text = private.acquire_names[A.SEASONAL],	row = 2, col = 2 },
			["trainer"]	= { tt = L["TRAINER_DESC"],		text = L["Trainer"],				row = 3, col = 1 },
			["vendor"]	= { tt = L["VENDOR_DESC"],		text = L["Vendor"],				row = 3, col = 2 },
			["pvp"]		= { tt = L["PVP_DESC"],			text = _G.PVP,					row = 4, col = 1 },
			["discovery"]	= { tt = L["DISCOVERY_DESC"],		text = L["Discovery"],				row = 4, col = 2 },
			["worlddrop"]	= { tt = L["WORLD_DROP_DESC"],		text = L["World Drop"],				row = 5, col = 1 },
			["mobdrop"]	= { tt = L["MOB_DROP_DESC"],		text = L["Mob Drop"],				row = 5, col = 2 },
			["expansion0"]	= { tt = L["ORIGINAL_WOW_DESC"],	text = _G.EXPANSION_NAME0,			row = 7, col = 1 },
			["expansion1"]	= { tt = L["BC_WOW_DESC"],		text = _G.EXPANSION_NAME1,			row = 8, col = 1 },
			["expansion2"]	= { tt = L["LK_WOW_DESC"],		text = _G.EXPANSION_NAME2,			row = 9, col = 1 },
		}
		GenerateCheckBoxes(obtain_frame, obtain_buttons)
		obtain_buttons = nil
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.binding, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local binding_frame = FilterPanel:CreateSubMenu("binding")

		-------------------------------------------------------------------------------
		-- Create the CheckButtons
		-------------------------------------------------------------------------------
		local binding_buttons = {
			["itemboe"]	= { tt = L["BOE_DESC"],		text = L["BOEFilter"],		row = 1, col = 1 },
			["itembop"]	= { tt = L["BOP_DESC"],		text = L["BOPFilter"],		row = 2, col = 1 },
			["recipeboe"]	= { tt = L["RECIPE_BOE_DESC"],	text = L["RecipeBOEFilter"],	row = 3, col = 1 },
			["recipebop"]	= { tt = L["RECIPE_BOP_DESC"],	text = L["RecipeBOPFilter"],	row = 4, col = 1 },
		}
		GenerateCheckBoxes(binding_frame, binding_buttons)
		binding_buttons = nil
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.item, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local item_frame = FilterPanel:CreateSubMenu("item")

		-------------------------------------------------------------------------------
		-- Create the Armor toggle and CheckButtons
		-------------------------------------------------------------------------------
		local armor_toggle = GenericCreateButton(nil, item_frame, 20, 105, "GameFontHighlight", _G.ARMOR .. ":", "LEFT", L["ARMOR_TEXT_DESC"], 0)
		armor_toggle:SetPoint("TOPLEFT", item_frame, "TOPLEFT", -2, -4)
		armor_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		armor_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		armor_toggle:SetScript("OnClick",
				       function(self, button)
					       local armors = addon.db.profile.filters.item.armor
					       local toggle = (button == "LeftButton") and true or false

					       for armor in pairs(armors) do
						       armors[armor] = toggle
						       item_frame[armor]:SetChecked(toggle)
					       end
					       MainPanel:UpdateTitle()
					       MainPanel.list_frame:Update(nil, false)
				       end)

		item_frame.armor_toggle = armor_toggle

		local armor_buttons = {
			["cloth"]	= { tt = L["CLOTH_DESC"],	text = L["Cloth"],	row = 2, col = 1 },
			["leather"]	= { tt = L["LEATHER_DESC"],	text = L["Leather"],	row = 2, col = 2 },
			["mail"]	= { tt = L["MAIL_DESC"],	text = L["Mail"],	row = 3, col = 1 },
			["plate"]	= { tt = L["PLATE_DESC"],	text = L["Plate"],	row = 3, col = 2 },
			["cloak"]	= { tt = L["CLOAK_DESC"],	text = L["Cloak"],	row = 4, col = 1 },
			["necklace"]	= { tt = L["NECKLACE_DESC"],	text = L["Necklace"],	row = 4, col = 2 },
			["ring"]	= { tt = L["RING_DESC"],	text = L["Ring"],	row = 5, col = 1 },
			["trinket"]	= { tt = L["TRINKET_DESC"],	text = L["Trinket"],	row = 5, col = 2 },
			["shield"]	= { tt = L["SHIELD_DESC"],	text = L["Shield"],	row = 6, col = 1 },
		}
		GenerateCheckBoxes(item_frame, armor_buttons)
		armor_buttons = nil

		-------------------------------------------------------------------------------
		-- Create the Weapon toggle and CheckButtons
		-------------------------------------------------------------------------------
		local weapon_toggle = GenericCreateButton(nil, item_frame, 20, 105, "GameFontHighlight", L["Weapon"] .. ":", "LEFT", L["WEAPON_TEXT_DESC"], 0)
		weapon_toggle:SetPoint("TOPLEFT", item_frame, "TOPLEFT", -2, -122)

		weapon_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		weapon_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		weapon_toggle:SetScript("OnClick",
					function(self, button)
						local weapons = addon.db.profile.filters.item.weapon
						local toggle = (button == "LeftButton") and true or false

						for weapon in pairs(weapons) do
							weapons[weapon] = toggle

							if FilterPanel.value_map[weapon].svroot then
								item_frame[weapon]:SetChecked(toggle)
							end
						end
						MainPanel:UpdateTitle()
						MainPanel.list_frame:Update(nil, false)
					end)

		item_frame.weapon_toggle = weapon_toggle

		local BASIC_COLORS = private.basic_colors

		local weapon_buttons = {
			["onehand"]	= { tt = L["ONEHAND_DESC"],	text = L["One Hand"],						row = 9,  col = 1 },
			["twohand"]	= { tt = L["TWOHAND_DESC"],	text = L["Two Hand"],						row = 9,  col = 2 },
			["dagger"]	= { tt = L["DAGGER_DESC"],	text = L["Dagger"],						row = 10, col = 1 },
			["axe"]		= { tt = L["AXE_DESC"],		text = L["Axe"],						row = 10, col = 2 },
			["mace"]	= { tt = L["MACE_DESC"],	text = L["Mace"],						row = 11, col = 1 },
			["sword"]	= { tt = L["SWORD_DESC"],	text = L["Sword"],						row = 11, col = 2 },
			["polearm"]	= { tt = L["POLEARM_DESC"],	text = L["Polearm"],						row = 12, col = 1 },
			["fist"]	= { tt = L["FIST_DESC"],	text = L["Fist"],						row = 12, col = 2 },
			["staff"]	= { tt = L["STAFF_DESC"],	text = SetTextColor(BASIC_COLORS["grey"], L["Staff"]),		row = 13, col = 1 },
			["wand"]	= { tt = L["WAND_DESC"],	text = L["Wand"],						row = 13, col = 2 },
			["thrown"]	= { tt = L["THROWN_DESC"],	text = L["Thrown"],						row = 14, col = 1 },
			["bow"]		= { tt = L["BOW_DESC"],		text = SetTextColor(BASIC_COLORS["grey"], L["Bow"]),		row = 14, col = 2 },
			["crossbow"]	= { tt = L["CROSSBOW_DESC"],	text = SetTextColor(BASIC_COLORS["grey"], L["Crossbow"]),	row = 15, col = 1 },
			["ammo"]	= { tt = L["AMMO_DESC"],	text = L["Ammo"],						row = 15, col = 2 },
			["gun"]		= { tt = L["GUN_DESC"],		text = L["Gun"],						row = 16, col = 1 },
		}
		GenerateCheckBoxes(item_frame, weapon_buttons)
		weapon_buttons = nil

		-- Some of these are disabled for now, since they currently have no recipes.
		item_frame.staff:Disable()
		item_frame.bow:Disable()
		item_frame.crossbow:Disable()
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.quality, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local quality_frame = FilterPanel:CreateSubMenu("quality")

		-------------------------------------------------------------------------------
		-- Create the CheckButtons
		-------------------------------------------------------------------------------
		local function QualityDesc(text)
			return string.format(L["QUALITY_GENERAL_DESC"], text)
		end

		local quality_buttons = {
			["common"]	= { tt = QualityDesc(_G.ITEM_QUALITY1_DESC),	text = _G.ITEM_QUALITY1_DESC,	row = 1, col = 1 },
			["uncommon"]	= { tt = QualityDesc(_G.ITEM_QUALITY2_DESC),	text = _G.ITEM_QUALITY2_DESC,	row = 2, col = 1 },
			["rare"]	= { tt = QualityDesc(_G.ITEM_QUALITY3_DESC),	text = _G.ITEM_QUALITY3_DESC,	row = 3, col = 1 },
			["epic"]	= { tt = QualityDesc(_G.ITEM_QUALITY4_DESC),	text = _G.ITEM_QUALITY4_DESC,	row = 4, col = 1 },
		}
		GenerateCheckBoxes(quality_frame, quality_buttons)
		quality_buttons = nil
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.player, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local player_frame = FilterPanel:CreateSubMenu("player")
		local tank_desc = string.format(L["ROLE_DESC_FORMAT"], _G.TANK)
		local melee_desc = string.format(L["ROLE_DESC_FORMAT"], _G.MELEE)
		local healer_desc = string.format(L["ROLE_DESC_FORMAT"], _G.HEALER)
		local caster_desc = string.format(L["ROLE_DESC_FORMAT"], _G.DAMAGER)

		-------------------------------------------------------------------------------
		-- Create the CheckButtons
		-------------------------------------------------------------------------------
		local role_buttons = {
			["tank"]	= { tt = tank_desc,	text = _G.TANK,		row = 1, col = 1 },
			["melee"]	= { tt = melee_desc,	text = _G.MELEE,	row = 2, col = 1 },
			["healer"]	= { tt = healer_desc,	text = _G.HEALER,	row = 3, col = 1 },
			["caster"]	= { tt = caster_desc,	text = _G.DAMAGER,	row = 4, col = 1 },
		}
		GenerateCheckBoxes(player_frame, role_buttons)
		role_buttons = nil
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.rep, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local rep_frame = FilterPanel:CreateSubMenu("rep")

		local EXPANSION_TOOLTIP = {
			["expansion0"]	= L["FILTERING_OLDWORLD_DESC"],
			["expansion1"]	= L["FILTERING_BC_DESC"],
			["expansion2"]	= L["FILTERING_WOTLK_DESC"],
		}
		-------------------------------------------------------------------------------
		-- This manages the WoW expansion reputation filter menu panel
		-------------------------------------------------------------------------------
		local function ToggleExpansionMenu(panel)
			local toggle = "toggle_" .. panel
			local button = rep_frame[toggle]

			button:SetChecked(not button:GetChecked())

			if not button:GetChecked() then
				button:SetChecked(true)
				rep_frame[panel]:Show()

				-- Hide all of the other expansion frames, and un-check them as well.
				for expansion in pairs(EXPANSION_FRAMES) do
					if expansion ~= panel then
						local tog = "toggle_" .. expansion

						rep_frame[tog]:SetChecked(false)
						rep_frame[expansion]:Hide()
					end
				end
			else
				rep_frame[panel]:Hide()
				button:SetChecked(false)
			end
		end

		-------------------------------------------------------------------------------
		-- Generic function to create expansion buttons.
		-------------------------------------------------------------------------------
		function rep_frame:CreateExpansionButton(texture, expansion)
			local cButton = CreateFrame("CheckButton", nil, self)
			cButton:SetWidth(100)
			cButton:SetHeight(46)
			cButton:SetChecked(false)
			cButton:SetScript("OnClick", function(self, button, down)
							     ToggleExpansionMenu(expansion)
						     end)

			local iconTex = cButton:CreateTexture(nil, "BORDER")

			if texture == "wotlk_logo" then
				iconTex:SetTexture("Interface\\Addons\\AckisRecipeList\\img\\" .. texture)
			else
				iconTex:SetTexture("Interface/Glues/Common/" .. texture)
			end
			iconTex:SetWidth(100)
			iconTex:SetHeight(46)
			iconTex:SetAllPoints(cButton)

			local pushedTexture = cButton:CreateTexture(nil, "ARTWORK")
			pushedTexture:SetTexture("Interface/Buttons/UI-Quickslot-Depress")
			pushedTexture:SetAllPoints(cButton)
			cButton:SetPushedTexture(pushedTexture)

			local highlightTexture = cButton:CreateTexture()
			highlightTexture:SetTexture("Interface/Buttons/ButtonHilight-Square")
			highlightTexture:SetAllPoints(cButton)
			highlightTexture:SetBlendMode("ADD")
			cButton:SetHighlightTexture(highlightTexture)

			local checkedTexture = cButton:CreateTexture()
			checkedTexture:SetTexture("Interface/Buttons/CheckButtonHilight")
			checkedTexture:SetAllPoints(cButton)
			checkedTexture:SetBlendMode("ADD")
			cButton:SetCheckedTexture(checkedTexture)

			-- And throw up a tooltip
			SetTooltipScripts(cButton, EXPANSION_TOOLTIP[expansion])

			return cButton
		end

		-------------------------------------------------------------------------------
		-- Create the expansion toggles.
		-------------------------------------------------------------------------------
		local expansion0 = rep_frame:CreateExpansionButton("Glues-WoW-Logo", "expansion0")
		expansion0:SetPoint("TOPLEFT", FilterPanel.rep, "TOPLEFT", 0, -10)

		local expansion1 = rep_frame:CreateExpansionButton("GLUES-WOW-BCLOGO", "expansion1")
		expansion1:SetPoint("TOPLEFT", FilterPanel.rep, "TOPLEFT", 0, -60)

		local expansion2 = rep_frame:CreateExpansionButton("Glues-WOW-WotlkLogo", "expansion2")
		expansion2:SetPoint("TOPLEFT", FilterPanel.rep, "TOPLEFT", 0, -110)

		rep_frame.toggle_expansion0 = expansion0
		rep_frame.toggle_expansion1 = expansion1
		rep_frame.toggle_expansion2 = expansion2
	end	-- do

	-------------------------------------------------------------------------------
	-- Check to see if we're Horde or Alliance, and change the displayed
	-- reputation strings to be faction-correct.
	-------------------------------------------------------------------------------
	local isAlliance = (Player.faction == "Alliance")

	local HonorHold_Thrallmar_Text = isAlliance and BFAC["Honor Hold"] or BFAC["Thrallmar"]
	local Kurenai_Maghar_Text = isAlliance and BFAC["Kurenai"] or BFAC["The Mag'har"]
	local Vanguard_Expedition_Text = isAlliance and BFAC["Alliance Vanguard"] or BFAC["Horde Expedition"]
	local SilverCov_Sunreaver_Text = isAlliance and BFAC["The Silver Covenant"] or BFAC["The Sunreavers"]
	local Valiance_Warsong_Text = isAlliance and BFAC["Valiance Expedition"] or BFAC["Warsong Offensive"]
	local Frostborn_Taunka_Text = isAlliance and BFAC["The Frostborn"] or BFAC["The Taunka"]
	local Explorer_Hand_Text = isAlliance and BFAC["Explorers' League"] or BFAC["The Hand of Vengeance"]

	-------------------------------------------------------------------------------
	-- Used for the tooltip of every reputation checkbox.
	-------------------------------------------------------------------------------
	local function ReputationDesc(text)
		return string.format(L["SPECIFIC_REP_DESC"], text)
	end

	-------------------------------------------------------------------------------
	-- Create FilterPanel.rep.expansion0, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local expansion0_frame = CreateFrame("Frame", nil, FilterPanel.rep)
		expansion0_frame:SetWidth(150)
		expansion0_frame:SetHeight(280)
		expansion0_frame:EnableMouse(true)
		expansion0_frame:EnableKeyboard(true)
		expansion0_frame:SetMovable(false)
		expansion0_frame:SetPoint("TOPRIGHT", FilterPanel, "TOPRIGHT", -30, -16)
		expansion0_frame:Hide()

		FilterPanel.rep.expansion0 = expansion0_frame

		-------------------------------------------------------------------------------
		-- Create the Reputation toggle and CheckButtons
		-------------------------------------------------------------------------------
		local expansion0_buttons = {
			["argentdawn"]		= { tt = ReputationDesc(BFAC["Argent Dawn"]),		text = BFAC["Argent Dawn"],		row = 2, col = 1 },
			["cenarioncircle"]	= { tt = ReputationDesc(BFAC["Cenarion Circle"]),	text = BFAC["Cenarion Circle"],		row = 3, col = 1 },
			["thoriumbrotherhood"]	= { tt = ReputationDesc(BFAC["Thorium Brotherhood"]),	text = BFAC["Thorium Brotherhood"],	row = 4, col = 1 },
			["timbermaw"]		= { tt = ReputationDesc(BFAC["Timbermaw Hold"]),	text = BFAC["Timbermaw Hold"],		row = 5, col = 1 },
			["zandalar"]		= { tt = ReputationDesc(BFAC["Zandalar Tribe"]),	text = BFAC["Zandalar Tribe"],		row = 6, col = 1 },
		}
		GenerateCheckBoxes(expansion0_frame, expansion0_buttons)

		local expansion0_toggle = GenericCreateButton(nil, expansion0_frame, 15, 120, "GameFontHighlight", _G.REPUTATION .. ":", "LEFT", L["REP_TEXT_DESC"], 0)
		expansion0_toggle:SetPoint("TOPLEFT", expansion0_frame, "TOPLEFT", -2, -4)

		expansion0_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		expansion0_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		expansion0_toggle:SetScript("OnClick",
					    function(self, button)
						    local filterdb = addon.db.profile.filters.rep

						    if button == "LeftButton" then
							    for reputation in pairs(expansion0_buttons) do
								    filterdb[reputation] = true
							    end
						    elseif button == "RightButton" then
							    for reputation in pairs(expansion0_buttons) do
								    filterdb[reputation] = false
							    end
						    end

						    for reputation in pairs(expansion0_buttons) do
							    expansion0_frame[reputation]:SetChecked(filterdb[reputation])
						    end
						    MainPanel:UpdateTitle()
						    MainPanel.list_frame:Update(nil, false)
					    end)
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.rep.expansion1, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local expansion1_frame = CreateFrame("Frame", nil, FilterPanel.rep)
		expansion1_frame:SetWidth(150)
		expansion1_frame:SetHeight(280)
		expansion1_frame:EnableMouse(true)
		expansion1_frame:EnableKeyboard(true)
		expansion1_frame:SetMovable(false)
		expansion1_frame:SetPoint("TOPRIGHT", FilterPanel, "TOPRIGHT", -30, -16)
		expansion1_frame:Hide()

		FilterPanel.rep.expansion1 = expansion1_frame

		-------------------------------------------------------------------------------
		-- Create the Reputation toggle and CheckButtons
		-------------------------------------------------------------------------------
		local expansion1_buttons = {
			["aldor"]		= { tt = ReputationDesc(BFAC["The Aldor"]),			text = BFAC["The Aldor"],		row = 2,	col = 1 },
			["ashtonguedeathsworn"]	= { tt = ReputationDesc(BFAC["Ashtongue Deathsworn"]),		text = BFAC["Ashtongue Deathsworn"],	row = 3,	col = 1 },
			["cenarionexpedition"]	= { tt = ReputationDesc(BFAC["Cenarion Expedition"]),		text = BFAC["Cenarion Expedition"],	row = 4,	col = 1 },
			["consortium"]		= { tt = ReputationDesc(BFAC["The Consortium"]),		text = BFAC["The Consortium"],		row = 5,	col = 1 },
			["hellfire"]		= { tt = ReputationDesc(HonorHold_Thrallmar_Text),		text = HonorHold_Thrallmar_Text,	row = 6,	col = 1 },
			["keepersoftime"]	= { tt = ReputationDesc(BFAC["Keepers of Time"]),		text = BFAC["Keepers of Time"],		row = 7,	col = 1 },
			["nagrand"]		= { tt = ReputationDesc(Kurenai_Maghar_Text),			text = Kurenai_Maghar_Text,		row = 8,	col = 1 },
			["lowercity"]		= { tt = ReputationDesc(BFAC["Lower City"]),			text = BFAC["Lower City"],		row = 9,	col = 1 },
			["scaleofthesands"]	= { tt = ReputationDesc(BFAC["The Scale of the Sands"]),	text = BFAC["The Scale of the Sands"],	row = 10,	col = 1 },
			["scryer"]		= { tt = ReputationDesc(BFAC["The Scryers"]),			text = BFAC["The Scryers"],		row = 11,	col = 1 },
			["shatar"]		= { tt = ReputationDesc(BFAC["The Sha'tar"]),			text = BFAC["The Sha'tar"],		row = 12,	col = 1 },
			["shatteredsun"]	= { tt = ReputationDesc(BFAC["Shattered Sun Offensive"]),	text = BFAC["Shattered Sun Offensive"],	row = 13,	col = 1 },
			["sporeggar"]		= { tt = ReputationDesc(BFAC["Sporeggar"]),			text = BFAC["Sporeggar"],		row = 14,	col = 1 },
			["violeteye"]		= { tt = ReputationDesc(BFAC["The Violet Eye"]),		text = BFAC["The Violet Eye"],		row = 15,	col = 1 },
		}
		GenerateCheckBoxes(expansion1_frame, expansion1_buttons)

		local expansion1_toggle = GenericCreateButton(nil, expansion1_frame, 15, 120, "GameFontHighlight", _G.REPUTATION .. ":", "LEFT", L["REP_TEXT_DESC"], 0)
		expansion1_toggle:SetPoint("TOPLEFT", expansion1_frame, "TOPLEFT", -2, -4)

		expansion1_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		expansion1_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		expansion1_toggle:SetScript("OnClick",
					    function(self,button)
						    local filterdb = addon.db.profile.filters.rep

						    if button == "LeftButton" then
							    for reputation in pairs(expansion1_buttons) do
								    filterdb[reputation] = true
							    end
						    elseif button == "RightButton" then
							    for reputation in pairs(expansion1_buttons) do
								    filterdb[reputation] = false
							    end
						    end

						    for reputation in pairs(expansion1_buttons) do
							    expansion1_frame[reputation]:SetChecked(filterdb[reputation])
						    end
						    MainPanel:UpdateTitle()
						    MainPanel.list_frame:Update(nil, false)
					    end)
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Create FilterPanel.rep.expansion2, and set its scripts.
	-------------------------------------------------------------------------------
	do
		local expansion2_frame = CreateFrame("Frame", nil, FilterPanel.rep)
		expansion2_frame:SetWidth(150)
		expansion2_frame:SetHeight(280)
		expansion2_frame:EnableMouse(true)
		expansion2_frame:EnableKeyboard(true)
		expansion2_frame:SetMovable(false)
		expansion2_frame:SetPoint("TOPRIGHT", FilterPanel, "TOPRIGHT", -30, -16)
		expansion2_frame:Hide()

		FilterPanel.rep.expansion2 = expansion2_frame

		-------------------------------------------------------------------------------
		-- Create the Reputation toggle and CheckButtons
		-------------------------------------------------------------------------------
		local function DisabledText(text)
			return SetTextColor(private.basic_colors["grey"], text)
		end

		local expansion2_buttons = {
			["wrathcommon1"]	= { tt = ReputationDesc(Vanguard_Expedition_Text),		text = Vanguard_Expedition_Text,		row = 2,	col = 1 },
			["argentcrusade"]	= { tt = ReputationDesc(BFAC["Argent Crusade"]),		text = BFAC["Argent Crusade"],			row = 3,	col = 1 },
			["wrathcommon5"]	= { tt = ReputationDesc(Explorer_Hand_Text),			text = DisabledText(Explorer_Hand_Text),	row = 4,	col = 1 },
			["frenzyheart"]		= { tt = ReputationDesc(BFAC["Frenzyheart Tribe"]),		text = BFAC["Frenzyheart Tribe"],		row = 5,	col = 1 },
			["kaluak"]		= { tt = ReputationDesc(BFAC["The Kalu'ak"]),			text = BFAC["The Kalu'ak"],			row = 6,	col = 1 },
			["kirintor"]		= { tt = ReputationDesc(BFAC["Kirin Tor"]),			text = BFAC["Kirin Tor"],			row = 7,	col = 1 },
			["ebonblade"]		= { tt = ReputationDesc(BFAC["Knights of the Ebon Blade"]),	text = BFAC["Knights of the Ebon Blade"],	row = 8,	col = 1 },
			["oracles"]		= { tt = ReputationDesc(BFAC["The Oracles"]),			text = BFAC["The Oracles"],			row = 9,	col = 1 },
			["wrathcommon2"]	= { tt = ReputationDesc(SilverCov_Sunreaver_Text),		text = DisabledText(SilverCov_Sunreaver_Text),	row = 10,	col = 1 },
			["sonsofhodir"]		= { tt = ReputationDesc(BFAC["The Sons of Hodir"]),		text = BFAC["The Sons of Hodir"],		row = 11,	col = 1 },
			["wrathcommon4"]	= { tt = ReputationDesc(Frostborn_Taunka_Text),			text = DisabledText(Frostborn_Taunka_Text),	row = 12,	col = 1 },
			["wrathcommon3"]	= { tt = ReputationDesc(Valiance_Warsong_Text),			text = DisabledText(Valiance_Warsong_Text),	row = 13,	col = 1 },
			["wyrmrest"]		= { tt = ReputationDesc(BFAC["The Wyrmrest Accord"]),		text = BFAC["The Wyrmrest Accord"],		row = 14,	col = 1 },
			["ashenverdict"]	= { tt = ReputationDesc(BFAC["The Ashen Verdict"]),		text = BFAC["The Ashen Verdict"],		row = 15,	col = 1 },
		}
		GenerateCheckBoxes(expansion2_frame, expansion2_buttons)

		-- Disable these for now, since they have no recipes.
		expansion2_frame.wrathcommon2:Disable()
		expansion2_frame.wrathcommon3:Disable()
		expansion2_frame.wrathcommon4:Disable()
		expansion2_frame.wrathcommon5:Disable()

		local expansion2_toggle = GenericCreateButton(nil, expansion2_frame, 15, 120, "GameFontHighlight", _G.REPUTATION .. ":", "LEFT", L["REP_TEXT_DESC"], 0)
		expansion2_toggle:SetPoint("TOPLEFT", expansion2_frame, "TOPLEFT", -2, -4)

		expansion2_toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		expansion2_toggle:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		expansion2_toggle:SetScript("OnClick",
					   function(self,button)
						    local filterdb = addon.db.profile.filters.rep

						    if button == "LeftButton" then
							    for reputation in pairs(expansion2_buttons) do
								    filterdb[reputation] = true
							    end
						    elseif button == "RightButton" then
							    for reputation in pairs(expansion2_buttons) do
								    filterdb[reputation] = false
							    end
						    end

						    for reputation in pairs(expansion2_buttons) do
							    expansion2_frame[reputation]:SetChecked(filterdb[reputation])
						    end
						    MainPanel:UpdateTitle()
						    MainPanel.list_frame:Update(nil, false)
					   end)
	end	-- do-block

	-------------------------------------------------------------------------------
	-- Miscellaneous Filter Menu
	-------------------------------------------------------------------------------
	FilterPanel.misc = CreateFrame("Frame", "ARL_FilterMenu_Misc", FilterPanel)
	FilterPanel.misc:SetWidth(FILTERMENU_WIDTH)
	FilterPanel.misc:SetHeight(280)
	FilterPanel.misc:EnableMouse(true)
	FilterPanel.misc:EnableKeyboard(true)
	FilterPanel.misc:SetMovable(false)
	FilterPanel.misc:SetPoint("TOPLEFT", FilterPanel, "TOPLEFT", 17, -16)
	FilterPanel.misc:Hide()

	local ARL_MiscAltText = FilterPanel.misc:CreateFontString("ARL_MiscAltBtn", "OVERLAY", "QuestFontNormalSmall")
	ARL_MiscAltText:SetText(L["Alt-Tradeskills"] .. ":")
	ARL_MiscAltText:SetPoint("TOPLEFT", FilterPanel.misc, "TOPLEFT", 5, -8)
	ARL_MiscAltText:SetHeight(14)
	ARL_MiscAltText:SetWidth(95)
	ARL_MiscAltText:SetJustifyH("LEFT")

	local ARL_MiscAltBtn = CreateFrame("Button", "ARL_MiscAltBtn", FilterPanel.misc)
	ARL_MiscAltBtn:SetPoint("LEFT", ARL_MiscAltText, "RIGHT")
	ARL_MiscAltBtn:SetHeight(22)
	ARL_MiscAltBtn:SetWidth(22)
	ARL_MiscAltBtn:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	ARL_MiscAltBtn:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	ARL_MiscAltBtn:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
	ARL_MiscAltBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

	SetTooltipScripts(ARL_MiscAltBtn, L["ALT_TRADESKILL_DESC"], 1)

	ARL_MiscAltBtn:RegisterForClicks("LeftButtonUp")

	do
		-------------------------------------------------------------------------------
		-- Data used in GenerateClickableTT() and its support functions.
		-------------------------------------------------------------------------------
		local click_info = {
			anchor = nil,
			change_realm = nil,
			target_realm = nil,
			modified = nil,
			name = nil,
			realm = nil,
		}
		local clicktip
		local GenerateClickableTT	-- Upvalued!

		-------------------------------------------------------------------------------
		-- Clicktip OnMouseUp scripts.
		-------------------------------------------------------------------------------
		local function ChangeRealm(cell, arg, button)
			click_info.modified = true
			click_info.realm = nil
			click_info.change_realm = true
			click_info.target_realm = nil
			GenerateClickableTT()
		end

		local function SelectRealm(cell, arg, button)
			click_info.modified = true

			if click_info.change_realm then
				click_info.target_realm = arg
			end
			click_info.realm = arg
			GenerateClickableTT()
		end

		local function SelectName(cell, arg, button)
			click_info.modified = true
			click_info.name = arg

			-- Wipe tradeskill information for the selected toon. -Torhal
			if _G.IsAltKeyDown() and button == "LeftButton" then
				local tskl_list = addon.db.global.tradeskill
				tskl_list[click_info.realm][click_info.name] = nil

				-- See if there are any toons left on the realm. If not, nuke it as well.
				local found = false
				for name in pairs(tskl_list[click_info.realm]) do
					found = true
				end
				if not found then
					tskl_list[click_info.realm] = nil
				end
				local anchor = click_info.anchor
				table.wipe(click_info)
				click_info.anchor = anchor
				GenerateClickableTT()
				return
			end
			GenerateClickableTT()
		end

		local function SelectProfession(cell, arg, button)
			local tskl_list = addon.db.global.tradeskill
			local saved_link = tskl_list[click_info.realm][click_info.name][arg]

			if click_info.realm ~= _G.GetRealmName() then
				local player_guid = string.gsub(_G.UnitGUID("player"), "0x0+", "")
				local color, trade_id, cur_lev, max_lev, guid, bitmask = string.split(":", saved_link)
				local trade_link = string.join(":", color, trade_id, cur_lev, max_lev, player_guid, bitmask)

				addon:Printf("%s (%s): %s", click_info.name, click_info.realm, trade_link)
			else
				addon:Printf("%s: %s", click_info.name, saved_link)
			end
			click_info.modified = true
		end

		-------------------------------------------------------------------------------
		-- Creates a list of names/alts/etc in a tooltip which can be clicked.
		-------------------------------------------------------------------------------
		function GenerateClickableTT(anchor)
			local tskl_list = addon.db.global.tradeskill
			local tip = clicktip
			local y, x
			local prealm = _G.GetRealmName()
			local target_realm = prealm

			if click_info.change_realm then
				target_realm = click_info.target_realm
				click_info.change_realm = nil
			end
			tip:Clear()

			if not click_info.realm then
				local other_realms = nil
				local header = nil

				for realm in pairs(tskl_list) do
					if target_realm and realm ~= target_realm then
						other_realms = true
					end

					if not target_realm and realm ~= prealm then
						if not header then
							tip:AddHeader(L["Other Realms"])
							tip:AddSeparator()
							header = true
						end
						y, x = tip:AddLine()
						tip:SetCell(y, x, realm)
						tip:SetCellScript(y, x, "OnMouseUp", SelectRealm, realm)
					elseif realm == target_realm then
						click_info.realm = realm

						tip:AddHeader(realm)
						tip:AddSeparator()

						for name in pairs(tskl_list[click_info.realm]) do
							if name ~= _G.UnitName("player") then
								y, x = tip:AddLine()
								tip:SetCell(y, x, name)
								tip:SetCellScript(y, x, "OnMouseUp", SelectName, name)
							end
						end
					end
				end

				if other_realms then
					tip:AddSeparator()
					y, x = tip:AddLine()
					tip:SetCell(y, x, L["Other Realms"])
					tip:SetCellScript(y, x, "OnMouseUp", ChangeRealm)
				end
				tip:AddSeparator()
			elseif not click_info.name then
				local realm_list = tskl_list[click_info.realm]

				if realm_list then
					tip:AddLine(click_info.realm)
					tip:AddSeparator()

					for name in pairs(realm_list) do
						y, x = tip:AddLine()
						tip:SetCell(y, x, name)
						tip:SetCellScript(y, x, "OnMouseUp", SelectName, name)
					end
					tip:AddSeparator()
				end
			else
				tip:AddHeader(click_info.name)
				tip:AddSeparator()

				for prof in pairs(tskl_list[click_info.realm][click_info.name]) do
					y, x = tip:AddLine()
					tip:SetCell(y, x, prof)
					tip:SetCellScript(y, x, "OnMouseUp", SelectProfession, prof)
				end
				tip:AddSeparator()
			end

			if anchor then
				click_info.anchor = anchor
				tip:SetPoint("TOP", anchor, "BOTTOM")
			else
				tip:SetPoint("TOP", click_info.anchor, "BOTTOM")
			end
			tip:Show()
		end

		ARL_MiscAltBtn:SetScript("OnClick",
					 function(self, button)
						 if clicktip then
							 if not click_info.modified then
								 clicktip = QTip:Release(clicktip)
								 table.wipe(click_info)
							 else
								 table.wipe(click_info)
								 GenerateClickableTT(self)
							 end
						 else
							 clicktip = QTip:Acquire("ARL_Clickable", 1, "CENTER")
							 table.wipe(click_info)

							 if _G.TipTac and _G.TipTac.AddModifiedTip then
								 _G.TipTac:AddModifiedTip(clicktip, true)
							 end
							 GenerateClickableTT(self)
						 end
					 end)

		ARL_MiscAltBtn:SetScript("OnHide",
					 function(self, button)
						 clicktip = QTip:Release(clicktip)
						 table.wipe(click_info)
					 end)
	end

	-------------------------------------------------------------------------------
	-- Now that everything exists, populate the global filter table
	-------------------------------------------------------------------------------
	local filterdb = addon.db.profile.filters

	local expansion0 = FilterPanel.rep.expansion0
	local expansion1 = FilterPanel.rep.expansion1
	local expansion2 = FilterPanel.rep.expansion2

	FilterPanel.value_map = {
		------------------------------------------------------------------------------------------------
		-- General Options
		------------------------------------------------------------------------------------------------
		["specialty"]		= { cb = FilterPanel.general.specialty,		svroot = filterdb.general },
		["skill"]		= { cb = FilterPanel.general.skill,		svroot = filterdb.general },
		["faction"]		= { cb = FilterPanel.general.faction,		svroot = filterdb.general },
		["known"]		= { cb = FilterPanel.general.known,		svroot = filterdb.general },
		["unknown"]		= { cb = FilterPanel.general.unknown,		svroot = filterdb.general },
		["retired"]		= { cb = FilterPanel.general.retired,		svroot = filterdb.general },
		------------------------------------------------------------------------------------------------
		-- Classes
		------------------------------------------------------------------------------------------------
		["deathknight"]		= { cb = FilterPanel.general.deathknight,	svroot = filterdb.classes },
		["druid"]		= { cb = FilterPanel.general.druid,		svroot = filterdb.classes },
		["hunter"]		= { cb = FilterPanel.general.hunter,		svroot = filterdb.classes },
		["mage"]		= { cb = FilterPanel.general.mage,		svroot = filterdb.classes },
		["paladin"]		= { cb = FilterPanel.general.paladin,		svroot = filterdb.classes },
		["priest"]		= { cb = FilterPanel.general.priest,		svroot = filterdb.classes },
		["rogue"]		= { cb = FilterPanel.general.rogue,		svroot = filterdb.classes },
		["shaman"]		= { cb = FilterPanel.general.shaman,		svroot = filterdb.classes },
		["warlock"]		= { cb = FilterPanel.general.warlock,		svroot = filterdb.classes },
		["warrior"]		= { cb = FilterPanel.general.warrior,		svroot = filterdb.classes },
		------------------------------------------------------------------------------------------------
		-- Obtain Options
		------------------------------------------------------------------------------------------------
		["instance"]		= { cb = FilterPanel.obtain.instance,		svroot = filterdb.obtain },
		["raid"]		= { cb = FilterPanel.obtain.raid,		svroot = filterdb.obtain },
		["quest"]		= { cb = FilterPanel.obtain.quest,		svroot = filterdb.obtain },
		["seasonal"]		= { cb = FilterPanel.obtain.seasonal,		svroot = filterdb.obtain },
		["trainer"]		= { cb = FilterPanel.obtain.trainer,		svroot = filterdb.obtain },
		["vendor"]		= { cb = FilterPanel.obtain.vendor,		svroot = filterdb.obtain },
		["pvp"]			= { cb = FilterPanel.obtain.pvp,		svroot = filterdb.obtain },
		["discovery"]		= { cb = FilterPanel.obtain.discovery,		svroot = filterdb.obtain },
		["worlddrop"]		= { cb = FilterPanel.obtain.worlddrop,		svroot = filterdb.obtain },
		["mobdrop"]		= { cb = FilterPanel.obtain.mobdrop,		svroot = filterdb.obtain },
		["expansion0"]		= { cb = FilterPanel.obtain.expansion0,		svroot = filterdb.obtain },
		["expansion1"]		= { cb = FilterPanel.obtain.expansion1,		svroot = filterdb.obtain },
		["expansion2"]		= { cb = FilterPanel.obtain.expansion2,		svroot = filterdb.obtain },
		------------------------------------------------------------------------------------------------
		-- Binding Options
		------------------------------------------------------------------------------------------------
		["itemboe"]		= { cb = FilterPanel.binding.itemboe,		svroot = filterdb.binding },
		["itembop"]		= { cb = FilterPanel.binding.itembop,		svroot = filterdb.binding },
		["recipeboe"]		= { cb = FilterPanel.binding.recipeboe,		svroot = filterdb.binding },
		["recipebop"]		= { cb = FilterPanel.binding.recipebop,		svroot = filterdb.binding },
		------------------------------------------------------------------------------------------------
		-- Armor Options
		------------------------------------------------------------------------------------------------
		["cloth"]		= { cb = FilterPanel.item.cloth,		svroot = filterdb.item.armor },
		["leather"]		= { cb = FilterPanel.item.leather,		svroot = filterdb.item.armor },
		["mail"]		= { cb = FilterPanel.item.mail,			svroot = filterdb.item.armor },
		["plate"]		= { cb = FilterPanel.item.plate,		svroot = filterdb.item.armor },
		["cloak"]		= { cb = FilterPanel.item.cloak,		svroot = filterdb.item.armor },
		["necklace"]		= { cb = FilterPanel.item.necklace,		svroot = filterdb.item.armor },
		["ring"]		= { cb = FilterPanel.item.ring,			svroot = filterdb.item.armor },
		["trinket"]		= { cb = FilterPanel.item.trinket,		svroot = filterdb.item.armor },
		["shield"]		= { cb = FilterPanel.item.shield,		svroot = filterdb.item.armor },
		------------------------------------------------------------------------------------------------
		-- Weapon Options
		------------------------------------------------------------------------------------------------
		["onehand"]		= { cb = FilterPanel.item.onehand,		svroot = filterdb.item.weapon },
		["twohand"]		= { cb = FilterPanel.item.twohand,		svroot = filterdb.item.weapon },
		["dagger"]		= { cb = FilterPanel.item.dagger,		svroot = filterdb.item.weapon },
		["axe"]			= { cb = FilterPanel.item.axe,			svroot = filterdb.item.weapon },
		["mace"]		= { cb = FilterPanel.item.mace,			svroot = filterdb.item.weapon },
		["sword"]		= { cb = FilterPanel.item.sword,		svroot = filterdb.item.weapon },
		["polearm"]		= { cb = FilterPanel.item.polearm,		svroot = filterdb.item.weapon },
		["fist"]		= { cb = FilterPanel.item.fist,			svroot = filterdb.item.weapon },
		["staff"]		= { cb = FilterPanel.item.staff,		svroot = nil },
		["wand"]		= { cb = FilterPanel.item.wand,			svroot = filterdb.item.weapon },
		["thrown"]		= { cb = FilterPanel.item.thrown,		svroot = filterdb.item.weapon },
		["bow"]			= { cb = FilterPanel.item.bow,			svroot = nil },
		["crossbow"]		= { cb = FilterPanel.item.crossbow,		svroot = nil },
		["ammo"]		= { cb = FilterPanel.item.ammo,			svroot = filterdb.item.weapon },
		["gun"]			= { cb = FilterPanel.item.gun,			svroot = filterdb.item.weapon },
		------------------------------------------------------------------------------------------------
		-- Quality Options
		------------------------------------------------------------------------------------------------
		["common"]		= { cb = FilterPanel.quality.common,		svroot = filterdb.quality },
		["uncommon"]		= { cb = FilterPanel.quality.uncommon,		svroot = filterdb.quality },
		["rare"]		= { cb = FilterPanel.quality.rare,		svroot = filterdb.quality },
		["epic"]		= { cb = FilterPanel.quality.epic,		svroot = filterdb.quality },
		------------------------------------------------------------------------------------------------
		-- Role Options
		------------------------------------------------------------------------------------------------
		["tank"]		= { cb = FilterPanel.player.tank,		svroot = filterdb.player },
		["melee"]		= { cb = FilterPanel.player.melee,		svroot = filterdb.player },
		["healer"]		= { cb = FilterPanel.player.healer,		svroot = filterdb.player },
		["caster"]		= { cb = FilterPanel.player.caster,		svroot = filterdb.player },
		------------------------------------------------------------------------------------------------
		-- Old World Rep Options
		------------------------------------------------------------------------------------------------
		["argentdawn"]		= { cb = expansion0.argentdawn,			svroot = filterdb.rep },
		["cenarioncircle"]	= { cb = expansion0.cenarioncircle,		svroot = filterdb.rep },
		["thoriumbrotherhood"]	= { cb = expansion0.thoriumbrotherhood,		svroot = filterdb.rep },
		["timbermaw"]		= { cb = expansion0.timbermaw,			svroot = filterdb.rep },
		["zandalar"]		= { cb = expansion0.zandalar,			svroot = filterdb.rep },
		------------------------------------------------------------------------------------------------
		-- The Burning Crusade Rep Options
		------------------------------------------------------------------------------------------------
		["aldor"]		= { cb = expansion1.aldor,			svroot = filterdb.rep },
		["ashtonguedeathsworn"]	= { cb = expansion1.ashtonguedeathsworn,	svroot = filterdb.rep },
		["cenarionexpedition"]	= { cb = expansion1.cenarionexpedition,		svroot = filterdb.rep },
		["consortium"]		= { cb = expansion1.consortium,			svroot = filterdb.rep },
		["hellfire"]		= { cb = expansion1.hellfire,			svroot = filterdb.rep },
		["keepersoftime"]	= { cb = expansion1.keepersoftime,		svroot = filterdb.rep },
		["nagrand"]		= { cb = expansion1.nagrand,			svroot = filterdb.rep },
		["lowercity"]		= { cb = expansion1.lowercity,			svroot = filterdb.rep },
		["scaleofthesands"]	= { cb = expansion1.scaleofthesands,		svroot = filterdb.rep },
		["scryer"]		= { cb = expansion1.scryer,			svroot = filterdb.rep },
		["shatar"]		= { cb = expansion1.shatar,			svroot = filterdb.rep },
		["shatteredsun"]	= { cb = expansion1.shatteredsun,		svroot = filterdb.rep },
		["sporeggar"]		= { cb = expansion1.sporeggar,			svroot = filterdb.rep },
		["violeteye"]		= { cb = expansion1.violeteye,			svroot = filterdb.rep },
		------------------------------------------------------------------------------------------------
		-- Wrath of The Lich King Rep Options
		------------------------------------------------------------------------------------------------
		["argentcrusade"]	= { cb = expansion2.argentcrusade,		svroot = filterdb.rep },
		["frenzyheart"]		= { cb = expansion2.frenzyheart,		svroot = filterdb.rep },
		["ebonblade"]		= { cb = expansion2.ebonblade,			svroot = filterdb.rep },
		["kirintor"]		= { cb = expansion2.kirintor,			svroot = filterdb.rep },
		["sonsofhodir"]		= { cb = expansion2.sonsofhodir,		svroot = filterdb.rep },
		["kaluak"]		= { cb = expansion2.kaluak,			svroot = filterdb.rep },
		["oracles"]		= { cb = expansion2.oracles,			svroot = filterdb.rep },
		["wyrmrest"]		= { cb = expansion2.wyrmrest,			svroot = filterdb.rep },
		["ashenverdict"]	= { cb = expansion2.ashenverdict,		svroot = filterdb.rep },
		["wrathcommon1"]	= { cb = expansion2.wrathcommon1,		svroot = filterdb.rep },
		["wrathcommon2"]	= { cb = expansion2.wrathcommon2,		svroot = nil },
		["wrathcommon3"]	= { cb = expansion2.wrathcommon3,		svroot = nil },
		["wrathcommon4"]	= { cb = expansion2.wrathcommon4,		svroot = nil },
		["wrathcommon5"]	= { cb = expansion2.wrathcommon5,		svroot = nil },
	}
	private.InitializeFilterPanel = nil
end