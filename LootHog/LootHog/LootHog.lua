asLH_temp, loothog_line_height,LH_temp = GameTooltipTextSmall:GetFont()
loothog_top_height = 72
loothog_button_height = 80
loothog_default_lines = 10

loothog_countdownStarted = false
loothog_numberOfSecondsToCountDown = 5
loothog_countdownStartTime = 0
loothog_countdownannounce = true
display_time = 0

loothog_titanPanelActive = false --on load check if Titan Panel is present


function loothog_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("CHAT_MSG_SYSTEM")
	this:RegisterEvent("CHAT_MSG_SAY")
	this:RegisterEvent("CHAT_MSG_PARTY")
	this:RegisterEvent("CHAT_MSG_RAID")
	this:RegisterEvent("CHAT_MSG_RAID_LEADER")

--leave raid bug fix array
	loothog_classes = {}
		
-- Default settings:
	loothog_settings = {}
	
	loothog_timer = 0
	loothog_timeout_held = 0
	loothog_duplicate = false
	
-- Register a slash command:
	SlashCmdList["LOOTHOG"] = loothog_slash;
	SLASH_LOOTHOG1 = "/loothog";
	SLASH_LOOTHOG2 = "/lh";
	
	if (TitanPlugins) then
		loothog_titanPanelActive = true
	else
		loothog_titanPanelActive = false
	end
	
-- Hook the function to add messages to Chat Frame 1:
	loothog_o_AddMessage = ChatFrame1.AddMessage
	ChatFrame1.AddMessage = loothog_AddMessage
	
end

function loothog_slash(args)
	local cmd, val = loothog_GetCommand(args);

	if cmd and GetItemInfo(cmd) then
		return loothog_start(cmd)
	end
	if cmd and (cmd == "options" or cmd == "config") then
	  	return loothog_toggle_options()
	end
	if cmd and cmd == "toggle" then
		if loothog_settings["enable"] then
			loothog_settings["enable"] = false
		else
			loothog_settings["enable"] = true
		end
		loothog_togglemodelabel()
		loothog_showmode()
		loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
	end
	if cmd and cmd == "manual" then
		if loothog_settings["manual"] then
			loothog_settings["manual"] = false
		else
			if loothog_settings["enable"] == false then
				loothog_settings["enable"] = true
			end
			loothog_settings["manual"] = true
		end
		loothog_togglemodelabel()
		loothog_showmode()
		loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
		return
	end
	if cmd and cmd == "roll" then
		return loothog_rollclicked()
	end
	if cmd and cmd == "countdown" then
		return loothog_countdown_clicked()
	end
	if cmd and cmd == "mode" then
		loothog_togglemode()
		loothog_showmode()
		return 
	end
	if cmd and cmd == "hold" then
		return loothog_holdclicked()
	end
	if cmd and cmd == "kick" then
		return loothog_kickRoll()
	end
	if cmd and cmd == "announce" then
		return loothog_announce_winner()
	end
	if cmd and cmd == "announce" and loothog_will_assign == true then
		return loothog_assignloot()
	end
	if cmd and cmd == "clear" then
		return loothog_clear()
	end
	if cmd and cmd == "notrolled" then
		return loothog_AnnounceYetToRoll()
	end
	if cmd and cmd == "list" then
		return loothog_listtochat()
	end
	if cmd and cmd == "start" then
		local numLootItems
		local lootitem
		numLootItems = GetNumLootItems();
		if numLootItems > 0 then
			lootitem = GetLootSlotLink(numLootItems)
		end
		if val == "" and lootitem then
			val = lootitem
		end
		return loothog_start(val)
	end
	if cmd and cmd == "activate" then
		local numLootItems
		local lootitem
		numLootItems = GetNumLootItems();
		if numLootItems > 0 then
			lootitem = GetLootSlotLink(numLootItems)
		end
		if val == "" and lootitem then
			val = lootitem
		end
		return loothog_start(val)
	end
	if cmd and cmd == "offspec" then
		return loothog_offrollclicked()
	end
	if cmd and cmd == "rules" then
		return loothog_rules()
	end
	if cmd and cmd == "help" then
		return loothog_help()
	end
	if cmd and cmd == "reset" then
		return loothog_resettodefaults()
	end
	if cmd and cmd == "manual" then
		return loothog_setmanual()
	end
	if cmd and cmd == "debug" then
		if (loothog_debug) then
			loothog_debug = false
		else
			loothog_debug = true	
		end
		return
	end
	loothog_toggle_visible()
end
function loothog_toggleenabled()
		if loothog_settings["enable"] then
			loothog_settings["enable"] = false
		else
			loothog_settings["enable"] = true
		end
		loothog_togglemodelabel()
		loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
end

function loothog_GetCommand (args)
 	if args then
		local a, b, c = string.find(args, "(%S+)");
		if a then
			return c, string.sub(args, b + 2);
		else	
			return "";
		end
	end
end

function loothog_OnEvent()
	if (event == "VARIABLES_LOADED") then
		loothog_initialize()
	end
	
	if (event == "CHAT_MSG_SYSTEM") then
		loothog_sys_msg_received()
	end
	if (event == "CHAT_MSG_" .. loothog_get_auto_channel() or event == "CHAT_MSG_RAID_LEADER") then
		loothog_chat_msg_received()
	end
end

function loothog_SetDefaultSettings(name, value)
   if (loothog_settings[name] == nil) then
     loothog_settings[name] = value
   end
end

function loothog_initialize()
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(LOOTHOG_MSG_LOAD, loothog_version))
	end
-- initialize default settings	
	loothog_SetDefaultSettings("enable", true)
	loothog_SetDefaultSettings("showalllootbutton", false)
	loothog_SetDefaultSettings("masterlooteronly", false)
	loothog_SetDefaultSettings("autoassign", false)
	loothog_SetDefaultSettings("overriderefresh", false)
	loothog_SetDefaultSettings("custom_refresh_interval", 10)
	loothog_SetDefaultSettings("manual", false)
	loothog_SetDefaultSettings("auto_show", true)
	loothog_SetDefaultSettings("triggered_clear", false)
	loothog_SetDefaultSettings("group_only", false)
	loothog_SetDefaultSettings("listtochat", false)
	loothog_SetDefaultSettings("listtochatno", 5)
	loothog_SetDefaultSettings("suppress_chat", false)
	loothog_SetDefaultSettings("close_on_announce", false)
	loothog_SetDefaultSettings("clear_on_close", false)
	loothog_SetDefaultSettings("finalize", false)
	loothog_SetDefaultSettings("finalizerolls", false)
	loothog_SetDefaultSettings("ack_rolls", false)
	loothog_SetDefaultSettings("reject_bound", false)
	loothog_SetDefaultSettings("LowerLimit", 1)
	loothog_SetDefaultSettings("UpperLimit", 100)
	loothog_SetDefaultSettings("OffspecLowerLimit", 101)
	loothog_SetDefaultSettings("OffspecUpperLimit", 200)
	loothog_SetDefaultSettings("Allow_offspec", false)
	loothog_SetDefaultSettings("reject_announce", false)
	loothog_SetDefaultSettings("reject_notifyme", false)	
	loothog_SetDefaultSettings("timeout", 60)
	loothog_SetDefaultSettings("timeout_enabled", false)
	loothog_SetDefaultSettings("autooffspec", false)
	loothog_SetDefaultSettings("offspectimer", 30)
	loothog_SetDefaultSettings("offspectimerenabled", false)
	loothog_SetDefaultSettings("announceoffspec", false)
	loothog_SetDefaultSettings("new_roll_text", LOOTHOG_OPTION_NEW_ROLL_TEXT)
	loothog_SetDefaultSettings("announce_new", false)
	loothog_SetDefaultSettings("offspec_roll_text", LOOTHOG_OPTION_OFFSPEC_ROLL_TEXT)
	loothog_SetDefaultSettings("timeout_announce", false)
	loothog_SetDefaultSettings("autocountdown", false)
	loothog_SetDefaultSettings("autoextend", false)
	loothog_SetDefaultSettings("announceextend", false)
	loothog_SetDefaultSettings("autocounttime", 5)
	loothog_SetDefaultSettings("autoextendtime", 5)
	loothog_SetDefaultSettings("autoresettime", 10)
	loothog_SetDefaultSettings("lowerrollboundary", 1)
	loothog_SetDefaultSettings("upperrollboundary", 100)
	loothog_SetDefaultSettings("reject_class", false)
	loothog_SetDefaultSettings("announce_class", false)
	loothog_SetDefaultSettings("announce_classTK", false)
	loothog_SetDefaultSettings("announce_rulesintro", false)
	loothog_SetDefaultSettings("Rules_Intro", LOOTHOG_RULES_INTRO)
	loothog_SetDefaultSettings("OneEpic", false)
	loothog_SetDefaultSettings("OneSet", false)
	loothog_SetDefaultSettings("disenchanter", UnitName("player"))
	loothog_SetDefaultSettings("reset_eligible", false)
	
	
-- Initialize session variables:
	loothog_last_roll = 0	-- The time of the most recent roll
	loothog_active = false
	loothog_hold = false
	loothog_peopleToRoll = {} --list of people in group/raid who have to roll

	--
	-- Squid:	This is the list of rolls that gets updated as each person rolls.
	--				I added constants for each of the columns in the two-dimensional array
	--				to make the code a little easier to understand.
	--
	loothog_rolls = {}
	LHR_PLAYER = 1
	LHR_ROLL = 2
	LHR_MIN_ROLL = 3
	LHR_MAX_ROLL = 4
		
-->Titan
	loothog_titanrolls = ""
	loothog_titannonrolls = ""
	loothog_titanwinner = ""
	loothog_titan_active = false
	loothog_titanstatus = "|cff0000ff"  .. LOOTHOG_LABEL_READY .. FONT_COLOR_CODE_CLOSE
--<Titan
	
	loothog_interval = 10	-- Execute OnUpdate every x frames
	loothog_refreshoverride()
	loothog_current_interval = 0
	loothog_player_count = 0
	loothog_players = {}
	local height = loothog_line_height * loothog_default_lines + loothog_top_height + loothog_button_height
	loothog_main:SetHeight(height)

--Setting the width/height for the main and configuration window dependent on the needed height for each localization
	loothog_main:SetWidth(LOOTHOG_UI_MAIN_WIDTH)
	loothog_language = GetDefaultLanguage("player")

-- Use Different Variable names for certain settings.
	loothog_timeout = loothog_settings["timeout"]	
	loothog_autocounttime = loothog_settings["autocounttime"]
	loothog_autoextendtime = loothog_settings["autoextendtime"]
	loothog_autoresettime = loothog_settings["autoresettime"]

-- Set Default Values if settings set to zero.
	if loothog_timeout == 0 then
		loothog_timeout = 60
	end
	if loothog_settings["autocounttime"] == 0 then
		loothog_settings["autocounttime"] = 5
	end
	if loothog_autoextendtime == 0 then
		loothog_autoextendtime = 5
	end

	if loothog_autoresettime == 0 then
		loothog_autoresettime = 10
	end
	if loothog_settings["LowerLimit"] == 0 then
		loothog_settings["LowerLimit"] = 1
	end
	if loothog_settings["UpperLimit"] == 0 then
		loothog_settings["UpperLimit"] = 100
	end
	
	if loothog_settings["OffspecLowerLimit"] == 0 then
		loothog_settings["OffspecLowerLimit"] = 1
	end
	if loothog_settings["OffspecUpperLimit"] == 0 then
		loothog_settings["OffspecUpperLimit"] = 50
	end

