-------------------------------------------------------------------------------
-- AckisRecipeList.lua
-------------------------------------------------------------------------------
-- File date: 2009-11-24T06:08:06Z
-- File revision: 2693
-- Project revision: 2695
-- Project version: r2696
-------------------------------------------------------------------------------
-- Authors: Ackis, Zhinjio, Jim-Bim, Torhal, Pompy
-------------------------------------------------------------------------------
-- Please see http://www.wowace.com/projects/arl/for more information.
-------------------------------------------------------------------------------
-- License:
--	Please see LICENSE.txt

-- This source code is released under All Rights Reserved.
-------------------------------------------------------------------------------
--- **AckisRecipeList** provides an interface for scanning professions for missing recipes.
-- There are a set of functions which allow you make use of the ARL database outside of ARL.
-- ARL supports all professions currently in World of Warcraft 3.2
-- @class file
-- @name AckisRecipeList.lua
-- @release 1.0

-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local tostring = _G.tostring
local tonumber = _G.tonumber

local pairs, ipairs = _G.pairs, _G.ipairs
local select = _G.select

local table = _G.table
local twipe = table.wipe
local tconcat = table.concat
local tinsert = table.insert

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

--[===[@alpha@
_G.ARL = addon
--@end-alpha@]===]

local L	= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

local BFAC = LibStub("LibBabble-Faction-3.0"):GetLookupTable()

--------------------------------------------------------------------------------------------------------------------
-- Acquire types
--------------------------------------------------------------------------------------------------------------------
local A_TRAINER, A_VENDOR, A_MOB, A_QUEST, A_SEASONAL, A_REPUTATION, A_WORLD_DROP, A_CUSTOM = 1, 2, 3, 4, 5, 6, 7, 8

------------------------------------------------------------------------------
-- Constants.
------------------------------------------------------------------------------
local NUM_FILTER_FLAGS = 128
local PROFESSION_INITS = {}	-- Professions initialization functions.

------------------------------------------------------------------------------
-- Database tables
------------------------------------------------------------------------------
local RecipeList = {}
local CustomList = {}
local MobList = {}
local QuestList = {}
local ReputationList = {}
local TrainerList = {}
local SeasonalList = {}
local VendorList = {}
local AllSpecialtiesTable = {}
local SpecialtyTable

addon.custom_list	= CustomList
addon.mob_list		= MobList
addon.quest_list	= QuestList
addon.recipe_list	= RecipeList
addon.reputation_list	= ReputationList
addon.trainer_list	= TrainerList
addon.seasonal_list	= SeasonalList
addon.vendor_list	= VendorList


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
addon.Player = Player

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
	addon:Print("You are using an SVN version of ARL.  As per WowAce/Curseforge standards, SVN externals are not set up.  You will have to install Ace3, Babble-Faction-3.0, Babble-Zone-3.0, Babble-Boss-3.0, LibAboutPanel, and LibSharedMedia-3.0 in order for the addon to function correctly.")
	--@end-debug@]===]
	_G.AckisRecipeList = nil
	return
end

function addon:DEBUG(str, ...)
	print(string.format(addon:Red("DEBUG: ") .. tostring(str), ...))
end

do
	local output = {}

	function addon:DumpMembers(match)
		twipe(output)
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
				tooltipscale = .9,
				fontsize = 11,
			},

			-------------------------------------------------------------------------------
			-- Sorting Options
			-------------------------------------------------------------------------------
			sorting = "SkillAsc",

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
					originalwow = true,
					bc = true,
					wrath = true,
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
	version = string.gsub(version, "@project.revision@", "SVN")
	self.version = version

	self:SetupOptions()

	-- Register slash commands
	self:RegisterChatCommand("arl", "ChatCommand")
	self:RegisterChatCommand("ackisrecipelist", "ChatCommand")

	-------------------------------------------------------------------------------
	-- Create the scan button, then set its parent and scripts.
	-------------------------------------------------------------------------------
	local scan_button = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")

	-- Add to Skillet interface
	if Skillet and Skillet:IsActive() then
		scan_button:SetParent(SkilletFrame)
		scan_button:Show()
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
  	end
	scan_button:SetHeight(20)
	scan_button:RegisterForClicks("LeftButtonUp")
	scan_button:SetScript("OnClick",
			      function(self, button, down)
				      local cprof = GetTradeSkillLine()
				      local current_prof = Player["Profession"]

				      if addon.Frame:IsVisible() then
					      if IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						      -- Shift only (Text dump)
						      addon:Scan(true)
					      elseif not IsShiftKeyDown() and IsAltKeyDown() and not IsControlKeyDown() then
						      -- Alt only (Wipe icons from map)
						      addon:ClearMap()
					      elseif not IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() and current_prof == cprof then
						      -- If we have the same profession open, then we close the scanned window
						      addon.Frame:Hide()
					      elseif not IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						      -- If we have a different profession open we do a scan
						      addon:Scan(false)
						      addon:SetupMap()
					      end
				      else
					      if IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						      -- Shift only (Text dump)
						      addon:Scan(true)
					      elseif not IsShiftKeyDown() and IsAltKeyDown() and not IsControlKeyDown() then
						      -- Alt only (Wipe icons from map)
						      addon:ClearMap()
					      elseif not IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						      -- No modification
						      addon:Scan(false)
						      addon:SetupMap()
					      end
				      end
			      end)

	scan_button:SetScript("OnEnter",
			      function(this)
				      GameTooltip_SetDefaultAnchor(GameTooltip, this)
				      GameTooltip:SetText(L["SCAN_RECIPES_DESC"])
				      GameTooltip:Show()
			      end)
	scan_button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	scan_button:SetText(L["Scan"])

	local buttonparent = scan_button:GetParent()
	local framelevel = buttonparent:GetFrameLevel()
	local framestrata = buttonparent:GetFrameStrata()

	-- Set the frame level of the button to be 1 deeper than its parent
	scan_button:SetFrameLevel(framelevel + 1)
	scan_button:SetFrameStrata(framestrata)
	scan_button:Enable()
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
	PROFESSION_INITS[GetSpellInfo(53428)] = addon.InitRuneforging

	-------------------------------------------------------------------------------
	-- Initialize the databases
	-------------------------------------------------------------------------------
	self:InitCustom(CustomList)
	self:InitMob(MobList)
	self:InitQuest(QuestList)
	self:InitReputation(ReputationList)
	self:InitTrainer(TrainerList)
	self:InitSeasons(SeasonalList)
	self:InitVendor(VendorList)

	-------------------------------------------------------------------------------
	-- Hook GameTooltip so we can show information on mobs that drop/sell/train
	-------------------------------------------------------------------------------
        GameTooltip:HookScript("OnTooltipSetUnit",
		       function(self)
			       local name, unit = self:GetUnit()

			       if not unit then
				       return
			       end
			       local guid = UnitGUID(unit)

			       if not guid then
				       return
			       end
			       local GUID = tonumber(string.sub(guid, 8, 12), 16)
			       local mob = MobList[GUID]
			       local shifted = IsShiftKeyDown()

			       if mob and mob["DropList"] then
				       for spell_id in pairs(mob["DropList"]) do
					       local recipe = RecipeList[spell_id]

					       if not recipe["Known"] or shifted then
						       local _, _, _, hex = GetItemQualityColor(recipe["Rarity"])

						       self:AddLine("Drops: "..hex..recipe["Name"].."|r")
					       end
				       end
				       return
			       end
			       local vendor = VendorList[GUID]

			       if vendor and vendor["SellList"] then
				       for spell_id in pairs(vendor["SellList"]) do
					       local recipe = RecipeList[spell_id]

					       if (not recipe["Known"] or shifted) and Player:IsCorrectFaction(recipe["Flags"]) then
						       local _, _, _, hex = GetItemQualityColor(recipe["Rarity"])

						       self:AddLine("Sells: "..hex..recipe["Name"].."|r")
					       end
				       end
				       return
			       end
			       local trainer = TrainerList[GUID]

			       if trainer and trainer["TrainList"] then
				       for spell_id in pairs(trainer["TrainList"]) do
					       local recipe = RecipeList[spell_id]

					       if (not recipe["Known"] or shifted) and Player:IsCorrectFaction(recipe["Flags"]) then
						       local _, _, _, hex = GetItemQualityColor(recipe["Rarity"])

						       self:AddLine("Trains: "..hex..recipe["Name"].."|r")
					       end
				       end
				       return
			       end
		       end)
