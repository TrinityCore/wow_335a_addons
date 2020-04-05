-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> global name declaration
 
		_ = nil
		_details = LibStub("AceAddon-3.0"):NewAddon("_details", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")
		_details.build_counter = 101 --it's 101 for release
		_details.userversion = "v1.29.3"
		_details.realversion = 28
		_details.version = _details.userversion .. "(core " .. _details.realversion .. ")"

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialization stuff
 
do 

	local _details = _G._details
	
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	
	--[[

|cFFFFFF00-|r Fixed an addon crash bug when clicking directly on the sword button.\n\n|cFFFFFF00-|r Removed Flat Skin, added new skin: Serenity.\n\n
	--]]

	
	Loc["STRING_VERSION_LOG"] = "|cFFFFFF00v1.29.3(|cFFFFCC00Oct 11, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed an addon crash bug when clicking directly on the sword button.\n\n|cFFFFFF00-|r Removed Flat Skin, added new skin: Serenity.\n\n|cFFFFFF00-|r Fixed many issues with bar animations.\n\n|cFFFFFF00-|r Fixed combat encounter start if the player already is in combat when the boss is pulled.\n\n|cFFFFFF00-|r Fixed wheel scroll when sometimes it move very slow or doesn't move the bars at all.\n\n|cFFFFFF00-|r Added option 'Always Show Me' which when enabled and you aren't at the top ranked players shown in the window, it forces to show you in the last bar.\n\n|cFFFFFF00-|r Added option 'First Hit' which when enabled show who did the first struck in the combat(normally is who pulled the boss).\n\n|cFFFFFF00-|r Added a panel to change class colors.\n\n|cFFFFFF00v1.28.3(|cFFFFCC00Oct 04, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added support for plugin descriptions on options panel.\n\n|cFFFFFF00-|r Added scale option.\n\n|cFFFFFF00-|r Added a Change Log button on Options Panel.\n\n|cFFFFFF00-|r Added option to use the same profile on all characters without asking.\n\n|cFFFFFF00-|r Added a shortcut color button on main panel on Options Panel.\n\n|cFFFFFF00-|r Added auto erase/ask to erase options.\n\n|cFFFFFF00-|r Bars now highlight when hover over.\n\n|cFFFFFF00-|r Fixed problem with drag the window when the toolbar is on the bottom side.\n\n|cFFFFFF00v1.27.0(|cFFFFCC00Set 27, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Minimalistic skin is now the old minimalistic v2.\n\n|cFFFFFF00-|r Minimalistic v2 got a new texture, little more darker.\n\n|cFFFFFF00-|r Few tweaks to make more easy making groups of windows.\n\n|cFFFFFF00-|r Bookmark now accepts more than two columns.\n\n|cFFFFFF00v1.26.3(|cFFFFCC00Set 18, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Changed the way to set the broker text to be more customizable.\n\n|cFFFFFF00-|r Fixed the problem with custom display report.\n\n|cFFFFFF00-|r Added tutorial and a config panel for bookmarks.\n\n|cFFFFFF00-|r Added option for choose the format type of data broker's text.\n\n|cFFFFFF00-|r Changed few icons on damage done tooltip.\n\n|cFFFFFF00-|r Fixed the class color on texts for healing attribute.\n\n|cFFFFFF00-|r Added options for change the tooltip border's size, color and texture.\n\n|cFFFFFF00-|r Added buttons for test interrupt and cooldown announcers under raid tools section.\n\n|cFFFFFF00v1.25.1(|cFFFFCC00Set 09, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added buttons to edit the total and percentage code for custom displays.\n\n|cFFFFFF00-|r Fixed a problem while report custom displays.\n\n|cFFFFFF00-|r Added Acitivity Time for Damage + Healing, tooltip show the activity separately.\n\n|cFFFFFF00-|r Major changes on Encounter Details Plugin making more easy to use.\n\n|cFFFFFF00-|r Removed Spell Details Plugin.\n\n|cFFFFFF00-|r Added new plugin for Solo Mode: Dps Tuning.\n\n|cFFFFFF00v1.24.5(|cFFFFCC00Ago 31, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added Raid Tools bracket on Options Panel.\n\n|cFFFFFF00-|r Added interrupt, cooldown and death announcers(raid tools).\n\n|cFFFFFF00-|r Added pre potion recognition, showing after the encounter on the chat only for you(raid tools).\n\n|cFFFFFF00-|r Added a Boss Emotes tab for Encounter Details plugin |cFF999999(thanks Bloodforce-Azralon)|r.\n\n|cFFFFFF00-|r Rework on Activity Time, now it is tuned to closely match warcraftlogs |cFF999999(thanks www.warcraftlogs.com)|r.\n\n|cFFFFFF00-|r Added two new customs: Damage Activity Time and Healing Activity Time.\n\n|cFFFFFF00-|r Time Attack Plugin now have six fixed time amount options for test your dps on training dummies.\n\n|cFFFFFF00-|r Time Attack Plugin can now also share results on your realm, between players with the same class.\n\n|cFFFFFF00v1.23.6(|cFFFFCC00Ago 24, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added 2 new bar textures and 6 new fonts.\n\n|cFFFFFF00-|r Swapped left and middle button for enemy bars, now left button open damage taken and middle button player detail window.\n\n|cFFFFFF00-|r Added new skin: Minimalistic v2.\n\n|cFFFFFF00-|r Minimalistic v2 is now the default skin.\n\n|cFFFFFF00-|r Few changes on both icon packs with transparency.\n\n|cFFFFFF00-|r Replaced the slash command '/d' with '/de' |cFF999999(thanks @kamuul-mmochampion forum)|r.\n\n|cFFFFFF00-|r Added custom spells for Atonement, Power Word: Solance and Life Bloom |cFF999999(thanks @skmzarn-mmochampion forum)|r.\n\n|cFFFFFF00v1.22.4(|cFFFFCC00Ago 15, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added new skin: ElvUI Frame Style(Black White).\n\n|cFFFFFF00-|r Align With Right Chat Window option now check if the window have statusbar enabled.\n\n|cFFFFFF00-|r Few improvements on report for Deaths and Spells over Player Detail Window.\n\n|cFFFFFF00-|r Added option to disable reset button(reset only using its tooltip menu).\n\n|cFFFFFF00-|r Added option for disable window groups.\n\n|cFFFFFF00-|r Added option for select the icon pack to use, also added black white icon pack.\n\n|cFFFFFF00-|r Fixed many bugs involving skins and profiles, thing should run more smooth now.\n\n|cFFFFFF00-|r Plugin Time Attack now correctly saves the attempt when pressing the big save button.\n\n|cFFFFFF00-|r Added support for hotcorners.\n\n|cFFFFFF00v1.21.4(|cFFFFCC00Ago 9, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added Shaman's Ancestral Guidance on cooldowns list |cFF999999(thanks @skmzarn-mmochampion forum)|r.\n\n|cFFFFFF00-|r Added a profile selection screen when Details! are running for the first time on a character.\n\n|cFFFFFF00-|r Added Menu Text Size option over miscellaneous section on options panel |cFF999999(thanks @ Revi-mmochampion forum)|r.\n\n|cFFFFFF00-|r Fixed a bug over Healing Player Details Window where pets wasn't being shown |cFF999999(thanks @Mystery2012-mmochampion forum)|r.\n\n|cFFFFFF00-|r Fixed issue with summoning pets with unknown owners where it was breaking the summon of all the others pets. |cFF999999(thanks @ThunderLost-curse website)|r.\n\n|cFFFFFF00-|r Hot Corners isn't no more a part of Details!, instead of that, Hot Corner is now a standalone addon which needs to be installed separately for who wants to use it.\n\n|cFFFFFF00-|r Skin data is now stored inside the profiles, many code parts got rewrite, still may have few bugs but it's more reliable then before.\n\n|cFFFFFF00-|r Rework on Auras and Voidzones: now shows damage, dps and percentage. Also its tooltip got fixes and now shows the correct damage done to players.\n\n|cFFFFFF00-|r Tooltip for Enemies now shows damage taken from players |cFF999999(thanks @Arieth-mmochampion forum)|r.\n\n|cFFFFFF00-|r Right clicking a real-time enemy bar, makes it back to Enemies display instead of show Bookmark panel |cFF999999(thanks @Arieth-mmochampion forum)|r.\n\n|cFFFFFF00-|r Tank comparison from previous segment now uses the same percentage method from player comparison panel.\n\n|cFFFFFF00-|r Fix bug with the slash command 'show' where was ignoring the window limit set on options panel |cFF999999(thanks @Castiel-US-Azralon realm)|r.\n\n|cFFFFFF00-|r Fixed few bugs with scroll bars, including scrolls on dropdown menu and player detail window |cFF999999(thanks @Revi-mmochampion forum)|r.\n\n|cFFFFFF00v1.20.2(|cFFFFCC00Aug 1, 2014|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added a option under Miscellaneous section to provide spell link instead of spell name for helpful spells when reporting a death |cFF999999(thanks @skmzarn-mmochampion forum)|r.\n\n|cFFFFFF00-|r Improvements done on how deaths are handled, now latest events before death will be more precise.\n\n|cFFFFFF00-|r Implemented Damage Taken from environment like lava, gravity, etc.\n\n|cFFFFFF00-|r Added Warlock's Fire and Brimstone spell on customized spells."
	Loc["STRING_DETAILS1"] = "|cffffaeaeDetails!:|r "

	--> startup
		_details.initializing = true
		_details.enabled = true
		_details.__index = _details
		_details._time = time()
		_details.debug = false
		_details.opened_windows = 0
		
	--> containers
		--> armazenas as funções do parser - All parse functions 
			_details.parser = {} 
			_details.parser_functions = {}
			_details.parser_frame = CreateFrame("Frame", nil, _UIParent)
			_details.parser_frame:Hide()
		--> armazena os shields - Shields information for absorbs
			_details.shields = {} 
		--> armazena as funções dos frames - Frames functions
			_details.gump = {} 
			function _details:GetFramework()
				return self.gump
			end
		--> armazena as funções para inicialização dos dados - Metatable functions
			_details.refresh = {} 
		--> armazena as funções para limpar e guardas os dados - Metatable functions
			_details.clear = {} 
		--> armazena a config do painel de fast switch
			_details.switch = {} 
		--> armazena os estilos stargets
			_details.savedStyles = {}
		--> armazena quais attributes possue window de attributes - contain attributes and sub attributos wich have a detailed window(left click on a row)
			_details.row_singleclick_overwrite = {} 
		--> report
			_details.ReportOptions = {}
		--> armazena os buffs registrados - store buffs ids and functions
			_details.Buffs = {} --> initialize buff table
		-->  cache de group
			_details.cache_damage_group = {}
			_details.cache_healing_group = {}
		--> ignored pets
			_details.pets_ignored = {}
			_details.pets_no_owner = {}
		--> armazena as skins disponíveis para as windows
			_details.skins = {}
		--> armazena os hooks das funções do parser
			_details.hooks = {}
		--> informações sobre a fight do boss atual
			_details.encounter_end_table = {}
			_details.encounter_table = {}
		--> informações sobre a arena atual
			_details.arena_table = {}
			_details.arena_info = {
				[562] = {file = "LoadScreenBladesEdgeArena", coords = {0, 1, 0.29296875, 0.9375}}, -- Circle of Blood Arena
				[617] = {file = "LoadScreenDalaranSewersArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Dalaran Arena
				[559] = {file = "LoadScreenNagrandArenaBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ring of Trials
				[980] = {file = "LoadScreenTolvirArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Tol'Viron Arena
				[572] = {file = "LoadScreenRuinsofLordaeronBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ruins of Lordaeron
				[1134] = {file = "LoadingScreen_Shadowpan_bg", coords = {0, 1, 0.29296875, 0.857421875}}, -- Tiger's Peak
				--"LoadScreenOrgrimmarArena", --Ring of Valor 
			}
		--> armazena instances inactives
			_details.unused_instances = {}
			
			function _details:GetArenaInfo(mapid)
				local t = _details.arena_info[mapid]
				if (t) then
					return t.file, t.coords
				end
			end
			
		--> tooltip
			_details.tooltip_backdrop = {
				bgFile =[[Interface\AddOns\Details\images\UI-DialogBox-Background-Dark]], 
				edgeFile =[[Interface\Tooltips\UI-Tooltip-Border]], 
				tile = true,
				edgeSize = 16, 
				tileSize = 16, 
				insets = {left = 3, right = 3, top = 4, bottom = 4}
			}
			_details.tooltip_border_color = {1, 1, 1, 1}
			_details.tooltip_spell_icon = {file =[[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
			--_details.tooltip_target_icon = {file =[[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
		
		
	--> Plugins
		--> raid -------------------------------------------------------------------
			--> general function for raid mode plugins
				_details.RaidTables = {} 
			--> menu for raid modes
				_details.RaidTables.Menu = {} 
			--> plugin objects for raid mode
				_details.RaidTables.Plugins = {} 
			--> name to plugin object
				_details.RaidTables.NameTable = {} 
			--> using by
				_details.RaidTables.InstancesInUse = {} 
				_details.RaidTables.PluginsInUse = {} 

		--> solo -------------------------------------------------------------------
			--> general functions for solo mode plugins
				_details.SoloTables = {} 
			--> maintain plugin menu
				_details.SoloTables.Menu = {} 
			--> plugins objects for solo mode
				_details.SoloTables.Plugins = {} 
			--> name to plugin object
				_details.SoloTables.NameTable = {} 
		
		--> toolbar -------------------------------------------------------------------
			--> plugins container
				_details.ToolBar = {}
			--> current showing icons
				_details.ToolBar.Shown = {}
				_details.ToolBar.AllButtons = {}
			--> plugin objects
				_details.ToolBar.Plugins = {}
			--> name to plugin object
				_details.ToolBar.NameTable = {}
				_details.ToolBar.Menu = {}
		
		--> statusbar -------------------------------------------------------------------
			--> plugins container
				_details.StatusBar = {}
			--> maintain plugin menu
				_details.StatusBar.Menu = {} 
			--> plugins object
				_details.StatusBar.Plugins = {} 
			--> name to plugin object
				_details.StatusBar.NameTable = {} 

	--> constants
		_details._details_props = {
			DATA_TYPE_START = 1,	--> Something on start
			DATA_TYPE_END = 2,	--> Something on end

			MODE_ALONE = 1,	--> Solo
			MODE_GROUP = 2,	--> Group
			MODE_ALL = 3,		--> Everything
			MODE_RAID = 4,	--> Raid
		}
		_details.modes = {
			alone = 1, --> Solo
			group = 2,	--> Group
			all = 3,	--> Everything
			raid = 4	--> Raid
		}

		_details.dividers = {
			open = "(",	--> open
			close = ")",	--> close
			placing = ". " --> dot
		}
		
		_details.role_texcoord = {
			DAMAGER = "72:130:69:127",
			HEALER = "72:130:2:60",
			TANK = "5:63:69:127",
			NONE = "139:196:69:127",
		}
		
		_details.player_class = {
			["HUNTER"] = true,
			["WARRIOR"] = true,
			["PALADIN"] = true,
			["SHAMAN"] = true,
			["MAGE"] = true,
			["ROGUE"] = true,
			["PRIEST"] = true,
			["WARLOCK"] = true,
			["DRUID"] = true,
			["DEATHKNIGHT"] = true,
		}
		
		local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")
		
		_details.segments = {
			label = Loc["STRING_SEGMENT"]..": ", 
			overall = Loc["STRING_TOTAL"], 
			overall_standard = Loc["STRING_OVERALL"],
			current = Loc["STRING_CURRENT"], 
			current_standard = Loc["STRING_CURRENTFIGHT"],
			past = Loc["STRING_FIGHTNUMBER"] 
		}
		
		_details._details_props["mode_name"] = {
				[_details._details_props["MODE_ALONE"]] = Loc["STRING_MODE_SELF"], 
				[_details._details_props["MODE_GROUP"]] = Loc["STRING_MODE_GROUP"], 
				[_details._details_props["MODE_ALL"]] = Loc["STRING_MODE_ALL"],
				[_details._details_props["MODE_RAID"]] = Loc["STRING_MODE_RAID"]
		}
		
		--[[global]] DETAILS_MODE_SOLO = 1
		--[[global]] DETAILS_MODE_RAID = 4
		--[[global]] DETAILS_MODE_GROUP = 2
		--[[global]] DETAILS_MODE_ALL = 3

		_details.icons = {
			--> report window
			report = { 
					up = "Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon",
					down = "Interface\\MINIMAP\\TRACKING\\Profession",
					disabled = "Interface\\MINIMAP\\TRACKING\\Profession",
					highlight = nil
				}
		}
	
		_details.missTypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"} --> do not localize-me

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frames
	
	local _CreateFrame = CreateFrame --api locals
	local _UIParent = UIParent --api locals
	
	--> Info Window
		_details.window_info = _CreateFrame("Frame", "Details_WindowInfo", _UIParent)

	--> Event Frame
		_details.listener = _CreateFrame("Frame", nil, _UIParent)
		_details.listener:RegisterEvent("ADDON_LOADED")
		_details.listener:RegisterEvent("PLAYER_LOGOUT")
		_details.listener:SetFrameStrata("LOW")
		_details.listener:SetFrameLevel(9)
		_details.listener.FrameTime = 0
		
		_details.overlay_frame = _CreateFrame("Frame", nil, _UIParent)
		_details.overlay_frame:SetFrameStrata("TOOLTIP")

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> functions
	
	_details.empty_function = function() end
	
	--> register textures and fonts for shared media
		local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
		--default bars
		SharedMedia:Register("statusbar", "Details D'ictum",[[Interface\AddOns\Details\images\bar4]])
		SharedMedia:Register("statusbar", "Details Vidro",[[Interface\AddOns\Details\images\bar4_vidro]])
		SharedMedia:Register("statusbar", "Details D'ictum(reverse)",[[Interface\AddOns\Details\images\bar4_reverse]])
		--flat bars
		SharedMedia:Register("statusbar", "Details Serenity",[[Interface\AddOns\Details\images\bar_serenity]])
		SharedMedia:Register("statusbar", "BantoBar",[[Interface\AddOns\Details\images\BantoBar]])
		SharedMedia:Register("statusbar", "Skyline",[[Interface\AddOns\Details\images\bar_skyline]])
		--window bg and bar border
		SharedMedia:Register("background", "Details Ground",[[Interface\AddOns\Details\images\background]])
		SharedMedia:Register("border", "Details BarBorder 1",[[Interface\AddOns\Details\images\border_1]])
		SharedMedia:Register("border", "Details BarBorder 2",[[Interface\AddOns\Details\images\border_2]])
		--misc fonts
		SharedMedia:Register("font", "Oswald",[[Interface\Addons\Details\fonts\Oswald-Regular.otf]])
		SharedMedia:Register("font", "Nueva Std Cond",[[Interface\Addons\Details\fonts\NuevaStd-Cond.otf]])
		SharedMedia:Register("font", "Accidental Presidency",[[Interface\Addons\Details\fonts\Accidental Presidency.ttf]])
		SharedMedia:Register("font", "TrashHand",[[Interface\Addons\Details\fonts\TrashHand.TTF]])
		SharedMedia:Register("font", "Harry P",[[Interface\Addons\Details\fonts\HARRYP__.TTF]])
		SharedMedia:Register("font", "FORCED SQUARE",[[Interface\Addons\Details\fonts\FORCED SQUARE.ttf]])
	
	--> global 'vardump' for dump table contents over chat panel
		function vardump(t)
			if (type(t) ~= "table") then
				return
			end
			for a,b in pairs(t) do 
				print(a,b)
			end
		end
		
	--> global 'table_deepcopy' copies a full table	
		function table_deepcopy(orig)
			local orig_type = type(orig)
			local copy
			if orig_type == 'table' then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					copy[table_deepcopy(orig_key)] = table_deepcopy(orig_value)
				end
			else
				copy = orig
			end
			return copy
		end
	
	--> delay messages
		function _details:DelayMsg(msg)
			_details.delaymsgs = _details.delaymsgs or {}
			_details.delaymsgs[#_details.delaymsgs+1] = msg
		end
		function _details:ShowDelayMsg()
			if (_details.delaymsgs and #_details.delaymsgs > 0) then
				for _, msg in ipairs(_details.delaymsgs) do 
					print(msg)
				end
			end
			_details.delaymsgs = {}
		end
	
	--> print messages
		function _details:Msg(_string, arg1, arg2, arg3, arg4)
			if (self.__name) then
				--> yes, we have a name!
				print("|cffffaeae" .. self.__name .. "|r |cffcc7c7c(plugin)|r: " .. _string, arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			else
				print(Loc["STRING_DETAILS1"] .. _string, arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			end
		end
		
	--> welcome
		function _details:WelcomeMsgLogon()
			_details:Msg("|cffb0b0b0you can always reset the addon running the command '/details reinstall' if it does fail to load after being updated.|r")
		end
		_details:ScheduleTimer("WelcomeMsgLogon", 8)
	
	--> key binds
		--> header
			_G["BINDING_HEADER_Details"] = "Details!"
		--> keys
			_G["BINDING_NAME_DETAILS_RESET_SEGMENTS"] = "Reset Segments"
			_G["BINDING_NAME_DETAILS_SCROLL_UP"] = "Scroll Up All Windows"
			_G["BINDING_NAME_DETAILS_SCROLL_DOWN"] = "Scroll Down All Windows"
	
end
