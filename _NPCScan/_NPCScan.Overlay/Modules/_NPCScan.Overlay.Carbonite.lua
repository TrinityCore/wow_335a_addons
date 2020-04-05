--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.Carbonite.lua - Modifies the WorldMap and Minimap modules *
  *   to work with Carbonite.                                                  *
  ****************************************************************************]]


if ( IsAddOnLoaded( "Cartographer3" ) or not IsAddOnLoaded( "Carbonite" ) ) then
	return;
end

local Overlay = _NPCScan.Overlay;
local CarboniteMap = NxMap1.NxM1;
local WorldMap = Overlay.WorldMap;
local Key = WorldMap.Key;
local me = CreateFrame( "Frame", nil, WorldMap );
Overlay.Carbonite = me;

local IsMaximized;




--[[****************************************************************************
  * Function: local EnableKey                                                  *
  ****************************************************************************]]
local function EnableKey ( Enable )
	if ( Enable ) then
		WorldMap.Key = Key;
		WorldMap:Update(); -- Update key and show if necessary
	else
		WorldMap.Key = nil; -- Prevents updates from re-showing it
		Key:Hide();
	end
end

--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:OnUpdate                              *
  * Description: Repositions the module as the Carbonite map moves.            *
  ****************************************************************************]]
function me:OnUpdate ()
	CarboniteMap:CZF( CarboniteMap.Con, CarboniteMap.Zon, WorldMap, 1 );

	-- Fade the key frame out on mouseover with the rest of the map's buttons
	Key:SetAlpha( NxMap1.NxW.BaF );
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:WorldMapFrameOnShow                   *
  * Description: Set up the module to paint to the WorldMapFrame.              *
  ****************************************************************************]]
function me:WorldMapFrameOnShow ()
	me:SetScript( "OnUpdate", nil ); -- Stop updating with Carbonite
	-- Undo Carbonite scaling/fading
	WorldMap:SetScale( 1 );
	Key:SetAlpha( 1 );

	WorldMap:SetParent( WorldMapDetailFrame );
	WorldMap:SetAllPoints();

	Key:SetParent( WorldMapButton );
	Key:SetPoint( ( Key:GetPoint() ) );

	EnableKey( true );
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:WorldMapFrameOnHide                   *
  * Description: Set up the module to paint to Carbonite's map.                *
  ****************************************************************************]]
function me:WorldMapFrameOnHide ()
	me:SetScript( "OnUpdate", me.OnUpdate ); -- Begin updating with Carbonite

	local ScrollChild = CarboniteMap.TeF;
	WorldMap:SetParent( ScrollChild );
	WorldMap:SetAllPoints();

	Key:SetParent( ScrollChild );
	Key:SetPoint( Key:GetPoint(), CarboniteMap.Frm ); -- Border frame

	EnableKey( IsMaximized ); -- Restore key visibility
end


--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite.Maximize                              *
  * Description: Shows the key when Carbonite is in "Max size" mode.           *
  ****************************************************************************]]
function me.Maximize ()
	if ( IsMaximized ~= true ) then
		IsMaximized = true;
		if ( not WorldMapFrame:IsVisible() ) then -- In Carbonite mode
			EnableKey( IsMaximized );
		end
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite.Minimize                              *
  * Description: Hides the key when Carbonite is in normal size mode.          *
  ****************************************************************************]]
function me.Minimize ()
	if ( IsMaximized ~= false ) then
		IsMaximized = false;
		if ( not WorldMapFrame:IsVisible() ) then -- In Carbonite mode
			EnableKey( IsMaximized );
		end
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	if ( NxData.NXGOpts.MapMMOwn ) then -- Minimap docked into WorldMap
		Overlay.ModuleUnregister( "Minimap" );
	end


	me:SetScript( "OnUpdate", me.OnUpdate );

	-- Give the canvas an explicit size so it paints correctly in Carbonite mode
	WorldMap:SetSize( WorldMapDetailFrame:GetSize() );

	-- Hooks to swap between Carbonite's normal and max sizes
	hooksecurefunc( Nx.Map, "MaS1", me.Maximize );
	hooksecurefunc( Nx.Map, "ReS1", me.Minimize );
	me[ Nx.Map:GeM( 1 ).Win1:ISM() and "Maximize" or "Minimize" ]();

	-- Hooks to swap between Carbonite's map mode and the default UI map mode
	WorldMapFrame:HookScript( "OnShow", me.WorldMapFrameOnShow );
	WorldMapFrame:HookScript( "OnHide", me.WorldMapFrameOnHide );
	me[ WorldMapFrame:IsVisible() and "WorldMapFrameOnShow" or "WorldMapFrameOnHide" ]( WorldMapFrame );
end
