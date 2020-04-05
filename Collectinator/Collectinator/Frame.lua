-------------------------------------------------------------------------------
-- Frame.lua
-------------------------------------------------------------------------------
-- Frame functions for all of Collectinator
-------------------------------------------------------------------------------
-- File date: 2010-07-04T07:02:33Z
-- File revision: @file-revision@
-- Project revision: @project-revision@
-- Project version: v1.0.4
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Localized globals
-------------------------------------------------------------------------------
local _G = getfenv(0)

local string = _G.string
local strformat = string.format
local strlower = string.lower

local math = _G.math
local floor = math.floor

local table = _G.table
local twipe = table.wipe
local tinsert = table.insert
local tremove = table.remove

local ipairs = _G.ipairs
local pairs = _G.pairs

local select = _G.select
local type = _G.type

local tonumber = _G.tonumber

-------------------------------------------------------------------------------
-- Localized Blizzard API
-------------------------------------------------------------------------------
local GetSpellInfo = _G.GetSpellInfo
local GetItemInfo = _G.GetItemInfo
local UnitClass = _G.UnitClass

local IsModifierKeyDown = _G.IsModifierKeyDown
local IsShiftKeyDown = _G.IsShiftKeyDown
local IsAltKeyDown = _G.IsAltKeyDown
local IsControlKeyDown = _G.IsControlKeyDown

-------------------------------------------------------------------------------
-- AddOn namespace
-------------------------------------------------------------------------------
local MODNAME	= "Collectinator"
local addon	= LibStub("AceAddon-3.0"):GetAddon(MODNAME)

local BFAC	= LibStub("LibBabble-Faction-3.0"):GetLookupTable()
local L		= LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local QTip	= LibStub("LibQTip-1.0")

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------
local current_tab = 0
local maxVisibleCollectibles = 24
local FilterValueMap		-- Assigned in InitializeFrame()
local DisplayStrings = {}
local myFaction = ""

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Item "rarity"
-------------------------------------------------------------------------------
local R_COMMON, R_UNCOMMON, R_RARE, R_EPIC, R_LEGENDARY, R_ARTIFACT = 1, 2, 3, 4, 5, 6

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
-- Constants for acquire types.
-------------------------------------------------------------------------------
local A_VENDOR, A_QUEST, A_CRAFTED, A_MOB, A_SEASONAL, A_REPUTATION, A_WORLD_DROP, A_CUSTOM, A_ACHIEVEMENT, A_MAX = 1, 2, 3, 4, 5, 6, 7, 8, 9, 9

-------------------------------------------------------------------------------
-- Class types
-------------------------------------------------------------------------------
local C_DK, C_DRUID, C_HUNTER, C_MAGE, C_PALADIN, C_PRIEST, C_ROGUE, C_SHAMAN, C_WARLOCK, C_WARRIOR = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

-- Returns the index type based on the supplied string.
local INDEX_TYPE = {
	["CRITTER"]	= 1,
	["MOUNT"]	= 2,
}

-- Returns the index string based on the supplied type.
local INDEX_STRING = {
	[1] = "CRITTER",
	[2] = "MOUNT",
}

-------------------------------------------------------------------------------
-- Tables assigned in addon:DisplayFrame()
-------------------------------------------------------------------------------
local collectibleDB, vendorDB, questDB, repDB, seasonDB, customDB, mobDB

local allSpecTable
local playerData

local sortedCollectibleIndex

local SEASONAL_CATEGORY = GetCategoryInfo(155)

-------------------------------------------------------------------------------
-- Fonts
-------------------------------------------------------------------------------
local narrowFont = nil
local normalFont = nil

-- Font Objects needed for CollectinatorTooltip
local normalFontObj = CreateFont(MODNAME.."normalFontObj")
local narrowFontObj = CreateFont(MODNAME.."narrowFontObj")

-- Fallback in case the user doesn't have LSM-3.0 installed
if (not LibStub:GetLibrary("LibSharedMedia-3.0", true)) then

	local locale = GetLocale()
	-- Fix for font issues on koKR
	if (locale == "koKR") then
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

local CollectinatorTooltip = _G["CollectinatorTooltip"]
local CollectinatorSpellTooltip = _G["CollectinatorSpellTooltip"]

local addonversion = GetAddOnMetadata("Collectinator", "Version")
addonversion = string.gsub(addonversion, "@project.revision@", "SVN")

local Collectinator_SearchText, Collectinator_LastSearchedText
local Collectinator_ExpGeneralOptCB, Collectinator_ExpObtainOptCB, Collectinator_ExpBindingOptCB
local Collectinator_ExpRarityOptCB, Collectinator_ExpRepOptCB
local Collectinator_RepOldWorldCB, Collectinator_RepBCCB, Collectinator_RepLKCB, Collectinator_ExpMiscOptCB

-- To make tabbing between collections easier
local SortedCollections = {
	{ name = "CRITTER", 	texture = "minipets" }, -- 1
	{ name = "MOUNT", 	texture = "mounts" }, 	-- 2
}
local MaxCollections = 2

-------------------------------------------------------------------------------
-- Expanded button constants
-------------------------------------------------------------------------------
local ExpButtonText = {
	L["General"], 		-- 1
	L["Obtain"], 		-- 2
	L["Binding"], 		-- 3
	L["Rarity"], 		-- 4
	L["Reputation"], 	-- 5
	L["Miscellaneous"]	-- 6
}

local ExpButtonTT = {
	L["FILTERING_GENERAL_DESC"],	-- 1
	L["FILTERING_OBTAIN_DESC"],	-- 2
	L["FILTERING_BINDING_DESC"],	-- 3
	L["FILTERING_RARITY_DESC"], 	-- 4
	L["FILTERING_REP_DESC"], 	-- 5
	L["FILTERING_MISC_DESC"]	-- 6
}

