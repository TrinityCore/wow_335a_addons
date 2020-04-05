--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaMacro", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Macro"
AJM.settingsDatabaseName = "JambaMacroProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-macro"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Macro"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		variableSets = {},
		macroSets = {},
		currentVariableSetName = "",
		currentMacroSetName = "",
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
			use = {
				type = "input",
				name = L["Use Macro and Variable Set"],
				desc = L["Update the macros to use the specified macro and variable sets."],
				usage = "/jamba-macro use",
				get = false,
				set = "UpdateMacrosUseSetCommand",
			},		
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the macro settings to all characters in the team."],
				usage = "/jamba-macro push",
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

AJM.COMMAND_MACROSET_USE = "MacroSetUse"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
-- Module variables.
-------------------------------------------------------------------------------------------------------------

--AJM.storedMacroFrames = {}
--AJM.frameCount = 0
AJM.pendingMacroUpdate = false
AJM.macroFrames = {}
--AJM.previousMacroSetName = ""
AJM.currentVariables = {}
AJM.currentMacros = {}
AJM.currentControlMacroSet = {}

-------------------------------------------------------------------------------------------------------------
-- Settings Management.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
	AJM:CheckForEmptySets()
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	AJM:SettingsMacroControlScrollRefresh()
	AJM:SettingsVariableSetsScrollRefresh()
	AJM:SettingsVariablesScrollRefresh()
	AJM:SettingsMacroSetsScrollRefresh()
	AJM:SettingsMacrosScrollRefresh()	
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.variableSets = JambaUtilities:CopyTable( settings.variableSets )
		AJM.db.macroSets = JambaUtilities:CopyTable( settings.macroSets )
		-- Refresh the settings.
		AJM:ClearMacroFrames()
		AJM:CheckForEmptySets()
		AJM:SettingsRefresh()
		AJM:SettingsMacroControlRowClick( 1, 1 )	
		AJM:SettingsVariableSetsRowClick( 1, 1 )	
		AJM:SettingsMacroSetsRowClick( 1, 1 )	
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:CheckForEmptySets()
	if #AJM.db.variableSets == 0 then
		AJM.currentVariables = {}
	end
	if #AJM.db.macroSets == 0 then
		AJM.currentMacros = {}
	end
end

function AJM:ClearMacroFrames()
	for index, macroSet in ipairs( AJM.db.macroSets ) do
		for position, macro in pairs( macroSet.macros ) do
			macro.frame = nil
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- Macro Management - Variable Sets.
-------------------------------------------------------------------------------------------------------------

function AJM:GetVariableSetsMaxPosition()
	return #AJM.db.variableSets
end

function AJM:GetVariableSetAtPosition( position )
	return AJM.db.variableSets[position]
end

function AJM:SetVariableSetAtPosition( position, variableSet )
	AJM.db.variableSets[position] = variableSet
end

function AJM:GetVariableSetByName( variableSetName )
	local variableSetIndex = 0
	for index, variableSet in ipairs( AJM.db.variableSets ) do
		if variableSet.name == variableSetName then
			variableSetIndex = index
			break
		end
	end
	if variableSetIndex ~= 0 then
		return AJM.db.variableSets[variableSetIndex]
	end
	return nil
end

function AJM:AddVariableSet( variableSetName, variables )
	local newVariableSet = {}
	newVariableSet.name = variableSetName
	newVariableSet.variables = variables or {}
	table.insert( AJM.db.variableSets, newVariableSet )
	AJM:SettingsRefresh()			
	AJM:SettingsVariableSetsRowClick( 1, 1 )
end

function AJM:RemoveVariableSet( variableSetName )
	local variableSetIndex = 0
	for index, variableSet in ipairs( AJM.db.variableSets ) do
		if variableSet.name == variableSetName then
			variableSetIndex = index
			break
		end
	end
	if variableSetIndex ~= 0 then
		table.remove( AJM.db.variableSets, variableSetIndex )
	end
	AJM:SettingsVariableSetsRowClick( 1, 1 )		
end

function AJM:AddVariableSetGUI( name )
	AJM:AddVariableSet( name, nil )
	AJM:SettingsVariableSetsScrollRefresh()
end

function AJM:CopyVariableSetGUI( name )
	local variableSetToCopy = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )	
	local variables = JambaUtilities:CopyTable( variableSetToCopy.variables )
	AJM:AddVariableSet( name, variables )
	AJM:SettingsVariableSetsScrollRefresh()
end

function AJM:RemoveVariableSetGUI()
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )	
	AJM:RemoveVariableSet( variableSet.name )
	AJM.settingsControlVariables.variableSetsHighlightRow = 1	
	AJM:SettingsVariableSetsScrollRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Macro Management - Variables.
-------------------------------------------------------------------------------------------------------------

function AJM:GetVariablesMaxPosition()
	return #AJM.currentVariables
end

function AJM:GetVariableAtPosition( position )
	return AJM.currentVariables[position]
end

function AJM:SetVariableAtPosition( position, variableInformation )
	AJM.currentVariables[position] = variableInformation
end

function AJM:AddVariable( variableName )
	local newVariable = {}
	newVariable.name = variableName
	newVariable.value = ""
	newVariable.tag = JambaApi.AllTag()
	table.insert( AJM.currentVariables, newVariable )
	AJM:SettingsRefresh()			
	AJM:SettingsVariablesRowClick( 1, 1 )
end

function AJM:RemoveVariable( variableName, variableTag )
	local variableIndex = 0
	for index, variable in ipairs( AJM.currentVariables ) do
		if variable.name == variableName and variable.tag == variableTag then
			variableIndex = index
			break
		end
	end
	if variableIndex ~= 0 then
		table.remove( AJM.currentVariables, variableIndex )
	end
	AJM:SettingsVariablesRowClick( 1, 1 )		
end

function AJM:AddVariableGUI( name )
	AJM:AddVariable( name )
	AJM:SettingsVariablesScrollRefresh()
end

function AJM:RemoveVariableGUI()
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )	
	AJM:RemoveVariable( variable.name, variable.tag )
	AJM.settingsControlVariables.variablesHighlightRow = 1	
	AJM:SettingsVariablesScrollRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Macro Management - Macro Sets.
-------------------------------------------------------------------------------------------------------------

function AJM:GetMacroSetsMaxPosition()
	return #AJM.db.macroSets
end

function AJM:GetMacroSetAtPosition( position )
	return AJM.db.macroSets[position]
end

function AJM:SetMacroSetAtPosition( position, macroSet )
	AJM.db.macroSets[position] = macroSet
end

