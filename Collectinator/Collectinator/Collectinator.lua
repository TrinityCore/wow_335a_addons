-------------------------------------------------------------------------------
-- Collectinator
-- File date: 2010-05-12T21:12:23Z
-- Project version: v1.0.4
-- Authors: Ackis, Torhal, Pompachomp
-------------------------------------------------------------------------------

--- **Collectinator** provides an interface for scanning companions and moutns to find what is missing.
-- There are a set of functions which allow you make use of the Collectinator database outside of Collectinator.
-- Collectinator supports all mounts/pets currently in World of Warcraft 3.3.3
-- @class file
-- @name Collectinator.lua
-- @release @file-revision@

-------------------------------------------------------------------------------
-- Localized Lua globals
-------------------------------------------------------------------------------
local _G = getfenv(0)

local tostring = _G.tostring
local tonumber = _G.tonumber

local pairs = _G.pairs
local select = _G.select

local table = _G.table
local twipe = table.wipe
local tremove = table.remove
local tconcat = table.concat
local tsort = table.sort
local tinsert = table.insert

local string = _G.string
local format = string.format
local sfind = string.find
local smatch = string.match
local strlower = string.lower

-------------------------------------------------------------------------------
-- Localized API Functions
-------------------------------------------------------------------------------
local GetSpellInfo = GetSpellInfo

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local MODNAME = "Collectinator"

local LibStub = LibStub
local addon = LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0", "AceEvent-3.0")
_G["Collectinator"] = addon

local L = LibStub("AceLocale-3.0"):GetLocale(MODNAME)

addon.optionsFrame = {}

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local NUM_FILTER_FLAGS = 76

-------------------------------------------------------------------------------
-- Constants for acquire types.
-------------------------------------------------------------------------------
local A_VENDOR, A_QUEST, A_CRAFTED, A_MOB, A_SEASONAL, A_REPUTATION, A_WORLD_DROP, A_CUSTOM, A_ACHIEVEMENT, A_MAX = 1, 2, 3, 4, 5, 6, 7, 8, 9, 9

-------------------------------------------------------------------------------
-- Class types
-------------------------------------------------------------------------------
local C_DK, C_DRUID, C_HUNTER, C_MAGE, C_PALADIN, C_PRIEST, C_ROGUE, C_SHAMAN, C_WARLOCK, C_WARRIOR = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10


------------------------------------------------------------------------------
-- Database tables
------------------------------------------------------------------------------
local CompanionDB = {}
local TitleDB = {}
local CustomList = {}
local MobList = {}
local QuestList = {}
local ReputationList = {}
local SeasonalList = {}
local VendorList = {}

------------------------------------------------------------------------------
--- Data which is stored regarding a player's statistics
------------------------------------------------------------------------------
-- @class table
-- @name playerData
-- @field total_str Total number of items in the scan.
-- @field known_str Total number of items known in the scan.
-- @field total_filtered_str Total number of items filtered during the scan.
-- @field known_filtered_str Total number of items known filtered during the scan.
-- @field unknown_exclude_str Total number of items unknown excluded during the scan.
-- @field known_exclude_str Total number of items known excluded during the scan.
-- @field playerFaction Players faction
-- @field playerClass Players class
-- @field ["Reputation"] Listing of players reputation levels
local playerData = {}

------------------------------------------------------------------------------
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
				addon:Print(format(L["MISSING_LIBRARY"], lib))
			end
		end
		return missing
	end

	if MissingLibraries() then
		--[===[@debug@
		addon:Print("You are using a repository version of Collectinator.")
		addon:Print("You will have to install the following libraries to ensure the mod runs correctly:")
		for idx, lib in ipairs(REQUIRED_LIBS) do
			addon:Print(lib)
		end
		addon:Print("Collectinator not loaded.")
		--@end-debug@]===]
		_G["Collectinator"] = nil
		return
	end
end	-- do

local BFAC = LibStub("LibBabble-Faction-3.0"):GetLookupTable()

