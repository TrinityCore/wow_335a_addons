--[[--------------------------------------------------------
-- Factionizer, a reputation management tool --
------------------------------------------------------------
CODE INDEX (search on index for fast access):
_01_ Addon Variables
_02_ Addon Startup
_03_ Event Handler
_04_ Addon Initialization
_05_ Slash Handler
_06_ General Helper Functions
_07_ Information
_08_ Faction map
_09_ Faction gain
_10_ New Hook Functions
_11_ Prepare update entries
_12_ Reputation Changes to Chat
_13_ Chat filtering
_14_ Testing
_15_ Getting reputation ready to hand in
_16_ Listing by standing
_17_ List german names
_18_ urbin addon listing
_19_ sso phase handling
_20_ sso phase handling UI glue
_21_ extracting skill information
_22_ extracting skill information
]]----------------------------------------------------------

--[[
StandingId
0 - Unknown
1 - Hated	-42k .. -6k	36k
2 - Hostile	- 6k .. -3k	 3k
3 - Unfriendly	- 3k ..  0	 3k
4 - Neutral	  0  ..  3k	 3k
5 - Friendly	  3k ..  9k	 6k
6 - Honored	  9k .. 21k	12k
7 - Revered	 21k .. 42k	21k
8 - Exalted	 42k .. 43k	 1k
local standingName = FACTION_STANDING_LABEL(standingID)
]]--

FIZ_ToExalted = {}
FIZ_ToExalted[0] = 84000;
FIZ_ToExalted[1] = 48000;	-- working on Hated -> Hostile, base offset 21k+12k+6k+3k+3k+3k
FIZ_ToExalted[2] = 45000;	-- working on Hostile -> Unfriendly, base offset 21k+12k+6k+3k+3k
FIZ_ToExalted[3] = 42000;	-- working on Unfriendly -> Neutral, base offset 21k+12k+6k+3k
FIZ_ToExalted[4] = 39000;	-- working on Neutral -> Friendly, base offset 21k+12k+6k
FIZ_ToExalted[5] = 33000;	-- working on Friendly -> Honored, base offset 21k+12k
FIZ_ToExalted[6] = 21000;	-- working on honoured -> revered, base offset 21k
FIZ_ToExalted[7] = 0;		-- working on revered -> exalted, so no base offset
FIZ_ToExalted[8] = 0;		-- already at exalted -> no offset

-- Addon constants
FIZ_NAME 	= "Factionizer"
FIZ_VNMBR	= 201031			-- Number code for this version

-- Colours
FIZ_HELP_COLOUR		= "|cFFFFFF7F"
FIZ_ERROR_COLOUR	= "|cFFFF0000"
FIZ_UNKNOWN_COLOUR	= "|cFF7F7F7F"
FIZ_HOSTILE_COLOUR	= "|cFFCC4C38"
FIZ_NEUTRAL_COLOUR	= "|cFFE5B200"
FIZ_FRIENDLY_COLOUR	= "|cFF009919"
FIZ_NEW_REP_COLOUR	= "|cFF7F7FFF"
FIZ_NEW_STANDING_COLOUR	= "|cFF6060C0"
FIZ_BAG_COLOUR		= "|cFFC0FFC0"
FIZ_BAG_BANK_COLOUR	= "|cFFFFFF7F"
FIZ_QUEST_COLOUR	= "|cFFC0FFC0"
FIZ_HIGHLIGHT_COLOUR    = "|cFF00FF00"
FIZ_QUEST_ACTIVE_COLOUR	= "|cFFFF7F7F"
FIZ_LOWLIGHT_COLOUR	= "|cFFFF3F3F"
FIZ_SUPPRESS_COLOUR	= "|cFF7F7F7F"

FIZ_LIMIT_TYPE_HERB	= 1
FIZ_LIMIT_TYPE_SKIN	= 2
FIZ_LIMIT_TYPE_MINE	= 3
FIZ_LIMIT_TYPE_SSO	= 4
FIZ_LIMIT_TYPE_GATHER	= 5
FIZ_LIMIT_TYPE_JEWEL    = 6
FIZ_LIMIT_TYPE_COOK     = 7

--------------------------
-- _01_ Addon Variables --
--------------------------

-- Stored data
FIZ_Data = {}			-- Data saved between sessions
-- Initialization
FIZ_Main = nil			-- Main program window
FIZ_InitComplete = nil
-- Faction information
FIZ_FactionMapping = {}
FIZ_FactionGain = {}
-- Tracking data
FIZ_Entries = {}
-- SSO phase tracking
FIZ_SSO_WARNED = false
-- Skill tracking
FIZ_Herb = false
FIZ_Skin = false
FIZ_Mine = false
FIZ_Jewel = false
FIZ_Cook = false

------------------------
-- _02_ Addon Startup --
------------------------

------------------------------------------------------------
function FIZ_OnLoad(self)
	-- Events monitored by Event Handler
	FIZ_Main = self
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGIN")

	-- Slash commands for CLI
	SLASH_FIZ1 = "/factionizer"
	SLASH_FIZ2 = "/fz"
	SlashCmdList.FIZ = FIZ_SlashHandler

	FIZ_Orig_GetFactionInfo = GetFactionInfo;
	GetFactionInfo = FIZ_GetFactionInfo;

	FIZ_Orig_ReputationFrame_Update = ReputationFrame_Update
	ReputationFrame_Update = FIZ_ReputationFrame_Update

	FIZ_Orig_ReputationBar_OnClick = ReputationBar_OnClick
	ReputationBar_OnClick = FIZ_ReputationBar_OnClick

	FIZ_Orig_ExpandFactionHeader = ExpandFactionHeader
	ExpandFactionHeader = FIZ_ExpandFactionHeader

	FIZ_Orig_CollapseFactionHeader = CollapseFactionHeader
	CollapseFactionHeader = FIZ_CollapseFactionHeader

	--FIZ_Orig_ChatFrame_OnEvent = ChatFrame_OnEvent
	--ChatFrame_OnEvent = FIZ_ChatFrame_OnEvent

	FIZ_Orig_StandingText = ReputationFrameStandingLabel:GetText()
end

------------------------------------------------------------
function FIZ_myAddons()
	-- Register addon with myAddons
	if not (myAddOnsFrame_Register) then return end
	local version = GetAddOnMetadata("Factionizer", "Version");
	local date = GetAddOnMetadata("Factionizer", "X-Date");
	local author = GetAddOnMetadata("Factionizer", "Author");
	local web = GetAddOnMetadata("Factionizer", "X-Website");
	if (version == nil) then
		version = "unknown";
	end
	if (date == nil) then
		date = "unknown";
	end
	if (author == nil) then
		author = "unknown";
	end
	if (web == nil) then
		web = "unknown";
	end

	myAddOnsFrame_Register({
		name = FIZ_NAME,
		version = version,
		releaseDate = date,
		author = author,
		email = "none",
		website = web,
		category = MYADDONS_CATEGORY_UNKNOWN,
		optionsframe = nil,
	})
end


------------------------
-- _03_ Event Handler --
------------------------

function FIZ_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
	if (event == "ADDON_LOADED") and (arg1 == FIZ_NAME) then
		FIZ_myAddons()
		FIZ_RegisterUrbinAddon(FIZ_NAME, FIZ_About)
		FIZ_Main:UnregisterEvent("ADDON_LOADED")

	elseif (event == "PLAYER_LOGIN") then
		FIZ_Main:UnregisterEvent("PLAYER_LOGIN")
		--FIZ_DoInitialCollapse()

	elseif (event == "PLAYER_ENTERING_WORLD") then
		FIZ_Init()
		FIZ_Main:UnregisterEvent("PLAYER_ENTERING_WORLD")
--		FIZ_Main:RegisterEvent("PLAYER_LEAVING_WORLD")
		FIZ_Main:RegisterEvent("UPDATE_FACTION")
		FIZ_Main:RegisterEvent("BAG_UPDATE")
--		FIZ_Main:RegisterEvent("UNIT_INVENTORY_CHANGED")	-- can be fired many times upon logging/zoning
		FIZ_Main:RegisterEvent("BANKFRAME_OPENED")
		FIZ_Main:RegisterEvent("BANKFRAME_CLOSED")
		-- to keep list of known skills up to date
		FIZ_Main:RegisterEvent("CHAT_MSG_SKILL")
		FIZ_Main:RegisterEvent("CHAT_MSG_SPELL_TRADESKILLS")
		FIZ_Main:RegisterEvent("SKILL_LINES_CHANGED")
		FIZ_Main:RegisterEvent("UPDATE_TRADESKILL_RECAST")
		FIZ_Main:RegisterEvent("QUEST_COMPLETE")
		FIZ_Main:RegisterEvent("QUEST_WATCH_UPDATE")

		-- new chat hook system
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", FIZ_ChatFilter)
		ChatFrame_AddMessageEventFilter("COMBAT_TEXT_UPDATE", FIZ_ChatFilter)


--	elseif( event == "PLAYER_LEAVING_WORLD" ) then
--		FIZ_Main:RegisterEvent("PLAYER_ENTERING_WORLD")
--		FIZ_Main:UnregisterEvent("PLAYER_LEAVING_WORLD")
--		FIZ_Main:UnregisterEvent("BAG_UPDATE")
--		FIZ_Main:UnregisterEvent("UNIT_INVENTORY_CHANGED")

	elseif (event == "UPDATE_FACTION" or
	        event == "QUEST_COMPLETE" or
	        event == "QUEST_WATCH_UPDATE") then
		if ( ReputationFrame:IsVisible() ) then
			ReputationFrame_Update();
		end
		if ( FIZ_ReputationDetailFrame:IsVisible()) then
			FIZ_BuildUpdateList()
			FIZ_UpdateList_Update()
		end
		FIZ_DumpReputationChangesToChat()

	elseif ( event == "BAG_UPDATE") then
		if (FIZ_ReputationDetailFrame:IsVisible()) then
			-- update rep frame (implicitely updates detail frame which in turn implicitely reparses bag contents)
			ReputationFrame_Update()
		end

--	elseif ( event == "UNIT_INVENTORY_CHANGED") then
--		if (arg1 == "player") then
--			if (FIZ_ReputationDetailFrame:IsVisible()) then
--				-- update rep frame (implicitely updates detail frame which in turn implicitely reparses bag contents)
--				ReputationFrame_Update()
--			end
--		end

	elseif ( event == "BANKFRAME_OPENED") then
		FIZ_BankOpen = true

	elseif ( event == "BANKFRAME_CLOSED") then
		-- this is fired twice when closing the bank window, bank contents only available at the first event
		if (FIZ_BankOpen) then
			-- this is the first call
			FIZ_ParseBankContent()
			FIZ_BankOpen = nil

			if (FIZ_ReputationDetailFrame:IsVisible()) then
				-- update rep frame (implicitely updates detail frame which in turn implicitely reparses bag contents)
				ReputationFrame_Update()
			end
		end

	elseif ( event == "CHAT_MSG_SKILL") or
	       ( event == "CHAT_MSG_SPELL_TRADESKILLS") or
	       ( event == "SKILL_LINES_CHANGED") or
	       ( event == "UPDATE_TRADESKILL_RECAST") then
		FIZ_ExtractSkills()
		if ( ReputationFrame:IsVisible() ) then
			ReputationFrame_Update();
		end
		if ( FIZ_ReputationDetailFrame:IsVisible()) then
			FIZ_BuildUpdateList()
			FIZ_UpdateList_Update()
		end

	end
end

-------------------------------
function FIZ_OnUpdate(self)
	if FIZ_InitComplete then return end
	if not FIZ_UpdateRequest then return end
	if (GetTime() < FIZ_UpdateRequest) then return end

	FIZ_Init()
end


-------------------------------
-- _04_ Addon Initialization --
-------------------------------

function FIZ_Init()
	if FIZ_InitComplete then return end

	local version = GetAddOnMetadata("Factionizer", "Version");
	if (version == nil) then
		version = "unknown";
	end

	-- create data structures
	if not FIZ_Data then FIZ_Data = {} end
	if not FIZ_Data.SSO then FIZ_Data.SSO = {} end
	if not FIZ_Data.OriginalCollapsed then FIZ_Data.OriginalCollapsed = {} end

	if FIZ_Data.ChatFrame == nil then FIZ_Data.ChatFrame = 0 end
	--if not FIZ_Data.ShowMobs then FIZ_Data.ShowMobs = true end
	--if not FIZ_Data.ShowQuests then FIZ_Data.ShowQuests = true end
	--if not FIZ_Data.ShowInstances then FIZ_Data.ShowInstances = true end
	--if not FIZ_Data.ShowItems then FIZ_Data.ShowItems = true end

	-- if not FIZ_Data.ShowMissing then FIZ_Data.ShowMissing = true end
	-- if not FIZ_Data.ExtendDetails then FIZ_Data.ExtendDetails = true end
	-- if not FIZ_Data.WriteChatMessage then FIZ_Data.WriteChatMessage = true end
	-- if not FIZ_Data.SuppressOriginalChat then FIZ_Data.SuppressOriginalChat = true end
	-- if not FIZ_Data.ShowPreviewRep then FIZ_Data.ShowPreviewRep = true end

	-- Keep version in configuration file
	FIZ_Data.Version = FIZ_VNMBR

	-- set up UI
	FIZ_OptionsButtonText:SetText(FIZ_TXT.options)
	FIZ_OptionsFrameTitle:SetText(FIZ_NAME.." "..FIZ_TXT.options)

	FIZ_EnableMissingBoxText:SetText(FIZ_TXT.showMissing)
	FIZ_ExtendDetailsBoxText:SetText(FIZ_TXT.extendDetails)
	FIZ_GainToChatBoxText:SetText(FIZ_TXT.gainToChat)
	FIZ_SupressOriginalGainBoxText:SetText(FIZ_TXT.suppressOriginalGain)
	FIZ_ShowPreviewRepBoxText:SetText(FIZ_TXT.showPreviewRep)
	FIZ_OrderByStandingCheckBoxText:SetText(FIZ_TXT.orderByStanding)

	FIZ_EnableMissingBox:SetChecked(FIZ_Data.ShowMissing)
	FIZ_ExtendDetailsBox:SetChecked(FIZ_Data.ExtendDetails)
	FIZ_GainToChatBox:SetChecked(FIZ_Data.WriteChatMessage)
	FIZ_SupressOriginalGainBox:SetChecked(FIZ_Data.SuppressOriginalChat)
	FIZ_ShowPreviewRepBox:SetChecked(FIZ_Data.ShowPreviewRep)
	FIZ_OrderByStandingCheckBox:SetChecked(FIZ_Data.SortByStanding)

	FIZ_ChatFrameSlider:SetValue(FIZ_Data.ChatFrame)

	local _, race = UnitRace("player")
	local faction, locFaction = UnitFactionGroup("player")
	local class, enClass = UnitClass("player")
	FIZ_Player = UnitName("player")
	FIZ_Realm = GetCVar("realmName")

	if (race and faction and locFaction and FIZ_Player and FIZ_Realm) then
		if (race == "Human") then
			FIZ_IsHuman = true
		end

		if enClass and enClass == "DEATHKNIGHT" then
			FIZ_IsDeathKnight = true
		end

		if (faction == FACTION_ALLIANCE) or (locFaction == FACTION_ALLIANCE) then
			FIZ_IsAlliance = true
		end

		if (faction == FACTION_HORDE) or (locFaction == FACTION_HORDE) then
			FIZ_IsHorde = true
		end

		if not FIZ_Data.SSO[FIZ_Realm] then FIZ_Data.SSO[FIZ_Realm] = {} end

		-- Initialize faction information
		FIZ_InitFactionMap()
		-- Changed by Bagdad for easy reputation content moderation
		if (GetLocale() == "deDE") then
			FIZ_InitDeFactionGains()
		elseif (GetLocale() == "ruRU") then
			FIZ_InitRuFactionGains()
		else
			FIZ_InitEnFactionGains()
		end
		FIZ_DumpReputationChangesToChat(true)

		FIZ_InitComplete = true
		FIZ_UpdateRequest = nil
	end
end

-------------------------------
function FIZ_DoInitialCollapse()

	FIZ_ShowCollapsedList()
	local numFactions = GetNumFactions();
	local name
	for factionIndex=numFactions, 1, -1 do
		name = FIZ_Orig_GetFactionInfo(factionIndex)
		if (FIZ_Data.OriginalCollapsed[name]) then
			FIZ_Print("Collapsing original entry at index "..factionIndex.." ["..name.."] which is ["..tostring(FIZ_Data.OriginalCollapsed[name]).."]")
			FIZ_Orig_CollapseFactionHeader(factionIndex)
		else
			FIZ_Print("Leaving original entry at index "..factionIndex.." ["..name.."] which is ["..tostring(FIZ_Data.OriginalCollapsed[name]).."] alone")
		end
	end
end

-------------------------------
function FIZ_ShowCollapsedList()
	FIZ_Print("Showing contents of collapsed list")
	for p in pairs(FIZ_Data.OriginalCollapsed) do
		FIZ_Print("  Entry ["..tostring(p).."] is ["..tostring(FIZ_Data.OriginalCollapsed[p]).."]")
	end
end

------------------------
-- _05_ Slash Handler --
------------------------

