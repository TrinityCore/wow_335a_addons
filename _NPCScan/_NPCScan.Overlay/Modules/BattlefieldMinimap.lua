--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/BattlefieldMinimap.lua - Canvas for Blizzard_BattlefieldMinimap.   *
  ****************************************************************************]]


local Overlay = select( 2, ... );
local me = Overlay.Modules.WorldMapTemplate.Embed( CreateFrame( "Frame" ) );

me.AlphaDefault = 0.8;




--[[****************************************************************************
  * Function: _NPCScan.Overlay.Modules.List.BattlefieldMinimap:OnLoad          *
  ****************************************************************************]]
function me:OnLoad ( ... )
	self:SetParent( BattlefieldMinimap );

	return self.super.OnLoad( self, ... );
end




Overlay.Modules.Register( "BattlefieldMinimap", me,
	_NPCScanOverlayLocalization.MODULE_BATTLEFIELDMINIMAP,
	"Blizzard_BattlefieldMinimap" );