function AJM:GetMacroSetByName( macroSetName )
	local macroSetIndex = 0
	for index, macroSet in ipairs( AJM.db.macroSets ) do
		if macroSet.name == macroSetName then
			macroSetIndex = index
			break
		end
	end
	if macroSetIndex ~= 0 then
		return AJM.db.macroSets[macroSetIndex]
	end
	return nil
end

function AJM:AddMacroSet( macroSetName, macros )
	local newMacroSet = {}
	newMacroSet.name = macroSetName
	newMacroSet.macros = macros or {}
	newMacroSet.variableSet = ""
	newMacroSet.tag = JambaApi.AllTag()
	newMacroSet.enabled = false
	table.insert( AJM.db.macroSets, newMacroSet )
	AJM:SettingsRefresh()
	AJM:SettingsMacroControlRowClick( 1, 1 )
	AJM:SettingsMacroSetsRowClick( 1, 1 )
end

function AJM:RemoveMacroSet( macroSetName )
	local macroSetIndex = 0
	for index, macroSet in ipairs( AJM.db.macroSets ) do
		if macroSet.name == macroSetName then
			macroSetIndex = index
			break
		end
	end
	if macroSetIndex ~= 0 then
		table.remove( AJM.db.macroSets, macroSetIndex )
	end
	AJM:SettingsMacroControlRowClick( 1, 1 )
	AJM:SettingsMacroSetsRowClick( 1, 1 )		
end

function AJM:AddMacroSetGUI( name )
	AJM:AddMacroSet( name, nil )
	AJM:SettingsMacroSetsScrollRefresh()
end

function AJM:CopyMacroSetGUI( name )
	local macroSetToCopy = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )	
	local macros = JambaUtilities:CopyTable( macroSetToCopy.macros )
	AJM:AddMacroSet( name, macros )
	AJM:SettingsMacroSetsScrollRefresh()
end

function AJM:RemoveMacroSetGUI()
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )	
	AJM:ClearMacroSetKeyBindings( macroSet.name )	
	AJM:RemoveMacroSet( macroSet.name )
	AJM.settingsControlMacros.macroSetsHighlightRow = 1	
	AJM:SettingsMacroSetsScrollRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Macro Management - Macros.
-------------------------------------------------------------------------------------------------------------

function AJM:GetMacrosMaxPosition()
	return #AJM.currentMacros
end

function AJM:GetMacroAtPosition( position )
	return AJM.currentMacros[position]
end

function AJM:SetMacroAtPosition( position, macro )
	AJM.currentMacros[position] = macro
end

function AJM:AddMacro( macroName )
	local newMacro = {}
	newMacro.name = macroName
	newMacro.key = ""
	newMacro.text = ""
	newMacro.tag = JambaApi.AllTag()
	table.insert( AJM.currentMacros, newMacro )
	AJM:SettingsRefresh()			
	AJM:SettingsMacrosRowClick( 1, 1 )
end

function AJM:RemoveMacro( macroName, macroTag )
	local macroIndex = 0
	for index, macro in ipairs( AJM.currentMacros ) do
		if macro.name == macroName and macro.tag == macroTag then
			macroIndex = index
			break
		end
	end
	if macroIndex ~= 0 then
		local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )	
		AJM:ClearMacroKeyBinding( macroSet.name, macroName )
		table.remove( AJM.currentMacros, macroIndex )
	end
	AJM:SettingsMacrosRowClick( 1, 1 )		
end

function AJM:AddMacroGUI( name )
	AJM:AddMacro( name )
	AJM:SettingsMacrosScrollRefresh()
end

function AJM:RemoveMacroGUI()
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )	
	AJM:RemoveMacro( macro.name, macro.tag )
	AJM.settingsControlMacros.macrosHighlightRow = 1	
	AJM:SettingsMacrosScrollRefresh()
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateMacroControl( top )
	-- Position and size constants.
	local buttonControlWidth = 125
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local macroControlWidth = headingWidth
	local halfWidth = (headingWidth/2) - horizontalSpacing
	local left2 = left + halfWidth 
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Macro Sets Control"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.macroControlHighlightRow = 1
	AJM.settingsControl.macroControlOffset = 1
	local list = {}
	list.listFrameName = "JambaMacroSettingsMacroControlFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = macroControlWidth
	list.rowHeight = 20
	list.rowsToDisplay = 9
	list.columnsToDisplay = 4
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 40
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 30
	list.columnInformation[2].alignment = "LEFT"
	list.columnInformation[3] = {}
	list.columnInformation[3].width = 20
	list.columnInformation[3].alignment = "LEFT"
	list.columnInformation[4] = {}
	list.columnInformation[4].width = 10
	list.columnInformation[4].alignment = "CENTER"
	list.scrollRefreshCallback = AJM.SettingsMacroControlScrollRefresh
	list.rowClickCallback = AJM.SettingsMacroControlRowClick
	AJM.settingsControl.macroControl = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.macroControl )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControl.macroControlButtonEnable = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Enable"],
		AJM.SettingsMacroControlEnableClick
	)
	AJM.settingsControl.macroControlButtonDisable = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		buttonControlWidth, 
		left + buttonControlWidth + horizontalSpacing, 
		movingTop, 
		L["Disable"],
		AJM.SettingsMacroControlDisableClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	AJM.settingsControl.macroControlButtonBuildMacros = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Build Macros (Team)"],
		AJM.SettingsMacroControlBuildMacrosClick
	)	
	movingTop = movingTop -	buttonHeight - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Configure Macro Set"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.macroControlEditBoxVariableSetName = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		macroControlWidth,
		left,
		movingTop,
		L["Variable Set"]
	)
	AJM.settingsControl.macroControlEditBoxVariableSetName:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedMacroControlVariableSet )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControl.macroControlEditBoxTagName = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl,
		macroControlWidth,
		left,
		movingTop,
		L["Tag"]
	)
	AJM.settingsControl.macroControlEditBoxTagName:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedMacroControlTag )	
	movingTop = movingTop - editBoxHeight
	return movingTop
end

