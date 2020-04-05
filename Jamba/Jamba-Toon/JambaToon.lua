--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaToon", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceTimer-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
local LibBagUtils = LibStub:GetLibrary( "LibBagUtils-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Toon"
AJM.settingsDatabaseName = "JambaToonProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-toon"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Toon: Warnings"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		warnHitFirstTimeCombat = false,
		hitFirstTimeMessage = L["I'm Attacked!"],
		warnTargetNotMasterEnterCombat = false,
		warnTargetNotMasterMessage = L["Not Targeting!"],
		warnFocusNotMasterEnterCombat = false,
		warnFocusNotMasterMessage = L["Not Focus!"],
		warnWhenHealthDropsBelowX = true,
		warnWhenHealthDropsAmount = "60",
		warnHealthDropsMessage = L["Low Health!"],
		warnWhenManaDropsBelowX = true,
		warnWhenManaDropsAmount = "30",
		warnManaDropsMessage = L["Low Mana!"],
		warnBagsFull = true,
		bagsFullMessage = L["Bags Full!"],
		warningArea = JambaApi.DefaultWarningArea(),
		autoAcceptResurrectRequest = true,
		autoDenyDuels = true,
		autoDenyGuildInvites = true,
		requestArea = JambaApi.DefaultMessageArea(),
		autoRepair = true,
		autoRepairUseGuildFunds = true,
		merchantArea = JambaApi.DefaultMessageArea(),
		warnAfk = true,
		afkMessage = L["I went away!"],
	},
}

-- Configuration.
function AJM:GetConfiguration()
	local configuration = {
		name = AJM.moduleDisplayName,
		handler = AJM,
		type = 'group',
		args = {	
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the toon settings to all characters in the team."],
				usage = "/jamba-toon push",
				get = false,
				set = "JambaSendSettings",
			},											
		},
	}
	return configuration
end

local function DebugMessage( ... )
	--AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateMerchant( top )
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
	JambaHelperSettings:CreateHeading( AJM.settingsControlMerchant, L["Merchant"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMerchant.checkBoxAutoRepair = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Repair"],
		AJM.SettingsToggleAutoRepair
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Repair With Guild Funds"],
		AJM.SettingsToggleAutoRepairUseGuildFunds
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlMerchant.dropdownMerchantArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlMerchant, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Request Message Area"] 
	)
	AJM.settingsControlMerchant.dropdownMerchantArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetCallback( "OnValueChanged", AJM.SettingsSetMerchantArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing				
	return movingTop	
end

local function SettingsCreateRequests( top )
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
	JambaHelperSettings:CreateHeading( AJM.settingsControlRequests, L["Requests"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlRequests.checkBoxAutoDenyDuels = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Deny Duels"],
		AJM.SettingsToggleAutoDenyDuels
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.checkBoxAutoDenyGuildInvites = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Deny Guild Invites"],
		AJM.SettingsToggleAutoDenyGuildInvites
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.checkBoxAutoAcceptResurrectRequest = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Auto Accept Resurrect Request"],
		AJM.SettingsToggleAutoAcceptResurrectRequests
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlRequests.dropdownRequestArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlRequests, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Request Message Area"] 
	)
	AJM.settingsControlRequests.dropdownRequestArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlRequests.dropdownRequestArea:SetCallback( "OnValueChanged", AJM.SettingsSetRequestArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing			
	return movingTop	
end

local function SettingsCreateWarnings( top )
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
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Combat"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Hit First Time In Combat (Slave)"],
		AJM.SettingsToggleWarnHitFirstTimeCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Hit First Time Message"]
	)	
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedHitFirstTimeMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Target Not Master On Combat (Slave)"],
		AJM.SettingsToggleWarnTargetNotMasterEnterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Target Not Master Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnTargetNotMasterMessage )
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Focus Not Master On Combat (Slave)"],
		AJM.SettingsToggleWarnFocusNotMasterEnterCombat
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Focus Not Master Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnFocusNotMasterMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Health / Mana"], movingTop, true )
	movingTop = movingTop - headingHeight	
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If My Health Drops Below"],
		AJM.SettingsToggleWarnWhenHealthDropsBelowX
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Health Amount - Percentage Allowed Before Warning"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenHealthDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Health Drop Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnHealthDropsMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If My Mana Drops Below"],
		AJM.SettingsToggleWarnWhenManaDropsBelowX
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Mana Amount - Percentage Allowed Before Warning"]
	)	
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnWhenManaDropsAmount )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Warn Mana Drop Message"]
	)	
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedWarnManaDropsMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["Bag Space"], movingTop, true )
	movingTop = movingTop - headingHeight
    AJM.settingsControlWarnings.checkBoxWarnBagsFull = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If All Regular Bags Are Full"],
		AJM.SettingsToggleWarnBagsFull
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxBagsFullMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["Bags Full Message"]
	)	
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedBagsFullMessage )
	movingTop = movingTop - editBoxHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlWarnings, L["AFK"], movingTop, true )
	movingTop = movingTop - headingHeight
    AJM.settingsControlWarnings.checkBoxWarnAfk = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Warn If Toon Goes AFK"],
		AJM.SettingsToggleWarnAfk
	)	
	movingTop = movingTop - checkBoxHeight
	AJM.settingsControlWarnings.editBoxAfkMessage = JambaHelperSettings:CreateEditBox( AJM.settingsControlWarnings,
		headingWidth,
		left,
		movingTop,
		L["AFK Message"]
	)	
	AJM.settingsControlWarnings.editBoxAfkMessage:SetCallback( "OnEnterPressed", AJM.EditBoxChangedAfkMessage )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlWarnings.dropdownWarningArea = JambaHelperSettings:CreateDropdown( 
		AJM.settingsControlWarnings, 
		headingWidth, 
		left, 
		movingTop, 
		L["Send Warning Area"] 
	)
	AJM.settingsControlWarnings.dropdownWarningArea:SetList( JambaApi.MessageAreaList() )
	AJM.settingsControlWarnings.dropdownWarningArea:SetCallback( "OnValueChanged", AJM.SettingsSetWarningArea )
	movingTop = movingTop - dropdownHeight - verticalSpacing		
	return movingTop	
