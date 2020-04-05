--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Some code borrowed from DruidTimerBars by Gilbert - Tichondrius US (license is Public Domain)

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaProc", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceTimer-3.0"
)

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )
AJM.SharedMedia = LibStub( "LibSharedMedia-3.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Proc"
AJM.settingsDatabaseName = "JambaProcProfileDBv2"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-proc"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Proc"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		procEnabled = true,
		procEnabledOnMasterOnly = true,
		procTimerBarHeight = 22,
		procTimerBarWidth = 350,
		procTimerBarSpacing = 3,
		procTimerBarDurationWidth = 55,
		framePoint = "CENTER",
		frameRelativePoint = "CENTER",
		frameXOffset = 0,
		frameYOffset = 0,			
		barTexture = L["Blizzard"],
		barFont = L["Friz Quadrata TT"],
		barFontSize = 10,
		showConfigBars = false,
		procs = {},
		initialLoad1 = false,
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
				desc = L["Push the proc settings to all characters in the team."],
				usage = "/jamba-proc push",
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
-- Proc Management.
-------------------------------------------------------------------------------------------------------------

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
	-- Update the settings area list.
	AJM.settingsControl.procCheckBoxEnable:SetValue( AJM.db.procEnabled )
	AJM:SettingsProcListScrollRefresh()
	AJM.settingsControl.appearanceProcBarMediaStatus:SetValue( AJM.db.barTexture )
	AJM.settingsControl.appearanceProcBarMediaFont:SetValue( AJM.db.barFont )
	AJM.settingsControl.appearanceProcBarMediaFontSizeSlider:SetValue( AJM.db.barFontSize )
	AJM.settingsControl.appearanceProcBarWidthSlider:SetValue( AJM.db.procTimerBarWidth )
	AJM.settingsControl.appearanceProcBarHeightSlider:SetValue( AJM.db.procTimerBarHeight )
	AJM.settingsControl.appearanceProcBarSpacingSlider:SetValue( AJM.db.procTimerBarSpacing )
	AJM.settingsControl.procCheckBoxShowConfigBars:SetValue( AJM.db.showConfigBars )
	AJM.settingsControl.procCheckBoxShowOnlyOnMaster:SetValue( AJM.db.procEnabledOnMasterOnly )
	AJM:SettingsUpdateStatusBarMediaAppearance()
	AJM:SettingsUpdateStatusBarLayout()
	-- State
	AJM.settingsControl.appearanceProcBarMediaStatus:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.appearanceProcBarMediaFont:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.appearanceProcBarMediaFontSizeSlider:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.appearanceProcBarWidthSlider:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.appearanceProcBarHeightSlider:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.appearanceProcBarSpacingSlider:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procCheckBoxShowConfigBars:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procCheckBoxShowOnlyOnMaster:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procListButtonAdd:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procListButtonRemove:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procEditBoxSpellName:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procEditBoxCooldown:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procEditBoxDisplayText:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procEditBoxTag:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procColourPicker:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procSound:SetDisabled( not AJM.db.procEnabled )
	AJM.settingsControl.procListButtonUpdate:SetDisabled( not AJM.db.procEnabled )
end

function AJM:SettingsUpdateStatusBarMediaAppearance()
	if AJM.procTimerBars == nil then
		return
	end
	local statusBarTexture = AJM.SharedMedia:Fetch( "statusbar", AJM.db.barTexture )
	local statusBarFont = AJM.db.barFont
	local reDraw = false
	if AJM.currentBarTexture ~= statusBarTexture then
		AJM.currentBarTexture = statusBarTexture
		reDraw = true
	end
	if AJM.currentBarFont ~= statusBarFont then
		AJM.currentBarFont = statusBarFont
		reDraw = true
	end
	if AJM.currentBarFontSize ~= AJM.db.barFontSize then
		AJM.currentBarFontSize = AJM.db.barFontSize
		reDraw = true
	end
	if reDraw == false then
		return
	end
	for index, procBar in pairs( AJM.procTimerBars ) do
		if procBar.bar ~= nil then
			procBar.bar:SetStatusBarTexture( statusBarTexture )
			procBar.bar:GetStatusBarTexture():SetHorizTile( false )
			procBar.bar:GetStatusBarTexture():SetVertTile( false )
			procBar.bar.dshadow:SetFont( AJM.SharedMedia:Fetch( "font", statusBarFont ), AJM.db.barFontSize )
			procBar.bar.duration:SetFont( AJM.SharedMedia:Fetch( "font", statusBarFont ), AJM.db.barFontSize )
			procBar.bar.shadow:SetFont( AJM.SharedMedia:Fetch( "font", statusBarFont ), AJM.db.barFontSize )
			procBar.bar.label:SetFont( AJM.SharedMedia:Fetch( "font", statusBarFont ), AJM.db.barFontSize )			
		end
	end
end

function AJM:SettingsUpdateStatusBarLayout()
	if AJM.procTimerBars == nil then
		return
	end
	for index, procBar in pairs( AJM.procTimerBars ) do
		if procBar.bar ~= nil then
		    procBar.bar:SetHeight( AJM.db.procTimerBarHeight )
			procBar.bar:SetWidth( AJM.db.procTimerBarWidth )
		    procBar.bar.icon:SetWidth( AJM.db.procTimerBarHeight )
			procBar.bar.icon:SetHeight( AJM.db.procTimerBarHeight )
			procBar.bar.label:SetWidth( AJM.db.procTimerBarWidth - AJM.db.procTimerBarDurationWidth )
			procBar.bar.label:SetHeight( AJM.db.procTimerBarHeight )
			procBar.bar.shadow:SetWidth( AJM.db.procTimerBarWidth - AJM.db.procTimerBarDurationWidth )
			procBar.bar.shadow:SetHeight( AJM.db.procTimerBarHeight )
		end
	end
	AJM.procFrame:SetWidth( (AJM.db.procTimerBarWidth + AJM.db.procTimerBarHeight) )
	AJM:UpdateProcBarTimerPositions( true )
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.procEnabled = settings.procEnabled
		AJM.db.procEnabledOnMasterOnly = settings.procEnabledOnMasterOnly
		AJM.db.procs = JambaUtilities:CopyTable( settings.procs )
		AJM.db.barTexture = settings.barTexture
		AJM.db.barFont = settings.barFont
		AJM.db.barFontSize = settings.barFontSize
		AJM.db.procTimerBarHeight = settings.procTimerBarHeight
		AJM.db.procTimerBarWidth = settings.procTimerBarWidth
		AJM.db.procTimerBarSpacing = settings.procTimerBarSpacing
		AJM.db.procTimerBarDurationWidth = settings.procTimerBarDurationWidth
		AJM.db.showConfigBars = settings.showConfigBars
		-- Refresh the settings.
		AJM:SettingsRefresh()
		AJM:UpdateProcEnabled()
		AJM:UpdateShowConfigBars()		
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

local function GetProcListMaxPosition()
	return #AJM.db.procs
end

local function GetProcAtPosition( position )
	return AJM.db.procs[position]
end

local function SetProcAtPosition( position, procInformation )
	AJM.db.procs[position] = procInformation
end

local function AddProc( spellID )
	local newProc = {}
	newProc.spellID = spellID
	local spellName, spellRank, spellIcon, spellPowerCost, spellIsFunnel, spellPowerType, spellCastingTime, spellMinRange, spellMaxRange = GetSpellInfo( spellID )	
	newProc.displayText = spellName
	newProc.tag = JambaApi.AllTag()
	newProc.type = "SPELL_AURA"
	newProc.coolDown = AJM.currentProcCooldown
	newProc.colourRed = AJM.currentProcColourR
	newProc.colourGreen = AJM.currentProcColourG
	newProc.colourBlue = AJM.currentProcColourB
	newProc.colourAlpha = 1.0
	newProc.sound = AJM.currentSound
	table.insert( AJM.db.procs, newProc )
	AJM:SettingsRefresh()			
	-- Click the proc list first row, column to set the child controls.
	AJM:SettingsProcListRowClick( 1, 1 )
end

local function AddProcWithDetails( spellID, displayText, type, coolDown, colourRed, colourGreen, colourBlue, colourAlpha, tag, sound )
	local newProc = {}
	newProc.spellID = spellID
	newProc.displayText = displayText
	newProc.tag = tag
	newProc.type = type
	newProc.coolDown = coolDown
	newProc.colourRed = colourRed
	newProc.colourGreen = colourGreen
	newProc.colourBlue = colourBlue
	newProc.colourAlpha = colourAlpha
	newProc.sound = sound
	table.insert( AJM.db.procs, newProc )
end

local function RemoveProc( spellID, displayText, tag )
	local procIndex = 0
	for index, proc in ipairs( AJM.db.procs ) do
		if (proc.spellID == spellID) and (proc.displayText == displayText) and (proc.tag == tag) then
			procIndex = index
			break
		end
	end
	if procIndex ~= 0 then
		table.remove( AJM.db.procs, procIndex )
	end
	-- Click the proc list first row, column to set the child controls.
	AJM:SettingsProcListRowClick( 1, 1 )		
end

function AJM:AddProcGUI( name )
	AddProc( name )
	AJM:SettingsProcListScrollRefresh()
end

function AJM:RemoveProcGUI()
	local proc = GetProcAtPosition( AJM.settingsControl.procListHighlightRow )	
	RemoveProc( proc.spellID, proc.displayText, proc.tag )
	AJM.settingsControl.procListHighlightRow = 1	
	AJM:SettingsProcListScrollRefresh()
end

function AJM:LoadDefaultProcs()
	AddProcWithDetails( 59578, L["The Art of War"], "SPELL_AURA", 15, 0.0, 1.0, 1.0, 1.0, JambaApi.AllTag(), L["None"] )
	AddProcWithDetails( 48108, L["Hot Streak"],"SPELL_AURA", 10,1.0,0.0,0.0,1.0,JambaApi.AllTag(),L["None"] )
    AddProcWithDetails( 44401, L["Missile Barrage"], "SPELL_AURA", 15, 0.45, 0.24, 0.65, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 57761, L["Fireball!"], "SPELL_AURA", 15, 0.15, 0.94, 0.35, 1, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 16246, L["Clearcasting (Shaman)"], "SPELL_AURA", 15, 0.49, 0.12, 0.12, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 16870, L["Clearcasting (Druid)"], "SPELL_AURA", 15, 0.99, 0.59, 0.78, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 53817, L["Maelstrom Weapon"], "SPELL_AURA", 30, 0.59, 0.39, 0.62, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 64823, L["Elune's Wrath"], "SPELL_AURA", 10, 0.89, 0.12, 0.12, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 17941, L["Shadow Trance"], "SPELL_AURA", 10, 0.23, 0.23, 0.66, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 59052, L["Freezing Fog"], "SPELL_AURA", 15, 0.83, 0.19, 0.73, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 54149, L["Infusion of Light"], "SPELL_AURA", 15, 0.05, 0.65, 0.49, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 12536, L["Clearcasting (Mage)"], "SPELL_AURA", 15, 0.89, 0.82, 0.72, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 56453, L["Lock and Load"], "SPELL_AURA", 12, 0.77, 0.23, 0.77, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 48518, L["Eclipse (Lunar)"], "SPELL_AURA", 15, 0.2, 0.4, 0.2, 1.0, JambaApi.AllTag(), L["None"] )
    AddProcWithDetails( 48517, L["Eclipse (Solar)"], "SPELL_AURA", 15, 0.2, 0.7, 0.7, 1.0, JambaApi.AllTag(), L["None"] )
	AJM:SettingsRefresh()			
	-- Click the proc list first row, column to set the child controls.
	AJM:SettingsProcListRowClick( 1, 1 )
end

-------------------------------------------------------------------------------------------------------------
-- Settings Dialogs.
-------------------------------------------------------------------------------------------------------------

local function SettingsCreateProcList()
	-- Position and size constants.
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local procListButtonControlWidth = 105
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local top = JambaHelperSettings:TopOfSettings()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local procListWidth = headingWidth
	-- Team list internal variables (do not change).
	AJM.settingsControl.procListHighlightRow = 1
	AJM.settingsControl.procListOffset = 1
	AJM.settingsControl.procCheckBoxEnable = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		top, 
		L["Enable Jamba Proc"],
		AJM.SettingsToggleProcEnable
	)
	-- Create a heading.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Proc List"], top - checkBoxHeight - verticalSpacing, false )
	-- Create an area list frame.
	local list = {}
	list.listFrameName = "JambaProcSettingsProcListFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = top - headingHeight - checkBoxHeight - verticalSpacing
	list.listLeft = left
	list.listWidth = procListWidth
	list.rowHeight = 20
	list.rowsToDisplay = 5
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 15
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 85
	list.columnInformation[2].alignment = "LEFT"
	list.scrollRefreshCallback = AJM.SettingsProcListScrollRefresh
	list.rowClickCallback = AJM.SettingsProcListRowClick
	AJM.settingsControl.procList = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.procList )
	-- Position and size constants (once list height is known).
	local bottomOfList = top - headingHeight - list.listHeight - verticalSpacing - checkBoxHeight - verticalSpacing
	local bottomOfSection = bottomOfList - verticalSpacing - buttonHeight - verticalSpacing
	-- Create buttons.
	AJM.settingsControl.procListButtonAdd = JambaHelperSettings:CreateButton(	
		AJM.settingsControl, 
		procListButtonControlWidth, 
		left, 
		bottomOfList, 
		L["Add"],
		AJM.SettingsAddClick
	)
	AJM.settingsControl.procListButtonRemove = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		procListButtonControlWidth, 
		left + horizontalSpacing + procListButtonControlWidth, 
		bottomOfList, 
		L["Remove"],
		AJM.SettingsRemoveClick
	)	
	return bottomOfSection