-- Set the checkboxes:
	loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
	loothog_addonconfManual:SetChecked(loothog_settings["manual"])
	loothog_addonconfQuiet:SetChecked(loothog_settings["quiet"])
	loothog_addonconfAutoShow:SetChecked(loothog_settings["auto_show"])
	loothog_addonconfClear:SetChecked(loothog_settings["triggered_clear"])
	loothog_addonconfGroupOnly:SetChecked(loothog_settings["group_only"])
	loothog_addonconfSuppress:SetChecked(loothog_settings["suppress_chat"])
	loothog_addonconfAckRolls:SetChecked(loothog_settings["ack_rolls"])
	loothog_addonconfShowAllLootButton:SetChecked(loothog_settings["showalllootbutton"])
	loothog_addonconfMasterLooterOnly:SetChecked(loothog_settings["masterlooteronly"])
	loothog_addonconfOverRideRefresh:SetChecked(loothog_settings["overriderefresh"])
	loothog_addonconfRefreshInterval:SetNumber(loothog_settings["custom_refresh_interval"])

	loothog_addonactiveRejectBound:SetChecked(loothog_settings["reject_bound"])
	loothog_addonactiveLower:SetNumber(loothog_settings["LowerLimit"])
	loothog_addonactiveUpper:SetNumber(loothog_settings["UpperLimit"])
	loothog_addonactiveAllowOffspec:SetChecked(loothog_settings["Allow_offspec"])
	loothog_addonactiveOffspecLower:SetNumber(loothog_settings["OffspecLowerLimit"])
	loothog_addonactiveOffspecUpper:SetNumber(loothog_settings["OffspecUpperLimit"])

	loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])
	loothog_addonactiveAnnounceOffspec:SetChecked(loothog_settings["announceoffspec"])
	loothog_addonactiveAnnounceOffspecTxt:SetText(loothog_settings["offspec_roll_text"])
	loothog_addonactiveOffspecTimeoutEnabled:SetChecked(loothog_settings["offspectimerenabled"])
	loothog_addonactiveOffspecTimeout:SetNumber(loothog_settings["offspectimer"])

	loothog_addonactiveRejectClass:SetChecked(loothog_settings["reject_class"])
	loothog_addonactiveRejectAnnounce:SetChecked(loothog_settings["reject_announce"])
	loothog_addonactiveRejectNotifyMe:SetChecked(loothog_settings["reject_notifyme"])

	loothog_addonactiveAnnounceNew:SetChecked(loothog_settings["announce_new"])
	loothog_addonactiveAnnouncement:SetText(loothog_settings["new_roll_text"])
	loothog_addonactiveAnnounceClass:SetChecked(loothog_settings["announce_class"])
	loothog_addonactiveAnnounceClassTK:SetChecked(loothog_settings["announce_classTK"])
	loothog_addonactiveTimeoutEnabled:SetChecked(loothog_settings["timeout_enabled"])
	loothog_addonactiveTimeout:SetNumber(loothog_settings["timeout"])
	loothog_addonactiveAnnounceTimeout:SetChecked(loothog_settings["timeout_announce"])
	loothog_addonactiveAutoCountdown:SetChecked(loothog_settings["autocountdown"])
	loothog_addonactiveAutoCountTime:SetNumber(loothog_settings["autocounttime"])
	loothog_addonactiveAutoExtend:SetChecked(loothog_settings["autoextend"])
	loothog_addonactiveExtendTime:SetNumber(loothog_settings["autoextendtime"])
	loothog_addonactiveAutoResetTime:SetNumber(loothog_settings["autoresettime"])
	loothog_addonactiveAnnounceExtend:SetChecked(loothog_settings["announceextend"])
	loothog_addonactiveFinalize:SetChecked(loothog_settings["finalize"])
	loothog_addonactiveAutoAssignLoot:SetChecked(loothog_settings["autoassign"])
	loothog_addonactiveFinalizeRolls:SetChecked(loothog_settings["finalizerolls"])
	loothog_addonactiveListToChatNo:SetNumber(loothog_settings["listtochatno"])
	loothog_addonactiveCloseOnAnnounce:SetChecked(loothog_settings["close_on_announce"])
	loothog_addonactiveClearOnClose:SetChecked(loothog_settings["clear_on_close"])

	loothog_rulessettingsIntroTxt:SetChecked(loothog_settings["announce_rulesintro"])
	loothog_rulessettingsIntro:SetText(loothog_settings["Rules_Intro"])
	loothog_rulessettingsOneEpic:SetChecked(loothog_settings["OneEpic"])
	loothog_rulessettingsOneSet:SetChecked(loothog_settings["OneSet"])
	loothog_rulessettingsResetLoot:SetChecked(loothog_settings["reset_eligible"])
	loothog_rulessettingsDisenchanterName:SetText(loothog_settings["disenchanter"])

-- Update Options texts
	loothog_dynamicoptions()

-- Update the count text:
	loothog_update_counts()
-- Hide the roll window:
	loothog_main:Hide()
	loothog_rulessettings:Hide()
	
--Initialize tables for gear check
	loothog_DEATHKNIGHT_token={"34855","34858","34852","40627","29753","31090","40612","30237","40633","40630","29758","31093","40615","30240","29761","31096","40618","30243","29767","31099","40621","30246","40636","40639","29764","31102","30249","40624","45637","45658","52025","52028"}
	loothog_DRUID_token={"34855","34858","34852","40627","29753","31090","40612","30237","40633","40630","29758","31093","40615","30240","29761","31096","40618","30243","29767","31099","40621","30246","40636","40639","29764","31102","30249","40624","45637","45658","52025","52028"}
	loothog_HUNTER_token={"34854","34857","34851","40626","29755","31091","40611","30238","40632","40629","29756","31094","40614","30241","29759","31095","40617","30244","29765","31100","40620","30247","40635","40638","29762","31103","30250","40623","45636","45657","52026","52029"}
	loothog_MAGE_token={"34855","34858","34852","40627","29755","31090","40612","30238","40633","40630","29756","31093","40615","30241","29759","31096","40618","30244","29765","31099","40621","30247","40636","40639","29762","31102","30250","40624","45637","45658","52025","52028"}
	loothog_PALADIN_token={"34853","34856","34848","40625","29754","31089","40610","30236","40631","40628","29757","31092","40613","30239","29760","31097","40616","30242","29766","31098","40619","30245","40634","40637","29763","31101","30248","40622","45635","45656","52027","52030"}
	loothog_PRIEST_token={"34853","34856","34848","40625","29753","31089","40610","30237","40631","40628","29758","31092","40613","30240","29761","31097","40616","30243","29767","31098","40619","30246","40634","40637","29764","31101","30249","40622","45635","45656","52027","52030"}
	loothog_ROGUE_token={"34855","34858","34852","40627","29754","31090","40612","30236","40633","40630","29757","31093","40615","30239","29760","31096","40618","30242","29766","31099","40621","30245","40636","40639","29763","31102","30248","40624","45637","45658","52025","52028"}
	loothog_SHAMAN_token={"34854","34857","34851","40626","29754","31091","40611","30236","40632","40629","29757","31094","40614","30239","29760","31095","40617","30242","29766","31100","40620","30245","40635","40638","29763","31103","30248","40623","45636","45657","52026","52029"}
	loothog_WARLOCK_token={"34853","34856","34848","40625","29755","31089","40610","30238","40631","40628","29756","31092","40613","30241","29759","31097","40616","30244","29765","31098","40619","30247","40634","40637","29762","31101","30250","40622","45635","45656","52027","52030"}
	loothog_WARRIOR_token={"34854","34857","34851","40626","29753","31091","40611","30237","40632","40629","29758","31094","40614","30240","29761","31095","40617","30243","29767","31100","40620","30246","40635","40638","29764","31103","30249","40623","45636","45657","52026","52029"}

--Set "Mode" label
	loothog_togglemodelabel()
	loothog_toggleoffspec()
	loothog_alllootbutton()

--Allow All classes to roll
	loothog_initClassesTrue()

--Get Current Settings
	loothog_updatecurrentsettings()

--Add option in Interface/addons
	if not loothog_BlizzardOptions then
		loothog_addonhelp.name="LootHog"
		InterfaceOptions_AddCategory(loothog_addonhelp)
		loothog_addonconf.name=LOOTHOG_ADDON_LABEL_OPTIONS
		loothog_addonconf.parent="LootHog"
		InterfaceOptions_AddCategory(loothog_addonconf)
		loothog_addonactive.name=LOOTHOG_ADDON_LABEL_HANDLE
		loothog_addonactive.parent="LootHog"
		InterfaceOptions_AddCategory(loothog_addonactive)
		loothog_rulessettings.name=LOOTHOG_ADDON_LABEL_RULES
		loothog_rulessettings.parent="LootHog"
		InterfaceOptions_AddCategory(loothog_rulessettings)
		loothog_addonabout.name=LOOTHOG_ADDON_LABEL_ABOUT
		loothog_addonabout.parent="LootHog"
		InterfaceOptions_AddCategory(loothog_addonabout)
		loothog_BlizzardOptions = true
	end

loothog_offspecrolled = false
loothog_offspecrolling = false

end

function loothog_sys_msg_received()
	local msg = arg1
	local itemString = ""

	local pattern = LOOTHOG_ROLL_PATTERN

	-- Check to see if it's a /random roll:
	local player, roll, min_roll, max_roll, report, startIndex, endIndex
	if (loothog_settings["enable"]) then
		if (string.find(msg, pattern)) then
			_, _, player, roll, min_roll, max_roll = string.find(msg, pattern)
			
			--
			-- Check if player who rolled is in your group or configured to count all rolls
			--
			if (((loothog_isInGroup(player)) and (loothog_settings["group_only"])) or (not loothog_settings["group_only"])) then
				if ((loothog_active) and (loothog_settings["manual"])) or (not loothog_settings["manual"]) then
					loothog_ProcessRoll(player, roll, min_roll, max_roll)
				end
			end
		end
	end
end

--
-- This function is called when a message is received in the chat window.
--
function loothog_chat_msg_received()
	local msg = arg1
	local player = arg2
	if (loothog_settings["enable"]) then
		if ((loothog_active) and (loothog_settings["manual"])) or (not loothog_settings["manual"]) then
			if (strlower(msg) == LOOTHOG_PASS_PATTERN) then
				if loothog_settings["Allow_offspec"] then
					--
					-- Squid:  Process offspec rolls correctly.
					--
					loothog_ProcessRoll(player, "0", loothog_settings["OffspecLowerLimit"], loothog_settings["OffspecUpperLimit"])
				else
					loothog_ProcessRoll(player, "0", loothog_settings["LowerLimit"], loothog_settings["UpperLimit"])
				end
			elseif ((string.find(msg, LOOTHOG_RESETONWATCH_PATTERN) or string.find(msg, LOOTHOG_RESETONWATCH_PATTERN2)) and loothog_settings["triggered_clear"]) then
				loothog_make_inactive()
			end
		end
	end
end

function loothog_AddMessage(self, msg, ...)
-- Pass along to the default handler unless it's a /random roll:
	local pattern = LOOTHOG_ROLL_PATTERN
	if (msg==nil) or (not loothog_settings["suppress_chat"]) or (not string.find(msg, pattern)) then
		loothog_o_AddMessage(self, msg, ...)
	end