function FIZ_SlashHandler(msg)
	if not msg then
		return
	else
		local msgLower = string.lower(msg)
		local words = FIZ_GetWords(msg)
		local wordsLower = FIZ_GetWords(msgLower)
		local size = FIZ_TableSize(wordsLower)

		if (size>0) then
			if (wordsLower[0]=="enable") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FIZ_Data.ShowMobs = true
					elseif  (wordsLower[1]=="quests") then
						FIZ_Data.ShowQuests = true
					elseif  (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FIZ_Data.ShowInstances = true
					elseif  (wordsLower[1]=="items") then
						FIZ_Data.ShowItems = true
					elseif  (wordsLower[1]=="missing") then
						FIZ_Data.ShowMissing = true
					elseif  (wordsLower[1]=="details") then
						FIZ_Data.ExtendDetails = true
					elseif  (wordsLower[1]=="chat") then
						FIZ_Data.WriteChatMessage = true
					elseif  (wordsLower[1]=="suppress") then
						FIZ_Data.SuppressOriginalChat = true
					elseif (wordsLower[1]=="preview") then
						FIZ_Data.ShowPreviewRep = true
					elseif  (wordsLower[1]=="all") then
						FIZ_Data.ShowMobs = true
						FIZ_Data.ShowQuests = true
						FIZ_Data.ShowInstances = true
						FIZ_Data.ShowItems = true
						FIZ_Data.ShowMissing = true
						FIZ_Data.ExtendDetails = true
						FIZ_Data.WriteChatMessage = true
						FIZ_Data.SuppressOriginalChat = true
						FIZ_Data.ShowPreviewRep = true
					else
						FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
						FIZ_Help()
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update();
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
					FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
					FIZ_Help()
				end
			elseif (wordsLower[0]=="disable") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FIZ_Data.ShowMobs = false
					elseif  (wordsLower[1]=="quests") then
						FIZ_Data.ShowQuests = false
					elseif  (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FIZ_Data.ShowInstances = false
					elseif  (wordsLower[1]=="items") then
						FIZ_Data.ShowItems = false
					elseif  (wordsLower[1]=="missing") then
						FIZ_Data.ShowMissing = false
					elseif  (wordsLower[1]=="details") then
						FIZ_Data.ExtendDetails = false
					elseif  (wordsLower[1]=="chat") then
						FIZ_Data.WriteChatMessage = false
					elseif  (wordsLower[1]=="suppress") then
						FIZ_Data.SuppressOriginalChat = false
					elseif (wordsLower[1]=="preview") then
						FIZ_Data.ShowPreviewRep = false
					elseif  (wordsLower[1]=="all") then
						FIZ_Data.ShowMobs = false
						FIZ_Data.ShowQuests = false
						FIZ_Data.ShowInstances = false
						FIZ_Data.ShowItems = false
						FIZ_Data.ShowMissing = false
						FIZ_Data.ExtendDetails = false
						FIZ_Data.WriteChatMessage = false
						FIZ_Data.SuppressOriginalChat = false
						FIZ_Data.ShowPreviewRep = false
					else
						FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
						FIZ_Help()
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update();
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
					FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
					FIZ_Help()
				end
			elseif (wordsLower[0]=="toggle") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FIZ_Data.ShowMobs = not FIZ_Data.ShowMobs
					elseif  (wordsLower[1]=="quests") then
						FIZ_Data.ShowQuests = not FIZ_Data.ShowQuests
					elseif  (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FIZ_Data.ShowInstances = not FIZ_Data.ShowInstances
					elseif  (wordsLower[1]=="items") then
						FIZ_Data.ShowItems = not FIZ_Data.ShowItems
					elseif  (wordsLower[1]=="missing") then
						FIZ_Data.ShowMissing = not FIZ_Data.ShowMissing
					elseif  (wordsLower[1]=="details") then
						FIZ_Data.ExtendDetails = not FIZ_Data.ExtendDetails
					elseif  (wordsLower[1]=="chat") then
						FIZ_Data.WriteChatMessage = not FIZ_Data.WriteChatMessage
					elseif  (wordsLower[1]=="suppress") then
						FIZ_Data.SuppressOriginalChat = not FIZ_Data.SuppressOriginalChat
					elseif (wordsLower[1]=="preview") then
						FIZ_Data.ShowPreviewRep = not FIZ_Data.ShowPreviewRep
					elseif  (wordsLower[1]=="all") then
						FIZ_Data.ShowMobs = not FIZ_Data.ShowMobs
						FIZ_Data.ShowQuests = not FIZ_Data.ShowQuests
						FIZ_Data.ShowInstances = not FIZ_Data.ShowInstances
						FIZ_Data.ShowItems = not FIZ_Data.ShowItems
						FIZ_Data.ShowMissing = not FIZ_Data.ShowMissing
						FIZ_Data.ExtendDetails = not FIZ_Data.ExtendDetails
						FIZ_Data.WriteChatMessage = not FIZ_Data.WriteChatMessage
						FIZ_Data.SuppressOriginalChat = not FIZ_Data.SuppressOriginalChat
						FIZ_Data.ShowPreviewRep = not FIZ_Data.ShowPreviewRep
					else
						FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
						FIZ_Help()
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update();
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
					FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
					FIZ_Help()
				end
			elseif (wordsLower[0]=="list") then
				if (size>1) then
					if (wordsLower[1]=="1" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL1"))) then
						FIZ_ListByStanding(1)
					elseif (wordsLower[1]=="2" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL2"))) then
						FIZ_ListByStanding(2)
					elseif (wordsLower[1]=="3" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL3"))) then
						FIZ_ListByStanding(3)
					elseif (wordsLower[1]=="4" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL4"))) then
						FIZ_ListByStanding(4)
					elseif (wordsLower[1]=="5" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL5"))) then
						FIZ_ListByStanding(5)
					elseif (wordsLower[1]=="6" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL6"))) then
						FIZ_ListByStanding(6)
					elseif (wordsLower[1]=="7" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL7"))) then
						FIZ_ListByStanding(7)
					elseif (wordsLower[1]=="8" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL8"))) then
						FIZ_ListByStanding(8)
					else
						FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
						FIZ_Help()
					end
				else
					FIZ_ListByStanding()
				end
			elseif (wordsLower[0]=="de") then
				if (size>1) then
					if (wordsLower[1]=="1" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL1"))) then
						FIZ_ShowGerman(1)
					elseif (wordsLower[1]=="2" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL2"))) then
						FIZ_ShowGerman(2)
					elseif (wordsLower[1]=="3" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL3"))) then
						FIZ_ShowGerman(3)
					elseif (wordsLower[1]=="4" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL4"))) then
						FIZ_ShowGerman(4)
					elseif (wordsLower[1]=="5" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL5"))) then
						FIZ_ShowGerman(5)
					elseif (wordsLower[1]=="6" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL6"))) then
						FIZ_ShowGerman(6)
					elseif (wordsLower[1]=="7" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL7"))) then
						FIZ_ShowGerman(7)
					elseif (wordsLower[1]=="8" or wordsLower[1]==string.lower(getglobal("FACTION_STANDING_LABEL8"))) then
						FIZ_ShowGerman(8)
					else
						FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
						FIZ_Help()
					end
				else
					FIZ_ShowGerman()
				end
			elseif (wordsLower[0]=="phase" or wordsLower[0]=="sso") then
				if (size>1) then
					if (wordsLower[1]=="1") then
						FIZ_SetSSOPhase(1)
					elseif (wordsLower[1]=="2") then
						FIZ_SetSSOPhase(2)
					elseif (wordsLower[1]=="3") then
						FIZ_SetSSOPhase(3)
					elseif (wordsLower[1]=="4") then
						FIZ_SetSSOPhase(4)
					elseif (wordsLower[1]=="clear") then
						FIZ_SetSSOPhase(nil)
					elseif (wordsLower[1]=="all") then
						FIZ_SetSSOPhase(5)
					else
						FIZ_Help()
					end
				else
					FIZ_SSOPhaseStatus()
				end

				if ( ReputationFrame:IsVisible() ) then
					ReputationFrame_Update();
				end
				if ( FIZ_ReputationDetailFrame:IsVisible()) then
					FIZ_BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			elseif (wordsLower[0]=="phase2b") then
				if (size>1) then
					if (wordsLower[1]=="1") then
						FIZ_SetSSOPhase2b(1)
					elseif (wordsLower[1]=="2") then
						FIZ_SetSSOPhase2b(2)
					else
						FIZ_Help()
					end
				else
					FIZ_SSOPhaseStatus()
				end

				if ( ReputationFrame:IsVisible() ) then
					ReputationFrame_Update();
				end
				if ( FIZ_ReputationDetailFrame:IsVisible()) then
					FIZ_BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			elseif (wordsLower[0]=="phase3b") then
				if (size>1) then
					if (wordsLower[1]=="1") then
						FIZ_SetSSOPhase3b(1)
					elseif (wordsLower[1]=="2") then
						FIZ_SetSSOPhase3b(2)
					else
						FIZ_Help()
					end
				else
					FIZ_SSOPhaseStatus()
				end

				if ( ReputationFrame:IsVisible() ) then
					ReputationFrame_Update();
				end
				if ( FIZ_ReputationDetailFrame:IsVisible()) then
					FIZ_BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			elseif (wordsLower[0]=="phase4b") then
				if (size>1) then
					if (wordsLower[1]=="1") then
						FIZ_SetSSOPhase4b(1)
					elseif (wordsLower[1]=="2") then
						FIZ_SetSSOPhase4b(2)
					else
						FIZ_Help()
					end
				else
					FIZ_SSOPhaseStatus()
				end

				if ( ReputationFrame:IsVisible() ) then
					ReputationFrame_Update();
				end
				if ( FIZ_ReputationDetailFrame:IsVisible()) then
					FIZ_BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			elseif (wordsLower[0]=="phase4c") then
				if (size>1) then
					if (wordsLower[1]=="1") then
						FIZ_SetSSOPhase4c(1)
					elseif (wordsLower[1]=="2") then
						FIZ_SetSSOPhase4c(2)
					else
						FIZ_Help()
					end
				else
					FIZ_SSOPhaseStatus()
				end

				if ( ReputationFrame:IsVisible() ) then
					ReputationFrame_Update();
				end
				if ( FIZ_ReputationDetailFrame:IsVisible()) then
					FIZ_BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			elseif (wordsLower[0]=="test") then
				FIZ_Test()
			elseif (wordsLower[0]=="status") then
				FIZ_Status()
			elseif (wordsLower[0]=="help") then
				FIZ_Help()
			elseif (wordsLower[0]=="about") then
				FIZ_About()
			elseif (wordsLower[0]=="urbin") then
				FIZ_ListUrbinAddonDetails()
			else
				FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.command.." ["..FIZ_HELP_COLOUR..msgLower.."|r]", true)
				FIZ_Help()
			end
		else
			-- do nothing
		end
	end
end


-----------------------------------
-- _06_ General Helper Functions --
-----------------------------------

------------------------------------------------------------
function FIZ_Print(msg, forceDefault)
	if not (msg) then return end
	if ((FIZ_Data.ChatFrame==0) or forceDefault) then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	else
		getglobal("ChatFrame"..FIZ_Data.ChatFrame):AddMessage(msg)
	end
end

------------------------------------------------------------
function FIZ_Debug(msg)
	if not (msg) then return end
	--DEFAULT_CHAT_FRAME:AddMessage(msg)
end

------------------------------------------------------------
function FIZ_TableSize(info)
	local result = 0
	if info then
		for item in pairs(info) do result = result + 1 end
	end
	return result
end

------------------------------------------------------------
function FIZ_GetWords(str)
	local ret = {};
	local pos=0;
	local index=0
	while(true) do
		local word;
		_,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
		if(not word) then
			return ret;
		end
		ret[index]=word
		index = index+1
	end
end

------------------------------------------------------------
function FIZ_Concat(list, start, stop)
	local ret = "";

	if (start == nil) then start = 0 end
	if (stop == nil) then stop = FIZ_TableSize(list) end

	for i = start,stop do
		if list[i] then
			if (ret ~= "") then ret = ret.." " end
			ret = ret..list[i]
		end
	end
	return ret
end

------------------------------------------------------------
function FIZ_BoolToEnabled(b)
	local result = FIZ_TXT.disabled
	if b then result = FIZ_TXT.enabled end
	return result
end

------------------------------------------------------------
function FIZ_RGBToColour_perc(a, r, g, b)
	return string.format("|c%02X%02X%02X%02X", a*255, r*255, g*255, b*255)
end

-----------------------------------
-- _07_ Information
-----------------------------------
function FIZ_Help()
	FIZ_Print(" ", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.help, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz help "..FIZ_HELP_COLOUR..FIZ_TXT.helphelp, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz about "..FIZ_HELP_COLOUR..FIZ_TXT.helpabout, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz urbin|r "..FIZ_TXT.help_urbin, true);
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz status "..FIZ_HELP_COLOUR..FIZ_TXT.helpstatus, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz enable { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz disable { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz toggle { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz enable { missing | details | chat | suppress }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz disable { missing | details | chat | suppress }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz toggle { missing | details | chat | suppress }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz phase { 1..4 | all | clear } "..FIZ_HELP_COLOUR..FIZ_TXT.helpphase, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz phase2b { 1 | 2 } "..FIZ_HELP_COLOUR..FIZ_TXT.helpsubphase, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz phase3b { 1 | 2 } "..FIZ_HELP_COLOUR..FIZ_TXT.helpsubphase, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz phase4b { 1 | 2 } "..FIZ_HELP_COLOUR..FIZ_TXT.helpsubphase, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz phase4c { 1 | 2 } "..FIZ_HELP_COLOUR..FIZ_TXT.helpsubphase, true)
end

------------------------------------------------------------
function FIZ_About(urbin)
	local ver = GetAddOnMetadata("Factionizer", "Version");
	local date = GetAddOnMetadata("Factionizer", "X-Date");
	local author = GetAddOnMetadata("Factionizer", "Author");
	local web = GetAddOnMetadata("Factionizer", "X-Website");

	if (author ~= nil) then
		FIZ_Print(FIZ_NAME.." "..FIZ_TXT.by.." "..FIZ_HELP_COLOUR..author.."|r", true);
	end
	if (ver ~= nil) then
		FIZ_Print("  "..FIZ_TXT.version..": "..FIZ_HELP_COLOUR..ver.."|r", true);
	end
	if (date ~= nil) then
		FIZ_Print("  "..FIZ_TXT.date..": "..FIZ_HELP_COLOUR..date.."|r", true);
	end
	if (web ~= nil) then
		FIZ_Print("  "..FIZ_TXT.web..": "..FIZ_HELP_COLOUR..web.."|r", true);
	end

	if (urbin) then
		FIZ_Print("  "..FIZ_TXT.slash..": "..FIZ_HELP_COLOUR..SLASH_FIZ2.."|r", true);
	else
		FIZ_ListUrbinAddons(FIZ_NAME)
	end
end

------------------------------------------------------------
function FIZ_Status()
	FIZ_Print(" ", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.status, true)
	FIZ_Print("   "..FIZ_TXT.statMobs..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowMobs).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statQuests..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowQuests).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statInstances..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowInstances).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statItems..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowItems).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statMissing..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowMissing).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statDetails..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ExtendDetails).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statChat..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.WriteChatMessage).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statSuppress..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.SuppressOriginalChat).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statPreview..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowPreviewRep).."|r", true)
end

-----------------------------------
-- _08_ Faction map              --
-----------------------------------
function FIZ_InitFactionMap()
	if ((GetLocale() == "enGB") or (GetLocale() == "enUS")) then
	    FIZ_InitEnFactions()
	elseif (GetLocale() == "deDE") then
		-- German localisation of factions still needs to be finished
		FIZ_InitDeFactions()
	elseif (GetLocale() == "frFR") then
		-- French localisation of factions still needs to be done
		FIZ_InitFrFactions()
	elseif (GetLocale() == "koKR") then
		-- Korean localisation of factions still needs to be done
	elseif (GetLocale() == "zhCN") then
		-- Chinese (trad) localisation of factions still needs to be done
	elseif (GetLocale() == "zhTW") then
		-- Chinese (simpl) localisation of factions still needs to be done
	elseif (GetLocale() == "ruRU") then
		-- Russian localisation of factions curtesy of Alifar. Fixed by Bagdad
		-- Русские фракции. Исправлено Багдад. Азурегос.
		FIZ_InitRuFactions()
	elseif ((GetLocale() == "esES") or (GetLocal()=="esMX")) then
		-- Spanish localisation curtesy of Syldavia of Uldum
  	    FIZ_InitEsFactions()
	end
end

function FIZ_AddMapping(english, localised)
	if (not FIZ_FactionMapping) then
		FIZ_FactionMapping = {}
	end
	FIZ_FactionMapping[string.lower(localised)] = string.lower(english)
end

function FIZ_AddMob(faction, from, to, name, rep, zone, limit)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	if FIZ_IsHuman then rep = rep * 1.1 end

	for standing = from,to do
		if (not FIZ_FactionGain[faction]) then
			FIZ_FactionGain[faction] = {}
		end
		if (not FIZ_FactionGain[faction][standing]) then
			FIZ_FactionGain[faction][standing] = {}
		end
		if (not FIZ_FactionGain[faction][standing].mobs) then
			FIZ_FactionGain[faction][standing].mobs = {}
			FIZ_FactionGain[faction][standing].mobs.data = {}
			FIZ_FactionGain[faction][standing].mobs.count = 0
		else
			FIZ_FactionGain[faction][standing].mobs.count = FIZ_FactionGain[faction][standing].mobs.count + 1
		end
		FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count] = {}
		FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count].name = name
		FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count].rep = rep
		FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count].zone = zone
		FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count].maxStanding = to
		if ((standing == to) and limit) then
			FIZ_FactionGain[faction][standing].mobs.data[FIZ_FactionGain[faction][standing].mobs.count].limit = limit
		end

		FIZ_Debug("Added mob ["..name.."] for faction ["..faction.."] and standing ["..getglobal("FACTION_STANDING_LABEL"..standing).."]")
	end
end

function FIZ_AddQuest(faction, from, to, name, rep, itemList, limitType, arg1, arg2, arg3, arg4, arg5, arg6)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	if FIZ_IsHuman then rep = rep * 1.1 end

	for standing = from,to do
		if (not FIZ_FactionGain[faction]) then
			FIZ_FactionGain[faction] = {}
		end
		if (not FIZ_FactionGain[faction][standing]) then
			FIZ_FactionGain[faction][standing] = {}
		end
		if (not FIZ_FactionGain[faction][standing].quests) then
			FIZ_FactionGain[faction][standing].quests = {}
			FIZ_FactionGain[faction][standing].quests.data = {}
			FIZ_FactionGain[faction][standing].quests.count = 0
		else
			FIZ_FactionGain[faction][standing].quests.count = FIZ_FactionGain[faction][standing].quests.count + 1
		end
		FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count] = {}
		FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].name = name
		FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].rep = rep
		FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].maxStanding = to
		if (itemList) then
			FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].items = {}
			for item in pairs(itemList) do
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].items[item] = itemList[item]
			end
		end
		if ((standing == to) and limit) then
			FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].limit = limit
		end
		if (limitType ~= nil) then
			if (limitType == FIZ_LIMIT_TYPE_HERB or
			    limitType == FIZ_LIMIT_TYPE_MINE or
			    limitType == FIZ_LIMIT_TYPE_SKIN or
			    limitType == FIZ_LIMIT_TYPE_GATHER or
			    limitType == FIZ_LIMIT_TYPE_JEWEL) then
			    	FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].profession = limitType
			elseif (limitType == FIZ_LIMIT_TYPE_SSO and arg1 and arg2) then
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].sso = true
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].fromPhase = arg1
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].toPhase = arg2
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].phase2b = arg3
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].phase3b = arg4
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].phase4b = arg5
				FIZ_FactionGain[faction][standing].quests.data[FIZ_FactionGain[faction][standing].quests.count].phase4c = arg6
			end
		end

		FIZ_Debug("Added quest ["..name.."] for faction ["..faction.."] and standing ["..getglobal("FACTION_STANDING_LABEL"..standing).."]")
	end