end

local function SettingsCreateProcConfiguration( top )
	local procListButtonControlWidth = 105
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local dropdownHeight = JambaHelperSettings:GetDropdownHeight()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()
	local colourPickerHeight = JambaHelperSettings:GetColourPickerHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local halfWidth = (headingWidth - (horizontalSpacing  * 3)) / 2
	local column1Left = left
	local column2Left = left + halfWidth + (horizontalSpacing * 3)
	local procConfigurationTop = top - headingHeight
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Proc Configuration"], top, false )
		AJM.settingsControl.procEditBoxSpellName = JambaHelperSettings:CreateEditBox( AJM.settingsControl,
		halfWidth,
		column1Left,
		procConfigurationTop,
		L["Spell ID"]
	)	
	AJM.settingsControl.procEditBoxSpellName:SetCallback( "OnEnterPressed", AJM.EditBoxSpellNameChanged )
	AJM.settingsControl.procEditBoxCooldown = JambaHelperSettings:CreateEditBox( 
		AJM.settingsControl, 
		halfWidth, 
		column2Left, 
		procConfigurationTop, 
		L["Proc Duration (seconds)"] 
	)
	AJM.settingsControl.procEditBoxCooldown:SetCallback( "OnEnterPressed", AJM.EditBoxProcCooldownChanged )
	procConfigurationTop = procConfigurationTop - dropdownHeight	
	AJM.settingsControl.procEditBoxDisplayText = JambaHelperSettings:CreateEditBox(
		AJM.settingsControl,
		headingWidth,
		column1Left,
		procConfigurationTop,
		L["Display Text"]
	)
	AJM.settingsControl.procEditBoxDisplayText:SetCallback( "OnEnterPressed", AJM.EditBoxDisplayTextChanged )
	procConfigurationTop = procConfigurationTop - dropdownHeight	
	AJM.settingsControl.procEditBoxTag = JambaHelperSettings:CreateEditBox(
		AJM.settingsControl,
		headingWidth,
		column1Left,
		procConfigurationTop,
		L["Tag"]
	)
	AJM.settingsControl.procEditBoxTag:SetCallback( "OnEnterPressed", AJM.EditBoxTagChanged )
	procConfigurationTop = procConfigurationTop - dropdownHeight
	AJM.settingsControl.procColourPicker = JambaHelperSettings:CreateColourPicker(
		AJM.settingsControl,
		halfWidth,
		column1Left,
		procConfigurationTop - 13,
		L["Proc Colour"]
	)
	AJM.settingsControl.procColourPicker:SetHasAlpha( false )
	AJM.settingsControl.procColourPicker:SetCallback( "OnValueConfirmed", AJM.ProcColourPickerChanged )	
	AJM.settingsControl.procSound = JambaHelperSettings:CreateMediaSound( 
		AJM.settingsControl, 
		halfWidth, 
		column2Left, 
		procConfigurationTop,
		L["Proc Sound"]
	)
	AJM.settingsControl.procSound:SetCallback( "OnValueChanged", AJM.ProcSoundChanged )
	procConfigurationTop = procConfigurationTop - mediaHeight - verticalSpacing
	AJM.settingsControl.procListButtonUpdate = JambaHelperSettings:CreateButton(
		AJM.settingsControl, 
		procListButtonControlWidth, 
		column1Left, 
		procConfigurationTop, 
		L["Save"],
		AJM.SettingsUpdateClick
	)		
	procConfigurationTop = procConfigurationTop - buttonHeight
	AJM.settingsControl.procEditBoxTag:SetText( "" )
	AJM.settingsControl.procEditBoxDisplayText:SetText( "" )
	AJM.settingsControl.procEditBoxSpellName:SetText( "" )	
	AJM.settingsControl.procEditBoxCooldown:SetText( "" )
	local bottomOfSection = procConfigurationTop
	return bottomOfSection	