local function SettingsCreateVariableSets( top )
	-- Position and size constants.
	local buttonControlWidth = 105
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local variableSetsWidth = headingWidth - buttonControlWidth - horizontalSpacing
	local halfWidth = (headingWidth/2) - horizontalSpacing
	local left2 = left + halfWidth 
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlVariables, L["Variable Sets"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlVariables.variableSetsHighlightRow = 1
	AJM.settingsControlVariables.variableSetsOffset = 1
	local list = {}
	list.listFrameName = "JambaMacroSettingsVariableSetsFrame"
	list.parentFrame = AJM.settingsControlVariables.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = variableSetsWidth
	list.rowHeight = 20
	list.rowsToDisplay = 4
	list.columnsToDisplay = 1
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 100
	list.columnInformation[1].alignment = "LEFT"
	list.scrollRefreshCallback = AJM.SettingsVariableSetsScrollRefresh
	list.rowClickCallback = AJM.SettingsVariableSetsRowClick
	AJM.settingsControlVariables.variableSets = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlVariables.variableSets )
	--[[
	AJM.settingsControlVariables.variableSetsButtonUse = JambaHelperSettings:CreateButton(	
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left + variableSetsWidth + horizontalSpacing, 
		movingTop, 
		L["Use"],
		AJM.SettingsVariableSetsUseClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	]]--
	AJM.settingsControlVariables.variableSetsButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left + variableSetsWidth + horizontalSpacing, 
		movingTop, 
		L["Add"],
		AJM.SettingsVariableSetsAddClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	AJM.settingsControlVariables.variableSetsButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left + variableSetsWidth + horizontalSpacing, 
		movingTop,
		L["Remove"],
		AJM.SettingsVariableSetsRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	AJM.settingsControlVariables.variableSetsButtonCopy = JambaHelperSettings:CreateButton(
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left + variableSetsWidth + horizontalSpacing, 
		movingTop,
		L["Copy"],
		AJM.SettingsVariableSetsCopyClick
	)	
	movingTop = movingTop -	buttonHeight - verticalSpacing
	movingTop = movingTop -	verticalSpacing - verticalSpacing - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControlVariables, L["Variables"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlVariables.variablesHighlightRow = 1
	AJM.settingsControlVariables.variablesOffset = 1
	list = {}
	list.listFrameName = "JambaMacroSettingsVariablesFrame"
	list.parentFrame = AJM.settingsControlVariables.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = headingWidth
	list.rowHeight = 20
	list.rowsToDisplay = 4
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 50
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 50
	list.columnInformation[2].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsVariablesScrollRefresh
	list.rowClickCallback = AJM.SettingsVariablesRowClick
	AJM.settingsControlVariables.variables = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlVariables.variables )
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControlVariables.variablesButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left, 
		movingTop, 
		L["Add"],
		AJM.SettingsVariablesAddClick
	)
	AJM.settingsControlVariables.variablesButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlVariables, 
		buttonControlWidth, 
		left + horizontalSpacing + buttonControlWidth, 
		movingTop, 
		L["Remove"],
		AJM.SettingsVariablesRemoveClick
	)
	movingTop = movingTop -	buttonHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControlVariables, L["Edit Variable"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlVariables.variablesEditBoxVariableName = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlVariables,
		headingWidth,
		left,
		movingTop,
		L["Variable Name"]
	)
	AJM.settingsControlVariables.variablesEditBoxVariableName:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedVariableName )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlVariables.variablesEditBoxVariableTag = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlVariables,
		headingWidth,
		left,
		movingTop,
		L["Variable Tag (prefix ! for not this tag)"]
	)
	AJM.settingsControlVariables.variablesEditBoxVariableTag:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedVariableTag )	
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlVariables.variablesEditBoxVariableValue = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlVariables,
		headingWidth,
		left,
		movingTop,
		L["Variable Value"]
	)
	AJM.settingsControlVariables.variablesEditBoxVariableValue:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedVariableValue )
	movingTop = movingTop - editBoxHeight	
	return movingTop
end

local function SettingsCreateMacroSets( top )
	-- Position and size constants.
	local buttonControlWidth = 105
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local editBoxHeight = JambaHelperSettings:GetEditBoxHeight()
	local keyBindingHeight = JambaHelperSettings:GetKeyBindingHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local macroSetsWidth = headingWidth - buttonControlWidth - horizontalSpacing
	local halfWidth = (headingWidth/2) - horizontalSpacing
	local left2 = left + halfWidth 
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControlMacros, L["Macro Sets"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMacros.macroSetsHighlightRow = 1
	AJM.settingsControlMacros.macroSetsOffset = 1
	local list = {}
	list.listFrameName = "JambaMacroSettingsMacroSetsFrame"
	list.parentFrame = AJM.settingsControlMacros.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = macroSetsWidth
	list.rowHeight = 20
	list.rowsToDisplay = 4
	list.columnsToDisplay = 1
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 100
	list.columnInformation[1].alignment = "LEFT"
	list.scrollRefreshCallback = AJM.SettingsMacroSetsScrollRefresh
	list.rowClickCallback = AJM.SettingsMacroSetsRowClick
	AJM.settingsControlMacros.macroSets = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlMacros.macroSets )
	--[[
	AJM.settingsControlMacros.macroSetsButtonUse = JambaHelperSettings:CreateButton(	
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing,
		movingTop, 
		L["Use"],
		AJM.SettingsMacroSetsUseClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	]]--
	AJM.settingsControlMacros.macroSetsButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing,
		movingTop, 
		L["Add"],
		AJM.SettingsMacroSetsAddClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	AJM.settingsControlMacros.macroSetsButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing,
		movingTop, 
		L["Remove"],
		AJM.SettingsMacroSetsRemoveClick
	)
	movingTop = movingTop -	buttonHeight - verticalSpacing
	AJM.settingsControlMacros.macroSetsButtonCopy = JambaHelperSettings:CreateButton(
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing,
		movingTop, 
		L["Copy"],
		AJM.SettingsMacroSetsCopyClick
	)	
	movingTop = movingTop -	buttonHeight - verticalSpacing
	movingTop = movingTop -	verticalSpacing - verticalSpacing - verticalSpacing
	JambaHelperSettings:CreateHeading( AJM.settingsControlMacros, L["Macros"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMacros.macrosHighlightRow = 1
	AJM.settingsControlMacros.macrosOffset = 1
	list = {}
	list.listFrameName = "JambaMacroSettingsMacrosFrame"
	list.parentFrame = AJM.settingsControlMacros.widgetSettings.content
	list.listTop = movingTop
	list.listLeft = left
	list.listWidth = macroSetsWidth
	list.rowHeight = 20
	list.rowsToDisplay = 5
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 50
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 50
	list.columnInformation[2].alignment = "LEFT"	
	list.scrollRefreshCallback = AJM.SettingsMacrosScrollRefresh
	list.rowClickCallback = AJM.SettingsMacrosRowClick
	AJM.settingsControlMacros.macros = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControlMacros.macros )
	AJM.settingsControlMacros.macrosButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing, 
		movingTop, 
		L["Add"],
		AJM.SettingsMacrosAddClick
	)
	AJM.settingsControlMacros.macrosButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing, 
		movingTop - buttonHeight - verticalSpacing, 
		L["Remove"],
		AJM.SettingsMacrosRemoveClick
	)
	AJM.settingsControlMacros.macrosButtonShow = JambaHelperSettings:CreateButton(
		AJM.settingsControlMacros, 
		buttonControlWidth, 
		left + macroSetsWidth + horizontalSpacing, 
		movingTop - buttonHeight - verticalSpacing - buttonHeight - verticalSpacing, 
		L["Show"],
		AJM.SettingsMacrosShowClick
	)
	movingTop = movingTop - list.listHeight - verticalSpacing
	AJM.settingsControlMacros.macrosEditBoxMacroUsage = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlMacros,
		headingWidth,
		left,
		movingTop,
		L["Macro Usage - press key assigned or copy /click below."]
	)
	movingTop = movingTop - editBoxHeight	
	JambaHelperSettings:CreateHeading( AJM.settingsControlMacros, L["Edit Macro"], movingTop, false )
	movingTop = movingTop - headingHeight
	AJM.settingsControlMacros.macrosEditBoxMacroName = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlMacros,
		headingWidth,
		left,
		movingTop,
		L["Macro Name"]
	)
	AJM.settingsControlMacros.macrosEditBoxMacroName:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedMacroName )
	movingTop = movingTop - editBoxHeight
	AJM.settingsControlMacros.macrosEditBoxMacroTag = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControlMacros,
		headingWidth,
		left,
		movingTop,
		L["Macro Tag (prefix ! for not this tag)"]
	)
	AJM.settingsControlMacros.macrosEditBoxMacroTag:SetCallback( "OnEnterPressed", AJM.SettingsEditBoxChangedMacroTag )	
	movingTop = movingTop - editBoxHeight	
	AJM.settingsControlMacros.macrosMultiEditBoxMacroText = JambaHelperSettings:CreateMultiEditBox( 
		AJM.settingsControlMacros,
		headingWidth,
		left,
		movingTop,
		L["Macro Text"],
		4
	)
	AJM.settingsControlMacros.macrosMultiEditBoxMacroText:SetCallback( "OnEnterPressed", AJM.SettingsMultiEditBoxChangedMacroText )
	local multiEditBoxHeightMacroText = 100
	movingTop = movingTop - multiEditBoxHeightMacroText	
	AJM.settingsControlMacros.macrosKeyBindingMacroKey = JambaHelperSettings:CreateKeyBinding( 
		AJM.settingsControlMacros,
		headingWidth,
		left,
		movingTop,
		L["Macro Key"]
	)
	AJM.settingsControlMacros.macrosKeyBindingMacroKey:SetCallback( "OnKeyChanged", AJM.SettingsKeyBindingChangedMacroKey )
	movingTop = movingTop - keyBindingHeight		
	return movingTop
