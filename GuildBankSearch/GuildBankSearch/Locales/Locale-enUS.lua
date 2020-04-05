--[[****************************************************************************
  * GuildBankSearch by Saiket, originally by Harros                            *
  * Locales/Locale-enUS.lua - Localized string constants (en-US).              *
  ****************************************************************************]]


do
	local Title = "GuildBank|cffccccccSearch|r";


	GuildBankSearchLocalization = setmetatable( {
		TITLE = Title;

		FILTER = "Filter";
		CLEAR = "Clear";

		NAME = "Name:";
		QUALITY = "Quality:";
		ITEM_LEVEL = "Item Level:";
		REQUIRED_LEVEL = "Required Level:";
		LEVELRANGE_SEPARATOR = "-";

		ITEM_CATEGORY = "Item Category";
		TYPE = "Type:";
		SUB_TYPE = "Sub-Type:";
		SLOT = "Slot:";

		ALL = "|cffcccccc(All)|r";
	}, {
		__index = function ( self, Key )
			if ( Key ~= nil ) then
				rawset( self, Key, Key );
				return Key;
			end
		end;
	} );
end
