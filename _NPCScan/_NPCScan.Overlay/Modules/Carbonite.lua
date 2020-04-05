--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/Carbonite.lua - Modifies the WorldMap and Minimap modules for      *
  *   compatibility with Carbonite.                                            *
  ****************************************************************************]]


if ( not IsAddOnLoaded( "Carbonite" ) ) then
	return;
end

local Overlay = select( 2, ... );
local CarboniteMap = NxMap1.NxM1;
local WorldMap = Overlay.Modules.List[ "WorldMap" ];
local me = CreateFrame( "Frame", nil, WorldMap );
Overlay.Modules.Carbonite = me;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:OnUpdate                              *
  * Description: Repositions the module as the Carbonite map moves.            *
  ****************************************************************************]]
function me:OnUpdate ()
	CarboniteMap:CZF( CarboniteMap.Con, CarboniteMap.Zon, WorldMap, 1 );
	WorldMap.KeyParent:SetAlpha( NxMap1.NxW.BaF ); -- Obey window's "Fade Out" setting
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:WorldMapFrameOnShow                   *
  * Description: Set up the module to paint to the WorldMapFrame.              *
  ****************************************************************************]]
function me:WorldMapFrameOnShow ()
	if ( WorldMap.Loaded ) then
		me:Hide(); -- Stop updating with Carbonite

		-- Undo Carbonite scaling/fading
		WorldMap:SetScale( 1 );
		WorldMap.KeyParent:SetAlpha( 1 );

		WorldMap:SetParent( WorldMapDetailFrame );
		WorldMap:SetAllPoints();

		WorldMap.KeyParent:SetParent( WorldMapButton );
		WorldMap.KeyParent:SetAllPoints();
	end
end
--[[****************************************************************************
  * Function: _NPCScan.Overlay.Carbonite:WorldMapFrameOnHide                   *
  * Description: Set up the module to paint to Carbonite's map.                *
  ****************************************************************************]]
function me:WorldMapFrameOnHide ()
	if ( WorldMap.Loaded ) then
		me:Show(); -- Begin updating with Carbonite

		local ScrollFrame = CarboniteMap.TSF;
		WorldMap:SetParent( ScrollFrame:GetScrollChild() );
		WorldMap:ClearAllPoints();

		WorldMap.KeyParent:SetParent( ScrollFrame );
		WorldMap.KeyParent:SetAllPoints();
	end
end




if ( NxData.NXGOpts.MapMMOwn ) then -- Minimap docked into WorldMap
	Overlay.Modules.Unregister( "Minimap" );
end


local function HookHandler ( Module, Name, Handler )
	if ( Module[ Name ] ) then
		hooksecurefunc( Module, Name, Handler );
	else
		Module[ Name ] = Handler;
	end
end
local function OnUnload ()
	me.OnUpdate = nil;
	if ( WorldMap.Loaded ) then
		me:SetScript( "OnUpdate", nil );
	end
end
local function OnLoad ()
	HookHandler( WorldMap, "OnUnload", OnUnload );
	me:SetScript( "OnUpdate", me.OnUpdate );

	-- Give the canvas an explicit size so it paints correctly in Carbonite mode
	WorldMap:SetSize( WorldMapDetailFrame:GetSize() );

	-- Hooks to swap between Carbonite's map mode and the default UI map mode
	WorldMapFrame:HookScript( "OnShow", me.WorldMapFrameOnShow );
	WorldMapFrame:HookScript( "OnHide", me.WorldMapFrameOnHide );
	me[ WorldMapFrame:IsVisible() and "WorldMapFrameOnShow" or "WorldMapFrameOnHide" ]( WorldMapFrame );
end

if ( WorldMap and WorldMap.Registered ) then
	if ( WorldMap.Loaded ) then
		OnLoad();
	else
		HookHandler( WorldMap, "OnLoad", OnLoad );
	end
else
	OnUnload();
end