-------------------------------------------------------------------------------
-- Static popup dialogs
-------------------------------------------------------------------------------
StaticPopupDialogs["Collectinator_NOTSCANNED"] = {
	text = L["NOTSCANNED"],
	button1 = L["Ok"],
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["Collectinator_ALLFILTERED"] = {
	text = L["ALL_FILTERED"],
	button1 = L["Ok"],
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["Collectinator_ALLKNOWN"] = {
	text = L["Collectinator_ALLKNOWN"],
	button1 = L["Ok"],
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["Collectinator_ALLEXCLUDED"] = {
	text = L["Collectinator_ALLEXCLUDED"],
	button1 = L["Ok"],
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["Collectinator_SEARCHFILTERED"] = {
	text = L["Collectinator_SEARCHFILTERED"],
	button1 = L["Ok"],
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

-------------------------------------------------------------------------------
-- Table cache mechanism
-------------------------------------------------------------------------------
local AcquireTable, ReleaseTable
do
	local table_cache = {}

	-- Returns a table
	function AcquireTable()
		local tbl = tremove(table_cache) or {}
		return tbl
	end

	-- Cleans the table and stores it in the cache
	function ReleaseTable(tbl)
		if not tbl then return end
		twipe(tbl)
		tinsert(table_cache, tbl)
	end
end	-- do block

-------------------------------------------------------------------------------
-- Close all possible pop-up windows
-------------------------------------------------------------------------------
function addon:ClosePopups()
	StaticPopup_Hide("Collectinator_NOTSCANNED")
	StaticPopup_Hide("Collectinator_ALLFILTERED")
	StaticPopup_Hide("Collectinator_ALLKNOWN")
	StaticPopup_Hide("Collectinator_ALLEXCLUDED")
	StaticPopup_Hide("Collectinator_SEARCHFILTERED")
end

-------------------------------------------------------------------------------
-- Hide the main collectible frame, and close all popups.
-------------------------------------------------------------------------------
function addon:CloseWindow()
	self:ClosePopups()
	self.Frame:Hide()
end

------------------------------------------------------------------------------
-- Locale-specific strings. Save some CPU by looking these up exactly once.
------------------------------------------------------------------------------
local factionHorde	= BFAC["Horde"]
local factionAlliance	= BFAC["Alliance"]
local factionNeutral	= BFAC["Neutral"]

local checkFactions
do
	------------------------------------------------------------------------------
	-- Reputation constants
	------------------------------------------------------------------------------
	local REP_MAGHAR	= 941
	local REP_HONOR_HOLD	= 946
	local REP_THRALLMAR	= 947
	local REP_KURENI	= 978

	---Function to determine if the player has an appropiate level of faction.
	-- @name checkFactions
	-- @usage checkFactions:(DB, collectibleIndex, playerFaction, playerRep)
	-- @param DB Database which we are checking against
	-- @param collectibleIndex Which type of collection we are scanning
	-- @param playerFaction Which faction the player doing the scan is.
	-- @param playerRep Table containing all of the players reputations.
	-- @return A boolean indicating if they can learn the collectible or not
	function checkFactions(DB, collectibleIndex, playerFaction, playerRep)
		local fac = true
		local acquire = DB[collectibleIndex]["Acquire"]

		-- Scan through all acquire types
		for i in pairs(acquire) do
			if acquire[i]["Type"] == A_REPUTATION then
				local repid = acquire[i]["ID"]

				if repid == REP_HONOR_HOLD or repid == REP_THRALLMAR then
					if playerFaction == factionAlliance then
						repid = REP_HONOR_HOLD
					else
						repid = REP_THRALLMAR
					end
				elseif repid == REP_MAGHAR or repid == REP_KURENI then
					if playerFaction == factionAlliance then
						repid = REP_KURENI
					else
						repid = REP_MAGHAR
					end
				end
				local rep_idx = repDB[repid]
				local player_rep

				if rep_idx then
					player_rep = playerRep[rep_idx["Name"]]
				end

				if (not player_rep) or (player_rep < DB[collectibleIndex]["Acquire"][i]["RepLevel"]) then
					fac = false
				else
					-- This means that the faction level is high enough, so we'll set display to true and leave the loop
					-- This should allow collectibles which have multiple reputations to work correctly
					fac = true
					break
				end
			end
		end
		return fac
	end
end	-- do

local function CanDisplayFaction(faction)
	if not addon.db.profile.filters.rep[faction] then
		return (faction == BFAC[myFaction] or faction == BFAC["Neutral"] or not faction) and true or false
	else
		return true
	end
end

do
	local function LoadZones(c, y, ...)
		-- Fill up the list for normal lookup
		for i = 1, select('#', ...), 1 do
			c[i] = select(i, ...)
		end
		-- Reverse lookup to make work easier later on
		for i in pairs(c) do
			y[c[i]] = i
		end
	end

	local C1 = {}
	local C2 = {}
	local C3 = {}
	local C4 = {}
	local c1 = {}
	local c2 = {}
	local c3 = {}
	local c4 = {}

	LoadZones(C1, c1, GetMapZones(1))
	LoadZones(C2, c2, GetMapZones(2))
	LoadZones(C3, c3, GetMapZones(3))
	LoadZones(C4, c4, GetMapZones(4))

	local iconlist = {}

	--- Clears all the icons from the map.
	-- @return All icons are removed.

	function addon:ClearMap()
		-- Make sure we have TomTom installed
		if TomTom then
			-- Remove all the waypoints from TomTom
			for i in pairs(iconlist) do
				TomTom:RemoveWaypoint(iconlist[i])
			end
			-- Nuke our own internal table
			iconlist = twipe(iconlist)
		end
	end

	--- Determine if we should display the acquire method on the maps.
	-- @return Boolean value, true for vendor, reps and quest if the faction is the same, and true for mobs.
	local function CheckMapDisplay(v, filters)
		local display = false

		-- Vendors and reputations are treated the same way basically
		if (v["Type"] == A_VENDOR) or (v["Type"] == A_REPUTATION) then
			display = ((vendorDB[v["ID"]]["Faction"] == BFAC[myFaction]) or (vendorDB[v["ID"]]["Faction"] == BFAC["Neutral"]))
		elseif (v["Type"] == A_QUEST) then
			display = ((questDB[v["ID"]]["Faction"] == BFAC[myFaction]) or (questDB[v["ID"]]["Faction"] == BFAC["Neutral"]))
		-- Always show mob drops
		elseif (v["Type"] == A_MOB) then
			display = true
		end

		return display
	end

	local BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()

	local INSTANCE_LOCATIONS = {
		[BZ["Ahn'kahet: The Old Kingdom"]] = {
			["loc"] = c1[BZ["Dragonblight"]],
			["c"] = 4,
		},
		[BZ["Auchenai Crypts"]] = {
			["loc"] = c1[BZ["Terokkar Forest"]],
			["c"] = 3,
		},
		[BZ["Azjol-Nerub"]] = {
			["loc"] = c1[BZ["Dragonblight"]],
			["c"] = 4,
		},
		[BZ["Blackrock Depths"]] = {
			["loc"] = c1[BZ["Searing Gorge"]],
			["c"] = 2,
		},
		[BZ["Blackrock Spire"]] = {
			["loc"] = c1[BZ["Searing Gorge"]],
			["c"] = 2,
		},
		[BZ["Blackwing Lair"]] = {
			["loc"] = c1[BZ["Searing Gorge"]],
			["c"] = 2,
		},
		[BZ["Dire Maul"]] = {
			["loc"] = c1[BZ["Feralas"]],
			["c"] = 1,
		},
		[BZ["Drak'Tharon Keep"]] = {
			["loc"] = c1[BZ["Zul'Drak"]],
			["c"] = 4,
		},
		[BZ["Gnomeregan"]] = {
			["loc"] = c1[BZ["Dun Morogh"]],
			["c"] = 2,
		},
		[BZ["Halls of Lightning"]] = {
			["loc"] = c1[BZ["The Storm Peaks"]],
			["c"] = 4,
		},
		[BZ["Halls of Stone"]] = {
			["loc"] = c1[BZ["The Storm Peaks"]],
			["c"] = 4,
		},
		[BZ["Karazhan"]] = {
			["loc"] = c1[BZ["Deadwind Pass"]],
			["c"] = 2,
		},
		[BZ["Magisters' Terrace"]] = {
			["loc"] = c1[BZ["Isle of Quel'Danas"]],
			["c"] = 3,
		},
		[BZ["Mana-Tombs"]] = {
			["loc"] = c1[BZ["Terokkar Forest"]],
			["c"] = 3,
		},
		[BZ["The Oculus"]] = {
			["loc"] = c1[BZ["Borean Tundra"]],
			["c"] = 4,
		},
		[BZ["Old Hillsbrad Foothills"]] = {
			["loc"] = c1[BZ["Tanaris"]],
			["c"] = 1,
		},
		[BZ["Onyxia's Lair"]] = {
			["loc"] = c1[BZ["Dustwallow Marsh"]],
			["c"] = 1,
		},
		[BZ["Ruins of Ahn'Qiraj"]] = {
			["loc"] = c1[BZ["Tanaris"]],
			["c"] = 1,
		},
		[BZ["Scholomance"]] = {
			["loc"] = c1[BZ["Western Plaguelands"]],
			["c"] = 2,
		},
		[BZ["Sethekk Halls"]] = {
			["loc"] = c1[BZ["Terokkar Forest"]],
			["c"] = 3,
		},
		[BZ["Shadow Labyrinth"]] = {
			["loc"] = c1[BZ["Terokkar Forest"]],
			["c"] = 3,
		},
		[BZ["Stratholme"]] = {
			["loc"] = c1[BZ["Eastern Plaguelands"]],
			["c"] = 2,
		},
		[BZ["Temple of Ahn'Qiraj"]] = {
			["loc"] = c1[BZ["Tanaris"]],
			["c"] = 1,
		},
		[BZ["The Arcatraz"]] = {
			["loc"] = c1[BZ["Netherstorm"]],
			["c"] = 3,
		},
		[BZ["The Black Morass"]] = {
			["loc"] = c1[BZ["Tanaris"]],
			["c"] = 1,
		},
		[BZ["The Botanica"]] = {
			["loc"] = c1[BZ["Netherstorm"]],
			["c"] = 3,
		},
		[BZ["The Deadmines"]] = {
			["loc"] = c1[BZ["Westfall"]],
			["c"] = 2,
		},
		[BZ["The Mechanar"]] = {
			["loc"] = c1[BZ["Netherstorm"]],
			["c"] = 3,
		},
		[BZ["The Nexus"]] = {
			["loc"] = c1[BZ["Borean Tundra"]],
			["c"] = 4,
		},
		[BZ["The Shattered Halls"]] = {
			["loc"] = c1[BZ["Hellfire Peninsula"]],
			["c"] = 3,
		},
		[BZ["The Slave Pens"]] = {
			["loc"] = c1[BZ["Zangarmarsh"]],
			["c"] = 3,
		},
		[BZ["The Steamvault"]] = {
			["loc"] = c1[BZ["Zangarmarsh"]],
			["c"] = 3,
		},
		[BZ["The Temple of Atal'Hakkar"]] = {
			["loc"] = c1[BZ["Swamp of Sorrows"]],
			["c"] = 2,
		},
		[BZ["The Violet Hold"]] = {
			["loc"] = c1[BZ["Dalaran"]],
			["c"] = 4,
		},
		[BZ["Utgarde Keep"]] = {
			["loc"] = c1[BZ["Howling Fjord"]],
			["c"] = 4,
		},
		[BZ["Utgarde Pinnacle"]] = {
			["loc"] = c1[BZ["Howling Fjord"]],
			["c"] = 4,
		},
		[BZ["Zul'Gurub"]] = {
			["loc"] = c1[BZ["Stranglethorn Vale"]],
			["c"] = 2,
		},
	}

	local maplist = {}

	--- Adds mini-map and world map icons with tomtom.
	-- @param single_collectible An optional collectible ID
	-- @return Points are added to the maps
	function addon:SetupMap(single_collectible)
		if not TomTom then
			--[===[@debug@
			self:Print("TomTom not loaded, integration with the world map and mini-map disabled.")
			--@end-debug@]===]
			return
		end
		local worldmap = addon.db.profile.worldmap
		local minimap = addon.db.profile.minimap

		if not (worldmap or minimap) then
			return
		end
		local autoscanmap = addon.db.profile.autoscanmap
		local filters = addon.db.profile.filters

		twipe(maplist)

		-- We're only getting a single collectible, not a bunch
		if single_collectible then
			-- loop through acquire methods, display each
			for k, v in pairs(collectibleDB[single_collectible]["Acquire"]) do
				if CheckMapDisplay(v, filters) then
					maplist[v["ID"]] = v["Type"]
				end
			end
		elseif autoscanmap then
			-- Scan through all collectibles to display, and add the vendors to a list to get their acquire info
			for i = 1, #sortedCollectibleIndex do
				local collectibleIndex = sortedCollectibleIndex[i]

				if collectibleDB[collectibleIndex]["Display"] and collectibleDB[collectibleIndex]["Search"] then
					-- loop through acquire methods, display each
					for k, v in pairs(collectibleDB[collectibleIndex]["Acquire"]) do
						if CheckMapDisplay(v, filters) then
							maplist[v["ID"]] = v["Type"]
						end
					end
				end
			end
		end

		for k, j in pairs(maplist) do
			local continent, zone
			local loc = nil

			if maplist[k] == A_VENDOR then
				loc = vendorDB[k]
			elseif maplist[k] == A_MOB then
				loc = mobDB[k]
			elseif maplist[k] == A_QUEST then
				loc = questDB[k]
			end

			if c1[loc["Location"]] then
				continent = 1
				zone = c1[loc["Location"]]
			elseif c2[loc["Location"]] then
				continent = 2
				zone = c2[loc["Location"]]
			elseif c3[loc["Location"]] then
				continent = 3
				zone = c3[loc["Location"]]
			elseif c4[loc["Location"]] then
				continent = 4
				zone = c4[loc["Location"]]
			elseif INSTANCE_LOCATIONS[loc["Location"]] then
				continent = INSTANCE_LOCATIONS[loc["Location"]]["c"]
				zone = INSTANCE_LOCATIONS[loc["Location"]]["loc"]
				name = loc["Name"] .. " (" .. loc["Location"] .. ")"
			else
				--[===[@debug@
				addon:Print("DEBUG: No continent/zone map match for mob/quest/vendor ID " .. k .. ".")
				--@end-debug@]===]

			end

			--[===[@alpha@
			if (loc["Coordx"] < -100) or (loc["Coordx"] > 100) or (loc["Coordy"] < -100) or (loc["Coordy"] > 100) then
				addon:Print("DEBUG: Invalid location coordinates for ID " .. k .. " Location: " .. location)
			end
			--@end-alpha@]===]

			if zone and continent then
				local iconuid = TomTom:AddZWaypoint(continent, zone, loc["Coordx"], loc["Coordy"], loc["Name"], false, minimap, worldmap)
				tinsert(iconlist, iconuid)
			end
		end	-- for
	end
end	-- do

-------------------------------------------------------------------------------
-- Parses the collectibles and determines which ones to display, and makes
-- them display appropriatly
-------------------------------------------------------------------------------
local function WipeDisplayStrings()
	for i = 1, #DisplayStrings do
		ReleaseTable(DisplayStrings[i])
	end
	twipe(DisplayStrings)
end

function addon.IsCorrectFaction(player_faction, flags)
	if player_faction == BFAC["Alliance"] and flags[F_HORDE] and not flags[F_ALLIANCE] then
		return false
	elseif player_faction == BFAC["Horde"] and flags[F_ALLIANCE] and not flags[F_HORDE] then
		return false
	end
	return true
end

local function initDisplayStrings()
	local exclude = addon.db.profile.exclusionlist
	local insertIndex = 1

	WipeDisplayStrings()

	for i = 1, #sortedCollectibleIndex do
		local collectibleIndex = sortedCollectibleIndex[i]
		local companion = collectibleDB[collectibleIndex]

		if companion["Display"] and companion["Search"] then
			local recStr = ""
			local can_add = false

			if exclude[collectibleIndex] then
				can_add = true
				recStr = "** " .. companion["Name"] .. " **"
			else
				local flags = companion["Flags"]

				if flags then
					can_add = true
					local _, _, _, hex = GetItemQualityColor(companion["Rarity"])
					recStr = hex..companion["Name"].."|r"
				end
			end

			if can_add then
				local hasFaction = checkFactions(collectibleDB, collectibleIndex, playerData.playerFaction, playerData["Reputation"])
				local str = AcquireTable()

				str.String = recStr

				str.sID = collectibleIndex
				str.IsCollectible = true
				str.IsExpanded = false
				tinsert(DisplayStrings, insertIndex, str)
				insertIndex = insertIndex + 1
			end
		end
	end
end

-- Description: Converting from hex to rgb (Thanks Maldivia)
local function toRGB(hex)
	local r, g, b = hex:match("(..)(..)(..)")
	return (tonumber(r, 16) / 256), (tonumber(g, 16) / 256), (tonumber(b, 16) / 256)
end

-- I want to do a bit more comprehensive tooltip processing. Things like changing font sizes,
-- adding padding to the left hand side, and using better color handling. So... this function
-- will do that for me.

local function ttAdd(
	leftPad,		-- number of times to pad two spaces on left side
	textSize,		-- add to or subtract from addon.db.profile.frameopts.fontsize to get fontsize
	narrow,			-- if 1, use ARIALN instead of FRITZQ
	str1,			-- left-hand string
	hexcolor1,		-- hex color code for left-hand side
	str2,			-- if present, this is the right-hand string
	hexcolor2)		-- if present, hex color code for right-hand side

	-- are we changing fontsize or narrow?
	local fontSize
	if ((narrow == 1) or (textSize ~= 0)) then
		local font, fontObj = normalFont, normalFontObj
		if (narrow == 1) then
			font = narrowFont
			fontObj = narrowFontObj
		end

		fontSize = addon.db.profile.frameopts.fontsize + textSize

		fontObj:SetFont(font, fontSize)
		CollectinatorTooltip:SetFont(fontObj)
	end

	-- Add in our left hand padding
	local loopPad = leftPad
	local leftStr = str1

	while loopPad > 0 do
		leftStr = "  " .. leftStr
		loopPad = loopPad - 1
	end
	local lineNum

	if str2 then
		lineNum = CollectinatorTooltip:AddLine()
		CollectinatorTooltip:SetCell(lineNum, 1, "|cff"..hexcolor1..leftStr.."|r")
		CollectinatorTooltip:SetCell(lineNum, 2, "|cff"..hexcolor2..str2.."|r", "RIGHT")
	else
		-- Text spans both columns - set maximum width to match fontSize to maintain uniform tooltip size. -Torhal
		local width = math.ceil(fontSize * 37.5)
		lineNum = CollectinatorTooltip:AddLine()
		CollectinatorTooltip:SetCell(lineNum, 1, "|cff"..hexcolor1..leftStr.."|r", nil, "LEFT", 2, nil, 0, 0, width, width)
	end
end

local function SetSpellTooltip(owner, loc, link)
	CollectinatorSpellTooltip:SetOwner(owner, "ANCHOR_NONE")
	CollectinatorSpellTooltip:ClearAllPoints()

	if loc == "Top" then
		CollectinatorSpellTooltip:SetPoint("BOTTOMLEFT", owner, "TOPLEFT")
	elseif loc == "Bottom" then
		CollectinatorSpellTooltip:SetPoint("TOPLEFT", owner, "BOTTOMLEFT")
	elseif loc == "Left" then
		CollectinatorSpellTooltip:SetPoint("TOPRIGHT", owner, "TOPLEFT")
	elseif loc == "Right" then
		CollectinatorSpellTooltip:SetPoint("TOPLEFT", owner, "TOPRIGHT")
	end
	CollectinatorSpellTooltip:SetHyperlink("item:"..link)
	CollectinatorSpellTooltip:Show()
end

local function GenerateTooltipContent(owner, rIndex)
	local spell_tip_loc = addon.db.profile.spelltooltiplocation
	local acquire_tip_loc = addon.db.profile.acquiretooltiplocation
	local companion = collectibleDB[rIndex]
	local spellLink = companion["ItemID"]

	if acquire_tip_loc == L["Off"] then
		QTip:Release(CollectinatorTooltip)
		-- If we have the spell link tooltip, anchor it to addon.Frame instead so it shows
		if spell_tip_loc ~= L["Off"] and spellLink then
			SetSpellTooltip(owner, spell_tip_loc, spellLink)
		else
			CollectinatorSpellTooltip:Hide()
		end
		return
	end
	CollectinatorTooltip = QTip:Acquire(MODNAME.." Tooltip", 2, "LEFT", "LEFT")
	CollectinatorTooltip:SetScale(addon.db.profile.frameopts.tooltipscale)
	CollectinatorTooltip:ClearAllPoints()

	if acquire_tip_loc == "Right" then
		CollectinatorTooltip:SetPoint("TOPLEFT", owner, "TOPRIGHT")
	elseif acquire_tip_loc == "Left" then
		CollectinatorTooltip:SetPoint("TOPRIGHT", owner, "TOPLEFT")
	elseif acquire_tip_loc == "Top" then
		CollectinatorTooltip:SetPoint("BOTTOMLEFT", owner, "TOPLEFT")
	elseif acquire_tip_loc == "Bottom" then
		CollectinatorTooltip:SetPoint("TOPLEFT", owner, "BOTTOMLEFT")
	elseif acquire_tip_loc == "Mouse" then
		local x, y = GetCursorPosition()
		local uiscale = UIParent:GetEffectiveScale()

		x = x / uiscale
		y = y / uiscale
		CollectinatorTooltip:ClearAllPoints()
		CollectinatorTooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
	end

	if TipTac and TipTac.AddModifiedTip then
		-- Pass true as second parameter because hooking OnHide causes C stack overflows -Torhal
		TipTac:AddModifiedTip(CollectinatorTooltip, true)
	end
	local left_color, right_color = "", ""
	local _, _, _, hex = GetItemQualityColor(companion["Rarity"])
	local item_icon = "|T"..(companion["ItemIcon"] or "Interface\\CharacterFrame\\Disconnect-Icon")..":40:40|t"

	CollectinatorTooltip:Clear()
	CollectinatorTooltip:AddHeader()
	CollectinatorTooltip:SetCell(1, 1, item_icon, "CENTER", 2)

	CollectinatorTooltip:AddHeader()
	CollectinatorTooltip:SetCell(2, 1, hex..companion["Name"], "CENTER", 2)

	-- check if the collectible is excluded
	local exclude = addon.db.profile.exclusionlist

	if exclude[rIndex] then
		ttAdd(0, -1, 1, L["COLLECTIBLE_EXCLUDED"], addon:hexcolor("RED"))
	end
	local flags = companion["Flags"]

	-- Add in skill level requirement, colored correctly
	left_color = addon:hexcolor("NORMAL")

	CollectinatorTooltip:AddSeparator()
	-- Binding info
	left_color = addon:hexcolor("NORMAL")

	if flags[F_BOE] then
		ttAdd(0, -1, 1, L["BOEFilter"], left_color)
	end

	if flags[F_BOP] then
		ttAdd(0, -1, 1, L["BOPFilter"], left_color)
	end

	if flags[F_BOA] then
		ttAdd(0, -1, 1, L["BOAFilter"], left_color)
	end
	CollectinatorTooltip:AddSeparator()
	ttAdd(0, -1, 0, L["Obtained From"] .. " : ", addon:hexcolor("NORMAL"))

	local playerFaction = playerData.playerFaction
	local acquire_type

	for k, v in pairs(companion["Acquire"]) do
		acquire_type = v["Type"]

		if acquire_type == A_VENDOR then
			local vendor = vendorDB[v["ID"]]
			local cStr = ""

			left_color = addon:hexcolor("VENDOR")

			if not vendor then
				right_color = addon:hexcolor("NEUTRAL")
				ttAdd(0, -1, 0, L["Vendor"], left_color, UNKNOWN, right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, v["ID"], left_color, cStr, right_color)
			else
				-- Don't display vendors of opposite faction
				local displaytt = false
				local faction

				if (vendor["Faction"] == factionHorde) then
					right_color = addon:hexcolor("HORDE")
					if (playerFaction == factionHorde) then
						displaytt = true
					else
						faction = factionHorde
					end
				elseif (vendor["Faction"] == factionAlliance) then
					right_color = addon:hexcolor("ALLIANCE")
					if (playerFaction == factionAlliance) then
						displaytt = true
					else
						faction = factionAlliance
					end
				else
					right_color = addon:hexcolor("NEUTRAL")
					displaytt = true
				end

				if displaytt then
					if (vendor["Coordx"] ~= 0) and (vendor["Coordy"] ~= 0) then
						cStr = "(" .. vendor["Coordx"] .. ", " .. vendor["Coordy"] .. ")"
					end

					ttAdd(0, -1, 0, L["Vendor"], left_color, vendor["Name"], right_color)
					left_color = addon:hexcolor("NORMAL")
					right_color = addon:hexcolor("HIGH")
					ttAdd(1, -2, 1, vendor["Location"], left_color, cStr, right_color)
				elseif faction and companion["Type"] ~= "MOUNT" then
					ttAdd(0, -1, 0, faction.." "..L["Vendor"], left_color)
				end
			end
		elseif acquire_type == A_CRAFTED then
			left_color = addon:hexcolor("NORMAL")
			right_color = addon:hexcolor("HIGH")
			ttAdd(0, -1, 0, _G.TRADE_SKILLS, left_color, GetSpellInfo(v["Crafted"]), right_color)
		elseif acquire_type == A_MOB then
			local mob = mobDB[v["ID"]]
			local cStr = ""

			if not mob then
				left_color = addon:hexcolor("MOBDROP")
				right_color = addon:hexcolor("NEUTRAL")
				ttAdd(0, -1, 0, L["Mob Drop"], left_color, UNKNOWN, right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, v["ID"], left_color, cStr, right_color)
			else
				if mob["Coordx"] ~= 0 and mob["Coordy"] ~= 0 then
					cStr = "(" .. mob["Coordx"] .. ", " .. mob["Coordy"] .. ")"
				end

				left_color = addon:hexcolor("MOBDROP")
				right_color = addon:hexcolor("HORDE")
				ttAdd(0, -1, 0, L["Mob Drop"], left_color, mob["Name"], right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, mob["Location"], left_color, cStr, right_color)
			end
		elseif acquire_type == A_QUEST then
			local qst = questDB[v["ID"]]

			if qst then
				left_color = addon:hexcolor("QUEST")
				-- Don't display quests of opposite faction
				local displaytt = false
				local faction

				if qst["Faction"] == factionHorde then
					right_color = addon:hexcolor("HORDE")
					if (playerFaction == factionHorde) then
						displaytt = true
					else
						faction = factionHorde
					end
				elseif qst["Faction"] == factionAlliance then
					right_color = addon:hexcolor("ALLIANCE")

					if playerFaction == factionAlliance then
						displaytt = true
					else
						faction = factionAlliance
					end
				else
					right_color = addon:hexcolor("NEUTRAL")
					displaytt = true
				end

				if displaytt then
					local cStr = ""

					if qst["Coordx"] ~= 0 and qst["Coordy"] ~= 0 then
						cStr = "(" .. qst["Coordx"] .. ", " .. qst["Coordy"] .. ")"
					end

					ttAdd(0, -1, 0, L["Quest"], left_color, qst["Name"], right_color)
					left_color = addon:hexcolor("NORMAL")
					right_color = addon:hexcolor("HIGH")
					ttAdd(1, -2, 1, qst["Location"], left_color, cStr, right_color)
				elseif faction then
					ttAdd(0, -1, 0, faction.." "..L["Quest"], left_color)
				end
			end
		elseif acquire_type == A_SEASONAL then
			left_color = addon:hexcolor("SEASON")
			ttAdd(0, -1, 0, SEASONAL_CATEGORY, left_color, seasonDB[v["ID"]]["Name"], left_color)
		elseif acquire_type == A_REPUTATION then
			local rep_vendor = vendorDB[v["RepVendor"]]
			local cStr = ""

			if not rep_vendor then
				right_color = addon:hexcolor("NEUTRAL")
				ttAdd(0, -1, 0, L["Vendor"], left_color, UNKNOWN, right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, v["ID"], left_color, cStr, right_color)
			else
				local displaytt = false

				if rep_vendor["Faction"] == factionHorde then
					if playerFaction == factionHorde then
						displaytt = true
						right_color = addon:hexcolor("HORDE")
					end
				elseif rep_vendor["Faction"] == factionAlliance then
					if playerFaction == factionAlliance then
						displaytt = true
						right_color = addon:hexcolor("ALLIANCE")
					end
				else
					displaytt = true
					right_color = addon:hexcolor("NEUTRAL")
				end

				if displaytt then
					local rep_level = v["RepLevel"]
					local rep_faction = repDB[v["ID"]]
					local repname = rep_faction and rep_faction["Name"] or "Unknown Faction"

					if rep_vendor["Coordx"] ~= 0 and rep_vendor["Coordy"] ~= 0 then
						cStr = "(" .. rep_vendor["Coordx"] .. ", " .. rep_vendor["Coordy"] .. ")"
					end
					local rep_string = ""

					if rep_level == 0 then
						rep_string = factionNeutral
						left_color = addon:hexcolor("NEUTRAL")
					elseif rep_level == 1 then
						rep_string = BFAC["Friendly"]
						left_color = addon:hexcolor("FRIENDLY")
					elseif rep_level == 2 then
						rep_string = BFAC["Honored"]
						left_color = addon:hexcolor("HONORED")
					elseif rep_level == 3 then
						rep_string = BFAC["Revered"]
						left_color = addon:hexcolor("REVERED")
					else
						rep_string = BFAC["Exalted"]
						left_color = addon:hexcolor("EXALTED")
					end
					ttAdd(0, -1, 0, rep_string, left_color, rep_vendor["Name"], right_color)

					left_color = addon:hexcolor("REP")
					right_color = addon:hexcolor("NORMAL")
					ttAdd(1, -1, 0, L["Reputation"], left_color, repname, right_color)

					left_color = addon:hexcolor("NORMAL")
					right_color = addon:hexcolor("HIGH")
					ttAdd(2, -2, 1, rep_vendor["Location"], left_color, cStr, right_color)
				end
			end
		elseif acquire_type == A_WORLD_DROP then
			-- World Drop				RarityLevel
			if (v["ID"] == R_COMMON) then
				left_color = addon:hexcolor("COMMON")
			elseif (v["ID"] == R_UNCOMMON) then
				left_color = addon:hexcolor("UNCOMMON")
			elseif (v["ID"] == R_RARE) then
				left_color = addon:hexcolor("RARE")
			elseif (v["ID"] == R_EPIC) then
				left_color = addon:hexcolor("EPIC")
			elseif (v["ID"] == R_LEGENDARY) then
				left_color = addon:hexcolor("LEGENDARY")
			elseif (v["ID"] == R_ARTIFACT) then
				left_color = addon:hexcolor("ARTIFACT")
			else
				left_color = addon:hexcolor("NORMAL")
			end
			ttAdd(0, -1, 0, L["World Drop"], left_color)
		elseif acquire_type == A_CUSTOM then
			local customname = customDB[v["ID"]]["Name"]
			ttAdd(0, -1, 0, customname, addon:hexcolor("NORMAL"))
		elseif acquire_type == A_PVP then
			-- Vendor:					VendorName
			-- VendorZone				VendorCoords
			local vendor = vendorDB[v["ID"]]

			if not vendor then
				right_color = addon:hexcolor("NEUTRAL")
				ttAdd(0, -1, 0, L["Vendor"], left_color, UNKNOWN, right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, v["ID"], left_color, cStr, right_color)
			else
				local cStr = ""

				left_color = addon:hexcolor("VENDOR")
				-- Don't display vendors of opposite faction
				local displaytt = false
				local faction

				if (vendor["Faction"] == factionHorde) then
					right_color = addon:hexcolor("HORDE")
					if (playerFaction == factionHorde) then
						displaytt = true
					else
						faction = factionHorde
					end
				elseif (vendor["Faction"] == factionAlliance) then
					right_color = addon:hexcolor("ALLIANCE")
					if (playerFaction == factionAlliance) then
						displaytt = true
					else
						faction = factionAlliance
					end
				else
					right_color = addon:hexcolor("NEUTRAL")
					displaytt = true
				end
			end

			if displaytt then
				if vendor["Coordx"] ~= 0 and vendor["Coordy"] ~= 0 then
					cStr = "(" .. vendor["Coordx"] .. ", " .. vendor["Coordy"] .. ")"
				end
				ttAdd(0, -1, 0, L["Vendor"], left_color, vendor["Name"], right_color)
				left_color = addon:hexcolor("NORMAL")
				right_color = addon:hexcolor("HIGH")
				ttAdd(1, -2, 1, vendor["Location"], left_color, cStr, right_color)
			elseif faction then
				ttAdd(0, -1, 0, faction.." "..L["Vendor"], left_color)
			end
		elseif acquire_type == A_ACHIEVEMENT then
			-- Bit of a hack since we're using achievement text to describe as much as we can
			-- If we have the avehivement flag marked, it's a real reward from achievements
			if flags[F_ACHIEVEMENT] then
				ttAdd(0, -1, 0, L["Achievement"], addon:hexcolor("NEUTRAL"), v["Achievement"], addon:hexcolor("NEUTRAL"))
				ttAdd(0, -1, 0, v["AchievementDesc"], addon:hexcolor("NORMAL"))
			-- No achievement flag means that we're just using the achievement text to describe how to get the item
			else
				ttAdd(0, -1, 0, v["AchievementDesc"], addon:hexcolor("NORMAL"))
			end
		--[===[@alpha@
		else	-- Unhandled
			ttAdd(0, -1, 0, L["Unhandled Collectible"], addon:hexcolor("NORMAL"))
		--@end-alpha@]===]
		end
	end
	CollectinatorTooltip:AddSeparator()
	CollectinatorTooltip:AddSeparator()

	left_color = addon:hexcolor("NORMAL")

	ttAdd(0, -1, 0, L["ALT_CLICK"], left_color)
	ttAdd(0, -1, 0, L["CTRL_CLICK"], left_color)
	ttAdd(0, -1, 0, L["SHIFT_CLICK"], left_color)

	if addon.db.profile.worldmap or addon.db.profile.minimap then
		ttAdd(0, -1, 0, L["CTRL_SHIFT_CLICK"], left_color)
	end
	CollectinatorTooltip:Show()

	-- If we have the spell link tooltip, link it to the acquire tooltip.
	if spell_tip_loc ~= L["Off"] and spellLink and companion["ItemIcon"] then
		SetSpellTooltip(CollectinatorTooltip, spell_tip_loc, spellLink)
	else
		CollectinatorSpellTooltip:Hide()
	end
end

-------------------------------------------------------------------------------
-- Scrollframe update stuff
-------------------------------------------------------------------------------
local CollectibleList_Update
do
	local highlight = CreateFrame("Frame", nil, UIParent)
	highlight:SetFrameStrata("TOOLTIP")
	highlight:Hide()

	highlight._texture = highlight:CreateTexture(nil, "OVERLAY")
	highlight._texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight._texture:SetBlendMode("ADD")
	highlight._texture:SetAllPoints(highlight)

	local function Button_OnLeave()
		QTip:Release(CollectinatorTooltip)
		CollectinatorSpellTooltip:Hide()
	end

	local function Bar_OnEnter(self)
		highlight:SetParent(self)
		highlight:SetAllPoints(self)
		highlight:Show()
		GenerateTooltipContent(self, DisplayStrings[self.sI].sID)
	end

	local function Bar_OnLeave()
		highlight:Hide()
		highlight:ClearAllPoints()
		highlight:SetParent(nil)
		QTip:Release(CollectinatorTooltip)
		CollectinatorSpellTooltip:Hide()
	end

	local function SetButtonScripts(bIndex)
		local pButton = addon.PlusListButton[bIndex]
		local rButton = addon.CollectibleListButton[bIndex]
		local dStringIndex = rButton.sI
		local rIndex = DisplayStrings[dStringIndex].sID

		pButton:SetScript("OnEnter",
				  function(pButton)
					  GenerateTooltipContent(pButton, rIndex)
				  end)
		pButton:SetScript("OnLeave", Button_OnLeave)

		rButton:SetScript("OnEnter", Bar_OnEnter)
		rButton:SetScript("OnLeave", Bar_OnLeave)
	end

	local function ClearButtonScripts(bIndex)
		local pButton = addon.PlusListButton[bIndex]
		local rButton = addon.CollectibleListButton[bIndex]

		pButton:SetScript("OnEnter", nil)
		pButton:SetScript("OnLeave", nil)
		rButton:SetScript("OnEnter", nil)
		rButton:SetScript("OnLeave", nil)
	end

	function CollectibleList_Update()
		-- Clear out the current buttons
		for i = 1, maxVisibleCollectibles do
			addon.CollectibleListButton[i]:SetText("")
			addon.CollectibleListButton[i].sI = 0
			addon.PlusListButton[i]:Hide()
			ClearButtonScripts(i)
		end
		local entries = #DisplayStrings

		FauxScrollFrame_Update(Collectinator_CollectibleScrollFrame, entries, maxVisibleCollectibles, 16)
		addon:ClosePopups()

		if entries > 0 then
			-- enable expand button
			Collectinator_ExpandButton:SetNormalFontObject("GameFontNormalSmall")
			Collectinator_ExpandButton:Enable()

			-- now fill in our buttons
			local listOffset = FauxScrollFrame_GetOffset(Collectinator_CollectibleScrollFrame)
			local buttonIndex = 1
			local stringsIndex = buttonIndex + listOffset
			local stayInLoop = true

			while stayInLoop do
				if DisplayStrings[stringsIndex].IsCollectible then
					addon.PlusListButton[buttonIndex]:Show()	-- display the + symbol

					if (DisplayStrings[stringsIndex].IsExpanded) then
						addon.PlusListButton[buttonIndex]:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
						addon.PlusListButton[buttonIndex]:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
						addon.PlusListButton[buttonIndex]:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
						addon.PlusListButton[buttonIndex]:SetDisabledTexture("Interface\\Buttons\\UI-MinusButton-Disabled")
					else
						addon.PlusListButton[buttonIndex]:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
						addon.PlusListButton[buttonIndex]:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
						addon.PlusListButton[buttonIndex]:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
						addon.PlusListButton[buttonIndex]:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")
					end
				else
					addon.PlusListButton[buttonIndex]:Hide()
				end
				addon.CollectibleListButton[buttonIndex]:SetText(DisplayStrings[stringsIndex].String)
				addon.CollectibleListButton[buttonIndex].sI = stringsIndex

				SetButtonScripts(buttonIndex)

				buttonIndex = buttonIndex + 1
				stringsIndex = stringsIndex + 1

				if ((buttonIndex > maxVisibleCollectibles) or (stringsIndex > entries)) then
					stayInLoop = false
				end
			end
			-- Entries are 0 here, so we have 0 to display
		else
			-- disable expand button, it's useless here and would spam the same error again
			Collectinator_ExpandButton:SetNormalFontObject("GameFontDisableSmall")
			Collectinator_ExpandButton:Disable()

			local showpopup = false

			if not addon.db.profile.hidepopup then
				showpopup = true
			end

			-- If we haven't run this before we'll show pop-ups for the first time.
			if addon.db.profile.addonversion ~= addonversion then
				addon.db.profile.addonversion = addonversion
				showpopup = true
			end

			-- If the collectible total is at 0, it means we have not scanned yet
			if playerData.collectibles_total == 0 then
				if showpopup then
					StaticPopup_Show("COLLECTINATOR_NOTSCANNED")
				end
				-- We know all the collectibles
			elseif playerData.collectibles_known == playerData.collectibles_total then
				if showpopup then
					StaticPopup_Show("COLLECTINATOR_ALLKNOWN")
				end
				-- Our filters are actually filtering something
			elseif ((playerData.collectibles_total_filtered - playerData.collectibles_known_filtered) == 0) then
				if showpopup then
					StaticPopup_Show("COLLECTINATOR_ALLFILTERED")
				end
				-- Our exclusion list is preventing something from being displayed
			elseif (playerData.excluded_collectibles_unknown ~= 0) then
				if showpopup then
					StaticPopup_Show("COLLECTINATOR_ALLEXCLUDED")
				end
				-- We have some search text that is preventing stuff from being displayed
			elseif (Collectinator_SearchText:GetText() ~= "") then
				StaticPopup_Show("COLLECTINATOR_SEARCHFILTERED")
			else
				addon:Print(L["NO_DISPLAY"])
				addon:Print("DEBUG: collectibles_total check for 0")
				addon:Print("DEBUG: collectibles_total: " .. playerData.collectibles_total)
				addon:Print("DEBUG: collectibles_total check for equal to collectibles_total")
				addon:Print("DEBUG: collectibles_known: " .. playerData.collectibles_known)
				addon:Print("DEBUG: collectibles_total: " .. playerData.collectibles_total)
				addon:Print("DEBUG: collectibles_total_filtered - collectibles_known_filtered = 0")
				addon:Print("DEBUG: collectibles_total_filtered: " .. playerData.collectibles_total_filtered)
				addon:Print("DEBUG: collectibles_known_filtered: " .. playerData.collectibles_known_filtered)
				addon:Print("DEBUG: excluded_collectibles_unknown ~= 0")
				addon:Print("DEBUG: excluded_collectibles_unknown: " .. playerData.excluded_collectibles_unknown)
			end
		end
	end
end	-- do

-- Description:

function addon:ResetGUI()

	addon.db.profile.frameopts.offsetx = 0
	addon.db.profile.frameopts.offsety = 0
	addon.db.profile.frameopts.anchorTo = ""
	addon.db.profile.frameopts.anchorFrom = ""
	addon.db.profile.frameopts.uiscale = 1
	addon.db.profile.frameopts.tooltipscale = .9
	addon.db.profile.frameopts.fontsize = 11

end

-------------------------------------------------------------------------------
-- Sorts the database depending on the configuration settings.
-------------------------------------------------------------------------------
local SortDatabase
do
	local tsort = table.sort
	local sortFuncs
	local SortedIndex = {}

	function SortDatabase(DB)
		if not sortFuncs then
			sortFuncs = {
				["Name"]	= function(a, b)
							  return DB[a]["Name"] < DB[b]["Name"]
						  end,

				-- Will only sort based off of the first acquire type
				["Acquisition"]	= function (a, b)
							  local reca = DB[a]["Acquire"][1]
							  local recb = DB[b]["Acquire"][1]

							  if not reca or not recb then
								  return not not reca
							  end

							  if reca["Type"] ~= recb["Type"] then
								  return reca["Type"] < recb["Type"]
							  end

							  if reca["Type"] == A_CUSTOM then
								  -- Sort on name if they're the same custom ID
								  if reca["ID"] == recb["ID"] then
									  return DB[a]["Name"] < DB[b]["Name"]
								  else
									  return reca["ID"] < recb["ID"]
								  end
							  else
								  return DB[a]["Name"] < DB[b]["Name"]
							  end
						  end,

				-- Will only sort based off of the first acquire type
				["Location"]	= function (a, b)
							  -- We do the or "" because of nil's, I think this would be better if I just left it as a table which was returned
							  local reca = DB[a]["Locations"] or ""
							  local recb = DB[b]["Locations"] or ""

							  local reca = string.match(reca,"(%w+), ") or reca
							  local recb = string.match(recb,"(%w+), ") or recb

							  if reca == recb then
								  return sortFuncs["Acquisition"](a, b)
--								  return DB[a]["Name"] < DB[b]["Name"]
							  else
								  return reca < recb
							  end
						  end,
			}
		end
		twipe(SortedIndex)

		-- Get all the indexes of the DB
		for n, v in pairs(DB) do
			tinsert(SortedIndex, n)
		end
		tsort(SortedIndex, sortFuncs[addon.db.profile.sorting])
		return SortedIndex
	end
end	-- do

-------------------------------------------------------------------------------
-- Displays a tooltip for the given frame.
-------------------------------------------------------------------------------
local TooltipDisplay
do
	local function Show_Tooltip(frame, motion)
		GameTooltip_SetDefaultAnchor(GameTooltip, frame)
		GameTooltip:SetText(frame.tooltip_text, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		GameTooltip:Show()
	end

	local function Hide_Tooltip()
		GameTooltip:Hide()
	end

	function TooltipDisplay(frame, textLabel)
		frame.tooltip_text = textLabel

		frame:SetScript("OnEnter", Show_Tooltip)
		frame:SetScript("OnLeave", Hide_Tooltip)
	end
end	-- do

-------------------------------------------------------------------------------
-- Under various conditions, the collectible listwill have to be re-displayed.
-- This could happen because a filter changes, a different collectible type is
-- chosen, or a new search occurred. Use this function to do all the dirty work
-------------------------------------------------------------------------------
local function ReDisplay(scan_type)
	addon:UpdateFilters(collectibleDB, playerData, INDEX_STRING[scan_type])
	sortedCollectibleIndex = SortDatabase(collectibleDB)

	playerData.excluded_collectibles_known, playerData.excluded_collectibles_unknown = addon:MarkExclusions(collectibleDB, scan_type)

	initDisplayStrings()
	addon.Frame.progress_bar:Update()

	-- Make sure our expand all button is set to expandall
	Collectinator_ExpandButton:SetText(L["EXPANDALL"])
	TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])

	-- And update our scrollframe
	CollectibleList_Update()
end

function addon.resetTitle()
	local myTitle = ""	-- reset the frame title line

	if addon.Frame._Expanded then
		local total, active = 0, 0

		for filter, info in pairs(FilterValueMap) do
			if info.svroot and info.svroot[filter] == true then
				active = active + 1
			end
			total = total + 1
		end
		myTitle = "Collectinator (v." .. addonversion .. ") - (" .. active .. "/" .. total .. " " .. L["Filters"] .. ")"
	else
		myTitle = "Collectinator (v." .. addonversion .. ")"
	end
	addon.Frame.HeadingText:SetText(addon:Normal(myTitle))
end

-- Description:

local function HideCollectinator_ExpOptCB(ignorevalue)
	Collectinator_ExpGeneralOptCB.text:SetText(addon:Yellow(ExpButtonText[1]))
	Collectinator_ExpObtainOptCB.text:SetText(addon:Yellow(ExpButtonText[2]))
	Collectinator_ExpBindingOptCB.text:SetText(addon:Yellow(ExpButtonText[3]))
	Collectinator_ExpRarityOptCB.text:SetText(addon:Yellow(ExpButtonText[4]))
	Collectinator_ExpRepOptCB.text:SetText(addon:White(ExpButtonText[5]))
	Collectinator_ExpMiscOptCB.text:SetText(addon:Yellow(ExpButtonText[6]))

	if (ignorevalue ~= "general") then
		Collectinator_ExpGeneralOptCB:SetChecked(false)
		Collectinator_ExpGeneralOptCB.text:SetText(addon:Yellow(ExpButtonText[1]))
	else
		Collectinator_ExpGeneralOptCB.text:SetText(addon:White(ExpButtonText[1]))
	end

	if (ignorevalue ~= "obtain") then
		Collectinator_ExpObtainOptCB:SetChecked(false)
		Collectinator_ExpObtainOptCB.text:SetText(addon:Yellow(ExpButtonText[2]))
	else
		Collectinator_ExpObtainOptCB.text:SetText(addon:White(ExpButtonText[2]))
	end

	if (ignorevalue ~= "binding") then
		Collectinator_ExpBindingOptCB:SetChecked(false)
		Collectinator_ExpBindingOptCB.text:SetText(addon:Yellow(ExpButtonText[3]))
	else
		Collectinator_ExpBindingOptCB.text:SetText(addon:White(ExpButtonText[3]))
	end

	if (ignorevalue ~= "rarity") then
		Collectinator_ExpRarityOptCB:SetChecked(false)
		Collectinator_ExpRarityOptCB.text:SetText(addon:Yellow(ExpButtonText[4]))
	else
		Collectinator_ExpRarityOptCB.text:SetText(addon:White(ExpButtonText[4]))
	end

	if (ignorevalue ~= "rep") then
		Collectinator_ExpRepOptCB:SetChecked(false)
		Collectinator_ExpRepOptCB.text:SetText(addon:Yellow(ExpButtonText[5]))
	else
		Collectinator_ExpRepOptCB.text:SetText(addon:White(ExpButtonText[5]))
	end

	if (ignorevalue ~= "misc") then
		Collectinator_ExpMiscOptCB:SetChecked(false)
		Collectinator_ExpMiscOptCB.text:SetText(addon:Yellow(ExpButtonText[6]))
	else
		Collectinator_ExpMiscOptCB.text:SetText(addon:White(ExpButtonText[6]))
	end
end

do
	function addon:GenericMakeCB(cButton, anchorFrame, ttText, scriptVal, row, col, misc)
		-- set the position of the new checkbox
		local xPos = 2 + ((col - 1) * 100)
		local yPos = -3 - ((row - 1) * 17)

		cButton:SetPoint("TOPLEFT", anchorFrame, "TOPLEFT", xPos, yPos)
		cButton:SetHeight(24)
		cButton:SetWidth(24)

		-- depending if we're on the misc panel thingers or not, set an alternative OnClick method
		if misc == 0 then
			cButton:SetScript("OnClick", function(self, button, down)
							     if not FilterValueMap[scriptVal] then
								     --[===[@alpha@
								     self:Print("No entry for "..scriptVal.." in FilterValueMap.")
								     --@end-alpha@]===]
								     return
							     end
							     FilterValueMap[scriptVal].svroot[scriptVal] = FilterValueMap[scriptVal].cb:GetChecked() and true or false
							     addon.resetTitle()
							     ReDisplay(current_tab)
						     end)
		else
			cButton:SetScript("OnClick", function(self, button, down)
							     addon.db.profile.ignoreexclusionlist = not addon.db.profile.ignoreexclusionlist
							     ReDisplay(current_tab)
						     end)
		end
		TooltipDisplay(cButton, ttText, 1)
	end
end	-- do

-- Description:

-------------------------------------------------------------------------------
-- Generic button-creation function and functions required for its
-- implementation
-------------------------------------------------------------------------------
do
	-- when pressed, the button should look pressed
	local function button_OnMouseDown(this)
		if this:IsEnabled() == 1 then
			this.left:SetTexture([[Interface\Buttons\UI-Panel-Button-Down]])
			this.middle:SetTexture([[Interface\Buttons\UI-Panel-Button-Down]])
			this.right:SetTexture([[Interface\Buttons\UI-Panel-Button-Down]])
		end
	end
	-- when depressed, return to normal
	local function button_OnMouseUp(this)
		if this:IsEnabled() == 1 then
			this.left:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
			this.middle:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
			this.right:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
		end
	end

	local function button_Disable(this)
		this.left:SetTexture([[Interface\Buttons\UI-Panel-Button-Disabled]])
		this.middle:SetTexture([[Interface\Buttons\UI-Panel-Button-Disabled]])
		this.right:SetTexture([[Interface\Buttons\UI-Panel-Button-Disabled]])
		this:__Disable()
		this:EnableMouse(false)
	end

	local function button_Enable(this)
		this.left:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
		this.middle:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
		this.right:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
		this:__Enable()
		this:EnableMouse(true)
	end

	function addon:GenericCreateButton(
					   bName, parentFrame, 	bHeight, bWidth,
					   anchorFrom, anchorFrame, anchorTo, xOffset, yOffset,
					   bNormFont, bHighFont, initText, tAlign, tooltipText, noTextures)
		-- I hate stretchy buttons. Thanks very much to ckknight for this code
		-- (found in RockConfig)

		local button = CreateFrame("Button", bName, parentFrame)

		button:SetWidth(bWidth)
		button:SetHeight(bHeight)

		if (noTextures == 1) then
			local left = button:CreateTexture(nil, "BACKGROUND")
			button.left = left
			local middle = button:CreateTexture(nil, "BACKGROUND")
			button.middle = middle
			local right = button:CreateTexture(nil, "BACKGROUND")
			button.right = right

			left:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
			middle:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])
			right:SetTexture([[Interface\Buttons\UI-Panel-Button-Up]])

			left:SetPoint("TOPLEFT")
			left:SetPoint("BOTTOMLEFT")
			left:SetWidth(12)
			left:SetTexCoord(0, 0.09375, 0, 0.6875)

			right:SetPoint("TOPRIGHT")
			right:SetPoint("BOTTOMRIGHT")
			right:SetWidth(12)
			right:SetTexCoord(0.53125, 0.625, 0, 0.6875)

			middle:SetPoint("TOPLEFT", left, "TOPRIGHT")
			middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
			middle:SetTexCoord(0.09375, 0.53125, 0, 0.6875)

			button:SetScript("OnMouseDown", button_OnMouseDown)
			button:SetScript("OnMouseUp", button_OnMouseUp)

			button.__Enable = button.Enable
			button.__Disable = button.Disable
			button.Enable = button_Enable
			button.Disable = button_Disable

			local highlight = button:CreateTexture(nil, "OVERLAY", "UIPanelButtonHighlightTexture")
			button:SetHighlightTexture(highlight)
		elseif (noTextures == 2) then
			button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
			button:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
			button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
			button:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")
		elseif (noTextures == 3) then
			button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
			button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Hilight")
			button:SetDisabledTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Disable")
		end

		local text = button:CreateFontString(nil, "ARTWORK")
		button:SetFontString(text)
		button.text = text
		text:SetPoint("LEFT", button, "LEFT", 7, 0)
		text:SetPoint("RIGHT", button, "RIGHT", -7, 0)
		text:SetJustifyH(tAlign)

		text:SetFontObject(bNormFont)
		--	text:SetHighlightFontObject(bHighFont)
		--	text:SetDisabledFontObject(GameFontDisableSmall)
		text:SetText(initText)
		button:SetPoint(anchorFrom, anchorFrame, anchorTo, xOffset, yOffset)

		if tooltipText and tooltipText ~= "" then
			TooltipDisplay(button, tooltipText)
		end
		return button
	end
end	-- do

-- Description: Generic function for creating my expanded panel buttons
function addon:CreateExpCB(bName, bTex, panelIndex)
	local ExpTextureSize = 34

	if ((bName == "Collectinator_RepOldWorldCB") or (bName == "Collectinator_RepBCCB") or (bName == "Collectinator_RepLKCB")) then
		local cButton = CreateFrame("CheckButton", bName, addon.Fly_Rep) -- , "UICheckButtonTemplate")
			cButton:SetWidth(100)
			cButton:SetHeight(46)
			cButton:SetChecked(false)

		local iconTex = cButton:CreateTexture(cButton:GetName() .. "buttonTex", "BORDER")
			if (bName == "Collectinator_RepLKCB") then
				iconTex:SetTexture("Interface\\Addons\\Collectinator\\img\\" .. bTex)
			else
				iconTex:SetTexture('Interface/Glues/Common/' .. bTex)
			end
			iconTex:SetWidth(100)
			iconTex:SetHeight(46)
			iconTex:SetAllPoints(cButton)

		local pushedTexture = cButton:CreateTexture(cButton:GetName() .. "pTex", "ARTWORK")
			pushedTexture:SetTexture('Interface/Buttons/UI-Quickslot-Depress')
			pushedTexture:SetAllPoints(cButton)
			cButton:SetPushedTexture(pushedTexture)
		local highlightTexture = cButton:CreateTexture()
			highlightTexture:SetTexture('Interface/Buttons/ButtonHilight-Square')
			highlightTexture:SetAllPoints(cButton)
			highlightTexture:SetBlendMode('ADD')
			cButton:SetHighlightTexture(highlightTexture)
		local checkedTexture = cButton:CreateTexture()
			checkedTexture:SetTexture('Interface/Buttons/CheckButtonHilight')
			checkedTexture:SetAllPoints(cButton)
			checkedTexture:SetBlendMode('ADD')
			cButton:SetCheckedTexture(checkedTexture)

		-- And throw up a tooltip
		if (bName == "Collectinator_RepOldWorldCB") then
			TooltipDisplay(cButton, L["FILTERING_OLDWORLD_DESC"])
		elseif (bName == "Collectinator_RepBCCB") then
			TooltipDisplay(cButton, L["FILTERING_BC_DESC"])
		else
			TooltipDisplay(cButton, L["FILTERING_WOTLK_DESC"])
		end

		return cButton
	else
		local cButton = CreateFrame("CheckButton", bName, addon.Frame) -- , "UICheckButtonTemplate")
		cButton:SetWidth(ExpTextureSize)
		cButton:SetHeight(ExpTextureSize)
		cButton:SetScript("OnClick", function()
						     addon.DoFlyaway(panelIndex)
					     end)

		local bgTex = cButton:CreateTexture(cButton:GetName() .. "bgTex", "BACKGROUND")
		bgTex:SetTexture('Interface/SpellBook/UI-Spellbook-SpellBackground')
		bgTex:SetHeight(ExpTextureSize + 6)
		bgTex:SetWidth(ExpTextureSize + 4)
		bgTex:SetTexCoord(0, (43/64), 0, (43/64))
		bgTex:SetPoint("CENTER", cButton, "CENTER", 0, 0)

		local iconTex = cButton:CreateTexture(cButton:GetName() .. "iconTex", "BORDER")
		iconTex:SetTexture('Interface/Icons/' .. bTex)
		iconTex:SetAllPoints(cButton)

		local pushedTexture = cButton:CreateTexture(cButton:GetName() .. "pTex", "ARTWORK")
		pushedTexture:SetTexture('Interface/Buttons/UI-Quickslot-Depress')
		pushedTexture:SetAllPoints(cButton)
		cButton:SetPushedTexture(pushedTexture)

		local highlightTexture = cButton:CreateTexture()
		highlightTexture:SetTexture('Interface/Buttons/ButtonHilight-Square')
		highlightTexture:SetAllPoints(cButton)
		highlightTexture:SetBlendMode('ADD')
		cButton:SetHighlightTexture(highlightTexture)

		local checkedTexture = cButton:CreateTexture()
		checkedTexture:SetTexture('Interface/Buttons/CheckButtonHilight')
		checkedTexture:SetAllPoints(cButton)
		checkedTexture:SetBlendMode('ADD')
		cButton:SetCheckedTexture(checkedTexture)

		-- Create the text object to go along with it
		local cbText = cButton:CreateFontString("cbText", "OVERLAY", "GameFontHighlight")
		cbText:SetText(addon:Yellow(ExpButtonText[panelIndex]))
		cbText:SetPoint("LEFT", cButton, "RIGHT", 5, 0)
		cbText:SetHeight(14)
		cbText:SetWidth(100)
		cbText:SetJustifyH("LEFT")
		cButton.text = cbText

		-- And throw up a tooltip
		TooltipDisplay(cButton, ExpButtonTT[panelIndex])
		cButton:Hide()
		return cButton
	end
