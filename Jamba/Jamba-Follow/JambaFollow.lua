--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaFollow", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Follow"
AJM.settingsDatabaseName = "JambaFollowProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-follow"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Follow"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		warnWhenFollowBreaks = true, 
		followBrokenMessage = L["Follow Broken!"],
		autoFollowAfterCombat = false,  
		useAfterCombatDelay = false,
		afterCombatDelay = "3",
		strobeFrequencySeconds = "1",
		strobeFrequencySecondsInCombat = "3",
		doNotWarnFollowBreakInCombat = false,
		doNotWarnFollowBreakMembersInCombat = false,
		doNotWarnFollowStrobing = false,
		strobePauseInCombat = false,
		--strobePauseMembersInCombat = false,
		strobePauseIfDrinking = false,
		strobePauseIfInVehicle = false,
		strobePauseTag = JambaApi.AllTag(),
		warningArea = JambaApi.DefaultWarningArea(),
		followMaster = "",
		useFollowMaster = false,
		overrideStrobeTargetWithMaster = false,
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		childGroups  = "tab",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the follow settings to all characters in the team."],
				usage = "/jamba-follow push",
				get = false,
				set = "JambaSendSettings",
			},											
			master = {
				type = "input",
				name = L["Follow The Master"],
				desc = L["Follow the current master."],
				usage = "/jamba-follow master <tag>",
				get = false,
				set = "FollowMasterCommand",
			},					
			target = {
				type = "input",
				name = L["Follow A Target"],
				desc = L["Follow the target specified."],
				usage = "/jamba-follow target <target> <tag>",
				get = false,
				set = "FollowTargetCommand",
			},					
			afterCombat = {
				type = "input",
				name = L["Auto Follow After Combat"],
				desc = L["Automatically follow after combat."],
				usage = "/jamba-follow aftercombat <on|off> <tag>",
			},															
			strobeOn = {
				type = "input",
				name = L["Begin Follow Strobing Target."],
				desc = L["Begin a sequence of follow commands that strobe every second (configurable) a specified target."],
				usage = "/jamba-follow strobeon <target> <tag>",
				get = false,
				set = "FollowStrobeOnCommand",
			},	
			strobeOnMe = {
				type = "input",
				name = L["Begin Follow Strobing Me."],
				desc = L["Begin a sequence of follow commands that strobe every second (configurable) this character."],
				usage = "/jamba-follow strobeonme <tag>",
				get = false,
				set = "FollowStrobeOnMeCommand",
			},								
			strobeOnLast = {
				type = "input",
				name = L["Begin Follow Strobing Last Target."],
				desc = L["Begin a sequence of follow commands that strobe every second (configurable) the last follow target character."],
				usage = "/jamba-follow strobeonlast <tag>",
				get = false,
				set = "FollowStrobeOnLastCommand",
			},				
			strobeOff = {
				type = "input",
				name = L["End Follow Strobing."],
				desc = L["End the strobing of follow commands."],
				usage = "/jamba-follow strobeoff <tag>",
				get = false,
				set = "FollowStrobeOffCommand",
			},	
			setmaster = {
				type = "input",
				name = L["Master"],
				desc = L["Set the follow master character."],
				usage = "/jamba-follow setmaster <name> <tag>",
				get = false,
				set = "CommandSetFollowMaster",
			},									
		},
	}
	return configuration
end

local function DebugMessage( ... )
	AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_FOLLOW_TARGET = "FollowTarget"
AJM.COMMAND_AUTO_FOLLOW_AFTER_COMBAT = "AutoFollowAfterCombat"
AJM.COMMAND_FOLLOW_STROBE_ON = "FollowStrobeOn"
AJM.COMMAND_FOLLOW_STROBE_OFF = "FollowStrobeOff"
AJM.COMMAND_SET_FOLLOW_MASTER = "FollowMaster"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function BuildAndSetTeamList()
	JambaUtilities:ClearTable( AJM.teamList )
	for characterName, order in JambaApi.TeamList() do
		table.insert( AJM.teamList, characterName )
	end
	AJM.settingsControl.dropdownFollowMaster:SetList( AJM.teamList )
end