end

local function SettingsCreate()
	AJM.settingsControl = {}
	AJM.settingsControlVariables = {}
	AJM.settingsControlMacros = {}
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlVariables, 
		L["Macro: Variables"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControlMacros, 
		L["Macro: Macros"], 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)
	local bottomOfMacroControl = SettingsCreateMacroControl( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfMacroControl )	
	local bottomOfVariableSets = SettingsCreateVariableSets( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlVariables.widgetSettings.content:SetHeight( -bottomOfVariableSets )
	local bottomOfMacroSets = SettingsCreateMacroSets( JambaHelperSettings:TopOfSettings() )
	AJM.settingsControlMacros.widgetSettings.content:SetHeight( -bottomOfMacroSets )	
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsMacroControlScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.macroControl.listScrollFrame, 
		AJM:GetMacroSetsMaxPosition(),
		AJM.settingsControl.macroControl.rowsToDisplay, 
		AJM.settingsControl.macroControl.rowHeight
	)
	AJM.settingsControl.macroControlOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.macroControl.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.macroControl.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[3].textString:SetText( "" )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[3].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetText( "" )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.macroControl.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.macroControlOffset
		if dataRowNumber <= AJM:GetMacroSetsMaxPosition() then
			-- Put data information into columns.
			local macroSetsInformation = AJM:GetMacroSetAtPosition( dataRowNumber )
			AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[1].textString:SetText( macroSetsInformation.name )
			AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[2].textString:SetText( macroSetsInformation.variableSet )
			AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[3].textString:SetText( macroSetsInformation.tag )
			if (macroSetsInformation.enabled == nil) or (macroSetsInformation.enabled == false) then
				AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetText( L["Off"] )
				AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetTextColor( 1.0, 0.0, 0.0, 1.0 )
			else
				AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetText( L["On"] )
				AJM.settingsControl.macroControl.rows[iterateDisplayRows].columns[4].textString:SetTextColor( 0.0, 1.0, 0.0, 1.0 )
			end
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.macroControlHighlightRow then
				AJM.settingsControl.macroControl.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
	local disabled = false
	if AJM:GetMacroSetsMaxPosition() == 0 then
		disabled = true
	end
	AJM.settingsControl.macroControlButtonEnable:SetDisabled( disabled )
	AJM.settingsControl.macroControlButtonDisable:SetDisabled( disabled )
	AJM.settingsControl.macroControlEditBoxVariableSetName:SetDisabled( disabled )		
	AJM.settingsControl.macroControlEditBoxTagName:SetDisabled( disabled )
end

