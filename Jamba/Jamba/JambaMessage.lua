--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaMessage",
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

-- Constants and Locale for this module.
AJM.moduleName = "Jamba-Message"
AJM.settingsDatabaseName = "JambaMessageProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-message"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Core: Message Display"]

-------------------------------------------------------------------------------------------------------------
-- Message area management.
-------------------------------------------------------------------------------------------------------------

-- areas = {}
-- areas["areaname"].type
-- areas["areaname"].tag
-- areas["areaname"].channelName
-- areas["areaname"].channelPassword
-- areas["areaname"].chatWindowName 
-- areas["areaname"].areaOnScreenName 

-- Message area types.
AJM.AREA_TYPE_DEFAULT_CHAT = 1
--AJM.AREA_TYPE_SPECIFIC_CHAT = 2
AJM.AREA_TYPE_WHISPER = 3
AJM.AREA_TYPE_PARTY = 4
AJM.AREA_TYPE_GUILD = 5
AJM.AREA_TYPE_GUILD_OFFICER = 6
AJM.AREA_TYPE_RAID = 7
AJM.AREA_TYPE_RAID_WARNING = 8
--AJM.AREA_TYPE_CHANNEL = 9
AJM.AREA_TYPE_PARROT = 10
AJM.AREA_TYPE_MSBT = 11
AJM.AREA_TYPE_MUTE = 12
AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT = 13

-- Message area types names and uses information.
AJM.areaTypes = {}
-- Default chat window.
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT] = {}
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].name = L["Default Chat Window"]
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_DEFAULT_CHAT].mustBeWired = true
-- Specific chat window.
--[[
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT] = {}
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].name = L["Specific Chat Window"]
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].usesChatWindowName = true
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_SPECIFIC_CHAT].mustBeWired = true
]]--
-- Whisper.
AJM.areaTypes[AJM.AREA_TYPE_WHISPER] = {}
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].name = L["Whisper"]
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER].mustBeWired = true
-- Party.
AJM.areaTypes[AJM.AREA_TYPE_PARTY] = {}
AJM.areaTypes[AJM.AREA_TYPE_PARTY].name = L["Party"]
AJM.areaTypes[AJM.AREA_TYPE_PARTY].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_PARTY].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_PARTY].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_PARTY].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_PARTY].mustBeWired = false
-- Guild.
AJM.areaTypes[AJM.AREA_TYPE_GUILD] = {}
AJM.areaTypes[AJM.AREA_TYPE_GUILD].name = L["Guild"]
AJM.areaTypes[AJM.AREA_TYPE_GUILD].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD].mustBeWired = false
-- Guild Officer.
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER] = {}
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].name = L["Guild Officer"]
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_GUILD_OFFICER].mustBeWired = false
-- Raid.
AJM.areaTypes[AJM.AREA_TYPE_RAID] = {}
AJM.areaTypes[AJM.AREA_TYPE_RAID].name = L["Raid"]
AJM.areaTypes[AJM.AREA_TYPE_RAID].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_RAID].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_RAID].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_RAID].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_RAID].mustBeWired = false
-- Raid Warning.
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING] = {}
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].name = L["Raid Warning"]
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_RAID_WARNING].mustBeWired = true
-- Private Channel.
--[[
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL] = {}
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].name = L["Channel"]
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].usesChannel = true
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_CHANNEL].mustBeWired = false
]]--
-- Area On Screen Via Parrot.
AJM.areaTypes[AJM.AREA_TYPE_PARROT] = {}
AJM.areaTypes[AJM.AREA_TYPE_PARROT].name = L["Parrot"]
AJM.areaTypes[AJM.AREA_TYPE_PARROT].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_PARROT].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_PARROT].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_PARROT].usesScreen = true
AJM.areaTypes[AJM.AREA_TYPE_PARROT].mustBeWired = true
-- Area On Screen Via MSBT.
AJM.areaTypes[AJM.AREA_TYPE_MSBT] = {}
AJM.areaTypes[AJM.AREA_TYPE_MSBT].name = L["MikScrollingBattleText"]
AJM.areaTypes[AJM.AREA_TYPE_MSBT].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_MSBT].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_MSBT].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_MSBT].usesScreen = true
AJM.areaTypes[AJM.AREA_TYPE_MSBT].mustBeWired = true
-- Mute.
AJM.areaTypes[AJM.AREA_TYPE_MUTE] = {}
AJM.areaTypes[AJM.AREA_TYPE_MUTE].name = L["Mute"]
AJM.areaTypes[AJM.AREA_TYPE_MUTE].usesTag = false
AJM.areaTypes[AJM.AREA_TYPE_MUTE].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_MUTE].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_MUTE].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_MUTE].mustBeWired = false
-- Whisper to Default Chat (for Jamba-Talk).
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT] = {}
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].name = L["Default Chat Whisper"]
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].usesTag = true
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].usesChannel = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].usesChatWindowName = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].usesScreen = false
AJM.areaTypes[AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT].mustBeWired = true

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		["areas"] = {
			{
				["type"] = 1,
				["name"] = L["Default Message"],
				["tag"] = JambaPrivate.Tag.MasterTag(),
			},
			{
				["type"] = 8,
				["name"] = L["Default Warning"],
				["tag"] = JambaPrivate.Tag.MasterTag(),
			},
			{
				["type"] = 8,
				["name"] = L["Default Proc Area"],
				["tag"] = JambaPrivate.Tag.AllTag(),
			},
			{
				["type"] = 12,
				["name"] = L["Mute (Default)"],
			},			
		},
	},
}

 AJM.simpleAreaList = {}
 
