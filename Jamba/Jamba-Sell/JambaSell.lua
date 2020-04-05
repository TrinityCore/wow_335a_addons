--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaSell", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local AceGUI = LibStub:GetLibrary( "AceGUI-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Sell"
AJM.settingsDatabaseName = "JambaSellProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-sell"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Sell: Greys"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		sellItemOnAllWithAltKey = false,
		autoSellPoorItems = false,
		autoSellPoorItemsHaveExceptions = false,
		autoSellPoorItemsExceptionList = {},
		autoSellOtherItems = false,
		autoSellOtherItemsList = {},
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
			--[[
			popout = {
				type = "input",
				name = L["PopOut"],
				desc = L["Show the sell other settings in their own window."],
				usage = "/jamba-sell popout",
				get = false,
				set = "ShowPopOutWindow",
			},
			]]--
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the sell settings to all characters in the team."],
				usage = "/jamba-sell push",
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

AJM.COMMAND_SELL_ITEM = "SellItem"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Sell Management.
-------------------------------------------------------------------------------------------------------------

AJM.BAG_PLAYER_BACKPACK = 0
-- NUM_BAG_SLOTS is defined as 4 in Blizzard's FrameXML\BankFrame.lua.
AJM.BAG_PLAYER_MAXIMUM = NUM_BAG_SLOTS
AJM.ITEM_QUALITY_POOR = 0

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	-- Sell on all with alt key.
	AJM.settingsControlGreys.checkBoxSellItemOnAllWithAltKey:SetValue( AJM.db.sellItemOnAllWithAltKey )
	-- Messages.
	AJM.settingsControlGreys.dropdownMessageArea:SetValue( AJM.db.messageArea )
	-- Greys.
	AJM.settingsControlGreys.checkBoxAutoSellPoorItems:SetValue( AJM.db.autoSellPoorItems )
	AJM.settingsControlGreys.checkBoxAutoSellPoorItemsHaveExceptions:SetValue( AJM.db.autoSellPoorItemsHaveExceptions )
	AJM.settingsControlGreys.greysEditBoxExceptionTag:SetText( AJM.autoSellPoorItemExceptionTag )
	AJM.settingsControlGreys.checkBoxAutoSellPoorItemsHaveExceptions:SetDisabled( not AJM.db.autoSellPoorItems )
	AJM.settingsControlGreys.greysEditBoxExceptionItem:SetDisabled( not AJM.db.autoSellPoorItems or not AJM.db.autoSellPoorItemsHaveExceptions )
	AJM.settingsControlGreys.greysEditBoxExceptionTag:SetDisabled( not AJM.db.autoSellPoorItems or not AJM.db.autoSellPoorItemsHaveExceptions )
	AJM.settingsControlGreys.greysButtonRemove:SetDisabled( not AJM.db.autoSellPoorItems or not AJM.db.autoSellPoorItemsHaveExceptions )
	AJM.settingsControlGreys.greysButtonAdd:SetDisabled( not AJM.db.autoSellPoorItems or not AJM.db.autoSellPoorItemsHaveExceptions )
	-- Others. 
	AJM.settingsControlOthers.checkBoxAutoSellOtherItems:SetValue( AJM.db.autoSellOtherItems )
	AJM.settingsControlOthers.othersEditBoxOtherTag:SetText( AJM.autoSellOtherItemTag )
	AJM.settingsControlOthers.othersEditBoxOtherItem:SetDisabled( not AJM.db.autoSellOtherItems )
	AJM.settingsControlOthers.othersEditBoxOtherTag:SetDisabled( not AJM.db.autoSellOtherItems )
	AJM.settingsControlOthers.othersButtonRemove:SetDisabled( not AJM.db.autoSellOtherItems )
	AJM.settingsControlOthers.othersButtonAdd:SetDisabled( not AJM.db.autoSellOtherItems )
	AJM:SettingsGreysScrollRefresh()
	AJM:SettingsOthersScrollRefresh()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.sellItemOnAllWithAltKey = settings.sellItemOnAllWithAltKey
		AJM.db.autoSellPoorItems = settings.autoSellPoorItems
		AJM.db.autoSellPoorItemsHaveExceptions = settings.autoSellPoorItemsHaveExceptions 
		AJM.db.autoSellOtherItems = settings.autoSellOtherItems
		AJM.db.messageArea = settings.messageArea
		AJM.db.autoSellPoorItemsExceptionList = JambaUtilities:CopyTable( settings.autoSellPoorItemsExceptionList )
		AJM.db.autoSellOtherItemsList = JambaUtilities:CopyTable( settings.autoSellOtherItemsList )
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateGreys( top )
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
	local greysWidth = headingWidth
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlGreys, L["Sell Item On All Toons"], movingTop, false )
	movingTop = movingTop - headingHeight	
	AJM.settingsControlGreys.checkBoxSellItemOnAllWithAltKey = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlGreys, 
		headingWidth, 
		left, 
		movingTop, 
		L["Hold Alt While Selling An Item To Sell On All Toons"],
		AJM.SettingsToggleSellItemOnAllWithAltKey
	)	
	movingTop = movingTop - checkBoxHeight	
	JambaHelperSettings:CreateHeading( AJM.settingsControlGreys, L["Sell Messages"], movingTop, false )
	movingTop = movingTop - headingHeight	
	AJM.settingsControlGreys.dropdownMessageArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlGreys, 
		headingWidth, 
		left, 
		movingTop, 
		L["Message Area"] 
	)
	AJM.settingsControlGreys.dropdownMessageArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlGreys.dropdownMessageArea:SetCallback( "OnValueChanged", AJM.SettingsSetMessageArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing							
	JambaHelperSettings:CreateHeading( AJM.settingsControlGreys, L["Sell Greys"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlGreys.checkBoxAutoSellPoorItems = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlGreys, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Sell Poor Quality Items"],
		AJM.SettingsToggleAutoSellPoorItems
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlGreys.checkBoxAutoSellPoorItemsHaveExceptions = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlGreys, 
		headingWidth, 
		left, 
		movingTop, 
		L["Except For These Poor Quality Items"],
		AJM.SettingsToggleAutoSellPoorItemsHaveExceptions
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlGreys.greysHighlightRow = 1
	AJM.settingsControlGreys.greysOffset = 1
	local list = {}
	list.listFrameName = "JambaSellSettingsGreysFrame"
	list.parentFrame = AJM.settingsControlGreys.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = greysWidth
	list.rowHeight = 20
	list.rowsToDisplay = 2
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 70
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 30
	list.columnInformation[2].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsGreysScrollRefresh
	list.rowClickCallback = AJM.SettingsGreysRowClick
	AJM.settingsControlGreys.greys = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlGreys.greys )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControlGreys.greysButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlGreys, 
		buttonControlWidth, 
		left, 
		movingTop,
		L["Remove"],
		AJM.SettingsGreysRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControlGreys, L["Add Exception"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlGreys.greysEditBoxExceptionItem = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlGreys,
		headingWidth,
		left,
		movingTop,
		L["Exception Item (drag item to box)"]
	)
	AJM.settingsControlGreys.greysEditBoxExceptionItem:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedGreyExceptionItem )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlGreys.greysEditBoxExceptionTag = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlGreys,
		headingWidth,
		left,
		movingTop,
		L["Exception Tag"]
	)
	AJM.settingsControlGreys.greysEditBoxExceptionTag:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedGreyExceptionTag )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlGreys.greysButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlGreys, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Add"],
		AJM.SettingsGreysAddClick
	)
	movingTop = movingTop -	buttonHeight	
	return movingTop