function AJM:SettingsVariableSetsScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlVariables.variableSets.listScrollFrame, 
		AJM:GetVariableSetsMaxPosition(),
		AJM.settingsControlVariables.variableSets.rowsToDisplay, 
		AJM.settingsControlVariables.variableSets.rowHeight
	)
	AJM.settingsControlVariables.variableSetsOffset = FauxScrollFrame_GetOffset( AJM.settingsControlVariables.variableSets.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlVariables.variableSets.rowsToDisplay do
		-- Reset.
		AJM.settingsControlVariables.variableSets.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlVariables.variableSets.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlVariables.variableSets.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlVariables.variableSetsOffset
		if dataRowNumber <= AJM:GetVariableSetsMaxPosition() then
			-- Put data information into columns.
			local variableSetsInformation = AJM:GetVariableSetAtPosition( dataRowNumber )
			AJM.settingsControlVariables.variableSets.rows[iterateDisplayRows].columns[1].textString:SetText( variableSetsInformation.name )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlVariables.variableSetsHighlightRow then
				AJM.settingsControlVariables.variableSets.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
	local disabled = false
	if AJM:GetVariableSetsMaxPosition() == 0 then
		disabled = true
	end
	-- Variable Sets.
	--AJM.settingsControlVariables.variableSetsButtonUse:SetDisabled( disabled )
	AJM.settingsControlVariables.variableSetsButtonRemove:SetDisabled( disabled )
	AJM.settingsControlVariables.variableSetsButtonCopy:SetDisabled( disabled )	
	-- Variables.
	AJM.settingsControlVariables.variablesButtonAdd:SetDisabled( disabled )
end

function AJM:SettingsVariablesScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlVariables.variables.listScrollFrame, 
		AJM:GetVariablesMaxPosition(),
		AJM.settingsControlVariables.variables.rowsToDisplay, 
		AJM.settingsControlVariables.variables.rowHeight
	)
	AJM.settingsControlVariables.variablesOffset = FauxScrollFrame_GetOffset( AJM.settingsControlVariables.variables.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlVariables.variables.rowsToDisplay do
		-- Reset.
		AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlVariables.variables.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlVariables.variablesOffset
		if dataRowNumber <= AJM:GetVariablesMaxPosition() then
			-- Put data information into columns.
			local variablesInformation = AJM:GetVariableAtPosition( dataRowNumber )
			AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[1].textString:SetText( variablesInformation.name )
			AJM.settingsControlVariables.variables.rows[iterateDisplayRows].columns[2].textString:SetText( variablesInformation.value )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlVariables.variablesHighlightRow then
				AJM.settingsControlVariables.variables.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
	local disabled = false
	if AJM:GetVariablesMaxPosition() == 0 then
		disabled = true
		AJM.settingsControlVariables.variablesEditBoxVariableName:SetText( "" )
		AJM.settingsControlVariables.variablesEditBoxVariableTag:SetText( "" )
		AJM.settingsControlVariables.variablesEditBoxVariableValue:SetText( "" )
	end
	AJM.settingsControlVariables.variablesButtonRemove:SetDisabled( disabled )
	AJM.settingsControlVariables.variablesEditBoxVariableName:SetDisabled( disabled )
	AJM.settingsControlVariables.variablesEditBoxVariableTag:SetDisabled( disabled )
	AJM.settingsControlVariables.variablesEditBoxVariableValue:SetDisabled( disabled )
	if AJM:GetVariableSetsMaxPosition() == 0 then
		AJM.settingsControlVariables.variablesButtonAdd:SetDisabled( true )
	else
		AJM.settingsControlVariables.variablesButtonAdd:SetDisabled( false )
	end
end

function AJM:SettingsMacroSetsScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlMacros.macroSets.listScrollFrame, 
		AJM:GetMacroSetsMaxPosition(),
		AJM.settingsControlMacros.macroSets.rowsToDisplay, 
		AJM.settingsControlMacros.macroSets.rowHeight
	)
	AJM.settingsControlMacros.macroSetsOffset = FauxScrollFrame_GetOffset( AJM.settingsControlMacros.macroSets.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlMacros.macroSets.rowsToDisplay do
		-- Reset.
		AJM.settingsControlMacros.macroSets.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlMacros.macroSets.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlMacros.macroSets.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlMacros.macroSetsOffset
		if dataRowNumber <= AJM:GetMacroSetsMaxPosition() then
			-- Put data information into columns.
			local macroSetsInformation = AJM:GetMacroSetAtPosition( dataRowNumber )
			AJM.settingsControlMacros.macroSets.rows[iterateDisplayRows].columns[1].textString:SetText( macroSetsInformation.name )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlMacros.macroSetsHighlightRow then
				AJM.settingsControlMacros.macroSets.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
	local disabled = false
	if AJM:GetMacroSetsMaxPosition() == 0 then
		disabled = true
	end
	-- Macro sets.
	--AJM.settingsControlMacros.macroSetsButtonUse:SetDisabled( disabled )
	AJM.settingsControlMacros.macroSetsButtonRemove:SetDisabled( disabled )
	AJM.settingsControlMacros.macroSetsButtonCopy:SetDisabled( disabled )		
	-- Macro.
	AJM.settingsControlMacros.macrosButtonAdd:SetDisabled( disabled )
end

function AJM:SettingsMacrosScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControlMacros.macros.listScrollFrame, 
		AJM:GetMacrosMaxPosition(),
		AJM.settingsControlMacros.macros.rowsToDisplay, 
		AJM.settingsControlMacros.macros.rowHeight
	)
	AJM.settingsControlMacros.macrosOffset = FauxScrollFrame_GetOffset( AJM.settingsControlMacros.macros.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControlMacros.macros.rowsToDisplay do
		-- Reset.
		AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControlMacros.macros.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControlMacros.macrosOffset
		if dataRowNumber <= AJM:GetMacrosMaxPosition() then
			-- Put data information into columns.
			local macrosInformation = AJM:GetMacroAtPosition( dataRowNumber )
			AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[1].textString:SetText( macrosInformation.name )
			AJM.settingsControlMacros.macros.rows[iterateDisplayRows].columns[2].textString:SetText( macrosInformation.key )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControlMacros.macrosHighlightRow then
				AJM.settingsControlMacros.macros.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
	local disabled = false
	if AJM:GetMacrosMaxPosition() == 0 then
		disabled = true
		AJM.settingsControlMacros.macrosEditBoxMacroName:SetText( "" )
		AJM.settingsControlMacros.macrosEditBoxMacroTag:SetText( "" )
		AJM.settingsControlMacros.macrosMultiEditBoxMacroText:SetText( "" )
		AJM.settingsControlMacros.macrosKeyBindingMacroKey:SetKey( "" )		
	end
	AJM.settingsControlMacros.macrosButtonRemove:SetDisabled( disabled )
	AJM.settingsControlMacros.macrosButtonShow:SetDisabled( disabled )		
	AJM.settingsControlMacros.macrosEditBoxMacroUsage:SetDisabled( disabled )
	AJM.settingsControlMacros.macrosEditBoxMacroName:SetDisabled( disabled )
	AJM.settingsControlMacros.macrosEditBoxMacroTag:SetDisabled( disabled )
	AJM.settingsControlMacros.macrosMultiEditBoxMacroText:SetDisabled( disabled )
	AJM.settingsControlMacros.macrosKeyBindingMacroKey:SetDisabled( disabled )
end

function AJM:UpdateVariableSetInformation()		
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )
	AJM.currentVariables = variableSet.variables
	AJM:SettingsVariablesScrollRefresh()
	AJM:SettingsVariablesRowClick( 1, 1 )
