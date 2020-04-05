--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Locales/Locale-koKR.lua - Localized string constants (ko-KR).              *
  ****************************************************************************]]


if ( GetLocale() ~= "koKR" ) then
	return;
end


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/koKR/
_NPCScanOverlayLocalization.NPCS = setmetatable( {
	[ 5842 ] = "껑충발 타크",
	[ 6581 ] = "우두머리 라바사우루스",
	[ 18684 ] = "외톨이 브로가즈",
	[ 33776 ] = "곤드리아",
	[ 35189 ] = "스콜",
}, { __index = _NPCScanOverlayLocalization.NPCS; } );