end

local function SettingsCreateOthers( top )
	-- Position and size constants.
	local buttonControlWidth = 85
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local othersWidth = headingWidth
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlOthers, L["Sell Others"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlOthers.checkBoxAutoSellOtherItems = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlOthers, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Sell Items"],
		AJM.SettingsToggleAutoSellOtherItems
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlOthers.othersHighlightRow = 1
	AJM.settingsControlOthers.othersOffset = 1
	local list = {}
	list.listFrameName = "JambaSellSettingsOthersFrame"
	list.parentFrame = AJM.settingsControlOthers.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = othersWidth
	list.rowHeight = 20
	list.rowsToDisplay = 8
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 70
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 30
	list.columnInformation[2].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsOthersScrollRefresh
	list.rowClickCallback = AJM.SettingsOthersRowClick
	AJM.settingsControlOthers.others = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlOthers.others )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControlOthers.othersButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlOthers, 
		buttonControlWidth, 
		left, 
		movingTop,
		L["Remove"],
		AJM.SettingsOthersRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControlOthers, L["Add Other"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlOthers.othersEditBoxOtherItem = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlOthers,
		headingWidth,
		left,
		movingTop,
		L["Other Item (drag item to box)"]
	)
	AJM.settingsControlOthers.othersEditBoxOtherItem:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedOtherItem )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlOthers.othersEditBoxOtherTag = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlOthers,
		headingWidth,
		left,
		movingTop,
		L["Other Tag"]
	)
	AJM.settingsControlOthers.othersEditBoxOtherTag:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedOtherTag )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlOthers.othersButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlOthers, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Add"],
		AJM.SettingsOthersAddClick
	)
	movingTop = movingTop -	buttonHeight	
	return movingTop