end

function AJM:UpdateVariableInformation()		
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )
	AJM.settingsControlVariables.variablesEditBoxVariableName:SetText( variable.name )
	AJM.settingsControlVariables.variablesEditBoxVariableTag:SetText( variable.tag )
	AJM.settingsControlVariables.variablesEditBoxVariableValue:SetText( variable.value )
end

function AJM:UpdateMacroSetInformation()		
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )
	AJM.currentMacros = macroSet.macros
	AJM:SettingsMacrosScrollRefresh()
	AJM:SettingsMacrosRowClick( 1, 1 )
end

function AJM:UpdateMacroControlInformation()		
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControl.macroControlHighlightRow )
	AJM.currentControlMacroSet = macroSet
	-- New additions to macro sets in Jamba 0.5c, make sure there are workable defaults in place.
	-- Begin.
	if macroSet.variableSet == nil then
		macroSet.variableSet = ""
	end
	if macroSet.tag == nil then
		macroSet.tag = JambaApi.AllTag()
	end	
	if macroSet.enabled == nil then
		macroSet.enabled = false
	end
	-- End.
	AJM.settingsControl.macroControlEditBoxVariableSetName:SetText( macroSet.variableSet )
	AJM.settingsControl.macroControlEditBoxTagName:SetText( macroSet.tag )
end

function AJM:UpdateMacroInformation()		
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	AJM.settingsControlMacros.macrosEditBoxMacroUsage:SetText( L["/click JMB_"]..macro.name )
	AJM.settingsControlMacros.macrosEditBoxMacroName:SetText( macro.name )
	AJM.settingsControlMacros.macrosMultiEditBoxMacroText:SetText( macro.text )
	AJM.settingsControlMacros.macrosEditBoxMacroTag:SetText( macro.tag )
	AJM.settingsControlMacros.macrosKeyBindingMacroKey:SetKey( macro.key )
end

function AJM:SettingsMacroControlRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.macroControlOffset + rowNumber <= AJM:GetMacroSetsMaxPosition() then
		AJM.settingsControl.macroControlHighlightRow = AJM.settingsControl.macroControlOffset + rowNumber
		AJM:UpdateMacroControlInformation()
		AJM:SettingsMacroControlScrollRefresh()
	end
end

function AJM:SettingsVariableSetsRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlVariables.variableSetsOffset + rowNumber <= AJM:GetVariableSetsMaxPosition() then
		AJM.settingsControlVariables.variableSetsHighlightRow = AJM.settingsControlVariables.variableSetsOffset + rowNumber
		AJM:UpdateVariableSetInformation()
		AJM:SettingsVariableSetsScrollRefresh()
	end
end

function AJM:SettingsVariablesRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlVariables.variablesOffset + rowNumber <= AJM:GetVariablesMaxPosition() then
		AJM.settingsControlVariables.variablesHighlightRow = AJM.settingsControlVariables.variablesOffset + rowNumber
		AJM:UpdateVariableInformation()
		AJM:SettingsVariablesScrollRefresh()
	end
end

function AJM:SettingsMacroSetsRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlMacros.macroSetsOffset + rowNumber <= AJM:GetMacroSetsMaxPosition() then
		AJM.settingsControlMacros.macroSetsHighlightRow = AJM.settingsControlMacros.macroSetsOffset + rowNumber
		AJM:UpdateMacroSetInformation()
		AJM:SettingsMacroSetsScrollRefresh()
	end
end

function AJM:SettingsMacrosRowClick( rowNumber, columnNumber )		
	if AJM.settingsControlMacros.macrosOffset + rowNumber <= AJM:GetMacrosMaxPosition() then
		AJM.settingsControlMacros.macrosHighlightRow = AJM.settingsControlMacros.macrosOffset + rowNumber
		AJM:UpdateMacroInformation()
		AJM:SettingsMacrosScrollRefresh()
	end
end

function AJM:SettingsEditBoxChangedVariableName( event, text )
	if not text or text:trim() == "" or text:find( "%W" ) ~= nil then
		AJM:Print( L["Variable names must only be made up of letters and numbers."] )
		return
	end
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )
	variable.name = text
	AJM:SettingsVariablesScrollRefresh()
end

function AJM:SettingsEditBoxChangedVariableTag( event, text )
	if AJM:CheckForValidTag( text ) == false then
		return
	end
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )
	variable.tag = text
	AJM:SettingsVariablesScrollRefresh()
end

function AJM:SettingsEditBoxChangedVariableValue( event, text )
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )
	variable.value = text
	AJM:SettingsVariablesScrollRefresh()
end

function AJM:SettingsEditBoxChangedMacroName( event, text )
	if not text or text:trim() == "" or text:find( "%W" ) ~= nil then
		AJM:Print( L["Macro names must only be made up of letters and numbers."] )
		return
	end
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	macro.name = text
	AJM.settingsControlMacros.macrosEditBoxMacroUsage:SetText( L["/click JMB_"]..macro.name )
	AJM:SettingsMacrosScrollRefresh()
end

function AJM:CheckForValidTag( text )
	if not text or text:trim() == "" then
		return false
	end
	if text:sub( 1, 1 ) == "!" then
		text = text:sub( 2 )
	end
	if text:find( "%W" ) ~= nil then
		AJM:Print( L["Macro tags must only be made up of letters and numbers."] )
		return false
	end	
	return true
end

function AJM:SettingsEditBoxChangedMacroTag( event, text )
	if AJM:CheckForValidTag( text ) == false then
		return
	end
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	macro.tag = text
	AJM:SettingsMacrosScrollRefresh()
end

function AJM:SettingsMultiEditBoxChangedMacroText( event, text )
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	macro.text = text
	AJM:SettingsMacrosScrollRefresh()
end

function AJM:SettingsKeyBindingChangedMacroKey( event, key )
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	macro.key = key
	AJM:SettingsMacrosScrollRefresh()
end

function AJM:SettingsVariableSetsAddClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_VARIABLE_SET_NAME" )
end

function AJM:SettingsVariableSetsRemoveClick( event )
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )
	StaticPopup_Show( "JAMBAMACRO_CONFIRM_REMOVE_VARIABLE_SET", variableSet.name )
end

function AJM:SettingsVariableSetsCopyClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_VARIABLE_SET_COPY_NAME" )
end

function AJM:SettingsVariablesAddClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_VARIABLE_NAME" )
end

