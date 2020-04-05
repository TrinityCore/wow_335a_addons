--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaQuest", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Quest"
AJM.settingsDatabaseName = "JambaQuestProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-quest"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Quest"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		mirrorMasterQuestSelectionAndDeclining = true,
		acceptQuests = true,
		slaveMirrorMasterAccept = true,
		allAutoSelectQuests = false,
		doNotAutoAccept = true,
		allAcceptAnyQuest = false,
		onlyAcceptQuestsFrom = false,
		acceptFromTeam = false,
		acceptFromNpc = false,
		acceptFromFriends = false,
		acceptFromParty = false,
		acceptFromRaid = false,
		acceptFromGuild = false,
		masterAutoShareQuestOnAccept = false,
		slaveAutoAcceptEscortQuest = true,
		showJambaQuestLogWithWoWQuestLog = true,
		enableAutoQuestCompletion = true,
		noChoiceAllDoNothing = false,
		noChoiceSlaveCompleteQuestWithMaster = true,
		noChoiceAllAutoCompleteQuest = false,
		hasChoiceSlaveDoNothing = false,
		hasChoiceSlaveCompleteQuestWithMaster = true,
		hasChoiceSlaveChooseSameRewardAsMaster = false,
		hasChoiceSlaveMustChooseOwnReward = true,
		hasChoiceSlaveRewardChoiceModifierConditional = false,
		hasChoiceAquireBestQuestRewardForCharacter = false,
		hasChoiceCtrlKeyModifier = false,
		hasChoiceShiftKeyModifier = false,
		hasChoiceAltKeyModifier = false,
		hasChoiceOverrideUseSlaveRewardSelected = true,
		messageArea = JambaApi.DefaultMessageArea(),
		warningArea = JambaApi.DefaultWarningArea(),
		framePoint = "CENTER",
		frameRelativePoint = "CENTER",
		frameXOffset = 0,
		frameYOffset = 0,
		overrideQuestAutoSelectAndComplete = false,
		enableQuestWatcher = true,
		watcherFramePoint = "CENTER",
		watcherFrameRelativePoint = "CENTER",
		watcherFrameXOffset = 0,
		watcherFrameYOffset = 0,
		watcherFrameAlpha = 1.0,
		watcherFrameScale = 1.0,
		borderStyle = L["Blizzard Tooltip"],
		backgroundStyle = L["Blizzard Dialog Background"],
		hideQuestWatcherInCombat = false,
		enableQuestWatcherOnMasterOnly = false,
		watchFrameBackgroundColourR = 0.0,
		watchFrameBackgroundColourG = 0.0,
		watchFrameBackgroundColourB = 0.0,
		watchFrameBackgroundColourA = 0.0,
		watchFrameBorderColourR = 0.0,
		watchFrameBorderColourG = 0.0,
		watchFrameBorderColourB = 0.0,
		watchFrameBorderColourA = 0.0,
		watcherListLines = 20,
		watcherFrameWidth = 300,
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = "group",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			autoselect = 
			{
				type = "input",
				name = L["Set The Auto Select Functionality"],
				desc = L["Set the auto select functionality."],
				usage = "/jamba-quest autoselect <on|off|toggle> <tag>",
				get = false,
				set = "AutoSelectToggleCommand",
			},
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the quest settings to all characters in the team."],
				usage = "/jamba-quest push",
				get = false,
				set = "JambaSendSettings",
			},	
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_SELECT_GOSSIP_OPTION = "SelectGossipOption"
AJM.COMMAND_SELECT_GOSSIP_ACTIVE_QUEST = "SelectGossipActiveQuest"
AJM.COMMAND_SELECT_GOSSIP_AVAILABLE_QUEST = "SelectGossipAvailableQuest"
AJM.COMMAND_SELECT_ACTIVE_QUEST = "SelectActiveQuest"
AJM.COMMAND_SELECT_AVAILABLE_QUEST = "SelectAvailableQuest"
AJM.COMMAND_ACCEPT_QUEST = "AcceptQuest"
AJM.COMMAND_COMPLETE_QUEST = "CompleteQuest"
AJM.COMMAND_CHOOSE_QUEST_REWARD = "ChooseQuestReward"
AJM.COMMAND_DECLINE_QUEST = "DeclineQuest"
AJM.COMMAND_SELECT_QUEST_LOG_ENTRY = "SelectQuestLogEntry"
AJM.COMMAND_QUEST_TRACK = "QuestTrack"
AJM.COMMAND_ABANDON_QUEST = "AbandonQuest"
AJM.COMMAND_ABANDON_ALL_QUESTS = "AbandonAllQuests"
AJM.COMMAND_TOGGLE_AUTO_SELECT = "ToggleAutoSelect"
AJM.COMMAND_QUEST_WATCH_OBJECTIVE_UPDATE = "QuestWatchObjectiveUpdate"
AJM.COMMAND_UPDATE_QUEST_WATCHER_LIST = "QuestWatchListUpdate"
AJM.COMMAND_QUEST_WATCH_REMOVE_QUEST = "QuestWatchRemoveQuest"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

local function DebugMessage( ... )
	--AJM:Print( ... )
end

-- Initialise the module.
function AJM:OnInitialize()
	AJM.questWatcherFrameCreated = false
	-- Create the settings control.
	AJM:SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Create the Jamba Quest Log frame.
	AJM.currentlySelectedQuest =  L["(No Quest Selected)"]
	AJM.jambaQuestLogFrame = nil
	AJM:CreateJambaQuestLogFrame()
	-- Create the quest watcher frame.
	AJM:CreateQuestWatcherFrame()
	AJM:SetQuestWatcherVisibility()		
	-- An empty table to hold the available and active quests at an npc.
	AJM.gossipQuests = {}
	-- Quest watcher.
	AJM.questWatchListOfQuests = {}
	AJM.questWatchCache = {}
	AJM.questWatchObjectivesList = {}
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- No internal commands active.
	AJM.isInternalCommand = false
	-- Register for the Jamba master changed message.
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_MASTER_CHANGED, "OnMasterChanged" )
    -- Quest events.
	AJM:RegisterEvent( "QUEST_ACCEPTED" )
    AJM:RegisterEvent( "QUEST_DETAIL" )
    AJM:RegisterEvent( "QUEST_COMPLETE" )
    AJM:RegisterEvent( "QUEST_ACCEPT_CONFIRM" )
	AJM:RegisterEvent( "GOSSIP_SHOW" )
	AJM:RegisterEvent( "QUEST_GREETING" )
	AJM:RegisterEvent( "QUEST_PROGRESS" )
	-- Watcher events.
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	--AJM:RegisterEvent( "ITEM_PUSH" )
	AJM:RegisterEvent( "QUEST_WATCH_UPDATE" )	
    -- Quest post hooks.
    AJM:SecureHook( "SelectGossipOption" )
    AJM:SecureHook( "SelectGossipActiveQuest" )
    AJM:SecureHook( "SelectGossipAvailableQuest" )
    AJM:SecureHook( "SelectActiveQuest" )
    AJM:SecureHook( "SelectAvailableQuest" )
    AJM:SecureHook( "AcceptQuest" )
    AJM:SecureHook( "CompleteQuest" )
    AJM:SecureHook( "DeclineQuest" )
	AJM:SecureHook( "GetQuestReward" )
	AJM:SecureHook( "ToggleFrame" )
	AJM:SecureHook( QuestLogFrame, "Hide", "QuestLogFrameHide" )
	AJM:SecureHook( "SelectQuestLogEntry" )
	AJM:SecureHook( "AddQuestWatch" )
	AJM:SecureHook( "RemoveQuestWatch" )
	AJM:SecureHook( "AbandonQuest" )
	AJM:SecureHook( "SetAbandonQuest" )
	-- Update the quest watcher for watched quests.
	AJM:ScheduleTimer( "JambaQuestWatcherUpdate", 1, false )	
end

-- Called when the addon is disabled.
function AJM:OnDisable()
	-- AceHook-3.0 will tidy up the hooks for us. 
end

-------------------------------------------------------------------------------------------------------------
-- Messages.
-------------------------------------------------------------------------------------------------------------

function AJM:OnMasterChanged( message, characterName )
	AJM:SetQuestWatcherVisibility()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsCreate()
	AJM.settingsControl = {}
	AJM.settingsControlCompletion = {}
	AJM.settingsControlWatcher = {}
	-- Create the settings panels.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlCompletion, 
		AJM.moduleDisplayName..L[": "]..L["Completion"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlWatcher, 
		AJM.moduleDisplayName..L[": "]..L["Watcher"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)	
	-- Create the quest controls.
	local bottomOfQuestOptions = AJM:SettingsCreateQuestControl( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfQuestOptions )
	local bottomOfQuestCompletionOptions = AJM:SettingsCreateQuestCompletionControl( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlCompletion.widgetSettings.content:SetHeight( -bottomOfQuestCompletionOptions )
	local bottomOfQuestWatcherOptions = AJM:SettingsCreateQuestWatcherControl( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlWatcher.widgetSettings.content:SetHeight( -bottomOfQuestCompletionOptions )
end

function AJM:SettingsCreateQuestControl( top )
	-- Get positions and dimensions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local radioBoxHeight = JambaHelperSettings:GetRadioBoxHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local indent = horizontalSpacing * 10
	local indentContinueLabel = horizontalSpacing * 22
	local checkBoxThirdWidth = (headingWidth - indentContinueLabel) / 3
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local middle = left + halfWidth
	local column1Left = left
	local column1LeftIndent = left + indentContinueLabel
	local column2LeftIndent = column1LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local column3LeftIndent = column2LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local movingTop = top
	-- Create a heading for information.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, AJM.moduleDisplayName..L[" "]..L["Information"], movingTop, false )
	movingTop = movingTop - headingHeight
	-- Information line 1.
	AJM.settingsControlCompletion.labelQuestInformation1 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Jamba-Quest treats any team member as the Master."] 
	)	
	movingTop = movingTop - labelContinueHeight		
	-- Information line 2.
	AJM.settingsControlCompletion.labelQuestInformation2 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Quest actions by one character will be actioned by the other"] 
	)	
	movingTop = movingTop - labelContinueHeight		
	-- Information line 3.
	AJM.settingsControlCompletion.labelQuestInformation3 = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["characters regardless of who the Master is."] 
	)	
	movingTop = movingTop - labelContinueHeight				
	-- Create a heading for quest selection.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Quest Selection & Acceptance"], movingTop, false )
	movingTop = movingTop - headingHeight
	-- Radio box: Slave select, accept and decline quest with master.
	AJM.settingsControl.checkBoxMirrorMasterQuestSelectionAndDeclining = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Select & Decline Quest With Team"],
		AJM.SettingsToggleMirrorMasterQuestSelectionAndDeclining
	)	
	AJM.settingsControl.checkBoxMirrorMasterQuestSelectionAndDeclining:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Radio box: All auto select quests.
	AJM.settingsControl.checkBoxAllAutoSelectQuests = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["All Auto Select Quests"],
		AJM.SettingsToggleAllAutoSelectQuests
	)	
	AJM.settingsControl.checkBoxAllAutoSelectQuests:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Check box: Accept quests.
	AJM.settingsControl.checkBoxAcceptQuests = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Accept Quests"],
		AJM.SettingsToggleAcceptQuests
	)	
	movingTop = movingTop - checkBoxHeight		
	-- Radio box: Slave accept quest with master.
	AJM.settingsControl.checkBoxSlaveMirrorMasterAccept = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Toon Accept Quest From Team"],
		AJM.SettingsToggleSlaveMirrorMasterAccept
	)	
	movingTop = movingTop - checkBoxHeight		
	-- Radio box: All auto accept any quest.
	AJM.settingsControl.checkBoxDoNotAutoAccept = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Do Not Auto Accept Quests"],
		AJM.SettingsToggleDoNotAutoAccept
	)	
	AJM.settingsControl.checkBoxDoNotAutoAccept:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight		
	-- Radio box: All auto accept any quest.
	AJM.settingsControl.checkBoxAllAcceptAnyQuest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["All Auto Accept ANY Quest"],
		AJM.SettingsToggleAllAcceptAnyQuest
	)	
	AJM.settingsControl.checkBoxAllAcceptAnyQuest:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight		
	-- Radio box: Choose who to auto accept quests from.
	AJM.settingsControl.checkBoxOnlyAcceptQuestsFrom = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Only Auto Accept Quests From:"],
		AJM.SettingsToggleOnlyAcceptQuestsFrom
	)	
	AJM.settingsControl.checkBoxOnlyAcceptQuestsFrom:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Check box: Team.
	AJM.settingsControl.checkBoxAcceptFromTeam = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column1LeftIndent, 
		movingTop,
		L["Team"],
		AJM.SettingsToggleAcceptFromTeam
	)	
	-- Check box: NPC.
	AJM.settingsControl.checkBoxAcceptFromNpc = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column2LeftIndent, 
		movingTop,
		L["NPC"],
		AJM.SettingsToggleAcceptFromNpc
	)	
	-- Check box: Friends.
	AJM.settingsControl.checkBoxAcceptFromFriends = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column3LeftIndent, 
		movingTop,
		L["Friends"],
		AJM.SettingsToggleAcceptFromFriends
	)	
	movingTop = movingTop - checkBoxHeight
	-- Check box: Party.
	AJM.settingsControl.checkBoxAcceptFromParty = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column1LeftIndent, 
		movingTop,
		L["Party"],
		AJM.SettingsToggleAcceptFromParty
	)	
	-- Check box: Raid.
	AJM.settingsControl.checkBoxAcceptFromRaid = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column2LeftIndent, 
		movingTop,
		L["Raid"],
		AJM.SettingsToggleAcceptFromRaid
	)	
	-- Check box: Guild.
	AJM.settingsControl.checkBoxAcceptFromGuild = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		checkBoxThirdWidth, 
		column3LeftIndent, 
		movingTop,
		L["Guild"],
		AJM.SettingsToggleAcceptFromGuild
	)	
	movingTop = movingTop - checkBoxHeight
	-- Check box: Master auto share quest on accept.
	AJM.settingsControl.checkBoxMasterAutoShareQuestOnAccept = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Master Auto Share Quests When Accepted"],
		AJM.SettingsToggleMasterAutoShareQuestOnAccept
	)	
	movingTop = movingTop - checkBoxHeight			
	-- Check box: Slave auto accept escort quest from master.
	AJM.settingsControl.checkBoxSlaveAutoAcceptEscortQuest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Auto Accept Escort Quest From Team"],
		AJM.SettingsToggleSlaveAutoAcceptEscortQuest
	)	
	movingTop = movingTop - checkBoxHeight
	-- Create a heading for other options.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Other Options"], movingTop, false )
	movingTop = movingTop - headingHeight
	-- Check box: Override quest auto select and auto complete.
	AJM.settingsControl.checkBoxOverrideQuestAutoSelectAndComplete = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Hold Shift To Override Auto Select/Auto Complete"],
		AJM.SettingsToggleOverrideQuestAutoSelectAndComplete
	)	
	movingTop = movingTop - checkBoxHeight
	-- Check box: Show Jamba quest log with WoW quest log.
	AJM.settingsControl.checkBoxShowJambaQuestLogWithWoWQuestLog = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Show Jamba-Quest Log With WoW Quest Log"],
		AJM.SettingsToggleShowJambaQuestLogWithWoWQuestLog
	)	
	movingTop = movingTop - checkBoxHeight
	-- Message area.
	AJM.settingsControl.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Send Message Area"] 
	)
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - dropdownHeight
	-- Warning area.
	AJM.settingsControl.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Send Warning Area"] 
	)
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight
	return movingTop	