-------------------------------------------------------------------------------
-- Initialization functions
-------------------------------------------------------------------------------
--  Registers the slash commands, options, and database
function addon:OnInitialize()
	-------------------------------------------------------------------------------
	-- Set default options, which are to include everything in the scan
	-------------------------------------------------------------------------------
	local defaults = {
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
			sorting = "Name",


			-------------------------------------------------------------------------------
			-- Display Options
			-------------------------------------------------------------------------------
			includefiltered = false,
			includeexcluded = false,
			ignoreexclusionlist = false,
			includeknownfiltered = false,
			spelltooltiplocation = "Right",
			acquiretooltiplocation = "Mouse",
			hidepopup = false,
			minimap = true,
			worldmap = true,
			autoscanmap = false,

			-------------------------------------------------------------------------------
			-- Exclusion
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
					faction = false,
					known = false,
					unknown = true,
					removed = false,
				},
				-------------------------------------------------------------------------------
				-- Obtain Filters
				-------------------------------------------------------------------------------
				obtain = {
					vendor = true,
					quest = true,
					instance = true,
					raid = true,
					craft = true,
					seasonal = true,
					worlddrop = true,
					mobdrop = true,
					pvp = true,
					tcg = true,
					event = true,
					ce = true,
					achievement = true,
					originalwow = true,
					bc = true,
					wrath = true,
					store = true,
				},
				-------------------------------------------------------------------------------
				-- Binding Filters
				-------------------------------------------------------------------------------
				binding = {
					itemboe = true,
					itembop = true,
					itemboa = true,
				},
				-------------------------------------------------------------------------------
				-- Rarity Filters
				-------------------------------------------------------------------------------
				rarity = {
					poor = true,
					common = true,
					uncommon = true,
					rare = true,
					epic = true,
					legendary = true,
					artifact = true,
				},
				-------------------------------------------------------------------------------
				-- Profession Filters
				-------------------------------------------------------------------------------
				profs = {
					alch = true,
					bs = true,
					cook = true,
					ench = true,
					eng = true,
					fa = true,
					insc = true,
					jc = true,
					lw = true,
					smelt = true,
					tailor = true,
					fish = true,
				},
				-------------------------------------------------------------------------------
				-- Reputation Filters
				-------------------------------------------------------------------------------
				rep = {
					aldor = true,
					scryer = true,
					argentdawn = true,
					ashtonguedeathsworn = true,
					bloodsail = true,
					cenarioncircle = true,
					cenarionexpedition = true,
					consortium = true,
					hellfire = true,
					keepersoftime = true,
					nagrand = true,
					netherwing = true,
					lowercity = true,
					scaleofthesands = true,
					shatar = true,
					shatteredsun = true,
					skyguard = true,
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
					ashenverdict = true,
					wrathcommon1 = true,
					wrathcommon2 = true,
					wrathcommon3 = true,
					wrathcommon4 = true,
					wrathcommon5 = true,
					city1 = true,
					city2 = true,
					city3 = true,
					city4 = true,
					city5 = true,
					pvp1 = true,
					pvp2 = true,
					pvp3 = true,
				}, -- rep
			} -- filters
		} -- profile
	} --defaults
	addon.db = LibStub("AceDB-3.0"):New("CollectinatorDB", defaults)

	if not addon.db then
		self:Print(L["DB_LOAD_ERROR"])
		return
	end
	self:SetupOptions()
	self:RegisterChatCommand("collectinator", "ChatCommand")

	-------------------------------------------------------------------------------
	-- Create the scan button.
	-------------------------------------------------------------------------------
	local button = CreateFrame("Button", "Collectinator_ScanButton", PetPaperDollFrameCompanionFrame, "UIPanelButtonTemplate")
	self.ScanButton = button

	-- Add to PetList+
	if PetListPlus then
		button:SetParent(PetListPlusFrame)
		button:Show()
	end

	if CE_Pets then
		button:SetParent(CE_Pets)
		button:Show()
	end
	button:SetHeight(20)
	button:RegisterForClicks("LeftButtonUp")
	button:SetScript("OnClick",
				  function()
					  local companion_frame = PetPaperDollFrameCompanionFrame
					  local is_visible = (PetListPlus and PetListPlusFrame:IsVisible()) or (CE_Pets and CE_Pets:IsVisible()) or companion_frame:IsVisible()
					  -- Alt-Shift (Warcraft Pets)
					  if IsShiftKeyDown() and IsAltKeyDown() and not IsControlKeyDown() then
						  addon:Scan(true, false, "pets")

					  -- Shift only (Text Dump)
					  elseif IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						  addon:Scan(true, false, is_visible and companion_frame.mode or "CRITTER")
					  -- Alt only (Wipe icons from map)
					  elseif not IsShiftKeyDown() and IsAltKeyDown() and not IsControlKeyDown() then
						  addon:ClearMap()
					  -- If we are just clicking do the scan
					  elseif not IsShiftKeyDown() and not IsAltKeyDown() and not IsControlKeyDown() then
						  addon:Scan(false, false, is_visible and companion_frame.mode or "CRITTER")
						  self:SetupMap()
					  end
				  end)

	button:SetScript("OnEnter",
				   function(this)
					   GameTooltip_SetDefaultAnchor(GameTooltip, this)
					   GameTooltip:SetText(L["SCAN_COMPANIONS_DESC"])
					   GameTooltip:Show()
				   end)

	button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	button:SetText(L["Scan"])

	-- Set the frame level of the button to be 1 deeper than its parent
	local button_parent = button:GetParent()
	button:SetFrameLevel(button_parent:GetFrameLevel() + 1)
	button:SetFrameStrata(button_parent:GetFrameStrata())

	button:Enable()
	button:ClearAllPoints()

	button:SetPoint("RIGHT", CharacterFrameCloseButton, "LEFT", 4, 0)
	button:SetWidth(addon.ScanButton:GetTextWidth() + 10)

	button:Show()

	-------------------------------------------------------------------------------
	-- Add mini-pet/mount totals to the tab
	-------------------------------------------------------------------------------
	PetPaperDollFrameTab2:SetScript("OnEnter",
					function(this)
						GameTooltip_SetDefaultAnchor(GameTooltip, this)
						GameTooltip:SetText(string.format("%d %s.", GetNumCompanions("CRITTER"), PETS))
						GameTooltip:Show()
					end)
	PetPaperDollFrameTab2:SetScript("OnLeave", function() GameTooltip:Hide() end)

	PetPaperDollFrameTab3:SetScript("OnEnter",
					function(this)
						GameTooltip_SetDefaultAnchor(GameTooltip, this)
						GameTooltip:SetText(string.format("%d %s.", GetNumCompanions("MOUNT"), MOUNTS))
						GameTooltip:Show()
					end)
	PetPaperDollFrameTab3:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-------------------------------------------------------------------------------
	-- Initialize the databases
	-------------------------------------------------------------------------------
	self.data_table = CompanionDB

	self:InitCustom(CustomList)
	self:InitMob(MobList)
	self:InitQuest(QuestList)
	self:InitReputation(ReputationList)
	self:InitSeasons(SeasonalList)
	self:InitVendor(VendorList)

	-------------------------------------------------------------------------------
	-- Hook GameTooltip so we can show information on mobs that drop companions
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
					       local companion = CompanionDB[spell_id]

					       if not companion["Known"] or shifted then
						       local _, _, _, hex = GetItemQualityColor(companion["Rarity"])

						       self:AddLine("Drops: "..hex..companion["Name"].."|r")
					       end
				       end
				       return
			       end
			       local vendor = VendorList[GUID]

			       if vendor and vendor["SellList"] then
				       for spell_id in pairs(vendor["SellList"]) do
					       local companion = CompanionDB[spell_id]

					       if (not companion["Known"] or shifted) and addon.IsCorrectFaction(playerData.playerFaction, companion["Flags"]) then
						       local _, _, _, hex = GetItemQualityColor(companion["Rarity"])

						       self:AddLine("Sells: "..hex..companion["Name"].."|r")
					       end
				       end
				       return
			       end
		       end)
