--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- The global private table for Jamba.
JambaPrivate = {}
JambaPrivate.Core = {}
JambaPrivate.Communications = {}
JambaPrivate.Message = {}
JambaPrivate.Team = {}
JambaPrivate.Tag = {}

-- The global public API table for Jamba.
JambaApi = {}

local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaCore", 
	"AceConsole-3.0" 
)

-- JambaCore is not a module, but the same naming convention for these values is convenient.
AJM.moduleName = "Jamba-Core"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Core"]
AJM.settingsDatabaseName = "JambaCoreProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba"
AJM.teamModuleName = "Jamba-Team"

-- Load libraries.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )
local AceGUI = LibStub("AceGUI-3.0")

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		showMinimapIcon = true,
	},
}

-- Configuration.
local function GetConfiguration()
	local configuration = {
		name = "Jamba",
		handler = AJM,
		type = 'group',
		childGroups  = "tab",
		get = "ConfigurationGetSetting",
		set = "ConfigurationSetSetting",
		args = {
			headerInformation = {
				type = "header",
				name = L["Jafula's Awesome Multi-Boxer Assistant"],
				order = 10,
			},
			informationLine2 = {
				type = "description",
				name = L["Copyright 2008-2010 Michael 'Jafula' Miller"],
				order = 20,
			},			
			informationLine3 = {
				type = "description",
				name = L["Made in New Zealand"],
				order = 30,
			},
			informationLine3AndAHalf = {
				type = "description",
				name = "",
				order = 35,
			},			
			informationLine4 = {
				type = "description",
				name = L["For user manuals and documentation please visit:"],
				order = 50,
			},
			informationLine4AndAHalf = {
				type = "description",
				name = "",
				order = 60,
			},
			informationLine5 = {
				type = "description",
				name = L["http://multiboxhaven.com/wow/addons/jamba/"],
				order = 70,
			},
			informationLine5AndAHalf = {
				type = "description",
				name = "",
				order = 75,
			},			
			informationLine6 = {
				type = "description",
				name = L["Other useful websites:"],
				order = 80,
			},
			informationLine6AndAHalf = {
				type = "description",
				name = "",
				order = 85,
			},			
			informationLine7 = {
				type = "description",
				name = L["http://wow.jafula.com/addons/jamba/"],
				order = 90,
			},
			informationLine8 = {
				type = "description",
				name = L["http://dual-boxing.com/"],
				order = 100,
			},
			informationLine9 = {
				type = "description",
				name = L["http://multiboxing.com/"],
				order = 110,
			},
			informationLine9AndAHalf = {
				type = "description",
				name = "",
				order = 115,
			},				
			informationLine10 = {
				type = "description",
				name = L["Special thanks to olipcs on dual-boxing.com for writing the FTL Helper module."],
				order = 120,
			},
			headerSettings = {
				type = "header",
				name = L["Settings"],
				order = 130,
			},			
			pushSettingAllModules = {
				type = "execute",
				name = L["Push Settings For All The Modules"],
				desc = L["Push all module settings to all characters in the team list."],
				func = "SendSettingsAllModules",
				width = "full",
				order = 140,			
			},					 
		},
	}
	return configuration
end