end

function AJM:SettingsCreateQuestCompletionControl( top )
	-- Get positions and dimensions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local radioBoxHeight = JambaHelperSettings:GetRadioBoxHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local indent = horizontalSpacing * 10
	local indentContinueLabel = horizontalSpacing * 18
	local indentSpecial = indentContinueLabel + 9
	local checkBoxThirdWidth = (headingWidth - indentContinueLabel) / 3
	local column1Left = left
	local column1LeftIndent = left + indentContinueLabel
	local column2LeftIndent = column1LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local column3LeftIndent = column2LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local movingTop = top
	-- Create a heading for quest completion.
	JambaHelperSettings:CreateHeading( AJM.settingsControlCompletion, L["Quest Completion"], movingTop, false )
	movingTop = movingTop - headingHeight
	-- Check box: Enable auto quest completion.
	AJM.settingsControlCompletion.checkBoxEnableAutoQuestCompletion = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Enable Auto Quest Completion"],
		AJM.SettingsToggleEnableAutoQuestCompletion
	)	
	movingTop = movingTop - checkBoxHeight
	-- Label: Quest has no rewards or one reward.	
	AJM.settingsControlCompletion.labelQuestNoRewardsOrOneReward = JambaHelperSettings:CreateLabel( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Quest Has No Rewards Or One Reward:"]
	)	
	movingTop = movingTop - labelHeight
	-- Radio box: No choice, slave do nothing.
	AJM.settingsControlCompletion.checkBoxNoChoiceAllDoNothing = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Do Nothing"],
		AJM.SettingsToggleNoChoiceAllDoNothing
	)	
	AJM.settingsControlCompletion.checkBoxNoChoiceAllDoNothing:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight	
	-- Radio box: No choice, slave complete quest with master.
	AJM.settingsControlCompletion.checkBoxNoChoiceSlaveCompleteQuestWithMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Complete Quest With Team"],
		AJM.SettingsToggleNoChoiceSlaveCompleteQuestWithMaster
	)
	AJM.settingsControlCompletion.checkBoxNoChoiceSlaveCompleteQuestWithMaster:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Radio box: No Choice, all automatically complete quest.
	AJM.settingsControlCompletion.checkBoxNoChoiceAllAutoCompleteQuest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["All Automatically Complete Quest"],
		AJM.SettingsToggleNoChoiceAllAutoCompleteQuest
	)	
	AJM.settingsControlCompletion.checkBoxNoChoiceAllAutoCompleteQuest:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Label: Quest has more than one reward.
	AJM.settingsControlCompletion.labelQuestHasMoreThanOneReward = JambaHelperSettings:CreateLabel( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Quest Has More Than One Reward:"]
	)	
	movingTop = movingTop - labelHeight
	-- Radio box: Has choice, slave do nothing.
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveDoNothing = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Do Nothing"],
		AJM.SettingsToggleHasChoiceSlaveDoNothing
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveDoNothing:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Radio box: Has choice, choose best reward.
	AJM.settingsControlCompletion.checkBoxHasChoiceAquireBestQuestRewardForCharacter = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Auto Chooses Best Reward"],
		AJM.SettingsToggleHasChoiceAquireBestQuestRewardForCharacter
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceAquireBestQuestRewardForCharacter:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight		
	-- Radio box: Has choice, slave complete quest with master.
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveCompleteQuestWithMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Toon Complete Quest With Team"],
		AJM.SettingsToggleHasChoiceSlaveCompleteQuestWithMaster
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveCompleteQuestWithMaster:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Radio box: Has choice, slave must choose own reward.
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveMustChooseOwnReward = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Toon Must Choose Own Reward"],
		AJM.SettingsToggleHasChoiceSlaveMustChooseOwnReward
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveMustChooseOwnReward:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight	
	-- Radio box: Has choice, slave choose same reward as master.
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveChooseSameRewardAsMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Toon Choose Same Reward As Team"],
		AJM.SettingsToggleHasChoiceSlaveChooseSameRewardAsMaster
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveChooseSameRewardAsMaster:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Radio box: Has choice, slave reward choice depends on modifier key pressed down.
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveRewardChoiceModifierConditional = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["If Modifier Keys Pressed, Toon Choose Same Reward"],
		AJM.SettingsToggleHasChoiceSlaveRewardChoiceModifierConditional
	)	
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveRewardChoiceModifierConditional:SetType( "radio" )
	movingTop = movingTop - radioBoxHeight
	-- Label continuing radio box above.
	AJM.settingsControlCompletion.labelHasChoiceSlaveRewardChoiceModifierConditional = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indentContinueLabel, 
		movingTop,
		L["As Team Otherwise Toon Must Choose Own Reward"]
	)	
	movingTop = movingTop - labelContinueHeight	
	-- Check box: Ctrl modifier key.
	AJM.settingsControlCompletion.checkBoxHasChoiceCtrlKeyModifier = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		checkBoxThirdWidth, 
		column1LeftIndent, 
		movingTop,
		L["Ctrl"],
		AJM.SettingsToggleHasChoiceCtrlKeyModifier
	)	
	-- Check box: Shift modifier key.
	AJM.settingsControlCompletion.checkBoxHasChoiceShiftKeyModifier = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		checkBoxThirdWidth, 
		column2LeftIndent, 
		movingTop,
		L["Shift"],
		AJM.SettingsToggleHasChoiceShiftKeyModifier
	)	
	-- Check box: Alt modifier key.
	AJM.settingsControlCompletion.checkBoxHasChoiceAltKeyModifier = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		checkBoxThirdWidth, 
		column3LeftIndent, 
		movingTop,
		L["Alt"],
		AJM.SettingsToggleHasChoiceAltKeyModifier
	)	
	movingTop = movingTop - checkBoxHeight
	-- Check box: Has choice, override, if slave already has reward selected, choose that reward.
	AJM.settingsControlCompletion.checkBoxHasChoiceOverrideUseSlaveRewardSelected = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indent, 
		movingTop,
		L["Override: If Toon Already Has Reward Selected,"],
		AJM.SettingsToggleHasChoiceOverrideUseSlaveRewardSelected
	)	
	movingTop = movingTop - checkBoxHeight
	-- Label continuing check box above.
	AJM.settingsControlCompletion.labelHasChoiceOverrideUseSlaveRewardSelected = JambaHelperSettings:CreateContinueLabel( 
		AJM.settingsControlCompletion, 
		headingWidth, 
		column1Left + indentSpecial, 
		movingTop,
		L["Choose That Reward"]
	)	
	movingTop = movingTop - labelContinueHeight	
	return movingTop	
end

function AJM:SettingsCreateQuestWatcherControl( top )
	-- Get positions and dimensions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local radioBoxHeight = JambaHelperSettings:GetRadioBoxHeight()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local labelContinueHeight = JambaHelperSettings:GetContinueLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidthSlider = (headingWidth - horizontalSpacing) / 2
	local indent = horizontalSpacing * 10
	local indentContinueLabel = horizontalSpacing * 18
	local indentSpecial = indentContinueLabel + 9
	local checkBoxThirdWidth = (headingWidth - indentContinueLabel) / 3
	local column1Left = left
	local column1LeftIndent = left + indentContinueLabel
	local column2LeftIndent = column1LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local column3LeftIndent = column2LeftIndent + checkBoxThirdWidth + horizontalSpacing
	local movingTop = top
	-- Create a heading for quest completion.
	JambaHelperSettings:CreateHeading( AJM.settingsControlWatcher, L["Quest Watcher"], movingTop, false )
	movingTop = movingTop - headingHeight
	-- Check box: Enable auto quest completion.
	AJM.settingsControlWatcher.checkBoxEnableQuestWatcher = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Enable Team Quest Watcher"],
		AJM.SettingsToggleEnableQuestWatcher
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWatcher.checkBoxEnableQuestWatcherMasterOnly = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Show Team Quest Watcher On Master Only"],
		AJM.SettingsToggleEnableQuestWatcherMasterOnly
	)	
	movingTop = movingTop - checkBoxHeight	
	AJM.settingsControlWatcher.displayOptionsCheckBoxHideQuestWatcherInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Hide Quest Watcher In Combat"],
		AJM.SettingsToggleHideQuestWatcherInCombat
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControlWatcher.displayOptionsQuestWatcherLinesSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Lines Of Info To Display (Reload UI To See Change)"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherLinesSlider:SetSliderValues( 5, 50, 1 )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherLinesSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeWatchLines )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControlWatcher.displayOptionsQuestWatcherFrameWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Quest Watcher Width (Reload UI To See Change)"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherFrameWidthSlider:SetSliderValues( 250, 600, 5 )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherFrameWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeWatchFrameWidth )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBorder = JambaHelperSettings:CreateMediaBorder( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Border Style"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBorder:SetCallback( "OnValueChanged", AJM.SettingsChangeBorderStyle )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControlWatcher.questWatchBorderColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControlWatcher,
		headingWidth,
		column1Left,
		movingTop,
		L["Border Colour"]
	)
	AJM.settingsControlWatcher.questWatchBorderColourPicker:SetHasAlpha( true )
	AJM.settingsControlWatcher.questWatchBorderColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsQuestWatchBorderColourPickerChanged )
	movingTop = movingTop - checkBoxHeight - verticalSpacing	
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBackground = JambaHelperSettings:CreateMediaBackground( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Background"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBackground:SetCallback( "OnValueChanged", AJM.SettingsChangeBackgroundStyle )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControlWatcher.questWatchBackgroundColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControlWatcher,
		headingWidth,
		column1Left,
		movingTop,
		L["Background Colour"]
	)
	AJM.settingsControlWatcher.questWatchBackgroundColourPicker:SetHasAlpha( true )
	AJM.settingsControlWatcher.questWatchBackgroundColourPicker:SetCallback( "OnValueConfirmed", AJM.SettingsQuestWatchBackgroundColourPickerChanged )
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControlWatcher.displayOptionsQuestWatcherScaleSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Scale"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherScaleSlider:SetSliderValues( 0.5, 2, 0.01 )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherScaleSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeScale )
	movingTop = movingTop - sliderHeight - verticalSpacing	
	AJM.settingsControlWatcher.displayOptionsQuestWatcherTransparencySlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControlWatcher, 
		headingWidth, 
		column1Left, 
		movingTop, 
		L["Transparency"]
	)
	AJM.settingsControlWatcher.displayOptionsQuestWatcherTransparencySlider:SetSliderValues( 0, 1, 0.01 )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherTransparencySlider:SetCallback( "OnValueChanged", AJM.SettingsChangeTransparency )
	movingTop = movingTop - sliderHeight - verticalSpacing		
end

-------------------------------------------------------------------------------------------------------------
-- Watcher frame.
-------------------------------------------------------------------------------------------------------------

local function CanDisplayQuestWatcher()
	local canShow = false
	if AJM.db.enableQuestWatcher == true then
		if AJM.db.enableQuestWatcherOnMasterOnly == true then
			if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
				if AJM:CountLinesInQuestWatchList() > 0 then
					canShow = true
				end	
			end
		else
			if AJM:CountLinesInQuestWatchList() > 0 then
				canShow = true
			end	
		end
	end
	return canShow
end

function AJM:CreateQuestWatcherFrame()
	-- The frame.
	local frame = CreateFrame( "Frame", "JambaQuestWatcherWindowFrame", UIParent )
	frame.obj = AJM
	frame:SetFrameStrata( "LOW" )
	frame:SetToplevel( true )
	frame:SetClampedToScreen( true )
	frame:EnableMouse()
	frame:SetMovable( true )	
	frame:RegisterForDrag( "LeftButton" )
	frame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() == 1 then
				this:StartMoving() 
			end
		end )
	frame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.watcherFramePoint = point
			AJM.db.watcherFrameRelativePoint = relativePoint
			AJM.db.watcherFrameXOffset = xOffset
			AJM.db.watcherFrameYOffset = yOffset
		end	)	
	frame:ClearAllPoints()
	frame:SetPoint( AJM.db.watcherFramePoint, UIParent, AJM.db.watcherFrameRelativePoint, AJM.db.watcherFrameXOffset, AJM.db.watcherFrameYOffset )
	frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, tileSize = 10, edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	-- Create the title for the team list frame.
	local titleName = frame:CreateFontString( "JambaQuestWatcherWindowFrameTitleText", "OVERLAY", "GameFontNormal" )
	titleName:SetPoint( "TOPLEFT", frame, "TOPLEFT", 7, -7 )
	titleName:SetTextColor( 1.00, 1.00, 1.00 )
	titleName:SetText( L["Jamba Quest Watcher"] )
	frame.titleName = titleName
	-- Update button.
	local updateButton = CreateFrame( "Button", "JambaQuestWatcherWindowFrameButtonUpdate", frame, "UIPanelButtonGrayTemplate" )
	updateButton:SetScript( "OnClick", AJM.JambaQuestWatchListUpdateButtonClicked )
	updateButton:SetPoint( "TOPRIGHT", frame, "TOPRIGHT", -5, -4 )
	updateButton:SetHeight( 20 )
	updateButton:SetWidth( 100 )
	updateButton:SetText( L["Update"] )		
	-- Set transparency of the the frame (and all its children).
	frame:SetAlpha( AJM.db.watcherFrameAlpha )
	-- List.
	local topOfList = -24
	local list = {}
	list.listFrameName = "JambaQuestWatcherQuestListFrame"
	list.parentFrame = frame
	list.listTop = topOfList
	list.listLeft = 2
	list.listWidth = AJM.db.watcherFrameWidth
	list.rowHeight = 16
	list.rowsToDisplay = AJM.db.watcherListLines
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 80
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 20
	list.columnInformation[2].alignment = "CENTER"
	list.scrollRefreshCallback = AJM.QuestWatcherQuestListScrollRefresh
	list.rowClickCallback = AJM.QuestWatcherQuestListRowClick
	frame.questWatchList = list
	JambaHelperSettings:CreateScrollList( frame.questWatchList )
	-- Change appearance from default.
	frame.questWatchList.listFrame:SetBackdropColor( 0.0, 0.0, 0.0, 0.0 )
	frame.questWatchList.listFrame:SetBackdropBorderColor( 0.0, 0.0, 0.0, 0.0 )
	-- Position and size constants (once list height is known).
	frame.questWatchListBottom = topOfList - list.listHeight
	frame.questWatchListHeight = list.listHeight
	frame.questWatchHighlightRow = 1
	frame.questWatchListOffset = 1
	-- Set the global frame reference for this frame.
	JambaQuestWatcherFrame = frame
	AJM:SettingsUpdateBorderStyle()	
	AJM.questWatcherFrameCreated = true