local function SettingsCreateDisplayOptions( top )
	-- Get positions.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( true )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local thirdWidth = (headingWidth - (horizontalSpacing * 2)) / 3
	local column2left = left + halfWidth
	local left2 = left + thirdWidth
	local left3 = left + (thirdWidth * 2)
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Follow After Combat"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxAutoFollowAfterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Follow After Combat"],
		AJM.SettingsToggleAutoFollowAfterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxDelayAutoFollowAfterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Delay Follow After Combat (s)"],
		AJM.SettingsToggleDelayAutoFollowAfterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.editBoxFollowAfterCombatDelaySeconds = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["Seconds To Delay Before Following After Combat"]
	)	
	AJM.settingsControl.editBoxFollowAfterCombatDelaySeconds:SetCallback( "OnEnterPressed", AJM.EditBoxChangedFollowAfterCombatDelaySeconds )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Follow Master"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxUseFollowMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Use Different Master For Follow"],
		AJM.SettingsToggleUseFollowMaster
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.dropdownFollowMaster = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["Follow Master"] 
	)
	BuildAndSetTeamList()
	AJM.settingsControl.dropdownFollowMaster:SetCallback( "OnValueChanged", AJM.SettingsSetFollowMaster )
	movingTop = movingTop - dropdownHeight - verticalSpacing	
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Follow Broken Warning"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxWarnWhenFollowBreaks = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If I Stop Following"],
		AJM.SettingsToggleWarnWhenFollowBreaks
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.editBoxFollowBrokenMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["Follow Broken Message"]
	)	
	AJM.settingsControl.editBoxFollowBrokenMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedFollowBrokenMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControl.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Warning Area"] 
	)
	AJM.settingsControl.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing	
	AJM.settingsControl.labelDoNotWarnIf = JambaHelperSettings:CreateLabel( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["Do Not Warn If"]
	)	
	movingTop = movingTop - labelHeight	
	AJM.settingsControl.checkBoxDoNotWarnInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["In Combat"],
		AJM.SettingsToggleDoNotWarnInCombat
	)	
	AJM.settingsControl.checkBoxDoNotWarnMembersInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		column2left, 
		movingTop, 
		L["Any Member In Combat"],
		AJM.SettingsToggleDoNotWarnMembersInCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxDoNotWarnFollowStrobing = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["Follow Strobing"],
		AJM.SettingsToggleDoNotWarnFollowStrobing
	)		
	movingTop = movingTop - checkBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Follow Strobing"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.labelStrobeHelp = JambaHelperSettings:CreateLabel( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["Follow strobing is controlled by /jamba-follow commands."]
	)	
	movingTop = movingTop - labelHeight	
	AJM.settingsControl.checkBoxOverrideStrobeTargetWithMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Always Use Master As The Strobe Target"],
		AJM.SettingsToggleOverrideStrobeTargetWithMaster
	)	
	movingTop = movingTop - checkBoxHeight	
	AJM.settingsControl.labelPauseStrobeHelp = JambaHelperSettings:CreateLabel( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop,
		L["Pause Follow Strobing If"]
	)	
	movingTop = movingTop - labelHeight	
	AJM.settingsControl.checkBoxPauseInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["In Combat"],
		AJM.SettingsTogglePauseInCombat
	)	
	--[[
	AJM.settingsControl.checkBoxPauseMembersInCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		column2left, 
		movingTop, 
		L["Any Member In Combat"],
		AJM.SettingsTogglePauseMembersInCombat
	)	
	movingTop = movingTop - checkBoxHeight
	]]--
	AJM.settingsControl.checkBoxPauseDrinking = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		column2left, --left, 
		movingTop, 
		L["Drinking/Eating"],
		AJM.SettingsTogglePauseDrinking
	)		
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxPauseIfInVehicle = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop, 
		L["In A Vehicle"],
		AJM.SettingsTogglePauseIfInVehicle
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.editBoxFollowStrobePauseTag = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["Tag For Pause Follow Strobe"]
	)	
	AJM.settingsControl.editBoxFollowStrobePauseTag:SetCallback( "OnEnterPressed", AJM.EditBoxChangedFollowStrobePauseTag )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControl.editBoxFollowStrobeDelaySeconds = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		halfWidth,
		left,
		movingTop,
		L["Frequency (s)"]
	)	
	AJM.settingsControl.editBoxFollowStrobeDelaySeconds:SetCallback( "OnEnterPressed", AJM.EditBoxChangedFollowStrobeDelaySeconds )
	AJM.settingsControl.editBoxFollowStrobeDelaySecondsInCombat = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		halfWidth,
		column2left,
		movingTop,
		L["Frequency In Combat (s)"]
	)	
	AJM.settingsControl.editBoxFollowStrobeDelaySecondsInCombat:SetCallback( "OnEnterPressed", AJM.EditBoxChangedFollowStrobeDelaySecondsInCombat )	
	movingTop = movingTop - editBoxHeight
	return movingTop	
