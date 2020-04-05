-- Author      : olipcs
-- Create Date : 8/12/2009 
-- Version : 0.1
-- Credits: Many thanks goes to Jafula for the awsome JAMBA addon
--          Nearly all code where copy & pasted from Jafulas JAMBA 0.5 addon,
--          and only small additions where coded by me.
--          So again, many thanks Jafula, for making the Jamba 0.5 API so simple to use!     


-- Create the addon using AceAddon-3.0 and embed some libraries.

local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaFTL", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local JambaHelperSettings = LibStub:GetLibrary( "JambaHelperSettings-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-FTL"
AJM.settingsDatabaseName = "JambaFTLProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-ftl"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["FTL Helper"]

local assistButton
local targetButton 
  
-- Settings - the values to store and their defaults for the settings database.
-- dontUseLeftRight : If this is true only shift/alt/ctrl will be used instead of lshift/rshift...
-- onlyUseUsedModifiers : If this is true, only modifiers, which are used by the active Toons are used in the macro
-- onlyUseOnlineToons : If true only Toons which are online (and active) when the ftl-string is created are included
-- assistString: The macrotext of the JambaFTLAssist Button
AJM.settings = { 
	profile = {
	  dontUseLeftRight = false,
	  onlyUseUsedModifiers = true,
	  onlyUseOnlineToons = false,
	  assistString = "",
	  targetString = "",
      CharListWithModifiers = {},	   	
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
            update = {
				type = "input",
				name = L["Update FTL-Button"],
				desc = L["Updates the FTL-Button on all Team members"],
				usage = "/jamba-ftl update",
				get = false,
				set = "CreateUpdateFTLButton",			
			},				
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the FTL settings to all characters in the team."],
				usage = "/jamba-ftl push",
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

AJM.COMMAND_UPDATE_FTL_BUTTON = "JambaFTLupdate"

-------------------------------------------------------------------------------------------------------------
-- FTL.
-------------------------------------------------------------------------------------------------------------

-- Creates a new Entry if a Char isn't in CharListWithModifiers
local function createNewFTLListEntry( characterName )
    if AJM.db.CharListWithModifiers[characterName] == nil then   
        AJM.db.CharListWithModifiers[characterName] = {useToon = false, lshift=false, lalt=false, lctrl=false, rshift=false, ralt=false, rctrl=false}     
    end
end

-- Updates The AssistButton with an FTL String (called when the AJM.COMMAND_UPDATE_FTL_BUTTON is recieved)
local function UpdateFTLAssistButton( astring )
  assistButton:SetAttribute("macrotext", astring)
  AJM:Print("Updating JambaFTLAssist-Button with:" .. astring)		
  AJM.db.assistString = astring
end

-- Updates The AssistButton with an FTL String (called when the AJM.COMMAND_UPDATE_FTL_BUTTON is recieved)
local function UpdateFTLTargetButton( tstring )
  targetButton:SetAttribute("macrotext", tstring)
  AJM:Print("Updating JambaFTLTarget-Button with:" .. tstring)		
  AJM.db.targetString = tstring
end

local function UpdateFTLButton( ftlstring )
  a = "/assist " .. ftlstring
  t = "/target " .. ftlstring
  UpdateFTLAssistButton(a)
  UpdateFTLTargetButton(t)
end



--creates a String for the teamlist which represents the used modifiers 
local function getModifierStringForChar( characterName )
   if AJM.db.CharListWithModifiers[characterName] == nil then
        createNewFTLListEntry(characterName)             
   end
   modstring = "";
   if AJM.db.CharListWithModifiers[characterName].lshift then 
      modstring = modstring .. "lshift "
   end
   if AJM.db.CharListWithModifiers[characterName].lalt then 
      modstring = modstring .. "lalt "
   end
   if AJM.db.CharListWithModifiers[characterName].lctrl then 
      modstring = modstring .. "lctrl "
   end
   if AJM.db.CharListWithModifiers[characterName].rshift then 
      modstring = modstring .. "rshift "
   end
   if AJM.db.CharListWithModifiers[characterName].ralt then 
      modstring = modstring .. "ralt "
   end
   if AJM.db.CharListWithModifiers[characterName].rctrl then 
      modstring = modstring .. "rctrl "
   end
   return modstring  
end

-- Main function to cerate the FTL-Assist-String from the settings
local function createFTLString()
    -- create a list of the Toons which should be used
    activeToons = {}	
    for index, characterName in JambaApi.TeamListOrdered() do
	    -- check if modifoers for a character exist       	    
	    if AJM.db.CharListWithModifiers[characterName] then
	       -- check if useToon is true	        
           if AJM.db.CharListWithModifiers[characterName].useToon then
               -- check if onlyUseOnlineToons is activated and if so, if the toon is online
               if (not AJM.db.onlyUseOnlineToons) or (JambaApi.GetCharacterOnlineStatus( characterName )) then                        
                      	table.insert( activeToons, characterName )         
               end
           end  
        end                
	end
    -- First  find out, which modifiers to use:
    useLShift = false;
    useRShift = false;
    useLAlt = false;
    useRAlt = false;
    useLCtrl = false;
    useRCtrl = false;
    if AJM.db.onlyUseUsedModifiers then
        for index, characterName in ipairs( activeToons ) do
            if AJM.db.CharListWithModifiers[characterName].lshift then useLShift=true end
            if AJM.db.CharListWithModifiers[characterName].rshift then useRShift=true end
            if AJM.db.CharListWithModifiers[characterName].lalt then useLAlt=true end
            if AJM.db.CharListWithModifiers[characterName].ralt then useRAlt=true end
            if AJM.db.CharListWithModifiers[characterName].lctrl then useLCtrl=true end
            if AJM.db.CharListWithModifiers[characterName].rctrl then useRCtrl=true end 
        end
    else
       useLShift = true;
       useRShift = true;
       useLAlt = true;
       useRAlt = true;
       useLCtrl = true;
       useRCtrl = true;
    end
    -- create the string
    ftlstring = ""
	for index, characterName in ipairs( activeToons ) do
        ftlstring = ftlstring .. "["
	    --first if not dontUseLeftRight is set (so its differeniated between l/r)
	    if (not AJM.db.dontUseLeftRight) then
	      if useLShift then	         
             if (not AJM.db.CharListWithModifiers[characterName].lshift) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:lshift,"	         
	      end
	      if useRShift then	         
             if (not AJM.db.CharListWithModifiers[characterName].rshift) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:rshift,"	         
	      end
	      if useLAlt then	         
             if (not AJM.db.CharListWithModifiers[characterName].lalt) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:lalt,"	         
	      end
	      if useRAlt then	         
             if (not AJM.db.CharListWithModifiers[characterName].ralt) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:ralt,"	         
	      end
	      if useLCtrl then	         
             if (not AJM.db.CharListWithModifiers[characterName].lctrl) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:lctrl,"	         
	      end
	      if useRShift then	         
             if (not AJM.db.CharListWithModifiers[characterName].rctrl) then
	             ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:rctrl,"	         
	      end	      
	    -- dontUseLeftRight is set
        else
	       if (useLShift or useRShift) then
	         if (not ((AJM.db.CharListWithModifiers[characterName].lshift) or (AJM.db.CharListWithModifiers[characterName].rshift))) then
	            ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:shift,"
           end	 
	       if (useLAlt or useRAlt) then
	         if (not ((AJM.db.CharListWithModifiers[characterName].lalt) or (AJM.db.CharListWithModifiers[characterName].ralt))) then
	            ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:alt,"
           end
           if (useLCtrl or useRCtrl) then
	         if (not ((AJM.db.CharListWithModifiers[characterName].lctrl) or (AJM.db.CharListWithModifiers[characterName].rctrl))) then
	            ftlstring = ftlstring .. "no"
	         end
	         ftlstring = ftlstring .. "mod:ctrl,"
           end	    
	    end
	    ftlstring = ftlstring .. "target=" .. characterName .. "]"
	end	
	return ftlstring
end

------------------------------------------
-- GUI/Settings (Creation, refreshing, callbacks)
------------------------------------------

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.		
		AJM.db.CharListWithModifiers = JambaUtilities:CopyTable( settings.CharListWithModifiers )
		AJM.db.dontUseLeftRight = settings.dontUseLeftRight
		AJM.db.onlyUseUsedModifiers = settings.onlyUseUsedModifiers
		AJM.db.onlyUseOnlineToons = settings.onlyUseOnlineToons
        AJM.db.assistString = settings.assistString
        AJM.db.targetString = settings.targetString			
		-- Refresh the settings.
		AJM:SettingsRefresh()
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

function AJM:BeforeJambaProfileChanged()	
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
     -- Refreshes all GUI-Elements
     AJM.settingsControl.checkBoxDontUseLeftRight:SetValue( AJM.db.dontUseLeftRight )
     AJM.settingsControl.checkBoxonlyUseUsedModifiers:SetValue( AJM.db.onlyUseUsedModifiers )
     AJM.settingsControl.checkBoxonlyUseOnlineToons:SetValue( AJM.db.onlyUseOnlineToons )       
     characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
     if AJM.db.CharListWithModifiers[characterName] == nil then
        createNewFTLListEntry( characterName )     
     end     
     AJM.settingsControl.checkBoxUseToon:SetValue( AJM.db.CharListWithModifiers[characterName].useToon )
     AJM.settingsControl.checkBoxLShift:SetValue( AJM.db.CharListWithModifiers[characterName].lshift )
     AJM.settingsControl.checkBoxRShift:SetValue( AJM.db.CharListWithModifiers[characterName].rshift )
     AJM.settingsControl.checkBoxLAlt:SetValue( AJM.db.CharListWithModifiers[characterName].lalt )
     AJM.settingsControl.checkBoxRAlt:SetValue( AJM.db.CharListWithModifiers[characterName].ralt )
     AJM.settingsControl.checkBoxLCtrl:SetValue( AJM.db.CharListWithModifiers[characterName].lctrl )
     AJM.settingsControl.checkBoxRCtrl:SetValue( AJM.db.CharListWithModifiers[characterName].rctrl )  
	 AJM:SettingsTeamListScrollRefresh()		
end


function SettingsCreateFTLControl( top )
	-- Get positions and dimensions.	
	local buttonHeight = JambaHelperSettings:GetButtonHeight()		
	local checkBoxHeight = JambaHelperSettings:GetCheckBoxHeight()
	local labelHeight = JambaHelperSettings:GetLabelHeight()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )	
	local column1Left = left
	local movingTop = top
	-- Create a heading for information.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Modifiers to use for selected toon"], movingTop, false )
	movingTop = movingTop - headingHeight
    AJM.settingsControl.checkBoxUseToon = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Use selected Toon in FTL"],		
		AJM.SettingsToggleUseToon
	)
    movingTop = movingTop - headingHeight
    AJM.settingsControl.checkBoxLShift = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth/2 - column1Left, 
		column1Left, 
		movingTop,
		L["Use left shift"],		
		AJM.SettingsToggleLShift
	)
	AJM.settingsControl.checkBoxRShift = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth/2, 
		headingWidth/2, 
		movingTop,
		L["Use right shift"],
		AJM.SettingsToggleRShift
	)
    movingTop = movingTop - checkBoxHeight
    AJM.settingsControl.checkBoxLAlt = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth/2 - column1Left, 
		column1Left, 
		movingTop,
		L["Use left alt"],
		AJM.SettingsToggleLAlt
	)
	AJM.settingsControl.checkBoxRAlt = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth/2, 
		headingWidth/2, 
		movingTop,
		L["Use right alt"],
		AJM.SettingsToggleRAlt
	)
    movingTop = movingTop - checkBoxHeight
    AJM.settingsControl.checkBoxLCtrl = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth/2 - column1Left, 
		column1Left, 
		movingTop,
		L["Use left ctrl"],
		AJM.SettingsToggleLCtrl
	)       
    AJM.settingsControl.checkBoxRCtrl = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		headingWidth/2, 
		movingTop,
		L["Use right ctrl"],
		AJM.SettingsToggleRCtrl
	)
    movingTop = movingTop - checkBoxHeight	
    JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Options"], movingTop, false )
    movingTop = movingTop - headingHeight				
	-- Check box: left/right_mod.
	AJM.settingsControl.checkBoxonlyUseUsedModifiers = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["If a modifier isn't used in a team, don't include it."],
		AJM.SettingsToggleonlyUseUsedModifiers
	)
	movingTop = movingTop - checkBoxHeight
    -- Check box: left/right_mod.
	AJM.settingsControl.checkBoxDontUseLeftRight = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Don't differenciate between left/right modifier states"],
		AJM.SettingsToggleDontUseLeftRight
	)		 
	movingTop = movingTop - checkBoxHeight
    -- Check box: left/right_mod.
	AJM.settingsControl.checkBoxonlyUseOnlineToons   = JambaHelperSettings:CreateCheckBox( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Only use Toons which are online"],
		AJM.SettingsToggleonlyUseOnlineToons
	)		 
	movingTop = movingTop - checkBoxHeight		
    AJM.settingsControl.teamListButtonUpdateFTL = JambaHelperSettings:CreateButton(
		AJM.settingsControl,  
		headingWidth, 
		left, 
		movingTop, 
		L["Create / Update FTL Buttons"],
		AJM.CreateUpdateFTLButton
	)
	movingTop = movingTop - buttonHeight
	-- Label: Quest has more than one reward.
	AJM.settingsControl.labelUpdateFTL= JambaHelperSettings:CreateLabel( 
		AJM.settingsControl, 
		headingWidth, 
		column1Left, 
		movingTop,
		L["Hint:Use the buttons by: /click JambaFTLAssist or /click JambaFTLTarget"]
	)
	