end

function AJM:SettingsUpdateBorderStyle()
	local borderStyle = AJM.SharedMedia:Fetch( "border", AJM.db.borderStyle )
	local backgroundStyle = AJM.SharedMedia:Fetch( "background", AJM.db.backgroundStyle )
	local frame = JambaQuestWatcherFrame
	frame:SetBackdrop( {
		bgFile = backgroundStyle, 
		edgeFile = borderStyle, 
		tile = true, tileSize = frame:GetWidth(), edgeSize = 10, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	} )
	frame:SetBackdropColor( AJM.db.watchFrameBackgroundColourR, AJM.db.watchFrameBackgroundColourG, AJM.db.watchFrameBackgroundColourB, AJM.db.watchFrameBackgroundColourA )
	frame:SetBackdropBorderColor( AJM.db.watchFrameBorderColourR, AJM.db.watchFrameBorderColourG, AJM.db.watchFrameBorderColourB, AJM.db.watchFrameBorderColourA )	
end

function AJM:UpdateQuestWatcherDimensions()
	local frame = JambaQuestWatcherFrame
	frame:SetWidth( frame.questWatchList.listWidth + 4 )
	frame:SetHeight( frame.questWatchListHeight + 40 )
	frame:SetScale( AJM.db.watcherFrameScale )
end

function AJM:SetQuestWatcherVisibility()
	if CanDisplayQuestWatcher() == true then
		AJM:UpdateQuestWatcherDimensions()
		JambaQuestWatcherFrame:ClearAllPoints()
		JambaQuestWatcherFrame:SetPoint( AJM.db.watcherFramePoint, UIParent, AJM.db.watcherFrameRelativePoint, AJM.db.watcherFrameXOffset, AJM.db.watcherFrameYOffset )
		JambaQuestWatcherFrame:SetAlpha( AJM.db.watcherFrameAlpha )
		JambaQuestWatcherFrame:Show()
	else
		JambaQuestWatcherFrame:Hide()
	end	
end

-------------------------------------------------------------------------------------------------------------
-- Settings functionality.
-------------------------------------------------------------------------------------------------------------

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.mirrorMasterQuestSelectionAndDeclining = settings.mirrorMasterQuestSelectionAndDeclining
		AJM.db.allAutoSelectQuests = settings.allAutoSelectQuests
		AJM.db.acceptQuests = settings.acceptQuests
		AJM.db.slaveMirrorMasterAccept = settings.slaveMirrorMasterAccept
		AJM.db.doNotAutoAccept = settings.doNotAutoAccept 
		AJM.db.allAcceptAnyQuest = settings.allAcceptAnyQuest
		AJM.db.onlyAcceptQuestsFrom = settings.onlyAcceptQuestsFrom
		AJM.db.acceptFromTeam = settings.acceptFromTeam
		AJM.db.acceptFromNpc = settings.acceptFromNpc
		AJM.db.acceptFromFriends = settings.acceptFromFriends
		AJM.db.acceptFromParty = settings.acceptFromParty
		AJM.db.acceptFromRaid = settings.acceptFromRaid
		AJM.db.acceptFromGuild = settings.acceptFromGuild
		AJM.db.masterAutoShareQuestOnAccept = settings.masterAutoShareQuestOnAccept
		AJM.db.slaveAutoAcceptEscortQuest = settings.slaveAutoAcceptEscortQuest
		AJM.db.showJambaQuestLogWithWoWQuestLog = settings.showJambaQuestLogWithWoWQuestLog
		AJM.db.enableAutoQuestCompletion = settings.enableAutoQuestCompletion
		AJM.db.noChoiceAllDoNothing = settings.noChoiceAllDoNothing
		AJM.db.noChoiceSlaveCompleteQuestWithMaster = settings.noChoiceSlaveCompleteQuestWithMaster
		AJM.db.noChoiceAllAutoCompleteQuest = settings.noChoiceAllAutoCompleteQuest
		AJM.db.hasChoiceSlaveDoNothing = settings.hasChoiceSlaveDoNothing
		AJM.db.hasChoiceSlaveCompleteQuestWithMaster = settings.hasChoiceSlaveCompleteQuestWithMaster
		AJM.db.hasChoiceSlaveChooseSameRewardAsMaster = settings.hasChoiceSlaveChooseSameRewardAsMaster
		AJM.db.hasChoiceSlaveMustChooseOwnReward = settings.hasChoiceSlaveMustChooseOwnReward
		AJM.db.hasChoiceSlaveRewardChoiceModifierConditional = settings.hasChoiceSlaveRewardChoiceModifierConditional
		AJM.db.hasChoiceCtrlKeyModifier = settings.hasChoiceCtrlKeyModifier
		AJM.db.hasChoiceShiftKeyModifier = settings.hasChoiceShiftKeyModifier
		AJM.db.hasChoiceAltKeyModifier = settings.hasChoiceAltKeyModifier
		AJM.db.hasChoiceOverrideUseSlaveRewardSelected = settings.hasChoiceOverrideUseSlaveRewardSelected
		AJM.db.hasChoiceAquireBestQuestRewardForCharacter = settings.hasChoiceAquireBestQuestRewardForCharacter
		AJM.db.messageArea = settings.messageArea
		AJM.db.warningArea = settings.warningArea
		AJM.db.overrideQuestAutoSelectAndComplete = settings.overrideQuestAutoSelectAndComplete
		AJM.db.enableQuestWatcher = settings.enableQuestWatcher
		AJM.db.watcherFrameAlpha = settings.watcherFrameAlpha
		AJM.db.watcherFramePoint = settings.watcherFramePoint
		AJM.db.watcherFrameRelativePoint = settings.watcherFrameRelativePoint
		AJM.db.watcherFrameXOffset = settings.watcherFrameXOffset
		AJM.db.watcherFrameYOffset = settings.watcherFrameYOffset
		AJM.db.borderStyle = settings.borderStyle
		AJM.db.backgroundStyle = settings.backgroundStyle
		AJM.db.hideQuestWatcherInCombat = settings.hideQuestWatcherInCombat
		AJM.db.watcherFrameScale = settings.watcherFrameScale
		AJM.db.enableQuestWatcherOnMasterOnly = settings.enableQuestWatcherOnMasterOnly
		AJM.db.watchFrameBackgroundColourR = settings.watchFrameBackgroundColourR
		AJM.db.watchFrameBackgroundColourG = settings.watchFrameBackgroundColourG
		AJM.db.watchFrameBackgroundColourB = settings.watchFrameBackgroundColourB
		AJM.db.watchFrameBackgroundColourA = settings.watchFrameBackgroundColourA
		AJM.db.watchFrameBorderColourR = settings.watchFrameBorderColourR
		AJM.db.watchFrameBorderColourG = settings.watchFrameBorderColourG
		AJM.db.watchFrameBorderColourB = settings.watchFrameBorderColourB
		AJM.db.watchFrameBorderColourA = settings.watchFrameBorderColourA
		AJM.db.watcherListLines = settings.watcherListLines
		AJM.db.watcherFrameWidth = settings.watcherFrameWidth
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	-- Quest general and acceptance options.
	AJM.settingsControl.checkBoxMirrorMasterQuestSelectionAndDeclining:SetValue( AJM.db.mirrorMasterQuestSelectionAndDeclining )
	AJM.settingsControl.checkBoxAllAutoSelectQuests:SetValue( AJM.db.allAutoSelectQuests )
	AJM.settingsControl.checkBoxAcceptQuests:SetValue( AJM.db.acceptQuests )
	AJM.settingsControl.checkBoxSlaveMirrorMasterAccept:SetValue( AJM.db.slaveMirrorMasterAccept )
	AJM.settingsControl.checkBoxDoNotAutoAccept:SetValue( AJM.db.doNotAutoAccept )
	AJM.settingsControl.checkBoxAllAcceptAnyQuest:SetValue( AJM.db.allAcceptAnyQuest )
	AJM.settingsControl.checkBoxOnlyAcceptQuestsFrom:SetValue( AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromTeam:SetValue( AJM.db.acceptFromTeam )
	AJM.settingsControl.checkBoxAcceptFromNpc:SetValue( AJM.db.acceptFromNpc )
	AJM.settingsControl.checkBoxAcceptFromFriends:SetValue( AJM.db.acceptFromFriends )
	AJM.settingsControl.checkBoxAcceptFromParty:SetValue( AJM.db.acceptFromParty )
	AJM.settingsControl.checkBoxAcceptFromRaid:SetValue( AJM.db.acceptFromRaid )
	AJM.settingsControl.checkBoxAcceptFromGuild:SetValue( AJM.db.acceptFromGuild )
	AJM.settingsControl.checkBoxMasterAutoShareQuestOnAccept:SetValue( AJM.db.masterAutoShareQuestOnAccept )
	AJM.settingsControl.checkBoxSlaveAutoAcceptEscortQuest:SetValue( AJM.db.slaveAutoAcceptEscortQuest )
	AJM.settingsControl.checkBoxShowJambaQuestLogWithWoWQuestLog:SetValue( AJM.db.showJambaQuestLogWithWoWQuestLog )
	AJM.settingsControl.checkBoxOverrideQuestAutoSelectAndComplete:SetValue( AJM.db.overrideQuestAutoSelectAndComplete )
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )
	AJM.settingsControl.dropdownWarningArea:SetValue( AJM.db.warningArea )
	-- Quest completion options.
	AJM.settingsControlCompletion.checkBoxEnableAutoQuestCompletion:SetValue( AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxNoChoiceAllDoNothing:SetValue( AJM.db.noChoiceAllDoNothing )
	AJM.settingsControlCompletion.checkBoxNoChoiceSlaveCompleteQuestWithMaster:SetValue( AJM.db.noChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.checkBoxNoChoiceAllAutoCompleteQuest:SetValue( AJM.db.noChoiceAllAutoCompleteQuest )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveDoNothing:SetValue( AJM.db.hasChoiceSlaveDoNothing )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveCompleteQuestWithMaster:SetValue( AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveChooseSameRewardAsMaster:SetValue( AJM.db.hasChoiceSlaveChooseSameRewardAsMaster )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveMustChooseOwnReward:SetValue( AJM.db.hasChoiceSlaveMustChooseOwnReward )
	AJM.settingsControlCompletion.checkBoxHasChoiceAquireBestQuestRewardForCharacter:SetValue( AJM.db.hasChoiceAquireBestQuestRewardForCharacter )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveRewardChoiceModifierConditional:SetValue( AJM.db.hasChoiceSlaveRewardChoiceModifierConditional )
	AJM.settingsControlCompletion.checkBoxHasChoiceCtrlKeyModifier:SetValue( AJM.db.hasChoiceCtrlKeyModifier )
	AJM.settingsControlCompletion.checkBoxHasChoiceShiftKeyModifier:SetValue( AJM.db.hasChoiceShiftKeyModifier )
	AJM.settingsControlCompletion.checkBoxHasChoiceAltKeyModifier:SetValue( AJM.db.hasChoiceAltKeyModifier )
	AJM.settingsControlCompletion.checkBoxHasChoiceOverrideUseSlaveRewardSelected:SetValue( AJM.db.hasChoiceOverrideUseSlaveRewardSelected )
	-- Ensure correct state (general and acceptance options).
	AJM.settingsControl.checkBoxSlaveMirrorMasterAccept:SetDisabled( not AJM.db.acceptQuests )
	AJM.settingsControl.checkBoxDoNotAutoAccept:SetDisabled( not AJM.db.acceptQuests )
	AJM.settingsControl.checkBoxAllAcceptAnyQuest:SetDisabled( not AJM.db.acceptQuests )
	AJM.settingsControl.checkBoxOnlyAcceptQuestsFrom:SetDisabled( not AJM.db.acceptQuests )
	AJM.settingsControl.checkBoxAcceptFromTeam:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromNpc:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromFriends:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromParty:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromRaid:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	AJM.settingsControl.checkBoxAcceptFromGuild:SetDisabled( not AJM.db.acceptQuests or not AJM.db.onlyAcceptQuestsFrom )
	-- Ensure correct state (completion options). 
	AJM.settingsControlCompletion.labelQuestNoRewardsOrOneReward:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.labelQuestHasMoreThanOneReward:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxNoChoiceAllDoNothing:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxNoChoiceSlaveCompleteQuestWithMaster:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxNoChoiceAllAutoCompleteQuest:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveDoNothing:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxHasChoiceAquireBestQuestRewardForCharacter:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveCompleteQuestWithMaster:SetDisabled( not AJM.db.enableAutoQuestCompletion )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveChooseSameRewardAsMaster:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveMustChooseOwnReward:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.checkBoxHasChoiceSlaveRewardChoiceModifierConditional:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.labelHasChoiceSlaveRewardChoiceModifierConditional:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.checkBoxHasChoiceCtrlKeyModifier:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster or not AJM.db.hasChoiceSlaveRewardChoiceModifierConditional )
	AJM.settingsControlCompletion.checkBoxHasChoiceShiftKeyModifier:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster or not AJM.db.hasChoiceSlaveRewardChoiceModifierConditional )
	AJM.settingsControlCompletion.checkBoxHasChoiceAltKeyModifier:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster or not AJM.db.hasChoiceSlaveRewardChoiceModifierConditional )
	AJM.settingsControlCompletion.checkBoxHasChoiceOverrideUseSlaveRewardSelected:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	AJM.settingsControlCompletion.labelHasChoiceOverrideUseSlaveRewardSelected:SetDisabled( not AJM.db.enableAutoQuestCompletion or not AJM.db.hasChoiceSlaveCompleteQuestWithMaster )
	-- Quest watcher options.
	AJM.settingsControlWatcher.checkBoxEnableQuestWatcher:SetValue( AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBorder:SetValue( AJM.db.borderStyle )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBackground:SetValue( AJM.db.backgroundStyle )
	AJM.settingsControlWatcher.displayOptionsCheckBoxHideQuestWatcherInCombat:SetValue( AJM.db.hideQuestWatcherInCombat )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherTransparencySlider:SetValue( AJM.db.watcherFrameAlpha )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherScaleSlider:SetValue( AJM.db.watcherFrameScale )
	AJM.settingsControlWatcher.checkBoxEnableQuestWatcherMasterOnly:SetValue( AJM.db.enableQuestWatcherOnMasterOnly )
	AJM.settingsControlWatcher.questWatchBackgroundColourPicker:SetColor( AJM.db.watchFrameBackgroundColourR, AJM.db.watchFrameBackgroundColourG, AJM.db.watchFrameBackgroundColourB, AJM.db.watchFrameBackgroundColourA )
	AJM.settingsControlWatcher.questWatchBorderColourPicker:SetColor( AJM.db.watchFrameBorderColourR, AJM.db.watchFrameBorderColourG, AJM.db.watchFrameBorderColourB, AJM.db.watchFrameBorderColourA )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherLinesSlider:SetValue( AJM.db.watcherListLines )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherFrameWidthSlider:SetValue( AJM.db.watcherFrameWidth )
	-- Quest watcher state.
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBorder:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherMediaBackground:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsCheckBoxHideQuestWatcherInCombat:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherTransparencySlider:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherScaleSlider:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.checkBoxEnableQuestWatcherMasterOnly:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.questWatchBackgroundColourPicker:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.questWatchBorderColourPicker:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherLinesSlider:SetDisabled( not AJM.db.enableQuestWatcher )
	AJM.settingsControlWatcher.displayOptionsQuestWatcherFrameWidthSlider:SetDisabled( not AJM.db.enableQuestWatcher )
	if AJM.questWatcherFrameCreated == true then
		AJM:SettingsUpdateBorderStyle()
		AJM:SetQuestWatcherVisibility()	
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleMirrorMasterQuestSelectionAndDeclining( event, checked )
	AJM.db.mirrorMasterQuestSelectionAndDeclining = checked
	AJM.db.allAutoSelectQuests = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAllAutoSelectQuests( event, checked )
	AJM.db.allAutoSelectQuests = checked
	AJM.db.mirrorMasterQuestSelectionAndDeclining = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptQuests( event, checked )
	AJM.db.acceptQuests = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleSlaveMirrorMasterAccept( event, checked )
	AJM.db.slaveMirrorMasterAccept = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleOverrideQuestAutoSelectAndComplete( event, checked )
	AJM.db.overrideQuestAutoSelectAndComplete = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDoNotAutoAccept( event, checked )
	AJM.db.doNotAutoAccept = checked
	AJM.db.allAcceptAnyQuest = not checked
	AJM.db.onlyAcceptQuestsFrom = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAllAcceptAnyQuest( event, checked )
	AJM.db.allAcceptAnyQuest = checked
	AJM.db.onlyAcceptQuestsFrom = not checked
	AJM.db.doNotAutoAccept = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleOnlyAcceptQuestsFrom( event, checked )
	AJM.db.onlyAcceptQuestsFrom = checked
	AJM.db.allAcceptAnyQuest = not checked
	AJM.db.doNotAutoAccept = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromTeam( event, checked )
	AJM.db.acceptFromTeam = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromNpc( event, checked )
	AJM.db.acceptFromNpc = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromFriends( event, checked )
	AJM.db.acceptFromFriends = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromParty( event, checked )
	AJM.db.acceptFromParty = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromRaid( event, checked )
	AJM.db.acceptFromRaid = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAcceptFromGuild( event, checked )
	AJM.db.acceptFromGuild = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleMasterAutoShareQuestOnAccept( event, checked )
	AJM.db.masterAutoShareQuestOnAccept = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleSlaveAutoAcceptEscortQuest( event, checked )
	AJM.db.slaveAutoAcceptEscortQuest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowJambaQuestLogWithWoWQuestLog( event, checked )
	AJM.db.showJambaQuestLogWithWoWQuestLog = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleEnableAutoQuestCompletion( event, checked )
	AJM.db.enableAutoQuestCompletion = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleNoChoiceAllDoNothing( event, checked )
	AJM.db.noChoiceAllDoNothing = checked
	AJM.db.noChoiceSlaveCompleteQuestWithMaster = not checked
	AJM.db.noChoiceAllAutoCompleteQuest = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleNoChoiceSlaveCompleteQuestWithMaster( event, checked )
	AJM.db.noChoiceSlaveCompleteQuestWithMaster = checked
	AJM.db.noChoiceAllDoNothing = not checked
	AJM.db.noChoiceAllAutoCompleteQuest = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleNoChoiceAllAutoCompleteQuest( event, checked )
	AJM.db.noChoiceAllAutoCompleteQuest = checked
	AJM.db.noChoiceAllDoNothing = not checked
	AJM.db.noChoiceSlaveCompleteQuestWithMaster = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceSlaveDoNothing( event, checked )
	AJM.db.hasChoiceSlaveDoNothing = checked
	AJM.db.hasChoiceAquireBestQuestRewardForCharacter = not checked
	AJM.db.hasChoiceSlaveCompleteQuestWithMaster = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceSlaveCompleteQuestWithMaster( event, checked )
	AJM.db.hasChoiceSlaveCompleteQuestWithMaster = checked
	AJM.db.hasChoiceAquireBestQuestRewardForCharacter = not checked
	AJM.db.hasChoiceSlaveDoNothing = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceAquireBestQuestRewardForCharacter( event, checked )
	AJM.db.hasChoiceAquireBestQuestRewardForCharacter = checked
	AJM.db.hasChoiceSlaveCompleteQuestWithMaster = not checked
	AJM.db.hasChoiceSlaveDoNothing = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceSlaveChooseSameRewardAsMaster( event, checked )
	AJM.db.hasChoiceSlaveChooseSameRewardAsMaster = checked
	AJM.db.hasChoiceSlaveMustChooseOwnReward = not checked
	AJM.db.hasChoiceSlaveRewardChoiceModifierConditional = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceSlaveMustChooseOwnReward( event, checked )
	AJM.db.hasChoiceSlaveMustChooseOwnReward = checked
	AJM.db.hasChoiceSlaveChooseSameRewardAsMaster = not checked
	AJM.db.hasChoiceSlaveRewardChoiceModifierConditional = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceSlaveRewardChoiceModifierConditional( event, checked )
	AJM.db.hasChoiceSlaveRewardChoiceModifierConditional = checked
	AJM.db.hasChoiceSlaveChooseSameRewardAsMaster = not checked
	AJM.db.hasChoiceSlaveMustChooseOwnReward = not checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceCtrlKeyModifier( event, checked )
	AJM.db.hasChoiceCtrlKeyModifier = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceShiftKeyModifier( event, checked )
	AJM.db.hasChoiceShiftKeyModifier = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceAltKeyModifier( event, checked )
	AJM.db.hasChoiceAltKeyModifier = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHasChoiceOverrideUseSlaveRewardSelected( event, checked )
	AJM.db.hasChoiceOverrideUseSlaveRewardSelected = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMessageArea( event, messageAreaValue )
	DebugMessage( event, messageAreaValue )
	AJM.db.messageArea = messageAreaValue
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, messageAreaValue )
	AJM.db.warningArea = messageAreaValue
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleEnableQuestWatcher( event, checked )
	AJM.db.enableQuestWatcher = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBorderStyle( event, value )
	AJM.db.borderStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeBackgroundStyle( event, value )
	AJM.db.backgroundStyle = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleHideQuestWatcherInCombat( event, checked )
	AJM.db.hideQuestWatcherInCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeTransparency( event, value )
	AJM.db.watcherFrameAlpha = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeScale( event, value )
	AJM.db.watcherFrameScale = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeWatchLines( event, value )
	AJM.db.watcherListLines = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeWatchFrameWidth( event, value )
	AJM.db.watcherFrameWidth = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleEnableQuestWatcherMasterOnly( event, checked )
	AJM.db.enableQuestWatcherOnMasterOnly = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsQuestWatchBackgroundColourPickerChanged( event, r, g, b, a )
	AJM.db.watchFrameBackgroundColourR = r
	AJM.db.watchFrameBackgroundColourG = g
	AJM.db.watchFrameBackgroundColourB = b
	AJM.db.watchFrameBackgroundColourA = a
	AJM:SettingsRefresh()
