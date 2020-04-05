--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Locales/Locale-frFR.lua - Localized string constants (fr-FR).              *
  ****************************************************************************]]


if ( GetLocale() ~= "frFR" ) then
	return;
end


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/frFR/
_NPCScanOverlayLocalization.NPCS = setmetatable( {
	[ 1140 ] = "Matriarche tranchegueules",
	[ 5842 ] = "Takk le Bondisseur",
	[ 6581 ] = "Matriarche ravasaure",
	[ 14232 ] = "Flèche",
	[ 18684 ] = "Bro'Gaz Sans-clan",
	[ 32491 ] = "Proto-drake perdu dans le temps",
	[ 33776 ] = "Gondria",
	[ 35189 ] = "Skoll",
	[ 38453 ] = "Arcturis",
}, { __index = _NPCScanOverlayLocalization.NPCS; } );