end

function loothog_postInformation()
	local infoMsg = string.format(LOOTHOG_MSG_INFO, LOOTHOG_PASS_PATTERN)
	loothog_chat(infoMsg)
end

function loothog_setmanual()
	if loothog_settings["manual"]==true then
		loothog_settings["manual"] = false
	else
		loothog_settings["manual"] = true
	end
end

function loothog_setquiet()
	if loothog_settings["manual"] then
		loothog_settings["quiet"] = false
		loothog_addonconfQuiet:SetChecked(loothog_settings["quiet"])
	end
end

function loothog_setauto()
	if loothog_settings["quiet"] then
		loothog_settings["manual"] = false
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
	end
end

-- Did this for future function calls to elminate reduntant code (e.g. processSystemLootRoll(...))
function growWindow()
-- Grow the window if needed:
	local count = #loothog_rolls
	local count2 = #loothog_peopleToRoll
	count = count + count2
	
	if (count > loothog_default_lines) then
		local height = loothog_line_height * count + loothog_top_height + loothog_button_height
		loothog_main:SetHeight(height)
	end
end

-- Checks if the unit is in the current group of the player, return always true for the local player!
function loothog_isInGroup(playerName)
-- Check if the rolling player is in your group
	local isInParty = false
-- Check if in party or raid group
	if (GetNumRaidMembers() > 0) then
		local raidMemberString = "raid"
		for i = 1, GetNumRaidMembers(), 1 do
			raidMemberString = "raid" --reset string		
			raidMemberString = raidMemberString .. i --add the suffix of corresponding player
			if (UnitName(raidMemberString) == playerName) then
				isInParty = true	
			end
		end

	elseif (GetNumPartyMembers() > 0) then
		local partyMemberString = "party"
		for i = 1, GetNumPartyMembers(), 1 do
			partyMemberString = "party" --reset string		
			partyMemberString = partyMemberString .. i --add the suffix of corresponding player
			if (UnitName(partyMemberString) == playerName) then
				isInParty = true	
			end
		end
	end
	
	if (UnitName("player") == playerName) then
		isInParty = true
	end

	return isInParty
end

--
-- Squid:	Returns true if a roll is an offspec roll by checking the minimum
--				roll against the offspec minimum and the maximum roll against the
--				offspec maximum.
--
function loothog_isOffspecRoll (minRoll, maxRoll)
	local	isOffspecRoll = false
	
	if (minRoll == loothog_settings["OffspecLowerLimit"] and maxRoll == loothog_settings["OffspecUpperLimit"]) then
		isOffspecRoll = true
	end
	
	return isOffspecRoll
end

--
-- Returns if true if the roll is valid (meets bound requirements)
--
function loothog_validRoll(roll, lowerBoundary, upperBoundary)
	local validRoll = false
	offspecroll = false
	if ((lowerBoundary == loothog_settings["LowerLimit"])  and (upperBoundary == loothog_settings["UpperLimit"])) then
		--
		-- Prevent possible future cheating (totally "sinnfrei" ;-)
		--
		if (((roll <= loothog_settings["UpperLimit"]) and (roll >= loothog_settings["LowerLimit"])) or roll == 0) then
			validRoll = true
		end
	--
	-- Squid:  Modified the boundary checks for offspec rules.
	--
	elseif ((lowerBoundary == loothog_settings["OffspecLowerLimit"]) and (upperBoundary == loothog_settings["OffspecUpperLimit"]) and (loothog_settings["Allow_offspec"])) then
		if (((roll <= upperBoundary) and (roll >= lowerBoundary)) or roll == 0) then
			validRoll = true
			offspecroll = true
		end
	else
		validRoll = false
	end
	return validRoll
end

