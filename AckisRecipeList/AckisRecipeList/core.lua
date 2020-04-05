--[[
************************************************************************
core.lua
************************************************************************
File date: 2010-08-30T15:19:33Z
File hash: 6593a22
Project hash: 9458672
Project version: v2.01-8-g9458672
************************************************************************
Please see http://www.wowace.com/addons/arl/ for more information.
************************************************************************
This source code is released under All Rights Reserved.
************************************************************************
@class file
@name core.lua
@release 2.0
************************************************************************
]]

-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local tostring = _G.tostring
local tonumber = _G.tonumber

local pairs, ipairs = _G.pairs, _G.ipairs
local select = _G.select

local table = _G.table

local tconcat = table.concat
local tinsert = table.insert

local bit = _G.bit

local string = _G.string
local strformat = string.format
local strfind = string.find
local strmatch = string.match
local strlower = string.lower

-------------------------------------------------------------------------------
-- Localized Blizzard API.
-------------------------------------------------------------------------------
local GetNumTradeSkills = _G.GetNumTradeSkills
local GetSpellInfo = _G.GetSpellInfo

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub	= _G.LibStub
local MODNAME	= "Ackis Recipe List"
local addon	= LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0")
_G.AckisRecipeList = addon

--@alpha@
_G.ARL = addon
--@end-alpha@

local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local BFAC 	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local BZ	= LibStub("LibBabble-Zone-3.0"):GetLookupTable()

local debugger	= _G.tekDebug and _G.tekDebug:GetFrame(MODNAME)

------------------------------------------------------------------------------
-- Constants.
------------------------------------------------------------------------------
local PROFESSION_INITS = {}	-- Professions initialization functions.

------------------------------------------------------------------------------
-- Database tables
------------------------------------------------------------------------------
local AllSpecialtiesTable = {}
local SpecialtyTable

-- Set up the private intra-file namespace.
local private	= select(2, ...)

private.build_num = select(2, GetBuildInfo())

private.custom_list	= {}
private.mob_list	= {}
private.quest_list	= {}
private.recipe_list	= {}
private.reputation_list	= {}
private.trainer_list	= {}
private.seasonal_list	= {}
private.vendor_list	= {}
private.location_list	= {}
private.acquire_list	= {}

-- Filter flags and acquire types - defined in Constants.lua
local F 	= private.filter_flags
local A		= private.acquire_types

------------------------------------------------------------------------------
-- Data which is stored regarding a players statistics (luadoc copied from Collectinator, needs updating)
------------------------------------------------------------------------------
-- @class table
-- @name Player
-- @field known_filtered Total number of items known filtered during the scan.
-- @field Faction Player's faction
-- @field Class Player's class
-- @field ["Reputation"] Listing of players reputation levels
local Player = {}
private.Player = Player

-- Global Frame Variables
addon.optionsFrame = {}

-------------------------------------------------------------------------------
-- Check to see if we have mandatory libraries loaded. If not, notify the user
-- which are missing and return.
-------------------------------------------------------------------------------
local MissingLibraries
do
	local REQUIRED_LIBS = {
		"AceLocale-3.0",
		"LibBabble-Boss-3.0",
		"LibBabble-Faction-3.0",
		"LibBabble-Zone-3.0",
	}
	function MissingLibraries()
		local missing = false

		for idx, lib in ipairs(REQUIRED_LIBS) do
			if not LibStub:GetLibrary(lib, true) then
				missing = true
				addon:Print(strformat(L["MISSING_LIBRARY"], lib))
			end
		end
		return missing
	end
end -- do

if MissingLibraries() then
	--[===[@debug@
	addon:Print("You are using a development version of ARL.  As per WowAce standards, externals are not set up.  You will have to install all necessary libraries in order for the addon to function correctly.")
	--@end-debug@]===]
	_G.AckisRecipeList = nil
	return
end