end

local faction_strings	-- This is populated in expandEntry()

local function expandEntry(dsIndex)
	-- insertIndex is the position in DisplayStrings that we want
	-- to expand. Since we are expanding the current entry, the return
	-- value should be the index of the next button after the expansion
	-- occurs
	local obtainDB = addon.db.profile.filters.obtain
	local collectibleIndex = DisplayStrings[dsIndex].sID
	local pad = "  "
	local acquire_type

	dsIndex = dsIndex + 1

	-- Need to loop through the available acquires and put them all in
	for k, v in pairs(collectibleDB[collectibleIndex]["Acquire"]) do
		-- Initialize the first line here, since every type below will have one.
		local t = AcquireTable()
		t.IsCollectible = false
		t.sID = collectibleIndex
		t.IsExpanded = true

		acquire_type = v["Type"]

		if acquire_type == A_VENDOR and (obtainDB.vendor or obtainDB.pvp) then
			-- Right now PVP obtained items are located on vendors so they have the vendor and pvp flag.
			-- We need to display the vendor in the drop down if we want to see vendors or if we want to see PVP
			-- This allows us to select PVP only and to see just the PVP collectibles
			local vendor = vendorDB[v["ID"]]

			if vendor then
				local nStr = ""

				if vendor["Faction"] == factionHorde then
					nStr = addon:Horde(vendor["Name"])
				elseif vendor["Faction"] == factionAlliance then
					nStr = addon:Alliance(vendor["Name"])
				else
					nStr = addon:Neutral(vendor["Name"])
				end
				t.String = pad .. addon:Vendor(L["Vendor"] .. " : ") .. nStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				local cStr = ""

				if (vendor["Coordx"] ~= 0) and (vendor["Coordy"] ~= 0) then
					cStr = addon:Coords("(" .. vendor["Coordx"] .. ", " .. vendor["Coordy"] .. ")")
				end
				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true
				t.String = pad .. pad .. vendor["Location"] .. " " .. cStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1
			end
		elseif acquire_type == A_CRAFTED and (obtainDB.craft) then
			t.String = pad .. addon:Normal(GetSpellInfo(v["Crafted"]))
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		-- Mobs can be in instances, raids, or specific mob related drops.
		elseif acquire_type == A_MOB and (obtainDB.mobdrop or obtainDB.instance or obtainDB.raid) then
			local mob = mobDB[v["ID"]]

			if mob then
				t.String = pad .. addon:MobDrop(L["Mob Drop"] .. " : ") .. addon:Red(mob["Name"])

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				local cStr = ""

				if (mob["Coordx"] ~= 0) and (mob["Coordy"] ~= 0) then
					cStr = addon:Coords("(" .. mob["Coordx"] .. ", " .. mob["Coordy"] .. ")")
				end
				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true
				t.String = pad .. pad .. mob["Location"] .. " " .. cStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1
			end
		elseif acquire_type == A_QUEST and obtainDB.quest then
			local quest = questDB[v["ID"]]

			if quest then
				local nStr = ""

				if (quest["Faction"] == factionHorde) then
					nStr = addon:Horde(quest["Name"])
				elseif (quest["Faction"] == factionAlliance) then
					nStr = addon:Alliance(quest["Name"])
				else
					nStr = addon:Neutral(quest["Name"])
				end
				t.String = pad .. addon:Quest(L["Quest"] .. " : ") .. nStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				local cStr = ""

				if (quest["Coordx"] ~= 0) and (quest["Coordy"] ~= 0) then
					cStr = addon:Coords("(" .. quest["Coordx"] .. ", " .. quest["Coordy"] .. ")")
				end
				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true
				t.String = pad .. pad .. quest["Location"] .. " " .. cStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1
			end
		elseif acquire_type == A_SEASONAL and obtainDB.seasonal then
			t.String = pad .. addon:Season(SEASONAL_CATEGORY .. " : " .. seasonDB[v["ID"]]["Name"])
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		elseif acquire_type == A_REPUTATION then -- Need to check if we're displaying the currently id'd rep or not as well
			-- Reputation Obtain
			-- Rep: ID, Faction
			-- RepLevel = 0 (Neutral), 1 (Friendly), 2 (Honored), 3 (Revered), 4 (Exalted)
			-- RepVendor - VendorID
			local rep_vendor = vendorDB[v["RepVendor"]]

			if rep_vendor then
				t.String = pad .. addon:Rep(L["Reputation"] .. " : ") .. (repDB[v["ID"]] and repDB[v["ID"]]["Name"] or "Unknown Faction")
				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				if not faction_strings then
					faction_strings = {
						[0] = addon:Neutral(factionNeutral .. " : "),
						[1] = addon:Friendly(BFAC["Friendly"] .. " : "),
						[2] = addon:Honored(BFAC["Honored"] .. " : "),
						[3] = addon:Revered(BFAC["Revered"] .. " : "),
						[4] = addon:Exalted(BFAC["Exalted"] .. " : ")
					}
				end
				local nStr = ""

				if (rep_vendor["Faction"] == factionHorde) then
					nStr = addon:Horde(rep_vendor["Name"])
				elseif (rep_vendor["Faction"] == factionAlliance) then
					nStr = addon:Alliance(rep_vendor["Name"])
				else
					nStr = addon:Neutral(rep_vendor["Name"])
				end
				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true

				t.String = pad .. pad .. faction_strings[v["RepLevel"]] .. nStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				local cStr = ""

				if (rep_vendor["Coordx"] ~= 0) and (rep_vendor["Coordy"] ~= 0) then
					cStr = addon:Coords("(" .. rep_vendor["Coordx"] .. ", " .. rep_vendor["Coordy"] .. ")")
				end
				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true
				t.String = pad .. pad .. pad .. rep_vendor["Location"] .. " " .. cStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1
			end
		elseif acquire_type == A_WORLD_DROP and obtainDB.worlddrop then
			t.String = pad .. addon:RarityColor(v["ID"] + 1, L["World Drop"])
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		elseif acquire_type == A_CUSTOM then
			t.String = pad .. addon:Normal(customDB[v["ID"]]["Name"])
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		elseif acquire_type == A_ACHIEVEMENT then
			t.String = pad .. addon:Normal(v["Achievement"])
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		elseif acquire_type == A_PVP and obtainDB.pvp then
			local vendor = vendorDB[v["ID"]]

				local cStr = ""

				if (vendor["Coordx"] ~= 0) and (vendor["Coordy"] ~= 0) then
					cStr = addon:Coords("(" .. vendor["Coordx"] .. ", " .. vendor["Coordy"] .. ")")
				end
				local nStr = ""

				if (vendor["Faction"] == factionHorde) then
					nStr = addon:Horde(vendor["Name"])
				elseif (vendor["Faction"] == factionAlliance) then
					nStr = addon:Alliance(vendor["Name"])
				else
					nStr = addon:Neutral(vendor["Name"])
				end
				t.String = pad .. addon:Vendor(L["Vendor"] .. " : ") .. nStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1

				t = AcquireTable()
				t.IsCollectible = false
				t.sID = collectibleIndex
				t.IsExpanded = true
				t.String = pad .. pad .. vendor["Location"] .. " " .. cStr

				tinsert(DisplayStrings, dsIndex, t)
				dsIndex = dsIndex + 1
		--[===[@alpha@
		elseif	(v["Type"] > A_MAX) then -- We have an acquire type we aren't sure how to deal with.
			t.String = "Unhandled Acquire Case - Type: " .. v["Type"]
			tinsert(DisplayStrings, dsIndex, t)
			dsIndex = dsIndex + 1
		--@end-alpha@]===]
		end
	end
	return dsIndex
