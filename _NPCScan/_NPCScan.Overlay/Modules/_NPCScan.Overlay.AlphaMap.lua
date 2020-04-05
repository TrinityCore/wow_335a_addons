--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.AlphaMap.lua - Canvas for the AlphaMap addon.             *
  ****************************************************************************]]


local Overlay = _NPCScan.Overlay;
local me = CreateFrame( "Frame" );
Overlay.AlphaMap = me;

me.Label = _NPCScanLocalization.OVERLAY.MODULE_ALPHAMAP;
me.AlphaDefault = 0.8;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.AlphaMap:OnLoad                                 *
  ****************************************************************************]]
function me:OnLoad ()
	me:SetParent( AlphaMapDetailFrame );
	me:SetAllPoints();

	-- Inherit standard map update code from WorldMap module
	local WorldMap = Overlay.WorldMap;
	me.Paint = WorldMap.Paint;
	me.Enable = WorldMap.Enable;
	me.Disable = WorldMap.Disable;
	me.Update = WorldMap.Update;
	WorldMap.OnLoad( me );

	if ( Overlay.Options.Modules[ "AlphaMap" ] == true ) then
		me:Enable();
		me:Update();
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	Overlay.ModuleRegister( "AlphaMap", me, "AlphaMap" );
end