end

local function SettingsCreateProcAppearanceAndLayout( top )
	local left = JambaHelperSettings:LeftOfSettings()	
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local mediaHeight = JambaHelperSettings:GetMediaHeight()
	local sliderHeight = JambaHelperSettings:GetSliderHeight()
	local halfWidth = (headingWidth - horizontalSpacing) / 2
	local column2left = left + halfWidth
	local movingTop = top
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Appearance & Layout"], movingTop, true )
	movingTop = movingTop - headingHeight
	AJM.settingsControl.procCheckBoxShowConfigBars = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show Test Bars"],
		AJM.SettingsToggleShowConfigBars
	)
	movingTop = movingTop - checkBoxHeight - verticalSpacing
	AJM.settingsControl.procCheckBoxShowOnlyOnMaster = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Show Proc Bars Only On Master"],
		AJM.SettingsToggleShowOnMasterOnly
	)	
	movingTop = movingTop - checkBoxHeight - verticalSpacing	
	AJM.settingsControl.appearanceProcBarMediaStatus = JambaHelperSettings:CreateMediaStatus( 
		AJM.settingsControl, 
		halfWidth, 
		left, 
		movingTop,
		L["Proc Bar Texture"]
	)
	AJM.settingsControl.appearanceProcBarMediaStatus:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarTexture )
	AJM.settingsControl.appearanceProcBarMediaFont = JambaHelperSettings:CreateMediaFont( 
		AJM.settingsControl, 
		halfWidth, 
		column2left, 
		movingTop,
		L["Proc Bar Font"]
	)
	AJM.settingsControl.appearanceProcBarMediaFont:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarFont )
	movingTop = movingTop - mediaHeight - verticalSpacing
	AJM.settingsControl.appearanceProcBarMediaFontSizeSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Proc Bar Font Size"]
	)
	AJM.settingsControl.appearanceProcBarMediaFontSizeSlider:SetSliderValues( 5, 25, 0.25 )
	AJM.settingsControl.appearanceProcBarMediaFontSizeSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarFontSize )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControl.appearanceProcBarWidthSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Proc Bar Width"]
	)
	AJM.settingsControl.appearanceProcBarWidthSlider:SetSliderValues( 50, 500, 5 )
	AJM.settingsControl.appearanceProcBarWidthSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarWidth )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControl.appearanceProcBarHeightSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Proc Bar Height"]
	)
	AJM.settingsControl.appearanceProcBarHeightSlider:SetSliderValues( 5, 100, 1 )
	AJM.settingsControl.appearanceProcBarHeightSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarHeight )
	movingTop = movingTop - sliderHeight - verticalSpacing
	AJM.settingsControl.appearanceProcBarSpacingSlider = JambaHelperSettings:CreateSlider( 
		AJM.settingsControl, 
		headingWidth, 
		left, 
		movingTop, 
		L["Proc Bar Spacing"]
	)
	AJM.settingsControl.appearanceProcBarSpacingSlider:SetSliderValues( 0, 20, 0.25 )
	AJM.settingsControl.appearanceProcBarSpacingSlider:SetCallback( "OnValueChanged", AJM.SettingsChangeStatusBarSpacing )
	movingTop = movingTop - sliderHeight - verticalSpacing
	local bottomOfSection = movingTop
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
	-- Create the proc list controls.
	local bottomOfProcList = SettingsCreateProcList()
	-- Create the proc configuration controls.
	local bottomOfProcConfiguration = SettingsCreateProcConfiguration( bottomOfProcList )
	local bottomOfAppearanceAndLayout = SettingsCreateProcAppearanceAndLayout( bottomOfProcConfiguration )
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfAppearanceAndLayout )
end