end

-- Description:

function addon.CollectibleItem_OnClick(button)
	local clickedIndex = addon.CollectibleListButton[button].sI

	-- Don't do anything if they've clicked on an empty button
	if not clickedIndex or clickedIndex == 0 then
		return
	end
	local isCollectible = DisplayStrings[clickedIndex].IsCollectible
	local isExpanded = DisplayStrings[clickedIndex].IsExpanded
	local dString = DisplayStrings[clickedIndex].String
	local clickedSpellIndex = DisplayStrings[clickedIndex].sID
	local traverseIndex = 0

	-- First, check if this is a "modified" click, and react appropriately
	if IsModifierKeyDown() then
		if IsControlKeyDown() and IsShiftKeyDown() then
			addon:SetupMap(clickedSpellIndex)
		elseif IsShiftKeyDown() then
			local itemID = collectibleDB[clickedSpellIndex]["ItemID"]

			if itemID then
				local _, itemLink = GetItemInfo(itemID)

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
		elseif IsControlKeyDown() then
			local edit_box = _G.ChatEdit_ChooseBoxForSend()

			_G.ChatEdit_ActivateChat(edit_box)
			edit_box:Insert(collectibleDB[clickedSpellIndex]["CollectibleLink"])
		elseif IsAltKeyDown() then
			-- Code needed here to insert this item into the "Ignore List"
			addon:ToggleExclude(clickedSpellIndex)
			ReDisplay(current_tab)
		end
	elseif isCollectible then
		-- three possibilities here (all with no modifiers)
		-- 1) We clicked on the collectible button on a closed collectible
		-- 2) We clicked on the collectible button of an open collectible
		-- 3) we clicked on the expanded text of an open collectible
		if isExpanded then
			traverseIndex = clickedIndex + 1	-- get rid of our expanded lines

			while (DisplayStrings[traverseIndex].IsCollectible == false) do
				tremove(DisplayStrings, traverseIndex)

				-- if this is the last entry in the whole list, we should break out
				if not DisplayStrings[traverseIndex] then
					break
				end
			end
			DisplayStrings[clickedIndex].IsExpanded = false
		else
			-- add in our expanded lines
			expandEntry(clickedIndex)
			-- set our current collectible to expanded
			DisplayStrings[clickedIndex].IsExpanded = true
		end
	else
		-- this inherently implies that we're on an expanded collectible
		-- first, back up in the list of buttons until we find our collectible line
		traverseIndex = clickedIndex - 1

		while (DisplayStrings[traverseIndex].IsCollectible == false) do
			traverseIndex = traverseIndex - 1
		end
		DisplayStrings[traverseIndex].IsExpanded = false	-- unexpand it
		traverseIndex = traverseIndex + 1

		-- now remove the expanded lines until we get to a collectible again
		while (DisplayStrings[traverseIndex].IsCollectible == false) do
			tremove(DisplayStrings, traverseIndex)

			-- if this is the last entry in the whole list, we should break out
			if not DisplayStrings[traverseIndex] then
				break
			end
		end
	end
	-- finally, call our scrollframe updater
	CollectibleList_Update()
end

-- Description: Rep Filtering panel switcher

function addon.RepFilterSwitch(whichrep)
	-- 1	Collectinator_RepOldWorldCB		Old World Rep
	-- 2	Collectinator_RepBCCB				Burning Crusade
	-- 3	Collectinator_RepLKCB				Wrath of the Lich King
	local ShowPanel = false

	if (whichrep == 1) then

		if (Collectinator_RepOldWorldCB:GetChecked()) then

			ShowPanel = true
			addon.Fly_Rep_OW:Show()
			addon.Fly_Rep_BC:Hide()
			addon.Fly_Rep_LK:Hide()
			Collectinator_RepBCCB:SetChecked(false)
			Collectinator_RepLKCB:SetChecked(false)

		else

			ShowPanel = false

		end

	elseif (whichrep == 2) then

		if (Collectinator_RepBCCB:GetChecked()) then

			ShowPanel = true
			addon.Fly_Rep_OW:Hide()
			addon.Fly_Rep_BC:Show()
			addon.Fly_Rep_LK:Hide()
			Collectinator_RepOldWorldCB:SetChecked(false)
			Collectinator_RepLKCB:SetChecked(false)

		else

			ShowPanel = false

		end

	else -- whichrep == 3 (WotLK)

		if (Collectinator_RepLKCB:GetChecked()) then

			ShowPanel = true
			addon.Fly_Rep_OW:Hide()
			addon.Fly_Rep_BC:Hide()
			addon.Fly_Rep_LK:Show()
			Collectinator_RepOldWorldCB:SetChecked(false)
			Collectinator_RepBCCB:SetChecked(false)

		else

			ShowPanel = false

		end

	end

	if (ShowPanel == true) then

		addon.flyTexture:ClearAllPoints()
		addon.Flyaway:SetWidth(296)
		addon.Flyaway:SetHeight(312)
		addon.flyTexture:SetTexture([[Interface\Addons\Collectinator\img\fly_repcol]])
		addon.flyTexture:SetAllPoints(addon.Flyaway)
		addon.flyTexture:SetTexCoord(0, (296/512), 0, (312/512))

		addon.Fly_Rep_OW:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -14)
		addon.Fly_Rep_BC:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -14)
		addon.Fly_Rep_LK:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -14)

	else

		addon.flyTexture:ClearAllPoints()
		addon.Flyaway:SetWidth(136)
		addon.Flyaway:SetHeight(312)
		addon.flyTexture:SetTexture([[Interface\Addons\Collectinator\img\fly_1col]])
		addon.flyTexture:SetAllPoints(addon.Flyaway)
		addon.flyTexture:SetTexCoord(0, (136/256), 0, (312/512))
		addon.Fly_Rep_OW:Hide()
		addon.Fly_Rep_BC:Hide()
		addon.Fly_Rep_LK:Hide()
		Collectinator_RepOldWorldCB:SetChecked(false)
		Collectinator_RepBCCB:SetChecked(false)
		Collectinator_RepLKCB:SetChecked(false)

	end

end

-- Description:
local function recursiveReset(t)
	-- Thanks to Antiarc for this code
	for k, v in pairs(t) do
		if type(v) == "table" then
			recursiveReset(v)
		else
			t[k] = true
		end
	end
end

-- Description:
function addon.DoFlyaway(panel)

	-- This is going to manage the flyaway panel, as well as checking or unchecking the
	-- buttons that got us here in the first place
	--
	-- our panels are:
	-- 1	Collectinator_ExpGeneralOptCB			General Filters
	-- 2	Collectinator_ExpObtainOptCB			Obtain Filters
	-- 3	Collectinator_ExpBindingOptCB			Binding Filters
	-- 4	Collectinator_ExpRarityOptCB			Rarity Filters
	-- 5	Collectinator_ExpRepOptCB			Reputation Filters
	-- 6	Collectinator_ExpMiscOptCB			Miscellaneous Filters

	local ChangeFilters = false

	addon.Fly_Rep_OW:Hide()
	addon.Fly_Rep_BC:Hide()
	addon.Fly_Rep_LK:Hide()
	Collectinator_RepOldWorldCB:SetChecked(false)
	Collectinator_RepBCCB:SetChecked(false)
	Collectinator_RepLKCB:SetChecked(false)

	if (panel == 1) then

		if (Collectinator_ExpGeneralOptCB:GetChecked()) then

			-- uncheck all other buttons
			HideCollectinator_ExpOptCB("general")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Show()
			addon.Fly_Obtain:Hide()
			addon.Fly_Binding:Hide()
			addon.Fly_Rarity:Hide()
			addon.Fly_Rep:Hide()
			addon.Fly_Misc:Hide()

			ChangeFilters = true

		else

			Collectinator_ExpGeneralOptCB.text:SetText(addon:Yellow(ExpButtonText[1]))
			ChangeFilters = false

		end

	elseif (panel == 2) then

		if (Collectinator_ExpObtainOptCB:GetChecked()) then

			HideCollectinator_ExpOptCB("obtain")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Hide()
			addon.Fly_Obtain:Show()
			addon.Fly_Binding:Hide()
			addon.Fly_Rarity:Hide()
			addon.Fly_Rep:Hide()
			addon.Fly_Misc:Hide()

			ChangeFilters = true

		else

			Collectinator_ExpObtainOptCB.text:SetText(addon:Yellow(ExpButtonText[2]))
			ChangeFilters = false

		end

	elseif (panel == 3) then

		if (Collectinator_ExpBindingOptCB:GetChecked()) then

			HideCollectinator_ExpOptCB("binding")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Hide()
			addon.Fly_Obtain:Hide()
			addon.Fly_Binding:Show()
			addon.Fly_Rarity:Hide()
			addon.Fly_Rep:Hide()
			addon.Fly_Misc:Hide()

			ChangeFilters = true

		else

			Collectinator_ExpBindingOptCB.text:SetText(addon:Yellow(ExpButtonText[3]))
			ChangeFilters = false

		end

	elseif (panel == 4) then

		if (Collectinator_ExpRarityOptCB:GetChecked()) then

			HideCollectinator_ExpOptCB("rarity")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Hide()
			addon.Fly_Obtain:Hide()
			addon.Fly_Binding:Hide()
			addon.Fly_Rarity:Show()
			addon.Fly_Rep:Hide()
			addon.Fly_Misc:Hide()

			ChangeFilters = true

		else

			Collectinator_ExpRarityOptCB.text:SetText(addon:Yellow(ExpButtonText[4]))
			ChangeFilters = false

		end

	elseif (panel == 5) then
		if (Collectinator_ExpRepOptCB:GetChecked()) then

			HideCollectinator_ExpOptCB("rep")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Hide()
			addon.Fly_Obtain:Hide()
			addon.Fly_Binding:Hide()
			addon.Fly_Rarity:Hide()
			addon.Fly_Rep:Show()
			addon.Fly_Misc:Hide()

			ChangeFilters = true

		else

			Collectinator_ExpRepOptCB.text:SetText(addon:Yellow(ExpButtonText[5]))
			ChangeFilters = false

		end
	elseif (panel == 6) then
		if (Collectinator_ExpMiscOptCB:GetChecked()) then

			HideCollectinator_ExpOptCB("misc")

			-- display the correct subframe with all the buttons and such, hide the others
			addon.Fly_General:Hide()
			addon.Fly_Obtain:Hide()
			addon.Fly_Binding:Hide()
			addon.Fly_Rarity:Hide()
			addon.Fly_Rep:Hide()
			addon.Fly_Misc:Show()

			ChangeFilters = true

		else

			Collectinator_ExpMiscOptCB.text:SetText(addon:Yellow(ExpButtonText[6]))
			ChangeFilters = false

		end

	end

	if ChangeFilters then
		-- Depending on which panel we're showing, either display one column
		-- or two column
		if ((panel == 2) or (panel == 3) or (panel == 6)) then
			addon.flyTexture:ClearAllPoints()
			addon.Flyaway:SetWidth(234)
			addon.Flyaway:SetHeight(312)
			addon.flyTexture:SetTexture([[Interface\Addons\Collectinator\img\fly_2col]])
			addon.flyTexture:SetAllPoints(addon.Flyaway)
			addon.flyTexture:SetTexCoord(0, (234/256), 0, (312/512))
		elseif ((panel == 1) or (panel == 4) or (panel == 5)) then
			addon.flyTexture:ClearAllPoints()
			addon.Flyaway:SetWidth(136)
			addon.Flyaway:SetHeight(312)
			addon.flyTexture:SetTexture([[Interface\Addons\Collectinator\img\fly_1col]])
			addon.flyTexture:SetAllPoints(addon.Flyaway)
			addon.flyTexture:SetTexCoord(0, (136/256), 0, (312/512))
		end
		-- Change the filters to the current panel
		addon.Flyaway:Show()
	else
		-- We're hiding, don't bother changing anything
		addon.Flyaway:Hide()
	end
end

-- Description: This does an initial fillup of the DisplayStrings, as above.
-- However, in this case, it expands every collectible

local function expandallDisplayStrings()
	local exclude = addon.db.profile.exclusionlist
	local insertIndex = 1

	WipeDisplayStrings()

	for i = 1, #sortedCollectibleIndex do
		local collectibleIndex = sortedCollectibleIndex[i]
		local companion = collectibleDB[collectibleIndex]

		if companion["Display"] and companion["Search"] then
			local recStr = ""

			if exclude[collectibleIndex] then
				can_add = true
				recStr = "** " .. companion["Name"] .. " **"
			else
				local flags = companion["Flags"]

				if flags then
					can_add = true
					local _, _, _, hex = GetItemQualityColor(companion["Rarity"])
					recStr = hex..companion["Name"].."|r"
				end
			end

			if can_add then
				local hasFaction = checkFactions(collectibleDB, collectibleIndex, playerData.playerFaction, playerData["Reputation"])
				local t = AcquireTable()

				t.String = recStr
				t.sID = sortedCollectibleIndex[i]
				t.IsCollectible = true

				if companion["Acquire"] then
					-- we have acquire information for this. push the title entry into the strings
					-- and start processing the acquires
					t.IsExpanded = true
					tinsert(DisplayStrings, insertIndex, t)
					insertIndex = expandEntry(insertIndex)
				else
					t.IsExpanded = false
					tinsert(DisplayStrings, insertIndex, t)
					insertIndex = insertIndex + 1
				end
			end
		end
	end
end

-- Description:

function addon.ExpandAll_Clicked()

	-- Called when the expand all button is clicked
	if (Collectinator_ExpandButton:GetText() == L["EXPANDALL"]) then
		Collectinator_ExpandButton:SetText(L["CONTRACTALL"])
		TooltipDisplay(Collectinator_ExpandButton, L["CONTRACTALL_DESC"])
		expandallDisplayStrings()
	else
		Collectinator_ExpandButton:SetText(L["EXPANDALL"])
		TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])
		initDisplayStrings()
	end
	CollectibleList_Update()

end

-- Description:

local function SetSortName()

	local sorttype = addon.db.profile.sorting

	if (sorttype == "Name") then
		Collectinator_DD_SortText:SetText(L["Sort"] .. ": " .. L["Name"])
	elseif (sorttype == "Acquisition") then
		Collectinator_DD_SortText:SetText(L["Sort"] .. ": " .. L["Acquisition"])
	elseif (sorttype == "Location") then
		Collectinator_DD_SortText:SetText(L["Sort"] .. ": " .. L["Location"])
	end

end

-- Description:

local function Collectinator_DD_Sort_OnClick(button, value)
	CloseDropDownMenus()
	addon.db.profile.sorting = value
	SetSortName()
	ReDisplay(current_tab)
end

-- Description:

local function Collectinator_DD_Sort_Initialize()

	local k
	local info = UIDropDownMenu_CreateInfo()

	k = "Name"
		info.text = k
		info.arg1 = info.text
		info.func = Collectinator_DD_Sort_OnClick
		info.checked = (addon.db.profile.sorting == k)
		UIDropDownMenu_AddButton(info)
	k = "Acquisition"
		info.text = k
		info.arg1 = info.text
		info.func = Collectinator_DD_Sort_OnClick
		info.checked = (addon.db.profile.sorting == k)
		UIDropDownMenu_AddButton(info)
	k = "Location"
		info.text = k
		info.arg1 = info.text
		info.func = Collectinator_DD_Sort_OnClick
		info.checked = (addon.db.profile.sorting == k)
		UIDropDownMenu_AddButton(info)

	SetSortName()

end

-- Description: Saves the frame position into the database
-- Expected result: Frame coordinates are saved
-- Input: None
-- @return Database values updated with frame position

local function SaveFramePosition()

	local opts = addon.db.profile.frameopts
	local from, _, to, x, y = addon.Frame:GetPoint()
	opts.anchorFrom = from
	opts.anchorTo = to
	if (addon.Frame._Expanded == true) then
		if (opts.anchorFrom == "TOPLEFT") or
		(opts.anchorFrom == "LEFT") or
		(opts.anchorFrom == "BOTTOMLEFT") then
			opts.offsetx = x
		elseif (opts.anchorFrom == "TOP") or
		(opts.anchorFrom == "CENTER") or
		(opts.anchorFrom == "BOTTOM") then
			opts.offsetx = x - 151/2
		elseif (opts.anchorFrom == "TOPRIGHT") or
		(opts.anchorFrom == "RIGHT") or
		(opts.anchorFrom == "BOTTOMRIGHT") then
			opts.offsetx = x - 151
		end
	else
		opts.offsetx = x
	end
	opts.offsety = y