function AJM:SettingsVariablesRemoveClick( event )
	local variable = AJM:GetVariableAtPosition( AJM.settingsControlVariables.variablesHighlightRow )
	StaticPopup_Show( "JAMBAMACRO_CONFIRM_REMOVE_VARIABLE", variable.name )
end

function AJM:SettingsMacroSetsAddClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_MACRO_SET_NAME" )
end

function AJM:SettingsMacroSetsRemoveClick( event )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )
	StaticPopup_Show( "JAMBAMACRO_CONFIRM_REMOVE_MACRO_SET", macroSet.name )
end

function AJM:SettingsMacroSetsCopyClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_MACRO_SET_COPY_NAME" )
end

function AJM:SettingsMacrosAddClick( event )
	StaticPopup_Show( "JAMBAMACRO_ASK_MACRO_NAME" )
end

function AJM:SettingsMacrosRemoveClick( event )
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	StaticPopup_Show( "JAMBAMACRO_CONFIRM_REMOVE_MACRO", macro.name )
end

function AJM:SettingsMacroControlEnableClick( event )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControl.macroControlHighlightRow )
	macroSet.enabled = true
	AJM:SettingsMacroControlScrollRefresh()
end

function AJM:SettingsMacroControlDisableClick( event )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControl.macroControlHighlightRow )
	macroSet.enabled = false
	AJM:SettingsMacroControlScrollRefresh()
end

function AJM:SettingsEditBoxChangedMacroControlVariableSet( event, text )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControl.macroControlHighlightRow )
	macroSet.variableSet = text
	AJM:SettingsMacroControlScrollRefresh()
end

function AJM:SettingsEditBoxChangedMacroControlTag( event, text )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControl.macroControlHighlightRow )
	macroSet.tag = text
	AJM:SettingsMacroControlScrollRefresh()
end

--[[
function AJM:SettingsVariableSetsUseClick( event )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )
	AJM:UpdateInternalMacros( macroSet, variableSet, false )
end
]]--

--[[
function AJM:SettingsMacroSetsUseClick( event )
	local macroSet = AJM:GetMacroSetAtPosition( AJM.settingsControlMacros.macroSetsHighlightRow )
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )
	AJM:UpdateInternalMacros( macroSet, variableSet, false )
end
]]--

function AJM:SettingsMacroControlBuildMacrosClick( event )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_MACROSET_USE )
end

function AJM:UpdateMacrosUseSetCommandReceive()
	AJM:UpdateMacrosUseSetCommandAction( false )
end

function AJM:UpdateMacrosUseSetCommandAction( silent )
	-- Iterate all the macro sets and remove keybindings.
	for index, macroSet in ipairs( AJM.db.macroSets ) do
		AJM:ClearMacroSetKeyBindings( macroSet.name )
	end
	-- Iterate all the enabled macro sets.
	-- Check that the toon has the tag for the macro set.  If so, use that macro set.
	local variableSetName
	local variableSet 
	for index, macroSet in ipairs( AJM.db.macroSets ) do
		-- Macro set enabled?
		if macroSet.enabled == true then
			-- Character has macro set tag?
			if JambaApi.DoesCharacterHaveTag( AJM.characterName, macroSet.tag ) == true then
				-- Variable set exists?
				variableSetName = macroSet.variableSet
				if variableSetName ~= nil and variableSetName:trim() ~= "" then
					variableSet = AJM:GetVariableSetByName( variableSetName )
					if variableSet == nil then
						AJM:Print( L["Can not find variable set: X"]( variableSetName ) )
					else
						-- Lets go make macros!
						AJM:UpdateInternalMacros( macroSet, variableSet, silent )				
					end
				else
					AJM:Print( L["Can not find variable set: X"]( "" ) )
				end	
				
			end
		end
	end
end

function AJM:UpdateMacrosUseSetCommand( info, parameters )
	AJM:JambaSendCommandToTeam( AJM.COMMAND_MACROSET_USE )
end

function AJM:SubstituteVariablesAndTagsForValues( originalMacroText, variables )
	local macroText = originalMacroText
	-- Substitute tags.
	for index, tag in JambaApi.AllTagsList() do
		local characterName = JambaApi.GetCharacterWithTag( tag )
		if characterName ~= "" then
			macroText = macroText:gsub( "#"..tag.."#", characterName )
		end
	end
	-- Substitute variables.	
	for position, variable in pairs( variables ) do
		-- Check to see if this variable is to be used if the character has a tag 
		-- or if the character does not have a tag (tag prefixed by !).
		local tag = variable.tag
		local hasTag = true
		if tag:sub( 1, 1 ) == "!" then
			tag = tag:sub( 2 )
			hasTag = false
		end
		if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == hasTag then
			macroText = macroText:gsub( "#"..variable.name.."#", variable.value )
		end
	end
	return macroText
end

function AJM:ClearMacroKeyBinding( macroSetName, macroName )
	local frameKey = macroSetName..macroName
	if AJM.macroFrames[frameKey] ~= nil then
		ClearOverrideBindings( AJM.macroFrames[frameKey] )
		AJM.macroFrames[frameKey]:SetAttribute( "macrotext", "" )
	end
end

function AJM:ClearMacroSetKeyBindings( macroSetName )
	local macroSetToClear = AJM:GetMacroSetByName( macroSetName )
	if macroSetToClear ~= nil then
		for positionToClear, macroToClear in pairs( macroSetToClear.macros ) do
			local frameKeyToClear = macroSetToClear.name..macroToClear.name
			if AJM.macroFrames[frameKeyToClear] ~= nil then					
				ClearOverrideBindings( AJM.macroFrames[frameKeyToClear] )
				AJM.macroFrames[frameKeyToClear]:SetAttribute( "macrotext", "" )
			end
		end
	end
end

--[[
function AJM:UpdateCurrentMacroSet( silent )
	local variableSet = AJM:GetVariableSetByName( AJM.db.currentVariableSetName )
	local macroSet = AJM:GetMacroSetByName( AJM.db.currentMacroSetName )
	if macroSet ~= nil and variableSet ~= nil then
		AJM:UpdateInternalMacros( macroSet, variableSet, silent )
	end
end
]]--