end

local function SettingsCreate()
	AJM.settingsControl = {}
	-- Create the settings panel.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfDisplayOptions = SettingsCreateDisplayOptions( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfDisplayOptions )
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
	-- Set values.
	AJM.settingsControl.checkBoxAutoFollowAfterCombat:SetValue( AJM.db.autoFollowAfterCombat )
	AJM.settingsControl.checkBoxDelayAutoFollowAfterCombat:SetValue( AJM.db.useAfterCombatDelay )
	AJM.settingsControl.editBoxFollowAfterCombatDelaySeconds:SetText( AJM.db.afterCombatDelay )
	AJM.settingsControl.checkBoxWarnWhenFollowBreaks:SetValue( AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.editBoxFollowBrokenMessage:SetText( AJM.db.followBrokenMessage )
	AJM.settingsControl.checkBoxDoNotWarnInCombat:SetValue( AJM.db.doNotWarnFollowBreakInCombat )
	AJM.settingsControl.checkBoxDoNotWarnMembersInCombat:SetValue( AJM.db.doNotWarnFollowBreakMembersInCombat )
	AJM.settingsControl.checkBoxDoNotWarnFollowStrobing:SetValue( AJM.db.doNotWarnFollowStrobing )
	AJM.settingsControl.checkBoxOverrideStrobeTargetWithMaster:SetValue( AJM.db.overrideStrobeTargetWithMaster )
	AJM.settingsControl.checkBoxPauseInCombat:SetValue( AJM.db.strobePauseInCombat )
	--AJM.settingsControl.checkBoxPauseMembersInCombat:SetValue( AJM.db.strobePauseMembersInCombat )
	AJM.settingsControl.checkBoxPauseDrinking:SetValue( AJM.db.strobePauseIfDrinking )
	AJM.settingsControl.checkBoxPauseIfInVehicle:SetValue( AJM.db.strobePauseIfInVehicle )
	AJM.settingsControl.editBoxFollowStrobePauseTag:SetText( AJM.db.strobePauseTag )
	AJM.settingsControl.editBoxFollowStrobeDelaySeconds:SetText( AJM.db.strobeFrequencySeconds )
	AJM.settingsControl.editBoxFollowStrobeDelaySecondsInCombat:SetText( AJM.db.strobeFrequencySecondsInCombat )
	AJM.settingsControl.dropdownWarningArea:SetValue( AJM.db.warningArea )
	AJM.settingsControl.dropdownFollowMaster:SetValue( AJM.db.followMaster )
	AJM.settingsControl.checkBoxUseFollowMaster:SetValue( AJM.db.useFollowMaster )
	-- Set state.
	AJM.settingsControl.checkBoxDelayAutoFollowAfterCombat:SetDisabled( not AJM.db.autoFollowAfterCombat )
	AJM.settingsControl.editBoxFollowAfterCombatDelaySeconds:SetDisabled( not AJM.db.autoFollowAfterCombat or not AJM.db.useAfterCombatDelay )
	AJM.settingsControl.dropdownFollowMaster:SetDisabled( not AJM.db.useFollowMaster )
	AJM.settingsControl.editBoxFollowBrokenMessage:SetDisabled( not AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.checkBoxDoNotWarnInCombat:SetDisabled( not AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.checkBoxDoNotWarnMembersInCombat:SetDisabled( not AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.checkBoxDoNotWarnFollowStrobing:SetDisabled( not AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.dropdownWarningArea:SetDisabled( not AJM.db.warnWhenFollowBreaks )
	AJM.settingsControl.labelDoNotWarnIf:SetDisabled( not AJM.db.warnWhenFollowBreaks )
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleUseFollowMaster( event, checked )
	AJM.db.useFollowMaster = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoFollowAfterCombat( event, checked )
	AJM.db.autoFollowAfterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDelayAutoFollowAfterCombat( event, checked )
	AJM.db.useAfterCombatDelay = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenFollowBreaks( event, checked )
	AJM.db.warnWhenFollowBreaks = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedFollowBrokenMessage( event, text )
	AJM.db.followBrokenMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDoNotWarnInCombat( event, checked )
	AJM.db.doNotWarnFollowBreakInCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDoNotWarnMembersInCombat( event, checked )
	AJM.db.doNotWarnFollowBreakMembersInCombat = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleDoNotWarnFollowStrobing( event, checked )
	AJM.db.doNotWarnFollowStrobing = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleOverrideStrobeTargetWithMaster( event, checked )
	AJM.db.overrideStrobeTargetWithMaster = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsTogglePauseInCombat( event, checked )
	AJM.db.strobePauseInCombat = checked
	AJM:SettingsRefresh()
end

--[[
function AJM:SettingsTogglePauseMembersInCombat( event, checked )
	AJM.db.strobePauseMembersInCombat = checked
	AJM:SettingsRefresh()
end
]]--

function AJM:SettingsTogglePauseDrinking( event, checked )
	AJM.db.strobePauseIfDrinking = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsTogglePauseIfInVehicle( event, checked )
	AJM.db.strobePauseIfInVehicle = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedFollowStrobePauseTag( event, text )
	AJM.db.strobePauseTag = text
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedFollowStrobeDelaySeconds( event, text )
	AJM.db.strobeFrequencySeconds = text
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedFollowStrobeDelaySecondsInCombat( event, text )
	AJM.db.strobeFrequencySecondsInCombat = text
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetFollowMaster( event, value )
	AJM.db.followMaster = value
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- An empty team list.
	AJM.teamList = {}
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Current follow target.
	AJM.currentFollowTarget = JambaApi.GetMasterName()
	AJM:UpdateFollowTargetToFollowMaster()
	-- Set to true if jamba initiated a follow.
	AJM.jambaSetFollowTarget = false
	-- Strobing follow.
	AJM.currentFollowStrobeTarget = JambaApi.GetMasterName()
	AJM.followingStrobing = false
	AJM.followStrobeTimer = nil
	AJM.followingStrobingPaused = false	
	-- Not in combat flag.
	AJM.outOfCombat = true
	-- Character on taxi flag.
	AJM.characterIsOnTaxi = false
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- WoW events.
	AJM:RegisterEvent( "AUTOFOLLOW_BEGIN" )
	AJM:RegisterEvent( "AUTOFOLLOW_END" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )	
	AJM:RegisterEvent( "PLAYER_CONTROL_GAINED" )
	AJM:RegisterEvent( "UNIT_ENTERING_VEHICLE" )
	AJM:RegisterEvent( "UNIT_EXITING_VEHICLE" )
	-- Jamba events.
	if JambaApi.Taxi ~= nil then
		AJM:RegisterMessage( JambaApi.Taxi.MESSAGE_TAXI_TAKEN, "CharacterOnTaxi" )	
	end
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_MASTER_CHANGED, "OnMasterChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_ADDED, "OnTeamChanged" )
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_REMOVED, "OnTeamChanged" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.warnWhenFollowBreaks = settings.warnWhenFollowBreaks
		AJM.db.followBrokenMessage = settings.followBrokenMessage
		AJM.db.autoFollowAfterCombat = settings.autoFollowAfterCombat
		AJM.db.strobeFrequencySeconds = settings.strobeFrequencySeconds
		AJM.db.strobeFrequencySecondsInCombat = settings.strobeFrequencySecondsInCombat
		AJM.db.doNotWarnFollowBreakInCombat = settings.doNotWarnFollowBreakInCombat
		AJM.db.doNotWarnFollowBreakMembersInCombat = settings.doNotWarnFollowBreakMembersInCombat
		AJM.db.strobePauseInCombat = settings.strobePauseInCombat
		AJM.db.strobePauseIfInVehicle = settings.strobePauseIfInVehicle
		--AJM.db.strobePauseMembersInCombat = settings.strobePauseMembersInCombat
		AJM.db.strobePauseIfDrinking = settings.strobePauseIfDrinking
		AJM.db.strobePauseTag = settings.strobePauseTag
		AJM.db.doNotWarnFollowStrobing = settings.doNotWarnFollowStrobing
		AJM.db.warningArea = settings.warningArea
		AJM.db.followMaster = settings.followMaster
		AJM.db.useFollowMaster = settings.useFollowMaster
		AJM.db.overrideStrobeTargetWithMaster = settings.overrideStrobeTargetWithMaster
		AJM.db.useAfterCombatDelay = settings.useAfterCombatDelay
		AJM.db.afterCombatDelay = settings.afterCombatDelay
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- JambaFollow functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:UNIT_ENTERING_VEHICLE()
	if AJM.db.strobePauseIfInVehicle == true then
		if AJM.followingStrobing == true then
			if AJM.followingStrobingPaused == false then
				AJM:FollowStrobingPause( true )
			end
		end
	end
end

function AJM:UNIT_EXITING_VEHICLE()
	if AJM.db.strobePauseIfInVehicle == true then
		if AJM.followingStrobing == true then
			if AJM.followingStrobingPaused == true then
				AJM:FollowStrobingPause( false )
			end
		end
	end
end

function AJM:AreTeamMembersInCombat()
	local inCombat = false
	for index, characterName in JambaApi.TeamListOrdered() do
		-- Is the team member online?
		if JambaApi.GetCharacterOnlineStatus( characterName ) == true then
			-- Yes, is the character in combat?
			if UnitAffectingCombat( characterName ) == 1 then
				inCombat = true
				break
			end
		end
	end
	return inCombat
end

function AJM:IsFollowingStrobing()
	return AJM.followingStrobing
end

function AJM:IsFollowingStrobingPaused()
	return AJM.followingStrobingPaused
end

function AJM:CharacterOnTaxi()
	AJM:SetNoFollowBrokenWarningNextBreak()
	if AJM:IsFollowingStrobing() == true then
		if AJM:IsFollowingStrobingPaused() == false then
			AJM:FollowStrobingPause( true )
			AJM.characterIsOnTaxi = true
		end
	end
end

function AJM:PLAYER_CONTROL_GAINED()
	if AJM.characterIsOnTaxi == true then
		AJM.characterIsOnTaxi = false
		if AJM:IsFollowingStrobing() == true then
			if AJM:IsFollowingStrobingPaused() == true then
				AJM:FollowStrobingPause( false )
				AJM.characterIsOnTaxi = true
			end
		end
	end
end

function AJM:SetNoFollowBrokenWarningNextBreak()
	AJM.jambaExternalNoWarnNextBreak = true	
end

function AJM:AUTOFOLLOW_BEGIN( event, ... )
end

function AJM:AUTOFOLLOW_END( event, ... )
	-- Argument 1 has the reason follow ended, this does not come back from the event parameters.
	--DebugMessage( event, arg1 )
	local followEndedBecause = arg1
	-- If warn if auto follow breaks is on...
	local canWarn = false
	if AJM.db.warnWhenFollowBreaks == true then
		if not followEndedBecause then	
			if AJM.jambaSetFollowTarget == false then
				canWarn = true			
			end
		end
	end
	-- Do not warn if in combat?
	if AJM.db.doNotWarnFollowBreakInCombat == true and AJM.outOfCombat == false then
		canWarn = false
	end
	-- Do not warn if any other members in combat?
	if AJM.db.doNotWarnFollowBreakMembersInCombat == true and AJM:AreTeamMembersInCombat() == true then
		canWarn = false
	end
	-- Don't warn about follow breaking if follow strobing is on or paused.
	if AJM.db.doNotWarnFollowStrobing == true then
		if AJM.followingStrobing == true or AJM.followStrobingPaused == true then
			canWarn = false
		end
	end
	-- Is another Jamba module supressing this warning?
	if AJM.jambaExternalNoWarnNextBreak == true then
		canWarn = false
	end
	-- If allowed to warn, then warn.
	if canWarn == true then
		AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.followBrokenMessage )
	end
	AJM.jambaSetFollowTarget = false		
	AJM.jambaExternalNoWarnNextBreak = false
end

--[[
function AJM:ProcessMemberCombatStatusUpdate()
	-- Pause follow strobing while member in combat?
	if AJM.db.strobePauseMembersInCombat == true then
		-- Yes, is a member in combat?
		if  AJM:AreTeamMembersInCombat() == true then
			AJM:FollowStrobingPause( true )
		else
			AJM:FollowStrobingPause( false )
		end
	end
end
--]]

function AJM:PLAYER_REGEN_ENABLED()
	AJM.outOfCombat = true
	-- Is auto follow after combat on?
	if AJM.db.autoFollowAfterCombat == true then
		if AJM.db.useAfterCombatDelay == false then
			AJM:FollowTarget( AJM.currentFollowTarget )
		else
			AJM:ScheduleTimer( "FollowTarget", tonumber( AJM.db.afterCombatDelay ), AJM.currentFollowTarget )
		end
	end
	-- Is follow strobing on?
	if AJM:IsFollowingStrobing() == true then
		-- Pause follow strobing while in combat?
		if AJM.db.strobePauseInCombat == true then
			-- Un-pause follow strobing.
			AJM:FollowStrobingPause( false )
		else
			-- Not pausing, so check strobe rate.
			if AJM.db.strobeFrequencySeconds ~= AJM.db.strobeFrequencySecondsInCombat then
				AJM:FollowStrobeOn( AJM.currentFollowStrobeTarget )
			end
		end	
	end
end

function AJM:PLAYER_REGEN_DISABLED()
	AJM.outOfCombat = false
	-- Is follow strobing on?
	if AJM:IsFollowingStrobing() == true then
		-- Pause follow strobing while in combat?
		if AJM.db.strobePauseInCombat == true then
			-- Pause follow strobing.
			AJM:FollowStrobingPause( true )
		else
			-- Not pausing, so check strobe rate.
			if AJM.db.strobeFrequencySeconds ~= AJM.db.strobeFrequencySecondsInCombat then
				AJM:FollowStrobeOn( AJM.currentFollowStrobeTarget )
			end
		end
	end
end

function AJM:AutoFollowAfterCombatCommand( info, parameters )
	-- Get the on/off state and the tag of who to send to.
	local state, tag = strsplit( " ", parameters )			
	if tag ~= nil and tag:trim() ~= "" then
		AJM:AutoFollowAfterCombatSendCommand( state, tag )
	else
		AJM:DoToggleAutoFollowAfterCombat( state )
	end	
end

function AJM:AutoFollowAfterCombatSendCommand( state, tag )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_AUTO_FOLLOW_AFTER_COMBAT, state, tag )
end

function AJM:AutoFollowAfterCombatReceiveCommand( state, tag )
	-- If this character responds to this tag...
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) then
		AJM:DoToggleAutoFollowAfterCombat( state )
	end
end

function AJM:DoToggleAutoFollowAfterCombat( state )
	-- Translate the on/off state from string to boolean/nil.
	local setToOn = JambaUtilities:GetOnOrOffFromCommand( state, L["on"], L["off"] )	
	-- If nil, then assume false.
	if setToOn == nil then
		setToOn = false
	end		
	-- Then set the flag appropriately.
	AJM:SettingsToggleAutoFollowAfterCombat( nil, setToOn )
	-- Refresh the settings.
	AJM:SettingsRefresh()
end

function AJM:GetCurrentFollowTarget()
	return AJM.currentFollowTarget
end

function AJM:GetCurrentFollowStrobeTarget()
	return AJM.currentFollowStrobeTarget
end

function AJM:UpdateFollowTargetToFollowMaster()
	if AJM.db.useFollowMaster == true then
		AJM.currentFollowTarget = JambaApi.GetMasterName()
		if AJM.db.followMaster ~= "" then
			if JambaApi.GetCharacterOnlineStatus( AJM.db.followMaster ) == true then
				AJM.currentFollowTarget = AJM.db.followMaster
			end
		end
	end
end

function AJM:OnMasterChanged()
	if AJM.db.autoFollowAfterCombat == true then
		AJM.currentFollowTarget = JambaApi.GetMasterName()	
		AJM:UpdateFollowTargetToFollowMaster()
	end
	if AJM.followingStrobing == true then
		if AJM.db.overrideStrobeTargetWithMaster == true then
			AJM.currentFollowStrobeTarget = JambaApi.GetMasterName()
			AJM:FollowStrobeOn( AJM.currentFollowStrobeTarget )
		end
	end
end

function AJM:OnTeamChanged()
	BuildAndSetTeamList()
end

function AJM:CommandSetFollowMaster( info, parameters )
	local target, tag = strsplit( " ", parameters )
	target = JambaUtilities:Capitalise( target )
	if tag ~= nil and tag:trim() ~= "" then 
		AJM:JambaSendCommandToTeam( AJM.COMMAND_SET_FOLLOW_MASTER, target, tag )
	else
		AJM.db.followMaster = target
		AJM:UpdateFollowTargetToFollowMaster()
	end
end

function AJM:ReceiveCommandSetFollowMaster( target, tag )
	if JambaPrivate.Tag.DoesCharacterHaveTag( AJM.characterName, tag ) then
		AJM.db.followMaster = target
		AJM:UpdateFollowTargetToFollowMaster()
	end
end

function AJM:FollowMasterCommand( info, parameters )
	-- The only parameter for this command is tag.  If there is a tag, send the command to all
	-- the members, otherwise just this character.
	local tag = parameters
	-- Set the current follow target to the master.
	AJM.currentFollowTarget = JambaApi.GetMasterName()
	AJM:UpdateFollowTargetToFollowMaster()
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowTargetSendCommand( AJM.currentFollowTarget, tag )
	else
		AJM:FollowTarget( AJM.currentFollowTarget )
	end	
end

function AJM:FollowTargetCommand( info, parameters )
	local target, tag = strsplit( " ", parameters )
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowTargetSendCommand( target, tag )
	else
		AJM.currentFollowTarget = target
		AJM:FollowTarget( AJM.currentFollowTarget )
	end	
end

function AJM:FollowTargetSendCommand( target, tag )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_FOLLOW_TARGET, target, tag )
end

function AJM:FollowTargetReceiveCommand( target, tag )
	-- If this character responds to this tag...
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) then
		-- Then follow the target specified.
		AJM.currentFollowTarget = target
		AJM:FollowTarget( AJM.currentFollowTarget )
	end