end

local function SetFramePosition()

	addon.Frame:ClearAllPoints()

	local opts = addon.db.profile.frameopts
	local FixedOffsetX = opts.offsetx

	if (opts.anchorTo == "") then
		-- no values yet, clamp to whatever frame is appropriate
		addon.Frame:SetPoint("TOPLEFT", PetPaperDollFrameCompanionFrame, "TOPRIGHT", 10, 0)
	else
		if (addon.Frame._Expanded == true) then
			if (opts.anchorFrom == "TOPLEFT") or
			(opts.anchorFrom == "LEFT") or
			(opts.anchorFrom == "BOTTOMLEFT") then
				FixedOffsetX = opts.offsetx
			elseif (opts.anchorFrom == "TOP") or
			(opts.anchorFrom == "CENTER") or
			(opts.anchorFrom == "BOTTOM") then
				FixedOffsetX = opts.offsetx + 151/2
			elseif (opts.anchorFrom == "TOPRIGHT") or
			(opts.anchorFrom == "RIGHT") or
			(opts.anchorFrom == "BOTTOMRIGHT") then
				FixedOffsetX = opts.offsetx + 151
			end
		end
		addon.Frame:SetPoint(opts.anchorFrom, UIParent, opts.anchorTo, FixedOffsetX, opts.offsety)
	end

end