--
-- Checks if the roll tied, and returns the number of winners. Returns 1 if there was NO tie.
-- Squid:	This function needs to be changed to incorporate ties when one person rolled mainspec
--				and one rolled offspec.
--
function loothog_rollTied()
	local rollTied = false;
	local num_winners = 0;
	if (#loothog_rolls ~= 0) then
		--
		-- Determine if there was a tie:
		--
		local winners = {}
		local best = loothog_rolls[1][LHR_ROLL]
		winners[1] = loothog_rolls[1][LHR_PLAYER]
		local i = 2
		local rolls = #loothog_rolls
		while (i <= rolls) and (loothog_rolls[i][LHR_ROLL] == best) do
			table.insert(winners, loothog_rolls[i][LHR_PLAYER])
			i = i + 1
		end
		num_winners = #winners
		if (num_winners > 1) then
			rollTied = true
		end
	end

	return num_winners
end


--
-- This function processes an incoming roll from a player.  This is "more or less" where all
-- the magic happens in the way that rolls are prioritized based on the configuration of the
-- addon.
--
function loothog_ProcessRoll(player, roll, min_roll, max_roll)
	roll = tonumber(roll)
	min_roll = tonumber(min_roll)
	max_roll = tonumber(max_roll)

	--
	-- Reject cheaters.
	--
	if (not loothog_validRoll(roll, min_roll, max_roll) and (loothog_settings["reject_bound"])) then
		local cheat_msg = string.format(LOOTHOG_MSG_CHEAT, player, roll, min_roll, max_roll)
		if (loothog_settings["reject_announce"]) then
		-- Bust the cheater if configured to announce rejects:
			loothog_chat(cheat_msg)
		end
		-- Otherwise just notify the local client:
		if (DEFAULT_CHAT_FRAME) and loothog_settings["reject_notifyme"] then
			DEFAULT_CHAT_FRAME:AddMessage(cheat_msg)
		end
		return
	end
	
	--
	-- Reject ineligible classes
	--
	if (loothog_settings["reject_class"]) and loothog_okayClasses then
		local cheat_msg = string.format(LOOTHOG_MSG_CHEATCLASS, player, roll)
		local loothog_playerClass, loothog_thisClass = UnitClass(loothog_getUnitIdentifier(player));
		for i = 1, #loothog_okayClasses, 1 do
			tempClass = loothog_okayClasses[i];
			if (tempClass == loothog_thisClass) then
				loothog_validClass = true
			end
		end
		if (not loothog_validClass) then
			if loothog_debug then
				loothog_chat(player .."'s Class: " .. loothog_thisClass)
			end
			if (loothog_settings["reject_announce"]) then
			-- Bust the cheater if configured to announce rejects:
				loothog_chat(cheat_msg)
			end
			-- Otherwise just notify the local client:
			if (DEFAULT_CHAT_FRAME) and loothog_settings["reject_notifyme"] then
				DEFAULT_CHAT_FRAME:AddMessage(cheat_msg)
			end
		return
		end
	end
	
	--
	-- We've determined it's a valid roll.  Acknowledge if configured to do so 
	-- and do it only if this is the first roll of the player:
	--
	if (loothog_settings["ack_rolls"] and (not loothog_players[player]) and (UnitName("player") ~= player)) then
		--
		-- Send pass message to player if he did pass on this roll or send the acknowledement
		-- message if they did not.
		--
		local ack = ""
		
		--
		-- Was this an offspec roll?  If so, send a different message letting
		-- the recipient know that they are rolling for offspec.
		--
		if (max_roll == loothog_settings["OffspecUpperLimit"]) then
			ack = string.format(LOOTHOG_MSG_OFFSPEC_ACK, roll)
		else
			ack = string.format(LOOTHOG_MSG_ACK, roll)
		end
		
		if (roll == 0) then
			ack = LOOTHOG_MSG_ACK_PASS
		end
		SendChatMessage(ack, "WHISPER", loothog_language, player)
	end
	
	--
	-- Squid:  Are we not active (i.e. is this the first roll of a new set)?
	--
	if (not loothog_active) then
		loothog_can_assign = false
		loothog_setannouncebutton()
		loothog_clear_clicked()
		loothog_timerstart()
		loothog_getpartymembers()
		loothog_alllootbutton()

		--
		-- Squid:  Add this roll to table of rolls at the first position in the rolls.
		--
		loothog_rolls[1] = {player, roll, min_roll, max_roll}
	else
		--
		-- Insert the roll into the list at the proper spot.
		--
		if (not loothog_players[player]) then
			local i = 1
			--
			-- Squid:  Are we allowing for offspec rolls?
			--
			if loothog_settings["Allow_offspec"] then
				--
				-- Was this person's roll a mainset roll?
				--
				if max_roll == loothog_settings["UpperLimit"] then
					--
					-- Since the person rolled main set, insert this roll into the first slot where
					-- his roll is greater than the one in the list at the current index or the roll
					-- in the list is an offspec roll.
					--
					while (loothog_rolls[i] ~= nil) and (loothog_rolls[i][LHR_ROLL] >= roll and loothog_rolls[i][LHR_MAX_ROLL] == loothog_settings["UpperLimit"]) do 
						i = i + 1 
					end
				else
					--
					-- This is an offset roll so we need to find the first spot in the list where
					-- the roll is greater than the one in the list AND the roll is NOT a mainset roll.
					--
					-- Start by searching for the first non-empty slot where the person's max roll was
					-- not a mainset roll.  This essentially skips over all of the mainset rolls.
					--
					while (loothog_rolls[i] ~= nil) and (loothog_rolls[i][LHR_MAX_ROLL] == loothog_settings["UpperLimit"]) do 
						i = i+1 
					end
					
					--
					-- Now find the place in the list of offspec rolls to insert the roll at.
					--
					while (loothog_rolls[i] ~= nil) and (loothog_rolls[i][LHR_ROLL] >= roll) do 
						i = i+1 
					end
				end
			else
				while (loothog_rolls[i] ~= nil) and (loothog_rolls[i][LHR_ROLL] >= roll) do i = i+1 end
			end
			table.insert(loothog_rolls, i, {player, roll, min_roll, max_roll})
		end
	end
	
-- Add to the list of players who have rolled:
	if (not loothog_players[player]) then
		loothog_player_count = loothog_player_count + 1
		loothog_players[player] = 1
		loothog_classes[player] = {};
		loothog_classes[player].LocalClass, loothog_classes[player].EnglishClass= UnitClass(loothog_getUnitIdentifier(player));
		loothog_classes[player].UnitLevel = UnitLevel(loothog_getUnitIdentifier(player));
	else
-- Duplicate roll!
		loothog_duplicate = true
		local dupe_msg = string.format(LOOTHOG_MSG_DUPE, player)
		if (DEFAULT_CHAT_FRAME) and loothog_settings["reject_notifyme"] then
			DEFAULT_CHAT_FRAME:AddMessage(dupe_msg)
		end
	end

-- Remove player who rolled from the list
	for i = 1, #loothog_peopleToRoll, 1 do
		if (loothog_peopleToRoll[i] == player) then
			table.remove(loothog_peopleToRoll, i)
		end
	end
	
	loothog_repaint()
	loothog_autoshow()
	loothog_alllootbutton()
end

function loothog_getUnitIdentifier (playerName)
-- Returns the identifier for the supplied player within raid/group (player; party1, party2,... party4; raid1, raid2, ..., raidN), nil if not in group/raid
	local identifierString = ""
		if (GetNumRaidMembers() > 0) then
			local raidMemberString = "raid"
			for i = 1, GetNumRaidMembers(), 1 do
				raidMemberString = "raid" --reset string		
				raidMemberString = raidMemberString .. i --add the suffix of corresponding player
				if (UnitName(raidMemberString) == playerName) then
					identifierString = raidMemberString
				end
			end
		elseif (GetNumPartyMembers() > 0) then
			local partyMemberString = "party"
			for i = 1, GetNumPartyMembers(), 1 do
				partyMemberString = "party" --reset string		
				partyMemberString = partyMemberString .. i --add the suffix of corresponding player
				if (UnitName(partyMemberString) == playerName) then
					identifierString = partyMemberString
				end
			end
		end
		
-- Check if supplied player name is the local player
		if (UnitName("player") == playerName) then	
			identifierString = "player"
		end
		
	return identifierString
end

function loothog_announce_clicked()
	if loothog_will_assign then
		loothog_assignloot()
	else
	    loothog_forceannounce = true
		loothog_announce_winner()
		loothog_setannouncebutton()
	end
end

function loothog_announce_winner()

-- If there are no rolls, don't do anything:
	if (#loothog_rolls == 0) then
		if loothog_iteminfo ~= "" then
			loothog_can_assign = true
			if not loothog_assign then
				loothog_assign_this = loothog_iteminfo
			end
		end
		return
	end

-- Announce Top Rolls if Configured to do so
	if (loothog_settings["listtochat"]) then
		loothog_listtochat()
	end		
	
-- Determine if there was a tie:
	local winners = {}
	local best = loothog_rolls[1][LHR_ROLL]
	winners[1] = loothog_rolls[1][LHR_PLAYER]
	local i = 2
	local rolls = #loothog_rolls
	while (i <= rolls) and (loothog_rolls[i][LHR_ROLL] == best) do
		table.insert(winners, loothog_rolls[i][LHR_PLAYER])
		i = i + 1
	end
	local num_winners = #winners
-- Announce the winner(s) and prepare for the next set of rolls:
	local report
	if (num_winners == 1) then
		--first get group number, if master looter
		groupnum = "";
		if (GetNumRaidMembers() > 0) then
			--check all 40 raid slots for winner
			i=1;
			found = false;
			while ((i <= 40) and (found == false)) do
				name, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i);
					if (name and name == loothog_rolls[1][LHR_PLAYER]) then
						found = true;
						groupnum = " (" .. LOOTHOG_MSG_GROUP .. " " .. subgroup .. ")";
					end
				i=i+1;
			end
			if (not found) then groupnum = " (" .. LOOTHOG_MSG_NOTGROUP .. ")"; end
		end
		if loothog_rolls[1][LHR_MAX_ROLL] == loothog_settings["UpperLimit"] then
			loothog_lootreason = "MS"
		else
			loothog_lootreason = "OS"
		end
		report = string.format(LOOTHOG_MSG_WINNER, loothog_rolls[1][LHR_PLAYER], groupnum, loothog_rolls[1][LHR_ROLL], loothog_rolls[1][LHR_MIN_ROLL], loothog_rolls[1][LHR_MAX_ROLL],loothog_iteminfo)
		if loothog_iteminfo ~= "" then
			loothog_can_assign = true
			if not loothog_assign then
				loothog_assign_this = loothog_iteminfo
			end
		end
	else
		report = ""
		for i, v in ipairs(winners) do
			if (i > 1 and num_winners > 2) then report = report..", " end
			if (i == num_winners) then report = report..LOOTHOG_MSG_AND end
			report = report..v
		end
		report = report..string.format(LOOTHOG_MSG_TIED, best)
		loothog_can_assign = false
	end
	loothog_last_roll = 0
	display_time = 0
	loothog_make_inactive()
	loothog_chat(report)
	if loothog_settings["close_on_announce"] then
		loothog_clearonclose()
	end
end

function loothog_clear_clicked()
	loothog_make_inactive()
	loothog_clear()
-- If so configured, announce the new roll:
	loothog_announcestart()
end

function loothog_clear()
-->Titan
	loothog_titanrolls = ""
	loothog_titannonrolls = ""
	loothog_titanwinner = ""
--<Titan
	loothog_make_inactive()
	loothog_rolls = {}
	loothog_peopleToRoll = {}
	loothog_classes = {}
	loothog_players = {}
	loothog_player_count = 0
	loothog_mainText1:SetText("")
	loothog_mainText2:SetText("")
	lootitem = ""
	local height = loothog_line_height * loothog_default_lines + loothog_top_height + loothog_button_height
	loothog_main:SetHeight(height)
end

function loothog_clearonclose()
	if loothog_settings["clear_on_close"] then
		loothog_clear()
	end
	loothog_main:Hide()
end

function loothog_toggle_visible()
	if loothog_main:IsVisible() then
		loothog_main:Hide()
	else
		loothog_main:Show()
		loothog_setcountdownbutton()
	end
end

function loothog_toggle_options()
	InterfaceOptionsFrame_OpenToCategory(loothog_addonactive)
end

function loothog_help()
	InterfaceOptionsFrame_OpenToCategory(loothog_addonabout)
end

function loothog_toggle(setting, checked)
	loothog_settings[setting] = checked
end

function loothog_onupdate()
	if loothog_current_interval == "" then
		loothog_current_interval = 0
	end
	loothog_current_interval = loothog_current_interval + 1
	if (loothog_current_interval >= loothog_interval) then
		loothog_current_interval = 0
		-- Update the counts:
		loothog_update_counts()
		if(loothog_countdownStarted) then
			loothog_countdown()
		end
		if (loothog_active) then
			-- Update the status text:
			if (loothog_hold) then
				loothog_mainStatusText:SetTextColor(0, 1, 0)
				loothog_mainStatusText:SetText(LOOTHOG_LABEL_HOLDING)
			else
				if loothog_settings["timeout_enabled"] then
					local time_left = math.ceil(loothog_timer + loothog_timeout - GetTime())
					loothog_mainStatusText:SetTextColor(1, 1, 0)
					loothog_mainStatusText:SetText(string.format(LOOTHOG_LABEL_TIMELEFT, time_left))
				else
					loothog_mainStatusText:SetTextColor(0, 1, 0)
					loothog_mainStatusText:SetText(LOOTHOG_LABEL_NOTIMEOUT)
				end

			end
-- See if it's time to go inactive:
			if (not loothog_hold) and (GetTime() - loothog_timer > loothog_timeout) and (loothog_settings["timeout_enabled"]) then
				loothog_alldone()
			end
		end
	end
	local loothog_people_target = table.getn(loothog_peopleToRoll)
	local loothog_current_rolls = table.getn(loothog_rolls)

end

function loothog_update_counts()
-- Set ratio number of players which have rolled/number of players in group
	local partyMemberCount = 1
	if (GetNumRaidMembers() > 0) then
		partyMemberCount = GetNumRaidMembers()
	elseif (GetNumPartyMembers() > 0) then
		partyMemberCount = GetNumPartyMembers() + 1
	end

	local titanPartyMemberCount = partyMemberCount
	
--GetNumRaidMembers()
	loothog_mainCountText:SetText(string.format(LOOTHOG_LABEL_COUNT, #loothog_rolls, partyMemberCount))
	local fontcolor = RED_FONT_COLOR_CODE
	
	if (loothog_player_count < #loothog_rolls) then
		loothog_mainCountText:SetTextColor(1, 0.3, 0.3)
	else
		loothog_mainCountText:SetTextColor(1, 1, 0)
	end
	

-->Titan
	if (loothog_titanPanelActive) then
		local fontcolor = GREEN_FONT_COLOR_CODE
		local rolls = #loothog_rolls
		if (rolls < titanPartyMemberCount)then
			fontcolor = RED_FONT_COLOR_CODE
		end
		if (rolls > 0) then
			local winner = loothog_rolls[1][LHR_PLAYER]
			local best = loothog_rolls[1][LHR_ROLL]
			loothog_titanwinner = GREEN_FONT_COLOR_CODE .. winner .." ("..best.. ")" .. FONT_COLOR_CODE_CLOSE .. fontcolor .. " [" .. #loothog_rolls .. "/" .. titanPartyMemberCount .. "]" .. FONT_COLOR_CODE_CLOSE 
		else
			loothog_titanwinner = ""
		end
	end
--<Titan
		if (loothog_active) and (partyMemberCount == #loothog_rolls) and (loothog_settings["finalizerolls"]) then
			loothog_timeout = 0
		end
end

function loothog_make_inactive()
	loothog_mainText1:SetTextColor(0.7, 0.7, 0.7)
	loothog_mainText2:SetTextColor(0.7, 0.7, 0.7)
	loothog_mainStatusText:SetTextColor(0.5, 0.5, 1.0)
	loothog_mainStatusText:SetText(LOOTHOG_LABEL_READY)
	loothog_timeout = loothog_settings["timeout"]
	loothog_numberOfSecondsToCountDown = 0
	loothog_active = false
	loothog_duplicate = false
	loothog_countdownclicked = false
	loothog_countingdown = false
	loothog_countdownannounce = true
	loothog_manual = false
	loothog_iteminfo = ""
	loothog_itemtype = ""
	loothog_itemstype = ""
	loothog_armorlevel = 0
	loothog_okayClasses = false
	loothog_validClass = false
	loothog_tokenclasses = false
	loothog_initClassesTrue()
	loothog_alllootbutton()
	loothog_setcountdownbutton()
	if loothog_offspecrolled then
		loothog_offspecrolling = false
		loothog_offspecrolled = false
	end

--> Titan
	loothog_titan_active = false
	loothog_titanstatus = "|cff0000ff" .. LOOTHOG_LABEL_READY .. FONT_COLOR_CODE_CLOSE 
--< Titan
end

function loothog_holdclicked()
	if (loothog_hold) then
		loothog_hold = false
		loothog_mainHoldButton:SetText(LOOTHOG_BUTTON_HOLD)
		loothog_timeout = loothog_timeout_held
		loothog_timer = GetTime()
		if (loothog_settings["announceextend"]) or loothog_manual then
			HoldInfo =string.format(LOOTHOG_MSG_HOLDCONT, loothog_timeout)
			loothog_chat(HoldInfo)
		end

		if loothog_countdownrunning then
			loothog_numberOfSecondsToCountDown = loothog_timeout
			loothog_countdown()
		end
	else
		loothog_hold = true
		loothog_mainHoldButton:SetText(LOOTHOG_BUTTON_UNHOLD)
		loothog_timeout_held = math.ceil(loothog_timer + loothog_timeout - GetTime())
		if loothog_timeout_held < loothog_settings["autoextendtime"] + 1 then
			loothog_timeout_held = loothog_settings["autoresettime"]
		end
		if (loothog_countdownStarted) then
			HoldInfo = string.format(LOOTHOG_MSG_HOLDSTART, loothog_timeout_held)
			if (loothog_settings["announceextend"]) or loothog_manual then
				loothog_chat(HoldInfo)
			end
			loothog_countdownrunning = true
			loothog_numberOfSecondsToCountDown = 0
		end

	end
end

function loothog_AnnounceYetToRoll()
    local PeopleNeedingToRoll = "";
   	local unitIdentifier = ""	
-- Print list of players which have yet to roll
	for i = 1, #loothog_peopleToRoll, 1 do
		if(i == 1) then
			PeopleNeedingToRoll = loothog_peopleToRoll[i];
		else
			unitIdentifier = loothog_getUnitIdentifier(loothog_peopleToRoll[i])
			PeopleNeedingToRoll = PeopleNeedingToRoll .. ", " .. loothog_peopleToRoll[i];
		end
	end

	if ( string.find(PeopleNeedingToRoll, '%a') ) then
	   loothog_forceannounce = true
	   loothog_chat(string.format(LOOTHOG_MSG_YETTOPASS, LOOTHOG_PASS_PATTERN))
       loothog_forceannounce = true
	   loothog_chat(PeopleNeedingToRoll);
	end
	 
end

function loothog_rollclicked()
	RandomRoll(loothog_settings["LowerLimit"], loothog_settings["UpperLimit"])
end

function loothog_offrollclicked()
	--
	-- Squid:  Modified for offspec rolls.
	--
	RandomRoll(loothog_settings["OffspecLowerLimit"], loothog_settings["OffspecUpperLimit"])
end

function loothog_countdown_clicked()
	local numLootItems
	if (not loothog_active) then
		numLootItems = GetNumLootItems();
		if numLootItems > 0 then
			loothog_iteminfo = GetLootSlotLink(numLootItems)
			loothog_start(loothog_iteminfo)
			return
		else
			val = ""
			loothog_start(val)
			return
		end
	end
	if loothog_settings["timeout_enabled"] then
		loothog_numberOfSecondsToCountDown = loothog_settings["autocounttime"] + 1
		loothog_timeout = loothog_settings["autocounttime"]
		loothog_timer = GetTime()
		loothog_countdownclicked = true
	else
		loothog_numberOfSecondsToCountDown = loothog_settings["autocounttime"]
		loothog_countdownclicked = true
		loothog_manual = true
		loothog_countdown()
	end
	if loothog_countingdown then
		return
	end
	loothog_setcountdownbutton()
end

function loothog_countdown()
	if (not loothog_countdownStarted) then
		loothog_countdownStarted = true
		loothog_countdownStartTime = GetTime()
	elseif (loothog_countdownStarted) then
		local currentTime = 0
		local elapsedTime = 0
		currentTime = GetTime()
		elapsedTime = currentTime - loothog_countdownStartTime
		if(elapsedTime >= 1) then
			loothog_countdownStartTime = GetTime()
			if (loothog_numberOfSecondsToCountDown <= loothog_settings["autocounttime"] + 1) then
				loothog_countingdown = true
				if(loothog_numberOfSecondsToCountDown > 1) and (loothog_countdownannounce) then
					loothog_chat(loothog_numberOfSecondsToCountDown - 1)
				end
			end
			loothog_numberOfSecondsToCountDown = loothog_numberOfSecondsToCountDown - 1
		end
		if (loothog_numberOfSecondsToCountDown == 0) then
			loothog_numberOfSecondsToCountDown = loothog_settings["autocounttime"]
			loothog_countdownStarted = false
			if (not loothog_settings["timeout_enabled"]) then
				loothog_alldone()
			end
		end
	end
end

function loothog_chat(msg,warning)
-- Send a chat message
	if loothog_debug then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	elseif not loothog_settings["quiet"] or loothog_forceannounce == true or loothog_countdownclicked == true then
		local channel = loothog_get_auto_channel(warning)
		SendChatMessage(msg, channel)
		loothog_forceannounce = false
	end
end

function loothog_error(msg)
-- Send a chat message
		DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function loothog_get_auto_channel(warning)
-- Return an appropriate channel in order of preference: /raid, /p, /s
	local channel = "SAY"
	if (GetNumPartyMembers() > 0) then
		channel = "PARTY"
	end
	if (GetNumRaidMembers() > 0) then
		if (warning and IsRaidOfficer()) then
			channel = "RAID_WARNING"
		else
			channel = "RAID"
		end
	end
	return channel
end

--> Titan
function loothog_getwinner()
	return loothog_titanwinner
end

function loothog_getrolls()
	return loothog_titanrolls
end

function loothog_getnonrolls()
	return loothog_titannonrolls
end

function loothog_getstatus()
	if (loothog_titanPanelActive) then
		if (loothog_hold) then
			loothog_titanstatus = RED_FONT_COLOR_CODE  .. LOOTHOG_LABEL_HOLDING .. FONT_COLOR_CODE_CLOSE
		else
			if loothog_settings["timeout_enabled"] then
				local titan_time_left = math.ceil(loothog_last_roll + loothog_timeout - GetTime())
				loothog_titanstatus = GREEN_FONT_COLOR_CODE  .. string.format(LOOTHOG_LABEL_TIMELEFT, titan_time_left) .. FONT_COLOR_CODE_CLOSE
			else
				loothog_titanstatus = GREEN_FONT_COLOR_CODE  .. LOOTHOG_LABEL_NOTIMEOUT .. FONT_COLOR_CODE_CLOSE
			end
		end
-- See if it's time to go inactive:
		if (not loothog_hold) and (GetTime() - loothog_timer > loothog_timeout) and (loothog_settings["timeout_enabled"]) then
			loothog_make_inactive()
		end
	end

	return loothog_titanstatus
end
--<Titan

-- DBM This function should kick out the top roll if the loot leader thinks it was a joke roll, or was otherwise ineligible.  
-- It will broadcast a message explaining the kick, and will make the roller eligible to roll again if they would like.
--
-- This is needed because otherwise there is no way to remove the top roll and use the announce functionality.
-- Functionality to remove any arbitrary roll in the list would be preferred, but is infeasible given the text field structure of the LH main window.
-- 
function loothog_kickRoll()
	local player = ""
	if (#loothog_rolls > 0) then

		player = loothog_rolls[1][LHR_PLAYER]

		loothog_chat(string.format(LOOTHOG_MSG_REMOVEROLL, player, loothog_rolls[1][LHR_ROLL]))
		table.remove(loothog_rolls, 1)
	
-- Delete from rolled list
		loothog_players[player] = false
		loothog_player_count = loothog_player_count - 1
	
-- Add player whose roll was kicked back onto the unrolled list
		table.insert(loothog_peopleToRoll, player)

-- Update screen
		loothog_repaint()
	end
end

-- DBM This function re-paints the main LH window with roll results and people yet to roll, along with the Titan plug-in.
-- I extracted it from it's original location in loothog_processroll it because it is also needed by the new "loothog_kickRoll" function
function loothog_repaint()
-- Update the list onscreen:
	local text1 = ""
	local text2 = ""
-->Titan
	local text3 = ""
	local text4 = ""
--<Titan
	local localClass = ""
	local unitString = ""
	local englishClass = ""
	local unitLevel = "-"
	local unitIdentifier = ""	

-- Get number of winners
	local winners_num = loothog_rollTied()
	
-- Print those who have already rolled
	for i, p in ipairs(loothog_rolls) do
		if(loothog_isInGroup(p[LHR_PLAYER])) then
			localClass, englishClass = loothog_classes[p[1]].LocalClass, loothog_classes[p[LHR_PLAYER]].EnglishClass
			unitLevel = loothog_classes[p[LHR_PLAYER]].UnitLevel
			
			--
			-- Check if supplied player name is the local player.
			--
			local offspecText = ""
			if (p[LHR_MIN_ROLL] == loothog_settings["OffspecLowerLimit"] and p[LHR_MAX_ROLL] == loothog_settings["OffspecUpperLimit"]) then
				offspecText = " OFFSPEC "
			end

			if (UnitName("player") == p[LHR_PLAYER]) then
				text1 = text1 .. "|cffff0000" .. p[LHR_PLAYER] .. "-" .. localClass .."(" .. unitLevel .. ")" .. offspecText .. "|r\n"
				text2 = text2 .. "|cffff0000" .. p[LHR_ROLL] .. "|r\n"
			else
				text1 = text1 .. p[1] .. "-" .. localClass .."(" .. unitLevel .. ")" .. offspecText .. "\n"
				text2 = text2 .. p[2] .. "\n"
			end
			if(loothog_titanPanelActive) then
				-->Titan
				text3 = text3 .. GREEN_FONT_COLOR_CODE .. p[LHR_PLAYER] .. "-" .. localClass .."(" .. unitLevel .. ")" .. offspecText .. FONT_COLOR_CODE_CLOSE  .. "\t" .. GREEN_FONT_COLOR_CODE ..  p[2] .. FONT_COLOR_CODE_CLOSE .. "\n"
				--<Titan
			end
		else
			text1 = text1 .. p[LHR_PLAYER] .. "\n"
			text2 = text2 .. p[LHR_ROLL] .. "\n"
			if(loothog_titanPanelActive) then
				-->Titan
				text3 = text3 .. GREEN_FONT_COLOR_CODE .. p[LHR_PLAYER] .. "\t" .. p[2] .. FONT_COLOR_CODE_CLOSE  .. "\n"
			end
		end
		
-- Printing delimiter to seperate multiple winners for visual clarity
		if((i == winners_num) and (i > 1)) then
			text1 = text1 .. LOOTHOG_LABEL_WINNERSDELIMITER .. "\n"
			text2 = text2 .. "===" .. "\n"
		end
	end
	
-- Printing a delimiter
	if((#loothog_rolls > 0) and (#loothog_peopleToRoll > 0)) then
		text1 = text1 .. LOOTHOG_LABEL_DELIMITER .. "\n"
	end
	
-- Print list of players which have yet to roll
	local unitIdentifier = ""	
	for i = 1, #loothog_peopleToRoll, 1 do
		localClass, englishClass = loothog_classes[loothog_peopleToRoll[i]].LocalClass, loothog_classes[loothog_peopleToRoll[i]].EnglishClass
		unitLevel = loothog_classes[loothog_peopleToRoll[i]].UnitLevel
		
		text1 = text1 .. loothog_peopleToRoll[i] .. "-" .. localClass .."(" .. unitLevel .. ")" .. "\n"
		if(loothog_titanPanelActive) then
-->Titan
			text4 = text4 .. RED_FONT_COLOR_CODE .. loothog_peopleToRoll[i] .. "-" .. localClass .."(" .. unitLevel .. ")" .. FONT_COLOR_CODE_CLOSE  .. "\n"
--<Titan
		end
	end

	loothog_mainText1:SetText(text1)
	loothog_mainText2:SetText(text2)
	loothog_update_counts()
	
-->Titan
	loothog_titanrolls = text3
	loothog_titannonrolls = text4
	loothog_titan_active = true
--<Titan


-- Make the text white to indicate rolling is active:
	loothog_active = true
	loothog_can_assign = false
	loothog_assign = false
	loothog_mainText1:SetTextColor(1, 1, 1)
	loothog_mainText2:SetTextColor(1, 1, 1)
	
-- Grow the window if needed:	
	growWindow()
	loothog_setcountdownbutton()
--	loothog_setannouncebutton()

-- Update the last roll timestamp:
	loothog_last_roll = GetTime()
	if (loothog_settings["autoextend"]) and (loothog_timer + loothog_timeout - GetTime() < loothog_autoextendtime ) and (not loothog_duplicate) then 
		loothog_timer = loothog_last_roll
		loothog_timeout = loothog_autoresettime
		loothog_numberOfSecondsToCountDown = loothog_timeout
		if (not loothog_hold and loothog_settings["announceextend"] and loothog_settings["timeout_enabled"] and loothog_settings["autoextend"]) then
			ResetInfo = string.format(LOOTHOG_MSG_RESET, loothog_timeout)
			loothog_chat(ResetInfo)
		end
	end
end

function loothog_alldone()
	if (#loothog_rolls == 0) then
		loothog_allpassed = true
	else
		local bestroll = loothog_rolls[1][LHR_ROLL]
		if bestroll == 0 then
			loothog_allpassed = true
		else
			loothog_allpassed = false
		end
	end
	if (loothog_allpassed) and loothog_settings["autooffspec"] and not (loothog_offspecrolling)  then
		loothog_offspecrolling = true
		loothog_mainText1:SetTextColor(0.7, 0.7, 0.7)
		loothog_mainText2:SetTextColor(0.7, 0.7, 0.7)
		loothog_mainStatusText:SetTextColor(0.5, 0.5, 1.0)
		loothog_mainStatusText:SetText(LOOTHOG_LABEL_READY)
		loothog_numberOfSecondsToCountDown = 0
		loothog_active = false
		loothog_duplicate = false
		loothog_countdownclicked = false
		loothog_countingdown = false
		loothog_countdownannounce = true
		loothog_manual = false
		loothog_itemtype = ""
		loothog_itemstype = ""
  		loothog_can_assign = false
		loothog_armorlevel = 0
		loothog_okayClasses = false
		loothog_validClass = false
		loothog_tokenclasses = false
		loothog_initClassesTrue()
		return loothog_start(loothog_iteminfo)
	end
	if (loothog_settings["finalize"]) then
		loothog_announce_winner()
	end
	if loothog_allpassed then
		if loothog_settings["autoassign"] then
			loothog_assignloot()
		else
			if loothog_iteminfo ~= "" then
	    		loothog_can_assign = true
	    	end
			loothog_setannouncebutton()
		end
		loothog_make_inactive()
		return
	end
	if loothog_settings["autoassign"] then
		loothog_assignloot()
	else
		if loothog_iteminfo ~= "" then
	    		loothog_can_assign = true
	    	end
		loothog_setannouncebutton()
	end
	loothog_make_inactive()
end

--
-- This function lists the top rolls to the appropriate chat window.
--
function loothog_listtochat()
		loothog_chat(LOOTHOG_LABEL_CHATLISTTOP)
		loothog_chat(LOOTHOG_LABEL_WINNERSDELIMITER)
		local roll_counter_target = table.getn(loothog_rolls)
		if (roll_counter_target > loothog_settings["listtochatno"]) then
			roll_counter_target = loothog_settings["listtochatno"]
		end
		local roll_counter = 1
		local report_roll = ""
		while (roll_counter >= 1 and roll_counter <= roll_counter_target) do
			--
			-- Announce the list entry in such a way as to indicate the roll was
			-- offspec (if necessary).
			--
			if (loothog_rolls[roll_counter][LHR_MAX_ROLL] == loothog_settings["UpperLimit"]) then
				loothog_chat(string.format(LOOTHOG_MSG_ROLLS, roll_counter, loothog_rolls[roll_counter][LHR_PLAYER], loothog_rolls[roll_counter][LHR_ROLL]))
			elseif (loothog_rolls[roll_counter][LHR_MAX_ROLL] == loothog_settings["OffspecUpperLimit"]) then
				loothog_chat(string.format(LOOTHOG_MSG_ROLLS_OFFSPEC, roll_counter, loothog_rolls[roll_counter][LHR_PLAYER], loothog_rolls[roll_counter][LHR_ROLL]))
				
			end
			roll_counter = roll_counter + 1
		end
		loothog_chat(report_roll)
end

function loothog_announcestart()
		loothog_StartText = ""
		if GetItemInfo(loothog_iteminfo) then
			loothog_StartText = " :: " .. loothog_iteminfo .. " :: "
		end
		if (loothog_settings["announce_new"]) then
			if loothog_offspecrolling == true then
				loothog_StartText = loothog_settings["offspec_roll_text"]
				if GetItemInfo(loothog_iteminfo) then
					loothog_StartText = loothog_StartText .. " :: " .. loothog_iteminfo .. " :: "
				end
				if (loothog_settings["timeout_announce"]) and (loothog_settings["timeout_enabled"]) then
					loothog_StartText = loothog_StartText .. "  " .. string.format(LOOTHOG_MSG_TIMEANNOUNCE, loothog_settings["offspectimer"])
				end
			else
				loothog_StartText = loothog_settings["new_roll_text"] .. loothog_StartText
				if (loothog_settings["timeout_announce"]) and (loothog_settings["timeout_enabled"]) then
					loothog_StartText = loothog_StartText .. "  " .. string.format(LOOTHOG_MSG_TIMEANNOUNCE, loothog_timeout)
				end
			end
		end

 		if loothog_StartText then
			if GetItemInfo(loothog_iteminfo) then
				loothog_chat(loothog_StartText,true)
			else
				loothog_chat(loothog_StartText)
			end
		end
end

function loothog_timerstart()
-- Check if timer is set and start timer
		if loothog_settings["timeout_enabled"] then
			if loothog_offspecrolling then
				loothog_timeout = loothog_settings["offspectimer"]
			end
			loothog_numberOfSecondsToCountDown = loothog_timeout - 1
			if loothog_settings["autocountdown"] then
       			loothog_countdown()
 			end
		loothog_timer = GetTime()
		end
end

function loothog_autoshow()
-- Check if set to auto show and show
		if (loothog_settings["auto_show"]) then
			loothog_main:Show()
			loothog_setcountdownbutton()
		end
end

function loothog_getpartymembers()
-- Setting up a list of people who are in the players group/raid and "have" to roll
		if (GetNumRaidMembers() > 0) then
			local raidMemberString = "raid"
			for i = 1, GetNumRaidMembers(), 1 do
				raidMemberString = "raid" --reset string		
				raidMemberString = raidMemberString .. i --add the suffix of corresponding player
				table.insert(loothog_peopleToRoll, (UnitName(raidMemberString)))
				loothog_classes[(UnitName(raidMemberString))] = {};
				loothog_classes[(UnitName(raidMemberString))].LocalClass, loothog_classes[UnitName(raidMemberString)].EnglishClass= UnitClass(raidMemberString);
				loothog_classes[(UnitName(raidMemberString))].UnitLevel = UnitLevel(raidMemberString);
			end
		elseif (GetNumPartyMembers() > 0) then
			local partyMemberString = "party"
			for i = 1, GetNumPartyMembers(), 1 do
				partyMemberString = "party" --reset string		
				partyMemberString = partyMemberString .. i --add the suffix of corresponding player
				table.insert(loothog_peopleToRoll, (UnitName(partyMemberString)))
				loothog_classes[(UnitName(partyMemberString))] = {};
				loothog_classes[(UnitName(partyMemberString))].LocalClass, loothog_classes[UnitName(partyMemberString)].EnglishClass= UnitClass(partyMemberString);
				loothog_classes[(UnitName(partyMemberString))].UnitLevel = UnitLevel(partyMemberString);
			end
		end
end

function loothog_start(loothog_itemid)
	if (not loothog_active) then
		loothog_can_assign = false
		loothog_setannouncebutton()
		loothog_clear()
		if loothog_offspecrolling then
			loothog_offspecrolled = true
		end
		loothog_getiteminfo(loothog_itemid)
		loothog_timerstart()
		loothog_autoshow()
		loothog_getpartymembers()
		loothog_active=true
		loothog_countdownclicked = true
		loothog_manual = true
		loothog_initClassesTrue()
		loothog_setcountdownbutton()
		if (GetItemInfo(loothog_itemid)) and (loothog_settings["announce_class"] or loothog_settings["reject_class"]) then
			for i = 1, #loothog_okayClasses, 1 do
				if(i == 1) then
					tempClass = loothog_okayClasses[i];
					AllowedClass = loothog_localizeClass(tempClass)
				else
					tempClass = loothog_okayClasses[i];
					AllowedClass = AllowedClass .. ", " .. loothog_localizeClass(tempClass)
				end
			end
			if (loothog_settings["announce_class"] and (not loothog_settings["announce_classTK"])) or (loothog_settings["announce_class"] and loothog_settings["announce_classTK"] and loothog_tokenclasses) then
				loothog_chat(LOOTHOG_MSG_CLASSES .. ": " .. AllowedClass, true)
			end
		end
		loothog_announcestart()
	else
		return
	end
end

function loothog_getiteminfo(loothog_itemid)
		if GetItemInfo(loothog_itemid) then
			local sName, sLink, iRarity, iLevel, iMinLevel, sType, sSubType, iStackCount = GetItemInfo(loothog_itemid);
			loothog_iteminfo = sLink
			loothog_itemid = loothog_ExtractItemID(loothog_iteminfo)
			if loothog_debug then
				loothog_chat("Type: " .. sType .. " Subtype: " .. sSubType)
			end
			if loothog_settings["announce_class"] or loothog_settings["reject_class"] then
				loothog_itemtype = sType
				loothog_itemstype = sSubType
					if loothog_itemtype == Loothog_Armor then
						loothog_armor()
					elseif loothog_itemtype == Loothog_Weapon then
						loothog_weapon()
					elseif loothog_itemtype == Loothog_Miscellaneous then
						loothog_checktoken(loothog_itemid)
					end
				loothog_updateClasses()
			end
		else
			return
		end
end

function loothog_ExtractItemID(link)
	local found, _, id = string.find(link, "^|c%x+|Hitem:(.-):.-%:")
	return id;
end


function loothog_initClassesTrue()
	loothog_Deathknight_okay = true 
	loothog_Warlock_okay = true 
	loothog_Paladin_okay = true 
	loothog_Druid_okay = true 
	loothog_Mage_okay = true 
	loothog_Shaman_okay = true
	loothog_Priest_okay = true
	loothog_Rogue_okay = true
	loothog_Hunter_okay = true
	loothog_Warrior_okay = true
end

function loothog_armor()
	loothog_initClassesTrue()
	loothog_getarmorvalue()

	if loothog_armorlevel > 1  then
					loothog_Priest_okay = false 
					loothog_Mage_okay = false 
					loothog_Warlock_okay = false 
	end 
	if loothog_armorlevel > 2  then
					loothog_Druid_okay = false 
					loothog_Rogue_okay = false 
	end 
	if loothog_armorlevel > 3  then
					loothog_Shaman_okay = false 
					loothog_Hunter_okay = false 
	end 
end

function loothog_getarmorvalue()
	if loothog_itemstype == Loothog_Cloth then
		loothog_armorlevel = 1
		return
	end
	if loothog_itemstype == Loothog_Leather then
		loothog_armorlevel = 2
		return
	end
	if loothog_itemstype == Loothog_Mail then
		loothog_armorlevel = 3
		return
	end
	if loothog_itemstype == Loothog_Plate then
		loothog_armorlevel = 4
		return
	end
	loothog_itemstype = Loothog_Weapon
end

function loothog_weapon()
	if loothog_itemstype ==	Loothog_Bows  then
                loothog_Deathknight_okay = false 
                loothog_Warlock_okay = false 
                loothog_Paladin_okay = false 
                loothog_Druid_okay = false 
                loothog_Mage_okay = false 
                loothog_Deathknight_okay = false 
                loothog_Shaman_okay = false
                loothog_Warlock_okay = false 
                loothog_Priest_okay = false
	elseif loothog_itemstype ==	Loothog_Crossbows  then
                loothog_Paladin_okay = false 
                loothog_Druid_okay = false 
                loothog_Mage_okay = false 
                loothog_Deathknight_okay = false 
                loothog_Shaman_okay = false
                loothog_Warlock_okay = false 
                loothog_Priest_okay = false
	elseif loothog_itemstype ==	Loothog_Daggers  then
                loothog_Paladin_okay = false 
                loothog_Mage_okay = false 
	elseif loothog_itemstype == Loothog_Guns  then
                loothog_Paladin_okay = false 
                loothog_Shaman_okay = false
                loothog_Deathknight_okay = false 
                loothog_Warlock_okay = false 
                loothog_Priest_okay = false
                loothog_Druid_okay = false
                loothog_Mage_okay = false  
	elseif loothog_itemstype ==	Loothog_FishingPoles then
	elseif loothog_itemstype ==	Loothog_FistWeapons  then
                loothog_Priest_okay = false
                loothog_Warlock_okay = false 
                loothog_Paladin_okay = false 
                loothog_Mage_okay = false  
	elseif loothog_itemstype ==	Loothog_Miscellaneous  then
	elseif loothog_itemstype ==	Loothog_OneHandedAxes  then
                loothog_Druid_okay = false
                loothog_Warlock_okay = false 
                loothog_Priest_okay = false
                loothog_Mage_okay = false  
	elseif loothog_itemstype ==	Loothog_OneHandedMaces  then
                loothog_Mage_okay = false 
                loothog_Hunter_okay = false 
                loothog_Warlock_okay = false 
	elseif loothog_itemstype ==	Loothog_OneHandedSwords  then
                loothog_Druid_okay = false
                loothog_Priest_okay = false 
	elseif loothog_itemstype ==	Loothog_Polearms  then
                loothog_Mage_okay = false 
                loothog_Rogue_okay = false
                loothog_Warlock_okay = false  
                loothog_Priest_okay = false
                loothog_Shaman_okay = false
	elseif loothog_itemstype ==	Loothog_Staves  then
                loothog_Paladin_okay = false 
                loothog_Rogue_okay = false 
	elseif loothog_itemstype ==	Loothog_Thrown  then
                loothog_Paladin_okay = false 
                loothog_Mage_okay = false 
                loothog_Warlock_okay = false 
                loothog_Shaman_okay = false
                loothog_Druid_okay = false
                loothog_Priest_okay = false 
	elseif loothog_itemstype ==	Loothog_TwoHandedAxes  then
                loothog_Mage_okay = false 
                loothog_Druid_okay = false
                loothog_Warlock_okay = false 
                loothog_Priest_okay = false 
	elseif loothog_itemstype ==	Loothog_TwoHandedMaces  then
                loothog_Mage_okay = false 
                loothog_Priest_okay = false
                loothog_Warlock_okay = false 
                loothog_Hunter_okay = false 
	elseif loothog_itemstype ==	Loothog_TwoHandedSwords  then
                loothog_Mage_okay = false 
                loothog_Shaman_okay = false
                loothog_Priest_okay = false
                loothog_Warlock_okay = false 
                loothog_Druid_okay = false 
	elseif loothog_itemstype ==	Loothog_Wands  then
                loothog_Paladin_okay = false 
                loothog_Shaman_okay = false
                loothog_Druid_okay = false 
                loothog_Rogue_okay = false 
                loothog_Warrior_okay = false 
                loothog_Hunter_okay = false 
	end
end

function loothog_updateClasses()
	loothog_okayClasses = {};
	loothog_okayClasses = {"PRIEST","MAGE","WARLOCK","DRUID","ROGUE","SHAMAN","HUNTER","WARRIOR","DEATHKNIGHT","PALADIN"}
                if not loothog_Priest_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "PRIEST") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Mage_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "MAGE") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Warlock_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "WARLOCK") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Druid_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "DRUID") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Rogue_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "ROGUE") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Shaman_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "SHAMAN") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Hunter_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "HUNTER") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Warrior_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "WARRIOR") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Deathknight_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "DEATHKNIGHT") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
                if not loothog_Paladin_okay then 
			for i = 1, #loothog_okayClasses, 1 do
				if (loothog_okayClasses[i] == "PALADIN") then
					table.remove(loothog_okayClasses, i)
				end
			end
		end