end

function AJM:FollowStrobeOnMeCommand( info, parameters )
	local tag = parameters
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowStrobeOnSendCommand( AJM.characterName, tag )
	else
		AJM:FollowStrobeOn( AJM.characterName )
	end	
end

function AJM:FollowStrobeOnLastCommand( info, parameters )
	local tag = parameters
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowStrobeOnSendCommand( AJM.currentFollowStrobeTarget, tag )
	else
		AJM:FollowStrobeOn( AJM.currentFollowStrobeTarget )
	end	
end

function AJM:FollowStrobeOnCommand( info, parameters )
	local target, tag = strsplit( " ", parameters )
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowStrobeOnSendCommand( target, tag )
	else
		AJM:FollowStrobeOn( target )
	end	
end

function AJM:FollowStrobeOnSendCommand( target, tag )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_FOLLOW_STROBE_ON, target, tag )
end

function AJM:FollowStrobeOnReceiveCommand( target, tag )
	-- If this character responds to this tag...
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) then
		-- Then follow the target specified - strobing.
		AJM:FollowStrobeOn( target )
	end
end

function AJM:FollowStrobeOffCommand( info, parameters )
	local tag = parameters
	if tag ~= nil and tag:trim() ~= "" then
		AJM:FollowStrobeOffSendCommand( tag )
	else		
		AJM:FollowStrobeOff()
	end	
