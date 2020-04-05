--[[

****************************************************************************************

Config.lua

Ace3 Configuration options for Collectinator

File date: 2010-07-27T16:13:18Z
File revision: @file-revision@
Project revision: @project-revision@
Project version: v1.0.4

****************************************************************************************

]]--

local MODNAME		= "Collectinator"
local addon		= LibStub("AceAddon-3.0"):GetAddon(MODNAME)
local L			= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

local AceConfig 	= LibStub("AceConfig-3.0")
local AceConfigReg 	= LibStub("AceConfigRegistry-3.0")
local AceConfigDialog 	= LibStub("AceConfigDialog-3.0")

local modularOptions = {}

local addonversion = GetAddOnMetadata("Collectinator", "Version")
addonversion = string.gsub(addonversion, "@project.revision@", "GIT")

local function giveProfiles()
	return LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
end

local options = nil

local function fullOptions()

	local disableknownfiltered = false

	if (not options) then

		options = {
			type = "group",
			name = MODNAME,
			args = {
				general = {
					order	= 1,
					type	= "group",
					name	= L["Main Options"],
					desc	= L["MAIN_OPTIONS_DESC"],
					args	= {
						header1 = {
							order	= 10,
							type	= "header",
							name	= L["General Options"],
						},
						version = {
							order	= 11,
							type	= "description",
							name	= L["Version"] .. addonversion .. "\n",
						},
						run = {
							order	= 12,
							type	= "execute",
							name	= L["Scan"],
							desc	= L["SCAN_COMPANIONS_DESC"],
							func	= function(info) addon:Scan(false) end,
						},
						textdump = {
							order	= 13,
							type	= "execute",
							name	= L["Text Dump"],
							desc	= L["TEXT_DUMP_DESC"],
							func	= function(info) addon:Scan(true) end,
						},
						exclusionlist = {
							order	= 14,
							type	= "execute",
							name	= L["View Exclusion List"],
							desc	= L["VIEW_EXCLUSION_LIST_DESC"],
							func	= function(info) addon:ViewExclusionList() end,
						},
						clearexclusionlist = {
							order	= 15,
							type	= "execute",
							name	= L["Clear Exclusion List"],
							desc	= L["CLEAR_EXCLUSION_LIST_DESC"],
							func	= function(info) addon:ClearExclusionList() end,
						},
						resetallfilters = {
							order	= 16,
							type	= "execute",
							name	= L["Reset All Filters"],
							desc	= L["RESET_DESC"],
							func	= function(info) addon.resetFilters() end,
						},
						resetguiwindow = {
							order	= 17,
							type	= "execute",
							name	= L["Reset Window Position"],
							desc	= L["RESET_WINDOW_DESC"],
							func	= function(info) addon:ResetGUI() end,
						},
						spacer1 = {
							order	= 19,
							type	= "description",
							name	= "\n",
						},
						header1a = {
							order	= 20,
							type	= "header",
							name	= L["Main Filter Options"],
						},
						mainfilter_desc = {
							order	= 21,
							type	= "description",
							name	= L["MAINFILTER_OPTIONS_DESC"] .. "\n",
						},
						includefiltered = {
							order	= 22,
							type	= "toggle",
							name	= L["Include Filtered"],
							desc	= L["FILTERCOUNT_DESC"],
							get		= function() return addon.db.profile.includefiltered end,
							set		= function()
										addon.db.profile.includefiltered = not addon.db.profile.includefiltered
										disableknownfiltered = not addon.db.profile.includefiltered
									end,
						},
						includeknownfiltered = {
							order	= 23,
							type	= "toggle",
							name	= L["Include Known Filtered"],
							desc	= L["FILTERKNOWNCOUNT_DESC"],
							disabled = disableknownfiltered,
							get		= function() return addon.db.profile.includeknownfiltered end,
							set		= function() addon.db.profile.includeknownfiltered = not addon.db.profile.includeknownfiltered end,
						},
						includeexcluded = {
							order	= 24,
							type	= "toggle",
							name	= L["Include Excluded"],
							desc	= L["EXCLUDECOUNT_DESC"],
							get		= function() return addon.db.profile.includeexcluded end,
							set		= function() addon.db.profile.includeexcluded = not addon.db.profile.includeexcluded end,
						},
						ignoreexclusionlist = {
							order	= 25,
							type	= "toggle",
							name	= L["Display Exclusions"],
							desc	= L["DISPLAY_EXCLUSION_DESC"],
							get		= function() return addon.db.profile.ignoreexclusionlist end,
							set		= function() addon.db.profile.ignoreexclusionlist = not addon.db.profile.ignoreexclusionlist end,
						},
						spacer2 = {
							order	= 39,
							type	= "description",
							name	= "\n",
						},
						header3 = {
							order	= 40,
							type	= "header",
							name	= L["Sorting Options"],
						},
						sort_desc =	{
							order	= 41,
							type	= "description",
							name	= L["SORTING_OPTIONS_DESC"] .. "\n",
						},
						sorting = {
							order	= 45,
							type	= "select",
							name	= L["Sorting"],
							desc	= L["SORTING_DESC"],
							get		= function() return addon.db.profile.sorting end,
							set		= function(info,name) addon.db.profile.sorting = name end,
							values	= function() return {Name = L["Name"], Acquisition = L["Acquisition"], Location = L["Location"]} end,
						},
					},
				},
			},
		}

		for k,v in pairs(modularOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end

	end

	return options

end

local documentation = nil

local function giveDocs()

	if (not documentation) then

		documentation = {
			order = 1,
			type = "group",
			name = L["Documentation"],
			args = {
				header1 = {
					order	= 1,
					type	= "header",
					name	= L["Collectinator Documentation"],
				},
				desc1 = {
					order	= 2,
					type	= "description",
					name	= L["DOC_DESC"],
				},
				header2 = {
					order	= 3,
					type	= "header",
					name	= L["Using Filters"],
				},
				desc2 = {
					order	= 4,
					type	= "description",
					name	= L["USING_FILTERS_DESC"],
				},
				header3 = {
					order	= 5,
					type	= "header",
					name	= L["Common Issues"],
				},
				desc3 = {
					order	= 6,
					type	= "description",
					name	= L["COMMON_ISSUES_DESC"],
				},
				header4 = {
					order	= 7,
					type	= "header",
					name	= L["Reporting Bugs"],
				},
				desc4 = {
					order	= 8,
					type	= "description",
					name	= L["REPORTING_BUGS_DESC"],
				},
				header5 = {
					order	= 9,
					type	= "header",
					name	= L["Exclusion Issues"],
				},
				desc5 = {
					order	= 10,
					type	= "description",
					name	= L["EXCLUSION_ISSUES_DESC"],
				},
				header6 = {
					order	= 11,
					type	= "header",
					name	= L["Map Issues"],
				},
				desc6 = {
					order	= 12,
					type	= "description",
					name	= L["MAP_ISSUES_DESC"],
				},
				header7 = {
					order	= 13,
					type	= "header",
					name	= L["Game Commands"],
				},
				desc7 = {
					order	= 14,
					type	= "description",
					name	= L["GAME_COMMANDS_DESC"],
				},
			},
		}

	end

	return documentation

end

local displayoptions = nil

local function giveDisplay()

	if (not displayoptions) then

	displayoptions = {
			order = 1,
			type = "group",
			name = L["Display Options"],
			desc = L["DISPLAY_OPTIONS_DESC"],
			args = {
				display_desc =	{
					order	= 1,
					type	= "description",
					name	= L["MAP_OPTIONS_DESC"] .. "\n",
				},
				uiscale = {
					order	= 3,
					type	= "range",
					name	= _G.UI_SCALE,
					desc	= L["UI_SCALE_DESC"],
					min	= .5,
					max	= 1.5,
					step	= .05,
					bigStep = .05,
					get	= function() return addon.db.profile.frameopts.uiscale end,
					set	= function(info, v)
							addon.db.profile.frameopts.uiscale = v
							if (addon.Frame) then addon.Frame:SetScale(v) end
						end,
				},
				fontsize = {
					order	= 4,
					type	= "range",
					name	= L["Font Size"],
					desc	= L["FONT_SIZE_DESC"],
					min	= 6,
					max	= 20,
					step	= 1,
					bigStep = 1,
					get	= function() return addon.db.profile.frameopts.fontsize end,
					set	= function(info, v) addon.db.profile.frameopts.fontsize = v end,
				},
				hidepopup = {
					order	= 6,
					type	= "toggle",
					name	= L["Hide Pop-Up"],
					desc	= L["HIDEPOPUP_DESC"],
					get	= function() return addon.db.profile.hidepopup end,
					set	= function() addon.db.profile.hidepopup = not addon.db.profile.hidepopup end,
				},
				spacer1 = {
					order	= 10,
					type	= "description",
					name	= "\n",
				},
				tooltip_header = {
					order	= 11,
					type	= "header",
					name	= L["Tooltip Options"],
				},
				tooltip_desc =	{
					order	= 12,
					type	= "description",
					name	= L["TOOLTIP_OPTIONS_DESC"] .. "\n",
				},
				tooltipscale = {
					order	= 20,
					type	= "range",
					name	= L["Tooltip Scale"],
					desc	= L["TOOLTIP_SCALE_DESC"],
					min	= .5,
					max	= 1.5,
					step	= .05,
					bigStep = .05,
					get	= function() return addon.db.profile.frameopts.tooltipscale end,
					set	= function(info, v)
							addon.db.profile.frameopts.tooltipscale = v
							if (CollectinatorTooltip) then CollectinatorTooltip:SetScale(v) end
							if (CollectinatorSpellTooltip) then CollectinatorSpellTooltip:SetScale(v) end
						end,
				},
				acquiretooltiplocation = {
					order	= 21,
					type	= "select",
					name	= L["Tooltip (Acquire) Position"],
					desc	= L["ACQUIRETOOLTIPPOSITION_DESC"],
					get	= function() return addon.db.profile.acquiretooltiplocation end,
					set	= function(info,name) addon.db.profile.acquiretooltiplocation = name end,
					values	= function() return {Right = L["Right"], Left = L["Left"], Top = L["Top"], Bottom = L["Bottom"], Off = L["Off"], Mouse = L["Mouse"]} end,
				},
				spelltooltiplocation = {
					order	= 22,
					type	= "select",
					name	= L["Tooltip (Collectible) Position"],
					desc	= L["SPELLTOOLTIPPOSITION_DESC"],
					get		= function() return addon.db.profile.spelltooltiplocation end,
					set		= function(info,name) addon.db.profile.spelltooltiplocation = name end,
					values	= function() return {Right = L["Right"], Left = L["Left"], Top = L["Top"], Bottom = L["Bottom"], Off = L["Off"]} end,
				},
			},
		}


	end

	return displayoptions

end

local map = nil

local function giveMap()

	local tomtomsupport = true

	if ((TomTom) or ((TomTom) and (Carbonite))) then
		tomtomsupport = false
	end

	if (not map) then

	map = {
			order	= 1,
			type	= "group",
			name	= L["Map Options"],
			desc	= L["MAP_OPTIONS_DESC"],
			args	= {
				map_desc =	{
					order	= 1,
					type	= "description",
					name	= L["MAP_OPTIONS_DESC"] .. "\n",
				},
				autoscanmap = {
					order	= 2,
					type	= "toggle",
					name	= L["Auto Scan Map"],
					desc	= L["AUTOSCANMAP_DESC"],
					disabled = tomtomsupport,
					get		= function() return addon.db.profile.autoscanmap end,
					set		= function() addon.db.profile.autoscanmap = not addon.db.profile.autoscanmap end,
				},
				worldmap = {
					order	= 3,
					type	= "toggle",
					name	= _G.WORLD_MAP,
					desc	= L["WORLDMAP_DESC"],
					disabled = tomtomsupport,
					get		= function() return addon.db.profile.worldmap end,
					set		= function() addon.db.profile.worldmap = not addon.db.profile.worldmap end,
				},
				minimap = {
					order	= 4,
					type	= "toggle",
					name	= L["Mini Map"],
					desc	= L["MINIMAP_DESC"],
					disabled = tomtomsupport,
					get		= function() return addon.db.profile.minimap end,
					set		= function() addon.db.profile.minimap = not addon.db.profile.minimap end,
				},
				clearmap = {
					order	= 20,
					type	= "execute",
					name	= L["Clear Waypoints"],
					disabled = tomtomsupport,
					desc	= L["CLEAR_WAYPOINTS_DESC"],
					func	= function() addon:ClearMap() end,
				},
			},
		}

	end

	return map

end


function addon:SetupOptions()

	AceConfigReg:RegisterOptionsTable(MODNAME, fullOptions)
	self.optionsFrame = AceConfigDialog:AddToBlizOptions(MODNAME, nil, nil, "general")

	-- Add in the about panel to the Bliz options (but not the ace3 config)
	if LibStub:GetLibrary("LibAboutPanel", true) then
		self.optionsFrame["About"] = LibStub:GetLibrary("LibAboutPanel").new(MODNAME, MODNAME)
	else
		self:Print("Lib AboutPanel not loaded.")
	end

	-- Fill up our modular options...
	self:RegisterModuleOptions("Display", giveDisplay(), L["Display Options"])
	self:RegisterModuleOptions("Documentation", giveDocs(), L["Collectinator Documentation"])
	self:RegisterModuleOptions("Map", giveMap(), L["Map Options"])
	self:RegisterModuleOptions("Profiles", giveProfiles(), L["Profile Options"])

end

-- Description: Function which extends our options table in a modular way
-- Expected result: add a new modular options table to the modularOptions upvalue as well as the Blizzard config
-- Input:
--		name		: index of the options table in our main options table
--		optionsTable	: the sub-table to insert
--		displayName	: the name to display in the config interface for this set of options
-- Output: None.

function addon:RegisterModuleOptions(name, optionsTable, displayName)

	modularOptions[name] = optionsTable
	self.optionsFrame[name] = AceConfigDialog:AddToBlizOptions(MODNAME, displayName, MODNAME, name)

end