-- Get a settings value.
function AJM:ConfigurationGetSetting( key )
	return AJM.db[key[#key]]
end

-- Set a settings value.
function AJM:ConfigurationSetSetting( key, value )
	AJM.db[key[#key]] = value
end

local function DebugMessage( ... )
	AJM:Print( ... )
end

-------------------------------------------------------------------------------------------------------------
-- Module management.
-------------------------------------------------------------------------------------------------------------

-- Register a Jamba module.
local function RegisterModule( moduleAddress, moduleName )
	if AJM.registeredModulesByName == nil then
		AJM.registeredModulesByName = {}
	end
	if AJM.registeredModulesByAddress == nil then
		AJM.registeredModulesByAddress = {}
	end
	AJM.registeredModulesByName[moduleName] = moduleAddress
	AJM.registeredModulesByAddress[moduleAddress] = moduleName
end

-------------------------------------------------------------------------------------------------------------
-- Settings sending and receiving.
-------------------------------------------------------------------------------------------------------------

-- Send the settings for the module specified (using its address) to other Jamba Team characters.
local function SendSettings( moduleAddress, settings )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the settings identified by the module name.
	JambaPrivate.Communications.SendSettings( moduleName, settings )
end

-- Settings are received, pass them to the relevant module.
local function OnSettingsReceived( sender, moduleName, settings )
	-- Get the address of the module.
	local moduleAddress = AJM.registeredModulesByName[moduleName]	
	-- Pass the module its settings.
	moduleAddress:JambaOnSettingsReceived( sender, settings )
end

function AJM:SendSettingsAllModules()
	AJM:Print( "Sending settings for all modules." )
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		AJM:Print( "Sending settings for: ", moduleName )
		moduleAddress:JambaSendSettings()
	end
end

-------------------------------------------------------------------------------------------------------------
-- Commands sending and receiving.
-------------------------------------------------------------------------------------------------------------

-- Send a command for the module specified (using its address) to other Jamba Team characters.
local function SendCommandToTeam( moduleAddress, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	JambaPrivate.Communications.SendCommandAll( moduleName, commandName, ... )
end

-- Send a command for the module specified (using its address) to the master character.
local function SendCommandToMaster( moduleAddress, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	JambaPrivate.Communications.SendCommandMaster( moduleName, commandName, ... )
end

-- Send a command for the module specified (using its address) to other Jamba Team character slaves.
local function SendCommandToSlaves( moduleAddress, commandName, ... )
	-- Get the name of the module.
	local moduleName = AJM.registeredModulesByAddress[moduleAddress]
	-- Send the command identified by the module name.
	JambaPrivate.Communications.SendCommandSlaves( moduleName, commandName, ... )
end

-- A command is received, pass it to the relevant module.
local function OnCommandReceived( sender, moduleName, commandName, ... )
	-- Get the address of the module.
	local moduleAddress = AJM.registeredModulesByName[moduleName]
	-- Pass the module its settings.
	moduleAddress:JambaOnCommandReceived( sender, commandName, ... )
end

-------------------------------------------------------------------------------------------------------------
-- Jamba Core Profile Support.
-------------------------------------------------------------------------------------------------------------

function AJM:FireBeforeProfileChangedEvent()
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if moduleName ~= AJM.moduleName then		
			moduleAddress:BeforeJambaProfileChanged()
		end
	end
end

function AJM:CanChangeProfileForModule( moduleName )
	if (moduleName ~= AJM.moduleName) and (moduleName ~= AJM.teamModuleName) then		
		return true
	end
	return false
end

function AJM:FireOnProfileChangedEvent( moduleAddress )
	moduleAddress.db = moduleAddress.completeDatabase.profile
	moduleAddress:OnJambaProfileChanged()
end

function AJM:OnProfileChanged( event, database, newProfileKey, ... )
	AJM:Print( "Profile changed - iterating all modules." )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( "Changing profile: ", AJM.teamModuleName )
	teamModuleAddress.completeDatabase:SetProfile( newProfileKey )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )
	-- Do the other modules.
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( "Changing profile: ", moduleName )
			moduleAddress.completeDatabase:SetProfile( newProfileKey )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileCopied( event, database, sourceProfileKey )
	AJM:Print( "Profile copied - iterating all modules." )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( "Copying profile: ", AJM.teamModuleName )
	teamModuleAddress.completeDatabase:CopyProfile( sourceProfileKey, true )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( "Copying profile: ", moduleName )
			moduleAddress.completeDatabase:CopyProfile( sourceProfileKey, true )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileReset( event, database )
	AJM:Print( "Profile reset - iterating all modules." )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( "Resetting profile: ", AJM.teamModuleName )
	teamModuleAddress.completeDatabase:ResetProfile()
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.	
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( "Resetting profile: ", moduleName )
			moduleAddress.completeDatabase:ResetProfile()
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

function AJM:OnProfileDeleted( event, database, profileKey )
	AJM:Print( "Profile deleted - iterating all modules." )
	AJM:FireBeforeProfileChangedEvent()
	-- Do the team module before all the others.
	local teamModuleAddress = AJM.registeredModulesByName[AJM.teamModuleName]
	AJM:Print( "Deleting profile: ", AJM.teamModuleName )
	teamModuleAddress.completeDatabase:DeleteProfile( profileKey, true )
	AJM:FireOnProfileChangedEvent( teamModuleAddress )	
	-- Do the other modules.		
	for moduleName, moduleAddress in pairs( AJM.registeredModulesByName ) do
		if AJM:CanChangeProfileForModule( moduleName ) == true then		
			AJM:Print( "Deleting profile: ", moduleName )
			moduleAddress.completeDatabase:DeleteProfile( profileKey, true )
			AJM:FireOnProfileChangedEvent( moduleAddress )
		end
	end
end

-------------------------------------------------------------------------------------------------------------
-- Jamba Core Initialization.
-------------------------------------------------------------------------------------------------------------

-- Initialize the addon.
function AJM:OnInitialize()
	-- Tables to hold registered modules - lookups by name and by address.  
	-- By name is used for communication between clients and by address for communication between addons on the same client.
	AJM.registeredModulesByName = {}
	AJM.registeredModulesByAddress = {}
	-- Create the settings database supplying the settings values along with defaults.
    AJM.completeDatabase = LibStub( "AceDB-3.0" ):New( AJM.settingsDatabaseName, AJM.settings )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileChanged", "OnProfileChanged" )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileCopied", "OnProfileCopied" )
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileReset", "OnProfileReset" )	
	AJM.completeDatabase.RegisterCallback( AJM, "OnProfileDeleted", "OnProfileDeleted" )	
	AJM.db = AJM.completeDatabase.profile
	-- Create the settings.
	LibStub( "AceConfig-3.0" ):RegisterOptionsTable( 
		AJM.moduleName, 
		GetConfiguration() 
	)
	AJM.settingsFrame = LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( 
		AJM.moduleName,
		AJM.parentDisplayName
	)
	-- Create the settings profile support.
	LibStub( "AceConfig-3.0" ):RegisterOptionsTable( 
		AJM.moduleName.."-Profiles",
		LibStub( "AceDBOptions-3.0" ):GetOptionsTable( AJM.completeDatabase ) 
	)
	AJM.settingsFrameProfiles = LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( 
		AJM.moduleName.."-Profiles", 
		AJM.moduleDisplayName..L[": Profiles"], 
		AJM.parentDisplayName 
	)	
	-- Register the core as a module.
	RegisterModule( AJM, AJM.moduleName )	
	-- Register the chat command.
	AJM:RegisterChatCommand( AJM.chatCommand, "JambaChatCommand" )	
end

function AJM:OnEnable()
end

function AJM:OnDisable()
end

-- Send core settings.
function AJM:JambaSendSettings()
	JambaPrivate.Communications.SendSettings( AJM.moduleName, AJM.db )
end

function AJM:OnJambaProfileChanged()	
	AJM:SettingsRefresh()
end

function AJM:SettingsRefresh()
end

-- Core settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.showMinimapIcon = settings.showMinimapIcon
		-- Refresh the settings.
		LibStub( "AceConfigRegistry-3.0" ):NotifyChange( AJM.moduleName )
		-- Tell the player.
		AJM:Print( L["Settings received from A."]( characterName ) )
	end
end

-- Handle the chat command.
function AJM:JambaChatCommand( input )
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory( AJM.parentDisplayName )
    else
        LibStub( "AceConfigCmd-3.0" ):HandleCommand( AJM.chatCommand, AJM.moduleName, input )
    end    
end

-- Functions available from Jamba Core for other Jamba internal objects.
JambaPrivate.Core.RegisterModule = RegisterModule
JambaPrivate.Core.SendSettings = SendSettings
JambaPrivate.Core.OnSettingsReceived = OnSettingsReceived
JambaPrivate.Core.SendCommandToTeam = SendCommandToTeam
JambaPrivate.Core.SendCommandToMaster = SendCommandToMaster
JambaPrivate.Core.SendCommandToSlaves = SendCommandToSlaves
JambaPrivate.Core.OnCommandReceived = OnCommandReceived