end

function AJM:SettingsQuestWatchBorderColourPickerChanged( event, r, g, b, a )
	AJM.db.watchFrameBorderColourR = r
	AJM.db.watchFrameBorderColourG = g
	AJM.db.watchFrameBorderColourB = b
	AJM.db.watchFrameBorderColourA = a
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- NPC QUEST PROCESSING - SELECTING AND DECLINING
-------------------------------------------------------------------------------------------------------------

function AJM:ChurnNpcGossip()
	-- GetGossipAvailableQuests and GetGossipActiveQuests are returning nil in some cases, so do this as well.
	--GetGossipAvailableQuests() now returns 5 elements per quest and GetGossipActiveQuests() returns 4. title, level, isTrivial, isDaily, ...
    local index
    for index = 0, GetNumAvailableQuests() do
		SelectAvailableQuest( index )
	end
    for index = 0, GetNumActiveQuests() do
		SelectActiveQuest( index )
	end
	JambaUtilities:ClearTable( AJM.gossipQuests )
	local availableQuestsData = { GetGossipAvailableQuests() }
	local iterateQuests = 1
	local questIndex = 1
	while( availableQuestsData[iterateQuests] ) do
		local questInformation = {}
		questInformation.type = "available"
		questInformation.index = questIndex
		questInformation.name = availableQuestsData[iterateQuests]
		questInformation.level = availableQuestsData[iterateQuests + 1]
		table.insert( AJM.gossipQuests, questInformation )
		iterateQuests = iterateQuests + 5
		questIndex = questIndex + 1
	end
	local activeQuestsData = { GetGossipActiveQuests() }
	iterateQuests = 1
	while( activeQuestsData[iterateQuests] ) do
		local questInformation = {}
		questInformation.type = "active"
		questInformation.index = questIndex
		questInformation.name = activeQuestsData[iterateQuests]
		questInformation.level = activeQuestsData[iterateQuests + 1]
		table.insert( AJM.gossipQuests, questInformation )
		iterateQuests = iterateQuests + 4
		questIndex = questIndex + 1
	end
	for index, questInformation in ipairs( AJM.gossipQuests ) do
		if questInformation.type == "available" then
			--AJM:JambaSendMessageToTeam( AJM.db.messageArea, "Auto Selecting Available Quest: "..questInformation.name.." of level "..questInformation.level )
			SelectGossipAvailableQuest( questInformation.index )
		end
		if questInformation.type == "active" then
			--AJM:JambaSendMessageToTeam( AJM.db.messageArea, "Auto Selecting Active Quest: "..questInformation.name.." of level "..questInformation.level )
			SelectGossipActiveQuest( questInformation.index )
		end			
	end

end

function AJM:CanAutomateAutoSelectAndComplete()
	if AJM.db.overrideQuestAutoSelectAndComplete == true then
		if IsShiftKeyDown() then
		   return false
		else
		   return true
		end
	end
	return true
 end

function AJM:GOSSIP_SHOW()
	if AJM.db.allAutoSelectQuests == true and AJM:CanAutomateAutoSelectAndComplete() == true then
        AJM:ChurnNpcGossip()
	end
end

function AJM:QUEST_GREETING()
	if AJM.db.allAutoSelectQuests == true and AJM:CanAutomateAutoSelectAndComplete() == true then
		AJM:ChurnNpcGossip()
	end
end

function AJM:QUEST_PROGRESS()
	if AJM.db.allAutoSelectQuests == true and AJM:CanAutomateAutoSelectAndComplete() == true then
		if IsQuestCompletable() then
			CompleteQuest()
		end
	end
end

function AJM:SelectGossipOption( gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "SelectGossipOption" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_GOSSIP_OPTION, gossipIndex )
		end
	end		
end