-------------------------------------------------------------------------------
-- Define the static popups we're going to call when people haven't scanned or
-- when current filters are blocking all recipes from being displayed.
-------------------------------------------------------------------------------
StaticPopupDialogs["ARL_NOTSCANNED"] = {
	text = L["NOTSCANNED"],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["ARL_ALLFILTERED"] = {
	text = L["ALL_FILTERED"],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["ARL_ALLKNOWN"] = {
	text = L["ARL_ALLKNOWN"],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["ARL_ALLEXCLUDED"] = {
	text = L["ARL_ALLEXCLUDED"],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["ARL_SEARCHFILTERED"] = {
	text = L["ARL_SEARCHFILTERED"],
	button1 = _G.OKAY,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

-------------------------------------------------------------------------------
-- Close all possible pop-up windows
-------------------------------------------------------------------------------
function addon:ClosePopups()
	_G.StaticPopup_Hide("ARL_NOTSCANNED")
	_G.StaticPopup_Hide("ARL_ALLFILTERED")
	_G.StaticPopup_Hide("ARL_ALLKNOWN")
	_G.StaticPopup_Hide("ARL_ALLEXCLUDED")
	_G.StaticPopup_Hide("ARL_SEARCHFILTERED")
end

-------------------------------------------------------------------------------
-- Functions common to most files in the AddOn.
-------------------------------------------------------------------------------
function private.SetTextColor(color_code, text)
	return string.format("|cff%s%s|r", color_code or "ffffff", text)
end



-------------------------------------------------------------------------------
-- Debugger.
-------------------------------------------------------------------------------
function addon:Debug(...)
	if debugger then
		debugger:AddMessage(string.format(...))
	else
		--[===[@debug@
		self:Printf(...)
		--@end-debug@]===]
	end
end

do
	local output = {}

	function addon:DumpMembers(match)
		table.wipe(output)
		tinsert(output, "Addon Object members.\n")

		local count = 0

		for key, value in pairs(self) do
			local val_type = type(value)

			if not match or val_type == match then
				tinsert(output, key.. " ("..val_type..")")
				count = count + 1
			end
		end
		tinsert(output, string.format("\n%d found\n", count))
		self:DisplayTextDump(nil, nil, tconcat(output, "\n"))
	end
end	-- do

-------------------------------------------------------------------------------
-- Initialization functions
-------------------------------------------------------------------------------
function addon:OnInitialize()
	-- Set default options, which are to include everything in the scan
	local defaults = {
		global = {
			-- Saving alts tradeskills (needs to be global so all profiles can access it)
			tradeskill = {},
		},
		profile = {
			-------------------------------------------------------------------------------
			-- Frame options
			-------------------------------------------------------------------------------
			frameopts = {
				offsetx = 0,
				offsety = 0,
				anchorTo = "",
				anchorFrom = "",
				uiscale = 1,
				small_list_font = true,
			},

			-------------------------------------------------------------------------------
			-- Tooltip Options
			-------------------------------------------------------------------------------
			tooltip = {
				scale = 1,
				acquire_fontsize = 11,
			},
			-------------------------------------------------------------------------------
			-- Sorting Options
			-------------------------------------------------------------------------------
			sorting = "Ascending",
			current_tab = 3,		-- Name tab
			skill_view = false,		-- Sort the recipes by skill level instead of name?

			-------------------------------------------------------------------------------
			-- Display Options
			-------------------------------------------------------------------------------
			includefiltered = false,
			includeexcluded = false,
			closeguionskillclose = false,
			ignoreexclusionlist = false,
			scanbuttonlocation = "TR",
			spelltooltiplocation = "Right",
			acquiretooltiplocation = "Right",
			recipes_in_tooltips = true,
			max_recipes_in_tooltips = 10,
			hide_tooltip_hint = false,
			hidepopup = false,
			minimap = true,
			worldmap = true,
			autoscanmap = false,
			scantrainers = false,
			scanvendors = false,
			autoloaddb = false,
			maptrainer = false,
			mapvendor = true,
			mapmob = true,
			mapquest = true,

			-------------------------------------------------------------------------------
			-- Text Dump Options
			-------------------------------------------------------------------------------
			textdumpformat = "BBCode",

			-------------------------------------------------------------------------------
			-- Recipe Exclusion
			-------------------------------------------------------------------------------
			exclusionlist = {},

			-------------------------------------------------------------------------------
			-- Filter Options
			-------------------------------------------------------------------------------
			filters = {
				-------------------------------------------------------------------------------
				-- General Filters
				-------------------------------------------------------------------------------
				general = {
					faction = true,
					specialty = false,
					skill = true,
					known = false,
					unknown = true,
					retired = false,
				},
				-------------------------------------------------------------------------------
				-- Obtain Filters
				-------------------------------------------------------------------------------
				obtain = {
					trainer = true,
					vendor = true,
					instance = true,
					raid = true,
					seasonal = true,
					quest = true,
					pvp = true,
					discovery = true,
					worlddrop = true,
					mobdrop = true,
					expansion0 = true,
					expansion1 = true,
					expansion2 = true,
				},
				-------------------------------------------------------------------------------
				-- Item Filters (Armor/Weapon)
				-------------------------------------------------------------------------------
				item = {
					armor = {
						cloth = true,
						leather = true,
						mail = true,
						plate = true,
						trinket = true,
						cloak = true,
						ring = true,
						necklace = true,
						shield = true,
					},
					weapon = {
						onehand = true,
						twohand = true,
						axe = true,
						sword = true,
						mace = true,
						polearm = true,
						dagger = true,
						fist = true,
						staff = true,
						wand = true,
						thrown = true,
						bow = true,
						crossbow = true,
						ammo = true,
						gun = true,
					},
				},
				-------------------------------------------------------------------------------
				-- Quality Filters
				-------------------------------------------------------------------------------
				quality = {
					common = true,
					uncommon = true,
					rare = true,
					epic = true,
				},
				-------------------------------------------------------------------------------
				-- Binding Filters
				-------------------------------------------------------------------------------
				binding = {
					itemboe = true,
					itembop = true,
					recipebop = true,
					recipeboe = true,
				},
				-------------------------------------------------------------------------------
				-- Player Role Filters
				-------------------------------------------------------------------------------
				player = {
					melee = true,
					tank = true,
					healer = true,
					caster = true,
				},
				-------------------------------------------------------------------------------
				-- Reputation Filters
				-------------------------------------------------------------------------------
				rep = {
					aldor = true,
					scryer = true,
					argentdawn = true,
					ashtonguedeathsworn = true,
					cenarioncircle = true,
					cenarionexpedition = true,
					consortium = true,
					hellfire = true,
					keepersoftime = true,
					nagrand = true,
					lowercity = true,
					scaleofthesands = true,
					shatar = true,
					shatteredsun = true,
					sporeggar = true,
					thoriumbrotherhood = true,
					timbermaw = true,
					violeteye = true,
					zandalar = true,
					argentcrusade = true,
					frenzyheart = true,
					ebonblade = true,
					kirintor = true,
					sonsofhodir = true,
					kaluak = true,
					oracles = true,
					wyrmrest = true,
					wrathcommon1 = true,
					wrathcommon2 = true,
					wrathcommon3 = true,
					wrathcommon4 = true,
					wrathcommon5 = true,
					ashenverdict = true,
				},
				-------------------------------------------------------------------------------
				-- Class Filters
				-------------------------------------------------------------------------------
				classes = {
					deathknight = true,
					druid = true,
					hunter = true,
					mage = true,
					paladin = true,
					priest = true,
					rogue = true,
					shaman = true,
					warlock = true,
					warrior = true,
				},
			}
		}
	}
	self.db = LibStub("AceDB-3.0"):New("ARLDB2", defaults)

	if not self.db then
		self:Print("Error: Database not loaded correctly.  Please exit out of WoW and delete the ARL database file (AckisRecipeList.lua) found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\")
		return
	end
	local version = GetAddOnMetadata("AckisRecipeList", "Version")

	-- @alpha@
	version = "Devel"
	-- @end-alpha@

	self.version = version

	self:SetupOptions()

	-- Register slash commands
	self:RegisterChatCommand("arl", "ChatCommand")
	self:RegisterChatCommand("ackisrecipelist", "ChatCommand")

	-------------------------------------------------------------------------------
	-- Create the scan button
	-------------------------------------------------------------------------------
	local scan_button = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
	scan_button:SetHeight(20)

	scan_button:RegisterForClicks("LeftButtonUp")
	scan_button:SetScript("OnClick",
			      function(self, button, down)
				      local cur_profession = GetTradeSkillLine()
				      local MainPanel = addon.Frame
				      local prev_profession

				      if MainPanel then
					      prev_profession = MainPanel.prof_name or private.ordered_professions[MainPanel.profession]
				      end

				      local shift_key = _G.IsShiftKeyDown()
				      local alt_key = _G.IsAltKeyDown()
				      local ctrl_key = _G.IsControlKeyDown()

				      if shift_key and not alt_key and not ctrl_key then
					      addon:Scan(true)
				      elseif not shift_key and alt_key and not ctrl_key then
					      addon:ClearWaypoints()
				      elseif not shift_key and not alt_key and not ctrl_key then
					      if MainPanel and MainPanel:IsVisible() and prev_profession == cur_profession then
						      MainPanel:Hide()
					      else
						      addon:Scan(false)
						      addon:AddWaypoint()
					      end
				      end
			      end)

	scan_button:SetScript("OnEnter",
			      function(self)
				      GameTooltip_SetDefaultAnchor(GameTooltip, self)
				      GameTooltip:SetText(L["SCAN_RECIPES_DESC"])
				      GameTooltip:Show()
			      end)
	scan_button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	scan_button:SetText(L["Scan"])

	self.scan_button = scan_button

	-------------------------------------------------------------------------------
	-- Populate the profession initialization functions.
	-------------------------------------------------------------------------------
	PROFESSION_INITS[GetSpellInfo(51304)] = addon.InitAlchemy
	PROFESSION_INITS[GetSpellInfo(51300)] = addon.InitBlacksmithing
	PROFESSION_INITS[GetSpellInfo(51296)] = addon.InitCooking
	PROFESSION_INITS[GetSpellInfo(51313)] = addon.InitEnchanting
	PROFESSION_INITS[GetSpellInfo(51306)] = addon.InitEngineering
	PROFESSION_INITS[GetSpellInfo(45542)] = addon.InitFirstAid
	PROFESSION_INITS[GetSpellInfo(51302)] = addon.InitLeatherworking
	PROFESSION_INITS[GetSpellInfo(32606)] = addon.InitSmelting
	PROFESSION_INITS[GetSpellInfo(51309)] = addon.InitTailoring
	PROFESSION_INITS[GetSpellInfo(51311)] = addon.InitJewelcrafting
	PROFESSION_INITS[GetSpellInfo(45363)] = addon.InitInscription
	PROFESSION_INITS[private.runeforging_name] = addon.InitRuneforging

	-------------------------------------------------------------------------------
	-- Hook GameTooltip so we can show information on mobs that drop/sell/train
	-------------------------------------------------------------------------------
        GameTooltip:HookScript("OnTooltipSetUnit",
		       function(self)
			       if not addon.db.profile.recipes_in_tooltips then
				       return
			       end
			       local name, unit = self:GetUnit()

			       if not unit then
				       return
			       end
			       local guid = UnitGUID(unit)

			       if not guid then
				       return
			       end
			       local GUID = tonumber(string.sub(guid, 8, 12), 16)
			       local unit = private.mob_list[GUID] or private.vendor_list[GUID] or private.trainer_list[GUID]

			       if not unit or not unit.item_list then
				       return
			       end
			       local recipe_list = private.recipe_list
			       local shifted = _G.IsShiftKeyDown()
			       local count = 0

			       for spell_id in pairs(unit.item_list) do
				       local recipe = recipe_list[spell_id]
				       local recipe_prof = GetSpellInfo(recipe.profession)
				       local scanned = Player.has_scanned[recipe_prof]

				       if scanned then
					       local skill_level = Player.professions[recipe_prof]
					       local has_level = skill_level and (type(skill_level) == "boolean" and true or skill_level >= recipe.skill_level)

					       if ((not recipe:HasState("KNOWN") and has_level) or shifted) and Player:HasRecipeFaction(recipe) then
						       local _, _, _, hex = GetItemQualityColor(recipe.quality)

						       self:AddLine(string.format("%s: %s%s|r (%d)", recipe.profession, hex, recipe.name, recipe.skill_level))
						       count = count + 1
					       end
				       end

				       if count >= addon.db.profile.max_recipes_in_tooltips then
					       break
				       end
			       end
		       end)
end

---Function run when the addon is enabled.  Registers events and pre-loads certain variables.
function addon:OnEnable()
	self:RegisterEvent("TRADE_SKILL_SHOW")	-- Make addon respond to the tradeskill windows being shown
	self:RegisterEvent("TRADE_SKILL_CLOSE")	-- Addon responds to tradeskill windows being closed.
	self:RegisterEvent("TRADE_SKILL_UPDATE")

	if addon.db.profile.scantrainers then
		self:RegisterEvent("TRAINER_SHOW")
	end

	if addon.db.profile.scanvendors then
		self:RegisterEvent("MERCHANT_SHOW")
	end

	-------------------------------------------------------------------------------
	-- Set the parent and scripts for addon.scan_button.
	-------------------------------------------------------------------------------
	local scan_button = self.scan_button

	if Skillet and Skillet:IsActive() then
		scan_button:SetParent(SkilletFrame)
		Skillet:AddButtonToTradeskillWindow(scan_button)
		scan_button:SetWidth(80)
	elseif MRTUIUtils_RegisterWindowOnShow then
		MRTUIUtils_RegisterWindowOnShow(function()
							scan_button:SetParent(MRTSkillFrame)
							scan_button:ClearAllPoints()
							scan_button:SetPoint("RIGHT", MRTSkillFrameCloseButton, "LEFT", 4, 0)
							scan_button:SetWidth(scan_button:GetTextWidth() + 10)
							scan_button:Show()
						end)
  	elseif ATSWFrame then
		scan_button:SetParent(ATSWFrame)
		scan_button:ClearAllPoints()

		if TradeJunkieMain and TJ_OpenButtonATSW then
			scan_button:SetPoint("RIGHT", TJ_OpenButtonATSW, "LEFT", 0, 0)
		else
			scan_button:SetPoint("RIGHT", ATSWOptionsButton, "LEFT", 0, 0)
		end
		scan_button:SetHeight(ATSWOptionsButton:GetHeight())
		scan_button:SetWidth(ATSWOptionsButton:GetWidth())
	elseif CauldronFrame then
		scan_button:SetParent(CauldronFrame)
		scan_button:ClearAllPoints()
		scan_button:SetPoint("TOP", CauldronFrame, "TOPRIGHT", -58, -52)
		scan_button:SetWidth(90)
	end

	local buttonparent = scan_button:GetParent()
	local framelevel = buttonparent:GetFrameLevel()
	local framestrata = buttonparent:GetFrameStrata()

	-- Set the frame level of the button to be 1 deeper than its parent
	scan_button:SetFrameLevel(framelevel + 1)
	scan_button:SetFrameStrata(framestrata)
	scan_button:Enable()

	-- Add an option so that ARL will work with Manufac
	if Manufac then
		Manufac.options.args.ARLScan = {
			type = 'execute',
			name = L["Scan"],
			desc = L["SCAN_RECIPES_DESC"],
			func = function() addon:Scan(false) end,
			order = 550,
		}
	end

	-------------------------------------------------------------------------------
	-- Initialize the player's data.
	-------------------------------------------------------------------------------
	do
		Player.faction = UnitFactionGroup("player")
		Player["Class"] = select(2, UnitClass("player"))

		-------------------------------------------------------------------------------
		-- Get the player's professions.
		-------------------------------------------------------------------------------
		Player.professions = {
			[GetSpellInfo(51304)]	= false, -- Alchemy
			[GetSpellInfo(51300)]	= false, -- Blacksmithing
			[GetSpellInfo(51296)]	= false, -- Cooking
			[GetSpellInfo(51313)]	= false, -- Enchanting
			[GetSpellInfo(51306)]	= false, -- Engineering
			[GetSpellInfo(45542)]	= false, -- First Aid
			[GetSpellInfo(51302)]	= false, -- Leatherworking
			[GetSpellInfo(2656)]	= false, -- Smelting
			[GetSpellInfo(51309)]	= false, -- Tailoring
			[GetSpellInfo(51311)]	= false, -- Jewelcrafting
			[GetSpellInfo(45363)]	= false, -- Inscription
			[private.runeforging_name]	= false, -- Runeforging
		}
		Player:SetProfessions()

		-------------------------------------------------------------------------------
		-- Set the scanned state for all professions to false.
		-------------------------------------------------------------------------------
		Player.has_scanned = {}

		for profession in pairs(Player.professions) do
			Player.has_scanned[profession] = false
		end

	end	-- do

	-------------------------------------------------------------------------------
	-- Initialize the SpecialtyTable and AllSpecialtiesTable.
	-------------------------------------------------------------------------------
	do
		local AlchemySpec = {
			[GetSpellInfo(28674)] = 28674,
			[GetSpellInfo(28678)] = 28678,
			[GetSpellInfo(28676)] = 28676,
		}

		local BlacksmithSpec = {
			[GetSpellInfo(9788)] = 9788,	-- Armorsmith
			[GetSpellInfo(17041)] = 17041,	-- Master Axesmith
			[GetSpellInfo(17040)] = 17040,	-- Master Hammersmith
			[GetSpellInfo(17039)] = 17039,	-- Master Swordsmith
			[GetSpellInfo(9787)] = 9787,	-- Weaponsmith
		}

		local EngineeringSpec = {
			[GetSpellInfo(20219)] = 20219, -- Gnomish
			[GetSpellInfo(20222)] = 20222, -- Goblin
		}

		local LeatherworkSpec = {
			[GetSpellInfo(10657)] = 10657, -- Dragonscale
			[GetSpellInfo(10659)] = 10659, -- Elemental
			[GetSpellInfo(10661)] = 10661, -- Tribal
		}

		local TailorSpec = {
			[GetSpellInfo(26797)] = 26797, -- Spellfire
			[GetSpellInfo(26801)] = 26801, -- Shadoweave
			[GetSpellInfo(26798)] = 26798, -- Primal Mooncloth
		}

		SpecialtyTable = {
			[GetSpellInfo(51304)] = AlchemySpec,
			[GetSpellInfo(51300)] = BlacksmithSpec,
			[GetSpellInfo(51306)] = EngineeringSpec,
			[GetSpellInfo(51302)] = LeatherworkSpec,
			[GetSpellInfo(51309)] = TailorSpec,
		}

		-- Populate the Specialty table with all Specialties, adding alchemy even though no recipes have alchemy filters
		for i in pairs(AlchemySpec) do AllSpecialtiesTable[i] = true end
		for i in pairs(BlacksmithSpec) do AllSpecialtiesTable[i] = true end
		for i in pairs(EngineeringSpec) do AllSpecialtiesTable[i] = true end
		for i in pairs(LeatherworkSpec) do AllSpecialtiesTable[i] = true end
		for i in pairs(TailorSpec) do AllSpecialtiesTable[i] = true end
	end	-- do
end

---Run when the addon is disabled. Ace3 takes care of unregistering events, etc.
function addon:OnDisable()
	if addon.Frame then
		addon.Frame:Hide()
	end

	-- Remove the option from Manufac
	if Manufac then
		Manufac.options.args.ARLScan = nil
	end
end

-------------------------------------------------------------------------------
-- Event handling functions
-------------------------------------------------------------------------------

---Event used for datamining when a trainer is shown.
function addon:TRAINER_SHOW()
	self:ScanSkillLevelData(true)
	self:ScanTrainerData(true)
end

---Event used for datamining when a vendor is shown.
function addon:MERCHANT_SHOW()
	addon:ScanVendor()
end

do
	local GetTradeSkillListLink = _G.GetTradeSkillListLink
	local UnitName = _G.UnitName
	local GetRealmName = _G.GetRealmName
	local IsTradeSkillLinked = _G.IsTradeSkillLinked

	function addon:TRADE_SKILL_SHOW()
		-- If this is our own skill, save it, if not don't save it
		if not IsTradeSkillLinked() then
			local tradelink = GetTradeSkillListLink()

			if tradelink then
				local pname = UnitName("player")
				local prealm = GetRealmName()
				local tradename = GetTradeSkillLine()

				-- Actual alt information saved here. -Torhal
				addon.db.global.tradeskill = addon.db.global.tradeskill or {}
				addon.db.global.tradeskill[prealm] = addon.db.global.tradeskill[prealm] or {}
				addon.db.global.tradeskill[prealm][pname] = addon.db.global.tradeskill[prealm][pname] or {}

				addon.db.global.tradeskill[prealm][pname][tradename] = tradelink
			end
		end
		local scan_button = self.scan_button
		local scan_parent = scan_button:GetParent()

		if not scan_parent or scan_parent == UIParent then
			scan_button:SetParent(TradeSkillFrame)
			scan_parent = scan_button:GetParent()
		end

		if scan_parent == TradeSkillFrame then
			scan_button:ClearAllPoints()

			local loc = addon.db.profile.scanbuttonlocation

			if loc == "TR" then
				scan_button:SetPoint("RIGHT", TradeSkillFrameCloseButton, "LEFT",4,0)
			elseif loc == "TL" then
				scan_button:SetPoint("LEFT", TradeSkillFramePortrait, "RIGHT",2,12)
			elseif loc == "BR" then
				scan_button:SetPoint("TOP", TradeSkillCancelButton, "BOTTOM",0,-5)
			elseif loc == "BL" then
				scan_button:SetPoint("TOP", TradeSkillCreateAllButton, "BOTTOM",0,-5)
			end
			scan_button:SetWidth(scan_button:GetTextWidth() + 10)
		end
		scan_button:Show()
	end
end

function addon:TRADE_SKILL_CLOSE()
	if self.Frame and addon.db.profile.closeguionskillclose then
		self.Frame:Hide()
	end

	if not Skillet then
		addon.scan_button:Hide()
	end
end

do
	local last_update = 0
	local updater = CreateFrame("Frame", nil, UIParent)

	updater:Hide()
	updater:SetScript("OnUpdate",
			  function(self, elapsed)
				  last_update = last_update + elapsed

				  if last_update >= 0.5 then
					  local profession = GetTradeSkillLine()

					  if profession ~= "UNKNOWN" then
						  addon:Scan(false, true)
					  end
					  self:Hide()
				  end
			  end)

	function addon:TRADE_SKILL_UPDATE(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
		if not self.Frame or not self.Frame:IsVisible() then
			return
		end

		if not updater:IsVisible() then
			last_update = 0
			updater:Show()
		end
	end
end

-------------------------------------------------------------------------------
-- Tradeskill functions
-- Recipe DB Structures are defined in Documentation.lua
-------------------------------------------------------------------------------

do
	local SF = private.recipe_state_flags

	-------------------------------------------------------------------------------
	-- Recipe methods.
	-------------------------------------------------------------------------------
	local function Recipe_HasState(self, state_name)
		return self.state and (bit.band(self.state, SF[state_name]) == SF[state_name]) or false
	end

	local function Recipe_AddState(self, state_name)
		if not self.state then
			self.state = 0
		end

		if bit.band(self.state, SF[state_name]) == SF[state_name] then
			return
		end
		self.state = bit.bxor(self.state, SF[state_name])
	end

	local function Recipe_RemoveState(self, state_name)
		if not self.state then
			return
		end

		if bit.band(self.state, SF[state_name]) ~= SF[state_name] then
			return
		end
		self.state = bit.bxor(self.state, SF[state_name])

		if self.state == 0 then
			self.state = nil
		end
	end

	local BITFIELD_MAP = {
		["common1"]	= private.common_flags_word1,
		["class1"]	= private.class_flags_word1,
		["reputation1"]	= private.rep_flags_word1,
		["reputation2"]	= private.rep_flags_word2,
		["item1"]	= private.item_flags_word1,
	}

	local function Recipe_IsFlagged(self, field_name, flag_name)
		local bitfield = self.flags[field_name]
		local bitset = BITFIELD_MAP[field_name]
		local value = bitset[flag_name]

		return bitfield and (bit.band(bitfield, value) == value) or false
	end
	local SKILL_LEVEL_FORMAT = "[%d]"
	local SPELL_ENCHANTING = GetSpellInfo(51313)

	local function Recipe_GetDisplayName(recipe_entry)
		local _, _, _, quality_color = GetItemQualityColor(recipe_entry.quality)
		local recipe_name = recipe_entry.name

		if private.ordered_professions[addon.Frame.profession] == SPELL_ENCHANTING then
			recipe_name = string.gsub(recipe_name, _G.ENSCRIBE.." ", "")
		end
		local recipe_string = string.format("%s%s|r", quality_color, recipe_name)
		local skill_level = Player["ProfessionLevel"]
		local recipe_level = recipe_entry.skill_level
		local has_faction = Player:HasProperRepLevel(recipe_entry.acquire_data[A.REPUTATION])

		local diff_color

		if not has_faction or recipe_level > skill_level then
			diff_color = "impossible"
		elseif skill_level >= recipe_entry.trivial_level then
			diff_color = "trivial"
		elseif skill_level >= recipe_entry.easy_level then
			diff_color = "easy"
		elseif skill_level >= recipe_entry.medium_level then
			diff_color = "medium"
		elseif skill_level >= recipe_entry.optimal_level then
			diff_color = "optimal"
		else
			--[===[@debug@
			addon:Debug("Skill level color fallback: %s.", recipe_string)
			--@end-debug@]===]
			diff_color = "trivial"
		end
		local level_text = string.format(private.SetTextColor(private.difficulty_colors[diff_color], SKILL_LEVEL_FORMAT), recipe_level)

		local skill_view = addon.db.profile.skill_view

		recipe_string = skill_view and string.format("%s - %s", level_text, recipe_string) or string.format("%s - %s", recipe_string, level_text)

		if addon.db.profile.exclusionlist[recipe_entry.spell_id] then
			recipe_string = string.format("** %s **", recipe_string)
		end
		return recipe_string
	end

	--- Adds a tradeskill recipe into the specified recipe database
	-- @name AckisRecipeList:AddRecipe
	-- @usage AckisRecipeList:AddRecipe(28927, 305, 23109, Q.UNCOMMON, V.TBC, 305, 305, 325, 345)
	-- @param spell_id The [[http://www.wowwiki.com/SpellLink|Spell ID]] of the recipe being added to the database
	-- @param skill_level The skill level at which the recipe can be initially learned
	-- @param item_id The [[http://www.wowwiki.com/ItemLink|Item ID]] that is created by the recipe, or nil
	-- @param quality The quality/rarity of the recipe
	-- @param profession The profession ID that uses the recipe.  See [[API/database-documentation]] for a listing of profession IDs
	-- @param specialty The specialty that uses the recipe (ie: goblin engineering) or nil or blank
	-- @param genesis Game version that the recipe was first introduced in, for example, Original, BC, or WoTLK
	-- @param optimal_level Level at which recipe is considered orange
	-- @param medium_level Level at which recipe is considered yellow
	-- @param easy_level Level at which recipe is considered green
	-- @param trivial_level Level at which recipe is considered grey
	-- @return None, array is passed as a reference
	function addon:AddRecipe(spell_id, skill_level, item_id, quality, profession, specialty, genesis, optimal_level, medium_level, easy_level, trivial_level)
		local recipe_list = private.recipe_list

		if recipe_list[spell_id] then
			--@alpha@
			self:Print("Duplicate recipe: "..recipe_list[spell_id].profession.." "..tostring(spell_id).." "..recipe_list[spell_id].name)
			--@end-alpha@
			return
		end

		local recipe = {
			["spell_id"]		= spell_id,
			["skill_level"]		= skill_level,
			["item_id"]		= item_id,
			["quality"]		= quality,
			["profession"]		= GetSpellInfo(profession),
			["name"]		= GetSpellInfo(spell_id),
			["flags"]		= {},
			["acquire_data"]	= {},
			["specialty"]		= specialty,			-- Assumption: there will only be 1 speciality for a trade skill
			["genesis"]		= private.game_version_names[genesis],
			["optimal_level"]	= optimal_level or skill_level,
			["medium_level"]	= medium_level or skill_level + 10,
			["easy_level"]		= easy_level or skill_level + 15,
			["trivial_level"]	= trivial_level or skill_level + 20,

			-- Function members
			["HasState"]		= Recipe_HasState,
			["AddState"]		= Recipe_AddState,
			["RemoveState"]		= Recipe_RemoveState,
			["IsFlagged"]		= Recipe_IsFlagged,
			["GetDisplayName"]	= Recipe_GetDisplayName,
		}

		if not recipe.name then
			self:Print(strformat(L["SpellIDCache"], spell_id))
		end
		recipe_list[spell_id] = recipe
	end
end	-- do

-- Public API function for retrieving specific information about a recipe.
-- @name AckisRecipeList:GetRecipeData
-- @usage AckisRecipeList:GetRecipeData(28972, "profession")
-- @param spell_id The [[http://www.wowwiki.com/SpellLink|Spell ID]] of the recipe being queried.
-- @param data Which member of the recipe table is being queried.
-- @return Variable, depending upon which member of the recipe table is queried.
function addon:GetRecipeData(spell_id, data)
	local recipe = private.recipe_list[spell_id]
	return recipe and recipe[data] or nil
end

--- Adds filtering flags to a specific tradeskill.
-- @name AckisRecipeList:AddRecipeFlags
-- @usage AckisRecipeList:AddRecipeFlags(28927, F.ALLIANCE, F.VENDOR, F.IBOE, F.RBOP, F.HEALER, F.CASTER, F.ALDOR)
-- @param spell_id The [[http://www.wowwiki.com/SpellLink|Spell ID]] of the recipe which the filter flags are being added to
-- @param ... A listing of filtering flags.  See [[API/database-documentation]] for a listing of filter flags
-- @return None, array is passed as a reference.
function addon:AddRecipeFlags(spell_id, ...)
	local num_flags = select('#',...)
	local recipe = private.recipe_list[spell_id]

	for index = 1, num_flags, 1 do
		local flag = select(index, ...)
		local flag_name = private.filter_strings[flag]

		local bitfield
		local member_name

		for table_index, bits in ipairs(private.bit_flags) do
			if bits[flag_name] then
				bitfield = bits
				member_name = private.flag_members[table_index]
			end
		end

		if not bitfield or not member_name then
			return
		end

		if not recipe.flags[member_name] then
			recipe.flags[member_name] = 0
		end
		recipe.flags[member_name] = bit.bxor(recipe.flags[member_name], bitfield[flag_name])
	end
end

--- Adds acquire methods to a specific tradeskill.
-- @name AckisRecipeList:AddRecipeAcquire
-- @usage AckisRecipeList:AddRecipeAcquire(28927, A.REPUTATION, FAC.ALDOR, REP.HONORED, 19321)
-- @param spell_id The [[http://www.wowwiki.com/SpellLink|Spell ID]] of the recipe which acquire methods are being added to
-- @param ... A listing of acquire methods.  See [[API/database-documentation]] for a listing of acquire methods and how they work
-- @return None, array is passed as a reference.
do
	local location_list = private.location_list
	local acquire_list = private.acquire_list

	function addon:AddRecipeAcquire(spell_id, ...)
		local numvars = select('#', ...)	-- Find out how many flags we're adding
		local i = 1				-- Index for which variables we're parsing through
		local recipe_list = private.recipe_list
		local acquire_data = recipe_list[spell_id].acquire_data

		while i <= numvars do
			local location, affiliation

			local acquire_type, acquire_id = select(i, ...)
			i = i + 2

			if not acquire_type then
				self:Debug("Spell ID: %d has no acquire type.", spell_id)
			else
				acquire_data[acquire_type] = acquire_data[acquire_type] or {}

				local acquire = acquire_data[acquire_type]

				if not acquire_id then
					self:Debug("Spell ID %d: %s ID is nil.", spell_id, private.acquire_strings[acquire_type])
				else
					if acquire_type == A.TRAINER then
						local trainer_list = private.trainer_list
						local trainer = trainer_list[acquire_id]

						if not trainer then
							self:Debug("Spell ID "..spell_id..": TrainerID "..acquire_id.." does not exist in the database.")
						else
							acquire[acquire_id] = true

							affiliation = trainer.faction
							location = trainer.location

							trainer.item_list = trainer.item_list or {}
							trainer.item_list[spell_id] = true
						end
					elseif acquire_type == A.VENDOR then
						local vendor_list = private.vendor_list
						local vendor = vendor_list[acquire_id]

						if not vendor then
							self:Debug("Spell ID "..spell_id..": VendorID "..acquire_id.." does not exist in the database.")
						else
							acquire[acquire_id] = true

							affiliation = vendor.faction
							location = vendor.location

							vendor.item_list = vendor.item_list or {}
							vendor.item_list[spell_id] = true
						end
					elseif acquire_type == A.MOB_DROP then
						local mob_list = private.mob_list
						local mob = mob_list[acquire_id]

						if not mob then
							self:Debug("Spell ID "..spell_id..": Mob ID "..acquire_id.." does not exist in the database.")
						else
							acquire[acquire_id] = true

							affiliation = mob.faction
							location = mob.location

							mob_list[acquire_id].item_list = mob_list[acquire_id].item_list or {}
							mob_list[acquire_id].item_list[spell_id] = true
						end
					elseif acquire_type == A.QUEST then
						local quest_list = private.quest_list
						local quest = quest_list[acquire_id]

						if not quest then
							self:Debug("Spell ID "..spell_id..": Quest ID "..acquire_id.." does not exist in the database.")
						else
							acquire[acquire_id] = true

							affiliation = quest.faction
							location = quest.location
						end
					elseif acquire_type == A.REPUTATION then
						local vendor_list = private.vendor_list
						local rep_level, vendor_id = select(i, ...)
						i = i + 2

						if not private.reputation_list[acquire_id] then
							self:Debug("Spell ID "..spell_id..": ReputationID "..acquire_id.." does not exist in the database.")
						else
							if not vendor_id then
								self:Debug("Spell ID "..spell_id..": Reputation Vendor ID is nil.")
							elseif not vendor_list[vendor_id] then
								self:Debug("Spell ID "..spell_id..": Reputation Vendor ID "..vendor_id.." does not exist in the database.")
							else
								acquire[acquire_id] = acquire[acquire_id] or {}

								local faction = acquire[acquire_id]
								faction[rep_level] = faction[rep_level] or {}
								faction[rep_level][vendor_id] = true

								local rep_vendor = vendor_list[vendor_id]

								affiliation = rep_vendor.faction
								location = rep_vendor.location

								rep_vendor.item_list = rep_vendor.item_list or {}
								rep_vendor.item_list[spell_id] = true
							end
						end
					elseif acquire_type == A.WORLD_DROP then
						acquire[acquire_id] = true
						location = type(acquire_id) == "string" and BZ[acquire_id] or nil

						if location then
							affiliation = "world_drop"
						else
							addon:Debug("WORLD_DROP with no location: %d %s", spell_id, recipe_list[spell_id].name)
						end
					elseif acquire_type == A.SEASONAL then
						acquire[acquire_id] = true
					elseif acquire_type == A.CUSTOM then
						acquire[acquire_id] = true
						location = private.custom_list[acquire_id].location
					else
						-- Unhandled acquire_type
						acquire[acquire_id] = true
						location = private.acquire_strings[acquire_type] or _G.UNKNOWN
					end
				end	-- acquire_id
				acquire_list[acquire_type] = acquire_list[acquire_type] or {}
				acquire_list[acquire_type].recipes = acquire_list[acquire_type].recipes or {}

				acquire_list[acquire_type].name = private.acquire_names[acquire_type]
				acquire_list[acquire_type].recipes[spell_id] = affiliation or true
			end	-- acquire_type

			if location then
				location_list[location] = location_list[location] or {}
				location_list[location].recipes = location_list[location].recipes or {}

				location_list[location].name = location
				location_list[location].recipes[spell_id] = affiliation or true
			end
		end	-- while
	end

	local function GenericAddRecipeAcquire(spell_id, acquire_type, type_string, unit_list, ...)
		local num_vars = select('#', ...)
		local cur_var = 1
		local recipe = private.recipe_list[spell_id]

		local acquire_data = recipe.acquire_data
		acquire_data[acquire_type] = acquire_data[acquire_type] or {}

		local acquire = acquire_data[acquire_type]

		while cur_var <= num_vars do
			local location, affiliation
			local id_num = select(cur_var, ...)
			cur_var = cur_var + 1

			-- A quantity of true means unlimited - normal vendor item.
			local quantity = true

			if type_string == "Limited Vendor" then
				quantity = select(cur_var, ...)
				cur_var = cur_var + 1
			end
			acquire[id_num] = true

			if unit_list and not unit_list[id_num] then
				addon:Debug("Spell ID %d: %s ID %d does not exist in the database.", spell_id, type_string, id_num)
			else
				if not unit_list then
					location = type(id_num) == "string" and BZ[id_num] or nil

					if location then
						affiliation = "world_drop"
					else
						addon:Debug("WORLD_DROP with no location: %d %s", spell_id, private.recipe_list[spell_id].name)
					end
				else
					local unit = unit_list[id_num]

					affiliation = unit.faction
					location = unit.location

					unit.item_list = unit.item_list or {}
					unit.item_list[spell_id] = quantity
				end
			end
			acquire_list[acquire_type] = acquire_list[acquire_type] or {}
			acquire_list[acquire_type].recipes = acquire_list[acquire_type].recipes or {}

			acquire_list[acquire_type].name = private.acquire_names[acquire_type]
			acquire_list[acquire_type].recipes[spell_id] = affiliation or true

			if location then
				location_list[location] = location_list[location] or {}
				location_list[location].recipes = location_list[location].recipes or {}

				location_list[location].name = location
				location_list[location].recipes[spell_id] = affiliation or true
			end
		end
	end

	function addon:AddRecipeMobDrop(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.MOB_DROP, "Mob", private.mob_list, ...)
	end

	function addon:AddRecipeTrainer(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.TRAINER, "Trainer", private.trainer_list, ...)
	end

	function addon:AddRecipeVendor(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.VENDOR, "Vendor", private.vendor_list, ...)
	end

	function addon:AddRecipeLimitedVendor(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.VENDOR, "Limited Vendor", private.vendor_list, ...)
	end

	function addon:AddRecipeWorldDrop(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.WORLD_DROP, nil, nil, ...)
	end

	function addon:AddRecipeQuest(spell_id, ...)
		GenericAddRecipeAcquire(spell_id, A.QUEST, "Quest", private.quest_list, ...)
	end

	-- This function can NOT use GenericAddRecipeAcquire() - reputation vendors are more complicated than the other acquire types.
	function addon:AddRecipeRepVendor(spell_id, faction_id, rep_level, ...)
		local num_vars = select('#', ...)
		local cur_var = 1

		local recipe = private.recipe_list[spell_id]
		local vendor_list = private.vendor_list

		local acquire_data = recipe.acquire_data
		acquire_data[A.REPUTATION] = acquire_data[A.REPUTATION] or {}

		local acquire = acquire_data[A.REPUTATION]
		acquire[faction_id] = acquire[faction_id] or {}

		local faction = acquire[faction_id]
		faction[rep_level] = faction[rep_level] or {}

		while cur_var <= num_vars do
			local location, affiliation
			local vendor_id = select(cur_var, ...)
			cur_var = cur_var + 1

			if not private.reputation_list[faction_id] then
				--@alpha@
				self:Printf("Spell ID %d: Faction ID %d does not exist in the database.", spell_id, faction_id)
				--@end-alpha@
			else
				if not vendor_id then
					--@alpha@
					self:Print("Spell ID "..spell_id..": Reputation Vendor ID is nil.")
					--@end-alpha@
				elseif not vendor_list[vendor_id] then
					--@alpha@
					self:Print("Spell ID "..spell_id..": Reputation Vendor ID "..vendor_id.." does not exist in the database.")
					--@end-alpha@
				else
					faction[rep_level][vendor_id] = true

					local rep_vendor = vendor_list[vendor_id]

					affiliation = rep_vendor.faction
					location = rep_vendor.location

					rep_vendor.item_list = rep_vendor.item_list or {}
					rep_vendor.item_list[spell_id] = true
				end
			end
			acquire_list[A.REPUTATION] = acquire_list[A.REPUTATION] or {}
			acquire_list[A.REPUTATION].recipes = acquire_list[A.REPUTATION].recipes or {}

			acquire_list[A.REPUTATION].name = private.acquire_names[A.REPUTATION]
			acquire_list[A.REPUTATION].recipes[spell_id] = affiliation or true

			if location then
				location_list[location] = location_list[location] or {}
				location_list[location].recipes = location_list[location].recipes or {}

				location_list[location].name = location
				location_list[location].recipes[spell_id] = affiliation or true
			end
		end
	end
end	-- do block

--- Adds an item to a specific database listing (ie: vendor, mob, etc)
-- @name AckisRecipeList:addLookupList
-- @usage AckisRecipeList:addLookupList(DB,NPC ID, NPC Name, NPC Location, X Coord, Y Coord, Faction)
-- @param DB Database which the entry will be stored
-- @param ID Unique identified for the entry
-- @param name Name of the entry
-- @param location Location of the entry in the world
-- @param coord_x X coordinate of where the entry is found
-- @param coord_y Y coordinate of where the entry is found
-- @param faction Faction identifier for the entry
-- @return None, array is passed as a reference
-- For individual database structures, see Documentation.lua
do
	local FACTION_NAMES = {
		[1]	= BFAC["Neutral"],
		[2]	= BFAC["Alliance"],
		[3]	= BFAC["Horde"]
	}
	function addon:addLookupList(DB, ID, name, location, coord_x, coord_y, faction)
		if DB[ID] then
			self:Debug("Duplicate lookup: %d - %s.", ID, name)
			return
		end

		DB[ID] = {
			["name"]	= name,
			["location"]	= location,
			["faction"]	= faction and FACTION_NAMES[faction + 1] or FACTION_NAMES[1]
		}

		if coord_x and coord_y then
			DB[ID]["coord_x"] = coord_x
			DB[ID]["coord_y"] = coord_y
		end

		--@alpha@
		if not location and DB ~= private.custom_list then
			self:Debug("Lookup ID: %d (%s) has an unknown location.", ID, DB[ID].name or _G.UNKNOWN)
		end

		if faction and DB == private.mob_list then
			self:Debug("Mob %d (%s) has been assigned to faction %s.", ID, name, DB[ID].faction)
		end
		--@end-alpha@
	end
end	-- do

-------------------------------------------------------------------------------
-- ARL Logic Functions
-------------------------------------------------------------------------------
function addon:InitializeProfession(profession)
	if not profession then
		--@alpha@
		addon:Print("nil profession passed to InitializeProfession()")
		--@end-alpha@
		return
	end

	if profession == private.professions["Smelting"] then
		profession = private.mining_name
	end
	local func = PROFESSION_INITS[profession]

	if func then
		return func(addon)
	else
		addon:Print(L["UnknownTradeSkill"]:format(profession))
		return 0
	end
end

-- Determines what to do when the slash command is called.
function addon:ChatCommand(input)

	-- Open About panel if there's no parameters or if we do /arl about
	if not input or (input and input:trim() == "") or input == strlower(L["Sorting"]) or input == strlower(L["Sort"])  or input == strlower(_G.DISPLAY) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	elseif (input == strlower(L["About"])) then
		if (self.optionsFrame["About"]) then
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["About"])
		else
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		end
	elseif (input == strlower(L["Profile"])) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["Profiles"])
	elseif (input == strlower(_G.FILTER)) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["Filters"])
	elseif (input == strlower(L["Documentation"])) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["Documentation"])
	elseif (input == strlower(L["Scan"])) then
		self:Scan(false)
	elseif (input == strlower("scandata")) then
		self:ScanSkillLevelData()
	elseif (input == strlower("scanprof")) then
		self:ScanProfession("all")
	elseif (input == strlower("tradelinks")) then
		self:GenerateLinks()
	else
		-- What happens when we get here?
		LibStub("AceConfigCmd-3.0"):HandleCommand("arl", "Ackis Recipe List", input)
	end

end

--- Public API function to initialize all of the lookup lists - self-nils once run.
-- @name AckisRecipeList:InitializeLookups()
-- @usage if AckisRecipeList.InitializeLookups then AckisRecipeList:InitializeLookups() end
function addon:InitializeLookups()
	self:InitCustom(private.custom_list)
	self:InitMob(private.mob_list)
	self:InitQuest(private.quest_list)
	self:InitReputation(private.reputation_list)
	self:InitTrainer(private.trainer_list)
	self:InitSeasons(private.seasonal_list)
	self:InitVendor(private.vendor_list)

	self.InitializeLookups = nil
end

-------------------------------------------------------------------------------
-- Recipe Scanning Functions
-------------------------------------------------------------------------------
do
	-- List of tradeskill headers, used in addon:Scan()
	local header_list = {}

	--- Causes a scan of the tradeskill to be conducted. Function called when the scan button is clicked.   Parses recipes and displays output
	-- @name AckisRecipeList:Scan
	-- @usage AckisRecipeList:Scan(true)
	-- @param textdump Boolean indicating if we want the output to be a text dump, or if we want to use the ARL GUI
	-- @return A frame with either the text dump, or the ARL frame
	function addon:Scan(textdump, is_refresh)
		local current_prof, prof_level = GetTradeSkillLine()

		-- Bail if we haven't opened a tradeskill frame.
		if current_prof == "UNKNOWN" then
			self:Print(L["OpenTradeSkillWindow"])
			return
		end

		-- Set the current profession level, and update the cached data.
		Player["ProfessionLevel"] = prof_level

		-- Make sure we're only updating a profession the character actually knows - this could be a scan from a tradeskill link.
		local is_linked = IsTradeSkillLinked()

		if not is_linked and Player.professions[current_prof] then
			Player.professions[current_prof] = prof_level
			Player.has_scanned[current_prof] = true
		end

		-- Get the current profession Specialty
		local specialty = SpecialtyTable[current_prof]

		for index = 1, 25, 1 do
			local spellName = GetSpellName(index, BOOKTYPE_SPELL)

			if not spellName or index == 25 then
				Player["Specialty"] = nil
				break
			elseif specialty and specialty[spellName] then
				Player["Specialty"] = specialty[spellName]
				break
			end
		end

		if self.InitializeLookups then
			self:InitializeLookups()
		end
		-- Add the recipes to the database
		-- TODO: Figure out what this variable was supposed to be for - it isn't used anywhere. -Torhal
		Player.totalRecipes = addon:InitializeProfession(current_prof)

		-------------------------------------------------------------------------------
		-- Scan all recipes and mark the ones we know
		-------------------------------------------------------------------------------
		table.wipe(header_list)

		-- Save the state of the "Have Materials" checkbox.
		local have_materials = TradeSkillFrameAvailableFilterCheckButton:GetChecked()

		if MRTUIUtils_PushFilterSelection then
			MRTUIUtils_PushFilterSelection()
		else
			if not Skillet and TradeSkillFrameAvailableFilterCheckButton:GetChecked() then
				TradeSkillFrameAvailableFilterCheckButton:SetChecked(false)
				TradeSkillOnlyShowMakeable(false)
			end

			-- Clear the inventory slot filter
			UIDropDownMenu_Initialize(TradeSkillInvSlotDropDown, TradeSkillInvSlotDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(TradeSkillInvSlotDropDown, 1)
			SetTradeSkillInvSlotFilter(0, 1, 1)

			-- Clear the sub-classes filters
			UIDropDownMenu_Initialize(TradeSkillSubClassDropDown, TradeSkillSubClassDropDown_Initialize)
			UIDropDownMenu_SetSelectedID(TradeSkillSubClassDropDown, 1)
			SetTradeSkillSubClassFilter(0, 1, 1)

			-- Expand all headers so we can see all the recipes there are
			for i = GetNumTradeSkills(), 1, -1 do
				local name, tradeType, _, isExpanded = GetTradeSkillInfo(i)

				if tradeType == "header" and not isExpanded then
					header_list[name] = true
					ExpandTradeSkillSubClass(i)
				end
			end
		end
		local recipe_list = private.recipe_list
		local recipes_found = 0
		local SF = private.recipe_state_flags

		for i = 1, GetNumTradeSkills() do
			local tradeName, tradeType = GetTradeSkillInfo(i)

			if tradeType ~= "header" then
				-- Get the trade skill link for the specified recipe
				local SpellLink = GetTradeSkillRecipeLink(i)
				local SpellString = strmatch(SpellLink, "^|c%x%x%x%x%x%x%x%x|H%w+:(%d+)")
				local recipe = recipe_list[tonumber(SpellString)]

				if recipe then
					if not is_linked then
						recipe:AddState("KNOWN")
						recipe:RemoveState("LINKED")
					else
						recipe:AddState("LINKED")
					end
					recipes_found = recipes_found + 1
				else
					self:Debug(tradeName .. " " .. SpellString .. L["MissingFromDB"])
				end
			end
		end

		-- Close all the headers we've opened
		-- If Mr Trader is installed use that API
		if MRTUIUtils_PopFilterSelection then
			MRTUIUtils_PopFilterSelection()
		else
			-- Collapse all headers that were collapsed before
			for i = GetNumTradeSkills(), 1, -1 do
				local name, tradeType, _, isExpanded = GetTradeSkillInfo(i)

				if header_list[name] then
					CollapseTradeSkillSubClass(i)
				end
			end
			-- Restore the state of the "Have Materials" checkbox.
			TradeSkillFrameAvailableFilterCheckButton:SetChecked(have_materials)
			TradeSkillOnlyShowMakeable(have_materials)
		end
		Player.prev_count = Player.foundRecipes
		Player.foundRecipes = recipes_found

		if is_refresh and Player.prev_count == recipes_found then
			return
		end

		-------------------------------------------------------------------------------
		-- Update the player's reputation levels.
		-------------------------------------------------------------------------------
		Player["Reputation"] = Player["Reputation"] or {}

		table.wipe(header_list)

		-- Number of factions before expansion
		local num_factions = GetNumFactions()

		-- Expand all the headers, storing those which were collapsed.
		for i = num_factions, 1, -1 do
			local name, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(i)

			if isCollapsed then
				ExpandFactionHeader(i)
				header_list[name] = true
			end
		end

		-- Number of factions with everything expanded
		num_factions = GetNumFactions()

		-- Get the rep levels
		for i = 1, num_factions, 1 do
			local name, _, replevel = GetFactionInfo(i)

			-- If the rep is greater than neutral
			if replevel > 4 then
				-- We use levels of 0, 1, 2, 3, 4 internally for reputation levels, make it correspond here
				Player["Reputation"][name] = replevel - 4
			end
		end

		-- Collapse the headers again
		for i = num_factions, 1, -1 do
			local name = GetFactionInfo(i)

			if header_list[name] then
				CollapseFactionHeader(i)
			end
		end

		-------------------------------------------------------------------------------
		-- Everything is ready - display the GUI or dump the list to text.
		-------------------------------------------------------------------------------
		if textdump then
			self:DisplayTextDump(recipe_list, current_prof)
		else
			if private.InitializeFrame then
				private.InitializeFrame()
			end
			self.Frame:Display(current_prof, is_linked)
		end
	end
end

-------------------------------------------------------------------------------
-- Text dumping functions
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
---- Creates a new frame with the contents of a text dump so you can copy and paste
--- Code borrowed from Antiarc (Chatter) with permission
--- @name AckisRecipeList:DisplayTextDump
--- @param RecipeDB The database (array) which you wish read data from.
--- @param profession Which profession are you displaying data for
--- @param text The text to be dumped
--------------------------------------------------------------------------------
do
	local copy_frame = CreateFrame("Frame", "ARLCopyFrame", UIParent)
	copy_frame:SetBackdrop({
				       bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
				       edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
				       tile = true,
				       tileSize = 16,
				       edgeSize = 16,
				       insets = {
					       left = 3,
					       right = 3,
					       top = 5,
					       bottom = 3
				       }
			       })
	copy_frame:SetBackdropColor(0, 0, 0, 1)
	copy_frame:SetWidth(750)
	copy_frame:SetHeight(400)
	copy_frame:SetPoint("CENTER", UIParent, "CENTER")
	copy_frame:SetFrameStrata("DIALOG")

	table.insert(UISpecialFrames, "ARLCopyFrame")

	local scrollArea = CreateFrame("ScrollFrame", "ARLCopyScroll", copy_frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", copy_frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", copy_frame, "BOTTOMRIGHT", -30, 8)

	local edit_box = CreateFrame("EditBox", nil, copy_frame)
	edit_box:SetMultiLine(true)
	edit_box:SetMaxLetters(0)
	edit_box:EnableMouse(true)
	edit_box:SetAutoFocus(true)
	edit_box:SetFontObject(ChatFontNormal)
	edit_box:SetWidth(650)
	edit_box:SetHeight(270)
	edit_box:SetScript("OnEscapePressed",
			   function()
				   copy_frame:Hide()
			   end)
	edit_box:HighlightText(0)

	scrollArea:SetScrollChild(edit_box)

	local close = CreateFrame("Button", nil, copy_frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", copy_frame, "TOPRIGHT")

	copy_frame:Hide()

	function addon:DisplayTextDump(RecipeDB, profession, text)
		local text = (not RecipeDB and not profession) and text or self:GetTextDump(profession)

		if text ~= "" then
			edit_box:SetText(text)
			edit_box:HighlightText(0)
			edit_box:SetCursorPosition(1)
			copy_frame:Show()
		end
	end
end	-- do

do
	-------------------------------------------------------------------------------
	-- Dumps recipe output in the format requested by the user
	-------------------------------------------------------------------------------
	local text_table = {}
	local acquire_list = {}
	local ACQUIRE_NAMES = private.acquire_names

	local GetFilterNames
	do
		local LC = _G.LOCALIZED_CLASS_NAMES_MALE
		local FILTER_NAMES

		function GetFilterNames()
			if not FILTER_NAMES then
				local is_alliance = (Player.faction == "Alliance")

				FILTER_NAMES = {
					[1]	= BFAC["Alliance"],
					[2]	= BFAC["Horde"],
					[3]	= L["Trainer"],
					[4]	= L["Vendor"],
					[5]	= _G.INSTANCE,
					[6]	= _G.RAID,
					[7]	= _G.EVENTS_LABEL,
					[8]	= L["Quest"],
					[9]	= _G.PVP,
					[10]	= L["World Drop"],
					[11]	= L["Mob Drop"],
					[12]	= L["Discovery"],
					[13]	= L["Retired"],
					[21]	= LC["DEATHKNIGHT"],
					[22]	= LC["DRUID"],
					[23]	= LC["HUNTER"],
					[24]	= LC["MAGE"],
					[25]	= LC["PALADIN"],
					[26]	= LC["PRIEST"],
					[27]	= LC["SHAMAN"],
					[28]	= LC["ROGUE"],
					[29]	= LC["WARLOCK"],
					[30]	= LC["WARRIOR"],
					[36]	= L["BOEFilter"],
					[37]	= L["BOPFilter"],
					[38]	= L["BOAFilter"],
					[40]	= L["RecipeBOEFilter"],
					[41]	= L["RecipeBOPFilter"],
					[42]	= L["RecipeBOAFilter"],
					[51]	= _G.MELEE,
					[52]	= _G.TANK,
					[53]	= _G.HEALER,
					[54]	= _G.DAMAGER,
					[56]	= L["Cloth"],
					[57]	= L["Leather"],
					[58]	= L["Mail"],
					[59]	= L["Plate"],
					[60]	= L["Cloak"],
					[61]	= L["Trinket"],
					[62]	= L["Ring"],
					[63]	= L["Necklace"],
					[64]	= L["Shield"],
					[66]	= L["One Hand"],
					[67]	= L["Two Hand"],
					[68]	= L["Axe"],
					[69]	= L["Sword"],
					[70]	= L["Mace"],
					[71]	= L["Polearm"],
					[72]	= L["Dagger"],
					[73]	= L["Staff"],
					[74]	= L["Wand"],
					[75]	= L["Thrown"],
					[76]	= L["Bow"],
					[77]	= L["Crossbow"],
					[78]	= L["Ammo"],
					[79]	= L["Fist"],
					[80]	= L["Gun"],
					[96]	= BFAC["Argent Dawn"],
					[97]	= BFAC["Cenarion Circle"],
					[98]	= BFAC["Thorium Brotherhood"],
					[99]	= BFAC["Timbermaw Hold"],
					[100]	= BFAC["Zandalar Tribe"],
					[101]	= BFAC["The Aldor"],
					[102]	= BFAC["Ashtongue Deathsworn"],
					[103]	= BFAC["Cenarion Expedition"],
					[104]	= (is_alliance and BFAC["Honor Hold"] or BFAC["Thrallmar"]),
					[105]	= BFAC["The Consortium"],
					[106]	= BFAC["Keepers of Time"],
					[107]	= BFAC["Lower City"],
					[108]	= (is_alliance and BFAC["Kurenai"] or BFAC["The Mag'har"]),
					[109]	= BFAC["The Scale of the Sands"],
					[110]	= BFAC["The Scryers"],
					[111]	= BFAC["The Sha'tar"],
					[112]	= BFAC["Shattered Sun Offensive"],
					[113]	= BFAC["Sporeggar"],
					[114]	= BFAC["The Violet Eye"],
					[115]	= BFAC["Argent Crusade"],
					[116]	= BFAC["Frenzyheart Tribe"],
					[117]	= BFAC["Knights of the Ebon Blade"],
					[118]	= BFAC["Kirin Tor"],
					[119]	= BFAC["The Sons of Hodir"],
					[120]	= BFAC["The Kalu'ak"],
					[121]	= BFAC["The Oracles"],
					[122]	= BFAC["The Wyrmrest Accord"],
					[123]	= (is_alliance and BFAC["The Silver Covenant"] or BFAC["The Sunreavers"]),
					[124]	= (is_alliance and BFAC["Explorers' League"] or BFAC["The Hand of Vengeance"]),
					[125]	= (is_alliance and BFAC["Valiance Expedition"] or BFAC["Warsong Offensive"]),
					[126]	= (is_alliance and BFAC["The Frostborn"] or BFAC["The Taunka"]),
					[127]	= (is_alliance and BFAC["Alliance Vanguard"] or BFAC["Horde Expedition"]),
					[128]	= BFAC["The Ashen Verdict"],
				}
			end
			return FILTER_NAMES
		end
	end	-- do

	---Dumps the recipe database in a format that is readable to humans (or machines)
	function addon:GetTextDump(profession)
		local output = addon.db.profile.textdumpformat
		table.wipe(text_table)

		if not output or output == "Comma" then
			tinsert(text_table, strformat("Ackis Recipe List Text Dump for %s's %s, in the form of Comma Separated Values.\n  ", UnitName("player"), profession))
			tinsert(text_table, "Spell ID,Recipe Name,Skill Level,ARL Filter Flags,Acquire Methods,Known\n")
		elseif output == "BBCode" then
			tinsert(text_table, strformat("Ackis Recipe List Text Dump for %s's %s, in the form of BBCode.\n", UnitName("player"), profession))
		elseif output == "XML" then
			tinsert(text_table, "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>")
		end

		local recipe_list = private.recipe_list
		local SF = private.recipe_state_flags

		for recipe_id in pairs(recipe_list) do
			local recipe = recipe_list[recipe_id]
			local recipe_prof = GetSpellInfo(recipe.profession)
			local is_known = recipe:HasState("KNOWN")

			if recipe_prof == profession then
				-- CSV
				if not output or output == "Comma" then
					-- Add Spell ID, Name and Skill Level to the list
					tinsert(text_table, recipe_id)
					tinsert(text_table, ",")
					tinsert(text_table, recipe.name)
					tinsert(text_table, ",")
					tinsert(text_table, recipe.skill_level)
					tinsert(text_table, ",\"")
				-- BBCode
				elseif output == "BBCode" then
					-- Make the entry red
					if not is_known then
						tinsert(text_table, "[color=red]")
					end
					tinsert(text_table, "\n[b]" .. recipe_id .. "[/b] - " .. recipe.name .. " (" .. recipe.skill_level .. ")\n")

					-- Close Color tag
					if not is_known then
						tinsert(text_table, "[/color]\nRecipe Flags:\n[list]")
					elseif is_known then
						tinsert(text_table, "\nRecipe Flags:\n[list]")
					end
				--XML
				elseif output == "XML" then
					tinsert(text_table, "<recipe>")
					tinsert(text_table, "  <id>..recipe_id..</id>")
					tinsert(text_table, "  <name>"..recipe.name.."</name>")
					tinsert(text_table, "  <skilllevel>..recipe.skill_level..</skilllevel>")
					tinsert(text_table, "  <known>"..tostring(is_known).."</known>")
					tinsert(text_table, "  <flags>")
				--Name
				elseif output == "Name" then
					tinsert(text_table, recipe.name)
				end

				-- Add in all the filter flags
				local filter_names = GetFilterNames()
				local prev = false

				-- Find out which flags are set
				for table_index, bits in ipairs(private.bit_flags) do
					for flag_name, flag in pairs(bits) do
						local bitfield = recipe.flags[private.flag_members[table_index]]

						if bitfield and bit.band(bitfield, flag) == flag then
							if not output or output == "Comma" then
								if prev then
									tinsert(text_table, ",")
								end
								tinsert(text_table, filter_names[private.filter_flags[flag_name]])
								prev = true
								-- BBCode
							elseif output == "BBCode" then
								tinsert(text_table, "[*]"..filter_names[private.filter_flags[flag_name]])
							elseif output == "XML" then
								tinsert(text_table, "    <flag>"..filter_names[private.filter_flags[flag_name]].."</flag>")
							end
						end
					end
				end

				if not output or output == "Comma" then
					tinsert(text_table, "\",\"")
				elseif output == "BBCode" then
					tinsert(text_table, "[/list]\nAcquire Methods:\n[list]")
				elseif output == "XML" then
					tinsert(text_table, "  </flags>")
					tinsert(text_table, "  <acquire>")
				end

				-- Find out which unique acquire methods we have
				local acquire_data = recipe["acquire_data"]
				table.wipe(acquire_list)

				for acquire_type in pairs(acquire_data) do
					acquire_list[ACQUIRE_NAMES[acquire_type]] = true
				end

				-- Add all the acquire methods in
				prev = false

				for i in pairs(acquire_list) do
					if not output or output == "Comma" then
						if prev then
							tinsert(text_table, ",")
						end
						tinsert(text_table, i)
						prev = true
					elseif output == "BBCode" then
						tinsert(text_table, "[*] " .. i)
					elseif output == "XML" then
						tinsert(text_table, "<acquiremethod>"..i.."</acquiremethod>")
					end
				end

				if not output or output == "Comma" then
					tinsert(text_table, "\","..tostring(is_known).."\n")
					--if is_known then
					--	tinsert(text_table, "\",true\n")
					--else
					--	tinsert(text_table, "\",false\n")
					--end
				elseif output == "BBCode" then
					tinsert(text_table, "\n[/list]")
				elseif output == "XML" then
					tinsert(text_table, "  </acquire>")
					tinsert(text_table, "</recipe>")
				end
			end
		end	-- for
		return tconcat(text_table, "")
	end
end
