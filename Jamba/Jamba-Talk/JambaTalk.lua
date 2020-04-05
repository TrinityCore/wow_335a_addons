--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaTalk", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Talk"
AJM.settingsDatabaseName = "JambaTalkProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-talk"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Talk"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		forwardWhispers = true,
		fakeWhisper = false,
		enableChatSnippets = false,
		chatSnippets = {},
		messageArea = JambaApi.DefaultMessageArea(),
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
				desc = L["Push the talk settings to all characters in the team."],
				usage = "/jamba-talk push",
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

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Purchase Management.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM.settingsControl.checkBoxForwardWhispers:SetValue( AJM.db.forwardWhispers )
	AJM.settingsControl.checkBoxFakeWhispers:SetValue( AJM.db.fakeWhisper )
	AJM.settingsControl.checkBoxEnableChatSnippets:SetValue( AJM.db.enableChatSnippets )
	AJM.settingsControl.dropdownMessageArea:SetValue( AJM.db.messageArea )	
	AJM:SettingsScrollRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.forwardWhispers = settings.forwardWhispers
		AJM.db.fakeWhisper = settings.fakeWhisper
		AJM.db.enableChatSnippets = settings.enableChatSnippets
		AJM.db.messageArea = settings.messageArea
		AJM.db.chatSnippets = JambaUtilities:CopyTable( settings.chatSnippets )
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateOptions( top )
	-- Position and size constants.
	local buttonControlWidth = 105
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local left2 = left + halfWidth + horizontalSpacing
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Talk Options"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.checkBoxForwardWhispers = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Forward Whispers And Relay"],
		AJM.SettingsToggleForwardWhispers
	)	
	movingTop = movingTop - checkBoxHeight	
	AJM.settingsControl.checkBoxFakeWhispers = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Fake Whispers For Clickable Player Names"],
		AJM.SettingsToggleFakeWhispers
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControl.checkBoxEnableChatSnippets = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Enable Chat Snippets"],
		AJM.SettingsToggleChatSnippets
	)	
	movingTop = movingTop - checkBoxHeight		
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Chat Snippets"], movingTop, false )
	movingTop = movingTop - headingHeight	
	AJM.settingsControl.highlightRow = 1
	AJM.settingsControl.offset = 1
	local list = {}
	list.listFrameName = "JambaTalkChatSnippetsSettingsFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = headingWidth
	list.rowHeight = 20
	list.rowsToDisplay = 4
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 25
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 75
	list.columnInformation[2].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsScrollRefresh
	list.rowClickCallback = AJM.SettingsRowClick
	AJM.settingsControl.list = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.list )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControl.buttonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Add"],
		AJM.SettingsAddClick
	)
	AJM.settingsControl.buttonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		buttonControlWidth, 
		left + buttonControlWidth + horizontalSpacing, 
		movingTop,
		L["Remove"],
		AJM.SettingsRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Add Snippet"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.multiEditBoxSnippet = JambaHelperSettings:CreateMultiEditBox( 
		AJM.settingsControl,
		headingWidth,
		left,
		movingTop,
		L["Snippet Text"],
		4
	)
	AJM.settingsControl.multiEditBoxSnippet:SetCallback( "OnEnterPressed", AJM.SettingsMultiEditBoxChangedSnippet )
	local multiEditBoxHeightSnippet = 110
	movingTop = movingTop - multiEditBoxHeightSnippet		
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Talk Messages"], movingTop, false )
	movingTop = movingTop - headingHeight	
	AJM.settingsControl.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Message Area"] 
	)
	AJM.settingsControl.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControl.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing								
	return movingTop
end