end

function FIZ_AddInstance(faction, from, to, name, rep, heroic)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	if FIZ_IsHuman then rep = rep * 1.1 end

	for standing = from,to do
		if (not FIZ_FactionGain[faction]) then
			FIZ_FactionGain[faction] = {}
		end
		if (not FIZ_FactionGain[faction][standing]) then
			FIZ_FactionGain[faction][standing] = {}
		end
		if (not FIZ_FactionGain[faction][standing].instance) then
			FIZ_FactionGain[faction][standing].instance = {}
			FIZ_FactionGain[faction][standing].instance.data = {}
			FIZ_FactionGain[faction][standing].instance.count = 0
		else
			FIZ_FactionGain[faction][standing].instance.count = FIZ_FactionGain[faction][standing].instance.count + 1
		end
		FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count] = {}
		FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].name = name
		FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].rep = rep
		FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].maxStanding = to
		if (heroic) then
			FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].level = FIZ_TXT.heroic
		else
			FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].level = FIZ_TXT.normal
		end
		if ((standing == to) and limit) then
			FIZ_FactionGain[faction][standing].instance.data[FIZ_FactionGain[faction][standing].instance.count].limit = limit
		end

		FIZ_Debug("Added instance ["..name.."] for faction ["..faction.."] and standing ["..getglobal("FACTION_STANDING_LABEL"..standing).."]")
	end
end

function FIZ_AddItems(faction, from, to, rep, itemList)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not rep then return end
	if not itemList then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	if FIZ_IsHuman then rep = rep * 1.1 end

	local itemString = ""
	for standing = from,to do
		if (not FIZ_FactionGain[faction]) then
			FIZ_FactionGain[faction] = {}
		end
		if (not FIZ_FactionGain[faction][standing]) then
			FIZ_FactionGain[faction][standing] = {}
		end
		if (not FIZ_FactionGain[faction][standing].items) then
			FIZ_FactionGain[faction][standing].items = {}
			FIZ_FactionGain[faction][standing].items.data = {}
			FIZ_FactionGain[faction][standing].items.count = 0
		else
			FIZ_FactionGain[faction][standing].items.count = FIZ_FactionGain[faction][standing].items.count + 1
		end
		FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count] = {}
		FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count].rep = rep
		FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count].maxStanding = to
		if (itemList) then
			FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count].items = {}
			for item in pairs(itemList) do
				if itemString ~= "" then itemString = itemString..", " end
				itemString = itemString..itemList[item].."x "..item
				FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count].items[item] = itemList[item]
			end
		end
		if ((standing == to) and limit) then
			FIZ_FactionGain[faction][standing].items.data[FIZ_FactionGain[faction][standing].items.count].limit = limit
		end

		FIZ_Debug("AddItem: Added items ["..itemString.."] for faction ["..faction.."] and standing ["..getglobal("FACTION_STANDING_LABEL"..standing).."]")
	end
end


-----------------------------------
-- _10_ New Hook Functions       --
-----------------------------------
function FIZ_GetFactionInfo(factionIndex)
	-- get original information
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = FIZ_Orig_GetFactionInfo(factionIndex)

	-- normalize values to within standing
	local normMax = barMax-barMin
	local normCurrent = barValue-barMin

	-- add missing reputation
	if (FIZ_Data.ShowMissing and isHeader and not hasRep and ((normMax-normCurrent)>0)) then
		name = name.." ("..normMax-normCurrent..")"
	end

	-- return values
	return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild;
end

function FIZ_ReputationFrame_Update()
	if FIZ_Data.SortByStanding then
		FIZ_ReputationFrame_UpdateByStanding()
		return
	end

	local numFactions = GetNumFactions();
	local factionIndex, factionRow, factionTitle, factionStanding, factionBar, factionButton, factionLeftLine, factionBottomLine, factionBackground, color, tooltipStanding;
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched, isChild;
	local atWarIndicator, rightBarTexture;

	local previousBigTexture = ReputationFrameTopTreeTexture;	--In case we have a line going off the panel to the top
	previousBigTexture:Hide();
	local previousBigTexture2 = ReputationFrameTopTreeTexture2;
	previousBigTexture2:Hide();

	-- Update scroll frame
	if ( not FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT ) ) then
		ReputationListScrollFrameScrollBar:SetValue(0);
	end
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);

	if (FIZ_Data.ShowMissing) then
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText.." "..FIZ_TXT.missing)
	else
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText)
	end

	if (FIZ_Data.ShowPreviewRep) then
		FIZ_ParseBagContent()
	end

	local gender = UnitSex("player");

	local i;

	local offScreenFudgeFactor = 5;
	local previousBigTextureRows = 0;
	local previousBigTextureRows2 = 0;
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		factionIndex = factionOffset + i;
		factionRow = getglobal("ReputationBar"..i);
		factionBar = getglobal("ReputationBar"..i.."ReputationBar");
		factionBarPreview = getglobal("FIZ_StatusBar"..i);
		factionTitle = getglobal("ReputationBar"..i.."FactionName");
		factionButton = getglobal("ReputationBar"..i.."ExpandOrCollapseButton");
		factionLeftLine = getglobal("ReputationBar"..i.."LeftLine");
		factionBottomLine = getglobal("ReputationBar"..i.."BottomLine");
		factionStanding = getglobal("ReputationBar"..i.."ReputationBarFactionStanding");
		factionBackground = getglobal("ReputationBar"..i.."Background");
		if ( factionIndex <= numFactions ) then
			name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(factionIndex);
			if (not FIZ_SSO_WARNED) then
				FIZ_SSOWarning(name)
			end
			factionTitle:SetText(name);
			if ( isCollapsed ) then
				factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
			else
				factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
			end
			factionRow.index = factionIndex;
			factionRow.isCollapsed = isCollapsed;
			local factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
			--factionStanding:SetText(factionStandingtext);		-- moved down

			--Normalize Values
			local origBarValue = barValue
			barMax = barMax - barMin;
			barValue = barValue - barMin;
			barMin = 0;
			local toExalted = 0
			if (standingID <8) then
				toExalted = FIZ_ToExalted[standingID] + barMax - barValue;
			end

			--factionRow.standingText = factionStandingtext;	-- replaced
			if (FIZ_Data.ShowMissing) then
				factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
			else
				factionRow.standingText = factionStandingtext;
			end
			factionStanding:SetText(factionRow.standingText);
			factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
			factionBar:SetMinMaxValues(0, barMax);
			factionBar:SetValue(barValue);
			local color = FACTION_BAR_COLORS[standingID];
			factionBar:SetStatusBarColor(color.r, color.g, color.b);

			local previewValue = 0
			if (FIZ_Data.ShowPreviewRep) then
				previewValue = FIZ_GetReadyReputation(factionIndex)
			end
			if ((previewValue > 0) and not ((standingID==8) and (barMax-barValue == 1) ) ) then
				factionBarPreview:Show()
				factionBarPreview:SetMinMaxValues(0, barMax)
				previewValue = previewValue + barValue
				if (previewValue > barMax) then previewValue = barMax end
				factionBarPreview:SetValue(previewValue)
				factionBarPreview:SetID(factionIndex)
				factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
			else
				factionBarPreview:Hide()
			end

			if ( isHeader and not isChild ) then
				factionLeftLine:SetTexCoord(0, 0.25, 0, 2);
				factionBottomLine:Hide();
				factionLeftLine:Hide();
				if ( previousBigTextureRows == 0 ) then
					previousBigTexture:Hide();
				end
				previousBigTexture = factionBottomLine;
				previousBigTextureRows = 0;
			elseif ( isHeader and isChild ) then
				ReputationBar_DrawHorizontalLine(factionLeftLine, 11, factionButton);
				if ( previousBigTexture2 and previousBigTextureRows2 == 0 ) then
					previousBigTexture2:Hide();
				end
				factionBottomLine:Hide();
				previousBigTexture2 = factionBottomLine;
				previousBigTextureRows2 = 0;
				previousBigTextureRows = previousBigTextureRows+1;
				ReputationBar_DrawVerticalLine(previousBigTexture, previousBigTextureRows);

			elseif ( isChild ) then
				ReputationBar_DrawHorizontalLine(factionLeftLine, 11, factionBackground);
				factionBottomLine:Hide();
				previousBigTextureRows = previousBigTextureRows+1;
				previousBigTextureRows2 = previousBigTextureRows2+1;
				ReputationBar_DrawVerticalLine(previousBigTexture2, previousBigTextureRows2);
			else
				-- is immediately under a main category
				ReputationBar_DrawHorizontalLine(factionLeftLine, 13, factionBackground);
				factionBottomLine:Hide();
				previousBigTextureRows = previousBigTextureRows+1;
				ReputationBar_DrawVerticalLine(previousBigTexture, previousBigTextureRows);
			end

			ReputationFrame_SetRowType(factionRow, ((isChild and 1 or 0) + (isHeader and 2 or 0)), hasRep);

			factionRow:Show();

			-- Update details if this is the selected faction
			if ( atWarWith ) then
				getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight1"):Show();
				getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight2"):Show();
			else
				getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight1"):Hide();
				getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight2"):Hide();
			end
			if ( factionIndex == GetSelectedFaction() ) then
				if ( ReputationDetailFrame:IsVisible() ) then
					ReputationDetailFactionName:SetText(name);
					ReputationDetailFactionDescription:SetText(description);
					if ( atWarWith ) then
						ReputationDetailAtWarCheckBox:SetChecked(1);
					else
						ReputationDetailAtWarCheckBox:SetChecked(nil);
					end
					if ( canToggleAtWar and (not isHeader)) then
						ReputationDetailAtWarCheckBox:Enable();
						ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
					else
						ReputationDetailAtWarCheckBox:Disable();
						ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					end
					if ( not isHeader ) then
						ReputationDetailInactiveCheckBox:Enable();
						ReputationDetailInactiveCheckBoxText:SetTextColor(ReputationDetailInactiveCheckBoxText:GetFontObject():GetTextColor());
					else
						ReputationDetailInactiveCheckBox:Disable();
						ReputationDetailInactiveCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					end
					if ( IsFactionInactive(factionIndex) ) then
						ReputationDetailInactiveCheckBox:SetChecked(1);
					else
						ReputationDetailInactiveCheckBox:SetChecked(nil);
					end
					if ( isWatched ) then
						ReputationDetailMainScreenCheckBox:SetChecked(1);
					else
						ReputationDetailMainScreenCheckBox:SetChecked(nil);
					end

					getglobal("ReputationBar"..i.."ReputationBarHighlight1"):Show();
					getglobal("ReputationBar"..i.."ReputationBarHighlight2"):Show();
				end

				if ( FIZ_ReputationDetailFrame:IsVisible() ) then
					FIZ_BuildUpdateList()

					FIZ_ReputationDetailFactionName:SetText(name);
					FIZ_ReputationDetailFactionDescription:SetText(description);

					FIZ_ReputationDetailStandingName:SetText(factionStandingtext)
					local color = FACTION_BAR_COLORS[standingID]
					FIZ_ReputationDetailStandingName:SetTextColor(color.r, color.g, color.b)

					FIZ_ReputationDetailStandingCurrent:SetText(FIZ_TXT.currentRep)
					FIZ_ReputationDetailStandingNeeded:SetText(FIZ_TXT.neededRep)
					FIZ_ReputationDetailStandingMissing:SetText(FIZ_TXT.missingRep)
					FIZ_ReputationDetailStandingBag:SetText(FIZ_TXT.repInBag)
					FIZ_ReputationDetailStandingBagBank:SetText(FIZ_TXT.repInBagBank)
					FIZ_ReputationDetailStandingQuests:SetText(FIZ_TXT.repInQuest)
					FIZ_ReputationDetailStandingGained:SetText(FIZ_TXT.factionGained)

					FIZ_ReputationDetailStandingCurrentValue:SetText(barValue)
					FIZ_ReputationDetailStandingNeededValue:SetText(barMax)
					FIZ_ReputationDetailStandingMissingValue:SetText(barMax-barValue)
					FIZ_ReputationDetailStandingBagValue:SetText(FIZ_CurrentRepInBag)
					FIZ_ReputationDetailStandingBagBankValue:SetText(FIZ_CurrentRepInBagBank)
					FIZ_ReputationDetailStandingQuestsValue:SetText(FIZ_CurrentRepInQuest)
					if (FIZ_StoredRep and FIZ_StoredRep[name] and FIZ_StoredRep[name].origRep) then
						FIZ_ReputationDetailStandingGainedValue:SetText(string.format("%d", origBarValue-FIZ_StoredRep[name].origRep))
					else
						FIZ_ReputationDetailStandingGainedValue:SetText("")
					end

					if (standingID <8) then
						color = FACTION_BAR_COLORS[standingID+1]
						--FIZ_ReputationDetailStandingNext:SetText(FIZ_TXT.nextLevel)
						FIZ_ReputationDetailStandingNextValue:SetText("(--> "..GetText("FACTION_STANDING_LABEL"..standingID+1, gender)..")")
						FIZ_ReputationDetailStandingNextValue:SetTextColor(color.r, color.g, color.b)
					else
						--FIZ_ReputationDetailStandingNext:SetText("")
						FIZ_ReputationDetailStandingNextValue:SetText("")
					end
					if (standingID <7) then
						FIZ_ReputationDetailStandingToExaltedHeader:SetText(FIZ_TXT.toExalted)
						FIZ_ReputationDetailStandingToExaltedValue:SetText(toExalted)
					else
						FIZ_ReputationDetailStandingToExaltedHeader:SetText("")
						FIZ_ReputationDetailStandingToExaltedValue:SetText("")
					end

					if ( atWarWith ) then
						FIZ_ReputationDetailAtWarCheckBox:SetChecked(1);
					else
						FIZ_ReputationDetailAtWarCheckBox:SetChecked(nil);
					end
					if ( canToggleAtWar ) then
						FIZ_ReputationDetailAtWarCheckBox:Enable();
						FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
					else
						FIZ_ReputationDetailAtWarCheckBox:Disable();
						FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);

					end
					if ( IsFactionInactive(factionIndex) ) then
						FIZ_ReputationDetailInactiveCheckBox:SetChecked(1);
					else
						FIZ_ReputationDetailInactiveCheckBox:SetChecked(nil);
					end
					if ( isWatched ) then
						FIZ_ReputationDetailMainScreenCheckBox:SetChecked(1);
					else
						FIZ_ReputationDetailMainScreenCheckBox:SetChecked(nil);
					end

					getglobal("ReputationBar"..i.."ReputationBarHighlight1"):Show();
					getglobal("ReputationBar"..i.."ReputationBarHighlight2"):Show();
				end
			else
				getglobal("ReputationBar"..i.."ReputationBarHighlight1"):Hide();
				getglobal("ReputationBar"..i.."ReputationBarHighlight2"):Hide();
			end
		else
			factionRow:Hide();
		end
	end
	if ( GetSelectedFaction() == 0 ) then
		ReputationDetailFrame:Hide();
		FIZ_ReputationDetailFrame:Hide();
	end

	local i = NUM_
	for i = (NUM_FACTIONS_DISPLAYED + factionOffset + 1), numFactions, 1 do
		local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild  = GetFactionInfo(i);
		if not name then break; end

		if ( isHeader and not isChild ) then
			break;
		elseif ( (isHeader and isChild) or not(isHeader or isChild) ) then
			ReputationBar_DrawVerticalLine(previousBigTexture, previousBigTextureRows+1);
			break;
		elseif ( isChild ) then
			ReputationBar_DrawVerticalLine(previousBigTexture2, previousBigTextureRows2+1);
			break;
		end
	end