end

local function SettingsCreate()
	AJM.settingsControlWarnings = {}
	AJM.settingsControlRequests = {}
	AJM.settingsControlMerchant = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlWarnings, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlRequests, 
		L["Toon"]..L[": "]..L["Requests"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlMerchant, 
		L["Toon"]..L[": "]..L["Merchant"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfWarnings = SettingsCreateWarnings( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlWarnings.widgetSettings.content:SetHeight( -bottomOfWarnings )
	local bottomOfRequests = SettingsCreateRequests( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlRequests.widgetSettings.content:SetHeight( -bottomOfRequests )
	local bottomOfMerchant = SettingsCreateMerchant( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlMerchant.widgetSettings.content:SetHeight( -bottomOfMerchant )	
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
	AJM.settingsControlWarnings.checkBoxWarnHitFirstTimeCombat:SetValue( AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetText( AJM.db.hitFirstTimeMessage )
	AJM.settingsControlWarnings.checkBoxWarnTargetNotMasterEnterCombat:SetValue( AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetText( AJM.db.warnTargetNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnFocusNotMasterEnterCombat:SetValue( AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetText( AJM.db.warnFocusNotMasterMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenHealthDropsBelowX:SetValue( AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetText( AJM.db.warnWhenHealthDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetText( AJM.db.warnHealthDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnWhenManaDropsBelowX:SetValue( AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetText( AJM.db.warnWhenManaDropsAmount )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetText( AJM.db.warnManaDropsMessage )
	AJM.settingsControlWarnings.checkBoxWarnBagsFull:SetValue( AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetText( AJM.db.bagsFullMessage )
	AJM.settingsControlWarnings.checkBoxWarnAfk:SetValue( AJM.db.warnAfk )
	AJM.settingsControlWarnings.editBoxAfkMessage:SetText( AJM.db.afkMessage )
	AJM.settingsControlWarnings.dropdownWarningArea:SetValue( AJM.db.warningArea )
	AJM.settingsControlRequests.checkBoxAutoAcceptResurrectRequest:SetValue( AJM.db.autoAcceptResurrectRequest )
	AJM.settingsControlRequests.checkBoxAutoDenyDuels:SetValue( AJM.db.autoDenyDuels )
	AJM.settingsControlRequests.checkBoxAutoDenyGuildInvites:SetValue( AJM.db.autoDenyGuildInvites )
	AJM.settingsControlRequests.dropdownRequestArea:SetValue( AJM.db.requestArea )
	AJM.settingsControlMerchant.checkBoxAutoRepair:SetValue( AJM.db.autoRepair )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetValue( AJM.db.autoRepairUseGuildFunds )
	AJM.settingsControlMerchant.dropdownMerchantArea:SetValue( AJM.db.merchantArea )
	AJM.settingsControlWarnings.editBoxHitFirstTimeMessage:SetDisabled( not AJM.db.warnHitFirstTimeCombat )
	AJM.settingsControlWarnings.editBoxWarnTargetNotMasterMessage:SetDisabled( not AJM.db.warnTargetNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnFocusNotMasterMessage:SetDisabled( not AJM.db.warnFocusNotMasterEnterCombat )
	AJM.settingsControlWarnings.editBoxWarnWhenHealthDropsAmount:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnHealthDropsMessage:SetDisabled( not AJM.db.warnWhenHealthDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnWhenManaDropsAmount:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlWarnings.editBoxWarnManaDropsMessage:SetDisabled( not AJM.db.warnWhenManaDropsBelowX )
	AJM.settingsControlMerchant.checkBoxAutoRepairUseGuildFunds:SetDisabled( not AJM.db.autoRepair )
	AJM.settingsControlWarnings.editBoxBagsFullMessage:SetDisabled( not AJM.db.warnBagsFull )
	AJM.settingsControlWarnings.editBoxAfkMessage:SetDisabled( not AJM.db.warnAfk )
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleAutoRepair( event, checked )
	AJM.db.autoRepair = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoRepairUseGuildFunds( event, checked )
	AJM.db.autoRepairUseGuildFunds = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyDuels( event, checked )
	AJM.db.autoDenyDuels = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoDenyGuildInvites( event, checked )
	AJM.db.autoDenyGuildInvites = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleAutoAcceptResurrectRequests( event, checked )
	AJM.db.autoAcceptResurrectRequest = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnHitFirstTimeCombat( event, checked )
	AJM.db.warnHitFirstTimeCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedHitFirstTimeMessage( event, text )
	AJM.db.hitFirstTimeMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnBagsFull( event, checked )
	AJM.db.warnBagsFull = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedBagsFullMessage( event, text )
	AJM.db.bagsFullMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnAfk( event, checked )
	AJM.db.warnAfk = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedAfkMessage( event, text )
	AJM.db.afkMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnTargetNotMasterEnterCombat( event, checked )
	AJM.db.warnTargetNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnTargetNotMasterMessage( event, text )
	AJM.db.warnTargetNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnFocusNotMasterEnterCombat( event, checked )
	AJM.db.warnFocusNotMasterEnterCombat = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnFocusNotMasterMessage( event, text )
	AJM.db.warnFocusNotMasterMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenHealthDropsBelowX( event, checked )
	AJM.db.warnWhenHealthDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenHealthDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenHealthDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnHealthDropsMessage( event, text )
	AJM.db.warnHealthDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleWarnWhenManaDropsBelowX( event, checked )
	AJM.db.warnWhenManaDropsBelowX = checked
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnWhenManaDropsAmount( event, text )
	local amount = tonumber( text )
	amount = JambaUtilities:FixValueToRange( amount, 0, 100 )
	AJM.db.warnWhenManaDropsAmount = tostring( amount )
	AJM:SettingsRefresh()
end

function AJM:EditBoxChangedWarnManaDropsMessage( event, text )
	AJM.db.warnManaDropsMessage = text
	AJM:SettingsRefresh()
end

function AJM:SettingsSetWarningArea( event, value )
	AJM.db.warningArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetRequestArea( event, value )
	AJM.db.requestArea = value
	AJM:SettingsRefresh()
end

function AJM:SettingsSetMerchantArea( event, value )
	AJM.db.merchantArea = value
	AJM:SettingsRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControlWarnings.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Flag set when told the master about health falling below a certain percentage.
	AJM.toldMasterAboutHealth = false
	-- Flag set when told the master about mana falling below a certain percentage.
	AJM.toldMasterAboutMana = false
	-- Have been hit flag.
	AJM.haveBeenHit = false
	-- Bags full changed count.
	AJM.previousFreeBagSlotsCount = -1
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- WoW events.
	AJM:RegisterEvent( "UNIT_COMBAT" )
	AJM:RegisterEvent( "PLAYER_REGEN_DISABLED" )
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )
	AJM:RegisterEvent( "UNIT_HEALTH" )
	AJM:RegisterEvent( "MERCHANT_SHOW" )
	AJM:RegisterEvent( "UNIT_MANA" )
	AJM:RegisterEvent( "RESURRECT_REQUEST" )
	AJM:RegisterEvent( "DUEL_REQUESTED" )
	AJM:RegisterEvent( "GUILD_INVITE_REQUEST" )
	AJM:RegisterEvent( "ITEM_PUSH" )
	AJM:RegisterEvent( "UI_ERROR_MESSAGE", "ITEM_PUSH" )
	AJM:RegisterEvent( "PLAYER_FLAGS_CHANGED" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.warnHitFirstTimeCombat = settings.warnHitFirstTimeCombat
		AJM.db.hitFirstTimeMessage = settings.hitFirstTimeMessage
		AJM.db.warnTargetNotMasterEnterCombat = settings.warnTargetNotMasterEnterCombat
		AJM.db.warnTargetNotMasterMessage = settings.warnTargetNotMasterMessage
		AJM.db.warnFocusNotMasterEnterCombat = settings.warnFocusNotMasterEnterCombat
		AJM.db.warnFocusNotMasterMessage = settings.warnFocusNotMasterMessage
		AJM.db.warnWhenHealthDropsBelowX = settings.warnWhenHealthDropsBelowX
		AJM.db.warnWhenHealthDropsAmount = settings.warnWhenHealthDropsAmount
		AJM.db.warnHealthDropsMessage = settings.warnHealthDropsMessage
		AJM.db.warnWhenManaDropsBelowX = settings.warnWhenManaDropsBelowX
		AJM.db.warnWhenManaDropsAmount = settings.warnWhenManaDropsAmount
		AJM.db.warnManaDropsMessage = settings.warnManaDropsMessage
		AJM.db.warnBagsFull = settings.warnBagsFull
		AJM.db.bagsFullMessage = settings.bagsFullMessage
		AJM.db.warnAfk = settings.warnAfk
		AJM.db.afkMessage = settings.afkMessage		
		AJM.db.autoAcceptResurrectRequest = settings.autoAcceptResurrectRequest
		AJM.db.autoDenyDuels = settings.autoDenyDuels
		AJM.db.autoDenyGuildInvites = settings.autoDenyGuildInvites
		AJM.db.autoRepair = settings.autoRepair
		AJM.db.autoRepairUseGuildFunds = settings.autoRepairUseGuildFunds
		AJM.db.warningArea = settings.warningArea
		AJM.db.requestArea = settings.requestArea
		AJM.db.merchantArea = settings.merchantArea
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:UNIT_COMBAT( event, unitAffected, action )
	if AJM.db.warnHitFirstTimeCombat == false then
		return
	end
	if JambaApi.IsCharacterTheMaster( self.characterName ) == true then
		return
	end
	if InCombatLockdown() then
		if unitAffected == "player" and action ~= "HEAL" and not AJM.haveBeenHit then
			AJM.haveBeenHit = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.hitFirstTimeMessage )
		end
	end
end

function AJM:GUILD_INVITE_REQUEST( event, inviter, guild, ... )
	if AJM.db.autoDenyGuildInvites == true then
		DeclineGuild()
		StaticPopup_Hide( "GUILD_INVITE" )
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["I refused a guild invite to: X from: Y"]( guild, inviter ) )
	end
end

function AJM:DUEL_REQUESTED( event, challenger, ... )
	if AJM.db.autoDenyDuels == true then
		CancelDuel()
		StaticPopup_Hide( "DUEL_REQUESTED" )
		AJM:JambaSendMessageToTeam( AJM.db.requestArea, L["I refused a duel from: X"]( challenger ) )
	end
end

function AJM:RESURRECT_REQUEST( event, ... )
	if AJM.db.autoAcceptResurrectRequest == true then
		AcceptResurrect()
		StaticPopup_Hide( "RESURRECT")
		StaticPopup_Hide( "RESURRECT_NO_SICKNESS" )
		StaticPopup_Hide( "RESURRECT_NO_TIMER" )
		StaticPopup_Hide( "SKINNED" )
		StaticPopup_Hide( "SKINNED_REPOP" )
		StaticPopup_Hide( "DEATH" )
	end
end

function AJM:MERCHANT_SHOW( event, ... )	
	-- Does the user want to auto repair?
	if AJM.db.autoRepair == false then
		return
	end	
	-- Can this merchant repair?
	if CanMerchantRepair() == nil then 
		return
	end		
	-- How much to repair?
	local totalAmountSpentOnRepair = 0
	local repairCost = GetRepairAllCost()
	-- At least some cost...
	if repairCost > 0 then
		-- If allowed to use guild funds, then attempt to repair using guild funds.
		if AJM.db.autoRepairUseGuildFunds == true then
			if IsInGuild() and CanWithdrawGuildBankMoney() then
				RepairAllItems( 1 )
				totalAmountSpentOnRepair = totalAmountSpentOnRepair + repairCost
			end
		end
		-- After guild funds used, still need to repair?
		repairCost = GetRepairAllCost()
		-- At least some cost...
		if repairCost > 0 then
			-- How much money available?
			local moneyAvailable = GetMoney()
			-- More or equal money than cost?
			if moneyAvailable >= repairCost then
				-- Yes, repair.
				RepairAllItems()
				totalAmountSpentOnRepair = totalAmountSpentOnRepair + repairCost
			else
				-- Nope, tell the boss.
				 AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["I do not have enough money to repair all my items."] )
			end
		end
	end
	if totalAmountSpentOnRepair > 0 then
		-- Tell the boss how much that cost.
		local costString = JambaUtilities:FormatMoneyString( totalAmountSpentOnRepair )
		AJM:JambaSendMessageToTeam( AJM.db.merchantArea, L["Repairing cost me: X"]( costString ) )
	end
end

function AJM:UNIT_MANA( event, unitAffected, ... )
	if AJM.db.warnWhenManaDropsBelowX == false then
		return
	end
	if unitAffected ~= "player" then
		return
	end
	local powerType, powerTypeString = UnitPowerType( "player" )
	if powerTypeString ~= "MANA" then
		return
	end		
	local currentMana = (UnitMana( "player" ) / UnitManaMax( "player" ) * 100)
	if AJM.toldMasterAboutMana == true then
		if currentMana >= tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = false
		end
	else
		if currentMana < tonumber( AJM.db.warnWhenManaDropsAmount ) then
			AJM.toldMasterAboutMana = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnManaDropsMessage )
		end
	end
end

function AJM:UNIT_HEALTH( event, unitAffected, ... )
	if AJM.db.warnWhenHealthDropsBelowX == false then
		return
	end	
	if unitAffected ~= "player" then
		return
	end
	local currentHealth = (UnitHealth( "player" ) / UnitHealthMax( "player" ) * 100)
	if AJM.toldMasterAboutHealth == true then
		if currentHealth >= tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = false
		end
	else
		if currentHealth < tonumber( AJM.db.warnWhenHealthDropsAmount ) then
			AJM.toldMasterAboutHealth = true
			AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnHealthDropsMessage )
		end
	end
end

function AJM:PLAYER_REGEN_ENABLED( event, ... )
	AJM.haveBeenHit = false
end

function AJM:PLAYER_REGEN_DISABLED( event, ... )
	AJM.haveBeenHit = false
	if AJM.db.warnTargetNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			if UnitName( "target" ) ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnTargetNotMasterMessage )
			end
		end
	end
	if AJM.db.warnFocusNotMasterEnterCombat == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			if UnitName( "focus" ) ~= JambaApi.GetMasterName() then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.warnFocusNotMasterMessage )
			end
		end
	end
end

function AJM:ITEM_PUSH( event, ... )
    if AJM.db.warnBagsFull == true then
		if UnitIsGhost( "player" ) == 1 then
			return
		end
		if UnitIsDead( "player" ) == 1 then
			return
		end
		local numberFreeSlots, numberTotalSlots = LibBagUtils:CountSlots( "BAGS", 0 )
		if numberFreeSlots == 0 then
			if AJM.previousFreeBagSlotsCount ~= numberFreeSlots then
				AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.bagsFullMessage )
			end
		end
		AJM.previousFreeBagSlotsCount = numberFreeSlots
	end
end

function AJM:PLAYER_FLAGS_CHANGED( event, ... )
	if UnitIsAFK( "player" ) == 1 then
		AJM:JambaSendMessageToTeam( AJM.db.warningArea, AJM.db.afkMessage )
	end
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
end