end

function loothog_checktoken(loothog_itemid)
	loothog_tokenclasses = false
        loothog_Deathknight_okay = false 
        loothog_Warlock_okay = false 
        loothog_Paladin_okay = false 
        loothog_Druid_okay = false 
        loothog_Mage_okay = false 
        loothog_Shaman_okay = false
        loothog_Priest_okay = false
        loothog_Rogue_okay = false
        loothog_Hunter_okay = false
        loothog_Warrior_okay = false
	for i = 1, #loothog_DEATHKNIGHT_token, 1 do
		if (loothog_DEATHKNIGHT_token[i] == loothog_itemid) then
			loothog_Deathknight_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_WARLOCK_token, 1 do
		if (loothog_WARLOCK_token[i] == loothog_itemid) then
			loothog_Warlock_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_PALADIN_token, 1 do
		if (loothog_PALADIN_token[i] == loothog_itemid) then
			loothog_Paladin_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_DRUID_token, 1 do
		if (loothog_DRUID_token[i] == loothog_itemid) then
			loothog_Druid_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_MAGE_token, 1 do
		if (loothog_MAGE_token[i] == loothog_itemid) then
			loothog_Mage_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_SHAMAN_token, 1 do
		if (loothog_SHAMAN_token[i] == loothog_itemid) then
			loothog_Shaman_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_PRIEST_token, 1 do
		if (loothog_PRIEST_token[i] == loothog_itemid) then
			loothog_Priest_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_ROGUE_token, 1 do
		if (loothog_ROGUE_token[i] == loothog_itemid) then
			loothog_Rogue_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_HUNTER_token, 1 do
		if (loothog_HUNTER_token[i] == loothog_itemid) then
			loothog_Hunter_okay = true
			loothog_tokenclasses = true
		end
	end
	for i = 1, #loothog_WARRIOR_token, 1 do
		if (loothog_WARRIOR_token[i] == loothog_itemid) then
			loothog_Warrior_okay = true
			loothog_tokenclasses = true
		end
	end
	if (not loothog_tokenclasses) then
		loothog_initClassesTrue()
	end
