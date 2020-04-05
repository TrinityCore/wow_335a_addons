--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/WorldMapTemplate.lua - Template module for WorldMap-like canvases. *
  ****************************************************************************]]


local Overlay = select( 2, ... );
local me = {};
Overlay.Modules.WorldMapTemplate = me;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:Paint                  *
  ****************************************************************************]]
do
	local function PaintPath ( self, PathData, FoundX, FoundY, R, G, B, NpcID )
		Overlay.DrawPath( self, PathData, "ARTWORK", R, G, B );
		if ( FoundX ) then
			Overlay.DrawFound( self, FoundX, FoundY, Overlay.DetectionRadius / Overlay.GetZoneSize( Overlay.NPCMaps[ NpcID ] ), "OVERLAY", R, G, B );
		end
	end
	function me:Paint ( Map )
		Overlay.ApplyZone( self, Map, PaintPath );
	end
end
--[[****************************************************************************
  * Function: local MapUpdate                                                  *
  * Description: Throttles calls to the Paint method.                          *
  ****************************************************************************]]
local MapUpdate;
do
	local function OnUpdate ( self )
		self:SetScript( "OnUpdate", nil );

		local Map = GetCurrentMapAreaID() - 1;
		if ( Map ~= self.MapLast ) then
			self.MapLast = Map;

			Overlay.TextureRemoveAll( self );
			self:Paint( Map );
		end
	end
	function MapUpdate ( self, Force )
		if ( Force ) then
			self.MapLast = nil;
		end
		self:SetScript( "OnUpdate", OnUpdate );
	end
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:WORLD_MAP_UPDATE       *
  ****************************************************************************]]
function me:WORLD_MAP_UPDATE ()
	MapUpdate( self );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnShow                 *
  ****************************************************************************]]
function me:OnShow ()
	MapUpdate( self );
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnMapUpdate            *
  ****************************************************************************]]
function me:OnMapUpdate ( Map )
	if ( not Map or Map == self.MapLast ) then
		MapUpdate( self, true );
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnEnable               *
  ****************************************************************************]]
function me:OnEnable ()
	self:RegisterEvent( "WORLD_MAP_UPDATE" );
	self:Show();
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnDisable              *
  ****************************************************************************]]
function me:OnDisable ()
	self:UnregisterEvent( "WORLD_MAP_UPDATE" );
	self:Hide();
	Overlay.TextureRemoveAll( self );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnLoad                 *
  ****************************************************************************]]
function me:OnLoad ()
	self:Hide();
	self:SetAllPoints();
	self:SetScript( "OnShow", self.OnShow );
	self:SetScript( "OnEvent", Overlay.Modules.OnEvent );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnUnload               *
  * Description: Clears all methods and scripts to be garbage collected.       *
  ****************************************************************************]]
function me:OnUnload ()
	self:SetScript( "OnShow", nil );
	self:SetScript( "OnEvent", nil );
	self:SetScript( "OnUpdate", nil );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:OnUnregister           *
  * Description: Clears all scripts to be garbage collected.                   *
  ****************************************************************************]]
do
	local Preserve = {
		[ 0 ] = true; -- UserData
		Name = true;
		Config = true;
		OnSynchronize = true;
	};
	function me:OnUnregister ()
		for Key in pairs( self ) do
			if ( not Preserve[ Key ] ) then
				self[ Key ] = nil;
			end
		end
	end
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.WorldMapTemplate:Embed                  *
  * Description: Implements WorldMapTemplate for a given canvas module frame.  *
  ****************************************************************************]]
do
	local Inherit = {
		"Paint",
		"WORLD_MAP_UPDATE",
		"OnShow",
		"OnMapUpdate",
		"OnEnable",
		"OnDisable",
		"OnLoad",
		"OnUnload",
		"OnUnregister"
	};
	function me:Embed ()
		for _, Method in ipairs( Inherit ) do
			self[ Method ] = me[ Method ];
		end
		self.super = me;
		return self;
	end
end