-------------------------------------------------------------------------------
-- Creates the initial display frame for collectible info.
-------------------------------------------------------------------------------
local function InitializeFrame()
	local CreateFrame = _G.CreateFrame

	-------------------------------------------------------------------------------
	-- Check to see if we're Horde or Alliance, and change the displayed
	-- reputation strings to be faction-correct.
	-------------------------------------------------------------------------------
	local isAlliance = (myFaction == "Alliance")

	local HonorHold_Thrallmar_FactionText = isAlliance and BFAC["Honor Hold"] or BFAC["Thrallmar"]
	local Kurenai_Maghar_FactionText = isAlliance and BFAC["Kurenai"] or BFAC["The Mag'har"]
	local Vanguard_Expedition_FactionText = isAlliance and BFAC["Alliance Vanguard"] or BFAC["Horde Expedition"]
	local SilverConv_Sunreaver_FactionText = isAlliance and BFAC["The Silver Covenant"] or BFAC["The Sunreavers"]
	local Valiance_Warsong_FactionText = isAlliance and BFAC["Valiance Expedition"] or BFAC["Warsong Offensive"]
	local Frostborn_Taunka_FactionText = isAlliance and BFAC["The Frostborn"] or BFAC["The Taunka"]
	local Explorer_Hand_FactionText = isAlliance and BFAC["Explorers' League"] or BFAC["The Hand of Vengeance"]
	local City1_FactionText = isAlliance and BFAC["Darnassus"] or BFAC["Undercity"]
	local City2_FactionText = isAlliance and BFAC["Stormwind"] or BFAC["Orgrimmar"]
	local City3_FactionText = isAlliance and BFAC["Gnomeregan Exiles"] or BFAC["Thunder Bluff"]
	local City4_FactionText = isAlliance and BFAC["Ironforge"] or BFAC["Darkspear Trolls"]
	local City5_FactionText = isAlliance and BFAC["Exodar"] or BFAC["Silvermoon City"]
	local PVP1_FactionText = isAlliance and BFAC["Silverwing Sentinels"] or BFAC["Warsong Outriders"]
	local PVP2_FactionText = isAlliance and BFAC["Stormpike Guard"] or BFAC["Frostwolf Clan"]
	local PVP3_FactionText = isAlliance and BFAC["The League of Arathor"] or BFAC["The Defilers"]

	-------------------------------------------------------------------------------
	-- Create the main frame
	-------------------------------------------------------------------------------
	addon.Frame = CreateFrame("Frame", "Collectinator.Frame", UIParent)

	--Allows Collectinator to be closed with the Escape key
	tinsert(UISpecialFrames, "Collectinator.Frame")

	addon.Frame:SetWidth(293)
	addon.Frame:SetHeight(447)

	addon.bgTexture = addon.Frame:CreateTexture("Collectinator.bgTexture", "ARTWORK")
	addon.bgTexture:SetTexture("Interface\\Addons\\Collectinator\\img\\main")
	addon.bgTexture:SetAllPoints(addon.Frame)
	addon.bgTexture:SetTexCoord(0, (293/512), 0, (447/512))
	addon.Frame:SetFrameStrata("DIALOG")
	addon.Frame:SetHitRectInsets(5, 5, 5, 5)

	addon.Frame:EnableMouse(true)
	addon.Frame:EnableKeyboard(true)
	addon.Frame:SetMovable(true)

	-------------------------------------------------------------------------------
	-- Assign the frame scripts, then show it.
	-------------------------------------------------------------------------------
	addon.Frame:SetScript("OnMouseDown", function()	addon.Frame:StartMoving() end)

	addon.Frame:SetScript("OnHide", function() addon:CloseWindow() end)
	addon.Frame:SetScript("OnMouseUp",
			      function()
				      addon.Frame:StopMovingOrSizing()
				      SaveFramePosition()
			      end)

	addon.Frame:Show()
	addon.Frame._Expanded = false

	-------------------------------------------------------------------------------
	-- Create and position the header.
	-------------------------------------------------------------------------------
	addon.Frame.HeadingText = addon.Frame:CreateFontString("Collectinator_Frame.HeadingText", "ARTWORK")
	addon.Frame.HeadingText:SetFontObject("GameFontHighlightSmall")
	addon.Frame.HeadingText:ClearAllPoints()
	addon.Frame.HeadingText:SetPoint("TOP", addon.Frame, "TOP", 20, -16)
	addon.Frame.HeadingText:SetJustifyH("CENTER")

	-------------------------------------------------------------------------------
	-- Create the mode button and assign its values.
	-------------------------------------------------------------------------------
	local mode_button = CreateFrame("Button", nil, addon.Frame, "UIPanelButtonTemplate")
	mode_button:SetWidth(64)
	mode_button:SetHeight(64)
	mode_button:SetPoint("TOPLEFT", addon.Frame, "TOPLEFT", 1, -2)
	mode_button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	addon.Frame.mode_button = mode_button

	-------------------------------------------------------------------------------
	-- Normal, Pushed, and Disabled textures for the mode button.
	-------------------------------------------------------------------------------
	mode_button._normal = mode_button:CreateTexture(nil, "BACKGROUND")
	mode_button._pushed = mode_button:CreateTexture(nil, "BACKGROUND")
	mode_button._disabled = mode_button:CreateTexture(nil, "BACKGROUND")

	-------------------------------------------------------------------------------
	-- Mode button scripts/functions.
	-------------------------------------------------------------------------------
	function mode_button:ChangeTexture(texture)
		local normal, pushed, disabled = self._normal, self._pushed, self._disabled

		normal:SetTexture([[Interface\Addons\Collectinator\img\]] .. texture .. [[_up]])
		normal:SetTexCoord(0, 1, 0, 1)
		normal:SetAllPoints(self)
		self:SetNormalTexture(normal)

		pushed:SetTexture([[Interface\Addons\Collectinator\img\]] .. texture .. [[_down]])
		pushed:SetTexCoord(0, 1, 0, 1)
		pushed:SetAllPoints(self)
		self:SetPushedTexture(pushed)

		disabled:SetTexture([[Interface\Addons\Collectinator\img\]] .. texture .. [[_up]])
		disabled:SetTexCoord(0, 1, 0, 1)
		disabled:SetAllPoints(self)
		self:SetDisabledTexture(disabled)
	end

	mode_button:SetScript("OnClick",
			      function(self, button, down)
				      -- We need to ensure that we cycle through all the collectible types, but also
				      -- that we do so in order. That means that if the currently displayed type is
				      -- the last one in the list, we're actually going to iterate completely once to
				      -- get to the currently displayed type and then iterate again to make sure we
				      -- display the next one in line.
				      local startLoop = 0
				      local endLoop = 0
				      local displayProf = 0

				      addon:ClosePopups()

				      -- ok, so first off, if we've never done this before, there is no "current"
				      -- and a single iteration will do nicely, thank you
				      if button == "LeftButton" then
					      -- normal profession switch
					      if current_tab == 0 then
						      startLoop = 1
						      endLoop = MaxCollections + 1
					      else
						      startLoop = current_tab + 1
						      endLoop = current_tab
					      end
					      local index = startLoop

					      while index ~= endLoop do
						      if index > MaxCollections then
							      index = 1
						      else
							      displayProf = index
							      current_tab = index
							      break
						      end
					      end
				      elseif button == "RightButton" then
					      -- reverse profession switch
					      if current_tab == 0 then
						      startLoop = MaxCollections + 1
						      endLoop = 0
					      else
						      startLoop = current_tab - 1
						      endLoop = current_tab
					      end
					      local index = startLoop

					      while index ~= endLoop do
						      if index < 1 then
							      index = MaxCollections
						      else
							      displayProf = index
							      current_tab = index
							      break
						      end
					      end
				      end
				      -- Redisplay the button with the new skill
				      self:ChangeTexture(SortedCollections[current_tab].texture)

				      ReDisplay(current_tab)
				      addon.resetTitle()
			      end)

	-------------------------------------------------------------------------------
	-- Stuff in the non-expanded frame (or both)
	-------------------------------------------------------------------------------
	local Collectinator_CloseXButton = CreateFrame("Button", "Collectinator_CloseXButton", addon.Frame, "UIPanelCloseButton")
	-- Close all possible pop-up windows
	Collectinator_CloseXButton:SetScript("OnClick", function(self) addon:CloseWindow() end)
	Collectinator_CloseXButton:SetPoint("TOPRIGHT", addon.Frame, "TOPRIGHT", 5, -6)

	-------------------------------------------------------------------------------
	-- Create the filter button, position it, and set its scripts.
	-------------------------------------------------------------------------------
	local filter_button = addon:GenericCreateButton(nil, addon.Frame,
							25, 90, "TOPRIGHT", addon.Frame, "TOPRIGHT", -8, -40, "GameFontNormalSmall",
							"GameFontHighlightSmall", L["Filter"] .. ">>>", "CENTER", L["FILTER_OPEN_DESC"], 1)
	filter_button:SetScript("OnClick",
				function(self, button, down)
					local xPos = addon.Frame:GetLeft()
					local yPos = addon.Frame:GetBottom()

					if addon.Frame._Expanded then
						-- Adjust the frame size and texture
						addon.Frame:ClearAllPoints()
						addon.Frame:SetWidth(293)
						addon.Frame:SetHeight(447)
						addon.bgTexture:SetTexture([[Interface\Addons\Collectinator\img\main]])
						addon.bgTexture:SetAllPoints(addon.Frame)
						addon.bgTexture:SetTexCoord(0, (293/512), 0, (447/512))
						addon.Frame._Expanded = false
						addon.Frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", xPos, yPos)
						addon.Frame.progress_bar:SetWidth(195)

						-- Change the text and tooltip for the filter button
						self:SetText(L["Filter"] .. ">>>")
						TooltipDisplay(self, L["FILTER_OPEN_DESC"])

						-- Hide my buttons
						Collectinator_ExpGeneralOptCB:Hide()
						Collectinator_ExpObtainOptCB:Hide()
						Collectinator_ExpBindingOptCB:Hide()
						Collectinator_ExpRarityOptCB:Hide()
						Collectinator_ExpRepOptCB:Hide()
						Collectinator_ExpMiscOptCB:Hide()

						-- Uncheck my buttons
						HideCollectinator_ExpOptCB()

						-- Hide the flyaway panel
						addon.Flyaway:Hide()

						Collectinator_ResetButton:Hide()
					else
						-- Adjust the frame size and texture
						addon.Frame:ClearAllPoints()
						addon.Frame:SetWidth(444)
						addon.Frame:SetHeight(447)
						addon.bgTexture:SetTexture([[Interface\Addons\Collectinator\img\expanded]])
						addon.bgTexture:SetAllPoints(addon.Frame)
						addon.bgTexture:SetTexCoord(0, (444/512), 0, (447/512))
						addon.Frame._Expanded = true
						addon.Frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", xPos, yPos)
						addon.Frame.progress_bar:SetWidth(345)

						-- Change the text and tooltip for the filter button
						self:SetText("<<< " .. L["Filter"])
						TooltipDisplay(self, L["FILTER_CLOSE_DESC"])

						-- Show my buttons
						Collectinator_ExpGeneralOptCB:Show()
						Collectinator_ExpObtainOptCB:Show()
						Collectinator_ExpBindingOptCB:Show()
						Collectinator_ExpRarityOptCB:Show()
						Collectinator_ExpRepOptCB:Show()
						Collectinator_ExpMiscOptCB:Show()

						Collectinator_ResetButton:Show()
					end
					addon.resetTitle()
				end)

	-------------------------------------------------------------------------------
	-- Create the sort frame
	-------------------------------------------------------------------------------
	local Collectinator_DD_Sort = CreateFrame("Frame", "Collectinator_DD_Sort", addon.Frame, "UIDropDownMenuTemplate")
	Collectinator_DD_Sort:SetPoint("TOPLEFT", addon.Frame, "TOPLEFT", 55, -39)
	Collectinator_DD_Sort:SetHitRectInsets(16, 16, 0, 0)
	SetSortName()
	UIDropDownMenu_SetWidth(Collectinator_DD_Sort, 105)

	local Collectinator_ExpandButton = addon:GenericCreateButton("Collectinator_ExpandButton", addon.Frame,
								     21, 40, "TOPRIGHT", Collectinator_DD_Sort, "BOTTOMLEFT", -2, 0, "GameFontNormalSmall",
								     "GameFontHighlightSmall", L["EXPANDALL"], "CENTER", L["EXPANDALL_DESC"], 1)
	Collectinator_ExpandButton:SetScript("OnClick", addon.ExpandAll_Clicked)

	local SearchCollectibles
	do
		local search_params = {
			["ItemID"]	= true,
			["Name"]	= true,
			["Locations"]	= true,
			["Rarity"]	= true,
			["Type"]	= true,
		}

		-- Scans through the item database and toggles the flag on if the item is in the search criteria
		function SearchCollectibles(pattern)
			if not pattern then
				return
			end
			pattern = pattern:lower()

			for index in pairs(collectibleDB) do
				local entry = collectibleDB[index]
				entry["Search"] = false

				for field in pairs(search_params) do
					local str = entry[field] and tostring(entry[field]):lower() or nil

					if str and str:find(pattern) then
						entry["Search"] = true
						break
					end
				end
			end
		end
	end	-- do

	local Collectinator_SearchButton = addon:GenericCreateButton("Collectinator_SearchButton", addon.Frame,
								     25, 74, "TOPLEFT", Collectinator_DD_Sort, "BOTTOMRIGHT", 1, 4, "GameFontDisableSmall",
								     "GameFontHighlightSmall", _G.SEARCH, "CENTER", L["SEARCH_DESC"], 1)
	Collectinator_SearchButton:Disable()
	Collectinator_SearchButton:SetScript("OnClick",
					     function(this)
						     local searchtext = Collectinator_SearchText:GetText()
						     searchtext = searchtext:trim()

						     if (searchtext ~= "") then
							     Collectinator_LastSearchedText = searchtext

							     SearchCollectibles(searchtext)
							     initDisplayStrings()
							     CollectibleList_Update()

							     Collectinator_ExpandButton:SetText(L["EXPANDALL"])
							     TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])

							     Collectinator_SearchButton:SetNormalFontObject("GameFontDisableSmall")
							     Collectinator_SearchButton:Disable()
						     end
					     end)

	local Collectinator_ClearButton = addon:GenericCreateButton("Collectinator_ClearButton", addon.Frame,
								    28, 28, "RIGHT", Collectinator_SearchButton, "LEFT", 4, -1, "GameFontNormalSmall",
								    "GameFontHighlightSmall", "", "CENTER", L["CLEAR_DESC"], 3)
	Collectinator_ClearButton:SetScript("OnClick",
					    function()
						    addon:ResetSearch(collectibleDB)
						    Collectinator_SearchText:SetText(L["SEARCH_BOX_DESC"])

						    -- Make sure our expand all button is set to expandall
						    Collectinator_ExpandButton:SetText(L["EXPANDALL"])
						    TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])

						    -- Make sure to clear the focus of the searchbox
						    Collectinator_SearchText:ClearFocus()

						    -- Disable the search button since we're not searching for anything now
						    Collectinator_SearchButton:SetNormalFontObject("GameFontDisableSmall")
						    Collectinator_SearchButton:Disable()

						    -- Make sure to clear text for last search
						    Collectinator_LastSearchedText = ""

						    initDisplayStrings()
						    CollectibleList_Update()
					    end)
	Collectinator_SearchText = CreateFrame("EditBox", "Collectinator_SearchText", addon.Frame, "InputBoxTemplate")
	Collectinator_SearchText:SetText(L["SEARCH_BOX_DESC"])
	Collectinator_SearchText:SetScript("OnEnterPressed",
					   function(this)
						   local searchtext = Collectinator_SearchText:GetText()
						   searchtext = searchtext:trim()

						   if (searchtext ~= "") and (searchtext ~= L["SEARCH_BOX_DESC"]) then
							   Collectinator_LastSearchedText = searchtext

							   SearchCollectibles(searchtext)
							   initDisplayStrings()
							   CollectibleList_Update()

							   Collectinator_ExpandButton:SetText(L["EXPANDALL"])
							   TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])

							   Collectinator_SearchButton:SetNormalFontObject("GameFontDisableSmall")
							   Collectinator_SearchButton:Disable()
						   end
					   end)
	Collectinator_SearchText:SetScript("OnEditFocusGained",
					   function(this)
						   if (this:GetText() == L["SEARCH_BOX_DESC"]) then
							   this:SetText("")
						   end
					   end)
	Collectinator_SearchText:SetScript("OnEditFocusLost",
					   function(this)
						   if (this:GetText() == "") then
							   this:SetText(L["SEARCH_BOX_DESC"])
						   end
					   end)
	Collectinator_SearchText:SetScript("OnTextChanged",
					   function(this)
						   if (this:GetText() ~= "" and this:GetText() ~= L["SEARCH_BOX_DESC"] and this:GetText() ~= Collectinator_LastSearchedText) then

							   Collectinator_SearchButton:SetNormalFontObject("GameFontNormalSmall")
							   Collectinator_SearchButton:Enable()
						   else
							   Collectinator_SearchButton:SetNormalFontObject("GameFontDisableSmall")
							   Collectinator_SearchButton:Disable()
						   end
					   end)
	Collectinator_SearchText:EnableMouse(true)
	Collectinator_SearchText:SetAutoFocus(false)
	Collectinator_SearchText:SetFontObject(ChatFontNormal)
	Collectinator_SearchText:SetWidth(130)
	Collectinator_SearchText:SetHeight(12)
	Collectinator_SearchText:SetPoint("RIGHT", Collectinator_ClearButton, "LEFT", 3, -1)
	Collectinator_SearchText:Show()

	local Collectinator_CloseButton = addon:GenericCreateButton("Collectinator_CloseButton", addon.Frame,
								    22, 69, "BOTTOMRIGHT", addon.Frame, "BOTTOMRIGHT", -4, 3, "GameFontNormalSmall",
								    "GameFontHighlightSmall", _G.CLOSE, "CENTER", L["CLOSE_DESC"], 1)
	-- Close all possible pop-up windows
	Collectinator_CloseButton:SetScript("OnClick", function(self) addon:CloseWindow() end)

	-------------------------------------------------------------------------------
	-- ProgressBar for our collection
	-------------------------------------------------------------------------------
	-- Values for the progressbar (defaults)
	local pbMin = 0
	local pbMax = 100
	local pbCur = 50

	local progress_bar = CreateFrame("StatusBar", nil, addon.Frame)
	progress_bar:SetWidth(195)
	progress_bar:SetHeight(14)
	progress_bar:ClearAllPoints()
	progress_bar:SetPoint("BOTTOMLEFT", addon.Frame, 17, 7)
	progress_bar:SetStatusBarTexture("Interface\\Addons\\Collectinator\\img\\progressbar")
	progress_bar:SetOrientation("HORIZONTAL")
	progress_bar:SetStatusBarColor(0.25, 0.25, 0.75)
	progress_bar:SetMinMaxValues(pbMin, pbMax)
	progress_bar:SetValue(pbCur)

	-------------------------------------------------------------------------------
	-- Updates the progress bar based on the number of known and total collectibles
	-------------------------------------------------------------------------------
	function progress_bar:Update()
		local pbCur, pbMax
		local tmp_type = SortedCollections[current_tab].name
		local lower_type = tmp_type:lower()
		local known_str = lower_type .. "_known"
		local total_str = lower_type .. "_total"
		local known_filtered_str = lower_type .. "_known_filtered"
		local total_filtered_str = lower_type .. "_total_filtered"

		-- Progress bar shows the actual values, not dependant on what is filtered
		if addon.db.profile.includefiltered then
			pbCur = playerData[known_str]
			pbMax = playerData[total_str]
		-- Progress bar removes all of the unknown filtered entries from the known/total counts
		elseif addon.db.profile.includeknownfiltered then
			local known_filtered = playerData[known_str] - playerData[known_filtered_str]
			pbCur = playerData[known_str]
			pbMax = playerData[total_filtered_str] + known_filtered
		-- Progress bar removes all of the filtered entries from the known/total counts
		else
			pbCur = playerData[known_filtered_str]
			pbMax = playerData[total_filtered_str]
		end

		if not addon.db.profile.includeexcluded and not addon.db.profile.ignoreexclusionlist then
			pbCur = pbCur - playerData["unknown_exclude_str"]
			pbMax = pbMax - playerData["known_exclude_str"]
		end
		self:SetMinMaxValues(0, pbMax)
		self:SetValue(pbCur)

		if (floor(pbCur / pbMax * 100) < 101) and (pbCur >= 0) and (pbMax >= 0) then
			self.text:SetFormattedText("%d / %d - %1.1f%%", pbCur, pbMax, pbCur / pbMax * 100)
		else
			self.text:SetFormattedText("0 / 0 - %s", L["NOT_YET_SCANNED"])
		end
	end
	addon.Frame.progress_bar = progress_bar

	local progress_bar_text = progress_bar:CreateFontString(nil, "ARTWORK")
	progress_bar_text:SetWidth(195)
	progress_bar_text:SetHeight(14)
	progress_bar_text:SetFontObject("GameFontHighlightSmall")
	progress_bar_text:ClearAllPoints()
	progress_bar_text:SetPoint("CENTER", progress_bar, "CENTER", 0, 0)
	progress_bar_text:SetJustifyH("CENTER")
	progress_bar_text:SetText(pbCur .. " / " .. pbMax .. " - " .. floor(pbCur / pbMax * 100) .. "%")
	addon.Frame.progress_bar.text = progress_bar_text

	-- I'm going to use my own tooltip for collectiblebuttons
	CollectinatorSpellTooltip = CreateFrame("GameTooltip", "CollectinatorSpellTooltip", addon.Frame, "GameTooltipTemplate")

	-- Add TipTac Support
	if TipTac and TipTac.AddModifiedTip then
		TipTac:AddModifiedTip(CollectinatorSpellTooltip)
	end

	-------------------------------------------------------------------------------
	-- The main collectible list buttons and scrollframe
	-------------------------------------------------------------------------------
	addon.PlusListButton = {}
	addon.CollectibleListButton = {}

	for i = 1, maxVisibleCollectibles do
		local Temp_Plus = addon:GenericCreateButton("Collectinator_PlusListButton" .. i, addon.Frame,
							    16, 16, "TOPLEFT", addon.Frame, "TOPLEFT", 20, -100, "GameFontNormalSmall",
							    "GameFontHighlightSmall", "", "LEFT", "", 2)

		local Temp_Collectible = addon:GenericCreateButton("Collectinator_CollectibleListButton" .. i, addon.Frame,
								   16, 224, "TOPLEFT", addon.Frame, "TOPLEFT", 37, -100, "GameFontNormalSmall",
								   "GameFontHighlightSmall", "Blort", "LEFT", "", 0)

		if not (i == 1) then
			Temp_Plus:SetPoint("TOPLEFT", addon.PlusListButton[i-1], "BOTTOMLEFT", 0, 3)
			Temp_Collectible:SetPoint("TOPLEFT", addon.CollectibleListButton[i-1], "BOTTOMLEFT", 0, 3)
		end

		Temp_Plus:SetScript("OnClick", function() addon.CollectibleItem_OnClick(i) end)

		Temp_Collectible:SetScript("OnClick", function() addon.CollectibleItem_OnClick(i) end)

		addon.PlusListButton[i] = Temp_Plus
		addon.CollectibleListButton[i] = Temp_Collectible
	end

	local Collectinator_CollectibleScrollFrame = CreateFrame("ScrollFrame", "Collectinator_CollectibleScrollFrame", addon.Frame, "FauxScrollFrameTemplate")
	Collectinator_CollectibleScrollFrame:SetHeight(322)
	Collectinator_CollectibleScrollFrame:SetWidth(243)
	Collectinator_CollectibleScrollFrame:SetPoint("TOPLEFT", addon.Frame, "TOPLEFT", 20, -97)
	Collectinator_CollectibleScrollFrame:SetScript("OnVerticalScroll",
						       function(self, arg1)
							       FauxScrollFrame_OnVerticalScroll(self, arg1, 16, CollectibleList_Update)
						       end)

	-------------------------------------------------------------------------------
	-- Stuff that appears on the main frame only when expanded
	-------------------------------------------------------------------------------
	local Collectinator_ResetButton = addon:GenericCreateButton("Collectinator_ResetButton", addon.Frame,
								    25, 90, "TOPRIGHT", filter_button, "BOTTOMRIGHT", 0, -2, "GameFontNormalSmall",
								    "GameFontHighlightSmall", _G.RESET, "CENTER", L["RESET_DESC"], 1)
	Collectinator_ResetButton:SetScript("OnClick", function(self, button, down)
							       local filterdb = addon.db.profile.filters

							       -- Reset all filters to true
							       recursiveReset(filterdb)

							       -- Reset specific filters to false
							       filterdb.general.known = false
							       filterdb.general.faction = false

							       if addon.Frame:IsVisible() then
								       addon.resetTitle()
								       HideCollectinator_ExpOptCB()
								       addon.Flyaway:Hide()
								       ReDisplay(current_tab)
							       end
						       end)
	Collectinator_ResetButton:Hide()

	-------------------------------------------------------------------------------
	-- EXPANDED : buttons for opening/closing the flyaway
	-------------------------------------------------------------------------------
	Collectinator_ExpGeneralOptCB = addon:CreateExpCB("Collectinator_ExpGeneralOptCB", "INV_Misc_Note_06", 1)
	Collectinator_ExpGeneralOptCB:SetPoint("TOPRIGHT", Collectinator_ResetButton, "BOTTOMLEFT", -7, -23)

	Collectinator_ExpObtainOptCB = addon:CreateExpCB("Collectinator_ExpObtainOptCB", "Spell_Shadow_MindRot", 2)
	Collectinator_ExpObtainOptCB:SetPoint("TOPLEFT", Collectinator_ExpGeneralOptCB, "BOTTOMLEFT", 0, -8)

	Collectinator_ExpBindingOptCB = addon:CreateExpCB("Collectinator_ExpBindingOptCB", "INV_Belt_20", 3)
	Collectinator_ExpBindingOptCB:SetPoint("TOPLEFT", Collectinator_ExpObtainOptCB, "BOTTOMLEFT", -0, -8)

	Collectinator_ExpRarityOptCB = addon:CreateExpCB("Collectinator_ExpRarityOptCB", "spell_nature_elementalabsorption", 4)
	Collectinator_ExpRarityOptCB:SetPoint("TOPLEFT", Collectinator_ExpBindingOptCB, "BOTTOMLEFT", -0, -8)

	Collectinator_ExpRepOptCB = addon:CreateExpCB("Collectinator_ExpRepOptCB", "INV_Scroll_05", 5)
	Collectinator_ExpRepOptCB:SetPoint("TOPLEFT", Collectinator_ExpRarityOptCB, "BOTTOMLEFT", -0, -8)

	Collectinator_ExpMiscOptCB = addon:CreateExpCB("Collectinator_ExpMiscOptCB", "Trade_Engineering", 6)
	Collectinator_ExpMiscOptCB:SetPoint("TOPLEFT", Collectinator_ExpRepOptCB, "BOTTOMLEFT", -0, -8)

	-------------------------------------------------------------------------------
	-- Frame for the flyaway pane
	-------------------------------------------------------------------------------
	addon.Flyaway = CreateFrame("Frame", "Collectinator_Flyaway", addon.Frame)
	addon.Flyaway:SetWidth(234)
	addon.Flyaway:SetHeight(312)

	addon.flyTexture = addon.Flyaway:CreateTexture("Collectinator.flyTexture", "ARTWORK")
	addon.flyTexture:SetTexture("Interface\\Addons\\Collectinator\\img\\fly_2col")
	addon.flyTexture:SetAllPoints(addon.Flyaway)
	addon.flyTexture:SetTexCoord(0, (234/256), 0, (312/512))
	addon.Flyaway:SetHitRectInsets(5, 5, 5, 5)

	addon.Flyaway:EnableMouse(true)
	addon.Flyaway:EnableKeyboard(true)
	addon.Flyaway:SetMovable(false)

	addon.Flyaway:ClearAllPoints()
	addon.Flyaway:SetPoint("TOPLEFT", addon.Frame, "TOPRIGHT", -6, -102)

	-------------------------------------------------------------------------------
	-- Set all the current options in the flyaway panel to make sure they are
	-- consistent with the SV options.
	-------------------------------------------------------------------------------
	addon.Flyaway:SetScript("OnShow", function()
						  for filter, info in pairs(FilterValueMap) do
							  if info.svroot then
								  info.cb:SetChecked(info.svroot[filter])
							  end
						  end
						  -- Miscellaneous Options
						  Collectinator_IgnoreCB:SetChecked(addon.db.profile.ignoreexclusionlist)
					  end)
	addon.Flyaway:Hide()

	-------------------------------------------------------------------------------
	-- Flyaway virtual frames to group, show, and hide buttons and text easily
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	--			() Cross-Faction
	--			() Known
	--			() Unknown
	-------------------------------------------------------------------------------
	addon.Fly_General = CreateFrame("Frame", "Collectinator_Fly_General", addon.Flyaway)
	addon.Fly_General:SetWidth(112)
	addon.Fly_General:SetHeight(280)
	addon.Fly_General:EnableMouse(true)
	addon.Fly_General:EnableKeyboard(true)
	addon.Fly_General:SetMovable(false)
	addon.Fly_General:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_General:Hide()

	local Collectinator_FactionCB = CreateFrame("CheckButton", "Collectinator_FactionCB", addon.Fly_General, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_FactionCB, addon.Fly_General, L["FACTION_DESC"], "faction", 1, 1, 0)
	Collectinator_FactionCBText:SetText(L["Faction"])

	local Collectinator_KnownCB = CreateFrame("CheckButton", "Collectinator_KnownCB", addon.Fly_General, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_KnownCB, addon.Fly_General, L["KNOWN_DESC"], "known", 2, 1, 0)
	Collectinator_KnownCBText:SetText(L["Known"])

	local Collectinator_UnknownCB = CreateFrame("CheckButton", "Collectinator_UnknownCB", addon.Fly_General, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_UnknownCB, addon.Fly_General, L["UNKNOWN_DESC"], "unknown", 3, 1, 0)
	Collectinator_UnknownCBText:SetText(L["Unknown"])

	local Collectinator_RemovedCB = CreateFrame("CheckButton", "Collectinator_RemovedCB", addon.Fly_General, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RemovedCB, addon.Fly_General, L["Removed from Game"], "removed", 4, 1, 0)
	Collectinator_RemovedCBText:SetText(L["Retired"])

	-------------------------------------------------------------------------------
	--			() Instance	() Raid
	--			() Quest	() Seasonal
	--			() Vendor
	--			() PVP
	--			() World Drop	() Mob Drop
	-------------------------------------------------------------------------------
	addon.Fly_Obtain = CreateFrame("Frame", "Collectinator_Fly_Obtain", addon.Flyaway)
	addon.Fly_Obtain:SetWidth(210)
	addon.Fly_Obtain:SetHeight(280)
	addon.Fly_Obtain:EnableMouse(true)
	addon.Fly_Obtain:EnableKeyboard(true)
	addon.Fly_Obtain:SetMovable(false)
	addon.Fly_Obtain:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_Obtain:Hide()

	-------------------------------------------------------------------------------
	-- Obtain flyaway - First column.
	-------------------------------------------------------------------------------
	local Collectinator_InstanceCB = CreateFrame("CheckButton", "Collectinator_InstanceCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_InstanceCB, addon.Fly_Obtain, L["INSTANCE_DESC"], "instance", 1, 1, 0)
	Collectinator_InstanceCBText:SetText(L["Instance"])

	local Collectinator_RaidCB = CreateFrame("CheckButton", "Collectinator_RaidCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RaidCB, addon.Fly_Obtain, L["RAID_DESC"], "raid", 2, 1, 0)
	Collectinator_RaidCBText:SetText(L["Raid"])

	local Collectinator_QuestCB = CreateFrame("CheckButton", "Collectinator_QuestCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_QuestCB, addon.Fly_Obtain, L["QUEST_DESC"], "quest", 3, 1, 0)
	Collectinator_QuestCBText:SetText(L["Quest"])

	local Collectinator_SeasonalCB = CreateFrame("CheckButton", "Collectinator_SeasonalCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_SeasonalCB, addon.Fly_Obtain, L["SEASONAL_DESC"], "seasonal", 4, 1, 0)
	Collectinator_SeasonalCBText:SetText(SEASONAL_CATEGORY)

	local Collectinator_EventCB = CreateFrame("CheckButton", "Collectinator_EventCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_EventCB, addon.Fly_Obtain, L["EVENT_DESC"], "event", 5, 1, 0)
	Collectinator_EventCBText:SetText(L["Special Event"])

	local Collectinator_VendorCB = CreateFrame("CheckButton", "Collectinator_VendorCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_VendorCB, addon.Fly_Obtain, L["VENDOR_DESC"], "vendor", 6, 1, 0)
	Collectinator_VendorCBText:SetText(L["Vendor"])

	local Collectinator_PVPCB = CreateFrame("CheckButton", "Collectinator_PVPCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_PVPCB, addon.Fly_Obtain, L["PVP_DESC"], "pvp", 7, 1, 0)
	Collectinator_PVPCBText:SetText(L["PVP"])

	local Collectinator_TCGCB = CreateFrame("CheckButton", "Collectinator_TCGCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_TCGCB, addon.Fly_Obtain, L["TCG_DESC"], "tcg", 8, 1, 0)
	Collectinator_TCGCBText:SetText(L["TCG"])

	local Collectinator_CECB = CreateFrame("CheckButton", "Collectinator_CECB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_CECB, addon.Fly_Obtain, L["COLLECTOR_ED_DESC"], "ce", 9, 1, 0)
	Collectinator_CECBText:SetText(L["Collectors' Edition"])

	local Collectinator_CraftCB = CreateFrame("CheckButton", "Collectinator_CraftCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_CraftCB, addon.Fly_Obtain, L["CRAFT_DESC"], "craft", 10, 1, 0)
	Collectinator_CraftCBText:SetText(L["Crafted"])

	local Collectinator_WorldDropCB = CreateFrame("CheckButton", "Collectinator_WorldDropCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WorldDropCB, addon.Fly_Obtain, L["WORLD_DROP_DESC"], "worlddrop", 11, 1, 0)
	Collectinator_WorldDropCBText:SetText(L["World Drop"])

	local Collectinator_MobDropCB = CreateFrame("CheckButton", "Collectinator_MobDropCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_MobDropCB, addon.Fly_Obtain, L["MOB_DROP_DESC"], "mobdrop", 12, 1, 0)
	Collectinator_MobDropCBText:SetText(L["Mob Drop"])

	local Collectinator_AchievementCB = CreateFrame("CheckButton", "Collectinator_AchievementCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_AchievementCB, addon.Fly_Obtain, L["ACHIEVEMENT_DESC"], "achievement", 13, 1, 0)
	Collectinator_AchievementCBText:SetText(L["Achievement"])

	local Collectinator_StoreCB = CreateFrame("CheckButton", "Collectinator_StoreCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_StoreCB, addon.Fly_Obtain, L["STORE_DESC"], "store", 14, 1, 0)
	Collectinator_StoreCBText:SetText(L["Store"])

	local Collectinator_OriginalWoWCB = CreateFrame("CheckButton", "Collectinator_OriginalWoWCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_OriginalWoWCB, addon.Fly_Obtain, L["ORIGINAL_WOW_DESC"], "originalwow", 15, 1, 0)
	Collectinator_OriginalWoWCBText:SetText(L["Old World"])

	local Collectinator_BCCB = CreateFrame("CheckButton", "Collectinator_BCCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_BCCB, addon.Fly_Obtain, L["BC_WOW_DESC"], "bc", 16, 1, 0)
	Collectinator_BCCBText:SetText(L["Burning Crusade"])

	-------------------------------------------------------------------------------
	-- Obtain flyaway - Second column.
	-------------------------------------------------------------------------------
	local Collectinator_WrathCB = CreateFrame("CheckButton", "Collectinator_WrathCB", addon.Fly_Obtain, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCB, addon.Fly_Obtain, L["LK_WOW_DESC"], "wrath", 1, 2, 0)
	Collectinator_WrathCBText:SetText(L["Lich King"])

	-------------------------------------------------------------------------------
	--			() Collectible is Bind on Account
	--			() Collectible is Bind on Equip
	--			() Collectible is Bind on Pickup
	-------------------------------------------------------------------------------
	addon.Fly_Binding = CreateFrame("Frame", "Collectinator_Fly_Binding", addon.Flyaway)
	addon.Fly_Binding:SetWidth(210)
	addon.Fly_Binding:SetHeight(280)
	addon.Fly_Binding:EnableMouse(true)
	addon.Fly_Binding:EnableKeyboard(true)
	addon.Fly_Binding:SetMovable(false)
	addon.Fly_Binding:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_Binding:Hide()

	local Collectinator_iBoACB = CreateFrame("CheckButton", "Collectinator_iBoACB", addon.Fly_Binding, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_iBoACB, addon.Fly_Binding, L["BOA_DESC"], "itemboa", 1, 1, 0)
	Collectinator_iBoACBText:SetText(L["BOAFilter"])

	local Collectinator_iBoECB = CreateFrame("CheckButton", "Collectinator_iBoECB", addon.Fly_Binding, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_iBoECB, addon.Fly_Binding, L["BOE_DESC"], "itemboe", 2, 1, 0)
	Collectinator_iBoECBText:SetText(L["BOEFilter"])

	local Collectinator_iBoPCB = CreateFrame("CheckButton", "Collectinator_iBoPCB", addon.Fly_Binding, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_iBoPCB, addon.Fly_Binding, L["BOP_DESC"], "itembop", 3, 1, 0)
	Collectinator_iBoPCBText:SetText(L["BOPFilter"])

	-------------------------------------------------------------------------------
	-- Rarity flyaway
	-------------------------------------------------------------------------------
	addon.Fly_Rarity = CreateFrame("Frame", "Collectinator_Fly_Rarity", addon.Flyaway)
	addon.Fly_Rarity:SetWidth(112)
	addon.Fly_Rarity:SetHeight(280)
	addon.Fly_Rarity:EnableMouse(true)
	addon.Fly_Rarity:EnableKeyboard(true)
	addon.Fly_Rarity:SetMovable(false)
	addon.Fly_Rarity:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_Rarity:Hide()

	local Collectinator_PoorCB = CreateFrame("CheckButton", "Collectinator_PoorCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_PoorCB, addon.Fly_Rarity, L["Poor_DESC"], "poor", 1, 1, 0)
	Collectinator_PoorCBText:SetText(L["Poor"])
	Collectinator_PoorCBText:SetText(addon:Grey(L["Poor"]))
	Collectinator_PoorCB:Disable()

	local Collectinator_CommonCB = CreateFrame("CheckButton", "Collectinator_CommonCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_CommonCB, addon.Fly_Rarity, L["Common_DESC"], "common", 2, 1, 0)
	Collectinator_CommonCBText:SetText(L["Common"])

	local Collectinator_UncommonCB = CreateFrame("CheckButton", "Collectinator_UncommonCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_UncommonCB, addon.Fly_Rarity, L["Uncommon_DESC"], "uncommon", 3, 1, 0)
	Collectinator_UncommonCBText:SetText(L["Uncommon"])

	local Collectinator_RareCB = CreateFrame("CheckButton", "Collectinator_RareCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RareCB, addon.Fly_Rarity, L["Rare_DESC"], "rare", 4, 1, 0)
	Collectinator_RareCBText:SetText(L["Rare"])

	local Collectinator_EpicCB = CreateFrame("CheckButton", "Collectinator_EpicCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_EpicCB, addon.Fly_Rarity, L["Epic_DESC"], "epic", 5, 1, 0)
	Collectinator_EpicCBText:SetText(L["Epic"])

	local Collectinator_LegendaryCB = CreateFrame("CheckButton", "Collectinator_LegendaryCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_LegendaryCB, addon.Fly_Rarity, L["Legendary_DESC"], "legendary", 6, 1, 0)
	Collectinator_LegendaryCBText:SetText(L["Legendary"])

	local Collectinator_ArtifactCB = CreateFrame("CheckButton", "Collectinator_ArtifactCB", addon.Fly_Rarity, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_ArtifactCB, addon.Fly_Rarity, L["Artifact_DESC"], "artifact", 7, 1, 0)
	Collectinator_ArtifactCBText:SetText(L["Artifact"])
	Collectinator_ArtifactCBText:SetText(addon:Grey(L["Artifact"]))
	Collectinator_ArtifactCB:Disable()

	-------------------------------------------------------------------------------
	-- Reputation flyout
	-------------------------------------------------------------------------------
	addon.Fly_Rep = CreateFrame("Frame", "Collectinator_Fly_Rep", addon.Flyaway)
	addon.Fly_Rep:SetWidth(112)
	addon.Fly_Rep:SetHeight(280)
	addon.Fly_Rep:EnableMouse(true)
	addon.Fly_Rep:EnableKeyboard(true)
	addon.Fly_Rep:SetMovable(false)
	addon.Fly_Rep:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_Rep:Hide()

	Collectinator_RepOldWorldCB = addon:CreateExpCB("Collectinator_RepOldWorldCB", "Glues-WoW-Logo", 1)
	Collectinator_RepOldWorldCB:SetPoint("TOPLEFT", addon.Fly_Rep, "TOPLEFT", 0, -10)
	Collectinator_RepOldWorldCB:SetScript("OnClick", function() addon.RepFilterSwitch(1) end)

	Collectinator_RepBCCB = addon:CreateExpCB("Collectinator_RepBCCB", "GLUES-WOW-BCLOGO", 1)
	Collectinator_RepBCCB:SetPoint("TOPLEFT", addon.Fly_Rep, "TOPLEFT", 0, -60)
	Collectinator_RepBCCB:SetScript("OnClick", function() addon.RepFilterSwitch(2) end)

	Collectinator_RepLKCB = addon:CreateExpCB("Collectinator_RepLKCB", "wotlk_logo", 1)
	Collectinator_RepLKCB:SetPoint("TOPLEFT", addon.Fly_Rep, "TOPLEFT", 0, -110)
	Collectinator_RepLKCB:SetScript("OnClick", function() addon.RepFilterSwitch(3) end)

	-------------------------------------------------------------------------------
	-- Original Reputations
	-------------------------------------------------------------------------------
	addon.Fly_Rep_OW = CreateFrame("Frame", "Collectinator_Fly_Rep_OW", addon.Fly_Rep)
	addon.Fly_Rep_OW:SetWidth(150)
	addon.Fly_Rep_OW:SetHeight(280)
	addon.Fly_Rep_OW:EnableMouse(true)
	addon.Fly_Rep_OW:EnableKeyboard(true)
	addon.Fly_Rep_OW:SetMovable(false)
	addon.Fly_Rep_OW:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -16)
	addon.Fly_Rep_OW:Hide()

	local Collectinator_Rep_OWButton = addon:GenericCreateButton("Collectinator_Rep_OWButton", addon.Fly_Rep_OW,
								     20, 85, "TOPLEFT", addon.Fly_Rep_OW, "TOPLEFT", -2, -4, "GameFontHighlight",
								     "GameFontHighlightSmall", L["Reputation"], "LEFT", L["REP_TEXT_DESC"], 0)
	Collectinator_Rep_OWButton:SetText(L["Reputation"] .. ":")
	Collectinator_Rep_OWButton:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
	Collectinator_Rep_OWButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	Collectinator_Rep_OWButton:SetScript("OnClick",
					     function(self, button)
						     local filterdb = addon.db.profile.filters.rep
						     if button == "LeftButton" then
							     -- Reset all armor to true
							     filterdb.argentdawn = true
							     filterdb.cenarioncircle = true
							     filterdb.thoriumbrotherhood = true
							     filterdb.timbermaw = true
							     filterdb.zandalar = true
							     filterdb.bloodsail = true
							     filterdb.winterspring = true
							     filterdb.city1 = true
							     filterdb.city2 = true
							     filterdb.city3 = true
							     filterdb.city4 = true
							     filterdb.city5 = true
							     filterdb.pvp1 = true
							     filterdb.pvp2 = true
							     filterdb.pvp3 = true
						     elseif button == "RightButton" then
							     -- Reset all armor to false
							     filterdb.argentdawn = false
							     filterdb.cenarioncircle = false
							     filterdb.thoriumbrotherhood = false
							     filterdb.timbermaw = false
							     filterdb.zandalar = false
							     filterdb.bloodsail = false
							     filterdb.winterspring = false
							     filterdb.city1 = false
							     filterdb.city2 = false
							     filterdb.city3 = false
							     filterdb.city4 = false
							     filterdb.city5 = false
							     filterdb.pvp1 = false
							     filterdb.pvp2 = false
							     filterdb.pvp3 = false
						     end
						     -- Update the checkboxes with the new value
						     Collectinator_RepArgentDawnCB:SetChecked(filterdb.argentdawn)
						     Collectinator_RepCenarionCircleCB:SetChecked(filterdb.cenarioncircle)
						     Collectinator_RepThoriumCB:SetChecked(filterdb.thoriumbrotherhood)
						     Collectinator_RepTimbermawCB:SetChecked(filterdb.timbermaw)
						     Collectinator_RepZandalarCB:SetChecked(filterdb.zandalar)
						     Collectinator_RepBloodSailCB:SetChecked(filterdb.bloodsail)
						     Collectinator_RepWinterspringCB:SetChecked(filterdb.winterspring)
						     Collectinator_RepCity1CB:SetChecked(filterdb.city1)
						     Collectinator_RepCity2CB:SetChecked(filterdb.city2)
						     Collectinator_RepCity3CB:SetChecked(filterdb.city3)
						     Collectinator_RepCity4CB:SetChecked(filterdb.city4)
						     Collectinator_RepCity5CB:SetChecked(filterdb.city5)
						     Collectinator_RepPVP1CB:SetChecked(filterdb.pvp1)
						     Collectinator_RepPVP2CB:SetChecked(filterdb.pvp2)
						     Collectinator_RepPVP3CB:SetChecked(filterdb.pvp3)
						     -- Reset our title
						     addon.resetTitle()
						     -- Use new filters
						     ReDisplay(current_tab)
					     end)

	local Collectinator_RepCity1CB = CreateFrame("CheckButton", "Collectinator_RepCity1CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCity1CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], City1_FactionText), "city1", 2, 1, 0)
	Collectinator_RepCity1CBText:SetText(City1_FactionText)
	Collectinator_RepCity1CBText:SetFont(narrowFont, 11)
	Collectinator_RepCity1CB:Disable()

	local Collectinator_RepCity2CB = CreateFrame("CheckButton", "Collectinator_RepCity2CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCity2CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], City2_FactionText), "city2", 3, 1, 0)
	Collectinator_RepCity2CBText:SetText(City2_FactionText)
	Collectinator_RepCity2CBText:SetFont(narrowFont, 11)
	Collectinator_RepCity2CB:Disable()

	local Collectinator_RepCity3CB = CreateFrame("CheckButton", "Collectinator_RepCity3CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCity3CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], City3_FactionText), "city3", 4, 1, 0)
	Collectinator_RepCity3CBText:SetText(City3_FactionText)
	Collectinator_RepCity3CBText:SetFont(narrowFont, 11)
	Collectinator_RepCity3CB:Disable()

	local Collectinator_RepCity4CB = CreateFrame("CheckButton", "Collectinator_RepCity4CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCity4CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], City4_FactionText), "city4", 5, 1, 0)
	Collectinator_RepCity4CBText:SetText(City4_FactionText)
	Collectinator_RepCity4CBText:SetFont(narrowFont, 11)
	Collectinator_RepCity4CB:Disable()

	local Collectinator_RepCity5CB = CreateFrame("CheckButton", "Collectinator_RepCity5CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCity5CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], City5_FactionText), "city5", 6, 1, 0)
	Collectinator_RepCity5CBText:SetText(City5_FactionText)
	Collectinator_RepCity5CBText:SetFont(narrowFont, 11)
	Collectinator_RepCity5CB:Disable()

	local Collectinator_RepPVP1CB = CreateFrame("CheckButton", "Collectinator_RepPVP1CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepPVP1CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], PVP1_FactionText), "pvp1", 7, 1, 0)
	Collectinator_RepPVP1CBText:SetText(PVP1_FactionText)
	Collectinator_RepPVP1CBText:SetFont(narrowFont, 11)
	Collectinator_RepPVP1CB:Disable()

	local Collectinator_RepPVP2CB = CreateFrame("CheckButton", "Collectinator_RepPVP2CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepPVP2CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], PVP2_FactionText), "pvp2", 8, 1, 0)
	Collectinator_RepPVP2CBText:SetText(PVP2_FactionText)
	Collectinator_RepPVP2CBText:SetFont(narrowFont, 11)
	Collectinator_RepPVP2CB:Disable()

	local Collectinator_RepPVP3CB = CreateFrame("CheckButton", "Collectinator_RepPVP3CB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepPVP3CB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], PVP3_FactionText), "pvp3", 9, 1, 0)
	Collectinator_RepPVP3CBText:SetText(PVP3_FactionText)
	Collectinator_RepPVP3CBText:SetFont(narrowFont, 11)
	Collectinator_RepPVP3CB:Disable()

	local Collectinator_RepArgentDawnCB = CreateFrame("CheckButton", "Collectinator_RepArgentDawnCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepArgentDawnCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Argent Dawn"]), "argentdawn", 10, 1, 0)
	Collectinator_RepArgentDawnCBText:SetText(BFAC["Argent Dawn"])
	Collectinator_RepArgentDawnCBText:SetFont(narrowFont, 11)
	Collectinator_RepArgentDawnCB:Disable()

	local Collectinator_RepBloodSailCB = CreateFrame("CheckButton", "Collectinator_RepBloodSailCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepBloodSailCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Bloodsail Buccaneers"]), "bloodsail", 11, 1, 0)
	Collectinator_RepBloodSailCBText:SetText(BFAC["Bloodsail Buccaneers"])
	Collectinator_RepBloodSailCBText:SetFont(narrowFont, 11)
	Collectinator_RepBloodSailCB:Disable()

	local Collectinator_RepCenarionCircleCB = CreateFrame("CheckButton", "Collectinator_RepCenarionCircleCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCenarionCircleCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Cenarion Circle"]), "cenarioncircle", 12, 1, 0)
	Collectinator_RepCenarionCircleCBText:SetText(BFAC["Cenarion Circle"])
	Collectinator_RepCenarionCircleCBText:SetFont(narrowFont, 11)
	Collectinator_RepCenarionCircleCB:Disable()

	local Collectinator_RepThoriumCB = CreateFrame("CheckButton", "Collectinator_RepThoriumCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepThoriumCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Thorium Brotherhood"]), "thoriumbrotherhood", 13, 1, 0)
	Collectinator_RepThoriumCBText:SetText(BFAC["Thorium Brotherhood"])
	Collectinator_RepThoriumCBText:SetFont(narrowFont, 11)
	Collectinator_RepThoriumCB:Disable()

	local Collectinator_RepTimbermawCB = CreateFrame("CheckButton", "Collectinator_RepTimbermawCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepTimbermawCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Timbermaw Hold"]), "timbermaw", 14, 1, 0)
	Collectinator_RepTimbermawCBText:SetText(BFAC["Timbermaw Hold"])
	Collectinator_RepTimbermawCBText:SetFont(narrowFont, 11)
	Collectinator_RepTimbermawCB:Disable()

	local Collectinator_RepWinterspringCB = CreateFrame("CheckButton", "Collectinator_RepWinterspringCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepWinterspringCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Wintersaber Trainers"]), "winterspring", 15, 1, 0)
	Collectinator_RepWinterspringCBText:SetText(BFAC["Wintersaber Trainers"])
	Collectinator_RepWinterspringCBText:SetFont(narrowFont, 11)

	local Collectinator_RepZandalarCB = CreateFrame("CheckButton", "Collectinator_RepZandalarCB", addon.Fly_Rep_OW, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepZandalarCB, addon.Fly_Rep_OW, strformat(L["SPECIFIC_REP_DESC"], BFAC["Zandalar Tribe"]), "zandalar", 16, 1, 0)
	Collectinator_RepZandalarCBText:SetText(BFAC["Zandalar Tribe"])
	Collectinator_RepZandalarCBText:SetFont(narrowFont, 11)
	Collectinator_RepZandalarCB:Disable()

	-------------------------------------------------------------------------------
	-- The Burning Crusade Reputations
	-------------------------------------------------------------------------------
	addon.Fly_Rep_BC = CreateFrame("Frame", "Collectinator_Fly_Rep_BC", addon.Fly_Rep)
	addon.Fly_Rep_BC:SetWidth(150)
	addon.Fly_Rep_BC:SetHeight(280)
	addon.Fly_Rep_BC:EnableMouse(true)
	addon.Fly_Rep_BC:EnableKeyboard(true)
	addon.Fly_Rep_BC:SetMovable(false)
	addon.Fly_Rep_BC:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -16)
	addon.Fly_Rep_BC:Hide()

	local Collectinator_Rep_BCButton = addon:GenericCreateButton("Collectinator_Rep_OWButton", addon.Fly_Rep_BC,
								     20, 85, "TOPLEFT", addon.Fly_Rep_BC, "TOPLEFT", -2, -4, "GameFontHighlight",
								     "GameFontHighlightSmall", L["Reputation"], "LEFT", L["REP_TEXT_DESC"], 0)
	Collectinator_Rep_BCButton:SetText(L["Reputation"] .. ":")
	Collectinator_Rep_BCButton:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
	Collectinator_Rep_BCButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	Collectinator_Rep_BCButton:SetScript("OnClick",
					     function(self, button)
						     local filterdb = addon.db.profile.filters.rep

						     if button == "LeftButton" then
							     -- Reset all armor to true
							     filterdb.aldor = true
							     filterdb.ashtonguedeathsworn = true
							     filterdb.cenarionexpedition = true
							     filterdb.consortium = true
							     filterdb.hellfire = true
							     filterdb.keepersoftime = true
							     filterdb.nagrand = true
							     filterdb.lowercity = true
							     filterdb.scaleofthesands = true
							     filterdb.scryer = true
							     filterdb.shatar = true
							     filterdb.shatteredsun = true
							     filterdb.sporeggar = true
							     filterdb.violeteye = true
						     elseif button == "RightButton" then
							     -- Reset all armor to false
							     filterdb.aldor = false
							     filterdb.ashtonguedeathsworn = false
							     filterdb.cenarionexpedition = false
							     filterdb.consortium = false
							     filterdb.hellfire = false
							     filterdb.keepersoftime = false
							     filterdb.nagrand = false
							     filterdb.lowercity = false
							     filterdb.scaleofthesands = false
							     filterdb.scryer = false
							     filterdb.shatar = false
							     filterdb.shatteredsun = false
							     filterdb.sporeggar = false
							     filterdb.violeteye = false
						     end
						     -- Update the checkboxes with the new value
						     Collectinator_RepAldorCB:SetChecked(filterdb.aldor)
						     Collectinator_RepAshtongueCB:SetChecked(filterdb.ashtonguedeathsworn)
						     Collectinator_RepCenarionExpeditionCB:SetChecked(filterdb.cenarionexpedition)
						     Collectinator_RepConsortiumCB:SetChecked(filterdb.consortium)
						     Collectinator_RepHonorHoldCB:SetChecked(filterdb.hellfire)
						     Collectinator_RepKeepersOfTimeCB:SetChecked(filterdb.keepersoftime)
						     Collectinator_RepKurenaiCB:SetChecked(filterdb.nagrand)
						     Collectinator_RepLowerCityCB:SetChecked(filterdb.lowercity)
						     Collectinator_RepScaleSandsCB:SetChecked(filterdb.scaleofthesands)
						     Collectinator_RepScryersCB:SetChecked(filterdb.scryer)
						     Collectinator_RepShatarCB:SetChecked(filterdb.shatar)
						     Collectinator_RepShatteredSunCB:SetChecked(filterdb.shatteredsun)
						     Collectinator_RepSporeggarCB:SetChecked(filterdb.sporeggar)
						     Collectinator_RepVioletEyeCB:SetChecked(filterdb.violeteye)
						     -- Reset our title
						     addon.resetTitle()
						     -- Use new filters
						     ReDisplay(current_tab)
					     end)

	local Collectinator_RepAldorCB = CreateFrame("CheckButton", "Collectinator_RepAldorCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepAldorCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Aldor"]), "aldor", 2, 1, 0)
	Collectinator_RepAldorCBText:SetText(BFAC["The Aldor"])
	Collectinator_RepAldorCBText:SetFont(narrowFont, 11)
	Collectinator_RepAldorCB:Disable()

	local Collectinator_RepAshtongueCB = CreateFrame("CheckButton", "Collectinator_RepAshtongueCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepAshtongueCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Ashtongue Deathsworn"]), "ashtonguedeathsworn", 3, 1, 0)
	Collectinator_RepAshtongueCBText:SetText(BFAC["Ashtongue Deathsworn"])
	Collectinator_RepAshtongueCBText:SetFont(narrowFont, 11)
	Collectinator_RepAshtongueCB:Disable()

	local Collectinator_RepCenarionExpeditionCB = CreateFrame("CheckButton", "Collectinator_RepCenarionExpeditionCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepCenarionExpeditionCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Cenarion Expedition"]), "cenarionexpedition", 4, 1, 0)
	Collectinator_RepCenarionExpeditionCBText:SetText(BFAC["Cenarion Expedition"])
	Collectinator_RepCenarionExpeditionCBText:SetFont(narrowFont, 11)

	local Collectinator_RepConsortiumCB = CreateFrame("CheckButton", "Collectinator_RepConsortiumCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepConsortiumCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Consortium"]), "consortium", 5, 1, 0)
	Collectinator_RepConsortiumCBText:SetText(BFAC["The Consortium"])
	Collectinator_RepConsortiumCBText:SetFont(narrowFont, 11)

	local Collectinator_RepHonorHoldCB = CreateFrame("CheckButton", "Collectinator_RepHonorHoldCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepHonorHoldCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], HonorHold_Thrallmar_FactionText), "hellfire", 6, 1, 0)
	Collectinator_RepHonorHoldCBText:SetText(HonorHold_Thrallmar_FactionText)
	Collectinator_RepHonorHoldCBText:SetFont(narrowFont, 11)

	local Collectinator_RepKeepersOfTimeCB = CreateFrame("CheckButton", "Collectinator_RepKeepersOfTimeCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepKeepersOfTimeCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Keepers of Time"]), "keepersoftime", 7, 1, 0)
	Collectinator_RepKeepersOfTimeCBText:SetText(BFAC["Keepers of Time"])
	Collectinator_RepKeepersOfTimeCBText:SetFont(narrowFont, 11)

	local Collectinator_RepKurenaiCB = CreateFrame("CheckButton", "Collectinator_RepKurenaiCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepKurenaiCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], Kurenai_Maghar_FactionText), "nagrand", 8, 1, 0)
	Collectinator_RepKurenaiCBText:SetText(Kurenai_Maghar_FactionText)
	Collectinator_RepKurenaiCBText:SetFont(narrowFont, 11)

	local Collectinator_RepLowerCityCB = CreateFrame("CheckButton", "Collectinator_RepLowerCityCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepLowerCityCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Lower City"]), "lowercity", 9, 1, 0)
	Collectinator_RepLowerCityCBText:SetText(BFAC["Lower City"])
	Collectinator_RepLowerCityCBText:SetFont(narrowFont, 11)
	Collectinator_RepLowerCityCB:Disable()

	local Collectinator_RepScaleSandsCB = CreateFrame("CheckButton", "Collectinator_RepScaleSandsCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepScaleSandsCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Scale of the Sands"]), "scaleofthesands", 10, 1, 0)
	Collectinator_RepScaleSandsCBText:SetText(BFAC["The Scale of the Sands"])
	Collectinator_RepScaleSandsCBText:SetFont(narrowFont, 11)
	Collectinator_RepScaleSandsCB:Disable()

	local Collectinator_RepScryersCB = CreateFrame("CheckButton", "Collectinator_RepScryersCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepScryersCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Scryers"]), "scryer", 11, 1, 0)
	Collectinator_RepScryersCBText:SetText(BFAC["The Scryers"])
	Collectinator_RepScryersCBText:SetFont(narrowFont, 11)
	Collectinator_RepScryersCB:Disable()

	local Collectinator_RepShatarCB = CreateFrame("CheckButton", "Collectinator_RepShatarCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepShatarCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Sha'tar"]), "shatar", 12, 1, 0)
	Collectinator_RepShatarCBText:SetText(BFAC["The Sha'tar"])
	Collectinator_RepShatarCBText:SetFont(narrowFont, 11)

	local Collectinator_RepShatteredSunCB = CreateFrame("CheckButton", "Collectinator_RepShatteredSunCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepShatteredSunCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Shattered Sun Offensive"]), "shatteredsun", 13, 1, 0)
	Collectinator_RepShatteredSunCBText:SetText(BFAC["Shattered Sun Offensive"])
	Collectinator_RepShatteredSunCBText:SetFont(narrowFont, 11)

	local Collectinator_RepSporeggarCB = CreateFrame("CheckButton", "Collectinator_RepSporeggarCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepSporeggarCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["Sporeggar"]), "sporeggar", 14, 1, 0)
	Collectinator_RepSporeggarCBText:SetText(BFAC["Sporeggar"])
	Collectinator_RepSporeggarCBText:SetFont(narrowFont, 11)

	local Collectinator_RepVioletEyeCB = CreateFrame("CheckButton", "Collectinator_RepVioletEyeCB", addon.Fly_Rep_BC, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepVioletEyeCB, addon.Fly_Rep_BC, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Violet Eye"]), "violeteye", 15, 1, 0)
	Collectinator_RepVioletEyeCBText:SetText(BFAC["The Violet Eye"])
	Collectinator_RepVioletEyeCBText:SetFont(narrowFont, 11)

	-------------------------------------------------------------------------------
	-- Wrath of the Lich King Reputations
	-------------------------------------------------------------------------------
	addon.Fly_Rep_LK= CreateFrame("Frame", "Collectinator_Fly_Rep_LK", addon.Fly_Rep)
	addon.Fly_Rep_LK:SetWidth(150)
	addon.Fly_Rep_LK:SetHeight(280)
	addon.Fly_Rep_LK:EnableMouse(true)
	addon.Fly_Rep_LK:EnableKeyboard(true)
	addon.Fly_Rep_LK:SetMovable(false)
	addon.Fly_Rep_LK:SetPoint("TOPRIGHT", addon.Flyaway, "TOPRIGHT", -7, -16)
	addon.Fly_Rep_LK:Hide()

	local Collectinator_Rep_LKButton = addon:GenericCreateButton("Collectinator_Rep_OWButton", addon.Fly_Rep_LK,
								     20, 85, "TOPLEFT", addon.Fly_Rep_LK, "TOPLEFT", -2, -4, "GameFontHighlight",
								     "GameFontHighlightSmall", L["Reputation"], "LEFT", L["REP_TEXT_DESC"], 0)
	Collectinator_Rep_LKButton:SetText(L["Reputation"] .. ":")
	Collectinator_Rep_LKButton:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
	Collectinator_Rep_LKButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	Collectinator_Rep_LKButton:SetScript("OnClick",
					     function(self, button)
						     local filterdb = addon.db.profile.filters.rep
						     if button == "LeftButton" then
							     -- Reset all armor to true
							     filterdb.argentcrusade = true
							     filterdb.frenzyheart = true
							     filterdb.ebonblade = true
							     filterdb.kirintor = true
							     filterdb.sonsofhodir = true
							     filterdb.kaluak = true
							     filterdb.oracles = true
							     filterdb.wyrmrest = true
							     filterdb.ashenverdict = true
							     filterdb.wrathcommon1 = true
							     filterdb.wrathcommon2 = true
							     filterdb.wrathcommon3 = true
							     filterdb.wrathcommon4 = true
							     filterdb.wrathcommon5 = true
						     elseif button == "RightButton" then
							     -- Reset all armor to false
							     filterdb.argentcrusade = false
							     filterdb.frenzyheart = false
							     filterdb.ebonblade = false
							     filterdb.kirintor = false
							     filterdb.sonsofhodir = false
							     filterdb.kaluak = false
							     filterdb.oracles = false
							     filterdb.wyrmrest = false
							     filterdb.ashenverdict = false
							     filterdb.wrathcommon1 = false
							     filterdb.wrathcommon2 = false
							     filterdb.wrathcommon3 = false
							     filterdb.wrathcommon4 = false
							     filterdb.wrathcommon5 = false
						     end
						     -- Update the checkboxes with the new value
						     Collectinator_RepArgentCrusadeCB:SetChecked(filterdb.argentcrusade)
						     Collectinator_RepFrenzyheartCB:SetChecked(filterdb.frenzyheart)
						     Collectinator_RepEbonBladeCB:SetChecked(filterdb.ebonblade)
						     Collectinator_RepKirinTorCB:SetChecked(filterdb.kirintor)
						     Collectinator_RepSonsOfHodirCB:SetChecked(filterdb.sonsofhodir)
						     Collectinator_RepKaluakCB:SetChecked(filterdb.kaluak)
						     Collectinator_RepOraclesCB:SetChecked(filterdb.oracles)
						     Collectinator_RepWyrmrestCB:SetChecked(filterdb.wyrmrest)
						     Collectinator_RepAshenVerdictCB:SetChecked(filterdb.ashenverdict)
						     Collectinator_WrathCommon1CB:SetChecked(filterdb.wrathcommon1)
						     Collectinator_WrathCommon2CB:SetChecked(filterdb.wrathcommon2)
						     Collectinator_WrathCommon3CB:SetChecked(filterdb.wrathcommon3)
						     Collectinator_WrathCommon4CB:SetChecked(filterdb.wrathcommon4)
						     Collectinator_WrathCommon5CB:SetChecked(filterdb.wrathcommon5)
						     -- Reset our title
						     addon.resetTitle()
						     -- Use new filters
						     ReDisplay(current_tab)
					     end)

	local Collectinator_WrathCommon1CB = CreateFrame("CheckButton", "Collectinator_WrathCommon1CB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCommon1CB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"],  Vanguard_Expedition_FactionText), "wrathcommon1", 2, 1, 0)
	Collectinator_WrathCommon1CBText:SetText(Vanguard_Expedition_FactionText)
	Collectinator_WrathCommon1CBText:SetFont(narrowFont, 11)

	local Collectinator_RepArgentCrusadeCB = CreateFrame("CheckButton", "Collectinator_RepArgentCrusadeCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepArgentCrusadeCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["Argent Crusade"]), "argentcrusade", 3, 1, 0)
	Collectinator_RepArgentCrusadeCBText:SetText(BFAC["Argent Crusade"])
	Collectinator_RepArgentCrusadeCBText:SetFont(narrowFont, 11)

	local Collectinator_WrathCommon5CB = CreateFrame("CheckButton", "Collectinator_WrathCommon5CB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCommon5CB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], Explorer_Hand_FactionText), "wrathcommon5", 4, 1, 0)
	Collectinator_WrathCommon5CBText:SetText(Explorer_Hand_FactionText)
	Collectinator_WrathCommon5CBText:SetFont(narrowFont, 11)
	Collectinator_WrathCommon5CBText:SetText(addon:Grey(Explorer_Hand_FactionText))
	Collectinator_WrathCommon5CB:Disable()

	local Collectinator_RepFrenzyheartCB = CreateFrame("CheckButton", "Collectinator_RepFrenzyheartCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepFrenzyheartCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["Frenzyheart Tribe"]), "frenzyheart", 5, 1, 0)
	Collectinator_RepFrenzyheartCBText:SetText(BFAC["Frenzyheart Tribe"])
	Collectinator_RepFrenzyheartCBText:SetFont(narrowFont, 11)

	local Collectinator_RepKaluakCB = CreateFrame("CheckButton", "Collectinator_RepKaluakCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepKaluakCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Kalu'ak"]), "kaluak", 6, 1, 0)
	Collectinator_RepKaluakCBText:SetText(BFAC["The Kalu'ak"])
	Collectinator_RepKaluakCBText:SetFont(narrowFont, 11)

	local Collectinator_RepKirinTorCB = CreateFrame("CheckButton", "Collectinator_RepKirinTorCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepKirinTorCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["Kirin Tor"]), "kirintor", 7, 1, 0)
	Collectinator_RepKirinTorCBText:SetText(BFAC["Kirin Tor"])
	Collectinator_RepKirinTorCBText:SetFont(narrowFont, 11)

	local Collectinator_RepEbonBladeCB = CreateFrame("CheckButton", "Collectinator_RepEbonBladeCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepEbonBladeCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["Knights of the Ebon Blade"]), "ebonblade", 8, 1, 0)
	Collectinator_RepEbonBladeCBText:SetText(BFAC["Knights of the Ebon Blade"])
	Collectinator_RepEbonBladeCBText:SetFont(narrowFont, 11)

	local Collectinator_RepOraclesCB = CreateFrame("CheckButton", "Collectinator_RepOraclesCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepOraclesCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Oracles"]), "oracles", 9, 1, 0)
	Collectinator_RepOraclesCBText:SetText(BFAC["The Oracles"])
	Collectinator_RepOraclesCBText:SetFont(narrowFont, 11)

	local Collectinator_WrathCommon2CB = CreateFrame("CheckButton", "Collectinator_WrathCommon2CB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCommon2CB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], SilverConv_Sunreaver_FactionText), "wrathcommon2", 10, 1, 0)
	Collectinator_WrathCommon2CBText:SetText(SilverConv_Sunreaver_FactionText)
	Collectinator_WrathCommon2CBText:SetFont(narrowFont, 11)

	local Collectinator_RepSonsOfHodirCB = CreateFrame("CheckButton", "Collectinator_RepSonsOfHodirCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepSonsOfHodirCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Sons of Hodir"]), "sonsofhodir", 11, 1, 0)
	Collectinator_RepSonsOfHodirCBText:SetText(BFAC["The Sons of Hodir"])
	Collectinator_RepSonsOfHodirCBText:SetFont(narrowFont, 11)

	local Collectinator_WrathCommon4CB = CreateFrame("CheckButton", "Collectinator_WrathCommon4CB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCommon4CB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], Frostborn_Taunka_FactionText), "wrathcommon4", 12, 1, 0)
	Collectinator_WrathCommon4CBText:SetText(Frostborn_Taunka_FactionText)
	Collectinator_WrathCommon4CBText:SetFont(narrowFont, 11)
	Collectinator_WrathCommon4CBText:SetText(addon:Grey(Frostborn_Taunka_FactionText))
	Collectinator_WrathCommon4CB:Disable()

	local Collectinator_WrathCommon3CB = CreateFrame("CheckButton", "Collectinator_WrathCommon3CB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_WrathCommon3CB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], Valiance_Warsong_FactionText), "wrathcommon3", 13, 1, 0)
	Collectinator_WrathCommon3CBText:SetText(Valiance_Warsong_FactionText)
	Collectinator_WrathCommon3CBText:SetFont(narrowFont, 11)
	Collectinator_WrathCommon3CBText:SetText(addon:Grey(Valiance_Warsong_FactionText))
	Collectinator_WrathCommon3CB:Disable()

	local Collectinator_RepWyrmrestCB = CreateFrame("CheckButton", "Collectinator_RepWyrmrestCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepWyrmrestCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Wyrmrest Accord"]), "wyrmrest", 14, 1, 0)
	Collectinator_RepWyrmrestCBText:SetText(BFAC["The Wyrmrest Accord"])
	Collectinator_RepWyrmrestCBText:SetFont(narrowFont, 11)

	local Collectinator_RepAshenVerdictCB = CreateFrame("CheckButton", "Collectinator_RepAshenVerdictCB", addon.Fly_Rep_LK, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_RepAshenVerdictCB, addon.Fly_Rep_LK, strformat(L["SPECIFIC_REP_DESC"], BFAC["The Ashen Verdict"]), "ashenverdict", 15, 1, 0)
	Collectinator_RepAshenVerdictCBText:SetText(BFAC["The Ashen Verdict"])
	Collectinator_RepAshenVerdictCBText:SetFont(narrowFont, 11)
	Collectinator_RepAshenVerdictCB:Disable()

	addon.Fly_Misc = CreateFrame("Frame", "Collectinator_Fly_Misc", addon.Flyaway)
	addon.Fly_Misc:SetWidth(210)
	addon.Fly_Misc:SetHeight(280)
	addon.Fly_Misc:EnableMouse(true)
	addon.Fly_Misc:EnableKeyboard(true)
	addon.Fly_Misc:SetMovable(false)
	addon.Fly_Misc:SetPoint("TOPLEFT", addon.Flyaway, "TOPLEFT", 17, -16)
	addon.Fly_Misc:Hide()

	local Collectinator_MiscText = addon.Fly_Misc:CreateFontString("Collectinator_MiscText", "OVERLAY", "GameFontHighlight")
	Collectinator_MiscText:SetText(L["Miscellaneous"] .. ":")
	Collectinator_MiscText:SetPoint("TOPLEFT", addon.Fly_Misc, "TOPLEFT", 5, -8)
	Collectinator_MiscText:SetHeight(14)
	Collectinator_MiscText:SetWidth(150)
	Collectinator_MiscText:SetJustifyH("LEFT")

	local Collectinator_IgnoreCB = CreateFrame("CheckButton", "Collectinator_IgnoreCB", addon.Fly_Misc, "UICheckButtonTemplate")
	addon:GenericMakeCB(Collectinator_IgnoreCB, addon.Fly_Misc, L["DISPLAY_EXCLUSION_DESC"], 0, 2, 1, 1)
	Collectinator_IgnoreCBText:SetText(L["Display Exclusions"])

	-------------------------------------------------------------------------------
	-- Now that everything exists, populate the global filter table
	-------------------------------------------------------------------------------
	local filterdb = addon.db.profile.filters

	FilterValueMap = {
		------------------------------------------------------------------------------------------------
		-- General Options
		------------------------------------------------------------------------------------------------
		["faction"]		= { cb = Collectinator_FactionCB,		svroot = filterdb.general },
		["known"]		= { cb = Collectinator_KnownCB,			svroot = filterdb.general },
		["unknown"]		= { cb = Collectinator_UnknownCB,		svroot = filterdb.general },
		["removed"]		= { cb = Collectinator_RemovedCB,		svroot = filterdb.general },
		------------------------------------------------------------------------------------------------
		-- Obtain Options
		------------------------------------------------------------------------------------------------
		["vendor"]		= { cb = Collectinator_VendorCB,		svroot = filterdb.obtain },
		["quest"]		= { cb = Collectinator_QuestCB,			svroot = filterdb.obtain },
		["instance"]		= { cb = Collectinator_InstanceCB,		svroot = filterdb.obtain },
		["raid"]		= { cb = Collectinator_RaidCB,			svroot = filterdb.obtain },
		["craft"]		= { cb = Collectinator_CraftCB,			svroot = filterdb.obtain },
		["seasonal"]		= { cb = Collectinator_SeasonalCB,		svroot = filterdb.obtain },
		["worlddrop"]		= { cb = Collectinator_WorldDropCB,		svroot = filterdb.obtain },
		["mobdrop"]		= { cb = Collectinator_MobDropCB,		svroot = filterdb.obtain },
		["pvp"]			= { cb = Collectinator_PVPCB,			svroot = filterdb.obtain },
		["tcg"]			= { cb = Collectinator_TCGCB,			svroot = filterdb.obtain },
		["event"]		= { cb = Collectinator_EventCB,			svroot = filterdb.obtain },
		["ce"]			= { cb = Collectinator_CECB,			svroot = filterdb.obtain },
		["achievement"]		= { cb = Collectinator_AchievementCB,		svroot = filterdb.obtain },
		["store"]		= { cb = Collectinator_StoreCB,			svroot = filterdb.obtain },
		["originalwow"]		= { cb = Collectinator_OriginalWoWCB,		svroot = filterdb.obtain },
		["bc"]			= { cb = Collectinator_BCCB,			svroot = filterdb.obtain },
		["wrath"]		= { cb = Collectinator_WrathCB,			svroot = filterdb.obtain },
		------------------------------------------------------------------------------------------------
		-- Binding Options
		------------------------------------------------------------------------------------------------
		["itemboa"]		= { cb = Collectinator_iBoACB,			svroot = filterdb.binding },
		["itemboe"]		= { cb = Collectinator_iBoECB,			svroot = filterdb.binding },
		["itembop"]		= { cb = Collectinator_iBoPCB,			svroot = filterdb.binding },
		------------------------------------------------------------------------------------------------
		-- Binding Options
		------------------------------------------------------------------------------------------------
		["poor"]		= { cb = Collectinator_PoorCB,			svroot = filterdb.rarity },
		["common"]		= { cb = Collectinator_CommonCB,		svroot = filterdb.rarity },
		["uncommon"]	= { cb = Collectinator_UncommonCB,		svroot = filterdb.rarity },
		["rare"]		= { cb = Collectinator_RareCB,			svroot = filterdb.rarity },
		["epic"]		= { cb = Collectinator_EpicCB,			svroot = filterdb.rarity },
		["legendary"]	= { cb = Collectinator_LegendaryCB,		svroot = filterdb.rarity },
		["artifact"]	= { cb = Collectinator_ArtifactCB,		svroot = filterdb.rarity },
		------------------------------------------------------------------------------------------------
		-- Old World Rep Options
		------------------------------------------------------------------------------------------------
		["argentdawn"]		= { cb = Collectinator_RepArgentDawnCB,		svroot = filterdb.rep },
		["cenarioncircle"]	= { cb = Collectinator_RepCenarionCircleCB,	svroot = filterdb.rep },
		["thoriumbrotherhood"]	= { cb = Collectinator_RepThoriumCB,		svroot = filterdb.rep },
		["timbermaw"]		= { cb = Collectinator_RepTimbermawCB,		svroot = filterdb.rep },
		["zandalar"]		= { cb = Collectinator_RepZandalarCB,		svroot = filterdb.rep },
		------------------------------------------------------------------------------------------------
		-- BC Rep Options
		------------------------------------------------------------------------------------------------
		["aldor"]		= { cb = Collectinator_RepAldorCB,		svroot = filterdb.rep },
		["ashtonguedeathsworn"]	= { cb = Collectinator_RepAshtongueCB,		svroot = filterdb.rep },
		["cenarionexpedition"]	= { cb = Collectinator_RepCenarionExpeditionCB,	svroot = filterdb.rep },
		["consortium"]		= { cb = Collectinator_RepConsortiumCB,		svroot = filterdb.rep },
		["hellfire"]		= { cb = Collectinator_RepHonorHoldCB,		svroot = filterdb.rep },
		["keepersoftime"]	= { cb = Collectinator_RepKeepersOfTimeCB,	svroot = filterdb.rep },
		["nagrand"]		= { cb = Collectinator_RepKurenaiCB,		svroot = filterdb.rep },
		["lowercity"]		= { cb = Collectinator_RepLowerCityCB,		svroot = filterdb.rep },
		["scaleofthesands"]	= { cb = Collectinator_RepScaleSandsCB,		svroot = filterdb.rep },
		["scryer"]		= { cb = Collectinator_RepScryersCB,		svroot = filterdb.rep },
		["shatar"]		= { cb = Collectinator_RepShatarCB,		svroot = filterdb.rep },
		["shatteredsun"]	= { cb = Collectinator_RepShatteredSunCB,	svroot = filterdb.rep },
		["sporeggar"]		= { cb = Collectinator_RepSporeggarCB,		svroot = filterdb.rep },
		["violeteye"]		= { cb = Collectinator_RepVioletEyeCB,		svroot = filterdb.rep },
		------------------------------------------------------------------------------------------------
		-- LK Rep Options
		------------------------------------------------------------------------------------------------
		["argentcrusade"]	= { cb = Collectinator_RepArgentCrusadeCB,	svroot = filterdb.rep },
		["frenzyheart"]		= { cb = Collectinator_RepFrenzyheartCB,	svroot = filterdb.rep },
		["ebonblade"]		= { cb = Collectinator_RepEbonBladeCB,		svroot = filterdb.rep },
		["kirintor"]		= { cb = Collectinator_RepKirinTorCB,		svroot = filterdb.rep },
		["sonsofhodir"]		= { cb = Collectinator_RepSonsOfHodirCB,	svroot = filterdb.rep },
		["kaluak"]		= { cb = Collectinator_RepKaluakCB,		svroot = filterdb.rep },
		["oracles"]		= { cb = Collectinator_RepOraclesCB,		svroot = filterdb.rep },
		["wyrmrest"]		= { cb = Collectinator_RepWyrmrestCB,		svroot = filterdb.rep },
		["ashenverdict"]	= { cb = Collectinator_RepAshenVerdictCB,	svroot = filterdb.rep },
		["wrathcommon1"]	= { cb = Collectinator_WrathCommon1CB,		svroot = filterdb.rep },
		-- ["wrathcommon2"]	= { cb = Collectinator_WrathCommon2CB,		svroot = nil },
		-- ["wrathcommon3"]	= { cb = Collectinator_WrathCommon3CB,		svroot = nil },
		-- ["wrathcommon4"]	= { cb = Collectinator_WrathCommon4CB,		svroot = nil },
		-- ["wrathcommon5"]	= { cb = Collectinator_WrathCommon5CB,		svroot = nil },
	}