end

function FIZ_ReputationFrame_UpdateByStanding()
	-- parse original faction table and order by standing
	local numFactions = GetNumFactions();
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild;

	local standings = {}
	for i=1,numFactions do
		name, description, standingID, _, barMax, barValue, _, _, isHeader, _, hasRep = GetFactionInfo(i);

		if (not FIZ_SSO_WARNED) then
			FIZ_SSOWarning(name)
		end

		--if (not isHeader) then	-- only list factions, not faction groups headers
		if (not isHeader or hasRep) then
			if not standings[standingID] then
				standings[standingID] = {}
			end
			local size = FIZ_TableSize(standings[standingID])
			local entry = {}
			local inserted = false
			entry.missing = barMax-barValue
			entry.i = i
			if (size) then
				for j=1,size do
					if (not inserted) then
						if (standings[standingID][j].missing > entry.missing) then
							table.insert(standings[standingID], j, entry);
							inserted = true
						end
					end
				end
				if (not inserted) then
					table.insert(standings[standingID], entry)
				end
			else
				table.insert(standings[standingID], entry)
			end
		end
	end

	-- find number of elements to display
	local numFactions = 0
	FIZ_Entries = {}
	if (not FIZ_Collapsed) then
		FIZ_Collapsed = {}
	end
	for i=8,1, -1 do
	--for i in pairs(standings) do
		if FIZ_TableSize(standings[i]) then
			if (standings[i]) then
				numFactions = numFactions + 1 -- count standing as header
				FIZ_Entries[numFactions] = {}
				FIZ_Entries[numFactions].header = true
				FIZ_Entries[numFactions].i = i	-- this is the standingID
				if (not FIZ_Collapsed[i]) then
					for j in pairs(standings[i]) do
						numFactions = numFactions + 1 -- count each faction in the current standing
						FIZ_Entries[numFactions] = {}
						FIZ_Entries[numFactions].header = false
						FIZ_Entries[numFactions].i = standings[i][j].i -- this is the index into the faction table
					end
				end
			end
		end
	end

	local factionIndex, factionRow, factionTitle, factionStanding, factionBar, factionButton, factionLeftLine, factionBottomLine, factionBackground, color, tooltipStanding;
	local atWarIndicator, rightBarTexture;

	local previousBigTexture = ReputationFrameTopTreeTexture;	--In case we have a line going off the panel to the top
	previousBigTexture:Hide();
	local previousBigTexture2 = ReputationFrameTopTreeTexture2;
	previousBigTexture2:Hide();

	-- Update scroll frame
	if ( not FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT ) ) then
		ReputationListScrollFrameScrollBar:SetValue(0);
	end
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);

	if (FIZ_Data.ShowMissing) then
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText.." "..FIZ_TXT.missing)
	else
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText)
	end

	if (FIZ_Data.ShowPreviewRep) then
		FIZ_ParseBagContent()
	end

	local gender = UnitSex("player");

	local offScreenFudgeFactor = 5;
	local previousBigTextureRows = 0;
	local previousBigTextureRows2 = 0;

	local i;
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		factionIndex = factionOffset + i;
		factionBarPreview = getglobal("FIZ_StatusBar"..i);
		factionRow = getglobal("ReputationBar"..i);
		factionBar = getglobal("ReputationBar"..i.."ReputationBar");
		factionTitle = getglobal("ReputationBar"..i.."FactionName");
		factionButton = getglobal("ReputationBar"..i.."ExpandOrCollapseButton");
		factionLeftLine = getglobal("ReputationBar"..i.."LeftLine");
		factionBottomLine = getglobal("ReputationBar"..i.."BottomLine");
		factionStanding = getglobal("ReputationBar"..i.."ReputationBarFactionStanding");
		factionBackground = getglobal("ReputationBar"..i.."Background");

		if ( factionIndex <= numFactions ) then
			if (FIZ_Entries[factionIndex].header) then
				-- display the standingId as header
				if (FIZ_Entries[factionIndex].i == 8) then
					factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..FIZ_Entries[factionIndex].i, gender));
				else
					factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..FIZ_Entries[factionIndex].i, gender).." -> "..GetText("FACTION_STANDING_LABEL"..FIZ_Entries[factionIndex].i+1, gender));
				end
				if ( FIZ_Collapsed[FIZ_Entries[factionIndex].i] ) then
					factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				else
					factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				end
				factionRow.index = factionIndex
				factionRow.isCollapsed = FIZ_Collapsed[FIZ_Entries[factionIndex].i];

				factionLeftLine:SetTexCoord(0, 0.25, 0, 2);
				factionBottomLine:Hide();
				factionLeftLine:Hide();
				if ( previousBigTextureRows == 0 ) then
					previousBigTexture:Hide();
				end
				previousBigTexture = factionBottomLine;
				previousBigTextureRows = 0;

				ReputationFrame_SetRowType(factionRow, 2, hasRep);	-- 2 is top header (not intermediate header)
				factionRow:Show();
				factionBarPreview:Hide()
			else
				-- get the info for this faction
				name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(FIZ_Entries[factionIndex].i);
				local factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
				factionTitle:SetText(name);

				-- Normalize values
				local origBarValue = barValue
				barMax = barMax - barMin;
				barValue = barValue - barMin;
				barMin = 0;
				local toExalted = 0
				if (standingID <8) then
					toExalted = FIZ_ToExalted[standingID] + barMax - barValue;
				end

				factionRow.index = FIZ_Entries[factionIndex].i;

				if (FIZ_Data.ShowMissing) then
					factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
				else
					factionRow.standingText = factionStandingtext;
				end

				factionStanding:SetText(factionRow.standingText);

				factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
				factionBar:SetMinMaxValues(0, barMax);
				factionBar:SetValue(barValue);
				local color = FACTION_BAR_COLORS[standingID];
				factionBar:SetStatusBarColor(color.r, color.g, color.b);

				ReputationBar_DrawHorizontalLine(factionLeftLine, 13, factionBackground);
				factionBottomLine:Hide();
				previousBigTextureRows = previousBigTextureRows+1;
				ReputationBar_DrawVerticalLine(previousBigTexture, previousBigTextureRows);

				ReputationFrame_SetRowType(factionRow, 0, hasRep);	-- 0 is neither child nor header
				factionRow:Show();

				if ( atWarWith ) then
					getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight1"):Show();
					getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight2"):Show();
				else
					getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight1"):Hide();
					getglobal("ReputationBar"..i.."ReputationBarAtWarHighlight2"):Hide();
				end

				local previewValue = 0
				if (FIZ_Data.ShowPreviewRep) then
					previewValue = FIZ_GetReadyReputation(FIZ_Entries[factionIndex].i)
				end
				if ((previewValue > 0) and not ((standingID==8) and (barMax-barValue == 1) ) ) then
					factionBarPreview:Show()
					factionBarPreview:SetMinMaxValues(0, barMax)
					previewValue = previewValue + barValue
					if (previewValue > barMax) then previewValue = barMax end
					factionBarPreview:SetValue(previewValue)
					factionBarPreview:SetID(factionIndex)
					factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
				else
					factionBarPreview:Hide()
				end

				-- Update details if this is the selected faction
				if ( FIZ_Entries[factionIndex].i == GetSelectedFaction() ) then
					if ( ReputationDetailFrame:IsVisible() ) then
						ReputationDetailFactionName:SetText(name);
						ReputationDetailFactionDescription:SetText(description);
						if ( atWarWith ) then
							ReputationDetailAtWarCheckBox:SetChecked(1);
						else
							ReputationDetailAtWarCheckBox:SetChecked(nil);
						end
						if ( canToggleAtWar ) then
							ReputationDetailAtWarCheckBox:Enable();
							ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
						else
							ReputationDetailAtWarCheckBox:Disable();
							ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);

						end
						if ( IsFactionInactive(FIZ_Entries[factionIndex].i) ) then
							ReputationDetailInactiveCheckBox:SetChecked(1);
						else
							ReputationDetailInactiveCheckBox:SetChecked(nil);
						end
						if ( isWatched ) then
							ReputationDetailMainScreenCheckBox:SetChecked(1);
						else
							ReputationDetailMainScreenCheckBox:SetChecked(nil);
						end
					end
					if ( FIZ_ReputationDetailFrame:IsVisible() ) then
						FIZ_BuildUpdateList()

						FIZ_ReputationDetailFactionName:SetText(name);
						FIZ_ReputationDetailFactionDescription:SetText(description);

						FIZ_ReputationDetailStandingName:SetText(factionStandingtext)
						local color = FACTION_BAR_COLORS[standingID]
						FIZ_ReputationDetailStandingName:SetTextColor(color.r, color.g, color.b)

						FIZ_ReputationDetailStandingCurrent:SetText(FIZ_TXT.currentRep)
						FIZ_ReputationDetailStandingNeeded:SetText(FIZ_TXT.neededRep)
						FIZ_ReputationDetailStandingMissing:SetText(FIZ_TXT.missingRep)
						FIZ_ReputationDetailStandingBag:SetText(FIZ_TXT.repInBag)
						FIZ_ReputationDetailStandingBagBank:SetText(FIZ_TXT.repInBagBank)
						FIZ_ReputationDetailStandingQuests:SetText(FIZ_TXT.repInQuest)
						FIZ_ReputationDetailStandingGained:SetText(FIZ_TXT.factionGained)

						FIZ_ReputationDetailStandingCurrentValue:SetText(barValue)
						FIZ_ReputationDetailStandingNeededValue:SetText(barMax)
						FIZ_ReputationDetailStandingMissingValue:SetText(barMax-barValue)
						FIZ_ReputationDetailStandingBagValue:SetText(FIZ_CurrentRepInBag)
						FIZ_ReputationDetailStandingBagBankValue:SetText(FIZ_CurrentRepInBagBank)
						FIZ_ReputationDetailStandingQuestsValue:SetText(FIZ_CurrentRepInQuest)
						if (FIZ_StoredRep and FIZ_StoredRep[name] and FIZ_StoredRep[name].origRep) then
							FIZ_ReputationDetailStandingGainedValue:SetText(string.format("%d", origBarValue-FIZ_StoredRep[name].origRep))
						else
							FIZ_ReputationDetailStandingGainedValue:SetText("")
						end

						if (standingID <8) then
							color = FACTION_BAR_COLORS[standingID+1]
							--FIZ_ReputationDetailStandingNext:SetText(FIZ_TXT.nextLevel)
							FIZ_ReputationDetailStandingNextValue:SetText("(--> "..GetText("FACTION_STANDING_LABEL"..standingID+1, gender)..")")
							FIZ_ReputationDetailStandingNextValue:SetTextColor(color.r, color.g, color.b)
						else
							--FIZ_ReputationDetailStandingNext:SetText("")
							FIZ_ReputationDetailStandingNextValue:SetText("")
						end
						if (standingID <7) then
							FIZ_ReputationDetailStandingToExaltedHeader:SetText(FIZ_TXT.toExalted)
							FIZ_ReputationDetailStandingToExaltedValue:SetText(toExalted)
						else
							FIZ_ReputationDetailStandingToExaltedHeader:SetText("")
							FIZ_ReputationDetailStandingToExaltedValue:SetText("")
						end

						if ( atWarWith ) then
							FIZ_ReputationDetailAtWarCheckBox:SetChecked(1);
						else
							FIZ_ReputationDetailAtWarCheckBox:SetChecked(nil);
						end
						if ( canToggleAtWar ) then
							FIZ_ReputationDetailAtWarCheckBox:Enable();
							FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
						else
							FIZ_ReputationDetailAtWarCheckBox:Disable();
							FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);

						end
						if ( IsFactionInactive(FIZ_Entries[factionIndex].i) ) then
							FIZ_ReputationDetailInactiveCheckBox:SetChecked(1);
						else
							FIZ_ReputationDetailInactiveCheckBox:SetChecked(nil);
						end
						if ( isWatched ) then
							FIZ_ReputationDetailMainScreenCheckBox:SetChecked(1);
						else
							FIZ_ReputationDetailMainScreenCheckBox:SetChecked(nil);
						end
					end
					getglobal("ReputationBar"..i.."ReputationBarHighlight1"):Show();
					getglobal("ReputationBar"..i.."ReputationBarHighlight2"):Show();
				else
					getglobal("ReputationBar"..i.."ReputationBarHighlight1"):Hide();
					getglobal("ReputationBar"..i.."ReputationBarHighlight2"):Hide();
				end
			end
		else
			factionRow:Hide();
		end
	end
	if ( GetSelectedFaction() == 0 ) then
		ReputationDetailFrame:Hide();
		FIZ_ReputationDetailFrame:Hide();
	end

	local i = NUM_FACTIONS_DISPLAYED + factionOffset + 1
	if (i <= numFactions) then
		if (FIZ_Entries[i].header) then
		else
			ReputationBar_DrawVerticalLine(previousBigTexture, previousBigTextureRows+1);
		end
	end
end

function FIZ_ExpandFactionHeader(index)
	if not FIZ_Entries then return end

	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = nil
		FIZ_ReputationFrame_UpdateByStanding()
	else
		FIZ_Orig_ExpandFactionHeader(index)
		--[[
		local name = FIZ_Orig_GetFactionInfo(index);
		FIZ_Data.OriginalCollapsed[name] = nil
		FIZ_Print("Expanding original index "..tostring(index).." which is ["..tostring(name).."]")
		FIZ_ShowCollapsedList()
		]]--
	end
end

function FIZ_CollapseFactionHeader(index)
	if not FIZ_Entries then return end

	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = true
		FIZ_ReputationFrame_UpdateByStanding()
	else
		FIZ_Orig_CollapseFactionHeader(index)
		--[[
		local name = FIZ_Orig_GetFactionInfo(index);
		FIZ_Data.OriginalCollapsed[name] = true
		FIZ_Print("Collapsing original index "..tostring(index).." which is ["..tostring(name).."]")
		FIZ_ShowCollapsedList()
		]]--
	end
end

function FIZ_ReputationBar_OnClick(self)
	if ((ReputationDetailFrame:IsVisible() or FIZ_ReputationDetailFrame:IsVisible()) and (GetSelectedFaction() == self.index) ) then
		ReputationDetailFrame:Hide();
		FIZ_ReputationDetailFrame:Hide();
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		if (self.hasRep) then
			SetSelectedFaction(self.index);
			if (FIZ_Data.ExtendDetails) then
				FIZ_ReputationDetailFrame:Show();
				ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide()

				FIZ_BuildUpdateList()
				FIZ_UpdateList_Update()
			else
				ReputationDetailFrame:Show();
				FIZ_ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide()
			end
			PlaySound("igMainMenuOptionCheckBoxOn");
			ReputationFrame_Update();
		end
	end
end

FIZ_UPDATE_LIST_HEIGHT = 13