--TODO: Add in message area.
	return movingTop	
end

function SettingsCreateTeamList()
	-- Position and size constants.
	local teamListButtonControlWidth = 85
	local inviteDisbandButtonWidth = 85
	local setMasterButtonWidth = 120
	local buttonHeight = JambaHelperSettings:GetButtonHeight()
	local top = JambaHelperSettings:TopOfSettings()
	local left = JambaHelperSettings:LeftOfSettings()
	local headingHeight = JambaHelperSettings:HeadingHeight()
	local headingWidth = JambaHelperSettings:HeadingWidth( false )
	local horizontalSpacing = JambaHelperSettings:GetHorizontalSpacing()
	local verticalSpacing = JambaHelperSettings:GetVerticalSpacing()
	local teamListWidth = headingWidth  
	local rightOfList = left + teamListWidth + horizontalSpacing 
	local topOfList = top - headingHeight
	-- Team list internal variables (do not change).
	AJM.settingsControl.teamListHighlightRow = 1
	AJM.settingsControl.teamListOffset = 1
	-- Create a heading.
	JambaHelperSettings:CreateHeading( AJM.settingsControl, L["Team List"], top, false )
	-- Create a team list frame.
	local list = {}
	list.listFrameName = "JambaFTLSettingsTeamListFrame"
	list.parentFrame = AJM.settingsControl.widgetSettings.content
	list.listTop = topOfList
	list.listLeft = left
	list.listWidth = teamListWidth
	list.rowHeight = 20
	list.rowsToDisplay = 5
	list.columnsToDisplay = 2
	list.columnInformation = {}
	list.columnInformation[1] = {}
	list.columnInformation[1].width = 40
	list.columnInformation[1].alignment = "LEFT"
	list.columnInformation[2] = {}
	list.columnInformation[2].width = 60
	list.columnInformation[2].alignment = "LEFT"
	list.scrollRefreshCallback = AJM.SettingsTeamListScrollRefresh
	list.rowClickCallback = AJM.SettingsTeamListRowClick
	AJM.settingsControl.teamList = list
	JambaHelperSettings:CreateScrollList( AJM.settingsControl.teamList )
	-- Position and size constants (once list height is known).
	local bottomOfList = topOfList - list.listHeight - verticalSpacing	
	local bottomOfSection = bottomOfList  - verticalSpacing			
	return bottomOfSection