end

local function SettingsCreate()
	AJM.settingsControlGreys = {}
	AJM.settingsControlOthers = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlGreys, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlOthers, 
		L["Sell: Others"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)	
	local bottomOfGreys = SettingsCreateGreys( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlGreys.widgetSettings.content:SetHeight( -bottomOfGreys )
	local bottomOfOthers = SettingsCreateOthers( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlOthers.widgetSettings.content:SetHeight( -bottomOfOthers )	
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsGreysScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlGreys.greys.listScrollFrame, 
		AJM:GetGreysMaxPosition(),
		AJM.settingsControlGreys.greys.rowsToDisplay, 
		AJM.settingsControlGreys.greys.rowHeight
	)
	AJM.settingsControlGreys.greysOffset = FauxScrollFrame_GetOffset( AJM.settingsControlGreys.greys.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlGreys.greys.rowsToDisplay do
		-- Reset.
		AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlGreys.greys.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlGreys.greysOffset
		if dataRowNumber <= AJM:GetGreysMaxPosition() then
			-- Put data information into columns.
			local greysInformation = AJM:GetGreyAtPosition( dataRowNumber )
			AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[1].textString:SetText( greysInformation.name )
			AJM.settingsControlGreys.greys.rows[iterateDisplayRows].columns[2].textString:SetText( greysInformation.tag )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlGreys.greysHighlightRow then
				AJM.settingsControlGreys.greys.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:SettingsGreysRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlGreys.greysOffset + rowNumber <= AJM:GetGreysMaxPosition() then
		AJM.settingsControlGreys.greysHighlightRow = AJM.settingsControlGreys.greysOffset + rowNumber
		AJM:SettingsGreysScrollRefresh()
	end
end

function AJM:SettingsOthersScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlOthers.others.listScrollFrame, 
		AJM:GetOthersMaxPosition(),
		AJM.settingsControlOthers.others.rowsToDisplay, 
		AJM.settingsControlOthers.others.rowHeight
	)
	AJM.settingsControlOthers.othersOffset = FauxScrollFrame_GetOffset( AJM.settingsControlOthers.others.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlOthers.others.rowsToDisplay do
		-- Reset.
		AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )		
		AJM.settingsControlOthers.others.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlOthers.othersOffset
		if dataRowNumber <= AJM:GetOthersMaxPosition() then
			-- Put data information into columns.
			local othersInformation = AJM:GetOtherAtPosition( dataRowNumber )
			AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[1].textString:SetText( othersInformation.name )
			AJM.settingsControlOthers.others.rows[iterateDisplayRows].columns[2].textString:SetText( othersInformation.tag )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlOthers.othersHighlightRow then
				AJM.settingsControlOthers.others.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:SettingsOthersRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlOthers.othersOffset + rowNumber <= AJM:GetOthersMaxPosition() then
		AJM.settingsControlOthers.othersHighlightRow = AJM.settingsControlOthers.othersOffset + rowNumber
		AJM:SettingsOthersScrollRefresh()
	end
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleSellItemOnAllWithAltKey( event, checked )
	AJM.db.sellItemOnAllWithAltKey = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMessageArea( event, value )
	AJM.db.messageArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoSellPoorItems( event, checked )
	AJM.db.autoSellPoorItems = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoSellPoorItemsHaveExceptions( event, checked )
	AJM.db.autoSellPoorItemsHaveExceptions = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsGreysRemoveClick( event )
	StaticPopup_Show( "JAMBASELL_CONFIRM_REMOVE_AUTO_SELL_POOR_ITEMS_EXCEPTION" )
end

function AJM:SettingsEditBoxChangedGreyExceptionItem( event, text )
	AJM.autoSellPoorItemExceptionLink = text
	AJM:SettingsRefresh()
end

function AJM:SettingsEditBoxChangedGreyExceptionTag( event, text )
	if not text or text:trim() == "" or text:find( "%W" ) ~= nil then
		AJM:Print( L["Item tags must only be made up of letters and numbers."] )
		return
	end
	AJM.autoSellPoorItemExceptionTag = text
	AJM:SettingsRefresh()
end

function AJM:SettingsGreysAddClick( event )
	if AJM.autoSellPoorItemExceptionLink ~= nil and AJM.autoSellPoorItemExceptionTag ~= nil then
		AJM:AddGrey( AJM.autoSellPoorItemExceptionLink, AJM.autoSellPoorItemExceptionTag )
		AJM.autoSellPoorItemExceptionLink = nil
		AJM.settingsControlGreys.greysEditBoxExceptionItem:SetText( "" )
		AJM:SettingsRefresh()
	end
end

function AJM:SettingsToggleAutoSellOtherItems( event, checked )
	AJM.db.autoSellOtherItems = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsOthersRemoveClick( event )
	StaticPopup_Show( "JAMBASELL_CONFIRM_REMOVE_AUTO_SELL_OTHER_ITEMS" )
end

function AJM:SettingsEditBoxChangedOtherItem( event, text )
	AJM.autoSellOtherItemLink = text
	AJM:SettingsRefresh()
end

function AJM:SettingsEditBoxChangedOtherTag( event, text )
	if not text or text:trim() == "" or text:find( "%W" ) ~= nil then
		AJM:Print( L["Item tags must only be made up of letters and numbers."] )
		return
	end
	AJM.autoSellOtherItemTag = text
	AJM:SettingsRefresh()
end

function AJM:SettingsOthersAddClick( event )
	if AJM.autoSellOtherItemLink ~= nil and AJM.autoSellOtherItemTag ~= nil then
		AJM:AddOther( AJM.autoSellOtherItemLink, AJM.autoSellOtherItemTag )
		AJM.autoSellOtherItemLink = nil
		AJM.settingsControlOthers.othersEditBoxOtherItem:SetText( "" )
		AJM:SettingsRefresh()
	end
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
	StaticPopupDialogs["JAMBASELL_CONFIRM_REMOVE_AUTO_SELL_POOR_ITEMS_EXCEPTION"] = {
        text = L["Are you sure you wish to remove the selected item from the auto sell poor items exception list?"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveGrey()
		end,
    }
	StaticPopupDialogs["JAMBASELL_CONFIRM_REMOVE_AUTO_SELL_OTHER_ITEMS"] = {
        text = L["Are you sure you wish to remove the selected item from the auto sell other items list?"],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveOther()
		end,
    }
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Item link of item to add to auto sell item other / poor exception list.
	AJM.autoSellPoorItemExceptionLink = nil
	AJM.autoSellOtherItemLink = nil
	-- The tag to add to the other / poor exception item.
	AJM.autoSellPoorItemExceptionTag = JambaApi.AllTag()
	AJM.autoSellOtherItemTag = JambaApi.AllTag()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControlGreys.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()	
	-- Hook the item click event.
	AJM:RawHook( "ContainerFrameItemButton_OnModifiedClick", true )
	--[[
	-- Create a standalone window for the sell others.
	AJM.standaloneWindow = AceGUI:Create( "Window" )
	AJM.standaloneWindow:Hide()
	AJM.standaloneWindow:SetTitle( "Jamba-Sell" )
	AJM.standaloneWindow:SetLayout( "Fill" )
	AJM.standaloneWindow:AddChild( AJM.settingsControlOthers.widgetSettings )
	AJM.standaloneWindow:SetHeight( 410 )
	AJM.standaloneWindow:SetWidth( 410 )
	AJM.standaloneWindow.frame:SetFrameStrata( "HIGH" )
	]]--
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "MERCHANT_SHOW" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- JambaSell functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:ShowPopOutWindow()
	--AJM.standaloneWindow:Show()
end

-- The ContainerFrameItemButton_OnModifiedClick hook.
function AJM:ContainerFrameItemButton_OnModifiedClick( self, event, ... )
	if AJM.db.sellItemOnAllWithAltKey == true and IsAltKeyDown() == 1 and MerchantFrame:IsVisible() == 1 then
		local bag, slot = self:GetParent():GetID(), self:GetID()
		local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo( bag, slot )
		AJM:JambaSendCommandToTeam( AJM.COMMAND_SELL_ITEM, link )
	end
	return AJM.hooks["ContainerFrameItemButton_OnModifiedClick"]( self, event, ... )
end

function AJM:DoSellItem( itemlink )
	-- Iterate each bag the player has.		
	for bag = AJM.BAG_PLAYER_BACKPACK, AJM.BAG_PLAYER_MAXIMUM do 
		-- Iterate each slot in the bag.
		for slot = 1, GetContainerNumSlots( bag ) do 
			-- Get the item link for the item in this slot.
			local bagItemLink = GetContainerItemLink( bag, slot )
			-- If there is an item...
			if bagItemLink ~= nil then
				-- Does it match the item to sell?					
				if JambaUtilities:DoItemLinksContainTheSameItem( bagItemLink, itemlink ) then
					-- Yes, sell this item.
					UseContainerItem( bag, slot ) 
					-- Tell the boss.
					AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I have sold: X"]( bagItemLink ) )
				end
			end
		end
	end
end

function AJM:GetGreysMaxPosition()
	return #AJM.db.autoSellPoorItemsExceptionList
end

function AJM:GetGreyAtPosition( position )
	return AJM.db.autoSellPoorItemsExceptionList[position]
end

function AJM:GetGreyByName( name )
	for position, items in pairs( AJM.db.autoSellPoorItemsExceptionList ) do
		if items.name == name then
			return items
		end
	end
	return nil
end

function AJM:AddGrey( itemLink, itemTag )
	-- Get some more information about the item.
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemLink )
	-- If the item could be found.
	if name ~= nil then
		local itemInformation = {}
		itemInformation.link = itemLink
		itemInformation.name = name
		itemInformation.tag = itemTag
		table.insert( AJM.db.autoSellPoorItemsExceptionList, itemInformation )
		AJM:SettingsRefresh()			
		AJM:SettingsGreysRowClick( 1, 1 )
	end	
end

function AJM:RemoveGrey()
	table.remove( AJM.db.autoSellPoorItemsExceptionList, AJM.settingsControlGreys.greysHighlightRow )
	AJM:SettingsRefresh()
	AJM:SettingsGreysRowClick( 1, 1 )		
end

function AJM:GetOthersMaxPosition()
	return #AJM.db.autoSellOtherItemsList
end

function AJM:GetOtherAtPosition( position )
	return AJM.db.autoSellOtherItemsList[position]
end

function AJM:AddOther( itemLink, itemTag )
	-- Get some more information about the item.
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemLink )
	-- If the item could be found.
	if name ~= nil then
		local itemInformation = {}
		itemInformation.link = itemLink
		itemInformation.name = name
		itemInformation.tag = itemTag
		table.insert( AJM.db.autoSellOtherItemsList, itemInformation )
		AJM:SettingsRefresh()			
		AJM:SettingsOthersRowClick( 1, 1 )
	end	