end

-------------------------------------------------------------------------------
-- Displays the main collectible frame if it exists. Otherwise, create the frame
-- and initialize it, then show it.
-------------------------------------------------------------------------------
function addon:DisplayFrame(
	cPlayer, 	-- playerdata
	vList, 		-- VendorList
	qList, 		-- QuestList
	rList, 		-- ReputationList
	sList, 		-- SeasonalList
	mList, 		-- MobList
	cList)		-- Customlist
	-------------------------------------------------------------------------------
	-- cPlayer is a table containing:
	-- .totalCollectibles == Total collectibles added to the database
	-- .foundCollectibles == Total collectibles found that the player knows
	-- .otherCollectibles == Total non-profession collectibles in the database
	-- .filteredCollectibles == Total collectibles filtered
	-- .playerFaction == Faction of the player
	-- ["Reputation"] == Reputation levels, what I had in current Collectinatorform was if you didn't have the rep level, it would display it in red
	-------------------------------------------------------------------------------
	myFaction = cPlayer.playerFaction

	playerData = cPlayer
	vendorDB = vList
	questDB = qList
	repDB = rList
	seasonDB = sList
	mobDB = mList
	customDB = cList

	WipeDisplayStrings()	-- reset current display items

	local companion_frame = PetPaperDollFrameCompanionFrame
	local hide_frame;

	if (PetListPlus and PetListPlusFrame:IsVisible()) or (CE_Pets and CE_Pets:IsVisible()) or companion_frame:IsVisible() then
		-- frame is visible, check for same scan
		if self.Frame and self.Frame:IsVisible() then
			if (current_tab ~= INDEX_TYPE[companion_frame.mode] or current_tab == 0) then
				--new scan > show
				current_tab = INDEX_TYPE[companion_frame.mode] or 0
			else
				--same scan > hide
				addon:CloseWindow()
				hide_frame = true;
			end
		-- frame is not visible, show anyway
		else
			current_tab = INDEX_TYPE[companion_frame.mode] or 0
		end
	end

	if not self.Frame then
		InitializeFrame()
		InitializeFrame = nil
	end

	if not hide_frame then
		SetFramePosition()							-- Set our addon frame position
		Collectinator_DD_Sort.initialize = Collectinator_DD_Sort_Initialize	-- Initialize dropdown

		-- reset the scale
		self.Frame:SetScale(addon.db.profile.frameopts.uiscale)
		CollectinatorSpellTooltip:SetScale(addon.db.profile.frameopts.tooltipscale)

		-- We'll be in "ExpandAll" mode to start with. Make sure the button knows that:
		Collectinator_ExpandButton:SetText(L["EXPANDALL"])
		TooltipDisplay(Collectinator_ExpandButton, L["EXPANDALL_DESC"])

		self.resetTitle()
		self.Frame.mode_button:ChangeTexture(SortedCollections[current_tab].texture)

		-- Sort the list
		collectibleDB = self.data_table
		sortedCollectibleIndex = SortDatabase(collectibleDB)

		initDisplayStrings()							-- Take our sorted list, and fill up DisplayStrings
		self.Frame.progress_bar:Update()

		-- And update our scrollframe
		CollectibleList_Update()
		self.Frame:Show()

		-- Make sure to reset search gui elements
		Collectinator_LastSearchedText = ""
		Collectinator_SearchText:SetText(L["SEARCH_BOX_DESC"])
	end
