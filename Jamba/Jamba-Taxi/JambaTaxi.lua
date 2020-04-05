--[[
Jamba - Jafula's Awesome Multi-Boxer Assistant
Copyright 2008 - 2010 Michael "Jafula" Miller
All Rights Reserved
http://wow.jafula.com/addons/jamba/
jamba at jafula dot com
]]--

-- Create the addon using AceAddon-3.0 and embed some libraries.
local AJM = LibStub( "AceAddon-3.0" ):NewAddon( 
	"JambaTaxi", 
	"JambaModule-1.0", 
	"AceConsole-3.0", 
	"AceEvent-3.0",
	"AceHook-3.0"
)

-- Get the Jamba Utilities Library.
local JambaUtilities = LibStub:GetLibrary( "JambaUtilities-1.0" )

--  Constants and Locale for this module.
AJM.moduleName = "Jamba-Taxi"
AJM.settingsDatabaseName = "JambaTaxiProfileDB"
AJM.parentDisplayName = "Jamba"
AJM.chatCommand = "jamba-taxi"
local L = LibStub( "AceLocale-3.0" ):GetLocale( AJM.moduleName )
AJM.moduleDisplayName = L["Taxi"]

-- Settings - the values to store and their defaults for the settings database.
AJM.settings = {
	profile = {
		takeMastersTaxi = true,
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
			taxiHeading = {
				type = "header",
				name = L["Taxi Options"],
				order = 0,
			},			
			takeMastersTaxi = {
				type = "toggle",
				name = L["Take Master's Taxi"],
				desc = L["Take the same flight as the master did (slaves's must have NPC Flight Master window open)."],
				width = "full",
				order = 1,
			}, 
			pushHeading = {
				type = "header",
				name = L["Push Settings"],
				order = 2,
			},			
			pushGUI = {
				type = "execute",
				name = L["Push Settings"],
				desc = L["Push the taxi settings to all characters in the team."],
				func = "JambaSendSettings",
				order = 3,
				cmdHidden = true,
			},
			push = {
				type = "input",
				name = L["Push Settings"],
				desc = L["Push the taxi settings to all characters in the team."],
				usage = "/jamba-taxi push",
				get = false,
				set = "JambaSendSettings",
				order = 4,
				guiHidden = true,
			},
		},
	}
	return configuration
end

-------------------------------------------------------------------------------------------------------------
-- Command this module sends.
-------------------------------------------------------------------------------------------------------------

AJM.COMMAND_TAKE_TAXI = "JambaTaxiTakeTaxi"

-------------------------------------------------------------------------------------------------------------
-- Messages module sends.
-------------------------------------------------------------------------------------------------------------

-- Taxi has been taken, no parameters.
AJM.MESSAGE_TAXI_TAKEN = "JambaTaxiTaxiTaken"

-------------------------------------------------------------------------------------------------------------
-- Addon initialization, enabling and disabling.
-------------------------------------------------------------------------------------------------------------

-- Initialise the module.
function AJM:OnInitialize()
	-- Initialse the JambaModule part of this module.
	AJM:JambaModuleInitialize( nil )
end

-- Called when the addon is enabled.
function AJM:OnEnable()
	-- Hook the TaketaxiNode function.
	AJM:SecureHook( "TakeTaxiNode" )
end

-- Called when the addon is disabled.
function AJM:OnDisable()
	-- AceHook-3.0 will tidy up the hooks for us. 
end

-- Settings received.
function AJM:JambaOnSettingsReceived( characterName, settings )	
	if characterName ~= AJM.characterName then
		-- Update the settings.
		AJM.db.takeMastersTaxi = settings.takeMastersTaxi
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
	LibStub( "AceConfigRegistry-3.0" ):NotifyChange( AJM.moduleName )
end

-------------------------------------------------------------------------------------------------------------
-- JambaTaxi functionality.
-------------------------------------------------------------------------------------------------------------

-- Take a taxi.
local function TakeTaxi( sender, nodeName )
	-- If the take masters taxi option is on.
	if AJM.db.takeMastersTaxi == true then
		-- If the sender was not this character and is the master then...
		if sender ~= AJM.characterName then
			-- Find the index of the taxi node to fly to.
			local nodeIndex = nil
			for iterateNodes = 1, NumTaxiNodes() do
				if TaxiNodeName( iterateNodes ) == nodeName then
					nodeIndex = iterateNodes
					break
				end
			end	
			-- If a node index was found...
			if nodeIndex ~= nil then
				-- Send a message to any listeners that a taxi is being taken.
				AJM:SendMessage( AJM.MESSAGE_TAXI_TAKEN )
				-- Take a taxi.
				TakeTaxiNode( nodeIndex )
			else
				-- Tell the master that this character could not take the same flight.
				AJM:JambaSendMessageToTeam( AJM.characterName, L["I am unable to fly to A."]( nodename ) )				
			end
		end
	end
end

-- Called after the character has just taken a flight (hooked function).
function AJM:TakeTaxiNode( taxiNodeIndex )
	-- If the take masters taxi option is on.
	if AJM.db.takeMastersTaxi == true then
		-- Get the name of the node flown to.
		local nodeName = TaxiNodeName( taxiNodeIndex )
		-- Tell the other characters about the taxi.
		AJM:JambaSendCommandToTeam( AJM.COMMAND_TAKE_TAXI, nodeName )
	end
end

-- A Jamba command has been received.
function AJM:JambaOnCommandReceived( characterName, commandName, ... )
	if characterName ~= self.characterName then
		-- If the command was to take a taxi...
		if commandName == AJM.COMMAND_TAKE_TAXI then
			-- If not already on a taxi...
			if UnitOnTaxi( "player" ) == nil then
				-- And if the taxi frame is open...
				if TaxiFrame:IsVisible() then
					TakeTaxi( characterName, ... )
				end
			end
		end
	end
end

JambaApi.Taxi = {}
JambaApi.Taxi.MESSAGE_TAXI_TAKEN = AJM.MESSAGE_TAXI_TAKEN