end

function AJM:RemoveOther()
	table.remove( AJM.db.autoSellOtherItemsList, AJM.settingsControlOthers.othersHighlightRow )
	AJM:SettingsRefresh()
	AJM:SettingsOthersRowClick( 1, 1 )		
end

function AJM:MERCHANT_SHOW()
	-- Does the user want to auto sell poor items?
	if AJM.db.autoSellPoorItems == true then
		AJM:DoMerchantSellPoorItems()
	end
	-- Does the user want to auto sell other items?
	if AJM.db.autoSellOtherItems == true then
		AJM:DoMerchantSellOtherItems()
	end
end

function AJM:DoMerchantSellPoorItems()
	-- Iterate each bag the player has.		
	for bag = AJM.BAG_PLAYER_BACKPACK, AJM.BAG_PLAYER_MAXIMUM do 
		-- Iterate each slot in the bag.
		for slot = 1, GetContainerNumSlots( bag ) do 
			-- Get the item link for the item in this slot.
			local itemLink = GetContainerItemLink( bag, slot )
			-- If there is an item...
			if itemLink ~= nil then
				-- Get the item's quality.
				local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo( itemLink )				
				-- If the item is of a poor quality...
				if quality == AJM.ITEM_QUALITY_POOR then 
					-- Attempt to sell the item.
					AJM:SellPoorItemIfNotAnException( name, itemLink, bag, slot )				
				end
			end
		end
	end