end

local function SettingsCreate()
	AJM.settingsControl = {}	
	-- Create the settings panels.
	JambaHelperSettings:CreateSettings( 
		AJM.settingsControl, 
		AJM.moduleDisplayName, 
		AJM.parentDisplayName, 
		AJM.SettingsPushSettingsClick 
	)		
	-- Create the team list controls.
	local bottomOfTeamList = SettingsCreateTeamList()
	-- Create the FTL controls.
	local bottomOfQuestOptions = SettingsCreateFTLControl( bottomOfTeamList )	
	AJM.settingsControl.widgetSettings.content:SetHeight( -bottomOfQuestOptions )
end

function AJM:SettingsTeamListScrollRefresh()        
	FauxScrollFrame_Update(
		AJM.settingsControl.teamList.listScrollFrame, 
		JambaApi.GetTeamListMaximumOrder(),
		AJM.settingsControl.teamList.rowsToDisplay, 
		AJM.settingsControl.teamList.rowHeight
	)
	AJM.settingsControl.teamListOffset = FauxScrollFrame_GetOffset( AJM.settingsControl.teamList.listScrollFrame )
    for iterateDisplayRows = 1, AJM.settingsControl.teamList.rowsToDisplay do
		-- Reset.
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetText( "" )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetText( "" )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetTextColor( 1.0, 1.0, 1.0, 1.0 )
		AJM.settingsControl.teamList.rows[iterateDisplayRows].highlight:SetTexture( 0.0, 0.0, 0.0, 0.0 )
		-- Get data.
		local dataRowNumber = iterateDisplayRows + AJM.settingsControl.teamListOffset
		if dataRowNumber <= JambaApi.GetTeamListMaximumOrder() then
			-- Put character name and type into columns.
			local characterName = JambaApi.GetCharacterNameAtOrderPosition( dataRowNumber )
			local displayCharacterName = characterName			
			local characterType = getModifierStringForChar(characterName)		
			AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[1].textString:SetText( displayCharacterName )
			AJM.settingsControl.teamList.rows[iterateDisplayRows].columns[2].textString:SetText( characterType )			
			-- Highlight the selected row.
			if dataRowNumber == AJM.settingsControl.teamListHighlightRow then
				AJM.settingsControl.teamList.rows[iterateDisplayRows].highlight:SetTexture( 1.0, 1.0, 0.0, 0.5 )
			end
		end
	end	