end

function loothog_localizeClass(englishclass)
	if englishclass ==  "DEATHKNIGHT" then
		thisclass = LOOTHOG_DEATHKNIGHT_CLASS
		return thisclass
	end
	if englishclass ==  "WARLOCK" then
		thisclass = LOOTHOG_WARLOCK_CLASS
		return thisclass
	end
	if englishclass ==  "PALADIN" then
		thisclass = LOOTHOG_PALADIN_CLASS
		return thisclass
	end
	if englishclass ==  "DRUID" then
		thisclass = LOOTHOG_DRUID_CLASS
		return thisclass
	end
	if englishclass ==  "MAGE" then
		thisclass = LOOTHOG_MAGE_CLASS
		return thisclass
	end
	if englishclass ==  "SHAMAN" then
		thisclass = LOOTHOG_SHAMAN_CLASS
		return thisclass
	end
	if englishclass ==  "PRIEST" then
		thisclass = LOOTHOG_PRIEST_CLASS
		return thisclass
	end
	if englishclass ==  "ROGUE" then
		thisclass = LOOTHOG_ROGUE_CLASS
		return thisclass
	end
	if englishclass ==  "HUNTER" then
		thisclass = LOOTHOG_HUNTER_CLASS
		return thisclass
	end
	if englishclass ==  "WARRIOR" then
		thisclass = LOOTHOG_WARRIOR_CLASS
		return thisclass
	end
