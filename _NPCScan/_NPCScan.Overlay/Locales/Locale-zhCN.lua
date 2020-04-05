--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Locales/Locale-zhCN.lua - Localized string constants (zh-CN).              *
  ****************************************************************************]]


if ( GetLocale() ~= "zhCN" ) then
	return;
end


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/zhCN/
_NPCScanOverlayLocalization.NPCS = setmetatable( {
	[ 1140 ] = "刺喉雌龙",
	[ 5842 ] = "“跳跃者”塔克",
	[ 6581 ] = "暴掠龙女王",
	[ 14232 ] = "达尔特",
	[ 18684 ] = "独行者布罗加斯",
	[ 33776 ] = "古德利亚",
}, { __index = _NPCScanOverlayLocalization.NPCS; } );