end


function AJM:SettingsTeamListRowClick( rowNumber, columnNumber )		
	if AJM.settingsControl.teamListOffset + rowNumber <= JambaApi.GetTeamListMaximumOrder() then
		AJM.settingsControl.teamListHighlightRow = AJM.settingsControl.teamListOffset + rowNumber
		AJM:SettingsTeamListScrollRefresh()
	end
	AJM:SettingsRefresh()
end

function AJM:SettingsPushSettingsClick( event )
	AJM:JambaSendSettings()
end

function AJM:SettingsToggleDontUseLeftRight( event, checked )	  
    AJM.db.dontUseLeftRight  = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleonlyUseOnlineToons( event, checked )	  
    AJM.db.onlyUseOnlineToons  = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleonlyUseUsedModifiers( event, checked )	  
    AJM.db.onlyUseUsedModifiers  = checked
	AJM:SettingsRefresh()
end

function AJM:SettingsToggleUseToon( event, checked ) 
	characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].useToon = checked
    AJM:SettingsRefresh()
end

function AJM:SettingsToggleLShift( event, checked ) 
	characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].lshift = checked
    AJM:SettingsRefresh()  
end

function AJM:SettingsToggleLAlt( event, checked )
    local characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].lalt = checked 
	AJM:SettingsRefresh()