-------------------------------------------------------------------------------------------------------------
-- Settings Callbacks.
-------------------------------------------------------------------------------------------------------------

function AJM:SettingsChangeStatusBarTexture( event, value )
	AJM.db.barTexture = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarFont( event, value )
	AJM.db.barFont = value
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarFontSize( event, value )
	AJM.db.barFontSize = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarWidth( event, value )
	AJM.db.procTimerBarWidth = tonumber( value )
	AJM.db.procTimerBarDurationWidth = AJM.db.procTimerBarWidth * 0.1636363636
	if AJM.db.procTimerBarDurationWidth < 30 then
		AJM.db.procTimerBarDurationWidth = 30
	end
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarHeight( event, value )
	AJM.db.procTimerBarHeight = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsChangeStatusBarSpacing( event, value )
	AJM.db.procTimerBarSpacing = tonumber( value )
	AJM:SettingsRefresh()
end

function AJM:SettingsProcListScrollRefresh()
	FauxScrollFrame_Update(
		AJM.settingsControl.procList.listScrollFrame, 
		GetProcListMaxPosition(),
		AJM.settingsControl.procList.rowsToDisplay, 
		AJM.settingsControl.procList.rowHeight
	)
	AJM.settingsControl.procListOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.procList.listScrollFrame )
	for iterateDisplayRows = 1, AJM.settingsControl.procList.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.procList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.procList.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.procList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.procList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.procList.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.procListOffset
		if dataRowNumber <= GetProcListMaxPosition() then
			-- Put proc information into columns.
			local procInformation = GetProcAtPosition( dataRowNumber )
			AJM.settingsControl.procList.rows[iterateDisplayRows].columns[1].textString:SetText( procInformation.spellID )
			AJM.settingsControl.procList.rows[iterateDisplayRows].columns[2].textString:SetText( procInformation.displayText )
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.procListHighlightRow then
				AJM.settingsControl.procList.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end