function AJM:DoSelectGossipOption( sender, gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoSelectGossipOption" )
		SelectGossipOption( gossipIndex )
		AJM.isInternalCommand = false
	end		
end

function AJM:SelectGossipActiveQuest( gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "SelectGossipActiveQuest" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_GOSSIP_ACTIVE_QUEST, gossipIndex )		
		end
	end		
end

function AJM:DoSelectGossipActiveQuest( sender, gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoSelectGossipActiveQuest" )
		SelectGossipActiveQuest( gossipIndex )
		AJM.isInternalCommand = false
	end
end

function AJM:SelectGossipAvailableQuest( gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "SelectGossipAvailableQuest" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_GOSSIP_AVAILABLE_QUEST, gossipIndex )
		end
	end
end

function AJM:DoSelectGossipAvailableQuest( sender, gossipIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoSelectGossipAvailableQuest" )
		SelectGossipAvailableQuest( gossipIndex )
		AJM.isInternalCommand = false
	end
end

function AJM:SelectActiveQuest( questIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "SelectActiveQuest" )
			AJM:SetActiveQuestForQuestWatcherCache( questIndex )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_ACTIVE_QUEST, questIndex )
		end
	end		
end

function AJM:DoSelectActiveQuest( sender, questIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoSelectActiveQuest" )
		SelectActiveQuest( questIndex )
		AJM.isInternalCommand = false
	end
end

function AJM:SelectAvailableQuest( questIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then	
		if AJM.isInternalCommand == false then
			DebugMessage( "SelectAvailableQuest" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_AVAILABLE_QUEST, questIndex )
		end
	end		
end

function AJM:DoSelectAvailableQuest( sender, questIndex )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoSelectAvailableQuest" )
		SelectAvailableQuest( questIndex )
		AJM.isInternalCommand = false
	end
end

function AJM:DeclineQuest()
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "DeclineQuest" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_DECLINE_QUEST )
		end
	end		
end

function AJM:DoDeclineQuest( sender )
	if AJM.db.mirrorMasterQuestSelectionAndDeclining == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoDeclineQuest" )
		DeclineQuest()
		AJM.isInternalCommand = false
	end
end

-------------------------------------------------------------------------------------------------------------
-- NPC QUEST PROCESSING - COMPLETING
-------------------------------------------------------------------------------------------------------------

function AJM:CompleteQuest()  
	if AJM.db.enableAutoQuestCompletion == true then
		if AJM.isInternalCommand == false then
			DebugMessage( "CompleteQuest" )
			AJM:JambaSendCommandToTeam( AJM.COMMAND_COMPLETE_QUEST )
		end
	end
end

function AJM:DoCompleteQuest( sender )
	if AJM.db.enableAutoQuestCompletion == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoCompleteQuest" )	
		CompleteQuest()
		AJM.isInternalCommand = false
	end	
end

function AJM:QUEST_COMPLETE()
	DebugMessage( "QUEST_COMPLETE" )
	if AJM.db.enableAutoQuestCompletion == true then
		if AJM.db.hasChoiceAquireBestQuestRewardForCharacter == true then
			AJM:ChooseBestRewardForCharacter()
		elseif (AJM.db.noChoiceAllAutoCompleteQuest == true) and (GetNumQuestChoices() <= 1) then
			--AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Quest has X reward choices."]( GetNumQuestChoices() ) )
			AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Completed Quest: A"]( GetTitleText() ) )
			GetQuestReward( GetNumQuestChoices() )
		end		
	end
end

-------------------------------------------------------------------------------------------------------------
-- NPC QUEST PROCESSING - REWARDS
-------------------------------------------------------------------------------------------------------------

function AJM:CheckForOverrideAndChooseQuestReward( questIndex )
	-- Yes, override if slave has reward selected?
	if (AJM.db.hasChoiceOverrideUseSlaveRewardSelected == true) and (QuestInfoFrame.itemChoice > 0) then
		-- Yes, choose slaves reward.
		GetQuestReward( QuestInfoFrame.itemChoice )
	else
		-- No, choose masters reward.
		GetQuestReward( questIndex )
	end
end

function AJM:CheckForOverrideAndDoNotChooseQuestReward( questIndex )
	-- Yes, override if slave has reward selected?
	if QuestInfoFrame.itemChoice ~= nil then
		if (AJM.db.hasChoiceOverrideUseSlaveRewardSelected == true) and (QuestInfoFrame.itemChoice > 0) then
			-- Yes, choose slaves reward.
			GetQuestReward( QuestInfoFrame.itemChoice )
		end
	end
end

function AJM:AreCorrectConditionalKeysPressed()	
	local failTest = false
	if AJM.db.hasChoiceCtrlKeyModifier == true and IsControlKeyDown() == nil then
		failTest = true
	end
	if AJM.db.hasChoiceShiftKeyModifier == true and IsShiftKeyDown() == nil then
		failTest = true
	end
	if AJM.db.hasChoiceAltKeyModifier == true and IsAltKeyDown() == nil then
		failTest = true
	end
	return not failTest
end

function AJM:GetQuestReward( questIndex )
	-- TODO: still not removing quests when completed.
	AJM:ScheduleTimer( "JambaQuestWatchListUpdateButtonClicked", 1 )
	if AJM.db.enableAutoQuestCompletion == true then
		if (AJM.db.noChoiceSlaveCompleteQuestWithMaster == true) or (AJM.db.hasChoiceSlaveCompleteQuestWithMaster == true) then 
			if AJM.isInternalCommand == false then
				DebugMessage( "GetQuestReward" )
				AJM:JambaSendCommandToTeam( AJM.COMMAND_CHOOSE_QUEST_REWARD, questIndex, AJM:AreCorrectConditionalKeysPressed() )
			end
		end
	end		
end

function AJM:DoChooseQuestReward( sender, questIndex, modifierKeysPressed )
	local numberOfQuestRewards = GetNumQuestChoices()
	if AJM.db.enableAutoQuestCompletion == true then
		if (AJM.db.noChoiceSlaveCompleteQuestWithMaster == true) or (AJM.db.hasChoiceSlaveCompleteQuestWithMaster == true) then 
			AJM.isInternalCommand = true
			DebugMessage( "DoChooseQuestReward" )
			--AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Quest has X reward choices."]( numberOfQuestRewards ) )
			DebugMessage( "Quest has ", numberOfQuestRewards, " reward choices." )
			-- How many reward choices does this quest have?
			if numberOfQuestRewards <= 1 then
				-- One or less.
				if AJM.db.noChoiceSlaveCompleteQuestWithMaster == true then
					GetQuestReward( questIndex )
				end
			else
				-- More than one.
				if AJM.db.hasChoiceSlaveCompleteQuestWithMaster == true then
					-- Choose same as master?
					if AJM.db.hasChoiceSlaveChooseSameRewardAsMaster == true then
						AJM:CheckForOverrideAndChooseQuestReward( questIndex )
					-- Choose same as master, conditional keys?
					elseif AJM.db.hasChoiceSlaveRewardChoiceModifierConditional == true then
						if modifierKeysPressed == true then
							AJM:CheckForOverrideAndChooseQuestReward( questIndex )
						else
							AJM:CheckForOverrideAndDoNotChooseQuestReward( questIndex )
						end
					end
				end
			end
			AJM.isInternalCommand = false
		end
	end
end

function AJM:ChooseBestRewardForCharacter()
	-- Provided by loop: http://www.dual-boxing.com/showpost.php?p=257610&postcount=1505
	-- Choose the best item for this character, otherwise choose the most valuable to vendor:
	local numberOfQuestRewards = GetNumQuestChoices()
	local mostValuableQuestItemIndex, mostValuableQuestItemValue, bestQuestItemIndex, bestQuestItemArmorWeight = 1, 0, -1, -1
	local armorWeights = { Plate = 4, Mail = 2, Leather = 1, Cloth = 0 }
                
	-- Yanked this from LibItemUtils; sucks that we need this lookup table, but GetItemInfo only 
	-- returns an equipment location, which must first be converted to a slot value that GetInventoryItemLink understands:
	local equipmentSlotLookup = {
		INVTYPE_HEAD = {"HeadSlot", nil},
		INVTYPE_NECK = {"NeckSlot", nil},
		INVTYPE_SHOULDER = {"ShoulderSlot", nil},
		INVTYPE_CLOAK = {"BackSlot", nil},
		INVTYPE_CHEST = {"ChestSlot", nil},
		INVTYPE_WRIST = {"WristSlot", nil},
		INVTYPE_HAND = {"HandsSlot", nil},
		INVTYPE_WAIST = {"WaistSlot", nil},
		INVTYPE_LEGS = {"LegsSlot", nil},
		INVTYPE_FEET = {"FeetSlot", nil},
		INVTYPE_SHIELD = {"SecondaryHandSlot", nil},
		INVTYPE_ROBE = {"ChestSlot", nil},
		INVTYPE_2HWEAPON = {"MainHandSlot", "SecondaryHandSlot"},
		INVTYPE_WEAPONMAINHAND = {"MainHandSlot", nil},
		INVTYPE_WEAPONOFFHAND = {"SecondaryHandSlot", "MainHandSlot"},
		INVTYPE_WEAPON = {"MainHandSlot","SecondaryHandSlot"},
		INVTYPE_THROWN = {"RangedSlot", nil},
		INVTYPE_RANGED = {"RangedSlot", nil},
		INVTYPE_RANGEDRIGHT = {"RangedSlot", nil},
		INVTYPE_FINGER = {"Finger0Slot", "Finger1Slot"},
		INVTYPE_HOLDABLE = {"SecondaryHandSlot", "MainHandSlot"},
		INVTYPE_TRINKET = {"Trinket0Slot", "Trinket1Slot"}
	} 
                        
	for questItemIndex = 1, numberOfQuestRewards do
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(GetQuestItemLink("choice", questItemIndex))
		-- If there is a rare item as a reward, bail and let the player choose.
		if itemRarity >= 3 then
			return
		end
		local itemId = itemLink:match("|Hitem:(%d+)")
		local isItemEquippable = IsEquippableItem(itemId)
		local _, _, _, _, isItemUsable = GetQuestItemInfo("choice", questItemIndex)
                
		if itemSellPrice > mostValuableQuestItemValue then
			-- Keep track of which item is most valuable:
			mostValuableQuestItemIndex = questItemIndex
			mostValuableQuestItemValue = itemSellPrice
		end
                            
		if isItemEquippable == 1 and isItemUsable ~= nil then
			-- NPC is offering us an item we can actually wear:
			local currentEquippedItemLinksInSlots = {}
			local currentWorstEquippedItemInSlot = nil
			
			-- Figure out what we already have equipped:
			for _, itemSlot in ipairs(equipmentSlotLookup[itemEquipLoc]) do
				if itemSlot ~= nil then
					local currentEquippedItemLinkInSlot = GetInventoryItemLink("player", GetInventorySlotInfo(itemSlot))
					
					if currentEquippedItemLinkInSlot == nil then
						-- Of the n item slots available, at least one of them has nothing equipped. Ergo, it is the worst:
						currentWorstEquippedItemInSlot = nil
						break
					else
						-- There's an item in this slot, get some details on it:
						local _, _, _, currentEquippedItemLevelInSlot, _, _, currentEquippedItemSubTypeInSlot = GetItemInfo(currentEquippedItemLinkInSlot)
						
						-- We haven't yet determined the worst item, or the item we see in this slot happens to be worse than the other item
						-- we saw in this partner slot (ie. a ring in one slot is worse than a ring in another slot):
						if currentWorstEquippedItemInSlot == nil or currentWorstEquippedItemInSlot.itemLevel > currentEquippedItemLevelInSlot then
							currentWorstEquippedItemInSlot = { 
								itemLink = currentEquippedItemLinkInSlot,
								itemLevel = currentEquippedItemLevelInSlot,
								itemSubType = currentEquippedItemSubTypeInSlot
							}
						end
					end
				end
			end

			if currentWorstEquippedItemInSlot == nil then
				-- We're not even wearing an item in this slot, and the vendor has something we can use, take it:
				bestQuestItemIndex = questItemIndex
			else
				if itemLevel > currentWorstEquippedItemInSlot.itemLevel then
					-- NPC is providing us with an better item than what we currently have in this slot:
					if armorWeights[itemSubType] ~= nil then
						-- Armor subtype is one which we care to select based on some priority order:
						if armorWeights[itemSubType] > bestQuestItemArmorWeight then
							-- If this piece of armor is a better subtype (ie. Plate is better than Cloth if we can wear it):
							bestQuestItemIndex = questItemIndex
							bestQuestItemArmorWeight = armorWeights[itemSubType]
						end
					elseif currentWorstEquippedItemInSlot.itemSubType == itemSubType then
						-- This isn't a piece of armor (ie. might be a weapon) - only take it if it's the same 
						-- subtype as the item we are already wearing (if we're wearing a staff, and NPC offers
						--  a staff and a dagger, we'll take the staff):
						bestQuestItemIndex = questItemIndex
						bestQuestItemArmorWeight = -1
					end
				end
			end
		end
	end
                        
	if bestQuestItemIndex < 0 then
		-- If we haven't determined an item upgrade by now, just choose the one that we can vendor for the most gold:
		bestQuestItemIndex = mostValuableQuestItemIndex
	end
	
	GetQuestReward(bestQuestItemIndex)

end

-------------------------------------------------------------------------------------------------------------
-- NPC QUEST PROCESSING - ACCEPTING
-------------------------------------------------------------------------------------------------------------

function AJM:QUEST_ACCEPTED( ... )
	local event, questIndex =  ...
	if AJM.db.acceptQuests == true then
		if AJM.db.masterAutoShareQuestOnAccept == true then	
			if JambaApi.IsCharacterTheMaster( AJM.characterName ) == true then
				if AJM.isInternalCommand == false then
					AJM:JambaSendMessageToTeam( AJM.db.messageArea, "Attempting to auto share newly accepted quest." )
					SelectQuestLogEntry( questIndex )
					if AJM:IsCurrentlySelectedQuestValid() == true then
						if GetQuestLogPushable() == 1 and GetNumPartyMembers() > 0 then
							AJM:JambaSendMessageToTeam( AJM.db.messageArea, "Pushing newly accepted quest." )
							QuestLogPushQuest()
						end
					end
				end	
			end
		end
	end
end

function AJM:AcceptQuest()
	if AJM.db.acceptQuests == true then
		if AJM.db.slaveMirrorMasterAccept == true then	
			if AJM.isInternalCommand == false then
				DebugMessage( "AcceptQuest" )
				AJM:JambaSendCommandToTeam( AJM.COMMAND_ACCEPT_QUEST )
			end		
		end
	end
end

function AJM:DoAcceptQuest( sender )
	if AJM.db.acceptQuests == true and AJM.db.slaveMirrorMasterAccept == true then
		AJM.isInternalCommand = true
		DebugMessage( "DoAcceptQuest" )
		AcceptQuest()
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Accepted Quest: A"]( GetTitleText() ) )
		AJM.isInternalCommand = false	
	end
end

-------------------------------------------------------------------------------------------------------------
-- QUEST PROCESSING - AUTO ACCEPTING
-------------------------------------------------------------------------------------------------------------

function AJM:CanAutoAcceptSharedQuestFromPlayer()
	local canAccept = false
	if AJM.db.allAcceptAnyQuest == true then
		canAccept = true
	elseif AJM.db.onlyAcceptQuestsFrom == true then
		local questSourceName, questSourceRealm = UnitName( "npc" )
		if AJM.db.acceptFromTeam == true then	
			if JambaApi.IsCharacterInTeam( questSourceName ) == true then
				canAccept = true
			end
		end
		if AJM.db.acceptFromFriends == true then	
			for friendIndex = 1, GetNumFriends() do
				local friendName = GetFriendInfo( friendIndex )
				if questSourceName == friendName then
					canAccept = true
					break
				end
			end	
		end
		if AJM.db.acceptFromParty == true then	
			if UnitInParty( "npc" ) == 1 then
				canAccept = true
			end
		end
		if AJM.db.acceptFromRaid == true then	
			if UnitInRaid( "npc" ) ~= nil then
				canAccept = true
			end
		end
		if AJM.db.acceptFromGuild == true then
			if UnitIsInMyGuild( "npc" ) == 1 then
				canAccept = true
			end
		end			
	end
	return canAccept
end

function AJM:QUEST_DETAIL()
	DebugMessage( "QUEST_DETAIL" )
	if AJM.db.acceptQuests == true then
		-- Who is this quest from.
		local questSourceName, questSourceRealm = UnitName( "npc" )
		if UnitIsPlayer( "npc" ) == 1 then
			-- Quest is shared from a player.
			if AJM:CanAutoAcceptSharedQuestFromPlayer() == true then		
				AJM.isInternalCommand = true
				AcceptQuest()
				AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Automatically Accepted Quest: A"]( GetTitleText() ) )
				AJM.isInternalCommand = false
			end			
		else
			-- Quest is from an NPC.
			if (AJM.db.allAcceptAnyQuest == true) or ((AJM.db.onlyAcceptQuestsFrom == true) and (AJM.db.acceptFromNpc == true)) then		
				AJM.isInternalCommand = true
				AcceptQuest()
				AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Automatically Accepted Quest: A"]( GetTitleText() ) )
				AJM.isInternalCommand = false
			end
		end
	end	
end

-------------------------------------------------------------------------------------------------------------
-- ESCORT QUEST
-------------------------------------------------------------------------------------------------------------

function AJM:QUEST_ACCEPT_CONFIRM( event, senderName, questName )
	DebugMessage( "QUEST_ACCEPT_CONFIRM" )
	if AJM.db.acceptQuests == true then
		if AJM.db.slaveAutoAcceptEscortQuest == true then
			AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Automatically Accepted Escort Quest: A"]( questName ) )
			AJM.isInternalCommand = true
			ConfirmAcceptQuest()
			AJM.isInternalCommand = false
			StaticPopup_Hide( "QUEST_ACCEPT" )
		end
	end	
end

-------------------------------------------------------------------------------------------------------------
-- QUEST WATCHING
-------------------------------------------------------------------------------------------------------------

function AJM:AddQuestWatch( questIndex )
	AJM:JambaQuestWatcherUpdate( true )
	--AJM:JambaQuestWatchListUpdateButtonClicked()
end

function AJM:RemoveQuestWatch( questIndex )
	local questLogTitleText, level, questTag,  suggestedGroup, isHeader, isCollapsed,  isComplete, isDaily, questID = GetQuestLogTitle( questIndex )
	AJM:RemoveQuestFromWatchList( questID )
end

function AJM:SetAbandonQuest()
	questName = GetAbandonQuestName()
	if questName ~= nil then
		local questIndex = AJM:GetQuestLogIndexByName( questName )
		AJM:SetActiveQuestForQuestWatcherCache( questIndex )
	end
end

function AJM:AbandonQuest()
	-- Wait a bit for the correct information to come through from the server...
	AJM:ScheduleTimer( "AbandonQuestDelayed", 1 )		
end

function AJM:AbandonQuestDelayed()
	AJM:RemoveCurrentQuestFromWatcherCache()
	AJM:RemoveQuestsNotBeingWatched()
	--AJM:JambaQuestWatchListUpdateButtonClicked()
end

function AJM:JambaQuestWatchListUpdateButtonClicked()
	AJM:RemoveQuestsNotBeingWatched()
	AJM:JambaSendCommandToTeam( AJM.COMMAND_UPDATE_QUEST_WATCHER_LIST )
end

function AJM:DoQuestWatchListUpdate( characterName )
	AJM:JambaQuestWatcherUpdate( false )
end

function AJM:QUEST_WATCH_UPDATE( event, ... )
	if AJM.db.enableQuestWatcher == true then
		-- Wait a bit for the correct information to come through from the server...
		AJM:ScheduleTimer( "JambaQuestWatcherUpdate", 1, true )		
	end
end

function AJM:GetQuestObjectiveCompletion( text )
	local _, _, arg1, arg2 = string.find(text, "(.*):%s(.*)")
	if arg1 and arg2 then
		return arg2, arg1
	else
		return L["N/A"], text
	end
end

function AJM:QuestWatchGetObjectiveText( questIndex, objectiveIndex )
	local objectiveFullText, objectiveType, objectiveFinished = GetQuestLogLeaderBoard( objectiveIndex, questIndex )
	local amountCompleted, objectiveText = AJM:GetQuestObjectiveCompletion( objectiveFullText )
	return objectiveText 
end

-------------------------------------------------------------------------------------------------------------
-- QUEST WATCH CACHE
-------------------------------------------------------------------------------------------------------------

function AJM:IsQuestObjectiveInCache( questID, objectiveIndex )
	local key = questID..objectiveIndex
	if AJM.questWatchCache[key] == nil then
		return false
	end
	return true
end

function AJM:AddQuestObjectiveToCache( questID, objectiveIndex, amountCompleted, objectiveFinished )
	local key = questID..objectiveIndex
	AJM.questWatchCache[key] = {}
	AJM.questWatchCache[key].questID = questID
	AJM.questWatchCache[key].amountCompleted = amountCompleted
	AJM.questWatchCache[key].objectiveFinished = objectiveFinished
end

function AJM:GetQuestCachedValues( questID, objectiveIndex )
	local key = questID..objectiveIndex
	return AJM.questWatchCache[key].amountCompleted, AJM.questWatchCache[key].objectiveFinished
end

function AJM:UpdateQuestCachedValues( questID, objectiveIndex, amountCompleted, objectiveFinished )
	local key = questID..objectiveIndex
	AJM.questWatchCache[key].amountCompleted = amountCompleted
	AJM.questWatchCache[key].objectiveFinished = objectiveFinished
end

function AJM:QuestCacheUpdate( questID, objectiveIndex, amountCompleted, objectiveFinished )
	if AJM:IsQuestObjectiveInCache( questID, objectiveIndex ) == false then
		AJM:AddQuestObjectiveToCache( questID, objectiveIndex, amountCompleted, objectiveFinished )
		return true
	end
	local cachedAmountCompleted, cachedObjectiveFinished = AJM:GetQuestCachedValues( questID, objectiveIndex )
	if cachedAmountCompleted == amountCompleted and cachedObjectiveFinished == objectiveFinished then
		return false
	end
	AJM:UpdateQuestCachedValues( questID, objectiveIndex, amountCompleted, objectiveFinished )
	return true
end

function AJM:SetActiveQuestForQuestWatcherCache( questIndex )
	if AJM.db.enableQuestWatcher == false then
		return
	end
	if questIndex ~= nil then
		local questLogTitleText, level, questTag,  suggestedGroup, isHeader, isCollapsed,  isComplete, isDaily, questID = GetQuestLogTitle( questIndex )
		AJM.currentQuestForQuestWatcherID = questID
	else
		AJM.currentQuestForQuestWatcherID = nil
	end
end

function AJM:RemoveQuestFromWatcherCache( questID )
	for key, questInfo in pairs( AJM.questWatchCache ) do
		if questInfo.questID == questID then
			AJM.questWatchCache[key].questID = nil
			AJM.questWatchCache[key].amountCompleted = nil
			AJM.questWatchCache[key].objectiveFinished = nil
			AJM.questWatchCache[key] = nil
			AJM:JambaSendCommandToTeam( AJM.COMMAND_QUEST_WATCH_REMOVE_QUEST, questID )
		end
	end
end

function AJM:RemoveCurrentQuestFromWatcherCache()
	if AJM.db.enableQuestWatcher == false then
		return
	end
	if AJM.currentQuestForQuestWatcherID == nil then
		return
	end
	AJM:RemoveQuestFromWatcherCache( AJM.currentQuestForQuestWatcherID )
end

-------------------------------------------------------------------------------------------------------------
-- QUEST WATCH COMMUNICATION
-------------------------------------------------------------------------------------------------------------

function AJM:JambaQuestWatcherUpdate( useCache )
	if AJM.db.enableQuestWatcher == false then
		return
	end
	--AJM:Print( "Sending quest watch information...")
	for iterateWatchedQuests = 1, GetNumQuestWatches() do
		local questIndex = GetQuestIndexForWatch( iterateWatchedQuests )
		if questIndex ~= nil then
			local questLogTitleText, level, questTag,  suggestedGroup, isHeader, isCollapsed,  isComplete, isDaily, questID = GetQuestLogTitle( questIndex )
			numObjectives = GetNumQuestLeaderBoards( questIndex )
			for iterateObjectives = 1, numObjectives do
				local objectiveFullText, objectiveType, objectiveFinished = GetQuestLogLeaderBoard( iterateObjectives, questIndex )
				local amountCompleted, objectiveText = AJM:GetQuestObjectiveCompletion( objectiveFullText )			
				if (AJM:QuestCacheUpdate( questID, iterateObjectives, amountCompleted, objectiveFinished ) == true) or (useCache == false) then
					--AJM:Print( "UPDATE:", "cache:", useCache, "QuestID", questID, "ObjectID", iterateObjectives )				
					AJM:JambaSendCommandToTeam( AJM.COMMAND_QUEST_WATCH_OBJECTIVE_UPDATE, questID, questLogTitleText, iterateObjectives, objectiveText, amountCompleted, objectiveFinished )
				end
			end
		end
	end
end

-- Gathers messages from team.
function AJM:DoQuestWatchObjectiveUpdate( characterName, questID, questName, objectiveIndex, objectiveText, amountCompleted, objectiveFinished )
	AJM:UpdateQuestWatchList( questID, questName, objectiveIndex, objectiveText, characterName, amountCompleted, objectiveFinished )
end

function AJM:UpdateQuestWatchList( questID, questName, objectiveIndex, objectiveText, characterName, amountCompleted, objectiveFinished )
	local questHeaderPosition = AJM:GetQuestHeaderInWatchList( questID, questName )
	local objectiveHeaderPosition = AJM:GetObjectiveHeaderInWatchList( questID, questName, objectiveIndex, objectiveText, "", questHeaderPosition )
	local characterPosition = AJM:GetCharacterInWatchList( questID, objectiveIndex, characterName, amountCompleted, objectiveHeaderPosition, objectiveFinished )	
	local totalAmountCompleted = AJM:GetTotalCharacterAmountFromWatchList( questID, objectiveIndex )
	objectiveHeaderPosition = AJM:GetObjectiveHeaderInWatchList( questID, questName, objectiveIndex, objectiveText, totalAmountCompleted, questHeaderPosition )
	AJM:QuestWatcherQuestListScrollRefresh()
	AJM:SetQuestWatcherVisibility()
end

-------------------------------------------------------------------------------------------------------------

function AJM:RemoveQuestFromWatchList( questID )
	AJM:RemoveQuestFromWatcherCache( questID )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_QUEST_WATCH_REMOVE_QUEST, questID )
end

function AJM:DoRemoveQuestFromWatchList( characterName, questID )
	-- Remove character lines for this character.
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		if questWatchInfo.questID == questID and questWatchInfo.character == characterName then
			AJM:RemoveQuestWatchInfo( questWatchInfo.key )	
		end
	end
	-- See if any character lines left, if none, then remove quest completely.
	local found = false
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		if questWatchInfo.questID == questID and questWatchInfo.type == "CHARACTER_AMOUNT" then
			found = true
		end
	end
	if found == false then
		for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
			local questWatchInfo = questWatchInfoContainer.info
			if questWatchInfo.questID == questID then
				AJM:RemoveQuestWatchInfo( questWatchInfo.key )	
			end
		end	
	end
	AJM:QuestWatcherQuestListScrollRefresh()
	AJM:SetQuestWatcherVisibility()
end

-------------------------------------------------------------------------------------------------------------
-- QUEST WATCH DISPLAY LIST LOGIC
-------------------------------------------------------------------------------------------------------------

function AJM:GetTotalCharacterAmountFromWatchList( questID, objectiveIndex )
	local amount = 0
	local total = 0
	local countCharacters = 0
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local position = questWatchInfoContainer.position
		if questWatchInfo.questID == questID and questWatchInfo.type == "CHARACTER_AMOUNT" and questWatchInfo.objectiveIndex == objectiveIndex then
			countCharacters = countCharacters + 1
			local amountCompletedText = questWatchInfo.amount
			local _, _, arg1, arg2 = string.find(amountCompletedText, "(%d*)/(%d*)")
			if (arg1 ~= nil) and (arg2 ~= nil) then
				if strtrim( arg1 ) ~= "" and strtrim( arg2 ) ~= "" then
					amount = amount + tonumber( arg1 )
					total = total + tonumber( arg2 )
				end
			end
		end
	end
	if countCharacters == 0 then
		return L["DONE"]
	end
	local amountOverTotal = string.format( "%s/%s", amount, total )
	if amountOverTotal == "0/0" then
		amountOverTotal = "N/A" 
	end
	return amountOverTotal
end

function AJM:RemoveQuestsNotBeingWatched()
	AJM:UpdateAllQuestsInWatchList()
	for checkQuestID, value in pairs( AJM.questWatchListOfQuests ) do
		local found = false
		for iterateWatchedQuests = 1, GetNumQuestWatches() do
			local questIndex = GetQuestIndexForWatch( iterateWatchedQuests )
			if questIndex ~= nil then
				local questLogTitleText, level, questTag,  suggestedGroup, isHeader, isCollapsed,  isComplete, isDaily, questID = GetQuestLogTitle( questIndex )
				if checkQuestID == questID then
					found = true
				end
			end
		end
		if found == false then
			AJM:RemoveQuestFromWatchList( checkQuestID )
		end
	end
end

function AJM:UpdateAllQuestsInWatchList()
	table.wipe( AJM.questWatchListOfQuests )
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		AJM.questWatchListOfQuests[questWatchInfoContainer.info.questID] = true
	end
end

function AJM:GetCharacterInWatchList( questID, objectiveIndex, characterName, amountCompleted, objectiveHeaderPosition, objectiveFinished )
	local characterPosition = -1
	local characterQuestWatchInfo = nil
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local position = questWatchInfoContainer.position
		if questWatchInfo.questID == questID and questWatchInfo.type == "CHARACTER_AMOUNT" and questWatchInfo.objectiveIndex == objectiveIndex and questWatchInfo.character == characterName then
			questWatchInfo.amount = amountCompleted
			characterQuestWatchInfo = questWatchInfo
			characterPosition = position
			break
		end
	end
	if characterPosition == -1 and objectiveFinished == 1 then
		return -1
	end
	if objectiveFinished == 1 then
		AJM:RemoveQuestWatchInfo( characterQuestWatchInfo.key )	
		return -1
	end
	if characterPosition == -1 and objectiveFinished == nil then
		local questWatchInfo = AJM:CreateQuestWatchInfo( questID, "CHARACTER_AMOUNT", objectiveIndex, characterName, "        "..characterName, amountCompleted )
		AJM:InsertQuestWatchInfoToListAfterPosition( questWatchInfo, objectiveHeaderPosition )
		return objectiveHeaderPosition + 1
	end
	return -1
end

function AJM:GetObjectiveHeaderInWatchList( questID, questName, objectiveIndex, objectiveText, totalAmountCompleted, questHeaderPosition )
	if strtrim( objectiveText ) == "" then
		objectiveText = questName
	end
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local position = questWatchInfoContainer.position
		if questWatchInfo.questID == questID and questWatchInfo.type == "OBJECTIVE_HEADER" and questWatchInfo.objectiveIndex == objectiveIndex then
			questWatchInfo.information = "    "..objectiveText
			questWatchInfo.amount = totalAmountCompleted
			return position
		end
	end
	local questWatchInfo = AJM:CreateQuestWatchInfo( questID, "OBJECTIVE_HEADER", objectiveIndex, "", "    "..objectiveText, totalAmountCompleted )
	AJM:InsertQuestWatchInfoToListAfterPosition( questWatchInfo, questHeaderPosition )
	return questHeaderPosition + 1
end

function AJM:GetQuestHeaderInWatchList( questID, questName )
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local position = questWatchInfoContainer.position
		if questWatchInfo.questID == questID and questWatchInfo.type == "QUEST_HEADER" then
			return position
		end
	end
	local questWatchInfo = AJM:CreateQuestWatchInfo( questID, "QUEST_HEADER", -1, "", questName, L["<Map>"] )
	local newPositionAtEnd = AJM:GetQuestWatchMaximumOrder() + 1
	AJM:AddQuestWatchInfoToListAtPosition( questWatchInfo, newPositionAtEnd )
	return newPositionAtEnd
end

-------------------------------------------------------------------------------------------------------------

function AJM:CreateQuestWatchInfo( questID, type, objectiveIndex, character, information, amount )
	local questWatchInfo = {}
	questWatchInfo.key = questID..type..objectiveIndex..character
	questWatchInfo.questID = questID
	questWatchInfo.type = type
	questWatchInfo.objectiveIndex = objectiveIndex
	questWatchInfo.character = character
	questWatchInfo.information = information
	questWatchInfo.amount = amount
	return questWatchInfo 
end

function AJM:AddQuestWatchInfoToListAtPosition( questWatchInfo, position )
	AJM.questWatchObjectivesList[questWatchInfo.key] = {}
	AJM.questWatchObjectivesList[questWatchInfo.key].position = position
	AJM.questWatchObjectivesList[questWatchInfo.key].info = questWatchInfo
end

function AJM:InsertQuestWatchInfoToListAfterPosition( questWatchInfo, position )
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local checkPosition = questWatchInfoContainer.position
		if checkPosition > position then
			questWatchInfoContainer.position = checkPosition + 1
		end
	end
	AJM:AddQuestWatchInfoToListAtPosition( questWatchInfo, position + 1 )
end

function AJM:RemoveQuestWatchInfo( key )
	local removedPosition = AJM.questWatchObjectivesList[key].position
	for checkKey, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local checkPosition = questWatchInfoContainer.position
		if checkPosition > removedPosition then
			questWatchInfoContainer.position = checkPosition - 1
		end
	end
	AJM.questWatchObjectivesList[key].info = nil
	AJM.questWatchObjectivesList[key].position = nil
	AJM.questWatchObjectivesList[key] = nil
end

-- Get the largest order number from the quest watch list.
function AJM:GetQuestWatchMaximumOrder()
	local largestPosition = 0
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local position = questWatchInfoContainer.position	
		if position > largestPosition then
			largestPosition = position
		end
	end
	return largestPosition
end

-- Get the quest watch info at a specific position.
function AJM:GetQuestWatchInfoAtOrderPosition( position )
	local information = ""
	local amount = ""
	local type = ""
	local questID = ""
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		local questWatchInfo = questWatchInfoContainer.info
		local questWatchPosition = questWatchInfoContainer.position		
		if questWatchPosition == position then
			information = questWatchInfo.information
			amount = questWatchInfo.amount
			type = questWatchInfo.type
			questID = questWatchInfo.questID 
			break
		end
	end
	return information, amount, type, questID
end

function AJM:CountLinesInQuestWatchList()
	if AJM.questWatchObjectivesList == nil then
		return 0
	end
	local count = 0
	for key, questWatchInfoContainer in pairs( AJM.questWatchObjectivesList ) do
		count = count + 1
	end
	return count
end

-------------------------------------------------------------------------------------------------------------
-- QUEST WATCH DISPLAY LIST MECHANICS
-------------------------------------------------------------------------------------------------------------

function AJM:QuestWatcherQuestListScrollRefresh()
	frame = JambaQuestWatcherFrame
	FauxScrollFrame_Update(
		frame.questWatchList.listScrollFrame, 
		AJM:GetQuestWatchMaximumOrder(),
		frame.questWatchList.rowsToDisplay, 
		frame.questWatchList.rowHeight
	)
	frame.questWatchListOffset = FauxScrollFrame_GetOffset( frame.questWatchList.listScrollFrame )
	for iterateDisplayRows = 1, frame.questWatchList.rowsToDisplay do
		-- Reset.
		frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		frame.questWatchList.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + frame.questWatchListOffset
		if dataRowNumber <= AJM:GetQuestWatchMaximumOrder() then
			-- Put information and amount into columns.
			local information, amount, type, questID = AJM:GetQuestWatchInfoAtOrderPosition( dataRowNumber )
			frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetText( information )
			frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetText( amount )
			if type == "QUEST_HEADER" then
				--local textColor = GetQuestDifficultyColor( UnitLevel( "player" ) )
				--frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( textColor["r"], textColor["g"], textColor["b"], 1.0 )
				--frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( textColor["r"], textColor["g"], textColor["b"], 1.0 )
				frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 0.96, 0.41, 1.0 )
				frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 0.96, 0.41, 1.0 )
				--frame.questWatchList.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
			if type == "OBJECTIVE_HEADER" then
				frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1.0 )
				frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1.0 )				
				--frame.questWatchList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 0.75, 0.61, 0, 1.0 )
				--frame.questWatchList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 0.75, 0.61, 0, 1.0 )
			end
		end
	end