local function SettingsCreate()
	AJM.settingsControl = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfSettings = SettingsCreateOptions( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfSettings )
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.list.listScrollFrame, 
		AJM:GetItemsMaxPosition(),
		AJM.settingsControl.list.rowsToDisplay, 
		AJM.settingsControl.list.rowHeight
	)
	AJM.settingsControl.offset = FauxScrollFrame_GetOffset( AJM.settingsControl.list.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.list.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )				
		AJM.settingsControl.list.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.offset
		if dataRowNumber <= AJM:GetItemsMaxPosition() then
			-- Put data information into columns.
			local itemInformation = AJM:GetItemAtPosition( dataRowNumber )
			AJM.settingsControl.list.rows[iterateDisplayRows].columns[1].textString:SetText( itemInformation.name )
			AJM.settingsControl.list.rows[iterateDisplayRows].columns[2].textString:SetText( itemInformation.snippet )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.highlightRow then
				AJM.settingsControl.list.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:SettingsRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.offset + rowNumber <= AJM:GetItemsMaxPosition() then
		AJM.settingsControl.highlightRow = AJM.settingsControl.offset + rowNumber
		local itemInformation = AJM:GetItemAtPosition( AJM.settingsControl.highlightRow )
		if itemInformation ~= nil then
			AJM.settingsControl.multiEditBoxSnippet:SetText( itemInformation.snippet )
		end
		AJM:SettingsScrollRefresh()
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleForwardWhispers( event, checked )
	AJM.db.forwardWhispers = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleFakeWhispers( event, checked )
	AJM.db.fakeWhisper = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleChatSnippets( event, checked )
	AJM.db.enableChatSnippets = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsMultiEditBoxChangedSnippet( event, text )
	local itemInformation = AJM:GetItemAtPosition( AJM.settingsControl.highlightRow )
	if itemInformation ~= nil then
		itemInformation.snippet = text
	end
	AJM:SettingsRefresh()
end

function AJM:SettingsAddClick( event )
	StaticPopup_Show( "JAMBATALK_ASK_SNIPPET" )
end