end


-------------------------------------------------------------------------------
-- Creates a new frame with the contents of a text dump so you can copy and paste
-- Based on code borrowed (with permission) from Antiarc's Chatter
-- @name Collectinator:DisplayTextDump
-- @param CollectibleDB The database table you wish read data from.
-- @param collectible_type The type of collectible are you displaying data for
-- @param text The text to be dumped
-------------------------------------------------------------------------------
do
	local copy_frame = CreateFrame("Frame", "CollectinatorCopyFrame", UIParent)
	copy_frame:SetBackdrop({
				       bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
				       edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
				       tile = true, tileSize = 16, edgeSize = 16,
				       insets = { left = 3, right = 3, top = 5, bottom = 3 }
			       })
	copy_frame:SetBackdropColor(0, 0, 0, 1)
	copy_frame:SetWidth(750)
	copy_frame:SetHeight(400)
	copy_frame:SetPoint("CENTER", UIParent, "CENTER")
	copy_frame:SetFrameStrata("DIALOG")

	tinsert(UISpecialFrames, "CollectinatorCopyFrame")

	local scrollArea = CreateFrame("ScrollFrame", "CollectinatorCopyScroll", copy_frame, "UIPanelScrollFrameTemplate")
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
	edit_box:SetScript("OnEscapePressed", function() copy_frame:Hide() end)
	edit_box:HighlightText(0)

	scrollArea:SetScrollChild(edit_box)

	local close = CreateFrame("Button", nil, copy_frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", copy_frame, "TOPRIGHT")

	copy_frame:Hide()

	function addon:DisplayTextDump(CollectibleDB, collectible_type, text)
		edit_box:SetText((not CollectibleDB and not collectible_type) and text or self:GetTextDump(CollectibleDB, collectible_type))
		edit_box:HighlightText(0)
		copy_frame:Show()
	end
end	-- do