function FIZ_UpdateList_Update()

	if (not FIZ_ReputationDetailFrame:IsVisible()) then return end

	FIZ_UpdateListScrollFrame:Show()
	FIZ_ShowQuestButton:SetChecked(FIZ_Data.ShowQuests)
	FIZ_ShowItemsButton:SetChecked(FIZ_Data.ShowItems)
	FIZ_ShowMobsButton:SetChecked(FIZ_Data.ShowMobs)
	FIZ_ShowInstancesButton:SetChecked(FIZ_Data.ShowInstances)

	FIZ_ShowQuestButtonText:SetText(FIZ_TXT.showQuests)
	FIZ_ShowItemsButtonText:SetText(FIZ_TXT.showItems)
	FIZ_ShowMobsButtonText:SetText(FIZ_TXT.showMobs)
	FIZ_ShowInstancesButtonText:SetText(FIZ_TXT.showInstances)
	FIZ_ShowAllButton:SetText(FIZ_TXT.showAll)
	FIZ_ShowNoneButton:SetText(FIZ_TXT.showNone)
	FIZ_ExpandButton:SetText(FIZ_TXT.expand)
	FIZ_CollapseButton:SetText(FIZ_TXT.collapse)

	FIZ_SupressNoneFactionButton:SetText(FIZ_TXT.supressNoneFaction)
	FIZ_SupressNoneGlobalButton:SetText(FIZ_TXT.supressNoneGlobal)
	FIZ_ReputationDetailSuppressHint:SetText(FIZ_TXT.suppressHint)

	local numEntries, highestVisible = FIZ_GetUpdateListSize()

	-- Update scroll frame
	if ( not FauxScrollFrame_Update(FIZ_UpdateListScrollFrame, numEntries, FIZ_UPDATE_LIST_HEIGHT, 16 ) ) then
		FIZ_UpdateListScrollFrameScrollBar:SetValue(0);
	end
	local entryOffset = FauxScrollFrame_GetOffset(FIZ_UpdateListScrollFrame);

	local entryIndex
	local entryFrameName, entryFrame, entryTexture
	local entryLabel, entryName, entryRep, entryTimes
	local entryItemTimes, entryItemName, entryItemTotal
	local postfix

	local haveInfo = false;
	entryIndex = 1
	local i = 0
	local max = FIZ_TableSize(FIZ_UpdateList)
	while(i<entryOffset and entryIndex<max) do
		if FIZ_UpdateList[entryIndex].isShown then
			i = i + 1
		end
		entryIndex = entryIndex + 1
	end
	for i=1, FIZ_UPDATE_LIST_HEIGHT, 1 do
		while ((entryIndex <= highestVisible) and not FIZ_UpdateList[entryIndex].isShown) do
			entryIndex = entryIndex + 1
		end
		if (entryIndex <= highestVisible) then
			haveInfo = true

			entryFrameName = "FIZ_UpdateEntry"..i
			entryFrame = getglobal(entryFrameName)
			entryTexture = getglobal(entryFrameName.."Texture")

			entryLabel = getglobal(entryFrameName.."Label")
			entryName = getglobal(entryFrameName.."Name")
			entryRep = getglobal(entryFrameName.."Rep")
			entryTimes = getglobal(entryFrameName.."Times")

			entryItemTimes = getglobal(entryFrameName.."ItemTimes")
			entryItemName = getglobal(entryFrameName.."ItemName")
			entryItemTotal = getglobal(entryFrameName.."TotalTimes")

			if (entryFrame) then
				entryFrame:Show()
				entryFrame.id = FIZ_UpdateList[entryIndex].index
				entryFrame.tooltipHead = FIZ_UpdateList[entryIndex].tooltipHead
				entryFrame.tooltipTip = FIZ_UpdateList[entryIndex].tooltipTip
				entryFrame.tooltipDetails = FIZ_UpdateList[entryIndex].tooltipDetails
			end

			local color = ""
			if (FIZ_UpdateList[entryIndex].highlight) then
				color = FIZ_HIGHLIGHT_COLOUR
			elseif (FIZ_UpdateList[entryIndex].suppress) then
				color = FIZ_SUPPRESS_COLOUR
			elseif (FIZ_UpdateList[entryIndex].lowlight) then
				color = FIZ_LOWLIGHT_COLOUR
			end

			if (FIZ_UpdateList[entryIndex].type ~= "") then
				-- normal entry
				if (FIZ_UpdateList[entryIndex].suppress) then
					postfix = ""
				else
					postfix = "-Green"
				end
				if (FIZ_UpdateList[entryIndex].hasList) then
					if (FIZ_UpdateList[entryIndex].listShown) then
						entryTexture:SetTexture("Interface\\Addons\\Factionizer\\UI-MinusButton-Up"..postfix..".blp")
					else
						entryTexture:SetTexture("Interface\\Addons\\Factionizer\\UI-PlusButton-Up"..postfix..".blp")
					end
				else
					entryTexture:SetTexture("Interface\\Addons\\Factionizer\\UI-EmptyButton-Up"..postfix..".blp")
				end
				if (FIZ_UpdateList[entryIndex].canSuppress) then
					entryTexture:Show()
				else
					entryTexture:Hide()
				end

				entryLabel:Show()
				entryName:Show()
				entryRep:Show()
				entryTimes:Show()

				entryLabel:SetText(color..FIZ_UpdateList[entryIndex].type)
				entryName:SetText(color..FIZ_UpdateList[entryIndex].name)
				entryRep:SetText(color..FIZ_UpdateList[entryIndex].rep)
				entryTimes:SetText(color..FIZ_UpdateList[entryIndex].times)

				entryItemTimes:Hide()
				entryItemName:Hide()
				entryItemTotal:Hide()
			else
				-- item entry
				entryTexture:Hide()
				entryLabel:Hide()
				entryName:Hide()
				entryRep:Hide()
				entryTimes:Hide()

				entryItemTimes:Show()
				entryItemName:Show()

				entryItemTimes:SetText(color..FIZ_UpdateList[entryIndex].times)
				entryItemName:SetText(color..FIZ_UpdateList[entryIndex].name)
			end
			entryIndex = entryIndex + 1
		else
			getglobal("FIZ_UpdateEntry"..i):Hide()
		end
		if haveInfo then
			FIZ_NoInformationText:Hide()
		else
			FIZ_NoInformationText:SetText(FIZ_TXT.noInfo)
			FIZ_NoInformationText:Show()
		end
	end
end

function FIZ_UpdateEntryClick()
	if (FIZ_UpdateList[this.id] and FIZ_UpdateList[this.id].hasList) then
		if (FIZ_UpdateList[this.id].listShown) then
			FIZ_ShowUpdateEntry(this.id, false)
		else
			FIZ_ShowUpdateEntry(this.id, true)
		end
	end
end

function FIZ_UpdateEntrySuppress()
	if (FIZ_UpdateList[this.id]) then
		if (FIZ_UpdateList[this.id].type ~= "") then
			if (FIZ_UpdateList[this.id].faction and FIZ_UpdateList[this.id].originalName) then
				if (not FIZ_Suppressed) then
					FIZ_Suppressed = {}
				end
				if (not FIZ_Suppressed[FIZ_UpdateList[this.id].faction]) then
					FIZ_Suppressed[FIZ_UpdateList[this.id].faction] = {}
				end
				if (FIZ_Suppressed[FIZ_UpdateList[this.id].faction][FIZ_UpdateList[this.id].originalName]) then
					--FIZ_Print("No longer suppressing ["..FIZ_UpdateList[this.id].faction.."]["..FIZ_UpdateList[this.id].originalName.."]");
					FIZ_Suppressed[FIZ_UpdateList[this.id].faction][FIZ_UpdateList[this.id].originalName] = nil
				else
					--FIZ_Print("Suppressing ["..FIZ_UpdateList[this.id].faction.."]["..FIZ_UpdateList[this.id].originalName.."]");
					FIZ_Suppressed[FIZ_UpdateList[this.id].faction][FIZ_UpdateList[this.id].originalName] = true
				end
				FIZ_BuildUpdateList()
			end
		end
	end
end

function FIZ_SupressNone(allFactions)
	if (allFactions == true) then
		FIZ_Suppressed = {}
		FIZ_BuildUpdateList()
	else
		local factionIndex = GetSelectedFaction()
		local faction = GetFactionInfo(factionIndex)

		if (faction) then
			faction = string.lower(faction)
			if (FIZ_FactionMapping[faction]) then
				faction = FIZ_FactionMapping[faction]
			end

			if (not FIZ_Suppressed) then
				FIZ_Suppressed = {}
			end
			FIZ_Suppressed[faction] = {}
		end
		FIZ_BuildUpdateList()
	end
end

function FIZ_MouseButtonUp(button)
	if (button and button == "LeftButton") then
		FIZ_UpdateEntryClick()
	elseif (button and button == "RightButton") then
		FIZ_UpdateEntrySuppress()
	end
end

-----------------------------------
-- _11_ Prepare update entries   --
-----------------------------------
function FIZ_ParseBagContent()
	FIZ_ItemsCarried = {}

	for i = 0, NUM_BAG_SLOTS do
		local num = GetContainerNumSlots(i)
		for j = 1, num do
			local link = GetContainerItemLink(i, j)
			-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
			if link then
				local count = GetItemCount(link)
				local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
				if count and itemName then
					if (not FIZ_ItemsCarried[itemName]) then
						FIZ_ItemsCarried[itemName] = count
					end
				end
			end
		end
	end
end

function FIZ_ParseBankContent()
	if (not FIZ_Data.Bank) then FIZ_Data.Bank = {} end
	FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] = {}

	local i = BANK_CONTAINER
	local num = GetContainerNumSlots(i)
	for j = 1, num do
		local link = GetContainerItemLink(i, j)
		-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
		if link then
			local count = GetItemCount(link)
			local _, count = GetContainerItemInfo(i, j);
			local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
			if count and itemName then
				if (FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName]) then
					FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] + count
				else
					FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = count
				end
			end
		end
	end

	for i = NUM_BAG_SLOTS+NUM_BAG_SLOTS + NUM_BANKBAGSLOTS, NUM_BAG_SLOTS do
		local num = GetContainerNumSlots(i)
		for j = 1, num do
			local link = GetContainerItemLink(i, j)
			-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
			if link then
				local count = GetItemCount(link)
				local _, count = GetContainerItemInfo(i, j);
				local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
				if count and itemName then
					if (FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName]) then
						FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] + count
					else
						FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = count
					end
				end
			end
		end
	end
end