function AJM:SettingsRemoveClick( event )
	StaticPopup_Show( "JAMBATALK_CONFIRM_REMOVE_CHAT_SNIPPET" )
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
   StaticPopupDialogs["JAMBATALK_ASK_SNIPPET"] = {
        text = L["Enter the shortcut text for this chat snippet:"],
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
		    local value = _G[this:GetParent():GetName().."EditBox"]:GetText()
			AJM:AddItem( value )
		end,
        EditBoxOnTextChanged = function()
            local name = this:GetParent():GetName()
            local button = _G[name.."Button1"]
            local value = _G[this:GetParent():GetName().."EditBox"]:GetText()
            if not value or value:trim() == "" or value:find( "%W" ) ~= nil then
				button:Disable()
            else
                button:Enable()
            end
        end,		
		EditBoxOnEnterPressed = function()
            if _G[this:GetParent():GetName().."Button1"]:IsEnabled() then
				local value = _G[this:GetParent():GetName().."EditBox"]:GetText()
				AJM:AddItem( value )
            end
            this:GetParent():Hide()
        end,		
    }
	StaticPopupDialogs["JAMBATALK_CONFIRM_REMOVE_CHAT_SNIPPET"] = {
        text = L["Are you sure you wish to remove the selected chat snippet?"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveItem()
		end,
    } 
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Remember the last sender to whisper this character.
	AJM.lastSender = nil
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Hook the SendChatMessage to translate any chat snippets.
	AJM:RawHook( "SendChatMessage", true )	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	-- Populate the settings.
	AJM:SettingsRefresh()	
	AJM:SettingsRowClick( 1, 1 )
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "CHAT_MSG_WHISPER" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- JambaTalk functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:GetItemsMaxPosition()
	return #AJM.db.chatSnippets
end

function AJM:GetItemAtPosition( position )
	return AJM.db.chatSnippets[position]
end

function AJM:AddItem( name )
	local itemInformation = {}
	itemInformation.name = name
	itemInformation.snippet = ""
	table.insert( AJM.db.chatSnippets, itemInformation )
	AJM:SettingsRefresh()			
	AJM:SettingsRowClick( 1, 1 )
end

function AJM:RemoveItem()
	table.remove( AJM.db.chatSnippets, AJM.settingsControl.highlightRow )
	AJM:SettingsRefresh()
	AJM:SettingsRowClick( 1, 1 )		
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
end

-- The SendChatMessage hook.
function AJM:SendChatMessage( ... )
	local message, chatType, language, target = ...
	if chatType == "WHISPER" then
		-- Does this character have chat snippets enabled?
		if AJM.db.enableChatSnippets == true then
			local snippetName = select( 3, message:find( "^!(%w+)$" ) )
			-- If a snippet name was found...
			if snippetName then
				-- Then look up the associated text.
				local messageToSend = AJM:GetTextForSnippet( snippetName )
				JambaApi.SendChatMessage( messageToSend, "WHISPER", target, JambaApi.COMMUNICATION_PRIORITY_BULK )
				-- Finish with the chat message, i.e. do not let the original handler run.
				return true
			end
		end
	end
	-- Call the orginal function.
	return AJM.hooks["SendChatMessage"]( ... )
end

function AJM:CHAT_MSG_WHISPER( chatType, message, sender, language, channelName, target, flag, ... )
	-- Does this character forward whispers?
	if AJM.db.forwardWhispers == true then
		-- Set a GM flag if this whisper was from a GM.
		local isGM = false
		if flag == L["GM"] then
			isGM = true
		end
		-- Was the sender the master?
		if JambaApi.IsCharacterTheMaster( sender ) == true then
			-- Yes, relay the masters message to others.
			AJM:ForwardWhisperFromMaster( message )
		else		
			-- Not the master, forward the whisper to the master.
			AJM:ForwardWhisperToMaster( message, sender, isGM )
		end
	end
end

function AJM:ForwardWhisperToMaster( message, sender, isGM )
	-- From who and forward message?
	local fromCharacterFake = "|Hplayer:"..sender.."|h["..sender.."]|h"
	local fromCharacterWhisper = sender
	local forwardMessage = true
	-- Don't relay messages to the master or self (causes infinite loop, which causes disconnect).
	if (JambaApi.IsCharacterTheMaster( AJM.characterName )) or (AJM.characterName == sender) then
		forwardMessage = false
	end
	-- Don't relay messages from the master either (not that this situation should happen).
	if JambaApi.IsCharacterTheMaster( sender ) == true then
		forwardMessage = false
	end
	-- Allowed to forward the message?	
	if forwardMessage == true then
		-- Set the from character information.
		if isGM == true then
			fromCharacter = L["<GM>"]..fromCharacter
		end
		-- Whisper the master.
		if AJM.db.fakeWhisper == true then
			AJM:JambaSendMessageToTeam( "JambaTalkWhisper", fromCharacterFake..L[" whispers: "]..message )
		else
			JambaApi.SendChatMessage( fromCharacterWhisper..": "..message, "WHISPER", JambaApi.GetMasterName(), JambaApi.COMMUNICATION_PRIORITY_BULK )
		end
		-- Remember this sender as the most recent sender.
		AJM.lastSender = sender
	end
end

function AJM:ForwardWhisperFromMaster( messageFromMaster )
	-- Who to send to and what to send?
	-- Check the message to see if there is a character to whisper to; character name is preceeded by @.
	-- No match will return nil for the parameters.
	local sendTo, messageToInspect = select( 3, messageFromMaster:find( "^@(%w+)%s*(.*)$" ) )
	-- If no sender found in message...
	if not sendTo then
		-- Then send to last sender.
		sendTo = AJM.lastSender
		-- Send the full message.
		messageToInspect = messageFromMaster
	end
	-- Check to see if there is a snippet name in the message (text with a leading !).
	local messageToSend = messageToInspect
	if AJM.db.enableChatSnippets == true then
		local snippetName = select( 3, messageToInspect:find( "^!(%w+)$" ) )
		-- If a snippet name was found...
		if snippetName then
			-- Then look up the associated text.
			messageToSend = AJM:GetTextForSnippet( snippetName )
		end
	end
	-- If there is a valid character to send to...
	if sendTo then
		if messageToSend:trim() ~= "" then
			-- Send the message.
			JambaApi.SendChatMessage( messageToSend, "WHISPER", sendTo, JambaApi.COMMUNICATION_PRIORITY_BULK )
		end
		-- Remember this sender as the most recent sender.
		AJM.lastSender = sendTo
	end
end

function AJM:GetTextForSnippet( snippetName )
	local snippet = ""
	for position, itemInformation in pairs( AJM.db.chatSnippets ) do
		if itemInformation.name == snippetName then
			snippet = itemInformation.snippet
			break
		end
	end
	return snippet
end