end

function AJM:EditBoxProcCooldownChanged( event, value )
	AJM.currentProcCooldown = tonumber( value )
end

local function UpdateProcInformation()		
	-- Update the area type controls to reflect the information for this selection.
	local procInformation = GetProcAtPosition( AJM.settingsControl.procListHighlightRow )
	-- Update controls.
	AJM.settingsControl.procEditBoxTag:SetText( procInformation.tag )
	AJM.currentEditBoxTagText = procInformation.tag
	AJM.settingsControl.procEditBoxDisplayText:SetText( procInformation.displayText )
	AJM.currentEditBoxDisplayTextText = procInformation.displayText
	AJM.settingsControl.procEditBoxSpellName:SetText( procInformation.spellID )
	AJM.currentEditBoxSpellNameText = procInformation.spellID
	AJM.settingsControl.procEditBoxCooldown:SetText( procInformation.coolDown )
	AJM.currentProcCooldown = tonumber( procInformation.coolDown )
	AJM.settingsControl.procColourPicker:SetColor( procInformation.colourRed, procInformation.colourGreen, procInformation.colourBlue, 1.0 )
	AJM.currentProcColourR = tonumber( procInformation.colourRed )
	AJM.currentProcColourG = tonumber( procInformation.colourGreen )
	AJM.currentProcColourB = tonumber( procInformation.colourBlue )
	AJM.settingsControl.procSound:SetValue( procInformation.sound )
	AJM.currentSound = procInformation.sound
end

function AJM:SettingsProcListRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.procListOffset + rowNumber <= GetProcListMaxPosition() then
		AJM.settingsControl.procListHighlightRow = AJM.settingsControl.procListOffset + rowNumber
		UpdateProcInformation()
		AJM:SettingsProcListScrollRefresh()
	end
end

function AJM:ProcColourPickerChanged( event, r, g, b, a )
	AJM.currentProcColourR = r
	AJM.currentProcColourG = g
	AJM.currentProcColourB = b
end

function AJM:EditBoxTagChanged( event, text )
	AJM.currentEditBoxTagText = text
end

function AJM:ProcSoundChanged( event, value )
	AJM.currentSound = value
end

function AJM:EditBoxDisplayTextChanged( event, text )
	AJM.currentEditBoxDisplayTextText = text
end

function AJM:EditBoxSpellNameChanged( event, text )
	AJM.currentEditBoxSpellNameText = text
end

local function SetProcConfigurationIntoCurrentProc()
	-- Get information from table at position.
	local procInformation = GetProcAtPosition( AJM.settingsControl.procListHighlightRow )
	procInformation.coolDown = tonumber( AJM.currentProcCooldown )
	procInformation.tag = AJM.currentEditBoxTagText
	procInformation.displayText = AJM.currentEditBoxDisplayTextText
	procInformation.spellID = AJM.currentEditBoxSpellNameText
	procInformation.colourRed = AJM.currentProcColourR
	procInformation.colourGreen = AJM.currentProcColourG
	procInformation.colourBlue = AJM.currentProcColourB
	procInformation.sound = AJM.currentSound
	-- Put information back into table at position.
	SetProcAtPosition( AJM.settingsControl.procListHighlightRow, procInformation )
	-- Refresh the settings.
	AJM:SettingsRefresh()
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsUpdateClick( event )
	SetProcConfigurationIntoCurrentProc()
end

function AJM:SettingsAddClick( event )
	StaticPopup_Show( "JAMBAMPROC_ASK_PROC_SPELL_NAME" )
end

function AJM:SettingsToggleProcEnable( event, checked )
	AJM.db.procEnabled = checked
	AJM:UpdateProcEnabled()
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowConfigBars( event, checked )
	AJM.db.showConfigBars = checked
	AJM:UpdateShowConfigBars()
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleShowOnMasterOnly( event, checked )
	AJM.db.procEnabledOnMasterOnly = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsRemoveClick( event )
	local procInformation = GetProcAtPosition( AJM.settingsControl.procListHighlightRow )
	StaticPopup_Show( "JAMBAPROC_CONFIRM_REMOVE_PROC", procInformation.spellID )
end

function AJM:UpdateShowConfigBars()
	if AJM.db.showConfigBars == true then
		AJM.showConfigurationBarsTimer = AJM:ScheduleRepeatingTimer( "ShowConfigurationBars", 21 )
		AJM:ShowConfigurationBars()
	else
		if AJM.showConfigurationBarsTimer ~= nil then
			AJM:CancelTimer( AJM.showConfigurationBarsTimer )
		end
		AJM:RemoveConfigurationBars()
	end