end

function AJM:FollowStrobeOffSendCommand( tag )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_FOLLOW_STROBE_OFF, tag )
end

function AJM:FollowStrobeOffReceiveCommand( tag )
	-- If this character responds to this tag...
	if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) then
		-- Then follow the target specified - turn off strobing.
		AJM:FollowStrobeOff()
	end
end	

function AJM:FollowTarget( target )
	-- Attempting to follow self?  Note: if target ever is party1, etc, then this will not catch the same character.
	if JambaUtilities:Capitalise( target ) == JambaUtilities:Capitalise( AJM.characterName ) then
		return
	end
	local canFollowTarget = true
	-- If follow strobing and pause strobing if drinking then...
	if AJM.followingStrobing == true and AJM.db.strobePauseIfDrinking == true then
		-- And the character has the pause tag...
		if JambaApi.DoesCharacterHaveTag( AJM.characterName, AJM.db.strobePauseTag ) == true then
			-- Check player for drinking buff.
			if JambaUtilities:DoesThisCharacterHaveBuff( L["Drink"] ) == true then
				-- Have drinking buff, do not allow follow.
				canFollowTarget = false
			end
			if JambaUtilities:DoesThisCharacterHaveBuff( L["Food"] ) == true then
				-- Have eating buff, do not allow follow.
				canFollowTarget = false
			end
		end
	end
	-- If follow strobing and strobing paused.
	if AJM.followingStrobing == true and AJM.followingStrobingPaused == true then
		-- Follow strobing is paused, do not follow target.
		canFollowTarget = false		
	end
	-- If allowed to follow the target, then...
	if canFollowTarget == true then
		-- Set the jamba set this flag toggle, so not to complain about follow broken after combat.
		if (AJM.db.autoFollowAfterCombat == true) or (AJM.followingStrobing == true) then
			AJM.jambaSetFollowTarget = true	
		end
		-- Follow unit only works when in a party or raid for resolving against player names.
		FollowUnit( target )
	end	
