--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.Cartographer3.lua - Modifies the WorldMap module to work  *
  *   with Cartographer3.                                                      *
  ****************************************************************************]]


if ( not IsAddOnLoaded( "Cartographer3" ) ) then
	return;
end

local Overlay = _NPCScan.Overlay;
local WorldMap = Overlay.WorldMap;
local me = {};
Overlay.Cartographer3 = me;

local IntegrateWorldMap = Cartographer3.hijackingWorldMap;

local Key = WorldMap.Key;
if ( IntegrateWorldMap ) then
	me.KeyMinWidth = 300;
	me.KeyMinHeight = 200;
end




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Cartographer3.SetMapToCurrentZone               *
  * Description: Force a Minimap update when the map is returned.              *
  ****************************************************************************]]
function me.SetMapToCurrentZone ()
	if ( Overlay.Minimap.Update ) then
		Overlay.Minimap:Update();
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	hooksecurefunc( "SetMapToCurrentZone", me.SetMapToCurrentZone );

	if ( IntegrateWorldMap ) then
		Key:SetParent( Cartographer_MapFrame );
		Key:SetPoint( Key:GetPoint(), Cartographer_MapHolder_ScrollFrame );

		-- Only show the key frame when Cartographer3 is big enough
		Cartographer_MapFrame:HookScript( "OnSizeChanged", function ( self, Width, Height )
			if ( Width >= me.KeyMinWidth and Height >= me.KeyMinHeight ) then
				if ( not WorldMap.Key ) then -- Enable the key
					WorldMap.Key = Key;
					WorldMap:Update();
				end
			elseif ( WorldMap.Key ) then -- Too small; Disable key
				WorldMap.Key = nil;
				Key:Hide();
			end
		end );

	else -- Must be able to swap between Cartographer and WorldMap mode
		local function UpdateMapPosition ( self )
			if ( self == WorldMap -- In case other modules inherit this hooked version
				and not WorldMapFrame:IsVisible()
			) then
				local ZoneData = Cartographer3.Data.currentZoneData;
				if ( ZoneData ) then
					local Scale = ZoneData.fullWidth / WorldMap:GetWidth();
					WorldMap:SetScale( Scale );
					WorldMap:ClearAllPoints();
					WorldMap:SetPoint( "CENTER", ZoneData.fullCenterX / Scale, ZoneData.fullCenterY / Scale );
				end
			end
		end

		WorldMap:SetWidth( WorldMapDetailFrame:GetWidth() );
		WorldMap:SetHeight( WorldMapDetailFrame:GetHeight() );
		hooksecurefunc( WorldMap, "Paint", UpdateMapPosition );


		-- Hooks to swap between Cartographer3's map mode and the default UI map mode
		local function OnShow () -- Set up the module to paint to the WorldMapFrame.
			WorldMap:SetParent( WorldMapDetailFrame );
			WorldMap:SetAllPoints();
			WorldMap:SetScale( 1 );

			WorldMap.Key = Key;
			WorldMap:Update();
		end
		local function OnHide () -- Set up the module to paint to Cartographer3's map.
			WorldMap:SetParent( Cartographer_MapHolder_MapView );
			UpdateMapPosition( WorldMap );

			WorldMap.Key = nil;
			Key:Hide();
		end
		WorldMapFrame:HookScript( "OnShow", OnShow );
		WorldMapFrame:HookScript( "OnHide", OnHide );
		( WorldMapFrame:IsVisible() and OnShow or OnHide )();
	end
end