-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = "group",
		get = "JambaConfigurationGetSetting",
		set = "JambaConfigurationSetSetting",
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the message settings to all characters in the team."],
				usage = "/jamba-message push",
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

AJM.COMMAND_MESSAGE = "JambaMessageMessage"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Constants used by module.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Settings Populate.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	-- Update the settings area list.
	AJM:SettingsAreaListScrollRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.areas = JambaUtilities:CopyTable( settings.areas )
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Area management.
-------------------------------------------------------------------------------------------------------------

local function MessageAreaList()
	JambaUtilities:ClearTable( AJM.simpleAreaList )
	for index, area in ipairs( AJM.db.areas ) do
		AJM.simpleAreaList[area.name] = area.name
	end
	table.sort( AJM.simpleAreaList )
	return AJM.simpleAreaList
end

local function GetAreaByName( areaName )
	if areaName == "JambaTalkWhisper" then
		local area = {}
		area.name = "JambaTalkWhisper"
		area.type = AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT 
		area.tag = JambaPrivate.Tag.MasterTag()
		return area
	else
		for index, area in ipairs( AJM.db.areas ) do
			if area.name == areaName then
				return area
			end
		end
	end
	return nil
end

local function GetAreaAtPosition( position )
	return AJM.db.areas[position]
end

local function SetAreaAtPosition( position, areaInformation )
	AJM.db.areas[position] = areaInformation
end
	
local function GetAreaListMaxPosition()
	return #AJM.db.areas
end

local function DoesAreaListContainArea( name )
	local containsArea = false
	for index, area in ipairs( AJM.db.areas ) do
		if area.name == name then
			containsArea = true
			break
		end
	end
	return containsArea
end

local function AddArea( name )
	if DoesAreaListContainArea( name ) == false then
		-- Add a new area.
		local newArea = {}
		newArea.name = name
		newArea.type = AJM.AREA_TYPE_DEFAULT_CHAT
		table.insert( AJM.db.areas, newArea )
		-- Refresh the settings.
		AJM:SettingsRefresh()			
	end
end
		
local function RemoveArea( name )
	if DoesAreaListContainArea( name ) == true then
		local areaIndex = 0
		for index, area in ipairs( AJM.db.areas ) do
			if area.name == name then
				areaIndex = index
				break
			end
		end
		if areaIndex ~= 0 then
			table.remove( AJM.db.areas, areaIndex )
		end
	end
end

function AJM:AddAreaGUI( name )
	AddArea( name )
	AJM:SettingsAreaListScrollRefresh()
end