end


-- Registers events and pre-loads certain variables.
function addon:OnEnable()
	self:RegisterEvent("COMPANION_LEARNED")

	-------------------------------------------------------------------------------
	-- Initialize the player's data
	-------------------------------------------------------------------------------
	local _

	_, playerData.playerClass = UnitClass("player")
	playerData.playerFaction = UnitFactionGroup("player")
end

-- Run when the addon is disabled. Ace3 takes care of unregistering events, etc.
function addon:OnDisable()
	-- If we disable the addon when the GUI is up, hide it.
	addon.Frame:Hide()
end

-------------------------------------------------------------------------------
-- Event handling functions
-------------------------------------------------------------------------------
-- When we learn a new pet, we want to automatically scan the companions and update our saved variables
function addon:COMPANION_LEARNED()
	local companion_frame = self.ScanButton:GetParent()

	if companion_frame:IsVisible() then
		self:Scan(false, false, companion_frame.mode)
	else
		self:Scan(false, true, companion_frame.mode)
	end
end

-------------------------------------------------------------------------------
-- Player Data Acquisition Functions
-------------------------------------------------------------------------------
do
	local GetNumFactions = _G.GetNumFactions
	local GetFactionInfo = _G.GetFactionInfo
	local CollapseFactionHeader = _G.CollapseFactionHeader
	local ExpandFactionHeader = _G.ExpandFactionHeader
	local rep_list = {}

	-------------------------------------------------------------------------------
	-- Scans all reputations to get reputation levels to determine if the player can learn a reputation item
	-------------------------------------------------------------------------------
	function addon:GetFactionLevels(RepTable)
		if not RepTable then
			return
		end
		twipe(rep_list)

		-- Count the number of factions, then use that to expand the headers for the final count
		local num_factions = GetNumFactions()

		for i = num_factions, 1, -1 do
			local name, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(i)

			if isCollapsed then
				ExpandFactionHeader(i)
				rep_list[name] = true
			end
		end
		num_factions = GetNumFactions()

		-- Get the rep levels
		for i = 1, num_factions, 1 do
			local name, _, rep_level = GetFactionInfo(i)

			-- If the rep is greater than neutral
			if rep_level > 4 then
				-- We use levels of 0, 1, 2, 3, 4 internally for reputation levels, make it corrospond here
				RepTable[name] = rep_level - 4
			end
		end

		-- Collapse the headers again
		for i = num_factions, 1, -1 do
			if rep_list[GetFactionInfo(i)] then
				CollapseFactionHeader(i)
			end
		end
	end
end	-- do

-------------------------------------------------------------------------------
-- Companion DB functions
-------------------------------------------------------------------------------