end

function loothog_rules()
	if loothog_settings["announce_rulesintro"] then
		Rules_Intro = loothog_settings["Rules_Intro"]
		loothog_forceannounce = true
		loothog_chat(Rules_Intro)
	end
	if loothog_settings["OneEpic"] then
		DKP_Rules = LOOTHOG_RULES_CHAT_DKP1
	end
	if loothog_settings["OneSet"] then
		if DKP_Rules then
			DKP_Rules = DKP_Rules .. LOOTHOG_RULES_CHAT_DKP2
		else
		DKP_Rules = LOOTHOG_RULES_CHAT_DKP3
		end
	end
	if loothog_settings["OneSet"] or loothog_settings["OneEpic"] then
		DKP_Rules = DKP_Rules .. LOOTHOG_RULES_CHAT_DKP4
		loothog_forceannounce = true
		loothog_chat(DKP_Rules)
	end
	if (loothog_settings["reset_eligible"] and  loothog_settings["OneEpic"]) or (loothog_settings["reset_eligible"] and loothog_settings["OneSet"]) then
		Reset_Rules = LOOTHOG_RULES_CHAT_RESET
		loothog_forceannounce = true
		loothog_chat(Reset_Rules)
	end
	if loothog_settings["timeout_enabled"] then
		Timeout_Rules = string.format(LOOTHOG_RULES_CHAT_TIMEOUT, loothog_settings["timeout"])
		loothog_forceannounce = true
		loothog_chat(Timeout_Rules)
	end
	
	if loothog_settings["reject_bound"] then
		Bound_Rules = string.format(LOOTHOG_RULES_CHAT_BOUNDS, loothog_settings["LowerLimit"], loothog_settings["UpperLimit"])
		loothog_forceannounce = true
		loothog_chat(Bound_Rules)
	end

	--
	-- Squid:	Moved this check out of the previous if statement.  This will cause the offspec
	--				roll values to be announced regardless of the reject bounds assuming the offspec
	--				button is checked.
	--
	if loothog_settings["Allow_offspec"] then
		--
		-- Squid:  Changing bound rules for offspec bounds.
		--
		Bound_Rules = string.format(LOOTHOG_RULES_CHAT_OFFSPEC, loothog_settings["OffspecLowerLimit"], loothog_settings["OffspecUpperLimit"], loothog_settings["OffspecLowerLimit"], loothog_settings["OffspecUpperLimit"])
		loothog_forceannounce = true
		loothog_chat(Bound_Rules)
	end
	if not loothog_settings["disenchanter"] == "" then
		for ci = 1, GetNumRaidMembers() do
			if GetMasterLootCandidate(ci) == loothog_settings["disenchanter"] then
				loothog_Disenchanter_Present = true
  			end
		end
		if loothog_Disenchanter_Present then
			Disenchanter_Rules = loothog_settings["disenchanter"] .. " " .. LOOTHOG_RULES_DISENCHANTER
			loothog_forceannounce = true
			loothog_chat(Disenchaner_Rules)
		end
	end

	if loothog_settings["reject_class"] then
		Class_Rules = LOOTHOG_RULES_CHAT_CLASSES
		loothog_forceannounce = true
		loothog_chat(Class_Rules)
	end
end

function loothog_showrules()
	if loothog_rulessettings:IsVisible() then
		loothog_rulessettings:Hide()
	else
		loothog_rulessettings:Show()
	end
end

function loothog_togglemode()
	if loothog_settings["enable"] and loothog_settings["manual"] then
		loothog_clear()
		loothog_make_inactive()
		loothog_settings["enable"] = false
		loothog_settings["manual"] = false
		loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
		loothog_setmanual()
	elseif loothog_settings["enable"] and loothog_settings["quiet"] then
		loothog_settings["quiet"] = false
		loothog_addonconfQuiet:SetChecked(loothog_settings["quiet"])
		loothog_setmanual()
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
	elseif loothog_settings["enable"] then
		loothog_settings["quiet"] = true
		loothog_settings["manual"] = false
		loothog_addonconfQuiet:SetChecked(loothog_settings["quiet"])
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
	else
		loothog_settings["enable"] = true
		if loothog_settings["manual"] == true then
			loothog_settings["manual"] = false
		end
		loothog_addonconfEnable:SetChecked(loothog_settings["enable"])
		loothog_addonconfManual:SetChecked(loothog_settings["manual"])
	end
	loothog_togglemodelabel()