function AJM:RemoveAreaGUI()
	local area = GetAreaAtPosition( AJM.settingsControl.areaListHighlightRow )	
	RemoveArea( area.name )
	AJM.settingsControl.areaListHighlightRow = 1	
	AJM:SettingsAreaListScrollRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateAreaList()
	-- Position and size constants.
	local areaListButtonControlWidth = 125
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local top = JambaHelperSettings:TopOfSettings()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local areaListWidth = headingWidth
	-- Team list internal variables (do not change).
	AJM.settingsControl.areaListHighlightRow = 1
	AJM.settingsControl.areaListOffset = 1
	-- Create a heading.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Message Area List"], top, false )
	-- Create an area list frame.
	local list = {}
	list.listFrameName = "JambaMessageSettingsAreaListFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = top - headingHeight
	list.listLeft = left
	list.listWidth = areaListWidth
	list.rowHeight = 20
	list.rowsToDisplay = 8
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 60
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 40
	list.columnInformation[2].alignment = "LEFT"
	list.scrollRefreshCallback = AJM.SettingsAreaListScrollRefresh
	list.rowClickCallback = AJM.SettingsAreaListRowClick
	AJM.settingsControl.areaList = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.areaList )
	-- Position and size constants (once list height is known).
	local bottomOfList = top - headingHeight - list.listHeight - verticalSpacing	
	local bottomOfSection = bottomOfList - verticalSpacing - buttonHeight - verticalSpacing 
	-- Create buttons.
	AJM.settingsControl.areaListButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		areaListButtonControlWidth, 
		left, 
		bottomOfList, 
		L["Add"],
		AJM.SettingsAddClick
	)
	AJM.settingsControl.areaListButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		areaListButtonControlWidth, 
		left + horizontalSpacing + areaListButtonControlWidth, 
		bottomOfList, 
		L["Remove"],
		AJM.SettingsRemoveClick
	)	
	return bottomOfSection
end