--- Adds a companion into the database.
-- @name Collectinator:AddCompanion
-- @usage Collectinator:AddCompanion(DB)
-- @param DB The database (array) which you wish to add data too.
-- @param SpellID The [http://www.wowwiki.com/SpellLink Spell ID] of the item being entered to the database.
-- @param ItemID The [http://www.wowwiki.com/ItemLink Item ID] of the item, or nil
-- @param Rarity The rarity of the item.
-- @param CompanionType Type of entry added to the database.
-- @param Game Game version item was found in, for example, Original, BC, or Wrath.
-- @return None, array is passed as a reference.
function addon:AddCompanion(DB, CompanionType, SpellID, ItemID, Rarity, Game)
	if DB[SpellID] then	-- If the entry already exists, abort.
		--[===[@alpha@
		self:Print("Duplicate companion - "..SpellID.." "..ItemID)
		--@end-alpha@]===]
		return
	end

	if not Rarity then
		Rarity = 0
		--[===[@alpha@
		self:Print("SpellID "..SpellID..": ("..CompanionType..") Rarity is nil, setting to 0.")
		--@end-alpha@]===]
	end
	DB[SpellID] = {
		["Name"]	= GetSpellInfo(SpellID) or "Unknown ("..SpellID..")",
		["ItemID"]	= ItemID,
		["Rarity"]	= Rarity,
		["Type"]	= CompanionType,
		["Game"]	= Game or 0,
		["Display"]	= true,
		["Search"]	= true,
		["Known"]	= false,
		["Flags"]	= {},
		["Acquire"]	= {},
		["Location"]	= "Unknown",
	}
	local flag = DB[SpellID]["Flags"]

	if ItemID then
		DB[SpellID]["ItemIcon"]	= select(10, GetItemInfo(ItemID))
	end

	-- Set the filter flags to all false
	for i = 1, NUM_FILTER_FLAGS, 1 do
		flag[i] = false
	end
end

--- Adds filtering flags to a specific entry.
-- @name Collectinator:AddCompanionFlags
-- @usage Collectinator:AddCompanionFlags(DB)
-- @param DB The database (array) which you wish to add flags too.
-- @param SpellID The [http://www.wowwiki.com/SpellLink Spell ID] of the item being entered to the database.
-- @param ... A listing of filtering flags.  See [[database-documentation]] for a listing of filtering flags.
-- @return None, array is passed as a reference.
function addon:AddCompanionFlags(DB, SpellID, ...)
	-- flags are defined in Documentation.lua
	local numvars = select('#', ...)
	local flags = DB[SpellID]["Flags"]

	-- Find out how many flags we're adding
	for i = 1, numvars, 1 do
		-- Get the value of the current flag
		local flag = select(i, ...)

		if not flag then
			break
		end
		flags[flag] = true
	end
end

--- Adds acquire methods to a specific companion.
-- @name Collectinator:AddCompanionAcquire
-- @usage Collectinator:AddCompanionAcquire:(DB, 2329, 8, 8)
-- @param DB The database (array) which you wish to add acquire methods too.
-- @param SpellID The [http://www.wowwiki.com/SpellLink Spell ID] of the item being entered to the database.
-- @param ... A listing of acquire methods.  See [[database-documentation]] for a listing of acquire methods and how they behave.
-- @return None, array is passed as a reference.
do
	-- Variables for getting the locations
	local location_list = {}
	local location_checklist = {}

	function addon:AddCompanionAcquire(DB, SpellID, ...)
		local numvars = select('#', ...)-- Find out how many flags we're adding
		local index = 1			-- Index for the number of Acquire entries we have
		local i = 1			-- Index for which variables we're parsing through
		local acquire = DB[SpellID]["Acquire"]

		twipe(location_list)
		twipe(location_checklist)

		while i < numvars do
			local acquire_type, acquire_id = select(i, ...)
			i = i + 2

			--[===[@alpha@
			if acquire[index] then
				self:Print("AddCompanionAcquire called more than once for SpellID "..SpellID)
			end
			--@end-alpha@]===]

			acquire[index] = {
				["Type"] = acquire_type,
				["ID"] = acquire_id
			}
			local location

			if not acquire_type then
				self:Print("SpellID: "..SpellID.." has no acquire type.")
			elseif acquire_type == A_CRAFTED then
				local craft_spell = select(i, ...)
				i = i + 1

				acquire[index]["Crafted"] = acquire_id
				--[===[@alpha@
			elseif acquire_type == A_SEASONAL then
				if not acquire_id then
					self:Print("SpellID "..SpellID..": SeasonalID is nil.")
				end
				--@end-alpha@]===]
			elseif acquire_type == A_ACHIEVEMENT then
				if not acquire_id then
					--[===[@alpha@
					self:Print("SpellID "..SpellID..": AchievementID is nil.")
					--@end-alpha@]===]
				else
					local _, achievement_name, _, _, _, _, _, achievement_desc = GetAchievementInfo(acquire_id)
					acquire[index]["Achievement"] = achievement_name
					acquire[index]["AchievementDesc"] = achievement_desc
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
				location = L["World Drop"]

				if not location_checklist[location] then
					tinsert(location_list, location)
					location_checklist[location] = true
				end
			end
			index = index + 1
		end
		-- Assign acquire locations
		tsort(location_list, function(a, b) return a < b end)
		DB[SpellID]["Locations"] = (#location_list == 0 and "" or tconcat(location_list, ", "))
	end
end	-- do

-------------------------------------------------------------------------------
-- Title DB functions
-------------------------------------------------------------------------------
-- 0 - prefix
-- 1 - suffix
-- 2 - comma-led suffix
function addon:AddTitle(title_id, title_type, era)
	if TitleDB[title_id] then
		--[===[@alpha@
		self:Print("Duplicate title - "..title_id)
		--@end-alpha@]===]
		return
	end
	TitleDB[title_id] = {
		["Name"]	= GetTitleName(title_id) or "UnNamed_"..title_id,
		["Type"]	= title_type or 0,
		["Game"]	= era or 0,
		["Owned"]	= false,
		["Display"]	= true,
		["Search"]	= true,
		["Acquire"]	= {},
	}
end

--- Adds an item to a specific database listing (ie: vendor, mob, etc)
-- @name Collectinator:addLookupList
-- @usage Collectinator:addLookupList:(VendorDB, NPC ID, NPC Name, NPC Location, X Coord, Y Coord, Faction)
-- @param DB Database which the entry will be stored.
-- @param ID Unique identified for the entry.
-- @param Name Name of the entry.
-- @param Loc Location of the entry in the world.
-- @param Coordx X coordinate of where the entry is found.
-- @param Coordy Y coordinate of where the entry is found.
-- @param Faction Faction identifier for the entry.
-- @return None, array is passed as a reference.
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

		if DB == QuestList then
			GameTooltip:SetOwner(UIParent, ANCHOR_NONE)
			GameTooltip:SetHyperlink("quest:"..tostring(ID))

			local quest_name = _G["GameTooltipTextLeft1"]:GetText()
			GameTooltip:Hide()

			DB[ID]["Name"] = quest_name and quest_name or "Missing name: Quest "..ID
		end
		--[===[@alpha@
		if not Loc and DB ~= ReputationList and DB ~= CustomList and DB ~= SeasonalList then
			self:Print("Spell ID: " .. ID .. " (" .. DB[ID]["Name"] .. ") has an unknown location.")
		end
		--@end-alpha@]===]
	end
end

-------------------------------------------------------------------------------
-- Scanning Functions
-------------------------------------------------------------------------------

--- Gets a spell ID from a spell link.
-- @name GetIDFromLink
-- @usage Collectinator:GetIDFromLink(SpellLink)
-- @param SpellLink The [[http://www.wowwiki.com/SpellLink|SpellLink]] which you wish to get the Spell ID from
-- @return The spell ID of the passed [[http://www.wowwiki.com/SpellLink|SpellLink]]
local function GetIDFromLink(SpellLink)
	-- Faster pattern matching per Neffi
	return smatch(SpellLink, "^|c%x%x%x%x%x%x%x%x|H%w+:(%d+)")
end

--- Scans the database and the local list of companions and flags which ones you know
-- @name CheckForKnownCompanions
-- @usage Collectinator:CheckForKnownCompanions(DB)
-- @param DB Companion database which we are parsing.
-- @return Companion DB is updated by reference.
function addon:CheckForKnownCompanions(DB)
	local companionlist = addon.db.profile.companionlist

	for i, SpellID in pairs(companionlist) do
		if DB[SpellID] then
			DB[SpellID]["Known"] = true
		else
			local name = GetSpellInfo(SpellID)
			self:Print("Companion: " .. name .. " (" .. SpellID .. ") not found in database.")
		end
	end
end

do
	-------------------------------------------------------------------------------
	-- Origin
	-------------------------------------------------------------------------------
	local GAME_ORIG, GAME_TBC, GAME_WOTLK = 0, 1, 2

	-------------------------------------------------------------------------------
	-- Filter flags
	-------------------------------------------------------------------------------
	local F_ALLIANCE, F_HORDE, F_VENDOR, F_QUEST, F_CRAFT, F_INSTANCE, F_RAID, F_SEASONAL, F_WORLD_DROP, F_MOB_DROP = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	local F_TCG, F_SPEC_EVENT, F_COLLECTORS, F_REMOVED, F_ACHIEVEMENT, F_PVP, F_STORE = 11, 12, 13, 14, 15, 16, 77
	local F_BOE, F_BOP, F_BOA = 17, 18, 19
	local F_ALCH, F_BS, F_COOKING, F_ENCH, F_ENG, F_FIRST_AID, F_INSC, F_JC, F_LW, F_SMELT, F_TAILOR, F_FISHING = 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32

	-------------------------------------------------------------------------------
	-- Reputation Filter Flags
	-------------------------------------------------------------------------------
	local F_ARGENT_DAWN, F_BLOODSAIL, F_CENARION_CIRCLE, F_THORIUM_BROTHERHOOD, F_TIMBERMAW, F_WINTERSRPING, F_ZANDALAR = 33, 34, 35, 36, 37, 38, 39
	local F_ALDOR, F_ASHTONGUE, F_CENARION_EXPIDITION, F_HELLFIRE, F_CONSORTIUM, F_KOT, F_LOWER_CITY, F_NAGRAND = 40, 41, 42, 43, 44, 45, 46, 47
	local F_NETHERWING, F_SCALE_SANDS, F_SCRYER, F_SHATAR, F_SKYGUARD, F_SHATTEREDSUN, F_SPOREGGAR, F_VIOLET_EYE = 48, 49, 50, 51, 52, 53, 54, 55
	local F_ARGENT_CRUSADE, F_FRENZYHEART, F_EBON_BLADE, F_KIRINTOR, F_HODIR, F_KALUAK, F_ORACLES, F_WYRMREST, F_ASHEN_VERDICT = 56, 57, 58, 59, 60, 61, 62, 63, 64
	local WRATHCOMMON1, WRATHCOMMON2, WRATHCOMMON3, WRATHCOMMON4, WRATHCOMMON5 = 64, 65, 66, 67, 68
	local F_CITY1, F_CITY2, F_CITY3, F_CITY4, F_CITY5 = 69, 70, 71, 72, 73
	local F_PVP1, F_PVP2, F_PVP3 = 74, 75, 76

	-- City 1 Darnassus/Darkspear
	-- City 2 Stormwind/Orgrimmar
	-- City 3 Gnomerga/Thunder Bluff
	-- City 4 Ironforge/Undercity
	-- City 5 Exodar/Silvermoon
	-- PVP 1 WSG
	-- PVP 2 AV
	-- PVP 3 AB
	-- Wrath Common Factions 1 (The Silver Covenant/The Sunreavers)
	-- Wrath Common Factions 2 (Explorer's League/Hand of Vengance)
	-- Wrath Common Factions 3 (Explorer's League/Valiance Expedition)
	-- Wrath Common Factions 4 (The Frostborn/The Taunka)
	-- Wrath Common Factions 5 (Alliance Vanguard/Horde Expedition)

	local reptable

	local function CreateRepTable()

		local repdb = addon.db.profile.filters.rep

		reptable = {
			-- Old World
			[F_ARGENT_DAWN] = repdb.argentdawn,
			[F_BLOODSAIL] = repdb.bloodsail,
			[F_CENARION_CIRCLE] = repdb.cenarioncircle,
			[F_THORIUM_BROTHERHOOD] = repdb.thoriumbrotherhood,
			[F_TIMBERMAW] = repdb.timbermaw,
			[F_WINTERSRPING] = repdb.winterspring,
			[F_ZANDALAR] = repdb.zandalar,
			-- BC
			[F_ALDOR] = repdb.aldor,
			[F_ASHTONGUE] = repdb.ashtonguedeathsworn,
			[F_CENARION_EXPIDITION] = repdb.cenarionexpedition,
			[F_HELLFIRE] = repdb.hellfire,
			[F_CONSORTIUM] = repdb.consortium,
			[F_KOT] = repdb.keepersoftime,
			[F_LOWER_CITY] = repdb.lowercity,
			[F_NAGRAND] = repdb.nagrand,
			[F_NETHERWING] = repdb.netherwing,
			[F_SCALE_SANDS] = repdb.scaleofthesands,
			[F_SCRYER] = repdb.scryer,
			[F_SHATAR] = repdb.shatar,
			[F_SKYGUARD] = repdb.skyguard,
			[F_SHATTEREDSUN] = repdb.shatteredsun,
			[F_SPOREGGAR] = repdb.sporeggar,
			[F_VIOLET_EYE] = repdb.violeteye,
			-- Faction Cities
			[F_CITY1] = repdb.city1,
			[F_CITY2] = repdb.city2,
			[F_CITY3] = repdb.city3,
			[F_CITY4] = repdb.city4,
			[F_CITY5] = repdb.city5,
			-- PVP
			[F_PVP1] = repdb.pvp1,
			[F_PVP2] = repdb.pvp2,
			[F_PVP3] = repdb.pvp3,
			-- Wrath
			[F_ARGENT_CRUSADE] = repdb.argentcrusade,
			[F_FRENZYHEART] = repdb.frenzyheart,
			[F_EBON_BLADE] = repdb.ebonblade,
			[F_KIRINTOR] = repdb.kirintor,
			[F_HODIR] = repdb.sonsofhodir,
			[F_KALUAK] = repdb.kaluak,
			[F_ORACLES] = repdb.oracles,
			[F_WYRMREST] = repdb.wyrmrest,
			[F_ASHEN_VERDICT] = repdb.ashenverdict,
			[WRATHCOMMON1] = repdb.wrathcommon1,
			[WRATHCOMMON2] = repdb.wrathcommon2,
			[WRATHCOMMON3] = repdb.wrathcommon3,
			[WRATHCOMMON4] = repdb.wrathcommon4,
			[WRATHCOMMON5] = repdb.wrathcommon5,
		}

	end

	function addon:ClearRepTable()
		reptable = nil
	end

	local function CanDisplayReputation(flags)
		if not reptable then
			CreateRepTable()
		end
		local display = true

		for i in pairs(reptable) do
			if flags[i] then
				display = reptable[i] and true or false
			end
		end
		return display
	end

	-- Scans a specific item to determine if it is to be displayed or not.
	function addon:CheckDisplay(Entry, playerFaction)
		-- For flag info see comments at start of file in comments
		local filter_db = addon.db.profile.filters
		local flags = Entry["Flags"]

		-- See Documentation file for logic explanation
		-- Stage 1
		-- Loop through exclusive flags (hard filters)
		-- If one of these does not pass we do not display the item
		-- So to be more effecient we'll just leave this function if there's a false
		local general_db = filter_db.general

		if not general_db.faction then
			if playerFaction == BFAC["Alliance"] and flags[F_HORDE] and not flags[F_ALLIANCE] then
				return false
			elseif playerFaction == BFAC["Horde"] and flags[F_ALLIANCE] and not flags[F_HORDE] then
				return false
			end
		end

		if not general_db.removed and flags[F_REMOVED] then
			return false
		end

		local obtain_db = filter_db.obtain

		-- Filter out "era" items
		if not obtain_db.originalwow and Entry["Game"] == GAME_ORIG then
			return false
		end

		if not obtain_db.bc and Entry["Game"] == GAME_BC then
			return false
		end

		if not obtain_db.wrath and Entry["Game"] == GAME_WOTLK then
			return false
		end

		local rarity_db = filter_db.rarity

		if not rarity_db.poor and Entry["Rarity"] == 0 then
			return false
		end

		if not rarity_db.common and Entry["Rarity"] == 1 then
			return false
		end

		if not rarity_db.uncommon and Entry["Rarity"] == 2 then
			return false
		end

		if not rarity_db.rare and Entry["Rarity"] == 3 then
			return false
		end

		if not rarity_db.epic and Entry["Rarity"] == 4 then
			return false
		end

		if not rarity_db.legendary and Entry["Rarity"] == 5 then
			return false
		end

		if not rarity_db.artifact and Entry["Rarity"] == 6 then
			return false
		end

		local profession_db = filter_db.profs

		if not profession_db.alch and flags[F_ALCH] then
			return false
		end

		if not profession_db.bs and flags[F_BS] then
			return false
		end

		if not profession_db.cook and flags[F_COOKING] then
			return false
		end

		if not profession_db.ench and flags[F_ENCH] then
			return false
		end

		if not profession_db.eng and flags[F_ENG] then
			return false
		end

		if not profession_db.fa and flags[F_FIRST_AID] then
			return false
		end

		if not profession_db.insc and flags[F_INSC] then
			return false
		end

		if not profession_db.jc and flags[F_JC] then
			return false
		end

		if not profession_db.lw and flags[F_LW] then
			return false
		end

		if not profession_db.smelt and flags[F_SMELT] then
			return false
		end

		if not profession_db.tailor and flags[F_TAILOR] then
			return false
		end

		if not profession_db.fish and flags[F_FISHING] then
			return false
		end

		local binding_db = filter_db.binding

		-- Include BoE Items in the scan? (if I want to see BoE items, only filter those that are not BoE)
		if not binding_db.itemboe and flags[F_BOE] then
			return false
		end

		-- Include BoP Items in the scan? (if I want to see BoP items, only filter those that are not BoP)
		if not binding_db.itembop and flags[F_BOP] then
			return false
		end

		-- Include BoA Items in the scan? (if I want to see BoA items, only filter those that are not BoA)
		if not binding_db.itemboa and flags[F_BOA] then
			return false
		end

		if not CanDisplayReputation(flags) then
			return false
		end

		-- Stage 2
		-- loop through nonexclusive (soft filters) flags until one is true
		-- If one of these is true (ie: we want to see trainers and there is a trainer flag) we display the item
		if obtain_db.vendor and flags[F_VENDOR] then
			return true
		end

		if obtain_db.quest and flags[F_QUEST] then
			return true
		end

		if obtain_db.instance and flags[F_INSTANCE] then
			return true
		end

		if obtain_db.craft and flags[F_CRAFT] then
			return true
		end

		if obtain_db.raid and flags[F_RAID] then
			return true
		end

		if obtain_db.seasonal and flags[F_SEASONAL] then
			return true
		end

		if obtain_db.worlddrop and flags[F_WORLD_DROP] then
			return true
		end

		if obtain_db.mobdrop and flags[F_MOB_DROP] then
			return true
		end

		if obtain_db.tcg and flags[F_TCG] then
			return true
		end

		if obtain_db.event and flags[F_SPEC_EVENT] then
			return true
		end

		if obtain_db.ce and flags[F_COLLECTORS] then
			return true
		end

		if obtain_db.removed and flags[F_REMOVED] then
			return true
		end

		if obtain_db.achievement and flags[F_ACHIEVEMENT] then
			return true
		end

		if obtain_db.pvp and flags[F_PVP] then
			return true
		end

		if obtain_db.store and flags[F_STORE] then
			return true
		end

		-- If we get here it means that no flags matched our values
		return false
	end
end

-- Scans the item listing and updates the filters according to user preferences
function addon:UpdateFilters(DB, playerData, scantype)
	local playerFaction = playerData.playerFaction
	local playerClass = playerData.playerClass
	local can_show = false
	local tmp_type = scantype
	local lower_type = tmp_type:lower()
	local known_str = lower_type .. "_known"
	local total_str = lower_type .. "_total"
	local known_filtered_str = lower_type .. "_known_filtered"
	local total_filtered_str = lower_type .. "_total_filtered"

	playerData[known_str] = 0
	playerData[total_str] = 0
	playerData[known_filtered_str] = 0
	playerData[total_filtered_str] = 0

	for ID, item in pairs(DB) do
		if item["Type"] == scantype then
			can_show = self:CheckDisplay(item, playerFaction)

			-- Increment total count of collectibles
			playerData[total_str] = playerData[total_str] + 1
			-- Increment total count of known collectibles
			playerData[known_str] = playerData[known_str] + (item["Known"] == true and 1 or 0)

			-- Filters haven't excluded this item from the list
			if can_show then
				playerData[total_filtered_str] = playerData[total_filtered_str] + 1
				playerData[known_filtered_str] = playerData[known_filtered_str] + (item["Known"] == true and 1 or 0)

				-- Include known
				if not addon.db.profile.filters.general.known and item["Known"] then
					can_show = false
				end

				-- Include unknown
				if not addon.db.profile.filters.general.unknown and not item["Known"] then
					can_show = false
				end
			end
		else
			can_show = false
		end
		DB[ID]["Display"] = can_show
	end
	self:ClearRepTable()
end

-------------------------------------------------------------------------------
-- Collectinator Logic Functions
-------------------------------------------------------------------------------

-- Determines what to do when the slash command is called.
function addon:ChatCommand(input)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)

	if not input or (input and input:trim() == "") or (input == strlower(L["Sorting"])) or (input == strlower(L["Sort"]))  or (input == strlower(L["Display"])) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	elseif input == strlower(L["About"]) then
		if (self.optionsFrame["About"]) then
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["About"])
		else
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		end
	elseif (input == strlower(L["Profile"])) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["Profiles"])
	elseif (input == strlower(L["Documentation"])) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame["Documentation"])
	elseif (input == strlower(L["Scan"])) then
		self:Scan(false)
	else
		-- What happens when we get here?
		LibStub("AceConfigCmd-3.0"):HandleCommand("collectinator", "Collectinator", input)
	end
end

-- This signifies whether or not the database should be iterated to set names/icons.
local database_initialized = false

--- Causes a scan of the companions to be conducted.
-- @name Collectinator:Scan
-- @usage Collectinator:Scan(true)
-- @param textdump Boolean indicating if we want the output to be a text dump, or if we want to use the GUI.
-- @param autoupdatescan Boolean, true if we're triggering this from an event (aka we learned a new pet), false otherwise.
-- @param scantype CRITTER for pets, MOUNT for mounts
-- @return A frame with either the text dump, or the GUI frame.
function addon:Scan(textdump, autoupdatescan, scantype)
	if not database_initialized then
		local total_pets = self:GetMiniPetTotal(CompanionDB)
		local total_mounts = self:GetMountTotal(CompanionDB)

		for spell_id, companion in pairs(CompanionDB) do
			local name, _, icon = GetSpellInfo(spell_id)

			CompanionDB[spell_id]["Name"] = name
			CompanionDB[spell_id]["ItemIcon"] = icon
		end
		database_initialized = true
	end
	playerData["critter_known"] = GetNumCompanions("CRITTER")
	playerData["mount_known"] = GetNumCompanions("MOUNT")

	for i = 1, playerData["critter_known"], 1 do
	 	local _, _, spell = GetCompanionInfo("CRITTER", i)

		if CompanionDB[spell] then
			CompanionDB[spell]["Known"] = true
		elseif spell then
			self:Print("Error: Pet with ID " .. spell .. " not in database.")
		end
	end

	for i = 1, playerData["mount_known"], 1 do
		local _, _, spell = GetCompanionInfo("MOUNT", i)

		if CompanionDB[spell] then
			CompanionDB[spell]["Known"] = true
		elseif spell then
			self:Print("Error: Mount with ID ".. tostring(spell) .. " not in database.")
		end
	end

	-- Initialize or update reputations
	playerData["Reputation"] = playerData["Reputation"] or {}
	addon:GetFactionLevels(playerData["Reputation"])

	if not autoupdatescan and scantype then
		local filter_type = (scantype == "pets" and "CRITTER" or scantype)
		self:UpdateFilters(CompanionDB, playerData, filter_type)	-- Add filtering flags to the items

		-- Mark excluded items
		playerData["known_exclude_str"], playerData["unknown_exclude_str"] = self:MarkExclusions(CompanionDB, filter_type)

		if textdump then
			if scantype == "pets" then
				self:GetWarcraftPets(CompanionDB)
			else
				self:DisplayTextDump(CompanionDB, scantype)
			end
		else
			self:DisplayFrame(playerData, VendorList, QuestList, ReputationList, SeasonalList, MobList, CustomList)
		end
	end
end

-------------------------------------------------------------------------------
-- Item Exclusion Functions
-------------------------------------------------------------------------------

--- Marks all exclusions in the item database to not be displayed
-- @name Collectinator:MarkExclusions
-- @usage Collectinator:MarkExclusions(CompanionDB, "CRITTER")
-- @param DB Reference to the entire database.
-- @param scantype What type of scan occured: CRITTER, MOUNT, etc
-- @return All entries which are to be excluded in the database have their display flag marked to false.
function addon:MarkExclusions(DB, scantype)
	local exclusionlist = addon.db.profile.exclusionlist
	local ignored = not addon.db.profile.ignoreexclusionlist
	local known_count = 0
	local unknown_count = 0

	for i in pairs(exclusionlist) do
		local entry = DB[i]

		-- We may have a item in the exclusion list that has not been scanned yet
		-- check if the entry exists in DB first
		if entry then
			if ignored then
				entry["Display"] = false
			end
			local entry_type = entry["Type"]

			if not entry["Known"] and entry_type == scantype then
				known_count = known_count + 1
			elseif entry_type == scantype then
				unknown_count = unknown_count + 1
			end
		end
	end
	return known_count, unknown_count
end

--- Removes or adds a item to the exclusion list.
-- @name Collectinator:ToggleExclude
-- @usage Collectinator:ToggleExclude
-- @param SpellID The [http://www.wowwiki.com/SpellLink Spell ID] in the database which we want to exclude
-- @return The specified [http://www.wowwiki.com/SpellLink Spell ID] is excluded from the database.
function addon:ToggleExclude(SpellID)
	local exclusion_list = addon.db.profile.exclusionlist

	exclusion_list[SpellID] = (not exclusion_list[SpellID] and true or nil)
end

--- Prints all the ID's in the exclusion list out into chat.
-- @name Collectinator:ViewExclusionList
-- @usage Collectinator:ViewExclusionList()
-- @return All the entries in the exclusion list are printed out into chat.
function addon:ViewExclusionList()
	local exclusionlist = addon.db.profile.exclusionlist

	-- Parse all items in the exclusion list
	for i in pairs(exclusionlist) do
		self:Print(i .. ": " .. GetSpellInfo(i))
	end
end

--- Clears the exclusion list of all entries.
-- @name Collectinator:ClearExclusionList
-- @usage Collectinator:ClearExclusionList()
-- @return The exclusion list is cleared.
function addon:ClearExclusionList()
	local exclusionlist = addon.db.profile.exclusionlist
	exclusionlist = twipe(exclusionlist)
end

-------------------------------------------------------------------------------
-- Searching Functions
-------------------------------------------------------------------------------
-- Goes through the item database and resets all the search flags
function addon:ResetSearch(DB)
	for SpellID in pairs(DB) do
		DB[SpellID]["Search"] = true
	end
end

-------------------------------------------------------------------------------
-- Text dumping functions
-------------------------------------------------------------------------------

-- Scans through the item database providing a string of comma seperated values for all item information
do
	local texttable = {}

	function addon:GetTextDump(DB, collectible_type)
		twipe(texttable)
		local collectible_typename

		if(collectible_type == "CRITTER") then
			collectible_typename = "\"Pets\""
		elseif(collectible_type == "MOUNT") then
			collectible_typename = "\"Mounts\""
		end

		-- Add a header to the text table
		tinsert(texttable, format("Collectinator Text Dump for %s in the form of Comma Separated Values.\n", collectible_typename))
		tinsert(texttable, "Spell ID, Item Name, Filter Flags, Acquire Methods, Known\n")

		for SpellID in pairs(DB) do
			local companion_type = DB[SpellID]["Type"]
			if companion_type == collectible_type then
				-- Add Spell ID and Item Name to the list
				tinsert(texttable, SpellID)
				tinsert(texttable, ",")
				tinsert(texttable, DB[SpellID]["Name"])
				tinsert(texttable, ",\"")

				-- Add in all the filter flags
				local flags = DB[SpellID]["Flags"]
				local prev

				-- Find out which flags are marked as "true"
				for i = 1, 76, 1 do
					if flags[i] then
						if prev then
							tinsert(texttable, ",")
						end
						tinsert(texttable, i)
						prev = true
					end
				end
				tinsert(texttable, "\",\"")

				-- Find out which unique acquire methods we have
				local acquire = DB[SpellID]["Acquire"]
				local acquirelist = {}

				for i in pairs(acquire) do
					local acquire_type = acquire[i]["Type"]

					if acquire_type == A_VENDOR then
						acquirelist["Vendor"] = true
					elseif acquire_type == A_QUEST then
						acquirelist["Quest"] = true
					elseif acquire_type == A_CRAFTED then
						acquirelist["Crafted"] = true
					elseif acquire_type == A_MOB then
						acquirelist["Mob Drop"] = true
					elseif acquire_type == A_SEASONAL then
						acquirelist["Seasonal"] = true
					elseif acquire_type == A_REPUTATION then
						acquirelist["Reputation"] = true
					elseif acquire_type == A_WORLD_DROP then
						acquirelist["World Drop"] = true
					elseif acquire_type == A_CUSTOM then
						acquirelist["Custom"] = true
					elseif acquire_type == A_ACHIEVEMENT then
						acquirelist["Achievement"] = true
					end
				end

				-- Add all the acquire methods in
				prev = false

				for i in pairs(acquirelist) do
					if prev then
						tinsert(texttable, ",")
					end
					tinsert(texttable, i)
					prev = true
				end

				if DB[SpellID]["Known"] then
					tinsert(texttable, "\",true\n")
				else
					tinsert(texttable, "\",false\n")
				end
			end
		end
		return tconcat(texttable, "")
	end
end	-- do

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
-- WarcraftPets Integration
-------------------------------------------------------------------------------
function addon:GetWarcraftPets(PetDB)
	local t = {}

	for i, k in pairs(PetDB) do
		if PetDB[i]["Known"] == true and PetDB[i]["Type"] == "CRITTER" then
			tinsert(t, "["..i.."]")
		end
	end
	self:DisplayTextDump(nil, nil, tconcat(t, ""))
end