end

function AJM:UpdateProcEnabled()
	if AJM.procFrame ~= nil then
		if AJM.db.procEnabled == true then
			AJM.procFrame:Show()
		else
			AJM.procFrame:Hide()
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- Popup Dialogs.
-------------------------------------------------------------------------------------------------------------

-- Initialize Popup Dialogs.
local function InitializePopupDialogs()
   StaticPopupDialogs["JAMBAMPROC_ASK_PROC_SPELL_NAME"] = {
        text = L["Enter the ID of the spell to add:"],
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
			AJM:AddProcGUI( messageName )
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
				AJM:AddProcGUI( messageName )
            end
            this:GetParent():Hide()
        end,		
    }
   -- Confirm removing characters from member list.
   StaticPopupDialogs["JAMBAPROC_CONFIRM_REMOVE_PROC"] = {
        text = L['Are you sure you wish to remove "%s" from the proc list?'],
        button1 = YES,
        button2 = NO,
        timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
        OnAccept = function()
			AJM:RemoveProcGUI()
		end,
    }        
end

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	AJM.currentProcColourR = 0.5
	AJM.currentProcColourG = 0.5
	AJM.currentProcColourB = 0.5
	AJM.currentBarTexture = ""
	AJM.currentBarFont = ""
	AJM.currentBarSize = ""
	AJM.currentSound = L["None"]
	AJM.currentEditBoxTagText = ""
	AJM.currentEditBoxDisplayTextText = ""
	AJM.currentEditBoxSpellNameText = ""	
	AJM.currentProcCooldown = 55
	-- Create the settings control.
	SettingsCreate()
	-- Initialise the JambaModule part of this module.
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.
	AJM:SettingsRefresh()	
	-- Initialise the popup dialogs.
	InitializePopupDialogs()
	-- Click the proc list first row, column to set the child controls.
	AJM:SettingsProcListRowClick( 1, 1 )
	AJM.tempPositionTimeBars = {}
	AJM.procTimerBarPosition = 0
	AJM.procTimerBars = {}
	AJM.procTimerBarTop = 0
	AJM.procTimerBarLeft = 0
	AJM:CreateProcFrame()
	if AJM.db.initialLoad1 == false then
		AJM:LoadDefaultProcs()
		AJM.db.initialLoad1 = true
	end
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	AJM:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" )
	AJM:UpdateProcEnabled()
	AJM:UpdateShowConfigBars()
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end

-------------------------------------------------------------------------------------------------------------
-- JambaProc functionality.
-------------------------------------------------------------------------------------------------------------

function AJM:ShowConfigurationBars()
	AJM.procFrame:SetBackdropColor( 1.0, 1.0, 1.0, 1.0 )
	AJM.procFrame:EnableMouse( true )
	AJM:AddProcBarTimer( L["Toon-Name-2"], L["Proc Information Text Displayed Here"], 20, 1.0, 0.1, 0.1, 1.0, 57761, false )
	AJM:AddProcBarTimer( L["Toon-Name-3"], L["Proc Information Text Displayed Here"], 17.5, 0.8, 0.2, 0.4, 1.0, 48108, false )
	AJM:AddProcBarTimer( L["Toon-Name-1"], L["Proc Information Text Displayed Here"], 15, 0.3, 0.6, 0.8, 1.0, 59578, false )
	AJM:AddProcBarTimer( L["Toon-Name-1"], L["Proc Information Text Displayed Here"], 12.5, 1.0, 0.1, 0.1, 1.0, 57761, false )
	AJM:AddProcBarTimer( L["Toon-Name-2"], L["Proc Information Text Displayed Here"], 10, 0.8, 0.2, 0.4, 1.0, 48108, false )
	AJM:AddProcBarTimer( L["Toon-Name-3"], L["Proc Information Text Displayed Here"], 5, 0.3, 0.6, 0.8, 1.0, 59578, false )
end

function AJM:RemoveConfigurationBars()
	AJM.procFrame:SetBackdropColor( 1.0, 1.0, 1.0, 0.0 )
	AJM.procFrame:EnableMouse( false )
	AJM:RemoveProcBarTimer( L["Toon-Name-2"].."57761" )
	AJM:RemoveProcBarTimer( L["Toon-Name-3"].."48108" )	
	AJM:RemoveProcBarTimer( L["Toon-Name-1"].."59578" )
	AJM:RemoveProcBarTimer( L["Toon-Name-1"].."57761" )
	AJM:RemoveProcBarTimer( L["Toon-Name-2"].."48108" )
	AJM:RemoveProcBarTimer( L["Toon-Name-3"].."59578" )	
end

function AJM:CreateProcFrame()
	AJM.procFrame = CreateFrame( "Frame", "JambaProcBarAnchor", UIParent )
	AJM.procFrame:SetFrameStrata( "BACKGROUND" )
	AJM.procFrame:SetWidth( (AJM.db.procTimerBarWidth + AJM.db.procTimerBarHeight) )
	AJM.procFrame:SetHeight( 34 )
    AJM.procFrame:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background" } )
    AJM.procFrame:SetBackdropColor( 1.0, 1.0, 1.0, 0.0 )
    AJM.procFrame:RegisterForDrag( "LeftButton" )
    AJM.procFrame:SetMovable( true )
    AJM.procFrame:ClearAllPoints()
	AJM.procFrame:SetScript( "OnDragStart", 
		function( this ) 
			if IsAltKeyDown() == 1 then
				this:StartMoving() 
			end
		end )
	AJM.procFrame:SetScript( "OnDragStop", 
		function( this ) 
			this:StopMovingOrSizing() 
			point, relativeTo, relativePoint, xOffset, yOffset = this:GetPoint()
			AJM.db.framePoint = point
			AJM.db.frameRelativePoint = relativePoint
			AJM.db.frameXOffset = xOffset
			AJM.db.frameYOffset = yOffset
		end	)	
	AJM.procFrame:ClearAllPoints()
	AJM.procFrame:SetPoint( AJM.db.framePoint, UIParent, AJM.db.frameRelativePoint, AJM.db.frameXOffset, AJM.db.frameYOffset )	
    AJM.procFrame:Show()
    AJM.procFrame:SetScript( "OnUpdate",
		function()
			AJM:DoProcBarUpdates( self, elapsed )
		end )