end

---Function run when the addon is enabled.  Registers events and pre-loads certain variables.
function addon:OnEnable()
	self:RegisterEvent("TRADE_SKILL_SHOW")	-- Make addon respond to the tradeskill windows being shown
	self:RegisterEvent("TRADE_SKILL_CLOSE")	-- Addon responds to tradeskill windows being closed.

	if addon.db.profile.scantrainers then
		self:RegisterEvent("TRAINER_SHOW")
	end

	if addon.db.profile.scanvendors then
		self:RegisterEvent("MERCHANT_SHOW")
	end

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

--[[
	-- If we're using Skillet, use Skillet's API to work with getting tradeskills
	if (Skillet) and (Skillet.GetNumTradeSkills) and
	(Skillet.GetTradeSkillLine) and (Skillet.GetTradeSkillInfo) and
	(Skillet.GetTradeSkillRecipeLink) and (Skillet.ExpandTradeSkillSubClass) then
		self:Print("Enabling Skillet advanced features.")
		GetNumTradeSkills = function(...) return Skillet:GetNumTradeSkills(...) end
		GetTradeSkillLine = function(...) return Skillet:GetTradeSkillLine(...) end
		GetTradeSkillInfo = function(...) return Skillet:GetTradeSkillInfo(...) end
		GetTradeSkillRecipeLink = function(...) return Skillet:GetTradeSkillRecipeLink(...) end
		ExpandTradeSkillSubClass = function(...) return Skillet:ExpandTradeSkillSubClass(...) end
	end
]]--
	-------------------------------------------------------------------------------
	-- Initialize the main panel frame.
	-------------------------------------------------------------------------------
	self:InitializeFrame()
	self.InitializeFrame = nil

	-------------------------------------------------------------------------------
	-- Initialize the player's data.
	-------------------------------------------------------------------------------
	do
		Player["Faction"] = UnitFactionGroup("player")
		Player["Class"] = select(2, UnitClass("player"))

		-------------------------------------------------------------------------------
		-- Get the player's reputation levels.
		-------------------------------------------------------------------------------
		Player["Reputation"] = {}
		Player:SetReputationLevels()

		-------------------------------------------------------------------------------
		-- Get the player's professions.
		-------------------------------------------------------------------------------
		Player["Professions"] = {
			[GetSpellInfo(51304)] = false, -- Alchemy
			[GetSpellInfo(51300)] = false, -- Blacksmithing
			[GetSpellInfo(51296)] = false, -- Cooking
			[GetSpellInfo(51313)] = false, -- Enchanting
			[GetSpellInfo(51306)] = false, -- Engineering
			[GetSpellInfo(45542)] = false, -- First Aid
			[GetSpellInfo(51302)] = false, -- Leatherworking
			[GetSpellInfo(32606)] = false, -- Mining
			[GetSpellInfo(51309)] = false, -- Tailoring
			[GetSpellInfo(51311)] = false, -- Jewelcrafting
			[GetSpellInfo(45363)] = false, -- Inscription
			[GetSpellInfo(53428)] = false, -- Runeforging
		}
		Player:SetProfessions()
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
	addon.Frame:Hide()

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

function addon:MERCHANT_SHOW()
	addon:ScanVendor()
end

do
	local GetTradeSkillListLink = _G.GetTradeSkillListLink
	local UnitName = _G.UnitName
	local GetRealmName = _G.GetRealmName
	local IsTradeSkillLinked = _G.IsTradeSkillLinked

	function addon:TRADE_SKILL_SHOW()
		local is_linked = IsTradeSkillLinked()

		-- If this is our own skill, save it, if not don't save it
		if not is_linked then
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

		if Skillet then
			return
		end
		local scan_button = self.scan_button

		if ATSWFrame then
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
		else
			scan_button:SetParent(TradeSkillFrame)
			scan_button:ClearAllPoints()

			local loc = addon.db.profile.scanbuttonlocation

			if loc == "TR" then
				scan_button:SetPoint("RIGHT",TradeSkillFrameCloseButton,"LEFT",4,0)
			elseif loc == "TL" then
				scan_button:SetPoint("LEFT",TradeSkillFramePortrait,"RIGHT",2,12)
			elseif loc == "BR" then
				scan_button:SetPoint("TOP",TradeSkillCancelButton,"BOTTOM",0,-5)
			elseif loc == "BL" then
				scan_button:SetPoint("TOP",TradeSkillCreateAllButton,"BOTTOM",0,-5)
			end
			scan_button:SetWidth(addon.scan_button:GetTextWidth() + 10)
		end
		scan_button:Show()
	end
end

function addon:TRADE_SKILL_CLOSE()
	if addon.db.profile.closeguionskillclose then
		self.Frame:Hide()
	end

	if not Skillet then
		addon.scan_button:Hide()
	end
end

-------------------------------------------------------------------------------
-- Tradeskill functions
-- Recipe DB Structures are defined in Documentation.lua
-------------------------------------------------------------------------------

