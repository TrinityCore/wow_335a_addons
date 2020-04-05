--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Locales/Locale-deDE.lua - Localized string constants (de-DE).              *
  ****************************************************************************]]


if ( GetLocale() ~= "deDE" ) then
	return;
end


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/deDE/
_NPCScanOverlayLocalization.NPCS = setmetatable( {
	[ 1140 ] = "Scharfzahnmatriarchin",
	[ 5842 ] = "Takk der Springer",
	[ 6581 ] = "Ravasaurusmatriarchin",
	[ 14232 ] = "Pfeil",
	[ 18684 ] = "Bro'Gaz der Klanlose",
	[ 32491 ] = "Zeitverlorener Protodrache",
	[ 33776 ] = "Gondria",
	[ 35189 ] = "Skoll",
	[ 38453 ] = "Arcturis",
}, { __index = _NPCScanOverlayLocalization.NPCS; } );