end

function AJM:FollowStrobeOn( target )
	AJM.currentFollowStrobeTarget = target
	-- Do the initial follow.
    AJM:FollowTarget( AJM.currentFollowStrobeTarget )
	-- If the timer is running, then 
	if AJM.followingStrobing == true then
		AJM:FollowStrobeOff()
	end
	-- Set up a timer to do another follow command.
	AJM.followingStrobing = true
	local seconds = AJM.db.strobeFrequencySeconds
	if InCombatLockdown() then
		seconds = AJM.db.strobeFrequencySecondsInCombat
	end
	AJM.followStrobeTimer = AJM:ScheduleRepeatingTimer( "FollowTarget", tonumber( seconds ), AJM.currentFollowStrobeTarget )
end

function AJM:FollowStrobeOff()
	-- Stop the timer from doing another follow command.
	if AJM.followingStrobing == true then
		AJM.followingStrobing = false
		AJM:CancelTimer( AJM.followStrobeTimer )
	end	
end

function AJM:FollowStrobingPause( pause )
	if pause == true then
		-- Is follow strobing on?
		if AJM.followingStrobing == true then
			-- Yes, turn it off, if this character has a tag that matches the pause follow strobe tag.
			if JambaApi.DoesCharacterHaveTag( AJM.characterName, AJM.db.strobePauseTag ) == true then
				AJM.followingStrobingPaused = true
			end
		end
	else
		-- Is follow strobing paused?
		if AJM.followingStrobingPaused == true then
			-- Yes, turn it on, if this character has a tag that matches the pause follow strobe tag.
			if JambaApi.DoesCharacterHaveTag( AJM.characterName, AJM.db.strobePauseTag ) == true then
				AJM.followingStrobingPaused = false
			end
		end
	end	
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_FOLLOW_TARGET then
		AJM:FollowTargetReceiveCommand( ... )
	end
	if commandName == AJM.COMMAND_AUTO_FOLLOW_AFTER_COMBAT then
		AJM:AutoFollowAfterCombatReceiveCommand( ... )
	end
	if commandName == AJM.COMMAND_FOLLOW_STROBE_ON then
		AJM:FollowStrobeOnReceiveCommand( ... )
	end
	if commandName == AJM.COMMAND_FOLLOW_STROBE_OFF then
		AJM:FollowStrobeOffReceiveCommand( ... )
	end
	if commandName == AJM.COMMAND_SET_FOLLOW_MASTER then
		AJM:ReceiveCommandSetFollowMaster( ... )
	end
end

JambaApi.Follow = {}
JambaApi.Follow.IsFollowingStrobing = AJM.IsFollowingStrobing
JambaApi.Follow.IsFollowingStrobingPaused = AJM.IsFollowingStrobingPaused
JambaApi.Follow.GetCurrentFollowTarget = AJM.GetCurrentFollowTarget
JambaApi.Follow.GetCurrentFollowStrobeTarget = AJM.GetCurrentFollowStrobeTarget