end
function AJM:SettingsToggleLCtrl( event, checked )
    local characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].lctrl = checked	
	AJM:SettingsRefresh()
end
function AJM:SettingsToggleRShift( event, checked )
    local characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].rshift = checked
	AJM:SettingsRefresh()
end
function AJM:SettingsToggleRAlt( event, checked )
    local characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].ralt = checked
	AJM:SettingsRefresh()
end
function AJM:SettingsToggleRCtrl( event, checked )
    local characterName = JambaApi.GetCharacterNameAtOrderPosition( AJM.settingsControl.teamListHighlightRow )
    AJM.db.CharListWithModifiers[characterName].rctrl = checked	
	AJM:SettingsRefresh()
end

function AJM:CreateUpdateFTLButton(event)    
    ftlstring = createFTLString()
    AJM:Print("FTL-String is:" .. ftlstring)
    AJM:JambaSendCommandToTeam( AJM.COMMAND_UPDATE_FTL_BUTTON, ftlstring )
    -- UpdateFTLButton( ftlstring )  (is done by SendCommandToTeam)  		
end

-------------------------------------------------------------------------------------------------------------
-- Jamba-FTL functionality.
-------------------------------------------------------------------------------------------------------------

-- A Jamba command has been recieved.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )	
    if commandName == AJM.COMMAND_UPDATE_FTL_BUTTON then
           AJM:Print("Update recieved")
    	   UpdateFTLButton( ... )
	end
end

function AJM:OnCharacterAdded( message, characterName )
	AJM:SettingsRefresh()
end

function AJM:OnCharacterRemoved( message, characterName )
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
	AJM:JambaModuleInitialize( AJM.settingsControl.widgetSettings.frame )
	-- Populate the settings.			    	
	AJM:SettingsRefresh()
    -- Creates the Assistbutton    
    assistButton = CreateFrame("Button", "JambaFTLAssist", nil, "SecureActionButtonTemplate")
    assistButton:SetAttribute("type", "macro")
    if AJM.db.assistString then
       UpdateFTLAssistButton(AJM.db.assistString)
    end
    -- Creates the Targetbutton    
    targetButton = CreateFrame("Button", "JambaFTLTarget", nil, "SecureActionButtonTemplate")
    targetButton:SetAttribute("type", "macro")
    if AJM.db.targetString then
       UpdateFTLTargetButton(AJM.db.targetString)
    end 	
end

-- Called when the addon is enabled.
function AJM:OnEnable()
    AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_ADDED, "OnCharacterAdded" )
	AJM:RegisterMessage( JambaApi.MESSAGE_TEAM_CHARACTER_REMOVED, "OnCharacterRemoved" )
	AJM:SettingsTeamListScrollRefresh()
end

-- Called when the addon is disabled.
function AJM:OnDisable()
end
	 