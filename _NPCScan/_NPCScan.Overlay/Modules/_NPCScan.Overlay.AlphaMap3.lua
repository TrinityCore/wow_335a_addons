--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.AlphaMap3.lua - Canvas for the AlphaMap3 addon.           *
  ****************************************************************************]]


local Overlay = _NPCScan.Overlay;
local me = CreateFrame( "Frame" );
Overlay.AlphaMap3 = me;

me.Label = _NPCScanLocalization.OVERLAY.MODULE_ALPHAMAP3;
me.AlphaDefault = 0.8;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.AlphaMap3:OnLoad                                *
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

	if ( Overlay.Options.Modules[ "AlphaMap3" ] == true ) then
		me:Enable();
		me:Update();
	end
end




--------------------------------------------------------------------------------
-- Function Hooks / Execution
-----------------------------

do
	Overlay.ModuleRegister( "AlphaMap3", me, "AlphaMap3" );
end