end

function AJM:DoProcBarUpdates()
	local time = GetTime()
	for index, procBar in pairs( AJM.procTimerBars ) do
		if procBar.active == true then
			if time >= procBar.expires then
				AJM:RemoveProcBarTimer( procBar.key )
			else
				local progress = ((procBar.expires - time) / procBar.duration) * 100
				local timeLeft = procBar.expires - time
				AJM:UpdateProcBarTimer( procBar, progress, timeLeft )
			end
		end
    end
end

function AJM:UpdateProcBarTimer( procBar, progress, timeLeft )
	local timeLeftText = ""
	if timeLeft >= 60 then
	    timeLeftText = ( "%dm %1.1fs" ):format( (timeLeft / 60), (timeLeft % 60) )
	else
		timeLeftText = ( "%1.1fs" ):format( (timeLeft % 60) )
	end
	procBar.bar.dshadow:SetText( timeLeftText )
	procBar.bar.duration:SetText( timeLeftText )
	procBar.bar.spark:SetPoint( "LEFT", procBar.bar, "LEFT", (progress / 100 * AJM.db.procTimerBarWidth - 5), 0 )
	procBar.bar:SetValue( progress )
end

function AJM:CreateProcBar( key, labelText, spellID, textColourR, textColourG, textColourB, textColourA, barColourR, barColourG, barColourB, barColourA )
    local newBar = CreateFrame( "StatusBar", "JambaProcBar"..key, AJM.procFrame )
    -- Create all the portions of the bar.
    newBar.icon = CreateFrame( "Frame", "JambaProcBar"..key.."Icon", AJM.procFrame )
	newBar.backgroundTexture = newBar:CreateTexture( "JambaProcBar"..key.."BackgroundTexture", "ARTWORK" )
    newBar.dshadow = newBar:CreateFontString( nil, "OVERLAY" )
    newBar.duration = newBar:CreateFontString( nil, "OVERLAY" )
    newBar.shadow = newBar:CreateFontString( nil, "OVERLAY" )
    newBar.label = newBar:CreateFontString( nil, "OVERLAY" )
    newBar.spark = newBar:CreateTexture( nil, "OVERLAY" )
    -- Icon.
    local name, rank, icon, powerCost, isFunnel, powerType, castingTime, minRange, maxRange = GetSpellInfo( spellID )
    newBar.icon:SetWidth( AJM.db.procTimerBarHeight )
    newBar.icon:SetHeight( AJM.db.procTimerBarHeight )
    newBar.icon:SetBackdrop( {bgFile = icon} )
    newBar.icon:SetBackdropColor( 1, 1, 1, 1 )
    newBar.icon:SetPoint( "RIGHT", "JambaProcBar"..key, "LEFT", 0, 0 )
	-- Status Bar.	
    newBar:SetHeight( AJM.db.procTimerBarHeight )
	newBar:SetWidth( AJM.db.procTimerBarWidth )
    newBar:SetParent( UIParent )
    newBar:SetMinMaxValues( 0, 100 )
	newBar:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background" } )
	newBar:SetStatusBarTexture( AJM.SharedMedia:Fetch( "statusbar", AJM.db.barTexture ) )
	newBar:GetStatusBarTexture():SetHorizTile( false )
	newBar:GetStatusBarTexture():SetVertTile( false )
	newBar:SetBackdropColor( { r = barColourR, g = barColourG, b = barColourB, a = 0.2} )
	newBar:SetStatusBarColor( barColourR, barColourG, barColourB, barColourA )
	-- Status bar backdrop.
	newBar.backgroundTexture:SetTexture( barColourR, barColourG, barColourB, 0.15 )
	newBar.backgroundTexture:SetAllPoints()
	-- Duration backdrop.
	newBar.dshadow:SetFont( AJM.SharedMedia:Fetch( "font", AJM.db.barFont ), AJM.db.barFontSize )
	newBar.dshadow:SetTextColor( 0, 0, 0, .75 )
	newBar.dshadow:ClearAllPoints()
	newBar.dshadow:SetPoint( "RIGHT", newBar, "RIGHT", -6, -1 )
	-- Duration.
	newBar.duration:SetFont( AJM.SharedMedia:Fetch( "font", AJM.db.barFont ), AJM.db.barFontSize )
	newBar.duration:SetTextColor( textColourR, textColourG, textColourB, textColourA )
	newBar.duration:ClearAllPoints()
	newBar.duration:SetPoint( "RIGHT", newBar, "RIGHT", -5, 0 )
	-- Text backdrop.
	newBar.shadow:SetFont( AJM.SharedMedia:Fetch( "font", AJM.db.barFont ), AJM.db.barFontSize )
	newBar.shadow:SetTextColor( 0, 0, 0, .75 )
	newBar.shadow:SetHeight( AJM.db.procTimerBarHeight )
	newBar.shadow:SetWidth( AJM.db.procTimerBarWidth - AJM.db.procTimerBarDurationWidth )	
	newBar.shadow:ClearAllPoints()
	newBar.shadow:SetPoint( "LEFT", newBar, "LEFT", 2, -1 )
	newBar.shadow:SetText( labelText )
	-- Label.
	newBar.label:SetFont( AJM.SharedMedia:Fetch( "font", AJM.db.barFont ), AJM.db.barFontSize )
	newBar.label:SetTextColor( textColourR, textColourG, textColourB, textColourA )
	newBar.label:SetHeight( AJM.db.procTimerBarHeight )
	newBar.label:SetWidth( AJM.db.procTimerBarWidth - AJM.db.procTimerBarDurationWidth )
	newBar.label:ClearAllPoints()
	newBar.label:SetPoint( "LEFT", newBar, "LEFT", 1, 0 )
	newBar.label:SetText( labelText )
    -- Spark.
    newBar.spark:SetTexture( "Interface\\CastingBar\\UI-CastingBar-Spark" )
    newBar.spark:SetWidth( 10 )
    newBar.spark:SetBlendMode( "ADD" )
	return newBar