function FIZ_BuildUpdateList()
	FIZ_UpdateList = {}
	FIZ_CurrentRepInBag = 0
	FIZ_CurrentRepInBagBank = 0
	FIZ_CurrentRepInQuest = 0
	local index = 1

	if (not FIZ_ReputationDetailFrame:IsVisible()) then
		return
	end

	FIZ_ParseBagContent()

	local factionIndex = GetSelectedFaction()
	local faction, description, standingId, barMin, barMax, barValue = GetFactionInfo(factionIndex)

	if (not FIZ_SSO_WARNED) then
		FIZ_SSOWarning(faction)
	end

	if (faction) then
		origFaction = faction
		faction = string.lower(faction)
		if (FIZ_FactionMapping[faction]) then
			faction = FIZ_FactionMapping[faction]
		end

		-- Normalize values
		local normMax = barMax - barMin
		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue

		if (FIZ_FactionGain[faction]) then
			if (FIZ_FactionGain[faction][standingId]) then
				-- instances
				if (FIZ_FactionGain[faction][standingId].instance and FIZ_Data.ShowInstances) then
					for i = 0, FIZ_FactionGain[faction][standingId].instance.count do
						if (not FIZ_FactionGain[faction][standingId].instance.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].instance.data[i].limit)) then
							local toDo = string.format("%.2f", repToNext / FIZ_FactionGain[faction][standingId].instance.data[i].rep)
							if (FIZ_FactionGain[faction][standingId].instance.data[i].limit) then
								toDo = string.format("%.2f", (FIZ_FactionGain[faction][standingId].instance.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].instance.data[i].rep)
							end
							FIZ_UpdateList[index] = {}
							FIZ_UpdateList[index].type = FIZ_TXT.instanceShort
							FIZ_UpdateList[index].times = toDo.."x"
							FIZ_UpdateList[index].rep = string.format("%d", FIZ_FactionGain[faction][standingId].instance.data[i].rep)
							FIZ_UpdateList[index].hasList = false
							FIZ_UpdateList[index].listShown = nil
							FIZ_UpdateList[index].index = index
							FIZ_UpdateList[index].belongsTo = nil
							FIZ_UpdateList[index].isShown = true
							FIZ_UpdateList[index].name = FIZ_FactionGain[faction][standingId].instance.data[i].name.." ("..FIZ_FactionGain[faction][standingId].instance.data[i].level..")"

							FIZ_UpdateList[index].tooltipHead = FIZ_TXT.instanceHead
							FIZ_UpdateList[index].tooltipTip = FIZ_TXT.instanceTip

							FIZ_UpdateList[index].tooltipDetails = {}
							local x = 0
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.instance2
							FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_FactionGain[faction][standingId].instance.data[i].name
							x = x+1
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.mode
							FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_FactionGain[faction][standingId].instance.data[i].level
							x = x+1
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
							FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].rep
							x = x+1
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.timesToRun
							FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].times
							x = x+1
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = " "
							FIZ_UpdateList[index].tooltipDetails[x].r = " "
							x = x+1
							FIZ_UpdateList[index].tooltipDetails[x] = {}
							FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
							FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].instance.data[i].maxStanding)
							FIZ_UpdateList[index].tooltipDetails.count = x
							index = index + 1
						end
					end
				end

				-- mobs
				if (FIZ_FactionGain[faction][standingId].mobs and FIZ_Data.ShowMobs) then
					for i = 0, FIZ_FactionGain[faction][standingId].mobs.count do
						if (not FIZ_FactionGain[faction][standingId].mobs.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].mobs.data[i].limit)) then
							local toDo = ceil(repToNext / FIZ_FactionGain[faction][standingId].mobs.data[i].rep)
							if (FIZ_FactionGain[faction][standingId].mobs.data[i].limit) then
								toDo = ceil((FIZ_FactionGain[faction][standingId].mobs.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].mobs.data[i].rep)
							end
							FIZ_UpdateList[index] = {}
							FIZ_UpdateList[index].type = FIZ_TXT.mobShort
							FIZ_UpdateList[index].times = toDo.."x"
							FIZ_UpdateList[index].rep = string.format("%d", FIZ_FactionGain[faction][standingId].mobs.data[i].rep)
							FIZ_UpdateList[index].hasList = false
							FIZ_UpdateList[index].listShown = nil
							FIZ_UpdateList[index].index = index
							FIZ_UpdateList[index].belongsTo = nil
							FIZ_UpdateList[index].isShown = true
							FIZ_UpdateList[index].tooltipHead = FIZ_TXT.mobHead
							FIZ_UpdateList[index].tooltipTip = FIZ_TXT.mobTip
							if (FIZ_FactionGain[faction][standingId].mobs.data[i].zone) then
								FIZ_UpdateList[index].name = FIZ_FactionGain[faction][standingId].mobs.data[i].name.." ("..FIZ_FactionGain[faction][standingId].mobs.data[i].zone..")"
								FIZ_UpdateList[index].tooltipDetails = {}
								local x = 0
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.mob2
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_FactionGain[faction][standingId].mobs.data[i].name
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.location
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_FactionGain[faction][standingId].mobs.data[i].zone
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].rep
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.toDo
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].times
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = " "
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
								FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].mobs.data[i].maxStanding)
								FIZ_UpdateList[index].tooltipDetails.count = x
							else
								FIZ_UpdateList[index].name = FIZ_FactionGain[faction][standingId].mobs.data[i].name
								FIZ_UpdateList[index].tooltipDetails = {}
								local x = 0
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.mob2
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_FactionGain[faction][standingId].mobs.data[i].name
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].rep
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.toDo
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].times
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = " "
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
								FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].mobs.data[i].maxStanding)
								FIZ_UpdateList[index].tooltipDetails.count = x
							end
							index = index + 1
						end
					end
				end

				-- quests (may have items)
				local sum = 0
				local count = 0
				if (FIZ_FactionGain[faction][standingId].quests and FIZ_Data.ShowQuests) then
					for i = 0, FIZ_FactionGain[faction][standingId].quests.count do
						local showQuest = true

					    	if (FIZ_FactionGain[faction][standingId].quests.data[i].profession) then
					    		-- todo: create a list of known professions and keep them updated, do this outside this loop
						    	if ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_HERB) and not FIZ_Herb) then
						    		-- if list of known professions does not contain herbology
						    		showQuest = false
					    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know herbalism")
						    	elseif ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_SKIN) and not FIZ_Skin) then
						    		-- if list of known professions does not contain herbology
						    		showQuest = false
					    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know skinning")
						    	elseif ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_MINE) and not FIZ_Mine) then
						    		-- if list of known professions does not contain herbology
						    		showQuest = false
					    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know mining")
						    	elseif ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_GATHER) and not (FIZ_Herb or FIZ_Skin or FIZ_Mine)) then
						    		-- no gathering profession
						    		showQuest = false
						    	elseif ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_JEWEL) and not FIZ_Jewel) then
						    		-- if list of known professions does not contain jewelcrafting
						    		showQuest = false
						    	elseif ((FIZ_FactionGain[faction][standingId].quests.data[i].profession == FIZ_LIMIT_TYPE_COOK) and not FIZ_Cook) then
						    		-- if list of known professions does not contain jewelcrafting
						    		showQuest = false
						    	else
						    		-- unexpected limit -> ignore this and still show quest
						    	end
					    	end

						if (FIZ_FactionGain[faction][standingId].quests.data[i].sso and
						    FIZ_FactionGain[faction][standingId].quests.data[i].fromPhase and
						    FIZ_FactionGain[faction][standingId].quests.data[i].toPhase and
						    FIZ_Data.SSO[FIZ_Realm].phase and (FIZ_Data.SSO[FIZ_Realm].phase > 0)) then
							-- this quest is limited by the SSO phases and SSO phase information is available

							-- check main phase requirement
							if ((FIZ_Data.SSO[FIZ_Realm].phase < FIZ_FactionGain[faction][standingId].quests.data[i].fromPhase) or
							    (FIZ_Data.SSO[FIZ_Realm].phase > FIZ_FactionGain[faction][standingId].quests.data[i].toPhase)) then
								-- required phase not yet reached or already passed
								showQuest = false
								--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because the current phase "..FIZ_Data.SSO[FIZ_Realm].phase.." mismatches the requirement "..FIZ_FactionGain[faction][standingId].quests.data[i].fromPhase.."-"..FIZ_FactionGain[faction][standingId].quests.data[i].toPhase)
							else
								-- required phase matches -> check sub-phases
								if (FIZ_FactionGain[faction][standingId].quests.data[i].phase2b) then
								  -- there is a phase2b requirement
									if (not FIZ_Data.SSO[FIZ_Realm].phase2b or (FIZ_Data.SSO[FIZ_Realm].phase2b ~= FIZ_FactionGain[faction][standingId].quests.data[i].phase2b)) then
										-- phase 2b status not defined or does not match
										showQuest = false
							    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because the phase2b requirement "..FIZ_FactionGain[faction][standingId].quests.data[i].phase2b.." has not been met")
							    		end
								end
								if (FIZ_FactionGain[faction][standingId].quests.data[i].phase3b) then
								  -- there is a phase3b requirement
									if (not FIZ_Data.SSO[FIZ_Realm].phase3b or (FIZ_Data.SSO[FIZ_Realm].phase3b ~= FIZ_FactionGain[faction][standingId].quests.data[i].phase3b)) then
										-- phase 3b status not defined or does not match
										showQuest = false
							    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because the phase3b requirement "..FIZ_FactionGain[faction][standingId].quests.data[i].phase3b.." has not been met")
							    		end
								end
								if (FIZ_FactionGain[faction][standingId].quests.data[i].phase4b) then
								  -- there is a phase4b requirement
									if (not FIZ_Data.SSO[FIZ_Realm].phase4b or (FIZ_Data.SSO[FIZ_Realm].phase4b ~= FIZ_FactionGain[faction][standingId].quests.data[i].phase4b)) then
										-- phase 4b status not defined or does not match
										showQuest = false
							    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because the phase4b requirement "..FIZ_FactionGain[faction][standingId].quests.data[i].phase4b.." has not been met")
							    		end
								end
								if (FIZ_FactionGain[faction][standingId].quests.data[i].phase4c) then
								  -- there is a phase4c requirement
									if (not FIZ_Data.SSO[FIZ_Realm].phase4c or (FIZ_Data.SSO[FIZ_Realm].phase4c ~= FIZ_FactionGain[faction][standingId].quests.data[i].phase4c)) then
										-- phase 4c status not defined or does not match
										showQuest = false
							    			--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because the phase4c requirement "..FIZ_FactionGain[faction][standingId].quests.data[i].phase4c.." has not been met")
							    		end
								end
							end
						end

						if (showQuest) then
							if (not FIZ_FactionGain[faction][standingId].quests.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].quests.data[i].limit)) then
								local toDo = ceil(repToNext / FIZ_FactionGain[faction][standingId].quests.data[i].rep)
								if (FIZ_FactionGain[faction][standingId].quests.data[i].limit) then
									toDo = ceil((FIZ_FactionGain[faction][standingId].quests.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].quests.data[i].rep)
								end
								FIZ_UpdateList[index] = {}
								FIZ_UpdateList[index].type = FIZ_TXT.questShort
								FIZ_UpdateList[index].times = toDo.."x"
								FIZ_UpdateList[index].rep = string.format("%d", FIZ_FactionGain[faction][standingId].quests.data[i].rep)
								FIZ_UpdateList[index].index = index
								FIZ_UpdateList[index].belongsTo = nil
								FIZ_UpdateList[index].isShown = true
								FIZ_UpdateList[index].name = FIZ_FactionGain[faction][standingId].quests.data[i].name
								FIZ_UpdateList[index].originalName = FIZ_UpdateList[index].name
								FIZ_UpdateList[index].faction = faction
								FIZ_UpdateList[index].canSuppress = true
								FIZ_UpdateList[index].suppress = nil
								if (FIZ_Suppressed and FIZ_Suppressed[faction] and FIZ_Suppressed[faction][FIZ_UpdateList[index].originalName]) then
									FIZ_UpdateList[index].suppress = true
								end
								FIZ_UpdateList[index].tooltipHead = FIZ_TXT.questHead
								FIZ_UpdateList[index].tooltipTip = FIZ_TXT.questTip

								FIZ_UpdateList[index].tooltipDetails = {}
								local x = 0
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.quest2
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].name
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].rep
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.timesToDo
								FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].times
								x = x+1

								if (not FIZ_UpdateList[index].suppress) then
									sum = sum + FIZ_FactionGain[faction][standingId].quests.data[i].rep
									count = count + 1
								end

								if (FIZ_FactionGain[faction][standingId].quests.data[i].items) then
									FIZ_UpdateList[index].hasList = true
									FIZ_UpdateList[index].listShown = false

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = " "
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.itemsRequired
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1

									-- quest in log?
									FIZ_UpdateList[index].lowlight = nil

									-- check if this quest is known
									local entries, quests = GetNumQuestLogEntries()
									for z=1,entries do
										local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
										if (title and not header) then
											if string.find(string.lower(FIZ_FactionGain[faction][standingId].quests.data[i].name), string.lower(title)) then
												-- this quest matches
												FIZ_UpdateList[index].lowlight = true
												FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_QUEST_ACTIVE_COLOUR.." ("..FIZ_TXT.active..")|r"
											end
										end
									end


									-- add items
									local itemIndex = index+1

									local currentQuestTimesBag = -1
									local currentQuestTimesBagBank = -1
									for item in pairs(FIZ_FactionGain[faction][standingId].quests.data[i].items) do
										FIZ_UpdateList[itemIndex] = {}
										FIZ_UpdateList[itemIndex].type = ""
										FIZ_UpdateList[itemIndex].times = (FIZ_FactionGain[faction][standingId].quests.data[i].items[item] * toDo).."x"
										FIZ_UpdateList[itemIndex].rep = nil
										FIZ_UpdateList[itemIndex].index = itemIndex
										FIZ_UpdateList[itemIndex].belongsTo = index
										FIZ_UpdateList[itemIndex].hasList = nil
										FIZ_UpdateList[itemIndex].listShown = nil
										FIZ_UpdateList[itemIndex].isShown = FIZ_UpdateList[index].listShown
										FIZ_UpdateList[itemIndex].name = item.." ("..FIZ_FactionGain[faction][standingId].quests.data[i].items[item].."x)"

										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_FactionGain[faction][standingId].quests.data[i].items[item].."x"
										FIZ_UpdateList[index].tooltipDetails[x].r = item
										x = x+1

										if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
											if ((FIZ_ItemsCarried[item] >= FIZ_FactionGain[faction][standingId].quests.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].quests.data[i].items[item] > 0)) then
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name..FIZ_BAG_COLOUR.." ["..FIZ_ItemsCarried[item].."x]|r"
												FIZ_UpdateList[itemIndex].currentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FactionGain[faction][standingId].quests.data[i].items[item])
												if (currentQuestTimesBag == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBag = FIZ_UpdateList[itemIndex].currentTimesBag
												else
													-- some items already set
													if (FIZ_UpdateList[itemIndex].currentTimesBag < currentQuestTimesBag) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBag = FIZ_UpdateList[itemIndex].currentTimesBag
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBag = 0
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..FIZ_ItemsCarried[item].."x]"
											end
											if (FIZ_Data.Bank and
											    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
											    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
												local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
												if ((total >= FIZ_FactionGain[faction][standingId].quests.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].quests.data[i].items[item] > 0)) then
													FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name..FIZ_BAG_BANK_COLOUR.." ["..total.."x]|r"
													FIZ_UpdateList[itemIndex].currentTimesBagBank = floor(total / FIZ_FactionGain[faction][standingId].quests.data[i].items[item])
													if (currentQuestTimesBagBank == -1) then
														-- first items for this quest --> take value
														currentQuestTimesBagBank = FIZ_UpdateList[itemIndex].currentTimesBagBank
													else
														-- some items already set
														if (FIZ_UpdateList[itemIndex].currentTimesBagBank < currentQuestTimesBagBank) then
															-- fewer of this item than of others, reduce quest count
															currentQuestTimesBagBank = FIZ_UpdateList[itemIndex].currentTimesBagBank
														end
													end
												else
													-- not enough of this item for quest -> set to 0
													currentQuestTimesBagBank = 0
													FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..total.."x]"
												end
											else
												-- none of this carried in bank
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
										end
										itemIndex = itemIndex + 1
									end
									if (currentQuestTimesBag > 0) then
										FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
										FIZ_UpdateList[index].currentTimesBag = currentQuestTimesBag
										FIZ_UpdateList[index].currentRepBag = currentQuestTimesBag * FIZ_UpdateList[index].rep
										FIZ_UpdateList[index].highlight = true
										FIZ_UpdateList[index].name = FIZ_UpdateList[index].originalName
										FIZ_UpdateList[index].lowlight = nil
										FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FIZ_UpdateList[index].currentRepBag

										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = " "
										FIZ_UpdateList[index].tooltipDetails[x].r = " "
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.inBag
										FIZ_UpdateList[index].tooltipDetails[x].r = " "
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.turnIns
										FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentTimesBag)
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
										FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentRepBag)
										x = x+1
									else
										FIZ_UpdateList[index].currentTimesBag = nil
										FIZ_UpdateList[index].currentRepBag = nil
									end
									if (currentQuestTimesBagBank > 0) then
										FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."x]|r"
										FIZ_UpdateList[index].currentTimesBagBank = currentQuestTimesBagBank
										FIZ_UpdateList[index].currentRepBagBank = currentQuestTimesBagBank * FIZ_UpdateList[index].rep
										FIZ_UpdateList[index].highlight = true
										FIZ_UpdateList[index].name = FIZ_UpdateList[index].originalName
										FIZ_UpdateList[index].lowlight = nil
										FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FIZ_UpdateList[index].currentRepBagBank

										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = " "
										FIZ_UpdateList[index].tooltipDetails[x].r = " "
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.inBagBank
										FIZ_UpdateList[index].tooltipDetails[x].r = " "
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.turnIns
										FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentTimesBagBank)
										x = x+1
										FIZ_UpdateList[index].tooltipDetails[x] = {}
										FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
										FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentRepBagBank)
										x = x+1
									else
										FIZ_UpdateList[index].currentTimesBagBank = nil
										FIZ_UpdateList[index].currentRepBagBank = nil
									end
									if ((currentQuestTimesBag == 0) and (currentQuestTimesBagBank)) then
										FIZ_UpdateList[index].highlight = nil
									end

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = " "
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
									FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].quests.data[i].maxStanding)
									x = x+1

									FIZ_UpdateList[index].tooltipDetails.count = x-1
									index = itemIndex
								else
									-- no items to add
									FIZ_UpdateList[index].hasList = false
									FIZ_UpdateList[index].listShown = nil
									FIZ_UpdateList[index].highlight = nil	-- will be changed below if needed
									FIZ_UpdateList[index].lowlight = nil

									-- check if this quest is known and/or completed
									local entries, quests = GetNumQuestLogEntries()
									for z=1,entries do
										local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
										if (title and not header) then
											if string.find(string.lower(FIZ_FactionGain[faction][standingId].quests.data[i].name), string.lower(title)) then
												-- this quest matches
												if (complete) then
													FIZ_UpdateList[index].highlight = true
													FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_QUEST_COLOUR.." ("..FIZ_TXT.complete..")|r"
													FIZ_UpdateList[index].currentTimesQuest = 1
													FIZ_UpdateList[index].currentRepQuest = FIZ_UpdateList[index].rep

													FIZ_CurrentRepInQuest = FIZ_CurrentRepInQuest + FIZ_FactionGain[faction][standingId].quests.data[i].rep

													FIZ_UpdateList[index].tooltipDetails[x] = {}
													FIZ_UpdateList[index].tooltipDetails[x].l = " "
													FIZ_UpdateList[index].tooltipDetails[x].r = " "
													x = x+1
													FIZ_UpdateList[index].tooltipDetails[x] = {}
													FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.questCompleted
													FIZ_UpdateList[index].tooltipDetails[x].r = " "
													x = x+1
													FIZ_UpdateList[index].tooltipDetails[x] = {}
													FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
													FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentRepQuest)
													x = x+1
												else
													FIZ_UpdateList[index].lowlight = true
													FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_QUEST_ACTIVE_COLOUR.." ("..FIZ_TXT.active..")|r"
												end
											end
										end
									end

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = " "
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
									FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].quests.data[i].maxStanding)
									x = x+1

									FIZ_UpdateList[index].tooltipDetails.count = x-1
									index = index + 1
								end
							end
						end
					end
					if ((sum > 0) and (count > 1)) then
						-- add virtual quest to show summary of all quests:
						local toDo = ceil(repToNext / sum)
						FIZ_UpdateList[index] = {}
						FIZ_UpdateList[index].type = FIZ_TXT.questShort
						FIZ_UpdateList[index].times = toDo.."x"
						FIZ_UpdateList[index].rep = string.format("%d", sum)
						FIZ_UpdateList[index].index = index
						FIZ_UpdateList[index].belongsTo = nil
						FIZ_UpdateList[index].isShown = true
						FIZ_UpdateList[index].name = string.format(FIZ_TXT.allOfTheAbove, count)
						FIZ_UpdateList[index].tooltipHead = string.format(FIZ_TXT.questSummaryHead, count)
						FIZ_UpdateList[index].tooltipTip = FIZ_TXT.questSummaryTip

						FIZ_UpdateList[index].tooltipDetails = {}
						local x = 0
						FIZ_UpdateList[index].tooltipDetails[x] = {}
						FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
						FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].rep
						x = x+1
						FIZ_UpdateList[index].tooltipDetails[x] = {}
						FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.timesToDo
						FIZ_UpdateList[index].tooltipDetails[x].r = FIZ_UpdateList[index].times
						FIZ_UpdateList[index].tooltipDetails.count = x

						index = index + 1
					end
				end

				-- items
				if (FIZ_FactionGain[faction][standingId].items and FIZ_Data.ShowItems) then
					for i = 0, FIZ_FactionGain[faction][standingId].items.count do
						if (not FIZ_FactionGain[faction][standingId].items.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].items.data[i].limit)) then
							local toDo = ceil(repToNext / FIZ_FactionGain[faction][standingId].items.data[i].rep)
							if (FIZ_FactionGain[faction][standingId].items.data[i].limit) then
								toDo = ceil((FIZ_FactionGain[faction][standingId].items.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].items.data[i].rep)
							end
							if (FIZ_FactionGain[faction][standingId].items.data[i].items) then
								FIZ_UpdateList[index] = {}
								FIZ_UpdateList[index].type = FIZ_TXT.itemsShort
								FIZ_UpdateList[index].times = toDo.."x"
								FIZ_UpdateList[index].rep = string.format("%d", FIZ_FactionGain[faction][standingId].items.data[i].rep)
								FIZ_UpdateList[index].index = index
								FIZ_UpdateList[index].belongsTo = nil
								FIZ_UpdateList[index].isShown = true
								FIZ_UpdateList[index].name = FIZ_TXT.itemsName
								FIZ_UpdateList[index].hasList = true
								FIZ_UpdateList[index].listShown = false
								FIZ_UpdateList[index].tooltipHead = FIZ_TXT.itemsHead
								FIZ_UpdateList[index].tooltipTip = FIZ_TXT.itemsTip

								FIZ_UpdateList[index].tooltipDetails = {}
								local x = 0
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_UpdateList[index].name
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = " "
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.itemsRequired
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1

								-- add items
								local itemIndex = index+1

								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(FIZ_FactionGain[faction][standingId].items.data[i].items) do
									FIZ_UpdateList[itemIndex] = {}
									FIZ_UpdateList[itemIndex].type = ""
									FIZ_UpdateList[itemIndex].times = (FIZ_FactionGain[faction][standingId].items.data[i].items[item] * toDo).."x"
									FIZ_UpdateList[itemIndex].rep = nil
									FIZ_UpdateList[itemIndex].index = itemIndex
									FIZ_UpdateList[itemIndex].belongsTo = index
									FIZ_UpdateList[itemIndex].hasList = nil
									FIZ_UpdateList[itemIndex].listShown = nil
									FIZ_UpdateList[itemIndex].isShown = FIZ_UpdateList[index].listShown
									FIZ_UpdateList[itemIndex].name = item.." ("..FIZ_FactionGain[faction][standingId].items.data[i].items[item].."x)"

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_FactionGain[faction][standingId].items.data[i].items[item].."x"
									FIZ_UpdateList[index].tooltipDetails[x].r = item
									x = x+1

									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= FIZ_FactionGain[faction][standingId].items.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].items.data[i].items[item] > 0)) then
											FIZ_UpdateList[itemIndex].currentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FactionGain[faction][standingId].items.data[i].items[item])
											FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name..FIZ_BAG_COLOUR.." ["..FIZ_ItemsCarried[item].."x]|r"
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = FIZ_UpdateList[itemIndex].currentTimesBag
											else
												-- some items already set
												if (FIZ_UpdateList[itemIndex].currentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = FIZ_UpdateList[itemIndex].currentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
											FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..FIZ_ItemsCarried[item].."x]"
										end
										if (FIZ_Data.Bank and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= FIZ_FactionGain[faction][standingId].itemsdata[i].items[item]) and (FIZ_FactionGain[faction][standingId].items.data[i].items[item] > 0)) then
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name..FIZ_BAG_BANK_COLOUR.." ["..total.."x]|r"
												FIZ_UpdateList[itemIndex].currentTimesBagBank = floor(total / FIZ_FactionGain[faction][standingId].items.data[i].items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = FIZ_UpdateList[itemIndex].currentTimesBagBank
												else
													-- some items already set
													if (FIZ_UpdateList[itemIndex].currentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = FIZ_UpdateList[itemIndex].currentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..total.."x]"
											end
										else
											-- none of this carried in bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
									itemIndex = itemIndex + 1

								end
								if (currentQuestTimesBag > 0) then
									FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
									FIZ_UpdateList[index].currentTimesBag = currentQuestTimesBag
									FIZ_UpdateList[index].currentRepBag = currentQuestTimesBag * FIZ_UpdateList[index].rep
									FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FIZ_UpdateList[index].currentRepBag

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = " "
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.inBag
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.turnIns
									FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentTimesBag)
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
									FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentRepBag)
									x = x+1
								else
									FIZ_UpdateList[index].currentTimesBag = nil
									FIZ_UpdateList[index].currentRepBag = nil
								end
								if (currentQuestTimesBagBank > 0) then
									FIZ_UpdateList[index].name = FIZ_UpdateList[index].name..FIZ_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."]|r"
									FIZ_UpdateList[index].currentTimesBagBank = currentQuestTimesBagBank
									FIZ_UpdateList[index].currentRepBagBank = currentQuestTimesBagBank * FIZ_UpdateList[index].rep
									FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FIZ_UpdateList[index].currentRepBagBank

									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = " "
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.inBagBank
									FIZ_UpdateList[index].tooltipDetails[x].r = " "
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.turnIns
									FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentTimesBagBank)
									x = x+1
									FIZ_UpdateList[index].tooltipDetails[x] = {}
									FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.reputation
									FIZ_UpdateList[index].tooltipDetails[x].r = string.format("%d", FIZ_UpdateList[index].currentRepBagBank)
									x = x+1
								else
									FIZ_UpdateList[index].currentTimesBagBank = nil
									FIZ_UpdateList[index].currentRepBagBank = nil
								end

								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = " "
								FIZ_UpdateList[index].tooltipDetails[x].r = " "
								x = x+1
								FIZ_UpdateList[index].tooltipDetails[x] = {}
								FIZ_UpdateList[index].tooltipDetails[x].l = FIZ_TXT.maxStanding
								FIZ_UpdateList[index].tooltipDetails[x].r = getglobal("FACTION_STANDING_LABEL"..FIZ_FactionGain[faction][standingId].items.data[i].maxStanding)
								x = x+1

								FIZ_UpdateList[index].tooltipDetails.count = x-1

								index = itemIndex
							end
						end
					end
				end
			end
		end
	end

	--FIZ_Print("Added "..(index-1).." entries for ["..faction.."] at standing "..standingId)

	FIZ_UpdateList_Update()
