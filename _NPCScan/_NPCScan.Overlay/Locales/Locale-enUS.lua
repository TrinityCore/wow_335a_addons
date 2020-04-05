--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Locales/Locale-enUS.lua - Localized string constants (en-US).              *
  ****************************************************************************]]


-- See http://wow.curseforge.com/addons/npcscan-overlay/localization/enUS/
_NPCScanOverlayLocalization = setmetatable( {
	NPCS = { -- Note: Don't use a metatable default; Missing keys must return nil
		[ 1140 ] = "Razormaw Matriarch",
		[ 5842 ] = "Takk the Leaper",
		[ 6581 ] = "Ravasaur Matriarch",
		[ 14232 ] = "Dart",
		[ 18684 ] = "Bro'Gaz the Clanless",
		[ 32491 ] = "Time-Lost Proto Drake",
		[ 33776 ] = "Gondria",
		[ 35189 ] = "Skoll",
		[ 38453 ] = "Arcturis",
	};

	CONFIG_ALPHA = "Alpha",
	CONFIG_DESC = "Control which maps will show mob path overlays.  Most map-modifying addons are controlled with the World Map option.",
	CONFIG_SHOWALL = "Always show all paths",
	CONFIG_SHOWALL_DESC = "Normally when a mob isn't being searched for, its path gets taken off the map.  Enable this setting to always show every known patrol instead.",
	CONFIG_TITLE = "Overlay",
	CONFIG_TITLE_STANDALONE = "_|cffCCCC88NPCScan|r.Overlay",
	CONFIG_ZONE = "Zone:",
	MODULE_ALPHAMAP3 = "AlphaMap3 AddOn",
	MODULE_BATTLEFIELDMINIMAP = "Battlefield-Minimap Popout",
	MODULE_MINIMAP = "Minimap",
	MODULE_RANGERING_DESC = "Note: The range ring only appears in zones with tracked rares.",
	MODULE_RANGERING_FORMAT = "Show %dyd ring for approximate detection range",
	MODULE_WORLDMAP = "Main World Map",
	MODULE_WORLDMAP_KEY = "_|cffCCCC88NPCScan|r.Overlay",
	MODULE_WORLDMAP_KEY_FORMAT = "• %s",
	MODULE_WORLDMAP_TOGGLE = "_|cffCCCC88NPCScan|r.Overlay",
	MODULE_WORLDMAP_TOGGLE_DESC = "If enabled, displays _|cffCCCC88NPCScan|r.Overlay's paths for tracked NPCs.",

	-- Phrases localized by default UI
	CONFIG_ENABLE = ENABLE;
}, {
	__index = function ( self, Key )
		if ( Key ~= nil ) then
			rawset( self, Key, Key );
			return Key;
		end
	end;
} );


SLASH__NPCSCAN_OVERLAY1 = "/npcscanoverlay";
SLASH__NPCSCAN_OVERLAY2 = "/npcoverlay";
SLASH__NPCSCAN_OVERLAY3 = "/overlay";