local function SettingsCreateAreaTypes( top )
	local areaListButtonControlWidth = 125
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - (horizontalSpacing  * 3)) / 2
	local column1Left = left
	local column2Left = left + halfWidth + (horizontalSpacing * 3)
	local areaConfigurationTop = top - headingHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Message Area Configuration"], top, false )
	AJM.settingsControl.areaTypeDropdown = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		areaConfigurationTop, 
		L["Message Area Type"] 
	)
	areaConfigurationTop = areaConfigurationTop - dropdownHeight
	local areaList = {}
	for areaType, areaTypeInformation in pairs( AJM.areaTypes ) do
		areaList[areaType] = areaTypeInformation.name
	end
	AJM.settingsControl.areaTypeDropdown:SetList( areaList )
	AJM.settingsControl.areaTypeDropdown:SetCallback( "OnValueChanged", AJM.UpdateAreaTypeControls )
	AJM.settingsControl.areaEditBoxTag = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		column1Left,
		areaConfigurationTop,
		L["Tag"]
	)
	AJM.settingsControl.areaEditBoxTag:SetCallback( "OnEnterPressed", AJM.EditBoxTagChanged )
	areaConfigurationTop = areaConfigurationTop - dropdownHeight	
	AJM.settingsControl.areaEditBoxName = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		column1Left,
		areaConfigurationTop,
		L["Name"]
	)
	AJM.settingsControl.areaEditBoxName:SetCallback( "OnEnterPressed", AJM.EditBoxNameChanged )
	areaConfigurationTop = areaConfigurationTop - dropdownHeight	
	AJM.settingsControl.areaEditBoxPassword = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		headingWidth,
		column1Left,
		areaConfigurationTop,
		L["Password"]
	)	
	AJM.settingsControl.areaEditBoxPassword:SetCallback( "OnEnterPressed", AJM.EditBoxPasswordChanged )
	areaConfigurationTop = areaConfigurationTop - dropdownHeight	
	AJM.settingsControl.areaOnScreenDropdown = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		areaConfigurationTop, 
		L["Area On Screen"] 
	)
	AJM.settingsControl.areaOnScreenDropdown:SetCallback( "OnValueChanged", AJM.UpdateAreaOnScreenControls )
	areaConfigurationTop = areaConfigurationTop - dropdownHeight
	areaConfigurationTop = areaConfigurationTop - verticalSpacing - verticalSpacing		
	AJM.settingsControl.areaListButtonUpdate = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		areaListButtonControlWidth, 
		column1Left, 
		areaConfigurationTop, 
		L["Save"],
		AJM.SettingsUpdateClick
	)		
	areaConfigurationTop = areaConfigurationTop - buttonHeight
	AJM.settingsControl.areaEditBoxTag:SetDisabled( true )
	AJM.settingsControl.areaEditBoxTag:SetText( "" )
	AJM.settingsControl.areaEditBoxName:SetDisabled( true )
	AJM.settingsControl.areaEditBoxName:SetText( "" )
	AJM.settingsControl.areaEditBoxPassword:SetDisabled( true )
	AJM.settingsControl.areaEditBoxPassword:SetText( "" )	
	AJM.settingsControl.areaOnScreenDropdown:SetDisabled( true )
	AJM.settingsControl.areaOnScreenDropdown:SetText( "" )
	local bottomOfSection = areaConfigurationTop
	return bottomOfSection	
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
	-- Create the area list controls.
	local bottomOfAreaList = SettingsCreateAreaList()
	-- Create the area type configuration controls.
	local bottomOfAreaTypes = SettingsCreateAreaTypes( bottomOfAreaList )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfAreaTypes )
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsAreaListScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.areaList.listScrollFrame, 
		GetAreaListMaxPosition(),
		AJM.settingsControl.areaList.rowsToDisplay, 
		AJM.settingsControl.areaList.rowHeight
	)
	AJM.settingsControl.areaListOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.areaList.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.areaList.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.areaList.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.areaListOffset
		if dataRowNumber <= GetAreaListMaxPosition() then
			-- Put area name and type into columns.
			local areaInformation = GetAreaAtPosition( dataRowNumber )
			local areaName = areaInformation.name
			local areaType = AJM.areaTypes[areaInformation.type].name
			AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[1].textString:SetText( areaName )
			AJM.settingsControl.areaList.rows[iterateDisplayRows].columns[2].textString:SetText( areaType )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.areaListHighlightRow then
				AJM.settingsControl.areaList.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:UpdateAreaTypeControls( event, areaTypeIdentifier )		
	AJM.currentlySelectedAreaTypeIdentifier = areaTypeIdentifier
	local areaType = AJM.areaTypes[areaTypeIdentifier]
	-- Disable all controls.
	AJM.settingsControl.areaEditBoxTag:SetDisabled( true )
	AJM.settingsControl.areaEditBoxName:SetDisabled( true )
	AJM.settingsControl.areaEditBoxPassword:SetDisabled( true )
	AJM.settingsControl.areaOnScreenDropdown:SetDisabled( true )
	-- Enable controls if they are used.
	if areaType.usesTag == true then
		AJM.settingsControl.areaEditBoxTag:SetDisabled( false )
	end
	if areaType.usesChannel == true then
		AJM.settingsControl.areaEditBoxName:SetDisabled( false )
		AJM.settingsControl.areaEditBoxPassword:SetDisabled( false )
	end
	if areaType.usesChatWindowName == true then
		AJM.settingsControl.areaEditBoxName:SetDisabled( false )
	end
	if areaType.usesScreen == true then
		-- Parrot.
		if areaTypeIdentifier == AJM.AREA_TYPE_PARROT then
			if Parrot ~= nil then
				AJM.settingsControl.areaOnScreenDropdown:SetList( Parrot.GetScrollAreasChoices() )
				AJM.settingsControl.areaOnScreenDropdown:SetDisabled( false )
			else
				AJM.settingsControl.areaOnScreenDropdown:SetText( L["ERROR: Parrot Missing"] )
			end
		end
		-- MSBT.
		if areaTypeIdentifier == AJM.AREA_TYPE_MSBT then
			if MikSBT ~= nil then
				local scrollAreas = {}
				for scrollAreaKey, scrollAreaName in MikSBT.IterateScrollAreas() do
					scrollAreas[scrollAreaKey] = scrollAreaName
				end 
				AJM.settingsControl.areaOnScreenDropdown:SetList( scrollAreas )
				AJM.settingsControl.areaOnScreenDropdown:SetDisabled( false )
			else
				AJM.settingsControl.areaOnScreenDropdown:SetText( L["ERROR: MikScrollingBattleText Missing"] )
			end
		end
	end
end