end

function FIZ_GetUpdateListSize()
	local count = 0
	local highest = 0
	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].isShown) then
			count = count + 1
			if (i > highest) then
				highest = i
			end
		end
	end

	return count, highest
end

function FIZ_ShowUpdateEntry(index, show)
	if (not FIZ_UpdateList[index]) then return end		-- invalid index
	if (not FIZ_UpdateList[index].hasList) then return end	-- not a list header entry
	if (type(show)~="boolean") then return end		-- wrong data type

	FIZ_UpdateList[index].listShown = show
	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].belongsTo == index) then
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowUpdateEntries(show)
	if (type(show)~="boolean") then return end		-- wrong data type

	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].belongsTo == nil) then
			-- always show parent entries, show or hide their children
			FIZ_UpdateList[i].isShown = true
			FIZ_UpdateList[i].listShown = show
		else
			-- show or hide child entries
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowLineToolTip(object)
	if not object then return end

	if (this.tooltipHead) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this)
		GameTooltip:SetText(this.tooltipHead, 1, 1, 0.5, 1)
		if (this.tooltipTip) then
			GameTooltip:AddLine(this.tooltipTip, 1, 1, 1, 1)
		end
		if (this.tooltipDetails and type(this.tooltipDetails) == "table") then
			GameTooltip:AddLine(" ", 1, 1, 1, 1)
			for i = 0, this.tooltipDetails.count do
				if (this.tooltipDetails[i].l and this.tooltipDetails[i].r) then
					if (this.tooltipDetails[i].r == " " or this.tooltipDetails[i].r=="") then
						GameTooltip:AddDoubleLine(this.tooltipDetails[i].l, this.tooltipDetails[i].r, 1, 1, 0, 1, 1, 1)
					else
						GameTooltip:AddDoubleLine(this.tooltipDetails[i].l, this.tooltipDetails[i].r, 1, 1, 0.5, 1, 1, 1)
					end
				end
			end
		end
		GameTooltip:Show()
	end
end

function FIZ_ShowHelpToolTip(element)
	if not element then return end

	local name = ""

	-- cut off leading frame name
	--if (string.find(element, GLDG_GUI)) then
	--	name = string.sub(element, string.len(GLDG_GUI)+1)
	--elseif (string.find(element, GLDG_COLOUR)) then
	--	name = string.sub(element, string.len(GLDG_COLOUR)+1)
	--elseif (string.find(element, GLDG_LIST)) then
		name = element
	--end

	-- cut off trailing number in case of line and collect
	--local s,e = string.find(name, "Line");
	--if (s and e) then
	--	name = string.sub(name, 0, e)
	--end
	--s,e = string.find(name, "Collect");
	--if (s and e) then
	--	name = string.sub(name, 0, e)
	--end

	-- cut off colour button/texture
	--if (string.find(name, "Colour") == 1) then
	--	-- ["ColourGuildNewButton"] = true,
	--	s,e = string.find(name, "Button");
	--	if (s and e) then
	--		name = string.sub(name, 0, s-1)
	--	end
	--	-- ["ColourGuildNewColour"] = true,
	--	s,e = string.find(name, "Colour", 2);	-- start at 2 to skip the initial Colour
	--	if (s and e) then
	--		name = string.sub(name, 0, s-1)
	--	end
	--end


	local tip = ""
	local head = ""
	if (FIZ_TXT.elements and
	    FIZ_TXT.elements.name and
	    FIZ_TXT.elements.tip and
	    FIZ_TXT.elements.name[name] and
	    FIZ_TXT.elements.tip[name]) then
		tip = FIZ_TXT.elements.tip[name]
		head = FIZ_TXT.elements.name[name]

		if (FIZ_Data.needsTip and FIZ_Data.needsTip[name]) then
			FIZ_Data.needsTip[name] = nil
		end
	else
		if (not FIZ_Data.needsTip) then
			FIZ_Data.needsTip = {}
		end
		FIZ_Data.needsTip[name] = true
	end

	--GameTooltip_SetDefaultAnchor(GameTooltip, this)
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if (head ~= "") then
		GameTooltip:SetText(head, 1, 1, 0.5, 1.0, 1)
--		GameTooltip:AddLine(name, 1, 0, 0, 1.0, 1)
		GameTooltip:AddLine(tip, 1, 1, 1, 1.0, 1)
--	else
--		GameTooltip:SetText(element, 1, 1, 0.5, 1.0, 1)
--		GameTooltip:AddLine(name, 1, 1, 1, 1.0, 1)
	end

	GameTooltip:Show()
end

-----------------------------------
-- _12_ Reputation Changes to Chat
-----------------------------------
function FIZ_DumpReputationChangesToChat(initOnly)
	if not FIZ_StoredRep then FIZ_StoredRep = {} end

	local numFactions = GetNumFactions();
	local factionIndex
	local name, standingID, barMin, barMax, barValue, isHeader, hasRep
	local RepRemains
	for factionIndex=1, numFactions, 1 do
		name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep = GetFactionInfo(factionIndex)

		--if (not isHeader) then
		if (not isHeader or hasRep) then
			if FIZ_StoredRep[name] and not initOnly then
				if (FIZ_Data.WriteChatMessage) then
					local sign=""
					if ((barValue-FIZ_StoredRep[name].origRep)>0) then
						sign = "+"
					end
					if (barValue > FIZ_StoredRep[name].rep) then
						-- increased rep
						FIZ_Print(FIZ_NEW_REP_COLOUR..string.format(FACTION_STANDING_INCREASED..FIZ_TXT.stats, name, barValue-FIZ_StoredRep[name].rep, sign, barValue-FIZ_StoredRep[name].origRep, barMax-barValue))
					elseif (barValue < FIZ_StoredRep[name].rep) then
						FIZ_Print(FIZ_NEW_REP_COLOUR..string.format(FACTION_STANDING_DECREASED..FIZ_TXT.stats, name, FIZ_StoredRep[name].rep-barValue, sign, barValue-FIZ_StoredRep[name].origRep, barMax-barValue))
						-- decreased rep
					end
					if (FIZ_StoredRep[name].standingID ~= standingID) then
						FIZ_Print(FIZ_NEW_STANDING_COLOUR..string.format(FACTION_STANDING_CHANGED, getglobal("FACTION_STANDING_LABEL"..standingID), name))
					end
				end
			else
				FIZ_StoredRep[name] = {}
				FIZ_StoredRep[name].origRep = barValue
			end
			FIZ_StoredRep[name].standingID = standingID
			FIZ_StoredRep[name].rep = barValue
		end
	end
end