function AJM:UpdateInternalMacros( macroSet, variableSet, silent )
	if macroSet == nil then
		if silent == false then
			AJM:Print( L["Please choose a macro set to use."] )
		end
		return
	end
	if variableSet == nil then
		if silent == false then
			AJM:Print( L["Please choose a variable set to use."] )
		end
		return
	end
	if silent == false then
		AJM:Print( L["Using macros set: X"]( macroSet.name ) )
		AJM:Print( L["Using variables set: X"]( variableSet.name ) )
	end
	AJM.db.currentVariableSetName = variableSet.name
	AJM.db.currentMacroSetName = macroSet.name
	if InCombatLockdown() == 1 then
		AJM:Print( L["In combat, waiting until after combat to update the macros."] )
		AJM.pendingMacroUpdate = true
		return
	end
	--[[
	-- Clear the previous macros.
	AJM:ClearMacroSetKeyBindings( AJM.previousMacroSetName )
	AJM.previousMacroSetName = macroSet.name
	]]--
	-- Create a new set of macros based on this macro set.
	for position, macro in pairs( macroSet.macros ) do
		-- Check to see if this is macro is to be used if the character has a tag 
		-- or if the character does not have a tag (tag prefixed by !).
		local tag = macro.tag
		local hasTag = true
		if tag:sub( 1, 1 ) == "!" then
			tag = tag:sub( 2 )
			hasTag = false
		end
		if JambaApi.DoesCharacterHaveTag( AJM.characterName, tag ) == hasTag then
			local macroText = AJM:SubstituteVariablesAndTagsForValues( macro.text, variableSet.variables )
			local frameKey = macroSet.name..macro.name
			if AJM.macroFrames[frameKey] == nil then
				AJM.macroFrames[frameKey] = CreateFrame( "Button", "JMB_"..macro.name, nil, "SecureActionButtonTemplate" )
			end
			-- Set the macro text and key binding.
			AJM.macroFrames[frameKey]:SetAttribute( "type", "macro" )
			AJM.macroFrames[frameKey]:SetAttribute( "macrotext", macroText )
			SetOverrideBindingClick( AJM.macroFrames[frameKey], true, macro.key, AJM.macroFrames[frameKey]:GetName() )
			-- Show the player.
			if silent == false then
				AJM:Print( macro.name, macro.key )
				AJM:Print( macroText )	
			end
		end
	end
end

function AJM:SettingsMacrosShowClick( event )
	local macro = AJM:GetMacroAtPosition( AJM.settingsControlMacros.macrosHighlightRow )
	local variableSet = AJM:GetVariableSetAtPosition( AJM.settingsControlVariables.variableSetsHighlightRow )
	local macroText = AJM:SubstituteVariablesAndTagsForValues( macro.text, variableSet.variables )
	AJM:Print( macro.name, macro.key )
	AJM:Print( macroText )		
end

--[[
-------------------------------------------------------------------------------------------------------------
-- Frame storage.
-------------------------------------------------------------------------------------------------------------

function AJM:GetMacroFrame()
	local freeFrameAtIndex = #AJM.storedMacroFrames
	local frame = nil
	if freeFrameAtIndex == 0 then
		AJM.frameCount = AJM.frameCount + 1
		frame = CreateFrame( "Button", "JambaMacroFrame"..AJM.frameCount, nil, "SecureActionButtonTemplate" )
		frame:SetAttribute( "type", "macro" )
		frame:SetAttribute( "macrotext", "" )
	else
		frame = table.remove( AJM.storedMacroFrames, freeFrameAtIndex )
	end
	return frame
end

function AJM:FreeMacroFrame( frame )
	-- Clean the frame by removing the key bindings and macro text.
	ClearOverrideBindings( frame )
	frame:SetAttribute( "macrotext", "" )
	table.insert( AJM.storedMacroFrames, frame )
end
]]--

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
   StaticPopupDialogs["JAMBAMACRO_ASK_VARIABLE_SET_NAME"] = {
        text = L["Enter name for this SET of variables:"],
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
			AJM:AddVariableSetGUI( value )
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
				AJM:AddVariableSetGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMACRO_CONFIRM_REMOVE_VARIABLE_SET"] = {
        text = L['Are you sure you wish to remove "%s" from the variable SET list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveVariableSetGUI()
		end,
    }        
   StaticPopupDialogs["JAMBAMACRO_ASK_VARIABLE_NAME"] = {
        text = L["Enter name for this variable:"],
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
			AJM:AddVariableGUI( value )
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
				AJM:AddVariableGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMACRO_CONFIRM_REMOVE_VARIABLE"] = {
        text = L['Are you sure you wish to remove "%s" from the variable list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveVariableGUI()
		end,
    }        
	StaticPopupDialogs["JAMBAMACRO_ASK_MACRO_SET_NAME"] = {
        text = L["Enter name for this SET of macros:"],
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
			AJM:AddMacroSetGUI( value )
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
				AJM:AddMacroSetGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMACRO_CONFIRM_REMOVE_MACRO_SET"] = {
        text = L['Are you sure you wish to remove "%s" from the macro SET list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveMacroSetGUI()
		end,
    }        
   StaticPopupDialogs["JAMBAMACRO_ASK_MACRO_NAME"] = {
        text = L["Enter name for this macro:"],
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
			AJM:AddMacroGUI( value )
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
				AJM:AddMacroGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMACRO_CONFIRM_REMOVE_MACRO"] = {
        text = L['Are you sure you wish to remove "%s" from the macro list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveMacroGUI()
		end,
    }        
   StaticPopupDialogs["JAMBAMACRO_ASK_VARIABLE_SET_COPY_NAME"] = {
        text = L["Enter name for the copy of this SET of variables:"],
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
			AJM:CopyVariableSetGUI( value )
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
				AJM:CopyVariableSetGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }
   StaticPopupDialogs["JAMBAMACRO_ASK_MACRO_SET_COPY_NAME"] = {
        text = L["Enter name for the copy of this SET of macros:"],
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
			AJM:CopyMacroSetGUI( value )
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
				AJM:CopyMacroSetGUI( value )
            end
            this:GetParent():Hide()
        end,		
    }	
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControlVariables.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	-- Click the first row, column to set the child controls on the lists.
	AJM:SettingsMacroControlRowClick( 1, 1 )	
	AJM:SettingsVariableSetsRowClick( 1, 1 )	
	AJM:SettingsMacroSetsRowClick( 1, 1 )	
	-- Clear existing macro frames.
	AJM:ClearMacroFrames()
	-- Update the macros.
	AJM:UpdateMacrosUseSetCommandAction( true )
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "PLAYER_REGEN_ENABLED" )	
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

function AJM:PLAYER_REGEN_ENABLED()
	if AJM.pendingMacroUpdate == true then
		AJM.pendingMacroUpdate = false
		AJM:UpdateMacrosUseSetCommandAction( false )
	end
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if commandName == AJM.COMMAND_MACROSET_USE then
		AJM:UpdateMacrosUseSetCommandReceive( ... )
	end
end