end

function AJM:QuestWatcherQuestListRowClick( rowNumber, columnNumber )
	frame = JambaQuestWatcherFrame
	if frame.questWatchListOffset + rowNumber <= AJM:GetQuestWatchMaximumOrder() then
		frame.questWatchHighlightRow = frame.questWatchListOffset + rowNumber
		local information, amount, type, questID = AJM:GetQuestWatchInfoAtOrderPosition( frame.questWatchHighlightRow )
		if type == "QUEST_HEADER" then
			local questIndex = AJM:GetQuestLogIndexByName( information )
			if questIndex ~= 0 then
				if columnNumber == 1 then
					QuestLog_OpenToQuest( questIndex )
				end
				if columnNumber == 2 then
					WorldMap_OpenToQuest( questID )
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- JAMBA QUEST LOG WINDOW
-------------------------------------------------------------------------------------------------------------

function AJM.JambaQuestSelectButtonClicked()
	if AJM:IsCurrentlySelectedQuestValid() == true then
		AJM:JambaSendCommandToTeam( AJM.COMMAND_SELECT_QUEST_LOG_ENTRY, AJM.currentlySelectedQuest, AJM.selectedTag )
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["You must select a quest from the quest log in order to action it on your other characters."] )
	end
end

function AJM.JambaQuestShareButtonClicked()
	if AJM:IsCurrentlySelectedQuestValid() == true then
		if GetQuestLogPushable() == 1 and GetNumPartyMembers() > 0 then
			QuestLogPushQuest()
		end
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["You must select a quest from the quest log in order to action it on your other characters."] )
	end