end

function AJM:UpdateProcBarTimerPositions( updateAll )
	JambaUtilities:ClearTable( AJM.tempPositionTimeBars )
	for index, procBar in pairs( AJM.procTimerBars ) do
		if procBar.active == true then
			AJM.tempPositionTimeBars[procBar.key] = procBar.position
		end
	end
	table.sort( AJM.tempPositionTimeBars )
	AJM.procTimerBarPosition = 0
	for procBarKey, oldPosition in pairs( AJM.tempPositionTimeBars ) do
		AJM.procTimerBars[procBarKey].position = AJM.procTimerBarPosition
		AJM.procTimerBarPosition = AJM.procTimerBarPosition + 1
	end
	for index, procBar in pairs( AJM.procTimerBars ) do
		if procBar.active == true or updateAll == true then
			AJM:SetProcBarTimerPosition( procBar )
		end
	end	
end

function AJM:SetProcBarTimerPosition( procBar )
	procBar.bar:SetPoint( "TOPLEFT", AJM.procFrame, "TOPLEFT", AJM.procTimerBarLeft, AJM.procTimerBarTop - (procBar.position * (AJM.db.procTimerBarHeight + AJM.db.procTimerBarSpacing) ) )
end

function AJM:AddProcBarTimer( characterName, displayText, timeLeft, colourRed, colourGreen, colourBlue, colourAlpha, spellID, isUpdate )
	local key = characterName..spellID
	if AJM.procTimerBars[key] == nil then
		AJM.procTimerBars[key] = {}
		AJM.procTimerBars[key].bar = AJM:CreateProcBar( key, characterName.." - "..displayText, spellID, 1, 1, 1, 1, colourRed, colourGreen, colourBlue, colourAlpha )
	end
	if isUpdate == false then
		AJM.procTimerBars[key].position = AJM.procTimerBarPosition
		AJM.procTimerBarPosition = AJM.procTimerBarPosition + 1
		AJM:SetProcBarTimerPosition( AJM.procTimerBars[key] )		
	end
	AJM.procTimerBars[key].duration = timeLeft
	AJM.procTimerBars[key].expires = GetTime() + timeLeft
	AJM.procTimerBars[key].active = true
	AJM.procTimerBars[key].key = key
	AJM.procTimerBars[key].bar:Show()
	AJM.procTimerBars[key].bar.icon:Show()
	AJM:UpdateProcBarTimerPositions( false )
end

function AJM:RemoveProcBarTimer( key )
	if AJM.procTimerBars[key] ~= nil then
		AJM.procTimerBars[key].active = false
		AJM.procTimerBars[key].bar:Hide()
		AJM.procTimerBars[key].bar.icon:Hide()
	end
	AJM:UpdateProcBarTimerPositions( false )	
end

function AJM:COMBAT_LOG_EVENT_UNFILTERED( ... )
	-- If not enabled, stop now.
	if AJM.db.procEnabled == false then
		return
	end
	-- If show only on master and not the master, stop now.
	if AJM.db.procEnabledOnMasterOnly == true then
		if JambaApi.IsCharacterTheMaster( AJM.characterName ) == false then
			return
		end
	end
	-- Get the combat log information.
	local wowEvent, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, param1, param2, param3, param4, param5, param6, param7, param8, param9 = ...
	-- See if the source of this information is in the team, if not stop now.
	if JambaApi.IsCharacterInTeam( sourceName ) == false then
		return
	end
	if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
		local isUpdate = false
		if event == "SPELL_AURA_REFRESH" then
			isUpdate = true
		end
		for index, procInformation in pairs( AJM.db.procs ) do
			if tonumber( param1 ) == tonumber( procInformation.spellID ) then
				if JambaApi.DoesCharacterHaveTag( sourceName, procInformation.tag ) == true then
					PlaySoundFile( AJM.SharedMedia:Fetch( "sound", procInformation.sound ) )
					AJM:AddProcBarTimer( sourceName, procInformation.displayText, procInformation.coolDown, procInformation.colourRed, procInformation.colourGreen, procInformation.colourBlue, procInformation.colourAlpha, param1, isUpdate )
				end
				break
			end
		end
	end
	if event == "SPELL_AURA_REMOVED" then
		for index, procInformation in pairs( AJM.db.procs ) do
			if param1 == procInformation.spellID then
				if JambaApi.DoesCharacterHaveTag( sourceName, procInformation.tag ) == true then
					AJM:RemoveProcBarTimer( sourceName..param1 )
				end
			end
		end			
	end
end

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
end