--- Adds a tradeskill recipe into the specified recipe database.
-- @name AckisRecipeList:addTradeSkill
-- @usage AckisRecipeList:addTradeSkill(RecipeDB,2329,1,2454,1,2259,0,1,55,75,95)
-- @param RecipeDB The database (array) which you wish to add data too.
-- @param SpellID The [[http://www.wowwiki.com/SpellLink | Spell ID]] of the recipe being added to the database.
-- @param SkillLevel The skill level at which the recipe may be learned.
-- @param ItemID The [[http://www.wowwiki.com/ItemLink | Item ID]] that is created by the recipe, or nil
-- @param Rarity The rarity of the recipe.
-- @param Profession The profession ID that uses the recipe.  See [[database-documentation]] for a listing of profession IDs.
-- @param Specialty The specialty that uses the recipe (ie: goblin engineering) or nil or blank
-- @param Game Game version recipe was found in, for example, Original, BC, or Wrath.
-- @param Orange Level at which recipe is considered orange.
-- @param Yellow Level at which recipe is considered yellow.
-- @param Green Level at which recipe is considered green.
-- @param Grey Level at which recipe is considered grey.
-- @return None, array is passed as a reference.
function addon:addTradeSkill(RecipeDB, SpellID, SkillLevel, ItemID, Rarity, Profession, Specialty, Game, Orange, Yellow, Green, Grey)
	local spellLink = GetSpellLink(SpellID)
	local profession_id = GetSpellInfo(Profession)
	local recipe_name = GetSpellInfo(SpellID)

	if RecipeDB[SpellID] then
		--[===[@alpha@
		self:Print("Duplicate recipe: "..profession_id.." "..tostring(SpellID).." "..recipe_name)
		--@end-alpha@]===]
		return
	end

	-------------------------------------------------------------------------------
	-- Create a table inside the RecipeListing table which stores all information
	-- about a recipe
	-------------------------------------------------------------------------------
	RecipeDB[SpellID] = {
		["Level"] = SkillLevel,
		["ItemID"] = ItemID,
		["Rarity"] = Rarity,
		["Profession"] = profession_id,
		["Locations"] = nil,
		["RecipeLink"] = spellLink,
		["Name"] = recipe_name,
		["Display"] = true,				-- Set to be displayed until the filtering occurs
		["Search"] = true,				-- Set to be showing in the search results
		["Flags"] = {},					-- Create the flag space in the RecipeDB
		["Acquire"] = {},				-- Create the Acquire space in the RecipeDB
		["Specialty"] = Specialty,			-- Assumption: there will only be 1 speciality for a trade skill
		["Game"] = Game,
		["Orange"] = Orange or SkillLevel,		-- If we don't have an orange value in the db, just assume the skill level
		["Yellow"] = Yellow or SkillLevel + 10,		-- If we don't have a yellow value in the db, just assume the skill level
		["Green"] = Green or SkillLevel + 15,		-- If we don't have a green value in the db, just assume the skill level
		["Grey"] = Grey or SkillLevel + 20,		-- If we don't have a grey value in the db, just assume the skill level
	}
	local recipe = RecipeDB[SpellID]

	if not recipe["Name"] then
		self:Print(strformat(L["SpellIDCache"], SpellID))
	end

	-- Set all the flags to be false, will also set the padding spaces to false as well.
	for i = 1, NUM_FILTER_FLAGS, 1 do
		recipe["Flags"][i] = false
	end
end

--- Adds filtering flags to a specific tradeskill.
-- @name AckisRecipeList:addTradeFlags
-- @usage AckisRecipeList:addTradeFlags(RecipeDB,2329,1,2,3,21,22,23,24,25,26,27,28,29,30,36,41,51,52)
-- @param RecipeDB The database (array) which you wish to add flags too.
-- @param SpellID The [[http://www.wowwiki.com/SpellLink | Spell ID]] of the recipe which flags are being added to.
-- @param ... A listing of filtering flags.  See [[database-documentation]] for a listing of filtering flags.
-- @return None, array is passed as a reference.
function addon:addTradeFlags(RecipeDB, SpellID, ...)
	-- flags are defined in Documentation.lua
	local numvars = select('#',...)
	local flags = RecipeDB[SpellID]["Flags"]

	-- Find out how many flags we're adding
	for i = 1, numvars, 1 do
		-- Get the value of the current flag
		local flag = select(i, ...)
		flags[flag] = true
	end
end

--- Adds acquire methods to a specific tradeskill.
-- @name AckisRecipeList:addTradeAcquire
-- @usage AckisRecipeList:addTradeAcquire:(RecipeDB,2329,8,8)
-- @param RecipeDB The database (array) which you wish to add acquire methods too.
-- @param SpellID The [[http://www.wowwiki.com/SpellLink | Spell ID]] of the recipe which acquire methods are being added to.
-- @param ... A listing of acquire methods.  See [[database-documentation]] for a listing of acquire methods and how they behave.
-- @return None, array is passed as a reference.
do
	-- Tables for getting the locations
	local location_list = {}
	local location_checklist = {}

	local function LocationSort(a, b)
		return a < b
	end

	function addon:addTradeAcquire(DB, SpellID, ...)
		local numvars = select('#', ...)	-- Find out how many flags we're adding
		local index = 1				-- Index for the number of Acquire entries we have
		local i = 1				-- Index for which variables we're parsing through
		local acquire = DB[SpellID]["Acquire"]

		twipe(location_list)
		twipe(location_checklist)

		while i < numvars do
			local acquire_type, acquire_id = select(i, ...)
			i = i + 2

			--[===[@alpha@
			if acquire[index] then
				self:Print("addTradeAcquire called more than once for SpellID "..SpellID)
			end
			--@end-alpha@]===]

			acquire[index] = {
				["Type"] = acquire_type,
				["ID"] = acquire_id
			}
			local location

			if not acquire_type then
				self:Print("SpellID: "..SpellID.." has no acquire type.")
			elseif acquire_type == A_TRAINER then
				if not acquire_id then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": TrainerID is nil.")
					--@end-alpha@]===]
				elseif not TrainerList[acquire_id] then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": TrainerID "..acquire_id.." does not exist in the database.")
					--@end-alpha@]===]
				else
					location = TrainerList[acquire_id]["Location"]

					if not location_checklist[location] then
						tinsert(location_list, location)
						location_checklist[location] = true
					end
					TrainerList[acquire_id]["TrainList"] = TrainerList[acquire_id]["TrainList"] or {}
					TrainerList[acquire_id]["TrainList"][SpellID] = true
				end
			elseif acquire_type == A_VENDOR then
				if not acquire_id then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": VendorID is nil.")
					--@end-alpha@]===]
				elseif not VendorList[acquire_id] then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": VendorID "..acquire_id.." does not exist in the database.")
					--@end-alpha@]===]
				else
					location = VendorList[acquire_id]["Location"]

					if not location_checklist[location] then
						tinsert(location_list, location)
						location_checklist[location] = true
					end
					VendorList[acquire_id]["SellList"] = VendorList[acquire_id]["SellList"] or {}
					VendorList[acquire_id]["SellList"][SpellID] = true
				end
			elseif acquire_type == A_MOB then
				if not acquire_id then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": MobID is nil.")
					--@end-alpha@]===]
				elseif not MobList[acquire_id] then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": Mob ID "..acquire_id.." does not exist in the database.")
					--@end-alpha@]===]
				else
					location = MobList[acquire_id]["Location"]

					if not location_checklist[location] then
						tinsert(location_list, location)
						location_checklist[location] = true
					end
					MobList[acquire_id]["DropList"] = MobList[acquire_id]["DropList"] or {}
					MobList[acquire_id]["DropList"][SpellID] = true
				end
			elseif acquire_type == A_QUEST then
				if not acquire_id then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": QuestID is nil.")
					--@end-alpha@]===]
				elseif not QuestList[acquire_id] then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": Quest ID "..acquire_id.." does not exist in the database.")
					--@end-alpha@]===]
				else
					location = QuestList[acquire_id]["Location"]

					if not location_checklist[location] then
						tinsert(location_list, location)
						location_checklist[location] = true
					end
				end
				--[===[@alpha@
			elseif acquire_type == A_SEASONAL then
				if not acquire_id then
					self:Print("SpellID "..SpellID..": SeasonalID is nil.")
				end
				--@end-alpha@]===]
			elseif acquire_type == A_REPUTATION then
				local RepLevel, RepVendor = select(i, ...)
				i = i + 2

				acquire[index]["RepLevel"] = RepLevel
				acquire[index]["RepVendor"] = RepVendor
				VendorList[RepVendor]["SellList"] = VendorList[RepVendor]["SellList"] or {}
				VendorList[RepVendor]["SellList"][SpellID] = true

				--[===[@alpha@
				if not acquire_id then
					self:Print("SpellID "..SpellID..": ReputationID is nil.")
				elseif not ReputationList[acquire_id] then
					self:Print("SpellID "..SpellID..": ReputationID "..acquire_id.." does not exist in the database.")
				end

				if not RepVendor then
					self:Print("SpellID "..SpellID..": Reputation VendorID is nil.")
				elseif not VendorList[RepVendor] then
					self:Print("SpellID "..SpellID..": Reputation VendorID "..RepVendor.." does not exist in the database.")
				end
				--@end-alpha@]===]
			elseif acquire_type == A_WORLD_DROP then
				local location = L["World Drop"]

				if not location_checklist[location] then
					tinsert(location_list, location)
					location_checklist[location] = true
				end
			end
			index = index + 1
		end
		-- Populate the location field with all the data
		table.sort(location_list, LocationSort)
		DB[SpellID]["Locations"] = (#location_list == 0 and "" or tconcat(location_list, ", "))
	end
end	-- do block

--- Adds an item to a specific database listing (ie: vendor, mob, etc)
-- @name AckisRecipeList:addLookupList
-- @usage AckisRecipeList:addLookupList:(VendorDB,NPC ID, NPC Name, NPC Location, X Coord, Y Coord, Faction)
-- @param DB Database which the entry will be stored.
-- @param ID Unique identified for the entry.
-- @param Name Name of the entry.
-- @param Loc Location of the entry in the world.
-- @param Coordx X coordinate of where the entry is found.
-- @param Coordy Y coordinate of where the entry is found.
-- @param Faction Faction identifier for the entry.
-- @return None, array is passed as a reference.
--For individual database structures, see Documentation.lua
do
	local FACTION_NAMES = {
		[1]	= BFAC["Neutral"],
		[2]	= BFAC["Alliance"],
		[3]	= BFAC["Horde"]
	}
	function addon:addLookupList(DB, ID, Name, Loc, Coordx, Coordy, Faction)
		if DB[ID] then
			--[===[@alpha@
			self:Print("Duplicate lookup: "..tostring(ID).." "..Name)
			--@end-alpha@]===]
			return
		end

		DB[ID] = {
			["Name"]	= Name,
			["Location"]	= Loc or L["Unknown Zone"],
			["Faction"]	= Faction and FACTION_NAMES[Faction + 1] or nil
		}
		if Coordx and Coordy then
			DB[ID]["Coordx"] = Coordx
			DB[ID]["Coordy"] = Coordy
		end

		--[===[@alpha@
		if not Loc then
			self:Print("Spell ID: " .. ID .. " (" .. DB[ID]["Name"] .. ") has an unknown location.")
		end
		--@end-alpha@]===]
	end
end	-- do

-------------------------------------------------------------------------------
-- Filter flag functions
-------------------------------------------------------------------------------
do
	local F_ALLIANCE, F_HORDE = 1, 2

	-------------------------------------------------------------------------------
	-- Item "rarity"
	-------------------------------------------------------------------------------
	local R_COMMON, R_UNCOMMON, R_RARE, R_EPIC, R_LEGENDARY, R_ARTIFACT = 1, 2, 3, 4, 5, 6

	-- HardFilterFlags and SoftFilterFlags are used to determine if a recipe should be shown based on the value of the key compared to the value of its saved_var.
	-- Its keys and values are populated the first time CanDisplayRecipe() is called.
	local HardFilterFlags, SoftFilterFlags, RepFilterFlags

	local F_DK, F_DRUID, F_HUNTER, F_MAGE, F_PALADIN, F_PRIEST, F_SHAMAN, F_ROGUE, F_WARLOCK, F_WARRIOR = 21, 22, 23, 24, 25, 26, 27, 28, 29, 30
	local ClassFilterFlags = {
		["deathknight"]	= F_DK,		["druid"]	= F_DRUID,	["hunter"]	= F_HUNTER,
		["mage"]	= F_MAGE,	["paladin"]	= F_PALADIN,	["priest"]	= F_PRIEST,
		["shaman"]	= F_SHAMAN,	["rogue"]	= F_ROGUE,	["warlock"]	= F_WARLOCK,
		["warrior"]	= F_WARRIOR,
	}

	---Scans a specific recipe to determine if it is to be displayed or not.
	local function CanDisplayRecipe(recipe)
		-------------------------------------------------------------------------------
		-- Origin
		-------------------------------------------------------------------------------
		local GAME_ORIG, GAME_TBC, GAME_WOTLK = 0, 1, 2

		-- For flag info see comments at start of file in comments
		local filter_db = addon.db.profile.filters
		local general_filters = filter_db.general
		local recipe_flags = recipe["Flags"]

		-- See Documentation file for logic explanation
		-------------------------------------------------------------------------------
		-- Stage 1
		-- Loop through exclusive flags (hard filters)
		-- If one of these does not pass we do not display the recipe
		-- So to be more efficient we'll just leave this function if there's a false
		-------------------------------------------------------------------------------

		-- Display both horde and alliance factions?
		if not general_filters.faction and not Player:IsCorrectFaction(recipe_flags) then
			return false
		end

		-- Display all skill levels?
		if not general_filters.skill and recipe["Level"] > Player["ProfessionLevel"] then
			return false
		end

		-- Display all specialities?
		if not general_filters.specialty then
			local specialty = recipe["Specialty"]

			if specialty and specialty ~= Player["Specialty"] then
				return false
			end
		end
		local obtain_filters = filter_db.obtain
		local game_version = recipe["Game"]

		-- Filter out game recipes
		if not obtain_filters.originalwow and game_version == GAME_ORIG then
			return false
		end

		if not obtain_filters.bc and game_version == GAME_TBC then
			return false
		end

		if not obtain_filters.wrath and game_version == GAME_WOTLK then
			return false
		end

		-------------------------------------------------------------------------------
		-- Check the hard filter flags
		-------------------------------------------------------------------------------
		if not HardFilterFlags then
			local F_IBOE, F_IBOP, F_IBOA, F_RBOE, F_RBOP, F_RBOA = 36, 37, 38, 40, 41, 42
			local F_DPS, F_TANK, F_HEALER, F_CASTER = 51, 52, 53, 54
			local F_CLOTH, F_LEATHER, F_MAIL, F_PLATE, F_CLOAK, F_TRINKET, F_RING, F_NECK, F_SHIELD = 56, 57, 58, 59, 60, 61, 62, 63, 64
			local F_1H, F_2H, F_AXE, F_SWORD, F_MACE, F_POLEARM, F_DAGGER = 66, 67, 68, 69, 70, 71, 72
			local F_STAFF, F_WAND, F_THROWN, F_BOW, F_XBOW, F_AMMO, F_FIST, F_GUN = 73, 74, 75, 76, 77, 78, 79, 80

			local binding_filters	= filter_db.binding
			local player_filters	= filter_db.player
			local armor_filters	= filter_db.item.armor
			local weapon_filters	= filter_db.item.weapon

			HardFilterFlags = {
				------------------------------------------------------------------------------------------------
				-- Binding flags.
				------------------------------------------------------------------------------------------------
				["itemboe"]	= { flag = F_IBOE,	sv_root = binding_filters },
				["itembop"]	= { flag = F_IBOP,	sv_root = binding_filters },
				["itemboa"]	= { flag = F_IBOA,	sv_root = binding_filters },
				["recipeboe"]	= { flag = F_RBOE,	sv_root = binding_filters },
				["recipebop"]	= { flag = F_RBOP,	sv_root = binding_filters },
				["recipeboa"]	= { flag = F_RBOA,	sv_root = binding_filters },
				------------------------------------------------------------------------------------------------
				-- Player Type flags.
				------------------------------------------------------------------------------------------------
				["melee"]	= { flag = F_DPS,	sv_root = player_filters },
				["tank"]	= { flag = F_TANK,	sv_root = player_filters },
				["healer"]	= { flag = F_HEALER,	sv_root = player_filters },
				["caster"]	= { flag = F_CASTER,	sv_root = player_filters },
				------------------------------------------------------------------------------------------------
				-- Armor flags.
				------------------------------------------------------------------------------------------------
				["cloth"]	= { flag = F_CLOTH,	sv_root = armor_filters },
				["leather"]	= { flag = F_LEATHER,	sv_root = armor_filters },
				["mail"]	= { flag = F_MAIL,	sv_root = armor_filters },
				["plate"]	= { flag = F_PLATE,	sv_root = armor_filters },
				["trinket"]	= { flag = F_TRINKET,	sv_root = armor_filters },
				["cloak"]	= { flag = F_CLOAK,	sv_root = armor_filters },
				["ring"]	= { flag = F_RING,	sv_root = armor_filters },
				["necklace"]	= { flag = F_NECK,	sv_root = armor_filters },
				["shield"]	= { flag = F_SHIELD,	sv_root = armor_filters },
				------------------------------------------------------------------------------------------------
				-- Weapon flags.
				------------------------------------------------------------------------------------------------
				["onehand"]	= { flag = F_1H,	sv_root = weapon_filters },
				["twohand"]	= { flag = F_2H,	sv_root = weapon_filters },
				["axe"]		= { flag = F_AXE,	sv_root = weapon_filters },
				["sword"]	= { flag = F_SWORD,	sv_root = weapon_filters },
				["mace"]	= { flag = F_MACE,	sv_root = weapon_filters },
				["polearm"]	= { flag = F_POLEARM,	sv_root = weapon_filters },
				["dagger"]	= { flag = F_DAGGER,	sv_root = weapon_filters },
				["fist"]	= { flag = F_FIST,	sv_root = weapon_filters },
				["gun"]		= { flag = F_GUN,	sv_root = weapon_filters },
				["staff"]	= { flag = F_STAFF,	sv_root = weapon_filters },
				["wand"]	= { flag = F_WAND,	sv_root = weapon_filters },
				["thrown"]	= { flag = F_THROWN,	sv_root = weapon_filters },
				["bow"]		= { flag = F_BOW,	sv_root = weapon_filters },
				["crossbow"]	= { flag = F_XBOW,	sv_root = weapon_filters },
				["ammo"]	= { flag = F_AMMO,	sv_root = weapon_filters },
			}
		end

		for filter, data in pairs(HardFilterFlags) do
			if recipe_flags[data.flag] and not data.sv_root[filter] then
				return false
			end
		end

		-------------------------------------------------------------------------------
		-- Check the reputation filter flags
		-------------------------------------------------------------------------------
		if not RepFilterFlags then
			local rep_filters = filter_db.rep

			local F_ARGENTDAWN, F_CENARION_CIRCLE, F_THORIUM_BROTHERHOOD, F_TIMBERMAW_HOLD, F_ZANDALAR = 96, 97, 98, 99, 100
			local F_ALDOR, F_ASHTONGUE, F_CENARION_EXPEDITION, F_HELLFIRE, F_CONSORTIUM = 101, 102, 103, 104, 105
			local F_KOT, F_LOWERCITY, F_NAGRAND, F_SCALE_SANDS, F_SCRYER, F_SHATAR = 106, 107, 108, 109, 110, 111
			local F_SHATTEREDSUN, F_SPOREGGAR, F_VIOLETEYE = 112, 113, 114
			local F_ARGENTCRUSADE, F_FRENZYHEART, F_EBONBLADE, F_KIRINTOR, F_HODIR = 115, 116, 117, 118, 119
			local F_KALUAK, F_ORACLES, F_WYRMREST, F_WRATHCOMMON1, F_WRATHCOMMON2 = 120, 121, 122, 123, 124
			local F_WRATHCOMMON3, F_WRATHCOMMON4, F_WRATHCOMMON5, F_ASHEN_VERDICT = 125, 126, 127, 128

			RepFilterFlags = {
				[F_ARGENTDAWN]		= rep_filters.argentdawn,
				[F_CENARION_CIRCLE]	= rep_filters.cenarioncircle,
				[F_THORIUM_BROTHERHOOD]	= rep_filters.thoriumbrotherhood,
				[F_TIMBERMAW_HOLD]	= rep_filters.timbermaw,
				[F_ZANDALAR]		= rep_filters.zandalar,
				[F_ALDOR]		= rep_filters.aldor,
				[F_ASHTONGUE]		= rep_filters.ashtonguedeathsworn,
				[F_CENARION_EXPEDITION]	= rep_filters.cenarionexpedition,
				[F_HELLFIRE]		= rep_filters.hellfire,
				[F_CONSORTIUM]		= rep_filters.consortium,
				[F_KOT]			= rep_filters.keepersoftime,
				[F_LOWERCITY]		= rep_filters.lowercity,
				[F_NAGRAND]		= rep_filters.nagrand,
				[F_SCALE_SANDS]		= rep_filters.scaleofthesands,
				[F_SCRYER]		= rep_filters.scryer,
				[F_SHATAR]		= rep_filters.shatar,
				[F_SHATTEREDSUN]	= rep_filters.shatteredsun,
				[F_SPOREGGAR]		= rep_filters.sporeggar,
				[F_VIOLETEYE]		= rep_filters.violeteye,
				[F_ARGENTCRUSADE]	= rep_filters.argentcrusade,
				[F_FRENZYHEART]		= rep_filters.frenzyheart,
				[F_EBONBLADE]		= rep_filters.ebonblade,
				[F_KIRINTOR]		= rep_filters.kirintor,
				[F_HODIR]		= rep_filters.sonsofhodir,
				[F_KALUAK]		= rep_filters.kaluak,
				[F_ORACLES]		= rep_filters.oracles,
				[F_WYRMREST]		= rep_filters.wyrmrest,
				[F_WRATHCOMMON1]	= rep_filters.wrathcommon1,
				[F_WRATHCOMMON2]	= rep_filters.wrathcommon2,
				[F_WRATHCOMMON3]	= rep_filters.wrathcommon3,
				[F_WRATHCOMMON4]	= rep_filters.wrathcommon4,
				[F_WRATHCOMMON5]	= rep_filters.wrathcommon5,
				[F_ASHEN_VERDICT]	= rep_filters.ashenverdict,
			}
		end
		local rep_display = true

		for flag in pairs(RepFilterFlags) do
			if recipe_flags[flag] then
				rep_display = RepFilterFlags[flag] and true or false
			end
		end

		if not rep_display then
			return false
		end

		-------------------------------------------------------------------------------
		-- Check the class filter flags
		-------------------------------------------------------------------------------
		local toggled_off, toggled_on = 0, 0
		local class_filters = filter_db.classes

		-- Now we check to see if _all_ of the pertinent class flags are toggled off. If even one is toggled on, we still show the recipe.
		for class, flag in pairs(ClassFilterFlags) do
			if recipe_flags[flag] then
				if class_filters[class] then
					toggled_on = toggled_on + 1
				elseif not class_filters[class] then
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
		if not SoftFilterFlags then
			local F_TRAINER, F_VENDOR, F_INSTANCE, F_RAID, F_SEASONAL, F_QUEST, F_PVP, F_WORLD_DROP, F_MOB_DROP, F_DISC = 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

			SoftFilterFlags = {
				["trainer"]	= { flag = F_TRAINER,		sv_root = obtain_filters },
				["vendor"]	= { flag = F_VENDOR,		sv_root = obtain_filters },
				["instance"]	= { flag = F_INSTANCE,		sv_root = obtain_filters },
				["raid"]	= { flag = F_RAID,		sv_root = obtain_filters },
				["seasonal"]	= { flag = F_SEASONAL,		sv_root = obtain_filters },
				["quest"]	= { flag = F_QUEST,		sv_root = obtain_filters },
				["pvp"]		= { flag = F_PVP,		sv_root = obtain_filters },
				["worlddrop"]	= { flag = F_WORLD_DROP,	sv_root = obtain_filters },
				["mobdrop"]	= { flag = F_MOB_DROP,		sv_root = obtain_filters },
				["discovery"]	= { flag = F_DISC,		sv_root = obtain_filters },
			}
		end

		for filter, data in pairs(SoftFilterFlags) do
			if recipe_flags[data.flag] and data.sv_root[filter] then
				return true
			end
		end

		-- If we get here it means that no flags matched our values
		return false
	end

	---Scans the recipe listing and updates the filters according to user preferences
	function addon:UpdateFilters()
		local general_filters = addon.db.profile.filters.general
		local recipes_total = 0
		local recipes_known = 0
		local recipes_total_filtered = 0
		local recipes_known_filtered = 0
		local can_display = false
		local current_profession = Player["Profession"]

		for recipe_id, recipe in pairs(RecipeList) do
			if recipe["Profession"] == current_profession then
				local is_known = recipe["Known"]

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
			RecipeList[recipe_id]["Display"] = can_display
		end
		Player.recipes_total = recipes_total
		Player.recipes_known = recipes_known
		Player.recipes_total_filtered = recipes_total_filtered
		Player.recipes_known_filtered = recipes_known_filtered
		end

end	-- do

-------------------------------------------------------------------------------
-- ARL Logic Functions
-------------------------------------------------------------------------------

---Determines which profession we are dealing with and loads up the recipe information for it.
local function InitializeRecipe(profession)
	if not profession then
		--[===[@alpha@
		addon:Print("nil profession passed to InitializeRecipe()")
		--@end-alpha@]===]
		return
	end
	local func = PROFESSION_INITS[profession]

	if func then
		return func(addon, RecipeList)
	else
		addon:Print(L["UnknownTradeSkill"]:format(profession))
		return 0
	end
end

---Determines what to do when the slash command is called.
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
	else
		-- What happens when we get here?
		LibStub("AceConfigCmd-3.0"):HandleCommand("arl", "Ackis Recipe List", input)
	end

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
	-- @param textdump Boolean indicating if we want the output to be a text dump, or if we want to use the ARL GUI.
	-- @return A frame with either the text dump, or the ARL frame.
	function addon:Scan(textdump)
		local scan_parent = self.scan_button:GetParent()

		-- The scan button is re-parented to whichever interface it's anchored to, whether it's TradeSkillFrame or a replacement AddOn,
		-- so we make sure its parent exists and is visible before proceeding.
		if not scan_parent or not scan_parent:IsVisible() then
			self:Print(L["OpenTradeSkillWindow"])
			return
		end
		Player["Profession"], Player["ProfessionLevel"] = GetTradeSkillLine()

		-- Get the current profession Specialty
		local specialty = SpecialtyTable[Player["Profession"]]

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

		-- Add the recipes to the database
		-- TODO: Figure out what this variable was supposed to be for - it isn't used anywhere. -Torhal
		Player.totalRecipes = InitializeRecipe(Player["Profession"])

		--- Set the known flag to false for every recipe in the database.
		for SpellID in pairs(RecipeList) do
			RecipeList[SpellID]["Known"] = false
		end

		-------------------------------------------------------------------------------
		-- Scan all recipes and mark the ones we know
		-------------------------------------------------------------------------------
		twipe(header_list)

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
		local recipes_found = 0

		for i = 1, GetNumTradeSkills() do
			local tradeName, tradeType = GetTradeSkillInfo(i)

			if tradeType ~= "header" then
				-- Get the trade skill link for the specified recipe
				local SpellLink = GetTradeSkillRecipeLink(i)
				local SpellString = strmatch(SpellLink, "^|c%x%x%x%x%x%x%x%x|H%w+:(%d+)")
				local recipe = RecipeList[tonumber(SpellString)]

				if recipe then
					recipe["Known"] = true
					recipes_found = recipes_found + 1
				else
					self:Print(self:Red(tradeName .. " " .. SpellString) .. self:White(L["MissingFromDB"]))	
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
		end
		-- TODO: Figure out what this variable was supposed to be for - it isn't used anywhere. -Torhal
		Player.foundRecipes = recipes_found

		self:UpdateFilters()
		Player:MarkExclusions()

		if textdump then
			self:DisplayTextDump(RecipeList, Player["Profession"])
		else
			self:DisplayFrame()
		end
	end
end

-------------------------------------------------------------------------------
-- Recipe Exclusion Functions
-------------------------------------------------------------------------------
---Removes or adds a recipe to the exclusion list.
function addon:ToggleExcludeRecipe(SpellID)
	local exclusion_list = addon.db.profile.exclusionlist

	exclusion_list[SpellID] = (not exclusion_list[SpellID] and true or nil)
end

---Prints all the ID's in the exclusion list out into chat.
function addon:ViewExclusionList()
	local exclusion_list = addon.db.profile.exclusionlist

	-- Parse all items in the exclusion list
	for i in pairs(exclusion_list) do
		self:Print(i .. ": " .. GetSpellInfo(i))
	end
end

function addon:ClearExclusionList()
	local exclusion_list = addon.db.profile.exclusionlist

	exclusion_list = twipe(exclusion_list)
end

-------------------------------------------------------------------------------
-- Text dumping functions
-------------------------------------------------------------------------------
do
	-------------------------------------------------------------------------------
	-- Provides a string of comma separated values for all recipe information
	-------------------------------------------------------------------------------
	local text_table = {}
	local acquire_list = {}

	local ACQUIRE_NAMES = {
		[A_TRAINER]	= "Trainer",
		[A_VENDOR]	= "Vendor",
		[A_MOB]		= "Mob Drop",
		[A_QUEST]	= "Quest",
		[A_SEASONAL]	= "Seasonal",
		[A_REPUTATION]	= "Reputation",
		[A_WORLD_DROP]	= "World Drop",
		[A_CUSTOM]	= "Custom",
	}

	function addon:GetTextDump(RecipeDB, profession)
		twipe(text_table)

		tinsert(text_table, strformat("Ackis Recipe List Text Dump for %s.  ", profession))
		tinsert(text_table, "Text output of all recipes and acquire information.  Output is in the form of comma separated values.\n")
		tinsert(text_table, "Spell ID,Recipe Name,Skill Level,ARL Filter Flags,Acquire Methods,Known\n")

		for SpellID in pairs(RecipeDB) do
			local recipe_prof = GetSpellInfo(RecipeDB[SpellID]["Profession"])

			if recipe_prof == profession then
				-- Add Spell ID, Name and Skill Level to the list
				tinsert(text_table, SpellID)
				tinsert(text_table, ",")
				tinsert(text_table, RecipeDB[SpellID]["Name"])
				tinsert(text_table, ",")
				tinsert(text_table, RecipeDB[SpellID]["Level"])
				tinsert(text_table, ",\"")

				-- Add in all the filter flags
				local recipe_flags = RecipeDB[SpellID]["Flags"]
				local prev

				-- Find out which flags are marked as "true"
				for i = 1, NUM_FILTER_FLAGS, 1 do
					if recipe_flags[i] then
						if prev then
							tinsert(text_table, ",")
						end
						tinsert(text_table, i)
						prev = true
					end
				end
				tinsert(text_table, "\",\"")

				-- Find out which unique acquire methods we have
				local acquire = RecipeDB[SpellID]["Acquire"]
				twipe(acquire_list)

				for i in pairs(acquire) do
					local acquire_type = acquire[i]["Type"]

					acquire_list[ACQUIRE_NAMES[acquire_type]] = true
				end

				-- Add all the acquire methods in
				prev = false

				for i in pairs(acquire_list) do
					if prev then
						tinsert(text_table, ",")
					end
					tinsert(text_table, i)
					prev = true
				end

				if (RecipeDB[SpellID]["Known"]) then
					tinsert(text_table, "\",true\n")
				else
					tinsert(text_table, "\",false\n")
				end
			end
		end
		return tconcat(text_table, "")
	end

	---Dumps all the info about a recipe out to chat
	function addon:DumpRecipe(SpellID)
		local recipelist = addon.recipe_list

		if not recipelist[SpellID] then
			self:Print("Spell ID not in recipe database.")
			return
		end
		local recipe = recipelist[SpellID]

		self:Print(recipe["Name"] .. "(" .. recipe["Level"] .. ") -- " .. SpellID)
		self:Print("Rarity: " .. recipe["Rarity"])

		if recipe["Specialty"] then
			self:Print("Profession: " .. recipe["Profession"] .. "(" .. recipe["Specialty"] .. ")")
		else
			self:Print("Profession: " .. recipe["Profession"])
		end

		if recipe["ItemID"] then
			local _, linky = GetItemInfo(recipe["ItemID"])

			self:Print("Creates: " .. linky .. "(" .. recipe["ItemID"] .. ")")
		end

		if recipe["Locations"] then
			self:Print("Located: " .. recipe["Locations"])
		end

		local recipe_flags = recipe["Flags"]
		local flagstr = ""

		if recipe_flags[1] then
			flagstr = flagstr .. "Ally, "
		end
		if recipe_flags[2] then
			flagstr = flagstr .. "Horde, "
		end
		if recipe_flags[3] then
			flagstr = flagstr .. "Trn, "
		end
		if recipe_flags[4] then
			flagstr = flagstr .. "Ven, "
		end
		if recipe_flags[5] then
			flagstr = flagstr .. "Instance, "
		end
		if recipe_flags[6] then
			flagstr = flagstr .. "Raid, "
		end
		if recipe_flags[7] then
			flagstr = flagstr .. "Seasonal, "
		end
		if recipe_flags[8] then
			flagstr = flagstr .. "Quest, "
		end
		if recipe_flags[9] then
			flagstr = flagstr .. "PVP, "
		end
		if recipe_flags[10] then
			flagstr = flagstr .. "World, "
		end
		if recipe_flags[11] then
			flagstr = flagstr .. "Mob, "
		end
		if recipe_flags[12] then
			flagstr = flagstr .. "Disc, "
		end
		if recipe_flags[13] then
			flagstr = flagstr .. "13, "
		end
		if recipe_flags[14] then
			flagstr = flagstr .. "14, "
		end
		if recipe_flags[15] then
			flagstr = flagstr .. "15, "
		end
		if recipe_flags[16] then
			flagstr = flagstr .. "16, "
		end
		if recipe_flags[17] then
			flagstr = flagstr .. "17, "
		end
		if recipe_flags[18] then
			flagstr = flagstr .. "18, "
		end
		if recipe_flags[19] then
			flagstr = flagstr .. "19, "
		end
		if recipe_flags[20] then
			flagstr = flagstr .. "20, "
		end
		if recipe_flags[21] then
			flagstr = flagstr .. "DK, "
		end
		if recipe_flags[22] then
			flagstr = flagstr .. "Druid, "
		end
		if recipe_flags[23] then
			flagstr = flagstr .. "Huntard, "
		end
		if recipe_flags[24] then
			flagstr = flagstr .. "Mage, "
		end
		if recipe_flags[25] then
			flagstr = flagstr .. "Pally, "
		end
		if recipe_flags[26] then
			flagstr = flagstr .. "Priest, "
		end
		if recipe_flags[27] then
			flagstr = flagstr .. "Sham, "
		end
		if recipe_flags[28] then
			flagstr = flagstr .. "Rogue, "
		end
		if recipe_flags[29] then
			flagstr = flagstr .. "Lock, "
		end
		if recipe_flags[30] then
			flagstr = flagstr .. "War, "
		end
		if recipe_flags[31] then
			flagstr = flagstr .. "31, "
		end
		if recipe_flags[36] then
			flagstr = flagstr .. "IBoE, "
		end
		if recipe_flags[37] then
			flagstr = flagstr .. "IBoP, "
		end
		if recipe_flags[38] then
			flagstr = flagstr .. "IBoA, "
		end
		if recipe_flags[39] then
			flagstr = flagstr .. "39, "
		end
		if recipe_flags[40] then
			flagstr = flagstr .. "RBoE, "
		end
		if recipe_flags[41] then
			flagstr = flagstr .. "RBoP, "
		end
		if recipe_flags[42] then
			flagstr = flagstr .. "RBoA, "
		end
		if recipe_flags[51] then
			flagstr = flagstr .. "Melee, "
		end
		if recipe_flags[52] then
			flagstr = flagstr .. "Tank, "
		end
		if recipe_flags[53] then
			flagstr = flagstr .. "Heal, "
		end
		if recipe_flags[54] then
			flagstr = flagstr .. "Caster, "
		end
		if recipe_flags[56] then
			flagstr = flagstr .. "Cloth, "
		end
		if recipe_flags[57] then
			flagstr = flagstr .. "Leather, "
		end
		if recipe_flags[58] then
			flagstr = flagstr .. "Mail, "
		end
		if recipe_flags[59] then
			flagstr = flagstr .. "Plate, "
		end
		if recipe_flags[60] then
			flagstr = flagstr .. "Cloak, "
		end
		if recipe_flags[61] then
			flagstr = flagstr .. "Trinket, "
		end
		if recipe_flags[62] then
			flagstr = flagstr .. "Ring, "
		end
		if recipe_flags[63] then
			flagstr = flagstr .. "Neck, "
		end
		if recipe_flags[64] then
			flagstr = flagstr .. "Shield, "
		end
		if recipe_flags[66] then
			flagstr = flagstr .. "1H, "
		end
		if recipe_flags[67] then
			flagstr = flagstr .. "2H, "
		end
		if recipe_flags[68] then
			flagstr = flagstr .. "Axe, "
		end
		if recipe_flags[69] then
			flagstr = flagstr .. "Sword, "
		end
		if recipe_flags[70] then
			flagstr = flagstr .. "Mace, "
		end
		if recipe_flags[71] then
			flagstr = flagstr .. "Polearm, "
		end
		if recipe_flags[72] then
			flagstr = flagstr .. "Dagger, "
		end
		if recipe_flags[73] then
			flagstr = flagstr .. "Staff, "
		end
		if recipe_flags[74] then
			flagstr = flagstr .. "Wand, "
		end
		if recipe_flags[75] then
			flagstr = flagstr .. "Thrown, "
		end
		if recipe_flags[76] then
			flagstr = flagstr .. "Bow, "
		end
		if recipe_flags[77] then
			flagstr = flagstr .. "xBow, "
		end
		if recipe_flags[78] then
			flagstr = flagstr .. "Ammo, "
		end
		if recipe_flags[79] then
			flagstr = flagstr .. "Fist, "
		end

		self:Print("Flags: " .. flagstr)
		flagstr = ""

		if recipe_flags[96] then
			flagstr = flagstr .. "AD, "
		end
		if recipe_flags[97] then
			flagstr = flagstr .. "CC, "
		end
		if recipe_flags[98] then
			flagstr = flagstr .. "TB, "
		end
		if recipe_flags[99] then
			flagstr = flagstr .. "TH, "
		end
		if recipe_flags[100] then
			flagstr = flagstr .. "ZH, "
		end
		if recipe_flags[101] then
			flagstr = flagstr .. "Aldor, "
		end
		if recipe_flags[102] then
			flagstr = flagstr .. "Ashtongue, "
		end
		if recipe_flags[103] then
			flagstr = flagstr .. "CE, "
		end
		if recipe_flags[104] then
			flagstr = flagstr .. "Thrall/HH, "
		end
		if recipe_flags[105] then
			flagstr = flagstr .. "Consort, "
		end
		if recipe_flags[106] then
			flagstr = flagstr .. "KoT, "
		end
		if recipe_flags[107] then
			flagstr = flagstr .. "LC, "
		end
		if recipe_flags[108] then
			flagstr = flagstr .. "Mag/Kur, "
		end
		if recipe_flags[109] then
			flagstr = flagstr .. "SoS, "
		end
		if recipe_flags[110] then
			flagstr = flagstr .. "Scryer, "
		end
		if recipe_flags[111] then
			flagstr = flagstr .. "Sha'tar, "
		end
		if recipe_flags[112] then
			flagstr = flagstr .. "Shattered Sun, "
		end
		if recipe_flags[113] then
			flagstr = flagstr .. "Spore, "
		end
		if recipe_flags[114] then
			flagstr = flagstr .. "VE, "
		end
		if recipe_flags[115] then
			flagstr = flagstr .. "AC, "
		end
		if recipe_flags[116] then
			flagstr = flagstr .. "Frenzy, "
		end
		if recipe_flags[117] then
			flagstr = flagstr .. "Ebon, "
		end
		if recipe_flags[118] then
			flagstr = flagstr .. "Kirin, "
		end
		if recipe_flags[119] then
			flagstr = flagstr .. "Hodir, "
		end
		if recipe_flags[120] then
			flagstr = flagstr .. "Kalu'ak, "
		end
		if recipe_flags[121] then
			flagstr = flagstr .. "Oracles, "
		end
		if recipe_flags[122] then
			flagstr = flagstr .. "Wyrm, "
		end
		if recipe_flags[123] then
			flagstr = flagstr .. "Wrath Common Factions (The Silver Covenant/The Sunreavers), "
		end
		if recipe_flags[124] then
			flagstr = flagstr .. "Wrath Common Factions (Explorers' League/The Hand of Vengeance), "
		end
		if recipe_flags[125] then
			flagstr = flagstr .. "Wrath Common Factions(Explorer's League/Valiance Expedition), "
		end
		if recipe_flags[126] then
			flagstr = flagstr .. "Wrath Common Factions (The Frostborn/The Taunka), "
		end
		if recipe_flags[127] then
			flagstr = flagstr .. "Wrath Common Factions (Alliance Vanguard/Horde Expedition), "
		end
		self:Print("Reps: " .. flagstr)
	end
end

---Clears all saved tradeskills
function addon:ClearSavedSkills()
	twipe(addon.db.global.tradeskill)

	if addon.db.profile.tradeskill then
		addon.db.profile.tradeskill = nil
	end

end

-------------------------------------------------------------------------------
-- API to interface with external AddOns.
-------------------------------------------------------------------------------
--- Initialize the recipe database with a specific profession
-- @name AckisRecipeList:AddRecipeData
-- @usage AckisRecipeList:AddRecipeData(GetSpellInfo(51304))
-- @param profession Spell ID of the profession which you want to populate the database with.
-- @return Boolean indicating if the operation was successful.  The recipe database will be populated with appropriate data.
function addon:AddRecipeData(profession)
	return InitializeRecipe(profession)
end

--- Initialize the recipe database
-- @name AckisRecipeList:InitRecipeData
-- @usage AckisRecipeList:InitRecipeData()
-- @return Boolean indicating if the operation was successful.  The recipe database will be populated with appropriate data.
-- @return Arrays containing the RecipeList, MobList, TrainerList, VendorList, QuestList, ReputationList, SeasonalList.
function addon:InitRecipeData()
	return false, RecipeList, MobList, TrainerList, VendorList, QuestList, ReputationList, SeasonalList
end

--- Get recipe information from ARL
-- @name AckisRecipeList:GetRecipeData
-- @param spellID The spell ID of the recipe you want information about.
-- @return Table containing all spell ID information or nil if it's not found.
function addon:GetRecipeData(spellID)
	return RecipeList[spellID]
end