end

function AJM.JambaQuestTrackButtonClicked()
	if AJM:IsCurrentlySelectedQuestValid() == true then
		local watch = 0
		local questIndex = AJM:GetQuestLogIndexByName( AJM.currentlySelectedQuest )
		if questIndex ~= 0 then
			if IsQuestWatched( questIndex ) == 1 then
				RemoveQuestWatch( questIndex )
				watch = 0
			else
				AddQuestWatch( questIndex )
				watch = 1
			end
		end	
		AJM:JambaSendCommandToTeam( AJM.COMMAND_QUEST_TRACK, AJM.currentlySelectedQuest, watch, AJM.selectedTag )
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["You must select a quest from the quest log in order to action it on your other characters."] )
	end
end

function AJM.JambaQuestTrackAllButtonClicked()
	AJM.iterateQuests = 1
	if AJM.iterateQuests <= GetNumQuestLogEntries() then
		AJM:ScheduleTimer( "TrackNextQuest", 0.5 )
	end
end

function AJM.TrackNextQuest()
	local title, level, tag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle( AJM.iterateQuests )
	if isHeader == nil then
		if title ~= nil then
			SelectQuestLogEntry( AJM.iterateQuests )	
			if AJM:IsCurrentlySelectedQuestValid() == true then
				local watch = 0
				local questIndex = AJM:GetQuestLogIndexByName( AJM.currentlySelectedQuest )
				if questIndex ~= 0 then
					if IsQuestWatched( questIndex ) == 1 then
						RemoveQuestWatch( questIndex )
						watch = 0
					else
						AddQuestWatch( questIndex )
						watch = 1
					end
				end	
				AJM:JambaSendCommandToTeam( AJM.COMMAND_QUEST_TRACK, AJM.currentlySelectedQuest, watch, AJM.selectedTag )
			end	
		end
	end
	AJM.iterateQuests = AJM.iterateQuests + 1
	if AJM.iterateQuests <= GetNumQuestLogEntries() then
		AJM:ScheduleTimer( "TrackNextQuest", 0.5 )
	end
end

function AJM:JambaQuestAbandonQuest()
	if AJM:IsCurrentlySelectedQuestValid() == true then
		AJM:JambaSendCommandToTeam( AJM.COMMAND_ABANDON_QUEST, AJM.currentlySelectedQuest, AJM.selectedTag )
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["You must select a quest from the quest log in order to action it on your other characters."] )
	end
end

function AJM.JambaQuestAbandonButtonClicked()
	if AJM:IsCurrentlySelectedQuestValid() == true then
		StaticPopup_Show( "JAMBAQUEST_CONFIRM_ABANDON_QUEST", AJM.currentlySelectedQuest )
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["You must select a quest from the quest log in order to action it on your other characters."] )
	end
end

function AJM:JambaQuestAbandonAllQuests()
	AJM:JambaSendCommandToTeam( AJM.COMMAND_ABANDON_ALL_QUESTS, AJM.selectedTag )
end

function AJM.AbandonNextQuest()
	local title, level, tag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle( AJM.iterateQuests )
	if isHeader == nil then
		if title ~= nil then
			SelectQuestLogEntry( AJM.iterateQuests )
			SetAbandonQuest()
			AbandonQuest()
			AJM:UpdateQuestLog( nil )
			-- Start again at the top, as to not miss any quests.
			AJM.iterateQuests = 1
		end
	end
	AJM.iterateQuests = AJM.iterateQuests + 1
	if AJM.iterateQuests <= GetNumQuestLogEntries() then
		AJM:ScheduleTimer( "AbandonNextQuest", 0.5 )
	end
end

function AJM.JambaQuestAbandonAllButtonClicked()
	StaticPopup_Show( "JAMBAQUEST_CONFIRM_ABANDON_ALL_QUESTS" )
end

function AJM.JambaQuestShareAllButtonClicked()
	AJM.iterateQuests = 1
	if AJM.iterateQuests <= GetNumQuestLogEntries() then
		AJM:ScheduleTimer( "PushNextQuest", 1 )
	end
end

function AJM.PushNextQuest()
	local title, level, tag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle( AJM.iterateQuests )
	if isHeader == nil then
		if title ~= nil then
			SelectQuestLogEntry( AJM.iterateQuests )
			if GetQuestLogPushable() == 1 and GetNumPartyMembers() > 0 then
				AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["Sharing Quest: A"]( title ) )
				QuestLogPushQuest()
			end			
		end
	end
	AJM.iterateQuests = AJM.iterateQuests + 1
	if AJM.iterateQuests <= GetNumQuestLogEntries() then
		AJM:ScheduleTimer( "PushNextQuest", 1 )
	end
end

function AJM.JambaQuestCloseButtonClicked()
	AJM.jambaQuestLogFrame:Hide()
end

function AJM.JambaQuestTagDropDownOnClick()
	UIDropDownMenu_SetSelectedValue( this.owner, this.value )
	AJM.selectedTag = UIDropDownMenu_GetSelectedValue( AJM.jambaQuestLogFrameDropDownTag )
end

function AJM.JambaQuestTagDropDownInitialize()
	local level = 1
	local info = UIDropDownMenu_CreateInfo()	
	for index, tag in JambaApi.AllTagsList() do
		info.text = tag
		info.value = tag
		info.func = function() AJM.JambaQuestTagDropDownOnClick() end
		info.owner = this:GetParent()
		info.checked = nil
		info.icon = nil
		UIDropDownMenu_AddButton( info, level )
	end
end