-----------------------------------
-- _13_ Chat filtering
-----------------------------------
--function FIZ_ChatFrame_OnEvent(self, event, ...)
function FIZ_ChatFilter(chatFrame, event, ...) -- chatFrame = self
	--[[
	CHAT_MSG_COMBAT_FACTION_CHANGE
		Fires when player's faction changes. ie: "Your reputation with Timbermaw Hold has very slightly increased." -- NEW 1.9
		arg1
			The message to display

	COMBAT_TEXT_UPDATE
		arg1
			Combat message type.
			Known values include "HONOR_GAINED", and "FACTION".
		arg2
			for faction gain, this is the faction name.
		arg3
			for faction gain, the amount of reputation gained.
	]]--

	local msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = ...;
	local skip = false
	if (event) then
		--local m = "["..event.."]"
		--if (msg) then m = m.." ("..msg..")" else m = m.." ()" end
		--if (arg2) then m = m.." ("..arg2..")" else m = m.." ()" end
		--if (arg3) then m = m.." ("..arg3..")" else m = m.." ()" end
		--if (arg4) then m = m.." ("..arg4..")" else m = m.." ()" end
		--if (arg5) then m = m.." ("..arg5..")" else m = m.." ()" end
		--if (arg6) then m = m.." ("..arg6..")" else m = m.." ()" end
		--if (arg7) then m = m.." ("..arg7..")" else m = m.." ()" end
		--if (arg8) then m = m.." ("..arg8..")" else m = m.." ()" end
		--if (arg9) then m = m.." ("..arg9..")" else m = m.." ()" end
		--FIZ_Print("Caught an event: "..m)

		if (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
			skip = true
		end
		if ((event == "COMBAT_TEXT_UPDATE") and (msg=="FACTION")) then
			skip = true
		end
		skip = skip and FIZ_Data.SuppressOriginalChat

		--if not skip then
		--	FIZ_Orig_ChatFrame_OnEvent(self, event, ...)
		--	--FIZ_Orig_ChatFrame_OnEvent(self, event, msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
		--end
	end
	return skip, msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12
end

-----------------------------------
-- _13_ Show option window
-----------------------------------
function FIZ_ToggleConfigWindow()
	if ReputationFrame:IsVisible() then
		if FIZ_OptionsFrame:IsVisible() then
			-- both windows shown -> hide them both
			FIZ_OptionsFrame:Hide()
			HideUIPanel(CharacterFrame)
		else
			-- options window not shown -> show, hide any detail window
			FIZ_OptionsFrame:Show()
			FIZ_ReputationDetailFrame:Hide();
			ReputationDetailFrame:Hide();
		end
	else
		-- window not shown -> show both
		ToggleCharacter("ReputationFrame")
		FIZ_ReputationDetailFrame:Hide();
		ReputationDetailFrame:Hide();
		FIZ_OptionsFrame:Show()
	end
end

function FIZ_ToggleDetailWindow()
	if ReputationFrame:IsVisible() then
		if (FIZ_Data.ExtendDetails) then
			if FIZ_ReputationDetailFrame:IsVisible() then
				-- both windows shown -> hide them both
				FIZ_ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				-- detail window not shown -> show it, hide any others
				FIZ_ReputationDetailFrame:Show()
				ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide();
				ReputationFrame_Update();
			end
		else
			if ReputationDetailFrame:IsVisible() then
				-- both windows shown -> hide them both
				ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				-- detail window not shown -> show it, hide any others
				FIZ_ReputationDetailFrame:Hide()
				ReputationDetailFrame:Show();
				FIZ_OptionsFrame:Hide();
				ReputationFrame_Update();
			end
		end
	else
		-- window not shown -> show both
		ToggleCharacter("ReputationFrame")
		if (FIZ_Data.ExtendDetails) then
			FIZ_ReputationDetailFrame:Show();
		else
			ReputationDetailFrame:Show();
		end
		FIZ_OptionsFrame:Hide()
		ReputationFrame_Update();
	end
end


-----------------------------------
-- _14_ Testing
-----------------------------------

--[[
local numEntries, numQuests = GetNumQuestLogEntries()
numEntries
    Integer - Number of entries in the Quest Log (includes collapsable area grouping headlines).
numQuests
    Integer - Number of actual quests.

questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questID);
]]--

function FIZ_Test()
	local entries, quests = GetNumQuestLogEntries()

	FIZ_Print(" ")
	FIZ_Print("Entries: "..entries..", Quests: "..quests)

	for i=1,entries do
		local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(i)
		local link = GetQuestLink(i)
		if (title) then
			if not link then link = "nil" end
			if not level then level = "nil" end
			if not tag then tag = "no tag" end
			if not group then group = "no group" end
			FIZ_Print("Entry "..i..": ["..level.."] ["..title.."] ["..tag.."] - ["..link.."] - Header: "..tostring(header)..", Collapsed: "..tostring(collapsed)..", Complete: "..tostring(complete)..", Daily: "..tostring(daily))
		else
			FIZ_Print("Entry "..i.." is nil")
		end
	end
	FIZ_Print(" ")
end


-----------------------------------
-- _15_ Getting reputation ready to hand in
-----------------------------------
function FIZ_GetReadyReputation(factionIndex)
	local result = 0
	if not factionIndex then return result end

	if (not ReputationFrame:IsVisible()) then return result end

	local maxFactionIndex = GetNumFactions()
	if (factionIndex > maxFactionIndex) then return result end

	local faction, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = FIZ_Orig_GetFactionInfo(factionIndex)
	if (isHeader) then return result end

	if (faction) then
		origFaction = faction
		faction = string.lower(faction)
		if (FIZ_FactionMapping[faction]) then
			faction = FIZ_FactionMapping[faction]
		end

		-- Normalize values
		local normMax = barMax - barMin
		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue

		if (FIZ_FactionGain[faction]) then
			if (FIZ_FactionGain[faction][standingId]) then

				-- quests (may have items)
				if (FIZ_FactionGain[faction][standingId].quests) then
					for i = 0, FIZ_FactionGain[faction][standingId].quests.count do
						if (not FIZ_FactionGain[faction][standingId].quests.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].quests.data[i].limit)) then
							local toDo = ceil(repToNext / FIZ_FactionGain[faction][standingId].quests.data[i].rep)
							if (FIZ_FactionGain[faction][standingId].quests.data[i].limit) then
								toDo = ceil((FIZ_FactionGain[faction][standingId].quests.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].quests.data[i].rep)
							end

							if (FIZ_FactionGain[faction][standingId].quests.data[i].items) then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(FIZ_FactionGain[faction][standingId].quests.data[i].items) do
									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= FIZ_FactionGain[faction][standingId].quests.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].quests.data[i].items[item] > 0)) then
											local localCurrentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FactionGain[faction][standingId].quests.data[i].items[item])
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = localCurrentTimesBag
											else
												-- some items already set
												if (localCurrentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = localCurrentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
										end
										if (FIZ_Data.Bank and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= FIZ_FactionGain[faction][standingId].quests.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].quests.data[i].items[item] > 0)) then
												local localCurrentTimesBagBank = floor(total / FIZ_FactionGain[faction][standingId].quests.data[i].items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = localCurrentTimesBagBank
												else
													-- some items already set
													if (localCurrentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = localCurrentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
											end
										else
											-- none of this carried in bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
								end
								if (currentQuestTimesBag > toDo) then
									currentQuestTimesBag = toDo
								end
								if (currentQuestTimesBagBank > toDo) then
									currentQuestTimesBagBank = toDo
								end
								if (currentQuestTimesBagBank > 0) then
									result = result + currentQuestTimesBagBank * FIZ_FactionGain[faction][standingId].quests.data[i].rep
								elseif (currentQuestTimesBag > 0) then
									result = result + currentQuestTimesBag * FIZ_FactionGain[faction][standingId].quests.data[i].rep
								else
									-- nothing to add
								end
							else
								-- no items, check if this quest is completed
								local entries, quests = GetNumQuestLogEntries()
								for z=1,entries do
									local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
									if (title and not header and complete) then
										if string.find(string.lower(FIZ_FactionGain[faction][standingId].quests.data[i].name), string.lower(title)) then
											-- this quest matches
											result = result + FIZ_FactionGain[faction][standingId].quests.data[i].rep
										end
									end
								end
							end
						end
					end
				end

				-- items
				if (FIZ_FactionGain[faction][standingId].items and FIZ_Data.ShowItems) then
					for i = 0, FIZ_FactionGain[faction][standingId].items.count do
						if (not FIZ_FactionGain[faction][standingId].items.data[i].limit or (normCurrent < FIZ_FactionGain[faction][standingId].items.data[i].limit)) then
							local toDo = ceil(repToNext / FIZ_FactionGain[faction][standingId].items.data[i].rep)
							if (FIZ_FactionGain[faction][standingId].items.data[i].limit) then
								toDo = ceil((FIZ_FactionGain[faction][standingId].items.data[i].limit - normCurrent) / FIZ_FactionGain[faction][standingId].items.data[i].rep)
							end
							if (FIZ_FactionGain[faction][standingId].items.data[i].items) then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(FIZ_FactionGain[faction][standingId].items.data[i].items) do
									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= FIZ_FactionGain[faction][standingId].items.data[i].items[item]) and (FIZ_FactionGain[faction][standingId].items.data[i].items[item] > 0)) then
											local localCurrentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FactionGain[faction][standingId].items.data[i].items[item])
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = localCurrentTimesBag
											else
												-- some items already set
												if (localCurrentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = localCurrentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
										end
										if (FIZ_Data.Bank and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= FIZ_FactionGain[faction][standingId].itemsdata[i].items[item]) and (FIZ_FactionGain[faction][standingId].items.data[i].items[item] > 0)) then
												local localCurrentTimesBagBank = floor(total / FIZ_FactionGain[faction][standingId].items.data[i].items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = localCurrentTimesBagBank
												else
													-- some items already set
													if (localCurrentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = localCurrentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..total.."x]"
											end
										else
											-- none of this carried in bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
								end
								if (currentQuestTimesBag > toDo) then
									currentQuestTimesBag = toDo
								end
								if (currentQuestTimesBagBank > toDo) then
									currentQuestTimesBagBank = toDo
								end
								if (currentQuestTimesBagBank > 0) then
									result = result + currentQuestTimesBagBank * FIZ_FactionGain[faction][standingId].items.data[i].rep
								elseif (currentQuestTimesBag > 0) then
									result = result + currentQuestTimesBag * FIZ_FactionGain[faction][standingId].items.data[i].rep
								end
							end
						end
					end
				end
			end
		end
	end

	return result;
end

-----------------------------------
-- _16_ Listing by standing
-----------------------------------
function FIZ_ListByStanding(standing)
	local numFactions = GetNumFactions();
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, hasRep, isCollapsed, isWatched;
	local list = {}

	-- get factions by standing
	for i=1, numFactions do
		name, description, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep = GetFactionInfo(i)
		--if (not isHeader) then
		if (not isHeader or hasRep) then
			if ((standing == nil) or (standing==standingID)) then
				if (not list[standingID]) then
					list[standingID] = {}
				end
				list[standingID][name]={}
				list[standingID][name].max = barMax-barMin
				list[standingID][name].value = barValue-barMin
			end
		end
	end

	-- output
	for i=1, 8 do
		if (list[i]) then
			FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_RGBToColour_perc(1, FACTION_BAR_COLORS[i].r, FACTION_BAR_COLORS[i].g, FACTION_BAR_COLORS[i].b).."--- "..getglobal("FACTION_STANDING_LABEL"..i).." ("..i..") ---|r")
			for p in pairs(list[i]) do
				--FIZ_Print("    "..p..": "..list[i][p].value.."/"..list[i][p].max.." ("..FIZ_TXT.missing2..": "..list[i][p].max-list[i][p].value..")")
				FIZ_Print("    "..p..": "..FIZ_TXT.missing2..": "..list[i][p].max-list[i][p].value)
			end
			if (not standing) then
				FIZ_Print(" ")
			end
		end
	end
end

-----------------------------------
-- _17_ List german names
-----------------------------------
FIZ_STANDING_DE = {}
FIZ_STANDING_DE[0] = "Unbekannt"
FIZ_STANDING_DE[1] = "Hasserf\195\188llt"
FIZ_STANDING_DE[2] = "Feindselig"
FIZ_STANDING_DE[3] = "Unfreundlich"
FIZ_STANDING_DE[4] = "Neutral"
FIZ_STANDING_DE[5] = "Freundlich"
FIZ_STANDING_DE[6] = "Wohlwollend"
FIZ_STANDING_DE[7] = "Respektvoll"
FIZ_STANDING_DE[8] = "Ehrf\195\188rchtig"

function FIZ_ShowGerman(standing)
	local en,de,color,min,max
	min=1
	max=8
	if ((standing ~= nil) and (standing<=8)) then
		min=standing
		max=standing
	end
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r German standing names:")
	for i=min,max do
		en = getglobal("FACTION_STANDING_LABEL"..i)
		de = FIZ_STANDING_DE[i]
		color = FACTION_BAR_COLORS[i]
		FIZ_Print("  "..FIZ_RGBToColour_perc(1,color.r,color.g,color.b)..i..": "..en.." = "..de)
	end
end

--------------------------
-- _18_ urbin addon listing
--------------------------
function FIZ_RegisterUrbinAddon(name, about)
	if (not name) then
		return
	end
	if (not URBIN_AddonList) then
		URBIN_AddonList = {}
	end
	URBIN_AddonList[name] = {}
	URBIN_AddonList[name].name = name
	URBIN_AddonList[name].about = about
end

function FIZ_ListUrbinAddons(name)
	if (not URBIN_AddonList) then
		return
	end

	local addons = ""
	for p in pairs(URBIN_AddonList) do
		if (URBIN_AddonList[p].name ~= name) then
			if (addons ~= "") then
				addons = addons..", "
			end
			addons = addons..URBIN_AddonList[p].name
		end
	end

	if (addons ~= "") then
		FIZ_Print(" ", true);
		FIZ_Print("  "..FIZ_TXT.urbin..": "..FIZ_HELP_COLOUR..addons.."|r", true);
	end
end

function FIZ_ListUrbinAddonDetails()
	for p in pairs(URBIN_AddonList) do
		if (URBIN_AddonList[p].about) then
			URBIN_AddonList[p].about(true)
		end
	end
end

--------------------------
-- _19_ sso phase handling
--------------------------
function FIZ_SetSSOPhase(phase)
	if (phase and phase >= 1 and phase <=5) then
		if (phase == 5) then
			FIZ_Data.SSO[FIZ_Realm].phase = 4
			FIZ_Data.SSO[FIZ_Realm].phase4b = 2
			FIZ_Data.SSO[FIZ_Realm].phase4c = 2
			FIZ_Data.SSO[FIZ_Realm].phase3b = 2
			FIZ_Data.SSO[FIZ_Realm].phase2b = 2
		else
			FIZ_Data.SSO[FIZ_Realm].phase = phase
			if (phase <4) then
				FIZ_Data.SSO[FIZ_Realm].phase4b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4c = 0
			else
				if (not FIZ_Data.SSO[FIZ_Realm].phase4b or (FIZ_Data.SSO[FIZ_Realm].phase4b == 0)) then
					FIZ_Data.SSO[FIZ_Realm].phase4b = 1
				end
				if (not FIZ_Data.SSO[FIZ_Realm].phase4c or (FIZ_Data.SSO[FIZ_Realm].phase4c == 0)) then
					FIZ_Data.SSO[FIZ_Realm].phase4c = 1
				end
			end
			if (phase <3) then
				FIZ_Data.SSO[FIZ_Realm].phase3b = 0
			else
				if (not FIZ_Data.SSO[FIZ_Realm].phase3b or (FIZ_Data.SSO[FIZ_Realm].phase3b == 0)) then
					FIZ_Data.SSO[FIZ_Realm].phase3b = 1
				end
			end
			if (phase <2) then
				FIZ_Data.SSO[FIZ_Realm].phase2b = 0
			else
				if (not FIZ_Data.SSO[FIZ_Realm].phase2b or (FIZ_Data.SSO[FIZ_Realm].phase2b == 0)) then
					FIZ_Data.SSO[FIZ_Realm].phase2b = 1
				end
			end
		end
	else
		FIZ_Data.SSO[FIZ_Realm].phase = 0
		FIZ_Data.SSO[FIZ_Realm].phase2b = nil
		FIZ_Data.SSO[FIZ_Realm].phase3b = nil
		FIZ_Data.SSO[FIZ_Realm].phase4b = nil
		FIZ_Data.SSO[FIZ_Realm].phase4c = nil
	end

	FIZ_SSOPhaseStatus()
end

function FIZ_SetSSOPhase2b(state)
	if (FIZ_Data.SSO[FIZ_Realm].phase) then
		if (state >= 0 and state <= 2) then
			if (FIZ_Data.SSO[FIZ_Realm].phase >= 2) then
				FIZ_Data.SSO[FIZ_Realm].phase2b = state
			else
				FIZ_Data.SSO[FIZ_Realm].phase2b = 0
				FIZ_Data.SSO[FIZ_Realm].phase3b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4c = 0
			end
		else
			FIZ_Data.SSO[FIZ_Realm].phase2b = 0
		end
	else
		FIZ_Data.SSO[FIZ_Realm].phase = 0
		FIZ_Data.SSO[FIZ_Realm].phase2b = 0
		FIZ_Data.SSO[FIZ_Realm].phase3b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4c = 0
	end

	FIZ_SSOPhaseStatus()
end

function FIZ_SetSSOPhase3b(state)
	if (FIZ_Data.SSO[FIZ_Realm].phase) then
		if (state >= 0 and state <= 2) then
			if (FIZ_Data.SSO[FIZ_Realm].phase >= 3) then
				FIZ_Data.SSO[FIZ_Realm].phase3b = state
			else
				FIZ_Data.SSO[FIZ_Realm].phase3b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4c = 0
			end
		else
			FIZ_Data.SSO[FIZ_Realm].phase3b = 0
		end
	else
		FIZ_Data.SSO[FIZ_Realm].phase = 0
		FIZ_Data.SSO[FIZ_Realm].phase2b = 0
		FIZ_Data.SSO[FIZ_Realm].phase3b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4c = 0
	end

	FIZ_SSOPhaseStatus()
end

function FIZ_SetSSOPhase4b(state)
	if (FIZ_Data.SSO[FIZ_Realm].phase) then
		if (state >= 0 and state <= 2) then
			if (FIZ_Data.SSO[FIZ_Realm].phase >= 4) then
				FIZ_Data.SSO[FIZ_Realm].phase4b = state
			else
				FIZ_Data.SSO[FIZ_Realm].phase4b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4c = 0
			end
		else
			FIZ_Data.SSO[FIZ_Realm].phase4b = 0
		end
	else
		FIZ_Data.SSO[FIZ_Realm].phase = 0
		FIZ_Data.SSO[FIZ_Realm].phase2b = 0
		FIZ_Data.SSO[FIZ_Realm].phase3b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4c = 0
	end

	FIZ_SSOPhaseStatus()
end

function FIZ_SetSSOPhase4c(state)
	if (FIZ_Data.SSO[FIZ_Realm].phase) then
		if (state >= 0 and state <= 2) then
			if (FIZ_Data.SSO[FIZ_Realm].phase >= 4) then
				FIZ_Data.SSO[FIZ_Realm].phase4c = state
			else
				FIZ_Data.SSO[FIZ_Realm].phase4b = 0
				FIZ_Data.SSO[FIZ_Realm].phase4c = 0
			end
		else
			FIZ_Data.SSO[FIZ_Realm].phase4c = 0
		end
	else
		FIZ_Data.SSO[FIZ_Realm].phase = 0
		FIZ_Data.SSO[FIZ_Realm].phase2b = 0
		FIZ_Data.SSO[FIZ_Realm].phase3b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4b = 0
		FIZ_Data.SSO[FIZ_Realm].phase4c = 0
	end

	FIZ_SSOPhaseStatus()
end

function FIZ_SSOPhaseStatus()
	local main_phase = FIZ_TXT.sso_unknown
	local phase2b = FIZ_TXT.sso_unknown
	local phase3b = FIZ_TXT.sso_unknown
	local phase4b = FIZ_TXT.sso_unknown
	local phase4c = FIZ_TXT.sso_unknown

	if (FIZ_Data.SSO[FIZ_Realm].phase) then
		if (FIZ_Data.SSO[FIZ_Realm].phase == 1) then
			main_phase = FIZ_TXT.phase1
		elseif (FIZ_Data.SSO[FIZ_Realm].phase == 2) then
			main_phase = FIZ_TXT.phase2
		elseif (FIZ_Data.SSO[FIZ_Realm].phase == 3) then
			main_phase = FIZ_TXT.phase3
		elseif (FIZ_Data.SSO[FIZ_Realm].phase == 4) then
			main_phase = FIZ_TXT.phase4
		end
	end

	if (FIZ_Data.SSO[FIZ_Realm].phase2b) then
		if (FIZ_Data.SSO[FIZ_Realm].phase2b ==0) then
			phase2b = FIZ_TXT.phase2bWaiting
		elseif (FIZ_Data.SSO[FIZ_Realm].phase2b ==1) then
			phase2b = FIZ_TXT.phase2bActive
		elseif (FIZ_Data.SSO[FIZ_Realm].phase2b ==2) then
			phase2b = FIZ_TXT.phase2bDone
		end
	end

	if (FIZ_Data.SSO[FIZ_Realm].phase3b) then
		if (FIZ_Data.SSO[FIZ_Realm].phase3b ==0) then
			phase3b = FIZ_TXT.phase3bWaiting
		elseif (FIZ_Data.SSO[FIZ_Realm].phase3b ==1) then
			phase3b = FIZ_TXT.phase3bActive
		elseif (FIZ_Data.SSO[FIZ_Realm].phase3b ==2) then
			phase3b = FIZ_TXT.phase3bDone
		end
	end

	if (FIZ_Data.SSO[FIZ_Realm].phase4b) then
		if (FIZ_Data.SSO[FIZ_Realm].phase4b ==0) then
			phase4b = FIZ_TXT.phase4Waiting
		elseif (FIZ_Data.SSO[FIZ_Realm].phase4b ==1) then
			phase4b = FIZ_TXT.phase4bActive
		elseif (FIZ_Data.SSO[FIZ_Realm].phase4b ==2) then
			phase4b = FIZ_TXT.phase4bDone
		end
	end

	if (FIZ_Data.SSO[FIZ_Realm].phase4c) then
		if (FIZ_Data.SSO[FIZ_Realm].phase4c ==0) then
			phase4c = FIZ_TXT.phase4Waiting
		elseif (FIZ_Data.SSO[FIZ_Realm].phase4c ==1) then
			phase4c = FIZ_TXT.phase4cActive
		elseif (FIZ_Data.SSO[FIZ_Realm].phase4c ==2) then
			phase4c = FIZ_TXT.phase4cDone
		end
	end

	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.sso_status.." ["..FIZ_Realm.."]")
	FIZ_Print("   "..FIZ_HELP_COLOUR..FIZ_TXT.sso_main..":|r "..main_phase)
	FIZ_Print("   "..FIZ_HELP_COLOUR..FIZ_TXT.sso_phase2b..":|r "..phase2b)
	FIZ_Print("   "..FIZ_HELP_COLOUR..FIZ_TXT.sso_phase3b..":|r "..phase3b)
	FIZ_Print("   "..FIZ_HELP_COLOUR..FIZ_TXT.sso_phase4b..":|r "..phase4b)
	FIZ_Print("   "..FIZ_HELP_COLOUR..FIZ_TXT.sso_phase4c..":|r "..phase4c)
end

function FIZ_SSOWarning(name)
	name = string.lower(name)
	if (FIZ_FactionMapping[name]) then
		name = FIZ_FactionMapping[name]
	end

	if (name == "shattered sun offensive" and not FIZ_SSO_WARNED) then
		if (not FIZ_Data.SSO[FIZ_Realm].phase or FIZ_Data.SSO[FIZ_Realm].phase == 0) then
			FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_ERROR_COLOUR..FIZ_TXT.sso_warning)
		end
		FIZ_SSO_WARNED = true
	end
end

--------------------------
-- _20_ sso phase handling UI glue
--------------------------
-- todo

--------------------------
-- _21_ extracting skill information
--------------------------
function FIZ_ExtractSkills()
	FIZ_Herb = false
	FIZ_Skin = false
	FIZ_Mine = false
	FIZ_Jewel = false
	FIZ_Cook = false

	for skillIndex = 1, GetNumSkillLines() do
		skillName = GetSkillLineInfo(skillIndex)
		if isHeader == nil then
			if (skillName == FIZ_TXT.skillHerb) then
				FIZ_Herb = true
			elseif (skillName == FIZ_TXT.skillSkin) then
				FIZ_Skin = true
			elseif (skillName == FIZ_TXT.skillMine) then
				FIZ_Mine = true
			elseif (skillName == FIZ_TXT.skillJewel) then
				FIZ_Jewel = true
			elseif (skillName == FIZ_TXT.skillCook) then
				FIZ_Cook = true
			-- todo: add other secondary and crafting professions if needed
			--else
			end
		end
	end
end

--------------------------
-- _22_ extracting skill information
--------------------------
function FIZ_UpdateChatFrame()
	if not FIZ_updatingChatFrame then
		FIZ_updatingChatFrame = true

		-- Store the new value
		FIZ_Data.ChatFrame = FIZ_ChatFrameSlider:GetValue()

		-- Update display
		if (FIZ_Data.ChatFrame == 0) then
			FIZ_ChatFrameText:SetText(FIZ_TXT.defaultChatFrame)
			FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.usingDefaultChatFrame)
		else
			local name, fontSize, r, g, b, alpha, shown, locked, docked = GetChatWindowInfo(FIZ_Data.ChatFrame)
			if (not name or name == "") then
				name = "Tab does not exist"
			end
			FIZ_ChatFrameText:SetText(string.format(FIZ_TXT.chatFrame, FIZ_Data.ChatFrame, name))
			FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.usingChatFrame.." "..FIZ_Data.ChatFrame.." ("..name..")")
		end

		FIZ_updatingChatFrame = nil
	end
end