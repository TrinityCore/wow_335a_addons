--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/Mapster.lua - Adjusts WorldMap module with Mapster.                *
  ****************************************************************************]]


if ( not IsAddOnLoaded( "Mapster" ) ) then
	return;
end

local AddOnName, Overlay = ...;
local WorldMap = Overlay.Modules.List[ "WorldMap" ];
local Mapster = LibStub( "AceAddon-3.0" ):GetAddon( "Mapster" );
local me = Mapster:NewModule( AddOnName );
Overlay.Modules.Mapster = me;




--[[****************************************************************************
  * Function: local UpdateMapsize                                              *
  * Description: Moves the checkbox so it doesn't overlap Mapster's stuff.     *
  ****************************************************************************]]
local function UpdateMapsize ( self, Mini )
	WorldMap.Toggle:ClearAllPoints();
	WorldMap.Toggle:SetPoint( "BOTTOM", WorldMapTrackQuest );
	if ( Mini ) then -- Right side so coordinates don't overlap
		local Label = _G[ WorldMap.Toggle:GetName().."Text" ];
		WorldMap.Toggle:SetPoint( "RIGHT", WorldMapDetailFrame, -Label:GetStringWidth() - 4, 0 );
	else -- Left side, between "Track Quests" and player coordinates
		local Label = _G[ WorldMapTrackQuest:GetName().."Text" ];
		WorldMap.Toggle:SetPoint( "LEFT", WorldMapTrackQuest, "RIGHT", Label:GetStringWidth() + 8, -4 );
	end
end
--[[****************************************************************************
  * Function: local Enable                                                     *
  * Description: Fired when both modules are enabled at the same time.         *
  ****************************************************************************]]
local function Enable ( self )
	self.UpdateMapsize = UpdateMapsize;
	self:UpdateMapsize( Mapster.miniMap );
	WorldMap.Toggle:Show();
end
--[[****************************************************************************
  * Function: local Disable                                                    *
  ****************************************************************************]]
local function Disable ( self )
	self.UpdateMapsize = nil;
	WorldMap.Toggle:Hide();
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.Mapster:OnEnable                        *
  ****************************************************************************]]
function me:OnEnable ()
	self.Enabled = true;
	if ( WorldMap.Loaded ) then
		Enable( self );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.Mapster:OnDisable                       *
  ****************************************************************************]]
function me:OnDisable ()
	self.Enabled = nil;
	if ( WorldMap.Loaded ) then
		Disable( self );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.Mapster:OnInitialize                    *
  ****************************************************************************]]
do
	local function HookHandler ( Module, Name, Handler )
		if ( Module[ Name ] ) then
			hooksecurefunc( Module, Name, Handler );
		else
			Module[ Name ] = Handler;
		end
	end
	local function WorldMapOnUnload ()
		if ( me.Enabled ) then
			Disable( me );
		end
		me.OnEnable, me.OnDisable = nil;
	end
	local function WorldMapOnLoad ()
		HookHandler( WorldMap, "OnUnload", WorldMapOnUnload );
		if ( me.Enabled ) then
			Enable( me );
		end
	end
	function me:OnInitialize ()
		self.OnInitialize = nil;

		self:SetEnabledState( true );
		if ( WorldMap and WorldMap.Registered ) then
			if ( WorldMap.Loaded ) then
				WorldMapOnLoad();
			else
				HookHandler( WorldMap, "OnLoad", WorldMapOnLoad );
			end
		else -- WorldMap module unregistered
			WorldMapOnUnload();
		end
	end
end