function AJM:CreateJambaQuestLogFrame()
	local frameName = "JambaQuestLogWindowFrame"
	local frame = CreateFrame( "Frame", "JambaQuestLogWindowFrame", UIParent )
	frame:SetWidth( 670 )
	frame:SetHeight( 61 )
	frame:SetFrameStrata( "HIGH" )
	frame:SetToplevel( true )
	frame:SetClampedToScreen( true )
	frame:EnableMouse()
	frame:SetMovable( true )	
	frame:ClearAllPoints()
	frame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )
	frame:RegisterForDrag( "LeftButton" )
	frame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() == 1 then
				this:StartMoving() 
			end
		end )
	frame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.framePoint = point
			AJM.db.frameRelativePoint = relativePoint
			AJM.db.frameXOffset = xOffset
			AJM.db.frameYOffset = yOffset
		end	)
	frame:SetBackdrop( {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
		tile = true, tileSize = 15, edgeSize = 15, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	} )
	local buttonHeight = 22	
	local buttonTop = -7
	local buttonTopSecondRow = buttonTop - buttonHeight - 2
	local left = -10
	local spacing = 1
	-- Tags
	local dropDownTag = CreateFrame( "Frame", frameName.."DropDownTag", frame, "UIDropDownMenuTemplate" )
	dropDownTag:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, -4 )
	UIDropDownMenu_SetWidth( dropDownTag, 90 )
	UIDropDownMenu_Initialize( dropDownTag, AJM.JambaQuestTagDropDownInitialize )
	AJM.jambaQuestLogFrameDropDownTag = dropDownTag
	left = left + 125 + spacing
	-- Select.
	local selectButton = CreateFrame( "Button", frameName.."ButtonSelect", frame, "UIPanelButtonTemplate" )
	selectButton:SetScript( "OnClick", AJM.JambaQuestSelectButtonClicked )
	selectButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTop )
	selectButton:SetHeight( buttonHeight )
	selectButton:SetWidth( 100 )
	selectButton:SetText( L["Select"] )		
	left = left + 100 + spacing
	-- Share / Share All.
	local shareButton = CreateFrame( "Button", frameName.."ButtonShare", frame, "UIPanelButtonTemplate" )
	shareButton:SetScript( "OnClick", AJM.JambaQuestShareButtonClicked )
	shareButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTop )
	shareButton:SetHeight( buttonHeight )
	shareButton:SetWidth( 100 )
	shareButton:SetText( L["Share"] )		
	AJM.jambaQuestLogFrameShareButton = shareButton
	local shareAllButton = CreateFrame( "Button", frameName.."ButtonShareAll", frame, "UIPanelButtonTemplate" )
	shareAllButton:SetScript( "OnClick", AJM.JambaQuestShareAllButtonClicked )
	shareAllButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTopSecondRow )
	shareAllButton:SetHeight( buttonHeight )
	shareAllButton:SetWidth( 100 )
	shareAllButton:SetText( L["Share All"] )		
	left = left + 100 + spacing
	-- Track / Track All.
	local trackButton = CreateFrame( "Button", frameName.."ButtonTrack", frame, "UIPanelButtonTemplate" )
	trackButton:SetScript( "OnClick", AJM.JambaQuestTrackButtonClicked )
	trackButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTop )
	trackButton:SetHeight( buttonHeight )
	trackButton:SetWidth( 100 )
	trackButton:SetText( L["Track"] )
	local trackAllButton = CreateFrame( "Button", frameName.."ButtonTrackAll", frame, "UIPanelButtonTemplate" )
	trackAllButton:SetScript( "OnClick", AJM.JambaQuestTrackAllButtonClicked )
	trackAllButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTopSecondRow )
	trackAllButton:SetHeight( buttonHeight )
	trackAllButton:SetWidth( 100 )
	trackAllButton:SetText( L["Track All"] )	
	left = left + 100 + spacing
	-- Abandon / Abandon All.
	local abandonButton = CreateFrame( "Button", frameName.."ButtonAbandon", frame, "UIPanelButtonTemplate" )
	abandonButton:SetScript( "OnClick", AJM.JambaQuestAbandonButtonClicked )
	abandonButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTop )
	abandonButton:SetHeight( buttonHeight )
	abandonButton:SetWidth( 100 )
	abandonButton:SetText( L["Abandon"] )		
	local abandonAllButton = CreateFrame( "Button", frameName.."ButtonAbandonAll", frame, "UIPanelButtonTemplate" )
	abandonAllButton:SetScript( "OnClick", AJM.JambaQuestAbandonAllButtonClicked )
	abandonAllButton:SetPoint( "TOPLEFT", frame, "TOPLEFT", left, buttonTopSecondRow )
	abandonAllButton:SetHeight( buttonHeight )
	abandonAllButton:SetWidth( 100 )
	abandonAllButton:SetText( L["Abandon All"] )		
	left = left + 100 + spacing
	-- Close.
	local closeButton = CreateFrame( "Button", frameName.."ButtonClose", frame, "UIPanelCloseButton" )
	closeButton:SetScript( "OnClick", AJM.JambaQuestCloseButtonClicked )
	closeButton:SetPoint( "TOPRIGHT", frame, "TOPRIGHT", -1, -2 )	
	AJM.jambaQuestLogFrame = frame
	table.insert( UISpecialFrames, "JambaQuestLogWindowFrame" )
	-- Populate tag dropdown.
	UIDropDownMenu_SetText( AJM.jambaQuestLogFrameDropDownTag, JambaApi.AllTag() )
	UIDropDownMenu_SetSelectedName( AJM.jambaQuestLogFrameDropDownTag, JambaApi.AllTag() )
	AJM.selectedTag = JambaApi.AllTag()
	-- Popups.
	StaticPopupDialogs["JAMBAQUEST_CONFIRM_ABANDON_QUEST"] = {
        text = L['Abandon "%s"?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:JambaQuestAbandonQuest()
		end,
    }        
	StaticPopupDialogs["JAMBAQUEST_CONFIRM_ABANDON_ALL_QUESTS"] = {
        text = L["This will abandon ALL quests ON every toon!  Yes, this means you will end up with ZERO quests in your quest log!  Are you sure?"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:JambaQuestAbandonAllQuests()
		end,
    }        
end

function AJM:ToggleFrame( frame )
	if frame == QuestLogFrame then
		if AJM.db.showJambaQuestLogWithWoWQuestLog == true then
			if QuestLogFrame:IsVisible() then
				AJM:ToggleShowQuestCommandWindow( true )		
			else
				AJM:ToggleShowQuestCommandWindow( false )
			end
		end
	end
end

function AJM:QuestLogFrameHide()
	if AJM.db.showJambaQuestLogWithWoWQuestLog == true then
		AJM:ToggleShowQuestCommandWindow( false )
	end
end

function AJM:ToggleShowQuestCommandWindow( show )
    if show == true then	
		AJM.jambaQuestLogFrame:Show()
    else
		AJM.jambaQuestLogFrame:Hide()
    end
end

function AJM:UpdateQuestLog( questIndex )		
	if QuestLogFrame:IsVisible() or QuestLogDetailScrollFrame:IsVisible() then
		if questIndex then
			QuestLog_SetSelection( questIndex )
		end
	end
	if QuestLogFrame:IsVisible() then		
		QuestLog_Update()
	end
	if QuestLogDetailScrollFrame:IsVisible() then		
		QuestLog_UpdateQuestDetails( false );
		QuestLog_UpdateMap();
 	end
	if WatchFrame:IsVisible() then		
		WatchFrame_Update()
 	end
end

function AJM:GetQuestLogIndexByName( questName )
	for iterateQuests = 1, GetNumQuestLogEntries() do
		local title, level, tag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle( iterateQuests )
		if isHeader == nil then
			if title == questName then
				return iterateQuests
			end
		end
	end
	return 0
end

function AJM:SelectQuestLogEntry( questIndex )
	AJM.currentlySelectedQuest =  L["(No Quest Selected)"]
	if questIndex ~= nil then
		local title, level, tag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle( questIndex )
		if isHeader == nil then
			if title ~= nil then
				AJM.currentlySelectedQuest = title
				if AJM.jambaQuestLogFrame:IsVisible() then
					if GetQuestLogPushable() == 1 and GetNumPartyMembers() > 0 then
						AJM.jambaQuestLogFrameShareButton:Enable()
					else
						AJM.jambaQuestLogFrameShareButton:Disable()
					end
				end
			end
		end
	end	
end

function AJM:IsCurrentlySelectedQuestValid()
	if AJM.currentlySelectedQuest:trim() ~= "" and AJM.currentlySelectedQuest ~= L["(No Quest Selected)"] then
		return true
	end
	return false	
end

function AJM:DoSelectQuestLogEntry( sender, questName, tag )
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == true then
		local questIndex = AJM:GetQuestLogIndexByName( questName )
		if questIndex ~= 0 then
			SelectQuestLogEntry( questIndex )
			AJM:UpdateQuestLog( questIndex )
		else
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, L["I do not have the quest: A"]( questName ) )
		end		
	end
end

function AJM:DoQuestTrack( sender, questName, watch, tag )
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == true then
		local questIndex = AJM:GetQuestLogIndexByName( questName )
		if questIndex ~= 0 then
			if watch == 1 then
				AddQuestWatch( questIndex )
			else
				RemoveQuestWatch( questIndex )
			end
			AJM:UpdateQuestLog( questIndex )
		else
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, L["I do not have the quest: A"]( questName ) )
		end		
	end
end

function AJM:DoAbandonQuest( sender, questName, tag )
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == true then
		local questIndex = AJM:GetQuestLogIndexByName( questName )
		if questIndex ~= 0 then
			SelectQuestLogEntry( questIndex )
			--AJM:SetActiveQuestForQuestWatcherCache( questIndex )
			SetAbandonQuest()
			--AJM:RemoveCurrentQuestFromWatcherCache()			
			AbandonQuest()
			AJM:UpdateQuestLog( questIndex )
			AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I have abandoned the quest: A"]( questName ) )
		else
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, L["I do not have the quest: A"]( questName ) )
		end		
	end
end

function AJM:DoAbandonAllQuests( sender, tag )
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == true then
		AJM.iterateQuests = 1
		if AJM.iterateQuests <= GetNumQuestLogEntries() then
			AJM:ScheduleTimer( "AbandonNextQuest", 1 )
		end
	end
end

function AJM:AutoSelectToggleCommand( info, parameters )
	local toggle, tag = strsplit( " ", parameters )
	if tag ~= nil and tag:trim() ~= "" then
		AJM:JambaSendCommandToTeam( AJM.COMMAND_TOGGLE_AUTO_SELECT, toggle, tag )
	else
		AJM:AutoSelectToggle( toggle )
	end	
end

function AJM:DoAutoSelectToggle( sender, toggle, tag )
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == true then
		AJM:AutoSelectToggle( toggle )
	end
end

function AJM:AutoSelectToggle( toggle )
	if toggle == L["toggle"] then
		if AJM.db.allAutoSelectQuests == true then
			toggle = L["off"]
		else
			toggle = L["on"]
		end
	end
	if toggle == L["on"] then
		AJM.db.mirrorMasterQuestSelectionAndDeclining = false
		AJM.db.allAutoSelectQuests = true
	elseif toggle == L["off"] then
		AJM.db.mirrorMasterQuestSelectionAndDeclining = true
		AJM.db.allAutoSelectQuests = false
	end
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- COMMAND MANAGEMENT
-------------------------------------------------------------------------------------------------------------

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_QUEST_WATCH_OBJECTIVE_UPDATE then
		AJM:DoQuestWatchObjectiveUpdate( characterName, ... )
	end
	if commandName == AJM.COMMAND_UPDATE_QUEST_WATCHER_LIST then
		AJM:DoQuestWatchListUpdate( characterName, ... )
	end
	if commandName == AJM.COMMAND_QUEST_WATCH_REMOVE_QUEST then
		AJM:DoRemoveQuestFromWatchList( characterName, ... )
	end
	if commandName == AJM.COMMAND_TOGGLE_AUTO_SELECT then
		AJM:DoAutoSelectToggle( characterName, ... )
	end
	-- Want to action track and abandon command on the same character that sent the command.
	if commandName == AJM.COMMAND_QUEST_TRACK then
		AJM:DoQuestTrack( characterName, ... )
	end
	if commandName == AJM.COMMAND_ABANDON_QUEST then		
		AJM:DoAbandonQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_ABANDON_ALL_QUESTS then		
		AJM:DoAbandonAllQuests( characterName, ... )
	end
	-- If this character sent this command, don't action it.
	if characterName == AJM.characterName then
		return
	end
	if commandName == AJM.COMMAND_ACCEPT_QUEST then		
		AJM:DoAcceptQuest( characterName, ...  )
	end			
	if commandName == AJM.COMMAND_SELECT_GOSSIP_OPTION then		
		AJM:DoSelectGossipOption( characterName, ... )
	end
	if commandName == AJM.COMMAND_SELECT_GOSSIP_ACTIVE_QUEST then		
		AJM:DoSelectGossipActiveQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_SELECT_GOSSIP_AVAILABLE_QUEST then		
		AJM:DoSelectGossipAvailableQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_SELECT_ACTIVE_QUEST then		
		AJM:DoSelectActiveQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_SELECT_AVAILABLE_QUEST then		
		AJM:DoSelectAvailableQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_DECLINE_QUEST then		
		AJM:DoDeclineQuest( characterName, ...  )
	end
	if commandName == AJM.COMMAND_COMPLETE_QUEST then		
		AJM:DoCompleteQuest( characterName, ... )
	end
	if commandName == AJM.COMMAND_CHOOSE_QUEST_REWARD then		
		AJM:DoChooseQuestReward( characterName, ... )
	end
	if commandName == AJM.COMMAND_SELECT_QUEST_LOG_ENTRY then
		AJM:DoSelectQuestLogEntry( characterName, ... )
	end
end

function AJM:PLAYER_REGEN_ENABLED( event, ... )
	if AJM.db.hideQuestWatcherInCombat == true then
		AJM:SetQuestWatcherVisibility()
	end
end

function AJM:PLAYER_REGEN_DISABLED( event, ... )
	if AJM.db.hideQuestWatcherInCombat == true then
		JambaQuestWatcherFrame:Hide()
	end
end

jaqwc = AJM.questWatchCache