end

function loothog_togglemodelabel()
	if loothog_settings["enable"] and loothog_settings["manual"] then
		loothog_mainTitle:SetText(LOOTHOG_LABEL_MANUAL)
	elseif loothog_settings["enable"] and loothog_settings["quiet"] then
		loothog_mainTitle:SetText(LOOTHOG_LABEL_QUIET)
	elseif loothog_settings["enable"] then
		loothog_mainTitle:SetText(LOOTHOG_LABEL_ON)
	else
		loothog_mainTitle:SetText(LOOTHOG_LABEL_OFF)
	end
end

function loothog_showmode()
		if loothog_settings["enable"] and loothog_settings["manual"] then
			msg = LOOTHOG_LABEL_MANUAL
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		elseif loothog_settings["enable"] then
			msg = LOOTHOG_LABEL_ON
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		else
			msg = LOOTHOG_LABEL_OFF
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		end
end

function loothog_toggleoffspec()
	if loothog_settings["Allow_offspec"] then
		loothog_mainRollButton:SetWidth("65")
		loothog_mainOffSpecButton:Show()
		loothog_mainOffSpecButton:SetWidth("60")
		loothog_mainPassButton:SetPoint("LEFT", "loothog_mainOffSpecButton", "RIGHT", -4, 0)
		loothog_settings["autooffspec"] = false
		loothog_settings["announceoffspec"] = false
		loothog_settings["offspectimerenabled"] = false
		loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])
		loothog_addonactiveAnnounceOffspec:SetChecked(loothog_settings["announceoffspec"])
		loothog_addonactiveOffspecTimeoutEnabled:SetChecked(loothog_settings["offspectimerenabled"])
	else
		loothog_mainRollButton:SetWidth("120")
		loothog_mainOffSpecButton:SetWidth("0")
		loothog_mainOffSpecButton:Hide()
		loothog_mainPassButton:SetPoint("LEFT", "loothog_mainRollButton","RIGHT", -4, 0)
		loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])	
	end
end

function loothog_toggleautooffspec()
	if loothog_settings["autooffspec"] == false then
		loothog_settings["Allow_offspec"] = false
		loothog_toggleoffspec()
		loothog_settings["autooffspec"] = true
		loothog_addonactiveAllowOffspec:SetChecked(loothog_settings["Allow_offspec"])
		loothog_settings["offspectimerenabled"] = true
		loothog_settings["announceoffspec"] = true
		loothog_settings["announce_new"] = true
		loothog_settings["timeout_enabled"] = true
		loothog_addonactiveTimeoutEnabled:SetChecked(loothog_settings["timeout_enabled"])
		loothog_addonactiveAnnounceNew:SetChecked(loothog_settings["announce_new"])
		loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])
		loothog_addonactiveAnnounceOffspec:SetChecked(loothog_settings["announceoffspec"])
		loothog_addonactiveOffspecTimeoutEnabled:SetChecked(loothog_settings["offspectimerenabled"])
	else
		loothog_settings["autooffspec"] = false
		loothog_settings["announceoffspec"] = false
		loothog_settings["offspectimerenabled"] = false
		loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])
		loothog_addonactiveAnnounceOffspec:SetChecked(loothog_settings["announceoffspec"])
		loothog_addonactiveOffspecTimeoutEnabled:SetChecked(loothog_settings["offspectimerenabled"])
	end
end

function loothog_disableautooffspec()
	if not loothog_settings["announce_new"] or not loothog_settings["timeout_enabled"] then
		loothog_settings["autooffspec"] = false
		loothog_settings["announceoffspec"] = false
		loothog_settings["offspectimerenabled"] = false
		loothog_addonactiveAutoOffspec:SetChecked(loothog_settings["autooffspec"])
		loothog_addonactiveAnnounceOffspec:SetChecked(loothog_settings["announceoffspec"])
		loothog_addonactiveOffspecTimeoutEnabled:SetChecked(loothog_settings["offspectimerenabled"])
	end
end

function loothog_dynamicoptions()
	--
	-- Squid:  Modified the offpsec limits to be changeable.
	--
	LH_OffSpecLimits = string.format(LOOTHOG_OPTION_OFFSPEC)
	LH_RollBounds = string.format(LOOTHOG_SLASH_ROLL, loothog_settings["LowerLimit"], loothog_settings["UpperLimit"])
	LH_CountDown = string.format(LOOTHOG_SLASH_COUNTDOWN, loothog_settings["autocounttime"])
	LH_HoldReset = string.format(LOOTHOG_SLASH_HOLDRESET, loothog_settings["autoresettime"])
	LH_List = string.format(LOOTHOG_SLASH_LIST, loothog_settings["listtochatno"])
	
	--
	-- Squid:  Modified for offspec limits.
	--
	LH_SlashOffspec = string.format(LOOTHOG_SLASH_OFFSPEC, loothog_settings["OffspecLowerLimit"], loothog_settings["OffspecUpperLimit"])

	loothog_addonactiveAllowOffspecText:SetText(LH_OffSpecLimits)
	loothog_addonhelpSlashRoll:SetText(LH_RollBounds)
	loothog_addonhelpSlashCountdown:SetText(LH_CountDown)
	loothog_addonhelpSlashHoldReset:SetText(LH_HoldReset)
	loothog_addonhelpSlashList:SetText(LH_List)
	loothog_addonhelpSlashOffSpec:SetText(LH_SlashOffspec)
	if loothog_settings["autoextend"] then
		loothog_addonhelpSlashHoldReset:Show()
		loothog_addonhelpSlashKick:SetPoint("TOPLEFT", "loothog_addonhelpSlashHoldReset","BOTTOMLEFT", -26, -2)
	else
		loothog_addonhelpSlashHoldReset:Hide()
		loothog_addonhelpSlashKick:SetPoint("TOPLEFT", "loothog_addonhelpSlashHold","BOTTOMLEFT", 0, -2)
	end
end

function loothog_resettodefaults()
	loothog_settings = nil
	loothog_settings = {}
	loorhog_resetting = true
	loothog_initialize()
end

function loothog_updatecurrentsettings()
	loothog_current = {}
	loothog_current = loothog_settings
end

function loothog_resetoldsettings()
	loothog_settings = nil
	loothog_settings = loothog_current
end

function loothog_alllootbutton()
	loothog_masterlooter()
	if (not loothog_active) and (loothog_settings["showalllootbutton"]) and (loothog_settings["masterlooteronly"]) and (loothog_ismasterlooter == true) then
		loothog_mainAnnounceLootButton:Show()
	elseif (not loothog_active) and (loothog_settings["showalllootbutton"]) and (not loothog_settings["masterlooteronly"]) then
		loothog_mainAnnounceLootButton:Show()
	else
		loothog_mainAnnounceLootButton:Hide()
	end
end

function loothog_masterlooter()
	local loothog_myraidindex
	local loothog_masterlooter
	loothog_myraidindex = GetNumRaidMembers()
	_, _, _, _, _, _, _, _, _, _, loothog_masterlooter = GetRaidRosterInfo(loothog_myraidindex)
	if loothog_masterlooter == 1 then
		loothog_ismasterlooter = true
	else
		loothog_ismasterlooter = false
	end
end
	

function loothog_announceloot()
	local linkstext
	local numLootItems
	if GetNumLootItems() > 0 then
		loothog_linkx = 0
		for index = 1, GetNumLootItems() do
			loothog_linkx = loothog_linkx + 1
			if (LootSlotIsItem(index)) then
				local iteminfo = GetLootSlotLink(index);
				if linkstext == nil then
					linkstext = iteminfo
				else
					linkstext = linkstext.. " " .. iteminfo
				end
			end
			if loothog_linkx == 3 then
				loothog_chat(linkstext, true)
				linkstext = ""
				loothog_linkx = 0
			end
		end
		if (linkstext) then
			loothog_chat(linkstext, true)
		end
	end
end

function loothog_setcountdownbutton()
	if loothog_active then
	    loothog_can_assign = false
	    loothog_setannouncebutton()
		loothog_mainCountDownButton:SetText(LOOTHOG_BUTTON_COUNTDOWN)
	else
		loothog_mainCountDownButton:SetText(LOOTHOG_BUTTON_START)
	end
end

function loothog_setannouncebutton()
	if loothog_can_assign == true and GetNumRaidMembers() > 0 and loothog_ismasterlooter == true then
		loothog_mainAnnounceButton:SetText(LOOTHOG_BUTTON_ASSIGN)
		loothog_will_assign = true
	else
		loothog_mainAnnounceButton:SetText(LOOTHOG_BUTTON_ANNOUNCE)
		loothog_will_assign = false
	end
	if loothog_assign_this == "" then
		loothog_mainAnnounceButton:SetText(LOOTHOG_BUTTON_ANNOUNCE)
		loothog_will_assign = false
	end
end

function loothog_refreshoverride()
	if loothog_overriderefresh then
		loothog_interval = loothog_custom_refresh_interval
	end
end

function loothog_assignloot()
	if GetNumRaidMembers() == 0 or GetNumLootItems() == 0 or loothog_ismasterlooter == false then
		if GetNumRaidMembers() == 0 then
			loothog_error(LOOTHOG_ERROR_PARTY)
			return
		end
		if GetNumLootItems() == 0 then
			loothog_error(LOOTHOG_ERROR_LOOTWINDOW)
			return
		end
		if loothog_ismasterlooter == false then
			loothog_error(LOOTHOG_ERROR_MASTERLOOTER)
			return
		end
	else
		for index = 1, GetNumLootItems() do
			if (LootSlotIsItem(index)) then
	       			if GetLootSlotLink(index) == loothog_assign_this then
					loothog_assign_itemslot = index
					if (#loothog_rolls == 0) then
						if loothog_settings["disenchanter"] ~= "" then
							for cii = 1, GetNumRaidMembers() do
								if GetMasterLootCandidate(cii) == loothog_settings["disenchanter"] then
									loothog_assign_candidateindex = cii
								end
							end
						end
					else
						for cii = 1, GetNumRaidMembers() do
							if GetMasterLootCandidate(cii) == loothog_rolls[1][LHR_PLAYER] then
								loothog_assign_candidateindex = cii
  							end
						end
					end
				end
     			end
   		end
		if loothog_assign_candidateindex == "" then
			for cii = 1, GetNumRaidMembers() do
				if GetMasterLootCandidate(cii) == UnitName("player") then
					loothog_assign_candidateindex = cii
				end
			end
		end
		if not loothog_assign_itemslot then
			loothog_error(LOOTHOG_ERROR_NOLOOT)
		end
		if loothog_assign_itemslot and loothog_assign_candidateindex then
	   		GiveMasterLoot(loothog_assign_itemslot, loothog_assign_candidateindex);
-- Add another list with Player, Loot and Reason.  Need to add reason to change over from MS to OS, and end of rolls and clear at reset.
		end
	end
	loothog_assign = false
	loothog_assign_itemslot = ""
	loothog_assign_candidateindex = ""
	loothog_can_assign = false
	loothog_assign_this = ""
	loothog_setannouncebutton()
end