end

function AJM:SellPoorItemIfNotAnException( itemName, itemLink, bag, slot )
	local canSell = true
	-- Are selling poor items exceptions on?
	if AJM.db.autoSellPoorItemsHaveExceptions == true then
		-- Yes, is this item in the list?
		local itemInformation = AJM:GetGreyByName( itemName )
		if itemInformation ~= nil then
			-- Does the character have this tag?
			if JambaApi.DoesCharacterHaveTag( AJM.characterName, itemInformation.tag ) == true then
				-- Yes, has the tag, do not sell the item.
				canSell = false
			end
		end
	end
	-- Can sell the item?
	if canSell == true then
		-- Then use it (effectively selling it as the character is talking to a merchant).
		UseContainerItem( bag, slot ) 
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I have sold: X"]( itemLink ) )
	else
		AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["DID NOT SELL: X"]( itemLink ) )
	end						
end

function AJM:DoMerchantSellOtherItems()
	-- Iterate all the wanted items...
	for position, itemInformation in pairs( AJM.db.autoSellOtherItemsList ) do
		-- Does this character have the item tag?  No, don't sell.
		if JambaApi.DoesCharacterHaveTag( AJM.characterName, itemInformation.tag ) == true then
			-- Attempt to sell any items in the players bags.
			-- Iterate each bag the player has.		
			for bag = AJM.BAG_PLAYER_BACKPACK, AJM.BAG_PLAYER_MAXIMUM do 
				-- Iterate each slot in the bag.
				for slot = 1, GetContainerNumSlots( bag ) do 
					-- Get the item link for the item in this slot.
					local bagItemLink = GetContainerItemLink( bag, slot )
					-- If there is an item...
					if bagItemLink ~= nil then
						-- Does it match the item to sell?					
						if JambaUtilities:DoItemLinksContainTheSameItem( bagItemLink, itemInformation.link ) then
							-- Yes, sell this item.
							UseContainerItem( bag, slot ) 
							-- Tell the boss.
							AJM:JambaSendMessageToTeam( AJM.db.messageArea, L["I have sold: X"]( bagItemLink ) )
						end
					end
				end
			end
		end
	end
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_SELL_ITEM then
		AJM:DoSellItem( ... )
	end
end