local function UpdateAreaTypeInformation()		
	-- Update the area type controls to reflect the information for this selection.
	local areaInformation = GetAreaAtPosition( AJM.settingsControl.areaListHighlightRow )
	local areaType = AJM.areaTypes[areaInformation.type]
	-- Set the area type control.
	AJM.settingsControl.areaTypeDropdown:SetValue( areaInformation.type )
	AJM:UpdateAreaTypeControls( "OnValueChanged", areaInformation.type )
	-- Clear controls.
	AJM.settingsControl.areaEditBoxTag:SetText( "" )
	AJM.settingsControl.areaEditBoxName:SetText( "" )
	AJM.settingsControl.areaEditBoxPassword:SetText( "" )
	AJM.settingsControl.areaOnScreenDropdown:SetText( "" )
	-- Populate controls if they are used.
	if areaType.usesTag == true then
		AJM.settingsControl.areaEditBoxTag:SetText( areaInformation.tag )
		AJM.currentEditBoxTagText = areaInformation.tag
	end
	if areaType.usesChannel == true then
		AJM.settingsControl.areaEditBoxName:SetText( areaInformation.channelName )
		AJM.currentEditBoxNameText = areaInformation.channelName
		AJM.settingsControl.areaEditBoxPassword:SetText( areaInformation.channelPassword )
		AJM.currentEditBoxPasswordText = areaInformation.channelPassword
	end
	if areaType.usesChatWindowName == true then
		AJM.settingsControl.areaEditBoxName:SetText( areaInformation.chatWindowName )
		AJM.currentEditBoxNameText = areaInformation.chatWindowName
	end
	if areaType.usesScreen == true then
		AJM.settingsControl.areaOnScreenDropdown:SetValue( areaInformation.areaOnScreenName )
		AJM:UpdateAreaOnScreenControls( "OnValueChanged", areaInformation.areaOnScreenName )
	end
end

function AJM:SettingsAreaListRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.areaListOffset + rowNumber <= GetAreaListMaxPosition() then
		AJM.settingsControl.areaListHighlightRow = AJM.settingsControl.areaListOffset + rowNumber
		UpdateAreaTypeInformation()
		AJM:SettingsAreaListScrollRefresh()
	end
end

function AJM:EditBoxTagChanged( event, text )
	AJM.currentEditBoxTagText = text
end

function AJM:EditBoxNameChanged( event, text )
	AJM.currentEditBoxNameText = text
end

function AJM:EditBoxPasswordChanged( event, text )
	AJM.currentEditBoxPasswordText = text
end

local function SetAreaConfigurationIntoCurrentArea()
	-- Get information from table at position.
	local areaInformation = GetAreaAtPosition( AJM.settingsControl.areaListHighlightRow )
	-- Update the area type for this area.
	areaInformation.type = AJM.currentlySelectedAreaTypeIdentifier
	-- Get the area information.
	local areaType = AJM.areaTypes[areaInformation.type]
	-- Update the area information according to the area type.
	if areaType.usesTag == true then
		areaInformation.tag = AJM.currentEditBoxTagText
	end
	if areaType.usesChannel == true then
		areaInformation.channelName = AJM.currentEditBoxNameText
		areaInformation.channelPassword = AJM.currentEditBoxPasswordText
	end
	if areaType.usesChatWindowName == true then
		areaInformation.chatWindowName = AJM.currentEditBoxNameText
	end
	if areaType.usesScreen == true then
		areaInformation.areaOnScreenName = AJM.currentlySelectedAreaOnScreenName
	end	
	-- Put information back into table at position.
	SetAreaAtPosition( AJM.settingsControl.areaListHighlightRow, areaInformation )
	-- Refresh the settings.
	AJM:SettingsRefresh()
end

function AJM:UpdateAreaOnScreenControls( event, areaOnScreenName )		
	AJM.currentlySelectedAreaOnScreenName = areaOnScreenName
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsUpdateClick( event )
	SetAreaConfigurationIntoCurrentArea()
end

function AJM:SettingsAddClick( event )
	StaticPopup_Show( "JAMBAMESSAGE_ASK_AREA_NAME" )
end

