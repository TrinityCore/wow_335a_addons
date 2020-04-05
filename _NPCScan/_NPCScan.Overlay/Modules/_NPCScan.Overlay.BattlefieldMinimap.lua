--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.BattlefieldMinimap.lua - Canvas for the                   *
  *   Blizzard_BattlefieldMinimap addon.                                       *
  ****************************************************************************]]


local Overlay = _NPCScan.Overlay;
local me = CreateFrame( "Frame" );
Overlay.BattlefieldMinimap = me;

me.Label = _NPCScanLocalization.OVERLAY.MODULE_BATTLEFIELDMINIMAP;
me.AlphaDefault = 0.8;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.BattlefieldMinimap:OnLoad                       *
  ****************************************************************************]]
function me:OnLoad ()
	me:SetParent( BattlefieldMinimap );
	me:SetAllPoints();

	-- Inherit standard map update code from WorldMap module
	local WorldMap = Overlay.WorldMap;
	me.Paint = WorldMap.Paint;
	me.Enable = WorldMap.Enable;
	me.Disable = WorldMap.Disable;
	me.Update = WorldMap.Update;
	WorldMap.OnLoad( me );

	if ( Overlay.Options.Modules[ "BattlefieldMinimap" ] == true ) then
		me:Enable();
		me:Update();
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	Overlay.ModuleRegister( "BattlefieldMinimap", me, "Blizzard_BattlefieldMinimap" );
end