function AJM:SettingsRemoveClick( event )
	local area = GetAreaAtPosition( AJM.settingsControl.areaListHighlightRow )
	StaticPopup_Show( "JAMBAMESSAGE_CONFIRM_REMOVE_AREA", area.name )
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
   StaticPopupDialogs["JAMBAMESSAGE_ASK_AREA_NAME"] = {
        text = L["Enter name of the message area to add:"],
        button1 = ACCEPT,
        button2 = CANCEL,
        hasEditBox = 1,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
		OnShow = function()
            local name = this:GetName()
            _G[name.."EditBox"]:SetText("")
            _G[name.."Button1"]:Disable()
            _G[name.."EditBox"]:SetFocus()
        end,		
        OnAccept = function()
		    local messageName = _G[this:GetParent():GetName().."EditBox"]:GetText()
			AJM:AddAreaGUI( messageName )
		end,
        EditBoxOnTextChanged = function()
            local name = this:GetParent():GetName()
            local button = _G[name.."Button1"]
            local messageName = _G[this:GetParent():GetName().."EditBox"]:GetText()
            if not messageName or messageName:trim() == "" then
				button:Disable()
            else
                button:Enable()
            end
        end,		
		EditBoxOnEnterPressed = function()
            if _G[this:GetParent():GetName().."Button1"]:IsEnabled() then
				local messageName = _G[this:GetParent():GetName().."EditBox"]:GetText()
				AJM:AddAreaGUI( messageName )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMESSAGE_CONFIRM_REMOVE_AREA"] = {
        text = L['Are you sure you wish to remove "%s" from the message area list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveAreaGUI()
		end,
    }        
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	AJM.currentlySelectedAreaTypeIdentifier = AJM.AREA_TYPE_DEFAULT_CHAT
	AJM.currentEditBoxTagText = ""
	AJM.currentEditBoxNameText = ""
	AJM.currentEditBoxPasswordText = ""	
	AJM.currentlySelectedAreaOnScreenName = ""
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	-- Click the area list first row, column to set the child controls.
	AJM:SettingsAreaListRowClick( 1, 1 )
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- Kickstart the settings team list scroll frame.
	AJM:SettingsAreaListScrollRefresh()
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- Send messages.
-------------------------------------------------------------------------------------------------------------

local function DefaultMessageArea()
	return L["Default Message"]
end

local function DefaultWarningArea()
	return L["Default Warning"]
end

local function DisplayMessageWhisperInDefaultChat( sender, message )
	DEFAULT_CHAT_FRAME:AddMessage( "|cffff80ff|Hplayer:"..sender.."|h["..sender.."]|h"..L[" whispers: "]..message.."|r" )
end

local function DisplayMessageDefaultChat( sender, message )
	DEFAULT_CHAT_FRAME:AddMessage( "|Hplayer:"..sender.."|h["..sender.."]|h"..L[": "]..message )
end

local function DisplayMessageChatWhisper( sender, message )
	-- The whisper comes across the wire and you whisper yourself...
	JambaPrivate.Communications.SendChatMessage( message, "WHISPER", sender, JambaPrivate.Communications.COMMUNICATION_PRIORITY_ALERT )
end

local function DisplayMessageChat( sender, message, chatDestination )
	local canSend = false
	if (chatDestination == "GUILD" or chatDestination == "OFFICER") and IsInGuild() == 1 then	
		canSend = true
	else
		AJM:Print( L["ERROR: Not in a Guild"] )
	end
	if chatDestination == "PARTY" and GetNumPartyMembers() > 0 then	
		canSend = true
	else
		AJM:Print( L["ERROR: Not in a Party"] )
	end
	if chatDestination == "RAID" and GetNumRaidMembers() > 0 then	
		canSend = true
	else
		AJM:Print( L["ERROR: Not in a Raid"] )
	end	
	if canSend == true then
		JambaPrivate.Communications.SendChatMessage( sender..L[": "]..message, chatDestination, nil, JambaPrivate.Communications.COMMUNICATION_PRIORITY_ALERT )
	else
		AJM:Print( message )	
	end	
end

local function DisplayMessageRaidWarning( sender, message )
	RaidNotice_AddMessage( RaidWarningFrame, sender..L[": "]..message, ChatTypeInfo["RAID_WARNING"] )
	PlaySound( "RaidWarning" )
end
		
local function DisplayMessageParrot( sender, message, areaOnScreenName )
	if Parrot ~= nil then
		Parrot:ShowMessage( sender..L[": "]..message, areaOnScreenName, true )
	else
		AJM:Print( L["ERROR: Parrot Missing"] )
		AJM:Print( message )
	end		
end

local function DisplayMessageMikSBT( sender, message, areaOnScreenName )
	if MikSBT ~= nil then
		if MikSBT.IsModDisabled() == true then
			AJM:Print( L["ERROR: MikScrollingBattleText Disabled"] )
			AJM:Print( message )
		else
			MikSBT.DisplayMessage( sender..L[": "]..message, areaOnScreenName, true )
		end
	else
		AJM:Print( L["ERROR: MikScrollingBattleText Missing"] )
		AJM:Print( message )
	end		
end

local function ProcessReceivedMessage( sender, areaName, message )
	-- Get the area requested.
	local area = GetAreaByName( areaName )
	if area == nil then
		AJM:Print( L["ERROR: Could not find area: A"]( areaName ) )
		AJM:Print( message )
		return
	end
	-- What sort of area is this?
	local areaType = AJM.areaTypes[area.type]
	-- Does this area type use tags?  If so, check the tag.
	if areaType.usesTag == true then
		if JambaPrivate.Tag.DoesCharacterHaveTag( AJM.characterName, area.tag ) == false then
			-- Tag not on this character, bail.
			return
		end
	end
	-- Display the message.
	if area.type == AJM.AREA_TYPE_DEFAULT_CHAT then
		DisplayMessageDefaultChat( sender, message )
	end
	if area.type == AJM.AREA_TYPE_WHISPER_DEFAULT_CHAT then
		DisplayMessageWhisperInDefaultChat( sender, message )
	end	
	if area.type == AJM.AREA_TYPE_SPECIFIC_CHAT then
		-- TODO
	end
	if area.type == AJM.AREA_TYPE_WHISPER then
		DisplayMessageChatWhisper( sender, message )
	end
	if area.type == AJM.AREA_TYPE_PARTY then
		DisplayMessageChat( sender, message, "PARTY" )
	end
	if area.type == AJM.AREA_TYPE_GUILD then
		DisplayMessageChat( sender, message, "GUILD" )
	end
	if area.type == AJM.AREA_TYPE_GUILD_OFFICER then
		DisplayMessageChat( sender, message, "OFFICER" )
	end
	if area.type == AJM.AREA_TYPE_RAID then
		DisplayMessageChat( sender, message, "RAID" )
	end
	if area.type == AJM.AREA_TYPE_RAID_WARNING then
		DisplayMessageRaidWarning( sender, message )
	end
	if area.type == AJM.AREA_TYPE_CHANNEL then
		-- TODO
	end
	if area.type == AJM.AREA_TYPE_PARROT then
		DisplayMessageParrot( sender, message, area.areaOnScreenName )
	end
	if area.type == AJM.AREA_TYPE_MSBT then
		DisplayMessageMikSBT( sender, message, area.areaOnScreenName )
	end
	if area.type == AJM.AREA_TYPE_MUTE then
		-- Do nothing! Mute means eat the message.
	end
end

local function SendMessage( areaName, message )
	-- Get the area requested.
	local area = GetAreaByName( areaName )
	if area == nil then
		AJM:Print( L["ERROR: Could not find area: A"]( areaName ) )
		AJM:Print( message )
		return
	end
	-- What sort of area is this?
	local areaType = AJM.areaTypes[area.type]
	-- Does this area type use tags?  If so, find out if the message needs to be sent over the wire.
	local sendToJustMe = false
	if areaType.usesTag == true then
		if area.tag == JambaPrivate.Tag.JustMeTag() then
			sendToJustMe = true
		end
		if area.tag == JambaPrivate.Tag.MasterTag() and JambaPrivate.Team.IsCharacterTheMaster( AJM.characterName ) == true then
			sendToJustMe = true
		end
	end
	-- Send over the wire or process locally?
	if sendToJustMe == true or areaType.mustBeWired == false then
		ProcessReceivedMessage( AJM.characterName, areaName, message )
	else
		AJM:JambaSendCommandToTeam( AJM.COMMAND_MESSAGE, areaName, message )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Commands.
-------------------------------------------------------------------------------------------------------------

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_MESSAGE then		
		ProcessReceivedMessage( characterName, ... )
	end
end

-- Functions available from Jamba Message for other Jamba internal objects.
JambaPrivate.Message.SendMessage = SendMessage

-- Functions available for other addons.
JambaApi.MessageAreaList = MessageAreaList
JambaApi.DefaultMessageArea = DefaultMessageArea
JambaApi.DefaultWarningArea = DefaultWarningArea